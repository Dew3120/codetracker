package com.codetracker.service;

import com.codetracker.dto.request.GoalRequest;
import com.codetracker.dto.response.GoalResponse;
import com.codetracker.dto.response.StreakResponse;
import com.codetracker.entity.DailyGoal;
import com.codetracker.entity.User;
import com.codetracker.repository.DailyGoalRepository;
import com.codetracker.repository.UserRepository;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.http.HttpStatus;
import org.springframework.web.server.ResponseStatusException;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class DailyGoalServiceTest {

    @Mock
    private DailyGoalRepository dailyGoalRepository;

    @Mock
    private UserRepository userRepository;

    @InjectMocks
    private DailyGoalService dailyGoalService;

    @Test
    void setGoal_WithNewDate_CreatesGoalWithZeroProgress() {
        LocalDate today = LocalDate.now();
        User user = User.builder().id(1L).username("dev_student").build();
        GoalRequest request = GoalRequest.builder()
                .goalDate(today)
                .targetMinutes(120)
                .build();

        when(userRepository.findById(1L)).thenReturn(Optional.of(user));
        when(dailyGoalRepository.findByUserIdAndGoalDate(1L, today)).thenReturn(Optional.empty());
        when(dailyGoalRepository.save(any(DailyGoal.class))).thenAnswer(invocation -> {
            DailyGoal goal = invocation.getArgument(0);
            goal.setId(5L);
            return goal;
        });

        GoalResponse response = dailyGoalService.setGoal(1L, request);

        assertEquals(5L, response.getId());
        assertEquals(120, response.getTargetMinutes());
        assertEquals(0, response.getAchievedMinutes());
        assertFalse(response.getIsCompleted());
        assertEquals(0.0, response.getProgressPercentage());
    }

    @Test
    void setGoal_WithExistingDate_ThrowsConflict() {
        LocalDate today = LocalDate.now();
        GoalRequest request = GoalRequest.builder()
                .goalDate(today)
                .targetMinutes(120)
                .build();

        when(userRepository.findById(1L)).thenReturn(Optional.of(User.builder().id(1L).build()));
        when(dailyGoalRepository.findByUserIdAndGoalDate(1L, today))
                .thenReturn(Optional.of(DailyGoal.builder().id(10L).build()));

        ResponseStatusException exception = assertThrows(
                ResponseStatusException.class,
                () -> dailyGoalService.setGoal(1L, request)
        );

        assertEquals(HttpStatus.CONFLICT, exception.getStatusCode());
    }

    @Test
    void updateGoalProgress_WhenTargetReached_MarksGoalCompleted() {
        LocalDate today = LocalDate.now();
        DailyGoal goal = DailyGoal.builder()
                .id(10L)
                .goalDate(today)
                .targetMinutes(120)
                .achievedMinutes(90)
                .isCompleted(false)
                .build();

        when(dailyGoalRepository.findByUserIdAndGoalDate(1L, today)).thenReturn(Optional.of(goal));

        dailyGoalService.updateGoalProgress(1L, today, 45);

        assertEquals(135, goal.getAchievedMinutes());
        assertTrue(goal.getIsCompleted());
        verify(dailyGoalRepository).save(goal);
    }

    @Test
    void calculateStreak_ReturnsCurrentLongestAndTotalActiveDays() {
        LocalDate today = LocalDate.now();
        List<DailyGoal> completedGoals = List.of(
                completedGoal(today),
                completedGoal(today.minusDays(1)),
                completedGoal(today.minusDays(2)),
                completedGoal(today.minusDays(5)),
                completedGoal(today.minusDays(6))
        );

        when(dailyGoalRepository.findByUserIdAndIsCompletedTrueOrderByGoalDateDesc(1L))
                .thenReturn(completedGoals);

        StreakResponse response = dailyGoalService.calculateStreak(1L);

        assertEquals(3, response.getCurrentStreak());
        assertEquals(3, response.getLongestStreak());
        assertEquals(5, response.getTotalDaysActive());
    }

    private DailyGoal completedGoal(LocalDate date) {
        return DailyGoal.builder()
                .goalDate(date)
                .targetMinutes(120)
                .achievedMinutes(120)
                .isCompleted(true)
                .build();
    }
}