import XLSX from "xlsx-js-style";
import type { CellStyle, WorkBook, WorkSheet } from "xlsx-js-style";
import type { WorkBook as FastWorkBook } from "xlsx";
import type {
  ImportIssue,
  NormalizedRecord,
  ReconciliationOutput,
  ReconciliationResult,
  TextValues,
} from "../domain/types";

function joined(values: TextValues): string {
  return typeof values === "string" ? values : values.join("；");
}

function money(value: string): number {
  return Number(value);
}

const THIN_BORDER: NonNullable<CellStyle["border"]> = {
  top: { style: "thin", color: { rgb: "000000" } },
  bottom: { style: "thin", color: { rgb: "000000" } },
  left: { style: "thin", color: { rgb: "000000" } },
  right: { style: "thin", color: { rgb: "000000" } },
};

const HEADER_STYLE: CellStyle = {
  font: { name: "等线", sz: 11, bold: true, color: { rgb: "000000" } },
  fill: { patternType: "solid", fgColor: { rgb: "808080" } },
  border: THIN_BORDER,
  alignment: { horizontal: "center", vertical: "center", wrapText: false },
};

const BODY_STYLE: CellStyle = {
  font: { name: "等线", sz: 11, color: { rgb: "000000" } },
  border: THIN_BORDER,
  alignment: { vertical: "center" },
};

const CENTERED_BODY_STYLE: CellStyle = {
  ...BODY_STYLE,
  alignment: { horizontal: "center", vertical: "center" },
};

const MONEY_BODY_STYLE: CellStyle = {
  ...BODY_STYLE,
  alignment: { horizontal: "right", vertical: "center" },
  numFmt: "0.00",
};

const INTEGER_BODY_STYLE: CellStyle = {
  ...BODY_STYLE,
  alignment: { horizontal: "right", vertical: "center" },
  numFmt: "0",
};

// 旧版结果通常是月度小表，可以完整复刻细边框；年度大表若给数百万单元格
// 逐个附加样式，会明显增加浏览器内存和导出时间，因此不为其正文逐格附加样式。
export const FULL_BODY_STYLE_CELL_LIMIT = 250_000;

export function shouldApplyFullBodyStyle(rowCount: number, columnCount: number): boolean {
  return rowCount * columnCount <= FULL_BODY_STYLE_CELL_LIMIT;
}

interface SheetFormatOptions {
  centeredColumns?: number[];
  integerColumns?: number[];
  moneyColumns?: number[];
}

function minimumHeaderWidth(header: string): number {
  const displayWidth = Array.from(header).reduce(
    (width, character) => width + (/^[\u2e80-\u9fff\uff00-\uffef]$/u.test(character) ? 2 : 1),
    0,
  );
  return Math.ceil(displayWidth + 5);
}

function makeSheet(
  headers: string[],
  rows: Array<Array<string | number>>,
  widths: number[],
  options: SheetFormatOptions = {},
): WorkSheet {
  const sheet = XLSX.utils.aoa_to_sheet([headers, ...rows]);
  sheet["!cols"] = widths.map((wch, index) => ({
    wch: Math.max(wch, minimumHeaderWidth(headers[index] ?? "")),
  }));
  sheet["!rows"] = [{ hpt: 22 }];
  if (rows.length > 0) {
    sheet["!autofilter"] = {
      ref: XLSX.utils.encode_range({ s: { r: 0, c: 0 }, e: { r: rows.length, c: headers.length - 1 } }),
    };
  }

  const centeredColumns = new Set(options.centeredColumns ?? []);
  const integerColumns = new Set(options.integerColumns ?? []);
  const moneyColumns = new Set(options.moneyColumns ?? []);
  const fullBodyStyle = shouldApplyFullBodyStyle(rows.length, headers.length);

  for (let column = 0; column < headers.length; column += 1) {
    const cell = sheet[XLSX.utils.encode_cell({ r: 0, c: column })];
    if (cell) cell.s = HEADER_STYLE;
  }

  for (let row = 1; row <= rows.length; row += 1) {
    for (let column = 0; column < headers.length; column += 1) {
      const cell = sheet[XLSX.utils.encode_cell({ r: row, c: column })];
      if (!cell) continue;

      if (moneyColumns.has(column)) {
        cell.z = "0.00";
        if (fullBodyStyle) cell.s = MONEY_BODY_STYLE;
      } else if (integerColumns.has(column)) {
        cell.z = "0";
        if (fullBodyStyle) cell.s = INTEGER_BODY_STYLE;
      } else if (fullBodyStyle) {
        cell.s = centeredColumns.has(column) ? CENTERED_BODY_STYLE : BODY_STYLE;
      }
    }
  }

  return sheet;
}

function resultRows(results: ReconciliationResult[]): Array<Array<string | number>> {
  return results.map((result) => [
    joined(result.partyNames),
    result.accYm,
    result.realAccYm,
    joined(result.scNames),
    joined(result.hrallyNames),
    result.id,
    joined(result.scCompanyNos),
    joined(result.scCompanyNames),
    joined(result.groupNames),
    joined(result.scEmployeeNos),
    joined(result.hrallyCompanyNames),
    joined(result.hrallyEmployeeNos),
    money(result.social.difference),
    money(result.fund.difference),
    money(result.service.difference),
    money(result.total.difference),
  ]);
}

