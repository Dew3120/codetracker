package com.codetracker.codetracker.service;

import com.codetracker.codetracker.dto.response.AchievementResponse;
import com.codetracker.codetracker.exception.ResourceNotFoundException;
import com.codetracker.codetracker.model.Achievement;
import com.codetracker.codetracker.model.CodingSession;
import com.codetracker.codetracker.model.User;
import com.codetracker.codetracker.repository.AchievementRepository;
import com.codetracker.codetracker.repository.CodingSessionRepository;
import com.codetracker.codetracker.repository.ProblemRepository;
import com.codetracker.codetracker.repository.UserAchievementRepository;
import com.codetracker.codetracker.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Objects;
import java.util.Set;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Transactional
public class AchievementService {

    private final UserRepository userRepository;
    private final AchievementRepository achievementRepository;
    private final UserAchievementRepository userAchievementRepository;
    private final CodingSessionRepository codingSessionRepository;
    private final ProblemRepository problemRepository;

    public void checkAndAwardAchievements(Long userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new ResourceNotFoundException("User not found"));

        List<CodingSession> allSessions = codingSessionRepository.findByUserIdWithDetails(userId);
        int sessionCount = allSessions.size();
        int totalMinutes = allSessions.stream()
                .filter(Objects::nonNull)
                .mapToInt(session -> session.getDurationMinutes() != null ? session.getDurationMinutes() : 0)
                .sum();

        int solvedProblems = (int) problemRepository.findAllByUserId(userId).stream()
                .filter(problem -> Boolean.TRUE.equals(problem.getIsSolved()))
                .count();

        Set<Long> earnedIds = userAchievementRepository.findEarnedAchievementIdsByUserId(userId).stream().collect(Collectors.toSet());
        List<Achievement> achievements = achievementRepository.findAll();
        for (Achievement achievement : achievements) {
            if (earnedIds.contains(achievement.getId())) {
                continue;
            }
            if (meetsCriteria(achievement, sessionCount, solvedProblems, totalMinutes)) {
                userAchievementRepository.save(
                        com.codetracker.codetracker.model.UserAchievement.builder()
                                .user(user)
                                .achievement(achievement)
                                .build());
            }
        }
    }

    public List<AchievementResponse> getAchievementsWithStatus(Long userId) {
        userRepository.findById(userId)
                .orElseThrow(() -> new ResourceNotFoundException("User not found"));

        List<Long> earnedIds = userAchievementRepository.findEarnedAchievementIdsByUserId(userId);
        List<com.codetracker.codetracker.model.UserAchievement> earnedAchievements = userAchievementRepository.findByUserIdWithAchievement(userId);

        return achievementRepository.findAll().stream()
                .map(achievement -> {
                    boolean earned = earnedIds.contains(achievement.getId());
                    return AchievementResponse.builder()
                            .id(achievement.getId())
                            .name(achievement.getName())
                            .description(achievement.getDescription())
                            .icon(achievement.getIcon())
                            .criteriaType(achievement.getCriteriaType())
                            .criteriaValue(achievement.getCriteriaValue())
                            .earned(earned)
                            .earnedAt(earnedAchievements.stream()
                                    .filter(ua -> ua.getAchievement().getId().equals(achievement.getId()))
                                    .findFirst()
                                    .map(com.codetracker.codetracker.model.UserAchievement::getEarnedAt)
                                    .orElse(null))
                            .build();
                })
                .collect(Collectors.toList());
    }

    private boolean meetsCriteria(Achievement achievement, int sessionCount, int solvedProblems, int totalMinutes) {
        if (achievement.getCriteriaType() == null || achievement.getCriteriaValue() == null) {
            return false;
        }

        switch (achievement.getCriteriaType()) {
            case "session_count":
                return sessionCount >= achievement.getCriteriaValue();
            case "solved_problems":
                return solvedProblems >= achievement.getCriteriaValue();
            case "total_minutes":
                return totalMinutes >= achievement.getCriteriaValue();
            default:
                return false;
        }
    }
}
