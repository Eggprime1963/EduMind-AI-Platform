package tech.nguyenstudy0504.learningplatform.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import tech.nguyenstudy0504.learningplatform.service.AIService;

import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.CompletableFuture;

@RestController
@RequestMapping("/api/ai")
@CrossOrigin(origins = "*")
public class AIController {

    @Autowired
    private AIService aiService;

    @PostMapping("/chat")
    public ResponseEntity<Map<String, Object>> chat(@RequestBody Map<String, String> request) {
        String message = request.get("message");
        String category = request.getOrDefault("category", "general");

        if (message == null || message.trim().isEmpty()) {
            Map<String, Object> error = new HashMap<>();
            error.put("error", "Message cannot be empty");
            return ResponseEntity.badRequest().body(error);
        }

        try {
            String response = aiService.getAIResponse(message, category);
            
            Map<String, Object> result = new HashMap<>();
            result.put("response", response);
            result.put("status", "success");
            result.put("category", category);
            
            return ResponseEntity.ok(result);
        } catch (Exception e) {
            Map<String, Object> error = new HashMap<>();
            error.put("error", "AI service temporarily unavailable");
            error.put("status", "error");
            return ResponseEntity.internalServerError().body(error);
        }
    }

    @PostMapping("/chat/async")
    public CompletableFuture<ResponseEntity<Map<String, Object>>> chatAsync(@RequestBody Map<String, String> request) {
        String message = request.get("message");
        String category = request.getOrDefault("category", "general");

        if (message == null || message.trim().isEmpty()) {
            Map<String, Object> error = new HashMap<>();
            error.put("error", "Message cannot be empty");
            return CompletableFuture.completedFuture(ResponseEntity.badRequest().body(error));
        }

        return aiService.getAIResponseAsync(message, category)
            .thenApply(response -> {
                Map<String, Object> result = new HashMap<>();
                result.put("response", response);
                result.put("status", "success");
                result.put("category", category);
                return ResponseEntity.ok(result);
            })
            .exceptionally(ex -> {
                Map<String, Object> error = new HashMap<>();
                error.put("error", "AI service temporarily unavailable");
                error.put("status", "error");
                return ResponseEntity.internalServerError().body(error);
            });
    }

    @GetMapping("/status")
    public ResponseEntity<Map<String, Object>> getStatus() {
        Map<String, Object> status = new HashMap<>();
        status.put("gemini_available", aiService.isGeminiAvailable());
        status.put("ollama_available", aiService.isOllamaAvailable());
        status.put("fallback_available", true);
        status.put("service_status", aiService.getServiceStatus());
        
        return ResponseEntity.ok(status);
    }

    @PostMapping("/recommend")
    public ResponseEntity<Map<String, Object>> getRecommendations(@RequestBody Map<String, String> request) {
        String userLevel = request.getOrDefault("level", "beginner");
        String interests = request.getOrDefault("interests", "programming");
        
        String message = "I'm a " + userLevel + " interested in " + interests + 
                        ". What courses would you recommend?";
        
        try {
            String response = aiService.getAIResponse(message, "recommendations");
            
            Map<String, Object> result = new HashMap<>();
            result.put("recommendations", response);
            result.put("status", "success");
            result.put("user_level", userLevel);
            result.put("interests", interests);
            
            return ResponseEntity.ok(result);
        } catch (Exception e) {
            Map<String, Object> error = new HashMap<>();
            error.put("error", "Recommendation service temporarily unavailable");
            error.put("status", "error");
            return ResponseEntity.internalServerError().body(error);
        }
    }
}
