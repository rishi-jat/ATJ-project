<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TaskFlow - Your Productivity Hub</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        :root {
            --bg-primary: #0f0f0f;
            --bg-secondary: #1a1a1a;
            --bg-tertiary: #262626;
            --text-primary: #ffffff;
            --text-secondary: #a3a3a3;
            --text-muted: #737373;
            --accent: #6366f1;
            --accent-hover: #5b5ff1;
            --success: #10b981;
            --warning: #f59e0b;
            --danger: #ef4444;
            --border: #404040;
            --gradient: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            --glass-bg: rgba(255, 255, 255, 0.05);
            --glass-border: rgba(255, 255, 255, 0.1);
            --shadow: 0 8px 32px rgba(0, 0, 0, 0.3);
            --shadow-lg: 0 20px 50px rgba(0, 0, 0, 0.5);
        }
        
        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
            background: var(--bg-primary);
            color: var(--text-primary);
            line-height: 1.6;
            overflow-x: hidden;
        }
        
        .app-container {
            display: flex;
            min-height: 100vh;
        }
        
        .sidebar {
            width: 280px;
            background: var(--bg-secondary);
            border-right: 1px solid var(--border);
            padding: 2rem 1.5rem;
            position: fixed;
            height: 100vh;
            overflow-y: auto;
            z-index: 1000;
        }
        
        .logo {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            margin-bottom: 2.5rem;
            padding: 0.5rem;
        }
        
        .logo-icon {
            width: 40px;
            height: 40px;
            background: var(--gradient);
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 1.2rem;
            font-weight: 700;
        }
        
        .logo-text {
            font-size: 1.5rem;
            font-weight: 700;
            background: var(--gradient);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }
        
        .nav-menu {
            list-style: none;
        }
        
        .nav-item {
            margin-bottom: 0.5rem;
        }
        
        .nav-link {
            display: flex;
            align-items: center;
            gap: 0.875rem;
            padding: 0.875rem 1rem;
            border-radius: 12px;
            color: var(--text-secondary);
            text-decoration: none;
            font-weight: 500;
            transition: all 0.2s cubic-bezier(0.4, 0, 0.2, 1);
            position: relative;
            overflow: hidden;
        }
        
        .nav-link::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 0;
            height: 100%;
            background: var(--gradient);
            transition: width 0.3s ease;
            z-index: -1;
        }
        
        .nav-link:hover::before {
            width: 100%;
        }
        
        .nav-link:hover, .nav-link.active {
            color: var(--text-primary);
            transform: translateX(4px);
        }
        
        .nav-link.active {
            background: var(--glass-bg);
            border: 1px solid var(--glass-border);
        }
        
        .nav-icon {
            width: 20px;
            text-align: center;
        }
        
        .main-content {
            flex: 1;
            margin-left: 280px;
            padding: 2.5rem;
            min-height: 100vh;
            background: var(--bg-primary);
        }
        
        .header {
            margin-bottom: 3rem;
        }
        
        .page-title {
            font-size: 2.5rem;
            font-weight: 800;
            margin-bottom: 0.5rem;
            background: var(--gradient);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }
        
        .page-subtitle {
            color: var(--text-secondary);
            font-size: 1.1rem;
            font-weight: 400;
        }
        
        .quick-actions {
            display: flex;
            gap: 1rem;
            margin-bottom: 3rem;
        }
        
        .quick-action-btn {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            padding: 1rem 1.5rem;
            background: var(--bg-secondary);
            border: 1px solid var(--border);
            border-radius: 12px;
            color: var(--text-primary);
            text-decoration: none;
            font-weight: 500;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            cursor: pointer;
            position: relative;
            overflow: hidden;
        }
        
        .quick-action-btn::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: var(--gradient);
            transition: left 0.3s ease;
            z-index: 0;
        }
        
        .quick-action-btn:hover::before {
            left: 0;
        }
        
        .quick-action-btn:hover {
            transform: translateY(-2px);
            box-shadow: var(--shadow);
            border-color: var(--accent);
        }
        
        .quick-action-btn span {
            position: relative;
            z-index: 1;
        }
        
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 1.5rem;
            margin-bottom: 3rem;
        }
        
        .stat-card {
            background: var(--bg-secondary);
            border: 1px solid var(--border);
            border-radius: 16px;
            padding: 2rem;
            position: relative;
            overflow: hidden;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        }
        
        .stat-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: var(--gradient);
        }
        
        .stat-card:hover {
            transform: translateY(-4px);
            box-shadow: var(--shadow-lg);
            border-color: var(--accent);
        }
        
        .stat-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 1rem;
        }
        
        .stat-title {
            color: var(--text-secondary);
            font-size: 0.9rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }
        
        .stat-icon {
            width: 48px;
            height: 48px;
            background: var(--glass-bg);
            border: 1px solid var(--glass-border);
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.2rem;
            color: var(--accent);
        }
        
        .stat-value {
            font-size: 2.5rem;
            font-weight: 800;
            color: var(--text-primary);
            margin-bottom: 0.5rem;
        }
        
        .stat-change {
            font-size: 0.85rem;
            font-weight: 500;
            color: var(--success);
        }
        
        .tasks-section {
            background: var(--bg-secondary);
            border: 1px solid var(--border);
            border-radius: 16px;
            padding: 2rem;
            margin-bottom: 2rem;
        }
        
        .section-header {
            display: flex;
            align-items: center;
            justify-content: between;
            margin-bottom: 2rem;
        }
        
        .section-title {
            font-size: 1.5rem;
            font-weight: 700;
            color: var(--text-primary);
            margin-bottom: 0.5rem;
        }
        
        .section-subtitle {
            color: var(--text-secondary);
            font-size: 0.95rem;
        }
        
        .task-list {
            space: 1rem 0;
        }
        
        .task-item {
            display: flex;
            align-items: center;
            gap: 1rem;
            padding: 1.25rem;
            background: var(--bg-tertiary);
            border: 1px solid var(--border);
            border-radius: 12px;
            margin-bottom: 1rem;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            cursor: pointer;
        }
        
        .task-item:hover {
            transform: translateX(4px);
            border-color: var(--accent);
            box-shadow: var(--shadow);
        }
        
        .task-checkbox {
            width: 24px;
            height: 24px;
            border: 2px solid var(--border);
            border-radius: 6px;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: all 0.2s ease;
            flex-shrink: 0;
        }
        
        .task-checkbox:hover {
            border-color: var(--accent);
        }
        
        .task-checkbox.completed {
            background: var(--success);
            border-color: var(--success);
            color: white;
        }
        
        .task-content {
            flex: 1;
            min-width: 0;
        }
        
        .task-title {
            font-weight: 600;
            color: var(--text-primary);
            margin-bottom: 0.25rem;
            word-wrap: break-word;
        }
        
        .task-title.completed {
            text-decoration: line-through;
            color: var(--text-muted);
        }
        
        .task-meta {
            display: flex;
            align-items: center;
            gap: 1rem;
            font-size: 0.85rem;
            color: var(--text-secondary);
        }
        
        .task-priority {
            padding: 0.25rem 0.75rem;
            border-radius: 20px;
            font-size: 0.75rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }
        
        .priority-low { background: rgba(16, 185, 129, 0.2); color: var(--success); }
        .priority-medium { background: rgba(245, 158, 11, 0.2); color: var(--warning); }
        .priority-high { background: rgba(239, 68, 68, 0.2); color: var(--danger); }
        .priority-urgent { background: rgba(239, 68, 68, 0.3); color: var(--danger); font-weight: 700; }
        
        .task-actions {
            display: flex;
            gap: 0.5rem;
            opacity: 0;
            transition: opacity 0.2s ease;
        }
        
        .task-item:hover .task-actions {
            opacity: 1;
        }
        
        .task-action-btn {
            width: 32px;
            height: 32px;
            background: var(--glass-bg);
            border: 1px solid var(--glass-border);
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--text-secondary);
            cursor: pointer;
            transition: all 0.2s ease;
        }
        
        .task-action-btn:hover {
            background: var(--accent);
            color: white;
            transform: scale(1.1);
        }
        
        .empty-state {
            text-align: center;
            padding: 4rem 2rem;
            color: var(--text-secondary);
        }
        
        .empty-icon {
            font-size: 4rem;
            margin-bottom: 1.5rem;
            opacity: 0.3;
            background: var(--gradient);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }
        
        .empty-title {
            font-size: 1.25rem;
            font-weight: 600;
            margin-bottom: 0.5rem;
            color: var(--text-primary);
        }
        
        .empty-description {
            font-size: 0.95rem;
            margin-bottom: 2rem;
        }
        
        .cta-button {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            padding: 1rem 2rem;
            background: var(--gradient);
            color: white;
            text-decoration: none;
            border-radius: 12px;
            font-weight: 600;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            border: none;
            cursor: pointer;
            font-size: 1rem;
        }
        
        .cta-button:hover {
            transform: translateY(-2px);
            box-shadow: var(--shadow);
        }
        
        @media (max-width: 768px) {
            .sidebar {
                transform: translateX(-100%);
                transition: transform 0.3s ease;
            }
            
            .main-content {
                margin-left: 0;
                padding: 1.5rem;
            }
            
            .stats-grid {
                grid-template-columns: 1fr;
            }
            
            .quick-actions {
                flex-direction: column;
            }
        }
        
        .fade-in {
            animation: fadeIn 0.6s ease-out;
        }
        
        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        .slide-in {
            animation: slideIn 0.4s ease-out;
        }
        
        @keyframes slideIn {
            from {
                opacity: 0;
                transform: translateX(-20px);
            }
            to {
                opacity: 1;
                transform: translateX(0);
            }
        }
    </style>
