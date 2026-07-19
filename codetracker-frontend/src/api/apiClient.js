import axios from "axios";

export const TOKEN_STORAGE_KEY = "codetracker_token";
export const USER_STORAGE_KEY = "codetracker_user";

const apiClient = axios.create({
  baseURL: process.env.REACT_APP_API_BASE_URL || "http://localhost:8080/api",
  headers: {
    "Content-Type": "application/json",
  },
});

apiClient.interceptors.request.use((config) => {
  const token = localStorage.getItem(TOKEN_STORAGE_KEY);

  if (token) {
    config.headers.Authorization = `Bearer ${token}`;
  }

  return config;
});

export function getApiError(error) {
  const data = error?.response?.data;

  if (typeof data === "string") {
    return data;
  }

  return data?.message || error?.message || "Something went wrong. Please try again.";
}

export default apiClient;