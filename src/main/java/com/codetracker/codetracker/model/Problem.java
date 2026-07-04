package com.codetracker.codetracker.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Entity
@Table(name = "problems_solved")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Problem {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, length = 50)
    private String platform;

    @Column(name = "problem_name", nullable = false, length = 200)
    private String problemName;

    @Column(name = "problem_url", length = 500)
    private String problemUrl;

    @Column(nullable = false, columnDefinition = "ENUM('EASY','MEDIUM','HARD')")
    private String difficulty;

    @Column(name = "is_solved", nullable = false)
    @Builder.Default
    private Boolean isSolved = false;

    @Column(name = "time_taken_minutes")
    private Integer timeTakenMinutes;

    @Column(columnDefinition = "TEXT")
    private String notes;

    @Column(name = "solved_date", nullable = false)
    private LocalDate solvedDate;

    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "session_id")
    private CodingSession session;
}
