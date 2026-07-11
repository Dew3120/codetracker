import { FiCheckCircle, FiCode, FiEdit3, FiExternalLink, FiPlus } from "react-icons/fi";
import DashboardLayout from "../components/DashboardLayout";
import { problems } from "../data/mockData";

export default function ProblemsPage() {
  return (
    <DashboardLayout
      title="Problems"
      subtitle="Log and analyze problem-solving progress across coding platforms."
      action={<button className="primary-button" type="button"><FiPlus /> Log Problem</button>}
    >
      <section className="grid-4">
        <ProblemStat label="Total Problems" value="142" />
        <ProblemStat label="Solved" value="118" />
        <ProblemStat label="Success Rate" value="83%" />
        <ProblemStat label="Avg Time" value="34m" />
      </section>

      <section className="form-panel" style={{ marginTop: 16 }}>
        <div className="section-title">
          <h3>Log New Problem</h3>
          <FiCode />
        </div>
        <form className="form-grid">
          <div className="form-field">
            <label>Problem Name</label>
            <input placeholder="Two Sum" />
          </div>
          <div className="form-field">
            <label>Platform</label>
            <select defaultValue="LeetCode">
              <option>LeetCode</option>
              <option>HackerRank</option>
              <option>Codeforces</option>
              <option>Other</option>
            </select>
          </div>
          <div className="form-field">
            <label>Difficulty</label>
            <select defaultValue="Medium">
              <option>Easy</option>
              <option>Medium</option>
              <option>Hard</option>
            </select>
          </div>
          <div className="form-field">
            <label>Time Spent</label>
            <input placeholder="45 minutes" />
          </div>
          <div className="form-field">
            <label>Solved Date</label>
            <input type="date" defaultValue="2026-07-07" />
          </div>
          <div className="form-field">
            <label>Problem URL</label>
            <input placeholder="https://leetcode.com/problems/..." />
          </div>
          <div className="form-field full">
            <label>Notes</label>
            <textarea placeholder="Approach, edge cases, and complexity notes." />
          </div>
          <div className="action-row full">
            <button className="primary-button" type="button"><FiCheckCircle /> Save Problem</button>
            <button className="secondary-button" type="button">Mark Attempted</button>
          </div>
        </form>
      </section>

      <section className="table-panel" style={{ marginTop: 16 }}>
        <div className="section-title" style={{ padding: "18px 18px 0" }}>
          <h3>Problem Log</h3>
          <div className="filter-row">
            <span className="pill active">All</span>
            <span className="pill">Easy</span>
            <span className="pill">Medium</span>
            <span className="pill">Hard</span>
          </div>
        </div>
        <table className="data-table">
          <thead>
            <tr>
              <th>Problem</th>
              <th>Platform</th>
              <th>Difficulty</th>
              <th>Solved Date</th>
              <th>Time</th>
              <th>Status</th>
              <th>Action</th>
            </tr>
          </thead>
          <tbody>
            {problems.map((problem) => (
              <tr key={problem.id}>
                <td>{problem.name}</td>
                <td>{problem.platform}</td>
                <td><DifficultyBadge difficulty={problem.difficulty} /></td>
                <td>{problem.solvedDate}</td>
                <td>{problem.timeSpent}</td>
                <td><span className={`badge ${problem.solved ? "badge-success" : "badge-warning"}`}>{problem.solved ? "Solved" : "Attempted"}</span></td>
                <td>
                  <div className="action-row">
                    <button className="icon-button" type="button" aria-label="Open problem"><FiExternalLink /></button>
                    <button className="icon-button" type="button" aria-label="Edit problem"><FiEdit3 /></button>
                  </div>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </section>
    </DashboardLayout>
  );
}

function ProblemStat({ label, value }) {
  return (
    <article className="stat-card">
      <div className="stat-top">
        <div className="stat-icon"><FiCode /></div>
        <span className="trend-up">Updated</span>
      </div>
      <p>{label}</p>
      <strong>{value}</strong>
    </article>
  );
}

function DifficultyBadge({ difficulty }) {
  const className = difficulty === "Hard" ? "badge-danger" : difficulty === "Medium" ? "badge-warning" : "badge-success";
  return <span className={`badge ${className}`}>{difficulty}</span>;
}
