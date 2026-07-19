-- CodeTracker admin demo seed
-- Purpose: create 100 days of realistic local/demo activity for admin@email.com.
-- Login after running: admin@email.com / admin123
-- Safe to rerun: DEMO100 sessions/problems are cleared before reinsert.

START TRANSACTION;

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

SET @admin_id := (SELECT id FROM users WHERE email = 'admin@email.com' LIMIT 1);

DELETE FROM problems_solved WHERE user_id = @admin_id AND notes LIKE 'DEMO100:%';
DELETE FROM coding_sessions WHERE user_id = @admin_id AND notes LIKE 'DEMO100:%';

-- Day 1: 2026-04-11
INSERT INTO daily_goals (user_id, goal_date, target_minutes, achieved_minutes, is_completed, created_at) VALUES
(@admin_id, '2026-04-11', 90, 110, TRUE, '2026-04-11 06:15:00')
ON DUPLICATE KEY UPDATE
target_minutes = VALUES(target_minutes),
achieved_minutes = VALUES(achieved_minutes),
is_completed = VALUES(is_completed);
INSERT INTO coding_sessions (user_id, topic_id, language_id, session_date, start_time, end_time, duration_minutes, notes, is_timer_session, created_at, updated_at) VALUES
(@admin_id, (SELECT id FROM topics WHERE name = 'Spring Boot' LIMIT 1), (SELECT id FROM programming_languages WHERE name = 'Java' LIMIT 1), '2026-04-11', '08:00:00', '09:50:00', 110, 'DEMO100: implemented backend endpoint and verified request flow.', TRUE, '2026-04-11 09:50:00', '2026-04-11 09:50:00');
SET @demo_session_id := LAST_INSERT_ID();
INSERT INTO problems_solved (user_id, session_id, platform, problem_name, problem_url, difficulty, is_solved, time_taken_minutes, notes, solved_date, created_at) VALUES
(@admin_id, @demo_session_id, 'LeetCode', 'Two Sum', 'https://leetcode.com/problems/two-sum/', 'HARD', FALSE, 75, 'DEMO100: attempted during the 100-day practice streak.', '2026-04-11', '2026-04-11 10:10:00');
INSERT INTO problems_solved (user_id, session_id, platform, problem_name, problem_url, difficulty, is_solved, time_taken_minutes, notes, solved_date, created_at) VALUES
(@admin_id, @demo_session_id, 'HackerRank', 'Flood Fill', 'https://www.hackerrank.com/challenges/flood-fill/problem', 'MEDIUM', TRUE, 28, 'DEMO100: solved as a stretch problem after the main session.', '2026-04-11', '2026-04-11 10:25:00');

-- Day 2: 2026-04-12
INSERT INTO daily_goals (user_id, goal_date, target_minutes, achieved_minutes, is_completed, created_at) VALUES
(@admin_id, '2026-04-12', 90, 122, TRUE, '2026-04-12 06:15:00')
ON DUPLICATE KEY UPDATE
target_minutes = VALUES(target_minutes),
achieved_minutes = VALUES(achieved_minutes),
is_completed = VALUES(is_completed);
INSERT INTO coding_sessions (user_id, topic_id, language_id, session_date, start_time, end_time, duration_minutes, notes, is_timer_session, created_at, updated_at) VALUES
(@admin_id, (SELECT id FROM topics WHERE name = 'React.js' LIMIT 1), (SELECT id FROM programming_languages WHERE name = 'JavaScript' LIMIT 1), '2026-04-12', '08:19:00', '10:21:00', 122, 'DEMO100: refactored frontend state handling and tested the page.', FALSE, '2026-04-12 10:21:00', '2026-04-12 10:21:00');
SET @demo_session_id := LAST_INSERT_ID();

-- Day 3: 2026-04-13
INSERT INTO daily_goals (user_id, goal_date, target_minutes, achieved_minutes, is_completed, created_at) VALUES
(@admin_id, '2026-04-13', 120, 199, TRUE, '2026-04-13 06:15:00')
ON DUPLICATE KEY UPDATE
target_minutes = VALUES(target_minutes),
achieved_minutes = VALUES(achieved_minutes),
is_completed = VALUES(is_completed);
INSERT INTO coding_sessions (user_id, topic_id, language_id, session_date, start_time, end_time, duration_minutes, notes, is_timer_session, created_at, updated_at) VALUES
(@admin_id, (SELECT id FROM topics WHERE name = 'MySQL' LIMIT 1), (SELECT id FROM programming_languages WHERE name = 'SQL' LIMIT 1), '2026-04-13', '08:38:00', '11:03:00', 145, 'DEMO100: wrote SQL query practice and checked report numbers.', FALSE, '2026-04-13 11:03:00', '2026-04-13 11:03:00');
SET @demo_session_id := LAST_INSERT_ID();
INSERT INTO coding_sessions (user_id, topic_id, language_id, session_date, start_time, end_time, duration_minutes, notes, is_timer_session, created_at, updated_at) VALUES
(@admin_id, (SELECT id FROM topics WHERE name = 'SQL Queries' LIMIT 1), (SELECT id FROM programming_languages WHERE name = 'HTML/CSS' LIMIT 1), '2026-04-13', '19:14:00', '20:08:00', 54, 'DEMO100: evening review and cleanup session.', FALSE, '2026-04-13 20:08:00', '2026-04-13 20:08:00');
SET @demo_session_id := LAST_INSERT_ID();
INSERT INTO problems_solved (user_id, session_id, platform, problem_name, problem_url, difficulty, is_solved, time_taken_minutes, notes, solved_date, created_at) VALUES
(@admin_id, @demo_session_id, 'LeetCode', 'Merge Two Sorted Lists', 'https://leetcode.com/problems/merge-two-sorted-lists/', 'EASY', TRUE, 34, 'DEMO100: solved during the 100-day practice streak.', '2026-04-13', '2026-04-13 11:23:00');

-- Day 4: 2026-04-14
INSERT INTO daily_goals (user_id, goal_date, target_minutes, achieved_minutes, is_completed, created_at) VALUES
(@admin_id, '2026-04-14', 120, 141, TRUE, '2026-04-14 06:15:00')
ON DUPLICATE KEY UPDATE
target_minutes = VALUES(target_minutes),
achieved_minutes = VALUES(achieved_minutes),
is_completed = VALUES(is_completed);
INSERT INTO coding_sessions (user_id, topic_id, language_id, session_date, start_time, end_time, duration_minutes, notes, is_timer_session, created_at, updated_at) VALUES
(@admin_id, (SELECT id FROM topics WHERE name = 'Arrays & Strings' LIMIT 1), (SELECT id FROM programming_languages WHERE name = 'Python' LIMIT 1), '2026-04-14', '08:57:00', '11:18:00', 141, 'DEMO100: studied algorithm pattern and solved a related problem.', TRUE, '2026-04-14 11:18:00', '2026-04-14 11:18:00');
SET @demo_session_id := LAST_INSERT_ID();

-- Day 5: 2026-04-15
INSERT INTO daily_goals (user_id, goal_date, target_minutes, achieved_minutes, is_completed, created_at) VALUES
(@admin_id, '2026-04-15', 120, 178, TRUE, '2026-04-15 06:15:00')
ON DUPLICATE KEY UPDATE
target_minutes = VALUES(target_minutes),
achieved_minutes = VALUES(achieved_minutes),
is_completed = VALUES(is_completed);
INSERT INTO coding_sessions (user_id, topic_id, language_id, session_date, start_time, end_time, duration_minutes, notes, is_timer_session, created_at, updated_at) VALUES
(@admin_id, (SELECT id FROM topics WHERE name = 'Spring Security' LIMIT 1), (SELECT id FROM programming_languages WHERE name = 'HTML/CSS' LIMIT 1), '2026-04-15', '09:16:00', '11:41:00', 145, 'DEMO100: reviewed JWT/auth flow and cleaned edge cases.', FALSE, '2026-04-15 11:41:00', '2026-04-15 11:41:00');
SET @demo_session_id := LAST_INSERT_ID();
INSERT INTO coding_sessions (user_id, topic_id, language_id, session_date, start_time, end_time, duration_minutes, notes, is_timer_session, created_at, updated_at) VALUES
(@admin_id, (SELECT id FROM topics WHERE name = 'System Design' LIMIT 1), (SELECT id FROM programming_languages WHERE name = 'Java' LIMIT 1), '2026-04-15', '19:28:00', '20:01:00', 33, 'DEMO100: evening review and cleanup session.', FALSE, '2026-04-15 20:01:00', '2026-04-15 20:01:00');
SET @demo_session_id := LAST_INSERT_ID();
INSERT INTO problems_solved (user_id, session_id, platform, problem_name, problem_url, difficulty, is_solved, time_taken_minutes, notes, solved_date, created_at) VALUES
(@admin_id, @demo_session_id, 'LeetCode', 'Contains Duplicate', 'https://leetcode.com/problems/contains-duplicate/', 'EASY', TRUE, 31, 'DEMO100: solved during the 100-day practice streak.', '2026-04-15', '2026-04-15 12:01:00');

-- Day 6: 2026-04-16
INSERT INTO daily_goals (user_id, goal_date, target_minutes, achieved_minutes, is_completed, created_at) VALUES
(@admin_id, '2026-04-16', 120, 215, TRUE, '2026-04-16 06:15:00')
ON DUPLICATE KEY UPDATE
target_minutes = VALUES(target_minutes),
achieved_minutes = VALUES(achieved_minutes),
is_completed = VALUES(is_completed);
INSERT INTO coding_sessions (user_id, topic_id, language_id, session_date, start_time, end_time, duration_minutes, notes, is_timer_session, created_at, updated_at) VALUES
(@admin_id, (SELECT id FROM topics WHERE name = 'SQL Queries' LIMIT 1), (SELECT id FROM programming_languages WHERE name = 'TypeScript' LIMIT 1), '2026-04-16', '09:35:00', '12:00:00', 145, 'DEMO100: connected UI action to real API data.', FALSE, '2026-04-16 12:00:00', '2026-04-16 12:00:00');
SET @demo_session_id := LAST_INSERT_ID();
INSERT INTO coding_sessions (user_id, topic_id, language_id, session_date, start_time, end_time, duration_minutes, notes, is_timer_session, created_at, updated_at) VALUES
(@admin_id, (SELECT id FROM topics WHERE name = 'Spring Boot' LIMIT 1), (SELECT id FROM programming_languages WHERE name = 'JavaScript' LIMIT 1), '2026-04-16', '19:35:00', '20:45:00', 70, 'DEMO100: evening review and cleanup session.', FALSE, '2026-04-16 20:45:00', '2026-04-16 20:45:00');
SET @demo_session_id := LAST_INSERT_ID();

-- Day 7: 2026-04-17
INSERT INTO daily_goals (user_id, goal_date, target_minutes, achieved_minutes, is_completed, created_at) VALUES
(@admin_id, '2026-04-17', 120, 157, TRUE, '2026-04-17 06:15:00')
ON DUPLICATE KEY UPDATE
target_minutes = VALUES(target_minutes),
achieved_minutes = VALUES(achieved_minutes),
is_completed = VALUES(is_completed);
INSERT INTO coding_sessions (user_id, topic_id, language_id, session_date, start_time, end_time, duration_minutes, notes, is_timer_session, created_at, updated_at) VALUES
(@admin_id, (SELECT id FROM topics WHERE name = 'Git & GitHub' LIMIT 1), (SELECT id FROM programming_languages WHERE name = 'Java' LIMIT 1), '2026-04-17', '09:54:00', '12:19:00', 145, 'DEMO100: reviewed Git workflow and documented progress.', TRUE, '2026-04-17 12:19:00', '2026-04-17 12:19:00');
SET @demo_session_id := LAST_INSERT_ID();
INSERT INTO coding_sessions (user_id, topic_id, language_id, session_date, start_time, end_time, duration_minutes, notes, is_timer_session, created_at, updated_at) VALUES
(@admin_id, (SELECT id FROM topics WHERE name = 'React.js' LIMIT 1), (SELECT id FROM programming_languages WHERE name = 'SQL' LIMIT 1), '2026-04-17', '19:42:00', '19:54:00', 12, 'DEMO100: evening review and cleanup session.', FALSE, '2026-04-17 19:54:00', '2026-04-17 19:54:00');
SET @demo_session_id := LAST_INSERT_ID();
INSERT INTO problems_solved (user_id, session_id, platform, problem_name, problem_url, difficulty, is_solved, time_taken_minutes, notes, solved_date, created_at) VALUES
(@admin_id, @demo_session_id, 'LeetCode', 'Product of Array Except Self', 'https://leetcode.com/problems/product-of-array-except-self/', 'MEDIUM', TRUE, 42, 'DEMO100: solved during the 100-day practice streak.', '2026-04-17', '2026-04-17 12:39:00');

-- Day 8: 2026-04-18
INSERT INTO daily_goals (user_id, goal_date, target_minutes, achieved_minutes, is_completed, created_at) VALUES
(@admin_id, '2026-04-18', 90, 154, TRUE, '2026-04-18 06:15:00')
ON DUPLICATE KEY UPDATE
target_minutes = VALUES(target_minutes),
achieved_minutes = VALUES(achieved_minutes),
is_completed = VALUES(is_completed);
INSERT INTO coding_sessions (user_id, topic_id, language_id, session_date, start_time, end_time, duration_minutes, notes, is_timer_session, created_at, updated_at) VALUES
(@admin_id, (SELECT id FROM topics WHERE name = 'System Design' LIMIT 1), (SELECT id FROM programming_languages WHERE name = 'JavaScript' LIMIT 1), '2026-04-18', '08:13:00', '10:38:00', 145, 'DEMO100: planned architecture decisions from a product perspective.', FALSE, '2026-04-18 10:38:00', '2026-04-18 10:38:00');
SET @demo_session_id := LAST_INSERT_ID();
INSERT INTO coding_sessions (user_id, topic_id, language_id, session_date, start_time, end_time, duration_minutes, notes, is_timer_session, created_at, updated_at) VALUES
(@admin_id, (SELECT id FROM topics WHERE name = 'MySQL' LIMIT 1), (SELECT id FROM programming_languages WHERE name = 'Python' LIMIT 1), '2026-04-18', '19:49:00', '19:58:00', 9, 'DEMO100: evening review and cleanup session.', FALSE, '2026-04-18 19:58:00', '2026-04-18 19:58:00');
SET @demo_session_id := LAST_INSERT_ID();

-- Day 9: 2026-04-19
INSERT INTO daily_goals (user_id, goal_date, target_minutes, achieved_minutes, is_completed, created_at) VALUES
(@admin_id, '2026-04-19', 90, 96, TRUE, '2026-04-19 06:15:00')
ON DUPLICATE KEY UPDATE
target_minutes = VALUES(target_minutes),
achieved_minutes = VALUES(achieved_minutes),
is_completed = VALUES(is_completed);
INSERT INTO coding_sessions (user_id, topic_id, language_id, session_date, start_time, end_time, duration_minutes, notes, is_timer_session, created_at, updated_at) VALUES
(@admin_id, (SELECT id FROM topics WHERE name = 'Spring Boot' LIMIT 1), (SELECT id FROM programming_languages WHERE name = 'SQL' LIMIT 1), '2026-04-19', '08:32:00', '10:08:00', 96, 'DEMO100: implemented backend endpoint and verified request flow.', FALSE, '2026-04-19 10:08:00', '2026-04-19 10:08:00');
SET @demo_session_id := LAST_INSERT_ID();
INSERT INTO problems_solved (user_id, session_id, platform, problem_name, problem_url, difficulty, is_solved, time_taken_minutes, notes, solved_date, created_at) VALUES
(@admin_id, @demo_session_id, 'LeetCode', 'Climbing Stairs', 'https://leetcode.com/problems/climbing-stairs/', 'EASY', TRUE, 25, 'DEMO100: solved during the 100-day practice streak.', '2026-04-19', '2026-04-19 10:28:00');

-- Day 10: 2026-04-20
INSERT INTO daily_goals (user_id, goal_date, target_minutes, achieved_minutes, is_completed, created_at) VALUES
(@admin_id, '2026-04-20', 120, 173, TRUE, '2026-04-20 06:15:00')
ON DUPLICATE KEY UPDATE
target_minutes = VALUES(target_minutes),
achieved_minutes = VALUES(achieved_minutes),
is_completed = VALUES(is_completed);
INSERT INTO coding_sessions (user_id, topic_id, language_id, session_date, start_time, end_time, duration_minutes, notes, is_timer_session, created_at, updated_at) VALUES
(@admin_id, (SELECT id FROM topics WHERE name = 'React.js' LIMIT 1), (SELECT id FROM programming_languages WHERE name = 'Python' LIMIT 1), '2026-04-20', '08:51:00', '11:16:00', 145, 'DEMO100: refactored frontend state handling and tested the page.', TRUE, '2026-04-20 11:16:00', '2026-04-20 11:16:00');
SET @demo_session_id := LAST_INSERT_ID();
INSERT INTO coding_sessions (user_id, topic_id, language_id, session_date, start_time, end_time, duration_minutes, notes, is_timer_session, created_at, updated_at) VALUES
(@admin_id, (SELECT id FROM topics WHERE name = 'Spring Security' LIMIT 1), (SELECT id FROM programming_languages WHERE name = 'TypeScript' LIMIT 1), '2026-04-20', '20:03:00', '20:31:00', 28, 'DEMO100: evening review and cleanup session.', FALSE, '2026-04-20 20:31:00', '2026-04-20 20:31:00');
SET @demo_session_id := LAST_INSERT_ID();

-- Day 11: 2026-04-21
INSERT INTO daily_goals (user_id, goal_date, target_minutes, achieved_minutes, is_completed, created_at) VALUES
(@admin_id, '2026-04-21', 120, 210, TRUE, '2026-04-21 06:15:00')
ON DUPLICATE KEY UPDATE
target_minutes = VALUES(target_minutes),
achieved_minutes = VALUES(achieved_minutes),
is_completed = VALUES(is_completed);
INSERT INTO coding_sessions (user_id, topic_id, language_id, session_date, start_time, end_time, duration_minutes, notes, is_timer_session, created_at, updated_at) VALUES
(@admin_id, (SELECT id FROM topics WHERE name = 'MySQL' LIMIT 1), (SELECT id FROM programming_languages WHERE name = 'HTML/CSS' LIMIT 1), '2026-04-21', '09:10:00', '11:35:00', 145, 'DEMO100: wrote SQL query practice and checked report numbers.', FALSE, '2026-04-21 11:35:00', '2026-04-21 11:35:00');
SET @demo_session_id := LAST_INSERT_ID();
INSERT INTO coding_sessions (user_id, topic_id, language_id, session_date, start_time, end_time, duration_minutes, notes, is_timer_session, created_at, updated_at) VALUES
(@admin_id, (SELECT id FROM topics WHERE name = 'SQL Queries' LIMIT 1), (SELECT id FROM programming_languages WHERE name = 'Java' LIMIT 1), '2026-04-21', '20:10:00', '21:15:00', 65, 'DEMO100: evening review and cleanup session.', FALSE, '2026-04-21 21:15:00', '2026-04-21 21:15:00');
SET @demo_session_id := LAST_INSERT_ID();
INSERT INTO problems_solved (user_id, session_id, platform, problem_name, problem_url, difficulty, is_solved, time_taken_minutes, notes, solved_date, created_at) VALUES
(@admin_id, @demo_session_id, 'LeetCode', 'Invert Binary Tree', 'https://leetcode.com/problems/invert-binary-tree/', 'HARD', TRUE, 75, 'DEMO100: solved during the 100-day practice streak.', '2026-04-21', '2026-04-21 11:55:00');
INSERT INTO problems_solved (user_id, session_id, platform, problem_name, problem_url, difficulty, is_solved, time_taken_minutes, notes, solved_date, created_at) VALUES
(@admin_id, @demo_session_id, 'HackerRank', 'Subsets', 'https://www.hackerrank.com/challenges/subsets/problem', 'MEDIUM', TRUE, 38, 'DEMO100: solved as a stretch problem after the main session.', '2026-04-21', '2026-04-21 12:10:00');

-- Day 12: 2026-04-22
INSERT INTO daily_goals (user_id, goal_date, target_minutes, achieved_minutes, is_completed, created_at) VALUES
(@admin_id, '2026-04-22', 120, 152, TRUE, '2026-04-22 06:15:00')
ON DUPLICATE KEY UPDATE
target_minutes = VALUES(target_minutes),
achieved_minutes = VALUES(achieved_minutes),
is_completed = VALUES(is_completed);
INSERT INTO coding_sessions (user_id, topic_id, language_id, session_date, start_time, end_time, duration_minutes, notes, is_timer_session, created_at, updated_at) VALUES
(@admin_id, (SELECT id FROM topics WHERE name = 'Arrays & Strings' LIMIT 1), (SELECT id FROM programming_languages WHERE name = 'TypeScript' LIMIT 1), '2026-04-22', '09:29:00', '11:54:00', 145, 'DEMO100: studied algorithm pattern and solved a related problem.', FALSE, '2026-04-22 11:54:00', '2026-04-22 11:54:00');
SET @demo_session_id := LAST_INSERT_ID();
INSERT INTO coding_sessions (user_id, topic_id, language_id, session_date, start_time, end_time, duration_minutes, notes, is_timer_session, created_at, updated_at) VALUES
(@admin_id, (SELECT id FROM topics WHERE name = 'Git & GitHub' LIMIT 1), (SELECT id FROM programming_languages WHERE name = 'JavaScript' LIMIT 1), '2026-04-22', '19:02:00', '19:09:00', 7, 'DEMO100: evening review and cleanup session.', FALSE, '2026-04-22 19:09:00', '2026-04-22 19:09:00');
SET @demo_session_id := LAST_INSERT_ID();

