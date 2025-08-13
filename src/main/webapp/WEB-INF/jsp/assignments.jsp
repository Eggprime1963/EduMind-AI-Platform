<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Assignments - Learning Platform</title>
    <!-- Modern UI CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/modern-ui.css">
    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
</head>
<body data-user-id="${sessionScope.userId}" data-user-role="${sessionScope.userRole}">
    <jsp:include page="navbar.jsp" />

    <div class="main-content">
        <div class="container">
            <!-- Page Header -->
            <div class="page-header">
                <h1 class="page-title">
                    <c:if test="${sessionScope.userRole == 'teacher'}">Manage Assignments</c:if>
                    <c:if test="${sessionScope.userRole == 'student'}">My Assignments</c:if>
                </h1>
                <p class="page-subtitle">
                    <c:if test="${sessionScope.userRole == 'teacher'}">Create and manage course assignments</c:if>
                    <c:if test="${sessionScope.userRole == 'student'}">View and submit your assignments</c:if>
                </p>
            </div>

            <!-- Assignment Creation (Teacher Only) -->
            <c:if test="${sessionScope.userRole == 'teacher'}">
                <div class="card mb-4">
                    <div class="card-header">
                        <h2 class="card-title">Create New Assignment</h2>
                    </div>
                    <div class="card-content">
                        <form id="addAssignmentForm">
                            <div class="grid grid-cols-2 gap-4 mb-4">
                                <div class="form-group">
                                    <label for="assignmentTitle" class="form-label">Assignment Title</label>
                                    <input type="text" id="assignmentTitle" name="title" class="form-input" required>
                                </div>
                                <div class="form-group">
                                    <label for="assignmentCourse" class="form-label">Course</label>
                                    <select id="assignmentCourse" name="courseId" class="form-select form-input" required>
                                        <option value="">Select a course</option>
                                        <!-- Courses will be populated by JavaScript -->
                                    </select>
                                </div>
                            </div>
                            <div class="form-group mb-4">
                                <label for="assignmentDescription" class="form-label">Description</label>
                                <textarea id="assignmentDescription" name="description" class="form-input form-textarea" required></textarea>
                            </div>
                            <div class="form-group mb-4">
                                <label for="assignmentInstructions" class="form-label">Instructions</label>
                                <textarea id="assignmentInstructions" name="instructions" class="form-input form-textarea" rows="6"></textarea>
                            </div>
                            <div class="grid grid-cols-2 gap-4 mb-4">
                                <div class="form-group">
                                    <label for="assignmentDueDate" class="form-label">Due Date</label>
                                    <input type="datetime-local" id="assignmentDueDate" name="dueDate" class="form-input" required>
                                </div>
                                <div class="form-group">
                                    <label for="assignmentPoints" class="form-label">Total Points</label>
                                    <input type="number" id="assignmentPoints" name="totalPoints" class="form-input" min="1" required>
                                </div>
                            </div>
                            <button type="submit" class="btn btn-primary">
                                <i class="bi bi-plus-circle"></i>
                                Create Assignment
                            </button>
                        </form>
                    </div>
                </div>
            </c:if>

            <!-- Assignment Filters -->
            <div class="card mb-4">
                <div class="card-content">
                    <div class="flex gap-4 items-center">
                        <div class="flex-1">
                            <input type="text" id="assignmentSearch" class="form-input" 
                                   placeholder="Search assignments...">
                        </div>
                        <div>
                            <select id="statusFilter" class="form-select form-input">
                                <option value="">All Status</option>
                                <option value="not_submitted">Not Submitted</option>
                                <option value="submitted">Submitted</option>
                                <option value="graded">Graded</option>
                            </select>
                        </div>
                        <div>
                            <select id="courseFilter" class="form-select form-input">
                                <option value="">All Courses</option>
                                <!-- Courses will be populated by JavaScript -->
                            </select>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Loading Spinner -->
            <div id="loadingSpinner" class="loading-overlay hidden">
                <div class="loading-spinner"></div>
            </div>

            <!-- Assignments Container -->
            <div id="assignmentsContainer" class="assignment-list">
                <!-- Assignments will be populated by JavaScript -->
            </div>

            <!-- Empty State -->
            <div id="emptyState" class="text-center py-8 hidden">
                <i class="bi bi-clipboard-check text-gray-400" style="font-size: 4rem;"></i>
                <p class="text-gray-500 mt-4">No assignments found.</p>
            </div>
        </div>
    </div>

    <!-- Assignment Submission Modal -->
    <div id="submissionModal" class="modal-overlay hidden">
        <div class="modal-content">
            <div class="modal-header">
                <h2 class="modal-title">Submit Assignment</h2>
                <button class="close-modal" onclick="closeSubmissionModal()">×</button>
            </div>
            <form id="submitAssignmentForm">
                <input type="hidden" id="submissionAssignmentId" name="assignmentId">
                <div class="form-group mb-4">
                    <label for="submissionContent" class="form-label">Assignment Content</label>
                    <textarea id="submissionContent" name="content" class="form-input form-textarea" 
                              rows="8" placeholder="Enter your assignment content here..." required></textarea>
                </div>
                <div class="form-group mb-4">
                    <label for="submissionFile" class="form-label">Attachment (Optional)</label>
                    <input type="file" id="submissionFile" name="submissionFile" class="form-input">
                    <small class="text-gray-500">Supported formats: PDF, DOC, DOCX, TXT (Max 10MB)</small>
                </div>
                <div class="flex gap-4 justify-end">
                    <button type="button" class="btn btn-secondary" onclick="closeSubmissionModal()">
                        Cancel
                    </button>
                    <button type="submit" class="btn btn-primary">
                        <i class="bi bi-check-circle"></i>
                        Submit Assignment
                    </button>
                </div>
            </form>
        </div>
    </div>

    <!-- Grading Modal (Teacher Only) -->
    <div id="gradingModal" class="modal-overlay hidden">
        <div class="modal-content">
            <div class="modal-header">
                <h2 class="modal-title">Grade Assignment</h2>
                <button class="close-modal" onclick="closeGradingModal()">×</button>
            </div>
            <div id="gradingContent">
                <!-- Content will be populated by JavaScript -->
            </div>
        </div>
    </div>

    <!-- Scripts -->
    <script src="${pageContext.request.contextPath}/js/api-service.js"></script>
    <script src="${pageContext.request.contextPath}/js/assignment-manager.js"></script>
    
    <script>
        // Enhanced assignment rendering
        function renderAssignmentCard(assignment) {
            const userRole = getCurrentUserRole();
            const dueDate = new Date(assignment.dueDate);
            const now = new Date();
            const isOverdue = dueDate < now && !assignment.submission;
            const daysTilDue = Math.ceil((dueDate - now) / (1000 * 60 * 60 * 24));
            
            return `
                <div class="assignment-card ${isOverdue ? 'border-red-200' : ''}">
                    <div class="assignment-header mb-4">
                        <div class="flex-1">
                            <h3 class="assignment-title">${assignment.title}</h3>
                            <p class="text-gray-600 mb-2">${assignment.description}</p>
                            <div class="text-sm text-gray-500">
                                <span class="inline-block mr-4">
                                    <i class="bi bi-book"></i> ${assignment.courseName}
                                </span>
                                <span class="inline-block mr-4">
                                    <i class="bi bi-star"></i> ${assignment.totalPoints} points
                                </span>
                                <span class="inline-block ${isOverdue ? 'text-red-600 font-semibold' : daysTilDue <= 3 ? 'text-orange-600' : 'text-gray-500'}">
                                    <i class="bi bi-calendar"></i> 
                                    ${isOverdue ? 'Overdue' : `Due ${dueDate.toLocaleDateString()}`}
                                    ${!isOverdue && daysTilDue <= 7 ? ` (${daysTilDue} days)` : ''}
                                </span>
                            </div>
                        </div>
                        <div class="flex flex-col items-end gap-2">
                            ${getAssignmentStatusBadge(assignment)}
                            <div class="flex gap-2">
                                <button class="btn btn-secondary btn-sm view-assignment" data-assignment-id="${assignment.id}">
                                    <i class="bi bi-eye"></i> View
                                </button>
                                ${getAssignmentActions(assignment, userRole)}
                            </div>
                        </div>
                    </div>
                    ${assignment.submission ? renderSubmissionInfo(assignment.submission) : ''}
                </div>
            `;
        }

        function getAssignmentStatusBadge(assignment) {
            if (assignment.submission) {
                if (assignment.submission.grade !== null) {
                    return `<span class="assignment-status status-graded">
                        Graded: ${assignment.submission.grade}/${assignment.totalPoints}
                    </span>`;
                } else {
                    return `<span class="assignment-status status-submitted">Submitted</span>`;
                }
            } else {
                const dueDate = new Date(assignment.dueDate);
                const isOverdue = dueDate < new Date();
                return `<span class="assignment-status ${isOverdue ? 'bg-red-100 text-red-800' : 'status-pending'}">
                    ${isOverdue ? 'Overdue' : 'Not Submitted'}
                </span>`;
            }
        }

        function getAssignmentActions(assignment, userRole) {
            if (userRole === 'teacher') {
                return `
                    <button class="btn btn-success btn-sm grade-assignment" data-assignment-id="${assignment.id}">
                        <i class="bi bi-check-square"></i> Grade
                    </button>
                    <button class="btn btn-danger btn-sm delete-assignment" data-assignment-id="${assignment.id}">
                        <i class="bi bi-trash"></i> Delete
                    </button>
                `;
            } else if (!assignment.submission) {
                const dueDate = new Date(assignment.dueDate);
                const canSubmit = dueDate > new Date();
                return canSubmit ? `
                    <button class="btn btn-primary btn-sm" onclick="showSubmissionModal('${assignment.id}')">
                        <i class="bi bi-upload"></i> Submit
                    </button>
                ` : '';
            }
            return '';
        }

        function renderSubmissionInfo(submission) {
            return `
                <div class="mt-4 p-4 bg-gray-50 rounded-lg">
                    <h4 class="font-semibold mb-2">Submission Details</h4>
                    <p class="text-sm text-gray-600 mb-2">
                        <strong>Submitted:</strong> ${new Date(submission.submittedAt).toLocaleString()}
                    </p>
                    ${submission.content ? `
                        <p class="text-sm text-gray-600 mb-2">
                            <strong>Content:</strong> ${submission.content.substring(0, 100)}${submission.content.length > 100 ? '...' : ''}
                        </p>
                    ` : ''}
                    ${submission.grade !== null ? `
                        <div class="mt-2">
                            <p class="text-sm text-gray-600">
                                <strong>Grade:</strong> ${submission.grade}/${submission.totalPoints}
                            </p>
                            ${submission.feedback ? `
                                <p class="text-sm text-gray-600">
                                    <strong>Feedback:</strong> ${submission.feedback}
                                </p>
                            ` : ''}
                        </div>
                    ` : ''}
                </div>
            `;
        }

        function showSubmissionModal(assignmentId) {
            document.getElementById('submissionAssignmentId').value = assignmentId;
            document.getElementById('submissionModal').classList.remove('hidden');
        }

        function closeSubmissionModal() {
            document.getElementById('submissionModal').classList.add('hidden');
            document.getElementById('submitAssignmentForm').reset();
        }

        function closeGradingModal() {
            document.getElementById('gradingModal').classList.add('hidden');
        }

        function getCurrentUserRole() {
            return document.body.dataset.userRole || 'student';
        }

        function getCurrentUserId() {
            return document.body.dataset.userId || 1;
        }

        // Initialize when page loads
        document.addEventListener('DOMContentLoaded', function() {
            // Load teacher courses for assignment creation
            if (getCurrentUserRole() === 'teacher') {
                loadTeacherCourses();
            }

            // Override the default assignment rendering
            if (window.assignmentManager) {
                window.assignmentManager.renderAssignments = function() {
                    const container = document.getElementById('assignmentsContainer');
                    const emptyState = document.getElementById('emptyState');
                    
                    if (!container) return;

                    if (this.assignments.length === 0) {
                        container.innerHTML = '';
                        emptyState.classList.remove('hidden');
                        return;
                    }

                    emptyState.classList.add('hidden');
                    container.innerHTML = this.assignments.map(assignment => renderAssignmentCard(assignment)).join('');
                };
            }

            // Add filter functionality
            setupFilters();
        });

        async function loadTeacherCourses() {
            try {
                const courses = await window.api.getCoursesByTeacher(getCurrentUserId());
                const courseSelects = ['assignmentCourse', 'courseFilter'];
                
                courseSelects.forEach(selectId => {
                    const select = document.getElementById(selectId);
                    if (select && selectId === 'assignmentCourse') {
                        select.innerHTML = '<option value="">Select a course</option>' +
                            courses.map(course => `<option value="${course.id}">${course.name}</option>`).join('');
                    } else if (select) {
                        select.innerHTML = '<option value="">All Courses</option>' +
                            courses.map(course => `<option value="${course.id}">${course.name}</option>`).join('');
                    }
                });
            } catch (error) {
                console.error('Failed to load courses:', error);
            }
        }

        function setupFilters() {
            const searchInput = document.getElementById('assignmentSearch');
            const statusFilter = document.getElementById('statusFilter');
            const courseFilter = document.getElementById('courseFilter');

            [searchInput, statusFilter, courseFilter].forEach(element => {
                if (element) {
                    element.addEventListener('change', filterAssignments);
                    if (element === searchInput) {
                        element.addEventListener('input', debounce(filterAssignments, 300));
                    }
                }
            });
        }

        function filterAssignments() {
            if (!window.assignmentManager) return;

            const searchTerm = document.getElementById('assignmentSearch').value.toLowerCase();
            const statusFilter = document.getElementById('statusFilter').value;
            const courseFilter = document.getElementById('courseFilter').value;

            let filtered = window.assignmentManager.assignments.filter(assignment => {
                const matchesSearch = !searchTerm || 
                    assignment.title.toLowerCase().includes(searchTerm) ||
                    assignment.description.toLowerCase().includes(searchTerm) ||
                    assignment.courseName.toLowerCase().includes(searchTerm);

                const matchesStatus = !statusFilter || getAssignmentStatus(assignment) === statusFilter;
                const matchesCourse = !courseFilter || assignment.courseId.toString() === courseFilter;

                return matchesSearch && matchesStatus && matchesCourse;
            });

            window.assignmentManager.assignments = window.assignmentManager.assignments; // Keep original
            window.assignmentManager.renderAssignments.call({assignments: filtered});
        }

        function getAssignmentStatus(assignment) {
            if (assignment.submission) {
                return assignment.submission.grade !== null ? 'graded' : 'submitted';
            }
            return 'not_submitted';
        }

        function debounce(func, wait) {
            let timeout;
            return function executedFunction(...args) {
                const later = () => {
                    clearTimeout(timeout);
                    func(...args);
                };
                clearTimeout(timeout);
                timeout = setTimeout(later, wait);
            };
        }
    </script>
</body>
</html>