function detailRows(records: NormalizedRecord[]): Array<Array<string | number>> {
  return records.map((record) => [
    record.accYm,
    record.realAccYm,
    record.id,
    record.name,
    record.employeeNo,
    record.companyNo,
    record.companyName,
    record.companyFullName,
    record.groupName,
    record.partyName,
    money(record.socialAmount),
    money(record.fundAmount),
    money(record.serviceAmount),
    money(record.totalAmount),
    record.fileName,
    record.sheetName,
    record.rowNumber,
  ]);
}

function issueRows(issues: ImportIssue[]): Array<Array<string | number>> {
  return issues.map((issue) => [
    issue.side === "sc" ? "速创" : issue.side === "hrally" ? "聚合力" : "客户清单",
    issue.fileName,
    issue.sheetName,
    issue.rowNumber,
    issue.field,
    issue.message,
    issue.rawValue ?? "",
  ]);
}

function timestamp(): string {
  const date = new Date();
  const part = (value: number) => String(value).padStart(2, "0");
  return `${date.getFullYear()}${part(date.getMonth() + 1)}${part(date.getDate())}_${part(date.getHours())}${part(date.getMinutes())}${part(date.getSeconds())}`;
}

export function buildWorkbook(output: ReconciliationOutput): WorkBook {
  const workbook = XLSX.utils.book_new();
  const resultHeaders = [
    "关联方",
    "账单年月",
    "业务年月",
    "上海速创-姓名",
    "聚合力-姓名",
    "身份证",
    "上海速创-客户编号",
    "上海速创-客户简称",
    "上海速创-客户组",
    "上海速创-雇员编号",
    "聚合力-客户",
    "聚合力-雇员编号",
    "社保总计-对账差异",
    "公积金总计-对账差异",
    "服务费总计-对账差异",
    "对账金额总计-对账差异",
  ];
  const resultSheet = makeSheet(
    resultHeaders,
    resultRows(output.results),
    [9, 8, 9, 13, 13, 22, 16, 29, 16, 16, 42, 15, 18, 20, 18, 22],
    { centeredColumns: [1, 2], moneyColumns: [12, 13, 14, 15] },
  );
  XLSX.utils.book_append_sheet(workbook, resultSheet, "对账结果");

  const detailHeaders = [
    "财务年月",
    "业务年月",
    "身份证号",
    "姓名",
    "雇员编号",
    "客户编号",
    "客户名称",
    "客户全称",
    "客户组",
    "发包方",
    "社保金额",
    "公积金金额",
    "服务费",
    "对账金额",
    "来源文件",
    "工作表",
    "Excel行号",
  ];
  if (output.detailsIncluded) {
    XLSX.utils.book_append_sheet(
      workbook,
      makeSheet(
        detailHeaders,
        detailRows(output.scRecords),
        [11, 11, 22, 14, 14, 15, 24, 30, 20, 20, 14, 14, 14, 14, 28, 24, 12],
        { centeredColumns: [0, 1], moneyColumns: [10, 11, 12, 13], integerColumns: [16] },
      ),
      "速创原始明细",
    );
    XLSX.utils.book_append_sheet(
      workbook,
      makeSheet(
        detailHeaders,
        detailRows(output.hrallyRecords),
        [11, 11, 22, 14, 14, 15, 24, 30, 20, 20, 14, 14, 14, 14, 28, 24, 12],
        { centeredColumns: [0, 1], moneyColumns: [10, 11, 12, 13], integerColumns: [16] },
      ),
      "聚合力原始明细",
    );
  }

  XLSX.utils.book_append_sheet(
    workbook,
    makeSheet(
      ["数据来源", "文件", "工作表", "Excel行号", "字段", "问题", "原始值"],
      issueRows(output.issues),
      [12, 28, 24, 12, 16, 30, 24],
      { integerColumns: [3] },
    ),
    "导入错误",
  );

  XLSX.utils.book_append_sheet(
    workbook,
    makeSheet(
      ["指标", "数量"],
      [
        ["核对结果总数", output.summary.total],
        ["金额一致", output.summary.matched],
        ["存在差异", output.summary.different],
        ["仅速创", output.summary.scOnly],
        ["仅聚合力", output.summary.hrallyOnly],
        ["导入错误", output.summary.importIssues],
        ["速创有效明细", output.scRecords.length],
        ["聚合力有效明细", output.hrallyRecords.length],
        ["导出模式", output.detailsIncluded ? "完整明细" : "大文件结果模式"],
      ],
      [24, 14],
      { integerColumns: [1] },
    ),
    "统计摘要",
  );

  XLSX.utils.book_append_sheet(
    workbook,
    makeSheet(
      ["未找到映射的客户编号"],
      output.missingCustomerMappings.map((companyNo) => [companyNo]),
      [28],
    ),
    "客户映射异常",
  );

  return workbook;
}

export async function exportReconciliation(output: ReconciliationOutput): Promise<void> {
  const workbook = buildWorkbook(output);
  const months = [...new Set(output.results.map((result) => result.accYm))];
  const monthPart = months.length === 1 ? `_${months[0]}` : "";
  const fileName = `上海速创-聚合力对账${monthPart}_${timestamp()}.xlsx`;
  const writeOptions = { type: "array", compression: true, bookType: "xlsx" } as const;
  const data = output.detailsIncluded
    ? XLSX.write(workbook, writeOptions)
    : (await import("xlsx")).write(workbook as unknown as FastWorkBook, writeOptions);
  const url = URL.createObjectURL(
    new Blob([data], { type: "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" }),
  );
  const link = document.createElement("a");
  link.href = url;
  link.download = fileName;
  link.click();
  window.setTimeout(() => URL.revokeObjectURL(url), 0);
}