-- Day 13: 2026-04-23
INSERT INTO daily_goals (user_id, goal_date, target_minutes, achieved_minutes, is_completed, created_at) VALUES
(@admin_id, '2026-04-23', 120, 189, TRUE, '2026-04-23 06:15:00')
ON DUPLICATE KEY UPDATE
target_minutes = VALUES(target_minutes),
achieved_minutes = VALUES(achieved_minutes),
is_completed = VALUES(is_completed);
INSERT INTO coding_sessions (user_id, topic_id, language_id, session_date, start_time, end_time, duration_minutes, notes, is_timer_session, created_at, updated_at) VALUES
(@admin_id, (SELECT id FROM topics WHERE name = 'Spring Security' LIMIT 1), (SELECT id FROM programming_languages WHERE name = 'Java' LIMIT 1), '2026-04-23', '09:48:00', '12:13:00', 145, 'DEMO100: reviewed JWT/auth flow and cleaned edge cases.', TRUE, '2026-04-23 12:13:00', '2026-04-23 12:13:00');
SET @demo_session_id := LAST_INSERT_ID();
INSERT INTO coding_sessions (user_id, topic_id, language_id, session_date, start_time, end_time, duration_minutes, notes, is_timer_session, created_at, updated_at) VALUES
(@admin_id, (SELECT id FROM topics WHERE name = 'System Design' LIMIT 1), (SELECT id FROM programming_languages WHERE name = 'SQL' LIMIT 1), '2026-04-23', '19:09:00', '19:53:00', 44, 'DEMO100: evening review and cleanup session.', FALSE, '2026-04-23 19:53:00', '2026-04-23 19:53:00');
SET @demo_session_id := LAST_INSERT_ID();
INSERT INTO problems_solved (user_id, session_id, platform, problem_name, problem_url, difficulty, is_solved, time_taken_minutes, notes, solved_date, created_at) VALUES
(@admin_id, @demo_session_id, 'LeetCode', 'Number of Islands', 'https://leetcode.com/problems/number-of-islands/', 'MEDIUM', TRUE, 49, 'DEMO100: solved during the 100-day practice streak.', '2026-04-23', '2026-04-23 12:33:00');

-- Day 14: 2026-04-24
INSERT INTO daily_goals (user_id, goal_date, target_minutes, achieved_minutes, is_completed, created_at) VALUES
(@admin_id, '2026-04-24', 120, 131, TRUE, '2026-04-24 06:15:00')
ON DUPLICATE KEY UPDATE
target_minutes = VALUES(target_minutes),
achieved_minutes = VALUES(achieved_minutes),
is_completed = VALUES(is_completed);
INSERT INTO coding_sessions (user_id, topic_id, language_id, session_date, start_time, end_time, duration_minutes, notes, is_timer_session, created_at, updated_at) VALUES
(@admin_id, (SELECT id FROM topics WHERE name = 'SQL Queries' LIMIT 1), (SELECT id FROM programming_languages WHERE name = 'JavaScript' LIMIT 1), '2026-04-24', '08:07:00', '10:18:00', 131, 'DEMO100: connected UI action to real API data.', FALSE, '2026-04-24 10:18:00', '2026-04-24 10:18:00');
SET @demo_session_id := LAST_INSERT_ID();

-- Day 15: 2026-04-25
INSERT INTO daily_goals (user_id, goal_date, target_minutes, achieved_minutes, is_completed, created_at) VALUES
(@admin_id, '2026-04-25', 90, 128, TRUE, '2026-04-25 06:15:00')
ON DUPLICATE KEY UPDATE
target_minutes = VALUES(target_minutes),
achieved_minutes = VALUES(achieved_minutes),
is_completed = VALUES(is_completed);
INSERT INTO coding_sessions (user_id, topic_id, language_id, session_date, start_time, end_time, duration_minutes, notes, is_timer_session, created_at, updated_at) VALUES
(@admin_id, (SELECT id FROM topics WHERE name = 'Git & GitHub' LIMIT 1), (SELECT id FROM programming_languages WHERE name = 'SQL' LIMIT 1), '2026-04-25', '08:26:00', '10:34:00', 128, 'DEMO100: reviewed Git workflow and documented progress.', FALSE, '2026-04-25 10:34:00', '2026-04-25 10:34:00');
SET @demo_session_id := LAST_INSERT_ID();
INSERT INTO problems_solved (user_id, session_id, platform, problem_name, problem_url, difficulty, is_solved, time_taken_minutes, notes, solved_date, created_at) VALUES
(@admin_id, @demo_session_id, 'LeetCode', 'Group Anagrams', 'https://leetcode.com/problems/group-anagrams/', 'EASY', TRUE, 16, 'DEMO100: solved during the 100-day practice streak.', '2026-04-25', '2026-04-25 10:54:00');

-- Day 16: 2026-04-26
INSERT INTO daily_goals (user_id, goal_date, target_minutes, achieved_minutes, is_completed, created_at) VALUES
(@admin_id, '2026-04-26', 90, 165, TRUE, '2026-04-26 06:15:00')
ON DUPLICATE KEY UPDATE
target_minutes = VALUES(target_minutes),
achieved_minutes = VALUES(achieved_minutes),
is_completed = VALUES(is_completed);
INSERT INTO coding_sessions (user_id, topic_id, language_id, session_date, start_time, end_time, duration_minutes, notes, is_timer_session, created_at, updated_at) VALUES
(@admin_id, (SELECT id FROM topics WHERE name = 'System Design' LIMIT 1), (SELECT id FROM programming_languages WHERE name = 'Python' LIMIT 1), '2026-04-26', '08:45:00', '11:10:00', 145, 'DEMO100: planned architecture decisions from a product perspective.', TRUE, '2026-04-26 11:10:00', '2026-04-26 11:10:00');
SET @demo_session_id := LAST_INSERT_ID();
INSERT INTO coding_sessions (user_id, topic_id, language_id, session_date, start_time, end_time, duration_minutes, notes, is_timer_session, created_at, updated_at) VALUES
(@admin_id, (SELECT id FROM topics WHERE name = 'MySQL' LIMIT 1), (SELECT id FROM programming_languages WHERE name = 'TypeScript' LIMIT 1), '2026-04-26', '19:30:00', '19:50:00', 20, 'DEMO100: evening review and cleanup session.', FALSE, '2026-04-26 19:50:00', '2026-04-26 19:50:00');
SET @demo_session_id := LAST_INSERT_ID();

-- Day 17: 2026-04-27
INSERT INTO daily_goals (user_id, goal_date, target_minutes, achieved_minutes, is_completed, created_at) VALUES
(@admin_id, '2026-04-27', 120, 147, TRUE, '2026-04-27 06:15:00')
ON DUPLICATE KEY UPDATE
target_minutes = VALUES(target_minutes),
achieved_minutes = VALUES(achieved_minutes),
is_completed = VALUES(is_completed);
INSERT INTO coding_sessions (user_id, topic_id, language_id, session_date, start_time, end_time, duration_minutes, notes, is_timer_session, created_at, updated_at) VALUES
(@admin_id, (SELECT id FROM topics WHERE name = 'Spring Boot' LIMIT 1), (SELECT id FROM programming_languages WHERE name = 'HTML/CSS' LIMIT 1), '2026-04-27', '09:04:00', '11:29:00', 145, 'DEMO100: implemented backend endpoint and verified request flow.', FALSE, '2026-04-27 11:29:00', '2026-04-27 11:29:00');
SET @demo_session_id := LAST_INSERT_ID();
INSERT INTO coding_sessions (user_id, topic_id, language_id, session_date, start_time, end_time, duration_minutes, notes, is_timer_session, created_at, updated_at) VALUES
(@admin_id, (SELECT id FROM topics WHERE name = 'Arrays & Strings' LIMIT 1), (SELECT id FROM programming_languages WHERE name = 'Java' LIMIT 1), '2026-04-27', '19:37:00', '19:39:00', 2, 'DEMO100: evening review and cleanup session.', FALSE, '2026-04-27 19:39:00', '2026-04-27 19:39:00');
SET @demo_session_id := LAST_INSERT_ID();
INSERT INTO problems_solved (user_id, session_id, platform, problem_name, problem_url, difficulty, is_solved, time_taken_minutes, notes, solved_date, created_at) VALUES
(@admin_id, @demo_session_id, 'LeetCode', 'Course Schedule', 'https://leetcode.com/problems/course-schedule/', 'EASY', TRUE, 13, 'DEMO100: solved during the 100-day practice streak.', '2026-04-27', '2026-04-27 11:49:00');

-- Day 18: 2026-04-28
INSERT INTO daily_goals (user_id, goal_date, target_minutes, achieved_minutes, is_completed, created_at) VALUES
(@admin_id, '2026-04-28', 120, 149, TRUE, '2026-04-28 06:15:00')
ON DUPLICATE KEY UPDATE
target_minutes = VALUES(target_minutes),
achieved_minutes = VALUES(achieved_minutes),
is_completed = VALUES(is_completed);
INSERT INTO coding_sessions (user_id, topic_id, language_id, session_date, start_time, end_time, duration_minutes, notes, is_timer_session, created_at, updated_at) VALUES
(@admin_id, (SELECT id FROM topics WHERE name = 'React.js' LIMIT 1), (SELECT id FROM programming_languages WHERE name = 'TypeScript' LIMIT 1), '2026-04-28', '09:23:00', '11:48:00', 145, 'DEMO100: refactored frontend state handling and tested the page.', FALSE, '2026-04-28 11:48:00', '2026-04-28 11:48:00');
SET @demo_session_id := LAST_INSERT_ID();
INSERT INTO coding_sessions (user_id, topic_id, language_id, session_date, start_time, end_time, duration_minutes, notes, is_timer_session, created_at, updated_at) VALUES
(@admin_id, (SELECT id FROM topics WHERE name = 'Spring Security' LIMIT 1), (SELECT id FROM programming_languages WHERE name = 'JavaScript' LIMIT 1), '2026-04-28', '19:44:00', '19:48:00', 4, 'DEMO100: evening review and cleanup session.', FALSE, '2026-04-28 19:48:00', '2026-04-28 19:48:00');
SET @demo_session_id := LAST_INSERT_ID();

-- Day 19: 2026-04-29
INSERT INTO daily_goals (user_id, goal_date, target_minutes, achieved_minutes, is_completed, created_at) VALUES
(@admin_id, '2026-04-29', 120, 126, TRUE, '2026-04-29 06:15:00')
ON DUPLICATE KEY UPDATE
target_minutes = VALUES(target_minutes),
achieved_minutes = VALUES(achieved_minutes),
is_completed = VALUES(is_completed);
INSERT INTO coding_sessions (user_id, topic_id, language_id, session_date, start_time, end_time, duration_minutes, notes, is_timer_session, created_at, updated_at) VALUES
(@admin_id, (SELECT id FROM topics WHERE name = 'MySQL' LIMIT 1), (SELECT id FROM programming_languages WHERE name = 'Java' LIMIT 1), '2026-04-29', '09:42:00', '11:48:00', 126, 'DEMO100: wrote SQL query practice and checked report numbers.', TRUE, '2026-04-29 11:48:00', '2026-04-29 11:48:00');
SET @demo_session_id := LAST_INSERT_ID();
INSERT INTO problems_solved (user_id, session_id, platform, problem_name, problem_url, difficulty, is_solved, time_taken_minutes, notes, solved_date, created_at) VALUES
(@admin_id, @demo_session_id, 'LeetCode', 'House Robber', 'https://leetcode.com/problems/house-robber/', 'MEDIUM', FALSE, 56, 'DEMO100: attempted during the 100-day practice streak.', '2026-04-29', '2026-04-29 12:08:00');

-- Day 20: 2026-04-30
INSERT INTO daily_goals (user_id, goal_date, target_minutes, achieved_minutes, is_completed, created_at) VALUES
(@admin_id, '2026-04-30', 120, 163, TRUE, '2026-04-30 06:15:00')
ON DUPLICATE KEY UPDATE
target_minutes = VALUES(target_minutes),
achieved_minutes = VALUES(achieved_minutes),
is_completed = VALUES(is_completed);
INSERT INTO coding_sessions (user_id, topic_id, language_id, session_date, start_time, end_time, duration_minutes, notes, is_timer_session, created_at, updated_at) VALUES
(@admin_id, (SELECT id FROM topics WHERE name = 'Arrays & Strings' LIMIT 1), (SELECT id FROM programming_languages WHERE name = 'JavaScript' LIMIT 1), '2026-04-30', '08:01:00', '10:26:00', 145, 'DEMO100: studied algorithm pattern and solved a related problem.', FALSE, '2026-04-30 10:26:00', '2026-04-30 10:26:00');
SET @demo_session_id := LAST_INSERT_ID();
INSERT INTO coding_sessions (user_id, topic_id, language_id, session_date, start_time, end_time, duration_minutes, notes, is_timer_session, created_at, updated_at) VALUES
(@admin_id, (SELECT id FROM topics WHERE name = 'Git & GitHub' LIMIT 1), (SELECT id FROM programming_languages WHERE name = 'Python' LIMIT 1), '2026-04-30', '19:58:00', '20:16:00', 18, 'DEMO100: evening review and cleanup session.', FALSE, '2026-04-30 20:16:00', '2026-04-30 20:16:00');
SET @demo_session_id := LAST_INSERT_ID();

-- Day 21: 2026-05-01
INSERT INTO daily_goals (user_id, goal_date, target_minutes, achieved_minutes, is_completed, created_at) VALUES
(@admin_id, '2026-05-01', 120, 200, TRUE, '2026-05-01 06:15:00')
ON DUPLICATE KEY UPDATE
target_minutes = VALUES(target_minutes),
achieved_minutes = VALUES(achieved_minutes),
is_completed = VALUES(is_completed);
INSERT INTO coding_sessions (user_id, topic_id, language_id, session_date, start_time, end_time, duration_minutes, notes, is_timer_session, created_at, updated_at) VALUES
(@admin_id, (SELECT id FROM topics WHERE name = 'Spring Security' LIMIT 1), (SELECT id FROM programming_languages WHERE name = 'SQL' LIMIT 1), '2026-05-01', '08:20:00', '10:45:00', 145, 'DEMO100: reviewed JWT/auth flow and cleaned edge cases.', FALSE, '2026-05-01 10:45:00', '2026-05-01 10:45:00');
SET @demo_session_id := LAST_INSERT_ID();
INSERT INTO coding_sessions (user_id, topic_id, language_id, session_date, start_time, end_time, duration_minutes, notes, is_timer_session, created_at, updated_at) VALUES
(@admin_id, (SELECT id FROM topics WHERE name = 'System Design' LIMIT 1), (SELECT id FROM programming_languages WHERE name = 'HTML/CSS' LIMIT 1), '2026-05-01', '20:05:00', '21:00:00', 55, 'DEMO100: evening review and cleanup session.', FALSE, '2026-05-01 21:00:00', '2026-05-01 21:00:00');
SET @demo_session_id := LAST_INSERT_ID();
INSERT INTO problems_solved (user_id, session_id, platform, problem_name, problem_url, difficulty, is_solved, time_taken_minutes, notes, solved_date, created_at) VALUES
(@admin_id, @demo_session_id, 'LeetCode', 'Kth Largest Element in an Array', 'https://leetcode.com/problems/kth-largest-element-in-an-array/', 'HARD', TRUE, 75, 'DEMO100: solved during the 100-day practice streak.', '2026-05-01', '2026-05-01 11:05:00');
INSERT INTO problems_solved (user_id, session_id, platform, problem_name, problem_url, difficulty, is_solved, time_taken_minutes, notes, solved_date, created_at) VALUES
(@admin_id, @demo_session_id, 'HackerRank', 'Valid Parentheses', 'https://www.hackerrank.com/challenges/valid-parentheses/problem', 'MEDIUM', TRUE, 48, 'DEMO100: solved as a stretch problem after the main session.', '2026-05-01', '2026-05-01 11:20:00');

-- Day 22: 2026-05-02
INSERT INTO daily_goals (user_id, goal_date, target_minutes, achieved_minutes, is_completed, created_at) VALUES
(@admin_id, '2026-05-02', 90, 102, TRUE, '2026-05-02 06:15:00')
ON DUPLICATE KEY UPDATE
target_minutes = VALUES(target_minutes),
achieved_minutes = VALUES(achieved_minutes),
is_completed = VALUES(is_completed);
INSERT INTO coding_sessions (user_id, topic_id, language_id, session_date, start_time, end_time, duration_minutes, notes, is_timer_session, created_at, updated_at) VALUES
(@admin_id, (SELECT id FROM topics WHERE name = 'SQL Queries' LIMIT 1), (SELECT id FROM programming_languages WHERE name = 'Python' LIMIT 1), '2026-05-02', '08:39:00', '10:21:00', 102, 'DEMO100: connected UI action to real API data.', TRUE, '2026-05-02 10:21:00', '2026-05-02 10:21:00');
SET @demo_session_id := LAST_INSERT_ID();

-- Day 23: 2026-05-03
INSERT INTO daily_goals (user_id, goal_date, target_minutes, achieved_minutes, is_completed, created_at) VALUES
(@admin_id, '2026-05-03', 90, 139, TRUE, '2026-05-03 06:15:00')
ON DUPLICATE KEY UPDATE
target_minutes = VALUES(target_minutes),
achieved_minutes = VALUES(achieved_minutes),
is_completed = VALUES(is_completed);
INSERT INTO coding_sessions (user_id, topic_id, language_id, session_date, start_time, end_time, duration_minutes, notes, is_timer_session, created_at, updated_at) VALUES
(@admin_id, (SELECT id FROM topics WHERE name = 'Git & GitHub' LIMIT 1), (SELECT id FROM programming_languages WHERE name = 'HTML/CSS' LIMIT 1), '2026-05-03', '08:58:00', '11:17:00', 139, 'DEMO100: reviewed Git workflow and documented progress.', FALSE, '2026-05-03 11:17:00', '2026-05-03 11:17:00');
SET @demo_session_id := LAST_INSERT_ID();
INSERT INTO problems_solved (user_id, session_id, platform, problem_name, problem_url, difficulty, is_solved, time_taken_minutes, notes, solved_date, created_at) VALUES
(@admin_id, @demo_session_id, 'LeetCode', 'Combination Sum', 'https://leetcode.com/problems/combination-sum/', 'EASY', TRUE, 29, 'DEMO100: solved during the 100-day practice streak.', '2026-05-03', '2026-05-03 11:37:00');

-- Day 24: 2026-05-04
INSERT INTO daily_goals (user_id, goal_date, target_minutes, achieved_minutes, is_completed, created_at) VALUES
(@admin_id, '2026-05-04', 120, 276, TRUE, '2026-05-04 06:15:00')
ON DUPLICATE KEY UPDATE
target_minutes = VALUES(target_minutes),
achieved_minutes = VALUES(achieved_minutes),
is_completed = VALUES(is_completed);
INSERT INTO coding_sessions (user_id, topic_id, language_id, session_date, start_time, end_time, duration_minutes, notes, is_timer_session, created_at, updated_at) VALUES
(@admin_id, (SELECT id FROM topics WHERE name = 'System Design' LIMIT 1), (SELECT id FROM programming_languages WHERE name = 'TypeScript' LIMIT 1), '2026-05-04', '09:17:00', '11:42:00', 145, 'DEMO100: planned architecture decisions from a product perspective.', FALSE, '2026-05-04 11:42:00', '2026-05-04 11:42:00');
SET @demo_session_id := LAST_INSERT_ID();
INSERT INTO coding_sessions (user_id, topic_id, language_id, session_date, start_time, end_time, duration_minutes, notes, is_timer_session, created_at, updated_at) VALUES
(@admin_id, (SELECT id FROM topics WHERE name = 'MySQL' LIMIT 1), (SELECT id FROM programming_languages WHERE name = 'JavaScript' LIMIT 1), '2026-05-04', '19:11:00', '21:22:00', 131, 'DEMO100: evening review and cleanup session.', FALSE, '2026-05-04 21:22:00', '2026-05-04 21:22:00');
SET @demo_session_id := LAST_INSERT_ID();

-- Day 25: 2026-05-05
INSERT INTO daily_goals (user_id, goal_date, target_minutes, achieved_minutes, is_completed, created_at) VALUES
(@admin_id, '2026-05-05', 120, 158, TRUE, '2026-05-05 06:15:00')
ON DUPLICATE KEY UPDATE
target_minutes = VALUES(target_minutes),
achieved_minutes = VALUES(achieved_minutes),
is_completed = VALUES(is_completed);
INSERT INTO coding_sessions (user_id, topic_id, language_id, session_date, start_time, end_time, duration_minutes, notes, is_timer_session, created_at, updated_at) VALUES
(@admin_id, (SELECT id FROM topics WHERE name = 'Spring Boot' LIMIT 1), (SELECT id FROM programming_languages WHERE name = 'Java' LIMIT 1), '2026-05-05', '09:36:00', '12:01:00', 145, 'DEMO100: implemented backend endpoint and verified request flow.', TRUE, '2026-05-05 12:01:00', '2026-05-05 12:01:00');
SET @demo_session_id := LAST_INSERT_ID();
INSERT INTO coding_sessions (user_id, topic_id, language_id, session_date, start_time, end_time, duration_minutes, notes, is_timer_session, created_at, updated_at) VALUES
(@admin_id, (SELECT id FROM topics WHERE name = 'Arrays & Strings' LIMIT 1), (SELECT id FROM programming_languages WHERE name = 'SQL' LIMIT 1), '2026-05-05', '19:18:00', '19:31:00', 13, 'DEMO100: evening review and cleanup session.', FALSE, '2026-05-05 19:31:00', '2026-05-05 19:31:00');
SET @demo_session_id := LAST_INSERT_ID();
INSERT INTO problems_solved (user_id, session_id, platform, problem_name, problem_url, difficulty, is_solved, time_taken_minutes, notes, solved_date, created_at) VALUES
(@admin_id, @demo_session_id, 'LeetCode', 'Validate Binary Search Tree', 'https://leetcode.com/problems/validate-binary-search-tree/', 'MEDIUM', TRUE, 63, 'DEMO100: solved during the 100-day practice streak.', '2026-05-05', '2026-05-05 12:21:00');

