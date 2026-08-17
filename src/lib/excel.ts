import Decimal from "decimal.js";
import * as XLSX from "xlsx";
import type {
  CustomerMapping,
  DataSide,
  ImportIssue,
  NormalizedRecord,
  ParsedData,
  TransferFile,
} from "../domain/types";
import {
  inferYearMonthFromFileName,
  moneyToString,
  normalizeCompanyNo,
  normalizeHeader,
  normalizeId,
  normalizeText,
  normalizeYearMonth,
  parseMoney,
} from "./normalize";

export type Row = unknown[];

interface SheetCandidate {
  sheetName: string;
  rows: Row[];
  headerRowIndex: number;
  headers: string[];
  score: number;
}

const HEADER_SCAN_LIMIT = 15;

export const ALIASES = {
  accYm: ["账单年月", "财务年月", "ACCYM"],
  realAccYm: ["业务年月", "发生年月", "YYYYMM", "REALACCYM"],
  id: ["身份证", "身份证号", "证件号码", "IDCARD", "ID"],
  scName: ["姓名", "NAME"],
  hrallyName: ["雇员姓名", "姓名", "EMPLOYEENAME", "NAME"],
  scEmployeeNo: ["雇员编号", "外服工号", "SFSCID", "EMPNO"],
  hrallyEmployeeNo: ["平台雇员编号", "雇员编号", "UDID"],
  companyNo: ["客户代码", "客户编号", "商社编号", "COMPANYNO", "COMPANYCODE"],
  scCompanyName: ["客户简称", "商社名称", "COMPANYNAME"],
  scCompanyFullName: ["客户全称", "COMPANYFULLNAME"],
  hrallyCompanyName: ["客户名", "客户名称", "COMPANYNAME"],
  groupName: ["客户组名称", "客户组", "COMPGROUPNAME", "COMPGRPNAME"],
  partyName: ["发包方名称", "关联方", "PARTYSHORTNAME", "PARTYNAME"],
  scSocialTotal: ["社保总额", "社保总计", "SOCIALTOTAL"],
  scFundTotal: ["公积金总额", "公积金总计", "FUNDTOTAL"],
  scServiceTotal: ["服务费类金额", "服务费金额", "管理费", "ADMFEE"],
  scWagePay: ["薪酬金额", "代办薪酬", "AGENCYOFWAGEPAYMENT", "WAGEPAY"],
  scEmployeeTotal: ["雇员总额", "总计", "TOTAL", "TOTALVAL"],
  scCompareTotal: ["对账金额", "对账总计", "RECONCILIATIONTOTAL"],
  hrallyTotal: ["总额", "TOTAL", "TOTALPAYABLEVAL"],
  hrallyAdmFee: ["人事管理服务费", "管理服务费", "ADMFEE"],
  hrallyPayrollFee: ["薪酬服务费", "PAYROLLFEE"],
  hrallyDocFee: ["人事资料管理服务费", "资料管理服务费", "DOCFEE"],
} as const;

export const SC_SOCIAL_COMPONENTS = [
  ["养老保险", "养老保险ENDOWMENT", "ENDOWMENT"],
  ["医疗保险", "医疗保险MEDICAL", "MEDICAL"],
  ["失业保险", "失业保险UNEMPLOYMENT", "UNEMPLOYMENT"],
  ["工伤保险", "工伤保险EMPLOYMENTINJURY", "EMPLOYMENTINJURY"],
  ["医疗生育保险", "医疗生育保险MEDICALMATERNITY", "生育保险", "MATERNITY"],
] as const;

export const SC_FUND_COMPONENTS = [
  ["公积金PROVIDENTFUND", "PROVIDENTFUND"],
  ["补充公积金SUPPLEMENTARYHOUSINGFUND", "SUPPLEMENTARYHOUSINGFUND"],
] as const;

export const HRALLY_SOCIAL_FIELDS = [
  "养老保险公司金额",
  "养老保险个人金额",
  "医疗保险公司金额",
  "医疗保险个人金额",
  "失业保险公司金额",
  "失业保险个人金额",
  "工伤保险公司金额",
  "工伤保险个人金额",
  "生育保险公司金额",
  "生育保险个人金额",
  "残保金",
] as const;

