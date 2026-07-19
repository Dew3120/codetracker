package com.codetracker.service;

import com.codetracker.dto.response.LanguageDistributionResponse;
import com.codetracker.dto.response.TopicBreakdownResponse;
import com.codetracker.dto.response.WeeklyReportResponse;
import com.codetracker.entity.CodingSession;
import com.codetracker.entity.ProgrammingLanguage;
import com.codetracker.entity.Topic;
import com.codetracker.entity.User;
import com.codetracker.repository.CodingSessionRepository;
import com.codetracker.repository.UserRepository;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class ReportServiceTest {

    @Mock
    private UserRepository userRepository;

    @Mock
    private CodingSessionRepository codingSessionRepository;

    @InjectMocks
    private ReportService reportService;

    @Test
    void getWeeklyReport_AggregatesTotalsTopTopicAndTopLanguage() {
        User user = User.builder().id(1L).timezone("UTC").build();
        Topic spring = Topic.builder().name("Spring Boot").build();
        Topic react = Topic.builder().name("React.js").build();
        ProgrammingLanguage java = ProgrammingLanguage.builder().name("Java").build();
        ProgrammingLanguage js = ProgrammingLanguage.builder().name("JavaScript").build();

        List<CodingSession> sessions = List.of(
                session(LocalDate.now(), 120, spring, java),
                session(LocalDate.now().minusDays(1), 60, react, js),
                session(LocalDate.now().minusDays(2), 30, spring, java)
        );

        when(userRepository.findById(1L)).thenReturn(Optional.of(user));
        when(codingSessionRepository.findByUserIdAndDateRange(eq(1L), any(LocalDate.class), any(LocalDate.class)))
                .thenReturn(sessions);

        WeeklyReportResponse response = reportService.getWeeklyReport(1L);

        assertEquals(210, response.getTotalMinutes());
        assertEquals(3, response.getTotalSessions());
        assertEquals(30.0, response.getAverageMinutesPerDay());
        assertEquals("Spring Boot", response.getTopTopic());
        assertEquals("Java", response.getTopLanguage());
        assertEquals(7, response.getDailyBreakdown().size());
        assertNotNull(response.getWeekStart());
        assertNotNull(response.getWeekEnd());
    }

    @Test
    void getLanguageDistribution_MapsRepositoryProjection() {
        when(userRepository.findById(1L)).thenReturn(Optional.of(User.builder().id(1L).build()));
        when(codingSessionRepository.findLanguageDistributionByUserId(1L)).thenReturn(List.of(
                new Object[]{"Java", "#B07219", 180L},
                new Object[]{"JavaScript", "#F1E05A", 60L}
        ));

        LanguageDistributionResponse response = reportService.getLanguageDistribution(1L);

        assertEquals(2, response.getLanguageStats().size());
        assertEquals("Java", response.getLanguageStats().get(0).getLanguage());
        assertEquals("#B07219", response.getLanguageStats().get(0).getColor());
        assertEquals(180, response.getLanguageStats().get(0).getMinutes());
    }

    @Test
    void getTopicBreakdown_MapsRepositoryProjection() {
        when(userRepository.findById(1L)).thenReturn(Optional.of(User.builder().id(1L).build()));
        when(codingSessionRepository.findTopicBreakdownByUserId(1L)).thenReturn(List.of(
                new Object[]{"Spring Boot", 180L},
                new Object[]{"React.js", 60L}
        ));

        TopicBreakdownResponse response = reportService.getTopicBreakdown(1L);

        assertEquals(2, response.getTopicStats().size());
        assertEquals("Spring Boot", response.getTopicStats().get(0).getTopic());
        assertEquals(180, response.getTopicStats().get(0).getMinutes());
    }

    private CodingSession session(LocalDate date, int minutes, Topic topic, ProgrammingLanguage language) {
        return CodingSession.builder()
                .sessionDate(date)
                .durationMinutes(minutes)
                .topic(topic)
                .language(language)
                .build();
    }
}