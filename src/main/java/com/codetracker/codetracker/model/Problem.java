package com.codetracker.codetracker.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

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

    @Column(nullable = false)
    private String title;

    /** Difficulty values: "Easy", "Medium", "Hard" (stored as String) */
    private String difficulty;

    /** Topic such as "Arrays", "Trees", etc. */
    private String topic;

    /** Status values: "Solved", "Unsolved" */
    private String status;

    @Column(columnDefinition = "TEXT")
    private String notes;

    @Column(name = "solved_at")
    private LocalDateTime solvedAt;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id")
    private User user;
}