export const HRALLY_FUND_FIELDS = [
  "基本公积金公司金额",
  "基本公积金个人金额",
  "补充公积金公司金额",
  "补充公积金个人金额",
] as const;

function normalizedAliases(aliases: readonly string[]): string[] {
  return aliases.map(normalizeHeader);
}

export function findColumn(headers: string[], aliases: readonly string[]): number {
  const targets = normalizedAliases(aliases);
  return headers.findIndex((header) => targets.includes(header));
}

export function findAllColumns(headers: string[], aliases: readonly string[]): number[] {
  const targets = normalizedAliases(aliases);
  return headers
    .map((header, index) => (targets.includes(header) ? index : -1))
    .filter((index) => index >= 0);
}

function hasColumn(headers: string[], aliases: readonly string[]): boolean {
  return findColumn(headers, aliases) >= 0;
}

function workbookRows(workbook: XLSX.WorkBook, sheetName: string): Row[] {
  return XLSX.utils.sheet_to_json<Row>(workbook.Sheets[sheetName], {
    header: 1,
    raw: true,
    defval: null,
    blankrows: true,
  });
}

function scoreScHeaders(headers: string[], sheetName: string, fileName: string): number {
  let score = 0;
  if (hasColumn(headers, ALIASES.id)) score += 8;
  if (hasColumn(headers, ALIASES.realAccYm)) score += 6;
  if (hasColumn(headers, ALIASES.accYm) || inferYearMonthFromFileName(fileName)) score += 4;
  if (hasColumn(headers, ALIASES.scName)) score += 2;
  if (hasColumn(headers, ALIASES.companyNo)) score += 3;
  if (hasColumn(headers, ALIASES.scSocialTotal)) score += 7;
  if (hasColumn(headers, ALIASES.scFundTotal)) score += 7;
  if (hasColumn(headers, ALIASES.scServiceTotal)) score += 4;
  if (hasColumn(headers, ALIASES.scCompareTotal)) score += 5;
  if (hasColumn(headers, ALIASES.scEmployeeTotal)) score += 3;
  if (SC_SOCIAL_COMPONENTS.some((aliases) => findAllColumns(headers, aliases).length >= 2)) score += 7;
  if (/关联方账单/.test(sheetName)) score += 14;
  else if (/速创/.test(sheetName)) score += 6;
  if (/聚合力/.test(sheetName)) score -= 12;
  return score;
}

function scoreHrallyHeaders(headers: string[], sheetName: string): number {
  let score = 0;
  if (hasColumn(headers, ALIASES.id)) score += 8;
  if (hasColumn(headers, ALIASES.accYm)) score += 6;
  if (hasColumn(headers, ALIASES.realAccYm)) score += 6;
  if (hasColumn(headers, ALIASES.hrallyName)) score += 2;
  if (hasColumn(headers, ALIASES.hrallyCompanyName)) score += 3;
  if (hasColumn(headers, ["养老保险公司金额"])) score += 8;
  if (hasColumn(headers, ALIASES.hrallyAdmFee)) score += 5;
  if (hasColumn(headers, ALIASES.hrallyTotal)) score += 5;
  if (/聚合力/.test(sheetName)) score += 12;
  if (/速创|关联方账单/.test(sheetName)) score -= 12;
  return score;
}

export function scoreSheetHeaders(
  side: DataSide,
  rawHeaders: Row,
  sheetName: string,
  fileName: string,
): number {
  const headers = rawHeaders.map(normalizeHeader);
  return side === "sc"
    ? scoreScHeaders(headers, sheetName, fileName)
    : scoreHrallyHeaders(headers, sheetName);
}

