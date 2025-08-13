package tech.nguyenstudy0504.learningplatform.repository;

import tech.nguyenstudy0504.learningplatform.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Repository
public interface UserRepository extends JpaRepository<User, Long> {
    
    Optional<User> findByUsername(String username);
    
    Optional<User> findByEmail(String email);
    
    Optional<User> findByUsernameOrEmail(String username, String email);
    
    boolean existsByUsername(String username);
    
    boolean existsByEmail(String email);
    
    Optional<User> findByPasswordResetToken(String token);
    
    List<User> findByRole(User.Role role);
    
    List<User> findByIsActiveTrue();
    
    List<User> findByIsActiveFalse();
    
    List<User> findByEmailVerified(boolean emailVerified);
    
    @Query("SELECT u FROM User u WHERE u.createdAt >= :startDate")
    List<User> findUsersCreatedAfter(@Param("startDate") LocalDateTime startDate);
    
    @Query("SELECT u FROM User u WHERE u.username LIKE %:searchTerm% OR u.email LIKE %:searchTerm% OR u.firstName LIKE %:searchTerm% OR u.lastName LIKE %:searchTerm%")
    List<User> searchUsers(@Param("searchTerm") String searchTerm);
    
    @Query("SELECT COUNT(u) FROM User u WHERE u.role = :role")
    long countByRole(@Param("role") User.Role role);
    
    @Query("SELECT u FROM User u LEFT JOIN FETCH u.enrollments WHERE u.id = :id")
    Optional<User> findByIdWithEnrollments(@Param("id") Long id);
    
    @Query("SELECT u FROM User u LEFT JOIN FETCH u.activities WHERE u.id = :id")
    Optional<User> findByIdWithActivities(@Param("id") Long id);
}
