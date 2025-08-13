package tech.nguyenstudy0504.learningplatform.controller;

import tech.nguyenstudy0504.learningplatform.dto.ApiResponse;
import tech.nguyenstudy0504.learningplatform.model.Lecture;
import tech.nguyenstudy0504.learningplatform.model.User;
import tech.nguyenstudy0504.learningplatform.model.Course;
import tech.nguyenstudy0504.learningplatform.service.LectureService;
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
@RequestMapping("/api/lectures")
@CrossOrigin(origins = "*")
public class LectureController {

    @Autowired
    private LectureService lectureService;

    @Autowired
    private UserService userService;

    @Autowired
    private CourseService courseService;

    @Autowired
    private JwtUtil jwtUtil;

    // Get lectures by course
    @GetMapping("/course/{courseId}")
    public ResponseEntity<ApiResponse<List<Lecture>>> getLecturesByCourse(@PathVariable Long courseId) {
        try {
            List<Lecture> lectures = lectureService.findLecturesByCourse(courseId);
            return ResponseEntity.ok(new ApiResponse<>(true, "Lectures retrieved successfully", lectures));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(new ApiResponse<>(false, "Error retrieving lectures: " + e.getMessage(), null));
        }
    }

    // Get lecture by ID
    @GetMapping("/{id}")
    public ResponseEntity<ApiResponse<Lecture>> getLectureById(@PathVariable Long id, HttpServletRequest request) {
        try {
            Optional<Lecture> lecture = lectureService.findByIdAndActive(id);
            if (lecture.isPresent()) {
                // Check if user has access to this lecture (enrolled in course or instructor)
                String token = extractToken(request);
                if (token != null && jwtUtil.validateToken(token)) {
                    String username = jwtUtil.extractUsername(token);
                    Optional<User> userOpt = userService.findByUsername(username);
                    if (userOpt.isPresent()) {
                        User user = userOpt.get();
                        Long courseId = lecture.get().getCourse().getId();
                        if (courseService.canUserAccessCourse(user.getId(), courseId)) {
                            return ResponseEntity.ok(new ApiResponse<>(true, "Lecture retrieved successfully", lecture.get()));
                        } else {
                            return ResponseEntity.status(HttpStatus.FORBIDDEN)
                                    .body(new ApiResponse<>(false, "Access denied to this lecture", null));
                        }
                    }
                }
                // If no valid token, check if lecture is free
                if (lecture.get().isFree()) {
                    return ResponseEntity.ok(new ApiResponse<>(true, "Lecture retrieved successfully", lecture.get()));
                } else {
                    return ResponseEntity.status(HttpStatus.UNAUTHORIZED)
                            .body(new ApiResponse<>(false, "Authentication required", null));
                }
            } else {
                return ResponseEntity.status(HttpStatus.NOT_FOUND)
                        .body(new ApiResponse<>(false, "Lecture not found", null));
            }
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(new ApiResponse<>(false, "Error retrieving lecture: " + e.getMessage(), null));
        }
    }

