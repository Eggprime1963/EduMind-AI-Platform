package tech.nguyenstudy0504.learningplatform.model;

import jakarta.persistence.*;
import org.hibernate.annotations.CreationTimestamp;

import java.time.LocalDateTime;

@Entity
@Table(name = "enrollments")
public class Enrollment {

    @EmbeddedId
    private EnrollmentId id;

    @ManyToOne(fetch = FetchType.LAZY)
    @MapsId("userId")
    @JoinColumn(name = "user_id")
    private User user;

    @ManyToOne(fetch = FetchType.LAZY)
    @MapsId("courseId")
    @JoinColumn(name = "course_id")
    private Course course;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private Status status = Status.ACTIVE;

    @Column(name = "progress_percentage")
    private Double progressPercentage = 0.0;

    @Column(name = "completion_date")
    private LocalDateTime completionDate;

    @Column(name = "grade")
    private Double grade;

    @CreationTimestamp
    @Column(name = "enrolled_at", updatable = false)
    private LocalDateTime enrolledAt;

    // Constructors
    public Enrollment() {}

    public Enrollment(User user, Course course) {
        this.user = user;
        this.course = course;
        this.id = new EnrollmentId(user.getId(), course.getId());
    }

    // Getters and Setters
    public EnrollmentId getId() {
        return id;
    }

    public void setId(EnrollmentId id) {
        this.id = id;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public Course getCourse() {
        return course;
    }

    public void setCourse(Course course) {
        this.course = course;
    }

    public Status getStatus() {
        return status;
    }

    public void setStatus(Status status) {
        this.status = status;
    }

    public Double getProgressPercentage() {
        return progressPercentage;
    }

    public void setProgressPercentage(Double progressPercentage) {
        this.progressPercentage = progressPercentage;
    }

    public LocalDateTime getCompletionDate() {
        return completionDate;
    }

    public void setCompletionDate(LocalDateTime completionDate) {
        this.completionDate = completionDate;
    }

    public Double getGrade() {
        return grade;
    }

    public void setGrade(Double grade) {
        this.grade = grade;
    }

    public LocalDateTime getEnrolledAt() {
        return enrolledAt;
    }

    public void setEnrolledAt(LocalDateTime enrolledAt) {
        this.enrolledAt = enrolledAt;
    }

    // Helper methods
    public boolean isCompleted() {
        return status == Status.COMPLETED;
    }

    public boolean isActive() {
        return status == Status.ACTIVE;
    }

    public void markCompleted() {
        this.status = Status.COMPLETED;
        this.completionDate = LocalDateTime.now();
        this.progressPercentage = 100.0;
    }

    // Enums
    public enum Status {
        ACTIVE, COMPLETED, DROPPED, SUSPENDED
    }

    @Override
    public String toString() {
        return "Enrollment{" +
                "userId=" + (user != null ? user.getId() : null) +
                ", courseId=" + (course != null ? course.getId() : null) +
                ", status=" + status +
                ", progressPercentage=" + progressPercentage +
                '}';
    }
}
