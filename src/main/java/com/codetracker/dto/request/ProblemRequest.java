package com.codetracker.dto.request;

import jakarta.validation.constraints.NotBlank;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDate;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ProblemRequest {

    private String platform;

    private String problemName;

    private String problemUrl;

    private String difficulty;

    private Boolean isSolved;

    private Integer timeTakenMinutes;

    private String notes;

    private LocalDate solvedDate;
}
