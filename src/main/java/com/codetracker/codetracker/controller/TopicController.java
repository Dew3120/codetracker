package com.codetracker.codetracker.controller;

import com.codetracker.codetracker.model.Topic;
import com.codetracker.codetracker.repository.TopicRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/topics")
public class TopicController {

    @Autowired
    private TopicRepository topicRepository;

    @GetMapping
    public ResponseEntity<List<Topic>> getAllTopics() {
        List<Topic> topics = topicRepository.findAll();
        return ResponseEntity.ok(topics);
    }
}