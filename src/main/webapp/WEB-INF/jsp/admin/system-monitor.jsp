<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>System Monitor - Learning Platform Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/admin.css" rel="stylesheet">
    <style>
        .metric-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 15px;
            padding: 1.5rem;
            margin-bottom: 1rem;
            border: none;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
        }
        
        .metric-card.memory {
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
        }
        
        .metric-card.users {
            background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
        }
        
        .metric-card.system {
            background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%);
        }
        
        .metric-value {
            font-size: 2.5rem;
            font-weight: bold;
            margin-bottom: 0.5rem;
        }
        
        .metric-label {
            font-size: 0.9rem;
            opacity: 0.9;
        }
        
        .progress-container {
            background: rgba(255, 255, 255, 0.2);
            border-radius: 10px;
            padding: 1rem;
            margin: 1rem 0;
        }
        
        .memory-progress {
            height: 10px;
            border-radius: 5px;
            background: rgba(255, 255, 255, 0.3);
            overflow: hidden;
        }
        
        .memory-progress-bar {
            height: 100%;
            background: #fff;
            border-radius: 5px;
            transition: width 0.3s ease;
        }
        
        .system-info-table {
            background: white;
            border-radius: 15px;
            overflow: hidden;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.1);
        }
        
        .action-buttons .btn {
            margin: 0.25rem;
            border-radius: 20px;
        }
        
        .success-alert {
            border-radius: 10px;
            border-left: 4px solid #28a745;
        }
    </style>
