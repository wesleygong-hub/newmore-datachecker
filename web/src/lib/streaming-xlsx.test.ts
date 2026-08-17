import * as XLSX from "xlsx";
import { describe, expect, it } from "vitest";
import type { NormalizedRecord } from "../domain/types";
import { parseStreamingXlsx } from "./streaming-xlsx";

function workbookFile(name: string, sheetName: string, rows: unknown[][]): File {
  const workbook = XLSX.utils.book_new();
  XLSX.utils.book_append_sheet(workbook, XLSX.utils.aoa_to_sheet(rows), sheetName);
  const data = XLSX.write(workbook, {
    type: "array",
    bookType: "xlsx",
    bookSST: true,
  }) as ArrayBuffer;
  return new File([data], name, {
    type: "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
  });
}

describe("XLSX 流式解析", () => {
  it("逐行读取速创账单并保留三键金额", async () => {
    const file = workbookFile("速创202512.xlsx", "关联方账单", [
      ["账单年月", "业务年月", "身份证", "姓名", "客户代码", "社保总额", "公积金总额", "服务费类金额", "对账金额"],
      ["202512", "202511", "310101199001010011", "测试人员", "C001", 100.2, 50, 10, 160.2],
    ]);
    const records: NormalizedRecord[] = [];
    const parsed = await parseStreamingXlsx(file, "sc", (record) => records.push(record));
    expect(parsed.selectedSheet.recordCount).toBe(1);
    expect(records[0]).toMatchObject({
      accYm: "202512",
      realAccYm: "202511",
      id: "310101199001010011",
      socialAmount: "100.20",
      fundAmount: "50.00",
      serviceAmount: "10.00",
      totalAmount: "160.20",
    });
  });

  it("逐行读取聚合力账单并保持额外费用只进入总额", async () => {
    const file = workbookFile("聚合力202512.xlsx", "总表", [
      ["财务年月", "业务年月", "客户名", "雇员姓名", "身份证", "养老保险公司金额", "养老保险个人金额", "基本公积金公司金额", "基本公积金个人金额", "采暖费金额", "人事管理服务费", "薪酬服务费", "人事资料管理服务费", "总额"],
      ["202512", "202512", "测试客户", "测试人员", "310101199001010011", 80, 20, 30, 30, 10, 40, 2, 3, 220],
    ]);
    const records: NormalizedRecord[] = [];
    await parseStreamingXlsx(file, "hrally", (record) => records.push(record));
    expect(records[0]).toMatchObject({
      socialAmount: "100.00",
      fundAmount: "60.00",
      serviceAmount: "45.00",
      totalAmount: "220.00",
    });
  });
});