function findBestSheet(
  workbook: XLSX.WorkBook,
  side: DataSide,
  fileName: string,
): SheetCandidate {
  const candidates: SheetCandidate[] = [];
  for (const sheetName of workbook.SheetNames) {
    const rows = workbookRows(workbook, sheetName);
    const scanCount = Math.min(HEADER_SCAN_LIMIT, rows.length);
    for (let rowIndex = 0; rowIndex < scanCount; rowIndex += 1) {
      const headers = (rows[rowIndex] ?? []).map(normalizeHeader);
      const score =
        side === "sc"
          ? scoreScHeaders(headers, sheetName, fileName)
          : scoreHrallyHeaders(headers, sheetName);
      candidates.push({ sheetName, rows, headerRowIndex: rowIndex, headers, score });
    }
  }

  candidates.sort((a, b) => b.score - a.score);
  const best = candidates[0];
  const minimumScore = side === "sc" ? 22 : 28;
  if (!best || best.score < minimumScore) {
    throw new Error(
      `无法在【${fileName}】中识别${side === "sc" ? "速创" : "聚合力"}账单工作表。`,
    );
  }
  return best;
}

export function isBlankRow(row: Row): boolean {
  return row.every((value) => normalizeText(value) === "");
}

function rawValue(value: unknown): string {
  return normalizeText(value).slice(0, 200);
}

function addIssue(
  issues: ImportIssue[],
  side: DataSide | "customer",
  fileName: string,
  sheetName: string,
  rowNumber: number,
  field: string,
  message: string,
  value?: unknown,
): void {
  issues.push({
    side,
    fileName,
    sheetName,
    rowNumber,
    field,
    message,
    rawValue: value === undefined ? undefined : rawValue(value),
  });
}

function readMoney(
  row: Row,
  columns: number[],
  context: {
    issues: ImportIssue[];
    side: DataSide;
    fileName: string;
    sheetName: string;
    rowNumber: number;
    field: string;
  },
): Decimal | null {
  let result = new Decimal(0);
  for (const column of columns.filter((value) => value >= 0)) {
    const value = parseMoney(row[column]);
    if (!value) {
      addIssue(
        context.issues,
        context.side,
        context.fileName,
        context.sheetName,
        context.rowNumber,
        context.field,
        "金额不是有效数字",
        row[column],
      );
      return null;
    }
    result = result.plus(value);
  }
  return result;
}

export function requireColumn(
  headers: string[],
  aliases: readonly string[],
  fileName: string,
  sheetName: string,
  label: string,
): number {
  const column = findColumn(headers, aliases);
  if (column < 0) throw new Error(`【${fileName} / ${sheetName}】缺少必要字段：${label}`);
  return column;
}

export function componentColumns(headers: string[], groups: readonly (readonly string[])[]): number[] {
  return groups.flatMap((aliases) => findAllColumns(headers, aliases));
}

