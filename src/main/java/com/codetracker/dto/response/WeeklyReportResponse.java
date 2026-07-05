package com.codetracker.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import com.fasterxml.jackson.annotation.JsonInclude;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDate;
import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class WeeklyReportResponse {

    private LocalDate weekStart;
    private LocalDate weekEnd;
    private int totalMinutes;
    private int totalSessions;
    private List<DailyStats> dailyBreakdown;
    private double averageMinutesPerDay;
    private String topTopic;
    private String topLanguage;

    @Getter
    @Setter
    @NoArgsConstructor
    @AllArgsConstructor
    @Builder
    public static class DailyStats {
        private LocalDate date;
        private String day;
        private int minutes;
    }
}

