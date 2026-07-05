# CodeTracker

CodeTracker is a personal coding activity tracker: a full-stack application for logging coding sessions, setting daily goals, tracking solved programming problems, viewing reports, and earning achievement badges.

## Tech Stack

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
- React.js frontend planned for the next project phase

## Current Backend Scope

The backend follows the CodeTracker blueprint with REST API layers for authentication, users, coding sessions, goals, problems, reports, achievements, topics, and programming languages.

## Project Setup

Spring Initializr settings used by the blueprint:

- Project: Maven
- Language: Java
- Spring Boot: 3.2.x
- Group: com.codetracker
- Artifact: codetracker
- Name: CodeTracker
- Description: Personal coding activity tracker
- Package: com.codetracker
- Packaging: Jar
- Java: 17

## Required Dependencies

The backend uses these dependencies from the blueprint:

- Spring Web
- Spring Data JPA
- MySQL Driver
- Spring Security
- Lombok
- Validation
- Spring Boot DevTools
- JJWT API, implementation, and Jackson support
- Springdoc OpenAPI Swagger UI

## Local Configuration

Create the database before running the app:

```sql
CREATE DATABASE codetracker_db;
```

The local application config lives in `src/main/resources/application.properties` and is ignored by Git. Use `src/main/resources/application.properties.example` as the shareable template.

Expected local backend URL:

```text
http://localhost:8080
```

## Verification Commands

Use Maven to compile and run tests:

```powershell
mvn test
```

If Maven is not on PATH, use your installed Maven path or configure PATH first.

Check the database tables:

```powershell
mysql -uroot -p -D codetracker_db -e "SHOW TABLES;"
```

## Git Security Note

`application.properties` contains local database credentials and JWT secrets, so it must not be committed. Commit `application.properties.example` instead.