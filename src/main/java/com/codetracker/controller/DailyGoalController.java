package com.codetracker.controller;

import com.codetracker.dto.request.GoalRequest;
import com.codetracker.dto.response.GoalResponse;
import com.codetracker.dto.response.StreakResponse;
import com.codetracker.model.User;
import com.codetracker.service.DailyGoalService;
import com.codetracker.service.UserService;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;

@RestController
@RequestMapping("/api/goals")
public class DailyGoalController {

    private final DailyGoalService dailyGoalService;
    private final UserService userService;

    public DailyGoalController(DailyGoalService dailyGoalService, UserService userService) {
        this.dailyGoalService = dailyGoalService;
        this.userService = userService;
    }

    @PostMapping
    public ResponseEntity<GoalResponse> setGoal(@Valid @RequestBody GoalRequest request) {
        Long userId = getCurrentUserId();
        return ResponseEntity.status(HttpStatus.CREATED).body(dailyGoalService.setGoal(userId, request));
    }

    @GetMapping("/today")
    public ResponseEntity<GoalResponse> getTodayGoal() {
        Long userId = getCurrentUserId();
        return dailyGoalService.getTodayGoal(userId)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.noContent().build());
    }

    @GetMapping("/streak")
    public ResponseEntity<StreakResponse> calculateStreak() {
        Long userId = getCurrentUserId();
        return ResponseEntity.ok(dailyGoalService.calculateStreak(userId));
    }

    @GetMapping("/history")
    public ResponseEntity<List<GoalResponse>> getGoalHistory() {
        Long userId = getCurrentUserId();
        return ResponseEntity.ok(dailyGoalService.getGoalHistory(userId));
    }

    private Long getCurrentUserId() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication == null || authentication.getName() == null) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "User not authenticated");
        }

        return userService.findByUsername(authentication.getName())
                .map(User::getId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.UNAUTHORIZED, "User not found"));
    }
}
