package com.codetracker.controller;

import com.codetracker.dto.request.LoginRequest;
import com.codetracker.dto.request.RegisterRequest;
import com.codetracker.dto.response.AuthResponse;
import com.codetracker.dto.response.UserResponse;
import com.codetracker.entity.User;
import com.codetracker.exception.GlobalExceptionHandler;
import com.codetracker.service.UserService;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.validation.beanvalidation.LocalValidatorFactoryBean;

import java.security.Principal;
import java.util.Optional;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

class AuthControllerTest {

    private UserService userService;
    private MockMvc mockMvc;
    private ObjectMapper objectMapper;

    @BeforeEach
    void setUp() {
        userService = mock(UserService.class);

        LocalValidatorFactoryBean validator = new LocalValidatorFactoryBean();
        validator.afterPropertiesSet();

        mockMvc = MockMvcBuilders
                .standaloneSetup(new AuthController(userService))
                .setControllerAdvice(new GlobalExceptionHandler())
                .setValidator(validator)
                .build();

        objectMapper = new ObjectMapper().findAndRegisterModules();
    }

    @Test
    void register_WithValidRequest_ReturnsCreatedAuthResponse() throws Exception {
        when(userService.register(any(RegisterRequest.class))).thenReturn(AuthResponse.builder()
                .token("jwt-token")
                .user(userResponse())
                .build());

        RegisterRequest request = RegisterRequest.builder()
                .username("dev_student")
                .email("dev@example.com")
                .password("Pass1234")
                .firstName("Dev")
                .lastName("Student")
                .build();

        mockMvc.perform(post("/api/auth/register")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.token").value("jwt-token"))
                .andExpect(jsonPath("$.user.username").value("dev_student"));
    }

    @Test
    void login_WithValidRequest_ReturnsAuthResponse() throws Exception {
        when(userService.login(any(LoginRequest.class))).thenReturn(AuthResponse.builder()
                .token("jwt-token")
                .user(userResponse())
                .build());

        LoginRequest request = LoginRequest.builder()
                .email("dev@example.com")
                .password("Pass1234")
                .build();

        mockMvc.perform(post("/api/auth/login")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.token").value("jwt-token"))
                .andExpect(jsonPath("$.user.email").value("dev@example.com"));
    }

    @Test
    void login_WithInvalidEmail_ReturnsBadRequest() throws Exception {
        LoginRequest request = LoginRequest.builder()
                .email("not-an-email")
                .password("Pass1234")
                .build();

        mockMvc.perform(post("/api/auth/login")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isBadRequest());
    }

    @Test
    void currentUser_WithPrincipal_ReturnsUserResponse() throws Exception {
        Principal principal = () -> "dev_student";
        User user = User.builder().id(1L).username("dev_student").build();

        when(userService.findByUsername("dev_student")).thenReturn(Optional.of(user));
        when(userService.getCurrentUser(1L)).thenReturn(userResponse());

        mockMvc.perform(get("/api/auth/me").principal(principal))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.username").value("dev_student"))
                .andExpect(jsonPath("$.email").value("dev@example.com"));
    }

    private UserResponse userResponse() {
        return UserResponse.builder()
                .id(1L)
                .username("dev_student")
                .email("dev@example.com")
                .firstName("Dev")
                .lastName("Student")
                .timezone("Asia/Colombo")
                .dailyGoalMinutes(120)
                .build();
    }
}
