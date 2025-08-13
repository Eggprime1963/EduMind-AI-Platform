package tech.nguyenstudy0504.learningplatform.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class HealthController {

    @GetMapping("/health")
    public String health() {
        return "OK - Application is running!";
    }

    @GetMapping("/status")
    public String status() {
        return "EduMind Learning Platform - Status: Running";
    }
}