-- Day 26: 2026-05-06
INSERT INTO daily_goals (user_id, goal_date, target_minutes, achieved_minutes, is_completed, created_at) VALUES
(@admin_id, '2026-05-06', 120, 195, TRUE, '2026-05-06 06:15:00')
ON DUPLICATE KEY UPDATE
target_minutes = VALUES(target_minutes),
achieved_minutes = VALUES(achieved_minutes),
is_completed = VALUES(is_completed);
INSERT INTO coding_sessions (user_id, topic_id, language_id, session_date, start_time, end_time, duration_minutes, notes, is_timer_session, created_at, updated_at) VALUES
(@admin_id, (SELECT id FROM topics WHERE name = 'React.js' LIMIT 1), (SELECT id FROM programming_languages WHERE name = 'JavaScript' LIMIT 1), '2026-05-06', '09:55:00', '12:20:00', 145, 'DEMO100: refactored frontend state handling and tested the page.', FALSE, '2026-05-06 12:20:00', '2026-05-06 12:20:00');
SET @demo_session_id := LAST_INSERT_ID();
INSERT INTO coding_sessions (user_id, topic_id, language_id, session_date, start_time, end_time, duration_minutes, notes, is_timer_session, created_at, updated_at) VALUES
(@admin_id, (SELECT id FROM topics WHERE name = 'Spring Security' LIMIT 1), (SELECT id FROM programming_languages WHERE name = 'Python' LIMIT 1), '2026-05-06', '19:25:00', '20:15:00', 50, 'DEMO100: evening review and cleanup session.', FALSE, '2026-05-06 20:15:00', '2026-05-06 20:15:00');
SET @demo_session_id := LAST_INSERT_ID();

-- Day 27: 2026-05-07
INSERT INTO daily_goals (user_id, goal_date, target_minutes, achieved_minutes, is_completed, created_at) VALUES
(@admin_id, '2026-05-07', 120, 137, TRUE, '2026-05-07 06:15:00')
ON DUPLICATE KEY UPDATE
target_minutes = VALUES(target_minutes),
achieved_minutes = VALUES(achieved_minutes),
is_completed = VALUES(is_completed);
INSERT INTO coding_sessions (user_id, topic_id, language_id, session_date, start_time, end_time, duration_minutes, notes, is_timer_session, created_at, updated_at) VALUES
(@admin_id, (SELECT id FROM topics WHERE name = 'MySQL' LIMIT 1), (SELECT id FROM programming_languages WHERE name = 'SQL' LIMIT 1), '2026-05-07', '08:14:00', '10:31:00', 137, 'DEMO100: wrote SQL query practice and checked report numbers.', FALSE, '2026-05-07 10:31:00', '2026-05-07 10:31:00');
SET @demo_session_id := LAST_INSERT_ID();
INSERT INTO problems_solved (user_id, session_id, platform, problem_name, problem_url, difficulty, is_solved, time_taken_minutes, notes, solved_date, created_at) VALUES
(@admin_id, @demo_session_id, 'LeetCode', 'Rotting Oranges', 'https://leetcode.com/problems/rotting-oranges/', 'EASY', TRUE, 23, 'DEMO100: solved during the 100-day practice streak.', '2026-05-07', '2026-05-07 10:51:00');

-- Day 28: 2026-05-08
INSERT INTO daily_goals (user_id, goal_date, target_minutes, achieved_minutes, is_completed, created_at) VALUES
(@admin_id, '2026-05-08', 120, 174, TRUE, '2026-05-08 06:15:00')
ON DUPLICATE KEY UPDATE
target_minutes = VALUES(target_minutes),
achieved_minutes = VALUES(achieved_minutes),
is_completed = VALUES(is_completed);
INSERT INTO coding_sessions (user_id, topic_id, language_id, session_date, start_time, end_time, duration_minutes, notes, is_timer_session, created_at, updated_at) VALUES
(@admin_id, (SELECT id FROM topics WHERE name = 'Arrays & Strings' LIMIT 1), (SELECT id FROM programming_languages WHERE name = 'Python' LIMIT 1), '2026-05-08', '08:33:00', '10:58:00', 145, 'DEMO100: studied algorithm pattern and solved a related problem.', TRUE, '2026-05-08 10:58:00', '2026-05-08 10:58:00');
SET @demo_session_id := LAST_INSERT_ID();
INSERT INTO coding_sessions (user_id, topic_id, language_id, session_date, start_time, end_time, duration_minutes, notes, is_timer_session, created_at, updated_at) VALUES
(@admin_id, (SELECT id FROM topics WHERE name = 'Git & GitHub' LIMIT 1), (SELECT id FROM programming_languages WHERE name = 'TypeScript' LIMIT 1), '2026-05-08', '19:39:00', '20:08:00', 29, 'DEMO100: evening review and cleanup session.', FALSE, '2026-05-08 20:08:00', '2026-05-08 20:08:00');
SET @demo_session_id := LAST_INSERT_ID();

-- Day 29: 2026-05-09
INSERT INTO daily_goals (user_id, goal_date, target_minutes, achieved_minutes, is_completed, created_at) VALUES
(@admin_id, '2026-05-09', 90, 171, TRUE, '2026-05-09 06:15:00')
ON DUPLICATE KEY UPDATE
target_minutes = VALUES(target_minutes),
achieved_minutes = VALUES(achieved_minutes),
is_completed = VALUES(is_completed);
INSERT INTO coding_sessions (user_id, topic_id, language_id, session_date, start_time, end_time, duration_minutes, notes, is_timer_session, created_at, updated_at) VALUES
(@admin_id, (SELECT id FROM topics WHERE name = 'Spring Security' LIMIT 1), (SELECT id FROM programming_languages WHERE name = 'HTML/CSS' LIMIT 1), '2026-05-09', '08:52:00', '11:17:00', 145, 'DEMO100: reviewed JWT/auth flow and cleaned edge cases.', FALSE, '2026-05-09 11:17:00', '2026-05-09 11:17:00');
SET @demo_session_id := LAST_INSERT_ID();
INSERT INTO coding_sessions (user_id, topic_id, language_id, session_date, start_time, end_time, duration_minutes, notes, is_timer_session, created_at, updated_at) VALUES
(@admin_id, (SELECT id FROM topics WHERE name = 'System Design' LIMIT 1), (SELECT id FROM programming_languages WHERE name = 'Java' LIMIT 1), '2026-05-09', '19:46:00', '20:12:00', 26, 'DEMO100: evening review and cleanup session.', FALSE, '2026-05-09 20:12:00', '2026-05-09 20:12:00');
SET @demo_session_id := LAST_INSERT_ID();
INSERT INTO problems_solved (user_id, session_id, platform, problem_name, problem_url, difficulty, is_solved, time_taken_minutes, notes, solved_date, created_at) VALUES
(@admin_id, @demo_session_id, 'LeetCode', 'Decode Ways', 'https://leetcode.com/problems/decode-ways/', 'EASY', TRUE, 20, 'DEMO100: solved during the 100-day practice streak.', '2026-05-09', '2026-05-09 11:37:00');

-- Day 30: 2026-05-10
INSERT INTO daily_goals (user_id, goal_date, target_minutes, achieved_minutes, is_completed, created_at) VALUES
(@admin_id, '2026-05-10', 90, 113, TRUE, '2026-05-10 06:15:00')
ON DUPLICATE KEY UPDATE
target_minutes = VALUES(target_minutes),
achieved_minutes = VALUES(achieved_minutes),
is_completed = VALUES(is_completed);
INSERT INTO coding_sessions (user_id, topic_id, language_id, session_date, start_time, end_time, duration_minutes, notes, is_timer_session, created_at, updated_at) VALUES
(@admin_id, (SELECT id FROM topics WHERE name = 'SQL Queries' LIMIT 1), (SELECT id FROM programming_languages WHERE name = 'TypeScript' LIMIT 1), '2026-05-10', '09:11:00', '11:04:00', 113, 'DEMO100: connected UI action to real API data.', FALSE, '2026-05-10 11:04:00', '2026-05-10 11:04:00');
SET @demo_session_id := LAST_INSERT_ID();

-- Day 31: 2026-05-11
INSERT INTO daily_goals (user_id, goal_date, target_minutes, achieved_minutes, is_completed, created_at) VALUES
(@admin_id, '2026-05-11', 120, 190, TRUE, '2026-05-11 06:15:00')
ON DUPLICATE KEY UPDATE
target_minutes = VALUES(target_minutes),
achieved_minutes = VALUES(achieved_minutes),
is_completed = VALUES(is_completed);
INSERT INTO coding_sessions (user_id, topic_id, language_id, session_date, start_time, end_time, duration_minutes, notes, is_timer_session, created_at, updated_at) VALUES
(@admin_id, (SELECT id FROM topics WHERE name = 'Git & GitHub' LIMIT 1), (SELECT id FROM programming_languages WHERE name = 'Java' LIMIT 1), '2026-05-11', '09:30:00', '11:55:00', 145, 'DEMO100: reviewed Git workflow and documented progress.', TRUE, '2026-05-11 11:55:00', '2026-05-11 11:55:00');
SET @demo_session_id := LAST_INSERT_ID();
INSERT INTO coding_sessions (user_id, topic_id, language_id, session_date, start_time, end_time, duration_minutes, notes, is_timer_session, created_at, updated_at) VALUES
(@admin_id, (SELECT id FROM topics WHERE name = 'React.js' LIMIT 1), (SELECT id FROM programming_languages WHERE name = 'SQL' LIMIT 1), '2026-05-11', '20:00:00', '20:45:00', 45, 'DEMO100: evening review and cleanup session.', FALSE, '2026-05-11 20:45:00', '2026-05-11 20:45:00');
SET @demo_session_id := LAST_INSERT_ID();
INSERT INTO problems_solved (user_id, session_id, platform, problem_name, problem_url, difficulty, is_solved, time_taken_minutes, notes, solved_date, created_at) VALUES
(@admin_id, @demo_session_id, 'LeetCode', 'Two Sum', 'https://leetcode.com/problems/two-sum/', 'HARD', TRUE, 75, 'DEMO100: solved during the 100-day practice streak.', '2026-05-11', '2026-05-11 12:15:00');
INSERT INTO problems_solved (user_id, session_id, platform, problem_name, problem_url, difficulty, is_solved, time_taken_minutes, notes, solved_date, created_at) VALUES
(@admin_id, @demo_session_id, 'HackerRank', 'Flood Fill', 'https://www.hackerrank.com/challenges/flood-fill/problem', 'MEDIUM', TRUE, 58, 'DEMO100: solved as a stretch problem after the main session.', '2026-05-11', '2026-05-11 12:30:00');

-- Day 32: 2026-05-12
INSERT INTO daily_goals (user_id, goal_date, target_minutes, achieved_minutes, is_completed, created_at) VALUES
(@admin_id, '2026-05-12', 120, 132, TRUE, '2026-05-12 06:15:00')
ON DUPLICATE KEY UPDATE
target_minutes = VALUES(target_minutes),
achieved_minutes = VALUES(achieved_minutes),
is_completed = VALUES(is_completed);
INSERT INTO coding_sessions (user_id, topic_id, language_id, session_date, start_time, end_time, duration_minutes, notes, is_timer_session, created_at, updated_at) VALUES
(@admin_id, (SELECT id FROM topics WHERE name = 'System Design' LIMIT 1), (SELECT id FROM programming_languages WHERE name = 'JavaScript' LIMIT 1), '2026-05-12', '09:49:00', '12:01:00', 132, 'DEMO100: planned architecture decisions from a product perspective.', FALSE, '2026-05-12 12:01:00', '2026-05-12 12:01:00');
SET @demo_session_id := LAST_INSERT_ID();

-- Day 33: 2026-05-13
INSERT INTO daily_goals (user_id, goal_date, target_minutes, achieved_minutes, is_completed, created_at) VALUES
(@admin_id, '2026-05-13', 120, 169, TRUE, '2026-05-13 06:15:00')
ON DUPLICATE KEY UPDATE
target_minutes = VALUES(target_minutes),
achieved_minutes = VALUES(achieved_minutes),
is_completed = VALUES(is_completed);
INSERT INTO coding_sessions (user_id, topic_id, language_id, session_date, start_time, end_time, duration_minutes, notes, is_timer_session, created_at, updated_at) VALUES
(@admin_id, (SELECT id FROM topics WHERE name = 'Spring Boot' LIMIT 1), (SELECT id FROM programming_languages WHERE name = 'SQL' LIMIT 1), '2026-05-13', '08:08:00', '10:33:00', 145, 'DEMO100: implemented backend endpoint and verified request flow.', FALSE, '2026-05-13 10:33:00', '2026-05-13 10:33:00');
SET @demo_session_id := LAST_INSERT_ID();
INSERT INTO coding_sessions (user_id, topic_id, language_id, session_date, start_time, end_time, duration_minutes, notes, is_timer_session, created_at, updated_at) VALUES
(@admin_id, (SELECT id FROM topics WHERE name = 'Arrays & Strings' LIMIT 1), (SELECT id FROM programming_languages WHERE name = 'HTML/CSS' LIMIT 1), '2026-05-13', '20:14:00', '20:38:00', 24, 'DEMO100: evening review and cleanup session.', FALSE, '2026-05-13 20:38:00', '2026-05-13 20:38:00');
SET @demo_session_id := LAST_INSERT_ID();
INSERT INTO problems_solved (user_id, session_id, platform, problem_name, problem_url, difficulty, is_solved, time_taken_minutes, notes, solved_date, created_at) VALUES
(@admin_id, @demo_session_id, 'LeetCode', 'Merge Two Sorted Lists', 'https://leetcode.com/problems/merge-two-sorted-lists/', 'EASY', TRUE, 14, 'DEMO100: solved during the 100-day practice streak.', '2026-05-13', '2026-05-13 10:53:00');

-- Day 34: 2026-05-14
INSERT INTO daily_goals (user_id, goal_date, target_minutes, achieved_minutes, is_completed, created_at) VALUES
(@admin_id, '2026-05-14', 120, 206, TRUE, '2026-05-14 06:15:00')
ON DUPLICATE KEY UPDATE
target_minutes = VALUES(target_minutes),
achieved_minutes = VALUES(achieved_minutes),
is_completed = VALUES(is_completed);
INSERT INTO coding_sessions (user_id, topic_id, language_id, session_date, start_time, end_time, duration_minutes, notes, is_timer_session, created_at, updated_at) VALUES
(@admin_id, (SELECT id FROM topics WHERE name = 'React.js' LIMIT 1), (SELECT id FROM programming_languages WHERE name = 'Python' LIMIT 1), '2026-05-14', '08:27:00', '10:52:00', 145, 'DEMO100: refactored frontend state handling and tested the page.', TRUE, '2026-05-14 10:52:00', '2026-05-14 10:52:00');
SET @demo_session_id := LAST_INSERT_ID();
INSERT INTO coding_sessions (user_id, topic_id, language_id, session_date, start_time, end_time, duration_minutes, notes, is_timer_session, created_at, updated_at) VALUES
(@admin_id, (SELECT id FROM topics WHERE name = 'Spring Security' LIMIT 1), (SELECT id FROM programming_languages WHERE name = 'TypeScript' LIMIT 1), '2026-05-14', '19:06:00', '20:07:00', 61, 'DEMO100: evening review and cleanup session.', FALSE, '2026-05-14 20:07:00', '2026-05-14 20:07:00');
SET @demo_session_id := LAST_INSERT_ID();

-- Day 35: 2026-05-15
INSERT INTO daily_goals (user_id, goal_date, target_minutes, achieved_minutes, is_completed, created_at) VALUES
(@admin_id, '2026-05-15', 120, 113, FALSE, '2026-05-15 06:15:00')
ON DUPLICATE KEY UPDATE
target_minutes = VALUES(target_minutes),
achieved_minutes = VALUES(achieved_minutes),
is_completed = VALUES(is_completed);
INSERT INTO coding_sessions (user_id, topic_id, language_id, session_date, start_time, end_time, duration_minutes, notes, is_timer_session, created_at, updated_at) VALUES
(@admin_id, (SELECT id FROM topics WHERE name = 'MySQL' LIMIT 1), (SELECT id FROM programming_languages WHERE name = 'HTML/CSS' LIMIT 1), '2026-05-15', '08:46:00', '10:39:00', 113, 'DEMO100: wrote SQL query practice and checked report numbers.', FALSE, '2026-05-15 10:39:00', '2026-05-15 10:39:00');
SET @demo_session_id := LAST_INSERT_ID();
INSERT INTO problems_solved (user_id, session_id, platform, problem_name, problem_url, difficulty, is_solved, time_taken_minutes, notes, solved_date, created_at) VALUES
(@admin_id, @demo_session_id, 'LeetCode', 'Contains Duplicate', 'https://leetcode.com/problems/contains-duplicate/', 'EASY', TRUE, 36, 'DEMO100: solved during the 100-day practice streak.', '2026-05-15', '2026-05-15 10:59:00');

-- Day 36: 2026-05-16
INSERT INTO daily_goals (user_id, goal_date, target_minutes, achieved_minutes, is_completed, created_at) VALUES
(@admin_id, '2026-05-16', 90, 145, TRUE, '2026-05-16 06:15:00')
ON DUPLICATE KEY UPDATE
target_minutes = VALUES(target_minutes),
achieved_minutes = VALUES(achieved_minutes),
is_completed = VALUES(is_completed);
INSERT INTO coding_sessions (user_id, topic_id, language_id, session_date, start_time, end_time, duration_minutes, notes, is_timer_session, created_at, updated_at) VALUES
(@admin_id, (SELECT id FROM topics WHERE name = 'Arrays & Strings' LIMIT 1), (SELECT id FROM programming_languages WHERE name = 'TypeScript' LIMIT 1), '2026-05-16', '09:05:00', '11:30:00', 145, 'DEMO100: studied algorithm pattern and solved a related problem.', FALSE, '2026-05-16 11:30:00', '2026-05-16 11:30:00');
SET @demo_session_id := LAST_INSERT_ID();

-- Day 37: 2026-05-17
INSERT INTO daily_goals (user_id, goal_date, target_minutes, achieved_minutes, is_completed, created_at) VALUES
(@admin_id, '2026-05-17', 90, 87, FALSE, '2026-05-17 06:15:00')
ON DUPLICATE KEY UPDATE
target_minutes = VALUES(target_minutes),
achieved_minutes = VALUES(achieved_minutes),
is_completed = VALUES(is_completed);
INSERT INTO coding_sessions (user_id, topic_id, language_id, session_date, start_time, end_time, duration_minutes, notes, is_timer_session, created_at, updated_at) VALUES
(@admin_id, (SELECT id FROM topics WHERE name = 'Spring Security' LIMIT 1), (SELECT id FROM programming_languages WHERE name = 'Java' LIMIT 1), '2026-05-17', '09:24:00', '10:51:00', 87, 'DEMO100: reviewed JWT/auth flow and cleaned edge cases.', TRUE, '2026-05-17 10:51:00', '2026-05-17 10:51:00');
SET @demo_session_id := LAST_INSERT_ID();
INSERT INTO problems_solved (user_id, session_id, platform, problem_name, problem_url, difficulty, is_solved, time_taken_minutes, notes, solved_date, created_at) VALUES
(@admin_id, @demo_session_id, 'LeetCode', 'Product of Array Except Self', 'https://leetcode.com/problems/product-of-array-except-self/', 'MEDIUM', FALSE, 42, 'DEMO100: attempted during the 100-day practice streak.', '2026-05-17', '2026-05-17 11:11:00');

-- Day 38: 2026-05-18
INSERT INTO daily_goals (user_id, goal_date, target_minutes, achieved_minutes, is_completed, created_at) VALUES
(@admin_id, '2026-05-18', 120, 164, TRUE, '2026-05-18 06:15:00')
ON DUPLICATE KEY UPDATE
target_minutes = VALUES(target_minutes),
achieved_minutes = VALUES(achieved_minutes),
is_completed = VALUES(is_completed);
INSERT INTO coding_sessions (user_id, topic_id, language_id, session_date, start_time, end_time, duration_minutes, notes, is_timer_session, created_at, updated_at) VALUES
(@admin_id, (SELECT id FROM topics WHERE name = 'SQL Queries' LIMIT 1), (SELECT id FROM programming_languages WHERE name = 'JavaScript' LIMIT 1), '2026-05-18', '09:43:00', '12:08:00', 145, 'DEMO100: connected UI action to real API data.', FALSE, '2026-05-18 12:08:00', '2026-05-18 12:08:00');
SET @demo_session_id := LAST_INSERT_ID();
INSERT INTO coding_sessions (user_id, topic_id, language_id, session_date, start_time, end_time, duration_minutes, notes, is_timer_session, created_at, updated_at) VALUES
(@admin_id, (SELECT id FROM topics WHERE name = 'Spring Boot' LIMIT 1), (SELECT id FROM programming_languages WHERE name = 'Python' LIMIT 1), '2026-05-18', '19:34:00', '19:53:00', 19, 'DEMO100: evening review and cleanup session.', FALSE, '2026-05-18 19:53:00', '2026-05-18 19:53:00');
SET @demo_session_id := LAST_INSERT_ID();

