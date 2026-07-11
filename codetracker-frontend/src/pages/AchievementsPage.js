import { FiAward, FiClock, FiLock, FiSave, FiTarget, FiZap } from "react-icons/fi";
import DashboardLayout from "../components/DashboardLayout";
import { achievements } from "../data/mockData";

const iconMap = {
  clock: FiClock,
  flame: FiZap,
  target: FiTarget,
  zap: FiZap,
};

export default function AchievementsPage() {
  return (
    <DashboardLayout
      title="Achievements"
      subtitle="Turn consistent learning into visible milestones for your portfolio."
      action={<button className="primary-button" type="button"><FiAward /> View Badges</button>}
    >
      <section className="content-card profile-hero">
        <div className="profile-avatar">D</div>
        <div>
          <p className="section-kicker">Student Developer</p>
          <h3 style={{ margin: 0, color: "#10243b", fontSize: 24 }}>Dev Student</h3>
          <p>Second-year SE student building CodeTracker as a full-stack portfolio project.</p>
        </div>
        <span className="badge badge-success">2 unlocked</span>
      </section>

      <section className="achievement-grid" style={{ marginTop: 16 }}>
        {achievements.map((achievement) => (
          <AchievementCard key={achievement.id} achievement={achievement} />
        ))}
      </section>

      <section className="grid-2" style={{ marginTop: 16 }}>
        <div className="form-panel">
          <div className="section-title">
            <h3>Profile Preferences</h3>
            <FiSave />
          </div>
          <form className="form-grid">
            <div className="form-field">
              <label>Daily Coding Goal</label>
              <input type="number" defaultValue="120" />
            </div>
            <div className="form-field">
              <label>Timezone</label>
              <select defaultValue="Asia/Colombo">
                <option>Asia/Colombo</option>
                <option>UTC</option>
                <option>Asia/Singapore</option>
              </select>
            </div>
            <div className="form-field full">
              <label>Portfolio Note</label>
              <textarea defaultValue="Building CodeTracker with Spring Boot, MySQL, JWT, REST APIs, and React." />
            </div>
            <div className="action-row full">
              <button className="primary-button" type="button"><FiSave /> Save Changes</button>
            </div>
          </form>
        </div>

        <div className="content-card">
          <div className="section-title">
            <h3>Next Unlock</h3>
            <FiLock />
          </div>
          <strong style={{ display: "block", color: "#10243b", fontSize: 28 }}>Seven Day Streak</strong>
          <p>One more consistent coding day unlocks the streak badge.</p>
          <div className="goal-meter">
            <span style={{ width: "71%" }} />
          </div>
        </div>
      </section>
    </DashboardLayout>
  );
}

function AchievementCard({ achievement }) {
  const Icon = iconMap[achievement.icon] || FiAward;

  return (
    <article className={`achievement-card ${achievement.unlocked ? "" : "locked"}`}>
      <div className="achievement-icon">
        <Icon />
      </div>
      <span className={`badge ${achievement.unlocked ? "badge-success" : "badge-neutral"}`}>
        {achievement.unlocked ? "Unlocked" : "Locked"}
      </span>
      <h3>{achievement.title}</h3>
      <p>{achievement.description}</p>
      <div className="goal-meter">
        <span style={{ width: `${achievement.progress}%` }} />
      </div>
    </article>
  );
}
