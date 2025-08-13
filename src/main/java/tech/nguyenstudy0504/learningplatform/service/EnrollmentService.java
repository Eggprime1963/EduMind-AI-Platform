package tech.nguyenstudy0504.learningplatform.service;

import tech.nguyenstudy0504.learningplatform.model.Enrollment;
import tech.nguyenstudy0504.learningplatform.model.EnrollmentId;
import tech.nguyenstudy0504.learningplatform.model.User;
import tech.nguyenstudy0504.learningplatform.model.Course;
import tech.nguyenstudy0504.learningplatform.repository.EnrollmentRepository;
import tech.nguyenstudy0504.learningplatform.repository.UserRepository;
import tech.nguyenstudy0504.learningplatform.repository.CourseRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Service
@Transactional
public class EnrollmentService {

    @Autowired
    private EnrollmentRepository enrollmentRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private CourseRepository courseRepository;

    // Enrollment CRUD operations
    public Enrollment createEnrollment(Enrollment enrollment) {
        enrollment.setEnrolledAt(LocalDateTime.now());
        enrollment.setStatus(Enrollment.Status.ACTIVE);
        enrollment.setProgressPercentage(0.0);
        return enrollmentRepository.save(enrollment);
    }

    public Enrollment updateEnrollment(Enrollment enrollment) {
        return enrollmentRepository.save(enrollment);
    }

    public void deleteEnrollment(EnrollmentId id) {
        enrollmentRepository.deleteById(id);
    }

    public void deleteEnrollment(Long userId, Long courseId) {
        EnrollmentId id = new EnrollmentId(userId, courseId);
        enrollmentRepository.deleteById(id);
    }

    public Optional<Enrollment> findById(EnrollmentId id) {
        return enrollmentRepository.findById(id);
    }

    public Optional<Enrollment> findById(Long userId, Long courseId) {
        EnrollmentId id = new EnrollmentId(userId, courseId);
        return enrollmentRepository.findById(id);
    }

    public List<Enrollment> findAllEnrollments() {
        return enrollmentRepository.findAll();
    }

    public List<Enrollment> findEnrollmentsByUser(Long userId) {
        return enrollmentRepository.findByUserId(userId);
    }

    public List<Enrollment> findEnrollmentsByCourse(Long courseId) {
        return enrollmentRepository.findByCourseId(courseId);
    }

    public List<Enrollment> findActiveEnrollmentsByUser(Long userId) {
        return enrollmentRepository.findActiveByUserId(userId);
    }

    public List<Enrollment> findActiveEnrollmentsByCourse(Long courseId) {
        return enrollmentRepository.findActiveByCourseId(courseId);
    }

    public Optional<Enrollment> findEnrollmentByUserAndCourse(Long userId, Long courseId) {
        return enrollmentRepository.findByUserIdAndCourseId(userId, courseId);
    }

    // Enrollment management
    public boolean isUserEnrolled(Long userId, Long courseId) {
        return enrollmentRepository.existsByUserIdAndCourseId(userId, courseId);
    }

    public Enrollment enrollUser(Long userId, Long courseId) {
        if (isUserEnrolled(userId, courseId)) {
            throw new IllegalStateException("User is already enrolled in this course");
        }

        Optional<User> userOpt = userRepository.findById(userId);
        Optional<Course> courseOpt = courseRepository.findById(courseId);
        
        if (userOpt.isEmpty() || courseOpt.isEmpty()) {
            throw new IllegalArgumentException("User or Course not found");
        }

        Enrollment enrollment = new Enrollment(userOpt.get(), courseOpt.get());
        return createEnrollment(enrollment);
    }

    public void unenrollUser(Long userId, Long courseId) {
        Optional<Enrollment> enrollmentOpt = findEnrollmentByUserAndCourse(userId, courseId);
        if (enrollmentOpt.isPresent()) {
            Enrollment enrollment = enrollmentOpt.get();
            enrollment.setStatus(Enrollment.Status.DROPPED);
            updateEnrollment(enrollment);
        }
    }

    // Progress management
    public void updateProgress(Long userId, Long courseId, Double progress) {
        Optional<Enrollment> enrollmentOpt = findEnrollmentByUserAndCourse(userId, courseId);
        if (enrollmentOpt.isPresent()) {
            Enrollment enrollment = enrollmentOpt.get();
            enrollment.setProgressPercentage(progress);
            
            // Mark as completed if progress is 100%
            if (progress >= 100.0 && enrollment.getCompletionDate() == null) {
                enrollment.setCompletionDate(LocalDateTime.now());
                enrollment.setStatus(Enrollment.Status.COMPLETED);
            }
            
            updateEnrollment(enrollment);
        }
    }

    public void markCompleted(Long userId, Long courseId) {
        Optional<Enrollment> enrollmentOpt = findEnrollmentByUserAndCourse(userId, courseId);
        if (enrollmentOpt.isPresent()) {
            Enrollment enrollment = enrollmentOpt.get();
            enrollment.markCompleted();
            updateEnrollment(enrollment);
        }
    }

    // Statistics
    public long countEnrollmentsByUser(Long userId) {
        return enrollmentRepository.countActiveByUserId(userId);
    }

    public long countEnrollmentsByCourse(Long courseId) {
        return enrollmentRepository.countActiveByCourseId(courseId);
    }

    public Double getAverageProgressForCourse(Long courseId) {
        return enrollmentRepository.findAverageProgressByCourseId(courseId);
    }

    public List<Enrollment> findCompletedEnrollments() {
        return enrollmentRepository.findCompletedEnrollments();
    }

    public List<Enrollment> findIncompleteEnrollments() {
        return enrollmentRepository.findIncompleteEnrollments();
    }

    public List<Enrollment> findEnrollmentsByCategory(String category) {
        return enrollmentRepository.findByCourseCategory(category);
    }

    public List<Enrollment> findEnrollmentsByInstructor(Long instructorId) {
        return enrollmentRepository.findByInstructorId(instructorId);
    }

    public List<Enrollment> findEnrollmentsByDateRange(LocalDateTime startDate, LocalDateTime endDate) {
        return enrollmentRepository.findByEnrollmentDateBetween(startDate, endDate);
    }
}
