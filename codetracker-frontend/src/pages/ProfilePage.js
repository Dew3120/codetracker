import { FiLock, FiSave, FiUser } from "react-icons/fi";
import DashboardLayout from "../components/DashboardLayout";

export default function ProfilePage() {
  return (
    <DashboardLayout
      title="Profile"
      subtitle="Manage your account details, timezone, and password."
      action={
        <button className="primary-button" type="button">
          <FiSave /> Save Profile
        </button>
      }
    >
      <section className="content-card profile-hero">
        <div className="profile-avatar">D</div>
        <div>
          <p className="section-kicker">Account</p>
          <h3 style={{ margin: 0, color: "#10243b", fontSize: 24 }}>Dev Student</h3>
          <p>Second-year SE undergraduate building CodeTracker as a full-stack portfolio project.</p>
        </div>
        <span className="badge badge-success">Active</span>
      </section>

      <section className="grid-2" style={{ marginTop: 16 }}>
        <div className="form-panel">
          <div className="section-title">
            <h3>Personal Information</h3>
            <FiUser />
          </div>

          <form className="form-grid">
            <div className="form-field">
              <label>First Name</label>
              <input defaultValue="Dev" />
            </div>

            <div className="form-field">
              <label>Last Name</label>
              <input defaultValue="Student" />
            </div>

            <div className="form-field">
              <label>Username</label>
              <input defaultValue="tdg" />
            </div>

            <div className="form-field">
              <label>Email</label>
              <input defaultValue="tdg@example.com" />
            </div>

            <div className="form-field full">
              <label>Timezone</label>
              <select defaultValue="Asia/Colombo">
                <option>Asia/Colombo</option>
                <option>UTC</option>
                <option>Asia/Singapore</option>
              </select>
            </div>

            <div className="action-row full">
              <button className="primary-button" type="button">
                <FiSave /> Save Changes
              </button>
            </div>
          </form>
        </div>

        <div className="form-panel">
          <div className="section-title">
            <h3>Change Password</h3>
            <FiLock />
          </div>

          <form className="form-grid">
            <div className="form-field full">
              <label>Current Password</label>
              <input type="password" placeholder="Enter current password" />
            </div>

            <div className="form-field full">
              <label>New Password</label>
              <input type="password" placeholder="Enter new password" />
            </div>

            <div className="form-field full">
              <label>Confirm New Password</label>
              <input type="password" placeholder="Confirm new password" />
            </div>

            <div className="action-row full">
              <button className="secondary-button" type="button">
                <FiLock /> Update Password
              </button>
            </div>
          </form>
        </div>
      </section>
    </DashboardLayout>
  );
}