    // Create new lecture (instructor only)
    @PostMapping
    public ResponseEntity<ApiResponse<Lecture>> createLecture(@RequestBody Lecture lecture, HttpServletRequest request) {
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
            
            // Check if user is instructor of the course
            Optional<Course> courseOpt = courseService.findById(lecture.getCourse().getId());
            if (courseOpt.isEmpty()) {
                return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                        .body(new ApiResponse<>(false, "Course not found", null));
            }

            Course course = courseOpt.get();
            if (!course.getInstructorId().equals(user.getId()) && user.getRole() != User.Role.ADMIN) {
                return ResponseEntity.status(HttpStatus.FORBIDDEN)
                        .body(new ApiResponse<>(false, "Only course instructors can create lectures", null));
            }

            // Set next order index
            Integer nextOrder = lectureService.getNextOrderIndex(course.getId());
            lecture.setOrder(nextOrder);

            Lecture savedLecture = lectureService.createLecture(lecture);
            return ResponseEntity.status(HttpStatus.CREATED)
                    .body(new ApiResponse<>(true, "Lecture created successfully", savedLecture));

        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(new ApiResponse<>(false, "Error creating lecture: " + e.getMessage(), null));
        }
    }

    // Update lecture (instructor only)
    @PutMapping("/{id}")
    public ResponseEntity<ApiResponse<Lecture>> updateLecture(@PathVariable Long id, @RequestBody Lecture lecture, HttpServletRequest request) {
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
            Optional<Lecture> existingLectureOpt = lectureService.findById(id);
            
            if (existingLectureOpt.isEmpty()) {
                return ResponseEntity.status(HttpStatus.NOT_FOUND)
                        .body(new ApiResponse<>(false, "Lecture not found", null));
            }

            Lecture existingLecture = existingLectureOpt.get();
            Course course = existingLecture.getCourse();
            
            // Check if user is the instructor or admin
            if (!course.getInstructorId().equals(user.getId()) && user.getRole() != User.Role.ADMIN) {
                return ResponseEntity.status(HttpStatus.FORBIDDEN)
                        .body(new ApiResponse<>(false, "You can only update lectures in your own courses", null));
            }

            lecture.setId(id);
            if (lecture.getCourse() == null) {
                lecture.setCourse(existingLecture.getCourse());
            }
            if (lecture.getOrder() == null) {
                lecture.setOrder(existingLecture.getOrder());
            }
            
            Lecture updatedLecture = lectureService.updateLecture(lecture);
            return ResponseEntity.ok(new ApiResponse<>(true, "Lecture updated successfully", updatedLecture));

        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(new ApiResponse<>(false, "Error updating lecture: " + e.getMessage(), null));
        }
    }

    // Delete lecture (instructor only)
    @DeleteMapping("/{id}")
    public ResponseEntity<ApiResponse<Void>> deleteLecture(@PathVariable Long id, HttpServletRequest request) {
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
            Optional<Lecture> lectureOpt = lectureService.findById(id);
            
            if (lectureOpt.isEmpty()) {
                return ResponseEntity.status(HttpStatus.NOT_FOUND)
                        .body(new ApiResponse<>(false, "Lecture not found", null));
            }

            Lecture lecture = lectureOpt.get();
            Course course = lecture.getCourse();
            
            // Check if user is the instructor or admin
            if (!course.getInstructorId().equals(user.getId()) && user.getRole() != User.Role.ADMIN) {
                return ResponseEntity.status(HttpStatus.FORBIDDEN)
                        .body(new ApiResponse<>(false, "You can only delete lectures from your own courses", null));
            }

            lectureService.deleteLecture(id);
            return ResponseEntity.ok(new ApiResponse<>(true, "Lecture deleted successfully", null));

        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(new ApiResponse<>(false, "Error deleting lecture: " + e.getMessage(), null));
        }
    }

    // Publish lecture
    @PutMapping("/{id}/publish")
    public ResponseEntity<ApiResponse<Void>> publishLecture(@PathVariable Long id, HttpServletRequest request) {
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
            Optional<Lecture> lectureOpt = lectureService.findById(id);
            
            if (lectureOpt.isEmpty()) {
                return ResponseEntity.status(HttpStatus.NOT_FOUND)
                        .body(new ApiResponse<>(false, "Lecture not found", null));
            }

            Lecture lecture = lectureOpt.get();
            Course course = lecture.getCourse();
            
            // Check if user is the instructor or admin
            if (!course.getInstructorId().equals(user.getId()) && user.getRole() != User.Role.ADMIN) {
                return ResponseEntity.status(HttpStatus.FORBIDDEN)
                        .body(new ApiResponse<>(false, "You can only publish lectures in your own courses", null));
            }

            lectureService.activateLecture(id);
            return ResponseEntity.ok(new ApiResponse<>(true, "Lecture published successfully", null));

        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(new ApiResponse<>(false, "Error publishing lecture: " + e.getMessage(), null));
        }
    }

    // Reorder lecture
    @PutMapping("/{id}/reorder")
    public ResponseEntity<ApiResponse<Void>> reorderLecture(@PathVariable Long id, @RequestParam Integer newOrder, HttpServletRequest request) {
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
            Optional<Lecture> lectureOpt = lectureService.findById(id);
            
            if (lectureOpt.isEmpty()) {
                return ResponseEntity.status(HttpStatus.NOT_FOUND)
                        .body(new ApiResponse<>(false, "Lecture not found", null));
            }

            Lecture lecture = lectureOpt.get();
            Course course = lecture.getCourse();
            
            // Check if user is the instructor or admin
            if (!course.getInstructorId().equals(user.getId()) && user.getRole() != User.Role.ADMIN) {
                return ResponseEntity.status(HttpStatus.FORBIDDEN)
                        .body(new ApiResponse<>(false, "You can only reorder lectures in your own courses", null));
            }

            lectureService.reorderLecture(id, newOrder);
            return ResponseEntity.ok(new ApiResponse<>(true, "Lecture reordered successfully", null));

        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(new ApiResponse<>(false, "Error reordering lecture: " + e.getMessage(), null));
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
