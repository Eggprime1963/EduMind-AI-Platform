// Payment Management Component
class PaymentManager {
    constructor() {
        this.payments = [];
        this.vnpayConfig = {
            vnp_TmnCode: 'YOUR_TMN_CODE',
            vnp_HashSecret: 'YOUR_HASH_SECRET',
            vnp_Url: 'https://sandbox.vnpayment.vn/paymentv2/vpcpay.html',
            vnp_ReturnUrl: window.location.origin + '/vnpay-result.jsp'
        };
        this.init();
    }

    init() {
        this.bindEvents();
        this.loadPayments();
        this.initializePaymentForm();
    }

    bindEvents() {
        // Payment form submission
        const paymentForm = document.getElementById('paymentForm');
        if (paymentForm) {
            paymentForm.addEventListener('submit', (e) => this.handlePayment(e));
        }

        // Course enrollment payment
        document.addEventListener('click', (e) => {
            if (e.target.matches('.enroll-course')) {
                this.handleCourseEnrollment(e.target.dataset.courseId);
            }
            if (e.target.matches('.view-payment')) {
                this.viewPayment(e.target.dataset.paymentId);
            }
            if (e.target.matches('.refund-payment')) {
                this.handleRefund(e.target.dataset.paymentId);
            }
        });

        // Payment method selection
        const paymentMethods = document.querySelectorAll('input[name="paymentMethod"]');
        paymentMethods.forEach(method => {
            method.addEventListener('change', () => this.updatePaymentUI());
        });
    }

    async loadPayments() {
        try {
            this.showLoading();
            const userId = this.getCurrentUserId();
            const userRole = this.getCurrentUserRole();
            
            let payments;
            if (userRole === 'admin') {
                payments = await window.api.getAllPayments();
            } else {
                payments = await window.api.getPaymentsByUser(userId);
            }
            
            this.payments = payments;
            this.renderPayments();
        } catch (error) {
            this.showError('Failed to load payments: ' + error.message);
        } finally {
            this.hideLoading();
        }
    }

    initializePaymentForm() {
        const courseSelect = document.getElementById('courseSelect');
        if (courseSelect) {
            this.loadAvailableCourses();
        }
    }

    async loadAvailableCourses() {
        try {
            const courses = await window.api.getEnrollableCourses(this.getCurrentUserId());
            const courseSelect = document.getElementById('courseSelect');
            
            courseSelect.innerHTML = '<option value="">Select a course</option>' +
                courses.map(course => `
                    <option value="${course.id}" data-price="${course.price}">
                        ${course.name} - $${course.price}
                    </option>
                `).join('');

            courseSelect.addEventListener('change', (e) => {
                const selectedOption = e.target.selectedOptions[0];
                const price = selectedOption?.dataset.price || 0;
                this.updatePaymentAmount(price);
            });
        } catch (error) {
            console.error('Failed to load courses:', error);
        }
    }

    updatePaymentAmount(amount) {
        const amountInput = document.getElementById('paymentAmount');
        if (amountInput) {
            amountInput.value = amount;
        }
        
        const displayAmount = document.getElementById('displayAmount');
        if (displayAmount) {
            displayAmount.textContent = `$${amount}`;
        }
    }

    async handlePayment(e) {
        e.preventDefault();
        
        const formData = new FormData(e.target);
        const paymentData = {
            courseId: formData.get('courseId'),
            amount: formData.get('amount'),
            paymentMethod: formData.get('paymentMethod'),
            studentId: this.getCurrentUserId()
        };

        if (!paymentData.courseId || !paymentData.amount) {
            this.showError('Please select a course and verify the amount.');
            return;
        }

        try {
            this.showLoading();
            
            if (paymentData.paymentMethod === 'vnpay') {
                await this.processVNPayPayment(paymentData);
            } else if (paymentData.paymentMethod === 'card') {
                await this.processCreditCardPayment(paymentData);
            } else {
                throw new Error('Invalid payment method selected');
            }
            
        } catch (error) {
            this.showError('Payment failed: ' + error.message);
        } finally {
            this.hideLoading();
        }
    }

