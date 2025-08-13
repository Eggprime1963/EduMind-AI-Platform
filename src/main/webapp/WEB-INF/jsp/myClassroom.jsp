<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
    <meta charset="UTF-8">
    <title>My Classroom</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/classroom.css"/>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>
    <jsp:include page="navbar.jsp" />
    <div class="container-fluid mt-4">
        <div class="row">
            <!-- Sidebar -->
            <div class="col-md-3">
                <div class="card p-3">
                    <h5 class="mb-3">Navigation</h5>
                    <ul class="nav flex-column">
                        <li class="nav-item"><a class="nav-link ${section == 'courses' ? 'active' : ''}" href="?section=courses">Courses</a></li>
                        <li class="nav-item"><a class="nav-link ${section == 'assignments' ? 'active' : ''}" href="?section=assignments">Assignments</a></li>
                        <li class="nav-item"><a class="nav-link ${section == 'lectures' ? 'active' : ''}" href="?section=lectures">Lectures</a></li>
                    </ul>
                </div>
            </div>
            <!-- Main Content -->
            <div class="col-md-9">
                <h2 class="mb-4">My ${section == 'courses' ? 'Courses' : section == 'assignments' ? 'Assignments' : 'Lectures'}</h2>
                
                <!-- Success/Error Messages -->
                <c:if test="${not empty param.success}">
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        ${param.success}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>
                <c:if test="${not empty param.error}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        ${param.error}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>
                
                <c:if test="${canCrud}">
                    <button class="btn btn-primary mb-3" data-bs-toggle="modal" data-bs-target="#addModal">
                        Add ${section == 'courses' ? 'Course' : section == 'assignments' ? 'Assignment' : 'Lecture'}
                    </button>
                </c:if>
                <c:if test="${section != 'courses'}">
                    <form method="get" action="myClassroom" class="mb-3">
                        <input type="hidden" name="section" value="${section}">
                        <label for="courseSelect" class="form-label">Choose Course:</label>
                        <select name="courseId" id="courseSelect" class="form-select" onchange="this.form.submit()">
                            <c:forEach var="c" items="${courses}">
                                <option value="${c.idCourse}" <c:if test="${selectedCourse != null && selectedCourse.idCourse == c.idCourse}">selected</c:if>>
                                    ${c.name}
                                </option>
                            </c:forEach>
                        </select>
                    </form>
                </c:if>
                <div class="row g-4">
                    <c:choose>
                        <c:when test="${section == 'courses'}">
                            <c:forEach var="c" items="${courses}">
                                <div class="col-md-6 col-lg-4">
                                    <div class="card h-100 shadow-sm rounded-4">
                                        <img src="${pageContext.request.contextPath}/${c.image}" class="card-img-top rounded-top-4" alt="Course Thumbnail" style="height:180px;object-fit:cover;">
                                        <div class="card-body d-flex flex-column">
                                            <h5 class="card-title">${c.name}</h5>
                                            <p class="card-text">${c.description}</p>
                                            <div class="mt-auto">
                                                <div class="d-flex flex-column gap-2">
                                                    <!-- Navigation Buttons -->
                                                    <a href="${pageContext.request.contextPath}/lectures?courseId=${c.idCourse}" class="btn btn-primary btn-sm">
                                                        <i class="bi bi-play-circle me-1"></i>View Lectures
                                                    </a>
                                                    <a href="${pageContext.request.contextPath}/myClassroom?section=assignments&courseId=${c.idCourse}" class="btn btn-info btn-sm">
                                                        <i class="bi bi-file-text me-1"></i>View Assignments
                                                    </a>
                                                    <a href="${pageContext.request.contextPath}/course?courseId=${c.idCourse}" class="btn btn-success btn-sm">
                                                        <i class="bi bi-book me-1"></i>Course Details
                                                    </a>
                                                    
                                                    <!-- Admin Controls -->
                                                    <c:if test="${canCrud}">
                                                        <div class="border-top pt-2 mt-2">
                                                            <button class="btn btn-warning btn-sm mb-1 w-100" onclick="openEditModal('${c.idCourse}', '${c.name}', '${c.description}')">
                                                                <i class="bi bi-pencil me-1"></i>Edit Course
                                                            </button>
                                                            <form action="${pageContext.request.contextPath}/courses" method="post" style="display:inline;">
                                                                <input type="hidden" name="action" value="delete">
                                                                <input type="hidden" name="courseId" value="${c.idCourse}">
                                                                <button type="submit" class="btn btn-danger btn-sm w-100" onclick="return confirm('Are you sure?')">
                                                                    <i class="bi bi-trash me-1"></i>Delete Course
                                                                </button>
                                                            </form>
                                                        </div>
                                                    </c:if>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:when test="${section == 'assignments'}">
                            <c:forEach var="a" items="${assignments}">
                                <div class="col-md-6 col-lg-4">
                                    <div class="card h-100 shadow-sm rounded-4 ${a.deadlineExceeded ? 'border-danger' : ''}">
                                        <img src="${pageContext.request.contextPath}/img/assignment.png" class="card-img-top rounded-top-4" alt="Assignment" style="height:180px;object-fit:cover;">
                                        <div class="card-body d-flex flex-column">
                                            <h5 class="card-title">${a.title}</h5>
                                            <div class="card-text">
                                                <p><strong>Due:</strong> 
                                                    <span class="${a.deadlineStatusClass}">
                                                        ${a.formattedDueDate}
                                                    </span>
                                                </p>
                                                <p><strong>Time Remaining:</strong> 
                                                    <span class="${a.deadlineStatusClass}">
                                                        ${a.timeRemaining}
                                                    </span>
                                                </p>
                                                <p><strong>Status:</strong> 
                                                    <span class="badge ${a.status == 'ended' ? 'bg-secondary' : a.status == 'in progress' ? 'bg-warning' : 'bg-info'}">
                                                        ${a.status}
                                                    </span>
                                                </p>
                                                <c:if test="${a.deadlineExceeded}">
                                                    <div class="alert alert-danger py-2 mt-2" role="alert">
                                                        <i class="bi bi-exclamation-triangle-fill me-1"></i>
                                                        <strong>Deadline Exceeded!</strong>
                                                    </div>
                                                </c:if>
                                            </div>
                                            <div class="mt-auto">
                                                <c:if test="${!canCrud}">
                                                    <!-- Student actions -->
                                                    <c:choose>
                                                        <c:when test="${a.deadlineExceeded}">
                                                            <button class="btn btn-secondary btn-sm w-100 mb-2" disabled>
                                                                <i class="bi bi-clock-history me-1"></i>Submission Closed
                                                            </button>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <a href="${pageContext.request.contextPath}/assignment?id=${a.id}" class="btn btn-primary btn-sm w-100 mb-2">
                                                                <i class="bi bi-pencil-square me-1"></i>Submit Assignment
                                                            </a>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </c:if>
                                                <c:if test="${canCrud}">
                                                    <!-- Teacher actions -->
                                                    <button class="btn btn-warning btn-sm mb-2 w-100" onclick="openEditAssignmentModal('${a.id}', '${a.title}', '${a.dueDate}', '${a.status}')">
                                                        <i class="bi bi-pencil me-1"></i>Edit
                                                    </button>
                                                    <form action="${pageContext.request.contextPath}/assignments" method="post" style="display:inline;" class="w-100">
                                                        <input type="hidden" name="action" value="delete">
                                                        <input type="hidden" name="assignmentId" value="${a.id}">
                                                        <button type="submit" class="btn btn-danger btn-sm w-100" onclick="return confirm('Are you sure?')">
                                                            <i class="bi bi-trash me-1"></i>Delete
                                                        </button>
                                                    </form>
                                                </c:if>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="l" items="${lectures}">
                                <div class="col-md-6 col-lg-4">
                                    <div class="card h-100 shadow-sm rounded-4">
                                        <img src="${pageContext.request.contextPath}/img/lecture.png" class="card-img-top rounded-top-4" alt="Lecture" style="height:180px;object-fit:cover;">
                                        <div class="card-body d-flex flex-column">
                                            <h5 class="card-title">${l.title}</h5>
                                            <p class="card-text">Video: <a href="${l.videoUrl}" target="_blank">${l.videoUrl}</a></p>
                                            <div class="mt-auto">
                                                <c:if test="${canCrud}">
                                                    <!-- Add edit/delete buttons as needed -->
                                                    <button class="btn btn-warning btn-sm mb-2" onclick="openEditLectureModal('${l.id}', '${l.title}', '${l.videoUrl}')">Edit</button>
                                                    <form action="${pageContext.request.contextPath}/lectures" method="post" style="display:inline;">
                                                        <input type="hidden" name="action" value="delete">
                                                        <input type="hidden" name="lectureId" value="${l.id}">
                                                        <button type="submit" class="btn btn-danger btn-sm" onclick="return confirm('Are you sure?')">Delete</button>
                                                    </form>
                                                </c:if>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </div>
                <!-- Added section for course buttons -->
            </div>
        </div>
    </div>

    <!-- Add Modal (fixed for all sections) -->
    <div class="modal fade" id="addModal" tabindex="-1" aria-labelledby="addModalLabel" aria-hidden="true">
      <div class="modal-dialog">
        <form action="${pageContext.request.contextPath}/${section}" method="post" class="modal-content">
            <input type="hidden" name="action" value="create">
            <c:if test="${section != 'courses' && selectedCourse != null}">
                <input type="hidden" name="courseId" value="${selectedCourse.idCourse}">
            </c:if>
            <div class="modal-header">
                <h5 class="modal-title" id="addModalLabel">Add ${section == 'courses' ? 'Course' : section == 'assignments' ? 'Assignment' : 'Lecture'}</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <c:choose>
                    <c:when test="${section == 'courses'}">
                        <div class="mb-3">
                            <label>Course Name</label>
                            <input type="text" class="form-control" name="name" required>
                        </div>
                        <div class="mb-3">
                            <label>Description</label>
                            <textarea class="form-control" name="description" required></textarea>
                        </div>
                        <div class="mb-3">
                            <label>Thumbnail URL</label>
                            <input type="text" class="form-control" name="thumbnail" placeholder="Leave empty for default image">
                        </div>
                    </c:when>
                    <c:when test="${section == 'assignments'}">
                        <div class="mb-3">
                            <label>Title</label>
                            <input type="text" class="form-control" name="title" required>
                        </div>
                        <div class="mb-3">
                            <label>Due Date</label>
                            <input type="datetime-local" class="form-control" name="dueDate" required>
                        </div>
                        <div class="mb-3">
                            <label>Status</label>
                            <select class="form-control" name="status">
                                <option value="not yet">Not Yet</option>
                                <option value="in progress">In Progress</option>
                                <option value="ended">Ended</option>
                            </select>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="mb-3">
                            <label>Title</label>
                            <input type="text" class="form-control" name="title" required>
                        </div>
                        <div class="mb-3">
                            <label>Video URL</label>
                            <input type="url" class="form-control" name="videoUrl" required placeholder="https://...">
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
            <div class="modal-footer">
                <button type="submit" class="btn btn-success">Save</button>
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
            </div>
        </form>
      </div>
    </div>

    <!-- Edit Modal -->
    <div class="modal fade" id="editModal" tabindex="-1" aria-labelledby="editModalLabel" aria-hidden="true">
      <div class="modal-dialog">
        <form action="${pageContext.request.contextPath}/courses" method="post" class="modal-content">
            <input type="hidden" name="action" value="update">
            <input type="hidden" name="courseId" id="editId">
            <div class="modal-header">
                <h5 class="modal-title" id="editModalLabel">Edit Course</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <div class="mb-3">
                    <label>Course Name</label>
                    <input type="text" class="form-control" name="name" id="editName" required>
                </div>
                <div class="mb-3">
                    <label>Description</label>
                    <textarea class="form-control" name="description" id="editDescription" required></textarea>
                </div>
                <div class="mb-3">
                    <label>Thumbnail URL</label>
                    <input type="text" class="form-control" name="thumbnail" id="editThumbnail">
                </div>
            </div>
            <div class="modal-footer">
                <button type="submit" class="btn btn-warning">Update Course</button>
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
            </div>
        </form>
      </div>
    </div>

    <!-- Edit Assignment Modal -->
    <div class="modal fade" id="editAssignmentModal" tabindex="-1" aria-labelledby="editAssignmentModalLabel" aria-hidden="true">
      <div class="modal-dialog">
        <form action="${pageContext.request.contextPath}/assignments" method="post" class="modal-content">
            <input type="hidden" name="action" value="update">
            <input type="hidden" name="assignmentId" id="editAssignmentId">
            <div class="modal-header">
                <h5 class="modal-title" id="editAssignmentModalLabel">Edit Assignment</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <div class="mb-3">
                    <label>Title</label>
                    <input type="text" class="form-control" name="title" id="editAssignmentTitle" required>
                </div>
                <div class="mb-3">
                    <label>Due Date</label>
                    <input type="datetime-local" class="form-control" name="dueDate" id="editAssignmentDueDate" required>
                </div>
                <div class="mb-3">
                    <label>Status</label>
                    <select class="form-control" name="status" id="editAssignmentStatus">
                        <option value="not yet">Not Yet</option>
                        <option value="in progress">In Progress</option>
                        <option value="ended">Ended</option>
                    </select>
                </div>
            </div>
            <div class="modal-footer">
                <button type="submit" class="btn btn-warning">Update Assignment</button>
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
            </div>
        </form>
      </div>
    </div>

    <!-- Edit Lecture Modal -->
    <div class="modal fade" id="editLectureModal" tabindex="-1" aria-labelledby="editLectureModalLabel" aria-hidden="true">
      <div class="modal-dialog">
        <form action="${pageContext.request.contextPath}/lectures" method="post" class="modal-content">
            <input type="hidden" name="action" value="update">
            <input type="hidden" name="lectureId" id="editLectureId">
            <div class="modal-header">
                <h5 class="modal-title" id="editLectureModalLabel">Edit Lecture</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <div class="mb-3">
                    <label>Title</label>
                    <input type="text" class="form-control" name="title" id="editLectureTitle" required>
                </div>
                <div class="mb-3">
                    <label>Video URL</label>
                    <input type="text" class="form-control" name="videoUrl" id="editLectureVideoUrl" required>
                </div>
            </div>
            <div class="modal-footer">
                <button type="submit" class="btn btn-warning">Update Lecture</button>
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
            </div>
        </form>
      </div>
    </div>

    <script>
    function openEditModal(id, name, description) {
        document.getElementById('editId').value = id;
        document.getElementById('editName').value = name;
        document.getElementById('editDescription').value = description;
        new bootstrap.Modal(document.getElementById('editModal')).show();
    }
    
    function openEditAssignmentModal(id, title, dueDate, status) {
        document.getElementById('editAssignmentId').value = id;
        document.getElementById('editAssignmentTitle').value = title;
        document.getElementById('editAssignmentDueDate').value = dueDate;
        document.getElementById('editAssignmentStatus').value = status;
        new bootstrap.Modal(document.getElementById('editAssignmentModal')).show();
    }
    
    function openEditLectureModal(id, title, videoUrl) {
        document.getElementById('editLectureId').value = id;
        document.getElementById('editLectureTitle').value = title;
        document.getElementById('editLectureVideoUrl').value = videoUrl;
        new bootstrap.Modal(document.getElementById('editLectureModal')).show();
    }
    
    // Validate due dates to prevent past dates
    function validateDueDate(input) {
        const selectedDate = new Date(input.value);
        const now = new Date();
        
        if (selectedDate <= now) {
            alert('Due date cannot be in the past. Please select a future date and time.');
            input.value = '';
            return false;
        }
        return true;
    }
    
    // Add event listeners for due date validation
    document.addEventListener('DOMContentLoaded', function() {
        const dueDateInputs = document.querySelectorAll('input[name="dueDate"]');
        dueDateInputs.forEach(function(input) {
            input.addEventListener('change', function() {
                validateDueDate(this);
            });
            
            // Set minimum date to current date and time
            const now = new Date();
            const year = now.getFullYear();
            const month = String(now.getMonth() + 1).padStart(2, '0');
            const day = String(now.getDate()).padStart(2, '0');
            const hours = String(now.getHours()).padStart(2, '0');
            const minutes = String(now.getMinutes()).padStart(2, '0');
            const minDateTime = `${year}-${month}-${day}T${hours}:${minutes}`;
            input.setAttribute('min', minDateTime);
        });
        
        // Validate form submission
        const forms = document.querySelectorAll('form');
        forms.forEach(function(form) {
            form.addEventListener('submit', function(e) {
                const dueDateInput = this.querySelector('input[name="dueDate"]');
                if (dueDateInput && !validateDueDate(dueDateInput)) {
                    e.preventDefault();
                }
            });
        });
    });
    </script>
</body>
</html>