export function parseScWorkbook(file: TransferFile): ParsedData {
  const workbook = XLSX.read(file.data, { type: "array", cellDates: true });
  const candidate = findBestSheet(workbook, "sc", file.name);
  const { headers, rows, sheetName, headerRowIndex } = candidate;
  const issues: ImportIssue[] = [];
  const records: NormalizedRecord[] = [];

  const accColumn = findColumn(headers, ALIASES.accYm);
  const inferredAccYm = inferYearMonthFromFileName(file.name);
  if (accColumn < 0 && !inferredAccYm) {
    throw new Error(`【${file.name} / ${sheetName}】缺少账单年月，且无法从文件名推断。`);
  }
  const realAccColumn = requireColumn(
    headers,
    ALIASES.realAccYm,
    file.name,
    sheetName,
    "业务年月/发生年月",
  );
  const idColumn = requireColumn(headers, ALIASES.id, file.name, sheetName, "身份证号");
  const nameColumn = requireColumn(headers, ALIASES.scName, file.name, sheetName, "姓名");
  const employeeColumn = findColumn(headers, ALIASES.scEmployeeNo);
  const companyNoColumn = findColumn(headers, ALIASES.companyNo);
  const companyNameColumn = findColumn(headers, ALIASES.scCompanyName);
  const companyFullNameColumn = findColumn(headers, ALIASES.scCompanyFullName);
  const groupNameColumn = findColumn(headers, ALIASES.groupName);
  const partyNameColumn = findColumn(headers, ALIASES.partyName);

  const socialDirectColumn = findColumn(headers, ALIASES.scSocialTotal);
  const fundDirectColumn = findColumn(headers, ALIASES.scFundTotal);
  const serviceColumn = requireColumn(
    headers,
    ALIASES.scServiceTotal,
    file.name,
    sheetName,
    "服务费类金额/管理费",
  );
  const compareTotalColumn = findColumn(headers, ALIASES.scCompareTotal);
  const employeeTotalColumn = findColumn(headers, ALIASES.scEmployeeTotal);
  const wagePayColumn = findColumn(headers, ALIASES.scWagePay);

  const socialComponentColumns = componentColumns(headers, SC_SOCIAL_COMPONENTS);
  const fundComponentColumns = componentColumns(headers, SC_FUND_COMPONENTS);
  if (socialDirectColumn < 0 && socialComponentColumns.length === 0) {
    throw new Error(`【${file.name} / ${sheetName}】缺少社保金额字段。`);
  }
  if (fundDirectColumn < 0 && fundComponentColumns.length === 0) {
    throw new Error(`【${file.name} / ${sheetName}】缺少公积金金额字段。`);
  }
  if (compareTotalColumn < 0 && employeeTotalColumn < 0) {
    throw new Error(`【${file.name} / ${sheetName}】缺少对账金额或总计字段。`);
  }

  for (let index = headerRowIndex + 1; index < rows.length; index += 1) {
    const row = rows[index] ?? [];
    if (isBlankRow(row)) continue;
    const rowNumber = index + 1;
    const id = normalizeId(row[idColumn]);
    const name = normalizeText(row[nameColumn]);
    if (!id && /合计/.test(name)) continue;

    const accYm = accColumn >= 0 ? normalizeYearMonth(row[accColumn]) : inferredAccYm;
    const realAccYm = normalizeYearMonth(row[realAccColumn]);
    let valid = true;
    if (!accYm) {
      addIssue(issues, "sc", file.name, sheetName, rowNumber, "财务年月", "年月必须为 YYYYMM", row[accColumn]);
      valid = false;
    }
    if (!realAccYm) {
      addIssue(issues, "sc", file.name, sheetName, rowNumber, "业务年月", "年月必须为 YYYYMM", row[realAccColumn]);
      valid = false;
    }
    if (!id) {
      addIssue(issues, "sc", file.name, sheetName, rowNumber, "身份证号", "身份证号不能为空", row[idColumn]);
      valid = false;
    }

    const moneyContext = { issues, side: "sc" as const, fileName: file.name, sheetName, rowNumber };
    const social = readMoney(
      row,
      [socialDirectColumn >= 0 ? socialDirectColumn : -1, ...(socialDirectColumn < 0 ? socialComponentColumns : [])],
      { ...moneyContext, field: "社保金额" },
    );
    const fund = readMoney(
      row,
      [fundDirectColumn >= 0 ? fundDirectColumn : -1, ...(fundDirectColumn < 0 ? fundComponentColumns : [])],
      { ...moneyContext, field: "公积金金额" },
    );
    const service = readMoney(row, [serviceColumn], { ...moneyContext, field: "服务费" });
    let total: Decimal | null;
    if (compareTotalColumn >= 0) {
      total = readMoney(row, [compareTotalColumn], { ...moneyContext, field: "对账金额" });
    } else {
      const employeeTotal = readMoney(row, [employeeTotalColumn], {
        ...moneyContext,
        field: "总计",
      });
      const wagePay =
        wagePayColumn >= 0
          ? readMoney(row, [wagePayColumn], { ...moneyContext, field: "薪酬金额" })
          : new Decimal(0);
      total = employeeTotal && wagePay ? employeeTotal.minus(wagePay) : null;
    }

    if (!social || !fund || !service || !total) valid = false;
    if (!valid || !accYm || !realAccYm || !social || !fund || !service || !total) continue;

    records.push({
      side: "sc",
      fileName: file.name,
      sheetName,
      rowNumber,
      accYm,
      realAccYm,
      id,
      name,
      employeeNo: employeeColumn >= 0 ? normalizeText(row[employeeColumn]) : "",
      companyNo: companyNoColumn >= 0 ? normalizeCompanyNo(row[companyNoColumn]) : "",
      companyName: companyNameColumn >= 0 ? normalizeText(row[companyNameColumn]) : "",
      companyFullName:
        companyFullNameColumn >= 0 ? normalizeText(row[companyFullNameColumn]) : "",
      groupName: groupNameColumn >= 0 ? normalizeText(row[groupNameColumn]) : "",
      partyName: partyNameColumn >= 0 ? normalizeText(row[partyNameColumn]) : "",
      socialAmount: moneyToString(social),
      fundAmount: moneyToString(fund),
      serviceAmount: moneyToString(service),
      totalAmount: moneyToString(total),
    });
  }

  return {
    records,
    issues,
    selectedSheets: [{ side: "sc", fileName: file.name, sheetName, recordCount: records.length }],
  };
}

