package com.codetracker.codetracker.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDateTime;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class AchievementResponse {

    private Long id;
    private String name;
    private String description;
    private String icon;
    private String criteriaType;
    private Integer criteriaValue;
    private boolean earned;
    private LocalDateTime earnedAt;
}
