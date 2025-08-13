package tech.nguyenstudy0504.learningplatform.repository;

import tech.nguyenstudy0504.learningplatform.model.Enrollment;
import tech.nguyenstudy0504.learningplatform.model.EnrollmentId;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Repository
public interface EnrollmentRepository extends JpaRepository<Enrollment, EnrollmentId> {

    @Query("SELECT e FROM Enrollment e WHERE e.user.id = :userId")
    List<Enrollment> findByUserId(@Param("userId") Long userId);
    
    @Query("SELECT e FROM Enrollment e WHERE e.course.id = :courseId")
    List<Enrollment> findByCourseId(@Param("courseId") Long courseId);
    
    @Query("SELECT e FROM Enrollment e WHERE e.user.id = :userId AND e.course.id = :courseId")
    Optional<Enrollment> findByUserIdAndCourseId(@Param("userId") Long userId, @Param("courseId") Long courseId);
    
    @Query("SELECT COUNT(e) > 0 FROM Enrollment e WHERE e.user.id = :userId AND e.course.id = :courseId")
    boolean existsByUserIdAndCourseId(@Param("userId") Long userId, @Param("courseId") Long courseId);
    
    @Query("SELECT e FROM Enrollment e WHERE e.user.id = :userId AND e.status = 'ACTIVE'")
    List<Enrollment> findActiveByUserId(@Param("userId") Long userId);
    
    @Query("SELECT e FROM Enrollment e WHERE e.course.id = :courseId AND e.status = 'ACTIVE'")
    List<Enrollment> findActiveByCourseId(@Param("courseId") Long courseId);
    
    @Query("SELECT e FROM Enrollment e WHERE e.enrolledAt BETWEEN :startDate AND :endDate")
    List<Enrollment> findByEnrollmentDateBetween(@Param("startDate") LocalDateTime startDate, @Param("endDate") LocalDateTime endDate);
    
    @Query("SELECT COUNT(e) FROM Enrollment e WHERE e.course.id = :courseId AND e.status = 'ACTIVE'")
    long countActiveByCourseId(@Param("courseId") Long courseId);
    
    @Query("SELECT COUNT(e) FROM Enrollment e WHERE e.user.id = :userId AND e.status = 'ACTIVE'")
    long countActiveByUserId(@Param("userId") Long userId);
    
    @Query("SELECT e FROM Enrollment e JOIN e.course c WHERE c.instructorId = :instructorId")
    List<Enrollment> findByInstructorId(@Param("instructorId") Long instructorId);
    
    @Query("SELECT e FROM Enrollment e WHERE e.progressPercentage >= :minProgress")
    List<Enrollment> findByProgressGreaterThanEqual(@Param("minProgress") Double minProgress);
    
    @Query("SELECT AVG(e.progressPercentage) FROM Enrollment e WHERE e.course.id = :courseId AND e.status = 'ACTIVE'")
    Double findAverageProgressByCourseId(@Param("courseId") Long courseId);
    
    @Query("SELECT e FROM Enrollment e WHERE e.course.category = :category AND e.status = 'ACTIVE'")
    List<Enrollment> findByCourseCategory(@Param("category") String category);
    
    @Query("SELECT e FROM Enrollment e WHERE e.completionDate IS NOT NULL")
    List<Enrollment> findCompletedEnrollments();
    
    @Query("SELECT e FROM Enrollment e WHERE e.completionDate IS NULL AND e.status = 'ACTIVE'")
    List<Enrollment> findIncompleteEnrollments();
}
