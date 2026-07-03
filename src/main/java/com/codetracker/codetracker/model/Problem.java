package com.codetracker.codetracker.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Entity
@Table(name = "problems")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Problem {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, length = 100)
    private String platform;

    @Column(name = "problem_name", nullable = false)
    private String problemName;

    @Column(name = "problem_url")
    private String problemUrl;

    private String difficulty;

    @Column(name = "is_solved", nullable = false)
    private Boolean isSolved;

    @Column(name = "time_taken_minutes")
    private Integer timeTakenMinutes;

    @Column(columnDefinition = "TEXT")
    private String notes;

    @Column(name = "solved_date")
    private LocalDate solvedDate;

    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id")
    private User user;
}
