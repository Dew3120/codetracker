package com.codetracker.codetracker.controller;

import com.codetracker.codetracker.model.Achievement;
import com.codetracker.codetracker.model.User;
import com.codetracker.codetracker.model.UserAchievement;
import com.codetracker.codetracker.repository.AchievementRepository;
import com.codetracker.codetracker.repository.UserAchievementRepository;
import com.codetracker.codetracker.service.UserService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.server.ResponseStatusException;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/achievements")
public class AchievementController {

    private final AchievementRepository achievementRepository;
    private final UserAchievementRepository userAchievementRepository;
    private final UserService userService;

    public AchievementController(AchievementRepository achievementRepository,
                                 UserAchievementRepository userAchievementRepository,
                                 UserService userService) {
        this.achievementRepository = achievementRepository;
        this.userAchievementRepository = userAchievementRepository;
        this.userService = userService;
    }

    @GetMapping
    public ResponseEntity<Map<String, Object>> getAllAchievements() {
        Long userId = getCurrentUserId();

        Map<Long, LocalDateTime> earnedMap = new HashMap<>();
        for (UserAchievement ua : userAchievementRepository.findByUserIdWithAchievement(userId)) {
            earnedMap.put(ua.getAchievement().getId(), ua.getEarnedAt());
        }

        List<Map<String, Object>> achievements = new ArrayList<>();
        for (Achievement a : achievementRepository.findAll()) {
            Map<String, Object> item = new HashMap<>();
            item.put("id", a.getId());
            item.put("name", a.getName());
            item.put("description", a.getDescription());
            item.put("icon", a.getIcon());
            boolean earned = earnedMap.containsKey(a.getId());
            item.put("earned", earned);
            item.put("earnedAt", earned ? earnedMap.get(a.getId()) : null);
            achievements.add(item);
        }

        Map<String, Object> response = new HashMap<>();
        response.put("achievements", achievements);
        return ResponseEntity.ok(response);
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