-- Day 39: 2026-05-19
INSERT INTO daily_goals (user_id, goal_date, target_minutes, achieved_minutes, is_completed, created_at) VALUES
(@admin_id, '2026-05-19', 120, 201, TRUE, '2026-05-19 06:15:00')
ON DUPLICATE KEY UPDATE
target_minutes = VALUES(target_minutes),
achieved_minutes = VALUES(achieved_minutes),
is_completed = VALUES(is_completed);
INSERT INTO coding_sessions (user_id, topic_id, language_id, session_date, start_time, end_time, duration_minutes, notes, is_timer_session, created_at, updated_at) VALUES
(@admin_id, (SELECT id FROM topics WHERE name = 'Git & GitHub' LIMIT 1), (SELECT id FROM programming_languages WHERE name = 'SQL' LIMIT 1), '2026-05-19', '08:02:00', '10:27:00', 145, 'DEMO100: reviewed Git workflow and documented progress.', FALSE, '2026-05-19 10:27:00', '2026-05-19 10:27:00');
SET @demo_session_id := LAST_INSERT_ID();
INSERT INTO coding_sessions (user_id, topic_id, language_id, session_date, start_time, end_time, duration_minutes, notes, is_timer_session, created_at, updated_at) VALUES
(@admin_id, (SELECT id FROM topics WHERE name = 'React.js' LIMIT 1), (SELECT id FROM programming_languages WHERE name = 'HTML/CSS' LIMIT 1), '2026-05-19', '19:41:00', '20:37:00', 56, 'DEMO100: evening review and cleanup session.', FALSE, '2026-05-19 20:37:00', '2026-05-19 20:37:00');
SET @demo_session_id := LAST_INSERT_ID();
INSERT INTO problems_solved (user_id, session_id, platform, problem_name, problem_url, difficulty, is_solved, time_taken_minutes, notes, solved_date, created_at) VALUES
(@admin_id, @demo_session_id, 'LeetCode', 'Climbing Stairs', 'https://leetcode.com/problems/climbing-stairs/', 'EASY', TRUE, 30, 'DEMO100: solved during the 100-day practice streak.', '2026-05-19', '2026-05-19 10:47:00');

-- Day 40: 2026-05-20
INSERT INTO daily_goals (user_id, goal_date, target_minutes, achieved_minutes, is_completed, created_at) VALUES
(@admin_id, '2026-05-20', 120, 143, TRUE, '2026-05-20 06:15:00')
ON DUPLICATE KEY UPDATE
target_minutes = VALUES(target_minutes),
achieved_minutes = VALUES(achieved_minutes),
is_completed = VALUES(is_completed);
INSERT INTO coding_sessions (user_id, topic_id, language_id, session_date, start_time, end_time, duration_minutes, notes, is_timer_session, created_at, updated_at) VALUES
(@admin_id, (SELECT id FROM topics WHERE name = 'System Design' LIMIT 1), (SELECT id FROM programming_languages WHERE name = 'Python' LIMIT 1), '2026-05-20', '08:21:00', '10:44:00', 143, 'DEMO100: planned architecture decisions from a product perspective.', TRUE, '2026-05-20 10:44:00', '2026-05-20 10:44:00');
SET @demo_session_id := LAST_INSERT_ID();

-- Day 41: 2026-05-21
INSERT INTO daily_goals (user_id, goal_date, target_minutes, achieved_minutes, is_completed, created_at) VALUES
(@admin_id, '2026-05-21', 120, 180, TRUE, '2026-05-21 06:15:00')
ON DUPLICATE KEY UPDATE
target_minutes = VALUES(target_minutes),
achieved_minutes = VALUES(achieved_minutes),
is_completed = VALUES(is_completed);
INSERT INTO coding_sessions (user_id, topic_id, language_id, session_date, start_time, end_time, duration_minutes, notes, is_timer_session, created_at, updated_at) VALUES
(@admin_id, (SELECT id FROM topics WHERE name = 'Spring Boot' LIMIT 1), (SELECT id FROM programming_languages WHERE name = 'HTML/CSS' LIMIT 1), '2026-05-21', '08:40:00', '11:05:00', 145, 'DEMO100: implemented backend endpoint and verified request flow.', FALSE, '2026-05-21 11:05:00', '2026-05-21 11:05:00');
SET @demo_session_id := LAST_INSERT_ID();
INSERT INTO coding_sessions (user_id, topic_id, language_id, session_date, start_time, end_time, duration_minutes, notes, is_timer_session, created_at, updated_at) VALUES
(@admin_id, (SELECT id FROM topics WHERE name = 'Arrays & Strings' LIMIT 1), (SELECT id FROM programming_languages WHERE name = 'Java' LIMIT 1), '2026-05-21', '19:55:00', '20:30:00', 35, 'DEMO100: evening review and cleanup session.', FALSE, '2026-05-21 20:30:00', '2026-05-21 20:30:00');
SET @demo_session_id := LAST_INSERT_ID();
INSERT INTO problems_solved (user_id, session_id, platform, problem_name, problem_url, difficulty, is_solved, time_taken_minutes, notes, solved_date, created_at) VALUES
(@admin_id, @demo_session_id, 'LeetCode', 'Invert Binary Tree', 'https://leetcode.com/problems/invert-binary-tree/', 'HARD', TRUE, 75, 'DEMO100: solved during the 100-day practice streak.', '2026-05-21', '2026-05-21 11:25:00');
INSERT INTO problems_solved (user_id, session_id, platform, problem_name, problem_url, difficulty, is_solved, time_taken_minutes, notes, solved_date, created_at) VALUES
(@admin_id, @demo_session_id, 'HackerRank', 'Subsets', 'https://www.hackerrank.com/challenges/subsets/problem', 'MEDIUM', TRUE, 28, 'DEMO100: solved as a stretch problem after the main session.', '2026-05-21', '2026-05-21 11:40:00');

-- Day 42: 2026-05-22
INSERT INTO daily_goals (user_id, goal_date, target_minutes, achieved_minutes, is_completed, created_at) VALUES
(@admin_id, '2026-05-22', 120, 217, TRUE, '2026-05-22 06:15:00')
ON DUPLICATE KEY UPDATE
target_minutes = VALUES(target_minutes),
achieved_minutes = VALUES(achieved_minutes),
is_completed = VALUES(is_completed);
INSERT INTO coding_sessions (user_id, topic_id, language_id, session_date, start_time, end_time, duration_minutes, notes, is_timer_session, created_at, updated_at) VALUES
(@admin_id, (SELECT id FROM topics WHERE name = 'React.js' LIMIT 1), (SELECT id FROM programming_languages WHERE name = 'TypeScript' LIMIT 1), '2026-05-22', '08:59:00', '11:24:00', 145, 'DEMO100: refactored frontend state handling and tested the page.', FALSE, '2026-05-22 11:24:00', '2026-05-22 11:24:00');
SET @demo_session_id := LAST_INSERT_ID();
INSERT INTO coding_sessions (user_id, topic_id, language_id, session_date, start_time, end_time, duration_minutes, notes, is_timer_session, created_at, updated_at) VALUES
(@admin_id, (SELECT id FROM topics WHERE name = 'Spring Security' LIMIT 1), (SELECT id FROM programming_languages WHERE name = 'JavaScript' LIMIT 1), '2026-05-22', '20:02:00', '21:14:00', 72, 'DEMO100: evening review and cleanup session.', FALSE, '2026-05-22 21:14:00', '2026-05-22 21:14:00');
SET @demo_session_id := LAST_INSERT_ID();

-- Day 43: 2026-05-23
INSERT INTO daily_goals (user_id, goal_date, target_minutes, achieved_minutes, is_completed, created_at) VALUES
(@admin_id, '2026-05-23', 90, 119, TRUE, '2026-05-23 06:15:00')
ON DUPLICATE KEY UPDATE
target_minutes = VALUES(target_minutes),
achieved_minutes = VALUES(achieved_minutes),
is_completed = VALUES(is_completed);
INSERT INTO coding_sessions (user_id, topic_id, language_id, session_date, start_time, end_time, duration_minutes, notes, is_timer_session, created_at, updated_at) VALUES
(@admin_id, (SELECT id FROM topics WHERE name = 'MySQL' LIMIT 1), (SELECT id FROM programming_languages WHERE name = 'Java' LIMIT 1), '2026-05-23', '09:18:00', '11:17:00', 119, 'DEMO100: wrote SQL query practice and checked report numbers.', TRUE, '2026-05-23 11:17:00', '2026-05-23 11:17:00');
SET @demo_session_id := LAST_INSERT_ID();
INSERT INTO problems_solved (user_id, session_id, platform, problem_name, problem_url, difficulty, is_solved, time_taken_minutes, notes, solved_date, created_at) VALUES
(@admin_id, @demo_session_id, 'LeetCode', 'Number of Islands', 'https://leetcode.com/problems/number-of-islands/', 'MEDIUM', TRUE, 49, 'DEMO100: solved during the 100-day practice streak.', '2026-05-23', '2026-05-23 11:37:00');

-- Day 44: 2026-05-24
INSERT INTO daily_goals (user_id, goal_date, target_minutes, achieved_minutes, is_completed, created_at) VALUES
(@admin_id, '2026-05-24', 90, 156, TRUE, '2026-05-24 06:15:00')
ON DUPLICATE KEY UPDATE
target_minutes = VALUES(target_minutes),
achieved_minutes = VALUES(achieved_minutes),
is_completed = VALUES(is_completed);
INSERT INTO coding_sessions (user_id, topic_id, language_id, session_date, start_time, end_time, duration_minutes, notes, is_timer_session, created_at, updated_at) VALUES
(@admin_id, (SELECT id FROM topics WHERE name = 'Arrays & Strings' LIMIT 1), (SELECT id FROM programming_languages WHERE name = 'JavaScript' LIMIT 1), '2026-05-24', '09:37:00', '12:02:00', 145, 'DEMO100: studied algorithm pattern and solved a related problem.', FALSE, '2026-05-24 12:02:00', '2026-05-24 12:02:00');
SET @demo_session_id := LAST_INSERT_ID();
INSERT INTO coding_sessions (user_id, topic_id, language_id, session_date, start_time, end_time, duration_minutes, notes, is_timer_session, created_at, updated_at) VALUES
(@admin_id, (SELECT id FROM topics WHERE name = 'Git & GitHub' LIMIT 1), (SELECT id FROM programming_languages WHERE name = 'Python' LIMIT 1), '2026-05-24', '19:01:00', '19:12:00', 11, 'DEMO100: evening review and cleanup session.', FALSE, '2026-05-24 19:12:00', '2026-05-24 19:12:00');
SET @demo_session_id := LAST_INSERT_ID();

-- Day 45: 2026-05-25
INSERT INTO daily_goals (user_id, goal_date, target_minutes, achieved_minutes, is_completed, created_at) VALUES
(@admin_id, '2026-05-25', 120, 138, TRUE, '2026-05-25 06:15:00')
ON DUPLICATE KEY UPDATE
target_minutes = VALUES(target_minutes),
achieved_minutes = VALUES(achieved_minutes),
is_completed = VALUES(is_completed);
INSERT INTO coding_sessions (user_id, topic_id, language_id, session_date, start_time, end_time, duration_minutes, notes, is_timer_session, created_at, updated_at) VALUES
(@admin_id, (SELECT id FROM topics WHERE name = 'Spring Security' LIMIT 1), (SELECT id FROM programming_languages WHERE name = 'SQL' LIMIT 1), '2026-05-25', '09:56:00', '12:14:00', 138, 'DEMO100: reviewed JWT/auth flow and cleaned edge cases.', FALSE, '2026-05-25 12:14:00', '2026-05-25 12:14:00');
SET @demo_session_id := LAST_INSERT_ID();
INSERT INTO problems_solved (user_id, session_id, platform, problem_name, problem_url, difficulty, is_solved, time_taken_minutes, notes, solved_date, created_at) VALUES
(@admin_id, @demo_session_id, 'LeetCode', 'Group Anagrams', 'https://leetcode.com/problems/group-anagrams/', 'EASY', TRUE, 21, 'DEMO100: solved during the 100-day practice streak.', '2026-05-25', '2026-05-25 12:34:00');

-- Day 46: 2026-05-26
INSERT INTO daily_goals (user_id, goal_date, target_minutes, achieved_minutes, is_completed, created_at) VALUES
(@admin_id, '2026-05-26', 120, 175, TRUE, '2026-05-26 06:15:00')
ON DUPLICATE KEY UPDATE
target_minutes = VALUES(target_minutes),
achieved_minutes = VALUES(achieved_minutes),
is_completed = VALUES(is_completed);
INSERT INTO coding_sessions (user_id, topic_id, language_id, session_date, start_time, end_time, duration_minutes, notes, is_timer_session, created_at, updated_at) VALUES
(@admin_id, (SELECT id FROM topics WHERE name = 'SQL Queries' LIMIT 1), (SELECT id FROM programming_languages WHERE name = 'Python' LIMIT 1), '2026-05-26', '08:15:00', '10:40:00', 145, 'DEMO100: connected UI action to real API data.', TRUE, '2026-05-26 10:40:00', '2026-05-26 10:40:00');
SET @demo_session_id := LAST_INSERT_ID();
INSERT INTO coding_sessions (user_id, topic_id, language_id, session_date, start_time, end_time, duration_minutes, notes, is_timer_session, created_at, updated_at) VALUES
(@admin_id, (SELECT id FROM topics WHERE name = 'Spring Boot' LIMIT 1), (SELECT id FROM programming_languages WHERE name = 'TypeScript' LIMIT 1), '2026-05-26', '19:15:00', '19:45:00', 30, 'DEMO100: evening review and cleanup session.', FALSE, '2026-05-26 19:45:00', '2026-05-26 19:45:00');
SET @demo_session_id := LAST_INSERT_ID();

-- Day 47: 2026-05-27
INSERT INTO daily_goals (user_id, goal_date, target_minutes, achieved_minutes, is_completed, created_at) VALUES
(@admin_id, '2026-05-27', 120, 272, TRUE, '2026-05-27 06:15:00')
ON DUPLICATE KEY UPDATE
target_minutes = VALUES(target_minutes),
achieved_minutes = VALUES(achieved_minutes),
is_completed = VALUES(is_completed);
INSERT INTO coding_sessions (user_id, topic_id, language_id, session_date, start_time, end_time, duration_minutes, notes, is_timer_session, created_at, updated_at) VALUES
(@admin_id, (SELECT id FROM topics WHERE name = 'Git & GitHub' LIMIT 1), (SELECT id FROM programming_languages WHERE name = 'HTML/CSS' LIMIT 1), '2026-05-27', '08:34:00', '10:59:00', 145, 'DEMO100: reviewed Git workflow and documented progress.', FALSE, '2026-05-27 10:59:00', '2026-05-27 10:59:00');
SET @demo_session_id := LAST_INSERT_ID();
INSERT INTO coding_sessions (user_id, topic_id, language_id, session_date, start_time, end_time, duration_minutes, notes, is_timer_session, created_at, updated_at) VALUES
(@admin_id, (SELECT id FROM topics WHERE name = 'React.js' LIMIT 1), (SELECT id FROM programming_languages WHERE name = 'Java' LIMIT 1), '2026-05-27', '19:22:00', '21:29:00', 127, 'DEMO100: evening review and cleanup session.', FALSE, '2026-05-27 21:29:00', '2026-05-27 21:29:00');
SET @demo_session_id := LAST_INSERT_ID();
INSERT INTO problems_solved (user_id, session_id, platform, problem_name, problem_url, difficulty, is_solved, time_taken_minutes, notes, solved_date, created_at) VALUES
(@admin_id, @demo_session_id, 'LeetCode', 'Course Schedule', 'https://leetcode.com/problems/course-schedule/', 'EASY', TRUE, 18, 'DEMO100: solved during the 100-day practice streak.', '2026-05-27', '2026-05-27 11:19:00');

-- Day 48: 2026-05-28
INSERT INTO daily_goals (user_id, goal_date, target_minutes, achieved_minutes, is_completed, created_at) VALUES
(@admin_id, '2026-05-28', 120, 154, TRUE, '2026-05-28 06:15:00')
ON DUPLICATE KEY UPDATE
target_minutes = VALUES(target_minutes),
achieved_minutes = VALUES(achieved_minutes),
is_completed = VALUES(is_completed);
INSERT INTO coding_sessions (user_id, topic_id, language_id, session_date, start_time, end_time, duration_minutes, notes, is_timer_session, created_at, updated_at) VALUES
(@admin_id, (SELECT id FROM topics WHERE name = 'System Design' LIMIT 1), (SELECT id FROM programming_languages WHERE name = 'TypeScript' LIMIT 1), '2026-05-28', '08:53:00', '11:18:00', 145, 'DEMO100: planned architecture decisions from a product perspective.', FALSE, '2026-05-28 11:18:00', '2026-05-28 11:18:00');
SET @demo_session_id := LAST_INSERT_ID();
INSERT INTO coding_sessions (user_id, topic_id, language_id, session_date, start_time, end_time, duration_minutes, notes, is_timer_session, created_at, updated_at) VALUES
(@admin_id, (SELECT id FROM topics WHERE name = 'MySQL' LIMIT 1), (SELECT id FROM programming_languages WHERE name = 'JavaScript' LIMIT 1), '2026-05-28', '19:29:00', '19:38:00', 9, 'DEMO100: evening review and cleanup session.', FALSE, '2026-05-28 19:38:00', '2026-05-28 19:38:00');
SET @demo_session_id := LAST_INSERT_ID();

-- Day 49: 2026-05-29
INSERT INTO daily_goals (user_id, goal_date, target_minutes, achieved_minutes, is_completed, created_at) VALUES
(@admin_id, '2026-05-29', 120, 191, TRUE, '2026-05-29 06:15:00')
ON DUPLICATE KEY UPDATE
target_minutes = VALUES(target_minutes),
achieved_minutes = VALUES(achieved_minutes),
is_completed = VALUES(is_completed);
INSERT INTO coding_sessions (user_id, topic_id, language_id, session_date, start_time, end_time, duration_minutes, notes, is_timer_session, created_at, updated_at) VALUES
(@admin_id, (SELECT id FROM topics WHERE name = 'Spring Boot' LIMIT 1), (SELECT id FROM programming_languages WHERE name = 'Java' LIMIT 1), '2026-05-29', '09:12:00', '11:37:00', 145, 'DEMO100: implemented backend endpoint and verified request flow.', TRUE, '2026-05-29 11:37:00', '2026-05-29 11:37:00');
SET @demo_session_id := LAST_INSERT_ID();
INSERT INTO coding_sessions (user_id, topic_id, language_id, session_date, start_time, end_time, duration_minutes, notes, is_timer_session, created_at, updated_at) VALUES
(@admin_id, (SELECT id FROM topics WHERE name = 'Arrays & Strings' LIMIT 1), (SELECT id FROM programming_languages WHERE name = 'SQL' LIMIT 1), '2026-05-29', '19:36:00', '20:22:00', 46, 'DEMO100: evening review and cleanup session.', FALSE, '2026-05-29 20:22:00', '2026-05-29 20:22:00');
SET @demo_session_id := LAST_INSERT_ID();
INSERT INTO problems_solved (user_id, session_id, platform, problem_name, problem_url, difficulty, is_solved, time_taken_minutes, notes, solved_date, created_at) VALUES
(@admin_id, @demo_session_id, 'LeetCode', 'House Robber', 'https://leetcode.com/problems/house-robber/', 'MEDIUM', TRUE, 56, 'DEMO100: solved during the 100-day practice streak.', '2026-05-29', '2026-05-29 11:57:00');

-- Day 50: 2026-05-30
INSERT INTO daily_goals (user_id, goal_date, target_minutes, achieved_minutes, is_completed, created_at) VALUES
(@admin_id, '2026-05-30', 90, 93, TRUE, '2026-05-30 06:15:00')
ON DUPLICATE KEY UPDATE
target_minutes = VALUES(target_minutes),
achieved_minutes = VALUES(achieved_minutes),
is_completed = VALUES(is_completed);
INSERT INTO coding_sessions (user_id, topic_id, language_id, session_date, start_time, end_time, duration_minutes, notes, is_timer_session, created_at, updated_at) VALUES
(@admin_id, (SELECT id FROM topics WHERE name = 'React.js' LIMIT 1), (SELECT id FROM programming_languages WHERE name = 'JavaScript' LIMIT 1), '2026-05-30', '09:31:00', '11:04:00', 93, 'DEMO100: refactored frontend state handling and tested the page.', FALSE, '2026-05-30 11:04:00', '2026-05-30 11:04:00');
SET @demo_session_id := LAST_INSERT_ID();

