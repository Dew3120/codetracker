import apiClient from "./apiClient";

export const goalsApi = {
  getTodayGoal() {
    return apiClient.get("/goals/today").then((response) => response.data || null);
  },

  setGoal(payload) {
    return apiClient.post("/goals", payload).then((response) => response.data);
  },

  getStreak() {
    return apiClient.get("/goals/streak").then((response) => response.data);
  },

  getGoalHistory() {
    return apiClient.get("/goals/history").then((response) => response.data);
  },
};