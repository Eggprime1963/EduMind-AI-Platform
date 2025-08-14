package tech.nguyenstudy0504.learningplatform.config;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;
import tech.nguyenstudy0504.learningplatform.repository.CourseRepository;
import tech.nguyenstudy0504.learningplatform.repository.UserRepository;
import tech.nguyenstudy0504.learningplatform.model.Course;
import tech.nguyenstudy0504.learningplatform.model.User;

import java.math.BigDecimal;

@Component
public class DataLoader implements CommandLineRunner {

    @Autowired
    private UserRepository userRepository;
    
    @Autowired
    private CourseRepository courseRepository;
    
    @Autowired
    private PasswordEncoder passwordEncoder;

    @Override
    public void run(String... args) throws Exception {
        System.out.println("=== DataLoader: Starting application data initialization ===");
        try {
            // Add a small delay to let the application fully start
            Thread.sleep(2000);
            
            // Test basic database connectivity first
            long userCount = userRepository.count();
            System.out.println("DataLoader: Database connected successfully. Current user count: " + userCount);
            
            // Check if data already exists
            if (userCount == 0) {
                System.out.println("DataLoader: No users found, loading initial data...");
                loadInitialData();
                System.out.println("DataLoader: Initial data loaded successfully");
            } else {
                System.out.println("DataLoader: Database already contains " + userCount + " users, skipping initialization");
            }
        } catch (Exception e) {
            System.err.println("DataLoader: Error during data initialization: " + e.getClass().getSimpleName() + " - " + e.getMessage());
            System.err.println("DataLoader: Application will continue without initial data");
            // Don't print full stack trace in production to avoid log spam
            // e.printStackTrace();
        }
        System.out.println("=== DataLoader: Initialization complete ===");
    }

    private void loadInitialData() {
        try {
            // Create a sample admin user
            User admin = new User();
            admin.setUsername("admin");
            admin.setEmail("admin@example.com");
            admin.setPassword(passwordEncoder.encode("admin123")); // BCrypt encoded
            admin.setRole(User.Role.ADMIN);
            admin.setFirstName("Admin");
            admin.setLastName("User");
            admin.setActive(true);
            admin.setEmailVerified(true);
            admin = userRepository.save(admin);

            // Create a sample instructor
            User instructor = new User();
            instructor.setUsername("instructor");
            instructor.setEmail("instructor@example.com");
            instructor.setPassword(passwordEncoder.encode("instructor123"));
            instructor.setRole(User.Role.INSTRUCTOR);
            instructor.setFirstName("John");
            instructor.setLastName("Instructor");
            instructor.setActive(true);
            instructor.setEmailVerified(true);
            instructor = userRepository.save(instructor);

            // Create a sample course
            Course course = new Course();
            course.setTitle("Introduction to Spring Boot");
            course.setDescription("Learn the basics of Spring Boot development with hands-on examples");
            course.setShortDescription("Beginner-friendly Spring Boot course");
            course.setInstructorId(instructor.getId());
            course.setCategory("Programming");
            course.setPrice(new BigDecimal("99.99"));
            course.setStatus(Course.Status.PUBLISHED);
            course.setLevel(Course.Level.BEGINNER);
            course.setDurationHours(20);
            courseRepository.save(course);

            System.out.println("Created admin user: admin/admin123");
            System.out.println("Created instructor user: instructor/instructor123");
            System.out.println("Created sample course: Introduction to Spring Boot");
        } catch (Exception e) {
            System.err.println("Failed to load initial data: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
