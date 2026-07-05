package com.codetracker.repository;

import com.codetracker.entity.ProblemSolved;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ProblemSolvedRepository extends JpaRepository<ProblemSolved, Long> {

    List<ProblemSolved> findAllByUserId(Long userId);
}