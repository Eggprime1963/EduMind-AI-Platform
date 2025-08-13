package tech.nguyenstudy0504.learningplatform.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import tech.nguyenstudy0504.learningplatform.repository.UserRepository;

import javax.sql.DataSource;
import java.sql.Connection;
import java.util.HashMap;
import java.util.Map;

@RestController
public class HealthController {

    @Autowired
    private DataSource dataSource;
    
    @Autowired
    private UserRepository userRepository;

    @GetMapping("/health")
    public ResponseEntity<Map<String, Object>> health() {
        Map<String, Object> health = new HashMap<>();
        health.put("status", "UP");
        health.put("timestamp", System.currentTimeMillis());
        
        // Test database connection
        try (Connection connection = dataSource.getConnection()) {
            boolean isValid = connection.isValid(5);
            health.put("database", isValid ? "UP" : "DOWN");
            if (isValid) {
                long userCount = userRepository.count();
                health.put("userCount", userCount);
            }
        } catch (Exception e) {
            health.put("database", "DOWN");
            health.put("databaseError", e.getMessage());
        }
        
        return ResponseEntity.ok(health);
    }

    @GetMapping("/status")
    public ResponseEntity<Map<String, String>> status() {
        Map<String, String> status = new HashMap<>();
        status.put("application", "EduMind Learning Platform");
        status.put("version", "1.0.0");
        status.put("status", "RUNNING");
        status.put("profile", "production");
        return ResponseEntity.ok(status);
    }
}
