export const sessions = [
  {
    id: 1,
    name: "Spring Security JWT",
    topic: "Spring Boot",
    language: "Java",
    date: "Today",
    duration: "2h 15m",
    status: "Completed",
  },
  {
    id: 2,
    name: "React Router Layout",
    topic: "React.js",
    language: "JavaScript",
    date: "Yesterday",
    duration: "1h 40m",
    status: "Completed",
  },
  {
    id: 3,
    name: "Dynamic Programming Review",
    topic: "DSA",
    language: "Java",
    date: "Jul 05",
    duration: "1h 05m",
    status: "Completed",
  },
];

export const problems = [
  {
    id: 1,
    name: "Two Sum",
    platform: "LeetCode",
    difficulty: "Easy",
    solvedDate: "Today",
    timeSpent: "18m",
    solved: true,
  },
  {
    id: 2,
    name: "Longest Substring Without Repeating Characters",
    platform: "LeetCode",
    difficulty: "Medium",
    solvedDate: "Yesterday",
    timeSpent: "42m",
    solved: true,
  },
  {
    id: 3,
    name: "Median of Two Sorted Arrays",
    platform: "HackerRank",
    difficulty: "Hard",
    solvedDate: "Jul 05",
    timeSpent: "1h 12m",
    solved: false,
  },
];

export const achievements = [
  {
    id: 1,
    title: "First Session",
    description: "Completed your first focused coding session.",
    icon: "clock",
    progress: 100,
    unlocked: true,
  },
  {
    id: 2,
    title: "Seven Day Streak",
    description: "Code consistently for seven days in a row.",
    icon: "flame",
    progress: 71,
    unlocked: false,
  },
  {
    id: 3,
    title: "Problem Solver",
    description: "Solve 100 coding problems across platforms.",
    icon: "target",
    progress: 64,
    unlocked: false,
  },
  {
    id: 4,
    title: "Deep Work",
    description: "Complete a coding session longer than two hours.",
    icon: "zap",
    progress: 100,
    unlocked: true,
  },
];

export const weeklyHours = [
  { day: "Mon", hours: 1.2 },
  { day: "Tue", hours: 2.4 },
  { day: "Wed", hours: 1.6 },
  { day: "Thu", hours: 3.1 },
  { day: "Fri", hours: 2.0 },
  { day: "Sat", hours: 3.6 },
  { day: "Sun", hours: 1.8 },
];

export const topicBreakdown = [
  { name: "Spring Boot", value: 38, color: "#2563eb" },
  { name: "React.js", value: 26, color: "#14b8a6" },
  { name: "DSA", value: 22, color: "#f59e0b" },
  { name: "MySQL", value: 14, color: "#ef4444" },
];

export const goalCards = [
  { label: "Daily Goal", value: "120m", detail: "84 minutes completed" },
  { label: "Weekly Target", value: "14h", detail: "10.5 hours completed" },
  { label: "Streak", value: "6 days", detail: "One day from badge unlock" },
];
