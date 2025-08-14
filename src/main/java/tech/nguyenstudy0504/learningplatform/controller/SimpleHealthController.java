package tech.nguyenstudy0504.learningplatform.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;

@RestController
public class SimpleHealthController {

    @GetMapping("/ping")
    public ResponseEntity<Map<String, Object>> ping() {
        Map<String, Object> response = new HashMap<>();
        response.put("status", "OK");
        response.put("message", "Application is running");
        response.put("timestamp", LocalDateTime.now().toString());
        response.put("java_version", System.getProperty("java.version"));
        response.put("spring_profile", System.getProperty("spring.profiles.active", "default"));
        return ResponseEntity.ok(response);
    }

    @GetMapping("/ready")
    public ResponseEntity<String> ready() {
        return ResponseEntity.ok("READY");
    }
}
