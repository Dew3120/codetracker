package com.codetracker.codetracker.controller;

import com.codetracker.codetracker.dto.request.ProfileUpdateRequest;
import com.codetracker.codetracker.dto.response.UserResponse;
import com.codetracker.codetracker.exception.ResourceNotFoundException;
import com.codetracker.codetracker.model.User;
import com.codetracker.codetracker.repository.UserRepository;
import com.codetracker.codetracker.service.UserService;
import jakarta.validation.Valid;
import jakarta.validation.constraints.NotBlank;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.RequiredArgsConstructor;
import lombok.Setter;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.security.Principal;

@RestController
@RequestMapping("/api/users")
@RequiredArgsConstructor
public class UserController {

    private final UserService userService;
    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;

    @GetMapping("/me")
    public ResponseEntity<UserResponse> getCurrentUser(Principal principal) {
        User user = userService.findByUsername(principal.getName())
                .orElseThrow(() -> new ResourceNotFoundException("Current user not found"));
        return ResponseEntity.ok(UserResponse.fromEntity(user));
    }

    @PutMapping("/me")
    public ResponseEntity<UserResponse> updateProfile(@Valid @RequestBody ProfileUpdateRequest request,
                                                      Principal principal) {
        User user = userService.findByUsername(principal.getName())
                .orElseThrow(() -> new ResourceNotFoundException("Current user not found"));

        if (request.getFirstName() != null) {
            user.setFirstName(request.getFirstName());
        }
        if (request.getLastName() != null) {
            user.setLastName(request.getLastName());
        }
        if (request.getBio() != null) {
            user.setBio(request.getBio());
        }
        if (request.getTimezone() != null) {
            user.setTimezone(request.getTimezone());
        }
        if (request.getDailyGoalMinutes() != null) {
            user.setDailyGoalMinutes(request.getDailyGoalMinutes());
        }

        userRepository.save(user);
        return ResponseEntity.ok(UserResponse.fromEntity(user));
    }

    @PutMapping("/me/password")
    public ResponseEntity<UserResponse> changePassword(@Valid @RequestBody PasswordChangeRequest request,
                                                       Principal principal) {
        User user = userService.findByUsername(principal.getName())
                .orElseThrow(() -> new ResourceNotFoundException("Current user not found"));

        if (!passwordEncoder.matches(request.getOldPassword(), user.getPassword())) {
            return ResponseEntity.badRequest().build();
        }

        user.setPassword(passwordEncoder.encode(request.getNewPassword()));
        userRepository.save(user);
        return ResponseEntity.ok(UserResponse.fromEntity(user));
    }

    @Getter
    @Setter
    @NoArgsConstructor
    @AllArgsConstructor
    @Builder
    private static class PasswordChangeRequest {

        @NotBlank
        private String oldPassword;

        @NotBlank
        private String newPassword;
    }
}
