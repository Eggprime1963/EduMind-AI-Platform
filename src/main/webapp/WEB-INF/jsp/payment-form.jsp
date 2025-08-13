<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Payment - Learning Platform</title>
    <!-- Modern UI CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/modern-ui.css">
    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css" rel="stylesheet">
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 1rem;
        }
        .payment-container {
            max-width: 600px;
            width: 100%;
            background: white;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.2);
            overflow: hidden;
        }
        .payment-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 2rem;
            text-align: center;
        }
        .course-info {
            background: #f8f9fa;
            padding: 1.5rem;
            border-bottom: 1px solid #dee2e6;
        }
        .price-display {
            font-size: 2.5rem;
            font-weight: 700;
            color: #38a169;
            text-align: center;
            margin: 1rem 0;
        }
        .vnpay-logo {
            max-height: 60px;
            margin: 1rem 0;
        }
        .security-note {
            background: #e3f2fd;
            border-left: 4px solid #2196f3;
            padding: 1rem;
            margin: 1rem 0;
        }
    </style>
</head>
<body data-user-id="${sessionScope.userId}" data-user-role="${sessionScope.userRole}">
    <div class="payment-container">
        <!-- Header -->
        <div class="payment-header">
            <h2><i class="bi bi-credit-card"></i> Course Enrollment Payment</h2>
            <p class="mb-0">Secure payment powered by VNPay</p>
        </div>

        <!-- Course Information -->
        <div class="course-info">
            <h4><i class="bi bi-book"></i> ${course.name}</h4>
            <p class="text-gray-600 mb-2">${course.description}</p>
            <div class="flex justify-between items-center">
                <div>
                    <strong>Course ID:</strong> ${course.idCourse}
                </div>
                <div class="price-display">
                    <fmt:formatNumber value="${price}" type="number" groupingUsed="true"/> VND
                </div>
            </div>
        </div>

        <!-- Payment Form -->
        <div class="p-6">
            <div class="text-center mb-6">
                <img src="https://pay.vnpay.vn/images/brands/logo-en.svg" alt="VNPay" class="vnpay-logo">
                <p class="text-gray-500">You will be redirected to VNPay to complete your payment</p>
                </div>

                <div class="security-note">
                    <h6><i class="bi bi-shield-check me-2"></i>Payment Security</h6>
                    <ul class="mb-0 small">
                        <li>All transactions are encrypted and secure</li>
                        <li>Your payment information is protected</li>
                        <li>SSL encryption ensures data security</li>
                    </ul>
                </div>

            </div>

            <form id="paymentForm" action="${pageContext.request.contextPath}/payment" method="post">
                <input type="hidden" name="action" value="initiate">
                <input type="hidden" name="courseId" value="${course.idCourse}">
                <input type="hidden" name="amount" value="${price}">
                
                <div class="payment-amount mb-6">
                    <div class="text-center">
                        <p class="text-lg mb-2"><strong>Payment Amount:</strong></p>
                        <div class="price-display">
                            <fmt:formatNumber value="${price}" type="number" groupingUsed="true"/> VND
                        </div>
                    </div>
                </div>

                <!-- Payment Methods -->
                <div class="payment-methods mb-6">
                    <div class="payment-method selected">
                        <input type="radio" name="paymentMethod" value="vnpay" checked>
                        <img src="https://pay.vnpay.vn/images/brands/logo-en.svg" alt="VNPay" class="payment-method-icon">
                        <div>
                            <strong>VNPay</strong>
                            <p class="text-sm text-gray-600 mb-0">Secure payment with VNPay gateway</p>
                        </div>
                    </div>
                </div>

                <div class="text-center">
                    <button type="submit" class="btn btn-primary btn-lg w-full mb-4">
                        <i class="bi bi-credit-card"></i>
                        Proceed to Payment
                    </button>
                    
                    <a href="${pageContext.request.contextPath}/course" class="btn btn-secondary">
                        <i class="bi bi-arrow-left"></i>
                        Back to Courses
                    </a>
                </div>
            </form>

            <!-- Security Notice -->
            <div class="security-note mt-4">
                <h6><i class="bi bi-shield-check"></i> Security Information</h6>
                <p class="mb-2 text-sm">Your payment is processed securely through VNPay's encrypted gateway.</p>
                <p class="mb-0 text-sm"><strong>Accepted Payment Methods:</strong></p>
                <ul class="text-sm mb-0 mt-2">
                    <li>Domestic ATM/Debit Cards</li>
                    <li>International Visa/Mastercard</li>
                    <li>Mobile Banking (QR Code)</li>
                    <li>E-wallets (VNPay, ZaloPay, etc.)</li>
                </ul>
            </div>
        </div>
    </div>

    <!-- Loading Spinner -->
    <div id="loadingSpinner" class="loading-overlay hidden">
        <div class="loading-spinner"></div>
    </div>

    <!-- Scripts -->
    <script src="${pageContext.request.contextPath}/js/api-service.js"></script>
    <script src="${pageContext.request.contextPath}/js/payment-manager.js"></script>
    
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const form = document.getElementById('paymentForm');
            
            form.addEventListener('submit', function(e) {
                e.preventDefault();
                
                // Show loading
                document.getElementById('loadingSpinner').classList.remove('hidden');
                
                // Submit form after short delay for UX
                setTimeout(() => {
                    form.submit();
                }, 500);
            });
        });
    </script>
</body>
</html>
