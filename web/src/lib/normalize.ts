import Decimal from "decimal.js";

Decimal.set({
  precision: 40,
  rounding: Decimal.ROUND_HALF_UP,
});

export function normalizeHeader(value: unknown): string {
  return normalizeText(value)
    .toUpperCase()
    .replace(/[\s\u3000]+/g, "")
    .replace(/[()（）=：:·._\-/\\]/g, "");
}

export function normalizeText(value: unknown): string {
  if (value === null || value === undefined) return "";
  if (value instanceof Date && !Number.isNaN(value.getTime())) {
    const year = value.getFullYear();
    const month = String(value.getMonth() + 1).padStart(2, "0");
    const day = String(value.getDate()).padStart(2, "0");
    return `${year}-${month}-${day}`;
  }
  if (typeof value === "number" && Number.isFinite(value)) {
    return Number.isInteger(value) ? value.toFixed(0) : String(value);
  }
  return String(value)
    .replace(/\u3000/g, " ")
    .replace(/[\u200B-\u200D\uFEFF]/g, "")
    .trim()
    .replace(/\s+/g, " ");
}

export function normalizeId(value: unknown): string {
  return normalizeText(value).replace(/\s+/g, "").toUpperCase();
}

export function normalizeCompanyNo(value: unknown): string {
  return normalizeText(value).replace(/\s+/g, "").toUpperCase();
}

export function normalizeYearMonth(value: unknown): string | null {
  if (value instanceof Date && !Number.isNaN(value.getTime())) {
    return `${value.getFullYear()}${String(value.getMonth() + 1).padStart(2, "0")}`;
  }
  const text = normalizeText(value).replace(/[^0-9]/g, "");
  if (!/^\d{6}$/.test(text)) return null;
  const month = Number(text.slice(4, 6));
  return month >= 1 && month <= 12 ? text : null;
}

export function inferYearMonthFromFileName(fileName: string): string | null {
  const candidates = fileName.match(/20\d{4,6}/g) ?? [];
  for (const candidate of candidates.reverse()) {
    const result = normalizeYearMonth(candidate.slice(0, 6));
    if (result) return result;
  }
  return null;
}

export function parseMoney(value: unknown): Decimal | null {
  if (value === null || value === undefined || normalizeText(value) === "") {
    return new Decimal(0);
  }
  if (typeof value === "number") {
    return Number.isFinite(value) ? new Decimal(value.toString()) : null;
  }

  let text = normalizeText(value).replace(/[,，￥¥$]/g, "");
  if (/^\(.*\)$/.test(text)) text = `-${text.slice(1, -1)}`;
  if (!/^[+-]?(?:\d+(?:\.\d*)?|\.\d+)$/.test(text)) return null;

  try {
    return new Decimal(text);
  } catch {
    return null;
  }
}

export function moneyToString(value: Decimal): string {
  return value.toDecimalPlaces(2, Decimal.ROUND_HALF_UP).toFixed(2);
}

export function uniqueSorted(values: Iterable<string>): string[] {
  return [...new Set([...values].map((value) => value.trim()).filter(Boolean))].sort(
    (a, b) => a.localeCompare(b, "zh-CN"),
  );
}

export function makeKey(accYm: string, realAccYm: string, id: string): string {
  return `${accYm}\u001F${realAccYm}\u001F${id}`;
}
