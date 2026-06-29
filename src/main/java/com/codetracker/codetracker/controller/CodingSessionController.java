package com.codetracker.codetracker.controller;

import com.codetracker.codetracker.dto.request.SessionRequest;
import com.codetracker.codetracker.dto.response.SessionResponse;
import com.codetracker.codetracker.model.User;
import com.codetracker.codetracker.service.CodingSessionService;
import com.codetracker.codetracker.service.UserService;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.server.ResponseStatusException;

import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.List;

@RestController
@RequestMapping("/api/sessions")
public class CodingSessionController {

    private final CodingSessionService codingSessionService;
    private final UserService userService;

    public CodingSessionController(CodingSessionService codingSessionService, UserService userService) {
        this.codingSessionService = codingSessionService;
        this.userService = userService;
    }

    @PostMapping
    public ResponseEntity<SessionResponse> createSession(@Valid @RequestBody SessionRequest request) {
        Long userId = getCurrentUserId();
        SessionResponse response = codingSessionService.createSession(userId, request);
        return ResponseEntity.status(HttpStatus.CREATED).body(response);
    }

    @GetMapping
    public ResponseEntity<List<SessionResponse>> getUserSessions() {
        Long userId = getCurrentUserId();
        return ResponseEntity.ok(codingSessionService.getUserSessions(userId));
    }

    @GetMapping("/today")
    public ResponseEntity<List<SessionResponse>> getTodaySessions() {
        Long userId = getCurrentUserId();
        return ResponseEntity.ok(codingSessionService.getTodaySessions(userId));
    }

    @GetMapping("/{id}")
    public ResponseEntity<SessionResponse> getSessionById(@PathVariable Long id) {
        Long userId = getCurrentUserId();
        return ResponseEntity.ok(codingSessionService.getSessionById(id, userId));
    }

    @PutMapping("/{id}")
    public ResponseEntity<SessionResponse> updateSession(@PathVariable Long id,
                                                         @Valid @RequestBody SessionRequest request) {
        Long userId = getCurrentUserId();
        return ResponseEntity.ok(codingSessionService.updateSession(id, userId, request));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteSession(@PathVariable Long id) {
        Long userId = getCurrentUserId();
        codingSessionService.deleteSession(id, userId);
        return ResponseEntity.noContent().build();
    }

    @GetMapping("/range")
    public ResponseEntity<List<SessionResponse>> getSessionsByDateRange(@RequestParam String start,
                                                                        @RequestParam String end) {
        Long userId = getCurrentUserId();
        try {
            LocalDate startDate = LocalDate.parse(start);
            LocalDate endDate = LocalDate.parse(end);
            return ResponseEntity.ok(codingSessionService.getSessionsByDateRange(userId, startDate, endDate));
        } catch (DateTimeParseException ex) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Invalid date range format");
        }
    }

    private Long getCurrentUserId() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication == null || authentication.getName() == null) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "User not authenticated");
        }

        return userService.findByUsername(authentication.getName())
                .map(User::getId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.UNAUTHORIZED, "User not found"));
    }
}
