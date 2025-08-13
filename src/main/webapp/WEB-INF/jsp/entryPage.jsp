<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
    <meta charset="UTF-8">
    <title>Welcome - LearnHub</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/homePage.css"/>
    <style>
        body { background: #f8f9fa; color: #222; }
        .entry-card { background: #fff; border-radius: 16px; box-shadow: 0 4px 16px rgba(0,0,0,0.08); }
        .course-card { background: #f5f5f5; color: #222; border: none; }
        .course-card img { border-radius: 8px 8px 0 0; }
        .ai-section { background: #e9ecef; border-radius: 12px; padding: 1.5rem; margin-top: 2rem; }
        .book-icon-container { display: flex; align-items: center; }
        .book-icon { font-size: 2rem; margin-right: 0.5rem; color: #222; }
        .play-button svg { width: 24px; height: 24px; fill: #0d6efd; }
        .feature-title { font-weight: 600; }
    </style>
</head>
<body>
    <%@ include file="navbar.jsp" %>
    <div class="container py-5">
        <div class="row justify-content-center">
            <!-- Left column: Intro and actions -->
            <div class="col-lg-5 mb-4">
                <div class="entry-card p-5 text-center">
                    <h1 class="fw-bold mb-3">Welcome to LearnHub</h1>
                    <p class="lead mb-4">
                        Unlock your learning journey! Sign up or log in to access personalized courses, track your progress, and get AI-powered recommendations tailored just for you.
                    </p>
                    <a href="${pageContext.request.contextPath}/login" class="btn btn-primary btn-lg me-3">Login</a>
                    <a href="${pageContext.request.contextPath}/register" class="btn btn-outline-primary btn-lg">Register</a>
                </div>
            </div>
            <!-- Right column: AI Recommended Courses from DB -->
            <div class="col-lg-7">
                <h3 class="mb-4">AI Recommended Courses</h3>
                <div class="row">
                    <c:forEach var="course" items="${courses}">
                        <div class="col-md-4 mb-4">
                            <div class="card course-card">
                                <img src="${pageContext.request.contextPath}/img/${course.thumbnail}" class="card-img-top" alt="Course Thumbnail">
                                <div class="card-body">
                                    <h5 class="card-title">${course.name}</h5>
                                    <p class="card-text">${course.description}</p>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
                <p class="text-center text-muted mt-3">Sign up and log in to get personalized course recommendations powered by AI.</p>
            </div>
        </div>
    </div>
</body>
</html>