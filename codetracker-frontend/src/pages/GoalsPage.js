import { useEffect, useMemo, useState } from "react";
import { FiCalendar, FiCheckCircle, FiSave, FiTarget, FiTrendingUp } from "react-icons/fi";
import { getApiError } from "../api/apiClient";
import { goalsApi } from "../api/goalsApi";
import DashboardLayout from "../components/DashboardLayout";
import { displayDate, minutesToDurationLabel, todayIsoDate } from "../utils/formatters";

function buildHeatmapDays(history) {
  const historyByDate = new Map(history.map((goal) => [goal.goalDate, goal]));
  const days = [];
  const today = new Date(`${todayIsoDate()}T00:00:00`);

  for (let index = 89; index >= 0; index -= 1) {
    const date = new Date(today);
    date.setDate(today.getDate() - index);
    const iso = date.toISOString().slice(0, 10);
    const goal = historyByDate.get(iso);
    const progress = Math.round(goal?.progressPercentage || 0);
    let status = "empty";

    if (goal?.isCompleted) {
      status = "completed";
    } else if (goal && progress > 0) {
      status = "partial";
    } else if (goal) {
      status = "missed";
    }

    days.push({
      date: iso,
      label: displayDate(iso),
      progress,
      status,
      targetMinutes: goal?.targetMinutes || 0,
      achievedMinutes: goal?.achievedMinutes || 0,
    });
  }

  return days;
}

