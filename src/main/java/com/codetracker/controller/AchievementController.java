package com.codetracker.controller;

import com.codetracker.dto.response.AchievementResponse;
import com.codetracker.entity.User;
import com.codetracker.service.AchievementService;
import com.codetracker.service.UserService;
import java.security.Principal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.server.ResponseStatusException;

@RestController
@RequestMapping("/api/achievements")
public class AchievementController {

    private final AchievementService achievementService;
    private final UserService userService;

    public AchievementController(AchievementService achievementService, UserService userService) {
        this.achievementService = achievementService;
        this.userService = userService;
    }

    @GetMapping
    public ResponseEntity<Map<String, Object>> getAllAchievements(Principal principal) {
        Long userId = getCurrentUserId(principal);
        List<Map<String, Object>> achievements = achievementService.getAchievementsWithStatus(userId).stream()
                .map(this::toApiItem)
                .collect(Collectors.toList());

        Map<String, Object> response = new HashMap<>();
        response.put("achievements", achievements);
        return ResponseEntity.ok(response);
    }

    private Map<String, Object> toApiItem(AchievementResponse achievement) {
        Map<String, Object> item = new HashMap<>();
        item.put("id", achievement.getId());
        item.put("name", achievement.getName());
        item.put("description", achievement.getDescription());
        item.put("icon", achievement.getIcon());
        item.put("earned", achievement.isEarned());
        item.put("earnedAt", achievement.getEarnedAt());
        return item;
    }

    private Long getCurrentUserId(Principal principal) {
        if (principal == null) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "User not authenticated");
        }
        return userService.findByUsername(principal.getName())
                .map(User::getId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.UNAUTHORIZED, "User not found"));
    }
}
