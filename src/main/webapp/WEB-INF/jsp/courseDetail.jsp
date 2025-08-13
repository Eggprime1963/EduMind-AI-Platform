<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${course.name} - Course Details</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <!-- Custom CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/homePage.css">
</head>
<body>
    <jsp:include page="navbar.jsp" />
    
    <!-- Success/Error Messages -->
    <c:if test="${not empty error}">
        <div class="alert alert-danger alert-dismissible fade show mx-auto mt-3" role="alert" style="max-width: 800px;">
            <i class="bi bi-exclamation-triangle-fill me-2"></i>
            <strong>Error!</strong> ${error}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    </c:if>
    <c:if test="${param.message == 'enrolled_successfully'}">
        <div class="alert alert-success alert-dismissible fade show mx-auto mt-3" role="alert" style="max-width: 800px;">
            <i class="bi bi-check-circle-fill me-2"></i>
            <strong>Success!</strong> You have been successfully enrolled in this course.
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    </c:if>
    <c:if test="${param.message == 'already_enrolled'}">
        <div class="alert alert-info alert-dismissible fade show mx-auto mt-3" role="alert" style="max-width: 800px;">
            <i class="bi bi-info-circle-fill me-2"></i>
            <strong>Info:</strong> You are already enrolled in this course.
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    </c:if>
    
    <div class="container mt-5">
        <div class="row">
            <!-- Course Information Section -->
            <div class="col-md-6">
                <div class="d-flex align-items-center mb-3">
                    <h1 class="display-4 fw-bold mb-0 me-3">${course.name}</h1>
                    <div class="d-flex flex-column gap-2">
                        <!-- Difficulty Badge -->
                        <c:choose>
                            <c:when test="${course.difficulty == 'beginner'}">
                                <span class="badge bg-success fs-6 px-3 py-2">
                                    <i class="bi bi-circle-fill me-1"></i>BEGINNER
                                </span>
                            </c:when>
                            <c:when test="${course.difficulty == 'intermediate'}">
                                <span class="badge bg-primary fs-6 px-3 py-2">
                                    <i class="bi bi-circle-half me-1"></i>INTERMEDIATE
                                </span>
                            </c:when>
                            <c:when test="${course.difficulty == 'advanced'}">
                                <span class="badge bg-danger fs-6 px-3 py-2">
                                    <i class="bi bi-triangle-fill me-1"></i>ADVANCED
                                </span>
                            </c:when>
                        </c:choose>
                        
                        <!-- Premium Badge -->
                        <c:if test="${course.difficulty == 'advanced' && course.idCourse == 9}">
                            <span class="badge bg-warning text-dark fs-6 px-3 py-2">
                                <i class="bi bi-star-fill me-1"></i>PREMIUM
                            </span>
                        </c:if>
                    </div>
                </div>
                
                <div class="mb-4">
                    <h5 class="text-muted">
                        <i class="bi bi-person-fill me-2"></i>
                        Instructor: ${course.teacherName}
                    </h5>
                    <c:if test="${not empty course.category}">
                        <small class="text-primary">
                            <i class="bi bi-tag-fill me-1"></i>Category: ${course.category}
                        </small>
                    </c:if>
                    <br>
                    <c:if test="${course.difficulty == 'advanced' && course.idCourse == 9}">
                        <small class="text-warning">
                            <i class="bi bi-patch-check-fill me-1"></i>Expert Instructor • Advanced Content
                        </small>
                    </c:if>
                </div>
                
                <div class="mb-4">
                    <h6 class="fw-bold mb-3">Course Description</h6>
                    <p class="lead text-muted">${course.description}</p>
                </div>
                
                <div class="mb-4">
                    <h6 class="fw-bold mb-3">Course Details</h6>
                    <ul class="list-unstyled">
                        <li class="mb-2">
                            <i class="bi bi-play-circle-fill me-2 text-primary"></i>
                            <strong>Total Lectures:</strong> ${course.lectureCount}
                        </li>
                        <li class="mb-2">
                            <i class="bi bi-speedometer2 me-2 text-info"></i>
                            <strong>Difficulty Level:</strong> 
                            <c:choose>
                                <c:when test="${course.difficulty == 'beginner'}">
                                    <span class="text-success">Beginner</span>
                                </c:when>
                                <c:when test="${course.difficulty == 'intermediate'}">
                                    <span class="text-primary">Intermediate</span>
                                </c:when>
                                <c:when test="${course.difficulty == 'advanced'}">
                                    <span class="text-danger">Advanced</span>
                                </c:when>
                            </c:choose>
                        </li>
                        <c:if test="${not empty course.category}">
                            <li class="mb-2">
                                <i class="bi bi-tag-fill me-2 text-secondary"></i>
                                <strong>Category:</strong> ${course.category}
                            </li>
                        </c:if>
                        <li class="mb-2">
                            <i class="bi bi-clock-fill me-2 text-success"></i>
                            <strong>Duration:</strong> Self-paced
                        </li>
                        <li class="mb-2">
                            <i class="bi bi-award-fill me-2 text-warning"></i>
                            <strong>Certificate:</strong> Available upon completion
                        </li>
                        <c:if test="${course.difficulty == 'advanced' && course.idCourse == 9}">
                            <li class="mb-2">
                                <i class="bi bi-laptop me-2 text-info"></i>
                                <strong>Premium Content:</strong> Hands-on projects included
                            </li>
                            <li class="mb-2">
                                <i class="bi bi-headset me-2 text-primary"></i>
                                <strong>Support:</strong> Direct instructor access
                            </li>
                            <li class="mb-2">
                                <i class="bi bi-download me-2 text-success"></i>
                                <strong>Resources:</strong> Downloadable materials & code
                            </li>
                        </c:if>
                    </ul>
                </div>
                
                <!-- Enrollment Button -->
                <div class="d-grid gap-2">
                    <c:choose>
                        <c:when test="${empty sessionScope.username}">
                            <!-- Not logged in - Sign In to Start Learning -->
                            <a href="${pageContext.request.contextPath}/login" class="btn btn-primary btn-lg">
                                <i class="bi bi-box-arrow-in-right me-2"></i>
                                Sign In to Start Learning
                            </a>
                        </c:when>
                        <c:when test="${enrolled}">
                            <!-- Logged in and enrolled - Continue Learning -->
                            <a href="${pageContext.request.contextPath}/lectures?courseId=${course.idCourse}" class="btn btn-success btn-lg">
                                <i class="bi bi-play-fill me-2"></i>
                                Continue Learning
                            </a>
                        </c:when>
                        <c:otherwise>
                            <!-- Logged in but not enrolled -->
                            <c:choose>
                                <c:when test="${course.idCourse == 9}">
                                    <!-- Premium Course - Payment Required -->
                                    <div class="card border-warning mb-3">
                                        <div class="card-body text-center">
                                            <h5 class="card-title text-warning">
                                                <i class="bi bi-star-fill me-2"></i>Premium Course
                                            </h5>
                                            <p class="card-text text-muted">
                                                This is an advanced course with premium content and features.
                                            </p>
                                            <h4 class="text-success mb-3">299,000 VND</h4>
                                        </div>
                                    </div>
                                    
                                    <a href="${pageContext.request.contextPath}/payment?courseId=${course.idCourse}" 
                                       class="btn btn-warning btn-lg mb-2">
                                        <i class="bi bi-credit-card me-2"></i>
                                        Enroll with Payment - 299,000 VND
                                    </a>
                                    
                                    <small class="text-muted d-block text-center">
                                        <i class="bi bi-shield-check me-1"></i>
                                        Secure payment with VNPay • 30-day money back guarantee
                                    </small>
                                </c:when>
                                <c:otherwise>
                                    <!-- Free Course - Direct Enrollment -->
                                    <form action="${pageContext.request.contextPath}/course" method="post" class="d-inline">
                                        <input type="hidden" name="action" value="enroll">
                                        <input type="hidden" name="courseId" value="${course.idCourse}">
                                        <button type="submit" class="btn btn-primary btn-lg w-100">
                                            <i class="bi bi-bookmark-plus-fill me-2"></i>
                                            Enroll Now (Free)
                                        </button>
                                    </form>
                                </c:otherwise>
                            </c:choose>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
            
            <!-- Course Cover Image Section -->
            <div class="col-md-6">
                <div class="card shadow-lg border-0">
                    <div class="position-relative">
                        <c:choose>
                            <c:when test="${not empty course.image}">
                                <img src="${pageContext.request.contextPath}/${course.image}" 
                                     class="card-img-top" 
                                     alt="${course.name}"
                                     style="height: 400px; object-fit: cover;">
                            </c:when>
                            <c:otherwise>
                                <div class="card-img-top d-flex align-items-center justify-content-center bg-light" 
                                     style="height: 400px;">
                                    <div class="text-center text-muted">
                                        <i class="bi bi-image" style="font-size: 4rem;"></i>
                                        <p class="mt-3 fs-5">Course Cover Image</p>
                                    </div>
                                </div>
                            </c:otherwise>
                        </c:choose>
                        
                        <!-- Play button overlay for preview -->
                        <div class="position-absolute top-50 start-50 translate-middle">
                            <button class="btn btn-light btn-lg rounded-circle shadow" 
                                    style="width: 80px; height: 80px; opacity: 0.9;">
                                <i class="bi bi-play-fill fs-2"></i>
                            </button>
                        </div>
                    </div>
                </div>
                
                <!-- Course Stats -->
                <div class="row mt-4">
                    <div class="col-4 text-center">
                        <div class="card border-0 shadow-sm">
                            <div class="card-body">
                                <h5 class="card-title text-primary">${course.lectureCount}</h5>
                                <p class="card-text text-muted small">Lectures</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-4 text-center">
                        <div class="card border-0 shadow-sm">
                            <div class="card-body">
                                <h5 class="card-title text-success">∞</h5>
                                <p class="card-text text-muted small">Lifetime Access</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-4 text-center">
                        <div class="card border-0 shadow-sm">
                            <div class="card-body">
                                <h5 class="card-title text-warning">★ 4.8</h5>
                                <p class="card-text text-muted small">Rating</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Course Curriculum Section -->
        <div class="row mt-5">
            <div class="col-12">
                <h3 class="fw-bold mb-4">Course Curriculum</h3>
                <div class="card border-0 shadow-sm">
                    <div class="card-body">
                        <c:choose>
                            <c:when test="${not empty lectures}">
                                <div class="accordion" id="curriculumAccordion">
                                    <c:forEach var="lecture" items="${lectures}" varStatus="status">
                                        <div class="accordion-item">
                                            <h2 class="accordion-header" id="heading${status.index}">
                                                <button class="accordion-button collapsed" type="button" 
                                                        data-bs-toggle="collapse" 
                                                        data-bs-target="#collapse${status.index}" 
                                                        aria-expanded="false" 
                                                        aria-controls="collapse${status.index}">
                                                    <i class="bi bi-play-circle me-3"></i>
                                                    ${lecture.title}
                                                    <span class="badge bg-primary ms-auto me-3">Lecture ${status.index + 1}</span>
                                                </button>
                                            </h2>
                                            <div id="collapse${status.index}" 
                                                 class="accordion-collapse collapse" 
                                                 aria-labelledby="heading${status.index}" 
                                                 data-bs-parent="#curriculumAccordion">
                                                <div class="accordion-body">
                                                    <p class="text-muted">${lecture.content}</p>
                                                    <c:choose>
                                                        <c:when test="${enrolled}">
                                                            <a href="${pageContext.request.contextPath}/lectures?courseId=${course.idCourse}&lectureId=${lecture.id}" 
                                                               class="btn btn-primary btn-sm">
                                                                <i class="bi bi-play-fill me-1"></i>
                                                                Watch Lecture
                                                            </a>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <small class="text-success">
                                                                <i class="bi bi-unlock-fill me-1"></i>
                                                                Available after enrollment
                                                            </small>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="text-center text-muted py-5">
                                    <i class="bi bi-book" style="font-size: 3rem;"></i>
                                    <p class="mt-3">Course curriculum will be available soon.</p>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
        </div>
    </div>
    
    <!-- Include AI Chatbot Widget -->
    <jsp:include page="chatbotWidget.jsp" />
    
    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- Enhanced Course Detail JavaScript -->
    <script>
        // Course data from server
        var courseEnrolled = <c:out value="${enrolled}" default="false" />;
        var userLoggedIn = <c:out value="${not empty sessionScope.username}" default="false" />;
        var courseName = '<c:out value="${course.name}" />';
        var courseId = '<c:out value="${course.idCourse}" />';
        var instructorName = '<c:out value="${course.teacherName}" />';
        
        document.addEventListener('DOMContentLoaded', function() {
            // Enhanced course preview functionality
            const playButton = document.querySelector('.btn-light.rounded-circle');
            if (playButton) {
                playButton.addEventListener('click', function() {
                    if (courseEnrolled) {
                        window.location.href = '${pageContext.request.contextPath}/lectures?courseId=${course.idCourse}';
                    } else {
                        // Show enrollment prompt
                        if (confirm('You need to enroll in this course to access the lectures. Would you like to enroll now?')) {
                            if (userLoggedIn) {
                                const enrollForm = document.querySelector('form[action*="course"] button[type="submit"]');
                                if (enrollForm) enrollForm.click();
                            } else {
                                window.location.href = '${pageContext.request.contextPath}/login';
                            }
                        }
                    }
                });
            }
            
            // Course-specific AI assistance
            if (typeof window.aiChatWidget !== 'undefined') {
                // Add course context to AI chatbot
                window.aiChatWidget.courseContext = {
                    courseName: courseName,
                    courseId: courseId,
                    instructor: instructorName,
                    enrolled: courseEnrolled
                };
                
                // Show course-specific AI suggestions
                setTimeout(function() {
                    if (!sessionStorage.getItem('courseAISuggestionSeen_' + courseId)) {
                        showCourseAISuggestion();
                        sessionStorage.setItem('courseAISuggestionSeen_' + courseId, 'true');
                    }
                }, 2000);
            }
        });
        
        function showCourseAISuggestion() {
            const suggestion = document.createElement('div');
            suggestion.className = 'course-ai-suggestion';
            suggestion.innerHTML = 
                '<div class="alert alert-info alert-dismissible fade show position-fixed" ' +
                'style="bottom: 120px; right: 20px; z-index: 1055; max-width: 320px;">' +
                '<div class="d-flex align-items-start">' +
                '<i class="bi bi-lightbulb text-primary me-2 mt-1"></i>' +
                '<div>' +
                '<strong>AI Course Assistant</strong><br>' +
                '<small>Ask me anything about "' + courseName + '" - course content, prerequisites, or learning tips!</small>' +
                '</div>' +
                '</div>' +
                '<button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>' +
                '</div>';
            
            document.body.appendChild(suggestion);
            
            // Auto-remove after 8 seconds
            setTimeout(function() {
                const alert = suggestion.querySelector('.alert');
                if (alert) {
                    bootstrap.Alert.getOrCreateInstance(alert).close();
                }
            }, 8000);
        }
    </script>
    
    <!-- Course Detail Specific Styling -->
    <style>
        .course-ai-suggestion {
            animation: slideInFromRight 0.6s ease-out;
        }
        
        .course-ai-suggestion .alert {
            border-left: 4px solid #0d6efd;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }
        
        .position-relative .btn.rounded-circle {
            transition: all 0.3s ease;
        }
        
        .position-relative .btn.rounded-circle:hover {
            transform: scale(1.1);
            box-shadow: 0 8px 25px rgba(0,0,0,0.2);
        }
        
        .accordion-button {
            transition: all 0.2s ease;
        }
        
        .accordion-button:not(.collapsed) {
            background-color: #f8f9fa;
            border-color: #dee2e6;
        }
        
        .accordion-button:focus {
            box-shadow: 0 0 0 0.25rem rgba(13, 110, 253, 0.25);
        }
        
        @keyframes slideInFromRight {
            from {
                opacity: 0;
                transform: translateX(100px);
            }
            to {
                opacity: 1;
                transform: translateX(0);
            }
        }
        
        /* Enhanced course stats cards */
        .card.border-0.shadow-sm {
            transition: all 0.3s ease;
        }
        
        .card.border-0.shadow-sm:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.1) !important;
        }
        
        /* Responsive improvements */
        @media (max-width: 768px) {
            .course-ai-suggestion .alert {
                bottom: 80px !important;
                right: 10px !important;
                left: 10px !important;
                max-width: none !important;
            }
            
            .display-4 {
                font-size: 2rem;
            }
        }
    </style>
</body>
</html>