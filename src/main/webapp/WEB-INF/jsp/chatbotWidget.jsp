<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!-- AI Chatbot Widget -->
<div id="aiChatWidget" class="ai-chat-widget">
    <!-- Floating Chat Button -->
    <button id="chatToggleBtn" class="chat-toggle-btn" title="Ask AI Assistant">
        <i class="bi bi-robot"></i>
        <span class="chat-notification" id="chatNotification" style="display: none;"></span>
    </button>
    
    <!-- Chat Window -->
    <div id="chatWindow" class="chat-window" style="display: none;">
        <div class="chat-header">
            <div class="d-flex align-items-center">
                <i class="bi bi-robot text-white me-2"></i>
                <h6 class="mb-0 text-white">AI Learning Assistant</h6>
            </div>
            <div class="chat-controls">
                <button id="chatMinimize" class="btn btn-sm btn-outline-light me-1" title="Minimize">
                    <i class="bi bi-dash"></i>
                </button>
                <button id="chatClose" class="btn btn-sm btn-outline-light" title="Close">
                    <i class="bi bi-x"></i>
                </button>
            </div>
        </div>
        
        <div class="chat-body" id="chatBody">
            <div class="chat-welcome">
                <div class="text-center p-3">
                    <i class="bi bi-robot text-primary mb-2" style="font-size: 2rem;"></i>
                    <h6>Hello! I'm your AI learning assistant</h6>
                    <p class="text-muted small mb-3">I can help you with:</p>
                    <div class="quick-actions">
                        <button class="btn btn-sm btn-outline-primary mb-1 quick-action-btn" data-query="What programming language should I learn first?">
                            <i class="bi bi-lightbulb me-1"></i>First Language
                        </button>
                        <button class="btn btn-sm btn-outline-primary mb-1 quick-action-btn" data-query="Recommend courses for web development">
                            <i class="bi bi-globe me-1"></i>Web Dev
                        </button>
                        <button class="btn btn-sm btn-outline-primary mb-1 quick-action-btn" data-query="How to debug Python code?">
                            <i class="bi bi-bug me-1"></i>Debugging
                        </button>
                        <button class="btn btn-sm btn-outline-primary mb-1 quick-action-btn" data-query="Explain object-oriented programming">
                            <i class="bi bi-boxes me-1"></i>OOP Concepts
                        </button>
                    </div>
                </div>
            </div>
            
            <div class="chat-messages" id="chatMessages">
                <!-- Messages will be added here dynamically -->
            </div>
        </div>
        
        <div class="chat-footer">
            <div class="input-group">
                <input type="text" class="form-control" id="chatInput" placeholder="Ask me anything about programming..." maxlength="500">
                <button class="btn btn-primary" type="button" id="sendMessage" disabled>
                    <i class="bi bi-send"></i>
                </button>
            </div>
            <div class="chat-status" id="chatStatus">
                <small class="text-muted">
                    <i class="bi bi-circle-fill text-success me-1" style="font-size: 0.5rem;"></i>
                    AI Assistant Online
                </small>
            </div>
        </div>
    </div>
</div>

<style>
.ai-chat-widget {
    position: fixed;
    bottom: 20px;
    right: 20px;
    z-index: 1050;
    font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
}

.chat-toggle-btn {
    width: 60px;
    height: 60px;
    border-radius: 50%;
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    border: none;
    color: white;
    font-size: 1.5rem;
    box-shadow: 0 4px 20px rgba(0,0,0,0.15);
    transition: all 0.3s ease;
    position: relative;
    cursor: pointer;
}

.chat-toggle-btn:hover {
    transform: scale(1.1);
    box-shadow: 0 6px 25px rgba(0,0,0,0.2);
}

.chat-notification {
    position: absolute;
    top: -5px;
    right: -5px;
    width: 20px;
    height: 20px;
    background: #dc3545;
    border-radius: 50%;
    color: white;
    font-size: 0.7rem;
    display: flex;
    align-items: center;
    justify-content: center;
    animation: pulse 2s infinite;
}

@keyframes pulse {
    0% { transform: scale(1); }
    50% { transform: scale(1.1); }
    100% { transform: scale(1); }
}

.chat-window {
    position: absolute;
    bottom: 80px;
    right: 0;
    width: 350px;
    height: 500px;
    background: white;
    border-radius: 15px;
    box-shadow: 0 10px 30px rgba(0,0,0,0.15);
    border: 1px solid #e0e0e0;
    display: flex;
    flex-direction: column;
    overflow: hidden;
    animation: slideUp 0.3s ease-out;
}

@keyframes slideUp {
    from {
        opacity: 0;
        transform: translateY(20px);
    }
    to {
        opacity: 1;
        transform: translateY(0);
    }
}

