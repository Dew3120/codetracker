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
import jakarta.persistence.UniqueConstraint;
import java.time.LocalDate;
import java.time.LocalDateTime;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.OnDelete;
import org.hibernate.annotations.OnDeleteAction;

@Entity
@Table(name = "daily_goals", uniqueConstraints = {
        @UniqueConstraint(name = "unique_user_date", columnNames = {"user_id", "goal_date"})
})
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class DailyGoal {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    @OnDelete(action = OnDeleteAction.CASCADE)
    private User user;

    @Column(name = "goal_date", nullable = false, columnDefinition = "DATE")
    private LocalDate goalDate;

    @Column(name = "target_minutes", nullable = false, columnDefinition = "INT")
    private Integer targetMinutes;

    @Builder.Default
    @Column(name = "achieved_minutes", columnDefinition = "INT DEFAULT 0")
    private Integer achievedMinutes = 0;

    @Builder.Default
    @Column(name = "is_completed", columnDefinition = "BOOLEAN DEFAULT FALSE")
    private Boolean isCompleted = false;

    @CreationTimestamp
    @Column(name = "created_at", columnDefinition = "TIMESTAMP DEFAULT CURRENT_TIMESTAMP")
    private LocalDateTime createdAt;
}
