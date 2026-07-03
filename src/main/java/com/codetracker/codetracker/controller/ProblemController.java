package com.codetracker.codetracker.controller;

import com.codetracker.codetracker.dto.request.ProblemRequest;
import com.codetracker.codetracker.model.Problem;
import com.codetracker.codetracker.model.User;
import com.codetracker.codetracker.service.AchievementService;
import com.codetracker.codetracker.service.ProblemService;
import com.codetracker.codetracker.service.UserService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.server.ResponseStatusException;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.Map;
import java.util.Optional;

@RestController
@RequestMapping("/api/problems")
public class ProblemController {

    private final ProblemService problemService;
    private final UserService userService;
    private final AchievementService achievementService;

    public ProblemController(ProblemService problemService, UserService userService,
                            AchievementService achievementService) {
        this.problemService = problemService;
        this.userService = userService;
        this.achievementService = achievementService;
    }

    @GetMapping
    public ResponseEntity<Map<String, Object>> getAllProblems(
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "20") int size,
            @RequestParam(required = false) String platform,
            @RequestParam(required = false) String difficulty,
            @RequestParam(required = false) Boolean isSolved) {
        User user = getCurrentUser();
        return ResponseEntity.ok(problemService.getProblemsPaged(user.getId(), page, size, platform, difficulty, isSolved));
    }

    @PostMapping
    public ResponseEntity<Problem> createProblem(@RequestBody ProblemRequest request) {
        User user = getCurrentUser();
        boolean solved = Boolean.TRUE.equals(request.getIsSolved());
        LocalDate solvedDate = request.getSolvedDate();
        if (solved && solvedDate == null) {
            solvedDate = LocalDate.now();
        }
        Problem problem = Problem.builder()
                .platform(request.getPlatform())
                .problemName(request.getProblemName())
                .problemUrl(request.getProblemUrl())
                .difficulty(request.getDifficulty() == null ? null : request.getDifficulty().toUpperCase())
                .isSolved(solved)
                .timeTakenMinutes(request.getTimeTakenMinutes())
                .notes(request.getNotes())
                .solvedDate(solvedDate)
                .createdAt(LocalDateTime.now())
                .user(user)
                .build();
        Problem saved = problemService.save(problem);
        achievementService.checkAndAwardAchievements(user.getId());
        return ResponseEntity.status(HttpStatus.CREATED).body(saved);
    }

    @PutMapping("/{id}")
    public ResponseEntity<?> updateProblem(@PathVariable Long id, @RequestBody ProblemRequest request) {
        User user = getCurrentUser();
        Optional<Problem> problemOpt = problemService.findById(id);
        if (problemOpt.isEmpty()) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("Problem not found");
        }
        Problem problem = problemOpt.get();
        if (!problem.getUser().getId().equals(user.getId())) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body("You cannot update this problem");
        }
        if (request.getPlatform() != null) problem.setPlatform(request.getPlatform());
        if (request.getProblemName() != null) problem.setProblemName(request.getProblemName());
        if (request.getProblemUrl() != null) problem.setProblemUrl(request.getProblemUrl());
        if (request.getDifficulty() != null) problem.setDifficulty(request.getDifficulty().toUpperCase());
        if (request.getTimeTakenMinutes() != null) problem.setTimeTakenMinutes(request.getTimeTakenMinutes());
        if (request.getNotes() != null) problem.setNotes(request.getNotes());
        if (request.getSolvedDate() != null) problem.setSolvedDate(request.getSolvedDate());
        if (request.getIsSolved() != null) {
            problem.setIsSolved(request.getIsSolved());
            if (Boolean.TRUE.equals(request.getIsSolved()) && problem.getSolvedDate() == null) {
                problem.setSolvedDate(LocalDate.now());
            }
        }
        Problem updated = problemService.save(problem);
        achievementService.checkAndAwardAchievements(user.getId());
        return ResponseEntity.ok(updated);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<?> deleteProblem(@PathVariable Long id) {
        User user = getCurrentUser();
        Optional<Problem> problemOpt = problemService.findById(id);
        if (problemOpt.isEmpty()) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("Problem not found");
        }
        Problem problem = problemOpt.get();
        if (!problem.getUser().getId().equals(user.getId())) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).body("You cannot delete this problem");
        }
        problemService.deleteById(id);
        return ResponseEntity.noContent().build();
    }

    @GetMapping("/stats")
    public ResponseEntity<Map<String, Object>> getStats() {
        User user = getCurrentUser();
        return ResponseEntity.ok(problemService.getStats(user.getId()));
    }

    private User getCurrentUser() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication == null || authentication.getName() == null) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "User not authenticated");
        }
        return userService.findByUsername(authentication.getName())
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.UNAUTHORIZED, "User not found"));
    }
}