export default function GoalsPage() {
  const [goalDate, setGoalDate] = useState(todayIsoDate());
  const [targetMinutes, setTargetMinutes] = useState("120");
  const [todayGoal, setTodayGoal] = useState(null);
  const [streak, setStreak] = useState(null);
  const [history, setHistory] = useState([]);
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState("");
  const [message, setMessage] = useState("");

  async function loadGoals() {
    setLoading(true);
    setError("");

    try {
      const [currentGoal, streakData, goalHistory] = await Promise.all([
        goalsApi.getTodayGoal(),
        goalsApi.getStreak(),
        goalsApi.getGoalHistory(),
      ]);
      setTodayGoal(currentGoal);
      setStreak(streakData);
      setHistory(goalHistory || []);
    } catch (apiError) {
      setError(getApiError(apiError));
    } finally {
      setLoading(false);
    }
  }

  useEffect(() => {
    loadGoals();
  }, []);

  const heatmapDays = useMemo(() => buildHeatmapDays(history), [history]);

  const handleGoalSubmit = async (event) => {
    event?.preventDefault();
    setSaving(true);
    setError("");
    setMessage("");

    try {
      await goalsApi.setGoal({
        goalDate,
        targetMinutes: Number(targetMinutes),
      });
      setMessage("Goal saved successfully.");
      await loadGoals();
    } catch (apiError) {
      setError(getApiError(apiError));
    } finally {
      setSaving(false);
    }
  };

  const progress = Math.min(100, Math.round(todayGoal?.progressPercentage || 0));
  const achievedMinutes = todayGoal?.achievedMinutes || 0;
  const activeTargetMinutes = todayGoal?.targetMinutes || Number(targetMinutes) || 120;

  return (
    <DashboardLayout
      title="Goals"
      subtitle="Set daily targets and watch your coding consistency improve."
      action={<button className="primary-button" type="button" onClick={handleGoalSubmit} disabled={saving}><FiSave /> {saving ? "Saving..." : "Save Goal"}</button>}
    >
      {error && <div className="form-alert">{error}</div>}
      {message && <div className="form-alert success">{message}</div>}

      <section className="grid-3">
        <GoalCard label="Daily Goal" value={minutesToDurationLabel(activeTargetMinutes)} detail={`${minutesToDurationLabel(achievedMinutes)} completed`} />
        <GoalCard label="Current Streak" value={`${streak?.currentStreak || 0} days`} detail={`Longest: ${streak?.longestStreak || 0} days`} />
        <GoalCard label="Active Days" value={streak?.totalDaysActive || 0} detail="completed goal days" />
      </section>

      <section className="grid-2" style={{ marginTop: 16 }}>
        <div className="form-panel">
          <div className="section-title">
            <h3>Daily Goal Setter</h3>
            <FiCalendar />
          </div>

          <form className="form-grid" onSubmit={handleGoalSubmit}>
            <div className="form-field">
              <label>Goal Date</label>
              <input type="date" value={goalDate} max={todayIsoDate()} onChange={(event) => setGoalDate(event.target.value)} />
            </div>
            <div className="form-field">
              <label>Target Minutes</label>
              <input type="number" min="1" max="1440" value={targetMinutes} onChange={(event) => setTargetMinutes(event.target.value)} />
            </div>
            <div className="form-field full">
              <label>Status</label>
              <textarea value={todayGoal ? "Today already has a goal. The current backend supports creating goals and tracking progress." : "Set today's coding target before logging sessions."} readOnly />
            </div>
            <div className="action-row full">
              <button className="primary-button" type="submit" disabled={saving}><FiSave /> {saving ? "Saving..." : "Create Goal"}</button>
              <button className="secondary-button" type="button" onClick={() => { setGoalDate(todayIsoDate()); setTargetMinutes("120"); }}>Reset</button>
            </div>
          </form>
        </div>

        <div className="content-card">
          <div className="section-title">
            <h3>Target Performance</h3>
            <FiTrendingUp />
          </div>
          <div className="progress-ring" style={{ "--progress": `${progress}%` }}>
            <div>{progress}%</div>
          </div>
          <div className="goal-meter">
            <span style={{ width: `${progress}%` }} />
          </div>
          <p className="metric-small">{minutesToDurationLabel(Math.max(activeTargetMinutes - achievedMinutes, 0))} remaining to reach your goal.</p>
        </div>
      </section>

      <section className="content-card" style={{ marginTop: 16 }}>
        <div className="section-title">
          <h3>Streak Calendar</h3>
          <span className="badge badge-neutral">Past 90 days</span>
        </div>
        <div className="streak-heatmap" aria-label="Past 90 days goal streak calendar">
          {heatmapDays.map((day) => (
            <span
              key={day.date}
              className={`heat-day heat-${day.status}`}
              title={`${day.label}: ${day.progress}% (${day.achievedMinutes}/${day.targetMinutes} min)`}
            />
          ))}
        </div>
        <div className="heatmap-legend">
          <span>No goal</span>
          <i className="heat-day heat-empty" />
          <i className="heat-day heat-missed" />
          <i className="heat-day heat-partial" />
          <i className="heat-day heat-completed" />
          <span>Completed</span>
        </div>
      </section>

      <section className="table-panel" style={{ marginTop: 16 }}>
        <div className="section-title" style={{ padding: "18px 18px 0" }}>
          <h3>Goal History</h3>
          <span className="badge badge-neutral">{loading ? "Loading" : `${history.length} records`}</span>
        </div>
        <table className="data-table">
          <thead>
            <tr>
              <th>Date</th>
              <th>Target</th>
              <th>Achieved</th>
              <th>Progress</th>
              <th>Status</th>
            </tr>
          </thead>
          <tbody>
            {history.length > 0 ? (
              history.slice(0, 10).map((goal) => (
                <tr key={goal.id}>
                  <td>{displayDate(goal.goalDate)}</td>
                  <td>{minutesToDurationLabel(goal.targetMinutes)}</td>
                  <td>{minutesToDurationLabel(goal.achievedMinutes)}</td>
                  <td>{Math.round(goal.progressPercentage || 0)}%</td>
                  <td><span className={`badge ${goal.isCompleted ? "badge-success" : "badge-warning"}`}>{goal.isCompleted ? "Completed" : "In progress"}</span></td>
                </tr>
              ))
            ) : (
              <tr><td colSpan="5">No goals created yet.</td></tr>
            )}
          </tbody>
        </table>
      </section>

      <section className="grid-3" style={{ marginTop: 16 }}>
        <Milestone title="Today Progress" value={`${progress}%`} progress={progress} />
        <Milestone title="Streak Health" value={`${streak?.currentStreak || 0} days`} progress={Math.min(100, ((streak?.currentStreak || 0) / 7) * 100)} />
        <Milestone title="Goal Completion" value={todayGoal?.isCompleted ? "Done" : "Active"} progress={todayGoal?.isCompleted ? 100 : progress} />
      </section>
    </DashboardLayout>
  );
}

function GoalCard({ label, value, detail }) {
  return (
    <article className="stat-card">
      <div className="stat-top">
        <div className="stat-icon"><FiTarget /></div>
        <span className="trend-up">Live</span>
      </div>
      <p>{label}</p>
      <strong>{value}</strong>
      <div className="metric-small">{detail}</div>
    </article>
  );
}

function Milestone({ title, value, progress }) {
  return (
    <article className="content-card">
      <div className="section-title">
        <h3>{title}</h3>
        <FiCheckCircle />
      </div>
      <strong style={{ color: "#10243b", fontSize: 26 }}>{value}</strong>
      <p>{Math.round(progress)}% complete</p>
      <div className="goal-meter">
        <span style={{ width: `${Math.min(100, progress)}%` }} />
      </div>
    </article>
  );
}