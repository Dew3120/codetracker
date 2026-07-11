import { NavLink } from "react-router-dom";
import {
  FiAward,
  FiBarChart2,
  FiClock,
  FiCode,
  FiGrid,
  FiLogOut,
  FiSearch,
  FiTarget,
  FiUser,
} from "react-icons/fi";
import "../styles/dashboard.css";

const navItems = [
  { label: "Dashboard", path: "/dashboard", icon: FiGrid },
  { label: "Sessions", path: "/sessions", icon: FiClock },
  { label: "Goals", path: "/goals", icon: FiTarget },
  { label: "Problems", path: "/problems", icon: FiCode },
  { label: "Reports", path: "/reports", icon: FiBarChart2 },
  { label: "Achievements", path: "/achievements", icon: FiAward },
  { label: "Profile", path: "/profile", icon: FiUser },
];

export default function DashboardLayout({ children, title, subtitle, action }) {
  return (
    <div className="app-shell">
      <aside className="app-sidebar">
        <div className="brand-block">
          <div className="brand-mark">CT</div>
          <div>
            <h1>CodeTracker</h1>
            <p>Developer Dashboard</p>
          </div>
        </div>

        <nav className="side-nav" aria-label="Main navigation">
          {navItems.map((item) => {
            const Icon = item.icon;

            return (
              <NavLink key={item.path} to={item.path}>
                <Icon />
                <span>{item.label}</span>
              </NavLink>
            );
          })}
        </nav>

        <div className="sidebar-card">
          <p>Current streak</p>
          <strong>6 days</strong>
          <span>Keep the chain alive today</span>
        </div>
      </aside>

      <div className="app-main">
        <header className="topbar">
          <div className="topbar-search">
            <FiSearch />
            <input placeholder="Search sessions, goals, or problems..." />
          </div>

          <NavLink className="topbar-user topbar-profile-link" to="/profile">
            <div className="user-avatar">D</div>
            <div>
              <strong>Dev Student</strong>
              <span>Second Year SE</span>
            </div>
          </NavLink>

          <button className="icon-button" type="button" aria-label="Logout">
            <FiLogOut />
          </button>
        </header>

        <main className="page-content">
          <section className="page-heading">
            <div>
              <p className="section-kicker">CodeTracker</p>
              <h2>{title}</h2>
              {subtitle && <p>{subtitle}</p>}
            </div>
            {action}
          </section>

          {children}
        </main>

        <nav className="mobile-nav" aria-label="Mobile navigation">
          {navItems.map((item) => {
            const Icon = item.icon;

            return (
              <NavLink key={item.path} to={item.path}>
                <Icon />
                <span>{item.label}</span>
              </NavLink>
            );
          })}
        </nav>
      </div>
    </div>
  );
}