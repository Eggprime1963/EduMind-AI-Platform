<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Browse Courses - Learning Platform</title>
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
                <h1 class="page-title">Browse Courses</h1>
                <p class="page-subtitle">Discover amazing courses and expand your knowledge</p>
            </div>

            <!-- Search and Filter Section -->
            <div class="card mb-4">
                <div class="card-content">
                    <div class="flex gap-4 items-center">
                        <div class="flex-1">
                            <input type="text" id="courseSearch" class="form-input" 
                                   placeholder="Search courses by name, description, or instructor...">
                        </div>
                        <div>
                            <select id="categoryFilter" class="form-select form-input">
                                <option value="">All Categories</option>
                                <option value="programming">Programming</option>
                                <option value="design">Design</option>
                                <option value="business">Business</option>
                                <option value="marketing">Marketing</option>
                                <option value="science">Science</option>
                            </select>
                        </div>
                        <div>
                            <select id="sortFilter" class="form-select form-input">
                                <option value="name">Sort by Name</option>
                                <option value="date">Sort by Date</option>
                                <option value="price">Sort by Price</option>
                                <option value="rating">Sort by Rating</option>
                            </select>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Course Creation (Teacher Only) -->
            <c:if test="${sessionScope.userRole == 'teacher'}">
                <div class="card mb-4">
                    <div class="card-header">
                        <h2 class="card-title">Create New Course</h2>
                    </div>
                    <div class="card-content">
                        <form id="addCourseForm" class="space-y-4">
                            <div class="form-group">
                                <label for="courseName" class="form-label">Course Name</label>
                                <input type="text" id="courseName" name="name" class="form-input" required>
                            </div>
                            <div class="form-group">
                                <label for="courseDescription" class="form-label">Description</label>
                                <textarea id="courseDescription" name="description" class="form-input form-textarea" required></textarea>
                            </div>
                            <div class="flex gap-4">
                                <div class="form-group flex-1">
                                    <label for="coursePrice" class="form-label">Price ($)</label>
                                    <input type="number" id="coursePrice" name="price" class="form-input" min="0" step="0.01">
                                </div>
                                <div class="form-group flex-1">
                                    <label for="courseCategory" class="form-label">Category</label>
                                    <select id="courseCategory" name="category" class="form-select form-input">
                                        <option value="programming">Programming</option>
                                        <option value="design">Design</option>
                                        <option value="business">Business</option>
                                        <option value="marketing">Marketing</option>
                                        <option value="science">Science</option>
                                    </select>
                                </div>
                            </div>
                            <button type="submit" class="btn btn-primary">
                                <i class="bi bi-plus-circle"></i>
                                Create Course
                            </button>
                        </form>
                    </div>
                </div>
            </c:if>

            <!-- Loading Spinner -->
            <div id="loadingSpinner" class="loading-overlay hidden">
                <div class="loading-spinner"></div>
            </div>

            <!-- Courses Grid -->
            <div id="coursesContainer" class="courses-grid">
                <!-- Courses will be populated by JavaScript -->
            </div>

            <!-- Empty State -->
            <div id="emptyState" class="text-center py-8 hidden">
                <i class="bi bi-book text-gray-400" style="font-size: 4rem;"></i>
                <p class="text-gray-500 mt-4">No courses found. Try adjusting your search criteria.</p>
            </div>
        </div>
    </div>

    <!-- Enrollment Modal -->
    <div id="enrollmentModal" class="modal-overlay hidden">
        <div class="modal-content">
            <div class="modal-header">
                <h2 class="modal-title">Course Enrollment</h2>
                <button class="close-modal" onclick="closeEnrollmentModal()">×</button>
            </div>
            <div id="enrollmentContent">
                <!-- Content will be populated by JavaScript -->
            </div>
        </div>
    </div>

    <!-- Scripts -->
    <script src="${pageContext.request.contextPath}/js/api-service.js"></script>
    <script src="${pageContext.request.contextPath}/js/course-manager.js"></script>
    <script src="${pageContext.request.contextPath}/js/payment-manager.js"></script>
    
    <script>
        // Enhanced course rendering with enrollment functionality
        function renderCourseCard(course) {
            const userRole = getCurrentUserRole();
            const isEnrolled = course.isEnrolled || false;
            
            return `
                <div class="course-card" data-course-id="${course.id}">
                    <div class="course-thumbnail">
                        <i class="bi bi-book" style="font-size: 3rem;"></i>
                    </div>
                    <div class="course-info">
                        <h3 class="course-title">${course.name}</h3>
                        <p class="course-description">${course.description}</p>
                        <div class="course-meta">
                            <span><i class="bi bi-person"></i> ${course.instructor || 'Instructor'}</span>
                            <span><i class="bi bi-calendar"></i> ${new Date(course.createdAt).toLocaleDateString()}</span>
                        </div>
                        <div class="flex justify-between items-center mt-4">
                            <div class="course-price">
                                ${course.price == 0 ? 'Free' : '$' + course.price}
                            </div>
                            <div class="flex gap-2">
                                ${userRole === 'teacher' && course.teacherId == getCurrentUserId() ? `
                                    <button class="btn btn-secondary btn-sm" onclick="editCourse('${course.id}')">
                                        <i class="bi bi-pencil"></i> Edit
                                    </button>
                                    <button class="btn btn-danger btn-sm" onclick="deleteCourse('${course.id}')">
                                        <i class="bi bi-trash"></i> Delete
                                    </button>
                                ` : isEnrolled ? `
                                    <button class="btn btn-success btn-sm" onclick="viewCourse('${course.id}')">
                                        <i class="bi bi-play-circle"></i> Continue
                                    </button>
                                ` : `
                                    <button class="btn btn-primary btn-sm enroll-course" data-course-id="${course.id}">
                                        <i class="bi bi-plus-circle"></i> Enroll
                                    </button>
                                `}
                                <button class="btn btn-secondary btn-sm" onclick="viewCourseDetails('${course.id}')">
                                    <i class="bi bi-eye"></i> Details
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            `;
        }

        function getCurrentUserRole() {
            return document.body.dataset.userRole || 'student';
        }

        function getCurrentUserId() {
            return document.body.dataset.userId || 1;
        }

        function editCourse(courseId) {
            window.location.href = `/courses/edit?id=${courseId}`;
        }

        function deleteCourse(courseId) {
            if (window.courseManager) {
                window.courseManager.deleteCourse(courseId);
            }
        }

        function viewCourse(courseId) {
            window.location.href = `/courses/view?id=${courseId}`;
        }

        function viewCourseDetails(courseId) {
            window.location.href = `/courses/details?id=${courseId}`;
        }

        function closeEnrollmentModal() {
            document.getElementById('enrollmentModal').classList.add('hidden');
        }

        // Initialize when page loads
        document.addEventListener('DOMContentLoaded', function() {
            // Override the default course rendering
            if (window.courseManager) {
                window.courseManager.renderCourses = function(coursesToRender = this.courses) {
                    const container = document.getElementById('coursesContainer');
                    const emptyState = document.getElementById('emptyState');
                    
                    if (!container) return;

                    if (coursesToRender.length === 0) {
                        container.innerHTML = '';
                        emptyState.classList.remove('hidden');
                        return;
                    }

                    emptyState.classList.add('hidden');
                    container.innerHTML = coursesToRender.map(course => renderCourseCard(course)).join('');
                };
            }

            // Add filter functionality
            const categoryFilter = document.getElementById('categoryFilter');
            const sortFilter = document.getElementById('sortFilter');

            if (categoryFilter) {
                categoryFilter.addEventListener('change', function() {
                    filterAndSortCourses();
                });
            }

            if (sortFilter) {
                sortFilter.addEventListener('change', function() {
                    filterAndSortCourses();
                });
            }
        });

        function filterAndSortCourses() {
            if (!window.courseManager) return;

            const category = document.getElementById('categoryFilter').value;
            const sort = document.getElementById('sortFilter').value;
            let courses = [...window.courseManager.courses];

            // Filter by category
            if (category) {
                courses = courses.filter(course => course.category === category);
            }

            // Sort courses
            courses.sort((a, b) => {
                switch (sort) {
                    case 'name':
                        return a.name.localeCompare(b.name);
                    case 'date':
                        return new Date(b.createdAt) - new Date(a.createdAt);
                    case 'price':
                        return (a.price || 0) - (b.price || 0);
                    case 'rating':
                        return (b.rating || 0) - (a.rating || 0);
                    default:
                        return 0;
                }
            });

            window.courseManager.renderCourses(courses);
        }
    </script>
</body>
</html>
