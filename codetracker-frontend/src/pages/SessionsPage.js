import { useState } from "react";
import { FiClock, FiEdit3, FiPlayCircle, FiPlus, FiSave } from "react-icons/fi";
import DashboardLayout from "../components/DashboardLayout";
import { sessions } from "../data/mockData";

export default function SessionsPage() {
  const [mode, setMode] = useState("log");

  return (
    <DashboardLayout
      title="Coding Sessions"
      subtitle="Log focused coding time and review your session history."
      action={<button className="primary-button" type="button"><FiPlus /> New Session</button>}
    >
      <div className="pill-row" style={{ marginBottom: 16 }}>
        <button className={`pill ${mode === "log" ? "active" : ""}`} type="button" onClick={() => setMode("log")}>Log New Session</button>
        <button className={`pill ${mode === "history" ? "active" : ""}`} type="button" onClick={() => setMode("history")}>Session History</button>
      </div>

      {mode === "log" ? (
        <section className="grid-2">
          <div className="form-panel">
            <div className="section-title">
              <h3>Session Details</h3>
              <span className="badge badge-success">Ready</span>
            </div>

            <form className="form-grid">
              <div className="form-field">
                <label>Topic</label>
                <select defaultValue="Spring Boot">
                  <option>Spring Boot</option>
                  <option>React.js</option>
                  <option>DSA</option>
                  <option>MySQL</option>
                </select>
              </div>

              <div className="form-field">
                <label>Language</label>
                <select defaultValue="Java">
                  <option>Java</option>
                  <option>JavaScript</option>
                  <option>TypeScript</option>
                  <option>SQL</option>
                </select>
              </div>

              <div className="form-field">
                <label>Start Time</label>
                <input type="time" defaultValue="09:30" />
              </div>

              <div className="form-field">
                <label>End Time</label>
                <input type="time" defaultValue="11:00" />
              </div>

              <div className="form-field">
                <label>Session Date</label>
                <input type="date" defaultValue="2026-07-07" />
              </div>

              <div className="form-field">
                <label>Duration</label>
                <input value="90 minutes" readOnly />
              </div>

              <div className="form-field full">
                <label>Notes</label>
                <textarea placeholder="What did you learn or build?" />
              </div>

              <div className="action-row full">
                <button className="primary-button" type="button"><FiSave /> Log Session</button>
                <button className="secondary-button" type="button"><FiPlayCircle /> Start Timer</button>
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
                <strong>3</strong>
                <span className="trend-up">sessions today</span>
              </div>
              <div className="stat-card">
                <p>Focused Time</p>
                <strong>3.4h</strong>
                <span className="trend-up">70% of goal</span>
              </div>
            </div>
            <div style={{ marginTop: 16 }}>
              <div className="section-title">
                <h3>Session Mode</h3>
              </div>
              <div className="pill-row">
                <span className="pill active">Focused</span>
                <span className="pill">Review</span>
                <span className="pill">Practice</span>
              </div>
            </div>
          </div>
        </section>
      ) : (
        <HistoryTable />
      )}
    </DashboardLayout>
  );
}

function HistoryTable() {
  return (
    <section className="table-panel">
      <div className="section-title" style={{ padding: "18px 18px 0" }}>
        <h3>Session History</h3>
        <div className="filter-row">
          <span className="pill active">All</span>
          <span className="pill">This Week</span>
          <span className="pill">Java</span>
        </div>
      </div>
      <table className="data-table">
        <thead>
          <tr>
            <th>Session</th>
            <th>Topic</th>
            <th>Language</th>
            <th>Date</th>
            <th>Duration</th>
            <th>Status</th>
            <th>Action</th>
          </tr>
        </thead>
        <tbody>
          {sessions.map((session) => (
            <tr key={session.id}>
              <td>{session.name}</td>
              <td>{session.topic}</td>
              <td>{session.language}</td>
              <td>{session.date}</td>
              <td>{session.duration}</td>
              <td><span className="badge badge-success">{session.status}</span></td>
              <td><button className="icon-button" type="button" aria-label="Edit session"><FiEdit3 /></button></td>
            </tr>
          ))}
        </tbody>
      </table>
    </section>
  );
}
