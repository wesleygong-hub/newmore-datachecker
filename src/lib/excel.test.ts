import { readFileSync, existsSync } from "node:fs";
import { fileURLToPath } from "node:url";
import * as XLSX from "xlsx";
import { describe, expect, it } from "vitest";
import type { TransferFile } from "../domain/types";
import { parseCustomerWorkbook, parseHrallyWorkbook, parseScWorkbook } from "./excel";
import { reconcile } from "./reconcile";

function workbookFile(name: string, sheets: Record<string, unknown[][]>): TransferFile {
  const workbook = XLSX.utils.book_new();
  for (const [sheetName, rows] of Object.entries(sheets)) {
    XLSX.utils.book_append_sheet(workbook, XLSX.utils.aoa_to_sheet(rows), sheetName);
  }
  const data = XLSX.write(workbook, { type: "array", bookType: "xlsx" }) as ArrayBuffer;
  return { name, data };
}

function bufferFile(path: string, name: string): TransferFile {
  const buffer = readFileSync(path);
  const data = buffer.buffer.slice(buffer.byteOffset, buffer.byteOffset + buffer.byteLength);
  return { name, data };
}

describe("Excel adapters", () => {
  it("读取随项目提供的客户清单 Excel 模板", () => {
    const templatePath = fileURLToPath(
      new URL("../../docs/客户清单模板.xlsx", import.meta.url),
    );
    const parsed = parseCustomerWorkbook(bufferFile(templatePath, "客户清单模板.xlsx"));

    expect(parsed.issues).toHaveLength(0);
    expect(parsed.mappings).toEqual([
      expect.objectContaining({
        companyNo: "示例客户001",
        groupName: "示例客户组",
        partyName: "示例发包方",
      }),
    ]);
  });

  it("按表头识别速创汇总格式", () => {
    const file = workbookFile("速创202512.xlsx", {
      关联方账单202512: [
        ["账单年月", "业务年月", "身份证", "姓名", "客户代码", "社保总额", "公积金总额", "服务费类金额", "薪酬金额", "雇员总额", "对账金额"],
        ["202512", "202511", "310101199001010011", "测试人员", "CH001", "100.20", "50", "10", "200", "360.20", "160.20"],
      ],
    });
    const parsed = parseScWorkbook(file);
    expect(parsed.records).toHaveLength(1);
    expect(parsed.records[0]).toMatchObject({
      accYm: "202512",
      realAccYm: "202511",
      id: "310101199001010011",
      socialAmount: "100.20",
      fundAmount: "50.00",
      serviceAmount: "10.00",
      totalAmount: "160.20",
    });
  });

  it("聚合力的采暖费等字段不进入前三类差额", () => {
    const file = workbookFile("聚合力202512.xlsx", {
      聚合力202512: [
        ["财务年月", "业务年月", "客户名", "雇员姓名", "身份证", "平台雇员编号", "养老保险公司金额", "养老保险个人金额", "基本公积金公司金额", "基本公积金个人金额", "残保金", "采暖费金额", "人事管理服务费", "薪酬服务费", "人事资料管理服务费", "总额"],
        ["202512", "202512", "测试客户", "测试人员", "310101199001010011", "1001", 80, 20, 30, 30, 5, 10, 40, 2, 3, 220],
      ],
    });
    const parsed = parseHrallyWorkbook(file);
    expect(parsed.records[0]).toMatchObject({
      socialAmount: "105.00",
      fundAmount: "60.00",
      serviceAmount: "45.00",
      totalAmount: "220.00",
    });
  });
});

const samplePath = fileURLToPath(
  new URL("../../上海速创-聚合力对账/对账数据20251217.xlsx", import.meta.url),
);

describe.skipIf(!existsSync(samplePath))("历史样例回归", () => {
  it("读取 202512 样例并按三键生成唯一结果", () => {
    const sc = parseScWorkbook(bufferFile(samplePath, "对账数据20251217.xlsx"));
    const hrally = parseHrallyWorkbook(bufferFile(samplePath, "对账数据20251217.xlsx"));
    expect(sc.records).toHaveLength(13_599);
    expect(hrally.records).toHaveLength(8_809);

    const output = reconcile(sc.records, hrally.records, [...sc.issues, ...hrally.issues]);
    expect(output.results).toHaveLength(13_276);
    const tangWenli = output.results.find((result) => result.id === "310228198204082228");
    expect(tangWenli).toBeDefined();
    expect(tangWenli?.scRowCount).toBe(2);
    expect(tangWenli?.hrallyRowCount).toBe(1);
    expect(tangWenli?.status).toBe("matched");
    expect(tangWenli?.total.difference).toBe("0.00");
  }, 60_000);
});