</head>
<body>
    <div class="app-container">
        <!-- Sidebar -->
        <nav class="sidebar slide-in">
            <div class="logo">
                <div class="logo-icon">
                    <i class="fas fa-rocket"></i>
                </div>
                <div class="logo-text">TaskFlow</div>
            </div>
            
            <ul class="nav-menu">
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/" class="nav-link active">
                        <i class="fas fa-home nav-icon"></i>
                        <span>Dashboard</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/tasks" class="nav-link">
                        <i class="fas fa-tasks nav-icon"></i>
                        <span>All Tasks</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="#" class="nav-link">
                        <i class="fas fa-calendar nav-icon"></i>
                        <span>Calendar</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="#" class="nav-link">
                        <i class="fas fa-chart-line nav-icon"></i>
                        <span>Analytics</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="#" class="nav-link">
                        <i class="fas fa-cog nav-icon"></i>
                        <span>Settings</span>
                    </a>
                </li>
            </ul>
        </nav>
        
        <!-- Main Content -->
        <main class="main-content">
            <div class="header fade-in">
                <h1 class="page-title">Welcome back! 👋</h1>
                <p class="page-subtitle">Here's what's happening with your tasks today.</p>
            </div>
            
            <div class="quick-actions fade-in">
                <button class="quick-action-btn" onclick="addNewTask()">
                    <i class="fas fa-plus"></i>
                    <span>New Task</span>
                </button>
                <button class="quick-action-btn" onclick="viewAnalytics()">
                    <i class="fas fa-chart-bar"></i>
                    <span>Analytics</span>
                </button>
            </div>
            
            <div class="stats-grid fade-in">
                <div class="stat-card">
                    <div class="stat-header">
                        <div class="stat-title">Total Tasks</div>
                        <div class="stat-icon">
                            <i class="fas fa-tasks"></i>
                        </div>
                    </div>
                    <div class="stat-value">${totalTasks}</div>
                    <div class="stat-change">Active workspace</div>
                </div>
                
                <div class="stat-card">
                    <div class="stat-header">
                        <div class="stat-title">Completed</div>
                        <div class="stat-icon">
                            <i class="fas fa-check-circle"></i>
                        </div>
                    </div>
                    <div class="stat-value">${statusCounts['COMPLETED']}</div>
                    <div class="stat-change">Great progress!</div>
                </div>
                
                <div class="stat-card">
                    <div class="stat-header">
                        <div class="stat-title">In Progress</div>
                        <div class="stat-icon">
                            <i class="fas fa-clock"></i>
                        </div>
                    </div>
                    <div class="stat-value">${statusCounts['IN_PROGRESS']}</div>
                    <div class="stat-change">Keep going!</div>
                </div>
                
                <div class="stat-card">
                    <div class="stat-header">
                        <div class="stat-title">Pending</div>
                        <div class="stat-icon">
                            <i class="fas fa-pause-circle"></i>
                        </div>
                    </div>
                    <div class="stat-value">${statusCounts['PENDING']}</div>
                    <div class="stat-change">Ready to start</div>
                </div>
            </div>
            
            <div class="tasks-section fade-in">
                <div class="section-header">
                    <div>
                        <h2 class="section-title">Recent Tasks</h2>
                        <p class="section-subtitle">Your latest activities and priorities</p>
                    </div>
                </div>
                
                <div class="task-list">
                    <c:choose>
                        <c:when test="${empty recentTasks}">
                            <div class="empty-state">
                                <div class="empty-icon">
                                    <i class="fas fa-clipboard-list"></i>
                                </div>
                                <div class="empty-title">No tasks yet</div>
                                <div class="empty-description">Create your first task to get started on your productivity journey!</div>
                                <button class="cta-button" onclick="addNewTask()">
                                    <i class="fas fa-plus"></i>
                                    <span>Create Your First Task</span>
                                </button>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="task" items="${recentTasks}">
                                <div class="task-item" data-id="${task.taskId}">
                                    <div class="task-checkbox ${task.status == 'COMPLETED' ? 'completed' : ''}" onclick="toggleTask(${task.taskId})">
                                        <c:if test="${task.status == 'COMPLETED'}">
                                            <i class="fas fa-check"></i>
                                        </c:if>
                                    </div>
                                    <div class="task-content">
                                        <div class="task-title ${task.status == 'COMPLETED' ? 'completed' : ''}">${task.title}</div>
                                        <div class="task-meta">
                                            <span class="task-priority priority-${task.priority.toString().toLowerCase()}">${task.priority}</span>
                                            <c:if test="${task.dueDate != null}">
                                                <span><i class="fas fa-calendar"></i> <fmt:formatDate value="${task.dueDate}" pattern="MMM dd" /></span>
                                            </c:if>
                                        </div>
                                    </div>
                                    <div class="task-actions">
                                        <button class="task-action-btn" onclick="editTask(${task.taskId})" title="Edit">
                                            <i class="fas fa-edit"></i>
                                        </button>
                                        <button class="task-action-btn" onclick="deleteTask(${task.taskId})" title="Delete">
                                            <i class="fas fa-trash"></i>
                                        </button>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </main>
    </div>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script>
        // Modern task management functions
        function addNewTask() {
            const title = prompt('✨ What would you like to accomplish?');
            if (title && title.trim()) {
                $.ajax({
                    url: '${pageContext.request.contextPath}/api/tasks',
                    method: 'POST',
                    contentType: 'application/json',
                    data: JSON.stringify({
                        title: title.trim(),
                        description: '',
                        priority: 'MEDIUM',
                        status: 'PENDING'
                    }),
                    success: function(task) {
                        showNotification('Task created successfully! 🎉', 'success');
                        setTimeout(() => location.reload(), 800);
                    },
                    error: function(xhr, status, error) {
                        showNotification('Error creating task. Please try again.', 'error');
                        console.error('Error:', error);
                    }
                });
            }
        }
        
        function toggleTask(taskId) {
            $.ajax({
                url: '${pageContext.request.contextPath}/api/tasks/' + taskId + '/toggle',
                method: 'PUT',
                success: function() {
                    showNotification('Task updated! ✅', 'success');
                    setTimeout(() => location.reload(), 500);
                },
                error: function(xhr, status, error) {
                    showNotification('Error updating task', 'error');
                    console.error('Error:', error);
                }
            });
        }
        
        function editTask(taskId) {
            const newTitle = prompt('✏️ Edit your task:');
            if (newTitle && newTitle.trim()) {
                $.ajax({
                    url: '${pageContext.request.contextPath}/api/tasks/' + taskId,
                    method: 'PUT',
                    contentType: 'application/json',
                    data: JSON.stringify({
                        title: newTitle.trim()
                    }),
                    success: function() {
                        showNotification('Task updated successfully! 📝', 'success');
                        setTimeout(() => location.reload(), 500);
                    },
                    error: function(xhr, status, error) {
                        showNotification('Error updating task', 'error');
                        console.error('Error:', error);
                    }
                });
            }
        }
        
        function deleteTask(taskId) {
            if (confirm('🗑️ Are you sure you want to delete this task?')) {
                $.ajax({
                    url: '${pageContext.request.contextPath}/api/tasks/' + taskId,
                    method: 'DELETE',
                    success: function() {
                        showNotification('Task deleted successfully! 🗑️', 'success');
                        setTimeout(() => location.reload(), 500);
                    },
                    error: function(xhr, status, error) {
                        showNotification('Error deleting task', 'error');
                        console.error('Error:', error);
                    }
                });
            }
        }
        
        function viewAnalytics() {
            showNotification('Analytics coming soon! 📊', 'info');
        }
        
        function showNotification(message, type) {
            // Remove any existing notifications first
            $('.notification').remove();
            
            const notification = $(`
                <div class="notification notification-\${type}">
                    <div class="notification-content">
                        <div class="notification-icon">
                            \${type === 'success' ? '<i class="fas fa-check-circle"></i>' : 
                              type === 'error' ? '<i class="fas fa-exclamation-circle"></i>' : 
                              '<i class="fas fa-info-circle"></i>'}
                        </div>
                        <div class="notification-text">\${message}</div>
                        <button class="notification-close" onclick="$(this).closest('.notification').remove()">
                            <i class="fas fa-times"></i>
                        </button>
                    </div>
                </div>
            `);
            
            if (!$('#notification-styles').length) {
                $('head').append(`
                    <style id="notification-styles">
                        .notification {
                            position: fixed;
                            top: 20px;
                            right: 20px;
                            min-width: 300px;
                            max-width: 500px;
                            background: var(--bg-secondary);
                            border: 1px solid var(--border);
                            border-radius: 12px;
                            color: var(--text-primary);
                            font-weight: 600;
                            z-index: 10000;
                            animation: slideInRight 0.4s cubic-bezier(0.4, 0, 0.2, 1);
                            box-shadow: var(--shadow-lg);
                            backdrop-filter: blur(20px);
                        }
                        
                        .notification-content {
                            display: flex;
                            align-items: center;
                            gap: 1rem;
                            padding: 1rem 1.5rem;
                        }
                        
                        .notification-icon {
                            font-size: 1.5rem;
                            flex-shrink: 0;
                        }
                        
                        .notification-text {
                            flex: 1;
                            font-size: 0.95rem;
                        }
                        
                        .notification-close {
                            background: none;
                            border: none;
                            color: var(--text-secondary);
                            cursor: pointer;
                            padding: 0.5rem;
                            border-radius: 6px;
                            transition: all 0.2s ease;
                        }
                        
                        .notification-close:hover {
                            background: var(--bg-tertiary);
                            color: var(--text-primary);
                        }
                        
                        .notification-success {
                            border-left: 4px solid var(--success);
                        }
                        
                        .notification-success .notification-icon {
                            color: var(--success);
                        }
                        
                        .notification-error {
                            border-left: 4px solid var(--danger);
                        }
                        
                        .notification-error .notification-icon {
                            color: var(--danger);
                        }
                        
                        .notification-info {
                            border-left: 4px solid var(--accent);
                        }
                        
                        .notification-info .notification-icon {
                            color: var(--accent);
                        }
                        
                        @keyframes slideInRight {
                            from {
                                transform: translateX(100%);
                                opacity: 0;
                            }
                            to {
                                transform: translateX(0);
                                opacity: 1;
                            }
                        }
                        
                        @keyframes pulse {
                            0%, 100% { transform: scale(1); }
                            50% { transform: scale(1.05); }
                        }
                        
                        .notification.pulse {
                            animation: slideInRight 0.4s cubic-bezier(0.4, 0, 0.2, 1), pulse 0.6s ease 0.4s;
                        }
                    </style>
                `);
            }
            
            $('body').append(notification);
            
            // Add pulse effect for success messages
            if (type === 'success') {
                setTimeout(() => notification.addClass('pulse'), 100);
            }
            
            // Auto remove after 4 seconds
            setTimeout(() => {
                notification.fadeOut(300, function() {
                    $(this).remove();
                });
            }, 4000);
        }
        
        // Add smooth scrolling and animations
        $(document).ready(function() {
            // Add stagger animation to cards
            $('.stat-card').each(function(index) {
                $(this).css('animation-delay', (index * 0.1) + 's');
                $(this).addClass('fade-in');
            });
            
            $('.task-item').each(function(index) {
                $(this).css('animation-delay', (index * 0.05) + 's');
                $(this).addClass('slide-in');
            });
        });
    </script>
