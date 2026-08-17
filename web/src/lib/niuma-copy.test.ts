import { describe, expect, it } from "vitest";
import { completionBanter, NIUMA_QUOTES, randomQuoteIndex } from "./niuma-copy";

describe("牛马文案", () => {
  it("完整保留旧程序的 50 条语录", () => {
    expect(NIUMA_QUOTES).toHaveLength(50);
  });

  it("随机轮播不会立即重复当前语录", () => {
    for (let current = 0; current < NIUMA_QUOTES.length; current += 1) {
      expect(randomQuoteIndex(current, () => 0)).not.toBe(current);
      expect(randomQuoteIndex(current, () => 0.999999)).not.toBe(current);
    }
  });

  it("首次随机结果始终落在语录范围内", () => {
    expect(randomQuoteIndex(-1, () => 0)).toBe(0);
    expect(randomQuoteIndex(-1, () => 0.999999)).toBe(NIUMA_QUOTES.length - 1);
  });

  it("全一致时给出一致结果收尾", () => {
    expect(completionBanter({ total: 10, matched: 10, different: 0, scOnly: 0, hrallyOnly: 0, importIssues: 0 }))
      .toContain("严丝合缝");
  });

  it("导入错误优先提醒查看错误", () => {
    expect(completionBanter({ total: 10, matched: 8, different: 2, scOnly: 0, hrallyOnly: 0, importIssues: 3 }))
      .toContain("3 行数据");
  });
});
