import { BrowserRouter, Navigate, Route, Routes } from "react-router-dom";
import { Toaster } from "react-hot-toast";
import { AuthProvider } from "./context/AuthContext";
import ProtectedRoute, { PublicRoute } from "./components/ProtectedRoute";
import AchievementsPage from "./pages/AchievementsPage";
import DashboardPage from "./pages/DashboardPage";
import GoalsPage from "./pages/GoalsPage";
import LoginPage from "./pages/LoginPage";
import ProblemsPage from "./pages/ProblemsPage";
import ProfilePage from "./pages/ProfilePage";
import RegisterPage from "./pages/RegisterPage";
import ReportsPage from "./pages/ReportsPage";
import SessionsPage from "./pages/SessionsPage";

function protect(page) {
  return <ProtectedRoute>{page}</ProtectedRoute>;
}

function App() {
  return (
    <BrowserRouter>
      <AuthProvider>
        <Toaster position="top-right" />
        <Routes>
          <Route path="/" element={<Navigate to="/dashboard" replace />} />
          <Route path="/login" element={<PublicRoute><LoginPage /></PublicRoute>} />
          <Route path="/register" element={<PublicRoute><RegisterPage /></PublicRoute>} />
          <Route path="/dashboard" element={protect(<DashboardPage />)} />
          <Route path="/sessions" element={protect(<SessionsPage />)} />
          <Route path="/goals" element={protect(<GoalsPage />)} />
          <Route path="/problems" element={protect(<ProblemsPage />)} />
          <Route path="/reports" element={protect(<ReportsPage />)} />
          <Route path="/achievements" element={protect(<AchievementsPage />)} />
          <Route path="/profile" element={protect(<ProfilePage />)} />
          <Route path="*" element={<Navigate to="/dashboard" replace />} />
        </Routes>
      </AuthProvider>
    </BrowserRouter>
  );
}

export default App;