package com.codetracker.codetracker.service;

import com.codetracker.codetracker.model.Problem;
import com.codetracker.codetracker.repository.ProblemRepository;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class ProblemService {

    private final ProblemRepository problemRepository;

    public ProblemService(ProblemRepository problemRepository) {
        this.problemRepository = problemRepository;
    }

    public List<Problem> getAllProblemsByUserId(Long userId) {
        return problemRepository.findAllByUserId(userId);
    }

    public Problem save(Problem problem) {
        return problemRepository.save(problem);
    }

    public void deleteById(Long id) {
        problemRepository.deleteById(id);
    }

    public Optional<Problem> findById(Long id) {
        return problemRepository.findById(id);
    }
}

