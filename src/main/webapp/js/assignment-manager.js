// Assignment Management Component
class AssignmentManager {
    constructor() {
        this.assignments = [];
        this.selectedAssignment = null;
        this.init();
    }

    init() {
        this.bindEvents();
        this.loadAssignments();
    }

    bindEvents() {
        // Add assignment form
        const addAssignmentForm = document.getElementById('addAssignmentForm');
        if (addAssignmentForm) {
            addAssignmentForm.addEventListener('submit', (e) => this.handleAddAssignment(e));
        }

        // Submit assignment form
        const submitAssignmentForm = document.getElementById('submitAssignmentForm');
        if (submitAssignmentForm) {
            submitAssignmentForm.addEventListener('submit', (e) => this.handleSubmitAssignment(e));
        }

        // Assignment actions
        document.addEventListener('click', (e) => {
            if (e.target.matches('.view-assignment')) {
                this.viewAssignment(e.target.dataset.assignmentId);
            }
            if (e.target.matches('.grade-assignment')) {
                this.showGradingModal(e.target.dataset.assignmentId);
            }
            if (e.target.matches('.delete-assignment')) {
                this.deleteAssignment(e.target.dataset.assignmentId);
            }
        });

        // Grade submission
        const gradeForm = document.getElementById('gradeForm');
        if (gradeForm) {
            gradeForm.addEventListener('submit', (e) => this.handleGradeSubmission(e));
        }
    }

    async loadAssignments() {
        try {
            this.showLoading();
            const userId = this.getCurrentUserId();
            const userRole = this.getCurrentUserRole();
            
            let assignments;
            if (userRole === 'teacher') {
                assignments = await window.api.getAssignmentsByTeacher(userId);
            } else {
                assignments = await window.api.getAssignmentsByStudent(userId);
            }
            
            this.assignments = assignments;
            this.renderAssignments();
        } catch (error) {
            this.showError('Failed to load assignments: ' + error.message);
        } finally {
            this.hideLoading();
        }
    }

    async handleAddAssignment(e) {
        e.preventDefault();
        
        const formData = new FormData(e.target);
        const assignmentData = {
            title: formData.get('title'),
            description: formData.get('description'),
            courseId: formData.get('courseId'),
            dueDate: formData.get('dueDate'),
            totalPoints: formData.get('totalPoints'),
            instructions: formData.get('instructions')
        };

        try {
            this.showLoading();
            await window.api.createAssignment(assignmentData);
            this.showSuccess('Assignment created successfully!');
            e.target.reset();
            this.loadAssignments();
        } catch (error) {
            this.showError('Failed to create assignment: ' + error.message);
        } finally {
            this.hideLoading();
        }
    }

    async handleSubmitAssignment(e) {
        e.preventDefault();
        
        const formData = new FormData(e.target);
        const submissionData = {
            assignmentId: formData.get('assignmentId'),
            studentId: this.getCurrentUserId(),
            content: formData.get('content'),
            submissionFile: formData.get('submissionFile')
        };

        try {
            this.showLoading();
            await window.api.submitAssignment(submissionData);
            this.showSuccess('Assignment submitted successfully!');
            e.target.reset();
            this.loadAssignments();
        } catch (error) {
            this.showError('Failed to submit assignment: ' + error.message);
        } finally {
            this.hideLoading();
        }
    }

    async handleGradeSubmission(e) {
        e.preventDefault();
        
        const formData = new FormData(e.target);
        const gradeData = {
            submissionId: formData.get('submissionId'),
            grade: formData.get('grade'),
            feedback: formData.get('feedback')
        };

        try {
            this.showLoading();
            await window.api.gradeSubmission(gradeData);
            this.showSuccess('Grade submitted successfully!');
            this.closeModal();
            this.loadAssignments();
        } catch (error) {
            this.showError('Failed to submit grade: ' + error.message);
        } finally {
            this.hideLoading();
        }
    }

    async viewAssignment(assignmentId) {
        try {
            const assignment = await window.api.getAssignment(assignmentId);
            this.showAssignmentModal(assignment);
        } catch (error) {
            this.showError('Failed to load assignment: ' + error.message);
        }
    }

    async deleteAssignment(assignmentId) {
        if (!confirm('Are you sure you want to delete this assignment?')) {
            return;
        }

        try {
            await window.api.deleteAssignment(assignmentId);
            this.showSuccess('Assignment deleted successfully!');
            this.loadAssignments();
        } catch (error) {
            this.showError('Failed to delete assignment: ' + error.message);
        }
    }

