
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Student List</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/studentList.css"/>
    <style>
        .container {
            max-width: 1200px;
            margin: 2.5rem auto;
            padding: 2rem;
        }
        .course-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1rem;
            flex-wrap: wrap;
            gap: 1rem;
        }
        .course-info {
            flex: 1;
            min-width: 0;
        }
        .toggle-button {
            background: linear-gradient(45deg, #2c5282, #63b3ed);
            color: #fff;
            border: none;
            padding: 0.5rem 1rem;
            border-radius: 5px;
            cursor: pointer;
            transition: background 0.3s ease;
            white-space: nowrap;
        }
        [data-theme="dark"] .toggle-button {
            background: linear-gradient(45deg, #63b3ed, #90cdf4);
        }
        .toggle-button:hover {
            background: linear-gradient(45deg, #1a4066, #4c8dd1);
        }
        [data-theme="dark"] .toggle-button:hover {
            background: linear-gradient(45deg, #4c8dd1, #7ab8e6);
        }
        .student-list {
            display: none;
        }
        .student-list.active {
            display: table;
        }
        .status-badge {
            padding: 0.25rem 0.5rem;
            border-radius: 0.25rem;
            font-size: 0.75rem;
            font-weight: bold;
            text-transform: uppercase;
        }
        .status-active {
            background-color: #d4edda;
            color: #155724;
        }
        .status-inactive {
            background-color: #f8d7da;
            color: #721c24;
        }
        .status-pending {
            background-color: #fff3cd;
            color: #856404;
        }
        .alert {
            padding: 1rem;
            margin-bottom: 1rem;
            border: 1px solid transparent;
            border-radius: 0.375rem;
        }
        .alert-info {
            color: #0c5460;
            background-color: #d1ecf1;
            border-color: #b8daff;
        }
        .alert-primary {
            color: #084298;
            background-color: #cfe2ff;
            border-color: #b6d4fe;
        }
        .card {
            border: 1px solid rgba(0,0,0,.125);
            border-radius: 0.375rem;
            background-color: #fff;
            box-shadow: 0 0.125rem 0.25rem rgba(0,0,0,.075);
        }
        .card-body {
            padding: 1rem;
        }
        .card-title {
            margin-bottom: 0.5rem;
            font-size: 1.25rem;
        }
        .card-text {
            margin-bottom: 0.75rem;
        }
        .btn {
            display: inline-block;
            padding: 0.375rem 0.75rem;
            margin-bottom: 0;
            font-size: 1rem;
            font-weight: 400;
            line-height: 1.5;
            text-align: center;
            text-decoration: none;
            vertical-align: middle;
            cursor: pointer;
            border: 1px solid transparent;
            border-radius: 0.375rem;
            transition: all 0.15s ease-in-out;
        }
        .btn-primary {
            color: #fff;
            background-color: #0d6efd;
            border-color: #0d6efd;
        }
        .btn-primary:hover {
            background-color: #0b5ed7;
            border-color: #0a58ca;
        }
        .btn-warning {
            color: #000;
            background-color: #ffc107;
            border-color: #ffc107;
        }
        .btn-warning:hover {
            background-color: #ffcd39;
            border-color: #ffc720;
        }
        .btn-sm {
            padding: 0.25rem 0.5rem;
            font-size: 0.875rem;
            border-radius: 0.2rem;
        }
        .row {
            display: flex;
            flex-wrap: wrap;
            margin: 0 -0.75rem;
        }
        .col-md-6, .col-lg-4 {
            flex: 0 0 auto;
            padding: 0 0.75rem;
        }
        .col-md-6 {
            width: 50%;
        }
        .col-lg-4 {
            width: 33.333333%;
        }
        .mb-3 {
            margin-bottom: 1rem;
        }
        .text-muted {
            color: #6c757d;
        }
        @media (max-width: 768px) {
            .course-header {
                flex-direction: column;
                align-items: flex-start;
            }
            .toggle-button {
                align-self: flex-end;
            }
            .col-md-6, .col-lg-4 {
                width: 100%;
            }
        }
    </style>
</head>
<body>
     <jsp:include page="navbar.jsp" />
    <div class="container">
        <h2>Student List for My Courses</h2>

        <c:if test="${not empty error}">
            <p style="color: red;">Error: ${error}</p>
        </c:if>

        <form method="get" action="studentList" class="mb-3">
            <input type="hidden" name="section" value="${section}">
            <label for="courseSelect" class="form-label">Choose Course:</label>
            <select name="courseId" id="courseSelect" class="form-select" onchange="handleCourseSelection()">
                <option value="">-- Select a Course --</option>
                <c:forEach var="c" items="${courses}">
                    <option value="${c.idCourse}" <c:if test="${selectedCourse != null && selectedCourse.idCourse == c.idCourse}">selected</c:if>>
                        ${c.name}
                    </option>
                </c:forEach>
            </select>
        </form>

        <!-- Display selected course details and students -->
        <c:if test="${selectedCourse != null}">
            <div class="course-header">
                <div class="course-info">
                    <h3>Course: ${selectedCourse.name}</h3>
                    <p>Description: ${selectedCourse.description}</p>
                    <p>Total Students: <span id="studentCount">${selectedCourse.enrollments.size()}</span></p>
                </div>
                <c:if test="${not empty selectedCourse.enrollments}">
                    <button class="toggle-button" onclick="toggleStudentList('selected-course-students')">View Student List</button>
                </c:if>
            </div>

            <c:if test="${not empty selectedCourse.enrollments}">
                <table class="table student-list" id="selected-course-students">
                    <thead>
                        <tr>
                            <th>Student ID</th>
                            <th>Full Name</th>
                            <th>Email</th>
                            <th>Date of Birth</th>
                            <th>Gender</th>
                            <th>Address</th>
                            <th>Phone</th>
                            <th>School</th>
                            <th>Enrollment Date</th>
                            <th>Status</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="enrollment" items="${selectedCourse.enrollments}">
                            <tr>
                                <td>${enrollment.student.id}</td>
                                <td>${enrollment.student.firstName} ${enrollment.student.lastName}</td>
                                <td>${enrollment.student.email}</td>
                                <td><fmt:formatDate value="${enrollment.student.dateOfBirth}" pattern="yyyy-MM-dd"/></td>
                                <td>${enrollment.student.gender}</td>
                                <td>${enrollment.student.address}</td>
                                <td>${enrollment.student.phoneNumber}</td>
                                <td>${enrollment.student.school}</td>
                                <td>${enrollment.formattedEnrollmentDate}</td>
                                <td>
                                    <span class="status-badge status-${enrollment.status.toLowerCase()}">${enrollment.status}</span>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:if>

            <c:if test="${empty selectedCourse.enrollments}">
                <div class="alert alert-info">
                    <h4>No Students Enrolled</h4>
                    <p>This course currently has no students enrolled. Students can enroll through the course catalog.</p>
                </div>
            </c:if>
        </c:if>

        <!-- Show all courses overview when no specific course is selected -->
        <c:if test="${selectedCourse == null && not empty courses}">
            <div class="alert alert-primary">
                <h4>Course Overview</h4>
                <p>Select a course from the dropdown above to view detailed student information.</p>
            </div>
            
            <div class="row">
                <c:forEach var="course" items="${courses}" varStatus="loop">
                    <div class="col-md-6 col-lg-4 mb-3">
                        <div class="card">
                            <div class="card-body">
                                <h5 class="card-title">${course.name}</h5>
                                <p class="card-text">${course.description}</p>
                                <p class="card-text">
                                    <small class="text-muted">
                                        Students: ${course.enrollments.size()}
                                    </small>
                                </p>
                                <button class="btn btn-primary btn-sm" onclick="selectCourse('${course.idCourse}')">
                                    View Students
                                </button>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:if>

        <c:if test="${empty courses}">
            <p>No courses found for you. Please add or select a course.</p>
        </c:if>
    </div>

    <script>
        function handleCourseSelection() {
            const select = document.getElementById('courseSelect');
            const selectedCourseId = select.value;
            
            if (selectedCourseId) {
                // Submit the form to load the selected course
                const form = select.closest('form');
                form.submit();
            }
        }
        
        function selectCourse(courseId) {
            const select = document.getElementById('courseSelect');
            select.value = courseId;
            handleCourseSelection();
        }
        
        function toggleStudentList(tableId) {
            const table = document.getElementById(tableId);
            const button = table.previousElementSibling.querySelector('.toggle-button') || 
                          table.previousElementSibling.previousElementSibling.querySelector('.toggle-button');
            
            if (table.classList.contains('active')) {
                table.classList.remove('active');
                button.textContent = 'View Student List';
            } else {
                table.classList.add('active');
                button.textContent = 'Hide Student List';
            }
        }
        
        function viewStudentDetails(studentId) {
            // Redirect to student details page
            window.location.href = '${pageContext.request.contextPath}/student-details?id=' + studentId;
        }
        
        function updateEnrollmentStatus(enrollmentId, currentStatus) {
            const newStatus = prompt('Enter new status (ACTIVE, INACTIVE, PENDING):', currentStatus);
            if (newStatus && newStatus !== currentStatus) {
                // Send AJAX request to update status
                fetch('${pageContext.request.contextPath}/update-enrollment-status', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                    },
                    body: JSON.stringify({
                        enrollmentId: enrollmentId,
                        status: newStatus.toUpperCase()
                    })
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        alert('Status updated successfully!');
                        location.reload(); // Refresh the page to show updated status
                    } else {
                        alert('Error updating status: ' + data.message);
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('Error updating status. Please try again.');
                });
            }
        }
        
        // Auto-expand student list if a course is selected
        document.addEventListener('DOMContentLoaded', function() {
            const selectedTable = document.getElementById('selected-course-students');
            if (selectedTable) {
                selectedTable.classList.add('active');
                const button = selectedTable.previousElementSibling.querySelector('.toggle-button');
                if (button) {
                    button.textContent = 'Hide Student List';
                }
            }
        });
    </script>
</body>
</html>
```