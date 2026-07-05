package com.codetracker.repository;

import com.codetracker.entity.CodingSession;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

@Repository
public interface CodingSessionRepository extends JpaRepository<CodingSession, Long> {

    @Query("SELECT cs FROM CodingSession cs JOIN FETCH cs.user JOIN FETCH cs.topic JOIN FETCH cs.language " +
           "WHERE cs.user.id = :userId ORDER BY cs.sessionDate DESC")
    List<CodingSession> findByUserIdWithDetails(@Param("userId") Long userId);

    @Query("SELECT cs FROM CodingSession cs JOIN FETCH cs.topic JOIN FETCH cs.language " +
           "WHERE cs.user.id = :userId AND cs.sessionDate = :date")
    List<CodingSession> findByUserIdAndDate(@Param("userId") Long userId, @Param("date") LocalDate date);

    @Query("SELECT cs FROM CodingSession cs JOIN FETCH cs.topic JOIN FETCH cs.language " +
           "WHERE cs.user.id = :userId AND cs.sessionDate BETWEEN :start AND :end")
    List<CodingSession> findByUserIdAndDateRange(@Param("userId") Long userId,
                                                 @Param("start") LocalDate start,
                                                 @Param("end") LocalDate end);

    @Query("SELECT SUM(cs.durationMinutes) FROM CodingSession cs " +
           "WHERE cs.user.id = :userId AND cs.sessionDate = :date")
    Integer sumDurationByUserIdAndDate(@Param("userId") Long userId, @Param("date") LocalDate date);

    @Query("SELECT SUM(cs.durationMinutes) FROM CodingSession cs " +
           "WHERE cs.user.id = :userId AND cs.sessionDate BETWEEN :start AND :end")
    Integer sumDurationByUserIdAndDateRange(@Param("userId") Long userId,
                                            @Param("start") LocalDate start,
                                            @Param("end") LocalDate end);

    @Query("SELECT DISTINCT cs.sessionDate FROM CodingSession cs WHERE cs.user.id = :userId ORDER BY cs.sessionDate DESC")
    List<LocalDate> findDistinctSessionDatesByUserId(@Param("userId") Long userId);

    @Query("SELECT pl.name, pl.colorHex, SUM(cs.durationMinutes) FROM CodingSession cs " +
           "JOIN cs.language pl WHERE cs.user.id = :userId GROUP BY pl.name, pl.colorHex")
    List<Object[]> findLanguageDistributionByUserId(@Param("userId") Long userId);

    @Query("SELECT t.name, SUM(cs.durationMinutes) FROM CodingSession cs " +
           "JOIN cs.topic t WHERE cs.user.id = :userId GROUP BY t.name")
    List<Object[]> findTopicBreakdownByUserId(@Param("userId") Long userId);
}
