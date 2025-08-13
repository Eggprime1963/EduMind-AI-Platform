<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>${assignment.title} - Assignment Details</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>
<jsp:include page="navbar.jsp" />
<div class="container-fluid mt-4">
    <div class="row">
        <!-- Sidebar: Navigation -->
        <div class="col-md-3 border-end">
            <h5 class="mt-4"><strong>Course: ${assignment.courseName}</strong></h5>
            <c:if test="${not empty assignment.lectureTitle}">
                <div class="mb-2">Lecture: ${assignment.lectureTitle}</div>
            </c:if>
            <hr>
            <div class="nav flex-column">
                <a href="${pageContext.request.contextPath}/myClassroom?section=assignments&courseId=${assignment.idCourse}" class="nav-link">
                    <i class="bi bi-arrow-left me-1"></i>Back to Assignments
                </a>
            </div>
        </div>
        
        <!-- Main Content: Assignment Details -->
        <div class="col-md-9">
            <!-- Assignment Header -->
            <div class="d-flex justify-content-between align-items-start mb-4">
                <h1 class="fw-bold">${assignment.title}</h1>
                <span class="badge ${assignment.status == 'ended' ? 'bg-secondary' : assignment.status == 'in progress' ? 'bg-warning' : 'bg-info'} fs-6">
                    ${assignment.status}
                </span>
            </div>
            
            <!-- Deadline Status Alert -->
            <c:if test="${assignment.deadlineExceeded}">
                <div class="alert alert-danger d-flex align-items-center mb-4" role="alert">
                    <i class="bi bi-exclamation-triangle-fill me-2"></i>
                    <div>
                        <strong>Deadline Exceeded!</strong> This assignment is no longer accepting submissions.
                        <br>The deadline was: <strong>${assignment.formattedDueDate}</strong>
                    </div>
                </div>
            </c:if>
            
            <c:if test="${!assignment.deadlineExceeded}">
                <div class="alert ${assignment.deadlineStatusClass == 'text-warning fw-bold' ? 'alert-warning' : 'alert-info'} d-flex align-items-center mb-4" role="alert">
                    <i class="bi bi-clock me-2"></i>
                    <div>
                        <strong>Due:</strong> ${assignment.formattedDueDate}
                        <br><strong>Time remaining:</strong> ${assignment.timeRemaining}
                    </div>
                </div>
            </c:if>
            
            <!-- Assignment Content -->
            <div class="mb-4">
                <h4><strong>Assignment Description</strong></h4>
                <div class="border rounded p-3 bg-light">
                    <c:choose>
                        <c:when test="${not empty assignment.description}">
                            ${assignment.description}
                        </c:when>
                        <c:otherwise>
                            <em>No description provided for this assignment.</em>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
            
            <!-- Action Buttons -->
            <div class="d-flex justify-content-between mt-5">
                <c:choose>
                    <c:when test="${assignment.deadlineExceeded}">
                        <button type="button" class="btn btn-secondary btn-lg" disabled>
                            <i class="bi bi-clock-history me-2"></i>Submission Closed
                        </button>
                        <small class="text-muted align-self-center">
                            Submissions are no longer accepted for this assignment.
                        </small>
                    </c:when>
                    <c:otherwise>
                        <form method="post" action="${pageContext.request.contextPath}/assignments/submit" onsubmit="return confirmSubmission()">
                            <input type="hidden" name="assignmentId" value="${assignment.id}">
                            <button type="submit" class="btn ${assignment.submitted ? 'btn-success' : 'btn-primary'} btn-lg">
                                <c:choose>
                                    <c:when test="${assignment.submitted}">
                                        <i class="bi bi-check-circle me-2"></i>Resubmit Assignment
                                    </c:when>
                                    <c:otherwise>
                                        <i class="bi bi-upload me-2"></i>Submit Assignment
                                    </c:otherwise>
                                </c:choose>
                            </button>
                        </form>
                        
                        <c:if test="${assignment.graded}">
                            <div class="text-end">
                                <div class="badge bg-success fs-6 mb-2">Score: ${assignment.score}/100</div>
                                <br>
                                <a href="${pageContext.request.contextPath}/continue?assignmentId=${assignment.id}" class="btn btn-outline-success">
                                    <i class="bi bi-arrow-right me-1"></i>Continue to Next
                                </a>
                            </div>
                        </c:if>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</div>

<script>
// Set variables from JSP
var assignmentDeadlineExceeded = <c:out value="${assignment.deadlineExceeded}" default="false"/>;
var assignmentTimeRemaining = "<c:out value='${assignment.timeRemaining}' escapeXml='true'/>";

function confirmSubmission() {
    if (assignmentDeadlineExceeded) {
        alert('Cannot submit: The deadline for this assignment has passed.');
        return false;
    }
    
    if (assignmentTimeRemaining.includes('hour(s) remaining')) {
        const hours = parseInt(assignmentTimeRemaining.match(/\d+/)[0]);
        if (hours <= 1) {
            return confirm('Warning: Less than 1 hour remaining! Are you sure you want to submit now?');
        }
    }
    
    return confirm('Are you sure you want to submit this assignment?');
}

// Auto-refresh page every 5 minutes to update time remaining
setTimeout(function() {
    if (!assignmentDeadlineExceeded) {
        location.reload();
    }
}, 300000); // 5 minutes
</script>
</body>
</html>