</body>
</html>
    <div class="notion-container">
        <!-- Sidebar -->
        <div class="notion-sidebar">
            <div class="sidebar-header">
                <div class="workspace-title">Personal Workspace</div>
            </div>
            
            <nav>
                <a href="${pageContext.request.contextPath}/" class="sidebar-item active">
                    <i class="fas fa-home"></i>
                    Dashboard
                </a>
                <a href="${pageContext.request.contextPath}/tasks" class="sidebar-item">
                    <i class="fas fa-tasks"></i>
                    All Tasks
                </a>
                <a href="#" class="sidebar-item">
                    <i class="fas fa-calendar"></i>
                    Calendar
                </a>
                <a href="#" class="sidebar-item">
                    <i class="fas fa-chart-bar"></i>
                    Analytics
                </a>
            </nav>
        </div>
        
        <!-- Main Content -->
        <div class="notion-main">
            <div class="main-content">
                <textarea class="page-title" placeholder="Untitled" rows="1">My Dashboard</textarea>
                
                <div class="quick-actions">
                    <div class="add-block" onclick="addNewTask()">
                        <i class="fas fa-plus"></i> Click to add a task
                    </div>
                </div>
                
                <div class="section-title">Today's Tasks</div>
                <div class="task-list" id="taskList">
                    <c:choose>
                        <c:when test="${empty tasks}">
                            <div class="empty-state">
                                <i class="fas fa-clipboard-list"></i>
                                <div>No tasks yet. Click above to add your first task!</div>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="task" items="${tasks}">
                                <div class="task-item" data-id="${task.id}">
                                    <div class="task-checkbox ${task.status == 'COMPLETED' ? 'checked' : ''}" onclick="toggleTask(${task.id})">
                                        <c:if test="${task.status == 'COMPLETED'}">
                                            <i class="fas fa-check"></i>
                                        </c:if>
                                    </div>
                                    <textarea class="task-text ${task.status == 'COMPLETED' ? 'completed' : ''}" rows="1" onblur="updateTask(${task.id}, this.value)">${task.title}</textarea>
                                    <div class="task-actions">
                                        <button class="task-action-btn" onclick="deleteTask(${task.id})" title="Delete">
                                            <i class="fas fa-trash"></i>
                                        </button>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </div>
                
                <button class="add-task-btn" onclick="addNewTask()">
                    <i class="fas fa-plus"></i>
                    Add a task
                </button>
            </div>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script>
        function addNewTask() {
            const title = prompt('Enter task title:');
            if (title && title.trim()) {
                $.ajax({
                    url: '${pageContext.request.contextPath}/api/tasks',
                    method: 'POST',
                    contentType: 'application/json',
                    data: JSON.stringify({
                        title: title.trim(),
                        description: '',
                        priority: 'MEDIUM',
                        status: 'PENDING'
                    }),
                    success: function(task) {
                        location.reload();
                    },
                    error: function(xhr, status, error) {
                        alert('Error adding task: ' + error);
                    }
                });
            }
        }
        
        function toggleTask(taskId) {
            $.ajax({
                url: '${pageContext.request.contextPath}/api/tasks/' + taskId + '/toggle',
                method: 'PUT',
                success: function() {
                    location.reload();
                },
                error: function(xhr, status, error) {
                    alert('Error updating task: ' + error);
                }
            });
        }
        
        function updateTask(taskId, newTitle) {
            if (newTitle.trim()) {
                $.ajax({
                    url: '${pageContext.request.contextPath}/api/tasks/' + taskId,
                    method: 'PUT',
                    contentType: 'application/json',
                    data: JSON.stringify({
                        title: newTitle.trim()
                    }),
                    error: function(xhr, status, error) {
                        alert('Error updating task: ' + error);
                        location.reload();
                    }
                });
            }
        }
        
        function deleteTask(taskId) {
            if (confirm('Delete this task?')) {
                $.ajax({
                    url: '${pageContext.request.contextPath}/api/tasks/' + taskId,
                    method: 'DELETE',
                    success: function() {
                        location.reload();
                    },
                    error: function(xhr, status, error) {
                        alert('Error deleting task: ' + error);
                    }
                });
            }
        }
        
        // Auto-resize textareas
        document.querySelectorAll('textarea').forEach(textarea => {
            textarea.addEventListener('input', function() {
                this.style.height = 'auto';
                this.style.height = this.scrollHeight + 'px';
            });
        });
    </script>
