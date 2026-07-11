import { useState } from "react";
import { Link, useNavigate } from "react-router-dom";
import { FiArrowRight, FiBarChart2, FiClock, FiLock, FiTerminal, FiTrendingUp } from "react-icons/fi";
import forestBackground from "../assets/forest-auth.png";
import "../styles/auth.css";

export default function LoginPage() {
  const navigate = useNavigate();
  const [form, setForm] = useState({ email: "tdg", password: "tdg" });

  const handleChange = (event) => {
    setForm({ ...form, [event.target.name]: event.target.value });
  };

  const handleSubmit = (event) => {
    event.preventDefault();
    console.log("Login payload:", form);
    navigate("/dashboard");
  };

  return (
    <main className="auth-page">
      <section className="auth-shell auth-shell-login" aria-label="Login to CodeTracker">
        <aside className="auth-showcase" style={{ "--forest-bg": `url(${forestBackground})` }}>
          <div className="living-scene" aria-hidden="true">
            <span className="bird bird-one" />
            <span className="bird bird-two" />
            <span className="firefly firefly-one" />
            <span className="firefly firefly-two" />
            <span className="firefly firefly-three" />
          </div>

          <div className="showcase-topline">
            <span className="showcase-dot" />
            CodeTracker
          </div>

          <div className="showcase-copy">
            <p className="eyebrow">Welcome back</p>
            <h2>Your coding momentum is waiting.</h2>
            <p>Review sessions, goals, problems, reports, and achievements from one focused workspace.</p>
          </div>

          <div className="showcase-stats">
            <div>
              <FiClock />
              <span>10.5 hours this week</span>
            </div>
            <div>
              <FiTrendingUp />
              <span>6 day active streak</span>
            </div>
            <div>
              <FiBarChart2 />
              <span>64 problems tracked</span>
            </div>
          </div>
        </aside>

        <section className="auth-panel">
          <div className="auth-brand">
            <div className="auth-logo">
              <FiTerminal />
            </div>
            <p className="auth-kicker">Login</p>
            <h1>Welcome back</h1>
            <p>Sign in and continue tracking your development journey.</p>
          </div>

          <form className="auth-form" onSubmit={handleSubmit} noValidate>
            <label>
              <span>Email Address</span>
              <input name="email" type="email" value={form.email} onChange={handleChange} placeholder="name@example.com" required />
            </label>

            <label>
              <span>Password</span>
              <input name="password" type="password" value={form.password} onChange={handleChange} placeholder="Enter password" required />
            </label>

            <button className="auth-submit" type="submit">
              Login <FiArrowRight />
            </button>
          </form>

          <div className="auth-trust">
            <span><FiLock /> JWT secured</span>
            <span><FiBarChart2 /> Progress dashboard</span>
          </div>

          <p className="auth-switch">
            New to CodeTracker? <Link to="/register">Create account</Link>
          </p>
        </section>
      </section>
    </main>
  );
}