</head>
<body>
    <!-- Navigation -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
        <div class="container">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/admin/dashboard">
                <i class="bi bi-speedometer2"></i> Admin Panel
            </a>
            <div class="navbar-nav ms-auto">
                <a class="nav-link" href="${pageContext.request.contextPath}/admin/dashboard">
                    <i class="bi bi-house"></i> Dashboard
                </a>
                <a class="nav-link" href="${pageContext.request.contextPath}/logout">
                    <i class="bi bi-box-arrow-right"></i> Logout
                </a>
            </div>
        </div>
    </nav>

    <div class="container mt-4">
        <!-- Page Header -->
        <div class="row mb-4">
            <div class="col-12">
                <h2><i class="bi bi-activity"></i> System Monitor</h2>
                <p class="text-muted">Real-time system health and performance metrics</p>
            </div>
        </div>

        <!-- Success Messages -->
        <c:if test="${param.success == 'cacheCleared'}">
            <div class="alert alert-success success-alert alert-dismissible fade show" role="alert">
                <i class="bi bi-check-circle"></i> System cache has been cleared successfully.
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>
        
        <c:if test="${param.success == 'gcRequested'}">
            <div class="alert alert-success success-alert alert-dismissible fade show" role="alert">
                <i class="bi bi-check-circle"></i> Garbage collection has been requested.
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <!-- User Statistics -->
        <div class="row mb-4">
            <div class="col-md-3">
                <div class="metric-card users">
                    <div class="metric-value">${systemStats.totalUsers}</div>
                    <div class="metric-label">
                        <i class="bi bi-people"></i> Total Users
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="metric-card users">
                    <div class="metric-value">${systemStats.totalStudents}</div>
                    <div class="metric-label">
                        <i class="bi bi-person-badge"></i> Students
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="metric-card users">
                    <div class="metric-value">${systemStats.totalTeachers}</div>
                    <div class="metric-label">
                        <i class="bi bi-person-workspace"></i> Teachers
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="metric-card users">
                    <div class="metric-value">${systemStats.totalAdmins}</div>
                    <div class="metric-label">
                        <i class="bi bi-shield-check"></i> Admins
                    </div>
                </div>
            </div>
        </div>

        <!-- System Health -->
        <div class="row mb-4">
            <div class="col-md-6">
                <div class="metric-card memory">
                    <h5><i class="bi bi-memory"></i> Memory Usage</h5>
                    <div class="progress-container">
                        <div class="d-flex justify-content-between mb-2">
                            <span>Used: ${systemStats.usedMemoryMB} MB</span>
                            <span>Total: ${systemStats.totalMemoryMB} MB</span>
                        </div>
                        <div class="memory-progress">
                            <div class="memory-progress-bar" style="width: ${systemStats.memoryUsagePercentage}%"></div>
                        </div>
                        <div class="text-center mt-2">
                            <strong>${systemStats.memoryUsagePercentage}% Used</strong>
                        </div>
                    </div>
                    <div class="row text-center">
                        <div class="col-6">
                            <div class="metric-value" style="font-size: 1.5rem;">${systemStats.freeMemoryMB}</div>
                            <div class="metric-label">Free MB</div>
                        </div>
                        <div class="col-6">
                            <div class="metric-value" style="font-size: 1.5rem;">${systemStats.maxMemoryMB}</div>
                            <div class="metric-label">Max MB</div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-6">
                <div class="metric-card system">
                    <h5><i class="bi bi-cpu"></i> System Info</h5>
                    <div class="row">
                        <div class="col-6 text-center">
                            <div class="metric-value" style="font-size: 1.8rem;">${systemStats.availableProcessors}</div>
                            <div class="metric-label">CPU Cores</div>
                        </div>
                        <div class="col-6 text-center">
                            <div class="metric-value" style="font-size: 1.8rem;">${systemStats.uptimeHours}</div>
                            <div class="metric-label">Uptime Hours</div>
                        </div>
                    </div>
                    <hr style="border-color: rgba(255,255,255,0.3);">
                    <div class="row">
                        <div class="col-6 text-center">
                            <div class="metric-value" style="font-size: 1.5rem;">${systemStats.totalCourses}</div>
                            <div class="metric-label">Total Courses</div>
                        </div>
                        <div class="col-6 text-center">
                            <div class="metric-value" style="font-size: 1.5rem;">${systemStats.activeUsersToday}</div>
                            <div class="metric-label">Active Today</div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- System Information Table -->
        <div class="row mb-4">
            <div class="col-12">
                <div class="system-info-table">
                    <div class="card-header bg-primary text-white">
                        <h5 class="mb-0"><i class="bi bi-info-circle"></i> System Information</h5>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-hover">
                                <tbody>
                                    <tr>
                                        <td><strong>Java Version</strong></td>
                                        <td>${systemStats.javaVersion}</td>
                                    </tr>
                                    <tr>
                                        <td><strong>Java Vendor</strong></td>
                                        <td>${systemStats.javaVendor}</td>
                                    </tr>
                                    <tr>
                                        <td><strong>Operating System</strong></td>
                                        <td>${systemStats.osName} ${systemStats.osVersion}</td>
                                    </tr>
                                    <tr>
                                        <td><strong>Available Processors</strong></td>
                                        <td>${systemStats.availableProcessors}</td>
                                    </tr>
                                    <tr>
                                        <td><strong>Max Memory</strong></td>
                                        <td><fmt:formatNumber value="${systemStats.maxMemoryMB}" type="number"/> MB</td>
                                    </tr>
                                    <tr>
                                        <td><strong>Total Memory</strong></td>
                                        <td><fmt:formatNumber value="${systemStats.totalMemoryMB}" type="number"/> MB</td>
                                    </tr>
                                    <tr>
                                        <td><strong>Free Memory</strong></td>
                                        <td><fmt:formatNumber value="${systemStats.freeMemoryMB}" type="number"/> MB</td>
                                    </tr>
                                    <tr>
                                        <td><strong>Server Uptime</strong></td>
                                        <td>${systemStats.uptimeHours} hours</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- System Actions -->
        <div class="row mb-4">
            <div class="col-12">
                <div class="card">
                    <div class="card-header bg-warning text-dark">
                        <h5 class="mb-0"><i class="bi bi-tools"></i> System Actions</h5>
                    </div>
                    <div class="card-body">
                        <p class="text-muted">Perform administrative system operations. Use with caution.</p>
                        <div class="action-buttons">
                            <form method="post" style="display: inline;" 
                                  onsubmit="return confirm('Are you sure you want to clear the system cache?')">
                                <input type="hidden" name="action" value="clearCache">
                                <button type="submit" class="btn btn-outline-primary">
                                    <i class="bi bi-arrow-clockwise"></i> Clear Cache
                                </button>
                            </form>
                            
                            <form method="post" style="display: inline;" 
                                  onsubmit="return confirm('Are you sure you want to request garbage collection?')">
                                <input type="hidden" name="action" value="gc">
                                <button type="submit" class="btn btn-outline-success">
                                    <i class="bi bi-recycle"></i> Request GC
                                </button>
                            </form>
                            
                            <form method="post" style="display: inline;">
                                <input type="hidden" name="action" value="exportLogs">
                                <button type="submit" class="btn btn-outline-info">
                                    <i class="bi bi-download"></i> Export Logs
                                </button>
                            </form>
                            
                            <button type="button" class="btn btn-outline-secondary" onclick="location.reload()">
                                <i class="bi bi-arrow-repeat"></i> Refresh
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Auto-refresh every 30 seconds
        setTimeout(function() {
            location.reload();
        }, 30000);
        
        // Animate progress bars
        document.addEventListener('DOMContentLoaded', function() {
            const progressBars = document.querySelectorAll('.memory-progress-bar');
            progressBars.forEach(bar => {
                const width = bar.style.width;
                bar.style.width = '0%';
                setTimeout(() => {
                    bar.style.width = width;
                }, 500);
            });
        });
    </script>
</body>
</html>
