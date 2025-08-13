package tech.nguyenstudy0504.learningplatform.repository;

import tech.nguyenstudy0504.learningplatform.model.UserActivity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;

@Repository
public interface UserActivityRepository extends JpaRepository<UserActivity, Long> {

    List<UserActivity> findByUserId(Long userId);
    
    List<UserActivity> findByUserIdOrderByCreatedAtDesc(Long userId);
    
    List<UserActivity> findByActivityType(UserActivity.ActivityType activityType);
    
    @Query("SELECT ua FROM UserActivity ua WHERE ua.createdAt BETWEEN :startDate AND :endDate")
    List<UserActivity> findByCreatedAtBetween(@Param("startDate") LocalDateTime startDate, @Param("endDate") LocalDateTime endDate);
    
    @Query("SELECT ua FROM UserActivity ua WHERE ua.user.id = :userId AND ua.createdAt BETWEEN :startDate AND :endDate")
    List<UserActivity> findByUserIdAndCreatedAtBetween(@Param("userId") Long userId, @Param("startDate") LocalDateTime startDate, @Param("endDate") LocalDateTime endDate);
    
    @Query("SELECT ua FROM UserActivity ua WHERE ua.user.id = :userId AND ua.activityType = :activityType")
    List<UserActivity> findByUserIdAndActivityType(@Param("userId") Long userId, @Param("activityType") UserActivity.ActivityType activityType);
    
    @Query("SELECT ua FROM UserActivity ua WHERE ua.entityId = :entityId AND ua.entityType = :entityType")
    List<UserActivity> findByEntityIdAndEntityType(@Param("entityId") Long entityId, @Param("entityType") String entityType);
    
    @Query("SELECT COUNT(ua) FROM UserActivity ua WHERE ua.user.id = :userId AND ua.activityType = :activityType")
    long countByUserIdAndActivityType(@Param("userId") Long userId, @Param("activityType") UserActivity.ActivityType activityType);
    
    @Query("SELECT COUNT(ua) FROM UserActivity ua WHERE ua.user.id = :userId AND ua.createdAt BETWEEN :startDate AND :endDate")
    long countByUserIdAndCreatedAtBetween(@Param("userId") Long userId, @Param("startDate") LocalDateTime startDate, @Param("endDate") LocalDateTime endDate);
    
    @Query("SELECT ua FROM UserActivity ua WHERE ua.user.id = :userId ORDER BY ua.createdAt DESC")
    List<UserActivity> findRecentActivitiesByUserId(@Param("userId") Long userId);
    
    @Query("SELECT DISTINCT ua.activityType FROM UserActivity ua WHERE ua.user.id = :userId")
    List<UserActivity.ActivityType> findDistinctActivityTypesByUserId(@Param("userId") Long userId);
    
    @Query("SELECT ua FROM UserActivity ua WHERE ua.description LIKE %:searchTerm%")
    List<UserActivity> searchByDescription(@Param("searchTerm") String searchTerm);
}
