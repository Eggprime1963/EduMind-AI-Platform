// Notification System for Learning Platform
class NotificationManager {
    constructor() {
        this.notifications = [];
        this.unreadCount = 0;
        this.isConnected = false;
        this.init();
    }

    init() {
        this.loadNotifications();
        this.initWebSocket();
        this.bindEvents();
        this.createNotificationUI();
    }

    createNotificationUI() {
        // Create notification bell icon in the header
        const userMenu = document.querySelector('.user-menu');
        if (userMenu && !document.getElementById('notificationBell')) {
            const notificationBell = document.createElement('div');
            notificationBell.id = 'notificationBell';
            notificationBell.className = 'notification-bell relative cursor-pointer';
            notificationBell.innerHTML = `
                <i class="bi bi-bell text-white text-xl"></i>
                <span id="notificationBadge" class="notification-badge hidden absolute -top-2 -right-2 bg-red-500 text-white text-xs rounded-full w-5 h-5 flex items-center justify-center">
                    0
                </span>
            `;
            userMenu.insertBefore(notificationBell, userMenu.firstChild);
        }

        // Create notification dropdown
        if (!document.getElementById('notificationDropdown')) {
            const dropdown = document.createElement('div');
            dropdown.id = 'notificationDropdown';
            dropdown.className = 'notification-dropdown fixed top-16 right-4 bg-white rounded-lg shadow-lg border w-80 max-h-96 overflow-y-auto z-50 hidden';
            dropdown.innerHTML = `
                <div class="notification-header p-4 border-b">
                    <div class="flex justify-between items-center">
                        <h3 class="font-semibold">Notifications</h3>
                        <button id="markAllRead" class="text-sm text-blue-600 hover:text-blue-800">
                            Mark all read
                        </button>
                    </div>
                </div>
                <div id="notificationList" class="notification-list">
                    <!-- Notifications will be populated here -->
                </div>
                <div class="notification-footer p-4 border-t text-center">
                    <a href="/notifications" class="text-sm text-blue-600 hover:text-blue-800">
                        View all notifications
                    </a>
                </div>
            `;
            document.body.appendChild(dropdown);
        }
    }

    bindEvents() {
        // Toggle notification dropdown
        document.addEventListener('click', (e) => {
            const bell = e.target.closest('#notificationBell');
            const dropdown = document.getElementById('notificationDropdown');
            
            if (bell) {
                e.stopPropagation();
                dropdown.classList.toggle('hidden');
                if (!dropdown.classList.contains('hidden')) {
                    this.markNotificationsAsRead();
                }
            } else if (!e.target.closest('#notificationDropdown')) {
                dropdown.classList.add('hidden');
            }
        });

        // Mark all as read
        document.addEventListener('click', (e) => {
            if (e.target.id === 'markAllRead') {
                this.markAllAsRead();
            }
        });

        // Handle notification clicks
        document.addEventListener('click', (e) => {
            if (e.target.closest('.notification-item')) {
                const notificationId = e.target.closest('.notification-item').dataset.notificationId;
                this.handleNotificationClick(notificationId);
            }
        });
    }

    async loadNotifications() {
        try {
            const userId = this.getCurrentUserId();
            const response = await fetch(`/api/notifications/user/${userId}`);
            if (response.ok) {
                const data = await response.json();
                if (data.success) {
                    this.notifications = data.notifications || [];
                    this.updateUnreadCount();
                    this.renderNotifications();
                }
            }
        } catch (error) {
            console.error('Failed to load notifications:', error);
        }
    }

    initWebSocket() {
        // Simple WebSocket connection for real-time notifications
        try {
            const protocol = window.location.protocol === 'https:' ? 'wss:' : 'ws:';
            const wsUrl = `${protocol}//${window.location.host}/ws/notifications?userId=${this.getCurrentUserId()}`;
            
            this.ws = new WebSocket(wsUrl);
            
            this.ws.onopen = () => {
                console.log('Notification WebSocket connected');
                this.isConnected = true;
            };

            this.ws.onmessage = (event) => {
                const notification = JSON.parse(event.data);
                this.addNotification(notification);
            };

            this.ws.onclose = () => {
                console.log('Notification WebSocket disconnected');
                this.isConnected = false;
                // Attempt to reconnect after 5 seconds
                setTimeout(() => this.initWebSocket(), 5000);
            };

            this.ws.onerror = (error) => {
                console.error('WebSocket error:', error);
            };
        } catch (error) {
            console.error('Failed to initialize WebSocket:', error);
        }
    }

