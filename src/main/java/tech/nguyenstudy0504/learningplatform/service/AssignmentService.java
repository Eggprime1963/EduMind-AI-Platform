package tech.nguyenstudy0504.learningplatform.service;

import tech.nguyenstudy0504.learningplatform.model.Assignment;
import tech.nguyenstudy0504.learningplatform.repository.AssignmentRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Service
@Transactional
public class AssignmentService {

    @Autowired
    private AssignmentRepository assignmentRepository;

    // Assignment CRUD operations
    public Assignment createAssignment(Assignment assignment) {
        return assignmentRepository.save(assignment);
    }

    public Assignment updateAssignment(Assignment assignment) {
        return assignmentRepository.save(assignment);
    }

    public void deleteAssignment(Long id) {
        assignmentRepository.deleteById(id);
    }

    public Optional<Assignment> findById(Long id) {
        return assignmentRepository.findById(id);
    }

    public Optional<Assignment> findByIdAndActive(Long id) {
        return assignmentRepository.findByIdAndStatus(id, Assignment.Status.PUBLISHED);
    }

    public List<Assignment> findAllAssignments() {
        return assignmentRepository.findAll();
    }

    public List<Assignment> findAssignmentsByCourse(Long courseId) {
        return assignmentRepository.findActiveByCourseIdOrderByDueDate(courseId);
    }

    public List<Assignment> findAllAssignmentsByCourse(Long courseId) {
        return assignmentRepository.findByCourseId(courseId);
    }

    // Search operations
    public List<Assignment> searchAssignments(String searchTerm) {
        return assignmentRepository.searchAssignments(searchTerm);
    }

    public List<Assignment> findAssignmentsByTitle(String title) {
        return assignmentRepository.findByTitleContaining(title);
    }

    public List<Assignment> findAssignmentsByDescription(String description) {
        return assignmentRepository.findByDescriptionContaining(description);
    }

    // Assignment management
    public void activateAssignment(Long assignmentId) {
        Optional<Assignment> assignmentOpt = assignmentRepository.findById(assignmentId);
        if (assignmentOpt.isPresent()) {
            Assignment assignment = assignmentOpt.get();
            assignment.setStatus(Assignment.Status.PUBLISHED);
            assignmentRepository.save(assignment);
        }
    }

    public void deactivateAssignment(Long assignmentId) {
        Optional<Assignment> assignmentOpt = assignmentRepository.findById(assignmentId);
        if (assignmentOpt.isPresent()) {
            Assignment assignment = assignmentOpt.get();
            assignment.setStatus(Assignment.Status.DRAFT);
            assignmentRepository.save(assignment);
        }
    }

    // Due date management
    public List<Assignment> findOverdueAssignments() {
        return assignmentRepository.findOverdueAssignments(LocalDateTime.now());
    }

    public List<Assignment> findUpcomingAssignments() {
        return assignmentRepository.findUpcomingAssignments(LocalDateTime.now());
    }

    public List<Assignment> findAssignmentsByDateRange(LocalDateTime startDate, LocalDateTime endDate) {
        return assignmentRepository.findByDueDateBetween(startDate, endDate);
    }

    // Statistics
    public long countActiveAssignmentsByCourse(Long courseId) {
        return assignmentRepository.countActiveByCourseId(courseId);
    }

    public List<Assignment> findAssignmentsByInstructor(Long instructorId) {
        return assignmentRepository.findByInstructorId(instructorId);
    }

    public List<Assignment> findAssignmentsByEnrolledUser(Long userId) {
        return assignmentRepository.findByEnrolledUserId(userId);
    }

    // Validation
    public boolean isAssignmentOverdue(Assignment assignment) {
        return assignment.getDueDate() != null && assignment.getDueDate().isBefore(LocalDateTime.now());
    }

    public boolean canUserAccessAssignment(Long userId, Long assignmentId) {
        Optional<Assignment> assignmentOpt = findByIdAndActive(assignmentId);
        if (assignmentOpt.isPresent()) {
            // Check if user is enrolled in the course containing this assignment
            return assignmentRepository.findByEnrolledUserId(userId).stream()
                    .anyMatch(a -> a.getId().equals(assignmentId));
        }
        return false;
    }
}
