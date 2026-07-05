package com.codetracker.service;

import com.codetracker.dto.request.GoalRequest;
import com.codetracker.dto.response.GoalResponse;
import com.codetracker.dto.response.StreakResponse;
import com.codetracker.entity.DailyGoal;
import com.codetracker.entity.User;
import com.codetracker.repository.DailyGoalRepository;
import com.codetracker.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.Comparator;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Transactional
public class DailyGoalService {

    private final DailyGoalRepository dailyGoalRepository;
    private final UserRepository userRepository;

    public GoalResponse setGoal(Long userId, GoalRequest request) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "User not found"));

        if (dailyGoalRepository.findByUserIdAndGoalDate(userId, request.getGoalDate()).isPresent()) {
            throw new ResponseStatusException(HttpStatus.CONFLICT, "Goal already exists for this date");
        }

        DailyGoal goal = DailyGoal.builder()
                .user(user)
                .goalDate(request.getGoalDate())
                .targetMinutes(request.getTargetMinutes())
                .achievedMinutes(0)
                .isCompleted(false)
                .createdAt(LocalDateTime.now())
                .build();

        return GoalResponse.fromEntity(dailyGoalRepository.save(goal));
    }

    public void updateGoalProgress(Long userId, LocalDate date, int minutesAdded) {
        if (minutesAdded <= 0) {
            return;
        }

        dailyGoalRepository.findByUserIdAndGoalDate(userId, date).ifPresent(goal -> {
            int updatedMinutes = goal.getAchievedMinutes() + minutesAdded;
            goal.setAchievedMinutes(updatedMinutes);
            if (goal.getTargetMinutes() != null && updatedMinutes >= goal.getTargetMinutes()) {
                goal.setIsCompleted(true);
            }
            dailyGoalRepository.save(goal);
        });
    }

    public java.util.Optional<GoalResponse> getTodayGoal(Long userId) {
        LocalDate today = LocalDate.now(ZoneId.systemDefault());
        return dailyGoalRepository.findByUserIdAndGoalDate(userId, today)
                .map(GoalResponse::fromEntity);
    }

    public StreakResponse calculateStreak(Long userId) {
        List<DailyGoal> completedGoals = dailyGoalRepository.findByUserIdAndIsCompletedTrueOrderByGoalDateDesc(userId);
        Set<LocalDate> completedDates = completedGoals.stream()
                .map(DailyGoal::getGoalDate)
                .collect(Collectors.toSet());

        LocalDate today = LocalDate.now(ZoneId.systemDefault());
        int currentStreak = 0;
        LocalDate cursor = today;
        while (completedDates.contains(cursor)) {
            currentStreak++;
            cursor = cursor.minusDays(1);
        }

        int longestStreak = 0;
        int running = 0;
        LocalDate previous = null;

        List<LocalDate> sortedDates = completedGoals.stream()
                .map(DailyGoal::getGoalDate)
                .sorted()
                .collect(Collectors.toList());

        for (LocalDate date : sortedDates) {
            if (previous != null && date.equals(previous.plusDays(1))) {
                running++;
            } else {
                running = 1;
            }
            longestStreak = Math.max(longestStreak, running);
            previous = date;
        }

        return StreakResponse.builder()
                .currentStreak(currentStreak)
                .longestStreak(longestStreak)
                .totalDaysActive(completedDates.size())
                .build();
    }

    public List<GoalResponse> getGoalHistory(Long userId) {
        return dailyGoalRepository.findByUserId(userId).stream()
                .sorted(Comparator.comparing(DailyGoal::getGoalDate).reversed())
                .map(GoalResponse::fromEntity)
                .collect(Collectors.toList());
    }
}
