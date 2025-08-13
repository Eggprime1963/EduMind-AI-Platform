package tech.nguyenstudy0504.learningplatform.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@Service
public class EmailService {

    private static final Logger logger = LoggerFactory.getLogger(EmailService.class);

    @Autowired
    private JavaMailSender mailSender;

    @Value("${spring.mail.username:noreply@eduplatform.com}")
    private String fromEmail;

    @Value("${app.frontend.url:http://localhost:3000}")
    private String frontendUrl;

    public void sendPasswordResetEmail(String toEmail, String resetToken) {
        try {
            SimpleMailMessage message = new SimpleMailMessage();
            message.setFrom(fromEmail);
            message.setTo(toEmail);
            message.setSubject("Password Reset Request - EduMind Learning Platform");
            
            String resetUrl = frontendUrl + "/reset-password?token=" + resetToken;
            String emailContent = String.format(
                "Hello,\n\n" +
                "You have requested to reset your password for EduMind Learning Platform.\n\n" +
                "Please click the following link to reset your password:\n" +
                "%s\n\n" +
                "This link will expire in 24 hours for security reasons.\n\n" +
                "If you did not request this password reset, please ignore this email.\n\n" +
                "Best regards,\n" +
                "EduMind Learning Platform Team",
                resetUrl
            );
            
            message.setText(emailContent);
            mailSender.send(message);
            
            logger.info("Password reset email sent successfully to: {}", toEmail);
        } catch (Exception e) {
            logger.error("Failed to send password reset email to: {}", toEmail, e);
            throw new RuntimeException("Failed to send password reset email", e);
        }
    }

    public void sendPasswordResetConfirmation(String toEmail) {
        try {
            SimpleMailMessage message = new SimpleMailMessage();
            message.setFrom(fromEmail);
            message.setTo(toEmail);
            message.setSubject("Password Reset Successful - EduMind Learning Platform");
            
            String emailContent = 
                "Hello,\n\n" +
                "Your password has been successfully reset for EduMind Learning Platform.\n\n" +
                "If you did not make this change, please contact our support team immediately.\n\n" +
                "Best regards,\n" +
                "EduMind Learning Platform Team";
            
            message.setText(emailContent);
            mailSender.send(message);
            
            logger.info("Password reset confirmation email sent successfully to: {}", toEmail);
        } catch (Exception e) {
            logger.error("Failed to send password reset confirmation email to: {}", toEmail, e);
            // Don't throw exception here as password was already reset successfully
        }
    }
}
