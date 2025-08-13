// Main Application JavaScript
(function() {
    'use strict';

    // Application configuration
    const AppConfig = {
        apiBaseUrl: window.location.origin,
        contextPath: getContextPath(),
        version: '1.0.0',
        environment: 'development'
    };

    // Global application state
    window.LearningPlatform = {
        config: AppConfig,
        user: {
            id: null,
            role: null,
            name: null
        },
        modules: {},
        utils: {}
    };

    // Utility functions
    window.LearningPlatform.utils = {
        // Format currency
        formatCurrency: function(amount, currency = 'USD') {
            return new Intl.NumberFormat('en-US', {
                style: 'currency',
                currency: currency
            }).format(amount);
        },

        // Format date
        formatDate: function(date, options = {}) {
            const defaultOptions = {
                year: 'numeric',
                month: 'short',
                day: 'numeric'
            };
            return new Date(date).toLocaleDateString('en-US', {...defaultOptions, ...options});
        },

        // Format relative time
        formatRelativeTime: function(date) {
            const now = new Date();
            const diffInSeconds = Math.floor((now - new Date(date)) / 1000);
            
            if (diffInSeconds < 60) return 'Just now';
            if (diffInSeconds < 3600) return `${Math.floor(diffInSeconds / 60)} minutes ago`;
            if (diffInSeconds < 86400) return `${Math.floor(diffInSeconds / 3600)} hours ago`;
            if (diffInSeconds < 604800) return `${Math.floor(diffInSeconds / 86400)} days ago`;
            
            return this.formatDate(date);
        },

        // Debounce function
        debounce: function(func, wait, immediate) {
            let timeout;
            return function executedFunction(...args) {
                const later = () => {
                    timeout = null;
                    if (!immediate) func(...args);
                };
                const callNow = immediate && !timeout;
                clearTimeout(timeout);
                timeout = setTimeout(later, wait);
                if (callNow) func(...args);
            };
        },

        // Throttle function
        throttle: function(func, limit) {
            let inThrottle;
            return function() {
                const args = arguments;
                const context = this;
                if (!inThrottle) {
                    func.apply(context, args);
                    inThrottle = true;
                    setTimeout(() => inThrottle = false, limit);
                }
            };
        },

        // Generate unique ID
        generateId: function() {
            return 'id_' + Math.random().toString(36).substr(2, 9);
        },

        // Validate email
        isValidEmail: function(email) {
            const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            return emailRegex.test(email);
        },

        // Escape HTML
        escapeHtml: function(text) {
            const map = {
                '&': '&amp;',
                '<': '&lt;',
                '>': '&gt;',
                '"': '&quot;',
                "'": '&#039;'
            };
            return text.replace(/[&<>"']/g, function(m) { return map[m]; });
        },

        // Copy to clipboard
        copyToClipboard: function(text) {
            if (navigator.clipboard && window.isSecureContext) {
                return navigator.clipboard.writeText(text);
            } else {
                // Fallback for older browsers
                const textArea = document.createElement('textarea');
                textArea.value = text;
                textArea.style.position = 'fixed';
                textArea.style.left = '-999999px';
                textArea.style.top = '-999999px';
                document.body.appendChild(textArea);
                textArea.focus();
                textArea.select();
                return new Promise((resolve, reject) => {
                    document.execCommand('copy') ? resolve() : reject();
                    textArea.remove();
                });
            }
        },

        // Show notification
        showNotification: function(message, type = 'info', duration = 5000) {
            const notification = document.createElement('div');
            notification.className = `notification notification-${type} fixed top-4 right-4 p-4 rounded-lg shadow-lg z-50`;
            
            const colors = {
                success: 'bg-green-500 text-white',
                error: 'bg-red-500 text-white',
                warning: 'bg-yellow-500 text-white',
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

            // Auto remove
            setTimeout(() => {
                if (notification.parentElement) {
                    notification.remove();
                }
            }, duration);

            return notification;
        },

        // Loading overlay
        showLoading: function(message = 'Loading...') {
            let overlay = document.getElementById('globalLoadingOverlay');
            if (!overlay) {
                overlay = document.createElement('div');
                overlay.id = 'globalLoadingOverlay';
                overlay.className = 'loading-overlay fixed inset-0 bg-white bg-opacity-80 flex flex-col items-center justify-center z-50';
                overlay.innerHTML = `
                    <div class="loading-spinner mb-4"></div>
                    <p class="text-gray-600">${message}</p>
                `;
                document.body.appendChild(overlay);
            }
            overlay.style.display = 'flex';
        },

        hideLoading: function() {
            const overlay = document.getElementById('globalLoadingOverlay');
            if (overlay) {
                overlay.style.display = 'none';
            }
        }
    };

    // Initialize user information
    function initializeUser() {
        const userData = {
            id: document.body.dataset.userId || sessionStorage.getItem('userId'),
            role: document.body.dataset.userRole || sessionStorage.getItem('userRole'),
            name: document.body.dataset.userName || sessionStorage.getItem('userName')
        };

        window.LearningPlatform.user = userData;
        
        // Store in sessionStorage for persistence
        if (userData.id) sessionStorage.setItem('userId', userData.id);
        if (userData.role) sessionStorage.setItem('userRole', userData.role);
        if (userData.name) sessionStorage.setItem('userName', userData.name);
    }

    // Initialize global event listeners
    function initializeGlobalEvents() {
        // Handle keyboard shortcuts
        document.addEventListener('keydown', function(e) {
            // Ctrl/Cmd + / for search
            if ((e.ctrlKey || e.metaKey) && e.key === '/') {
                e.preventDefault();
                const searchInput = document.querySelector('input[type="search"], input[placeholder*="search"], input[placeholder*="Search"]');
                if (searchInput) {
                    searchInput.focus();
                }
            }

            // Escape to close modals
            if (e.key === 'Escape') {
                const modals = document.querySelectorAll('.modal-overlay:not(.hidden)');
                modals.forEach(modal => {
                    const closeBtn = modal.querySelector('.close-modal');
                    if (closeBtn) closeBtn.click();
                });
            }
        });

        // Handle form validations
        document.addEventListener('invalid', function(e) {
            e.target.classList.add('border-red-500');
        }, true);

        document.addEventListener('input', function(e) {
            if (e.target.validity.valid) {
                e.target.classList.remove('border-red-500');
            }
        });

        // Handle external links
        document.addEventListener('click', function(e) {
            if (e.target.matches('a[href^="http"]') && !e.target.matches('a[href*="' + window.location.hostname + '"]')) {
                e.target.setAttribute('target', '_blank');
                e.target.setAttribute('rel', 'noopener noreferrer');
            }
        });

        // Handle AJAX errors globally
        window.addEventListener('unhandledrejection', function(e) {
            console.error('Unhandled promise rejection:', e.reason);
            if (e.reason && e.reason.message && !e.reason.message.includes('NetworkError')) {
                window.LearningPlatform.utils.showNotification(
                    'An error occurred. Please try again.',
                    'error'
                );
            }
        });
    }

    // Initialize responsive behavior
    function initializeResponsive() {
        function handleResize() {
            const isMobile = window.innerWidth < 768;
            document.body.classList.toggle('mobile', isMobile);
            
            // Adjust modal sizes on mobile
            const modals = document.querySelectorAll('.modal-content');
            modals.forEach(modal => {
                if (isMobile) {
                    modal.style.maxWidth = '95vw';
                    modal.style.margin = '1rem';
                } else {
                    modal.style.maxWidth = '';
                    modal.style.margin = '';
                }
            });
        }

        window.addEventListener('resize', window.LearningPlatform.utils.throttle(handleResize, 250));
        handleResize(); // Initial call
    }

    // Initialize accessibility features
    function initializeAccessibility() {
        // Add focus management for modals
        document.addEventListener('focusin', function(e) {
            const modal = e.target.closest('.modal-overlay');
            if (modal && !modal.classList.contains('hidden')) {
                const focusableElements = modal.querySelectorAll(
                    'button, [href], input, select, textarea, [tabindex]:not([tabindex="-1"])'
                );
                const firstElement = focusableElements[0];
                const lastElement = focusableElements[focusableElements.length - 1];

                if (e.target === modal) {
                    firstElement?.focus();
                }
            }
        });

        // Add skip links for screen readers
        if (!document.querySelector('.skip-links')) {
            const skipLinks = document.createElement('div');
            skipLinks.className = 'skip-links sr-only focus:not-sr-only fixed top-0 left-0 z-50 bg-blue-600 text-white p-2';
            skipLinks.innerHTML = `
                <a href="#main-content" class="btn btn-sm">Skip to main content</a>
            `;
            document.body.insertBefore(skipLinks, document.body.firstChild);
        }

        // Ensure main content has proper ID
        const mainContent = document.querySelector('.main-content, main');
        if (mainContent && !mainContent.id) {
            mainContent.id = 'main-content';
        }
    }

    // Get context path helper
    function getContextPath() {
        const path = window.location.pathname;
        const contextPath = path.substring(0, path.indexOf('/', 1));
        return contextPath || '';
    }

    // Initialize modules based on page content
    function initializeModules() {
        // Course manager
        if (document.getElementById('coursesContainer')) {
            window.LearningPlatform.modules.courseManager = window.courseManager;
        }

        // Assignment manager
        if (document.getElementById('assignmentsContainer')) {
            window.LearningPlatform.modules.assignmentManager = window.assignmentManager;
        }

        // Payment manager
        if (document.getElementById('paymentsContainer') || document.getElementById('paymentForm')) {
            window.LearningPlatform.modules.paymentManager = window.paymentManager;
        }
    }

    // Main initialization function
    function initialize() {
        try {
            initializeUser();
            initializeGlobalEvents();
            initializeResponsive();
            initializeAccessibility();
            initializeModules();

            // Emit ready event
            document.dispatchEvent(new CustomEvent('LearningPlatformReady', {
                detail: { platform: window.LearningPlatform }
            }));

            console.log('Learning Platform initialized successfully');
        } catch (error) {
            console.error('Failed to initialize Learning Platform:', error);
        }
    }

    // Initialize when DOM is ready
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', initialize);
    } else {
        initialize();
    }

    // Export for global access
    window.LearningPlatform.initialize = initialize;
})();
