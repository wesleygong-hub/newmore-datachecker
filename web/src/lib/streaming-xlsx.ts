import { Unzip, UnzipInflate } from "fflate";
import type { DataSide, ImportIssue, NormalizedRecord, ParsedData } from "../domain/types";
import { scoreSheetHeaders, type Row } from "./excel";
import { createLargeRowAdapter } from "./large-row-adapter";

const HEADER_SCAN_LIMIT = 15;

export const LARGE_FILE_LIMITS = {
  singleFileBytes: 150 * 1024 * 1024,
  totalFileBytes: 300 * 1024 * 1024,
  totalRows: 1_000_000,
  uniqueKeys: 500_000,
} as const;

export interface StreamableWorkbook {
  name: string;
  size: number;
  stream(): ReadableStream<Uint8Array>;
  arrayBuffer(): Promise<ArrayBuffer>;
}

interface ZipConsumer {
  push(data: Uint8Array, final: boolean): void;
  done?: boolean;
}

interface WorkbookSheet {
  name: string;
  path: string;
}

interface BufferedRow {
  rowNumber: number;
  values: Row;
}

interface WorksheetReaderOptions {
  sharedStrings: string[];
  maxRows?: number;
  onDimension?: (maxRow: number) => void;
  onRow: (row: BufferedRow) => void;
}

export interface StreamingParseResult {
  issues: ImportIssue[];
  selectedSheet: ParsedData["selectedSheets"][number];
  worksheetRows: number;
}

function normalizeZipPath(path: string): string {
  const parts: string[] = [];
  for (const part of path.replace(/\\/g, "/").replace(/^\/+/, "").split("/")) {
    if (!part || part === ".") continue;
    if (part === "..") parts.pop();
    else parts.push(part);
  }
  return parts.join("/");
}

function resolveZipPath(baseFile: string, target: string): string {
  if (target.startsWith("/")) return normalizeZipPath(target);
  const directory = baseFile.slice(0, Math.max(0, baseFile.lastIndexOf("/") + 1));
  return normalizeZipPath(`${directory}${target}`);
}

function xmlAttribute(source: string, name: string): string {
  const escaped = name.replace(/[.*+?^${}()|[\]\\]/g, "\\$&");
  const match = source.match(new RegExp(`(?:^|\\s)${escaped}=(?:"([^"]*)"|'([^']*)')`));
  return decodeXml(match?.[1] ?? match?.[2] ?? "");
}