</body>
</html>
            color: white;
            background-color: rgba(255, 255, 255, 0.1);
        }
        .main-content {
            min-height: 100vh;
            background-color: #f8f9fa;
        }
        .card {
            border: none;
            border-radius: 15px;
            box-shadow: 0 0 20px rgba(0, 0, 0, 0.1);
            transition: transform 0.3s, box-shadow 0.3s;
        }
        .card:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 30px rgba(0, 0, 0, 0.15);
        }
        .stat-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        .stat-card-success { background: linear-gradient(135deg, #56ab2f 0%, #a8e6cf 100%); }
        .stat-card-warning { background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%); }
        .stat-card-info { background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%); }
        .task-item {
            border-left: 4px solid #007bff;
            transition: all 0.3s;
        }
        .task-priority-high { border-left-color: #dc3545; }
        .task-priority-medium { border-left-color: #ffc107; }
        .task-priority-low { border-left-color: #28a745; }
        .task-priority-urgent { border-left-color: #6f42c1; }
    </style>
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <!-- Sidebar -->
            <nav class="col-md-3 col-lg-2 d-md-block sidebar">
                <div class="position-sticky pt-3">
                    <div class="text-center mb-4">
                        <i class="fas fa-chart-line fa-3x mb-2"></i>
                        <h4>Productivity Tracker</h4>
                    </div>
                    
                    <ul class="nav flex-column">
                        <li class="nav-item">
                            <a class="nav-link active" href="/">
                                <i class="fas fa-tachometer-alt me-2"></i>
                                Dashboard
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="/tasks">
                                <i class="fas fa-tasks me-2"></i>
                                Tasks
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="#time-tracking">
                                <i class="fas fa-clock me-2"></i>
                                Time Tracking
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="#reports">
                                <i class="fas fa-chart-bar me-2"></i>
                                Reports
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="#settings">
                                <i class="fas fa-cog me-2"></i>
                                Settings
                            </a>
                        </li>
                    </ul>
                </div>
            </nav>

            <!-- Main Content -->
            <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4 main-content">
                <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                    <h1 class="h2"><i class="fas fa-tachometer-alt me-2"></i>Dashboard</h1>
                    <div class="btn-toolbar mb-2 mb-md-0">
                        <button type="button" class="btn btn-outline-primary">
                            <i class="fas fa-download me-2"></i>Export
                        </button>
                    </div>
                </div>

                <!-- Statistics Cards -->
                <div class="row mb-4">
                    <div class="col-xl-3 col-md-6 mb-4">
                        <div class="card stat-card h-100 py-2">
                            <div class="card-body">
                                <div class="row no-gutters align-items-center">
                                    <div class="col mr-2">
                                        <div class="text-xs font-weight-bold text-uppercase mb-1">Total Tasks</div>
                                        <div class="h5 mb-0 font-weight-bold">${totalTasks}</div>
                                    </div>
                                    <div class="col-auto">
                                        <i class="fas fa-tasks fa-2x text-gray-300"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="col-xl-3 col-md-6 mb-4">
                        <div class="card stat-card-success h-100 py-2">
                            <div class="card-body">
                                <div class="row no-gutters align-items-center">
                                    <div class="col mr-2">
                                        <div class="text-xs font-weight-bold text-uppercase mb-1">Completed</div>
                                        <div class="h5 mb-0 font-weight-bold">${statusCounts['COMPLETED']}</div>
                                    </div>
                                    <div class="col-auto">
                                        <i class="fas fa-check-circle fa-2x text-gray-300"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="col-xl-3 col-md-6 mb-4">
                        <div class="card stat-card-warning h-100 py-2">
                            <div class="card-body">
                                <div class="row no-gutters align-items-center">
                                    <div class="col mr-2">
                                        <div class="text-xs font-weight-bold text-uppercase mb-1">In Progress</div>
                                        <div class="h5 mb-0 font-weight-bold">${statusCounts['IN_PROGRESS']}</div>
                                    </div>
                                    <div class="col-auto">
                                        <i class="fas fa-spinner fa-2x text-gray-300"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="col-xl-3 col-md-6 mb-4">
                        <div class="card stat-card-info h-100 py-2">
                            <div class="card-body">
                                <div class="row no-gutters align-items-center">
                                    <div class="col mr-2">
                                        <div class="text-xs font-weight-bold text-uppercase mb-1">Overdue</div>
                                        <div class="h5 mb-0 font-weight-bold">${overdueTasks.size()}</div>
                                    </div>
                                    <div class="col-auto">
                                        <i class="fas fa-exclamation-triangle fa-2x text-gray-300"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Charts Row -->
                <div class="row">
                    <div class="col-xl-6 col-lg-6">
                        <div class="card shadow mb-4">
                            <div class="card-header py-3 d-flex flex-row align-items-center justify-content-between">
                                <h6 class="m-0 font-weight-bold text-primary">Task Status Distribution</h6>
                            </div>
                            <div class="card-body">
                                <div class="chart-pie pt-4 pb-2">
                                    <canvas id="statusChart"></canvas>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="col-xl-6 col-lg-6">
                        <div class="card shadow mb-4">
                            <div class="card-header py-3 d-flex flex-row align-items-center justify-content-between">
                                <h6 class="m-0 font-weight-bold text-primary">Priority Distribution</h6>
                            </div>
                            <div class="card-body">
                                <div class="chart-pie pt-4 pb-2">
                                    <canvas id="priorityChart"></canvas>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Recent Tasks and Upcoming Tasks -->
                <div class="row">
                    <div class="col-lg-6 mb-4">
                        <div class="card shadow">
                            <div class="card-header py-3 d-flex flex-row align-items-center justify-content-between">
                                <h6 class="m-0 font-weight-bold text-primary">Recent Tasks</h6>
                                <a href="/tasks" class="btn btn-sm btn-primary">View All</a>
                            </div>
                            <div class="card-body">
                                <c:choose>
                                    <c:when test="${not empty recentTasks}">
                                        <c:forEach var="task" items="${recentTasks}">
                                            <div class="task-item card mb-2 task-priority-${task.priority.name().toLowerCase()}">
                                                <div class="card-body py-2">
                                                    <div class="row align-items-center">
                                                        <div class="col">
                                                            <h6 class="mb-1">${task.title}</h6>
                                                            <span class="badge ${task.statusStyle}">${task.status}</span>
                                                            <span class="badge ${task.priorityStyle}">${task.priority}</span>
                                                        </div>
                                                        <div class="col-auto">
                                                            <c:if test="${not empty task.dueDate}">
                                                                <small class="text-muted">
                                                                    <fmt:formatDate value="${task.dueDate}" pattern="MMM dd"/>
                                                                </small>
                                                            </c:if>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <p class="text-muted">No recent tasks found.</p>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>

                    <div class="col-lg-6 mb-4">
                        <div class="card shadow">
                            <div class="card-header py-3 d-flex flex-row align-items-center justify-content-between">
                                <h6 class="m-0 font-weight-bold text-primary">Upcoming Tasks</h6>
                                <a href="/tasks/new" class="btn btn-sm btn-success">Add New</a>
                            </div>
                            <div class="card-body">
                                <c:choose>
                                    <c:when test="${not empty upcomingTasks}">
                                        <c:forEach var="task" items="${upcomingTasks}">
                                            <div class="task-item card mb-2 task-priority-${task.priority.name().toLowerCase()}">
                                                <div class="card-body py-2">
                                                    <div class="row align-items-center">
                                                        <div class="col">
                                                            <h6 class="mb-1">${task.title}</h6>
                                                            <span class="badge ${task.statusStyle}">${task.status}</span>
                                                            <span class="badge ${task.priorityStyle}">${task.priority}</span>
                                                        </div>
                                                        <div class="col-auto">
                                                            <c:if test="${not empty task.dueDate}">
                                                                <small class="text-muted">
                                                                    <fmt:formatDate value="${task.dueDate}" pattern="MMM dd"/>
                                                                </small>
                                                            </c:if>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <p class="text-muted">No upcoming tasks found.</p>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                </div>
            </main>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <!-- jQuery -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    
    <script>
        // Status Chart
        const statusCtx = document.getElementById('statusChart').getContext('2d');
        const statusChart = new Chart(statusCtx, {
            type: 'doughnut',
            data: {
                labels: ['Pending', 'In Progress', 'Completed', 'Cancelled'],
                datasets: [{
                    data: [
                        ${statusCounts['PENDING']},
                        ${statusCounts['IN_PROGRESS']},
                        ${statusCounts['COMPLETED']},
                        ${statusCounts['CANCELLED']}
                    ],
                    backgroundColor: ['#6c757d', '#007bff', '#28a745', '#dc3545']
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

        // Priority Chart
        const priorityCtx = document.getElementById('priorityChart').getContext('2d');
        const priorityChart = new Chart(priorityCtx, {
            type: 'doughnut',
            data: {
                labels: ['Low', 'Medium', 'High', 'Urgent'],
                datasets: [{
                    data: [
                        ${priorityCounts['LOW']},
                        ${priorityCounts['MEDIUM']},
                        ${priorityCounts['HIGH']},
                        ${priorityCounts['URGENT']}
                    ],
                    backgroundColor: ['#28a745', '#17a2b8', '#ffc107', '#6f42c1']
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
    </script>
</body>
</html>