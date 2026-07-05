package com.codetracker.dto.response;

import com.codetracker.entity.ProblemSolved;
import java.time.LocalDate;
import java.time.LocalDateTime;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ProblemResponse {

    private Long id;
    private String platform;
    private String problemName;
    private String problemUrl;
    private String difficulty;
    private Boolean isSolved;
    private Integer timeTakenMinutes;
    private String notes;
    private LocalDate solvedDate;
    private LocalDateTime createdAt;

    public static ProblemResponse fromEntity(ProblemSolved problem) {
        return ProblemResponse.builder()
                .id(problem.getId())
                .platform(problem.getPlatform())
                .problemName(problem.getProblemName())
                .problemUrl(problem.getProblemUrl())
                .difficulty(problem.getDifficulty())
                .isSolved(problem.getIsSolved())
                .timeTakenMinutes(problem.getTimeTakenMinutes())
                .notes(problem.getNotes())
                .solvedDate(problem.getSolvedDate())
                .createdAt(problem.getCreatedAt())
                .build();
    }
}
