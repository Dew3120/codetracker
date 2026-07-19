package com.codetracker.service;

import com.codetracker.dto.request.ChangePasswordRequest;
import com.codetracker.dto.request.LoginRequest;
import com.codetracker.dto.request.ProfileUpdateRequest;
import com.codetracker.dto.request.RegisterRequest;
import com.codetracker.dto.response.AuthResponse;
import com.codetracker.dto.response.UserResponse;
import com.codetracker.entity.User;
import com.codetracker.exception.DuplicateResourceException;
import com.codetracker.repository.UserRepository;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentCaptor;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.http.HttpStatus;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.server.ResponseStatusException;

import java.util.Optional;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class UserServiceTest {

    @Mock
    private UserRepository userRepository;

    @Mock
    private PasswordEncoder passwordEncoder;

    @Mock
    private JwtService jwtService;

    @InjectMocks
    private UserService userService;

    @Test
    void register_WithValidData_ReturnsAuthResponseAndHashesPassword() {
        RegisterRequest request = RegisterRequest.builder()
                .username("dev_student")
                .email("dev@example.com")
                .password("Pass1234")
                .firstName("Dev")
                .lastName("Student")
                .build();

        when(userRepository.existsByUsername("dev_student")).thenReturn(false);
        when(userRepository.existsByEmail("dev@example.com")).thenReturn(false);
        when(passwordEncoder.encode("Pass1234")).thenReturn("$2a$hashed");
        when(userRepository.save(any(User.class))).thenAnswer(invocation -> {
            User user = invocation.getArgument(0);
            user.setId(1L);
            return user;
        });
        when(jwtService.generateToken(any(User.class))).thenReturn("jwt-token");

        AuthResponse response = userService.register(request);

        assertEquals("jwt-token", response.getToken());
        assertEquals("dev_student", response.getUser().getUsername());
        assertEquals("Asia/Colombo", response.getUser().getTimezone());
        assertEquals(120, response.getUser().getDailyGoalMinutes());

        ArgumentCaptor<User> userCaptor = ArgumentCaptor.forClass(User.class);
        verify(userRepository).save(userCaptor.capture());
        assertEquals("$2a$hashed", userCaptor.getValue().getPassword());
    }

    @Test
    void register_WithExistingEmail_ThrowsDuplicateResourceException() {
        RegisterRequest request = RegisterRequest.builder()
                .username("dev_student")
                .email("existing@example.com")
                .password("Pass1234")
                .build();

        when(userRepository.existsByUsername("dev_student")).thenReturn(false);
        when(userRepository.existsByEmail("existing@example.com")).thenReturn(true);

        assertThrows(DuplicateResourceException.class, () -> userService.register(request));
        verify(userRepository, never()).save(any());
    }

    @Test
    void login_WithInvalidPassword_ThrowsUnauthorized() {
        User user = User.builder()
                .id(1L)
                .username("dev_student")
                .email("dev@example.com")
                .password("$2a$hashed")
                .build();

        when(userRepository.findByEmail("dev@example.com")).thenReturn(Optional.of(user));
        when(passwordEncoder.matches("wrong-password", "$2a$hashed")).thenReturn(false);

        ResponseStatusException exception = assertThrows(
                ResponseStatusException.class,
                () -> userService.login(LoginRequest.builder()
                        .email("dev@example.com")
                        .password("wrong-password")
                        .build())
        );

        assertEquals(HttpStatus.UNAUTHORIZED, exception.getStatusCode());
        verify(jwtService, never()).generateToken(any());
    }

    @Test
    void updateProfile_UpdatesAllowedFieldsOnly() {
        User user = User.builder()
                .id(1L)
                .username("dev_student")
                .email("dev@example.com")
                .password("$2a$hashed")
                .firstName("Old")
                .timezone("UTC")
                .dailyGoalMinutes(60)
                .build();
        ProfileUpdateRequest request = ProfileUpdateRequest.builder()
                .firstName("Dev")
                .lastName("Student")
                .bio("Building CodeTracker")
                .timezone("Asia/Colombo")
                .dailyGoalMinutes(150)
                .build();

        when(userRepository.findById(1L)).thenReturn(Optional.of(user));
        when(userRepository.save(any(User.class))).thenAnswer(invocation -> invocation.getArgument(0));

        UserResponse response = userService.updateProfile(1L, request);

        assertEquals("Dev", response.getFirstName());
        assertEquals("Student", response.getLastName());
        assertEquals("Building CodeTracker", response.getBio());
        assertEquals("Asia/Colombo", response.getTimezone());
        assertEquals(150, response.getDailyGoalMinutes());
        assertEquals("dev@example.com", response.getEmail());
    }

    @Test
    void changePassword_WithCorrectCurrentPassword_SavesEncodedNewPassword() {
        User user = User.builder()
                .id(1L)
                .password("$2a$current")
                .build();

        when(userRepository.findById(1L)).thenReturn(Optional.of(user));
        when(passwordEncoder.matches("Current123", "$2a$current")).thenReturn(true);
        when(passwordEncoder.encode("NewPass123")).thenReturn("$2a$new");

        userService.changePassword(1L, ChangePasswordRequest.builder()
                .currentPassword("Current123")
                .newPassword("NewPass123")
                .build());

        assertEquals("$2a$new", user.getPassword());
        verify(userRepository).save(user);
    }
}