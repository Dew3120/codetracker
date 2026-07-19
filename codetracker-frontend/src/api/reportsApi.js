import apiClient from "./apiClient";

export const reportsApi = {
  getWeeklyReport() {
    return apiClient.get("/reports/weekly").then((response) => response.data);
  },

  getMonthlyReport(month) {
    return apiClient.get("/reports/monthly", { params: { month } }).then((response) => response.data);
  },

  getLanguageDistribution() {
    return apiClient.get("/reports/languages").then((response) => response.data);
  },

  getTopicBreakdown() {
    return apiClient.get("/reports/topics").then((response) => response.data);
  },
};