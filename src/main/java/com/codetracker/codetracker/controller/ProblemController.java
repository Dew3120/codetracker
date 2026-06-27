package com.codetracker.codetracker.controller;

import com.codetracker.codetracker.model.Problem;
import com.codetracker.codetracker.model.User;
import com.codetracker.codetracker.repository.UserRepository;
import com.codetracker.codetracker.service.ProblemService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/api/problems")
public class ProblemController {

    private final ProblemService problemService;
    private final UserRepository userRepository;

    @Autowired
    public ProblemController(ProblemService problemService, UserRepository userRepository) {
        this.problemService = problemService;
        this.userRepository = userRepository;
    }

    /**
     * Helper method to get the currently authenticated user
     */
    private User getCurrentUser() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        String username = authentication.getName();
        return userRepository.findByUsername(username)
                .orElseThrow(() -> new RuntimeException("Current user not found"));
    }

    @GetMapping
    public ResponseEntity<List<Problem>> getAllProblems() {
        User currentUser = getCurrentUser();
        List<Problem> problems = problemService.getAllProblemsByUserId(currentUser.getId());
        return ResponseEntity.ok(problems);
    }

    @PostMapping
    public ResponseEntity<Problem> createProblem(@RequestBody CreateProblemRequest request) {
        User currentUser = getCurrentUser();

        Problem problem = Problem.builder()
                .title(request.getTitle())
                .difficulty(request.getDifficulty())
                .topic(request.getTopic())
                .status(request.getStatus())
                .notes(request.getNotes())
                .user(currentUser)
                .build();

        Problem savedProblem = problemService.save(problem);
        return ResponseEntity.status(HttpStatus.CREATED).body(savedProblem);
    }

    @PutMapping("/{id}")
    public ResponseEntity<?> updateProblem(@PathVariable Long id, @RequestBody UpdateProblemRequest request) {
        User currentUser = getCurrentUser();

        Optional<Problem> problemOpt = problemService.findById(id);
        if (problemOpt.isEmpty()) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("Problem not found");
        }

        Problem problem = problemOpt.get();

        // Verify that the problem belongs to the current user
        if (!problem.getUser().getId().equals(currentUser.getId())) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body("You cannot update this problem");
        }

        // Update fields if provided
        if (request.getTitle() != null) {
            problem.setTitle(request.getTitle());
        }
        if (request.getDifficulty() != null) {
            problem.setDifficulty(request.getDifficulty());
        }
        if (request.getTopic() != null) {
            problem.setTopic(request.getTopic());
        }
        if (request.getStatus() != null) {
            problem.setStatus(request.getStatus());
            // If status is "Solved", set solvedAt to current time
            if ("Solved".equalsIgnoreCase(request.getStatus()) && problem.getSolvedAt() == null) {
                problem.setSolvedAt(LocalDateTime.now());
            }
        }
        if (request.getNotes() != null) {
            problem.setNotes(request.getNotes());
        }

        Problem updatedProblem = problemService.save(problem);
        return ResponseEntity.ok(updatedProblem);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<?> deleteProblem(@PathVariable Long id) {
        User currentUser = getCurrentUser();

        Optional<Problem> problemOpt = problemService.findById(id);
        if (problemOpt.isEmpty()) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("Problem not found");
        }

        Problem problem = problemOpt.get();

        // Verify that the problem belongs to the current user
        if (!problem.getUser().getId().equals(currentUser.getId())) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body("You cannot delete this problem");
        }

        problemService.deleteById(id);
        return ResponseEntity.noContent().build();
    }

    // Request DTOs
    public static class CreateProblemRequest {
        private String title;
        private String difficulty;
        private String topic;
        private String status;
        private String notes;

        public String getTitle() { return title; }
        public void setTitle(String title) { this.title = title; }

        public String getDifficulty() { return difficulty; }
        public void setDifficulty(String difficulty) { this.difficulty = difficulty; }

        public String getTopic() { return topic; }
        public void setTopic(String topic) { this.topic = topic; }

        public String getStatus() { return status; }
        public void setStatus(String status) { this.status = status; }

        public String getNotes() { return notes; }
        public void setNotes(String notes) { this.notes = notes; }
    }

    public static class UpdateProblemRequest {
        private String title;
        private String difficulty;
        private String topic;
        private String status;
        private String notes;

        public String getTitle() { return title; }
        public void setTitle(String title) { this.title = title; }

        public String getDifficulty() { return difficulty; }
        public void setDifficulty(String difficulty) { this.difficulty = difficulty; }

        public String getTopic() { return topic; }
        public void setTopic(String topic) { this.topic = topic; }

        public String getStatus() { return status; }
        public void setStatus(String status) { this.status = status; }

        public String getNotes() { return notes; }
        public void setNotes(String notes) { this.notes = notes; }
    }
}

