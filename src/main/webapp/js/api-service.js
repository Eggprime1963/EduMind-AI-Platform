// API Service for communicating with Spring Boot backend
class ApiService {
    constructor() {
        this.baseURL = 'http://localhost:8080/api';
        this.headers = {
            'Content-Type': 'application/json',
        };
    }

    async request(endpoint, options = {}) {
        const url = `${this.baseURL}${endpoint}`;
        const config = {
            headers: this.headers,
            ...options,
        };

        try {
            const response = await fetch(url, config);
            
            if (!response.ok) {
                throw new Error(`HTTP error! status: ${response.status}`);
            }
            
            const contentType = response.headers.get('content-type');
            if (contentType && contentType.includes('application/json')) {
                return await response.json();
            }
            
            return await response.text();
        } catch (error) {
            console.error('API request failed:', error);
            throw error;
        }
    }

    // Course API methods
    async getCourses() {
        return this.request('/courses');
    }

    async getCourse(id) {
        return this.request(`/courses/${id}`);
    }

    async getCoursesByTeacher(teacherId) {
        return this.request(`/courses/teacher/${teacherId}`);
    }

    async getCoursesByStudent(studentId) {
        return this.request(`/courses/student/${studentId}`);
    }

    async searchCourses(keyword) {
        return this.request(`/courses/search?keyword=${encodeURIComponent(keyword)}`);
    }

    async createCourse(courseData) {
        return this.request('/courses', {
            method: 'POST',
            body: JSON.stringify(courseData),
        });
    }

    async updateCourse(id, courseData) {
        return this.request(`/courses/${id}`, {
            method: 'PUT',
            body: JSON.stringify(courseData),
        });
    }

    async deleteCourse(id) {
        return this.request(`/courses/${id}`, {
            method: 'DELETE',
        });
    }

    // Assignment API methods
    async getAssignments() {
        return this.request('/assignments');
    }

    async getAssignment(id) {
        return this.request(`/assignments/${id}`);
    }

    async getAssignmentsByCourse(courseId) {
        return this.request(`/assignments/course/${courseId}`);
    }

    async getAssignmentsByTeacher(teacherId) {
        return this.request(`/assignments/teacher/${teacherId}`);
    }

    async getOverdueAssignments() {
        return this.request('/assignments/overdue');
    }

    async createAssignment(assignmentData) {
        return this.request('/assignments', {
            method: 'POST',
            body: JSON.stringify(assignmentData),
        });
    }

    async updateAssignment(id, assignmentData) {
        return this.request(`/assignments/${id}`, {
            method: 'PUT',
            body: JSON.stringify(assignmentData),
        });
    }

    async deleteAssignment(id) {
        return this.request(`/assignments/${id}`, {
            method: 'DELETE',
        });
    }

    // Utility method to check if deadline is exceeded
    isDeadlineExceeded(dueDate) {
        if (!dueDate) return false;
        return new Date() > new Date(dueDate);
    }

    // Format time remaining for deadline
    getTimeRemaining(dueDate) {
        if (!dueDate) return 'No deadline';
        
        const now = new Date();
        const due = new Date(dueDate);
        
        if (now > due) {
            return 'Overdue';
        }
        
        const diff = due - now;
        const days = Math.floor(diff / (1000 * 60 * 60 * 24));
        const hours = Math.floor((diff % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
        const minutes = Math.floor((diff % (1000 * 60 * 60)) / (1000 * 60));
        
        if (days > 0) {
            return `${days} days, ${hours} hours remaining`;
        } else if (hours > 0) {
            return `${hours} hours remaining`;
        } else {
            return `${minutes} minutes remaining`;
        }
    }
}

// Global API instance
window.api = new ApiService();
