// Course Management Component
class CourseManager {
    constructor() {
        this.courses = [];
        this.selectedCourse = null;
        this.init();
    }

    init() {
        this.bindEvents();
        this.loadCourses();
    }

    bindEvents() {
        // Add course form submission
        const addCourseForm = document.getElementById('addCourseForm');
        if (addCourseForm) {
            addCourseForm.addEventListener('submit', (e) => this.handleAddCourse(e));
        }

        // Course search
        const searchInput = document.getElementById('courseSearch');
        if (searchInput) {
            let timeout;
            searchInput.addEventListener('input', (e) => {
                clearTimeout(timeout);
                timeout = setTimeout(() => this.handleSearch(e.target.value), 300);
            });
        }

        // Course selection
        document.addEventListener('click', (e) => {
            if (e.target.matches('.course-item')) {
                this.selectCourse(e.target.dataset.courseId);
            }
            if (e.target.matches('.delete-course')) {
                this.deleteCourse(e.target.dataset.courseId);
            }
        });
    }

    async loadCourses() {
        try {
            this.showLoading();
            const userId = this.getCurrentUserId();
            const userRole = this.getCurrentUserRole();
            
            let courses;
            if (userRole === 'teacher') {
                courses = await window.api.getCoursesByTeacher(userId);
            } else if (userRole === 'student') {
                courses = await window.api.getCoursesByStudent(userId);
            } else {
                courses = await window.api.getCourses();
            }
            
            this.courses = courses;
            this.renderCourses();
        } catch (error) {
            this.showError('Failed to load courses: ' + error.message);
        } finally {
            this.hideLoading();
        }
    }

    async handleAddCourse(e) {
        e.preventDefault();
        
        const formData = new FormData(e.target);
        const courseData = {
            name: formData.get('name'),
            description: formData.get('description'),
            teacherId: this.getCurrentUserId(),
            thumbnail: formData.get('thumbnail') || 'default-course.jpg'
        };

        try {
            this.showLoading();
            await window.api.createCourse(courseData);
            this.showSuccess('Course created successfully!');
            e.target.reset();
            this.loadCourses();
        } catch (error) {
            this.showError('Failed to create course: ' + error.message);
        } finally {
            this.hideLoading();
        }
    }

    async handleSearch(keyword) {
        if (!keyword.trim()) {
            this.renderCourses();
            return;
        }

        try {
            const results = await window.api.searchCourses(keyword);
            this.renderCourses(results);
        } catch (error) {
            this.showError('Search failed: ' + error.message);
        }
    }

    async deleteCourse(courseId) {
        if (!confirm('Are you sure you want to delete this course?')) {
            return;
        }

        try {
            await window.api.deleteCourse(courseId);
            this.showSuccess('Course deleted successfully!');
            this.loadCourses();
        } catch (error) {
            this.showError('Failed to delete course: ' + error.message);
        }
    }

    renderCourses(coursesToRender = this.courses) {
        const container = document.getElementById('coursesContainer');
        if (!container) return;

        if (coursesToRender.length === 0) {
            container.innerHTML = `
                <div class="text-center py-8">
                    <i class="bi bi-book text-gray-400" style="font-size: 4rem;"></i>
                    <p class="text-gray-500 mt-4">No courses found.</p>
                </div>
            `;
            return;
        }

        container.innerHTML = coursesToRender.map(course => this.renderCourseCard(course)).join('');
    }

    renderCourseCard(course) {
        const userRole = this.getCurrentUserRole();
        const isEnrolled = course.isEnrolled || false;
        const courseImage = course.thumbnail || course.imageUrl;
        
        return `
            <div class="course-card" data-course-id="${course.id}">
                <div class="course-thumbnail" style="${courseImage ? `background-image: url('${courseImage}'); background-size: cover; background-position: center;` : ''}">
                    ${!courseImage ? '<i class="bi bi-book" style="font-size: 3rem;"></i>' : ''}
                </div>
                <div class="course-info">
                    <h3 class="course-title">${course.name || course.title}</h3>
                    <p class="course-description">${course.description}</p>
                    
                    <div class="course-meta">
                        <div class="flex items-center text-sm text-gray-500 mb-2">
                            <i class="bi bi-person mr-2"></i>
                            <span>Instructor: ${course.instructor || 'TBA'}</span>
                        </div>
                        
                        ${course.duration ? `
                            <div class="flex items-center text-sm text-gray-500 mb-2">
                                <i class="bi bi-clock mr-2"></i>
                                <span>Duration: ${course.duration}</span>
                            </div>
                        ` : ''}
                        
                        ${course.level ? `
                            <div class="flex items-center text-sm text-gray-500 mb-2">
                                <i class="bi bi-star mr-2"></i>
                                <span>Level: ${course.level}</span>
                            </div>
                        ` : ''}
                        
                        ${course.enrollmentCount !== undefined ? `
                            <div class="flex items-center text-sm text-gray-500 mb-2">
                                <i class="bi bi-people mr-2"></i>
                                <span>${course.enrollmentCount} enrolled</span>
                            </div>
                        ` : ''}
                        
                        <div class="flex items-center text-sm text-gray-500">
                            <i class="bi bi-calendar mr-2"></i>
                            <span>Created: ${new Date(course.createdAt).toLocaleDateString()}</span>
                        </div>
                    </div>
                    
                    <div class="flex justify-between items-center mt-4">
                        <div class="course-price">
                            ${course.price == 0 ? 'Free' : '$' + course.price}
                        </div>
                        <div class="flex gap-2">
                            ${userRole === 'teacher' && course.teacherId == this.getCurrentUserId() ? `
                                <button class="btn btn-secondary btn-sm" onclick="editCourse('${course.id}')">
                                    <i class="bi bi-pencil"></i> Edit
                                </button>
                                <button class="btn btn-danger btn-sm delete-course" data-course-id="${course.id}">
                                    <i class="bi bi-trash"></i> Delete
                                </button>
                            ` : isEnrolled ? `
                                <button class="btn btn-success btn-sm" onclick="viewCourse('${course.id}')">
                                    <i class="bi bi-play-circle"></i> Continue
                                </button>
                            ` : `
                                <button class="btn btn-primary btn-sm enroll-course" data-course-id="${course.id}">
                                    <i class="bi bi-plus-circle"></i> Enroll
                                </button>
                            `}
                            <button class="btn btn-secondary btn-sm" onclick="viewCourseDetails('${course.id}')">
                                <i class="bi bi-eye"></i> Details
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        `;
    }

    getCurrentUserId() {
        // Get user ID from session or DOM
        return document.body.dataset.userId || 
               sessionStorage.getItem('userId') || 
               1; // fallback
    }

    getCurrentUserRole() {
        // Get user role from session or DOM
        return document.body.dataset.userRole || 
               sessionStorage.getItem('userRole') || 
               'student'; // fallback
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
        notification.innerHTML = `
            <div class="flex items-center">
                <span>${message}</span>
                <button class="ml-4 text-white hover:text-gray-200" onclick="this.parentElement.parentElement.remove()">
                    <svg class="w-4 h-4" fill="currentColor" viewBox="0 0 20 20">
                        <path fill-rule="evenodd" d="M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z" clip-rule="evenodd"></path>
                    </svg>
                </button>
            </div>
        `;

        document.body.appendChild(notification);

        // Auto remove after 5 seconds
        setTimeout(() => {
            if (notification.parentElement) {
                notification.remove();
            }
        }, 5000);
    }
}

// Initialize when DOM is loaded
document.addEventListener('DOMContentLoaded', () => {
    if (document.getElementById('coursesContainer')) {
        window.courseManager = new CourseManager();
    }
});
