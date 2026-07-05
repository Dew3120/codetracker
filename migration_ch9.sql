-- 1. Remove zombie table (0 rows, safe)
DROP TABLE IF EXISTS problems_solved;

-- 2. Rename problems -> problems_solved to match doc table name
RENAME TABLE problems TO problems_solved;

-- 3. Fix problems_solved structure (0 rows, safe to tighten)
ALTER TABLE problems_solved
  ADD COLUMN session_id BIGINT DEFAULT NULL AFTER problem_url,
  MODIFY COLUMN platform VARCHAR(50) NOT NULL,
  MODIFY COLUMN difficulty ENUM('EASY','MEDIUM','HARD') NOT NULL,
  MODIFY COLUMN is_solved BIT(1) NOT NULL DEFAULT b'0',
  MODIFY COLUMN solved_date DATE NOT NULL,
  MODIFY COLUMN user_id BIGINT NOT NULL;

ALTER TABLE problems_solved DROP FOREIGN KEY FKne4c7i14qvkkhybrqx30td8s3;
ALTER TABLE problems_solved
  ADD CONSTRAINT fk_problems_solved_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  ADD CONSTRAINT fk_problems_solved_session FOREIGN KEY (session_id) REFERENCES coding_sessions(id) ON DELETE SET NULL;

-- 4. users: add missing columns, fix defaults and lengths
ALTER TABLE users
  ADD COLUMN is_active BOOLEAN NOT NULL DEFAULT TRUE AFTER daily_goal_minutes,
  ADD COLUMN updated_at DATETIME(6) DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6) AFTER created_at,
  MODIFY COLUMN created_at DATETIME(6) DEFAULT CURRENT_TIMESTAMP(6),
  MODIFY COLUMN daily_goal_minutes INT DEFAULT 120,
  MODIFY COLUMN username VARCHAR(50) NOT NULL,
  MODIFY COLUMN email VARCHAR(100) NOT NULL,
  MODIFY COLUMN first_name VARCHAR(50) DEFAULT NULL,
  MODIFY COLUMN last_name VARCHAR(50) DEFAULT NULL,
  MODIFY COLUMN timezone VARCHAR(50) DEFAULT 'Asia/Colombo';

-- 5. coding_sessions: nullable topic/language + correct FK cascade behavior
ALTER TABLE coding_sessions
  MODIFY COLUMN topic_id BIGINT DEFAULT NULL,
  MODIFY COLUMN language_id BIGINT DEFAULT NULL;

ALTER TABLE coding_sessions DROP FOREIGN KEY FK3d8cdtvk2lsy1yue3jbedm1dh;
ALTER TABLE coding_sessions ADD CONSTRAINT fk_sessions_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;

ALTER TABLE coding_sessions DROP FOREIGN KEY FKl3lbtx74le1448s0c6tivkova;
ALTER TABLE coding_sessions ADD CONSTRAINT fk_sessions_topic FOREIGN KEY (topic_id) REFERENCES topics(id) ON DELETE SET NULL;

ALTER TABLE coding_sessions DROP FOREIGN KEY FKk5ajfdmrwe1tbuieh61t6mmwo;
ALTER TABLE coding_sessions ADD CONSTRAINT fk_sessions_language FOREIGN KEY (language_id) REFERENCES programming_languages(id) ON DELETE SET NULL;

-- 6. daily_goals: correct FK cascade
ALTER TABLE daily_goals DROP FOREIGN KEY FKt09st00y8w50mhd1aqpj5wyav;
ALTER TABLE daily_goals ADD CONSTRAINT fk_goals_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;

-- 7. user_achievements: correct FK cascade on both sides
ALTER TABLE user_achievements DROP FOREIGN KEY FK6vt5fpu0uta41vny1x6vpk45k;
ALTER TABLE user_achievements ADD CONSTRAINT fk_ua_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;

ALTER TABLE user_achievements DROP FOREIGN KEY FK8ipvec6cs8t3g8515thtlsxuf;
ALTER TABLE user_achievements ADD CONSTRAINT fk_ua_achievement FOREIGN KEY (achievement_id) REFERENCES achievements(id) ON DELETE CASCADE;

-- 8. achievements: add the 2 missing SPECIAL achievements from doc (13 total)
INSERT INTO achievements (name, description, icon, criteria_type, criteria_value)
SELECT 'Night Owl', 'Code after midnight', 'NightOwl', 'SPECIAL', 1
WHERE NOT EXISTS (SELECT 1 FROM achievements WHERE name = 'Night Owl');

INSERT INTO achievements (name, description, icon, criteria_type, criteria_value)
SELECT 'Early Bird', 'Code before 6 AM', 'EarlyBird', 'SPECIAL', 1
WHERE NOT EXISTS (SELECT 1 FROM achievements WHERE name = 'Early Bird');
