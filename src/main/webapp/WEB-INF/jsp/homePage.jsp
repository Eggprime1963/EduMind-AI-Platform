<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Learning Platform Homepage</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <!-- Modern UI CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/modern-ui.css">
    <!-- Custom CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/homePage.css">
    <!-- Google Fonts: Inter -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
</head>
<body data-user-id="${sessionScope.userId}" data-user-role="${sessionScope.userRole}">
    <jsp:include page="navbar.jsp" />

    <!-- Main Content -->
    <div class="main-content">
        <div class="container">
            <c:if test="${not empty sessionScope.username}">
                    <h1 class="fw-bold mb-4 welcome-header">Welcome Back, ${sessionScope.username}!</h1>
                </div>
            </div>
        </c:if>
        <div class="row">
            <!-- Sidebar with Learning Roadmap -->
            <div class="col-md-3">
                <c:if test="${empty sessionScope.username}">
                <div class="sidebar welcome-section">
                    <h1 class="fw-bold mb-3 welcome-title">Welcome to EduPlatform</h1>
                    <p class="lead mb-4 welcome-text">
                        Unlock your learning journey! Sign up or log in to access personalized courses, track your progress, and get AI-powered recommendations tailored just for you.
                    </p>
                    <div class="d-grid gap-2">
                        <a href="${pageContext.request.contextPath}/login" class="btn btn-primary btn-lg">
                            <i class="bi bi-box-arrow-in-right me-2"></i>
                            Login
                        </a>
                        <a href="${pageContext.request.contextPath}/register" class="btn btn-outline-primary btn-lg">
                            <i class="bi bi-person-plus me-2"></i>
                            Register
                        </a>
                    </div>
                </div></c:if>
                
                <c:if test="${not empty sessionScope.username}">
                <div class="sidebar">
                    <h4 class="roadmap-title">Learning Roadmap</h4>
                    <ul class="list-group list-group-flush">
                        <li class="list-group-item roadmap-item">
                            <div class="d-flex justify-content-between align-items-center mb-2">
                                <span class="fw-semibold">Module 1: Introduction</span>
                                <span class="badge bg-success">50%</span>
                            </div>
                            <div class="progress">
                                <div class="progress-bar bg-success" role="progressbar" style="width: 50%;" aria-valuenow="50" aria-valuemin="0" aria-valuemax="100"></div>
                            </div>
                        </li>
                        <li class="list-group-item roadmap-item">
                            <div class="d-flex justify-content-between align-items-center mb-2">
                                <span class="fw-semibold">Module 2: Intermediate</span>
                                <span class="badge bg-warning">30%</span>
                            </div>
                            <div class="progress">
                                <div class="progress-bar bg-warning" role="progressbar" style="width: 30%;" aria-valuenow="30" aria-valuemin="0" aria-valuemax="100"></div>
                            </div>
                        </li>
                        <li class="list-group-item roadmap-item">
                            <div class="d-flex justify-content-between align-items-center mb-2">
                                <span class="fw-semibold">Module 3: Advanced</span>
                                <span class="badge bg-secondary">10%</span>
                            </div>
                            <div class="progress">
                                <div class="progress-bar bg-secondary" role="progressbar" style="width: 10%;" aria-valuenow="10" aria-valuemin="0" aria-valuemax="100"></div>
                            </div>
                        </li>
                    </ul>
                    <button class="btn btn-primary w-100 mt-3 roadmap-btn">
                        <i class="bi bi-map me-2"></i>
                        View Full Roadmap
                    </button>
                </div></c:if>
                
            </div>

            <!-- Course Section -->
            <div class="col-md-9">
                <!-- AI-Powered Featured Courses Section -->
                <c:if test="${not empty featuredCourses && aiFeatured}">
                    <div class="ai-featured-section mb-5">
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <h2 class="mb-0">
                                <i class="bi bi-robot text-primary me-2"></i>
                                AI Recommended for You
                            </h2>
                            <span class="badge bg-gradient-primary">
                                <i class="bi bi-cpu me-1"></i>
                                AI Powered
                            </span>
                        </div>
                        <p class="text-muted mb-4">Personalized course recommendations generated by artificial intelligence</p>
                        
                        <div class="row">
                            <c:forEach var="course" items="${featuredCourses}" varStatus="status">
                                <div class="col-md-6 mb-3">
                                    <div class="card featured-course-card h-100 border-0 shadow-sm">
                                        <div class="row g-0">
                                            <div class="col-4">
                                                <img src="${pageContext.request.contextPath}/${course.image}" 
                                                     class="img-fluid rounded-start h-100" 
                                                     alt="${course.name}" 
                                                     style="object-fit: cover;">
                                            </div>
                                            <div class="col-8">
                                                <div class="card-body p-3">
                                                    <div class="d-flex justify-content-between align-items-start mb-2">
                                                        <h6 class="card-title mb-0">${course.name}</h6>
                                                        <span class="badge bg-primary">#${status.index + 1}</span>
                                                    </div>
                                                    <p class="card-text text-muted small mb-2">${course.description}</p>
                                                    <div class="d-flex justify-content-between align-items-center">
                                                        <small class="text-muted">
                                                            <i class="bi bi-play-circle me-1"></i>
                                                            ${course.lectureCount} lessons
                                                        </small>
                                                        <a href="${pageContext.request.contextPath}/course?courseId=${course.idCourse}" 
                                                           class="btn btn-sm btn-outline-primary">Start</a>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                        
                        <div class="text-center mt-3">
                            <a href="${pageContext.request.contextPath}/ai-recommendations" 
                               class="btn btn-primary">
                                <i class="bi bi-lightbulb me-2"></i>
                                Get More AI Recommendations
                            </a>
                        </div>
                    </div>
                </c:if>
                
                <!-- AI Assistant Integration Panel -->
                <c:if test="${aiAssistantAvailable}">
                    <div class="ai-assistant-panel mb-4">
                        <div class="card border-0 bg-gradient-primary text-white">
                            <div class="card-body">
                                <div class="row align-items-center">
                                    <div class="col-md-8">
                                        <h5 class="card-title mb-2">
                                            <i class="bi bi-robot me-2"></i>
                                            Meet Your AI Learning Assistant
                                        </h5>
                                        <p class="card-text mb-0">
                                            Get instant help with programming questions, course recommendations, and personalized learning guidance.
                                        </p>
                                    </div>
                                    <div class="col-md-4 text-md-end">
                                        <button class="btn btn-light btn-lg" onclick="window.aiChatWidget && window.aiChatWidget.open()">
                                            <i class="bi bi-chat-dots me-2"></i>
                                            Ask AI
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:if>
                
                <!-- All Courses Section -->
                <div class="all-courses-section">
                    <!-- Course Filter Section -->
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <div>
                            <h2 class="mb-0">All Courses</h2>
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
                    
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger">${error}</div>
                    </c:if>
                    
                    <div class="row" id="coursesContainer">
                        <c:forEach var="course" items="${courses}">
                            <div class="col-md-4 mb-4 course-item" data-level="${course.difficulty}">
                                <div class="card course-card h-100 shadow-sm border-0">
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
                                            
                                            <c:if test="${not empty sessionScope.username}">
                                                <div class="progress progress-container mb-2">
                                                    <div class="progress-bar" role="progressbar" style="width: 50%;" aria-valuenow="50" aria-valuemin="0" aria-valuemax="100">50%</div>
                                                </div>
                                            </c:if>
                                            
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
                                                        <c:if test="${not empty sessionScope.username}">
                                                            <c:choose>
                                                                <c:when test="${course.enrolled}">
                                                                    <a href="${pageContext.request.contextPath}/course?courseId=${course.idCourse}" class="btn btn-primary">
                                                                        <i class="bi bi-play-circle me-2"></i>Continue Learning
                                                                    </a>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <a href="${pageContext.request.contextPath}/course?courseId=${course.idCourse}" class="btn btn-success">
                                                                        <i class="bi bi-plus-circle me-2"></i>Start Course
                                                                    </a>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </c:if>
                                                        <c:if test="${empty sessionScope.username}">
                                                            <a href="${pageContext.request.contextPath}/course?courseId=${course.idCourse}" class="btn btn-outline-primary">
                                                                <i class="bi bi-eye me-2"></i>View Course Details
                                                            </a>
                                                        </c:if>
                                                    </c:otherwise>
                                                </c:choose>
                                                
                                                <c:if test="${course.price > 0}">
                                                    <c:choose>
                                                        <c:when test="${not empty sessionScope.username}">
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
            </div>
    </div>

    <!-- Include AI Chatbot Widget -->
    <jsp:include page="chatbotWidget.jsp" />

    <!-- Bootstrap JS and Popper.js -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- Modern UI Components -->
    <script src="${pageContext.request.contextPath}/js/api-service.js"></script>
    <script src="${pageContext.request.contextPath}/js/course-manager.js"></script>
    <script src="${pageContext.request.contextPath}/js/assignment-manager.js"></script>
    <script src="${pageContext.request.contextPath}/js/payment-manager.js"></script>
    <script src="${pageContext.request.contextPath}/js/notification-manager.js"></script>
    <script src="${pageContext.request.contextPath}/js/app.js"></script>
    
    <!-- Enhanced Homepage JavaScript -->
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Course filtering functionality (exact copy from browse.jsp)
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
            
            // AI feature announcements
            if (typeof window.aiChatWidget !== 'undefined') {
                // Show a subtle notification about AI features
                setTimeout(() => {
                    if (!sessionStorage.getItem('aiFeaturesSeen')) {
                        showAIFeatureNotification();
                        sessionStorage.setItem('aiFeaturesSeen', 'true');
                    }
                }, 3000);
            }
        });
        
        function showAIFeatureNotification() {
            const notification = document.createElement('div');
            notification.className = 'ai-notification';
            notification.innerHTML = `
                <div class="alert alert-info alert-dismissible fade show position-fixed" 
                     style="top: 20px; right: 20px; z-index: 1060; max-width: 300px;">
                    <div class="d-flex align-items-center">
                        <i class="bi bi-robot text-primary me-2"></i>
                        <div>
                            <strong>AI Features Available!</strong><br>
                            <small>Try our AI assistant for personalized help</small>
                        </div>
                    </div>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            `;
            
            document.body.appendChild(notification);
            
            // Auto-remove after 5 seconds
            setTimeout(() => {
                const alert = notification.querySelector('.alert');
                if (alert) {
                    bootstrap.Alert.getOrCreateInstance(alert).close();
                }
            }, 5000);
        }
    </script>
    
    <!-- Additional AI-Enhanced Styling -->
    <style>
        /* Custom CSS for course filter buttons with hover effects matching difficulty colors (copied from browse.jsp) */
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

        .ai-featured-section {
            background: linear-gradient(135deg, #f8f9ff 0%, #e3f2fd 100%);
            border-radius: 15px;
            padding: 2rem;
            border: 1px solid #e1f5fe;
        }
        
        .featured-course-card {
            transition: all 0.3s ease;
            border-radius: 10px;
            overflow: hidden;
        }
        
        .featured-course-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.1);
        }
        
        .bg-gradient-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }
        
        .ai-assistant-panel {
            animation: slideInFromRight 0.8s ease-out;
        }
        
        @keyframes slideInFromRight {
            from {
                opacity: 0;
                transform: translateX(30px);
            }
            to {
                opacity: 1;
                transform: translateX(0);
            }
        }
        
        .course-meta {
            border-top: 1px solid #f0f0f0;
            padding-top: 0.75rem;
        }
        
        .badge.bg-gradient-primary {
            background: linear-gradient(45deg, #667eea 0%, #764ba2 100%) !important;
        }
        
        .ai-notification {
            animation: slideInFromRight 0.5s ease-out;
        }
    </style>
</body>
</html>