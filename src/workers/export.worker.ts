/// <reference lib="webworker" />

import type { ExportWorkerRequest, ExportWorkerResponse } from "../domain/types";
import { reconciliationFileName, serializeReconciliation } from "../lib/export";

const worker = self as DedicatedWorkerGlobalScope;

worker.onmessage = (event: MessageEvent<ExportWorkerRequest>) => {
  if (event.data.type !== "export") return;

  try {
    const { output } = event.data;
    const data = serializeReconciliation(output);
    const response: ExportWorkerResponse = {
      type: "complete",
      data,
      fileName: reconciliationFileName(output),
    };
    worker.postMessage(response, [data]);
  } catch (error) {
    const response: ExportWorkerResponse = {
      type: "error",
      message: error instanceof Error ? error.message : "Excel 生成失败，请重新尝试。",
    };
    worker.postMessage(response);
  }
};
