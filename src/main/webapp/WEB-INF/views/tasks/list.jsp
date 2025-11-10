<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>All Tasks - TaskFlow</title>
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
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 3rem;
        }
        
        .header-left h1 {
            font-size: 2.5rem;
            font-weight: 800;
            margin-bottom: 0.5rem;
            background: var(--gradient);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }
        
        .header-left p {
            color: var(--text-secondary);
            font-size: 1.1rem;
            font-weight: 400;
        }
        
        .header-actions {
            display: flex;
            gap: 1rem;
        }
        
        .btn {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            padding: 0.75rem 1.5rem;
            border-radius: 12px;
            font-weight: 600;
            text-decoration: none;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            border: none;
            cursor: pointer;
            font-size: 0.9rem;
        }
        
        .btn-primary {
            background: var(--gradient);
            color: white;
        }
        
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: var(--shadow);
        }
        
        .btn-secondary {
            background: var(--bg-secondary);
            border: 1px solid var(--border);
            color: var(--text-primary);
        }
        
        .btn-secondary:hover {
            border-color: var(--accent);
            transform: translateY(-1px);
        }
        
        .tasks-container {
            background: var(--bg-secondary);
            border: 1px solid var(--border);
            border-radius: 16px;
            overflow: hidden;
        }
        
        .tasks-header {
            padding: 2rem;
            border-bottom: 1px solid var(--border);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .tasks-title {
            font-size: 1.25rem;
            font-weight: 700;
            color: var(--text-primary);
        }
        
        .tasks-count {
            color: var(--text-secondary);
            font-size: 0.9rem;
            font-weight: 500;
        }
        
        .task-list {
            padding: 0;
        }
        
        .task-item {
            display: flex;
            align-items: center;
            gap: 1rem;
            padding: 1.5rem 2rem;
            border-bottom: 1px solid var(--border);
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            cursor: pointer;
        }
        
        .task-item:last-child {
            border-bottom: none;
        }
        
        .task-item:hover {
            background: var(--bg-tertiary);
            transform: translateX(4px);
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
            margin-bottom: 0.5rem;
            font-size: 1rem;
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
            width: 36px;
            height: 36px;
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
            padding: 6rem 2rem;
            color: var(--text-secondary);
        }
        
        .empty-icon {
            font-size: 5rem;
            margin-bottom: 2rem;
            opacity: 0.3;
            background: var(--gradient);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }
        
        .empty-title {
            font-size: 1.5rem;
            font-weight: 700;
            margin-bottom: 0.75rem;
            color: var(--text-primary);
        }
        
        .empty-description {
            font-size: 1rem;
            margin-bottom: 2.5rem;
            max-width: 400px;
            margin-left: auto;
            margin-right: auto;
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
            
            .header {
                flex-direction: column;
                gap: 1.5rem;
                align-items: stretch;
            }
            
            .task-item {
                padding: 1rem;
            }
            
            .task-meta {
                flex-direction: column;
                align-items: flex-start;
                gap: 0.5rem;
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
                    <a href="${pageContext.request.contextPath}/" class="nav-link">
                        <i class="fas fa-home nav-icon"></i>
                        <span>Dashboard</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/tasks" class="nav-link active">
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
                <div class="header-left">
                    <h1>All Tasks</h1>
                    <p>Manage and organize all your tasks in one place</p>
                </div>
                <div class="header-actions">
                    <button class="btn btn-primary" onclick="addNewTask()">
                        <i class="fas fa-plus"></i>
                        <span>New Task</span>
                    </button>
                </div>
            </div>
            
            <div class="tasks-container fade-in">
                <div class="tasks-header">
                    <div class="tasks-title">Your Tasks</div>
                    <div class="tasks-count">
                        <c:choose>
                            <c:when test="${empty tasks}">
                                No tasks yet
                            </c:when>
                            <c:otherwise>
                                ${fn:length(tasks)} tasks
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
                
                <div class="task-list">
                    <c:choose>
                        <c:when test="${empty tasks}">
                            <div class="empty-state">
                                <div class="empty-icon">
                                    <i class="fas fa-clipboard-list"></i>
                                </div>
                                <div class="empty-title">No tasks yet</div>
                                <div class="empty-description">Start your productivity journey by creating your first task. Every great achievement begins with a single step!</div>
                                <button class="btn btn-primary" onclick="addNewTask()">
                                    <i class="fas fa-plus"></i>
                                    <span>Create Your First Task</span>
                                </button>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="task" items="${tasks}" varStatus="status">
                                <div class="task-item" data-id="${task.taskId}" style="animation-delay: ${status.index * 0.05}s;">
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
                                                <span><i class="fas fa-calendar"></i> Due: <fmt:formatDate value="${task.dueDate}" pattern="MMM dd, yyyy" /></span>
                                            </c:if>
                                            <span><i class="fas fa-clock"></i> Created: <fmt:formatDate value="${task.createdAt}" pattern="MMM dd" /></span>
                                        </div>
                                    </div>
                                    <div class="task-actions">
                                        <button class="task-action-btn" onclick="editTask(${task.taskId})" title="Edit Task">
                                            <i class="fas fa-edit"></i>
                                        </button>
                                        <button class="task-action-btn" onclick="deleteTask(${task.taskId})" title="Delete Task">
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
        function addNewTask() {
            // Create a custom modal for better UX
            const modal = $(`
                <div class="task-modal-overlay">
                    <div class="task-modal">
                        <div class="task-modal-header">
                            <h3><i class="fas fa-plus-circle"></i> Create New Task</h3>
                            <button class="modal-close" onclick="$(this).closest('.task-modal-overlay').remove()">
                                <i class="fas fa-times"></i>
                            </button>
                        </div>
                        <div class="task-modal-body">
                            <div class="form-group">
                                <label>Task Title</label>
                                <input type="text" id="taskTitleInput" placeholder="What would you like to accomplish?" maxlength="200">
                            </div>
                            <div class="form-group">
                                <label>Priority Level</label>
                                <select id="taskPriorityInput">
                                    <option value="LOW">Low Priority</option>
                                    <option value="MEDIUM" selected>Medium Priority</option>
                                    <option value="HIGH">High Priority</option>
                                    <option value="URGENT">Urgent</option>
                                </select>
                            </div>
                        </div>
                        <div class="task-modal-footer">
                            <button class="btn btn-secondary" onclick="$(this).closest('.task-modal-overlay').remove()">Cancel</button>
                            <button class="btn btn-primary" onclick="createTask()">
                                <i class="fas fa-plus"></i> Create Task
                            </button>
                        </div>
                    </div>
                </div>
            `);
            
            // Add modal styles if not present
            if (!$('#modal-styles').length) {
                $('head').append(`
                    <style id="modal-styles">
                        .task-modal-overlay {
                            position: fixed;
                            top: 0;
                            left: 0;
                            width: 100%;
                            height: 100%;
                            background: rgba(0, 0, 0, 0.7);
                            display: flex;
                            align-items: center;
                            justify-content: center;
                            z-index: 10000;
                            animation: fadeIn 0.2s ease;
                        }
                        
                        .task-modal {
                            background: var(--bg-secondary);
                            border: 1px solid var(--border);
                            border-radius: 16px;
                            width: 90%;
                            max-width: 500px;
                            box-shadow: var(--shadow-lg);
                            animation: slideInScale 0.3s cubic-bezier(0.4, 0, 0.2, 1);
                        }
                        
                        .task-modal-header {
                            padding: 1.5rem 2rem;
                            border-bottom: 1px solid var(--border);
                            display: flex;
                            justify-content: space-between;
                            align-items: center;
                        }
                        
                        .task-modal-header h3 {
                            margin: 0;
                            color: var(--text-primary);
                            font-size: 1.25rem;
                            font-weight: 700;
                            display: flex;
                            align-items: center;
                            gap: 0.75rem;
                        }
                        
                        .modal-close {
                            background: none;
                            border: none;
                            color: var(--text-secondary);
                            font-size: 1.25rem;
                            cursor: pointer;
                            padding: 0.5rem;
                            border-radius: 8px;
                            transition: all 0.2s ease;
                        }
                        
                        .modal-close:hover {
                            background: var(--bg-tertiary);
                            color: var(--text-primary);
                        }
                        
                        .task-modal-body {
                            padding: 2rem;
                        }
                        
                        .form-group {
                            margin-bottom: 1.5rem;
                        }
                        
                        .form-group:last-child {
                            margin-bottom: 0;
                        }
                        
                        .form-group label {
                            display: block;
                            margin-bottom: 0.5rem;
                            font-weight: 600;
                            color: var(--text-primary);
                            font-size: 0.9rem;
                        }
                        
                        .form-group input, .form-group select {
                            width: 100%;
                            padding: 0.875rem 1rem;
                            border: 1px solid var(--border);
                            border-radius: 8px;
                            background: var(--bg-tertiary);
                            color: var(--text-primary);
                            font-size: 1rem;
                            transition: all 0.2s ease;
                        }
                        
                        .form-group input:focus, .form-group select:focus {
                            outline: none;
                            border-color: var(--accent);
                            box-shadow: 0 0 0 3px rgba(99, 102, 241, 0.1);
                        }
                        
                        .task-modal-footer {
                            padding: 1.5rem 2rem;
                            border-top: 1px solid var(--border);
                            display: flex;
                            justify-content: flex-end;
                            gap: 1rem;
                        }
                        
                        @keyframes fadeIn {
                            from { opacity: 0; }
                            to { opacity: 1; }
                        }
                        
                        @keyframes slideInScale {
                            from {
                                transform: scale(0.9) translateY(-20px);
                                opacity: 0;
                            }
                            to {
                                transform: scale(1) translateY(0);
                                opacity: 1;
                            }
                        }
                    </style>
                `);
            }
            
            $('body').append(modal);
            $('#taskTitleInput').focus();
            
            // Handle Enter key
            $('#taskTitleInput').on('keypress', function(e) {
                if (e.which === 13) {
                    createTask();
                }
            });
        }
        
        function createTask() {
            const title = $('#taskTitleInput').val().trim();
            const priority = $('#taskPriorityInput').val();
            
            if (!title) {
                showNotification('Please enter a task title', 'error');
                $('#taskTitleInput').focus();
                return;
            }
            
            $.ajax({
                url: '${pageContext.request.contextPath}/api/tasks',
                method: 'POST',
                contentType: 'application/json',
                data: JSON.stringify({
                    title: title,
                    description: '',
                    priority: priority,
                    status: 'PENDING'
                }),
                success: function(task) {
                    $('.task-modal-overlay').remove();
                    showNotification(`🎉 Task "${title}" has been created successfully!`, 'success');
                    setTimeout(() => location.reload(), 1000);
                },
                error: function(xhr, status, error) {
                    showNotification('❌ Error creating task. Please try again.', 'error');
                    console.error('Error:', error);
                }
            });
        }
        
        function toggleTask(taskId) {
            $.ajax({
                url: '${pageContext.request.contextPath}/api/tasks/' + taskId + '/toggle',
                method: 'PUT',
                success: function() {
                    showNotification('✅ Task status updated successfully!', 'success');
                    setTimeout(() => location.reload(), 600);
                },
                error: function(xhr, status, error) {
                    showNotification('❌ Error updating task status', 'error');
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
                        showNotification('📝 Task updated successfully!', 'success');
                        setTimeout(() => location.reload(), 600);
                    },
                    error: function(xhr, status, error) {
                        showNotification('❌ Error updating task', 'error');
                        console.error('Error:', error);
                    }
                });
            }
        }
        
        function deleteTask(taskId) {
            if (confirm('🗑️ Are you sure you want to delete this task? This action cannot be undone.')) {
                $.ajax({
                    url: '${pageContext.request.contextPath}/api/tasks/' + taskId,
                    method: 'DELETE',
                    success: function() {
                        showNotification('🗑️ Task deleted successfully!', 'success');
                        setTimeout(() => location.reload(), 600);
                    },
                    error: function(xhr, status, error) {
                        showNotification('❌ Error deleting task', 'error');
                        console.error('Error:', error);
                    }
                });
            }
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
        
        $(document).ready(function() {
            $('.task-item').each(function(index) {
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
                <a href="${pageContext.request.contextPath}/" class="sidebar-item">
                    <i class="fas fa-home"></i>
                    Dashboard
                </a>
                <a href="${pageContext.request.contextPath}/tasks" class="sidebar-item active">
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
                <h1 class="page-title">All Tasks</h1>
                
                <div class="task-list" id="taskList">
                    <c:choose>
                        <c:when test="${empty tasks}">
                            <div class="empty-state">
                                <i class="fas fa-clipboard-list"></i>
                                <div>No tasks yet. Click below to add your first task!</div>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="task" items="${tasks}">
                                <div class="task-item" data-id="${task.taskId}">
                                    <div class="task-checkbox ${task.status == 'COMPLETED' ? 'checked' : ''}" onclick="toggleTask(${task.taskId})">
                                        <c:if test="${task.status == 'COMPLETED'}">
                                            <i class="fas fa-check"></i>
                                        </c:if>
                                    </div>
                                    <div class="task-content">
                                        <div class="task-title ${task.status == 'COMPLETED' ? 'completed' : ''}">${task.title}</div>
                                        <div class="task-meta">
                                            <span class="task-priority priority-${task.priority.toString().toLowerCase()}">${task.priority}</span>
                                            <c:if test="${task.dueDate != null}">
                                                <span>Due: <fmt:formatDate value="${task.dueDate}" pattern="MMM dd" /></span>
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
        
        function editTask(taskId) {
            const newTitle = prompt('Enter new task title:');
            if (newTitle && newTitle.trim()) {
                $.ajax({
                    url: '${pageContext.request.contextPath}/api/tasks/' + taskId,
                    method: 'PUT',
                    contentType: 'application/json',
                    data: JSON.stringify({
                        title: newTitle.trim()
                    }),
                    success: function() {
                        location.reload();
                    },
                    error: function(xhr, status, error) {
                        alert('Error updating task: ' + error);
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
    </script>
</body>
</html>
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    
    <style>
        .sidebar {
            min-height: 100vh;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        .sidebar .nav-link {
            color: rgba(255, 255, 255, 0.8);
            transition: all 0.3s;
            margin-bottom: 5px;
            border-radius: 5px;
        }
        .sidebar .nav-link:hover {
            color: white;
            background-color: rgba(255, 255, 255, 0.1);
        }
        .sidebar .nav-link.active {
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
        .task-card {
            border-left: 4px solid #007bff;
            margin-bottom: 10px;
        }
        .task-priority-high { border-left-color: #dc3545; }
        .task-priority-medium { border-left-color: #ffc107; }
        .task-priority-low { border-left-color: #28a745; }
        .task-priority-urgent { border-left-color: #6f42c1; }
        .filter-section {
            background: white;
            border-radius: 15px;
            padding: 20px;
            margin-bottom: 20px;
            box-shadow: 0 0 15px rgba(0, 0, 0, 0.1);
        }
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
                            <a class="nav-link" href="/">
                                <i class="fas fa-tachometer-alt me-2"></i>
                                Dashboard
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link active" href="/tasks">
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
                    <h1 class="h2"><i class="fas fa-tasks me-2"></i>Tasks</h1>
                    <div class="btn-toolbar mb-2 mb-md-0">
                        <a href="/tasks/new" class="btn btn-primary">
                            <i class="fas fa-plus me-2"></i>Add New Task
                        </a>
                    </div>
                </div>

                <!-- Filter Section -->
                <div class="filter-section">
                    <form method="GET" action="/tasks">
                        <div class="row">
                            <div class="col-md-3">
                                <label class="form-label">Search Tasks</label>
                                <input type="text" class="form-control" name="search" 
                                       value="${currentSearch}" placeholder="Search tasks...">
                            </div>
                            <div class="col-md-3">
                                <label class="form-label">Status</label>
                                <select class="form-select" name="status">
                                    <option value="">All Statuses</option>
                                    <option value="PENDING" ${currentStatus == 'PENDING' ? 'selected' : ''}>Pending</option>
                                    <option value="IN_PROGRESS" ${currentStatus == 'IN_PROGRESS' ? 'selected' : ''}>In Progress</option>
                                    <option value="COMPLETED" ${currentStatus == 'COMPLETED' ? 'selected' : ''}>Completed</option>
                                    <option value="CANCELLED" ${currentStatus == 'CANCELLED' ? 'selected' : ''}>Cancelled</option>
                                </select>
                            </div>
                            <div class="col-md-3">
                                <label class="form-label">Priority</label>
                                <select class="form-select" name="priority">
                                    <option value="">All Priorities</option>
                                    <option value="LOW" ${currentPriority == 'LOW' ? 'selected' : ''}>Low</option>
                                    <option value="MEDIUM" ${currentPriority == 'MEDIUM' ? 'selected' : ''}>Medium</option>
                                    <option value="HIGH" ${currentPriority == 'HIGH' ? 'selected' : ''}>High</option>
                                    <option value="URGENT" ${currentPriority == 'URGENT' ? 'selected' : ''}>Urgent</option>
                                </select>
                            </div>
                            <div class="col-md-3 d-flex align-items-end">
                                <button type="submit" class="btn btn-outline-primary me-2">
                                    <i class="fas fa-search me-1"></i>Filter
                                </button>
                                <a href="/tasks" class="btn btn-outline-secondary">
                                    <i class="fas fa-times me-1"></i>Clear
                                </a>
                            </div>
                        </div>
                    </form>
                </div>

                <!-- Tasks List -->
                <div class="row">
                    <div class="col-12">
                        <c:choose>
                            <c:when test="${not empty tasks}">
                                <c:forEach var="task" items="${tasks}">
                                    <div class="task-card card task-priority-${task.priority.name().toLowerCase()}">
                                        <div class="card-body">
                                            <div class="row align-items-center">
                                                <div class="col-md-8">
                                                    <h5 class="card-title mb-2">
                                                        <a href="/tasks/${task.taskId}/details" class="text-decoration-none">
                                                            ${task.title}
                                                        </a>
                                                    </h5>
                                                    <p class="card-text text-muted mb-2">${task.description}</p>
                                                    <div class="mb-2">
                                                        <span class="badge ${task.statusStyle} me-2">${task.status}</span>
                                                        <span class="badge ${task.priorityStyle} me-2">${task.priority}</span>
                                                        <c:if test="${not empty task.categoryName}">
                                                            <span class="badge bg-info me-2">${task.categoryName}</span>
                                                        </c:if>
                                                        <c:if test="${task.overdue}">
                                                            <span class="badge bg-danger">OVERDUE</span>
                                                        </c:if>
                                                    </div>
                                                </div>
                                                <div class="col-md-4 text-end">
                                                    <c:if test="${not empty task.dueDate}">
                                                        <p class="mb-2">
                                                            <i class="fas fa-calendar me-1"></i>
                                                            <fmt:formatDate value="${task.dueDate}" pattern="MMM dd, yyyy"/>
                                                        </p>
                                                    </c:if>
                                                    
                                                    <div class="btn-group" role="group">
                                                        <a href="/tasks/${task.taskId}/edit" class="btn btn-outline-primary btn-sm">
                                                            <i class="fas fa-edit"></i>
                                                        </a>
                                                        <button class="btn btn-outline-success btn-sm" 
                                                                onclick="updateStatus(${task.taskId}, 'COMPLETED')"
                                                                ${task.status == 'COMPLETED' ? 'disabled' : ''}>
                                                            <i class="fas fa-check"></i>
                                                        </button>
                                                        <form method="POST" action="/tasks/${task.taskId}/delete" 
                                                              style="display: inline;" 
                                                              onsubmit="return confirm('Are you sure you want to delete this task?')">
                                                            <button type="submit" class="btn btn-outline-danger btn-sm">
                                                                <i class="fas fa-trash"></i>
                                                            </button>
                                                        </form>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <div class="text-center py-5">
                                    <i class="fas fa-tasks fa-3x text-muted mb-3"></i>
                                    <h4 class="text-muted">No Tasks Found</h4>
                                    <p class="text-muted">Start by creating your first task to track your productivity.</p>
                                    <a href="/tasks/new" class="btn btn-primary">
                                        <i class="fas fa-plus me-2"></i>Create Your First Task
                                    </a>
                                </div>
                            </c:otherwise>
                        </c:choose>
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
        function updateStatus(taskId, status) {
            $.ajax({
                url: '/tasks/' + taskId + '/status',
                method: 'POST',
                data: { status: status },
                success: function(response) {
                    location.reload();
                },
                error: function(xhr, status, error) {
                    alert('Failed to update task status: ' + error);
                }
            });
        }
    </script>
</body>
</html>