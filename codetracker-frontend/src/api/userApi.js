import apiClient from "./apiClient";

export const userApi = {
  updateProfile(payload) {
    return apiClient.put("/users/profile", payload).then((response) => response.data);
  },

  changePassword(payload) {
    return apiClient.put("/users/password", payload).then((response) => response.data);
  },
};