<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Reports - Learning Platform</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/admin.css" rel="stylesheet">
    <style>
        .report-nav {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 15px;
            padding: 1rem;
            margin-bottom: 2rem;
        }
        
        .report-nav .nav-link {
            color: white;
            border-radius: 10px;
            margin: 0 0.5rem;
            transition: all 0.3s ease;
        }
        
        .report-nav .nav-link.active {
            background: rgba(255, 255, 255, 0.2);
            color: white;
        }
        
        .report-nav .nav-link:hover {
            background: rgba(255, 255, 255, 0.1);
            color: white;
        }
        
        .report-card {
            background: white;
            border-radius: 15px;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.1);
            margin-bottom: 2rem;
        }
        
        .report-header {
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
            color: white;
            padding: 1.5rem;
            border-radius: 15px 15px 0 0;
        }
        
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1rem;
            margin-bottom: 2rem;
        }
        
        .stat-item {
            text-align: center;
            padding: 1.5rem;
            background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
            color: white;
            border-radius: 10px;
        }
        
        .stat-number {
            font-size: 2rem;
            font-weight: bold;
            margin-bottom: 0.5rem;
        }
        
        .stat-label {
            font-size: 0.9rem;
            opacity: 0.9;
        }
        
        .export-section {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 1.5rem;
            margin-top: 2rem;
        }
        
        .table-responsive {
            border-radius: 10px;
            overflow: hidden;
        }
        
        .role-badge {
            font-size: 0.8rem;
            padding: 0.4rem 0.8rem;
            border-radius: 20px;
        }
        
        .role-admin { background-color: #dc3545; color: white; }
        .role-teacher { background-color: #ffc107; color: black; }
        .role-student { background-color: #0dcaf0; color: black; }
    </style>
</head>
<body>
    <!-- Navigation -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
        <div class="container">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/admin/dashboard">
                <i class="bi bi-graph-up"></i> Admin Reports
            </a>
            <div class="navbar-nav ms-auto">
                <a class="nav-link" href="${pageContext.request.contextPath}/admin/dashboard">
                    <i class="bi bi-house"></i> Dashboard
                </a>
                <a class="nav-link" href="${pageContext.request.contextPath}/admin/system">
                    <i class="bi bi-activity"></i> System Monitor
                </a>
                <a class="nav-link" href="${pageContext.request.contextPath}/logout">
                    <i class="bi bi-box-arrow-right"></i> Logout
                </a>
            </div>
        </div>
    </nav>

    <div class="container mt-4">
        <!-- Report Navigation -->
        <div class="report-nav">
            <ul class="nav nav-pills">
                <li class="nav-item">
                    <a class="nav-link ${reportType == 'overview' ? 'active' : ''}" 
                       href="${pageContext.request.contextPath}/admin/reports?type=overview">
                        <i class="bi bi-pie-chart"></i> Overview
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${reportType == 'users' ? 'active' : ''}" 
                       href="${pageContext.request.contextPath}/admin/reports?type=users">
                        <i class="bi bi-people"></i> User Report
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${reportType == 'activity' ? 'active' : ''}" 
                       href="${pageContext.request.contextPath}/admin/reports?type=activity">
                        <i class="bi bi-activity"></i> Activity Report
                    </a>
                </li>
            </ul>
        </div>

        <!-- Overview Report -->
        <c:if test="${reportType == 'overview'}">
            <div class="report-card">
                <div class="report-header">
                    <h3><i class="bi bi-pie-chart"></i> System Overview Report</h3>
                    <p class="mb-0">Generated on: ${reportData.generatedAt}</p>
                </div>
                <div class="card-body p-4">
                    <div class="stats-grid">
                        <div class="stat-item">
                            <div class="stat-number">${reportData.totalUsers}</div>
                            <div class="stat-label">Total Users</div>
                        </div>
                        <div class="stat-item">
                            <div class="stat-number">${reportData.totalStudents}</div>
                            <div class="stat-label">Students (${reportData.studentPercentage}%)</div>
                        </div>
                        <div class="stat-item">
                            <div class="stat-number">${reportData.totalTeachers}</div>
                            <div class="stat-label">Teachers (${reportData.teacherPercentage}%)</div>
                        </div>
                        <div class="stat-item">
                            <div class="stat-number">${reportData.totalAdmins}</div>
                            <div class="stat-label">Admins (${reportData.adminPercentage}%)</div>
                        </div>
                    </div>
                    
                    <h5>Recent Users</h5>
                    <div class="table-responsive">
                        <table class="table table-hover">
                            <thead class="table-dark">
                                <tr>
                                    <th>ID</th>
                                    <th>Username</th>
                                    <th>Email</th>
                                    <th>Role</th>
                                    <th>Full Name</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="user" items="${reportData.recentUsers}">
                                    <tr>
                                        <td>${user.id}</td>
                                        <td>${user.username}</td>
                                        <td>${user.email}</td>
                                        <td>
                                            <span class="role-badge role-${user.role}">
                                                ${user.role}
                                            </span>
                                        </td>
                                        <td>${user.fullName}</td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </c:if>

        <!-- User Report -->
        <c:if test="${reportType == 'users'}">
            <div class="report-card">
                <div class="report-header">
                    <h3><i class="bi bi-people"></i> Detailed User Report</h3>
                    <p class="mb-0">Generated on: ${reportData.generatedAt}</p>
                </div>
                <div class="card-body p-4">
                    <div class="stats-grid">
                        <div class="stat-item">
                            <div class="stat-number">${reportData.totalUsers}</div>
                            <div class="stat-label">Total Users</div>
                        </div>
                        <div class="stat-item">
                            <div class="stat-number">${reportData.totalStudents}</div>
                            <div class="stat-label">Students</div>
                        </div>
                        <div class="stat-item">
                            <div class="stat-number">${reportData.totalTeachers}</div>
                            <div class="stat-label">Teachers</div>
                        </div>
                        <div class="stat-item">
                            <div class="stat-number">${reportData.totalAdmins}</div>
                            <div class="stat-label">Admins</div>
                        </div>
                    </div>
                    
                    <h5>All Users</h5>
                    <div class="table-responsive">
                        <table class="table table-hover">
                            <thead class="table-dark">
                                <tr>
                                    <th>ID</th>
                                    <th>Username</th>
                                    <th>Email</th>
                                    <th>Full Name</th>
                                    <th>Role</th>
                                    <th>Phone</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="user" items="${reportData.allUsers}">
                                    <tr>
                                        <td>${user.id}</td>
                                        <td>${user.username}</td>
                                        <td>${user.email}</td>
                                        <td>${user.fullName}</td>
                                        <td>
                                            <span class="role-badge role-${user.role}">
                                                ${user.role}
                                            </span>
                                        </td>
                                        <td>${user.phoneNumber}</td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </c:if>

        <!-- Activity Report -->
        <c:if test="${reportType == 'activity'}">
            <div class="report-card">
                <div class="report-header">
                    <h3><i class="bi bi-activity"></i> Activity Report</h3>
                    <p class="mb-0">Generated on: ${reportData.generatedAt}</p>
                </div>
                <div class="card-body p-4">
                    <div class="stats-grid">
                        <div class="stat-item">
                            <div class="stat-number">${reportData.dailyLogins}</div>
                            <div class="stat-label">Daily Logins</div>
                        </div>
                        <div class="stat-item">
                            <div class="stat-number">${reportData.weeklyLogins}</div>
                            <div class="stat-label">Weekly Logins</div>
                        </div>
                        <div class="stat-item">
                            <div class="stat-number">${reportData.monthlyLogins}</div>
                            <div class="stat-label">Monthly Logins</div>
                        </div>
                        <div class="stat-item">
                            <div class="stat-number">${reportData.activeUsers}</div>
                            <div class="stat-label">Active Users</div>
                        </div>
                    </div>
                    
                    <div class="alert alert-info">
                        <i class="bi bi-info-circle"></i>
                        <strong>Note:</strong> Activity tracking is not fully implemented yet. 
                        This section will show real data once user activity logging is enabled.
                    </div>
                </div>
            </div>
        </c:if>

        <!-- Export Section -->
        <div class="export-section">
            <h5><i class="bi bi-download"></i> Export Report</h5>
            <p class="text-muted">Download the current report in CSV format for external analysis.</p>
            <div class="d-flex gap-2">
                <a href="${pageContext.request.contextPath}/admin/reports?type=export&reportType=${reportType}&format=csv" 
                   class="btn btn-primary">
                    <i class="bi bi-file-earmark-spreadsheet"></i> Export as CSV
                </a>
                <button type="button" class="btn btn-outline-secondary" onclick="window.print()">
                    <i class="bi bi-printer"></i> Print Report
                </button>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
