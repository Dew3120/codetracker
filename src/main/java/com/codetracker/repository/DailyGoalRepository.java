package com.codetracker.repository;

import com.codetracker.entity.DailyGoal;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@Repository
public interface DailyGoalRepository extends JpaRepository<DailyGoal, Long> {

    Optional<DailyGoal> findByUserIdAndGoalDate(Long userId, LocalDate goalDate);

    List<DailyGoal> findByUserIdAndIsCompletedTrueOrderByGoalDateDesc(Long userId);

    List<DailyGoal> findByUserId(Long userId);
}
