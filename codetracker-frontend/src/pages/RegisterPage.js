import { useMemo, useState } from "react";
import { Link, useNavigate } from "react-router-dom";
import {
  FiArrowRight,
  FiBarChart2,
  FiCheckCircle,
  FiClock,
  FiLock,
  FiTarget,
  FiTerminal,
  FiTrendingUp,
} from "react-icons/fi";
import { getApiError } from "../api/apiClient";
import { useAuth } from "../context/AuthContext";
import forestBackground from "../assets/forest-auth.png";
import "../styles/auth.css";

function getPasswordStrength(password) {
  let score = 0;
  if (password.length >= 8) score += 1;
  if (/[A-Z]/.test(password)) score += 1;
  if (/[a-z]/.test(password)) score += 1;
  if (/[0-9]/.test(password)) score += 1;
  return score;
}

export default function RegisterPage() {
  const navigate = useNavigate();
  const { register } = useAuth();
  const [form, setForm] = useState({
    firstName: "",
    lastName: "",
    username: "",
    email: "",
    password: "",
    confirmPassword: "",
  });
  const [error, setError] = useState("");
  const [submitting, setSubmitting] = useState(false);

  const strength = useMemo(() => getPasswordStrength(form.password), [form.password]);
  const passwordsMatch = form.confirmPassword && form.password === form.confirmPassword;
  const strengthLabels = ["Password strength", "Weak password", "Fair password", "Good password", "Strong password"];

  const handleChange = (event) => {
    setForm({ ...form, [event.target.name]: event.target.value });
  };

  const handleSubmit = async (event) => {
    event.preventDefault();
    setError("");

    if (form.password !== form.confirmPassword) {
      setError("Passwords do not match.");
      return;
    }

    if (strength < 4) {
      setError("Password must be at least 8 characters and include uppercase, lowercase, and a number.");
      return;
    }

    setSubmitting(true);

    try {
      await register({
        firstName: form.firstName.trim(),
        lastName: form.lastName.trim(),
        username: form.username.trim(),
        email: form.email.trim(),
        password: form.password,
      });
      navigate("/dashboard", { replace: true });
    } catch (apiError) {
      setError(getApiError(apiError));
    } finally {
      setSubmitting(false);
    }
  };

  return (
    <main className="auth-page">
      <section className="auth-shell" aria-label="Create CodeTracker account">
        <aside
          className="auth-showcase"
          style={{ "--forest-bg": `url(${forestBackground})` }}
        >
          <div className="living-scene" aria-hidden="true">
            <span className="bird bird-one" />
            <span className="bird bird-two" />
            <span className="bird bird-three" />
            <span className="firefly firefly-one" />
            <span className="firefly firefly-two" />
            <span className="firefly firefly-three" />
            <span className="firefly firefly-four" />
          </div>

          <div className="showcase-topline">
            <span className="showcase-dot" />
            CodeTracker
          </div>

          <div className="showcase-copy">
            <p className="eyebrow">Build the habit</p>
            <h2>Track every focused coding hour with clarity.</h2>
            <p>
              Sessions, problems, streaks, reports, and achievements in one calm dashboard built for daily progress.
            </p>
          </div>

          <div className="showcase-card">
            <div className="showcase-card-header">
              <span>Chapter 13</span>
              <strong>API</strong>
            </div>
            <div className="mini-chart" aria-hidden="true">
              <span style={{ height: "38%" }} />
              <span style={{ height: "62%" }} />
              <span style={{ height: "46%" }} />
              <span style={{ height: "78%" }} />
              <span style={{ height: "55%" }} />
              <span style={{ height: "88%" }} />
              <span style={{ height: "64%" }} />
            </div>
          </div>

          <div className="showcase-stats">
            <div>
              <FiClock />
              <span>Daily sessions</span>
            </div>
            <div>
              <FiTarget />
              <span>Goal progress</span>
            </div>
            <div>
              <FiTrendingUp />
              <span>Streak growth</span>
            </div>
          </div>
        </aside>

        <section className="auth-panel">
          <div className="auth-brand">
            <div className="auth-logo">
              <FiTerminal />
            </div>
            <p className="auth-kicker">Create account</p>
            <h1>Start tracking smarter</h1>
            <p>Create your account and turn your coding practice into measurable progress.</p>
          </div>

          <form className="auth-form" onSubmit={handleSubmit}>
            {error && <div className="auth-alert">{error}</div>}

            <div className="auth-grid">
              <label>
                <span>First Name</span>
                <input name="firstName" value={form.firstName} onChange={handleChange} placeholder="Linus" />
              </label>

              <label>
                <span>Last Name</span>
                <input name="lastName" value={form.lastName} onChange={handleChange} placeholder="Torvalds" />
              </label>
            </div>

            <label>
              <span>Username</span>
              <input name="username" value={form.username} onChange={handleChange} placeholder="dev_explorer" required />
            </label>

            <label>
              <span>Email Address</span>
              <input name="email" type="email" value={form.email} onChange={handleChange} placeholder="name@example.com" required />
            </label>

            <label>
              <span>Password</span>
              <input name="password" type="password" value={form.password} onChange={handleChange} placeholder="At least 8 characters" required />
            </label>

            <div className="password-meter-wrap">
              <div className="password-meter">
                <div style={{ width: `${strength * 25}%` }} className={`meter-fill strength-${strength}`} />
              </div>
              <span>{strengthLabels[strength]}</span>
            </div>

            <label>
              <span>Confirm Password</span>
              <div className="input-status">
                <input name="confirmPassword" type="password" value={form.confirmPassword} onChange={handleChange} placeholder="Confirm password" required />
                {passwordsMatch && <FiCheckCircle />}
              </div>
            </label>

            <button className="auth-submit" type="submit" disabled={submitting}>
              {submitting ? "Creating account..." : "Create Account"} <FiArrowRight />
            </button>
          </form>

          <div className="auth-trust">
            <span><FiLock /> Secure account</span>
            <span><FiBarChart2 /> Progress analytics</span>
          </div>

          <p className="auth-switch">
            Already have an account? <Link to="/login">Login here</Link>
          </p>
        </section>
      </section>
    </main>
  );
}