    addNotification(notification) {
        this.notifications.unshift(notification);
        this.updateUnreadCount();
        this.renderNotifications();
        this.showToastNotification(notification);
    }

    showToastNotification(notification) {
        // Create toast notification
        const toast = document.createElement('div');
        toast.className = 'toast-notification fixed top-4 right-4 bg-white border-l-4 border-blue-500 rounded-lg shadow-lg p-4 max-w-sm z-50';
        toast.innerHTML = `
            <div class="flex">
                <div class="flex-shrink-0">
                    ${this.getNotificationIcon(notification.type)}
                </div>
                <div class="ml-3">
                    <h4 class="text-sm font-medium text-gray-900">${notification.title}</h4>
                    <p class="text-sm text-gray-500 mt-1">${notification.message}</p>
                </div>
                <button class="ml-4 text-gray-400 hover:text-gray-600" onclick="this.parentElement.parentElement.remove()">
                    <i class="bi bi-x"></i>
                </button>
            </div>
        `;

        document.body.appendChild(toast);

        // Auto remove after 5 seconds
        setTimeout(() => {
            if (toast.parentElement) {
                toast.remove();
            }
        }, 5000);
    }

    renderNotifications() {
        const container = document.getElementById('notificationList');
        if (!container) return;

        if (this.notifications.length === 0) {
            container.innerHTML = `
                <div class="p-4 text-center text-gray-500">
                    <i class="bi bi-bell-slash text-4xl mb-2"></i>
                    <p>No notifications</p>
                </div>
            `;
            return;
        }

        container.innerHTML = this.notifications.slice(0, 10).map(notification => `
            <div class="notification-item p-4 border-b hover:bg-gray-50 cursor-pointer ${!notification.is_read ? 'bg-blue-50' : ''}" 
                 data-notification-id="${notification.id}">
                <div class="flex items-start">
                    <div class="flex-shrink-0 mr-3">
                        ${this.getNotificationIcon(notification.type)}
                    </div>
                    <div class="flex-1 min-w-0">
                        <h4 class="text-sm font-medium text-gray-900 ${!notification.is_read ? 'font-semibold' : ''}">
                            ${notification.title}
                        </h4>
                        <p class="text-sm text-gray-500 mt-1">${notification.message}</p>
                        <p class="text-xs text-gray-400 mt-2">
                            ${this.formatRelativeTime(notification.created_at)}
                        </p>
                    </div>
                    ${!notification.is_read ? `
                        <div class="flex-shrink-0">
                            <div class="w-2 h-2 bg-blue-500 rounded-full"></div>
                        </div>
                    ` : ''}
                </div>
            </div>
        `).join('');
    }

    getNotificationIcon(type) {
        const icons = {
            course: '<i class="bi bi-book text-blue-500"></i>',
            assignment: '<i class="bi bi-clipboard-check text-green-500"></i>',
            grade: '<i class="bi bi-star text-yellow-500"></i>',
            payment: '<i class="bi bi-credit-card text-purple-500"></i>',
            system: '<i class="bi bi-gear text-gray-500"></i>',
            default: '<i class="bi bi-bell text-blue-500"></i>'
        };
        return icons[type] || icons.default;
    }

    updateUnreadCount() {
        this.unreadCount = this.notifications.filter(n => !n.is_read).length;
        const badge = document.getElementById('notificationBadge');
        if (badge) {
            if (this.unreadCount > 0) {
                badge.classList.remove('hidden');
                badge.textContent = this.unreadCount > 99 ? '99+' : this.unreadCount;
            } else {
                badge.classList.add('hidden');
            }
        }
    }

