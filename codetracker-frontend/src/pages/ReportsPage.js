import { FiBarChart2, FiDownload, FiPieChart, FiTrendingUp } from "react-icons/fi";
import DashboardLayout from "../components/DashboardLayout";
import { topicBreakdown, weeklyHours } from "../data/mockData";

export default function ReportsPage() {
  const maxHours = Math.max(...weeklyHours.map((item) => item.hours));

  return (
    <DashboardLayout
      title="Reports"
      subtitle="Understand your weekly and monthly coding performance."
      action={
        <button className="primary-button" type="button">
          <FiDownload /> Export
        </button>
      }
    >
      <section className="grid-4">
        <ReportStat label="Total Hours" value="42.5h" />
        <ReportStat label="Average / Day" value="1.5h" />
        <ReportStat label="Best Day" value="Saturday" />
        <ReportStat label="Top Topic" value="Spring Boot" />
      </section>

      <section className="grid-2" style={{ marginTop: 16 }}>
        <div className="content-card">
          <div className="section-title">
            <h3>Weekly Report</h3>
            <span className="badge badge-success">+18%</span>
          </div>

          <div className="bar-chart">
            {weeklyHours.map((item) => (
              <div key={item.day}>
                <span style={{ height: `${(item.hours / maxHours) * 100}%` }} />
                <span>{item.day}</span>
              </div>
            ))}
          </div>

          <p className="metric-small">
            Total: 10.5h | Avg: 1.5h/day | Best day: Saturday
          </p>
        </div>

        <div className="content-card">
          <div className="section-title">
            <h3>Monthly Report</h3>
            <span className="badge badge-neutral">July 2026</span>
          </div>

          <div className="grid-2">
            <div className="stat-card">
              <p>Total Hours</p>
              <strong>42.5h</strong>
              <span className="trend-up">+12% vs last month</span>
            </div>

            <div className="stat-card">
              <p>Sessions</p>
              <strong>28</strong>
              <span className="trend-up">7 active days</span>
            </div>

            <div className="stat-card">
              <p>Problems</p>
              <strong>64</strong>
              <span className="trend-up">83% success rate</span>
            </div>

            <div className="stat-card">
              <p>Top Language</p>
              <strong>Java</strong>
              <span className="trend-up">48% usage</span>
            </div>
          </div>
        </div>
      </section>

      <section className="grid-2" style={{ marginTop: 16 }}>
        <div className="content-card">
          <div className="section-title">
            <h3>Topic Breakdown</h3>
            <FiPieChart />
          </div>

          <div style={{ display: "grid", gap: 14 }}>
            {topicBreakdown.map((topic) => (
              <div key={topic.name}>
                <div className="section-title" style={{ marginBottom: 7 }}>
                  <span style={{ fontWeight: 850 }}>{topic.name}</span>
                  <span className="metric-small">{topic.value}%</span>
                </div>

                <div className="goal-meter">
                  <span style={{ width: `${topic.value}%`, background: topic.color }} />
                </div>
              </div>
            ))}
          </div>
        </div>

        <div className="content-card">
          <div className="section-title">
            <h3>Language Distribution</h3>
            <FiPieChart />
          </div>

          <div style={{ display: "grid", gap: 14 }}>
            <DistributionItem name="Java" value={48} color="#2563eb" />
            <DistributionItem name="JavaScript" value={24} color="#14b8a6" />
            <DistributionItem name="SQL" value={18} color="#f59e0b" />
            <DistributionItem name="HTML/CSS" value={10} color="#ef4444" />
          </div>
        </div>
      </section>

      <section className="grid-3" style={{ marginTop: 16 }}>
        <InsightCard
          title="Prime Focus Window"
          value="2 PM - 5 PM"
          text="Highest completion rate happens during afternoon deep-work sessions."
        />
        <InsightCard
          title="Language Split"
          value="Java 48%"
          text="Java leads your coding time, followed by JavaScript and SQL."
        />
        <InsightCard
          title="Consistency"
          value="6 / 7 days"
          text="Your current week is close to a full consistency badge unlock."
        />
      </section>
    </DashboardLayout>
  );
}

function ReportStat({ label, value }) {
  return (
    <article className="stat-card">
      <div className="stat-top">
        <div className="stat-icon">
          <FiBarChart2 />
        </div>
        <span className="trend-up">Report</span>
      </div>
      <p>{label}</p>
      <strong>{value}</strong>
    </article>
  );
}

function DistributionItem({ name, value, color }) {
  return (
    <div>
      <div className="section-title" style={{ marginBottom: 7 }}>
        <span style={{ fontWeight: 850 }}>{name}</span>
        <span className="metric-small">{value}%</span>
      </div>

      <div className="goal-meter">
        <span style={{ width: `${value}%`, background: color }} />
      </div>
    </div>
  );
}

function InsightCard({ title, value, text }) {
  return (
    <article className="content-card">
      <div className="section-title">
        <h3>{title}</h3>
        <FiTrendingUp />
      </div>
      <strong style={{ display: "block", color: "#10243b", fontSize: 24 }}>
        {value}
      </strong>
      <p>{text}</p>
    </article>
  );
}