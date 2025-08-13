<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sign In - Learning Platform</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/homePage.css"/>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <meta name="google-signin-client_id" content="463263011713-mrrbjqdmf75o6r3lofr88hougr4imc9a.apps.googleusercontent.com">
    <script src="https://accounts.google.com/gsi/client" async defer></script>
    <style>
        .login-container {
            display: flex;
            gap: 2rem;
            margin-top: 3rem;
            flex-wrap: wrap;
        }
        .login-info {
            flex: 1 1 320px;
            min-width: 280px;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .login-form {
            flex: 1 1 340px;
            background: var(--bs-light, #fff);
            border-radius: 16px;
            box-shadow: 0 4px 16px rgba(0,0,0,0.08);
            padding: 2rem;
            min-width: 320px;
        }
        .login-form label {
            font-weight: 500;
        }
        .login-form .form-control {
            border-radius: 8px;
            margin-bottom: 1rem;
        }
        .login-form .btn {
            width: 100%;
            font-weight: 600;
            border-radius: 8px;
        }
        @media (max-width: 900px) {
            .login-container { flex-direction: column; }
        }
    </style>
</head>
<body>
<jsp:include page="navbar.jsp" />
<div class="container login-container">
    <div class="login-info">
        <div>
            <h2>Sign In</h2>
            <p>Access your courses, track your progress, and connect with the learning community.</p>
            <div style="display: flex; align-items: center; gap: var(--space-3);">
                <div style="width: 32px; height: 32px; background: rgba(255,255,255,0.2); border-radius: 50%; display: flex; align-items: center; justify-content: center;">
                    <i class="fas fa-play-circle"></i>
                </div>
                <span style="font-size: 0.875rem;">Resume where you left off</span>
            </div>
            <div style="display: flex; align-items: center; gap: var(--space-3);">
                <div style="width: 32px; height: 32px; background: rgba(255,255,255,0.2); border-radius: 50%; display: flex; align-items: center; justify-content: center;">
                    <i class="fas fa-chart-line"></i>
                </div>
                <span style="font-size: 0.875rem;">Track your learning progress</span>
            </div>
            <div style="display: flex; align-items: center; gap: var(--space-3);">
                <div style="width: 32px; height: 32px; background: rgba(255,255,255,0.2); border-radius: 50%; display: flex; align-items: center; justify-content: center;">
                    <i class="fas fa-certificate"></i>
                </div>
                <span style="font-size: 0.875rem;">Earn verified certificates</span>
            </div>
            </div>
    </div>
    <form class="login-form" method="post" action="${pageContext.request.contextPath}/login">
        <c:if test="${not empty message}">
            <div class="alert alert-info" role="alert">
                ${message}
            </div>
        </c:if>
        <div class="mb-3">
            <label for="username" class="form-label">Username or Email</label>
            <input type="text" class="form-control" id="username" name="username" required>
        </div>
        <div class="mb-3">
            <label for="password" class="form-label">Password</label>
            <input type="password" class="form-control" id="password" name="password" required>
        </div>
        <button type="submit" class="btn btn-primary mt-2 mb-3">Sign In</button>
        <div class="text-center mb-3">
            <div id="g_id_onload"
                 data-client_id="463263011713-mrrbjqdmf75o6r3lofr88hougr4imc9a.apps.googleusercontent.com"
                 data-callback="handleCredentialResponse"
                 data-auto_prompt="false">
            </div>
            <div class="g_id_signin" data-type="standard" data-size="large" data-theme="outline" data-text="sign_in_with" data-shape="rectangular"></div>
        </div>
        <p class="text-center">Don't have an account? <a href="${pageContext.request.contextPath}/register.jsp">Sign Up</a></p>
    </form>
</div>
<footer class="text-center mt-5 mb-3" style="color:#888;">copyright text</footer>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    document.addEventListener('DOMContentLoaded', () => {
        const htmlElement = document.documentElement;
        const currentTheme = localStorage.getItem('theme') || 'light';
        htmlElement.setAttribute('data-theme', currentTheme);
    });

    function parseJwt (token) {
        // Split the JWT and decode the payload
        var base64Url = token.split('.')[1];
        var base64 = base64Url.replace(/-/g, '+').replace(/_/g, '/');
        var jsonPayload = decodeURIComponent(atob(base64).split('').map(function(c) {
            return '%' + ('00' + c.charCodeAt(0).toString(16)).slice(-2);
        }).join(''));
        return JSON.parse(jsonPayload);
    }

    function handleCredentialResponse(response) {
        const idToken = response.credential;
        const payload = parseJwt(idToken);

        const googleId = payload.sub;
        const email = payload.email;
        const firstName = payload.given_name || "";
        const lastName = payload.family_name || "";
        const name = payload.name || "";

        fetch('${pageContext.request.contextPath}/login', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({
                googleId: googleId,
                email: email,
                firstName: firstName,
                lastName: lastName,
                idToken: idToken
            })
        })
        .then(response => {
            if (!response.ok) throw new Error('Server error');
            return response.json();
        })
        .then(data => {
            if (data.success && data.redirect) {
                window.location.href = data.redirect;
            } else if (data.register && data.redirect) {
                window.location.href = data.redirect;
            } else {
                alert(data.message || "Google login failed.");
            }
        })
        .catch(error => {
            alert("Login error: " + error);
        });
    }
</script>
</body>
</html>