    async processVNPayPayment(paymentData) {
        try {
            // Create payment order first
            const order = await window.api.createPaymentOrder(paymentData);
            
            // Generate VNPay payment URL
            const vnpayData = {
                vnp_Version: '2.1.0',
                vnp_Command: 'pay',
                vnp_TmnCode: this.vnpayConfig.vnp_TmnCode,
                vnp_Locale: 'vn',
                vnp_CurrCode: 'VND',
                vnp_TxnRef: order.orderCode,
                vnp_OrderInfo: `Payment for course enrollment - Order ${order.orderCode}`,
                vnp_OrderType: 'other',
                vnp_Amount: Math.round(paymentData.amount * 23000 * 100), // Convert USD to VND cents
                vnp_ReturnUrl: this.vnpayConfig.vnp_ReturnUrl,
                vnp_IpAddr: await this.getClientIP(),
                vnp_CreateDate: this.formatDate(new Date())
            };

            // Generate payment URL
            const paymentUrl = await window.api.generateVNPayUrl(vnpayData);
            
            this.showSuccess('Redirecting to VNPay...');
            
            // Redirect to VNPay
            setTimeout(() => {
                window.location.href = paymentUrl;
            }, 1000);
            
        } catch (error) {
            throw new Error('VNPay payment setup failed: ' + error.message);
        }
    }

    async processCreditCardPayment(paymentData) {
        // Simulate credit card processing
        const cardData = {
            cardNumber: document.getElementById('cardNumber')?.value,
            expiryDate: document.getElementById('expiryDate')?.value,
            cvv: document.getElementById('cvv')?.value,
            cardName: document.getElementById('cardName')?.value
        };

        if (!this.validateCreditCard(cardData)) {
            throw new Error('Invalid credit card information');
        }

        try {
            const result = await window.api.processCreditCardPayment({
                ...paymentData,
                cardData: cardData
            });

            if (result.success) {
                this.showSuccess('Payment processed successfully!');
                this.handlePaymentSuccess(result.paymentId);
            } else {
                throw new Error(result.message || 'Payment processing failed');
            }
        } catch (error) {
            throw new Error('Credit card payment failed: ' + error.message);
        }
    }

    validateCreditCard(cardData) {
        if (!cardData.cardNumber || cardData.cardNumber.length < 13) {
            this.showError('Invalid card number');
            return false;
        }
        
        if (!cardData.expiryDate || !/^\d{2}\/\d{2}$/.test(cardData.expiryDate)) {
            this.showError('Invalid expiry date (MM/YY)');
            return false;
        }
        
        if (!cardData.cvv || cardData.cvv.length < 3) {
            this.showError('Invalid CVV');
            return false;
        }
        
        if (!cardData.cardName || cardData.cardName.trim().length < 2) {
            this.showError('Invalid cardholder name');
            return false;
        }
        
        return true;
    }

    async handleCourseEnrollment(courseId) {
        try {
            const course = await window.api.getCourse(courseId);
            
            if (course.price === 0) {
                // Free course - direct enrollment
                await window.api.enrollInCourse(courseId, this.getCurrentUserId());
                this.showSuccess('Successfully enrolled in free course!');
                return;
            }

            // Paid course - show payment modal
            this.showPaymentModal(course);
            
        } catch (error) {
            this.showError('Enrollment failed: ' + error.message);
        }
    }

