package tech.nguyenstudy0504.learningplatform.dto;

import tech.nguyenstudy0504.learningplatform.model.User;

public class LoginResponse {
    
    private String token;
    private User user;
    private String message;
    
    // Constructors
    public LoginResponse() {}
    
    public LoginResponse(String token, User user, String message) {
        this.token = token;
        this.user = user;
        this.message = message;
    }
    
    // Getters and Setters
    public String getToken() {
        return token;
    }
    
    public void setToken(String token) {
        this.token = token;
    }
    
    public User getUser() {
        return user;
    }
    
    public void setUser(User user) {
        this.user = user;
    }
    
    public String getMessage() {
        return message;
    }
    
    public void setMessage(String message) {
        this.message = message;
    }
}
