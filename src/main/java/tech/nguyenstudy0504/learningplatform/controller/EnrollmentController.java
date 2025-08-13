package tech.nguyenstudy0504.learningplatform.controller;

import tech.nguyenstudy0504.learningplatform.dto.ApiResponse;
import tech.nguyenstudy0504.learningplatform.model.Enrollment;
import tech.nguyenstudy0504.learningplatform.model.User;
import tech.nguyenstudy0504.learningplatform.service.EnrollmentService;
import tech.nguyenstudy0504.learningplatform.service.UserService;
import tech.nguyenstudy0504.learningplatform.service.CourseService;
import tech.nguyenstudy0504.learningplatform.util.JwtUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import jakarta.servlet.http.HttpServletRequest;
import java.util.List;
import java.util.Optional;

@RestController
@RequestMapping("/api/enrollments")
@CrossOrigin(origins = "*")
public class EnrollmentController {

    @Autowired
    private EnrollmentService enrollmentService;

    @Autowired
    private UserService userService;

    @Autowired
    private CourseService courseService;

    @Autowired
    private JwtUtil jwtUtil;

    // Get my enrollments
    @GetMapping("/my-enrollments")
    public ResponseEntity<ApiResponse<List<Enrollment>>> getMyEnrollments(HttpServletRequest request) {
        try {
            String token = extractToken(request);
            if (token == null || !jwtUtil.validateToken(token)) {
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                        .body(new ApiResponse<>(false, "Invalid or missing token", null));
            }

            String username = jwtUtil.extractUsername(token);
            Optional<User> userOpt = userService.findByUsername(username);
            
            if (userOpt.isEmpty()) {
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                        .body(new ApiResponse<>(false, "User not found", null));
            }

            User user = userOpt.get();
            List<Enrollment> enrollments = enrollmentService.findEnrollmentsByUser(user.getId());
            return ResponseEntity.ok(new ApiResponse<>(true, "Enrollments retrieved successfully", enrollments));

        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(new ApiResponse<>(false, "Error retrieving enrollments: " + e.getMessage(), null));
        }
    }

    // Enroll in course
    @PostMapping("/enroll/{courseId}")
    public ResponseEntity<ApiResponse<Enrollment>> enrollInCourse(@PathVariable Long courseId, HttpServletRequest request) {
        try {
            String token = extractToken(request);
            if (token == null || !jwtUtil.validateToken(token)) {
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                        .body(new ApiResponse<>(false, "Invalid or missing token", null));
            }

            String username = jwtUtil.extractUsername(token);
            Optional<User> userOpt = userService.findByUsername(username);
            
            if (userOpt.isEmpty()) {
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                        .body(new ApiResponse<>(false, "User not found", null));
            }

            User user = userOpt.get();
            
            // Check if course exists and is active
            if (!courseService.findByIdAndActive(courseId).isPresent()) {
                return ResponseEntity.status(HttpStatus.NOT_FOUND)
                        .body(new ApiResponse<>(false, "Course not found or not available", null));
            }

            // Check if already enrolled
            if (enrollmentService.isUserEnrolled(user.getId(), courseId)) {
                return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                        .body(new ApiResponse<>(false, "Already enrolled in this course", null));
            }

            Enrollment enrollment = enrollmentService.enrollUser(user.getId(), courseId);
            return ResponseEntity.status(HttpStatus.CREATED)
                    .body(new ApiResponse<>(true, "Enrolled successfully", enrollment));

        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(new ApiResponse<>(false, "Error enrolling in course: " + e.getMessage(), null));
        }
    }

    // Unenroll from course
    @DeleteMapping("/unenroll/{courseId}")
    public ResponseEntity<ApiResponse<Void>> unenrollFromCourse(@PathVariable Long courseId, HttpServletRequest request) {
        try {
            String token = extractToken(request);
            if (token == null || !jwtUtil.validateToken(token)) {
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                        .body(new ApiResponse<>(false, "Invalid or missing token", null));
            }

            String username = jwtUtil.extractUsername(token);
            Optional<User> userOpt = userService.findByUsername(username);
            
            if (userOpt.isEmpty()) {
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                        .body(new ApiResponse<>(false, "User not found", null));
            }

            User user = userOpt.get();
            
            // Check if enrolled
            if (!enrollmentService.isUserEnrolled(user.getId(), courseId)) {
                return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                        .body(new ApiResponse<>(false, "Not enrolled in this course", null));
            }

            enrollmentService.unenrollUser(user.getId(), courseId);
            return ResponseEntity.ok(new ApiResponse<>(true, "Unenrolled successfully", null));

        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(new ApiResponse<>(false, "Error unenrolling from course: " + e.getMessage(), null));
        }
    }

