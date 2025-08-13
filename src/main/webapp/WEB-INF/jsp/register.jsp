<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Map" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register - Learning Platform</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <!-- Custom CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/homePage.css"/>
    <!-- Google Fonts: Inter -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        .register-container {
            display: flex;
            gap: 2rem;
            margin-top: 3rem;
            flex-wrap: wrap;
        }
        .register-info {
            flex: 1 1 320px;
            min-width: 280px;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .register-form {
            flex: 1 1 340px;
            background: var(--bs-light, #fff);
            border-radius: 16px;
            box-shadow: 0 4px 16px rgba(0,0,0,0.08);
            padding: 2rem;
            min-width: 320px;
        }
        .register-form label {
            font-weight: 500;
        }
        .register-form .form-control, .register-form .form-select {
            border-radius: 8px;
            margin-bottom: 1rem;
        }
        .register-form .btn {
            width: 100%;
            font-weight: 600;
            border-radius: 8px;
        }
        @media (max-width: 900px) {
            .register-container { flex-direction: column; }
        }
    </style>
</head>
<body>
<jsp:include page="navbar.jsp" />
<div class="container register-container">
    <div class="register-info">
        <div>
            <h2>Register</h2>
            <p>Join our platform to access courses, track your progress, and connect with a vibrant learning community.</p>
        </div>
    </div>
    <form class="register-form" method="post" action="${pageContext.request.contextPath}/register">
        <c:if test="${not empty message}">
            <div class="alert alert-info" role="alert">
                ${message}
            </div>
        </c:if>
        <div class="row mb-3">
            <div class="col">
                <label for="first_name" class="form-label">First Name*</label>
                <input type="text" name="first_name" id="first_name" class="form-control" value="${sessionScope.tempGoogleFirstName}" required>
            </div>
            <div class="col">
                <label for="last_name" class="form-label">Last Name*</label>
                <input type="text" name="last_name" id="last_name" class="form-control" value="${sessionScope.tempGoogleLastName}" required>
            </div>
        </div>
        <div class="mb-3">
            <label for="username" class="form-label">Username*</label>
            <input type="text" name="username" id="username" class="form-control" value="${sessionScope.tempGoogleEmail}" required>
        </div>
        <div class="mb-3">
            <label for="email" class="form-label">Email*</label>
            <input type="email" name="email" id="email" class="form-control" value="${sessionScope.tempGoogleEmail}" required>
        </div>
        <!-- Only show password fields if NOT Google registration -->
        <c:if test="${empty sessionScope.tempGoogleId}">
            <div class="mb-3">
                <label for="password" class="form-label">Password*</label>
                <input type="password" name="password" id="password" class="form-control" required>
            </div>
            <div class="mb-3">
                <label for="confirmPassword" class="form-label">Confirm Password*</label>
                <input type="password" name="confirmPassword" id="confirmPassword" class="form-control" required>
            </div>
        </c:if>
        <div class="row mb-3">
            <div class="col"><label for="gender" class="form-label">Your gender is</label></div>
            <div class="col">
            <div class="btn-group w-100" role="group">
                <input type="radio" class="btn-check" name="gender" id="male" value="Male" checked>
                <label class="btn btn-outline-primary" for="male">Male</label>
                <input type="radio" class="btn-check" name="gender" id="female" value="Female">
                <label class="btn btn-outline-primary" for="female">Female</label>
            </div>
            </div>
        </div>
        <div class="mb-3">
            <label for="dob" class="form-label">Date of Birth</label>
            <input type="date" name="dob" id="dob" class="form-control">
        </div>
        <div class="mb-3">
            <label for="phone" class="form-label">Phone</label>
            <input type="text" name="phone" id="phone" class="form-control">
        </div>
        <div class="mb-3">
            <label for="address" class="form-label">Address</label>
            <input type="text" name="address" id="address" class="form-control">
        </div>
        <div class="mb-3">
            <label for="school" class="form-label">School</label>
            <input type="text" name="school" id="school" class="form-control">
        </div>
        <div class="row mb-3">
            <div class="col"><label for="role" class="form-label">You are a</label></div>
            <div class="col">
            <div class="btn-group w-100" role="group">
                <input type="radio" class="btn-check" name="role" id="student" value="student" checked>
                <label class="btn btn-outline-success" for="student">Student</label>
                <input type="radio" class="btn-check" name="role" id="teacher" value="teacher">
                <label class="btn btn-outline-success" for="teacher">Teacher</label>
            </div>
            </div>
        </div>
        <button type="submit" class="btn btn-success mt-2">Register</button>
    </form>
</div>
<footer class="text-center mt-5 mb-3" style="color:#888;">copyright text</footer>
<!-- Bootstrap JS and Popper.js -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<!-- Theme Toggle Script -->
<script>
    document.addEventListener('DOMContentLoaded', () => {
        const htmlElement = document.documentElement;
        const currentTheme = localStorage.getItem('theme') || 'light';
        htmlElement.setAttribute('data-theme', currentTheme);
    });
</script>
<script>
    function b64DecodeUnicode(str) {
        return decodeURIComponent(Array.prototype.map.call(atob(str), function(c) {
            return '%' + ('00' + c.charCodeAt(0).toString(16)).slice(-2);
        }).join(''));
    }
    const payload = JSON.parse(b64DecodeUnicode(idToken.split('.')[1]));
</script>
</body>
</html>
