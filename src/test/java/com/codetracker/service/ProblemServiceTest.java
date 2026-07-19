package com.codetracker.service;

import com.codetracker.dto.response.ProblemResponse;
import com.codetracker.entity.ProblemSolved;
import com.codetracker.repository.ProblemSolvedRepository;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.time.LocalDate;
import java.util.List;
import java.util.Map;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class ProblemServiceTest {

    @Mock
    private ProblemSolvedRepository problemRepository;

    @InjectMocks
    private ProblemService problemService;

    @Test
    void getStats_CalculatesTotalsSuccessRateDifficultyAveragesAndPlatforms() {
        when(problemRepository.findAllByUserId(1L)).thenReturn(List.of(
                problem("LeetCode", "EASY", true, 20, LocalDate.now()),
                problem("LeetCode", "EASY", true, 40, LocalDate.now()),
                problem("HackerRank", "MEDIUM", false, null, LocalDate.now()),
                problem("Codeforces", "HARD", true, 90, LocalDate.now())
        ));

        Map<String, Object> stats = problemService.getStats(1L);

        assertEquals(4, stats.get("totalAttempted"));
        assertEquals(3, stats.get("totalSolved"));
        assertEquals(75.0, stats.get("successRate"));

        @SuppressWarnings("unchecked")
        Map<String, Object> byDifficulty = (Map<String, Object>) stats.get("byDifficulty");
        @SuppressWarnings("unchecked")
        Map<String, Object> easyStats = (Map<String, Object>) byDifficulty.get("EASY");
        @SuppressWarnings("unchecked")
        Map<String, Integer> byPlatform = (Map<String, Integer>) stats.get("byPlatform");

        assertEquals(2, easyStats.get("attempted"));
        assertEquals(2, easyStats.get("solved"));
        assertEquals(30.0, easyStats.get("avgMinutes"));
        assertEquals(2, byPlatform.get("LeetCode"));
    }

    @Test
    void getProblemsPaged_FiltersByDifficultySolvedAndDateRange() {
        LocalDate today = LocalDate.now();
        when(problemRepository.findAllByUserId(1L)).thenReturn(List.of(
                problem("LeetCode", "EASY", true, 20, today),
                problem("HackerRank", "MEDIUM", false, null, today.minusDays(1)),
                problem("Codeforces", "HARD", true, 90, today.minusDays(10))
        ));

        Map<String, Object> page = problemService.getProblemsPaged(
                1L, 0, 10, null, "EASY", true, today.minusDays(2), today);

        @SuppressWarnings("unchecked")
        List<ProblemResponse> content = (List<ProblemResponse>) page.get("content");

        assertEquals(1, page.get("totalElements"));
        assertEquals("EASY", content.get(0).getDifficulty());
        assertEquals("LeetCode", content.get(0).getPlatform());
    }

    private ProblemSolved problem(String platform, String difficulty, boolean solved, Integer minutes, LocalDate solvedDate) {
        return ProblemSolved.builder()
                .platform(platform)
                .problemName(platform + " Problem")
                .difficulty(difficulty)
                .isSolved(solved)
                .timeTakenMinutes(minutes)
                .solvedDate(solvedDate)
                .build();
    }
}