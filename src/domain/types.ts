export type DataSide = "sc" | "hrally";

export type ReconciliationStatus =
  | "matched"
  | "different"
  | "sc-only"
  | "hrally-only";

export interface SourceRef {
  fileName: string;
  sheetName: string;
  rowNumber: number;
}

export interface NormalizedRecord extends SourceRef {
  side: DataSide;
  accYm: string;
  realAccYm: string;
  id: string;
  name: string;
  employeeNo: string;
  companyNo: string;
  companyName: string;
  companyFullName: string;
  groupName: string;
  partyName: string;
  socialAmount: string;
  fundAmount: string;
  serviceAmount: string;
  totalAmount: string;
}

export interface CustomerMapping {
  companyNo: string;
  groupName: string;
  partyName: string;
  source: SourceRef;
}

export interface ImportIssue extends SourceRef {
  side: DataSide | "customer";
  field: string;
  message: string;
  rawValue?: string;
}

export interface ParsedData {
  records: NormalizedRecord[];
  issues: ImportIssue[];
  selectedSheets: Array<{
    side: DataSide | "customer";
    fileName: string;
    sheetName: string;
    recordCount: number;
  }>;
}

export interface MoneyBreakdown {
  sc: string;
  hrally: string;
  difference: string;
}

export type TextValues = string | string[];

export interface ReconciliationResult {
  key: string;
  accYm: string;
  realAccYm: string;
  id: string;
  status: ReconciliationStatus;
  scNames: TextValues;
  hrallyNames: TextValues;
  scEmployeeNos: TextValues;
  hrallyEmployeeNos: TextValues;
  scCompanyNos: TextValues;
  scCompanyNames: TextValues;
  hrallyCompanyNames: TextValues;
  groupNames: TextValues;
  partyNames: TextValues;
  social: MoneyBreakdown;
  fund: MoneyBreakdown;
  service: MoneyBreakdown;
  total: MoneyBreakdown;
  scRowCount: number;
  hrallyRowCount: number;
}

export interface ReconciliationSummary {
  total: number;
  matched: number;
  different: number;
  scOnly: number;
  hrallyOnly: number;
  importIssues: number;
}

export interface ReconciliationOutput {
  results: ReconciliationResult[];
  scRecords: NormalizedRecord[];
  hrallyRecords: NormalizedRecord[];
  issues: ImportIssue[];
  selectedSheets: ParsedData["selectedSheets"];
  missingCustomerMappings: string[];
  summary: ReconciliationSummary;
  detailsIncluded: boolean;
}

export interface TransferFile {
  name: string;
  data: ArrayBuffer;
}

export interface WorkerRunRequest {
  type: "run";
  scFile: File;
  hrallyFiles: File[];
  customerFile?: File;
}

export type WorkerResponse =
  | { type: "progress"; stage: string; percent: number }
  | { type: "complete"; output: ReconciliationOutput }
  | { type: "error"; message: string };

export interface ExportWorkerRequest {
  type: "export";
  output: ReconciliationOutput;
}

export type ExportWorkerResponse =
  | { type: "complete"; data: ArrayBuffer; fileName: string }
  | { type: "error"; message: string };
