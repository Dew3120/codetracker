import { FiCalendar, FiCheckCircle, FiSave, FiTarget, FiTrendingUp } from "react-icons/fi";
import DashboardLayout from "../components/DashboardLayout";
import { goalCards } from "../data/mockData";

export default function GoalsPage() {
  return (
    <DashboardLayout
      title="Goals"
      subtitle="Set daily targets and watch your coding consistency improve."
      action={<button className="primary-button" type="button"><FiSave /> Save Goal</button>}
    >
      <section className="grid-3">
        {goalCards.map((card) => (
          <article className="stat-card" key={card.label}>
            <div className="stat-top">
              <div className="stat-icon"><FiTarget /></div>
              <span className="trend-up">Active</span>
            </div>
            <p>{card.label}</p>
            <strong>{card.value}</strong>
            <div className="metric-small">{card.detail}</div>
          </article>
        ))}
      </section>

      <section className="grid-2" style={{ marginTop: 16 }}>
        <div className="form-panel">
          <div className="section-title">
            <h3>Daily Goal Setter</h3>
            <FiCalendar />
          </div>

          <form className="form-grid">
            <div className="form-field">
              <label>Goal Date</label>
              <input type="date" defaultValue="2026-07-07" />
            </div>
            <div className="form-field">
              <label>Target Minutes</label>
              <input type="number" defaultValue="120" />
            </div>
            <div className="form-field full">
              <label>Focus Note</label>
              <textarea placeholder="Today I will focus on Spring Boot and React UI wiring." />
            </div>
            <div className="action-row full">
              <button className="primary-button" type="button"><FiSave /> Update Goal</button>
              <button className="secondary-button" type="button">Reset</button>
            </div>
          </form>
        </div>

        <div className="content-card">
          <div className="section-title">
            <h3>Target Performance</h3>
            <FiTrendingUp />
          </div>
          <div className="progress-ring">
            <div>70%</div>
          </div>
          <div className="goal-meter">
            <span style={{ width: "70%" }} />
          </div>
          <p className="metric-small">Estimated 36 minutes remaining to reach your goal.</p>
        </div>
      </section>

      <section className="grid-3" style={{ marginTop: 16 }}>
        <Milestone title="Certification Goal" value="Spring Boot" progress={62} />
        <Milestone title="Open Source Goal" value="3 PRs" progress={40} />
        <Milestone title="Problem Goal" value="100 Problems" progress={64} />
      </section>
    </DashboardLayout>
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
      <p>{progress}% complete</p>
      <div className="goal-meter">
        <span style={{ width: `${progress}%` }} />
      </div>
    </article>
  );
}
