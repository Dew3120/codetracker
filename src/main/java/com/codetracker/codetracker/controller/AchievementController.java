package com.codetracker.codetracker.controller;

import com.codetracker.codetracker.dto.response.AchievementResponse;
import com.codetracker.codetracker.model.User;
import com.codetracker.codetracker.service.AchievementService;
import com.codetracker.codetracker.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.security.Principal;
import java.util.List;

@RestController
@RequestMapping("/api/achievements")
@RequiredArgsConstructor
public class AchievementController {

    private final AchievementService achievementService;
    private final UserService userService;

    @GetMapping
    public List<AchievementResponse> getAchievementsWithStatus(Principal principal) {
        User user = userService.findByUsername(principal.getName())
                .orElseThrow(() -> new IllegalStateException("User not found"));
        return achievementService.getAchievementsWithStatus(user.getId());
    }

    @PostMapping("/check")
    public ResponseEntity<Void> checkAchievements(Principal principal) {
        User user = userService.findByUsername(principal.getName())
                .orElseThrow(() -> new IllegalStateException("User not found"));
        achievementService.checkAndAwardAchievements(user.getId());
        return ResponseEntity.ok().build();
    }
}
