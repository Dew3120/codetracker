import { useCallback, useEffect, useMemo, useState } from "react";
import { FiCheckCircle, FiCode, FiEdit3, FiExternalLink, FiPlus, FiTrash2 } from "react-icons/fi";
import { getApiError } from "../api/apiClient";
import { problemsApi } from "../api/problemsApi";
import DashboardLayout from "../components/DashboardLayout";
import { displayDate, minutesToDurationLabel, todayIsoDate } from "../utils/formatters";

const initialProblemForm = {
  problemName: "",
  platform: "LeetCode",
  difficulty: "MEDIUM",
  timeTakenMinutes: "30",
  solvedDate: todayIsoDate(),
  problemUrl: "",
  notes: "",
};

export default function ProblemsPage() {
  const [form, setForm] = useState(initialProblemForm);
  const [problems, setProblems] = useState([]);
  const [stats, setStats] = useState(null);
  const [difficultyFilter, setDifficultyFilter] = useState("");
  const [editId, setEditId] = useState(null);
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState("");
  const [message, setMessage] = useState("");

  const loadProblems = useCallback(async (filter = difficultyFilter) => {
    setLoading(true);
    setError("");

    try {
      const params = { page: 0, size: 20 };
      if (filter) {
        params.difficulty = filter;
      }

      const [problemPage, problemStats] = await Promise.all([
        problemsApi.getProblems(params),
        problemsApi.getStats(),
      ]);
      setProblems(problemPage?.content || []);
      setStats(problemStats);
    } catch (apiError) {
      setError(getApiError(apiError));
    } finally {
      setLoading(false);
    }
  }, [difficultyFilter]);

  useEffect(() => {
    loadProblems(difficultyFilter);
  }, [difficultyFilter, loadProblems]);

  const averageTime = useMemo(() => {
    const solvedWithTime = problems.filter((problem) => problem.isSolved && problem.timeTakenMinutes);
    if (!solvedWithTime.length) {
      return 0;
    }

    return Math.round(solvedWithTime.reduce((total, problem) => total + problem.timeTakenMinutes, 0) / solvedWithTime.length);
  }, [problems]);

  const handleChange = (event) => {
    setForm({ ...form, [event.target.name]: event.target.value });
  };

  const resetForm = () => {
    setForm(initialProblemForm);
    setEditId(null);
  };

  const buildPayload = (isSolved) => ({
    problemName: form.problemName.trim(),
    platform: form.platform.trim(),
    difficulty: form.difficulty,
    timeTakenMinutes: Number(form.timeTakenMinutes) || null,
    solvedDate: form.solvedDate,
    problemUrl: form.problemUrl.trim(),
    notes: form.notes.trim(),
    isSolved,
  });

  const handleSubmit = async (event, isSolved = true) => {
    event.preventDefault();
    setSaving(true);
    setError("");
    setMessage("");

    try {
      if (editId) {
        await problemsApi.updateProblem(editId, buildPayload(isSolved));
        setMessage("Problem updated successfully.");
      } else {
        await problemsApi.createProblem(buildPayload(isSolved));
        setMessage(isSolved ? "Solved problem saved." : "Problem attempt saved.");
      }

      resetForm();
      await loadProblems();
    } catch (apiError) {
      setError(getApiError(apiError));
    } finally {
      setSaving(false);
    }
  };

  const handleEdit = (problem) => {
    setEditId(problem.id);
    setForm({
      problemName: problem.problemName || "",
      platform: problem.platform || "LeetCode",
      difficulty: problem.difficulty || "MEDIUM",
      timeTakenMinutes: String(problem.timeTakenMinutes || ""),
      solvedDate: problem.solvedDate || todayIsoDate(),
      problemUrl: problem.problemUrl || "",
      notes: problem.notes || "",
    });
    setMessage("Editing selected problem.");
  };

  const handleDelete = async (id) => {
    if (!window.confirm("Delete this problem record?")) {
      return;
    }

    try {
      await problemsApi.deleteProblem(id);
      setMessage("Problem deleted successfully.");
      await loadProblems();
    } catch (apiError) {
      setError(getApiError(apiError));
    }
  };

  return (
    <DashboardLayout
      title="Problems"
      subtitle="Log and analyze problem-solving progress across coding platforms."
      action={<button className="primary-button" type="button" onClick={resetForm}><FiPlus /> Log Problem</button>}
    >
      {error && <div className="form-alert">{error}</div>}
      {message && <div className="form-alert success">{message}</div>}

      <section className="grid-4">
        <ProblemStat label="Total Problems" value={stats?.totalAttempted || 0} />
        <ProblemStat label="Solved" value={stats?.totalSolved || 0} />
        <ProblemStat label="Success Rate" value={`${stats?.successRate || 0}%`} />
        <ProblemStat label="Avg Time" value={minutesToDurationLabel(averageTime)} />
      </section>

      <section className="form-panel" style={{ marginTop: 16 }}>
        <div className="section-title">
          <h3>{editId ? "Edit Problem" : "Log New Problem"}</h3>
          <FiCode />
        </div>
        <form className="form-grid" onSubmit={(event) => handleSubmit(event, true)}>
          <div className="form-field">
            <label>Problem Name</label>
            <input name="problemName" value={form.problemName} onChange={handleChange} placeholder="Two Sum" required />
          </div>
          <div className="form-field">
            <label>Platform</label>
            <select name="platform" value={form.platform} onChange={handleChange}>
              <option>LeetCode</option>
              <option>HackerRank</option>
              <option>Codeforces</option>
              <option>Other</option>
            </select>
          </div>
          <div className="form-field">
            <label>Difficulty</label>
            <select name="difficulty" value={form.difficulty} onChange={handleChange}>
              <option value="EASY">Easy</option>
              <option value="MEDIUM">Medium</option>
              <option value="HARD">Hard</option>
            </select>
          </div>
          <div className="form-field">
            <label>Time Spent</label>
            <input name="timeTakenMinutes" type="number" min="0" value={form.timeTakenMinutes} onChange={handleChange} placeholder="45" />
          </div>
          <div className="form-field">
            <label>Solved Date</label>
            <input name="solvedDate" type="date" value={form.solvedDate} max={todayIsoDate()} onChange={handleChange} required />
          </div>
          <div className="form-field">
            <label>Problem URL</label>
            <input name="problemUrl" value={form.problemUrl} onChange={handleChange} placeholder="https://leetcode.com/problems/..." />
          </div>
          <div className="form-field full">
            <label>Notes</label>
            <textarea name="notes" value={form.notes} onChange={handleChange} placeholder="Approach, edge cases, and complexity notes." />
          </div>
          <div className="action-row full">
            <button className="primary-button" type="submit" disabled={saving}><FiCheckCircle /> {saving ? "Saving..." : editId ? "Update Solved" : "Save Solved"}</button>
            <button className="secondary-button" type="button" disabled={saving} onClick={(event) => handleSubmit(event, false)}>Mark Attempted</button>
            {editId && <button className="ghost-button" type="button" onClick={resetForm}>Cancel Edit</button>}
          </div>
        </form>
      </section>

      <section className="table-panel" style={{ marginTop: 16 }}>
        <div className="section-title" style={{ padding: "18px 18px 0" }}>
          <h3>Problem Log</h3>
          <div className="filter-row">
            {["", "EASY", "MEDIUM", "HARD"].map((difficulty) => (
              <button key={difficulty || "ALL"} className={`pill ${difficultyFilter === difficulty ? "active" : ""}`} type="button" onClick={() => setDifficultyFilter(difficulty)}>
                {difficulty || "All"}
              </button>
            ))}
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
            {loading ? (
              <tr><td colSpan="7">Loading problems...</td></tr>
            ) : problems.length > 0 ? (
              problems.map((problem) => (
                <tr key={problem.id}>
                  <td>{problem.problemName}</td>
                  <td>{problem.platform}</td>
                  <td><DifficultyBadge difficulty={problem.difficulty} /></td>
                  <td>{displayDate(problem.solvedDate)}</td>
                  <td>{minutesToDurationLabel(problem.timeTakenMinutes)}</td>
                  <td><span className={`badge ${problem.isSolved ? "badge-success" : "badge-warning"}`}>{problem.isSolved ? "Solved" : "Attempted"}</span></td>
                  <td>
                    <div className="action-row">
                      <button className="icon-button" type="button" aria-label="Open problem" disabled={!problem.problemUrl} onClick={() => problem.problemUrl && window.open(problem.problemUrl, "_blank", "noreferrer")}><FiExternalLink /></button>
                      <button className="icon-button" type="button" aria-label="Edit problem" onClick={() => handleEdit(problem)}><FiEdit3 /></button>
                      <button className="icon-button danger-icon" type="button" aria-label="Delete problem" onClick={() => handleDelete(problem.id)}><FiTrash2 /></button>
                    </div>
                  </td>
                </tr>
              ))
            ) : (
              <tr><td colSpan="7">No problem records yet.</td></tr>
            )}
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
        <span className="trend-up">Live</span>
      </div>
      <p>{label}</p>
      <strong>{value}</strong>
    </article>
  );
}

function DifficultyBadge({ difficulty }) {
  const normalized = difficulty?.toUpperCase();
  const className = normalized === "HARD" ? "badge-danger" : normalized === "MEDIUM" ? "badge-warning" : "badge-success";
  return <span className={`badge ${className}`}>{normalized || "EASY"}</span>;
}