function decodeXml(value: string): string {
  return value
    .replace(/&#x([0-9a-f]+);/gi, (_, code: string) => String.fromCodePoint(Number.parseInt(code, 16)))
    .replace(/&#([0-9]+);/g, (_, code: string) => String.fromCodePoint(Number.parseInt(code, 10)))
    .replace(/&lt;/g, "<")
    .replace(/&gt;/g, ">")
    .replace(/&quot;/g, '"')
    .replace(/&apos;/g, "'")
    .replace(/&amp;/g, "&")
    .replace(/_x([0-9a-f]{4})_/gi, (_, code: string) => String.fromCharCode(Number.parseInt(code, 16)));
}

function richText(source: string): string {
  let result = "";
  const matcher = /<t(?:\s[^>]*)?>([\s\S]*?)<\/t>/g;
  for (let match = matcher.exec(source); match; match = matcher.exec(source)) {
    result += decodeXml(match[1]);
  }
  return result;
}

function textCollector(onComplete: (value: string) => void): ZipConsumer {
  const decoder = new TextDecoder();
  let text = "";
  return {
    push(data, final) {
      text += decoder.decode(data, { stream: !final });
      if (final) onComplete(text);
    },
  };
}

function sharedStringCollector(strings: string[]): ZipConsumer {
  const decoder = new TextDecoder();
  let buffer = "";
  return {
    push(data, final) {
      buffer += decoder.decode(data, { stream: !final });
      while (true) {
        const start = buffer.search(/<si(?:\s|>)/);
        if (start < 0) {
          if (buffer.length > 512) buffer = buffer.slice(-512);
          break;
        }
        const end = buffer.indexOf("</si>", start);
        if (end < 0) {
          if (start > 0) buffer = buffer.slice(start);
          break;
        }
        const item = buffer.slice(start, end + 5);
        strings.push(richText(item));
        buffer = buffer.slice(end + 5);
      }
      if (final) buffer = "";
    },
  };
}

function columnIndex(reference: string): number {
  let result = 0;
  let length = 0;
  for (const character of reference.toUpperCase()) {
    if (character < "A" || character > "Z") break;
    result = result * 26 + character.charCodeAt(0) - 64;
    length += 1;
  }
  return length > 0 ? result - 1 : -1;
}

function parseWorksheetRow(source: string, sharedStrings: string[]): BufferedRow {
  const openTagEnd = source.indexOf(">");
  const openingTag = openTagEnd >= 0 ? source.slice(0, openTagEnd + 1) : source;
  const declaredRow = Number.parseInt(xmlAttribute(openingTag, "r"), 10);
  const values: Row = [];
  let fallbackColumn = 0;
  const matcher = /<c\b([^>]*?)(?:\/>|>([\s\S]*?)<\/c>)/g;
  for (let match = matcher.exec(source); match; match = matcher.exec(source)) {
    const attributes = match[1] ?? "";
    const content = match[2] ?? "";
    const reference = xmlAttribute(attributes, "r");
    const explicitColumn = columnIndex(reference);
    const column = explicitColumn >= 0 ? explicitColumn : fallbackColumn;
    fallbackColumn = column + 1;
    const type = xmlAttribute(attributes, "t");
    const valueMatch = content.match(/<v(?:\s[^>]*)?>([\s\S]*?)<\/v>/);
    const rawValue = decodeXml(valueMatch?.[1] ?? "");
    let value: unknown = rawValue;
    if (type === "s") value = sharedStrings[Number.parseInt(rawValue, 10)] ?? "";
    else if (type === "inlineStr") value = richText(content);
    else if (type === "b") value = rawValue === "1";
    values[column] = value;
  }
  return {
    rowNumber: Number.isFinite(declaredRow) ? declaredRow : 0,
    values,
  };
}

function worksheetConsumer(options: WorksheetReaderOptions): ZipConsumer {
  const decoder = new TextDecoder();
  let buffer = "";
  let rowsRead = 0;
  let dimensionRead = false;
  const consumer: ZipConsumer = {
    push(data, final) {
      if (consumer.done) return;
      buffer += decoder.decode(data, { stream: !final });
      if (!dimensionRead) {
        const dimension = buffer.match(/<dimension\b[^>]*\bref=(?:"[A-Z]+\d+:([A-Z]+)(\d+)"|'[A-Z]+\d+:([A-Z]+)(\d+)')[^>]*\/>/i);
        const maxRow = Number.parseInt(dimension?.[2] ?? dimension?.[4] ?? "0", 10);
        if (maxRow > 0) options.onDimension?.(maxRow);
        if (buffer.includes("<sheetData")) dimensionRead = true;
      }
      while (true) {
        const start = buffer.search(/<row(?:\s|>)/);
        if (start < 0) {
          if (buffer.length > 1024) buffer = buffer.slice(-1024);
          break;
        }
        const end = buffer.indexOf("</row>", start);
        if (end < 0) {
          if (start > 0) buffer = buffer.slice(start);
          break;
        }
        const row = parseWorksheetRow(buffer.slice(start, end + 6), options.sharedStrings);
        rowsRead += 1;
        if (row.rowNumber <= 0) row.rowNumber = rowsRead;
        options.onRow(row);
        buffer = buffer.slice(end + 6);
        if (options.maxRows && rowsRead >= options.maxRows) {
          consumer.done = true;
          buffer = "";
          break;
        }
      }
      if (final) buffer = "";
    },
  };
  return consumer;
}

async function readZipPass(
  input: StreamableWorkbook,
  select: (path: string) => ZipConsumer | undefined,
  onCompressedProgress?: (ratio: number) => void,
): Promise<void> {
  let failure: Error | undefined;
  const unzipper = new Unzip((entry) => {
    const path = normalizeZipPath(entry.name);
    const consumer = select(path);
    if (!consumer) return;
    entry.ondata = (error, data, final) => {
      if (failure) return;
      if (error) {
        failure = error;
        return;
      }
      try {
        consumer.push(data, final);
        if (consumer.done) entry.terminate();
      } catch (caught) {
        failure = caught instanceof Error ? caught : new Error(String(caught));
        entry.terminate();
      }
    };
    entry.start();
  });
  unzipper.register(UnzipInflate);

  const reader = input.stream().getReader();
  let bytesRead = 0;
  while (true) {
    const { done, value } = await reader.read();
    if (failure) {
      await reader.cancel();
      throw failure;
    }
    if (done) {
      unzipper.push(new Uint8Array(0), true);
      break;
    }
    bytesRead += value.byteLength;
    unzipper.push(value, false);
    onCompressedProgress?.(Math.min(1, bytesRead / Math.max(1, input.size)));
  }
  if (failure) throw failure;
}

function parseWorkbookSheets(workbookXml: string, relationshipsXml: string): WorkbookSheet[] {
  const targets = new Map<string, string>();
  const relationshipMatcher = /<Relationship\b([^>]*?)(?:\/>|>[\s\S]*?<\/Relationship>)/g;
  for (let match = relationshipMatcher.exec(relationshipsXml); match; match = relationshipMatcher.exec(relationshipsXml)) {
    const attributes = match[1] ?? "";
    const id = xmlAttribute(attributes, "Id");
    const target = xmlAttribute(attributes, "Target");
    const type = xmlAttribute(attributes, "Type");
    if (id && target && /\/worksheet$/i.test(type)) {
      targets.set(id, resolveZipPath("xl/workbook.xml", target));
    }
  }

  const sheets: WorkbookSheet[] = [];
  const sheetMatcher = /<sheet\b([^>]*?)(?:\/>|>[\s\S]*?<\/sheet>)/g;
  for (let match = sheetMatcher.exec(workbookXml); match; match = sheetMatcher.exec(workbookXml)) {
    const attributes = match[1] ?? "";
    const name = xmlAttribute(attributes, "name");
    const relationshipId = xmlAttribute(attributes, "r:id");
    const path = targets.get(relationshipId);
    if (name && path) sheets.push({ name, path });
  }
  return sheets;
}

async function readMetadata(
  input: StreamableWorkbook,
  onProgress?: (ratio: number) => void,
): Promise<{ sheets: WorkbookSheet[]; sharedStrings: string[] }> {
  let workbookXml = "";
  let relationshipsXml = "";
  const sharedStrings: string[] = [];
  await readZipPass(
    input,
    (path) => {
      if (path === "xl/workbook.xml") return textCollector((value) => { workbookXml = value; });
      if (path === "xl/_rels/workbook.xml.rels") return textCollector((value) => { relationshipsXml = value; });
      if (/^(?:xl\/)?sharedStrings\.xml$/i.test(path) || path === "xl/sharedStrings.xml") {
        return sharedStringCollector(sharedStrings);
      }
      return undefined;
    },
    onProgress,
  );
  const sheets = parseWorkbookSheets(workbookXml, relationshipsXml);
  if (sheets.length === 0) throw new Error(`【${input.name}】没有可读取的工作表。`);
  return { sheets, sharedStrings };
}

async function selectSheet(
  input: StreamableWorkbook,
  side: DataSide,
  sheets: WorkbookSheet[],
  sharedStrings: string[],
): Promise<{ sheet: WorkbookSheet; headers: BufferedRow[] }> {
  const rowsByPath = new Map<string, BufferedRow[]>();
  const paths = new Set(sheets.map((sheet) => sheet.path));
  await readZipPass(input, (path) => {
    if (!paths.has(path)) return undefined;
    const rows: BufferedRow[] = [];
    rowsByPath.set(path, rows);
    return worksheetConsumer({
      sharedStrings,
      maxRows: HEADER_SCAN_LIMIT,
      onRow: (row) => rows.push(row),
    });
  });

  let best: { sheet: WorkbookSheet; headers: BufferedRow[]; score: number } | undefined;
  for (const sheet of sheets) {
    const headers = rowsByPath.get(sheet.path) ?? [];
    for (const row of headers) {
      const score = scoreSheetHeaders(side, row.values, sheet.name, input.name);
      if (!best || score > best.score) best = { sheet, headers, score };
    }
  }
  const minimumScore = side === "sc" ? 22 : 28;
  if (!best || best.score < minimumScore) {
    throw new Error(`无法在【${input.name}】中识别${side === "sc" ? "速创" : "聚合力"}账单工作表。`);
  }
  return { sheet: best.sheet, headers: best.headers };
}

export async function parseStreamingXlsx(
  input: StreamableWorkbook,
  side: DataSide,
  onRecord: (record: NormalizedRecord) => void,
  onProgress?: (ratio: number) => void,
): Promise<StreamingParseResult> {
  if (input.size > LARGE_FILE_LIMITS.singleFileBytes) {
    throw new Error(`【${input.name}】超过单文件 150 MB 的安全上限，请按月份拆分后重试。`);
  }
  const lowerName = input.name.toLocaleLowerCase();
  if (!lowerName.endsWith(".xlsx")) {
    throw new Error(`大文件模式只支持 .xlsx；请将【${input.name}】另存为 .xlsx 后重试。`);
  }

  const metadata = await readMetadata(input, (ratio) => onProgress?.(ratio * 0.2));
  const selected = await selectSheet(input, side, metadata.sheets, metadata.sharedStrings);
  const issues: ImportIssue[] = [];
  let validRecords = 0;
  let maxWorksheetRow = 0;
  let adapter: ReturnType<typeof createLargeRowAdapter> | undefined;
  let headerRowNumber = 0;
  const bufferedRows: BufferedRow[] = [];
  let lastPercent = -1;

  function initializeAdapter(): void {
    if (adapter || bufferedRows.length === 0) return;
    let best: BufferedRow | undefined;
    let bestScore = -Infinity;
    for (const row of bufferedRows) {
      const score = scoreSheetHeaders(side, row.values, selected.sheet.name, input.name);
      if (score > bestScore) {
        best = row;
        bestScore = score;
      }
    }
    const minimumScore = side === "sc" ? 22 : 28;
    if (!best || bestScore < minimumScore) {
      throw new Error(`无法在【${input.name}】中识别${side === "sc" ? "速创" : "聚合力"}账单工作表。`);
    }
    headerRowNumber = best.rowNumber;
    adapter = createLargeRowAdapter(side, best.values, input.name, selected.sheet.name);
    for (const row of bufferedRows) processDataRow(row);
    bufferedRows.length = 0;
  }

  function processDataRow(row: BufferedRow): void {
    if (!adapter || row.rowNumber <= headerRowNumber) return;
    const parsed = adapter.parse(row.values, row.rowNumber);
    issues.push(...parsed.issues);
    if (parsed.record) {
      validRecords += 1;
      onRecord(parsed.record);
    }
  }

  await readZipPass(input, (path) => {
    if (path !== selected.sheet.path) return undefined;
    return worksheetConsumer({
      sharedStrings: metadata.sharedStrings,
      onDimension: (maxRow) => { maxWorksheetRow = maxRow; },
      onRow: (row) => {
        if (!adapter) {
          bufferedRows.push(row);
          if (bufferedRows.length >= HEADER_SCAN_LIMIT) initializeAdapter();
        } else {
          processDataRow(row);
        }
        const ratio = maxWorksheetRow > 0 ? row.rowNumber / maxWorksheetRow : 0;
        const percent = Math.floor(ratio * 100);
        if (percent !== lastPercent) {
          lastPercent = percent;
          onProgress?.(0.2 + Math.min(1, ratio) * 0.8);
        }
      },
    });
  });
  initializeAdapter();
  onProgress?.(1);

  return {
    issues,
    worksheetRows: maxWorksheetRow,
    selectedSheet: {
      side,
      fileName: input.name,
      sheetName: selected.sheet.name,
      recordCount: validRecords,
    },
  };
}
