import apiClient from "./apiClient";

export const achievementsApi = {
  getAchievements() {
    return apiClient.get("/achievements").then((response) => response.data);
  },
};