-- Day 51: 2026-05-31
INSERT INTO daily_goals (user_id, goal_date, target_minutes, achieved_minutes, is_completed, created_at) VALUES
(@admin_id, '2026-05-31', 90, 130, TRUE, '2026-05-31 06:15:00')
ON DUPLICATE KEY UPDATE
target_minutes = VALUES(target_minutes),
achieved_minutes = VALUES(achieved_minutes),
is_completed = VALUES(is_completed);
INSERT INTO coding_sessions (user_id, topic_id, language_id, session_date, start_time, end_time, duration_minutes, notes, is_timer_session, created_at, updated_at) VALUES
(@admin_id, (SELECT id FROM topics WHERE name = 'MySQL' LIMIT 1), (SELECT id FROM programming_languages WHERE name = 'SQL' LIMIT 1), '2026-05-31', '09:50:00', '12:00:00', 130, 'DEMO100: wrote SQL query practice and checked report numbers.', FALSE, '2026-05-31 12:00:00', '2026-05-31 12:00:00');
SET @demo_session_id := LAST_INSERT_ID();
INSERT INTO problems_solved (user_id, session_id, platform, problem_name, problem_url, difficulty, is_solved, time_taken_minutes, notes, solved_date, created_at) VALUES
(@admin_id, @demo_session_id, 'LeetCode', 'Kth Largest Element in an Array', 'https://leetcode.com/problems/kth-largest-element-in-an-array/', 'HARD', TRUE, 75, 'DEMO100: solved during the 100-day practice streak.', '2026-05-31', '2026-05-31 12:20:00');
INSERT INTO problems_solved (user_id, session_id, platform, problem_name, problem_url, difficulty, is_solved, time_taken_minutes, notes, solved_date, created_at) VALUES
(@admin_id, @demo_session_id, 'HackerRank', 'Valid Parentheses', 'https://www.hackerrank.com/challenges/valid-parentheses/problem', 'MEDIUM', TRUE, 38, 'DEMO100: solved as a stretch problem after the main session.', '2026-05-31', '2026-05-31 12:35:00');

-- Day 52: 2026-06-01
INSERT INTO daily_goals (user_id, goal_date, target_minutes, achieved_minutes, is_completed, created_at) VALUES
(@admin_id, '2026-06-01', 120, 172, TRUE, '2026-06-01 06:15:00')
ON DUPLICATE KEY UPDATE
target_minutes = VALUES(target_minutes),
achieved_minutes = VALUES(achieved_minutes),
is_completed = VALUES(is_completed);
INSERT INTO coding_sessions (user_id, topic_id, language_id, session_date, start_time, end_time, duration_minutes, notes, is_timer_session, created_at, updated_at) VALUES
(@admin_id, (SELECT id FROM topics WHERE name = 'Arrays & Strings' LIMIT 1), (SELECT id FROM programming_languages WHERE name = 'Python' LIMIT 1), '2026-06-01', '08:09:00', '10:34:00', 145, 'DEMO100: studied algorithm pattern and solved a related problem.', TRUE, '2026-06-01 10:34:00', '2026-06-01 10:34:00');
SET @demo_session_id := LAST_INSERT_ID();
INSERT INTO coding_sessions (user_id, topic_id, language_id, session_date, start_time, end_time, duration_minutes, notes, is_timer_session, created_at, updated_at) VALUES
(@admin_id, (SELECT id FROM topics WHERE name = 'Git & GitHub' LIMIT 1), (SELECT id FROM programming_languages WHERE name = 'TypeScript' LIMIT 1), '2026-06-01', '19:57:00', '20:24:00', 27, 'DEMO100: evening review and cleanup session.', FALSE, '2026-06-01 20:24:00', '2026-06-01 20:24:00');
SET @demo_session_id := LAST_INSERT_ID();

-- Day 53: 2026-06-02
INSERT INTO daily_goals (user_id, goal_date, target_minutes, achieved_minutes, is_completed, created_at) VALUES
(@admin_id, '2026-06-02', 120, 149, TRUE, '2026-06-02 06:15:00')
ON DUPLICATE KEY UPDATE
target_minutes = VALUES(target_minutes),
achieved_minutes = VALUES(achieved_minutes),
is_completed = VALUES(is_completed);
INSERT INTO coding_sessions (user_id, topic_id, language_id, session_date, start_time, end_time, duration_minutes, notes, is_timer_session, created_at, updated_at) VALUES
(@admin_id, (SELECT id FROM topics WHERE name = 'Spring Security' LIMIT 1), (SELECT id FROM programming_languages WHERE name = 'HTML/CSS' LIMIT 1), '2026-06-02', '08:28:00', '10:53:00', 145, 'DEMO100: reviewed JWT/auth flow and cleaned edge cases.', FALSE, '2026-06-02 10:53:00', '2026-06-02 10:53:00');
SET @demo_session_id := LAST_INSERT_ID();
INSERT INTO coding_sessions (user_id, topic_id, language_id, session_date, start_time, end_time, duration_minutes, notes, is_timer_session, created_at, updated_at) VALUES
(@admin_id, (SELECT id FROM topics WHERE name = 'System Design' LIMIT 1), (SELECT id FROM programming_languages WHERE name = 'Java' LIMIT 1), '2026-06-02', '20:04:00', '20:08:00', 4, 'DEMO100: evening review and cleanup session.', FALSE, '2026-06-02 20:08:00', '2026-06-02 20:08:00');
SET @demo_session_id := LAST_INSERT_ID();
INSERT INTO problems_solved (user_id, session_id, platform, problem_name, problem_url, difficulty, is_solved, time_taken_minutes, notes, solved_date, created_at) VALUES
(@admin_id, @demo_session_id, 'LeetCode', 'Combination Sum', 'https://leetcode.com/problems/combination-sum/', 'EASY', TRUE, 34, 'DEMO100: solved during the 100-day practice streak.', '2026-06-02', '2026-06-02 11:13:00');

-- Day 54: 2026-06-03
INSERT INTO daily_goals (user_id, goal_date, target_minutes, achieved_minutes, is_completed, created_at) VALUES
(@admin_id, '2026-06-03', 120, 186, TRUE, '2026-06-03 06:15:00')
ON DUPLICATE KEY UPDATE
target_minutes = VALUES(target_minutes),
achieved_minutes = VALUES(achieved_minutes),
is_completed = VALUES(is_completed);
INSERT INTO coding_sessions (user_id, topic_id, language_id, session_date, start_time, end_time, duration_minutes, notes, is_timer_session, created_at, updated_at) VALUES
(@admin_id, (SELECT id FROM topics WHERE name = 'SQL Queries' LIMIT 1), (SELECT id FROM programming_languages WHERE name = 'TypeScript' LIMIT 1), '2026-06-03', '08:47:00', '11:12:00', 145, 'DEMO100: connected UI action to real API data.', FALSE, '2026-06-03 11:12:00', '2026-06-03 11:12:00');
SET @demo_session_id := LAST_INSERT_ID();
INSERT INTO coding_sessions (user_id, topic_id, language_id, session_date, start_time, end_time, duration_minutes, notes, is_timer_session, created_at, updated_at) VALUES
(@admin_id, (SELECT id FROM topics WHERE name = 'Spring Boot' LIMIT 1), (SELECT id FROM programming_languages WHERE name = 'JavaScript' LIMIT 1), '2026-06-03', '20:11:00', '20:52:00', 41, 'DEMO100: evening review and cleanup session.', FALSE, '2026-06-03 20:52:00', '2026-06-03 20:52:00');
SET @demo_session_id := LAST_INSERT_ID();

-- Day 55: 2026-06-04
INSERT INTO daily_goals (user_id, goal_date, target_minutes, achieved_minutes, is_completed, created_at) VALUES
(@admin_id, '2026-06-04', 120, 128, TRUE, '2026-06-04 06:15:00')
ON DUPLICATE KEY UPDATE
target_minutes = VALUES(target_minutes),
achieved_minutes = VALUES(achieved_minutes),
is_completed = VALUES(is_completed);
INSERT INTO coding_sessions (user_id, topic_id, language_id, session_date, start_time, end_time, duration_minutes, notes, is_timer_session, created_at, updated_at) VALUES
(@admin_id, (SELECT id FROM topics WHERE name = 'Git & GitHub' LIMIT 1), (SELECT id FROM programming_languages WHERE name = 'Java' LIMIT 1), '2026-06-04', '09:06:00', '11:14:00', 128, 'DEMO100: reviewed Git workflow and documented progress.', TRUE, '2026-06-04 11:14:00', '2026-06-04 11:14:00');
SET @demo_session_id := LAST_INSERT_ID();
INSERT INTO problems_solved (user_id, session_id, platform, problem_name, problem_url, difficulty, is_solved, time_taken_minutes, notes, solved_date, created_at) VALUES
(@admin_id, @demo_session_id, 'LeetCode', 'Validate Binary Search Tree', 'https://leetcode.com/problems/validate-binary-search-tree/', 'MEDIUM', FALSE, 63, 'DEMO100: attempted during the 100-day practice streak.', '2026-06-04', '2026-06-04 11:34:00');

-- Day 56: 2026-06-05
INSERT INTO daily_goals (user_id, goal_date, target_minutes, achieved_minutes, is_completed, created_at) VALUES
(@admin_id, '2026-06-05', 120, 165, TRUE, '2026-06-05 06:15:00')
ON DUPLICATE KEY UPDATE
target_minutes = VALUES(target_minutes),
achieved_minutes = VALUES(achieved_minutes),
is_completed = VALUES(is_completed);
INSERT INTO coding_sessions (user_id, topic_id, language_id, session_date, start_time, end_time, duration_minutes, notes, is_timer_session, created_at, updated_at) VALUES
(@admin_id, (SELECT id FROM topics WHERE name = 'System Design' LIMIT 1), (SELECT id FROM programming_languages WHERE name = 'JavaScript' LIMIT 1), '2026-06-05', '09:25:00', '11:50:00', 145, 'DEMO100: planned architecture decisions from a product perspective.', FALSE, '2026-06-05 11:50:00', '2026-06-05 11:50:00');
SET @demo_session_id := LAST_INSERT_ID();
INSERT INTO coding_sessions (user_id, topic_id, language_id, session_date, start_time, end_time, duration_minutes, notes, is_timer_session, created_at, updated_at) VALUES
(@admin_id, (SELECT id FROM topics WHERE name = 'MySQL' LIMIT 1), (SELECT id FROM programming_languages WHERE name = 'Python' LIMIT 1), '2026-06-05', '19:10:00', '19:30:00', 20, 'DEMO100: evening review and cleanup session.', FALSE, '2026-06-05 19:30:00', '2026-06-05 19:30:00');
SET @demo_session_id := LAST_INSERT_ID();

-- Day 57: 2026-06-06
INSERT INTO daily_goals (user_id, goal_date, target_minutes, achieved_minutes, is_completed, created_at) VALUES
(@admin_id, '2026-06-06', 90, 162, TRUE, '2026-06-06 06:15:00')
ON DUPLICATE KEY UPDATE
target_minutes = VALUES(target_minutes),
achieved_minutes = VALUES(achieved_minutes),
is_completed = VALUES(is_completed);
INSERT INTO coding_sessions (user_id, topic_id, language_id, session_date, start_time, end_time, duration_minutes, notes, is_timer_session, created_at, updated_at) VALUES
(@admin_id, (SELECT id FROM topics WHERE name = 'Spring Boot' LIMIT 1), (SELECT id FROM programming_languages WHERE name = 'SQL' LIMIT 1), '2026-06-06', '09:44:00', '12:09:00', 145, 'DEMO100: implemented backend endpoint and verified request flow.', FALSE, '2026-06-06 12:09:00', '2026-06-06 12:09:00');
SET @demo_session_id := LAST_INSERT_ID();
INSERT INTO coding_sessions (user_id, topic_id, language_id, session_date, start_time, end_time, duration_minutes, notes, is_timer_session, created_at, updated_at) VALUES
(@admin_id, (SELECT id FROM topics WHERE name = 'Arrays & Strings' LIMIT 1), (SELECT id FROM programming_languages WHERE name = 'HTML/CSS' LIMIT 1), '2026-06-06', '19:17:00', '19:34:00', 17, 'DEMO100: evening review and cleanup session.', FALSE, '2026-06-06 19:34:00', '2026-06-06 19:34:00');
SET @demo_session_id := LAST_INSERT_ID();
INSERT INTO problems_solved (user_id, session_id, platform, problem_name, problem_url, difficulty, is_solved, time_taken_minutes, notes, solved_date, created_at) VALUES
(@admin_id, @demo_session_id, 'LeetCode', 'Rotting Oranges', 'https://leetcode.com/problems/rotting-oranges/', 'EASY', TRUE, 28, 'DEMO100: solved during the 100-day practice streak.', '2026-06-06', '2026-06-06 12:29:00');

-- Day 58: 2026-06-07
INSERT INTO daily_goals (user_id, goal_date, target_minutes, achieved_minutes, is_completed, created_at) VALUES
(@admin_id, '2026-06-07', 90, 104, TRUE, '2026-06-07 06:15:00')
ON DUPLICATE KEY UPDATE
target_minutes = VALUES(target_minutes),
achieved_minutes = VALUES(achieved_minutes),
is_completed = VALUES(is_completed);
INSERT INTO coding_sessions (user_id, topic_id, language_id, session_date, start_time, end_time, duration_minutes, notes, is_timer_session, created_at, updated_at) VALUES
(@admin_id, (SELECT id FROM topics WHERE name = 'React.js' LIMIT 1), (SELECT id FROM programming_languages WHERE name = 'Python' LIMIT 1), '2026-06-07', '08:03:00', '09:47:00', 104, 'DEMO100: refactored frontend state handling and tested the page.', TRUE, '2026-06-07 09:47:00', '2026-06-07 09:47:00');
SET @demo_session_id := LAST_INSERT_ID();

-- Day 59: 2026-06-08
INSERT INTO daily_goals (user_id, goal_date, target_minutes, achieved_minutes, is_completed, created_at) VALUES
(@admin_id, '2026-06-08', 120, 181, TRUE, '2026-06-08 06:15:00')
ON DUPLICATE KEY UPDATE
target_minutes = VALUES(target_minutes),
achieved_minutes = VALUES(achieved_minutes),
is_completed = VALUES(is_completed);
INSERT INTO coding_sessions (user_id, topic_id, language_id, session_date, start_time, end_time, duration_minutes, notes, is_timer_session, created_at, updated_at) VALUES
(@admin_id, (SELECT id FROM topics WHERE name = 'MySQL' LIMIT 1), (SELECT id FROM programming_languages WHERE name = 'HTML/CSS' LIMIT 1), '2026-06-08', '08:22:00', '10:47:00', 145, 'DEMO100: wrote SQL query practice and checked report numbers.', FALSE, '2026-06-08 10:47:00', '2026-06-08 10:47:00');
SET @demo_session_id := LAST_INSERT_ID();
INSERT INTO coding_sessions (user_id, topic_id, language_id, session_date, start_time, end_time, duration_minutes, notes, is_timer_session, created_at, updated_at) VALUES
(@admin_id, (SELECT id FROM topics WHERE name = 'SQL Queries' LIMIT 1), (SELECT id FROM programming_languages WHERE name = 'Java' LIMIT 1), '2026-06-08', '19:31:00', '20:07:00', 36, 'DEMO100: evening review and cleanup session.', FALSE, '2026-06-08 20:07:00', '2026-06-08 20:07:00');
SET @demo_session_id := LAST_INSERT_ID();
INSERT INTO problems_solved (user_id, session_id, platform, problem_name, problem_url, difficulty, is_solved, time_taken_minutes, notes, solved_date, created_at) VALUES
(@admin_id, @demo_session_id, 'LeetCode', 'Decode Ways', 'https://leetcode.com/problems/decode-ways/', 'EASY', TRUE, 25, 'DEMO100: solved during the 100-day practice streak.', '2026-06-08', '2026-06-08 11:07:00');

-- Day 60: 2026-06-09
INSERT INTO daily_goals (user_id, goal_date, target_minutes, achieved_minutes, is_completed, created_at) VALUES
(@admin_id, '2026-06-09', 120, 218, TRUE, '2026-06-09 06:15:00')
ON DUPLICATE KEY UPDATE
target_minutes = VALUES(target_minutes),
achieved_minutes = VALUES(achieved_minutes),
is_completed = VALUES(is_completed);
INSERT INTO coding_sessions (user_id, topic_id, language_id, session_date, start_time, end_time, duration_minutes, notes, is_timer_session, created_at, updated_at) VALUES
(@admin_id, (SELECT id FROM topics WHERE name = 'Arrays & Strings' LIMIT 1), (SELECT id FROM programming_languages WHERE name = 'TypeScript' LIMIT 1), '2026-06-09', '08:41:00', '11:06:00', 145, 'DEMO100: studied algorithm pattern and solved a related problem.', FALSE, '2026-06-09 11:06:00', '2026-06-09 11:06:00');
SET @demo_session_id := LAST_INSERT_ID();
INSERT INTO coding_sessions (user_id, topic_id, language_id, session_date, start_time, end_time, duration_minutes, notes, is_timer_session, created_at, updated_at) VALUES
(@admin_id, (SELECT id FROM topics WHERE name = 'Git & GitHub' LIMIT 1), (SELECT id FROM programming_languages WHERE name = 'JavaScript' LIMIT 1), '2026-06-09', '19:38:00', '20:51:00', 73, 'DEMO100: evening review and cleanup session.', FALSE, '2026-06-09 20:51:00', '2026-06-09 20:51:00');
SET @demo_session_id := LAST_INSERT_ID();

-- Day 61: 2026-06-10
INSERT INTO daily_goals (user_id, goal_date, target_minutes, achieved_minutes, is_completed, created_at) VALUES
(@admin_id, '2026-06-10', 120, 160, TRUE, '2026-06-10 06:15:00')
ON DUPLICATE KEY UPDATE
target_minutes = VALUES(target_minutes),
achieved_minutes = VALUES(achieved_minutes),
is_completed = VALUES(is_completed);
INSERT INTO coding_sessions (user_id, topic_id, language_id, session_date, start_time, end_time, duration_minutes, notes, is_timer_session, created_at, updated_at) VALUES
(@admin_id, (SELECT id FROM topics WHERE name = 'Spring Security' LIMIT 1), (SELECT id FROM programming_languages WHERE name = 'Java' LIMIT 1), '2026-06-10', '09:00:00', '11:25:00', 145, 'DEMO100: reviewed JWT/auth flow and cleaned edge cases.', TRUE, '2026-06-10 11:25:00', '2026-06-10 11:25:00');
SET @demo_session_id := LAST_INSERT_ID();
INSERT INTO coding_sessions (user_id, topic_id, language_id, session_date, start_time, end_time, duration_minutes, notes, is_timer_session, created_at, updated_at) VALUES
(@admin_id, (SELECT id FROM topics WHERE name = 'System Design' LIMIT 1), (SELECT id FROM programming_languages WHERE name = 'SQL' LIMIT 1), '2026-06-10', '19:45:00', '20:00:00', 15, 'DEMO100: evening review and cleanup session.', FALSE, '2026-06-10 20:00:00', '2026-06-10 20:00:00');
SET @demo_session_id := LAST_INSERT_ID();
INSERT INTO problems_solved (user_id, session_id, platform, problem_name, problem_url, difficulty, is_solved, time_taken_minutes, notes, solved_date, created_at) VALUES
(@admin_id, @demo_session_id, 'LeetCode', 'Two Sum', 'https://leetcode.com/problems/two-sum/', 'HARD', TRUE, 75, 'DEMO100: solved during the 100-day practice streak.', '2026-06-10', '2026-06-10 11:45:00');
INSERT INTO problems_solved (user_id, session_id, platform, problem_name, problem_url, difficulty, is_solved, time_taken_minutes, notes, solved_date, created_at) VALUES
(@admin_id, @demo_session_id, 'HackerRank', 'Flood Fill', 'https://www.hackerrank.com/challenges/flood-fill/problem', 'MEDIUM', TRUE, 48, 'DEMO100: solved as a stretch problem after the main session.', '2026-06-10', '2026-06-10 12:00:00');

-- Day 62: 2026-06-11
INSERT INTO daily_goals (user_id, goal_date, target_minutes, achieved_minutes, is_completed, created_at) VALUES
(@admin_id, '2026-06-11', 120, 197, TRUE, '2026-06-11 06:15:00')
ON DUPLICATE KEY UPDATE
target_minutes = VALUES(target_minutes),
achieved_minutes = VALUES(achieved_minutes),
is_completed = VALUES(is_completed);
INSERT INTO coding_sessions (user_id, topic_id, language_id, session_date, start_time, end_time, duration_minutes, notes, is_timer_session, created_at, updated_at) VALUES
(@admin_id, (SELECT id FROM topics WHERE name = 'SQL Queries' LIMIT 1), (SELECT id FROM programming_languages WHERE name = 'JavaScript' LIMIT 1), '2026-06-11', '09:19:00', '11:44:00', 145, 'DEMO100: connected UI action to real API data.', FALSE, '2026-06-11 11:44:00', '2026-06-11 11:44:00');
SET @demo_session_id := LAST_INSERT_ID();
INSERT INTO coding_sessions (user_id, topic_id, language_id, session_date, start_time, end_time, duration_minutes, notes, is_timer_session, created_at, updated_at) VALUES
(@admin_id, (SELECT id FROM topics WHERE name = 'Spring Boot' LIMIT 1), (SELECT id FROM programming_languages WHERE name = 'Python' LIMIT 1), '2026-06-11', '19:52:00', '20:44:00', 52, 'DEMO100: evening review and cleanup session.', FALSE, '2026-06-11 20:44:00', '2026-06-11 20:44:00');
SET @demo_session_id := LAST_INSERT_ID();

