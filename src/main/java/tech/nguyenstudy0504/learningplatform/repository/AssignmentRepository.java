package tech.nguyenstudy0504.learningplatform.repository;

import tech.nguyenstudy0504.learningplatform.model.Assignment;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Repository
public interface AssignmentRepository extends JpaRepository<Assignment, Long> {

    List<Assignment> findByCourseId(Long courseId);
    
    List<Assignment> findByCourseIdAndStatus(Long courseId, Assignment.Status status);
    
    @Query("SELECT a FROM Assignment a WHERE a.course.id = :courseId AND a.status = 'PUBLISHED' ORDER BY a.dueDate ASC")
    List<Assignment> findActiveByCourseIdOrderByDueDate(@Param("courseId") Long courseId);
    
    @Query("SELECT a FROM Assignment a WHERE a.title LIKE %:title%")
    List<Assignment> findByTitleContaining(@Param("title") String title);
    
    @Query("SELECT a FROM Assignment a WHERE a.description LIKE %:description%")
    List<Assignment> findByDescriptionContaining(@Param("description") String description);
    
    @Query("SELECT a FROM Assignment a WHERE a.title LIKE %:searchTerm% OR a.description LIKE %:searchTerm%")
    List<Assignment> searchAssignments(@Param("searchTerm") String searchTerm);
    
    Optional<Assignment> findByIdAndStatus(Long id, Assignment.Status status);
    
    @Query("SELECT a FROM Assignment a WHERE a.dueDate BETWEEN :startDate AND :endDate")
    List<Assignment> findByDueDateBetween(@Param("startDate") LocalDateTime startDate, @Param("endDate") LocalDateTime endDate);
    
    @Query("SELECT a FROM Assignment a WHERE a.dueDate < :date AND a.status = 'PUBLISHED'")
    List<Assignment> findOverdueAssignments(@Param("date") LocalDateTime date);
    
    @Query("SELECT a FROM Assignment a WHERE a.dueDate > :date AND a.status = 'PUBLISHED'")
    List<Assignment> findUpcomingAssignments(@Param("date") LocalDateTime date);
    
    @Query("SELECT COUNT(a) FROM Assignment a WHERE a.course.id = :courseId AND a.status = 'PUBLISHED'")
    long countActiveByCourseId(@Param("courseId") Long courseId);
    
    @Query("SELECT a FROM Assignment a JOIN a.course c WHERE c.instructorId = :instructorId")
    List<Assignment> findByInstructorId(@Param("instructorId") Long instructorId);
    
    @Query("SELECT a FROM Assignment a JOIN a.course c JOIN c.enrollments e WHERE e.user.id = :userId AND a.status = 'PUBLISHED'")
    List<Assignment> findByEnrolledUserId(@Param("userId") Long userId);
}