.chat-header {
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    color: white;
    padding: 15px;
    display: flex;
    justify-content: space-between;
    align-items: center;
}

.chat-controls button {
    border: 1px solid rgba(255,255,255,0.3);
    width: 28px;
    height: 28px;
    padding: 0;
    border-radius: 4px;
    display: flex;
    align-items: center;
    justify-content: center;
}

.chat-body {
    flex: 1;
    overflow-y: auto;
    background: #f8f9fa;
}

.chat-welcome {
    border-bottom: 1px solid #e0e0e0;
    background: white;
}

.quick-actions {
    display: flex;
    flex-wrap: wrap;
    gap: 5px;
    justify-content: center;
}

.quick-action-btn {
    font-size: 0.75rem;
    padding: 0.25rem 0.5rem;
    border-radius: 15px;
}

.chat-messages {
    padding: 15px;
    min-height: 200px;
}

.chat-message {
    margin-bottom: 15px;
    display: flex;
    align-items: flex-start;
}

.chat-message.user {
    justify-content: flex-end;
}

.chat-message.ai {
    justify-content: flex-start;
}

.message-bubble {
    max-width: 80%;
    padding: 10px 15px;
    border-radius: 18px;
    word-wrap: break-word;
    line-height: 1.4;
}

.message-bubble.user {
    background: #007bff;
    color: white;
    border-bottom-right-radius: 5px;
}

.message-bubble.ai {
    background: white;
    color: #333;
    border: 1px solid #e0e0e0;
    border-bottom-left-radius: 5px;
}

.message-avatar {
    width: 25px;
    height: 25px;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 0.8rem;
    margin: 0 8px;
}

.message-avatar.ai {
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    color: white;
}

.message-avatar.user {
    background: #007bff;
    color: white;
}

.typing-indicator {
    display: flex;
    align-items: center;
    padding: 10px 15px;
    animation: fadeIn 0.3s ease-in;
}

.typing-dots {
    display: flex;
    align-items: center;
}

.typing-dots span {
    width: 6px;
    height: 6px;
    background: #667eea;
    border-radius: 50%;
    margin-right: 4px;
    animation: typing 1.4s infinite;
}

.typing-dots span:nth-child(2) {
    animation-delay: 0.2s;
}

.typing-dots span:nth-child(3) {
    animation-delay: 0.4s;
}

@keyframes typing {
    0%, 60%, 100% {
        transform: translateY(0);
        opacity: 0.3;
    }
    30% {
        transform: translateY(-10px);
        opacity: 1;
    }
}

@keyframes fadeIn {
    from { opacity: 0; }
    to { opacity: 1; }
}

/* Performance indicators */
.message-performance {
    font-size: 0.7rem;
    color: #6c757d;
    margin-top: 4px;
    font-style: italic;
}

.message-bubble.ai {
    background: white;
    color: #333;
    border: 1px solid #e0e0e0;
    border-bottom-left-radius: 5px;
    transition: all 0.2s ease;
}

.message-bubble.ai:hover {
    border-color: #667eea;
    box-shadow: 0 2px 8px rgba(102, 126, 234, 0.1);
}

/* Timeout and error states */
.error-message {
    background: #fff3cd !important;
    border: 1px solid #ffeaa7 !important;
    color: #856404 !important;
}

.timeout-message {
    background: #f8d7da !important;
    border: 1px solid #f5c6cb !important;
    color: #721c24 !important;
}

/* Quick response indicators */
.fast-response {
    border-left: 3px solid #28a745;
}

.slow-response {
    border-left: 3px solid #ffc107;
}

.timeout-response {
    border-left: 3px solid #dc3545;
}

.chat-footer {
    background: white;
    border-top: 1px solid #e0e0e0;
    padding: 15px;
}

.chat-status {
    margin-top: 8px;
    text-align: center;
}

#chatInput {
    border-radius: 20px;
    border: 1px solid #e0e0e0;
    padding: 10px 15px;
}

#sendMessage {
    border-radius: 20px;
    width: 40px;
    height: 40px;
    display: flex;
    align-items: center;
    justify-content: center;
}

/* Responsive design */
@media (max-width: 768px) {
    .chat-window {
        width: 300px;
        height: 450px;
        bottom: 70px;
        right: -10px;
    }
    
    .ai-chat-widget {
        bottom: 15px;
        right: 15px;
    }
}
</style>