export function parseHrallyWorkbook(file: TransferFile): ParsedData {
  const workbook = XLSX.read(file.data, { type: "array", cellDates: true });
  const candidate = findBestSheet(workbook, "hrally", file.name);
  const { headers, rows, sheetName, headerRowIndex } = candidate;
  const issues: ImportIssue[] = [];
  const records: NormalizedRecord[] = [];

  const accColumn = requireColumn(headers, ALIASES.accYm, file.name, sheetName, "财务年月");
  const realAccColumn = requireColumn(headers, ALIASES.realAccYm, file.name, sheetName, "业务年月");
  const idColumn = requireColumn(headers, ALIASES.id, file.name, sheetName, "身份证号");
  const nameColumn = requireColumn(headers, ALIASES.hrallyName, file.name, sheetName, "雇员姓名");
  const employeeColumn = findColumn(headers, ALIASES.hrallyEmployeeNo);
  const companyNameColumn = findColumn(headers, ALIASES.hrallyCompanyName);
  const totalColumn = requireColumn(headers, ALIASES.hrallyTotal, file.name, sheetName, "总额");
  const socialColumns = HRALLY_SOCIAL_FIELDS.flatMap((field) => findAllColumns(headers, [field]));
  const fundColumns = HRALLY_FUND_FIELDS.flatMap((field) => findAllColumns(headers, [field]));
  const serviceColumns = [
    findColumn(headers, ALIASES.hrallyAdmFee),
    findColumn(headers, ALIASES.hrallyPayrollFee),
    findColumn(headers, ALIASES.hrallyDocFee),
  ].filter((column) => column >= 0);
  if (socialColumns.length === 0) throw new Error(`【${file.name} / ${sheetName}】缺少社保金额字段。`);
  if (fundColumns.length === 0) throw new Error(`【${file.name} / ${sheetName}】缺少公积金金额字段。`);

  for (let index = headerRowIndex + 1; index < rows.length; index += 1) {
    const row = rows[index] ?? [];
    if (isBlankRow(row)) continue;
    const rowNumber = index + 1;
    const id = normalizeId(row[idColumn]);
    const name = normalizeText(row[nameColumn]);
    if (!id && /合计/.test(name)) continue;
    const accYm = normalizeYearMonth(row[accColumn]);
    const realAccYm = normalizeYearMonth(row[realAccColumn]);
    let valid = true;
    if (!accYm) {
      addIssue(issues, "hrally", file.name, sheetName, rowNumber, "财务年月", "年月必须为 YYYYMM", row[accColumn]);
      valid = false;
    }
    if (!realAccYm) {
      addIssue(issues, "hrally", file.name, sheetName, rowNumber, "业务年月", "年月必须为 YYYYMM", row[realAccColumn]);
      valid = false;
    }
    if (!id) {
      addIssue(issues, "hrally", file.name, sheetName, rowNumber, "身份证号", "身份证号不能为空", row[idColumn]);
      valid = false;
    }

    const moneyContext = {
      issues,
      side: "hrally" as const,
      fileName: file.name,
      sheetName,
      rowNumber,
    };
    const social = readMoney(row, socialColumns, { ...moneyContext, field: "社保金额" });
    const fund = readMoney(row, fundColumns, { ...moneyContext, field: "公积金金额" });
    const service = readMoney(row, serviceColumns, { ...moneyContext, field: "服务费" });
    const total = readMoney(row, [totalColumn], { ...moneyContext, field: "总额" });
    if (!social || !fund || !service || !total) valid = false;
    if (!valid || !accYm || !realAccYm || !social || !fund || !service || !total) continue;

    records.push({
      side: "hrally",
      fileName: file.name,
      sheetName,
      rowNumber,
      accYm,
      realAccYm,
      id,
      name,
      employeeNo: employeeColumn >= 0 ? normalizeText(row[employeeColumn]) : "",
      companyNo: "",
      companyName: companyNameColumn >= 0 ? normalizeText(row[companyNameColumn]) : "",
      companyFullName: companyNameColumn >= 0 ? normalizeText(row[companyNameColumn]) : "",
      groupName: "",
      partyName: "",
      socialAmount: moneyToString(social),
      fundAmount: moneyToString(fund),
      serviceAmount: moneyToString(service),
      totalAmount: moneyToString(total),
    });
  }

  return {
    records,
    issues,
    selectedSheets: [
      { side: "hrally", fileName: file.name, sheetName, recordCount: records.length },
    ],
  };
}

