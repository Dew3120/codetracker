# CodeTracker

A comprehensive **full-stack application** for tracking and managing coding problems, solutions, and progress. CodeTracker empowers developers to organize their practice problems, track their solving status, and build a personal problem database.

---

## 📋 Table of Contents

- [Tech Stack](#tech-stack)
- [Features](#features)
- [Prerequisites](#prerequisites)
- [Project Structure](#project-structure)
- [How to Run Locally](#how-to-run-locally)
  - [Environment Setup](#environment-setup)
  - [Database Setup](#database-setup)
  - [Running the Application](#running-the-application)
- [API Documentation](#api-documentation)
- [Future Roadmap](#future-roadmap)

---

## 🚀 Tech Stack

### Backend
- **Java 17** - Programming language
- **Spring Boot 3.5.16** - Application framework
- **Spring Security** - Authentication and authorization
- **Spring Data JPA** - ORM and database abstraction
- **JWT (JSON Web Token)** - Stateless authentication
- **MySQL** - Relational database
- **BCrypt** - Password encryption
- **Lombok** - Boilerplate code reduction
- **Maven** - Build tool

### Frontend (Coming Soon)
- **React** - UI library
- **TypeScript** - Type-safe JavaScript
- **Axios** - HTTP client
- **React Router** - Client-side routing

---

## ✨ Features

✅ **JWT Authentication**
- Secure user registration with email validation
- Login with JWT token generation
- Token-based session management
- Stateless authentication

✅ **Problem CRUD Operations**
- Create, read, update, and delete problems
- Track problem difficulty (Easy, Medium, Hard)
- Categorize by topic (Arrays, Trees, Graphs, etc.)
- Mark problems as Solved or Unsolved
- Add personal notes for each problem
- Track solve timestamps

✅ **Security**
- BCrypt password encryption
- JWT token validation
- Role-based access control (ROLE_USER)
- User isolation - users can only access their own problems
- Secure endpoints with Spring Security

✅ **RESTful API**
- Clean, intuitive endpoint design
- Proper HTTP status codes (200, 201, 400, 401, 403, 404)
- JSON request/response format
- Validation and error handling

---

## 📋 Prerequisites

Before running the application, ensure you have the following installed:

- **Java 17 or higher** - Download from [oracle.com](https://www.oracle.com/java/technologies/downloads/) or use a package manager
- **Maven 3.6+** - Comes with the project (`mvnw`/`mvnw.cmd`) or install from [maven.apache.org](https://maven.apache.org/)
- **MySQL 8.0+** - Download from [mysql.com](https://www.mysql.com/) or use Docker
- **Git** - For version control

### Using Docker for MySQL (Optional)
```bash
docker run --name codetracker-mysql -e MYSQL_ROOT_PASSWORD=root -e MYSQL_DATABASE=codetracker_db -p 3306:3306 -d mysql:8.0
```

---

## 📁 Project Structure

```
codetracker/
├── src/
│   ├── main/
│   │   ├── java/com/codetracker/codetracker/
│   │   │   ├── CodetrackerApplication.java          # Spring Boot entry point
│   │   │   ├── config/
│   │   │   │   ├── JwtAuthFilter.java               # JWT token filter
│   │   │   │   ├── JwtUtils.java                    # JWT token generation & validation
│   │   │   │   └── SecurityConfig.java              # Spring Security configuration
│   │   │   ├── controller/
│   │   │   │   ├── AuthController.java              # Auth endpoints (register, login)
│   │   │   │   └── ProblemController.java           # Problem endpoints (CRUD)
│   │   │   ├── model/
│   │   │   │   ├── User.java                        # User entity
│   │   │   │   └── Problem.java                     # Problem entity
│   │   │   ├── repository/
│   │   │   │   ├── UserRepository.java              # User data access
│   │   │   │   └── ProblemRepository.java           # Problem data access
│   │   │   └── service/
│   │   │       ├── UserService.java                 # User business logic
│   │   │       ├── UserDetailsServiceImpl.java       # Spring Security user loader
│   │   │       └── ProblemService.java              # Problem business logic
│   │   └── resources/
│   │       ├── application.properties                # Application configuration
│   │       ├── static/                               # Static files (CSS, JS, images)
│   │       └── templates/                            # Thymeleaf templates (optional)
│   └── test/
│       └── java/.../CodetrackerApplicationTests.java # Unit tests
├── pom.xml                                           # Maven dependencies
├── mvnw / mvnw.cmd                                   # Maven wrapper scripts
├── HELP.md                                           # Spring Boot help
└── README.md                                         # This file
```

---

## 🏃 How to Run Locally

### Environment Setup

1. **Clone the repository** (or navigate to the project directory)
   ```bash
   cd C:\Projects\codetracker\codetracker
   ```

2. **Create application.properties** from the example
   ```bash
   # Copy the example file
   copy src\main\resources\application.properties.example src\main\resources\application.properties
   ```

3. **Configure environment variables** in `src/main/resources/application.properties`
   ```properties
   spring.datasource.url=jdbc:mysql://localhost:3306/codetracker_db
   spring.datasource.username=root
   spring.datasource.password=your_mysql_password
   spring.jpa.hibernate.ddl-auto=update
   spring.jpa.show-sql=true
   spring.jpa.properties.hibernate.dialect=org.hibernate.dialect.MySQLDialect
   server.port=8080
   
   # JWT Configuration (must be at least 64 characters)
   jwt.secret=your_very_long_secret_key_at_least_64_characters_long_for_hs512_algorithm_here
   jwt.expiration=86400000
   ```

### Database Setup

1. **Create MySQL database**
   ```bash
   mysql -u root -p -e "CREATE DATABASE IF NOT EXISTS codetracker_db;"
   ```

2. **Verify connection**
   ```bash
   mysql -u root -p -D codetracker_db -e "SELECT 1;"
   ```

   Tables will be created automatically by Hibernate on first run (ddl-auto=update)

### Running the Application

1. **Build the project** (using Maven wrapper)
   ```bash
   # Windows
   mvnw.cmd clean package
   
   # Linux/Mac
   ./mvnw clean package
   ```

2. **Run the application**
   ```bash
   # Using Maven
   mvnw.cmd spring-boot:run
   
   # Or using the JAR
   java -jar target/codetracker-0.0.1-SNAPSHOT.jar
   ```

3. **Verify it's running**
   - Open browser: `http://localhost:8080`
   - Server should respond (or check logs for errors)

---

## 🔌 API Documentation

### Base URL
```
http://localhost:8080/api
```

### Authentication Endpoints

| Method | Endpoint | Description | Body | Auth Required | Response |
|--------|----------|-------------|------|---------------|----------|
| **POST** | `/auth/register` | Register a new user | `{ "username": "alice", "email": "alice@example.com", "password": "secret" }` | ❌ No | `"User registered successfully!"` |
| **POST** | `/auth/login` | Authenticate and get JWT token | `{ "username": "alice", "password": "secret" }` | ❌ No | `{ "token": "eyJhbGciOi..." }` |

### Problem Endpoints

| Method | Endpoint | Description | Body | Auth Required | Response |
|--------|----------|-------------|------|---------------|----------|
| **GET** | `/problems` | Get all problems for authenticated user | N/A | ✅ Yes | `[ { "id": 1, "title": "Two Sum", ... }, ... ]` |
| **POST** | `/problems` | Create a new problem | `{ "title": "Two Sum", "difficulty": "Easy", "topic": "Arrays", "status": "Unsolved", "notes": "Use hash map" }` | ✅ Yes | `{ "id": 1, "title": "Two Sum", ... }` |
| **PUT** | `/problems/{id}` | Update a problem by ID | `{ "title": "Updated Title", "status": "Solved" }` | ✅ Yes | `{ "id": 1, "title": "Updated Title", ... }` |
| **DELETE** | `/problems/{id}` | Delete a problem by ID | N/A | ✅ Yes | `204 No Content` |

### Request/Response Examples

#### Register User
```bash
curl -X POST http://localhost:8080/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "username": "alice",
    "email": "alice@example.com",
    "password": "password123"
  }'
```

#### Login
```bash
curl -X POST http://localhost:8080/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "username": "alice",
    "password": "password123"
  }'
```

Response:
```json
{
  "token": "eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJhbGljZSIsImlhdCI6MTcyNDEyMzQ1NiwiZXhwIjoxNzI0MjA5ODU2fQ...."
}
```

#### Create Problem
```bash
curl -X POST http://localhost:8080/api/problems \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer eyJhbGciOiJIUzUxMiJ9...." \
  -d '{
    "title": "Two Sum",
    "difficulty": "Easy",
    "topic": "Arrays",
    "status": "Unsolved",
    "notes": "Use a hash map to store complements"
  }'
```

Response:
```json
{
  "id": 1,
  "title": "Two Sum",
  "difficulty": "Easy",
  "topic": "Arrays",
  "status": "Unsolved",
  "notes": "Use a hash map to store complements",
  "solvedAt": null,
  "user": {
    "id": 1,
    "username": "alice",
    "email": "alice@example.com",
    "createdAt": "2024-06-27T10:30:00"
  }
}
```

#### Update Problem
```bash
curl -X PUT http://localhost:8080/api/problems/1 \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer eyJhbGciOiJIUzUxMiJ9...." \
  -d '{
    "status": "Solved",
    "notes": "Solved using HashMap - Time: O(n), Space: O(n)"
  }'
```

#### Get All Problems
```bash
curl -X GET http://localhost:8080/api/problems \
  -H "Authorization: Bearer eyJhbGciOiJIUzUxMiJ9...."
```

#### Delete Problem
```bash
curl -X DELETE http://localhost:8080/api/problems/1 \
  -H "Authorization: Bearer eyJhbGciOiJIUzUxMiJ9...."
```

---

## 🔒 Security Features

- **Password Encryption**: All passwords are hashed using BCrypt with strength 10
- **JWT Tokens**: Secure, stateless authentication with HS512 algorithm
- **CORS**: Configured to allow frontend communication (to be added)
- **CSRF Protection**: Disabled for stateless API (JWT-based)
- **User Isolation**: Users can only access their own data
- **Input Validation**: Jakarta Validation annotations on request bodies

---

## 📚 Database Schema

### users table
```sql
CREATE TABLE users (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  username VARCHAR(255) UNIQUE NOT NULL,
  email VARCHAR(255) UNIQUE NOT NULL,
  password VARCHAR(255) NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);
```

### problems table
```sql
CREATE TABLE problems (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  title VARCHAR(255) NOT NULL,
  difficulty VARCHAR(50),
  topic VARCHAR(100),
  status VARCHAR(50),
  notes TEXT,
  solved_at DATETIME,
  user_id BIGINT NOT NULL,
  FOREIGN KEY (user_id) REFERENCES users(id)
);
```

---

## 🚧 Future Roadmap

- [ ] **React Frontend** - Beautiful, responsive UI for problem management
- [ ] **Advanced Filtering** - Filter problems by difficulty, topic, status
- [ ] **Problem Categories** - Custom categories and tags
- [ ] **Statistics Dashboard** - Solve rate, time analytics, progress charts
- [ ] **Code Snippets** - Store and manage solution code
- [ ] **Difficulty Ratings** - User-contributed difficulty ratings
- [ ] **Export/Import** - Export problem data as JSON/CSV
- [ ] **Mobile App** - React Native mobile version
- [ ] **Docker Compose** - One-command deployment
- [ ] **Unit & Integration Tests** - Comprehensive test coverage

---

## 📝 License

This project is open-source and available under the MIT License.

---

## 👨‍💻 Contributing

Contributions are welcome! Feel free to fork, make improvements, and submit pull requests.

---

## 📞 Support

For issues or questions:
1. Check the API Documentation above
2. Review the application logs
3. Ensure MySQL is running and accessible
4. Verify `application.properties` configuration

---

**Happy coding! 🚀**

