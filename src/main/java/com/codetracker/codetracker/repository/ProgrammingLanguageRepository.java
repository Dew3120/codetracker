package com.codetracker.codetracker.repository;

import com.codetracker.codetracker.model.ProgrammingLanguage;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface ProgrammingLanguageRepository extends JpaRepository<ProgrammingLanguage, Long> {

    Optional<ProgrammingLanguage> findByName(String name);
}
