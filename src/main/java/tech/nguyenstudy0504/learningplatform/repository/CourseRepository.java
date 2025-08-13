package tech.nguyenstudy0504.learningplatform.repository;

import tech.nguyenstudy0504.learningplatform.model.Course;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface CourseRepository extends JpaRepository<Course, Long> {

    List<Course> findByStatus(Course.Status status);
    
    List<Course> findByInstructorId(Long instructorId);
    
    List<Course> findByInstructorIdAndStatus(Long instructorId, Course.Status status);
    
    @Query("SELECT c FROM Course c WHERE c.title LIKE %:title%")
    List<Course> findByTitleContaining(@Param("title") String title);
    
    @Query("SELECT c FROM Course c WHERE c.description LIKE %:description%")
    List<Course> findByDescriptionContaining(@Param("description") String description);
    
    @Query("SELECT c FROM Course c WHERE c.title LIKE %:searchTerm% OR c.description LIKE %:searchTerm%")
    List<Course> searchCourses(@Param("searchTerm") String searchTerm);
    
    List<Course> findByCategory(String category);
    
    List<Course> findByCategoryAndStatus(String category, Course.Status status);
    
    @Query("SELECT DISTINCT c.category FROM Course c WHERE c.status = 'PUBLISHED'")
    List<String> findDistinctCategories();
    
    @Query("SELECT COUNT(e) FROM Enrollment e WHERE e.course.id = :courseId")
    long countEnrollmentsByCourseId(@Param("courseId") Long courseId);
    
    @Query("SELECT c FROM Course c JOIN c.enrollments e WHERE e.user.id = :userId")
    List<Course> findCoursesByUserId(@Param("userId") Long userId);
    
    Optional<Course> findByIdAndStatus(Long id, Course.Status status);
}
