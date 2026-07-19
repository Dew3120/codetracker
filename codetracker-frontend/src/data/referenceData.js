export const topicOptions = [
  { id: 1, name: "Java Fundamentals", category: "Backend" },
  { id: 2, name: "Spring Boot", category: "Backend" },
  { id: 3, name: "Spring Security", category: "Backend" },
  { id: 4, name: "Spring Data JPA", category: "Backend" },
  { id: 5, name: "Node.js", category: "Backend" },
  { id: 6, name: "Express.js", category: "Backend" },
  { id: 7, name: "React.js", category: "Frontend" },
  { id: 8, name: "HTML/CSS", category: "Frontend" },
  { id: 9, name: "JavaScript ES6+", category: "Frontend" },
  { id: 10, name: "TypeScript", category: "Frontend" },
  { id: 11, name: "MySQL", category: "Database" },
  { id: 12, name: "MongoDB", category: "Database" },
  { id: 13, name: "SQL Queries", category: "Database" },
  { id: 14, name: "Arrays & Strings", category: "DSA" },
  { id: 15, name: "Linked Lists", category: "DSA" },
  { id: 16, name: "Stacks & Queues", category: "DSA" },
  { id: 17, name: "Trees & Graphs", category: "DSA" },
  { id: 18, name: "Sorting Algorithms", category: "DSA" },
  { id: 19, name: "Dynamic Programming", category: "DSA" },
  { id: 20, name: "Git & GitHub", category: "DevOps" },
  { id: 21, name: "Docker", category: "DevOps" },
  { id: 22, name: "CI/CD", category: "DevOps" },
  { id: 23, name: "Python Basics", category: "Backend" },
  { id: 24, name: "Machine Learning", category: "Backend" },
  { id: 25, name: "Flutter/Dart", category: "Frontend" },
  { id: 26, name: "System Design", category: "Other" },
];

export const languageOptions = [
  { id: 1, name: "Java", colorHex: "#B07219" },
  { id: 2, name: "Python", colorHex: "#3572A5" },
  { id: 3, name: "JavaScript", colorHex: "#F1E05A" },
  { id: 4, name: "TypeScript", colorHex: "#3178C6" },
  { id: 5, name: "SQL", colorHex: "#E38C00" },
  { id: 6, name: "HTML/CSS", colorHex: "#E34C26" },
  { id: 7, name: "C#", colorHex: "#178600" },
  { id: 8, name: "Dart", colorHex: "#00B4AB" },
  { id: 9, name: "PHP", colorHex: "#4F5D95" },
];

export function findTopicIdByName(name) {
  return topicOptions.find((topic) => topic.name === name)?.id || topicOptions[0].id;
}

export function findLanguageIdByName(name) {
  return languageOptions.find((language) => language.name === name)?.id || languageOptions[0].id;
}