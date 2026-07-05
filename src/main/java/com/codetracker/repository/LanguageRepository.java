package com.codetracker.repository;

import com.codetracker.entity.ProgrammingLanguage;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface LanguageRepository extends JpaRepository<ProgrammingLanguage, Long> {
}