package com.codetracker.codetracker.service;

import com.codetracker.codetracker.dto.request.SessionRequest;
import com.codetracker.codetracker.dto.response.SessionResponse;
import com.codetracker.codetracker.model.CodingSession;
import com.codetracker.codetracker.model.ProgrammingLanguage;
import com.codetracker.codetracker.model.Topic;
import com.codetracker.codetracker.model.User;
import com.codetracker.codetracker.repository.CodingSessionRepository;
import com.codetracker.codetracker.repository.ProgrammingLanguageRepository;
import com.codetracker.codetracker.repository.TopicRepository;
import com.codetracker.codetracker.repository.UserRepository;
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
    private final ProgrammingLanguageRepository programmingLanguageRepository;
    private final UserRepository userRepository;
    private final DailyGoalService dailyGoalService;
    private final AchievementService achievementService;

    public SessionResponse createSession(Long userId, SessionRequest request) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "User not found"));

        Topic topic = topicRepository.findById(request.getTopicId())
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.BAD_REQUEST, "Topic not found"));

        ProgrammingLanguage language = programmingLanguageRepository.findById(request.getLanguageId())
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.BAD_REQUEST, "Programming language not found"));

        Integer duration = request.getDurationMinutes();
        if (duration == null) {
            duration = calculateDuration(request.getStartTime(), request.getEndTime());
        }

        if (duration == null || duration <= 0) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Duration must be provided and greater than zero");
        }

        CodingSession session = CodingSession.builder()
                .user(user)
                .topic(topic)
                .language(language)
                .sessionDate(request.getSessionDate())
                .startTime(request.getStartTime())
                .endTime(request.getEndTime())
                .durationMinutes(duration)
                .notes(request.getNotes())
                .isTimerSession(request.getIsTimerSession())
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

    public Map<String, Object> getUserSessionsPaged(Long userId, int page, int size,
                                                    Long topicId, Long languageId,
                                                    LocalDate startDate, LocalDate endDate) {
        List<CodingSession> filtered = codingSessionRepository.findByUserIdWithDetails(userId).stream()
                .filter(cs -> topicId == null || (cs.getTopic() != null && topicId.equals(cs.getTopic().getId())))
                .filter(cs -> languageId == null || (cs.getLanguage() != null && languageId.equals(cs.getLanguage().getId())))
                .filter(cs -> startDate == null || !cs.getSessionDate().isBefore(startDate))
                .filter(cs -> endDate == null || !cs.getSessionDate().isAfter(endDate))
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

        Topic topic = topicRepository.findById(request.getTopicId())
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.BAD_REQUEST, "Topic not found"));

        ProgrammingLanguage language = programmingLanguageRepository.findById(request.getLanguageId())
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.BAD_REQUEST, "Programming language not found"));

        Integer requestedDuration = request.getDurationMinutes();
        if (requestedDuration == null) {
            requestedDuration = calculateDuration(request.getStartTime(), request.getEndTime());
        }
        if (requestedDuration == null || requestedDuration <= 0) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Duration must be provided and greater than zero");
        }

        int durationDelta = requestedDuration - existing.getDurationMinutes();

        existing.setTopic(topic);
        existing.setLanguage(language);
        existing.setSessionDate(request.getSessionDate());
        existing.setStartTime(request.getStartTime());
        existing.setEndTime(request.getEndTime());
        existing.setDurationMinutes(requestedDuration);
        existing.setNotes(request.getNotes());
        existing.setIsTimerSession(request.getIsTimerSession());
        existing.setUpdatedAt(LocalDateTime.now());

        CodingSession saved = codingSessionRepository.save(existing);
        if (durationDelta > 0) {
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
}
