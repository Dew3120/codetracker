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
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.http.HttpStatus;
import org.springframework.web.server.ResponseStatusException;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class CodingSessionServiceTest {

    @Mock
    private CodingSessionRepository codingSessionRepository;

    @Mock
    private TopicRepository topicRepository;

    @Mock
    private LanguageRepository languageRepository;

    @Mock
    private UserRepository userRepository;

    @Mock
    private DailyGoalService dailyGoalService;

    @Mock
    private AchievementService achievementService;

    @InjectMocks
    private CodingSessionService codingSessionService;

    @Test
    void createSession_WithStartAndEndTime_CalculatesDurationAndUpdatesGoal() {
        LocalDate today = LocalDate.now();
        User user = User.builder().id(1L).username("dev_student").build();
        Topic topic = Topic.builder().id(2L).name("Spring Boot").category("Backend").build();
        ProgrammingLanguage language = ProgrammingLanguage.builder().id(1L).name("Java").colorHex("#B07219").build();
        SessionRequest request = SessionRequest.builder()
                .topicId(2L)
                .languageId(1L)
                .sessionDate(today)
                .startTime(LocalTime.of(9, 0))
                .endTime(LocalTime.of(10, 30))
                .notes("Service tests")
                .isTimerSession(false)
                .build();

        when(userRepository.findById(1L)).thenReturn(Optional.of(user));
        when(topicRepository.findById(2L)).thenReturn(Optional.of(topic));
        when(languageRepository.findById(1L)).thenReturn(Optional.of(language));
        when(codingSessionRepository.save(any(CodingSession.class))).thenAnswer(invocation -> {
            CodingSession session = invocation.getArgument(0);
            session.setId(10L);
            return session;
        });

        SessionResponse response = codingSessionService.createSession(1L, request);

        assertEquals(10L, response.getId());
        assertEquals("Spring Boot", response.getTopicName());
        assertEquals("Java", response.getLanguageName());
        assertEquals(90, response.getDurationMinutes());
        verify(dailyGoalService).updateGoalProgress(1L, today, 90);
        verify(achievementService).checkAndAwardAchievements(1L);
    }

    @Test
    void createSession_WithFutureDate_ThrowsBadRequest() {
        SessionRequest request = SessionRequest.builder()
                .sessionDate(LocalDate.now().plusDays(1))
                .durationMinutes(30)
                .build();

        when(userRepository.findById(1L)).thenReturn(Optional.of(User.builder().id(1L).build()));

        ResponseStatusException exception = assertThrows(
                ResponseStatusException.class,
                () -> codingSessionService.createSession(1L, request)
        );

        assertEquals(HttpStatus.BAD_REQUEST, exception.getStatusCode());
        verify(codingSessionRepository, never()).save(any());
    }

    @Test
    void updateSession_WhenDurationChanges_UpdatesGoalByDelta() {
        LocalDate today = LocalDate.now();
        User user = User.builder().id(1L).build();
        CodingSession existing = CodingSession.builder()
                .id(10L)
                .user(user)
                .sessionDate(today)
                .durationMinutes(60)
                .notes("Old")
                .build();
        SessionRequest request = SessionRequest.builder()
                .durationMinutes(90)
                .notes("Updated")
                .build();

        when(codingSessionRepository.findById(10L)).thenReturn(Optional.of(existing));
        when(codingSessionRepository.save(existing)).thenReturn(existing);

        SessionResponse response = codingSessionService.updateSession(10L, 1L, request);

        assertEquals(90, response.getDurationMinutes());
        assertEquals("Updated", response.getNotes());
        verify(dailyGoalService).updateGoalProgress(1L, today, 30);
        verify(achievementService).checkAndAwardAchievements(1L);
    }

    @Test
    void getUserSessionsPaged_FiltersSortsAndPaginates() {
        User user = User.builder().id(1L).build();
        Topic spring = Topic.builder().id(2L).name("Spring Boot").category("Backend").build();
        Topic react = Topic.builder().id(7L).name("React.js").category("Frontend").build();
        ProgrammingLanguage java = ProgrammingLanguage.builder().id(1L).name("Java").build();
        ProgrammingLanguage js = ProgrammingLanguage.builder().id(3L).name("JavaScript").build();

        CodingSession first = CodingSession.builder()
                .id(1L)
                .user(user)
                .topic(spring)
                .language(java)
                .sessionDate(LocalDate.now().minusDays(1))
                .durationMinutes(90)
                .build();
        CodingSession second = CodingSession.builder()
                .id(2L)
                .user(user)
                .topic(react)
                .language(js)
                .sessionDate(LocalDate.now())
                .durationMinutes(45)
                .build();

        when(codingSessionRepository.findByUserIdWithDetails(1L)).thenReturn(List.of(first, second));

        Map<String, Object> page = codingSessionService.getUserSessionsPaged(
                1L, 0, 10, "durationMinutes,desc", null, null, null, null);

        @SuppressWarnings("unchecked")
        List<SessionResponse> content = (List<SessionResponse>) page.get("content");

        assertEquals(2, page.get("totalElements"));
        assertEquals(90, content.get(0).getDurationMinutes());
        assertEquals(45, content.get(1).getDurationMinutes());
        assertTrue(content.stream().anyMatch(session -> "React.js".equals(session.getTopicName())));
    }
}