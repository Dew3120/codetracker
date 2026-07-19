import apiClient from "./apiClient";

export const sessionsApi = {
  getSessions(params = {}) {
    return apiClient.get("/sessions", { params }).then((response) => response.data);
  },

  getTodaySessions() {
    return apiClient.get("/sessions/today").then((response) => response.data);
  },

  createSession(payload) {
    return apiClient.post("/sessions", payload).then((response) => response.data);
  },

  updateSession(id, payload) {
    return apiClient.put(`/sessions/${id}`, payload).then((response) => response.data);
  },

  deleteSession(id) {
    return apiClient.delete(`/sessions/${id}`).then((response) => response.data);
  },
};