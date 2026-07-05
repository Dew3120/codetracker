package com.codetracker.service;

import com.codetracker.dto.request.SessionRequest;
import com.codetracker.dto.response.SessionResponse;
import com.codetracker.entity.CodingSession;
import com.codetracker.entity.ProgrammingLanguage;
import com.codetracker.entity.Topic;
import com.codetracker.entity.User;
import com.codetracker.repository.CodingSessionRepository;
import com.codetracker.repository.LanguageRepository;
import com.codetracker.repository.TopicRepository;
import com.codetracker.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

import java.time.Duration;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.ZoneId;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Transactional
public class CodingSessionService {

    private final CodingSessionRepository codingSessionRepository;
    private final TopicRepository topicRepository;
    private final LanguageRepository programmingLanguageRepository;
    private final UserRepository userRepository;
    private final DailyGoalService dailyGoalService;
    private final AchievementService achievementService;

    public SessionResponse createSession(Long userId, SessionRequest request) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "User not found"));

        LocalDate sessionDate = requireValidSessionDate(request.getSessionDate());

        Topic topic = resolveTopic(request.getTopicId());
        ProgrammingLanguage language = resolveLanguage(request.getLanguageId());

        Integer duration = resolveDuration(request.getStartTime(), request.getEndTime(), request.getDurationMinutes());

        CodingSession session = CodingSession.builder()
                .user(user)
                .topic(topic)
                .language(language)
                .sessionDate(sessionDate)
                .startTime(request.getStartTime())
                .endTime(request.getEndTime())
                .durationMinutes(duration)
                .notes(request.getNotes())
                .isTimerSession(Boolean.TRUE.equals(request.getIsTimerSession()))
                .createdAt(LocalDateTime.now())
                .updatedAt(LocalDateTime.now())
                .build();

        CodingSession saved = codingSessionRepository.save(session);
        dailyGoalService.updateGoalProgress(userId, saved.getSessionDate(), duration);
        achievementService.checkAndAwardAchievements(userId);
        return SessionResponse.fromEntity(saved);
    }

    public List<SessionResponse> getUserSessions(Long userId) {
        return codingSessionRepository.findByUserIdWithDetails(userId).stream()
                .map(SessionResponse::fromEntity)
                .collect(Collectors.toList());
    }

    public Map<String, Object> getUserSessionsPaged(Long userId, int page, int size, String sort,
                                                    Long topicId, Long languageId,
                                                    LocalDate startDate, LocalDate endDate) {
        List<CodingSession> filtered = codingSessionRepository.findByUserIdWithDetails(userId).stream()
                .filter(cs -> topicId == null || (cs.getTopic() != null && topicId.equals(cs.getTopic().getId())))
                .filter(cs -> languageId == null || (cs.getLanguage() != null && languageId.equals(cs.getLanguage().getId())))
                .filter(cs -> startDate == null || !cs.getSessionDate().isBefore(startDate))
                .filter(cs -> endDate == null || !cs.getSessionDate().isAfter(endDate))
                .sorted(resolveSessionSort(sort))
                .collect(Collectors.toList());

        int total = filtered.size();
        int safeSize = size <= 0 ? 20 : Math.min(size, 100);
        int safePage = Math.max(page, 0);
        int totalPages = (int) Math.ceil((double) total / safeSize);
        int from = Math.min(safePage * safeSize, total);
        int to = Math.min(from + safeSize, total);

        List<SessionResponse> content = filtered.subList(from, to).stream()
                .map(SessionResponse::fromEntity)
                .collect(Collectors.toList());

        Map<String, Object> response = new HashMap<>();
        response.put("content", content);
        response.put("totalElements", total);
        response.put("totalPages", totalPages);
        response.put("currentPage", safePage);
        response.put("size", safeSize);
        return response;
    }

    public List<SessionResponse> getTodaySessions(Long userId) {
        LocalDate today = LocalDate.now(ZoneId.systemDefault());
        return codingSessionRepository.findByUserIdAndDate(userId, today).stream()
                .map(SessionResponse::fromEntity)
                .collect(Collectors.toList());
    }

    public List<SessionResponse> getSessionsByDateRange(Long userId, LocalDate start, LocalDate end) {
        return codingSessionRepository.findByUserIdAndDateRange(userId, start, end).stream()
                .map(SessionResponse::fromEntity)
                .collect(Collectors.toList());
    }

    public SessionResponse getSessionById(Long sessionId, Long userId) {
        CodingSession session = codingSessionRepository.findById(sessionId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Session not found"));
        if (!session.getUser().getId().equals(userId)) {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN, "Access denied");
        }
        return SessionResponse.fromEntity(session);
    }

    public SessionResponse updateSession(Long sessionId, Long userId, SessionRequest request) {
        CodingSession existing = codingSessionRepository.findById(sessionId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Session not found"));

        if (!existing.getUser().getId().equals(userId)) {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN, "Access denied");
        }

        LocalDate oldSessionDate = existing.getSessionDate();
        int oldDuration = existing.getDurationMinutes();

        Topic topic = request.getTopicId() == null ? existing.getTopic() : resolveTopic(request.getTopicId());
        ProgrammingLanguage language = request.getLanguageId() == null ? existing.getLanguage() : resolveLanguage(request.getLanguageId());
        LocalDate sessionDate = request.getSessionDate() == null
                ? existing.getSessionDate()
                : requireValidSessionDate(request.getSessionDate());
        LocalTime startTime = request.getStartTime() == null ? existing.getStartTime() : request.getStartTime();
        LocalTime endTime = request.getEndTime() == null ? existing.getEndTime() : request.getEndTime();
        Integer requestedDuration = resolveUpdatedDuration(existing, request, startTime, endTime);
        int durationDelta = requestedDuration - oldDuration;

        existing.setTopic(topic);
        existing.setLanguage(language);
        existing.setSessionDate(sessionDate);
        existing.setStartTime(startTime);
        existing.setEndTime(endTime);
        existing.setDurationMinutes(requestedDuration);
        if (request.getNotes() != null) {
            existing.setNotes(request.getNotes());
        }
        if (request.getIsTimerSession() != null) {
            existing.setIsTimerSession(request.getIsTimerSession());
        }
        existing.setUpdatedAt(LocalDateTime.now());

        CodingSession saved = codingSessionRepository.save(existing);
        if (!oldSessionDate.equals(saved.getSessionDate())) {
            dailyGoalService.updateGoalProgress(userId, oldSessionDate, -oldDuration);
            dailyGoalService.updateGoalProgress(userId, saved.getSessionDate(), requestedDuration);
        } else if (durationDelta != 0) {
            dailyGoalService.updateGoalProgress(userId, saved.getSessionDate(), durationDelta);
        }
        achievementService.checkAndAwardAchievements(userId);

        return SessionResponse.fromEntity(saved);
    }

    public void deleteSession(Long sessionId, Long userId) {
        CodingSession existing = codingSessionRepository.findById(sessionId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Session not found"));
        if (!existing.getUser().getId().equals(userId)) {
            throw new ResponseStatusException(HttpStatus.FORBIDDEN, "Access denied");
        }
        codingSessionRepository.delete(existing);
    }

    private Integer calculateDuration(LocalTime startTime, LocalTime endTime) {
        if (startTime == null || endTime == null) {
            return null;
        }
        if (endTime.isBefore(startTime)) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "End time must be after start time");
        }
        return (int) Duration.between(startTime, endTime).toMinutes();
    }

    private Topic resolveTopic(Long topicId) {
        if (topicId == null) {
            return null;
        }
        return topicRepository.findById(topicId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.BAD_REQUEST, "Topic not found"));
    }

    private ProgrammingLanguage resolveLanguage(Long languageId) {
        if (languageId == null) {
            return null;
        }
        return programmingLanguageRepository.findById(languageId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.BAD_REQUEST, "Programming language not found"));
    }

    private LocalDate requireValidSessionDate(LocalDate sessionDate) {
        if (sessionDate == null) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Session date is required");
        }
        if (sessionDate.isAfter(LocalDate.now())) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Session date cannot be in the future");
        }
        return sessionDate;
    }

    private Integer resolveDuration(LocalTime startTime, LocalTime endTime, Integer requestedDuration) {
        Integer duration = startTime != null && endTime != null
                ? calculateDuration(startTime, endTime)
                : requestedDuration;
        if (duration == null || duration <= 0 || duration > 1440) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Duration must be between 1 and 1440 minutes");
        }
        return duration;
    }

    private Integer resolveUpdatedDuration(CodingSession existing, SessionRequest request,
                                           LocalTime startTime, LocalTime endTime) {
        boolean timeChanged = request.getStartTime() != null || request.getEndTime() != null;
        if (!timeChanged && request.getDurationMinutes() == null) {
            return existing.getDurationMinutes();
        }
        if (timeChanged && (startTime == null || endTime == null) && request.getDurationMinutes() == null) {
            return existing.getDurationMinutes();
        }
        return resolveDuration(startTime, endTime, request.getDurationMinutes());
    }

    private Comparator<CodingSession> resolveSessionSort(String sort) {
        String value = sort == null || sort.isBlank() ? "sessionDate,desc" : sort;
        String[] parts = value.split(",");
        String field = parts[0].trim();
        boolean descending = parts.length < 2 || !"asc".equalsIgnoreCase(parts[1].trim());

        Comparator<CodingSession> comparator;
        if ("durationMinutes".equalsIgnoreCase(field)) {
            comparator = Comparator.comparing(CodingSession::getDurationMinutes, Comparator.nullsLast(Integer::compareTo));
        } else if ("createdAt".equalsIgnoreCase(field)) {
            comparator = Comparator.comparing(CodingSession::getCreatedAt, Comparator.nullsLast(LocalDateTime::compareTo));
        } else {
            comparator = Comparator.comparing(CodingSession::getSessionDate, Comparator.nullsLast(LocalDate::compareTo));
        }

        return descending ? comparator.reversed() : comparator;
    }
}