-- Day 63: 2026-06-12
INSERT INTO daily_goals (user_id, goal_date, target_minutes, achieved_minutes, is_completed, created_at) VALUES
(@admin_id, '2026-06-12', 120, 139, TRUE, '2026-06-12 06:15:00')
ON DUPLICATE KEY UPDATE
target_minutes = VALUES(target_minutes),
achieved_minutes = VALUES(achieved_minutes),
is_completed = VALUES(is_completed);
INSERT INTO coding_sessions (user_id, topic_id, language_id, session_date, start_time, end_time, duration_minutes, notes, is_timer_session, created_at, updated_at) VALUES
(@admin_id, (SELECT id FROM topics WHERE name = 'Git & GitHub' LIMIT 1), (SELECT id FROM programming_languages WHERE name = 'SQL' LIMIT 1), '2026-06-12', '09:38:00', '11:57:00', 139, 'DEMO100: reviewed Git workflow and documented progress.', FALSE, '2026-06-12 11:57:00', '2026-06-12 11:57:00');
SET @demo_session_id := LAST_INSERT_ID();
INSERT INTO problems_solved (user_id, session_id, platform, problem_name, problem_url, difficulty, is_solved, time_taken_minutes, notes, solved_date, created_at) VALUES
(@admin_id, @demo_session_id, 'LeetCode', 'Merge Two Sorted Lists', 'https://leetcode.com/problems/merge-two-sorted-lists/', 'EASY', TRUE, 19, 'DEMO100: solved during the 100-day practice streak.', '2026-06-12', '2026-06-12 12:17:00');

-- Day 64: 2026-06-13
INSERT INTO daily_goals (user_id, goal_date, target_minutes, achieved_minutes, is_completed, created_at) VALUES
(@admin_id, '2026-06-13', 90, 136, TRUE, '2026-06-13 06:15:00')
ON DUPLICATE KEY UPDATE
target_minutes = VALUES(target_minutes),
achieved_minutes = VALUES(achieved_minutes),
is_completed = VALUES(is_completed);
INSERT INTO coding_sessions (user_id, topic_id, language_id, session_date, start_time, end_time, duration_minutes, notes, is_timer_session, created_at, updated_at) VALUES
(@admin_id, (SELECT id FROM topics WHERE name = 'System Design' LIMIT 1), (SELECT id FROM programming_languages WHERE name = 'Python' LIMIT 1), '2026-06-13', '09:57:00', '12:13:00', 136, 'DEMO100: planned architecture decisions from a product perspective.', TRUE, '2026-06-13 12:13:00', '2026-06-13 12:13:00');
SET @demo_session_id := LAST_INSERT_ID();

-- Day 65: 2026-06-14
INSERT INTO daily_goals (user_id, goal_date, target_minutes, achieved_minutes, is_completed, created_at) VALUES
(@admin_id, '2026-06-14', 90, 173, TRUE, '2026-06-14 06:15:00')
ON DUPLICATE KEY UPDATE
target_minutes = VALUES(target_minutes),
achieved_minutes = VALUES(achieved_minutes),
is_completed = VALUES(is_completed);
INSERT INTO coding_sessions (user_id, topic_id, language_id, session_date, start_time, end_time, duration_minutes, notes, is_timer_session, created_at, updated_at) VALUES
(@admin_id, (SELECT id FROM topics WHERE name = 'Spring Boot' LIMIT 1), (SELECT id FROM programming_languages WHERE name = 'HTML/CSS' LIMIT 1), '2026-06-14', '08:16:00', '10:41:00', 145, 'DEMO100: implemented backend endpoint and verified request flow.', FALSE, '2026-06-14 10:41:00', '2026-06-14 10:41:00');
SET @demo_session_id := LAST_INSERT_ID();
INSERT INTO coding_sessions (user_id, topic_id, language_id, session_date, start_time, end_time, duration_minutes, notes, is_timer_session, created_at, updated_at) VALUES
(@admin_id, (SELECT id FROM topics WHERE name = 'Arrays & Strings' LIMIT 1), (SELECT id FROM programming_languages WHERE name = 'Java' LIMIT 1), '2026-06-14', '20:13:00', '20:41:00', 28, 'DEMO100: evening review and cleanup session.', FALSE, '2026-06-14 20:41:00', '2026-06-14 20:41:00');
SET @demo_session_id := LAST_INSERT_ID();
INSERT INTO problems_solved (user_id, session_id, platform, problem_name, problem_url, difficulty, is_solved, time_taken_minutes, notes, solved_date, created_at) VALUES
(@admin_id, @demo_session_id, 'LeetCode', 'Contains Duplicate', 'https://leetcode.com/problems/contains-duplicate/', 'EASY', TRUE, 16, 'DEMO100: solved during the 100-day practice streak.', '2026-06-14', '2026-06-14 11:01:00');

-- Day 66: 2026-06-15
INSERT INTO daily_goals (user_id, goal_date, target_minutes, achieved_minutes, is_completed, created_at) VALUES
(@admin_id, '2026-06-15', 120, 155, TRUE, '2026-06-15 06:15:00')
ON DUPLICATE KEY UPDATE
target_minutes = VALUES(target_minutes),
achieved_minutes = VALUES(achieved_minutes),
is_completed = VALUES(is_completed);
INSERT INTO coding_sessions (user_id, topic_id, language_id, session_date, start_time, end_time, duration_minutes, notes, is_timer_session, created_at, updated_at) VALUES
(@admin_id, (SELECT id FROM topics WHERE name = 'React.js' LIMIT 1), (SELECT id FROM programming_languages WHERE name = 'TypeScript' LIMIT 1), '2026-06-15', '08:35:00', '11:00:00', 145, 'DEMO100: refactored frontend state handling and tested the page.', FALSE, '2026-06-15 11:00:00', '2026-06-15 11:00:00');
SET @demo_session_id := LAST_INSERT_ID();
INSERT INTO coding_sessions (user_id, topic_id, language_id, session_date, start_time, end_time, duration_minutes, notes, is_timer_session, created_at, updated_at) VALUES
(@admin_id, (SELECT id FROM topics WHERE name = 'Spring Security' LIMIT 1), (SELECT id FROM programming_languages WHERE name = 'JavaScript' LIMIT 1), '2026-06-15', '19:05:00', '19:15:00', 10, 'DEMO100: evening review and cleanup session.', FALSE, '2026-06-15 19:15:00', '2026-06-15 19:15:00');
SET @demo_session_id := LAST_INSERT_ID();

-- Day 67: 2026-06-16
INSERT INTO daily_goals (user_id, goal_date, target_minutes, achieved_minutes, is_completed, created_at) VALUES
(@admin_id, '2026-06-16', 120, 192, TRUE, '2026-06-16 06:15:00')
ON DUPLICATE KEY UPDATE
target_minutes = VALUES(target_minutes),
achieved_minutes = VALUES(achieved_minutes),
is_completed = VALUES(is_completed);
INSERT INTO coding_sessions (user_id, topic_id, language_id, session_date, start_time, end_time, duration_minutes, notes, is_timer_session, created_at, updated_at) VALUES
(@admin_id, (SELECT id FROM topics WHERE name = 'MySQL' LIMIT 1), (SELECT id FROM programming_languages WHERE name = 'Java' LIMIT 1), '2026-06-16', '08:54:00', '11:19:00', 145, 'DEMO100: wrote SQL query practice and checked report numbers.', TRUE, '2026-06-16 11:19:00', '2026-06-16 11:19:00');
SET @demo_session_id := LAST_INSERT_ID();
INSERT INTO coding_sessions (user_id, topic_id, language_id, session_date, start_time, end_time, duration_minutes, notes, is_timer_session, created_at, updated_at) VALUES
(@admin_id, (SELECT id FROM topics WHERE name = 'SQL Queries' LIMIT 1), (SELECT id FROM programming_languages WHERE name = 'SQL' LIMIT 1), '2026-06-16', '19:12:00', '19:59:00', 47, 'DEMO100: evening review and cleanup session.', FALSE, '2026-06-16 19:59:00', '2026-06-16 19:59:00');
SET @demo_session_id := LAST_INSERT_ID();
INSERT INTO problems_solved (user_id, session_id, platform, problem_name, problem_url, difficulty, is_solved, time_taken_minutes, notes, solved_date, created_at) VALUES
(@admin_id, @demo_session_id, 'LeetCode', 'Product of Array Except Self', 'https://leetcode.com/problems/product-of-array-except-self/', 'MEDIUM', TRUE, 42, 'DEMO100: solved during the 100-day practice streak.', '2026-06-16', '2026-06-16 11:39:00');

-- Day 68: 2026-06-17
INSERT INTO daily_goals (user_id, goal_date, target_minutes, achieved_minutes, is_completed, created_at) VALUES
(@admin_id, '2026-06-17', 120, 134, TRUE, '2026-06-17 06:15:00')
ON DUPLICATE KEY UPDATE
target_minutes = VALUES(target_minutes),
achieved_minutes = VALUES(achieved_minutes),
is_completed = VALUES(is_completed);
INSERT INTO coding_sessions (user_id, topic_id, language_id, session_date, start_time, end_time, duration_minutes, notes, is_timer_session, created_at, updated_at) VALUES
(@admin_id, (SELECT id FROM topics WHERE name = 'Arrays & Strings' LIMIT 1), (SELECT id FROM programming_languages WHERE name = 'JavaScript' LIMIT 1), '2026-06-17', '09:13:00', '11:27:00', 134, 'DEMO100: studied algorithm pattern and solved a related problem.', FALSE, '2026-06-17 11:27:00', '2026-06-17 11:27:00');
SET @demo_session_id := LAST_INSERT_ID();

-- Day 69: 2026-06-18
INSERT INTO daily_goals (user_id, goal_date, target_minutes, achieved_minutes, is_completed, created_at) VALUES
(@admin_id, '2026-06-18', 120, 136, TRUE, '2026-06-18 06:15:00')
ON DUPLICATE KEY UPDATE
target_minutes = VALUES(target_minutes),
achieved_minutes = VALUES(achieved_minutes),
is_completed = VALUES(is_completed);
INSERT INTO coding_sessions (user_id, topic_id, language_id, session_date, start_time, end_time, duration_minutes, notes, is_timer_session, created_at, updated_at) VALUES
(@admin_id, (SELECT id FROM topics WHERE name = 'Spring Security' LIMIT 1), (SELECT id FROM programming_languages WHERE name = 'SQL' LIMIT 1), '2026-06-18', '09:32:00', '11:48:00', 136, 'DEMO100: reviewed JWT/auth flow and cleaned edge cases.', FALSE, '2026-06-18 11:48:00', '2026-06-18 11:48:00');
SET @demo_session_id := LAST_INSERT_ID();
INSERT INTO problems_solved (user_id, session_id, platform, problem_name, problem_url, difficulty, is_solved, time_taken_minutes, notes, solved_date, created_at) VALUES
(@admin_id, @demo_session_id, 'LeetCode', 'Climbing Stairs', 'https://leetcode.com/problems/climbing-stairs/', 'EASY', TRUE, 35, 'DEMO100: solved during the 100-day practice streak.', '2026-06-18', '2026-06-18 12:08:00');

-- Day 70: 2026-06-19
INSERT INTO daily_goals (user_id, goal_date, target_minutes, achieved_minutes, is_completed, created_at) VALUES
(@admin_id, '2026-06-19', 120, 268, TRUE, '2026-06-19 06:15:00')
ON DUPLICATE KEY UPDATE
target_minutes = VALUES(target_minutes),
achieved_minutes = VALUES(achieved_minutes),
is_completed = VALUES(is_completed);
INSERT INTO coding_sessions (user_id, topic_id, language_id, session_date, start_time, end_time, duration_minutes, notes, is_timer_session, created_at, updated_at) VALUES
(@admin_id, (SELECT id FROM topics WHERE name = 'SQL Queries' LIMIT 1), (SELECT id FROM programming_languages WHERE name = 'Python' LIMIT 1), '2026-06-19', '09:51:00', '12:16:00', 145, 'DEMO100: connected UI action to real API data.', TRUE, '2026-06-19 12:16:00', '2026-06-19 12:16:00');
SET @demo_session_id := LAST_INSERT_ID();
INSERT INTO coding_sessions (user_id, topic_id, language_id, session_date, start_time, end_time, duration_minutes, notes, is_timer_session, created_at, updated_at) VALUES
(@admin_id, (SELECT id FROM topics WHERE name = 'Spring Boot' LIMIT 1), (SELECT id FROM programming_languages WHERE name = 'TypeScript' LIMIT 1), '2026-06-19', '19:33:00', '21:36:00', 123, 'DEMO100: evening review and cleanup session.', FALSE, '2026-06-19 21:36:00', '2026-06-19 21:36:00');
SET @demo_session_id := LAST_INSERT_ID();

-- Day 71: 2026-06-20
INSERT INTO daily_goals (user_id, goal_date, target_minutes, achieved_minutes, is_completed, created_at) VALUES
(@admin_id, '2026-06-20', 90, 110, TRUE, '2026-06-20 06:15:00')
ON DUPLICATE KEY UPDATE
target_minutes = VALUES(target_minutes),
achieved_minutes = VALUES(achieved_minutes),
is_completed = VALUES(is_completed);
INSERT INTO coding_sessions (user_id, topic_id, language_id, session_date, start_time, end_time, duration_minutes, notes, is_timer_session, created_at, updated_at) VALUES
(@admin_id, (SELECT id FROM topics WHERE name = 'Git & GitHub' LIMIT 1), (SELECT id FROM programming_languages WHERE name = 'HTML/CSS' LIMIT 1), '2026-06-20', '08:10:00', '10:00:00', 110, 'DEMO100: reviewed Git workflow and documented progress.', FALSE, '2026-06-20 10:00:00', '2026-06-20 10:00:00');
SET @demo_session_id := LAST_INSERT_ID();
INSERT INTO problems_solved (user_id, session_id, platform, problem_name, problem_url, difficulty, is_solved, time_taken_minutes, notes, solved_date, created_at) VALUES
(@admin_id, @demo_session_id, 'LeetCode', 'Invert Binary Tree', 'https://leetcode.com/problems/invert-binary-tree/', 'HARD', TRUE, 75, 'DEMO100: solved during the 100-day practice streak.', '2026-06-20', '2026-06-20 10:20:00');
INSERT INTO problems_solved (user_id, session_id, platform, problem_name, problem_url, difficulty, is_solved, time_taken_minutes, notes, solved_date, created_at) VALUES
(@admin_id, @demo_session_id, 'HackerRank', 'Subsets', 'https://www.hackerrank.com/challenges/subsets/problem', 'MEDIUM', TRUE, 58, 'DEMO100: solved as a stretch problem after the main session.', '2026-06-20', '2026-06-20 10:35:00');

-- Day 72: 2026-06-21
INSERT INTO daily_goals (user_id, goal_date, target_minutes, achieved_minutes, is_completed, created_at) VALUES
(@admin_id, '2026-06-21', 90, 147, TRUE, '2026-06-21 06:15:00')
ON DUPLICATE KEY UPDATE
target_minutes = VALUES(target_minutes),
achieved_minutes = VALUES(achieved_minutes),
is_completed = VALUES(is_completed);
INSERT INTO coding_sessions (user_id, topic_id, language_id, session_date, start_time, end_time, duration_minutes, notes, is_timer_session, created_at, updated_at) VALUES
(@admin_id, (SELECT id FROM topics WHERE name = 'System Design' LIMIT 1), (SELECT id FROM programming_languages WHERE name = 'TypeScript' LIMIT 1), '2026-06-21', '08:29:00', '10:54:00', 145, 'DEMO100: planned architecture decisions from a product perspective.', FALSE, '2026-06-21 10:54:00', '2026-06-21 10:54:00');
SET @demo_session_id := LAST_INSERT_ID();
INSERT INTO coding_sessions (user_id, topic_id, language_id, session_date, start_time, end_time, duration_minutes, notes, is_timer_session, created_at, updated_at) VALUES
(@admin_id, (SELECT id FROM topics WHERE name = 'MySQL' LIMIT 1), (SELECT id FROM programming_languages WHERE name = 'JavaScript' LIMIT 1), '2026-06-21', '19:47:00', '19:49:00', 2, 'DEMO100: evening review and cleanup session.', FALSE, '2026-06-21 19:49:00', '2026-06-21 19:49:00');
SET @demo_session_id := LAST_INSERT_ID();

-- Day 73: 2026-06-22
INSERT INTO daily_goals (user_id, goal_date, target_minutes, achieved_minutes, is_completed, created_at) VALUES
(@admin_id, '2026-06-22', 120, 129, TRUE, '2026-06-22 06:15:00')
ON DUPLICATE KEY UPDATE
target_minutes = VALUES(target_minutes),
achieved_minutes = VALUES(achieved_minutes),
is_completed = VALUES(is_completed);
INSERT INTO coding_sessions (user_id, topic_id, language_id, session_date, start_time, end_time, duration_minutes, notes, is_timer_session, created_at, updated_at) VALUES
(@admin_id, (SELECT id FROM topics WHERE name = 'Spring Boot' LIMIT 1), (SELECT id FROM programming_languages WHERE name = 'Java' LIMIT 1), '2026-06-22', '08:48:00', '10:57:00', 129, 'DEMO100: implemented backend endpoint and verified request flow.', TRUE, '2026-06-22 10:57:00', '2026-06-22 10:57:00');
SET @demo_session_id := LAST_INSERT_ID();
INSERT INTO problems_solved (user_id, session_id, platform, problem_name, problem_url, difficulty, is_solved, time_taken_minutes, notes, solved_date, created_at) VALUES
(@admin_id, @demo_session_id, 'LeetCode', 'Number of Islands', 'https://leetcode.com/problems/number-of-islands/', 'MEDIUM', FALSE, 49, 'DEMO100: attempted during the 100-day practice streak.', '2026-06-22', '2026-06-22 11:17:00');

-- Day 74: 2026-06-23
INSERT INTO daily_goals (user_id, goal_date, target_minutes, achieved_minutes, is_completed, created_at) VALUES
(@admin_id, '2026-06-23', 120, 166, TRUE, '2026-06-23 06:15:00')
ON DUPLICATE KEY UPDATE
target_minutes = VALUES(target_minutes),
achieved_minutes = VALUES(achieved_minutes),
is_completed = VALUES(is_completed);
INSERT INTO coding_sessions (user_id, topic_id, language_id, session_date, start_time, end_time, duration_minutes, notes, is_timer_session, created_at, updated_at) VALUES
(@admin_id, (SELECT id FROM topics WHERE name = 'React.js' LIMIT 1), (SELECT id FROM programming_languages WHERE name = 'JavaScript' LIMIT 1), '2026-06-23', '09:07:00', '11:32:00', 145, 'DEMO100: refactored frontend state handling and tested the page.', FALSE, '2026-06-23 11:32:00', '2026-06-23 11:32:00');
SET @demo_session_id := LAST_INSERT_ID();
INSERT INTO coding_sessions (user_id, topic_id, language_id, session_date, start_time, end_time, duration_minutes, notes, is_timer_session, created_at, updated_at) VALUES
(@admin_id, (SELECT id FROM topics WHERE name = 'Spring Security' LIMIT 1), (SELECT id FROM programming_languages WHERE name = 'Python' LIMIT 1), '2026-06-23', '20:01:00', '20:22:00', 21, 'DEMO100: evening review and cleanup session.', FALSE, '2026-06-23 20:22:00', '2026-06-23 20:22:00');
SET @demo_session_id := LAST_INSERT_ID();

-- Day 75: 2026-06-24
INSERT INTO daily_goals (user_id, goal_date, target_minutes, achieved_minutes, is_completed, created_at) VALUES
(@admin_id, '2026-06-24', 120, 203, TRUE, '2026-06-24 06:15:00')
ON DUPLICATE KEY UPDATE
target_minutes = VALUES(target_minutes),
achieved_minutes = VALUES(achieved_minutes),
is_completed = VALUES(is_completed);
INSERT INTO coding_sessions (user_id, topic_id, language_id, session_date, start_time, end_time, duration_minutes, notes, is_timer_session, created_at, updated_at) VALUES
(@admin_id, (SELECT id FROM topics WHERE name = 'MySQL' LIMIT 1), (SELECT id FROM programming_languages WHERE name = 'SQL' LIMIT 1), '2026-06-24', '09:26:00', '11:51:00', 145, 'DEMO100: wrote SQL query practice and checked report numbers.', FALSE, '2026-06-24 11:51:00', '2026-06-24 11:51:00');
SET @demo_session_id := LAST_INSERT_ID();
INSERT INTO coding_sessions (user_id, topic_id, language_id, session_date, start_time, end_time, duration_minutes, notes, is_timer_session, created_at, updated_at) VALUES
(@admin_id, (SELECT id FROM topics WHERE name = 'SQL Queries' LIMIT 1), (SELECT id FROM programming_languages WHERE name = 'HTML/CSS' LIMIT 1), '2026-06-24', '20:08:00', '21:06:00', 58, 'DEMO100: evening review and cleanup session.', FALSE, '2026-06-24 21:06:00', '2026-06-24 21:06:00');
SET @demo_session_id := LAST_INSERT_ID();
INSERT INTO problems_solved (user_id, session_id, platform, problem_name, problem_url, difficulty, is_solved, time_taken_minutes, notes, solved_date, created_at) VALUES
(@admin_id, @demo_session_id, 'LeetCode', 'Group Anagrams', 'https://leetcode.com/problems/group-anagrams/', 'EASY', TRUE, 26, 'DEMO100: solved during the 100-day practice streak.', '2026-06-24', '2026-06-24 12:11:00');

-- Day 76: 2026-06-25
INSERT INTO daily_goals (user_id, goal_date, target_minutes, achieved_minutes, is_completed, created_at) VALUES
(@admin_id, '2026-06-25', 120, 145, TRUE, '2026-06-25 06:15:00')
ON DUPLICATE KEY UPDATE
target_minutes = VALUES(target_minutes),
achieved_minutes = VALUES(achieved_minutes),
is_completed = VALUES(is_completed);
INSERT INTO coding_sessions (user_id, topic_id, language_id, session_date, start_time, end_time, duration_minutes, notes, is_timer_session, created_at, updated_at) VALUES
(@admin_id, (SELECT id FROM topics WHERE name = 'Arrays & Strings' LIMIT 1), (SELECT id FROM programming_languages WHERE name = 'Python' LIMIT 1), '2026-06-25', '09:45:00', '12:10:00', 145, 'DEMO100: studied algorithm pattern and solved a related problem.', TRUE, '2026-06-25 12:10:00', '2026-06-25 12:10:00');
SET @demo_session_id := LAST_INSERT_ID();

