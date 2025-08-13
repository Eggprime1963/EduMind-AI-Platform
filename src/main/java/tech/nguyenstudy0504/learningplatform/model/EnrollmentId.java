package tech.nguyenstudy0504.learningplatform.model;

import jakarta.persistence.Embeddable;
import java.util.Objects;

@Embeddable
public class EnrollmentId {
    private Long userId;
    private Long courseId;

    public EnrollmentId() {}

    public EnrollmentId(Long userId, Long courseId) {
        this.userId = userId;
        this.courseId = courseId;
    }

    // Getters and Setters
    public Long getUserId() {
        return userId;
    }

    public void setUserId(Long userId) {
        this.userId = userId;
    }

    public Long getCourseId() {
        return courseId;
    }

    public void setCourseId(Long courseId) {
        this.courseId = courseId;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof EnrollmentId)) return false;
        EnrollmentId that = (EnrollmentId) o;
        return Objects.equals(userId, that.userId) && Objects.equals(courseId, that.courseId);
    }

    @Override
    public int hashCode() {
        return Objects.hash(userId, courseId);
    }

    @Override
    public String toString() {
        return "EnrollmentId{" +
                "userId=" + userId +
                ", courseId=" + courseId +
                '}';
    }
}
