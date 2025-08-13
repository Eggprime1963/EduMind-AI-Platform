package tech.nguyenstudy0504.learningplatform.controller;

import tech.nguyenstudy0504.learningplatform.model.User;
import tech.nguyenstudy0504.learningplatform.service.UserService;
import tech.nguyenstudy0504.learningplatform.util.JwtUtil;
import tech.nguyenstudy0504.learningplatform.dto.LoginRequest;
import tech.nguyenstudy0504.learningplatform.dto.LoginResponse;
import tech.nguyenstudy0504.learningplatform.dto.ApiResponse;
import tech.nguyenstudy0504.learningplatform.dto.ForgotPasswordRequest;
import tech.nguyenstudy0504.learningplatform.dto.ResetPasswordRequest;
import tech.nguyenstudy0504.learningplatform.service.EmailService;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import jakarta.validation.Valid;

@RestController
@RequestMapping("/api/auth")
@CrossOrigin(origins = "*")
public class AuthController {

    @Autowired
    private UserService userService;

    @Autowired
    private JwtUtil jwtUtil;

    @Autowired
    private EmailService emailService;

    @PostMapping("/login")
    public ResponseEntity<ApiResponse<LoginResponse>> login(@Valid @RequestBody LoginRequest loginRequest) {
        try {
            User user = userService.authenticateUser(loginRequest.getUsernameOrEmail(), loginRequest.getPassword());
            
            if (user != null) {
                String token = jwtUtil.generateToken(user.getUsername());
                
                LoginResponse loginResponse = new LoginResponse();
                loginResponse.setToken(token);
                loginResponse.setUser(user);
                loginResponse.setMessage("Login successful");
                
                ApiResponse<LoginResponse> response = new ApiResponse<>(true, "Login successful", loginResponse);
                return ResponseEntity.ok(response);
            } else {
                ApiResponse<LoginResponse> response = new ApiResponse<>(false, "Invalid credentials", null);
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(response);
            }
        } catch (Exception e) {
            ApiResponse<LoginResponse> response = new ApiResponse<>(false, "Login failed: " + e.getMessage(), null);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }

    @PostMapping("/logout")
    public ResponseEntity<ApiResponse<String>> logout(@RequestHeader("Authorization") String token) {
        // In a stateless JWT setup, logout is handled client-side by removing the token
        // Server-side logout would require token blacklisting
        ApiResponse<String> response = new ApiResponse<>(true, "Logout successful", null);
        return ResponseEntity.ok(response);
    }

    @GetMapping("/verify")
    public ResponseEntity<ApiResponse<User>> verifyToken(@RequestHeader("Authorization") String token) {
        try {
            String jwtToken = token.replace("Bearer ", "");
            if (jwtUtil.validateToken(jwtToken)) {
                String username = jwtUtil.extractUsername(jwtToken);
                User user = userService.findByUsername(username).orElse(null);
                
                if (user != null) {
                    ApiResponse<User> response = new ApiResponse<>(true, "Token valid", user);
                    return ResponseEntity.ok(response);
                }
            }
            
            ApiResponse<User> response = new ApiResponse<>(false, "Invalid token", null);
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(response);
        } catch (Exception e) {
            ApiResponse<User> response = new ApiResponse<>(false, "Token verification failed", null);
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(response);
        }
    }

    @PostMapping("/forgot-password")
    public ResponseEntity<ApiResponse<String>> forgotPassword(@Valid @RequestBody ForgotPasswordRequest request) {
        try {
            // Initiate password reset
            userService.initiatePasswordReset(request.getEmail());
            
            // Find user to get reset token
            User user = userService.findByEmail(request.getEmail()).orElse(null);
            if (user != null && user.getPasswordResetToken() != null) {
                // Send reset email
                emailService.sendPasswordResetEmail(request.getEmail(), user.getPasswordResetToken());
            }
            
            // Always return success message for security (don't reveal if email exists)
            ApiResponse<String> response = new ApiResponse<>(true, 
                "If the email address exists in our system, you will receive a password reset link.", null);
            return ResponseEntity.ok(response);
            
        } catch (Exception e) {
            // For security, don't reveal the actual error
            ApiResponse<String> response = new ApiResponse<>(true, 
                "If the email address exists in our system, you will receive a password reset link.", null);
            return ResponseEntity.ok(response);
        }
    }

    @PostMapping("/reset-password")
    public ResponseEntity<ApiResponse<String>> resetPassword(@Valid @RequestBody ResetPasswordRequest request) {
        try {
            // Validate passwords match
            if (!request.getNewPassword().equals(request.getConfirmPassword())) {
                ApiResponse<String> response = new ApiResponse<>(false, "Passwords do not match", null);
                return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(response);
            }

            // Validate token and get user
            User user = userService.findByPasswordResetToken(request.getToken()).orElse(null);
            if (user == null || !user.isPasswordResetTokenValid()) {
                ApiResponse<String> response = new ApiResponse<>(false, "Invalid or expired reset token", null);
                return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(response);
            }

            // Reset password
            userService.resetPassword(request.getToken(), request.getNewPassword());
            
            // Send confirmation email
            emailService.sendPasswordResetConfirmation(user.getEmail());
            
            ApiResponse<String> response = new ApiResponse<>(true, "Password reset successfully", null);
            return ResponseEntity.ok(response);
            
        } catch (Exception e) {
            ApiResponse<String> response = new ApiResponse<>(false, "Failed to reset password: " + e.getMessage(), null);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }

    @GetMapping("/verify-reset-token/{token}")
    public ResponseEntity<ApiResponse<String>> verifyResetToken(@PathVariable String token) {
        try {
            User user = userService.findByPasswordResetToken(token).orElse(null);
            if (user == null || !user.isPasswordResetTokenValid()) {
                ApiResponse<String> response = new ApiResponse<>(false, "Invalid or expired reset token", null);
                return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(response);
            }
            
            ApiResponse<String> response = new ApiResponse<>(true, "Reset token is valid", null);
            return ResponseEntity.ok(response);
            
        } catch (Exception e) {
            ApiResponse<String> response = new ApiResponse<>(false, "Token verification failed", null);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
        }
    }
}
