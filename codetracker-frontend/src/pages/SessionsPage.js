import { useEffect, useMemo, useState } from "react";
import { FiClock, FiEdit3, FiPauseCircle, FiPlayCircle, FiPlus, FiSave, FiSquare, FiTrash2 } from "react-icons/fi";
import { getApiError } from "../api/apiClient";
import { sessionsApi } from "../api/sessionsApi";
import DashboardLayout from "../components/DashboardLayout";
import { findLanguageIdByName, findTopicIdByName, languageOptions, topicOptions } from "../data/referenceData";
import { calculateDurationMinutes, displayDate, minutesToDurationLabel, todayIsoDate, toTimeInputValue } from "../utils/formatters";

const initialForm = {
  topicId: "2",
  languageId: "1",
  sessionDate: todayIsoDate(),
  startTime: "09:00",
  endTime: "10:00",
  durationMinutes: "60",
  notes: "",
};

function formatTimer(totalSeconds) {
  const hours = String(Math.floor(totalSeconds / 3600)).padStart(2, "0");
  const minutes = String(Math.floor((totalSeconds % 3600) / 60)).padStart(2, "0");
  const seconds = String(totalSeconds % 60).padStart(2, "0");
  return `${hours}:${minutes}:${seconds}`;
}

export default function SessionsPage() {
  const [mode, setMode] = useState("log");
  const [entryMode, setEntryMode] = useState("manual");
  const [form, setForm] = useState(initialForm);
  const [sessions, setSessions] = useState([]);
  const [todaySessions, setTodaySessions] = useState([]);
  const [editId, setEditId] = useState(null);
  const [timerSeconds, setTimerSeconds] = useState(0);
  const [timerRunning, setTimerRunning] = useState(false);
  const [timerStopped, setTimerStopped] = useState(false);
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);
  const [message, setMessage] = useState("");
  const [error, setError] = useState("");

  const manualDuration = useMemo(
    () => calculateDurationMinutes(form.startTime, form.endTime) || Number(form.durationMinutes) || 0,
    [form.startTime, form.endTime, form.durationMinutes]
  );
  const timerDuration = Math.max(1, Math.ceil(timerSeconds / 60));
  const durationPreview = entryMode === "timer" ? (timerSeconds > 0 ? timerDuration : 0) : manualDuration;

  useEffect(() => {
    if (!timerRunning) {
      return undefined;
    }

    const interval = window.setInterval(() => {
      setTimerSeconds((seconds) => seconds + 1);
    }, 1000);

    return () => window.clearInterval(interval);
  }, [timerRunning]);

  async function loadSessions() {
    setLoading(true);
    setError("");

    try {
      const [sessionPage, todayList] = await Promise.all([
        sessionsApi.getSessions({ page: 0, size: 20, sort: "sessionDate,desc" }),
        sessionsApi.getTodaySessions(),
      ]);
      setSessions(sessionPage?.content || []);
      setTodaySessions(todayList || []);
    } catch (apiError) {
      setError(getApiError(apiError));
    } finally {
      setLoading(false);
    }
  }

  useEffect(() => {
    loadSessions();
  }, []);

  const handleChange = (event) => {
    setForm({ ...form, [event.target.name]: event.target.value });
  };

  const resetTimer = () => {
    setTimerRunning(false);
    setTimerStopped(false);
    setTimerSeconds(0);
  };

  const resetForm = () => {
    setForm({ ...initialForm, sessionDate: todayIsoDate() });
    setEditId(null);
    setMessage("");
    resetTimer();
  };

  const handleUseCurrentTime = () => {
    const now = new Date();
    const current = now.toTimeString().slice(0, 5);
    setForm((currentForm) => ({ ...currentForm, startTime: current, endTime: "" }));
  };

  const handleStartTimer = () => {
    setTimerStopped(false);
    setTimerRunning(true);
  };

  const handlePauseTimer = () => {
    setTimerRunning(false);
  };

  const handleStopTimer = () => {
    if (timerSeconds === 0) {
      setError("Start the timer before stopping it.");
      return;
    }

    setTimerRunning(false);
    setTimerStopped(true);
    setForm((currentForm) => ({
      ...currentForm,
      durationMinutes: String(timerDuration),
      startTime: "",
      endTime: "",
    }));
  };

  const buildPayload = () => ({
    topicId: Number(form.topicId),
    languageId: Number(form.languageId),
    sessionDate: form.sessionDate,
    startTime: entryMode === "manual" ? form.startTime || null : null,
    endTime: entryMode === "manual" ? form.endTime || null : null,
    durationMinutes: durationPreview,
    notes: form.notes.trim(),
    isTimerSession: entryMode === "timer",
  });

  const handleSubmit = async (event) => {
    event.preventDefault();
    setSaving(true);
    setError("");
    setMessage("");

    if (entryMode === "timer" && !timerStopped && !editId) {
      setSaving(false);
      setError("Stop the timer first, then confirm save.");
      return;
    }

    if (!durationPreview) {
      setSaving(false);
      setError("Duration must be between 1 and 1440 minutes. Check your time range or manual duration.");
      return;
    }

    try {
      if (editId) {
        await sessionsApi.updateSession(editId, buildPayload());
        setMessage("Session updated successfully.");
      } else {
        await sessionsApi.createSession(buildPayload());
        setMessage("Session logged successfully.");
      }

      resetForm();
      await loadSessions();
      setMode("history");
    } catch (apiError) {
      setError(getApiError(apiError));
    } finally {
      setSaving(false);
    }
  };

  const handleEdit = (session) => {
    setEditId(session.id);
    setEntryMode(session.isTimerSession ? "timer" : "manual");
    setTimerSeconds((session.durationMinutes || 0) * 60);
    setTimerStopped(Boolean(session.isTimerSession));
    setTimerRunning(false);
    setForm({
      topicId: String(findTopicIdByName(session.topicName)),
      languageId: String(findLanguageIdByName(session.languageName)),
      sessionDate: session.sessionDate || todayIsoDate(),
      startTime: toTimeInputValue(session.startTime),
      endTime: toTimeInputValue(session.endTime),
      durationMinutes: String(session.durationMinutes || ""),
      notes: session.notes || "",
    });
    setMode("log");
    setMessage("Editing selected session.");
  };

  const handleDelete = async (id) => {
    if (!window.confirm("Delete this coding session?")) {
      return;
    }

    try {
      await sessionsApi.deleteSession(id);
      setMessage("Session deleted successfully.");
      await loadSessions();
    } catch (apiError) {
      setError(getApiError(apiError));
    }
  };

  const todayMinutes = todaySessions.reduce((total, session) => total + (session.durationMinutes || 0), 0);

  return (
    <DashboardLayout
      title="Coding Sessions"
      subtitle="Log focused coding time and review your session history."
      action={<button className="primary-button" type="button" onClick={() => setMode("log")}><FiPlus /> New Session</button>}
    >
      {error && <div className="form-alert">{error}</div>}
      {message && <div className="form-alert success">{message}</div>}

      <div className="pill-row" style={{ marginBottom: 16 }}>
        <button className={`pill ${mode === "log" ? "active" : ""}`} type="button" onClick={() => setMode("log")}>Log New Session</button>
        <button className={`pill ${mode === "history" ? "active" : ""}`} type="button" onClick={() => setMode("history")}>Session History</button>
      </div>

      {mode === "log" ? (
        <section className="grid-2">
          <div className="form-panel">
            <div className="section-title">
              <h3>{editId ? "Edit Session" : "Session Details"}</h3>
              <span className="badge badge-success">API ready</span>
            </div>

            <div className="pill-row form-mode-row">
              <button className={`pill ${entryMode === "timer" ? "active" : ""}`} type="button" onClick={() => setEntryMode("timer")}>Use Timer</button>
              <button className={`pill ${entryMode === "manual" ? "active" : ""}`} type="button" onClick={() => setEntryMode("manual")}>Manual Entry</button>
            </div>

            <form className="form-grid" onSubmit={handleSubmit}>
              <div className="form-field">
                <label>Topic</label>
                <select name="topicId" value={form.topicId} onChange={handleChange}>
                  {topicOptions.map((topic) => (
                    <option key={topic.id} value={topic.id}>{topic.name}</option>
                  ))}
                </select>
              </div>

              <div className="form-field">
                <label>Language</label>
                <select name="languageId" value={form.languageId} onChange={handleChange}>
                  {languageOptions.map((language) => (
                    <option key={language.id} value={language.id}>{language.name}</option>
                  ))}
                </select>
              </div>

              {entryMode === "timer" ? (
                <>
                  <div className="timer-display full">
                    <span>{formatTimer(timerSeconds)}</span>
                    <p>{timerStopped ? `${timerDuration} minute session ready to save.` : "Start, pause, and stop your focused session."}</p>
                  </div>
                  <div className="form-field">
                    <label>Session Date</label>
                    <input name="sessionDate" type="date" value={form.sessionDate} max={todayIsoDate()} onChange={handleChange} required />
                  </div>
                  <div className="form-field">
                    <label>Saved Duration</label>
                    <input value={timerSeconds > 0 ? minutesToDurationLabel(timerDuration) : "Not stopped yet"} readOnly />
                  </div>
                </>
              ) : (
                <>
                  <div className="form-field">
                    <label>Start Time</label>
                    <input name="startTime" type="time" value={form.startTime} onChange={handleChange} />
                  </div>

                  <div className="form-field">
                    <label>End Time</label>
                    <input name="endTime" type="time" value={form.endTime} onChange={handleChange} />
                  </div>

                  <div className="form-field">
                    <label>Session Date</label>
                    <input name="sessionDate" type="date" value={form.sessionDate} max={todayIsoDate()} onChange={handleChange} required />
                  </div>

                  <div className="form-field">
                    <label>Duration</label>
                    <input name="durationMinutes" type="number" min="1" max="1440" value={form.durationMinutes} onChange={handleChange} />
                  </div>
                </>
              )}

              <div className="form-field full">
                <label>Notes</label>
                <textarea name="notes" value={form.notes} onChange={handleChange} placeholder="What did you learn or build?" />
              </div>

              <div className="action-row full">
                <button className="primary-button" type="submit" disabled={saving}><FiSave /> {saving ? "Saving..." : editId ? "Update Session" : entryMode === "timer" ? "Save Timer Session" : "Log Session"}</button>
                {entryMode === "timer" ? (
                  <>
                    <button className="secondary-button" type="button" onClick={handleStartTimer} disabled={timerRunning}><FiPlayCircle /> Start</button>
                    <button className="secondary-button" type="button" onClick={handlePauseTimer} disabled={!timerRunning}><FiPauseCircle /> Pause</button>
                    <button className="secondary-button" type="button" onClick={handleStopTimer} disabled={!timerRunning && timerSeconds === 0}><FiSquare /> Stop</button>
                    <button className="ghost-button" type="button" onClick={resetTimer}>Reset Timer</button>
                  </>
                ) : (
                  <button className="secondary-button" type="button" onClick={handleUseCurrentTime}><FiPlayCircle /> Use Current Time</button>
                )}
                {editId && <button className="ghost-button" type="button" onClick={resetForm}>Cancel Edit</button>}
              </div>
            </form>
          </div>

          <div className="content-card">
            <div className="section-title">
              <h3>Today Summary</h3>
              <FiClock />
            </div>
            <div className="grid-2">
              <div className="stat-card">
                <p>Completed</p>
                <strong>{todaySessions.length}</strong>
                <span className="trend-up">sessions today</span>
              </div>
              <div className="stat-card">
                <p>Focused Time</p>
                <strong>{minutesToDurationLabel(todayMinutes)}</strong>
                <span className="trend-up">from live API</span>
              </div>
            </div>
            <div style={{ marginTop: 16 }}>
              <div className="section-title">
                <h3>Duration Preview</h3>
              </div>
              <div className="pill-row">
                <span className="pill active">{minutesToDurationLabel(durationPreview)}</span>
                <span className="pill">{entryMode === "timer" ? "Timer Mode" : "Manual Entry"}</span>
                <span className="pill">{form.sessionDate}</span>
              </div>
            </div>
          </div>
        </section>
      ) : (
        <HistoryTable sessions={sessions} loading={loading} onEdit={handleEdit} onDelete={handleDelete} />
      )}
    </DashboardLayout>
  );
}