    renderAssignments() {
        const container = document.getElementById('assignmentsContainer');
        if (!container) return;

        if (this.assignments.length === 0) {
            container.innerHTML = `
                <div class="text-center py-8">
                    <p class="text-gray-500">No assignments found.</p>
                </div>
            `;
            return;
        }

        const userRole = this.getCurrentUserRole();
        
        container.innerHTML = this.assignments.map(assignment => `
            <div class="assignment-item bg-white rounded-lg shadow-md p-6 mb-4">
                <div class="flex justify-between items-start mb-4">
                    <div class="flex-1">
                        <h3 class="text-xl font-semibold text-gray-800 mb-2">${assignment.title}</h3>
                        <p class="text-gray-600 mb-2">${assignment.description}</p>
                        <div class="text-sm text-gray-500">
                            <p>Course: ${assignment.courseName}</p>
                            <p>Due: ${new Date(assignment.dueDate).toLocaleDateString()}</p>
                            <p>Points: ${assignment.totalPoints}</p>
                            ${assignment.submission ? `
                                <p class="mt-2">
                                    <span class="inline-block px-2 py-1 text-xs rounded ${
                                        assignment.submission.grade ? 'bg-green-100 text-green-800' : 'bg-yellow-100 text-yellow-800'
                                    }">
                                        ${assignment.submission.grade ? `Graded: ${assignment.submission.grade}/${assignment.totalPoints}` : 'Submitted - Pending Grade'}
                                    </span>
                                </p>
                            ` : userRole === 'student' ? `
                                <p class="mt-2">
                                    <span class="inline-block px-2 py-1 text-xs rounded bg-red-100 text-red-800">
                                        Not Submitted
                                    </span>
                                </p>
                            ` : ''}
                        </div>
                    </div>
                    <div class="flex flex-col gap-2 ml-4">
                        <button class="view-assignment px-4 py-2 bg-blue-500 text-white rounded hover:bg-blue-600 transition-colors" 
                                data-assignment-id="${assignment.id}">
                            View
                        </button>
                        ${userRole === 'teacher' ? `
                            <button class="grade-assignment px-4 py-2 bg-green-500 text-white rounded hover:bg-green-600 transition-colors" 
                                    data-assignment-id="${assignment.id}">
                                Grade
                            </button>
                            <button class="delete-assignment px-4 py-2 bg-red-500 text-white rounded hover:bg-red-600 transition-colors" 
                                    data-assignment-id="${assignment.id}">
                                Delete
                            </button>
                        ` : !assignment.submission ? `
                            <button class="submit-assignment px-4 py-2 bg-purple-500 text-white rounded hover:bg-purple-600 transition-colors" 
                                    onclick="window.assignmentManager.showSubmissionModal('${assignment.id}')">
                                Submit
                            </button>
                        ` : ''}
                    </div>
                </div>
            </div>
        `).join('');
    }

    showAssignmentModal(assignment) {
        const modal = document.createElement('div');
        modal.className = 'modal-overlay fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50';
        modal.innerHTML = `
            <div class="modal-content bg-white rounded-lg p-6 max-w-2xl w-full mx-4 max-h-90vh overflow-y-auto">
                <div class="flex justify-between items-center mb-4">
                    <h2 class="text-2xl font-bold">${assignment.title}</h2>
                    <button class="close-modal text-gray-500 hover:text-gray-700">
                        <svg class="w-6 h-6" fill="currentColor" viewBox="0 0 20 20">
                            <path fill-rule="evenodd" d="M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z" clip-rule="evenodd"></path>
                        </svg>
                    </button>
                </div>
                <div class="assignment-details">
                    <p class="text-gray-600 mb-4">${assignment.description}</p>
                    <div class="grid grid-cols-2 gap-4 mb-4 text-sm">
                        <div>
                            <strong>Course:</strong> ${assignment.courseName}
                        </div>
                        <div>
                            <strong>Due Date:</strong> ${new Date(assignment.dueDate).toLocaleDateString()}
                        </div>
                        <div>
                            <strong>Total Points:</strong> ${assignment.totalPoints}
                        </div>
                        <div>
                            <strong>Status:</strong> 
                            <span class="inline-block px-2 py-1 text-xs rounded ${
                                assignment.submission?.grade ? 'bg-green-100 text-green-800' : 
                                assignment.submission ? 'bg-yellow-100 text-yellow-800' : 'bg-red-100 text-red-800'
                            }">
                                ${assignment.submission?.grade ? 'Graded' : assignment.submission ? 'Submitted' : 'Not Submitted'}
                            </span>
                        </div>
                    </div>
                    ${assignment.instructions ? `
                        <div class="mb-4">
                            <h3 class="font-semibold mb-2">Instructions:</h3>
                            <div class="bg-gray-50 p-4 rounded">${assignment.instructions}</div>
                        </div>
                    ` : ''}
                </div>
            </div>
        `;

        modal.querySelector('.close-modal').addEventListener('click', () => {
            modal.remove();
        });

        modal.addEventListener('click', (e) => {
            if (e.target === modal) {
                modal.remove();
            }
        });

        document.body.appendChild(modal);
    }

    showSubmissionModal(assignmentId) {
        // Implementation for submission modal
        console.log('Show submission modal for assignment:', assignmentId);
    }

    showGradingModal(assignmentId) {
        // Implementation for grading modal
        console.log('Show grading modal for assignment:', assignmentId);
    }

    closeModal() {
        const modal = document.querySelector('.modal-overlay');
        if (modal) {
            modal.remove();
        }
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
    if (document.getElementById('assignmentsContainer')) {
        window.assignmentManager = new AssignmentManager();
    }
});
