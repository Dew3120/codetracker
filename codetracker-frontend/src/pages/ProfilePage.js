import { useEffect, useState } from "react";
import { FiLock, FiSave, FiUser } from "react-icons/fi";
import { getApiError } from "../api/apiClient";
import { userApi } from "../api/userApi";
import DashboardLayout from "../components/DashboardLayout";
import { useAuth } from "../context/AuthContext";

const passwordInitialState = {
  currentPassword: "",
  newPassword: "",
  confirmPassword: "",
};

function displayName(user) {
  const fullName = [user?.firstName, user?.lastName].filter(Boolean).join(" ").trim();
  return fullName || user?.username || "Developer";
}

export default function ProfilePage() {
  const { user, updateCachedUser } = useAuth();
  const [profile, setProfile] = useState({
    firstName: "",
    lastName: "",
    bio: "",
    timezone: "Asia/Colombo",
    dailyGoalMinutes: 120,
  });
  const [passwordForm, setPasswordForm] = useState(passwordInitialState);
  const [savingProfile, setSavingProfile] = useState(false);
  const [savingPassword, setSavingPassword] = useState(false);
  const [error, setError] = useState("");
  const [message, setMessage] = useState("");

  useEffect(() => {
    if (user) {
      setProfile({
        firstName: user.firstName || "",
        lastName: user.lastName || "",
        bio: user.bio || "",
        timezone: user.timezone || "Asia/Colombo",
        dailyGoalMinutes: user.dailyGoalMinutes || 120,
      });
    }
  }, [user]);

  const handleProfileChange = (event) => {
    setProfile({ ...profile, [event.target.name]: event.target.value });
  };

  const handlePasswordChange = (event) => {
    setPasswordForm({ ...passwordForm, [event.target.name]: event.target.value });
  };

  const handleProfileSubmit = async (event) => {
    event.preventDefault();
    setSavingProfile(true);
    setError("");
    setMessage("");

    try {
      const updatedUser = await userApi.updateProfile({
        firstName: profile.firstName.trim(),
        lastName: profile.lastName.trim(),
        bio: profile.bio.trim(),
        timezone: profile.timezone,
        dailyGoalMinutes: Number(profile.dailyGoalMinutes) || null,
      });
      updateCachedUser(updatedUser);
      setMessage("Profile updated successfully.");
    } catch (apiError) {
      setError(getApiError(apiError));
    } finally {
      setSavingProfile(false);
    }
  };

  const handlePasswordSubmit = async (event) => {
    event.preventDefault();
    setSavingPassword(true);
    setError("");
    setMessage("");

    if (passwordForm.newPassword !== passwordForm.confirmPassword) {
      setSavingPassword(false);
      setError("New password and confirmation do not match.");
      return;
    }

    try {
      await userApi.changePassword({
        currentPassword: passwordForm.currentPassword,
        newPassword: passwordForm.newPassword,
      });
      setPasswordForm(passwordInitialState);
      setMessage("Password updated successfully.");
    } catch (apiError) {
      setError(getApiError(apiError));
    } finally {
      setSavingPassword(false);
    }
  };

  const name = displayName(user);

  return (
    <DashboardLayout
      title="Profile"
      subtitle="Manage your account details, timezone, and password."
      action={
        <button className="primary-button" type="button" onClick={handleProfileSubmit} disabled={savingProfile}>
          <FiSave /> {savingProfile ? "Saving..." : "Save Profile"}
        </button>
      }
    >
      {error && <div className="form-alert">{error}</div>}
      {message && <div className="form-alert success">{message}</div>}

      <section className="content-card profile-hero">
        <div className="profile-avatar">{name.charAt(0).toUpperCase()}</div>
        <div>
          <p className="section-kicker">Account</p>
          <h3 style={{ margin: 0, color: "#10243b", fontSize: 24 }}>{name}</h3>
          <p>{user?.email || "Profile loaded from your authenticated backend session."}</p>
        </div>
        <span className="badge badge-success">Active</span>
      </section>

      <section className="grid-2" style={{ marginTop: 16 }}>
        <div className="form-panel">
          <div className="section-title">
            <h3>Personal Information</h3>
            <FiUser />
          </div>

          <form className="form-grid" onSubmit={handleProfileSubmit}>
            <div className="form-field">
              <label>First Name</label>
              <input name="firstName" value={profile.firstName} onChange={handleProfileChange} />
            </div>

            <div className="form-field">
              <label>Last Name</label>
              <input name="lastName" value={profile.lastName} onChange={handleProfileChange} />
            </div>

            <div className="form-field">
              <label>Username</label>
              <input value={user?.username || ""} readOnly />
            </div>

            <div className="form-field">
              <label>Email</label>
              <input value={user?.email || ""} readOnly />
            </div>

            <div className="form-field">
              <label>Timezone</label>
              <select name="timezone" value={profile.timezone} onChange={handleProfileChange}>
                <option>Asia/Colombo</option>
                <option>UTC</option>
                <option>Asia/Singapore</option>
              </select>
            </div>

            <div className="form-field">
              <label>Daily Goal Minutes</label>
              <input name="dailyGoalMinutes" type="number" min="1" max="1440" value={profile.dailyGoalMinutes} onChange={handleProfileChange} />
            </div>

            <div className="form-field full">
              <label>Bio</label>
              <textarea name="bio" value={profile.bio} onChange={handleProfileChange} placeholder="Tell your future self what you are building." />
            </div>

            <div className="action-row full">
              <button className="primary-button" type="submit" disabled={savingProfile}>
                <FiSave /> {savingProfile ? "Saving..." : "Save Changes"}
              </button>
            </div>
          </form>
        </div>

        <div className="form-panel">
          <div className="section-title">
            <h3>Change Password</h3>
            <FiLock />
          </div>

          <form className="form-grid" onSubmit={handlePasswordSubmit}>
            <div className="form-field full">
              <label>Current Password</label>
              <input name="currentPassword" type="password" value={passwordForm.currentPassword} onChange={handlePasswordChange} placeholder="Enter current password" />
            </div>

            <div className="form-field full">
              <label>New Password</label>
              <input name="newPassword" type="password" value={passwordForm.newPassword} onChange={handlePasswordChange} placeholder="At least 8 characters with uppercase, lowercase, and number" />
            </div>

            <div className="form-field full">
              <label>Confirm New Password</label>
              <input name="confirmPassword" type="password" value={passwordForm.confirmPassword} onChange={handlePasswordChange} placeholder="Confirm new password" />
            </div>

            <div className="action-row full">
              <button className="secondary-button" type="submit" disabled={savingPassword}>
                <FiLock /> {savingPassword ? "Updating..." : "Update Password"}
              </button>
            </div>
          </form>
        </div>
      </section>
    </DashboardLayout>
  );
}