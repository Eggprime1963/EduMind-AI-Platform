package tech.nguyenstudy0504.learningplatform.repository;

import tech.nguyenstudy0504.learningplatform.model.Lecture;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface LectureRepository extends JpaRepository<Lecture, Long> {

    List<Lecture> findByCourseId(Long courseId);
    
    @Query("SELECT l FROM Lecture l WHERE l.course.id = :courseId ORDER BY l.order ASC")
    List<Lecture> findByCourseIdOrderByOrderIndexAsc(@Param("courseId") Long courseId);
    
    List<Lecture> findByCourseIdAndStatus(Long courseId, Lecture.Status status);
    
    @Query("SELECT l FROM Lecture l WHERE l.course.id = :courseId AND l.status = 'PUBLISHED' ORDER BY l.order ASC")
    List<Lecture> findActiveLecturesByCourseId(@Param("courseId") Long courseId);
    
    @Query("SELECT l FROM Lecture l WHERE l.title LIKE %:title%")
    List<Lecture> findByTitleContaining(@Param("title") String title);
    
    @Query("SELECT l FROM Lecture l WHERE l.content LIKE %:content%")
    List<Lecture> findByContentContaining(@Param("content") String content);
    
    @Query("SELECT l FROM Lecture l WHERE l.title LIKE %:searchTerm% OR l.content LIKE %:searchTerm%")
    List<Lecture> searchLectures(@Param("searchTerm") String searchTerm);
    
    Optional<Lecture> findByIdAndStatus(Long id, Lecture.Status status);
    
    @Query("SELECT COUNT(l) FROM Lecture l WHERE l.course.id = :courseId AND l.status = 'PUBLISHED'")
    long countActiveLecturesByCourseId(@Param("courseId") Long courseId);
    
    @Query("SELECT l FROM Lecture l WHERE l.course.id = :courseId AND l.order > :orderIndex ORDER BY l.order ASC")
    List<Lecture> findLecturesAfterOrder(@Param("courseId") Long courseId, @Param("orderIndex") Integer orderIndex);
    
    @Query("SELECT l FROM Lecture l WHERE l.course.id = :courseId AND l.order < :orderIndex ORDER BY l.order DESC")
    List<Lecture> findLecturesBeforeOrder(@Param("courseId") Long courseId, @Param("orderIndex") Integer orderIndex);
    
    @Query("SELECT MAX(l.order) FROM Lecture l WHERE l.course.id = :courseId")
    Integer findMaxOrderIndexByCourseId(@Param("courseId") Long courseId);
}