export function parseCustomerWorkbook(file: TransferFile): {
  mappings: CustomerMapping[];
  issues: ImportIssue[];
  selectedSheets: ParsedData["selectedSheets"];
} {
  const workbook = XLSX.read(file.data, { type: "array", cellDates: true });
  let best: SheetCandidate | undefined;
  for (const sheetName of workbook.SheetNames) {
    const rows = workbookRows(workbook, sheetName);
    for (let index = 0; index < Math.min(HEADER_SCAN_LIMIT, rows.length); index += 1) {
      const headers = (rows[index] ?? []).map(normalizeHeader);
      let score = 0;
      if (hasColumn(headers, ALIASES.companyNo)) score += 8;
      if (hasColumn(headers, ALIASES.groupName)) score += 5;
      if (hasColumn(headers, ALIASES.partyName)) score += 5;
      const candidate = { sheetName, rows, headerRowIndex: index, headers, score };
      if (!best || candidate.score > best.score) best = candidate;
    }
  }
  if (!best || best.score < 13) {
    throw new Error(`无法在【${file.name}】中识别客户清单。`);
  }

  const issues: ImportIssue[] = [];
  const mappings: CustomerMapping[] = [];
  const companyColumn = requireColumn(
    best.headers,
    ALIASES.companyNo,
    file.name,
    best.sheetName,
    "客户编号",
  );
  const groupColumn = findColumn(best.headers, ALIASES.groupName);
  const partyColumn = findColumn(best.headers, ALIASES.partyName);
  for (let index = best.headerRowIndex + 1; index < best.rows.length; index += 1) {
    const row = best.rows[index] ?? [];
    if (isBlankRow(row)) continue;
    const rowNumber = index + 1;
    const companyNo = normalizeCompanyNo(row[companyColumn]);
    if (!companyNo) {
      addIssue(
        issues,
        "customer",
        file.name,
        best.sheetName,
        rowNumber,
        "客户编号",
        "客户编号不能为空",
        row[companyColumn],
      );
      continue;
    }
    mappings.push({
      companyNo,
      groupName: groupColumn >= 0 ? normalizeText(row[groupColumn]) : "",
      partyName: partyColumn >= 0 ? normalizeText(row[partyColumn]) : "",
      source: { fileName: file.name, sheetName: best.sheetName, rowNumber },
    });
  }
  return {
    mappings,
    issues,
    selectedSheets: [
      {
        side: "customer",
        fileName: file.name,
        sheetName: best.sheetName,
        recordCount: mappings.length,
      },
    ],
  };
}
