<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${lecture.title} - Lecture</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <!-- Custom CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/homePage.css">
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
    
    <div class="container-fluid mt-4">
        <div class="row">
            <!-- Sidebar: Course Navigation -->
            <div class="col-md-3 bg-light border-end" style="min-height: calc(100vh - 120px);">
                <div class="p-3">
                    <h6 class="text-muted mb-3">COURSE CONTENT</h6>
                    
                    <!-- Lectures List -->
                    <div class="mb-4">
                        <h6 class="fw-bold mb-3">
                            <i class="bi bi-play-circle-fill me-2"></i>
                            Lectures
                        </h6>
                        <ul class="list-group list-group-flush">
                            <c:forEach var="lectureItem" items="${lectures}" varStatus="status">
                                <li class="list-group-item bg-transparent border-0 px-0 py-2 ${lectureItem.id == lecture.id ? 'active' : ''}">
                                    <a href="${pageContext.request.contextPath}/lectures?lectureId=${lectureItem.id}&courseId=${courseId}" 
                                       class="text-decoration-none ${lectureItem.id == lecture.id ? 'text-white' : 'text-dark'}">
                                        <div class="d-flex align-items-center">
                                            <i class="bi bi-play-circle me-2"></i>
                                            <span class="small">${lectureItem.title}</span>
                                        </div>
                                    </a>
                                </li>
                            </c:forEach>
                        </ul>
                    </div>
                    
                    <!-- Assignments List -->
                    <div class="mb-4">
                        <h6 class="fw-bold mb-3">
                            <i class="bi bi-file-earmark-text-fill me-2"></i>
                            Assignments
                        </h6>
                        <ul class="list-group list-group-flush">
                            <c:forEach var="assignment" items="${assignments}">
                                <li class="list-group-item bg-transparent border-0 px-0 py-2">
                                    <a href="${pageContext.request.contextPath}/assignments?assignmentId=${assignment.id}" 
                                       class="text-decoration-none text-dark">
                                        <div class="d-flex align-items-center">
                                            <i class="bi bi-file-earmark me-2"></i>
                                            <span class="small">${assignment.title}</span>
                                        </div>
                                    </a>
                                </li>
                            </c:forEach>
                        </ul>
                    </div>
                </div>
            </div>
            
            <!-- Main Content: Lecture Content -->
            <div class="col-md-9">
                <div class="p-4">
                    <!-- Lecture Header -->
                    <div class="mb-4">
                        <h1 class="display-5 fw-bold">${lecture.title}</h1>
                        <p class="text-muted lead">${lecture.content}</p>
                    </div>
                    
                    <!-- Video Player Section -->
                    <div class="mb-4">
                        <div class="card border-0 shadow">
                            <div class="position-relative">
                                <c:choose>
                                    <c:when test="${not empty lecture.videoUrl}">
                                        <c:choose>
                                            <c:when test="${fn:contains(lecture.videoUrl, 'youtube.com/watch') or fn:contains(lecture.videoUrl, 'youtu.be/')}">
                                                <!-- YouTube Video Player -->
                                                <div class="ratio ratio-16x9">
                                                    <c:choose>
                                                        <c:when test="${not empty embedUrl}">
                                                            <iframe src="${embedUrl}" 
                                                                    title="${lecture.title}" 
                                                                    allowfullscreen>
                                                            </iframe>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <c:set var="embedUrl" value="${fn:replace(lecture.videoUrl, 'watch?v=', 'embed/')}" />
                                                            <iframe src="${embedUrl}" 
                                                                    title="${lecture.title}" 
                                                                    allowfullscreen>
                                                            </iframe>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                            </c:when>
                                            <c:otherwise>
                                                <!-- Regular MP4 Video Player -->
                                                <video class="w-100" controls style="height: 400px; object-fit: cover;">
                                                    <source src="${lecture.videoUrl}" type="video/mp4">
                                                    Your browser does not support the video tag.
                                                </video>
                                            </c:otherwise>
                                        </c:choose>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="card-img-top d-flex align-items-center justify-content-center bg-dark text-white" 
                                             style="height: 400px;">
                                            <div class="text-center">
                                                <i class="bi bi-play-circle" style="font-size: 4rem;"></i>
                                                <p class="mt-3 fs-5">Video Content</p>
                                                <p class="text-muted">Video will be available here</p>
                                            </div>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Lecture Content -->
                    <div class="mb-4">
                        <div class="card border-0 shadow-sm">
                            <div class="card-body">
                                <h5 class="card-title fw-bold mb-3">
                                    <i class="bi bi-book-half me-2"></i>
                                    Lecture Content
                                </h5>
                                <div class="content-text">
                                    <c:choose>
                                        <c:when test="${not empty lecture.content}">
                                            ${lecture.content}
                                        </c:when>
                                        <c:otherwise>
                                            <p class="text-muted">Content for this lecture will be available soon.</p>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Navigation and Actions -->
                    <div class="row">
                        <div class="col-md-8">
                            <!-- Previous/Next Navigation -->
                            <div class="d-flex justify-content-between">
                                <c:if test="${hasPrevious}">
                                    <a href="${pageContext.request.contextPath}/lectures?lectureId=${previousLectureId}&courseId=${courseId}" 
                                       class="btn btn-outline-secondary">
                                        <i class="bi bi-chevron-left me-2"></i>
                                        Previous Lecture
                                    </a>
                                </c:if>
                                <c:if test="${!hasPrevious}">
                                    <div></div>
                                </c:if>
                                
                                <c:if test="${hasNext}">
                                    <a href="${pageContext.request.contextPath}/lectures?lectureId=${nextLectureId}&courseId=${courseId}" 
                                       class="btn btn-primary">
                                        Next Lecture
                                        <i class="bi bi-chevron-right ms-2"></i>
                                    </a>
                                </c:if>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <!-- Continue Button -->
                            <div class="d-grid">
                                <c:choose>
                                    <c:when test="${hasNext}">
                                        <a href="${pageContext.request.contextPath}/lectures?lectureId=${nextLectureId}&courseId=${courseId}" 
                                           class="btn btn-success btn-lg">
                                            <i class="bi bi-play-fill me-2"></i>
                                            Continue
                                        </a>
                                    </c:when>
                                    <c:otherwise>
                                        <a href="${pageContext.request.contextPath}/course?courseId=${courseId}" 
                                           class="btn btn-success btn-lg">
                                            <i class="bi bi-check-circle-fill me-2"></i>
                                            Complete Course
                                        </a>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Related Assignments -->
                    <c:if test="${not empty assignments}">
                        <div class="mt-5">
                            <h5 class="fw-bold mb-3">
                                <i class="bi bi-clipboard-check me-2"></i>
                                Related Assignments
                            </h5>
                            <div class="row">
                                <c:forEach var="assignment" items="${assignments}">
                                    <div class="col-md-6 mb-3">
                                        <div class="card border-0 shadow-sm">
                                            <div class="card-body">
                                                <h6 class="card-title">${assignment.title}</h6>
                                                <p class="card-text text-muted small">${assignment.description}</p>
                                                <a href="${pageContext.request.contextPath}/assignments?assignmentId=${assignment.id}" 
                                                   class="btn btn-outline-primary btn-sm">
                                                    View Assignment
                                                </a>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <style>
        .list-group-item.active {
            background-color: #0d6efd;
            border-color: #0d6efd;
        }
        
        .content-text {
            line-height: 1.8;
        }
        
        .content-text p {
            margin-bottom: 1.2rem;
        }
        
        .content-text h1, .content-text h2, .content-text h3 {
            margin-top: 2rem;
            margin-bottom: 1rem;
        }
    </style>
</body>
</html>