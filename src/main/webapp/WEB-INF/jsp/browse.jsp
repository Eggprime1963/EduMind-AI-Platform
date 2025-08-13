<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
    <meta charset="UTF-8">
    <title>Browse Courses</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/homePage.css"/>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
</head>
<body>
    <jsp:include page="navbar.jsp" />
    
    <!-- Error Messages -->
    <c:if test="${not empty error}">
        <div class="alert alert-danger alert-dismissible fade show mx-auto mt-3" role="alert" style="max-width: 1200px;">
            <i class="bi bi-exclamation-triangle-fill me-2"></i>
            <strong>Error!</strong> ${error}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    </c:if>
    
    <div class="container mt-4">
        <div class="text-center mb-5">
            <h1 class="display-4 fw-bold">Browse Courses</h1>
            <p class="lead text-muted">Discover amazing courses and start your learning journey</p>
        </div>
        
        <!-- Course Filter Section -->
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h3 class="mb-0">All Courses</h3>
                <small class="text-muted" id="resultsCounter">
                    <i class="bi bi-collection me-1"></i>
                    Showing <span id="courseCount">${courses.size()}</span> courses
                </small>
            </div>
            <div class="course-filters">
                <button class="btn btn-sm btn-primary me-2 filter-btn" data-filter="all">
                    <i class="bi bi-collection me-1"></i>All
                </button>
                <button class="btn btn-sm btn-outline-success me-2 filter-btn filter-btn-beginner" data-filter="beginner">
                    <i class="bi bi-circle-fill me-1"></i>Beginner
                </button>
                <button class="btn btn-sm btn-outline-primary me-2 filter-btn filter-btn-intermediate" data-filter="intermediate">
                    <i class="bi bi-circle-half me-1"></i>Intermediate
                </button>
                <button class="btn btn-sm btn-outline-danger filter-btn filter-btn-advanced" data-filter="advanced">
                    <i class="bi bi-triangle-fill me-1"></i>Advanced
                </button>
            </div>
        </div>
        
        <div class="row" id="coursesContainer">
            <c:forEach var="course" items="${courses}">
                <div class="col-md-4 mb-4 course-item" data-level="${course.difficulty}">
                    <div class="card h-100 shadow-sm border-0 course-card">
                        <div class="position-relative">
                            <c:choose>
                                <c:when test="${not empty course.image}">
                                    <img src="${pageContext.request.contextPath}/${course.image}" 
                                         class="card-img-top" 
                                         alt="${course.name}"
                                         style="height: 200px; object-fit: cover;">
                                </c:when>
                                <c:otherwise>
                                    <div class="card-img-top d-flex align-items-center justify-content-center bg-light" 
                                         style="height: 200px;">
                                        <i class="bi bi-book text-muted" style="font-size: 3rem;"></i>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                            
                            <!-- Difficulty Badge -->
                            <div class="position-absolute top-0 start-0 m-2">
                                <c:choose>
                                    <c:when test="${course.difficulty == 'beginner'}">
                                        <span class="badge bg-success px-2 py-1">
                                            <i class="bi bi-circle-fill me-1"></i>Beginner
                                        </span>
                                    </c:when>
                                    <c:when test="${course.difficulty == 'intermediate'}">
                                        <span class="badge bg-primary px-2 py-1">
                                            <i class="bi bi-circle-half me-1"></i>Intermediate
                                        </span>
                                    </c:when>
                                    <c:when test="${course.difficulty == 'advanced'}">
                                        <span class="badge bg-danger px-2 py-1">
                                            <i class="bi bi-triangle-fill me-1"></i>Advanced
                                        </span>
                                    </c:when>
                                </c:choose>
                            </div>
                            
                            <!-- Premium Badge -->
                            <c:if test="${course.price > 0}">
                                <div class="position-absolute top-0 end-0 m-2">
                                    <span class="badge bg-warning text-dark px-2 py-1">
                                        <i class="bi bi-star-fill me-1"></i>PREMIUM
                                    </span>
                                </div>
                            </c:if>
                        </div>
                        
                        <div class="card-body d-flex flex-column">
                            <div class="d-flex justify-content-between align-items-start mb-2">
                                <h5 class="card-title fw-bold mb-0">${course.name}</h5>
                                <c:if test="${not empty course.category}">
                                    <small class="text-muted badge bg-light text-dark">${course.category}</small>
                                </c:if>
                            </div>
                            <p class="card-text text-muted flex-grow-1">${course.description}</p>
                            
                            <div class="mt-auto">
                                <div class="d-flex justify-content-between align-items-center mb-3">
                                    <small class="text-muted">
                                        <i class="bi bi-play-circle me-1"></i>
                                        ${course.lectureCount} lectures
                                    </small>
                                    <c:choose>
                                        <c:when test="${course.price > 0}">
                                            <small class="text-warning fw-bold">
                                                <fmt:formatNumber value="${course.price}" type="currency" currencyCode="VND" />
                                            </small>
                                        </c:when>
                                        <c:otherwise>
                                            <small class="text-success fw-bold">Free</small>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                
                                <div class="d-grid gap-2">
                                    <c:choose>
                                        <c:when test="${course.price > 0}">
                                            <!-- Premium course - different styling -->
                                            <a href="${pageContext.request.contextPath}/course?courseId=${course.idCourse}" 
                                               class="btn btn-warning">
                                                <i class="bi bi-star-fill me-2"></i>View Premium Course
                                            </a>
                                        </c:when>
                                        <c:otherwise>
                                            <!-- Regular course -->
                                            <a href="${pageContext.request.contextPath}/course?courseId=${course.idCourse}" 
                                               class="btn btn-primary">
                                                <i class="bi bi-eye me-2"></i>View Course
                                            </a>
                                        </c:otherwise>
                                    </c:choose>
                                    
                                    <c:if test="${course.price > 0}">
                                        <c:choose>
                                            <c:when test="${not empty sessionScope.user}">
                                                <a href="${pageContext.request.contextPath}/payment?courseId=${course.idCourse}" 
                                                   class="btn btn-success">
                                                    <i class="bi bi-credit-card me-2"></i>Enroll Now - 
                                                    <fmt:formatNumber value="${course.price}" type="currency" currencyCode="VND" />
                                                </a>
                                            </c:when>
                                            <c:otherwise>
                                                <a href="${pageContext.request.contextPath}/login" 
                                                   class="btn btn-outline-success">
                                                    <i class="bi bi-box-arrow-in-right me-2"></i>Login to Enroll
                                                </a>
                                            </c:otherwise>
                                        </c:choose>
                                    </c:if>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </c:forEach>
            
            <c:if test="${empty courses}">
                <div class="col-12">
                    <div class="text-center py-5">
                        <i class="bi bi-book text-muted" style="font-size: 4rem;"></i>
                        <h3 class="mt-3 text-muted">No courses available</h3>
                        <p class="text-muted">Check back later for new courses!</p>
                    </div>
                </div>
            </c:if>
        </div>
    </div>
    
    <style>
        /* Custom CSS for course filter buttons with hover effects matching difficulty colors */
        .filter-btn {
            transition: all 0.3s ease;
            border-width: 2px;
        }
        
        .filter-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
        }
        
        .filter-btn-beginner:hover {
            background-color: #198754 !important;
            border-color: #198754 !important;
            color: white !important;
        }
        
        .filter-btn-intermediate:hover {
            background-color: #0d6efd !important;
            border-color: #0d6efd !important;
            color: white !important;
        }
        
        .filter-btn-advanced:hover {
            background-color: #dc3545 !important;
            border-color: #dc3545 !important;
            color: white !important;
        }
        
        /* Active states */
        .filter-btn.active.filter-btn-beginner {
            background-color: #198754 !important;
            border-color: #198754 !important;
            color: white !important;
        }
        
        .filter-btn.active.filter-btn-intermediate {
            background-color: #0d6efd !important;
            border-color: #0d6efd !important;
            color: white !important;
        }
        
        .filter-btn.active.filter-btn-advanced {
            background-color: #dc3545 !important;
            border-color: #dc3545 !important;
            color: white !important;
        }
        
        /* Course card animations */
        .course-item {
            transition: all 0.3s ease;
        }
        
        .course-card {
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }
        
        .course-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 25px rgba(0,0,0,0.15) !important;
        }
        
        /* Filter animation effects */
        .course-item.filtered-out {
            opacity: 0;
            transform: scale(0.8);
            pointer-events: none;
        }
        
        .course-item.filtered-in {
            opacity: 1;
            transform: scale(1);
            pointer-events: auto;
        }
        
        /* Responsive design for filters */
        @media (max-width: 768px) {
            .d-flex.justify-content-between {
                flex-direction: column;
                align-items: flex-start !important;
            }
            
            .course-filters {
                margin-top: 1rem;
                width: 100%;
            }
            
            .filter-btn {
                margin-bottom: 0.5rem;
                width: 48%;
                margin-right: 2% !important;
            }
            
            .filter-btn:nth-child(even) {
                margin-right: 0 !important;
            }
        }
        
        @media (max-width: 576px) {
            .filter-btn {
                width: 100%;
                margin-right: 0 !important;
                margin-bottom: 0.5rem;
            }
        }
    </style>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Course filtering functionality
            const filterButtons = document.querySelectorAll('.filter-btn[data-filter]');
            const courseItems = document.querySelectorAll('.course-item');
            
            // Initialize all courses as visible
            courseItems.forEach(item => {
                item.classList.add('filtered-in');
            });
            
            filterButtons.forEach(button => {
                button.addEventListener('click', function() {
                    const filter = this.dataset.filter;
                    
                    // Update active button state
                    filterButtons.forEach(btn => {
                        btn.classList.remove('active');
                        if (btn.dataset.filter === 'all') {
                            btn.classList.remove('btn-primary');
                            btn.classList.add('btn-outline-secondary');
                        }
                    });
                    
                    // Set active state for clicked button
                    this.classList.add('active');
                    if (filter === 'all') {
                        this.classList.remove('btn-outline-secondary');
                        this.classList.add('btn-primary');
                    }
                    
                    // Filter courses with animation
                    courseItems.forEach(item => {
                        const courseLevel = item.dataset.level;
                        
                        if (filter === 'all' || courseLevel === filter) {
                            // Show course
                            item.classList.remove('filtered-out');
                            item.classList.add('filtered-in');
                            item.style.display = 'block';
                        } else {
                            // Hide course
                            item.classList.remove('filtered-in');
                            item.classList.add('filtered-out');
                            setTimeout(() => {
                                if (item.classList.contains('filtered-out')) {
                                    item.style.display = 'none';
                                }
                            }, 300);
                        }
                    });
                    
                    // Update results count with a slight delay for better UX
                    setTimeout(() => {
                        const visibleCourses = document.querySelectorAll('.course-item.filtered-in').length;
                        updateResultsCount(visibleCourses, filter);
                    }, 100);
                });
            });
            
            // Function to update results count
            function updateResultsCount(count, filter) {
                const filterName = filter === 'all' ? 'All Courses' : 
                                 filter.charAt(0).toUpperCase() + filter.slice(1) + ' Courses';
                
                const courseCountElement = document.getElementById('courseCount');
                const resultsCounter = document.getElementById('resultsCounter');
                
                if (courseCountElement) {
                    courseCountElement.textContent = count;
                }
                
                if (resultsCounter) {
                    const icon = filter === 'all' ? 'bi-collection' : 
                                filter === 'beginner' ? 'bi-circle-fill' :
                                filter === 'intermediate' ? 'bi-circle-half' : 'bi-triangle-fill';
                    
                    const courseText = filter === 'all' ? 'courses' : filter + ' courses';
                    
                    resultsCounter.innerHTML = 
                        '<i class="' + icon + ' me-1"></i>' +
                        'Showing <span id="courseCount">' + count + '</span> ' + courseText;
                }
            }
            
            // Enhanced course card interactions
            const courseCards = document.querySelectorAll('.course-card');
            courseCards.forEach(card => {
                card.addEventListener('mouseenter', function() {
                    if (!this.closest('.course-item').classList.contains('filtered-out')) {
                        this.style.transform = 'translateY(-5px)';
                        this.style.boxShadow = '0 10px 25px rgba(0,0,0,0.15)';
                    }
                });
                
                card.addEventListener('mouseleave', function() {
                    this.style.transform = '';
                    this.style.boxShadow = '';
                });
            });
        });
    </script>
</body>
</html>
