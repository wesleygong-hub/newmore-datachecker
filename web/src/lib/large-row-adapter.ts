import type { DataSide, ImportIssue, NormalizedRecord } from "../domain/types";
import {
  ALIASES,
  HRALLY_FUND_FIELDS,
  HRALLY_SOCIAL_FIELDS,
  SC_FUND_COMPONENTS,
  SC_SOCIAL_COMPONENTS,
  componentColumns,
  findAllColumns,
  findColumn,
  isBlankRow,
  requireColumn,
  type Row,
} from "./excel";
import {
  inferYearMonthFromFileName,
  normalizeCompanyNo,
  normalizeHeader,
  normalizeId,
  normalizeText,
  normalizeYearMonth,
} from "./normalize";

export interface RowParseResult {
  record?: NormalizedRecord;
  issues: ImportIssue[];
}

export interface LargeRowAdapter {
  parse(row: Row, rowNumber: number): RowParseResult;
}

function issue(
  issues: ImportIssue[],
  side: DataSide,
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
    rawValue: value === undefined ? undefined : normalizeText(value).slice(0, 200),
  });
}

function moneyValueToCents(value: unknown): number | null {
  if (value === null || value === undefined || normalizeText(value) === "") return 0;
  if (typeof value === "number") {
    if (!Number.isFinite(value)) return null;
    return Math.sign(value) * Math.round(Math.abs(value) * 100 + 1e-8);
  }
  let text = normalizeText(value).replace(/[,，￥¥$]/g, "");
  if (/^\(.*\)$/.test(text)) text = `-${text.slice(1, -1)}`;
  const match = text.match(/^([+-]?)(?:(\d+)(?:\.(\d*))?|\.(\d+))$/);
  if (!match) return null;
  const fraction = (match[3] ?? match[4] ?? "").padEnd(3, "0");
  let cents = Number(match[2] ?? "0") * 100 + Number(fraction.slice(0, 2));
  if (Number(fraction[2] ?? "0") >= 5) cents += 1;
  return match[1] === "-" ? -cents : cents;
}

function centsToMoney(value: number): string {
  const sign = value < 0 ? "-" : "";
  const absolute = Math.abs(value);
  return `${sign}${Math.floor(absolute / 100)}.${String(absolute % 100).padStart(2, "0")}`;
}

