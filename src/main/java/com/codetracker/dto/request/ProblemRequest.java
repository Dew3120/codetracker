package com.codetracker.dto.request;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.PastOrPresent;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;
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

    @NotBlank
    @Size(max = 50)
    private String platform;

    @NotBlank
    @Size(max = 200)
    private String problemName;

    @Size(max = 500)
    private String problemUrl;

    @NotBlank
    @Pattern(regexp = "(?i)EASY|MEDIUM|HARD", message = "difficulty must be EASY, MEDIUM, or HARD")
    private String difficulty;

    private Boolean isSolved;

    private Integer timeTakenMinutes;

    private String notes;

    @PastOrPresent
    @NotNull
    private LocalDate solvedDate;
}
