package com.codetracker.codetracker.dto.response;

import com.codetracker.codetracker.model.CodingSession;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class SessionResponse {

    private Long id;
    private String topicName;
    private String topicCategory;
    private String languageName;
    private String languageColorHex;
    private LocalDate sessionDate;
    private LocalTime startTime;
    private LocalTime endTime;
    private Integer durationMinutes;
    private String notes;
    private Boolean isTimerSession;
    private LocalDateTime createdAt;

    public static SessionResponse fromEntity(CodingSession session) {
        return SessionResponse.builder()
                .id(session.getId())
                .topicName(session.getTopic().getName())
                .topicCategory(session.getTopic().getCategory())
                .languageName(session.getLanguage().getName())
                .languageColorHex(session.getLanguage().getColorHex())
                .sessionDate(session.getSessionDate())
                .startTime(session.getStartTime())
                .endTime(session.getEndTime())
                .durationMinutes(session.getDurationMinutes())
                .notes(session.getNotes())
                .isTimerSession(session.getIsTimerSession())
                .createdAt(session.getCreatedAt())
                .build();
    }
}
