package tech.nguyenstudy0504.learningplatform.service;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;
import org.springframework.http.*;

import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.CompletableFuture;

@Service
public class AIService {

    @Value("${gemini.api.key:}")
    private String geminiApiKey;

    @Value("${ollama.api.url:http://localhost:11434/api/generate}")
    private String ollamaApiUrl;

    private final RestTemplate restTemplate;

    public AIService() {
        this.restTemplate = new RestTemplate();
    }

    public String getAIResponse(String message, String category) {
        // Try Gemini first, then Ollama, then fallback
        try {
            if (isGeminiAvailable()) {
                return getGeminiResponse(message, category);
            }
        } catch (Exception e) {
            System.out.println("Gemini failed: " + e.getMessage());
        }

        try {
            if (isOllamaAvailable()) {
                return getOllamaResponse(message, category);
            }
        } catch (Exception e) {
            System.out.println("Ollama failed: " + e.getMessage());
        }

        return getFallbackResponse(message, category);
    }

    public boolean isGeminiAvailable() {
        return geminiApiKey != null && !geminiApiKey.isEmpty() && !geminiApiKey.equals("your_gemini_api_key");
    }

    public boolean isOllamaAvailable() {
        try {
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_JSON);
            
            Map<String, Object> requestBody = new HashMap<>();
            requestBody.put("model", "llama2");
            requestBody.put("prompt", "test");
            requestBody.put("stream", false);
            
            HttpEntity<Map<String, Object>> entity = new HttpEntity<>(requestBody, headers);
            ResponseEntity<String> response = restTemplate.postForEntity(ollamaApiUrl, entity, String.class);
            
            return response.getStatusCode() == HttpStatus.OK;
        } catch (Exception e) {
            return false;
        }
    }

    private String getGeminiResponse(String message, String category) {
        // Implement Gemini API call
        // This is a placeholder - you would implement actual Gemini API integration
        return "Gemini AI Response: Based on your question about " + category + ", here's what I found: " + message;
    }

    @SuppressWarnings("unchecked")
    private String getOllamaResponse(String message, String category) {
        try {
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_JSON);
            
            Map<String, Object> requestBody = new HashMap<>();
            requestBody.put("model", "llama2");
            requestBody.put("prompt", "Answer this question about " + category + ": " + message);
            requestBody.put("stream", false);
            
            HttpEntity<Map<String, Object>> entity = new HttpEntity<>(requestBody, headers);
            @SuppressWarnings("rawtypes")
            ResponseEntity<Map> response = restTemplate.postForEntity(ollamaApiUrl, entity, Map.class);
            
            if (response.getStatusCode() == HttpStatus.OK && response.getBody() != null) {
                Map<String, Object> body = (Map<String, Object>) response.getBody();
                if (body != null && body.get("response") != null) {
                    return (String) body.get("response");
                }
            }
        } catch (Exception e) {
            System.out.println("Ollama API error: " + e.getMessage());
        }
        
        throw new RuntimeException("Ollama API unavailable");
    }

    private String getFallbackResponse(String message, String category) {
        String lowerMessage = message.toLowerCase();
        
        // Programming languages
        if (lowerMessage.contains("java")) {
            return "🚀 **Java Programming Help:**\n\n" +
                   "• **Basics**: Variables, data types, control structures\n" +
                   "• **OOP**: Classes, objects, inheritance, polymorphism\n" +
                   "• **Frameworks**: Spring Boot, Hibernate, Maven\n" +
                   "• **Advanced**: Streams, Lambda expressions, Collections\n\n" +
                   "Check out our Java courses for hands-on practice!";
        }
        
        if (lowerMessage.contains("python")) {
            return "🐍 **Python Programming Help:**\n\n" +
                   "• **Basics**: Syntax, variables, functions, modules\n" +
                   "• **Libraries**: NumPy, Pandas, Django, Flask\n" +
                   "• **Data Science**: Machine learning, data analysis\n" +
                   "• **Web Dev**: Django, FastAPI, REST APIs\n\n" +
                   "Our Python courses cover everything from basics to AI!";
        }
        
        if (lowerMessage.contains("javascript") || lowerMessage.contains("js")) {
            return "⚡ **JavaScript Development:**\n\n" +
                   "• **Fundamentals**: ES6+, DOM manipulation, async/await\n" +
                   "• **Frontend**: React, Vue, Angular\n" +
                   "• **Backend**: Node.js, Express, APIs\n" +
                   "• **Tools**: Webpack, npm, TypeScript\n\n" +
                   "Master modern web development with our JS courses!";
        }
        
        if (lowerMessage.contains("react")) {
            return "⚛️ **React Development:**\n\n" +
                   "• **Core Concepts**: Components, JSX, state, props\n" +
                   "• **Hooks**: useState, useEffect, custom hooks\n" +
                   "• **Routing**: React Router, navigation\n" +
                   "• **State Management**: Redux, Context API\n\n" +
                   "Build modern UIs with our React courses!";
        }
        
        if (lowerMessage.contains("node") || lowerMessage.contains("nodejs")) {
            return "🟢 **Node.js Backend Development:**\n\n" +
                   "• **Core**: Modules, npm, file system, streams\n" +
                   "• **Web Frameworks**: Express.js, Koa, Fastify\n" +
                   "• **Databases**: MongoDB, PostgreSQL, Redis\n" +
                   "• **APIs**: REST, GraphQL, authentication\n\n" +
                   "Learn server-side JavaScript with our Node.js courses!";
        }
        
        // Course recommendations
        if (lowerMessage.contains("beginner") || lowerMessage.contains("start")) {
            return "🌟 **Perfect Starting Courses:**\n\n" +
                   "• **Introduction to Programming** - Learn fundamentals\n" +
                   "• **Web Development Basics** - HTML, CSS, JavaScript\n" +
                   "• **Python for Beginners** - Easy to learn first language\n" +
                   "• **Computer Science Fundamentals** - Core concepts\n\n" +
                   "All designed for complete beginners - no experience needed!";
        }
        
        if (lowerMessage.contains("recommend") || lowerMessage.contains("suggest")) {
            return "💡 **Course Recommendations:**\n\n" +
                   "Based on popular learning paths:\n" +
                   "• **Full-Stack Web Development** (12 weeks)\n" +
                   "• **Data Science with Python** (10 weeks)\n" +
                   "• **Mobile App Development** (8 weeks)\n" +
                   "• **DevOps & Cloud Computing** (6 weeks)\n\n" +
                   "What interests you most? I can suggest a specific path!";
        }
        
        // Learning help
        if (lowerMessage.contains("help") || lowerMessage.contains("learn")) {
            return "📚 **Learning Support Available:**\n\n" +
                   "• **Study Groups** - Join peer learning sessions\n" +
                   "• **Mentorship** - Connect with experienced developers\n" +
                   "• **Code Reviews** - Get feedback on your projects\n" +
                   "• **Career Guidance** - Job preparation and interview tips\n\n" +
                   "What specific area would you like help with?";
        }
        
        if (lowerMessage.contains("assignment") || lowerMessage.contains("homework")) {
            return "📝 **Assignment Help:**\n\n" +
                   "• Check your course dashboard for current assignments\n" +
                   "• Review assignment requirements and deadlines\n" +
                   "• Use discussion forums for clarification\n" +
                   "• Submit early and often (if multiple attempts allowed)\n\n" +
                   "Need help with a specific assignment? Please specify the course!";
        }
        
        // Default response
        return "🤖 **AI Assistant Here!**\n\n" +
               "I'm here to help with:\n" +
               "• Programming questions (Java, Python, JavaScript, etc.)\n" +
               "• Course recommendations and learning paths\n" +
               "• Study tips and learning strategies\n" +
               "• Technical concepts and explanations\n\n" +
               "Feel free to ask me anything about programming or our courses!";
    }

    public String getServiceStatus() {
        StringBuilder status = new StringBuilder();
        status.append("AI Service Status:\n");
        status.append("- Gemini API: ").append(isGeminiAvailable() ? "✅ Available" : "❌ Not configured").append("\n");
        status.append("- Ollama API: ").append(isOllamaAvailable() ? "✅ Available" : "❌ Not available").append("\n");
        status.append("- Fallback System: ✅ Always available\n");
        return status.toString();
    }

    public CompletableFuture<String> getAIResponseAsync(String message, String category) {
        return CompletableFuture.supplyAsync(() -> getAIResponse(message, category));
    }
}
