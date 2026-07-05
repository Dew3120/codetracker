package com.codetracker.service;

import com.codetracker.model.Problem;
import com.codetracker.repository.ProblemRepository;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class ProblemService {

    private final ProblemRepository problemRepository;

    public ProblemService(ProblemRepository problemRepository) {
        this.problemRepository = problemRepository;
    }

    public List<Problem> getAllProblemsByUserId(Long userId) {
        return problemRepository.findAllByUserId(userId);
    }

    public Problem save(Problem problem) {
        return problemRepository.save(problem);
    }

    public void deleteById(Long id) {
        problemRepository.deleteById(id);
    }

    public Optional<Problem> findById(Long id) {
        return problemRepository.findById(id);
    }

    public Map<String, Object> getProblemsPaged(Long userId, int page, int size,
                                                String platform, String difficulty, Boolean isSolved) {
        List<Problem> filtered = problemRepository.findAllByUserId(userId).stream()
                .filter(p -> platform == null || platform.equalsIgnoreCase(p.getPlatform()))
                .filter(p -> difficulty == null || (p.getDifficulty() != null && difficulty.equalsIgnoreCase(p.getDifficulty())))
                .filter(p -> isSolved == null || isSolved.equals(p.getIsSolved()))
                .collect(Collectors.toList());

        int total = filtered.size();
        int safeSize = size <= 0 ? 20 : Math.min(size, 100);
        int safePage = Math.max(page, 0);
        int totalPages = (int) Math.ceil((double) total / safeSize);
        int from = Math.min(safePage * safeSize, total);
        int to = Math.min(from + safeSize, total);
        List<Problem> content = filtered.subList(from, to);

        Map<String, Object> response = new HashMap<>();
        response.put("content", content);
        response.put("totalElements", total);
        response.put("totalPages", totalPages);
        response.put("currentPage", safePage);
        response.put("size", safeSize);
        return response;
    }

    public Map<String, Object> getStats(Long userId) {
        List<Problem> problems = problemRepository.findAllByUserId(userId);
        int totalAttempted = problems.size();
        int totalSolved = 0;
        int totalMinutes = 0;
        int withTime = 0;

        Map<String, int[]> byDifficulty = new HashMap<>();
        byDifficulty.put("EASY", new int[2]);
        byDifficulty.put("MEDIUM", new int[2]);
        byDifficulty.put("HARD", new int[2]);
        Map<String, int[]> byPlatform = new HashMap<>();

        for (Problem p : problems) {
            boolean solved = Boolean.TRUE.equals(p.getIsSolved());
            if (solved) totalSolved++;
            if (p.getTimeTakenMinutes() != null) { totalMinutes += p.getTimeTakenMinutes(); withTime++; }

            String diff = p.getDifficulty() == null ? "MEDIUM" : p.getDifficulty().toUpperCase();
            byDifficulty.computeIfAbsent(diff, k -> new int[2]);
            byDifficulty.get(diff)[0]++;
            if (solved) byDifficulty.get(diff)[1]++;

            String plat = p.getPlatform() == null ? "Unknown" : p.getPlatform();
            byPlatform.computeIfAbsent(plat, k -> new int[2]);
            byPlatform.get(plat)[0]++;
            if (solved) byPlatform.get(plat)[1]++;
        }

        double successRate = totalAttempted == 0 ? 0.0 : Math.round(totalSolved * 10000.0 / totalAttempted) / 100.0;
        double avgMinutes = withTime == 0 ? 0.0 : Math.round(totalMinutes * 100.0 / withTime) / 100.0;

        Map<String, Object> response = new HashMap<>();
        response.put("totalAttempted", totalAttempted);
        response.put("totalSolved", totalSolved);
        response.put("successRate", successRate);
        response.put("avgMinutes", avgMinutes);
        response.put("byDifficulty", toOut(byDifficulty));
        response.put("byPlatform", toOut(byPlatform));
        return response;
    }

    private Map<String, Object> toOut(Map<String, int[]> in) {
        Map<String, Object> out = new HashMap<>();
        for (Map.Entry<String, int[]> e : in.entrySet()) {
            Map<String, Object> m = new HashMap<>();
            m.put("attempted", e.getValue()[0]);
            m.put("solved", e.getValue()[1]);
            out.put(e.getKey(), m);
        }
        return out;
    }
}
