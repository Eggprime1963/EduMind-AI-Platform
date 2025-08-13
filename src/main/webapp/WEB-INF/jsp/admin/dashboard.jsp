<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - Learning Platform</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/global.css" rel="stylesheet">
    <style>
        :root {
            --admin-primary: #dc3545;
            --admin-secondary: #6f42c1;
            --admin-success: #198754;
            --admin-warning: #fd7e14;
            --admin-info: #0dcaf0;
        }
        
        .admin-header {
            background: linear-gradient(135deg, var(--admin-primary), var(--admin-secondary));
            color: white;
            padding: 2rem 0;
            margin-bottom: 2rem;
        }
        
        .stats-card {
            background: white;
            border-radius: 15px;
            padding: 2rem;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            height: 100%;
        }
        
        .stats-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 25px rgba(0,0,0,0.15);
        }
        
        .stats-icon {
            font-size: 3rem;
            margin-bottom: 1rem;
        }
        
        .stats-number {
            font-size: 2.5rem;
            font-weight: bold;
            margin-bottom: 0.5rem;
        }
        
        .users-table {
            background: white;
            border-radius: 15px;
            overflow: hidden;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
        
        .table-header {
            background: var(--admin-secondary);
            color: white;
            padding: 1.5rem;
        }
        
        .role-badge {
            font-size: 0.8rem;
            padding: 0.4rem 0.8rem;
            border-radius: 20px;
        }
        
        .role-admin { background-color: var(--admin-primary); }
        .role-teacher { background-color: var(--admin-warning); }
        .role-student { background-color: var(--admin-info); }
        
        .action-btn {
            padding: 0.3rem 0.8rem;
            border-radius: 20px;
            border: none;
            font-size: 0.8rem;
            margin: 0 0.2rem;
            transition: all 0.3s ease;
        }
        
        .btn-edit {
            background-color: var(--admin-info);
            color: white;
        }
        
        .btn-edit:hover {
            background-color: #0bb4d1;
            color: white;
        }
        
        .btn-delete {
            background-color: var(--admin-primary);
            color: white;
        }
        
        .btn-delete:hover {
            background-color: #b02a37;
            color: white;
        }
        
        .alert-custom {
            border-radius: 15px;
            border: none;
            padding: 1rem 1.5rem;
        }
        
        .search-box {
            border-radius: 25px;
            border: 2px solid #e9ecef;
            padding: 0.75rem 1.5rem;
            transition: border-color 0.3s ease;
        }
        
        .search-box:focus {
            border-color: var(--admin-secondary);
            box-shadow: 0 0 0 0.2rem rgba(111, 66, 193, 0.25);
        }
    </style>
</head>
<body class="bg-light">
    <!-- Include Navigation -->
    <%@ include file="../navbar.jsp" %>
    
    <!-- Admin Header -->
    <div class="admin-header">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-md-6">
                    <h1 class="mb-2"><i class="fas fa-shield-alt me-3"></i>Admin Dashboard</h1>
                    <p class="mb-0 opacity-75">Manage users, monitor system activity, and configure settings</p>
                </div>
                <div class="col-md-6 text-md-end">
                    <div class="d-flex justify-content-md-end align-items-center">
                        <span class="me-3">Welcome, ${sessionScope.user.username}</span>
                        <span class="badge bg-light text-dark px-3 py-2">
                            <i class="fas fa-crown me-1"></i>Administrator
                        </span>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <div class="container">
        <!-- Success/Error Messages -->
        <c:if test="${param.success == 'userDeleted'}">
            <div class="alert alert-success alert-custom alert-dismissible fade show">
                <i class="fas fa-check-circle me-2"></i>User has been successfully deleted.
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>
        
        <c:if test="${param.success == 'roleUpdated'}">
            <div class="alert alert-success alert-custom alert-dismissible fade show">
                <i class="fas fa-check-circle me-2"></i>User role has been successfully updated.
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>
        
        <!-- Statistics Cards -->
        <div class="row mb-5">
            <div class="col-lg-3 col-md-6 mb-4">
                <div class="stats-card text-center">
                    <div class="stats-icon text-primary">
                        <i class="fas fa-users"></i>
                    </div>
                    <div class="stats-number text-primary">${totalUsers}</div>
                    <div class="text-muted">Total Users</div>
                </div>
            </div>
            
            <div class="col-lg-3 col-md-6 mb-4">
                <div class="stats-card text-center">
                    <div class="stats-icon" style="color: var(--admin-info);">
                        <i class="fas fa-user-graduate"></i>
                    </div>
                    <div class="stats-number" style="color: var(--admin-info);">${totalStudents}</div>
                    <div class="text-muted">Students</div>
                </div>
            </div>
            
            <div class="col-lg-3 col-md-6 mb-4">
                <div class="stats-card text-center">
                    <div class="stats-icon" style="color: var(--admin-warning);">
                        <i class="fas fa-chalkboard-teacher"></i>
                    </div>
                    <div class="stats-number" style="color: var(--admin-warning);">${totalTeachers}</div>
                    <div class="text-muted">Teachers</div>
                </div>
            </div>
            
            <div class="col-lg-3 col-md-6 mb-4">
                <div class="stats-card text-center">
                    <div class="stats-icon" style="color: var(--admin-primary);">
                        <i class="fas fa-shield-alt"></i>
                    </div>
                    <div class="stats-number" style="color: var(--admin-primary);">${totalAdmins}</div>
                    <div class="text-muted">Administrators</div>
                </div>
            </div>
        </div>
        
        <!-- Users Management Section -->
        <div class="users-table">
            <div class="table-header">
                <div class="row align-items-center">
                    <div class="col-md-6">
                        <h3 class="mb-0"><i class="fas fa-users me-2"></i>User Management</h3>
                    </div>
                    <div class="col-md-6">
                        <div class="d-flex justify-content-md-end align-items-center">
                            <input type="text" id="userSearch" class="form-control search-box me-3" 
                                   placeholder="Search users..." style="max-width: 250px;">
                            <button class="btn btn-light" onclick="exportUsers()">
                                <i class="fas fa-download me-1"></i>Export
                            </button>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="table-responsive">
                <table class="table table-hover mb-0" id="usersTable">
                    <thead class="table-light">
                        <tr>
                            <th>ID</th>
                            <th>Username</th>
                            <th>Email</th>
                            <th>Role</th>
                            <th>Google ID</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="user" items="${allUsers}">
                            <tr>
                                <td>${user.id}</td>
                                <td>
                                    <div class="d-flex align-items-center">
                                        <div class="avatar me-2">
                                            <i class="fas fa-user-circle fa-lg text-muted"></i>
                                        </div>
                                        <strong>${user.username}</strong>
                                    </div>
                                </td>
                                <td>${user.email}</td>
                                <td>
                                    <span class="badge role-badge role-${user.role}">${user.role}</span>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty user.googleId}">
                                            <i class="fab fa-google text-danger me-1"></i>
                                            <small class="text-muted">Google User</small>
                                        </c:when>
                                        <c:otherwise>
                                            <small class="text-muted">Local Account</small>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:if test="${user.id != sessionScope.user.id}">
                                        <button class="action-btn btn-edit" onclick="editUser('${user.id}', '${user.role}')">
                                            <i class="fas fa-edit"></i> Edit
                                        </button>
                                        <button class="action-btn btn-delete" onclick="confirmDelete('${user.id}', '${user.username}')">
                                            <i class="fas fa-trash"></i> Delete
                                        </button>
                                    </c:if>
                                    <c:if test="${user.id == sessionScope.user.id}">
                                        <span class="badge bg-success">Current User</span>
                                    </c:if>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
    
    <!-- Edit User Modal -->
    <div class="modal fade" id="editUserModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title"><i class="fas fa-edit me-2"></i>Edit User Role</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form method="post" action="${pageContext.request.contextPath}/admin">
                    <div class="modal-body">
                        <input type="hidden" name="action" value="updateUserRole">
                        <input type="hidden" name="userId" id="editUserId">
                        
                        <div class="mb-3">
                            <label for="newRole" class="form-label">Select New Role:</label>
                            <select name="newRole" id="newRole" class="form-select" required>
                                <option value="student">Student</option>
                                <option value="teacher">Teacher</option>
                                <option value="admin">Administrator</option>
                            </select>
                        </div>
                        
                        <div class="alert alert-warning">
                            <i class="fas fa-exclamation-triangle me-2"></i>
                            <strong>Warning:</strong> Changing a user's role will affect their access permissions immediately.
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary">Update Role</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    
    <!-- Delete Confirmation Modal -->
    <div class="modal fade" id="deleteUserModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header bg-danger text-white">
                    <h5 class="modal-title"><i class="fas fa-exclamation-triangle me-2"></i>Confirm Deletion</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <form method="post" action="${pageContext.request.contextPath}/admin">
                    <div class="modal-body">
                        <input type="hidden" name="action" value="deleteUser">
                        <input type="hidden" name="userId" id="deleteUserId">
                        
                        <div class="text-center">
                            <i class="fas fa-user-times fa-4x text-danger mb-3"></i>
                            <h4>Delete User Account</h4>
                            <p class="mb-3">Are you sure you want to delete the user <strong id="deleteUsername"></strong>?</p>
                            <div class="alert alert-danger">
                                <strong>This action cannot be undone!</strong><br>
                                All user data, including courses, assignments, and submissions will be permanently deleted.
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-danger">
                            <i class="fas fa-trash me-1"></i>Delete User
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Search functionality
        document.getElementById('userSearch').addEventListener('keyup', function() {
            const searchTerm = this.value.toLowerCase();
            const tableRows = document.querySelectorAll('#usersTable tbody tr');
            
            tableRows.forEach(row => {
                const username = row.cells[1].textContent.toLowerCase();
                const email = row.cells[2].textContent.toLowerCase();
                const role = row.cells[3].textContent.toLowerCase();
                
                if (username.includes(searchTerm) || email.includes(searchTerm) || role.includes(searchTerm)) {
                    row.style.display = '';
                } else {
                    row.style.display = 'none';
                }
            });
        });
        
        // Edit user function
        function editUser(userId, currentRole) {
            document.getElementById('editUserId').value = userId;
            document.getElementById('newRole').value = currentRole;
            new bootstrap.Modal(document.getElementById('editUserModal')).show();
        }
        
        // Delete user function
        function confirmDelete(userId, username) {
            document.getElementById('deleteUserId').value = userId;
            document.getElementById('deleteUsername').textContent = username;
            new bootstrap.Modal(document.getElementById('deleteUserModal')).show();
        }
        
        // Export users function
        function exportUsers() {
            // Simple CSV export
            const table = document.getElementById('usersTable');
            let csv = 'ID,Username,Email,Role,Account Type\n';
            
            const rows = table.querySelectorAll('tbody tr');
            rows.forEach(row => {
                if (row.style.display !== 'none') {
                    const cells = row.querySelectorAll('td');
                    const accountType = cells[4].textContent.includes('Google') ? 'Google' : 'Local';
                    csv += `${cells[0].textContent},"${cells[1].textContent.trim()}","${cells[2].textContent}","${cells[3].textContent.trim()}","${accountType}"\n`;
                }
            });
            
            const blob = new Blob([csv], { type: 'text/csv' });
            const url = window.URL.createObjectURL(blob);
            const a = document.createElement('a');
            a.href = url;
            a.download = 'users_export.csv';
            a.click();
            window.URL.revokeObjectURL(url);
        }
        
        // Auto-hide alerts after 5 seconds
        setTimeout(() => {
            const alerts = document.querySelectorAll('.alert-dismissible');
            alerts.forEach(alert => {
                const bsAlert = new bootstrap.Alert(alert);
                bsAlert.close();
            });
        }, 5000);
    </script>
</body>
</html>
