package com.codetracker.codetracker.controller;

import com.codetracker.codetracker.model.ProgrammingLanguage;
import com.codetracker.codetracker.repository.ProgrammingLanguageRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/languages")
public class LanguageController {

    @Autowired
    private ProgrammingLanguageRepository languageRepository;

    @GetMapping
    public ResponseEntity<List<ProgrammingLanguage>> getAllLanguages() {
        List<ProgrammingLanguage> languages = languageRepository.findAll();
        return ResponseEntity.ok(languages);
    }
}