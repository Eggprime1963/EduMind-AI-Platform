<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Profile - LearnHub</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <!-- Chart.js -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <!-- Custom CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/modern-ui.css"/>
    <!-- Google Fonts: Inter -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --github-green-1: #0d1117;
            --github-green-2: #161b22;
            --github-green-3: #21262d;
            --github-green-4: #30363d;
            --activity-level-0: #161b22;
            --activity-level-1: #0e4429;
            --activity-level-2: #006d32;
            --activity-level-3: #26a641;
            --activity-level-4: #39d353;
        }

        .profile-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 3rem 0;
            margin-bottom: 2rem;
        }

        .profile-avatar {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            border: 4px solid white;
            box-shadow: 0 8px 32px rgba(0,0,0,0.2);
            background: linear-gradient(45deg, #ff6b6b, #4ecdc4);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 3rem;
            font-weight: bold;
            color: white;
        }

        .profile-stats {
            display: flex;
            gap: 2rem;
            margin-top: 1.5rem;
        }

        .stat-item {
            text-align: center;
        }

        .stat-number {
            font-size: 1.5rem;
            font-weight: bold;
            display: block;
        }

        .stat-label {
            font-size: 0.9rem;
            opacity: 0.9;
        }

        .dashboard-container {
            display: grid;
            grid-template-columns: 1fr 350px;
            gap: 2rem;
            margin-bottom: 2rem;
        }

        .main-dashboard {
            display: flex;
            flex-direction: column;
            gap: 1.5rem;
        }

        .sidebar-dashboard {
            display: flex;
            flex-direction: column;
            gap: 1.5rem;
        }

        .card {
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
            border: 1px solid #e1e8ed;
            overflow: hidden;
        }

        .card-header {
            padding: 1.25rem 1.5rem;
            border-bottom: 1px solid #e1e8ed;
            background: #f8f9fa;
            font-weight: 600;
            font-size: 1.1rem;
        }

        .card-body {
            padding: 1.5rem;
        }

        /* Activity Calendar */
        .contribution-calendar {
            overflow-x: auto;
            padding: 1rem 0;
        }

        .calendar-graph {
            display: grid;
            grid-template-columns: auto 1fr;
            gap: 1rem;
        }

        .calendar-months {
            display: grid;
            grid-template-columns: repeat(12, 1fr);
            gap: 0.25rem;
            font-size: 0.75rem;
            color: #656d76;
            margin-bottom: 0.5rem;
        }

        .calendar-weekdays {
            display: grid;
            grid-template-rows: repeat(7, 1fr);
            gap: 0.25rem;
            font-size: 0.75rem;
            color: #656d76;
            text-align: right;
            padding-right: 0.5rem;
        }

        .calendar-days {
            display: grid;
            grid-template-columns: repeat(53, 1fr);
            grid-template-rows: repeat(7, 1fr);
            gap: 0.25rem;
        }

        .calendar-day {
            width: 12px;
            height: 12px;
            border-radius: 2px;
            border: 1px solid rgba(27,31,36,0.06);
            cursor: pointer;
            transition: all 0.2s ease;
        }

        .calendar-day:hover {
            border-color: rgba(27,31,36,0.3);
            transform: scale(1.2);
        }

        .calendar-day[data-level="0"] { background-color: #ebedf0; }
        .calendar-day[data-level="1"] { background-color: #9be9a8; }
        .calendar-day[data-level="2"] { background-color: #40c463; }
        .calendar-day[data-level="3"] { background-color: #30a14e; }
        .calendar-day[data-level="4"] { background-color: #216e39; }

        .calendar-legend {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            margin-top: 1rem;
            font-size: 0.75rem;
            color: #656d76;
        }

        .legend-item {
            display: flex;
            align-items: center;
            gap: 0.25rem;
        }

        /* Activity Feed */
        .activity-item {
            display: flex;
            gap: 1rem;
            padding: 1rem 0;
            border-bottom: 1px solid #e1e8ed;
        }

        .activity-item:last-child {
            border-bottom: none;
        }

        .activity-icon {
            width: 32px;
            height: 32px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 0.875rem;
            flex-shrink: 0;
        }

        .activity-content {
            flex: 1;
        }

        .activity-title {
            font-weight: 500;
            margin-bottom: 0.25rem;
        }

        .activity-description {
            color: #656d76;
            font-size: 0.875rem;
            margin-bottom: 0.25rem;
        }

        .activity-time {
            color: #656d76;
            font-size: 0.75rem;
        }

        /* Achievement Badges */
        .achievement-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(80px, 1fr));
            gap: 1rem;
        }

        .achievement-badge {
            text-align: center;
            padding: 1rem;
            border-radius: 8px;
            background: linear-gradient(45deg, #f8f9fa, #e9ecef);
            transition: transform 0.2s ease;
        }

        .achievement-badge:hover {
            transform: translateY(-2px);
        }

        .achievement-badge.earned {
            background: linear-gradient(45deg, #ffd700, #ffed4e);
            color: #8b6914;
        }

        .achievement-icon {
            font-size: 2rem;
            margin-bottom: 0.5rem;
            display: block;
        }

        .achievement-title {
            font-size: 0.75rem;
            font-weight: 600;
            margin-bottom: 0.25rem;
        }

        .achievement-description {
            font-size: 0.625rem;
            opacity: 0.8;
        }

        /* Learning Streak */
        .streak-counter {
            text-align: center;
            padding: 2rem 1rem;
            background: linear-gradient(135deg, #ff6b6b, #ee5a24);
            color: white;
            border-radius: 12px;
            margin-bottom: 1rem;
        }

        .streak-number {
            font-size: 3rem;
            font-weight: bold;
            line-height: 1;
        }

        .streak-label {
            font-size: 0.875rem;
            margin-top: 0.5rem;
            opacity: 0.9;
        }

        /* Charts */
        .chart-container {
            position: relative;
            height: 300px;
            margin: 1rem 0;
        }

        /* Edit Profile Button */
        .edit-profile-btn {
            position: absolute;
            top: 1rem;
            right: 1rem;
            background: rgba(255,255,255,0.2);
            border: 1px solid rgba(255,255,255,0.3);
            color: white;
            padding: 0.5rem 1rem;
            border-radius: 6px;
            text-decoration: none;
            transition: all 0.2s ease;
        }

        .edit-profile-btn:hover {
            background: rgba(255,255,255,0.3);
            color: white;
            text-decoration: none;
        }

        /* Responsive Design */
        @media (max-width: 992px) {
            .dashboard-container {
                grid-template-columns: 1fr;
            }
            
            .sidebar-dashboard {
                order: -1;
            }
            
            .profile-stats {
                justify-content: center;
                flex-wrap: wrap;
            }
        }

        @media (max-width: 768px) {
            .profile-header {
                padding: 2rem 0;
            }
            
            .profile-avatar {
                width: 80px;
                height: 80px;
                font-size: 2rem;
            }
            
            .calendar-days {
                grid-template-columns: repeat(26, 1fr);
            }
        }
    </style>
</head>
<body>
<jsp:include page="navbar.jsp" />

<!-- Profile Header -->
<div class="profile-header position-relative">
    <a href="#" class="edit-profile-btn" data-bs-toggle="modal" data-bs-target="#editProfileModal">
        <i class="bi bi-pencil-square me-1"></i>Edit Profile
    </a>
    <div class="container">
        <div class="row align-items-center">
            <div class="col-md-3 text-center">
                <div class="profile-avatar mx-auto">
                    ${username.substring(0,1).toUpperCase()}
                </div>
            </div>
            <div class="col-md-9">
                <h1 class="h2 mb-2">${username}</h1>
                <p class="lead mb-3">${firstName} ${lastName}</p>
                <p class="mb-3">
                    <i class="bi bi-envelope me-2"></i>${user.email}
                    <c:if test="${not empty school}">
                        <span class="ms-3">
                            <i class="bi bi-building me-2"></i>${school}
                        </span>
                    </c:if>
                    <c:if test="${not empty address}">
                        <span class="ms-3">
                            <i class="bi bi-geo-alt me-2"></i>${address}
                        </span>
                    </c:if>
                </p>
                
                <div class="profile-stats">
                    <div class="stat-item">
                        <span class="stat-number" id="coursesCompleted">12</span>
                        <span class="stat-label">Courses Completed</span>
                    </div>
                    <div class="stat-item">
                        <span class="stat-number" id="hoursLearned">340</span>
                        <span class="stat-label">Hours Learned</span>
                    </div>
                    <div class="stat-item">
                        <span class="stat-number" id="assignmentsSubmitted">89</span>
                        <span class="stat-label">Assignments</span>
                    </div>
                    <div class="stat-item">
                        <span class="stat-number" id="currentStreak">15</span>
                        <span class="stat-label">Day Streak</span>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<div class="container">
    <div class="dashboard-container">
        <!-- Main Dashboard -->
        <div class="main-dashboard">
            <!-- Activity Calendar -->
            <div class="card">
                <div class="card-header">
                    <i class="bi bi-calendar-check me-2"></i>Learning Activity
                    <span class="text-muted ms-2" id="totalContributions">342 activities in the last year</span>
                </div>
                <div class="card-body">
                    <div class="contribution-calendar">
                        <div class="calendar-graph">
                            <div>
                                <div class="calendar-months" id="calendarMonths"></div>
                                <div style="display: grid; grid-template-columns: auto 1fr; gap: 1rem;">
                                    <div class="calendar-weekdays">
                                        <span></span>
                                        <span>Mon</span>
                                        <span></span>
                                        <span>Wed</span>
                                        <span></span>
                                        <span>Fri</span>
                                        <span></span>
                                    </div>
                                    <div class="calendar-days" id="calendarDays"></div>
                                </div>
                            </div>
                        </div>
                        <div class="calendar-legend">
                            <span>Less</span>
                            <div class="legend-item">
                                <div class="calendar-day" data-level="0"></div>
                            </div>
                            <div class="legend-item">
                                <div class="calendar-day" data-level="1"></div>
                            </div>
                            <div class="legend-item">
                                <div class="calendar-day" data-level="2"></div>
                            </div>
                            <div class="legend-item">
                                <div class="calendar-day" data-level="3"></div>
                            </div>
                            <div class="legend-item">
                                <div class="calendar-day" data-level="4"></div>
                            </div>
                            <span>More</span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Learning Progress Charts -->
            <div class="card">
                <div class="card-header">
                    <i class="bi bi-graph-up me-2"></i>Learning Progress
                </div>
                <div class="card-body">
                    <div class="row">
                        <div class="col-md-6">
                            <h6>Weekly Learning Hours</h6>
                            <div class="chart-container">
                                <canvas id="weeklyHoursChart"></canvas>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <h6>Course Completion Rate</h6>
                            <div class="chart-container">
                                <canvas id="completionChart"></canvas>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Recent Activity Feed -->
            <div class="card">
                <div class="card-header">
                    <i class="bi bi-clock-history me-2"></i>Recent Activity
                </div>
                <div class="card-body">
                    <div id="activityFeed">
                        <!-- Activity items will be populated by JavaScript -->
                    </div>
                </div>
            </div>
        </div>

        <!-- Sidebar Dashboard -->
        <div class="sidebar-dashboard">
            <!-- Learning Streak -->
            <div class="streak-counter">
                <div class="streak-number" id="streakDisplay">15</div>
                <div class="streak-label">🔥 Day Learning Streak</div>
                <small class="d-block mt-2">Keep it up! You're on fire!</small>
            </div>

            <!-- Achievements -->
            <div class="card">
                <div class="card-header">
                    <i class="bi bi-trophy me-2"></i>Achievements
                </div>
                <div class="card-body">
                    <div class="achievement-grid" id="achievementGrid">
                        <!-- Achievements will be populated by JavaScript -->
                    </div>
                </div>
            </div>

            <!-- Quick Stats -->
            <div class="card">
                <div class="card-header">
                    <i class="bi bi-bar-chart me-2"></i>Quick Stats
                </div>
                <div class="card-body">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <span>Average Score</span>
                        <span class="fw-bold text-success">87.5%</span>
                    </div>
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <span>Completion Rate</span>
                        <span class="fw-bold text-primary">92%</span>
                    </div>
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <span>Time This Month</span>
                        <span class="fw-bold text-info">42h 15m</span>
                    </div>
                    <div class="d-flex justify-content-between align-items-center">
                        <span>Rank</span>
                        <span class="fw-bold text-warning">#23</span>
                    </div>
                </div>
            </div>

            <!-- Learning Goals -->
            <div class="card">
                <div class="card-header">
                    <i class="bi bi-target me-2"></i>Learning Goals
                </div>
                <div class="card-body">
                    <div class="mb-3">
                        <div class="d-flex justify-content-between align-items-center mb-1">
                            <span class="small">Weekly Goal</span>
                            <span class="small">15/20 hours</span>
                        </div>
                        <div class="progress">
                            <div class="progress-bar bg-success" style="width: 75%"></div>
                        </div>
                    </div>
                    <div class="mb-3">
                        <div class="d-flex justify-content-between align-items-center mb-1">
                            <span class="small">Monthly Courses</span>
                            <span class="small">3/5 completed</span>
                        </div>
                        <div class="progress">
                            <div class="progress-bar bg-primary" style="width: 60%"></div>
                        </div>
                    </div>
                    <div>
                        <div class="d-flex justify-content-between align-items-center mb-1">
                            <span class="small">Skill Points</span>
                            <span class="small">820/1000</span>
                        </div>
                        <div class="progress">
                            <div class="progress-bar bg-warning" style="width: 82%"></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Edit Profile Modal -->
<div class="modal fade" id="editProfileModal" tabindex="-1" aria-labelledby="editProfileModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="editProfileModalLabel">
                    <i class="bi bi-person-gear me-2"></i>Edit Profile
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form method="post" action="${pageContext.request.contextPath}/profile">
                <div class="modal-body">
                    <c:if test="${not empty message}">
                        <div class="alert alert-info" role="alert">
                            ${message}
                        </div>
                    </c:if>
                    
                    <div class="row">
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label for="modalUsername" class="form-label">Username</label>
                                <input type="text" id="modalUsername" name="username" class="form-control" value="${username}" required>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label for="modalEmail" class="form-label">Email</label>
                                <input type="email" id="modalEmail" name="email" class="form-control" value="${user.email}" readonly>
                            </div>
                        </div>
                    </div>
                    
                    <div class="row">
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label for="modalFirstName" class="form-label">First Name</label>
                                <input type="text" id="modalFirstName" name="firstName" class="form-control" value="${firstName}">
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label for="modalLastName" class="form-label">Last Name</label>
                                <input type="text" id="modalLastName" name="lastName" class="form-control" value="${lastName}">
                            </div>
                        </div>
                    </div>
                    
                    <div class="row">
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label for="modalPhone" class="form-label">Phone</label>
                                <input type="text" id="modalPhone" name="phone" class="form-control" value="${phone}">
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="mb-3">
                                <label class="form-label">Gender</label>
                                <div class="btn-group w-100" role="group">
                                    <input type="radio" class="btn-check" name="gender" id="modalMale" value="Male"
                                        ${gender == 'Male' ? 'checked="checked"' : ''}>
                                    <label class="btn btn-outline-primary" for="modalMale">Male</label>
                                    <input type="radio" class="btn-check" name="gender" id="modalFemale" value="Female"
                                        ${gender == 'Female' ? 'checked="checked"' : ''}>
                                    <label class="btn btn-outline-primary" for="modalFemale">Female</label>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="mb-3">
                        <label for="modalAddress" class="form-label">Address</label>
                        <input type="text" id="modalAddress" name="address" class="form-control" value="${address}">
                    </div>
                    
                    <div class="mb-3">
                        <label for="modalSchool" class="form-label">School</label>
                        <input type="text" id="modalSchool" name="school" class="form-control" value="${school}">
                    </div>

                    <!-- Update Password (skip for Google users) -->
                    <c:if test="${empty user.googleId}">
                        <hr>
                        <h6 class="mb-3">Update Password</h6>
                        <div class="mb-3">
                            <label for="modalCurrentPassword" class="form-label">Current Password</label>
                            <input type="password" id="modalCurrentPassword" name="currentPassword" class="form-control">
                        </div>
                        <div class="row">
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="modalNewPassword" class="form-label">New Password</label>
                                    <input type="password" id="modalNewPassword" name="newPassword" class="form-control">
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="mb-3">
                                    <label for="modalConfirmNewPassword" class="form-label">Confirm New Password</label>
                                    <input type="password" id="modalConfirmNewPassword" name="confirmNewPassword" class="form-control">
                                </div>
                            </div>
                        </div>
                    </c:if>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary">
                        <i class="bi bi-check-lg me-1"></i>Save Changes
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
document.addEventListener('DOMContentLoaded', function() {
    // Initialize activity calendar
    initializeActivityCalendar();
    
    // Initialize charts
    initializeCharts();
    
    // Initialize activity feed
    initializeActivityFeed();
    
    // Initialize achievements
    initializeAchievements();
});

function initializeActivityCalendar() {
    const calendarDays = document.getElementById('calendarDays');
    const calendarMonths = document.getElementById('calendarMonths');
    
    // Generate months
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 
                   'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    months.forEach(month => {
        const monthEl = document.createElement('div');
        monthEl.textContent = month;
        calendarMonths.appendChild(monthEl);
    });
    
    // Generate activity squares for the past year
    const today = new Date();
    const oneYearAgo = new Date(today.getFullYear() - 1, today.getMonth(), today.getDate());
    
    for (let d = new Date(oneYearAgo); d <= today; d.setDate(d.getDate() + 1)) {
        const dayElement = document.createElement('div');
        dayElement.className = 'calendar-day';
        
        // Random activity level for demo
        const activityLevel = Math.floor(Math.random() * 5);
        dayElement.setAttribute('data-level', activityLevel);
        
        // Add tooltip
        const dateStr = d.toISOString().split('T')[0];
        dayElement.title = `${activityLevel} activities on ${dateStr}`;
        
        calendarDays.appendChild(dayElement);
    }
}

function initializeCharts() {
    // Weekly Hours Chart
    const weeklyCtx = document.getElementById('weeklyHoursChart').getContext('2d');
    new Chart(weeklyCtx, {
        type: 'line',
        data: {
            labels: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
            datasets: [{
                label: 'Hours Learned',
                data: [2.5, 3.2, 1.8, 4.1, 3.7, 2.3, 1.9],
                borderColor: '#667eea',
                backgroundColor: 'rgba(102, 126, 234, 0.1)',
                borderWidth: 2,
                fill: true,
                tension: 0.4
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: {
                    display: false
                }
            },
            scales: {
                y: {
                    beginAtZero: true,
                    max: 5
                }
            }
        }
    });
    
    // Completion Rate Chart
    const completionCtx = document.getElementById('completionChart').getContext('2d');
    new Chart(completionCtx, {
        type: 'doughnut',
        data: {
            labels: ['Completed', 'In Progress', 'Not Started'],
            datasets: [{
                data: [70, 20, 10],
                backgroundColor: ['#28a745', '#ffc107', '#dc3545'],
                borderWidth: 0
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: {
                    position: 'bottom'
                }
            }
        }
    });
}

function initializeActivityFeed() {
    const activityFeed = document.getElementById('activityFeed');
    
    const activities = [
        {
            icon: 'bi-trophy',
            iconColor: 'bg-warning text-white',
            title: 'Completed "Advanced JavaScript" course',
            description: 'Earned 50 skill points and a certificate',
            time: '2 hours ago'
        },
        {
            icon: 'bi-check-circle',
            iconColor: 'bg-success text-white',
            title: 'Submitted assignment "React Components"',
            description: 'Scored 95% on your submission',
            time: '5 hours ago'
        },
        {
            icon: 'bi-book',
            iconColor: 'bg-primary text-white',
            title: 'Started new course "Python for Data Science"',
            description: 'Completed introduction module',
            time: '1 day ago'
        },
        {
            icon: 'bi-star',
            iconColor: 'bg-info text-white',
            title: 'Achieved "Quick Learner" badge',
            description: 'Completed 3 courses in one week',
            time: '2 days ago'
        },
        {
            icon: 'bi-people',
            iconColor: 'bg-secondary text-white',
            title: 'Joined study group "Web Development Bootcamp"',
            description: '15 other students in this group',
            time: '3 days ago'
        }
    ];
    
    activities.forEach(activity => {
        const activityItem = document.createElement('div');
        activityItem.className = 'activity-item';
        activityItem.innerHTML = `
            <div class="activity-icon ${activity.iconColor}">
                <i class="${activity.icon}"></i>
            </div>
            <div class="activity-content">
                <div class="activity-title">${activity.title}</div>
                <div class="activity-description">${activity.description}</div>
                <div class="activity-time">${activity.time}</div>
            </div>
        `;
        activityFeed.appendChild(activityItem);
    });
}

function initializeAchievements() {
    const achievementGrid = document.getElementById('achievementGrid');
    
    const achievements = [
        {
            icon: '🎓',
            title: 'Graduate',
            description: 'Complete 10 courses',
            earned: true
        },
        {
            icon: '⚡',
            title: 'Speed Demon',
            description: 'Finish course in 1 day',
            earned: true
        },
        {
            icon: '🔥',
            title: 'Streak Master',
            description: '30 day learning streak',
            earned: false
        },
        {
            icon: '💎',
            title: 'Perfect Score',
            description: 'Get 100% on assignment',
            earned: true
        },
        {
            icon: '🏆',
            title: 'Champion',
            description: 'Top 10 in leaderboard',
            earned: false
        },
        {
            icon: '📚',
            title: 'Bookworm',
            description: 'Read 50 lessons',
            earned: true
        }
    ];
    
    achievements.forEach(achievement => {
        const badge = document.createElement('div');
        badge.className = `achievement-badge ${achievement.earned ? 'earned' : ''}`;
        badge.innerHTML = `
            <span class="achievement-icon">${achievement.icon}</span>
            <div class="achievement-title">${achievement.title}</div>
            <div class="achievement-description">${achievement.description}</div>
        `;
        achievementGrid.appendChild(badge);
    });
}

// Animate numbers on page load
function animateNumber(element, target, duration = 2000) {
    const start = 0;
    const increment = target / (duration / 16);
    let current = start;
    
    const timer = setInterval(() => {
        current += increment;
        element.textContent = Math.floor(current);
        
        if (current >= target) {
            element.textContent = target;
            clearInterval(timer);
        }
    }, 16);
}

// Load dashboard data from API
async function loadDashboardData() {
    try {
        const response = await fetch('/api/profile/dashboard/');
        if (response.ok) {
            const data = await response.json();
            updateDashboardWithData(data);
        }
    } catch (error) {
        console.warn('Could not load dashboard data, using mock data:', error);
        // Fall back to mock data if API fails
    }
}

function updateDashboardWithData(data) {
    if (data.stats) {
        const stats = data.stats;
        document.getElementById('coursesCompleted').textContent = stats.coursesCompleted || 12;
        document.getElementById('hoursLearned').textContent = stats.hoursLearned || 340;
        document.getElementById('assignmentsSubmitted').textContent = stats.assignmentsSubmitted || 89;
        document.getElementById('currentStreak').textContent = stats.learningStreak || data.learningStreak || 15;
        document.getElementById('streakDisplay').textContent = stats.learningStreak || data.learningStreak || 15;
    }
    
    if (data.recentActivity) {
        updateActivityFeed(data.recentActivity);
    }
    
    if (data.achievements) {
        updateAchievements(data.achievements);
    }
    
    if (data.goalsProgress) {
        updateGoalsProgress(data.goalsProgress);
    }
}

function updateActivityFeed(activities) {
    const activityFeed = document.getElementById('activityFeed');
    activityFeed.innerHTML = '';
    
    activities.forEach(activity => {
        const activityItem = document.createElement('div');
        activityItem.className = 'activity-item';
        activityItem.innerHTML = `
            <div class="activity-icon ${activity.iconColor}">
                <i class="${activity.icon}"></i>
            </div>
            <div class="activity-content">
                <div class="activity-title">${activity.title}</div>
                <div class="activity-description">${activity.description}</div>
                <div class="activity-time">${activity.time}</div>
            </div>
        `;
        activityFeed.appendChild(activityItem);
    });
}

function updateAchievements(achievements) {
    const achievementGrid = document.getElementById('achievementGrid');
    achievementGrid.innerHTML = '';
    
    achievements.forEach(achievement => {
        const badge = document.createElement('div');
        badge.className = `achievement-badge ${achievement.earned ? 'earned' : ''}`;
        badge.innerHTML = `
            <span class="achievement-icon">${achievement.icon}</span>
            <div class="achievement-title">${achievement.title}</div>
            <div class="achievement-description">${achievement.description}</div>
        `;
        achievementGrid.appendChild(badge);
    });
}

function updateGoalsProgress(goals) {
    if (goals.weekly) {
        const weeklyBar = document.querySelector('.progress-bar.bg-success');
        if (weeklyBar) {
            weeklyBar.style.width = goals.weekly.percentage + '%';
            weeklyBar.parentElement.previousElementSibling.querySelector('.small:last-child').textContent = 
                `${goals.weekly.current}/${goals.weekly.target} hours`;
        }
    }
    
    if (goals.monthly) {
        const monthlyBar = document.querySelector('.progress-bar.bg-primary');
        if (monthlyBar) {
            monthlyBar.style.width = goals.monthly.percentage + '%';
            monthlyBar.parentElement.previousElementSibling.querySelector('.small:last-child').textContent = 
                `${goals.monthly.current}/${goals.monthly.target} completed`;
        }
    }
    
    if (goals.skill) {
        const skillBar = document.querySelector('.progress-bar.bg-warning');
        if (skillBar) {
            skillBar.style.width = goals.skill.percentage + '%';
            skillBar.parentElement.previousElementSibling.querySelector('.small:last-child').textContent = 
                `${goals.skill.current}/${goals.skill.target}`;
        }
    }
}

// Load calendar data from API
async function loadActivityCalendarData() {
    try {
        const response = await fetch('/api/profile/dashboard/calendar');
        if (response.ok) {
            const data = await response.json();
            if (data.days) {
                updateActivityCalendarWithData(data.days);
                document.getElementById('totalContributions').textContent = 
                    `${data.totalContributions} activities in the last year`;
            }
        }
    } catch (error) {
        console.warn('Could not load calendar data, using mock data:', error);
    }
}

function updateActivityCalendarWithData(days) {
    const calendarDays = document.getElementById('calendarDays');
    calendarDays.innerHTML = '';
    
    days.forEach(day => {
        const dayElement = document.createElement('div');
        dayElement.className = 'calendar-day';
        dayElement.setAttribute('data-level', day.level);
        dayElement.title = `${day.count} activities on ${day.date}`;
        calendarDays.appendChild(dayElement);
    });
}

// Animate stats on page load
window.addEventListener('load', () => {
    // Load data from API first, then animate
    loadDashboardData().then(() => {
        // Get current values and animate them
        const coursesEl = document.getElementById('coursesCompleted');
        const hoursEl = document.getElementById('hoursLearned');
        const assignmentsEl = document.getElementById('assignmentsSubmitted');
        const streakEl = document.getElementById('currentStreak');
        const streakDisplayEl = document.getElementById('streakDisplay');
        
        const coursesTarget = parseInt(coursesEl.textContent) || 12;
        const hoursTarget = parseInt(hoursEl.textContent) || 340;
        const assignmentsTarget = parseInt(assignmentsEl.textContent) || 89;
        const streakTarget = parseInt(streakEl.textContent) || 15;
        
        animateNumber(coursesEl, coursesTarget);
        animateNumber(hoursEl, hoursTarget);
        animateNumber(assignmentsEl, assignmentsTarget);
        animateNumber(streakEl, streakTarget);
        animateNumber(streakDisplayEl, streakTarget);
    });
    
    // Load calendar data
    loadActivityCalendarData();
});
</script>

</body>
</html>