    showPaymentModal(course) {
        const modal = document.createElement('div');
        modal.className = 'modal-overlay fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50';
        modal.innerHTML = `
            <div class="modal-content bg-white rounded-lg p-6 max-w-md w-full mx-4">
                <div class="flex justify-between items-center mb-4">
                    <h2 class="text-xl font-bold">Course Enrollment</h2>
                    <button class="close-modal text-gray-500 hover:text-gray-700">×</button>
                </div>
                <div class="mb-4">
                    <h3 class="font-semibold text-lg">${course.name}</h3>
                    <p class="text-gray-600">${course.description}</p>
                    <p class="text-2xl font-bold text-green-600 mt-2">$${course.price}</p>
                </div>
                <form id="enrollmentPaymentForm" class="space-y-4">
                    <input type="hidden" name="courseId" value="${course.id}">
                    <input type="hidden" name="amount" value="${course.price}">
                    
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-2">Payment Method</label>
                        <div class="space-y-2">
                            <label class="flex items-center">
                                <input type="radio" name="paymentMethod" value="vnpay" checked class="mr-2">
                                <span>VNPay (Recommended)</span>
                            </label>
                            <label class="flex items-center">
                                <input type="radio" name="paymentMethod" value="card" class="mr-2">
                                <span>Credit Card</span>
                            </label>
                        </div>
                    </div>
                    
                    <div id="cardFields" class="hidden space-y-3">
                        <input type="text" id="cardNumber" placeholder="Card Number" 
                               class="w-full px-3 py-2 border rounded-lg focus:outline-none focus:border-blue-500">
                        <div class="grid grid-cols-2 gap-3">
                            <input type="text" id="expiryDate" placeholder="MM/YY" 
                                   class="px-3 py-2 border rounded-lg focus:outline-none focus:border-blue-500">
                            <input type="text" id="cvv" placeholder="CVV" 
                                   class="px-3 py-2 border rounded-lg focus:outline-none focus:border-blue-500">
                        </div>
                        <input type="text" id="cardName" placeholder="Cardholder Name" 
                               class="w-full px-3 py-2 border rounded-lg focus:outline-none focus:border-blue-500">
                    </div>
                    
                    <button type="submit" class="w-full bg-blue-500 text-white py-2 px-4 rounded-lg hover:bg-blue-600 transition-colors">
                        Pay $${course.price}
                    </button>
                </form>
            </div>
        `;

        // Event listeners for modal
        const closeBtn = modal.querySelector('.close-modal');
        closeBtn.addEventListener('click', () => modal.remove());

        const paymentMethodInputs = modal.querySelectorAll('input[name="paymentMethod"]');
        paymentMethodInputs.forEach(input => {
            input.addEventListener('change', () => {
                const cardFields = modal.querySelector('#cardFields');
                if (input.value === 'card') {
                    cardFields.classList.remove('hidden');
                } else {
                    cardFields.classList.add('hidden');
                }
            });
        });

        const form = modal.querySelector('#enrollmentPaymentForm');
        form.addEventListener('submit', async (e) => {
            e.preventDefault();
            const formData = new FormData(form);
            const paymentData = {
                courseId: formData.get('courseId'),
                amount: formData.get('amount'),
                paymentMethod: formData.get('paymentMethod'),
                studentId: this.getCurrentUserId()
            };

            try {
                if (paymentData.paymentMethod === 'vnpay') {
                    await this.processVNPayPayment(paymentData);
                } else {
                    await this.processCreditCardPayment(paymentData);
                }
                modal.remove();
            } catch (error) {
                this.showError(error.message);
            }
        });

        document.body.appendChild(modal);
    }

    async handlePaymentSuccess(paymentId) {
        try {
            // Reload payments and show success
            await this.loadPayments();
            this.showSuccess('Payment completed successfully! You are now enrolled in the course.');
            
            // Redirect to course or dashboard
            setTimeout(() => {
                window.location.href = '/courses';
            }, 2000);
        } catch (error) {
            console.error('Error handling payment success:', error);
        }
    }