function sumMoney(
  row: Row,
  columns: number[],
  issues: ImportIssue[],
  context: {
    side: DataSide;
    fileName: string;
    sheetName: string;
    rowNumber: number;
    field: string;
  },
): number | null {
  let total = 0;
  for (const column of columns.filter((value) => value >= 0)) {
    const value = moneyValueToCents(row[column]);
    if (value === null) {
      issue(
        issues,
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
    total += value;
  }
  return total;
}

function createScAdapter(rawHeaders: Row, fileName: string, sheetName: string): LargeRowAdapter {
  const headers = rawHeaders.map(normalizeHeader);
  const accColumn = findColumn(headers, ALIASES.accYm);
  const inferredAccYm = inferYearMonthFromFileName(fileName);
  if (accColumn < 0 && !inferredAccYm) {
    throw new Error(`【${fileName} / ${sheetName}】缺少账单年月，且无法从文件名推断。`);
  }
  const realAccColumn = requireColumn(headers, ALIASES.realAccYm, fileName, sheetName, "业务年月/发生年月");
  const idColumn = requireColumn(headers, ALIASES.id, fileName, sheetName, "身份证号");
  const nameColumn = requireColumn(headers, ALIASES.scName, fileName, sheetName, "姓名");
  const employeeColumn = findColumn(headers, ALIASES.scEmployeeNo);
  const companyNoColumn = findColumn(headers, ALIASES.companyNo);
  const companyNameColumn = findColumn(headers, ALIASES.scCompanyName);
  const companyFullNameColumn = findColumn(headers, ALIASES.scCompanyFullName);
  const groupNameColumn = findColumn(headers, ALIASES.groupName);
  const partyNameColumn = findColumn(headers, ALIASES.partyName);
  const socialDirectColumn = findColumn(headers, ALIASES.scSocialTotal);
  const fundDirectColumn = findColumn(headers, ALIASES.scFundTotal);
  const serviceColumn = requireColumn(headers, ALIASES.scServiceTotal, fileName, sheetName, "服务费类金额/管理费");
  const compareTotalColumn = findColumn(headers, ALIASES.scCompareTotal);
  const employeeTotalColumn = findColumn(headers, ALIASES.scEmployeeTotal);
  const wagePayColumn = findColumn(headers, ALIASES.scWagePay);
  const socialComponentColumns = componentColumns(headers, SC_SOCIAL_COMPONENTS);
  const fundComponentColumns = componentColumns(headers, SC_FUND_COMPONENTS);

  if (socialDirectColumn < 0 && socialComponentColumns.length === 0) {
    throw new Error(`【${fileName} / ${sheetName}】缺少社保金额字段。`);
  }
  if (fundDirectColumn < 0 && fundComponentColumns.length === 0) {
    throw new Error(`【${fileName} / ${sheetName}】缺少公积金金额字段。`);
  }
  if (compareTotalColumn < 0 && employeeTotalColumn < 0) {
    throw new Error(`【${fileName} / ${sheetName}】缺少对账金额或总计字段。`);
  }

  return {
    parse(row, rowNumber) {
      if (isBlankRow(row)) return { issues: [] };
      const issues: ImportIssue[] = [];
      const id = normalizeId(row[idColumn]);
      const name = normalizeText(row[nameColumn]);
      if (!id && /合计/.test(name)) return { issues };
      const accYm = accColumn >= 0 ? normalizeYearMonth(row[accColumn]) : inferredAccYm;
      const realAccYm = normalizeYearMonth(row[realAccColumn]);
      if (!accYm) issue(issues, "sc", fileName, sheetName, rowNumber, "财务年月", "年月必须为 YYYYMM", row[accColumn]);
      if (!realAccYm) issue(issues, "sc", fileName, sheetName, rowNumber, "业务年月", "年月必须为 YYYYMM", row[realAccColumn]);
      if (!id) issue(issues, "sc", fileName, sheetName, rowNumber, "身份证号", "身份证号不能为空", row[idColumn]);

      const context = { side: "sc" as const, fileName, sheetName, rowNumber };
      const social = sumMoney(
        row,
        socialDirectColumn >= 0 ? [socialDirectColumn] : socialComponentColumns,
        issues,
        { ...context, field: "社保金额" },
      );
      const fund = sumMoney(
        row,
        fundDirectColumn >= 0 ? [fundDirectColumn] : fundComponentColumns,
        issues,
        { ...context, field: "公积金金额" },
      );
      const service = sumMoney(row, [serviceColumn], issues, { ...context, field: "服务费" });
      let total: number | null;
      if (compareTotalColumn >= 0) {
        total = sumMoney(row, [compareTotalColumn], issues, { ...context, field: "对账金额" });
      } else {
        const employeeTotal = sumMoney(row, [employeeTotalColumn], issues, { ...context, field: "总计" });
        const wagePay = wagePayColumn >= 0
          ? sumMoney(row, [wagePayColumn], issues, { ...context, field: "薪酬金额" })
          : 0;
        total = employeeTotal !== null && wagePay !== null ? employeeTotal - wagePay : null;
      }
      if (!accYm || !realAccYm || !id || social === null || fund === null || service === null || total === null) return { issues };

      return {
        issues,
        record: {
          side: "sc",
          fileName,
          sheetName,
          rowNumber,
          accYm,
          realAccYm,
          id,
          name,
          employeeNo: employeeColumn >= 0 ? normalizeText(row[employeeColumn]) : "",
          companyNo: companyNoColumn >= 0 ? normalizeCompanyNo(row[companyNoColumn]) : "",
          companyName: companyNameColumn >= 0 ? normalizeText(row[companyNameColumn]) : "",
          companyFullName: companyFullNameColumn >= 0 ? normalizeText(row[companyFullNameColumn]) : "",
          groupName: groupNameColumn >= 0 ? normalizeText(row[groupNameColumn]) : "",
          partyName: partyNameColumn >= 0 ? normalizeText(row[partyNameColumn]) : "",
          socialAmount: centsToMoney(social),
          fundAmount: centsToMoney(fund),
          serviceAmount: centsToMoney(service),
          totalAmount: centsToMoney(total),
        },
      };
    },
  };
}

function createHrallyAdapter(rawHeaders: Row, fileName: string, sheetName: string): LargeRowAdapter {
  const headers = rawHeaders.map(normalizeHeader);
  const accColumn = requireColumn(headers, ALIASES.accYm, fileName, sheetName, "财务年月");
  const realAccColumn = requireColumn(headers, ALIASES.realAccYm, fileName, sheetName, "业务年月");
  const idColumn = requireColumn(headers, ALIASES.id, fileName, sheetName, "身份证号");
  const nameColumn = requireColumn(headers, ALIASES.hrallyName, fileName, sheetName, "雇员姓名");
  const employeeColumn = findColumn(headers, ALIASES.hrallyEmployeeNo);
  const companyNameColumn = findColumn(headers, ALIASES.hrallyCompanyName);
  const totalColumn = requireColumn(headers, ALIASES.hrallyTotal, fileName, sheetName, "总额");
  const socialColumns = HRALLY_SOCIAL_FIELDS.flatMap((field) => findAllColumns(headers, [field]));
  const fundColumns = HRALLY_FUND_FIELDS.flatMap((field) => findAllColumns(headers, [field]));
  const serviceColumns = [
    findColumn(headers, ALIASES.hrallyAdmFee),
    findColumn(headers, ALIASES.hrallyPayrollFee),
    findColumn(headers, ALIASES.hrallyDocFee),
  ].filter((column) => column >= 0);
  if (socialColumns.length === 0) throw new Error(`【${fileName} / ${sheetName}】缺少社保金额字段。`);
  if (fundColumns.length === 0) throw new Error(`【${fileName} / ${sheetName}】缺少公积金金额字段。`);

  return {
    parse(row, rowNumber) {
      if (isBlankRow(row)) return { issues: [] };
      const issues: ImportIssue[] = [];
      const id = normalizeId(row[idColumn]);
      const name = normalizeText(row[nameColumn]);
      if (!id && /合计/.test(name)) return { issues };
      const accYm = normalizeYearMonth(row[accColumn]);
      const realAccYm = normalizeYearMonth(row[realAccColumn]);
      if (!accYm) issue(issues, "hrally", fileName, sheetName, rowNumber, "财务年月", "年月必须为 YYYYMM", row[accColumn]);
      if (!realAccYm) issue(issues, "hrally", fileName, sheetName, rowNumber, "业务年月", "年月必须为 YYYYMM", row[realAccColumn]);
      if (!id) issue(issues, "hrally", fileName, sheetName, rowNumber, "身份证号", "身份证号不能为空", row[idColumn]);

      const context = { side: "hrally" as const, fileName, sheetName, rowNumber };
      const social = sumMoney(row, socialColumns, issues, { ...context, field: "社保金额" });
      const fund = sumMoney(row, fundColumns, issues, { ...context, field: "公积金金额" });
      const service = sumMoney(row, serviceColumns, issues, { ...context, field: "服务费" });
      const total = sumMoney(row, [totalColumn], issues, { ...context, field: "总额" });
      if (!accYm || !realAccYm || !id || social === null || fund === null || service === null || total === null) return { issues };

      return {
        issues,
        record: {
          side: "hrally",
          fileName,
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
          socialAmount: centsToMoney(social),
          fundAmount: centsToMoney(fund),
          serviceAmount: centsToMoney(service),
          totalAmount: centsToMoney(total),
        },
      };
    },
  };
}

export function createLargeRowAdapter(
  side: DataSide,
  headers: Row,
  fileName: string,
  sheetName: string,
): LargeRowAdapter {
  return side === "sc"
    ? createScAdapter(headers, fileName, sheetName)
    : createHrallyAdapter(headers, fileName, sheetName);
}