-- Day 77: 2026-06-26
INSERT INTO daily_goals (user_id, goal_date, target_minutes, achieved_minutes, is_completed, created_at) VALUES
(@admin_id, '2026-06-26', 120, 182, TRUE, '2026-06-26 06:15:00')
ON DUPLICATE KEY UPDATE
target_minutes = VALUES(target_minutes),
achieved_minutes = VALUES(achieved_minutes),
is_completed = VALUES(is_completed);
INSERT INTO coding_sessions (user_id, topic_id, language_id, session_date, start_time, end_time, duration_minutes, notes, is_timer_session, created_at, updated_at) VALUES
(@admin_id, (SELECT id FROM topics WHERE name = 'Spring Security' LIMIT 1), (SELECT id FROM programming_languages WHERE name = 'HTML/CSS' LIMIT 1), '2026-06-26', '08:04:00', '10:29:00', 145, 'DEMO100: reviewed JWT/auth flow and cleaned edge cases.', FALSE, '2026-06-26 10:29:00', '2026-06-26 10:29:00');
SET @demo_session_id := LAST_INSERT_ID();
INSERT INTO coding_sessions (user_id, topic_id, language_id, session_date, start_time, end_time, duration_minutes, notes, is_timer_session, created_at, updated_at) VALUES
(@admin_id, (SELECT id FROM topics WHERE name = 'System Design' LIMIT 1), (SELECT id FROM programming_languages WHERE name = 'Java' LIMIT 1), '2026-06-26', '19:07:00', '19:44:00', 37, 'DEMO100: evening review and cleanup session.', FALSE, '2026-06-26 19:44:00', '2026-06-26 19:44:00');
SET @demo_session_id := LAST_INSERT_ID();
INSERT INTO problems_solved (user_id, session_id, platform, problem_name, problem_url, difficulty, is_solved, time_taken_minutes, notes, solved_date, created_at) VALUES
(@admin_id, @demo_session_id, 'LeetCode', 'Course Schedule', 'https://leetcode.com/problems/course-schedule/', 'EASY', TRUE, 23, 'DEMO100: solved during the 100-day practice streak.', '2026-06-26', '2026-06-26 10:49:00');

-- Day 78: 2026-06-27
INSERT INTO daily_goals (user_id, goal_date, target_minutes, achieved_minutes, is_completed, created_at) VALUES
(@admin_id, '2026-06-27', 90, 179, TRUE, '2026-06-27 06:15:00')
ON DUPLICATE KEY UPDATE
target_minutes = VALUES(target_minutes),
achieved_minutes = VALUES(achieved_minutes),
is_completed = VALUES(is_completed);
INSERT INTO coding_sessions (user_id, topic_id, language_id, session_date, start_time, end_time, duration_minutes, notes, is_timer_session, created_at, updated_at) VALUES
(@admin_id, (SELECT id FROM topics WHERE name = 'SQL Queries' LIMIT 1), (SELECT id FROM programming_languages WHERE name = 'TypeScript' LIMIT 1), '2026-06-27', '08:23:00', '10:48:00', 145, 'DEMO100: connected UI action to real API data.', FALSE, '2026-06-27 10:48:00', '2026-06-27 10:48:00');
SET @demo_session_id := LAST_INSERT_ID();
INSERT INTO coding_sessions (user_id, topic_id, language_id, session_date, start_time, end_time, duration_minutes, notes, is_timer_session, created_at, updated_at) VALUES
(@admin_id, (SELECT id FROM topics WHERE name = 'Spring Boot' LIMIT 1), (SELECT id FROM programming_languages WHERE name = 'JavaScript' LIMIT 1), '2026-06-27', '19:14:00', '19:48:00', 34, 'DEMO100: evening review and cleanup session.', FALSE, '2026-06-27 19:48:00', '2026-06-27 19:48:00');
SET @demo_session_id := LAST_INSERT_ID();

-- Day 79: 2026-06-28
INSERT INTO daily_goals (user_id, goal_date, target_minutes, achieved_minutes, is_completed, created_at) VALUES
(@admin_id, '2026-06-28', 90, 121, TRUE, '2026-06-28 06:15:00')
ON DUPLICATE KEY UPDATE
target_minutes = VALUES(target_minutes),
achieved_minutes = VALUES(achieved_minutes),
is_completed = VALUES(is_completed);
INSERT INTO coding_sessions (user_id, topic_id, language_id, session_date, start_time, end_time, duration_minutes, notes, is_timer_session, created_at, updated_at) VALUES
(@admin_id, (SELECT id FROM topics WHERE name = 'Git & GitHub' LIMIT 1), (SELECT id FROM programming_languages WHERE name = 'Java' LIMIT 1), '2026-06-28', '08:42:00', '10:43:00', 121, 'DEMO100: reviewed Git workflow and documented progress.', TRUE, '2026-06-28 10:43:00', '2026-06-28 10:43:00');
SET @demo_session_id := LAST_INSERT_ID();
INSERT INTO problems_solved (user_id, session_id, platform, problem_name, problem_url, difficulty, is_solved, time_taken_minutes, notes, solved_date, created_at) VALUES
(@admin_id, @demo_session_id, 'LeetCode', 'House Robber', 'https://leetcode.com/problems/house-robber/', 'MEDIUM', TRUE, 56, 'DEMO100: solved during the 100-day practice streak.', '2026-06-28', '2026-06-28 11:03:00');

-- Day 80: 2026-06-29
INSERT INTO daily_goals (user_id, goal_date, target_minutes, achieved_minutes, is_completed, created_at) VALUES
(@admin_id, '2026-06-29', 120, 198, TRUE, '2026-06-29 06:15:00')
ON DUPLICATE KEY UPDATE
target_minutes = VALUES(target_minutes),
achieved_minutes = VALUES(achieved_minutes),
is_completed = VALUES(is_completed);
INSERT INTO coding_sessions (user_id, topic_id, language_id, session_date, start_time, end_time, duration_minutes, notes, is_timer_session, created_at, updated_at) VALUES
(@admin_id, (SELECT id FROM topics WHERE name = 'System Design' LIMIT 1), (SELECT id FROM programming_languages WHERE name = 'JavaScript' LIMIT 1), '2026-06-29', '09:01:00', '11:26:00', 145, 'DEMO100: planned architecture decisions from a product perspective.', FALSE, '2026-06-29 11:26:00', '2026-06-29 11:26:00');
SET @demo_session_id := LAST_INSERT_ID();
INSERT INTO coding_sessions (user_id, topic_id, language_id, session_date, start_time, end_time, duration_minutes, notes, is_timer_session, created_at, updated_at) VALUES
(@admin_id, (SELECT id FROM topics WHERE name = 'MySQL' LIMIT 1), (SELECT id FROM programming_languages WHERE name = 'Python' LIMIT 1), '2026-06-29', '19:28:00', '20:21:00', 53, 'DEMO100: evening review and cleanup session.', FALSE, '2026-06-29 20:21:00', '2026-06-29 20:21:00');
SET @demo_session_id := LAST_INSERT_ID();

-- Day 81: 2026-06-30
INSERT INTO daily_goals (user_id, goal_date, target_minutes, achieved_minutes, is_completed, created_at) VALUES
(@admin_id, '2026-06-30', 120, 140, TRUE, '2026-06-30 06:15:00')
ON DUPLICATE KEY UPDATE
target_minutes = VALUES(target_minutes),
achieved_minutes = VALUES(achieved_minutes),
is_completed = VALUES(is_completed);
INSERT INTO coding_sessions (user_id, topic_id, language_id, session_date, start_time, end_time, duration_minutes, notes, is_timer_session, created_at, updated_at) VALUES
(@admin_id, (SELECT id FROM topics WHERE name = 'Spring Boot' LIMIT 1), (SELECT id FROM programming_languages WHERE name = 'SQL' LIMIT 1), '2026-06-30', '09:20:00', '11:40:00', 140, 'DEMO100: implemented backend endpoint and verified request flow.', FALSE, '2026-06-30 11:40:00', '2026-06-30 11:40:00');
SET @demo_session_id := LAST_INSERT_ID();
INSERT INTO problems_solved (user_id, session_id, platform, problem_name, problem_url, difficulty, is_solved, time_taken_minutes, notes, solved_date, created_at) VALUES
(@admin_id, @demo_session_id, 'LeetCode', 'Kth Largest Element in an Array', 'https://leetcode.com/problems/kth-largest-element-in-an-array/', 'HARD', TRUE, 75, 'DEMO100: solved during the 100-day practice streak.', '2026-06-30', '2026-06-30 12:00:00');
INSERT INTO problems_solved (user_id, session_id, platform, problem_name, problem_url, difficulty, is_solved, time_taken_minutes, notes, solved_date, created_at) VALUES
(@admin_id, @demo_session_id, 'HackerRank', 'Valid Parentheses', 'https://www.hackerrank.com/challenges/valid-parentheses/problem', 'MEDIUM', TRUE, 28, 'DEMO100: solved as a stretch problem after the main session.', '2026-06-30', '2026-06-30 12:15:00');

-- Day 82: 2026-07-01
INSERT INTO daily_goals (user_id, goal_date, target_minutes, achieved_minutes, is_completed, created_at) VALUES
(@admin_id, '2026-07-01', 120, 177, TRUE, '2026-07-01 06:15:00')
ON DUPLICATE KEY UPDATE
target_minutes = VALUES(target_minutes),
achieved_minutes = VALUES(achieved_minutes),
is_completed = VALUES(is_completed);
INSERT INTO coding_sessions (user_id, topic_id, language_id, session_date, start_time, end_time, duration_minutes, notes, is_timer_session, created_at, updated_at) VALUES
(@admin_id, (SELECT id FROM topics WHERE name = 'React.js' LIMIT 1), (SELECT id FROM programming_languages WHERE name = 'Python' LIMIT 1), '2026-07-01', '09:39:00', '12:04:00', 145, 'DEMO100: refactored frontend state handling and tested the page.', TRUE, '2026-07-01 12:04:00', '2026-07-01 12:04:00');
SET @demo_session_id := LAST_INSERT_ID();
INSERT INTO coding_sessions (user_id, topic_id, language_id, session_date, start_time, end_time, duration_minutes, notes, is_timer_session, created_at, updated_at) VALUES
(@admin_id, (SELECT id FROM topics WHERE name = 'Spring Security' LIMIT 1), (SELECT id FROM programming_languages WHERE name = 'TypeScript' LIMIT 1), '2026-07-01', '19:42:00', '20:14:00', 32, 'DEMO100: evening review and cleanup session.', FALSE, '2026-07-01 20:14:00', '2026-07-01 20:14:00');
SET @demo_session_id := LAST_INSERT_ID();

-- Day 83: 2026-07-02
INSERT INTO daily_goals (user_id, goal_date, target_minutes, achieved_minutes, is_completed, created_at) VALUES
(@admin_id, '2026-07-02', 120, 214, TRUE, '2026-07-02 06:15:00')
ON DUPLICATE KEY UPDATE
target_minutes = VALUES(target_minutes),
achieved_minutes = VALUES(achieved_minutes),
is_completed = VALUES(is_completed);
INSERT INTO coding_sessions (user_id, topic_id, language_id, session_date, start_time, end_time, duration_minutes, notes, is_timer_session, created_at, updated_at) VALUES
(@admin_id, (SELECT id FROM topics WHERE name = 'MySQL' LIMIT 1), (SELECT id FROM programming_languages WHERE name = 'HTML/CSS' LIMIT 1), '2026-07-02', '09:58:00', '12:23:00', 145, 'DEMO100: wrote SQL query practice and checked report numbers.', FALSE, '2026-07-02 12:23:00', '2026-07-02 12:23:00');
SET @demo_session_id := LAST_INSERT_ID();
INSERT INTO coding_sessions (user_id, topic_id, language_id, session_date, start_time, end_time, duration_minutes, notes, is_timer_session, created_at, updated_at) VALUES
(@admin_id, (SELECT id FROM topics WHERE name = 'SQL Queries' LIMIT 1), (SELECT id FROM programming_languages WHERE name = 'Java' LIMIT 1), '2026-07-02', '19:49:00', '20:58:00', 69, 'DEMO100: evening review and cleanup session.', FALSE, '2026-07-02 20:58:00', '2026-07-02 20:58:00');
SET @demo_session_id := LAST_INSERT_ID();
INSERT INTO problems_solved (user_id, session_id, platform, problem_name, problem_url, difficulty, is_solved, time_taken_minutes, notes, solved_date, created_at) VALUES
(@admin_id, @demo_session_id, 'LeetCode', 'Combination Sum', 'https://leetcode.com/problems/combination-sum/', 'EASY', TRUE, 14, 'DEMO100: solved during the 100-day practice streak.', '2026-07-02', '2026-07-02 12:43:00');

-- Day 84: 2026-07-03
INSERT INTO daily_goals (user_id, goal_date, target_minutes, achieved_minutes, is_completed, created_at) VALUES
(@admin_id, '2026-07-03', 120, 156, TRUE, '2026-07-03 06:15:00')
ON DUPLICATE KEY UPDATE
target_minutes = VALUES(target_minutes),
achieved_minutes = VALUES(achieved_minutes),
is_completed = VALUES(is_completed);
INSERT INTO coding_sessions (user_id, topic_id, language_id, session_date, start_time, end_time, duration_minutes, notes, is_timer_session, created_at, updated_at) VALUES
(@admin_id, (SELECT id FROM topics WHERE name = 'Arrays & Strings' LIMIT 1), (SELECT id FROM programming_languages WHERE name = 'TypeScript' LIMIT 1), '2026-07-03', '08:17:00', '10:42:00', 145, 'DEMO100: studied algorithm pattern and solved a related problem.', FALSE, '2026-07-03 10:42:00', '2026-07-03 10:42:00');
SET @demo_session_id := LAST_INSERT_ID();
INSERT INTO coding_sessions (user_id, topic_id, language_id, session_date, start_time, end_time, duration_minutes, notes, is_timer_session, created_at, updated_at) VALUES
(@admin_id, (SELECT id FROM topics WHERE name = 'Git & GitHub' LIMIT 1), (SELECT id FROM programming_languages WHERE name = 'JavaScript' LIMIT 1), '2026-07-03', '19:56:00', '20:07:00', 11, 'DEMO100: evening review and cleanup session.', FALSE, '2026-07-03 20:07:00', '2026-07-03 20:07:00');
SET @demo_session_id := LAST_INSERT_ID();

-- Day 85: 2026-07-04
INSERT INTO daily_goals (user_id, goal_date, target_minutes, achieved_minutes, is_completed, created_at) VALUES
(@admin_id, '2026-07-04', 90, 153, TRUE, '2026-07-04 06:15:00')
ON DUPLICATE KEY UPDATE
target_minutes = VALUES(target_minutes),
achieved_minutes = VALUES(achieved_minutes),
is_completed = VALUES(is_completed);
INSERT INTO coding_sessions (user_id, topic_id, language_id, session_date, start_time, end_time, duration_minutes, notes, is_timer_session, created_at, updated_at) VALUES
(@admin_id, (SELECT id FROM topics WHERE name = 'Spring Security' LIMIT 1), (SELECT id FROM programming_languages WHERE name = 'Java' LIMIT 1), '2026-07-04', '08:36:00', '11:01:00', 145, 'DEMO100: reviewed JWT/auth flow and cleaned edge cases.', TRUE, '2026-07-04 11:01:00', '2026-07-04 11:01:00');
SET @demo_session_id := LAST_INSERT_ID();
INSERT INTO coding_sessions (user_id, topic_id, language_id, session_date, start_time, end_time, duration_minutes, notes, is_timer_session, created_at, updated_at) VALUES
(@admin_id, (SELECT id FROM topics WHERE name = 'System Design' LIMIT 1), (SELECT id FROM programming_languages WHERE name = 'SQL' LIMIT 1), '2026-07-04', '20:03:00', '20:11:00', 8, 'DEMO100: evening review and cleanup session.', FALSE, '2026-07-04 20:11:00', '2026-07-04 20:11:00');
SET @demo_session_id := LAST_INSERT_ID();
INSERT INTO problems_solved (user_id, session_id, platform, problem_name, problem_url, difficulty, is_solved, time_taken_minutes, notes, solved_date, created_at) VALUES
(@admin_id, @demo_session_id, 'LeetCode', 'Validate Binary Search Tree', 'https://leetcode.com/problems/validate-binary-search-tree/', 'MEDIUM', TRUE, 63, 'DEMO100: solved during the 100-day practice streak.', '2026-07-04', '2026-07-04 11:21:00');

-- Day 86: 2026-07-05
INSERT INTO daily_goals (user_id, goal_date, target_minutes, achieved_minutes, is_completed, created_at) VALUES
(@admin_id, '2026-07-05', 90, 60, FALSE, '2026-07-05 06:15:00')
ON DUPLICATE KEY UPDATE
target_minutes = VALUES(target_minutes),
achieved_minutes = VALUES(achieved_minutes),
is_completed = VALUES(is_completed);
INSERT INTO coding_sessions (user_id, topic_id, language_id, session_date, start_time, end_time, duration_minutes, notes, is_timer_session, created_at, updated_at) VALUES
(@admin_id, (SELECT id FROM topics WHERE name = 'SQL Queries' LIMIT 1), (SELECT id FROM programming_languages WHERE name = 'JavaScript' LIMIT 1), '2026-07-05', '08:55:00', '09:55:00', 60, 'DEMO100: connected UI action to real API data.', FALSE, '2026-07-05 09:55:00', '2026-07-05 09:55:00');
SET @demo_session_id := LAST_INSERT_ID();

-- Day 87: 2026-07-06
INSERT INTO daily_goals (user_id, goal_date, target_minutes, achieved_minutes, is_completed, created_at) VALUES
(@admin_id, '2026-07-06', 120, 172, TRUE, '2026-07-06 06:15:00')
ON DUPLICATE KEY UPDATE
target_minutes = VALUES(target_minutes),
achieved_minutes = VALUES(achieved_minutes),
is_completed = VALUES(is_completed);
INSERT INTO coding_sessions (user_id, topic_id, language_id, session_date, start_time, end_time, duration_minutes, notes, is_timer_session, created_at, updated_at) VALUES
(@admin_id, (SELECT id FROM topics WHERE name = 'Git & GitHub' LIMIT 1), (SELECT id FROM programming_languages WHERE name = 'SQL' LIMIT 1), '2026-07-06', '09:14:00', '11:39:00', 145, 'DEMO100: reviewed Git workflow and documented progress.', FALSE, '2026-07-06 11:39:00', '2026-07-06 11:39:00');
SET @demo_session_id := LAST_INSERT_ID();
INSERT INTO coding_sessions (user_id, topic_id, language_id, session_date, start_time, end_time, duration_minutes, notes, is_timer_session, created_at, updated_at) VALUES
(@admin_id, (SELECT id FROM topics WHERE name = 'React.js' LIMIT 1), (SELECT id FROM programming_languages WHERE name = 'HTML/CSS' LIMIT 1), '2026-07-06', '19:02:00', '19:29:00', 27, 'DEMO100: evening review and cleanup session.', FALSE, '2026-07-06 19:29:00', '2026-07-06 19:29:00');
SET @demo_session_id := LAST_INSERT_ID();
INSERT INTO problems_solved (user_id, session_id, platform, problem_name, problem_url, difficulty, is_solved, time_taken_minutes, notes, solved_date, created_at) VALUES
(@admin_id, @demo_session_id, 'LeetCode', 'Rotting Oranges', 'https://leetcode.com/problems/rotting-oranges/', 'EASY', TRUE, 33, 'DEMO100: solved during the 100-day practice streak.', '2026-07-06', '2026-07-06 11:59:00');

-- Day 88: 2026-07-07
INSERT INTO daily_goals (user_id, goal_date, target_minutes, achieved_minutes, is_completed, created_at) VALUES
(@admin_id, '2026-07-07', 120, 209, TRUE, '2026-07-07 06:15:00')
ON DUPLICATE KEY UPDATE
target_minutes = VALUES(target_minutes),
achieved_minutes = VALUES(achieved_minutes),
is_completed = VALUES(is_completed);
INSERT INTO coding_sessions (user_id, topic_id, language_id, session_date, start_time, end_time, duration_minutes, notes, is_timer_session, created_at, updated_at) VALUES
(@admin_id, (SELECT id FROM topics WHERE name = 'System Design' LIMIT 1), (SELECT id FROM programming_languages WHERE name = 'Python' LIMIT 1), '2026-07-07', '09:33:00', '11:58:00', 145, 'DEMO100: planned architecture decisions from a product perspective.', TRUE, '2026-07-07 11:58:00', '2026-07-07 11:58:00');
SET @demo_session_id := LAST_INSERT_ID();
INSERT INTO coding_sessions (user_id, topic_id, language_id, session_date, start_time, end_time, duration_minutes, notes, is_timer_session, created_at, updated_at) VALUES
(@admin_id, (SELECT id FROM topics WHERE name = 'MySQL' LIMIT 1), (SELECT id FROM programming_languages WHERE name = 'TypeScript' LIMIT 1), '2026-07-07', '19:09:00', '20:13:00', 64, 'DEMO100: evening review and cleanup session.', FALSE, '2026-07-07 20:13:00', '2026-07-07 20:13:00');
SET @demo_session_id := LAST_INSERT_ID();

