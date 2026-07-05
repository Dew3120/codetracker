package com.codetracker.dto.request;

import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.PastOrPresent;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDate;
import java.time.LocalTime;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class SessionRequest {

    private Long topicId;

    private Long languageId;

    @PastOrPresent
    private LocalDate sessionDate;

    private LocalTime startTime;

    private LocalTime endTime;

    @Min(1)
    @Max(1440)
    private Integer durationMinutes;

    private String notes;

    private Boolean isTimerSession;
}
