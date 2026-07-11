import { FiAward, FiClock, FiCode, FiPlus, FiTarget, FiTrendingUp } from "react-icons/fi";
import DashboardLayout from "../components/DashboardLayout";
import { achievements, sessions, weeklyHours } from "../data/mockData";

export default function DashboardPage() {
  const maxHours = Math.max(...weeklyHours.map((item) => item.hours));

  return (
    <DashboardLayout
      title="Dashboard"
      subtitle="A clean snapshot of today's coding progress and recent activity."
      action={<button className="primary-button" type="button"><FiPlus /> Log Session</button>}
    >
      <section className="grid-4">
        <StatCard icon={<FiClock />} label="Today" value="84m" trend="+24m vs yesterday" />
        <StatCard icon={<FiTrendingUp />} label="Current Streak" value="6 days" trend="Best: 12 days" />
        <StatCard icon={<FiCode />} label="Problems Solved" value="64" trend="+5 this week" />
        <StatCard icon={<FiTarget />} label="Goal Progress" value="70%" trend="36m remaining" />
      </section>

      <section className="grid-2" style={{ marginTop: 16 }}>
        <div className="content-card">
          <div className="section-title">
            <h3>Weekly Hours</h3>
            <span className="badge badge-success">10.5h total</span>
          </div>
          <div className="bar-chart">
            {weeklyHours.map((item) => (
              <div key={item.day}>
                <span style={{ height: `${(item.hours / maxHours) * 100}%` }} />
                <span>{item.day}</span>
              </div>
            ))}
          </div>
        </div>

        <div className="content-card">
          <div className="section-title">
            <h3>Daily Goal</h3>
            <span className="badge badge-warning">120m target</span>
          </div>
          <div className="progress-ring">
            <div>70%</div>
          </div>
          <div className="goal-meter">
            <span style={{ width: "70%" }} />
          </div>
          <p className="metric-small">84 of 120 minutes completed today.</p>
        </div>
      </section>

      <section className="grid-2" style={{ marginTop: 16 }}>
        <div className="table-panel">
          <div className="section-title" style={{ padding: "18px 18px 0" }}>
            <h3>Recent Sessions</h3>
            <button className="ghost-button" type="button">View all</button>
          </div>
          <table className="data-table">
            <thead>
              <tr>
                <th>Session</th>
                <th>Topic</th>
                <th>Duration</th>
              </tr>
            </thead>
            <tbody>
              {sessions.map((session) => (
                <tr key={session.id}>
                  <td>{session.name}</td>
                  <td>{session.topic}</td>
                  <td>{session.duration}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>

        <div className="content-card">
          <div className="section-title">
            <h3>Latest Achievements</h3>
            <FiAward />
          </div>
          <div className="grid-2">
            {achievements.slice(0, 2).map((achievement) => (
              <div className="achievement-card" key={achievement.id}>
                <div className="achievement-icon"><FiAward /></div>
                <h3>{achievement.title}</h3>
                <p>{achievement.description}</p>
                <div className="goal-meter">
                  <span style={{ width: `${achievement.progress}%` }} />
                </div>
              </div>
            ))}
          </div>
        </div>
      </section>
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
