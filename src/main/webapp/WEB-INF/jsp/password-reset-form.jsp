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
            word-break: break-all;
        }
        
        .form-floating {
            margin-bottom: 1rem;
        }
        
        .password-requirements {
            background: #f8f9fa;
            border-radius: 8px;
            padding: 1rem;
            margin-bottom: 1rem;
            font-size: 0.875rem;
        }
        
        .password-requirements h6 {
            color: #495057;
            margin-bottom: 0.5rem;
            font-weight: 600;
        }
        
        .password-requirements ul {
            margin: 0;
            padding-left: 1.25rem;
        }
        
        .password-requirements li {
            color: #6c757d;
            margin-bottom: 0.25rem;
        }
        
        .password-strength {
            height: 4px;
            border-radius: 2px;
            background: #e9ecef;
            margin-top: 0.5rem;
            overflow: hidden;
        }
        
        .password-strength-bar {
            height: 100%;
            width: 0%;
            transition: all 0.3s ease;
            border-radius: 2px;
        }
        
        .strength-weak { background: #dc3545; }
        .strength-fair { background: #fd7e14; }
        .strength-good { background: #ffc107; }
        .strength-strong { background: #28a745; }
        
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
                <i class="fas fa-key"></i>
                <h2>Create New Password</h2>
                <p>Setting new password for: <strong>${email}</strong></p>
            </div>
            
            <c:if test="${not empty error}">
                <div class="alert alert-danger">
                    <i class="fas fa-exclamation-triangle me-2"></i>
                    ${error}
                </div>
            </c:if>
            
            <div class="password-requirements">
                <h6><i class="fas fa-shield-alt me-2"></i>Password Requirements</h6>
                <ul>
                    <li>At least 6 characters long</li>
                    <li>Mix of uppercase and lowercase letters (recommended)</li>
                    <li>Include numbers and special characters (recommended)</li>
                </ul>
            </div>
            
            <form id="resetPasswordForm" method="post" action="<c:url value='/password-reset/verify'/>">
                <input type="hidden" name="token" value="${token}">
                
                <div class="form-floating">
                    <input type="password" class="form-control" id="newPassword" name="newPassword" 
                           placeholder="New Password" required minlength="6">
                    <label for="newPassword">
                        <i class="fas fa-lock me-2"></i>New Password
                    </label>
                    <div class="password-strength">
                        <div class="password-strength-bar" id="strengthBar"></div>
                    </div>
                    <small class="text-muted" id="strengthText"></small>
                </div>
                
                <div class="form-floating">
                    <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" 
                           placeholder="Confirm Password" required minlength="6">
                    <label for="confirmPassword">
                        <i class="fas fa-lock me-2"></i>Confirm Password
                    </label>
                    <div class="invalid-feedback" id="passwordMismatch">
                        Passwords do not match
                    </div>
                </div>
                
                <button type="submit" class="btn btn-reset btn-primary w-100" id="submitBtn" disabled>
                    <span class="btn-text">
                        <i class="fas fa-check me-2"></i>Reset Password
                    </span>
                    <span class="btn-loading d-none">
                        <div class="spinner-border spinner-border-sm me-2" role="status">
                            <span class="visually-hidden">Loading...</span>
                        </div>
                        Resetting...
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
        const newPasswordInput = document.getElementById('newPassword');
        const confirmPasswordInput = document.getElementById('confirmPassword');
        const strengthBar = document.getElementById('strengthBar');
        const strengthText = document.getElementById('strengthText');
        const submitBtn = document.getElementById('submitBtn');
        const passwordMismatch = document.getElementById('passwordMismatch');
        
        // Password strength checker
        function checkPasswordStrength(password) {
            let score = 0;
            let feedback = [];
            
            if (password.length >= 8) score += 2;
            else if (password.length >= 6) score += 1;
            
            if (/[a-z]/.test(password) && /[A-Z]/.test(password)) score += 2;
            else if (/[a-z]/.test(password) || /[A-Z]/.test(password)) score += 1;
            
            if (/\d/.test(password)) score += 1;
            if (/[^a-zA-Z0-9]/.test(password)) score += 1;
            
            if (score >= 6) return { strength: 'strong', color: 'strength-strong', text: 'Strong password' };
            if (score >= 4) return { strength: 'good', color: 'strength-good', text: 'Good password' };
            if (score >= 2) return { strength: 'fair', color: 'strength-fair', text: 'Fair password' };
            return { strength: 'weak', color: 'strength-weak', text: 'Weak password' };
        }
        
        // Update password strength indicator
        newPasswordInput.addEventListener('input', function() {
            const password = this.value;
            if (password.length === 0) {
                strengthBar.style.width = '0%';
                strengthBar.className = 'password-strength-bar';
                strengthText.textContent = '';
            } else {
                const result = checkPasswordStrength(password);
                const percentage = password.length >= 6 ? 
                    (result.strength === 'weak' ? 25 : 
                     result.strength === 'fair' ? 50 : 
                     result.strength === 'good' ? 75 : 100) : 25;
                
                strengthBar.style.width = percentage + '%';
                strengthBar.className = 'password-strength-bar ' + result.color;
                strengthText.textContent = result.text;
            }
            validateForm();
        });
        
        // Check password confirmation
        confirmPasswordInput.addEventListener('input', validateForm);
        
        function validateForm() {
            const password = newPasswordInput.value;
            const confirmPassword = confirmPasswordInput.value;
            const passwordsMatch = password === confirmPassword;
            const passwordValid = password.length >= 6;
            
            // Show/hide password mismatch message
            if (confirmPassword.length > 0 && !passwordsMatch) {
                confirmPasswordInput.classList.add('is-invalid');
                passwordMismatch.style.display = 'block';
            } else {
                confirmPasswordInput.classList.remove('is-invalid');
                passwordMismatch.style.display = 'none';
            }
            
            // Enable/disable submit button
            submitBtn.disabled = !(passwordValid && passwordsMatch && confirmPassword.length > 0);
        }
        
        // Handle form submission
        document.getElementById('resetPasswordForm').addEventListener('submit', async function(e) {
            e.preventDefault();
            
            const form = this;
            const submitBtn = form.querySelector('#submitBtn');
            const btnText = submitBtn.querySelector('.btn-text');
            const btnLoading = submitBtn.querySelector('.btn-loading');
            
            // Show loading state
            btnText.classList.add('d-none');
            btnLoading.classList.remove('d-none');
            submitBtn.disabled = true;
            
            // Remove previous alerts
            document.querySelectorAll('.alert').forEach(alert => alert.remove());
            
            try {
                const formData = new FormData(form);
                const response = await fetch(form.action, {
                    method: 'POST',
                    body: new URLSearchParams(formData)
                });
                
                const result = await response.json();
                
                if (result.success) {
                    // Show success message and redirect
                    const successDiv = document.createElement('div');
                    successDiv.className = 'alert alert-success';
                    successDiv.innerHTML = `
                        <i class="fas fa-check-circle me-2"></i>
                        ${result.message}
                    `;
                    form.insertBefore(successDiv, form.firstChild);
                    
                    // Redirect to login after 3 seconds
                    setTimeout(() => {
                        window.location.href = '/login';
                    }, 3000);
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
