<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${errorTitle != null ? errorTitle : 'Error'} - Learning Platform</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .error-container {
            background: white;
            border-radius: 20px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.1);
            padding: 3rem;
            text-align: center;
            max-width: 600px;
            width: 90%;
        }
        .error-icon {
            font-size: 5rem;
            margin-bottom: 1rem;
        }
        .error-403 { color: #dc3545; }
        .error-404 { color: #ffc107; }
        .error-500 { color: #6f42c1; }
        .error-default { color: #6c757d; }
        
        .error-title {
            font-size: 2.5rem;
            font-weight: bold;
            margin-bottom: 1rem;
        }
        .error-message {
            font-size: 1.2rem;
            color: #6c757d;
            margin-bottom: 2rem;
        }
        .action-buttons {
            display: flex;
            gap: 1rem;
            justify-content: center;
            flex-wrap: wrap;
        }
        .btn-custom {
            padding: 0.75rem 2rem;
            border-radius: 50px;
            font-weight: 600;
            text-decoration: none;
            transition: all 0.3s ease;
        }
        .btn-primary-custom {
            background: linear-gradient(45deg, #667eea, #764ba2);
            border: none;
            color: white;
        }
        .btn-primary-custom:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(0,0,0,0.2);
            color: white;
        }
        .btn-outline-custom {
            border: 2px solid #667eea;
            color: #667eea;
            background: transparent;
        }
        .btn-outline-custom:hover {
            background: #667eea;
            color: white;
            transform: translateY(-2px);
        }
    </style>
</head>
<jsp:include page="navbar.jsp"/>
<body>
    <div class="error-container">
        <!-- Dynamic Error Icon -->
        <div class="error-icon">
            <c:choose>
                <c:when test="${errorCode == '403'}">
                    <i class="fas fa-lock error-403"></i>
                </c:when>
                <c:when test="${errorCode == '404'}">
                    <i class="fas fa-exclamation-triangle error-404"></i>
                </c:when>
                <c:when test="${errorCode == '500'}">
                    <i class="fas fa-server error-500"></i>
                </c:when>
                <c:otherwise>
                    <i class="fas fa-exclamation-circle error-default"></i>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- Dynamic Error Title -->
        <h1 class="error-title">
            <c:choose>
                <c:when test="${errorTitle != null}">
                    ${errorTitle}
                </c:when>
                <c:when test="${errorCode == '403'}">
                    Access Denied
                </c:when>
                <c:when test="${errorCode == '404'}">
                    Page Not Found
                </c:when>
                <c:when test="${errorCode == '500'}">
                    Server Error
                </c:when>
                <c:otherwise>
                    Oops! Something went wrong
                </c:otherwise>
            </c:choose>
        </h1>

        <!-- Dynamic Error Message -->
        <p class="error-message">
            <c:choose>
                <c:when test="${errorMessage != null}">
                    ${errorMessage}
                </c:when>
                <c:when test="${errorCode == '403'}">
                    You don't have permission to access this resource. Please contact your administrator if you believe this is an error.
                </c:when>
                <c:when test="${errorCode == '404'}">
                    The page you're looking for doesn't exist. It might have been moved, deleted, or you entered the wrong URL.
                </c:when>
                <c:when test="${errorCode == '500'}">
                    We're experiencing technical difficulties. Our team has been notified and is working to fix the issue.
                </c:when>
                <c:otherwise>
                    An unexpected error occurred. Please try again later or contact support if the problem persists.
                </c:otherwise>
            </c:choose>
        </p>

        <!-- Action Buttons -->
        <div class="action-buttons">
            <c:if test="${sessionScope.user != null}">
                <a href="${pageContext.request.contextPath}/home" class="btn btn-custom btn-primary-custom">
                    <i class="fas fa-home me-2"></i>Go to Dashboard
                </a>
            </c:if>
            
            <c:if test="${sessionScope.user == null}">
                <a href="${pageContext.request.contextPath}/login" class="btn btn-custom btn-primary-custom">
                    <i class="fas fa-sign-in-alt me-2"></i>Login
                </a>
            </c:if>

            <a href="javascript:history.back()" class="btn btn-custom btn-outline-custom">
                <i class="fas fa-arrow-left me-2"></i>Go Back
            </a>

            <c:if test="${errorCode == '403' && sessionScope.user != null}">
                <a href="${pageContext.request.contextPath}/profile" class="btn btn-custom btn-outline-custom">
                    <i class="fas fa-user me-2"></i>My Profile
                </a>
            </c:if>
        </div>

        <!-- Additional Info for Development -->
        <c:if test="${param.debug == 'true' && sessionScope.role == 'admin'}">
            <div class="mt-4 p-3 bg-light rounded">
                <small class="text-muted">
                    <strong>Debug Info:</strong><br>
                    Error Code: ${errorCode}<br>
                    User Role: ${sessionScope.role}<br>
                    Request URI: ${pageContext.request.requestURI}<br>
                    <c:if test="${exception != null}">
                        Exception: ${exception.class.simpleName}<br>
                        Message: ${exception.message}
                    </c:if>
                </small>
            </div>
        </c:if>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
