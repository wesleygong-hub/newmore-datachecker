/// <reference lib="webworker" />

import type { WorkerResponse, WorkerRunRequest } from "../domain/types";
import { parseCustomerWorkbook, parseHrallyWorkbook, parseScWorkbook } from "../lib/excel";
import {
  addRecordToAggregate,
  createAggregateMap,
  reconcile,
  reconcileAggregateMaps,
} from "../lib/reconcile";
import { LARGE_FILE_LIMITS, parseStreamingXlsx } from "../lib/streaming-xlsx";

const worker = self as DedicatedWorkerGlobalScope;

function progress(stage: string, percent: number): void {
  const response: WorkerResponse = { type: "progress", stage, percent };
  worker.postMessage(response);
}

const LARGE_SINGLE_THRESHOLD = 15 * 1024 * 1024;
const LARGE_TOTAL_THRESHOLD = 30 * 1024 * 1024;

async function transferFile(file: File) {
  return { name: file.name, data: await file.arrayBuffer() };
}

function useLargeMode(request: WorkerRunRequest): boolean {
  const files = [request.scFile, ...request.hrallyFiles];
  const totalSize = files.reduce((total, file) => total + file.size, 0);
  return files.some((file) => file.size >= LARGE_SINGLE_THRESHOLD) || totalSize >= LARGE_TOTAL_THRESHOLD;
}

worker.onmessage = async (event: MessageEvent<WorkerRunRequest>) => {
  if (event.data.type !== "run") return;

  try {
    const request = event.data;
    if (useLargeMode(request)) {
      const sourceFiles = [request.scFile, ...request.hrallyFiles];
      const totalBytes = sourceFiles.reduce((total, file) => total + file.size, 0);
      if (totalBytes > LARGE_FILE_LIMITS.totalFileBytes) {
        throw new Error("所选账单合计超过 300 MB 的安全上限，请按月份拆分后核对。");
      }
      if (sourceFiles.some((file) => !file.name.toLocaleLowerCase().endsWith(".xlsx"))) {
        throw new Error("年度大文件模式只支持 .xlsx，请先将 .xls 文件另存为 .xlsx。");
      }

      const scGroups = createAggregateMap();
      const hrallyGroups = createAggregateMap();
      const issues = [];
      const selectedSheets = [];
      let totalRows = 0;

      const sc = await parseStreamingXlsx(
        request.scFile,
        "sc",
        (record) => {
          addRecordToAggregate(scGroups, record);
          if (scGroups.size > LARGE_FILE_LIMITS.uniqueKeys) {
            throw new Error("三键汇总结果超过 50 万条的安全上限，请缩小核对范围。");
          }
        },
        (ratio) => progress("大文件模式：正在读取速创账单", 5 + Math.round(ratio * 32)),
      );
      issues.push(...sc.issues);
      selectedSheets.push(sc.selectedSheet);
      totalRows += sc.selectedSheet.recordCount;

      for (let index = 0; index < request.hrallyFiles.length; index += 1) {
        const start = 40 + Math.round((index / request.hrallyFiles.length) * 35);
        const span = Math.max(1, Math.round(35 / request.hrallyFiles.length));
        const parsed = await parseStreamingXlsx(
          request.hrallyFiles[index],
          "hrally",
          (record) => {
            addRecordToAggregate(hrallyGroups, record);
            if (hrallyGroups.size > LARGE_FILE_LIMITS.uniqueKeys) {
              throw new Error("三键汇总结果超过 50 万条的安全上限，请缩小核对范围。");
            }
          },
          (ratio) => progress(
            `大文件模式：正在读取聚合力账单 ${index + 1}/${request.hrallyFiles.length}`,
            start + Math.round(ratio * span),
          ),
        );
        issues.push(...parsed.issues);
        selectedSheets.push(parsed.selectedSheet);
        totalRows += parsed.selectedSheet.recordCount;
        if (totalRows > LARGE_FILE_LIMITS.totalRows) {
          throw new Error("有效明细超过 100 万行的安全上限，请按月份拆分后核对。");
        }
      }

      let mappings;
      if (request.customerFile) {
        progress("正在读取客户清单", 78);
        const customer = parseCustomerWorkbook(await transferFile(request.customerFile));
        mappings = customer.mappings;
        issues.push(...customer.issues);
        selectedSheets.push(...customer.selectedSheets);
      }

      progress("正在生成三键核对结果", 86);
      const output = reconcileAggregateMaps(
        scGroups,
        hrallyGroups,
        issues,
        mappings,
        selectedSheets,
        { detailsIncluded: false },
      );
      progress("核对完成", 100);
      const response: WorkerResponse = { type: "complete", output };
      worker.postMessage(response);
      return;
    }

    progress("正在读取速创账单", 12);
    const sc = parseScWorkbook(await transferFile(request.scFile));

    const hrallyRecords = [];
    const issues = [...sc.issues];
    const selectedSheets = [...sc.selectedSheets];
    for (let index = 0; index < request.hrallyFiles.length; index += 1) {
      progress(
        `正在读取聚合力账单 ${index + 1}/${request.hrallyFiles.length}`,
        25 + Math.round((index / Math.max(request.hrallyFiles.length, 1)) * 35),
      );
      const parsed = parseHrallyWorkbook(await transferFile(request.hrallyFiles[index]));
      hrallyRecords.push(...parsed.records);
      issues.push(...parsed.issues);
      selectedSheets.push(...parsed.selectedSheets);
    }

    let mappings;
    if (request.customerFile) {
      progress("正在读取客户清单", 65);
      const customer = parseCustomerWorkbook(await transferFile(request.customerFile));
      mappings = customer.mappings;
      issues.push(...customer.issues);
      selectedSheets.push(...customer.selectedSheets);
    }

    progress("正在按三键汇总并核对", 78);
    const output = reconcile(sc.records, hrallyRecords, issues, mappings, selectedSheets);
    progress("核对完成", 100);
    const response: WorkerResponse = { type: "complete", output };
    worker.postMessage(response);
  } catch (error) {
    const response: WorkerResponse = {
      type: "error",
      message: error instanceof Error ? error.message : "核对失败，请检查文件格式。",
    };
    worker.postMessage(response);
  }
};
