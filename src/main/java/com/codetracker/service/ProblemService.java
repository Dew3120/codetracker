package com.codetracker.service;

import com.codetracker.dto.response.ProblemResponse;
import com.codetracker.entity.ProblemSolved;
import com.codetracker.repository.ProblemSolvedRepository;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class ProblemService {

    private final ProblemSolvedRepository problemRepository;

    public ProblemService(ProblemSolvedRepository problemRepository) {
        this.problemRepository = problemRepository;
    }

    public List<ProblemSolved> getAllProblemsByUserId(Long userId) {
        return problemRepository.findAllByUserId(userId);
    }

    public ProblemSolved save(ProblemSolved problem) {
        return problemRepository.save(problem);
    }

    public void deleteById(Long id) {
        problemRepository.deleteById(id);
    }

    public Optional<ProblemSolved> findById(Long id) {
        return problemRepository.findById(id);
    }

    public Map<String, Object> getProblemsPaged(Long userId, int page, int size,
                                                String platform, String difficulty, Boolean isSolved,
                                                LocalDate startDate, LocalDate endDate) {
        List<ProblemSolved> filtered = problemRepository.findAllByUserId(userId).stream()
                .filter(p -> platform == null || platform.equalsIgnoreCase(p.getPlatform()))
                .filter(p -> difficulty == null || (p.getDifficulty() != null && difficulty.equalsIgnoreCase(p.getDifficulty())))
                .filter(p -> isSolved == null || isSolved.equals(p.getIsSolved()))
                .filter(p -> startDate == null || !p.getSolvedDate().isBefore(startDate))
                .filter(p -> endDate == null || !p.getSolvedDate().isAfter(endDate))
                .collect(Collectors.toList());

        int total = filtered.size();
        int safeSize = size <= 0 ? 20 : Math.min(size, 100);
        int safePage = Math.max(page, 0);
        int totalPages = (int) Math.ceil((double) total / safeSize);
        int from = Math.min(safePage * safeSize, total);
        int to = Math.min(from + safeSize, total);
        List<ProblemResponse> content = filtered.subList(from, to).stream()
                .map(ProblemResponse::fromEntity)
                .collect(Collectors.toList());

        Map<String, Object> response = new HashMap<>();
        response.put("content", content);
        response.put("totalElements", total);
        response.put("totalPages", totalPages);
        response.put("currentPage", safePage);
        response.put("size", safeSize);
        return response;
    }

    public Map<String, Object> getStats(Long userId) {
        List<ProblemSolved> problems = problemRepository.findAllByUserId(userId);
        int totalAttempted = problems.size();
        int totalSolved = 0;
        Map<String, DifficultyStats> byDifficulty = new HashMap<>();
        byDifficulty.put("EASY", new DifficultyStats());
        byDifficulty.put("MEDIUM", new DifficultyStats());
        byDifficulty.put("HARD", new DifficultyStats());
        Map<String, Integer> byPlatform = new HashMap<>();

        for (ProblemSolved p : problems) {
            boolean solved = Boolean.TRUE.equals(p.getIsSolved());
            if (solved) totalSolved++;
            String diff = p.getDifficulty() == null ? "MEDIUM" : p.getDifficulty().toUpperCase();
            DifficultyStats stats = byDifficulty.computeIfAbsent(diff, k -> new DifficultyStats());
            stats.attempted++;
            if (solved) {
                stats.solved++;
                if (p.getTimeTakenMinutes() != null) {
                    stats.totalSolvedMinutes += p.getTimeTakenMinutes();
                    stats.solvedWithTime++;
                }
            }

            String plat = p.getPlatform() == null ? "Unknown" : p.getPlatform();
            byPlatform.put(plat, byPlatform.getOrDefault(plat, 0) + 1);
        }

        double successRate = totalAttempted == 0 ? 0.0 : Math.round(totalSolved * 10000.0 / totalAttempted) / 100.0;

        Map<String, Object> response = new HashMap<>();
        response.put("totalAttempted", totalAttempted);
        response.put("totalSolved", totalSolved);
        response.put("successRate", successRate);
        response.put("byDifficulty", toDifficultyOutput(byDifficulty));
        response.put("byPlatform", byPlatform);
        return response;
    }

    private Map<String, Object> toDifficultyOutput(Map<String, DifficultyStats> in) {
        Map<String, Object> out = new HashMap<>();
        for (Map.Entry<String, DifficultyStats> e : in.entrySet()) {
            DifficultyStats stats = e.getValue();
            Map<String, Object> m = new HashMap<>();
            m.put("attempted", stats.attempted);
            m.put("solved", stats.solved);
            m.put("avgMinutes", stats.averageSolvedMinutes());
            out.put(e.getKey(), m);
        }
        return out;
    }

    private static class DifficultyStats {
        private int attempted;
        private int solved;
        private int totalSolvedMinutes;
        private int solvedWithTime;

        private double averageSolvedMinutes() {
            if (solvedWithTime == 0) {
                return 0.0;
            }
            return Math.round(totalSolvedMinutes * 10.0 / solvedWithTime) / 10.0;
        }
    }
}
