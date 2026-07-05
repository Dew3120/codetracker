package com.codetracker.controller;

import com.codetracker.dto.request.ChangePasswordRequest;
import com.codetracker.dto.request.ProfileUpdateRequest;
import com.codetracker.dto.response.UserResponse;
import com.codetracker.entity.User;
import com.codetracker.service.UserService;
import jakarta.validation.Valid;
import java.security.Principal;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.server.ResponseStatusException;

@RestController
@RequestMapping("/api/users")
public class UserController {

    private final UserService userService;

    public UserController(UserService userService) {
        this.userService = userService;
    }

    @PutMapping("/profile")
    public ResponseEntity<UserResponse> updateProfile(Principal principal,
                                                      @Valid @RequestBody ProfileUpdateRequest request) {
        Long userId = getCurrentUserId(principal);
        return ResponseEntity.ok(userService.updateProfile(userId, request));
    }

    @PutMapping("/password")
    public ResponseEntity<Void> changePassword(Principal principal,
                                               @Valid @RequestBody ChangePasswordRequest request) {
        Long userId = getCurrentUserId(principal);
        userService.changePassword(userId, request);
        return ResponseEntity.noContent().build();
    }

    private Long getCurrentUserId(Principal principal) {
        if (principal == null) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "User not authenticated");
        }
        return userService.findByUsername(principal.getName())
                .map(User::getId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.UNAUTHORIZED, "User not found"));
    }
}
