# CodeTracker

[![CodeTracker CI](https://github.com/Dew3120/codetracker/actions/workflows/ci.yml/badge.svg)](https://github.com/Dew3120/codetracker/actions/workflows/ci.yml)

CodeTracker is a full-stack coding progress tracker for logging practice sessions, goals, solved problems, reports, and achievement badges.

## Screenshot / GIF

Final screenshot or GIF should be added after the final UI polish pass. Recommended capture:

```text
Login as admin@email.com / admin123
Open Dashboard, Reports, and Achievements after running the 100-day demo seed.
```

## Tech Stack

Backend:

- Java 17
- Spring Boot 3.2.x
- Spring Web
- Spring Data JPA with Hibernate
- Spring Security with JWT and BCrypt
- MySQL 8.0
- Maven
- Lombok
- Jakarta Validation
- Springdoc OpenAPI / Swagger UI
- JUnit 5, Mockito, MockMvc, JaCoCo

Frontend:

- React.js
- JavaScript
- React Router
- Axios
- Chart.js / react-chartjs-2
- React Icons
- React Datepicker
- React Hot Toast
- Plain CSS

DevOps / Tooling:

- Git and GitHub
- GitHub Actions CI
- Postman collection
- MySQL seed scripts

## Features

- JWT authentication with login and registration
- Protected frontend routes with persisted auth state
- User profile update and password change flow
- Coding session CRUD with manual and timer-based entry
- Daily goal tracking and streak calculation
- Problem logging for LeetCode-style practice
- Weekly and monthly reports
- Language and topic distribution reports
- Achievement badge status from backend data
- 100-day admin demo data seed for realistic portfolio walkthroughs
- Backend unit/controller tests with JaCoCo coverage report

## Demo Login

For local testing:

```text
Email: admin@email.com
Password: admin123
```

This account is seeded in `src/main/resources/data.sql`.

## How To Run

Prerequisites:

- Java 17
- Maven or the included Maven wrapper
- Node.js and npm
- MySQL 8.0

Create the local database:

```sql
CREATE DATABASE codetracker_db;
```

Run the backend:

```powershell
cd C:\Projects\codetracker\codetracker
.\mvnw.cmd spring-boot:run
```

Backend URL:

```text
http://localhost:8080
```

Run backend tests:

```powershell
.\mvnw.cmd test
```

Generate coverage report:

```powershell
.\mvnw.cmd test jacoco:report
```

Run the frontend:

```powershell
cd C:\Projects\codetracker\codetracker\codetracker-frontend
npm ci
npm start
```

Frontend URL:

```text
http://localhost:3000
```

Build the frontend:

```powershell
npm run build
```

Seed 100 days of admin demo data:

```powershell
mysql -u root -proot -D codetracker_db -e "source C:/Projects/codetracker/codetracker/scripts/seed-admin-100-days-demo.sql"
```

## API Endpoints Summary

Authentication:

- `POST /api/auth/register`
- `POST /api/auth/login`
- `GET /api/auth/me`

Users:

- `PUT /api/users/profile`
- `PUT /api/users/password`

Coding sessions:

- `POST /api/sessions`
- `GET /api/sessions`
- `GET /api/sessions/today`
- `GET /api/sessions/{id}`
- `PUT /api/sessions/{id}`
- `DELETE /api/sessions/{id}`
- `GET /api/sessions/range`

Goals:

- `POST /api/goals`
- `GET /api/goals/today`
- `GET /api/goals/streak`
- `GET /api/goals/history`

Problems:

- `GET /api/problems`
- `POST /api/problems`
- `PUT /api/problems/{id}`
- `DELETE /api/problems/{id}`
- `GET /api/problems/stats`

Reports:

- `GET /api/reports/weekly`
- `GET /api/reports/monthly?month=YYYY-MM`
- `GET /api/reports/languages`
- `GET /api/reports/topics`

Achievements:

- `GET /api/achievements`

API documentation:

- `GET /swagger-ui.html`
- `GET /v3/api-docs`

## Project Structure

```text
codetracker/
|-- .github/
|   `-- workflows/
|       `-- ci.yml
|-- codetracker-frontend/
|   |-- package.json
|   |-- public/
|   `-- src/
|       |-- api/
|       |-- components/
|       |-- context/
|       |-- pages/
|       |-- styles/
|       `-- utils/
|-- postman/
|   `-- CodeTracker API.postman_collection.json
|-- scripts/
|   `-- seed-admin-100-days-demo.sql
|-- src/
|   |-- main/
|   |   |-- java/com/codetracker/
|   |   `-- resources/
|   `-- test/
|       `-- java/com/codetracker/
|-- pom.xml
|-- README.md
`-- mvnw.cmd
```

## CI/CD

GitHub Actions runs on pushes and pull requests to `main`.

The CI pipeline:

- Starts a MySQL 8.0 service database
- Sets up Java 17 with Temurin
- Runs `mvn clean verify`
- Executes the backend test suite and JaCoCo instrumentation

Workflow file:

```text
.github/workflows/ci.yml
```

## What I Learned

- Designing a layered Spring Boot backend with controller, service, repository, DTO, and entity boundaries
- Implementing JWT authentication and protected frontend routes
- Connecting React pages to real backend APIs with Axios
- Designing relational tables for sessions, goals, problems, reports, and achievements
- Writing focused unit and controller tests for backend behavior
- Creating realistic demo seed data for product walkthroughs
- Setting up CI with GitHub Actions and MySQL service containers
- Thinking about a project as both a technical system and a portfolio product

## License

This project is built for educational and portfolio use. Add a formal license file before using it as a public reusable template.
