package com.codetracker.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import java.time.LocalDate;
import java.time.LocalDateTime;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.OnDelete;
import org.hibernate.annotations.OnDeleteAction;

@Entity
@Table(name = "problems_solved")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ProblemSolved {

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

    @Builder.Default
    @Column(name = "is_solved", columnDefinition = "BOOLEAN DEFAULT FALSE")
    private Boolean isSolved = false;

    @Column(name = "time_taken_minutes")
    private Integer timeTakenMinutes;

    @Column(columnDefinition = "TEXT")
    private String notes;

    @Column(name = "solved_date", nullable = false, columnDefinition = "DATE")
    private LocalDate solvedDate;

    @CreationTimestamp
    @Column(name = "created_at", updatable = false, columnDefinition = "TIMESTAMP DEFAULT CURRENT_TIMESTAMP")
    private LocalDateTime createdAt;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    @OnDelete(action = OnDeleteAction.CASCADE)
    private User user;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "session_id")
    @OnDelete(action = OnDeleteAction.SET_NULL)
    private CodingSession session;
}