    // Update progress
    @PutMapping("/progress/{courseId}")
    public ResponseEntity<ApiResponse<Void>> updateProgress(@PathVariable Long courseId, @RequestParam Double progress, HttpServletRequest request) {
        try {
            String token = extractToken(request);
            if (token == null || !jwtUtil.validateToken(token)) {
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                        .body(new ApiResponse<>(false, "Invalid or missing token", null));
            }

            String username = jwtUtil.extractUsername(token);
            Optional<User> userOpt = userService.findByUsername(username);
            
            if (userOpt.isEmpty()) {
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                        .body(new ApiResponse<>(false, "User not found", null));
            }

            User user = userOpt.get();
            
            // Check if enrolled
            if (!enrollmentService.isUserEnrolled(user.getId(), courseId)) {
                return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                        .body(new ApiResponse<>(false, "Not enrolled in this course", null));
            }

            // Validate progress value
            if (progress < 0 || progress > 100) {
                return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                        .body(new ApiResponse<>(false, "Progress must be between 0 and 100", null));
            }

            enrollmentService.updateProgress(user.getId(), courseId, progress);
            return ResponseEntity.ok(new ApiResponse<>(true, "Progress updated successfully", null));

        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(new ApiResponse<>(false, "Error updating progress: " + e.getMessage(), null));
        }
    }

    // Mark course as completed
    @PutMapping("/complete/{courseId}")
    public ResponseEntity<ApiResponse<Void>> markCourseCompleted(@PathVariable Long courseId, HttpServletRequest request) {
        try {
            String token = extractToken(request);
            if (token == null || !jwtUtil.validateToken(token)) {
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                        .body(new ApiResponse<>(false, "Invalid or missing token", null));
            }

            String username = jwtUtil.extractUsername(token);
            Optional<User> userOpt = userService.findByUsername(username);
            
            if (userOpt.isEmpty()) {
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                        .body(new ApiResponse<>(false, "User not found", null));
            }

            User user = userOpt.get();
            
            // Check if enrolled
            if (!enrollmentService.isUserEnrolled(user.getId(), courseId)) {
                return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                        .body(new ApiResponse<>(false, "Not enrolled in this course", null));
            }

            enrollmentService.markCompleted(user.getId(), courseId);
            return ResponseEntity.ok(new ApiResponse<>(true, "Course marked as completed", null));

        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(new ApiResponse<>(false, "Error marking course as completed: " + e.getMessage(), null));
        }
    }

    // Get enrollments by course (instructor/admin only)
    @GetMapping("/course/{courseId}")
    public ResponseEntity<ApiResponse<List<Enrollment>>> getEnrollmentsByCourse(@PathVariable Long courseId, HttpServletRequest request) {
        try {
            String token = extractToken(request);
            if (token == null || !jwtUtil.validateToken(token)) {
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                        .body(new ApiResponse<>(false, "Invalid or missing token", null));
            }

            String username = jwtUtil.extractUsername(token);
            Optional<User> userOpt = userService.findByUsername(username);
            
            if (userOpt.isEmpty()) {
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                        .body(new ApiResponse<>(false, "User not found", null));
            }

            User user = userOpt.get();
            
            // Check if user has permission (instructor of course or admin)
            if (user.getRole() != User.Role.ADMIN && !courseService.canUserAccessCourse(user.getId(), courseId)) {
                return ResponseEntity.status(HttpStatus.FORBIDDEN)
                        .body(new ApiResponse<>(false, "Access denied", null));
            }

            List<Enrollment> enrollments = enrollmentService.findEnrollmentsByCourse(courseId);
            return ResponseEntity.ok(new ApiResponse<>(true, "Course enrollments retrieved successfully", enrollments));

        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(new ApiResponse<>(false, "Error retrieving course enrollments: " + e.getMessage(), null));
        }
    }

    // Get enrollment statistics
    @GetMapping("/stats/course/{courseId}")
    public ResponseEntity<ApiResponse<Object>> getCourseEnrollmentStats(@PathVariable Long courseId, HttpServletRequest request) {
        try {
            String token = extractToken(request);
            if (token == null || !jwtUtil.validateToken(token)) {
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                        .body(new ApiResponse<>(false, "Invalid or missing token", null));
            }

            String username = jwtUtil.extractUsername(token);
            Optional<User> userOpt = userService.findByUsername(username);
            
            if (userOpt.isEmpty()) {
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                        .body(new ApiResponse<>(false, "User not found", null));
            }

            User user = userOpt.get();
            
            // Check if user has permission (instructor of course or admin)
            if (user.getRole() != User.Role.ADMIN && !courseService.canUserAccessCourse(user.getId(), courseId)) {
                return ResponseEntity.status(HttpStatus.FORBIDDEN)
                        .body(new ApiResponse<>(false, "Access denied", null));
            }

            // Create stats object
            java.util.Map<String, Object> stats = new java.util.HashMap<>();
            stats.put("totalEnrollments", enrollmentService.countEnrollmentsByCourse(courseId));
            stats.put("averageProgress", enrollmentService.getAverageProgressForCourse(courseId));
            stats.put("completedCount", enrollmentService.findCompletedEnrollments().stream()
                    .filter(e -> e.getCourse().getId().equals(courseId)).count());

            return ResponseEntity.ok(new ApiResponse<>(true, "Course statistics retrieved successfully", stats));

        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(new ApiResponse<>(false, "Error retrieving course statistics: " + e.getMessage(), null));
        }
    }

    private String extractToken(HttpServletRequest request) {
        String bearerToken = request.getHeader("Authorization");
        if (bearerToken != null && bearerToken.startsWith("Bearer ")) {
            return bearerToken.substring(7);
        }
        return null;
    }
}
