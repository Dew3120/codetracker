package com.codetracker.codetracker.dto.response;

import com.codetracker.codetracker.model.DailyGoal;
import lombok.AllArgsConstructor;
import lombok.Builder;
import com.fasterxml.jackson.annotation.JsonInclude;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class GoalResponse {

    private Long id;
    private java.time.LocalDate goalDate;
    private Integer targetMinutes;
    private Integer achievedMinutes;
    private Boolean isCompleted;
    private double progressPercentage;

    public static GoalResponse fromEntity(DailyGoal goal) {
        double percentage = 0d;
        if (goal.getTargetMinutes() != null && goal.getTargetMinutes() > 0) {
            percentage = (double) goal.getAchievedMinutes() / goal.getTargetMinutes() * 100d;
        }

        return GoalResponse.builder()
                .id(goal.getId())
                .goalDate(goal.getGoalDate())
                .targetMinutes(goal.getTargetMinutes())
                .achievedMinutes(goal.getAchievedMinutes())
                .isCompleted(goal.getIsCompleted())
                .progressPercentage(Math.min(100d, Math.max(0d, percentage)))
                .build();
    }
}

