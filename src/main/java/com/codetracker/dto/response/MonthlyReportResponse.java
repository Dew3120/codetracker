package com.codetracker.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
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
public class MonthlyReportResponse {

    private int month;
    private int year;
    private int totalMinutes;
    private int totalSessions;
    private List<DailyStats> dailyBreakdown;
    private double averageMinutesPerDay;

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
