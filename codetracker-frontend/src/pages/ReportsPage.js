import { useEffect, useMemo, useState } from "react";
import { FiBarChart2, FiDownload, FiPieChart, FiTrendingUp } from "react-icons/fi";
import { getApiError } from "../api/apiClient";
import { reportsApi } from "../api/reportsApi";
import DashboardLayout from "../components/DashboardLayout";
import { currentMonthValue, minutesToHoursLabel } from "../utils/formatters";

const emptyWeek = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"].map((day) => ({ day, hours: 0 }));

export default function ReportsPage() {
  const [weekly, setWeekly] = useState(null);
  const [monthly, setMonthly] = useState(null);
  const [languages, setLanguages] = useState([]);
  const [topics, setTopics] = useState([]);
  const [month, setMonth] = useState(currentMonthValue());
  const [error, setError] = useState("");
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    let active = true;

    async function loadReports() {
      setLoading(true);
      setError("");

      try {
        const [weeklyReport, monthlyReport, languageReport, topicReport] = await Promise.all([
          reportsApi.getWeeklyReport(),
          reportsApi.getMonthlyReport(month),
          reportsApi.getLanguageDistribution(),
          reportsApi.getTopicBreakdown(),
        ]);

        if (!active) return;
        setWeekly(weeklyReport);
        setMonthly(monthlyReport);
        setLanguages(languageReport?.languageStats || []);
        setTopics(topicReport?.topicStats || []);
      } catch (apiError) {
        if (active) {
          setError(getApiError(apiError));
        }
      } finally {
        if (active) {
          setLoading(false);
        }
      }
    }

    loadReports();

    return () => {
      active = false;
    };
  }, [month]);

  const weeklyHours = useMemo(() => {
    if (!weekly?.dailyBreakdown?.length) {
      return emptyWeek;
    }

    return weekly.dailyBreakdown.map((item) => ({
      day: item.day?.slice(0, 3) || "",
      hours: Math.round((item.minutes / 60) * 10) / 10,
    }));
  }, [weekly]);

  const maxHours = Math.max(1, ...weeklyHours.map((item) => item.hours));
  const bestDay = weekly?.dailyBreakdown?.reduce((best, item) => (item.minutes > (best?.minutes || 0) ? item : best), null);
  const totalTopicMinutes = topics.reduce((total, topic) => total + (topic.minutes || 0), 0);
  const totalLanguageMinutes = languages.reduce((total, language) => total + (language.minutes || 0), 0);

  const handleExport = () => {
    const reportData = {
      weekly,
      monthly,
      languages,
      topics,
    };
    const blob = new Blob([JSON.stringify(reportData, null, 2)], { type: "application/json" });
    const url = URL.createObjectURL(blob);
    const link = document.createElement("a");
    link.href = url;
    link.download = "codetracker-report.json";
    link.click();
    URL.revokeObjectURL(url);
  };

  return (
    <DashboardLayout
      title="Reports"
      subtitle="Understand your weekly and monthly coding performance."
      action={
        <button className="primary-button" type="button" onClick={handleExport}>
          <FiDownload /> Export
        </button>
      }
    >
      {error && <div className="form-alert">{error}</div>}

      <section className="grid-4">
        <ReportStat label="Total Hours" value={minutesToHoursLabel(weekly?.totalMinutes || 0)} />
        <ReportStat label="Average / Day" value={minutesToHoursLabel(weekly?.averageMinutesPerDay || 0)} />
        <ReportStat label="Best Day" value={bestDay?.day || "-"} />
        <ReportStat label="Top Topic" value={weekly?.topTopic || "-"} />
      </section>

      <section className="grid-2" style={{ marginTop: 16 }}>
        <div className="content-card">
          <div className="section-title">
            <h3>Weekly Report</h3>
            <span className="badge badge-success">{weekly?.totalSessions || 0} sessions</span>
          </div>

          <div className="bar-chart">
            {weeklyHours.map((item) => (
              <div key={item.day}>
                <span style={{ height: `${Math.max((item.hours / maxHours) * 100, item.hours > 0 ? 12 : 0)}%` }} />
                <span>{item.day}</span>
              </div>
            ))}
          </div>

          <p className="metric-small">
            Total: {minutesToHoursLabel(weekly?.totalMinutes || 0)} | Avg: {minutesToHoursLabel(weekly?.averageMinutesPerDay || 0)}/day | Best day: {bestDay?.day || "-"}
          </p>
        </div>

        <div className="content-card">
          <div className="section-title">
            <h3>Monthly Report</h3>
            <input className="compact-input" type="month" value={month} onChange={(event) => setMonth(event.target.value)} />
          </div>

          <div className="grid-2">
            <div className="stat-card">
              <p>Total Hours</p>
              <strong>{minutesToHoursLabel(monthly?.totalMinutes || 0)}</strong>
              <span className="trend-up">selected month</span>
            </div>

            <div className="stat-card">
              <p>Sessions</p>
              <strong>{monthly?.totalSessions || 0}</strong>
              <span className="trend-up">{monthly?.dailyBreakdown?.filter((day) => day.minutes > 0).length || 0} active days</span>
            </div>

            <div className="stat-card">
              <p>Top Language</p>
              <strong>{weekly?.topLanguage || "-"}</strong>
              <span className="trend-up">this week</span>
            </div>

            <div className="stat-card">
              <p>Loading</p>
              <strong>{loading ? "Yes" : "No"}</strong>
              <span className="trend-up">API status</span>
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
            {topics.length > 0 ? (
              topics.map((topic) => {
                const value = totalTopicMinutes ? Math.round((topic.minutes / totalTopicMinutes) * 100) : 0;
                return <DistributionItem key={topic.topic} name={topic.topic} value={value} color="#2563eb" />;
              })
            ) : (
              <p className="empty-text">No topic data yet.</p>
            )}
          </div>
        </div>

        <div className="content-card">
          <div className="section-title">
            <h3>Language Distribution</h3>
            <FiPieChart />
          </div>

          <div style={{ display: "grid", gap: 14 }}>
            {languages.length > 0 ? (
              languages.map((language) => {
                const value = totalLanguageMinutes ? Math.round((language.minutes / totalLanguageMinutes) * 100) : 0;
                return <DistributionItem key={language.language} name={language.language} value={value} color={language.color || "#14b8a6"} />;
              })
            ) : (
              <p className="empty-text">No language data yet.</p>
            )}
          </div>
        </div>
      </section>

      <section className="grid-3" style={{ marginTop: 16 }}>
        <InsightCard title="Weekly Focus" value={weekly?.topTopic || "Start logging"} text="Your strongest topic is calculated from real coding sessions." />
        <InsightCard title="Language Split" value={weekly?.topLanguage || "No data"} text="Language distribution updates when sessions are saved with a language." />
        <InsightCard title="Consistency" value={`${weekly?.totalSessions || 0} sessions`} text="Use goals and session logs together to unlock stronger streak reports." />
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
        <span className="trend-up">Live</span>
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