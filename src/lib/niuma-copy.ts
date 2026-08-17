import type { ReconciliationSummary } from "../domain/types";

export const NIUMA_QUOTES = [
  "你醒了，该上班了",
  "别看了，是工作日",
  "恭喜存活，又获得一天班",
  "系统检测到：你还没下班",
  "你今天也没有暴富，继续上班",
  "早啊，该为生活卖命了",
  "工位已就绪，请就位",
  "没事，我扛得住，我是牛马",
  "我不累，我只是活得很具体",
  "我不伟大，我只是一直在上班",
  "我是牛马，不是人，请直接下需求",
  "牛马无需理解，只需执行",
  "别问我意见，我只是个工位附件",
  "作为牛马，我的感受不在需求范围内",
  "牛马没有情绪，只有排期",
  "会议一开，马喽智商归零",
  "这个项目没问题，有问题的是我",
  "别问马喽怎么看，马喽只想下班",
  "牛马的极限，就是领导的起点",
  "牛马今天也在被“充分利用”",
  "马喽今天也在模仿人类上班",
  "马喽听不懂，但马喽点头",
  "马喽已读不回，因为已读不懂",
  "马喽一思考，会议就变长",
  "马喽不是摆烂，是失去希望",
  "马喽的沉默，是最后的体面",
  "马喽的工作状态：已麻",
  "马喽不配累，但马喽很累",
  "马喽的心死得很安详",
  "马喽只是笑了一下，灵魂已经裂开",
  "马喽只是坐在这里，事情就自己来了",
  "马喽还在这，说明昨天也挺过去了",
  "马喽的核心竞争力：还能来上班",
  "牛马最大的错觉：干完这波就轻松了",
  "努力不一定有回报，但一定有活",
  "我为公司付出了青春，公司让我成熟",
  "牛马今天也在为别人的目标燃烧自己",
  "尼采看了都要沉默三秒然后打卡",
  "世界是荒诞的，而我在其中做 Excel",
  "马喽不是摸鱼，是在和现实断联",
  "欢迎登录，本日精神损耗 +20%",
  "系统提示：你又要上一天班了",
  "牛马上线，尊严下线",
  "今日份人类体验即将结束",
  "你不是不行，是环境太行",
  "又是为公司奉献青春的一天",
  "上班不是选择，是轮回",
  "工位一坐，人生暂停",
  "你不干，有的是马喽干（包括你）",
  "别急，下班还在很远的未来",
] as const;

export function randomQuoteIndex(current = -1, random = Math.random): number {
  if (NIUMA_QUOTES.length <= 1) return 0;
  if (current < 0 || current >= NIUMA_QUOTES.length) {
    return Math.min(NIUMA_QUOTES.length - 1, Math.floor(random() * NIUMA_QUOTES.length));
  }
  const candidate = Math.floor(random() * (NIUMA_QUOTES.length - 1));
  return candidate >= current ? candidate + 1 : candidate;
}

export function completionBanter(summary: ReconciliationSummary): string {
  if (summary.importIssues > 0) {
    return `账核完了，但有 ${summary.importIssues.toLocaleString("zh-CN")} 行数据带着脾气进场。牛马先不背锅，请到“导入错误”里看看。`;
  }
  if (summary.different === 0 && summary.scOnly === 0 && summary.hrallyOnly === 0) {
    return "两边账单严丝合缝。今天这头牛马，可以把腰直起来三分钟。";
  }

  const problemCount = summary.different + summary.scOnly + summary.hrallyOnly;
  return `发现 ${problemCount.toLocaleString("zh-CN")} 条需要关注的数据。账还没全对上，但锅已经精准定位，牛马暂时洗清嫌疑。`;
}
