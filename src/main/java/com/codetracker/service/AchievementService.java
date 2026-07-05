package com.codetracker.service;

import com.codetracker.dto.response.AchievementResponse;
import com.codetracker.exception.ResourceNotFoundException;
import com.codetracker.model.Achievement;
import com.codetracker.model.CodingSession;
import com.codetracker.model.User;
import com.codetracker.repository.AchievementRepository;
import com.codetracker.repository.CodingSessionRepository;
import com.codetracker.repository.ProblemRepository;
import com.codetracker.repository.UserAchievementRepository;
import com.codetracker.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.HashSet;
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

        int currentStreak = calculateCurrentStreak(userId);

        Set<Long> earnedIds = new HashSet<>(userAchievementRepository.findEarnedAchievementIdsByUserId(userId));
        for (Achievement achievement : achievementRepository.findAll()) {
            if (earnedIds.contains(achievement.getId())) {
                continue;
            }
            if (meetsCriteria(achievement, sessionCount, solvedProblems, totalMinutes, currentStreak)) {
                userAchievementRepository.save(
                        com.codetracker.model.UserAchievement.builder()
                                .user(user)
                                .achievement(achievement)
                                .build());
            }
        }
    }

    private int calculateCurrentStreak(Long userId) {
        Set<LocalDate> dates = new HashSet<>(codingSessionRepository.findDistinctSessionDatesByUserId(userId));
        int streak = 0;
        LocalDate cursor = LocalDate.now();
        while (dates.contains(cursor)) {
            streak++;
            cursor = cursor.minusDays(1);
        }
        return streak;
    }

    @org.springframework.transaction.annotation.Transactional(readOnly = true)
    public List<AchievementResponse> getAchievementsWithStatus(Long userId) {
        userRepository.findById(userId)
                .orElseThrow(() -> new ResourceNotFoundException("User not found"));

        List<Long> earnedIds = userAchievementRepository.findEarnedAchievementIdsByUserId(userId);
        List<com.codetracker.model.UserAchievement> earnedAchievements = userAchievementRepository.findByUserIdWithAchievement(userId);

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
                                    .map(com.codetracker.model.UserAchievement::getEarnedAt)
                                    .orElse(null))
                            .build();
                })
                .collect(Collectors.toList());
    }

    private boolean meetsCriteria(Achievement achievement, int sessionCount, int solvedProblems,
                                  int totalMinutes, int currentStreak) {
        if (achievement.getCriteriaType() == null || achievement.getCriteriaValue() == null) {
            return false;
        }
        int value = achievement.getCriteriaValue();
        switch (achievement.getCriteriaType()) {
            case "TOTAL_SESSIONS":
                return sessionCount >= value;
            case "PROBLEMS_SOLVED":
                return solvedProblems >= value;
            case "TOTAL_HOURS":
                return totalMinutes >= value * 60;
            case "STREAK_DAYS":
                return currentStreak >= value;
            default:
                return false;
        }
    }
}
