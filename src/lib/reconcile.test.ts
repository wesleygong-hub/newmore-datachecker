import { describe, expect, it } from "vitest";
import type { NormalizedRecord } from "../domain/types";
import { reconcile } from "./reconcile";

function record(
  side: "sc" | "hrally",
  values: Partial<NormalizedRecord> = {},
): NormalizedRecord {
  return {
    side,
    fileName: `${side}.xlsx`,
    sheetName: "Sheet1",
    rowNumber: 2,
    accYm: "202512",
    realAccYm: "202512",
    id: "310228198204082228",
    name: "汤文礼",
    employeeNo: "",
    companyNo: "",
    companyName: "",
    companyFullName: "",
    groupName: "",
    partyName: "",
    socialAmount: "0.00",
    fundAmount: "0.00",
    serviceAmount: "0.00",
    totalAmount: "0.00",
    ...values,
  };
}

describe("reconcile", () => {
  it("先按三键汇总，再进行一次匹配", () => {
    const sc = [
      record("sc", { companyNo: "CH40114", totalAmount: "0.00" }),
      record("sc", {
        companyNo: "CH37242",
        socialAmount: "2810.18",
        fundAmount: "690.00",
        serviceAmount: "60.00",
        totalAmount: "3560.18",
      }),
    ];
    const hrally = [
      record("hrally", {
        socialAmount: "2810.18",
        fundAmount: "690.00",
        serviceAmount: "60.00",
        totalAmount: "3560.18",
      }),
    ];

    const output = reconcile(sc, hrally, []);
    expect(output.results).toHaveLength(1);
    expect(output.results[0].status).toBe("matched");
    expect(output.results[0].scCompanyNos).toEqual(["CH37242", "CH40114"]);
    expect(output.results[0].scRowCount).toBe(2);
    expect(output.results[0].total.difference).toBe("0.00");
  });

  it("差异精确到分，不设置容差", () => {
    const output = reconcile(
      [record("sc", { totalAmount: "100.00" })],
      [record("hrally", { totalAmount: "99.99" })],
      [],
    );
    expect(output.results[0].status).toBe("different");
    expect(output.results[0].total.difference).toBe("0.01");
  });

  it("未分类费用只影响总金额差额", () => {
    const output = reconcile(
      [record("sc", { socialAmount: "100.00", totalAmount: "100.00" })],
      [record("hrally", { socialAmount: "100.00", totalAmount: "110.00" })],
      [],
    );
    expect(output.results[0].social.difference).toBe("0.00");
    expect(output.results[0].total.difference).toBe("-10.00");
    expect(output.results[0].status).toBe("different");
  });

  it("保留单边记录", () => {
    const output = reconcile(
      [record("sc", { id: "SC-ONLY" })],
      [record("hrally", { id: "HR-ONLY" })],
      [],
    );
    expect(output.summary.scOnly).toBe(1);
    expect(output.summary.hrallyOnly).toBe(1);
    expect(output.summary.total).toBe(2);
  });
});
