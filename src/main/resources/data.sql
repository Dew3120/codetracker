INSERT INTO users (username, email, password_hash, first_name, last_name, bio, timezone, daily_goal_minutes, is_active) VALUES
('admin', 'admin@email.com', '$2a$10$NwUvZpGoB9sK7TojDDtaEOuXiIYcCpwhde9q9Xvd/4PldN1BfgYV2', 'Admin', 'User', 'Default local testing account for CodeTracker.', 'Asia/Colombo', 120, TRUE)
ON DUPLICATE KEY UPDATE
username = VALUES(username),
email = VALUES(email),
password_hash = VALUES(password_hash),
first_name = VALUES(first_name),
last_name = VALUES(last_name),
bio = VALUES(bio),
timezone = VALUES(timezone),
daily_goal_minutes = VALUES(daily_goal_minutes),
is_active = VALUES(is_active);
INSERT INTO programming_languages (name, color_hex) VALUES
('Java', '#B07219'),
('Python', '#3572A5'),
('JavaScript', '#F1E05A'),
('TypeScript', '#3178C6'),
('SQL', '#E38C00'),
('HTML/CSS', '#E34C26'),
('C#', '#178600'),
('Dart', '#00B4AB'),
('PHP', '#4F5D95')
ON DUPLICATE KEY UPDATE
color_hex = VALUES(color_hex);

INSERT INTO topics (name, category) VALUES
('Java Fundamentals', 'Backend'),
('Spring Boot', 'Backend'),
('Spring Security', 'Backend'),
('Spring Data JPA', 'Backend'),
('Node.js', 'Backend'),
('Express.js', 'Backend'),
('React.js', 'Frontend'),
('HTML/CSS', 'Frontend'),
('JavaScript ES6+', 'Frontend'),
('TypeScript', 'Frontend'),
('MySQL', 'Database'),
('MongoDB', 'Database'),
('SQL Queries', 'Database'),
('Arrays & Strings', 'DSA'),
('Linked Lists', 'DSA'),
('Stacks & Queues', 'DSA'),
('Trees & Graphs', 'DSA'),
('Sorting Algorithms', 'DSA'),
('Dynamic Programming', 'DSA'),
('Git & GitHub', 'DevOps'),
('Docker', 'DevOps'),
('CI/CD', 'DevOps'),
('Python Basics', 'Backend'),
('Machine Learning', 'Backend'),
('Flutter/Dart', 'Frontend'),
('System Design', 'Other')
ON DUPLICATE KEY UPDATE
category = VALUES(category);

INSERT INTO achievements (name, description, icon, criteria_type, criteria_value) VALUES
('First Steps', 'Log your first coding session', '👶', 'TOTAL_SESSIONS', 1),
('Getting Started', 'Log 10 coding sessions', '🚀', 'TOTAL_SESSIONS', 10),
('Consistent', 'Log 50 coding sessions', '📊', 'TOTAL_SESSIONS', 50),
('Centurion', 'Log 100 coding sessions', '💯', 'TOTAL_SESSIONS', 100),
('On Fire', 'Maintain a 7-day coding streak', '🔥', 'STREAK_DAYS', 7),
('Unstoppable', 'Maintain a 30-day coding streak', '⚡', 'STREAK_DAYS', 30),
('Dedicated', 'Code for 10 total hours', '⏰', 'TOTAL_HOURS', 10),
('Committed', 'Code for 50 total hours', '💪', 'TOTAL_HOURS', 50),
('Master', 'Code for 100 total hours', '🏆', 'TOTAL_HOURS', 100),
('Problem Solver', 'Solve 10 DSA problems', '🧩', 'PROBLEMS_SOLVED', 10),
('Algorithm Expert', 'Solve 50 DSA problems', '🧠', 'PROBLEMS_SOLVED', 50),
('Night Owl', 'Code after midnight', '🦉', 'SPECIAL', 1),
('Early Bird', 'Code before 6 AM', '🐦', 'SPECIAL', 1)
ON DUPLICATE KEY UPDATE
description = VALUES(description),
icon = VALUES(icon),
criteria_type = VALUES(criteria_type),
criteria_value = VALUES(criteria_value);