    async markNotificationsAsRead() {
        const unreadIds = this.notifications
            .filter(n => !n.isRead)
            .map(n => n.id);

        if (unreadIds.length === 0) return;

        try {
            await fetch('/api/notifications/mark-read', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({ notificationIds: unreadIds })
            });

            // Update local state
            this.notifications.forEach(n => {
                if (unreadIds.includes(n.id)) {
                    n.isRead = true;
                }
            });

            this.updateUnreadCount();
            this.renderNotifications();
        } catch (error) {
            console.error('Failed to mark notifications as read:', error);
        }
    }

    async markAllAsRead() {
        try {
            await fetch(`/api/notifications/user/${this.getCurrentUserId()}/mark-all-read`, {
                method: 'POST'
            });

            // Update local state
            this.notifications.forEach(n => n.is_read = true);
            this.updateUnreadCount();
            this.renderNotifications();
        } catch (error) {
            console.error('Failed to mark all notifications as read:', error);
        }
    }

    async handleNotificationClick(notificationId) {
        const notification = this.notifications.find(n => n.id == notificationId);
        if (!notification) return;

        // Mark as read if not already
        if (!notification.is_read) {
            await this.markNotificationsAsRead();
        }

        // Navigate based on notification type and data
        if (notification.data) {
            try {
                const data = typeof notification.data === 'string' 
                    ? JSON.parse(notification.data) 
                    : notification.data;

                switch (notification.type) {
                    case 'course':
                        if (data.courseId) {
                            window.location.href = `/courses/${data.courseId}`;
                        }
                        break;
                    case 'assignment':
                        if (data.assignmentId) {
                            window.location.href = `/assignments/${data.assignmentId}`;
                        }
                        break;
                    case 'grade':
                        if (data.assignmentId) {
                            window.location.href = `/assignments/${data.assignmentId}`;
                        }
                        break;
                    case 'payment':
                        if (data.paymentId) {
                            window.location.href = `/payments/${data.paymentId}`;
                        }
                        break;
                    default:
                        // Close dropdown
                        document.getElementById('notificationDropdown').classList.add('hidden');
                }
            } catch (error) {
                console.error('Error handling notification click:', error);
            }
        }
    }

    formatRelativeTime(dateString) {
        const date = new Date(dateString);
        const now = new Date();
        const diffInSeconds = Math.floor((now - date) / 1000);

        if (diffInSeconds < 60) return 'Just now';
        if (diffInSeconds < 3600) return `${Math.floor(diffInSeconds / 60)}m ago`;
        if (diffInSeconds < 86400) return `${Math.floor(diffInSeconds / 3600)}h ago`;
        if (diffInSeconds < 604800) return `${Math.floor(diffInSeconds / 86400)}d ago`;
        
        return date.toLocaleDateString();
    }

    getCurrentUserId() {
        return document.body.dataset.userId || 
               sessionStorage.getItem('userId') || 
               1;
    }

    // Public API for creating notifications
    async createNotification(notification) {
        try {
            const response = await fetch('/api/notifications', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify(notification)
            });

            if (response.ok) {
                const created = await response.json();
                return created;
            }
        } catch (error) {
            console.error('Failed to create notification:', error);
        }
    }

    // Create notification with email option
    async createNotificationWithEmail(notification, sendEmail = false, userEmail = null) {
        const notificationData = {
            ...notification,
            sendEmail: sendEmail,
            userEmail: userEmail
        };

        return this.createNotification(notificationData);
    }

    // Convenience method for different notification types with email
    async sendWelcomeNotification(userId, userEmail) {
        return this.createNotificationWithEmail({
            user_id: userId,
            type: 'welcome',
            title: 'Welcome to Learning Platform!',
            message: 'Welcome to our learning platform. We\'re excited to have you on board!'
        }, true, userEmail);
    }

    async sendCourseEnrollmentNotification(userId, userEmail, courseName) {
        return this.createNotificationWithEmail({
            user_id: userId,
            type: 'course',
            title: 'Course Enrollment Confirmed',
            message: `You have successfully enrolled in "${courseName}". Start learning now!`
        }, true, userEmail);
    }

    async sendAssignmentNotification(userId, userEmail, assignmentTitle) {
        return this.createNotificationWithEmail({
            user_id: userId,
            type: 'assignment',
            title: 'New Assignment Available',
            message: `A new assignment "${assignmentTitle}" has been assigned to you.`
        }, true, userEmail);
    }

    async sendGradeNotification(userId, userEmail, assignmentTitle, grade) {
        return this.createNotificationWithEmail({
            user_id: userId,
            type: 'grade',
            title: 'Assignment Graded',
            message: `Your assignment "${assignmentTitle}" has been graded. Score: ${grade}`
        }, true, userEmail);
    }

    async sendSecurityNotification(userId, userEmail, message) {
        return this.createNotificationWithEmail({
            user_id: userId,
            type: 'security',
            title: 'Security Alert',
            message: message
        }, true, userEmail);
    }

    destroy() {
        if (this.ws) {
            this.ws.close();
        }
    }
}

// Initialize notifications when DOM is ready
document.addEventListener('DOMContentLoaded', () => {
    window.notificationManager = new NotificationManager();
});

// Cleanup on page unload
window.addEventListener('beforeunload', () => {
    if (window.notificationManager) {
        window.notificationManager.destroy();
    }
});