<script>
document.addEventListener('DOMContentLoaded', function() {
    const chatWidget = {
        isOpen: false,
        isMinimized: false,
        
        elements: {
            toggleBtn: document.getElementById('chatToggleBtn'),
            window: document.getElementById('chatWindow'),
            messages: document.getElementById('chatMessages'),
            input: document.getElementById('chatInput'),
            sendBtn: document.getElementById('sendMessage'),
            minimizeBtn: document.getElementById('chatMinimize'),
            closeBtn: document.getElementById('chatClose'),
            status: document.getElementById('chatStatus'),
            notification: document.getElementById('chatNotification')
        },
        
        init() {
            this.bindEvents();
            this.checkAIStatus();
        },
        
        bindEvents() {
            this.elements.toggleBtn.addEventListener('click', () => this.toggle());
            this.elements.closeBtn.addEventListener('click', () => this.close());
            this.elements.minimizeBtn.addEventListener('click', () => this.minimize());
            this.elements.sendBtn.addEventListener('click', () => this.sendMessage());
            this.elements.input.addEventListener('keypress', (e) => {
                if (e.key === 'Enter') this.sendMessage();
            });
            
            this.elements.input.addEventListener('input', () => {
                this.elements.sendBtn.disabled = !this.elements.input.value.trim();
            });
            
            // Quick action buttons
            document.querySelectorAll('.quick-action-btn').forEach(btn => {
                btn.addEventListener('click', (e) => {
                    const query = e.target.closest('.quick-action-btn').dataset.query;
                    this.elements.input.value = query;
                    this.sendMessage();
                });
            });
        },
        
        toggle() {
            if (this.isOpen) {
                this.close();
            } else {
                this.open();
            }
        },
        
        open() {
            this.elements.window.style.display = 'flex';
            this.isOpen = true;
            this.isMinimized = false;
            this.elements.input.focus();
            this.hideNotification();
        },
        
        close() {
            this.elements.window.style.display = 'none';
            this.isOpen = false;
            this.isMinimized = false;
        },
        
        minimize() {
            this.elements.window.style.display = 'none';
            this.isMinimized = true;
            this.showNotification('🔽');
        },
        
        showNotification(text = '') {
            this.elements.notification.textContent = text;
            this.elements.notification.style.display = 'flex';
        },
        
        hideNotification() {
            this.elements.notification.style.display = 'none';
        },
        
        async sendMessage() {
            const message = this.elements.input.value.trim();
            if (!message) return;
            
            this.addMessage('user', message);
            this.elements.input.value = '';
            this.elements.sendBtn.disabled = true;
            
            this.showTypingIndicator();
            
            // Add timeout for better user experience
            const timeoutPromise = new Promise((_, reject) => {
                setTimeout(() => reject(new Error('Request timeout')), 12000); // 12 second timeout
            });
            
            const fetchPromise = fetch('${pageContext.request.contextPath}/chatbot', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({
                    message: message,
                    type: this.getQueryType(message)
                })
            });
            
            try {
                const startTime = Date.now();
                const response = await Promise.race([fetchPromise, timeoutPromise]);
                
                if (!response.ok) {
                    throw new Error(`Server error: ${response.status}`);
                }
                
                const data = await response.json();
                const responseTime = Date.now() - startTime;
                
                this.hideTypingIndicator();
                
                // Display response with processing time if available
                let reply = data.reply || 'I apologize, but I couldn\'t generate a response. Please try again.';
                if (data.processingTime && data.processingTime > 5000) {
                    reply += `\n\n(Response took ${Math.round(data.processingTime/1000)}s - AI service may be slow)`;
                }
                
                // Add message with performance styling
                this.addMessage('ai', reply, responseTime);
                
            } catch (error) {
                console.error('Chat error:', error);
                this.hideTypingIndicator();
                
                let errorMessage;
                let errorType = 'error';
                
                if (error.message === 'Request timeout') {
                    errorType = 'timeout';
                    errorMessage = 'The AI is taking longer than usual to respond. Here are some quick tips:\n\n' +
                                 '• Try a shorter, more specific question\n' +
                                 '• Check our course materials for immediate help\n' +
                                 '• The AI will be faster once it\'s warmed up';
                } else if (error.message.includes('Server error')) {
                    errorMessage = 'I\'m having trouble connecting to the AI service right now. You can:\n\n' +
                                 '• Browse our course catalog\n' +
                                 '• Check the FAQ section\n' +
                                 '• Try asking a simpler question';
                } else {
                    errorMessage = 'I\'m having a temporary issue. Please try again in a moment, or browse our courses for immediate help.';
                }
                
                this.addMessage('ai', errorMessage, null, errorType);
            } finally {
                this.elements.sendBtn.disabled = false;
            }
        },
        
        getQueryType(message) {
            const msg = message.toLowerCase();
            
            // More specific keyword matching for better routing
            if (msg.includes('code') || msg.includes('debug') || msg.includes('error') || 
                msg.includes('function') || msg.includes('syntax') || msg.includes('bug') ||
                msg.includes('programming') || msg.includes('algorithm')) {
                return 'programming-help';
            } else if (msg.includes('recommend') || msg.includes('suggest') || 
                      msg.includes('what course') || msg.includes('which course') ||
                      msg.includes('beginner') || msg.includes('advanced') || msg.includes('learn')) {
                return 'recommendation';
            } else if (msg.includes('assignment') || msg.includes('lecture') || 
                      msg.includes('course') || msg.includes('homework') || msg.includes('help')) {
                return 'course-help';
            }
            return 'general';
        },
        
        addMessage(sender, text, responseTime = null, messageType = 'normal') {
            const messageDiv = document.createElement('div');
            messageDiv.className = `chat-message ${sender}`;
            
            const avatarDiv = document.createElement('div');
            avatarDiv.className = `message-avatar ${sender}`;
            avatarDiv.innerHTML = sender === 'ai' ? '<i class="bi bi-robot"></i>' : '<i class="bi bi-person"></i>';
            
            const bubbleDiv = document.createElement('div');
            bubbleDiv.className = `message-bubble ${sender}`;
            
            // Apply performance and error styling
            if (sender === 'ai') {
                if (messageType === 'timeout') {
                    bubbleDiv.classList.add('timeout-message', 'timeout-response');
                } else if (messageType === 'error') {
                    bubbleDiv.classList.add('error-message');
                } else if (responseTime !== null) {
                    if (responseTime < 3000) {
                        bubbleDiv.classList.add('fast-response');
                    } else if (responseTime > 8000) {
                        bubbleDiv.classList.add('slow-response');
                    }
                }
            }
            
            // Format message with line breaks for better readability
            if (sender === 'ai') {
                bubbleDiv.innerHTML = this.formatMessage(text);
                
                // Add performance indicator for slow responses
                if (responseTime !== null && responseTime > 5000) {
                    const perfDiv = document.createElement('div');
                    perfDiv.className = 'message-performance';
                    perfDiv.textContent = `Response time: ${Math.round(responseTime/1000)}s`;
                    bubbleDiv.appendChild(perfDiv);
                }
            } else {
                bubbleDiv.textContent = text;
            }
            
            if (sender === 'ai') {
                messageDiv.appendChild(avatarDiv);
                messageDiv.appendChild(bubbleDiv);
            } else {
                messageDiv.appendChild(bubbleDiv);
                messageDiv.appendChild(avatarDiv);
            }
            
            this.elements.messages.appendChild(messageDiv);
            this.scrollToBottom();
        },
        
        formatMessage(text) {
            // Convert line breaks and format lists for better display
            return text
                .replace(/\n\n/g, '<br><br>')
                .replace(/\n/g, '<br>')
                .replace(/•/g, '&bull;')
                .replace(/\*\*([^*]+)\*\*/g, '<strong>$1</strong>'); // Bold text
        },
        
        showTypingIndicator() {
            // Remove any existing typing indicator first
            this.hideTypingIndicator();
            
            const typingDiv = document.createElement('div');
            typingDiv.id = 'typingIndicator';
            typingDiv.className = 'typing-indicator';
            typingDiv.innerHTML = `
                <div class="message-avatar ai">
                    <i class="bi bi-robot"></i>
                </div>
                <div class="typing-dots">
                    <span></span>
                    <span></span>
                    <span></span>
                </div>
                <small class="text-muted ms-2">AI is thinking...</small>
            `;
            
            this.elements.messages.appendChild(typingDiv);
            this.scrollToBottom();
        },
        
        hideTypingIndicator() {
            const typingIndicator = document.getElementById('typingIndicator');
            if (typingIndicator) {
                typingIndicator.remove();
            }
        },
        
        scrollToBottom() {
            this.elements.messages.scrollTop = this.elements.messages.scrollHeight;
        },
        
        async checkAIStatus() {
            try {
                // Simple check - you can enhance this
                this.elements.status.innerHTML = `
                    <small class="text-muted">
                        <i class="bi bi-circle-fill text-success me-1" style="font-size: 0.5rem;"></i>
                        AI Assistant Online
                    </small>
                `;
            } catch (error) {
                this.elements.status.innerHTML = `
                    <small class="text-muted">
                        <i class="bi bi-circle-fill text-warning me-1" style="font-size: 0.5rem;"></i>
                        AI Assistant Limited
                    </small>
                `;
            }
        }
    };
    
    // Initialize chat widget
    chatWidget.init();
    
    // Make chatWidget globally available
    window.aiChatWidget = chatWidget;
});
</script>
