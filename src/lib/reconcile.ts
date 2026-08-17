import type {
  CustomerMapping,
  ImportIssue,
  MoneyBreakdown,
  NormalizedRecord,
  ReconciliationOutput,
  ReconciliationResult,
  ReconciliationStatus,
  TextValues,
} from "../domain/types";
import { makeKey, uniqueSorted } from "./normalize";

type CompactText = string | string[] | undefined;

export interface AggregateGroup {
  accYm: string;
  realAccYm: string;
  id: string;
  names?: CompactText;
  employeeNos?: CompactText;
  companyNos?: CompactText;
  companyNames?: CompactText;
  companyFullNames?: CompactText;
  groupNames?: CompactText;
  partyNames?: CompactText;
  rowCount: number;
  socialCents: number;
  fundCents: number;
  serviceCents: number;
  totalCents: number;
}

export type AggregateMap = Map<string, AggregateGroup>;

function addText(target: CompactText, value: string): CompactText {
  const normalized = value.trim();
  if (!normalized) return target;
  if (target === undefined) return normalized;
  if (typeof target === "string") return target === normalized ? target : [target, normalized];
  if (!target.includes(normalized)) target.push(normalized);
  return target;
}

function moneyToCents(value: string): number {
  const match = value.match(/^(-?)(\d+)\.(\d{2})$/);
  if (!match) throw new Error(`内部金额格式无效：${value}`);
  const cents = Number(match[2]) * 100 + Number(match[3]);
  return match[1] ? -cents : cents;
}

function centsToMoney(value: number): string {
  const sign = value < 0 ? "-" : "";
  const absolute = Math.abs(value);
  return `${sign}${Math.floor(absolute / 100)}.${String(absolute % 100).padStart(2, "0")}`;
}

export function createAggregateMap(): AggregateMap {
  return new Map<string, AggregateGroup>();
}

export function addRecordToAggregate(groups: AggregateMap, record: NormalizedRecord): void {
  const key = makeKey(record.accYm, record.realAccYm, record.id);
  const group = groups.get(key) ?? {
    accYm: record.accYm,
    realAccYm: record.realAccYm,
    id: record.id,
    rowCount: 0,
    socialCents: 0,
    fundCents: 0,
    serviceCents: 0,
    totalCents: 0,
  };
  group.names = addText(group.names, record.name);
  group.employeeNos = addText(group.employeeNos, record.employeeNo);
  group.companyNos = addText(group.companyNos, record.companyNo);
  group.companyNames = addText(group.companyNames, record.companyName);
  group.companyFullNames = addText(group.companyFullNames, record.companyFullName);
  group.groupNames = addText(group.groupNames, record.groupName);
  group.partyNames = addText(group.partyNames, record.partyName);
  group.rowCount += 1;
  group.socialCents += moneyToCents(record.socialAmount);
  group.fundCents += moneyToCents(record.fundAmount);
  group.serviceCents += moneyToCents(record.serviceAmount);
  group.totalCents += moneyToCents(record.totalAmount);
  groups.set(key, group);
}

export function aggregateRecords(records: NormalizedRecord[]): AggregateMap {
  const groups = createAggregateMap();
  for (const record of records) addRecordToAggregate(groups, record);
  return groups;
}

function moneyBreakdown(sc: number, hrally: number): MoneyBreakdown {
  return {
    sc: centsToMoney(sc),
    hrally: centsToMoney(hrally),
    difference: centsToMoney(sc - hrally),
  };
}

function statusFor(
  sc: AggregateGroup | undefined,
  hrally: AggregateGroup | undefined,
  differences: number[],
): ReconciliationStatus {
  if (!sc) return "hrally-only";
  if (!hrally) return "sc-only";
  return differences.every((value) => value === 0) ? "matched" : "different";
}

interface AggregateReconcileOptions {
  scRecords?: NormalizedRecord[];
  hrallyRecords?: NormalizedRecord[];
  detailsIncluded?: boolean;
}

function setValues(values: CompactText): string[] {
  if (values === undefined) return [];
  return uniqueSorted(typeof values === "string" ? [values] : values);
}

function compactResultValues(values: Iterable<string>): TextValues {
  const result = uniqueSorted(values);
  if (result.length === 0) return "";
  return result.length === 1 ? result[0] : result;
}

