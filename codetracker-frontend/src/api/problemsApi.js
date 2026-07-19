import apiClient from "./apiClient";

export const problemsApi = {
  getProblems(params = {}) {
    return apiClient.get("/problems", { params }).then((response) => response.data);
  },

  getStats() {
    return apiClient.get("/problems/stats").then((response) => response.data);
  },

  createProblem(payload) {
    return apiClient.post("/problems", payload).then((response) => response.data);
  },

  updateProblem(id, payload) {
    return apiClient.put(`/problems/${id}`, payload).then((response) => response.data);
  },

  deleteProblem(id) {
    return apiClient.delete(`/problems/${id}`).then((response) => response.data);
  },
};