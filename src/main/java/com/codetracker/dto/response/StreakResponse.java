package com.codetracker.dto.response;

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
public class StreakResponse {

    private int currentStreak;
    private int longestStreak;
    private int totalDaysActive;
}

