package tech.nguyenstudy0504.learningplatform.model;

import jakarta.persistence.*;
import org.hibernate.annotations.CreationTimestamp;

import java.time.LocalDateTime;

@Entity
@Table(name = "user_activities")
public class UserActivity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private ActivityType activityType;

    @Column(name = "entity_type")
    private String entityType; // Course, Lecture, Assignment, etc.

    @Column(name = "entity_id")
    private Long entityId;

    @Column(name = "entity_name")
    private String entityName;

    @Column(columnDefinition = "TEXT")
    private String description;

    @Column(name = "metadata")
    private String metadata; // JSON format for additional data

    @CreationTimestamp
    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;

    // Constructors
    public UserActivity() {}

    public UserActivity(User user, ActivityType activityType, String description) {
        this.user = user;
        this.activityType = activityType;
        this.description = description;
    }

    public UserActivity(User user, ActivityType activityType, String entityType, Long entityId, String entityName, String description) {
        this.user = user;
        this.activityType = activityType;
        this.entityType = entityType;
        this.entityId = entityId;
        this.entityName = entityName;
        this.description = description;
    }

    // Getters and Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public ActivityType getActivityType() {
        return activityType;
    }

    public void setActivityType(ActivityType activityType) {
        this.activityType = activityType;
    }

    public String getEntityType() {
        return entityType;
    }

    public void setEntityType(String entityType) {
        this.entityType = entityType;
    }

    public Long getEntityId() {
        return entityId;
    }

    public void setEntityId(Long entityId) {
        this.entityId = entityId;
    }

    public String getEntityName() {
        return entityName;
    }

    public void setEntityName(String entityName) {
        this.entityName = entityName;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getMetadata() {
        return metadata;
    }

    public void setMetadata(String metadata) {
        this.metadata = metadata;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    // Enums
    public enum ActivityType {
        LOGIN, LOGOUT, COURSE_ENROLLED, COURSE_COMPLETED, LECTURE_VIEWED, 
        ASSIGNMENT_SUBMITTED, ASSIGNMENT_GRADED, PROFILE_UPDATED, 
        PASSWORD_CHANGED, EMAIL_VERIFIED, PAYMENT_MADE, CERTIFICATE_EARNED
    }

    @Override
    public String toString() {
        return "UserActivity{" +
                "id=" + id +
                ", activityType=" + activityType +
                ", entityType='" + entityType + '\'' +
                ", entityId=" + entityId +
                ", description='" + description + '\'' +
                ", createdAt=" + createdAt +
                '}';
    }
}
