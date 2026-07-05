-- CodeTracker Chapter 9 database alignment migration.
-- Run from the project root with:
-- mysql -uroot -p codetracker_db < migration_ch9.sql

ALTER TABLE users
  MODIFY COLUMN username VARCHAR(50) NOT NULL AFTER id,
  MODIFY COLUMN email VARCHAR(100) NOT NULL AFTER username,
  MODIFY COLUMN password_hash VARCHAR(255) NOT NULL AFTER email,
  MODIFY COLUMN first_name VARCHAR(50) DEFAULT NULL AFTER password_hash,
  MODIFY COLUMN last_name VARCHAR(50) DEFAULT NULL AFTER first_name,
  MODIFY COLUMN bio TEXT DEFAULT NULL AFTER last_name,
  MODIFY COLUMN avatar_url VARCHAR(255) DEFAULT NULL AFTER bio,
  MODIFY COLUMN timezone VARCHAR(50) DEFAULT 'Asia/Colombo' AFTER avatar_url,
  MODIFY COLUMN daily_goal_minutes INT DEFAULT 120 AFTER timezone,
  MODIFY COLUMN is_active BOOLEAN DEFAULT TRUE AFTER daily_goal_minutes,
  MODIFY COLUMN created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP AFTER is_active,
  MODIFY COLUMN updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP AFTER created_at;

ALTER TABLE topics
  MODIFY COLUMN name VARCHAR(100) NOT NULL AFTER id,
  MODIFY COLUMN category VARCHAR(50) NOT NULL AFTER name,
  MODIFY COLUMN description TEXT DEFAULT NULL AFTER category,
  MODIFY COLUMN created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP AFTER description;

ALTER TABLE programming_languages
  MODIFY COLUMN name VARCHAR(50) NOT NULL AFTER id,
  MODIFY COLUMN color_hex VARCHAR(7) NOT NULL DEFAULT '#808080' AFTER name;

ALTER TABLE coding_sessions
  MODIFY COLUMN user_id BIGINT NOT NULL AFTER id,
  MODIFY COLUMN topic_id BIGINT DEFAULT NULL AFTER user_id,
  MODIFY COLUMN language_id BIGINT DEFAULT NULL AFTER topic_id,
  MODIFY COLUMN session_date DATE NOT NULL AFTER language_id,
  MODIFY COLUMN start_time TIME DEFAULT NULL AFTER session_date,
  MODIFY COLUMN end_time TIME DEFAULT NULL AFTER start_time,
  MODIFY COLUMN duration_minutes INT NOT NULL AFTER end_time,
  MODIFY COLUMN notes TEXT DEFAULT NULL AFTER duration_minutes,
  MODIFY COLUMN is_timer_session BOOLEAN DEFAULT FALSE AFTER notes,
  MODIFY COLUMN created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP AFTER is_timer_session,
  MODIFY COLUMN updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP AFTER created_at;

ALTER TABLE daily_goals
  MODIFY COLUMN user_id BIGINT NOT NULL AFTER id,
  MODIFY COLUMN goal_date DATE NOT NULL AFTER user_id,
  MODIFY COLUMN target_minutes INT NOT NULL AFTER goal_date,
  MODIFY COLUMN achieved_minutes INT DEFAULT 0 AFTER target_minutes,
  MODIFY COLUMN is_completed BOOLEAN DEFAULT FALSE AFTER achieved_minutes,
  MODIFY COLUMN created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP AFTER is_completed;

SET @daily_goal_index := (
  SELECT INDEX_NAME
  FROM INFORMATION_SCHEMA.STATISTICS
  WHERE TABLE_SCHEMA = DATABASE()
    AND TABLE_NAME = 'daily_goals'
    AND NON_UNIQUE = 0
    AND INDEX_NAME <> 'PRIMARY'
  GROUP BY INDEX_NAME
  HAVING GROUP_CONCAT(COLUMN_NAME ORDER BY SEQ_IN_INDEX) = 'user_id,goal_date'
  LIMIT 1
);
SET @daily_goal_sql := IF(
  @daily_goal_index IS NULL OR @daily_goal_index = 'unique_user_date',
  'SELECT 1',
  CONCAT('ALTER TABLE daily_goals RENAME INDEX `', @daily_goal_index, '` TO unique_user_date')
);
PREPARE daily_goal_stmt FROM @daily_goal_sql;
EXECUTE daily_goal_stmt;
DEALLOCATE PREPARE daily_goal_stmt;

ALTER TABLE problems_solved
  MODIFY COLUMN user_id BIGINT NOT NULL AFTER id,
  MODIFY COLUMN session_id BIGINT DEFAULT NULL AFTER user_id,
  MODIFY COLUMN platform VARCHAR(50) NOT NULL AFTER session_id,
  MODIFY COLUMN problem_name VARCHAR(200) NOT NULL AFTER platform,
  MODIFY COLUMN problem_url VARCHAR(500) DEFAULT NULL AFTER problem_name,
  MODIFY COLUMN difficulty ENUM('EASY','MEDIUM','HARD') NOT NULL AFTER problem_url,
  MODIFY COLUMN is_solved BOOLEAN DEFAULT FALSE AFTER difficulty,
  MODIFY COLUMN time_taken_minutes INT DEFAULT NULL AFTER is_solved,
  MODIFY COLUMN notes TEXT DEFAULT NULL AFTER time_taken_minutes,
  MODIFY COLUMN solved_date DATE NOT NULL AFTER notes,
  MODIFY COLUMN created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP AFTER solved_date;

ALTER TABLE achievements
  MODIFY COLUMN name VARCHAR(100) NOT NULL AFTER id,
  MODIFY COLUMN description TEXT NOT NULL AFTER name,
  MODIFY COLUMN icon VARCHAR(50) NOT NULL AFTER description,
  MODIFY COLUMN criteria_type VARCHAR(50) NOT NULL AFTER icon,
  MODIFY COLUMN criteria_value INT NOT NULL AFTER criteria_type;

ALTER TABLE user_achievements
  MODIFY COLUMN user_id BIGINT NOT NULL AFTER id,
  MODIFY COLUMN achievement_id BIGINT NOT NULL AFTER user_id,
  MODIFY COLUMN earned_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP AFTER achievement_id;

SET @user_achievement_index := (
  SELECT INDEX_NAME
  FROM INFORMATION_SCHEMA.STATISTICS
  WHERE TABLE_SCHEMA = DATABASE()
    AND TABLE_NAME = 'user_achievements'
    AND NON_UNIQUE = 0
    AND INDEX_NAME <> 'PRIMARY'
  GROUP BY INDEX_NAME
  HAVING GROUP_CONCAT(COLUMN_NAME ORDER BY SEQ_IN_INDEX) = 'user_id,achievement_id'
  LIMIT 1
);
SET @user_achievement_sql := IF(
  @user_achievement_index IS NULL OR @user_achievement_index = 'unique_user_achievement',
  'SELECT 1',
  CONCAT('ALTER TABLE user_achievements RENAME INDEX `', @user_achievement_index, '` TO unique_user_achievement')
);
PREPARE user_achievement_stmt FROM @user_achievement_sql;
EXECUTE user_achievement_stmt;
DEALLOCATE PREPARE user_achievement_stmt;
