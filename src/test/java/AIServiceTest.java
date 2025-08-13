import tech.nguyenstudy0504.learningplatform.service.AIService;

/**
 * Test class for AIService with environment variables
 */
public class AIServiceTest {
    
    public static void main(String[] args) {
        System.out.println("=== AI Service Environment Variable Test ===\n");
        
        // Create AIService instance
        AIService aiService = new AIService();
        
        // Test service status
        System.out.println("Service Status:");
        System.out.println(aiService.getServiceStatus());
        System.out.println();
        
        // Test availability checks
        System.out.println("Availability Tests:");
        System.out.println("- Gemini Available: " + aiService.isGeminiAvailable());
        System.out.println("- Ollama Available: " + aiService.isOllamaAvailable());
        System.out.println();
        
        // Test AI response with priority system
        System.out.println("AI Response Test:");
        try {
            String response = aiService.getAIResponse(
                "What is Java programming?", 
                "programming"
            );
            System.out.println("Response: " + response);
        } catch (Exception e) {
            System.out.println("Error getting AI response: " + e.getMessage());
        }
        
        System.out.println("\n=== Test Complete ===");
    }
}
