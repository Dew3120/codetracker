package com.codetracker.service;

import com.codetracker.dto.request.ChangePasswordRequest;
import com.codetracker.dto.request.LoginRequest;
import com.codetracker.dto.request.ProfileUpdateRequest;
import com.codetracker.dto.request.RegisterRequest;
import com.codetracker.dto.response.AuthResponse;
import com.codetracker.dto.response.UserResponse;
import com.codetracker.entity.User;
import com.codetracker.exception.DuplicateResourceException;
import com.codetracker.exception.ResourceNotFoundException;
import com.codetracker.repository.UserRepository;
import java.util.Optional;
import org.springframework.http.HttpStatus;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

@Service
@Transactional
public class UserService {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtService jwtService;

    public UserService(UserRepository userRepository, PasswordEncoder passwordEncoder, JwtService jwtService) {
        this.userRepository = userRepository;
        this.passwordEncoder = passwordEncoder;
        this.jwtService = jwtService;
    }

    public AuthResponse register(RegisterRequest request) {
        if (existsByUsername(request.getUsername())) {
            throw new DuplicateResourceException("Username is already taken");
        }
        if (existsByEmail(request.getEmail())) {
            throw new DuplicateResourceException("Email is already in use");
        }

        User user = User.builder()
                .username(request.getUsername())
                .email(request.getEmail())
                .password(passwordEncoder.encode(request.getPassword()))
                .firstName(request.getFirstName())
                .lastName(request.getLastName())
                .timezone("Asia/Colombo")
                .dailyGoalMinutes(120)
                .build();

        User savedUser = userRepository.save(user);
        return AuthResponse.builder()
                .token(jwtService.generateToken(savedUser))
                .user(UserResponse.fromEntity(savedUser))
                .build();
    }

    public AuthResponse login(LoginRequest request) {
        User user = userRepository.findByEmail(request.getEmail())
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Invalid email or password"));

        if (!passwordEncoder.matches(request.getPassword(), user.getPassword())) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Invalid email or password");
        }

        return AuthResponse.builder()
                .token(jwtService.generateToken(user))
                .user(UserResponse.fromEntity(user))
                .build();
    }

    @Transactional(readOnly = true)
    public UserResponse getCurrentUser(Long userId) {
        return UserResponse.fromEntity(getUserById(userId));
    }

    public UserResponse updateProfile(Long userId, ProfileUpdateRequest request) {
        User user = getUserById(userId);

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

        return UserResponse.fromEntity(userRepository.save(user));
    }

    public void changePassword(Long userId, ChangePasswordRequest request) {
        User user = getUserById(userId);
        if (!passwordEncoder.matches(request.getCurrentPassword(), user.getPassword())) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Current password is incorrect");
        }
        user.setPassword(passwordEncoder.encode(request.getNewPassword()));
        userRepository.save(user);
    }

    @Transactional(readOnly = true)
    public Optional<User> findByUsername(String username) {
        return userRepository.findByUsername(username);
    }

    @Transactional(readOnly = true)
    public Optional<User> findByEmail(String email) {
        return userRepository.findByEmail(email);
    }

    @Transactional(readOnly = true)
    public boolean existsByUsername(String username) {
        return userRepository.existsByUsername(username);
    }

    @Transactional(readOnly = true)
    public boolean existsByEmail(String email) {
        return userRepository.existsByEmail(email);
    }

    public User save(User user) {
        return userRepository.save(user);
    }

    private User getUserById(Long userId) {
        return userRepository.findById(userId)
                .orElseThrow(() -> new ResourceNotFoundException("User not found"));
    }
}
