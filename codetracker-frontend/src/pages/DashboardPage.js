import { useEffect, useMemo, useState } from "react";
import { useNavigate } from "react-router-dom";
import { FiAward, FiClock, FiCode, FiPlus, FiTarget, FiTrendingUp } from "react-icons/fi";
import { achievementsApi } from "../api/achievementsApi";
import { getApiError } from "../api/apiClient";
import { goalsApi } from "../api/goalsApi";
import { problemsApi } from "../api/problemsApi";
import { reportsApi } from "../api/reportsApi";
import { sessionsApi } from "../api/sessionsApi";
import DashboardLayout from "../components/DashboardLayout";
import { minutesToDurationLabel, minutesToHoursLabel } from "../utils/formatters";

const emptyWeek = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"].map((day) => ({ day, hours: 0 }));

export default function DashboardPage() {
  const navigate = useNavigate();
  const [state, setState] = useState({
    loading: true,
    error: "",
    weekly: null,
    todayGoal: null,
    streak: null,
    sessions: [],
    problemStats: null,
    achievements: [],
  });

  useEffect(() => {
    let active = true;

    async function loadDashboard() {
      try {
        const [weekly, todayGoal, streak, sessionPage, problemStats, achievements] = await Promise.all([
          reportsApi.getWeeklyReport(),
          goalsApi.getTodayGoal(),
          goalsApi.getStreak(),
          sessionsApi.getSessions({ page: 0, size: 5, sort: "sessionDate,desc" }),
          problemsApi.getStats(),
          achievementsApi.getAchievements(),
        ]);

        if (!active) return;

        setState({
          loading: false,
          error: "",
          weekly,
          todayGoal,
          streak,
          sessions: sessionPage?.content || [],
          problemStats,
          achievements: achievements?.achievements || [],
        });
      } catch (error) {
        if (!active) return;

        setState((current) => ({
          ...current,
          loading: false,
          error: getApiError(error),
        }));
      }
    }

    loadDashboard();

    return () => {
      active = false;
    };
  }, []);

  const weeklyHours = useMemo(() => {
    if (!state.weekly?.dailyBreakdown?.length) {
      return emptyWeek;
    }

    return state.weekly.dailyBreakdown.map((item) => ({
      day: item.day?.slice(0, 3) || "",
      hours: Math.round((item.minutes / 60) * 10) / 10,
    }));
  }, [state.weekly]);

  const maxHours = Math.max(1, ...weeklyHours.map((item) => item.hours));
  const todayMinutes = state.todayGoal?.achievedMinutes || 0;
  const goalTarget = state.todayGoal?.targetMinutes || 120;
  const progress = Math.min(100, Math.round(state.todayGoal?.progressPercentage || 0));
  const earnedAchievements = state.achievements.filter((achievement) => achievement.earned);
  const latestAchievements = earnedAchievements.slice(0, 2);
  const weeklyTotalLabel = minutesToHoursLabel(state.weekly?.totalMinutes || 0);

  return (
    <DashboardLayout
      title="Dashboard"
      subtitle="A clean snapshot of today's coding progress and recent activity."
      action={<button className="primary-button" type="button" onClick={() => navigate("/sessions")}><FiPlus /> Log Session</button>}
    >
      {state.error && <div className="form-alert">{state.error}</div>}

      <section className="grid-4">
        <StatCard icon={<FiClock />} label="Today" value={minutesToDurationLabel(todayMinutes)} trend={`${minutesToDurationLabel(goalTarget)} target`} />
        <StatCard icon={<FiTrendingUp />} label="Current Streak" value={`${state.streak?.currentStreak || 0} days`} trend={`Best: ${state.streak?.longestStreak || 0} days`} />
        <StatCard icon={<FiCode />} label="Problems Solved" value={state.problemStats?.totalSolved || 0} trend={`${state.problemStats?.totalAttempted || 0} attempted`} />
        <StatCard icon={<FiTarget />} label="Goal Progress" value={`${progress}%`} trend={`${minutesToDurationLabel(Math.max(goalTarget - todayMinutes, 0))} remaining`} />
      </section>

      <section className="grid-2" style={{ marginTop: 16 }}>
        <div className="content-card">
          <div className="section-title">
            <h3>Weekly Hours</h3>
            <span className="badge badge-success">{weeklyTotalLabel} total</span>
          </div>
          <div className="bar-chart">
            {weeklyHours.map((item) => (
              <div key={item.day}>
                <span style={{ height: `${Math.max((item.hours / maxHours) * 100, item.hours > 0 ? 12 : 0)}%` }} />
                <span>{item.day}</span>
              </div>
            ))}
          </div>
        </div>

        <div className="content-card">
          <div className="section-title">
            <h3>Daily Goal</h3>
            <span className="badge badge-warning">{goalTarget}m target</span>
          </div>
          <div className="progress-ring" style={{ "--progress": `${progress}%` }}>
            <div>{progress}%</div>
          </div>
          <div className="goal-meter">
            <span style={{ width: `${progress}%` }} />
          </div>
          <p className="metric-small">{todayMinutes} of {goalTarget} minutes completed today.</p>
        </div>
      </section>

      <section className="grid-2" style={{ marginTop: 16 }}>
        <div className="table-panel">
          <div className="section-title" style={{ padding: "18px 18px 0" }}>
            <h3>Recent Sessions</h3>
            <button className="ghost-button" type="button" onClick={() => navigate("/sessions")}>View all</button>
          </div>
          <table className="data-table">
            <thead>
              <tr>
                <th>Topic</th>
                <th>Language</th>
                <th>Duration</th>
              </tr>
            </thead>
            <tbody>
              {state.sessions.length > 0 ? (
                state.sessions.map((session) => (
                  <tr key={session.id}>
                    <td>{session.topicName || "General Coding"}</td>
                    <td>{session.languageName || "Not set"}</td>
                    <td>{minutesToDurationLabel(session.durationMinutes)}</td>
                  </tr>
                ))
              ) : (
                <tr>
                  <td colSpan="3">No sessions logged yet.</td>
                </tr>
              )}
            </tbody>
          </table>
        </div>

        <div className="content-card">
          <div className="section-title">
            <h3>Latest Achievements</h3>
            <FiAward />
          </div>
          {latestAchievements.length > 0 ? (
            <div className="grid-2">
              {latestAchievements.map((achievement) => (
                <div className="achievement-card" key={achievement.id}>
                  <div className="achievement-icon"><FiAward /></div>
                  <h3>{achievement.name}</h3>
                  <p>{achievement.description}</p>
                  <div className="goal-meter">
                    <span style={{ width: "100%" }} />
                  </div>
                </div>
              ))}
            </div>
          ) : (
            <p className="empty-text">Your first earned badge will appear here.</p>
          )}
        </div>
      </section>

      {state.loading && <div className="loading-overlay">Loading dashboard data...</div>}
    </DashboardLayout>
  );
}

function StatCard({ icon, label, value, trend }) {
  return (
    <article className="stat-card">
      <div className="stat-top">
        <div className="stat-icon">{icon}</div>
        <span className="trend-up">{trend}</span>
      </div>
      <p>{label}</p>
      <strong>{value}</strong>
    </article>
  );
}