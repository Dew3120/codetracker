package com.codetracker.codetracker.repository;

import com.codetracker.codetracker.model.Problem;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ProblemRepository extends JpaRepository<Problem, Long> {

    /**
     * Find all problems belonging to a user identified by their id.
     * @param userId the id of the user
     * @return list of problems for the given user (empty list if none)
     */
    List<Problem> findAllByUserId(Long userId);
}