    renderPayments() {
        const container = document.getElementById('paymentsContainer');
        if (!container) return;

        if (this.payments.length === 0) {
            container.innerHTML = `
                <div class="text-center py-8">
                    <p class="text-gray-500">No payments found.</p>
                </div>
            `;
            return;
        }

        container.innerHTML = this.payments.map(payment => `
            <div class="payment-item bg-white rounded-lg shadow-md p-6 mb-4">
                <div class="flex justify-between items-start">
                    <div class="flex-1">
                        <h3 class="text-lg font-semibold text-gray-800">${payment.courseName}</h3>
                        <p class="text-gray-600">Order #${payment.orderCode}</p>
                        <div class="mt-2 text-sm text-gray-500">
                            <p>Amount: $${payment.amount}</p>
                            <p>Date: ${new Date(payment.createdAt).toLocaleDateString()}</p>
                            <p>Method: ${payment.paymentMethod.toUpperCase()}</p>
                        </div>
                    </div>
                    <div class="flex flex-col items-end">
                        <span class="inline-block px-3 py-1 text-sm rounded-full ${
                            payment.status === 'completed' ? 'bg-green-100 text-green-800' :
                            payment.status === 'pending' ? 'bg-yellow-100 text-yellow-800' :
                            'bg-red-100 text-red-800'
                        }">
                            ${payment.status.charAt(0).toUpperCase() + payment.status.slice(1)}
                        </span>
                        <div class="mt-2 space-x-2">
                            <button class="view-payment text-blue-500 hover:text-blue-700 text-sm" 
                                    data-payment-id="${payment.id}">
                                View Details
                            </button>
                            ${payment.status === 'completed' && this.getCurrentUserRole() === 'admin' ? `
                                <button class="refund-payment text-red-500 hover:text-red-700 text-sm" 
                                        data-payment-id="${payment.id}">
                                    Refund
                                </button>
                            ` : ''}
                        </div>
                    </div>
                </div>
            </div>
        `).join('');
    }

    updatePaymentUI() {
        const selectedMethod = document.querySelector('input[name="paymentMethod"]:checked')?.value;
        const cardFields = document.getElementById('cardFields');
        
        if (cardFields) {
            if (selectedMethod === 'card') {
                cardFields.classList.remove('hidden');
            } else {
                cardFields.classList.add('hidden');
            }
        }
    }

    async getClientIP() {
        try {
            const response = await fetch('https://api.ipify.org?format=json');
            const data = await response.json();
            return data.ip;
        } catch (error) {
            return '127.0.0.1'; // fallback
        }
    }

    formatDate(date) {
        return date.toISOString().replace(/[-:]/g, '').replace(/\.\d{3}Z/, '');
    }

    getCurrentUserId() {
        return document.body.dataset.userId || 
               sessionStorage.getItem('userId') || 
               1;
    }

    getCurrentUserRole() {
        return document.body.dataset.userRole || 
               sessionStorage.getItem('userRole') || 
               'student';
    }

    showLoading() {
        const loader = document.getElementById('loadingSpinner');
        if (loader) loader.style.display = 'block';
    }

    hideLoading() {
        const loader = document.getElementById('loadingSpinner');
        if (loader) loader.style.display = 'none';
    }

    showSuccess(message) {
        this.showNotification(message, 'success');
    }

    showError(message) {
        this.showNotification(message, 'error');
    }

    showNotification(message, type = 'info') {
        const notification = document.createElement('div');
        notification.className = `notification notification-${type} fixed top-4 right-4 p-4 rounded-lg shadow-lg z-50`;
        
        const colors = {
            success: 'bg-green-500 text-white',
            error: 'bg-red-500 text-white',
            info: 'bg-blue-500 text-white'
        };
        
        notification.className += ` ${colors[type]}`;
        notification.innerHTML = `
            <div class="flex items-center">
                <span>${message}</span>
                <button class="ml-4 text-white hover:text-gray-200" onclick="this.parentElement.parentElement.remove()">
                    ×
                </button>
            </div>
        `;

        document.body.appendChild(notification);

        setTimeout(() => {
            if (notification.parentElement) {
                notification.remove();
            }
        }, 5000);
    }
}

// Initialize when DOM is loaded
document.addEventListener('DOMContentLoaded', () => {
    if (document.getElementById('paymentsContainer') || document.getElementById('paymentForm')) {
        window.paymentManager = new PaymentManager();
    }
});
