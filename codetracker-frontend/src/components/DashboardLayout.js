import { NavLink, useNavigate } from "react-router-dom";
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
import { useAuth } from "../context/AuthContext";
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

function getDisplayName(user) {
  const fullName = [user?.firstName, user?.lastName].filter(Boolean).join(" ").trim();
  return fullName || user?.username || "Developer";
}

export default function DashboardLayout({ children, title, subtitle, action }) {
  const navigate = useNavigate();
  const { user, logout } = useAuth();
  const displayName = getDisplayName(user);
  const initial = displayName.charAt(0).toUpperCase();

  const handleLogout = () => {
    logout();
    navigate("/login", { replace: true });
  };

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
          <p>Signed in as</p>
          <strong>{initial}</strong>
          <span>{user?.email || "CodeTracker user"}</span>
        </div>
      </aside>

      <div className="app-main">
        <header className="topbar">
          <div className="topbar-search">
            <FiSearch />
            <input placeholder="Search sessions, goals, or problems..." />
          </div>

          <NavLink className="topbar-user topbar-profile-link" to="/profile">
            <div className="user-avatar">{initial}</div>
            <div>
              <strong>{displayName}</strong>
              <span>{user?.timezone || "Asia/Colombo"}</span>
            </div>
          </NavLink>

          <button className="icon-button" type="button" aria-label="Logout" onClick={handleLogout}>
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