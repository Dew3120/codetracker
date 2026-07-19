import { useEffect, useMemo, useState } from "react";
import { FiAward, FiClock, FiLock, FiTarget, FiZap } from "react-icons/fi";
import { achievementsApi } from "../api/achievementsApi";
import { getApiError } from "../api/apiClient";
import DashboardLayout from "../components/DashboardLayout";
import { useAuth } from "../context/AuthContext";

const iconMap = {
  clock: FiClock,
  flame: FiZap,
  target: FiTarget,
  zap: FiZap,
};

function displayName(user) {
  const fullName = [user?.firstName, user?.lastName].filter(Boolean).join(" ").trim();
  return fullName || user?.username || "Developer";
}

export default function AchievementsPage() {
  const { user } = useAuth();
  const [achievements, setAchievements] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState("");

  useEffect(() => {
    let active = true;

    async function loadAchievements() {
      try {
        const response = await achievementsApi.getAchievements();
        if (active) {
          setAchievements(response?.achievements || []);
        }
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

    loadAchievements();

    return () => {
      active = false;
    };
  }, []);

  const earnedCount = useMemo(
    () => achievements.filter((achievement) => achievement.earned).length,
    [achievements]
  );

  const nextAchievement = achievements.find((achievement) => !achievement.earned);
  const name = displayName(user);

  return (
    <DashboardLayout
      title="Achievements"
      subtitle="Turn consistent learning into visible milestones for your portfolio."
      action={<button className="primary-button" type="button"><FiAward /> View Badges</button>}
    >
      {error && <div className="form-alert">{error}</div>}

      <section className="content-card profile-hero">
        <div className="profile-avatar">{name.charAt(0).toUpperCase()}</div>
        <div>
          <p className="section-kicker">Student Developer</p>
          <h3 style={{ margin: 0, color: "#10243b", fontSize: 24 }}>{name}</h3>
          <p>Achievements are awarded by the backend when your sessions, goals, and problems reach each milestone.</p>
        </div>
        <span className="badge badge-success">{earnedCount} unlocked</span>
      </section>

      <section className="achievement-grid" style={{ marginTop: 16 }}>
        {loading ? (
          <article className="achievement-card"><p>Loading achievements...</p></article>
        ) : achievements.length > 0 ? (
          achievements.map((achievement) => (
            <AchievementCard key={achievement.id} achievement={achievement} />
          ))
        ) : (
          <article className="achievement-card"><p>No achievements found yet.</p></article>
        )}
      </section>

      <section className="grid-2" style={{ marginTop: 16 }}>
        <div className="content-card">
          <div className="section-title">
            <h3>Achievement Summary</h3>
            <FiAward />
          </div>
          <strong style={{ display: "block", color: "#10243b", fontSize: 30 }}>{earnedCount} / {achievements.length}</strong>
          <p>Earned badges are calculated from real backend achievement status.</p>
          <div className="goal-meter">
            <span style={{ width: `${achievements.length ? (earnedCount / achievements.length) * 100 : 0}%` }} />
          </div>
        </div>

        <div className="content-card">
          <div className="section-title">
            <h3>Next Unlock</h3>
            <FiLock />
          </div>
          <strong style={{ display: "block", color: "#10243b", fontSize: 28 }}>{nextAchievement?.name || "All caught up"}</strong>
          <p>{nextAchievement?.description || "Keep logging sessions, goals, and problems to maintain your record."}</p>
          <div className="goal-meter">
            <span style={{ width: nextAchievement ? "40%" : "100%" }} />
          </div>
        </div>
      </section>
    </DashboardLayout>
  );
}

function AchievementCard({ achievement }) {
  const Icon = iconMap[achievement.icon] || FiAward;

  return (
    <article className={`achievement-card ${achievement.earned ? "" : "locked"}`}>
      <div className="achievement-icon">
        <Icon />
      </div>
      <span className={`badge ${achievement.earned ? "badge-success" : "badge-neutral"}`}>
        {achievement.earned ? "Unlocked" : "Locked"}
      </span>
      <h3>{achievement.name}</h3>
      <p>{achievement.description}</p>
      <div className="goal-meter">
        <span style={{ width: achievement.earned ? "100%" : "35%" }} />
      </div>
    </article>
  );
}