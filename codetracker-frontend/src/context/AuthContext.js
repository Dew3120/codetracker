import { createContext, useCallback, useContext, useEffect, useMemo, useState } from "react";
import { authApi } from "../api/authApi";
import { TOKEN_STORAGE_KEY, USER_STORAGE_KEY } from "../api/apiClient";

const AuthContext = createContext(null);

function readStoredUser() {
  try {
    const value = localStorage.getItem(USER_STORAGE_KEY);
    return value ? JSON.parse(value) : null;
  } catch {
    return null;
  }
}

export function AuthProvider({ children }) {
  const [token, setToken] = useState(() => localStorage.getItem(TOKEN_STORAGE_KEY));
  const [user, setUser] = useState(readStoredUser);
  const [loading, setLoading] = useState(Boolean(localStorage.getItem(TOKEN_STORAGE_KEY)));

  const clearAuth = useCallback(() => {
    localStorage.removeItem(TOKEN_STORAGE_KEY);
    localStorage.removeItem(USER_STORAGE_KEY);
    setToken(null);
    setUser(null);
  }, []);

  const storeAuth = useCallback((authResponse) => {
    localStorage.setItem(TOKEN_STORAGE_KEY, authResponse.token);
    localStorage.setItem(USER_STORAGE_KEY, JSON.stringify(authResponse.user));
    setToken(authResponse.token);
    setUser(authResponse.user);
  }, []);

  const refreshUser = useCallback(async () => {
    const userResponse = await authApi.me();
    localStorage.setItem(USER_STORAGE_KEY, JSON.stringify(userResponse));
    setUser(userResponse);
    return userResponse;
  }, []);

  useEffect(() => {
    let active = true;

    if (!token) {
      setLoading(false);
      return () => {
        active = false;
      };
    }

    setLoading(true);
    refreshUser()
      .catch(() => {
        if (active) {
          clearAuth();
        }
      })
      .finally(() => {
        if (active) {
          setLoading(false);
        }
      });

    return () => {
      active = false;
    };
  }, [token, refreshUser, clearAuth]);

  const login = useCallback(
    async (credentials) => {
      const authResponse = await authApi.login(credentials);
      storeAuth(authResponse);
      return authResponse;
    },
    [storeAuth]
  );

  const register = useCallback(
    async (payload) => {
      const authResponse = await authApi.register(payload);
      storeAuth(authResponse);
      return authResponse;
    },
    [storeAuth]
  );

  const updateCachedUser = useCallback((nextUser) => {
    localStorage.setItem(USER_STORAGE_KEY, JSON.stringify(nextUser));
    setUser(nextUser);
  }, []);

  const value = useMemo(
    () => ({
      token,
      user,
      loading,
      isAuthenticated: Boolean(token && user),
      login,
      register,
      logout: clearAuth,
      refreshUser,
      updateCachedUser,
    }),
    [token, user, loading, login, register, clearAuth, refreshUser, updateCachedUser]
  );

  return <AuthContext.Provider value={value}>{children}</AuthContext.Provider>;
}

export function useAuth() {
  const context = useContext(AuthContext);

  if (!context) {
    throw new Error("useAuth must be used inside AuthProvider");
  }

  return context;
}