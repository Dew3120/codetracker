package com.codetracker.codetracker.repository;

import com.codetracker.codetracker.model.UserAchievement;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface UserAchievementRepository extends JpaRepository<UserAchievement, Long> {

    @Query("SELECT ua FROM UserAchievement ua JOIN FETCH ua.achievement WHERE ua.user.id = :userId")
    List<UserAchievement> findByUserIdWithAchievement(@Param("userId") Long userId);

    boolean existsByUserIdAndAchievementId(Long userId, Long achievementId);

    @Query("SELECT ua.achievement.id FROM UserAchievement ua WHERE ua.user.id = :userId")
    List<Long> findEarnedAchievementIdsByUserId(@Param("userId") Long userId);
}