export function reconcileAggregateMaps(
  scGroups: AggregateMap,
  hrallyGroups: AggregateMap,
  issues: ImportIssue[],
  mappings?: CustomerMapping[],
  selectedSheets: ReconciliationOutput["selectedSheets"] = [],
  options: AggregateReconcileOptions = {},
): ReconciliationOutput {
  const allKeys = uniqueSorted([...scGroups.keys(), ...hrallyGroups.keys()]);
  const mappingByCompany = new Map<string, CustomerMapping[]>();
  for (const mapping of mappings ?? []) {
    const existing = mappingByCompany.get(mapping.companyNo) ?? [];
    existing.push(mapping);
    mappingByCompany.set(mapping.companyNo, existing);
  }
  const missingMappings = new Set<string>();
  const results: ReconciliationResult[] = [];

  for (const key of allKeys) {
    const sc = scGroups.get(key);
    const hrally = hrallyGroups.get(key);
    const first = sc ?? hrally;
    if (!first) continue;
    const scSocial = sc?.socialCents ?? 0;
    const hrallySocial = hrally?.socialCents ?? 0;
    const scFund = sc?.fundCents ?? 0;
    const hrallyFund = hrally?.fundCents ?? 0;
    const scService = sc?.serviceCents ?? 0;
    const hrallyService = hrally?.serviceCents ?? 0;
    const scTotal = sc?.totalCents ?? 0;
    const hrallyTotal = hrally?.totalCents ?? 0;
    const companyNos = setValues(sc?.companyNos);
    const mappedRows = companyNos.flatMap((companyNo) => {
      const found = mappingByCompany.get(companyNo) ?? [];
      if (mappings && found.length === 0) missingMappings.add(companyNo);
      return found;
    });
    const groupNames = uniqueSorted([
      ...setValues(sc?.groupNames),
      ...mappedRows.map((mapping) => mapping.groupName),
    ]);
    const partyNames = uniqueSorted([
      ...setValues(sc?.partyNames),
      ...mappedRows.map((mapping) => mapping.partyName),
    ]);
    const differences = [
      scSocial - hrallySocial,
      scFund - hrallyFund,
      scService - hrallyService,
      scTotal - hrallyTotal,
    ];

    results.push({
      key,
      accYm: first.accYm,
      realAccYm: first.realAccYm,
      id: first.id,
      status: statusFor(sc, hrally, differences),
      scNames: compactResultValues(setValues(sc?.names)),
      hrallyNames: compactResultValues(setValues(hrally?.names)),
      scEmployeeNos: compactResultValues(setValues(sc?.employeeNos)),
      hrallyEmployeeNos: compactResultValues(setValues(hrally?.employeeNos)),
      scCompanyNos: compactResultValues(companyNos),
      scCompanyNames: compactResultValues(setValues(sc?.companyNames)),
      hrallyCompanyNames: compactResultValues([
        ...setValues(hrally?.companyNames),
        ...setValues(hrally?.companyFullNames),
      ]),
      groupNames: compactResultValues(groupNames),
      partyNames: compactResultValues(partyNames),
      social: moneyBreakdown(scSocial, hrallySocial),
      fund: moneyBreakdown(scFund, hrallyFund),
      service: moneyBreakdown(scService, hrallyService),
      total: moneyBreakdown(scTotal, hrallyTotal),
      scRowCount: sc?.rowCount ?? 0,
      hrallyRowCount: hrally?.rowCount ?? 0,
    });
  }

  results.sort(
    (a, b) =>
      a.accYm.localeCompare(b.accYm) ||
      a.id.localeCompare(b.id) ||
      a.realAccYm.localeCompare(b.realAccYm),
  );

  const summary = {
    total: results.length,
    matched: results.filter((result) => result.status === "matched").length,
    different: results.filter((result) => result.status === "different").length,
    scOnly: results.filter((result) => result.status === "sc-only").length,
    hrallyOnly: results.filter((result) => result.status === "hrally-only").length,
    importIssues: issues.length,
  };

  return {
    results,
    scRecords: options.scRecords ?? [],
    hrallyRecords: options.hrallyRecords ?? [],
    issues,
    selectedSheets,
    missingCustomerMappings: uniqueSorted(missingMappings),
    summary,
    detailsIncluded: options.detailsIncluded ?? false,
  };
}

export function reconcile(
  scRecords: NormalizedRecord[],
  hrallyRecords: NormalizedRecord[],
  issues: ImportIssue[],
  mappings?: CustomerMapping[],
  selectedSheets: ReconciliationOutput["selectedSheets"] = [],
): ReconciliationOutput {
  return reconcileAggregateMaps(
    aggregateRecords(scRecords),
    aggregateRecords(hrallyRecords),
    issues,
    mappings,
    selectedSheets,
    { scRecords, hrallyRecords, detailsIncluded: true },
  );
}
