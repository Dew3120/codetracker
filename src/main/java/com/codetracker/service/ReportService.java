package com.codetracker.service;

import com.codetracker.dto.response.LanguageDistributionResponse;
import com.codetracker.dto.response.MonthlyReportResponse;
import com.codetracker.dto.response.TopicBreakdownResponse;
import com.codetracker.dto.response.WeeklyReportResponse;
import com.codetracker.exception.ResourceNotFoundException;
import com.codetracker.entity.CodingSession;
import com.codetracker.entity.User;
import com.codetracker.repository.CodingSessionRepository;
import com.codetracker.repository.UserRepository;
import com.codetracker.util.DateUtils;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class ReportService {

    private final UserRepository userRepository;
    private final CodingSessionRepository codingSessionRepository;

    public WeeklyReportResponse getWeeklyReport(Long userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new ResourceNotFoundException("User not found"));

        LocalDate today = DateUtils.getTodayForUser(user.getTimezone());
        LocalDate startOfWeek = DateUtils.getStartOfWeek(today);
        LocalDate endOfWeek = DateUtils.getEndOfWeek(today);

        List<CodingSession> sessions = codingSessionRepository.findByUserIdAndDateRange(userId, startOfWeek, endOfWeek);
        int totalMinutes = sessions.stream().mapToInt(session -> session.getDurationMinutes() != null ? session.getDurationMinutes() : 0).sum();
        int totalSessions = sessions.size();

        Map<LocalDate, Integer> dailyTotals = sessions.stream()
                .collect(Collectors.groupingBy(CodingSession::getSessionDate,
                        Collectors.summingInt(session -> session.getDurationMinutes() != null ? session.getDurationMinutes() : 0)));

        List<WeeklyReportResponse.DailyStats> dailyBreakdown = new ArrayList<>();
        for (LocalDate date = startOfWeek; !date.isAfter(endOfWeek); date = date.plusDays(1)) {
            int minutes = dailyTotals.getOrDefault(date, 0);
            dailyBreakdown.add(WeeklyReportResponse.DailyStats.builder()
                    .date(date)
                    .day(DateUtils.getDayName(date))
                    .minutes(minutes)
                    .build());
        }

        double averageMinutesPerDay = dailyBreakdown.isEmpty() ? 0.0 : totalMinutes / 7.0;
        String topTopic = getTopTopic(sessions);
        String topLanguage = getTopLanguage(sessions);

        return WeeklyReportResponse.builder()
                .weekStart(startOfWeek)
                .weekEnd(endOfWeek)
                .totalMinutes(totalMinutes)
                .totalSessions(totalSessions)
                .dailyBreakdown(dailyBreakdown)
                .averageMinutesPerDay(averageMinutesPerDay)
                .topTopic(topTopic)
                .topLanguage(topLanguage)
                .build();
    }

    public MonthlyReportResponse getMonthlyReport(Long userId, int year, int month) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new ResourceNotFoundException("User not found"));

        LocalDate monthStart = LocalDate.of(year, month, 1);
        LocalDate monthEnd = monthStart.withDayOfMonth(monthStart.lengthOfMonth());

        List<CodingSession> sessions = codingSessionRepository.findByUserIdAndDateRange(userId, monthStart, monthEnd);
        int totalMinutes = sessions.stream().mapToInt(session -> session.getDurationMinutes() != null ? session.getDurationMinutes() : 0).sum();
        int totalSessions = sessions.size();

        Map<LocalDate, Integer> dailyTotals = sessions.stream()
                .collect(Collectors.groupingBy(CodingSession::getSessionDate,
                        Collectors.summingInt(session -> session.getDurationMinutes() != null ? session.getDurationMinutes() : 0)));

        List<MonthlyReportResponse.DailyStats> dailyBreakdown = new ArrayList<>();
        for (LocalDate date = monthStart; !date.isAfter(monthEnd); date = date.plusDays(1)) {
            dailyBreakdown.add(MonthlyReportResponse.DailyStats.builder()
                    .date(date)
                    .day(DateUtils.getDayName(date))
                    .minutes(dailyTotals.getOrDefault(date, 0))
                    .build());
        }

        double averageMinutesPerDay = monthEnd.getDayOfMonth() == 0 ? 0.0 : totalMinutes / (double) monthEnd.getDayOfMonth();

        return MonthlyReportResponse.builder()
                .month(month)
                .year(year)
                .totalMinutes(totalMinutes)
                .totalSessions(totalSessions)
                .dailyBreakdown(dailyBreakdown)
                .averageMinutesPerDay(averageMinutesPerDay)
                .build();
    }

    public LanguageDistributionResponse getLanguageDistribution(Long userId) {
        userRepository.findById(userId)
                .orElseThrow(() -> new ResourceNotFoundException("User not found"));

        List<Object[]> rawData = codingSessionRepository.findLanguageDistributionByUserId(userId);
        List<LanguageDistributionResponse.LanguageStats> stats = rawData.stream()
                .map(row -> LanguageDistributionResponse.LanguageStats.builder()
                        .language(row[0] != null ? row[0].toString() : "Unknown")
                        .color(row[1] != null ? row[1].toString() : null)
                        .minutes(row[2] != null ? ((Number) row[2]).intValue() : 0)
                        .build())
                .collect(Collectors.toList());

        return LanguageDistributionResponse.builder()
                .languageStats(stats)
                .build();
    }

    public TopicBreakdownResponse getTopicBreakdown(Long userId) {
        userRepository.findById(userId)
                .orElseThrow(() -> new ResourceNotFoundException("User not found"));

        List<Object[]> rawData = codingSessionRepository.findTopicBreakdownByUserId(userId);
        List<TopicBreakdownResponse.TopicStats> stats = rawData.stream()
                .map(row -> TopicBreakdownResponse.TopicStats.builder()
                        .topic(row[0] != null ? row[0].toString() : "Unknown")
                        .minutes(row[1] != null ? ((Number) row[1]).intValue() : 0)
                        .build())
                .collect(Collectors.toList());

        return TopicBreakdownResponse.builder()
                .topicStats(stats)
                .build();
    }

    private String getTopTopic(List<CodingSession> sessions) {
        return sessions.stream()
                .filter(session -> session.getTopic() != null)
                .collect(Collectors.groupingBy(session -> session.getTopic().getName(),
                        Collectors.summingInt(session -> session.getDurationMinutes() != null ? session.getDurationMinutes() : 0)))
                .entrySet()
                .stream()
                .max(Map.Entry.comparingByValue())
                .map(Map.Entry::getKey)
                .orElse(null);
    }

    private String getTopLanguage(List<CodingSession> sessions) {
        return sessions.stream()
                .filter(session -> session.getLanguage() != null)
                .collect(Collectors.groupingBy(session -> session.getLanguage().getName(),
                        Collectors.summingInt(session -> session.getDurationMinutes() != null ? session.getDurationMinutes() : 0)))
                .entrySet()
                .stream()
                .max(Map.Entry.comparingByValue())
                .map(Map.Entry::getKey)
                .orElse(null);
    }
}