-- Day 89: 2026-07-08
INSERT INTO daily_goals (user_id, goal_date, target_minutes, achieved_minutes, is_completed, created_at) VALUES
(@admin_id, '2026-07-08', 120, 151, TRUE, '2026-07-08 06:15:00')
ON DUPLICATE KEY UPDATE
target_minutes = VALUES(target_minutes),
achieved_minutes = VALUES(achieved_minutes),
is_completed = VALUES(is_completed);
INSERT INTO coding_sessions (user_id, topic_id, language_id, session_date, start_time, end_time, duration_minutes, notes, is_timer_session, created_at, updated_at) VALUES
(@admin_id, (SELECT id FROM topics WHERE name = 'Spring Boot' LIMIT 1), (SELECT id FROM programming_languages WHERE name = 'HTML/CSS' LIMIT 1), '2026-07-08', '09:52:00', '12:17:00', 145, 'DEMO100: implemented backend endpoint and verified request flow.', FALSE, '2026-07-08 12:17:00', '2026-07-08 12:17:00');
SET @demo_session_id := LAST_INSERT_ID();
INSERT INTO coding_sessions (user_id, topic_id, language_id, session_date, start_time, end_time, duration_minutes, notes, is_timer_session, created_at, updated_at) VALUES
(@admin_id, (SELECT id FROM topics WHERE name = 'Arrays & Strings' LIMIT 1), (SELECT id FROM programming_languages WHERE name = 'Java' LIMIT 1), '2026-07-08', '19:16:00', '19:22:00', 6, 'DEMO100: evening review and cleanup session.', FALSE, '2026-07-08 19:22:00', '2026-07-08 19:22:00');
SET @demo_session_id := LAST_INSERT_ID();
INSERT INTO problems_solved (user_id, session_id, platform, problem_name, problem_url, difficulty, is_solved, time_taken_minutes, notes, solved_date, created_at) VALUES
(@admin_id, @demo_session_id, 'LeetCode', 'Decode Ways', 'https://leetcode.com/problems/decode-ways/', 'EASY', TRUE, 30, 'DEMO100: solved during the 100-day practice streak.', '2026-07-08', '2026-07-08 12:37:00');

-- Day 90: 2026-07-09
INSERT INTO daily_goals (user_id, goal_date, target_minutes, achieved_minutes, is_completed, created_at) VALUES
(@admin_id, '2026-07-09', 120, 188, TRUE, '2026-07-09 06:15:00')
ON DUPLICATE KEY UPDATE
target_minutes = VALUES(target_minutes),
achieved_minutes = VALUES(achieved_minutes),
is_completed = VALUES(is_completed);
INSERT INTO coding_sessions (user_id, topic_id, language_id, session_date, start_time, end_time, duration_minutes, notes, is_timer_session, created_at, updated_at) VALUES
(@admin_id, (SELECT id FROM topics WHERE name = 'React.js' LIMIT 1), (SELECT id FROM programming_languages WHERE name = 'TypeScript' LIMIT 1), '2026-07-09', '08:11:00', '10:36:00', 145, 'DEMO100: refactored frontend state handling and tested the page.', FALSE, '2026-07-09 10:36:00', '2026-07-09 10:36:00');
SET @demo_session_id := LAST_INSERT_ID();
INSERT INTO coding_sessions (user_id, topic_id, language_id, session_date, start_time, end_time, duration_minutes, notes, is_timer_session, created_at, updated_at) VALUES
(@admin_id, (SELECT id FROM topics WHERE name = 'Spring Security' LIMIT 1), (SELECT id FROM programming_languages WHERE name = 'JavaScript' LIMIT 1), '2026-07-09', '19:23:00', '20:06:00', 43, 'DEMO100: evening review and cleanup session.', FALSE, '2026-07-09 20:06:00', '2026-07-09 20:06:00');
SET @demo_session_id := LAST_INSERT_ID();

-- Day 91: 2026-07-10
INSERT INTO daily_goals (user_id, goal_date, target_minutes, achieved_minutes, is_completed, created_at) VALUES
(@admin_id, '2026-07-10', 120, 130, TRUE, '2026-07-10 06:15:00')
ON DUPLICATE KEY UPDATE
target_minutes = VALUES(target_minutes),
achieved_minutes = VALUES(achieved_minutes),
is_completed = VALUES(is_completed);
INSERT INTO coding_sessions (user_id, topic_id, language_id, session_date, start_time, end_time, duration_minutes, notes, is_timer_session, created_at, updated_at) VALUES
(@admin_id, (SELECT id FROM topics WHERE name = 'MySQL' LIMIT 1), (SELECT id FROM programming_languages WHERE name = 'Java' LIMIT 1), '2026-07-10', '08:30:00', '10:40:00', 130, 'DEMO100: wrote SQL query practice and checked report numbers.', TRUE, '2026-07-10 10:40:00', '2026-07-10 10:40:00');
SET @demo_session_id := LAST_INSERT_ID();
INSERT INTO problems_solved (user_id, session_id, platform, problem_name, problem_url, difficulty, is_solved, time_taken_minutes, notes, solved_date, created_at) VALUES
(@admin_id, @demo_session_id, 'LeetCode', 'Two Sum', 'https://leetcode.com/problems/two-sum/', 'HARD', FALSE, 75, 'DEMO100: attempted during the 100-day practice streak.', '2026-07-10', '2026-07-10 11:00:00');
INSERT INTO problems_solved (user_id, session_id, platform, problem_name, problem_url, difficulty, is_solved, time_taken_minutes, notes, solved_date, created_at) VALUES
(@admin_id, @demo_session_id, 'HackerRank', 'Flood Fill', 'https://www.hackerrank.com/challenges/flood-fill/problem', 'MEDIUM', TRUE, 38, 'DEMO100: solved as a stretch problem after the main session.', '2026-07-10', '2026-07-10 11:15:00');

-- Day 92: 2026-07-11
INSERT INTO daily_goals (user_id, goal_date, target_minutes, achieved_minutes, is_completed, created_at) VALUES
(@admin_id, '2026-07-11', 90, 127, TRUE, '2026-07-11 06:15:00')
ON DUPLICATE KEY UPDATE
target_minutes = VALUES(target_minutes),
achieved_minutes = VALUES(achieved_minutes),
is_completed = VALUES(is_completed);
INSERT INTO coding_sessions (user_id, topic_id, language_id, session_date, start_time, end_time, duration_minutes, notes, is_timer_session, created_at, updated_at) VALUES
(@admin_id, (SELECT id FROM topics WHERE name = 'Arrays & Strings' LIMIT 1), (SELECT id FROM programming_languages WHERE name = 'JavaScript' LIMIT 1), '2026-07-11', '08:49:00', '10:56:00', 127, 'DEMO100: studied algorithm pattern and solved a related problem.', FALSE, '2026-07-11 10:56:00', '2026-07-11 10:56:00');
SET @demo_session_id := LAST_INSERT_ID();

-- Day 93: 2026-07-12
INSERT INTO daily_goals (user_id, goal_date, target_minutes, achieved_minutes, is_completed, created_at) VALUES
(@admin_id, '2026-07-12', 90, 224, TRUE, '2026-07-12 06:15:00')
ON DUPLICATE KEY UPDATE
target_minutes = VALUES(target_minutes),
achieved_minutes = VALUES(achieved_minutes),
is_completed = VALUES(is_completed);
INSERT INTO coding_sessions (user_id, topic_id, language_id, session_date, start_time, end_time, duration_minutes, notes, is_timer_session, created_at, updated_at) VALUES
(@admin_id, (SELECT id FROM topics WHERE name = 'Spring Security' LIMIT 1), (SELECT id FROM programming_languages WHERE name = 'SQL' LIMIT 1), '2026-07-12', '09:08:00', '11:33:00', 145, 'DEMO100: reviewed JWT/auth flow and cleaned edge cases.', FALSE, '2026-07-12 11:33:00', '2026-07-12 11:33:00');
SET @demo_session_id := LAST_INSERT_ID();
INSERT INTO coding_sessions (user_id, topic_id, language_id, session_date, start_time, end_time, duration_minutes, notes, is_timer_session, created_at, updated_at) VALUES
(@admin_id, (SELECT id FROM topics WHERE name = 'System Design' LIMIT 1), (SELECT id FROM programming_languages WHERE name = 'HTML/CSS' LIMIT 1), '2026-07-12', '19:44:00', '21:03:00', 79, 'DEMO100: evening review and cleanup session.', FALSE, '2026-07-12 21:03:00', '2026-07-12 21:03:00');
SET @demo_session_id := LAST_INSERT_ID();
INSERT INTO problems_solved (user_id, session_id, platform, problem_name, problem_url, difficulty, is_solved, time_taken_minutes, notes, solved_date, created_at) VALUES
(@admin_id, @demo_session_id, 'LeetCode', 'Merge Two Sorted Lists', 'https://leetcode.com/problems/merge-two-sorted-lists/', 'EASY', TRUE, 24, 'DEMO100: solved during the 100-day practice streak.', '2026-07-12', '2026-07-12 11:53:00');

-- Day 94: 2026-07-13
INSERT INTO daily_goals (user_id, goal_date, target_minutes, achieved_minutes, is_completed, created_at) VALUES
(@admin_id, '2026-07-13', 120, 146, TRUE, '2026-07-13 06:15:00')
ON DUPLICATE KEY UPDATE
target_minutes = VALUES(target_minutes),
achieved_minutes = VALUES(achieved_minutes),
is_completed = VALUES(is_completed);
INSERT INTO coding_sessions (user_id, topic_id, language_id, session_date, start_time, end_time, duration_minutes, notes, is_timer_session, created_at, updated_at) VALUES
(@admin_id, (SELECT id FROM topics WHERE name = 'SQL Queries' LIMIT 1), (SELECT id FROM programming_languages WHERE name = 'Python' LIMIT 1), '2026-07-13', '09:27:00', '11:52:00', 145, 'DEMO100: connected UI action to real API data.', TRUE, '2026-07-13 11:52:00', '2026-07-13 11:52:00');
SET @demo_session_id := LAST_INSERT_ID();
INSERT INTO coding_sessions (user_id, topic_id, language_id, session_date, start_time, end_time, duration_minutes, notes, is_timer_session, created_at, updated_at) VALUES
(@admin_id, (SELECT id FROM topics WHERE name = 'Spring Boot' LIMIT 1), (SELECT id FROM programming_languages WHERE name = 'TypeScript' LIMIT 1), '2026-07-13', '19:51:00', '19:52:00', 1, 'DEMO100: evening review and cleanup session.', FALSE, '2026-07-13 19:52:00', '2026-07-13 19:52:00');
SET @demo_session_id := LAST_INSERT_ID();

-- Day 95: 2026-07-14
INSERT INTO daily_goals (user_id, goal_date, target_minutes, achieved_minutes, is_completed, created_at) VALUES
(@admin_id, '2026-07-14', 120, 183, TRUE, '2026-07-14 06:15:00')
ON DUPLICATE KEY UPDATE
target_minutes = VALUES(target_minutes),
achieved_minutes = VALUES(achieved_minutes),
is_completed = VALUES(is_completed);
INSERT INTO coding_sessions (user_id, topic_id, language_id, session_date, start_time, end_time, duration_minutes, notes, is_timer_session, created_at, updated_at) VALUES
(@admin_id, (SELECT id FROM topics WHERE name = 'Git & GitHub' LIMIT 1), (SELECT id FROM programming_languages WHERE name = 'HTML/CSS' LIMIT 1), '2026-07-14', '09:46:00', '12:11:00', 145, 'DEMO100: reviewed Git workflow and documented progress.', FALSE, '2026-07-14 12:11:00', '2026-07-14 12:11:00');
SET @demo_session_id := LAST_INSERT_ID();
INSERT INTO coding_sessions (user_id, topic_id, language_id, session_date, start_time, end_time, duration_minutes, notes, is_timer_session, created_at, updated_at) VALUES
(@admin_id, (SELECT id FROM topics WHERE name = 'React.js' LIMIT 1), (SELECT id FROM programming_languages WHERE name = 'Java' LIMIT 1), '2026-07-14', '19:58:00', '20:36:00', 38, 'DEMO100: evening review and cleanup session.', FALSE, '2026-07-14 20:36:00', '2026-07-14 20:36:00');
SET @demo_session_id := LAST_INSERT_ID();
INSERT INTO problems_solved (user_id, session_id, platform, problem_name, problem_url, difficulty, is_solved, time_taken_minutes, notes, solved_date, created_at) VALUES
(@admin_id, @demo_session_id, 'LeetCode', 'Contains Duplicate', 'https://leetcode.com/problems/contains-duplicate/', 'EASY', TRUE, 21, 'DEMO100: solved during the 100-day practice streak.', '2026-07-14', '2026-07-14 12:31:00');

-- Day 96: 2026-07-15
INSERT INTO daily_goals (user_id, goal_date, target_minutes, achieved_minutes, is_completed, created_at) VALUES
(@admin_id, '2026-07-15', 120, 125, TRUE, '2026-07-15 06:15:00')
ON DUPLICATE KEY UPDATE
target_minutes = VALUES(target_minutes),
achieved_minutes = VALUES(achieved_minutes),
is_completed = VALUES(is_completed);
INSERT INTO coding_sessions (user_id, topic_id, language_id, session_date, start_time, end_time, duration_minutes, notes, is_timer_session, created_at, updated_at) VALUES
(@admin_id, (SELECT id FROM topics WHERE name = 'System Design' LIMIT 1), (SELECT id FROM programming_languages WHERE name = 'TypeScript' LIMIT 1), '2026-07-15', '08:05:00', '10:10:00', 125, 'DEMO100: planned architecture decisions from a product perspective.', FALSE, '2026-07-15 10:10:00', '2026-07-15 10:10:00');
SET @demo_session_id := LAST_INSERT_ID();

-- Day 97: 2026-07-16
INSERT INTO daily_goals (user_id, goal_date, target_minutes, achieved_minutes, is_completed, created_at) VALUES
(@admin_id, '2026-07-16', 120, 162, TRUE, '2026-07-16 06:15:00')
ON DUPLICATE KEY UPDATE
target_minutes = VALUES(target_minutes),
achieved_minutes = VALUES(achieved_minutes),
is_completed = VALUES(is_completed);
INSERT INTO coding_sessions (user_id, topic_id, language_id, session_date, start_time, end_time, duration_minutes, notes, is_timer_session, created_at, updated_at) VALUES
(@admin_id, (SELECT id FROM topics WHERE name = 'Spring Boot' LIMIT 1), (SELECT id FROM programming_languages WHERE name = 'Java' LIMIT 1), '2026-07-16', '08:24:00', '10:49:00', 145, 'DEMO100: implemented backend endpoint and verified request flow.', TRUE, '2026-07-16 10:49:00', '2026-07-16 10:49:00');
SET @demo_session_id := LAST_INSERT_ID();
INSERT INTO coding_sessions (user_id, topic_id, language_id, session_date, start_time, end_time, duration_minutes, notes, is_timer_session, created_at, updated_at) VALUES
(@admin_id, (SELECT id FROM topics WHERE name = 'Arrays & Strings' LIMIT 1), (SELECT id FROM programming_languages WHERE name = 'SQL' LIMIT 1), '2026-07-16', '20:12:00', '20:29:00', 17, 'DEMO100: evening review and cleanup session.', FALSE, '2026-07-16 20:29:00', '2026-07-16 20:29:00');
SET @demo_session_id := LAST_INSERT_ID();
INSERT INTO problems_solved (user_id, session_id, platform, problem_name, problem_url, difficulty, is_solved, time_taken_minutes, notes, solved_date, created_at) VALUES
(@admin_id, @demo_session_id, 'LeetCode', 'Product of Array Except Self', 'https://leetcode.com/problems/product-of-array-except-self/', 'MEDIUM', TRUE, 42, 'DEMO100: solved during the 100-day practice streak.', '2026-07-16', '2026-07-16 11:09:00');

-- Day 98: 2026-07-17
INSERT INTO daily_goals (user_id, goal_date, target_minutes, achieved_minutes, is_completed, created_at) VALUES
(@admin_id, '2026-07-17', 120, 199, TRUE, '2026-07-17 06:15:00')
ON DUPLICATE KEY UPDATE
target_minutes = VALUES(target_minutes),
achieved_minutes = VALUES(achieved_minutes),
is_completed = VALUES(is_completed);
INSERT INTO coding_sessions (user_id, topic_id, language_id, session_date, start_time, end_time, duration_minutes, notes, is_timer_session, created_at, updated_at) VALUES
(@admin_id, (SELECT id FROM topics WHERE name = 'React.js' LIMIT 1), (SELECT id FROM programming_languages WHERE name = 'JavaScript' LIMIT 1), '2026-07-17', '08:43:00', '11:08:00', 145, 'DEMO100: refactored frontend state handling and tested the page.', FALSE, '2026-07-17 11:08:00', '2026-07-17 11:08:00');
SET @demo_session_id := LAST_INSERT_ID();
INSERT INTO coding_sessions (user_id, topic_id, language_id, session_date, start_time, end_time, duration_minutes, notes, is_timer_session, created_at, updated_at) VALUES
(@admin_id, (SELECT id FROM topics WHERE name = 'Spring Security' LIMIT 1), (SELECT id FROM programming_languages WHERE name = 'Python' LIMIT 1), '2026-07-17', '19:04:00', '19:58:00', 54, 'DEMO100: evening review and cleanup session.', FALSE, '2026-07-17 19:58:00', '2026-07-17 19:58:00');
SET @demo_session_id := LAST_INSERT_ID();

-- Day 99: 2026-07-18
INSERT INTO daily_goals (user_id, goal_date, target_minutes, achieved_minutes, is_completed, created_at) VALUES
(@admin_id, '2026-07-18', 90, 101, TRUE, '2026-07-18 06:15:00')
ON DUPLICATE KEY UPDATE
target_minutes = VALUES(target_minutes),
achieved_minutes = VALUES(achieved_minutes),
is_completed = VALUES(is_completed);
INSERT INTO coding_sessions (user_id, topic_id, language_id, session_date, start_time, end_time, duration_minutes, notes, is_timer_session, created_at, updated_at) VALUES
(@admin_id, (SELECT id FROM topics WHERE name = 'MySQL' LIMIT 1), (SELECT id FROM programming_languages WHERE name = 'SQL' LIMIT 1), '2026-07-18', '09:02:00', '10:43:00', 101, 'DEMO100: wrote SQL query practice and checked report numbers.', FALSE, '2026-07-18 10:43:00', '2026-07-18 10:43:00');
SET @demo_session_id := LAST_INSERT_ID();
INSERT INTO problems_solved (user_id, session_id, platform, problem_name, problem_url, difficulty, is_solved, time_taken_minutes, notes, solved_date, created_at) VALUES
(@admin_id, @demo_session_id, 'LeetCode', 'Climbing Stairs', 'https://leetcode.com/problems/climbing-stairs/', 'EASY', TRUE, 15, 'DEMO100: solved during the 100-day practice streak.', '2026-07-18', '2026-07-18 11:03:00');

-- Day 100: 2026-07-19
INSERT INTO daily_goals (user_id, goal_date, target_minutes, achieved_minutes, is_completed, created_at) VALUES
(@admin_id, '2026-07-19', 90, 138, TRUE, '2026-07-19 06:15:00')
ON DUPLICATE KEY UPDATE
target_minutes = VALUES(target_minutes),
achieved_minutes = VALUES(achieved_minutes),
is_completed = VALUES(is_completed);
INSERT INTO coding_sessions (user_id, topic_id, language_id, session_date, start_time, end_time, duration_minutes, notes, is_timer_session, created_at, updated_at) VALUES
(@admin_id, (SELECT id FROM topics WHERE name = 'Arrays & Strings' LIMIT 1), (SELECT id FROM programming_languages WHERE name = 'Python' LIMIT 1), '2026-07-19', '09:21:00', '11:39:00', 138, 'DEMO100: studied algorithm pattern and solved a related problem.', TRUE, '2026-07-19 11:39:00', '2026-07-19 11:39:00');
SET @demo_session_id := LAST_INSERT_ID();

INSERT IGNORE INTO user_achievements (user_id, achievement_id, earned_at)
SELECT @admin_id, id, NOW() FROM achievements
WHERE name IN ('First Steps', 'Getting Started', 'Consistent', 'Centurion', 'On Fire', 'Unstoppable', 'Dedicated', 'Committed', 'Master', 'Problem Solver', 'Algorithm Expert');

COMMIT;

SELECT
  (SELECT COUNT(*) FROM coding_sessions WHERE user_id = @admin_id AND notes LIKE 'DEMO100:%') AS demo_sessions,
  (SELECT ROUND(SUM(duration_minutes) / 60, 1) FROM coding_sessions WHERE user_id = @admin_id AND notes LIKE 'DEMO100:%') AS demo_hours,
  (SELECT COUNT(*) FROM daily_goals WHERE user_id = @admin_id AND goal_date BETWEEN '2026-04-11' AND '2026-07-19') AS seeded_goal_days,
  (SELECT COUNT(*) FROM problems_solved WHERE user_id = @admin_id AND notes LIKE 'DEMO100:%') AS demo_problems,
  (SELECT COUNT(*) FROM problems_solved WHERE user_id = @admin_id AND notes LIKE 'DEMO100:%' AND is_solved = TRUE) AS solved_demo_problems,
  (SELECT COUNT(*) FROM user_achievements WHERE user_id = @admin_id) AS earned_achievements;
