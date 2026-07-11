# CodeTracker

CodeTracker is a personal coding activity tracker: a full-stack application for logging coding sessions, setting daily goals, tracking solved programming problems, viewing reports, and earning achievement badges.

## Tech Stack

### Backend

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

### Frontend

- React.js
- JavaScript
- React Router
- Axios
- Chart.js / react-chartjs-2
- React Icons
- React Datepicker
- React Hot Toast
- Plain CSS

## Project Structure

```text
codetracker/
├── pom.xml
├── src/
├── codetracker-frontend/
│   ├── package.json
│   ├── public/
│   └── src/
├── README.md
└── docs/
```

The Spring Boot backend currently lives at the repository root. The React frontend lives in `codetracker-frontend/`.

## Current Scope

The backend follows the CodeTracker blueprint with REST API layers for authentication, users, coding sessions, goals, problems, reports, achievements, topics, and programming languages.

The frontend Chapter 12 UI includes pages for login, registration, dashboard, coding sessions, goals, problems, reports, achievements, and profile.

## Backend Setup

Create the database before running the app:

```sql
CREATE DATABASE codetracker_db;
```

The local application config lives in `src/main/resources/application.properties` and is ignored by Git. Use `src/main/resources/application.properties.example` as the shareable template.

Expected backend URL:

```text
http://localhost:8080
```

Run backend tests:

```powershell
.\mvnw.cmd test
```

## Frontend Setup

Install frontend dependencies from inside the frontend folder:

```powershell
cd codetracker-frontend
npm ci
```

Run the frontend development server:

```powershell
npm start
```

Expected frontend URL:

```text
http://localhost:3000
```

Build the frontend:

```powershell
npm run build
```

## Git Security Note

`application.properties` contains local database credentials and JWT secrets, so it must not be committed. Commit `application.properties.example` instead.
