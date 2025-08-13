package tech.nguyenstudy0504.learningplatform.service;

import tech.nguyenstudy0504.learningplatform.model.Course;
import tech.nguyenstudy0504.learningplatform.repository.CourseRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
@Transactional
public class CourseService {

    @Autowired
    private CourseRepository courseRepository;

    // Course CRUD operations
    public Course createCourse(Course course) {
        return courseRepository.save(course);
    }

    public Course updateCourse(Course course) {
        return courseRepository.save(course);
    }

    public void deleteCourse(Long id) {
        courseRepository.deleteById(id);
    }

    public Optional<Course> findById(Long id) {
        return courseRepository.findById(id);
    }

    public Optional<Course> findByIdAndActive(Long id) {
        return courseRepository.findByIdAndStatus(id, Course.Status.PUBLISHED);
    }

    public List<Course> findAllCourses() {
        return courseRepository.findAll();
    }

    public List<Course> findActiveCourses() {
        return courseRepository.findByStatus(Course.Status.PUBLISHED);
    }

    public List<Course> findCoursesByInstructor(Long instructorId) {
        return courseRepository.findByInstructorId(instructorId);
    }

    public List<Course> findActiveCoursesByInstructor(Long instructorId) {
        return courseRepository.findByInstructorIdAndStatus(instructorId, Course.Status.PUBLISHED);
    }

    // Search operations
    public List<Course> searchCourses(String searchTerm) {
        return courseRepository.searchCourses(searchTerm);
    }

    public List<Course> findCoursesByTitle(String title) {
        return courseRepository.findByTitleContaining(title);
    }

    public List<Course> findCoursesByDescription(String description) {
        return courseRepository.findByDescriptionContaining(description);
    }

    public List<Course> findCoursesByCategory(String category) {
        return courseRepository.findByCategoryAndStatus(category, Course.Status.PUBLISHED);
    }

    public List<String> findAllCategories() {
        return courseRepository.findDistinctCategories();
    }

    // Course management
    public void activateCourse(Long courseId) {
        Optional<Course> courseOpt = courseRepository.findById(courseId);
        if (courseOpt.isPresent()) {
            Course course = courseOpt.get();
            course.setStatus(Course.Status.PUBLISHED);
            courseRepository.save(course);
        }
    }

    public void deactivateCourse(Long courseId) {
        Optional<Course> courseOpt = courseRepository.findById(courseId);
        if (courseOpt.isPresent()) {
            Course course = courseOpt.get();
            course.setStatus(Course.Status.DRAFT);
            courseRepository.save(course);
        }
    }

    // Enrollment statistics
    public long getEnrollmentCount(Long courseId) {
        return courseRepository.countEnrollmentsByCourseId(courseId);
    }

    public List<Course> findCoursesByUser(Long userId) {
        return courseRepository.findCoursesByUserId(userId);
    }

    // Validation
    public boolean canUserAccessCourse(Long userId, Long courseId) {
        Optional<Course> courseOpt = findByIdAndActive(courseId);
        if (courseOpt.isPresent()) {
            Course course = courseOpt.get();
            // Check if user is instructor or enrolled
            if (course.getInstructorId().equals(userId)) {
                return true;
            }
            // Check enrollment through course repository
            return courseRepository.findCoursesByUserId(userId).stream()
                    .anyMatch(c -> c.getId().equals(courseId));
        }
        return false;
    }
}