function HistoryTable({ sessions, loading, onEdit, onDelete }) {
  return (
    <section className="table-panel">
      <div className="section-title" style={{ padding: "18px 18px 0" }}>
        <h3>Session History</h3>
        <div className="filter-row">
          <span className="pill active">All</span>
          <span className="pill">Live API</span>
        </div>
      </div>
      <table className="data-table">
        <thead>
          <tr>
            <th>Topic</th>
            <th>Language</th>
            <th>Date</th>
            <th>Duration</th>
            <th>Mode</th>
            <th>Notes</th>
            <th>Action</th>
          </tr>
        </thead>
        <tbody>
          {loading ? (
            <tr><td colSpan="7">Loading sessions...</td></tr>
          ) : sessions.length > 0 ? (
            sessions.map((session) => (
              <tr key={session.id}>
                <td>{session.topicName || "General Coding"}</td>
                <td>{session.languageName || "Not set"}</td>
                <td>{displayDate(session.sessionDate)}</td>
                <td>{minutesToDurationLabel(session.durationMinutes)}</td>
                <td><span className="badge badge-neutral">{session.isTimerSession ? "Timer" : "Manual"}</span></td>
                <td>{session.notes || "-"}</td>
                <td>
                  <div className="action-row">
                    <button className="icon-button" type="button" aria-label="Edit session" onClick={() => onEdit(session)}><FiEdit3 /></button>
                    <button className="icon-button danger-icon" type="button" aria-label="Delete session" onClick={() => onDelete(session.id)}><FiTrash2 /></button>
                  </div>
                </td>
              </tr>
            ))
          ) : (
            <tr><td colSpan="7">No coding sessions logged yet.</td></tr>
          )}
        </tbody>
      </table>
    </section>
  );
}