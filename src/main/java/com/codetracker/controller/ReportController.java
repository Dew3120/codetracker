package com.codetracker.controller;

import com.codetracker.dto.response.LanguageDistributionResponse;
import com.codetracker.dto.response.MonthlyReportResponse;
import com.codetracker.dto.response.TopicBreakdownResponse;
import com.codetracker.dto.response.WeeklyReportResponse;
import com.codetracker.model.User;
import com.codetracker.service.ReportService;
import com.codetracker.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.security.Principal;
import java.time.YearMonth;

@RestController
@RequestMapping("/api/reports")
@RequiredArgsConstructor
public class ReportController {

    private final ReportService reportService;
    private final UserService userService;

    @GetMapping("/weekly")
    public WeeklyReportResponse getWeeklyReport(Principal principal) {
        User user = userService.findByUsername(principal.getName())
                .orElseThrow(() -> new IllegalStateException("User not found"));
        return reportService.getWeeklyReport(user.getId());
    }

    @GetMapping("/monthly")
    public MonthlyReportResponse getMonthlyReport(Principal principal,
                                                  @RequestParam String month) {
        User user = userService.findByUsername(principal.getName())
                .orElseThrow(() -> new IllegalStateException("User not found"));
        YearMonth ym = YearMonth.parse(month);
        return reportService.getMonthlyReport(user.getId(), ym.getYear(), ym.getMonthValue());
    }

    @GetMapping("/languages")
    public LanguageDistributionResponse getLanguageDistribution(Principal principal) {
        User user = userService.findByUsername(principal.getName())
                .orElseThrow(() -> new IllegalStateException("User not found"));
        return reportService.getLanguageDistribution(user.getId());
    }

    @GetMapping("/topics")
    public TopicBreakdownResponse getTopicBreakdown(Principal principal) {
        User user = userService.findByUsername(principal.getName())
                .orElseThrow(() -> new IllegalStateException("User not found"));
        return reportService.getTopicBreakdown(user.getId());
    }
}
