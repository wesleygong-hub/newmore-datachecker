import * as XLSX from "xlsx";
import StyledXLSX from "xlsx-js-style";
import { strFromU8, unzipSync } from "fflate";
import { describe, expect, it } from "vitest";
import type { ReconciliationOutput } from "../domain/types";
import { buildWorkbook, serializeReconciliation } from "./export";

const output: ReconciliationOutput = {
  results: [
    {
      key: "202512\u001f202511\u001f310101199001010011",
      accYm: "202512",
      realAccYm: "202511",
      id: "310101199001010011",
      status: "matched",
      scNames: ["测试人员"],
      hrallyNames: ["测试人员"],
      scEmployeeNos: ["SC001"],
      hrallyEmployeeNos: ["HR001"],
      scCompanyNos: ["C001"],
      scCompanyNames: ["测试客户"],
      hrallyCompanyNames: ["测试客户"],
      groupNames: ["测试组"],
      partyNames: ["测试发包方"],
      social: { sc: "100.00", hrally: "100.00", difference: "0.00" },
      fund: { sc: "50.00", hrally: "50.00", difference: "0.00" },
      service: { sc: "10.00", hrally: "10.00", difference: "0.00" },
      total: { sc: "160.00", hrally: "160.00", difference: "0.00" },
      scRowCount: 1,
      hrallyRowCount: 1,
    },
  ],
  scRecords: [],
  hrallyRecords: [],
  issues: [],
  selectedSheets: [],
  missingCustomerMappings: [],
  summary: {
    total: 1,
    matched: 1,
    different: 0,
    scOnly: 0,
    hrallyOnly: 0,
    importIssues: 0,
  },
  detailsIncluded: true,
};

describe("Excel 导出", () => {
  it("生成完整工作簿并保持身份证号为文本", () => {
    const workbook = buildWorkbook(output);
    expect(workbook.SheetNames).toEqual([
      "对账结果",
      "速创原始明细",
      "聚合力原始明细",
      "导入错误",
      "统计摘要",
      "客户映射异常",
    ]);

    const rows = XLSX.utils.sheet_to_json<unknown[]>(workbook.Sheets["对账结果"], {
      header: 1,
      raw: true,
    });
    expect(rows[1][5]).toBe("310101199001010011");
    expect(rows[1][7]).toBe("测试客户");
    expect(rows[1][12]).toBe(0);
  });

  it("按旧版格式设置灰色表头、边框、列宽和金额格式", () => {
    const workbook = buildWorkbook(output);
    const sheet = workbook.Sheets["对账结果"];

    expect(sheet.A1.s).toMatchObject({
      font: { name: "等线", sz: 11, bold: true },
      fill: { patternType: "solid", fgColor: { rgb: "808080" } },
      border: {
        top: { style: "thin" },
        bottom: { style: "thin" },
        left: { style: "thin" },
        right: { style: "thin" },
      },
      alignment: { horizontal: "center", vertical: "center", wrapText: false },
    });
    expect(sheet.A2.s).toMatchObject({
      font: { name: "等线", sz: 11 },
      border: { top: { style: "thin" }, bottom: { style: "thin" } },
    });
    expect(sheet.M2.s).toMatchObject({ numFmt: "0.00", alignment: { horizontal: "right" } });
    expect(sheet.M2.z).toBe("0.00");
    expect(sheet["!cols"]?.[1].wch).toBeGreaterThanOrEqual(13);
    expect(sheet["!cols"]?.[15].wch).toBeGreaterThanOrEqual(26);
    expect(sheet["!rows"]?.[0].hpt).toBe(22);
    expect(sheet["!autofilter"]).toEqual({ ref: "A1:P2" });

    const data = StyledXLSX.write(workbook, { type: "array", bookType: "xlsx", compression: true });
    const reopened = XLSX.read(data, { type: "array", cellStyles: true });
    expect(reopened.Sheets["对账结果"].A1.s).toMatchObject({
      patternType: "solid",
      fgColor: { rgb: "808080" },
    });
  });

  it("大文件结果模式仍使用样式写入器并保留完整表头和正文格式", () => {
    const largeModeOutput = { ...output, detailsIncluded: false };
    const data = serializeReconciliation(largeModeOutput);
    const reopened = XLSX.read(data, { type: "array", cellStyles: true });
    const sheet = reopened.Sheets["对账结果"];
    const archive = unzipSync(new Uint8Array(data));
    const sheetXml = strFromU8(archive["xl/worksheets/sheet1.xml"]);
    const stylesXml = strFromU8(archive["xl/styles.xml"]);

    expect(reopened.SheetNames).toEqual(["对账结果", "导入错误", "统计摘要", "客户映射异常"]);
    expect(sheet.A1.s).toMatchObject({
      patternType: "solid",
      fgColor: { rgb: "808080" },
    });
    expect(sheetXml).toMatch(/<c r="A2" s="\d+"/);
    expect(sheetXml).toMatch(/<c r="M2" s="\d+"/);
    expect(stylesXml).toContain('<border><left style="thin">');
    expect(stylesXml).toContain('numFmtId="2"');
  });
});
