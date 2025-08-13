<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${pageTitle} - Learning Platform</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="<c:url value='/css/modern-ui.css'/>" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .reset-container {
            min-height: 100vh;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            display: flex;
            align-items: center;
            justify-content: center;
        }
        
        .reset-card {
            background: white;
            border-radius: 15px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.1);
            padding: 2rem;
            width: 100%;
            max-width: 450px;
        }
        
        .reset-header {
            text-align: center;
            margin-bottom: 2rem;
        }
        
        .reset-header i {
            font-size: 3rem;
            color: #667eea;
            margin-bottom: 1rem;
        }
        
        .reset-header h2 {
            color: #333;
            font-weight: 600;
            margin-bottom: 0.5rem;
        }
        
        .reset-header p {
            color: #666;
            margin: 0;
        }
        
        .form-floating {
            margin-bottom: 1rem;
        }
        
        .btn-reset {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            border-radius: 10px;
            padding: 12px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            transition: all 0.3s ease;
        }
        
        .btn-reset:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
        }
        
        .alert {
            border-radius: 10px;
            border: none;
            margin-bottom: 1rem;
        }
        
        .back-link {
            text-align: center;
            margin-top: 1.5rem;
        }
        
        .back-link a {
            color: #667eea;
            text-decoration: none;
            font-weight: 500;
        }
        
        .back-link a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <div class="reset-container">
        <div class="reset-card">
            <div class="reset-header">
                <i class="fas fa-lock"></i>
                <h2>Reset Password</h2>
                <p>Enter your email address to receive a password reset link</p>
            </div>
            
            <c:if test="${not empty error}">
                <div class="alert alert-danger">
                    <i class="fas fa-exclamation-triangle me-2"></i>
                    ${error}
                </div>
            </c:if>
            
            <c:if test="${not empty message}">
                <div class="alert alert-success">
                    <i class="fas fa-check-circle me-2"></i>
                    ${message}
                </div>
            </c:if>
            
            <form id="resetRequestForm" method="post">
                <div class="form-floating">
                    <input type="email" class="form-control" id="email" name="email" 
                           placeholder="name@example.com" required>
                    <label for="email">
                        <i class="fas fa-envelope me-2"></i>Email Address
                    </label>
                </div>
                
                <button type="submit" class="btn btn-reset btn-primary w-100">
                    <span class="btn-text">
                        <i class="fas fa-paper-plane me-2"></i>Send Reset Link
                    </span>
                    <span class="btn-loading d-none">
                        <div class="spinner-border spinner-border-sm me-2" role="status">
                            <span class="visually-hidden">Loading...</span>
                        </div>
                        Sending...
                    </span>
                </button>
            </form>
            
            <div class="back-link">
                <a href="<c:url value='/login'/>">
                    <i class="fas fa-arrow-left me-2"></i>Back to Login
                </a>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        document.getElementById('resetRequestForm').addEventListener('submit', async function(e) {
            e.preventDefault();
            
            const form = this;
            const submitBtn = form.querySelector('button[type="submit"]');
            const btnText = submitBtn.querySelector('.btn-text');
            const btnLoading = submitBtn.querySelector('.btn-loading');
            const email = form.querySelector('#email').value;
            
            // Show loading state
            btnText.classList.add('d-none');
            btnLoading.classList.remove('d-none');
            submitBtn.disabled = true;
            
            // Remove previous alerts
            document.querySelectorAll('.alert').forEach(alert => alert.remove());
            
            try {
                const response = await fetch('/password-reset/', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: `email=${encodeURIComponent(email)}`
                });
                
                const result = await response.json();
                
                if (result.success) {
                    // Show success message
                    const successDiv = document.createElement('div');
                    successDiv.className = 'alert alert-success';
                    successDiv.innerHTML = `
                        <i class="fas fa-check-circle me-2"></i>
                        ${result.message}
                    `;
                    form.insertBefore(successDiv, form.firstChild);
                    
                    // Clear form
                    form.reset();
                } else {
                    // Show error message
                    const errorDiv = document.createElement('div');
                    errorDiv.className = 'alert alert-danger';
                    errorDiv.innerHTML = `
                        <i class="fas fa-exclamation-triangle me-2"></i>
                        ${result.error}
                    `;
                    form.insertBefore(errorDiv, form.firstChild);
                }
            } catch (error) {
                console.error('Error:', error);
                const errorDiv = document.createElement('div');
                errorDiv.className = 'alert alert-danger';
                errorDiv.innerHTML = `
                    <i class="fas fa-exclamation-triangle me-2"></i>
                    An error occurred. Please try again later.
                `;
                form.insertBefore(errorDiv, form.firstChild);
            } finally {
                // Reset button state
                btnText.classList.remove('d-none');
                btnLoading.classList.add('d-none');
                submitBtn.disabled = false;
            }
        });
    </script>
</body>
</html>
