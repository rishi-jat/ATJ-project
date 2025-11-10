<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Task Form - Personal Productivity Tracker</title>
    
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
                    <h1 class="h2">
                        <i class="fas fa-tasks me-2"></i>
                        <c:choose>
                            <c:when test="${not empty task.taskId}">Edit Task</c:when>
                            <c:otherwise>New Task</c:otherwise>
                        </c:choose>
                    </h1>
                    <div class="btn-toolbar mb-2 mb-md-0">
                        <a href="/tasks" class="btn btn-outline-secondary">
                            <i class="fas fa-arrow-left me-2"></i>Back to Tasks
                        </a>
                    </div>
                </div>

                <div class="row justify-content-center">
                    <div class="col-lg-8">
                        <div class="card">
                            <div class="card-body p-4">
                                <form action="${not empty task.taskId ? '/tasks/' += task.taskId += '/update' : '/tasks/create'}" method="POST">
                                    <div class="mb-3">
                                        <label for="title" class="form-label">Task Title *</label>
                                        <input type="text" class="form-control" id="title" name="title" 
                                               value="${task.title}" required 
                                               placeholder="Enter task title">
                                    </div>

                                    <div class="mb-3">
                                        <label for="description" class="form-label">Description</label>
                                        <textarea class="form-control" id="description" name="description" 
                                                  rows="4" placeholder="Enter task description">${task.description}</textarea>
                                    </div>

                                    <div class="row">
                                        <div class="col-md-6">
                                            <div class="mb-3">
                                                <label for="priority" class="form-label">Priority</label>
                                                <select class="form-select" id="priority" name="priority">
                                                    <option value="LOW" ${task.priority == 'LOW' ? 'selected' : ''}>Low</option>
                                                    <option value="MEDIUM" ${task.priority == 'MEDIUM' ? 'selected' : ''} 
                                                            ${empty task.priority ? 'selected' : ''}>Medium</option>
                                                    <option value="HIGH" ${task.priority == 'HIGH' ? 'selected' : ''}>High</option>
                                                    <option value="URGENT" ${task.priority == 'URGENT' ? 'selected' : ''}>Urgent</option>
                                                </select>
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="mb-3">
                                                <label for="status" class="form-label">Status</label>
                                                <select class="form-select" id="status" name="status">
                                                    <option value="PENDING" ${task.status == 'PENDING' ? 'selected' : ''} 
                                                            ${empty task.status ? 'selected' : ''}>Pending</option>
                                                    <option value="IN_PROGRESS" ${task.status == 'IN_PROGRESS' ? 'selected' : ''}>In Progress</option>
                                                    <option value="COMPLETED" ${task.status == 'COMPLETED' ? 'selected' : ''}>Completed</option>
                                                    <option value="CANCELLED" ${task.status == 'CANCELLED' ? 'selected' : ''}>Cancelled</option>
                                                </select>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="row">
                                        <div class="col-md-6">
                                            <div class="mb-3">
                                                <label for="dueDate" class="form-label">Due Date</label>
                                                <input type="date" class="form-control" id="dueDate" name="dueDate" 
                                                       value="${task.dueDate}">
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="mb-3">
                                                <label for="estimatedHours" class="form-label">Estimated Hours</label>
                                                <input type="number" class="form-control" id="estimatedHours" 
                                                       name="estimatedHours" step="0.5" min="0" 
                                                       value="${task.estimatedHours}" 
                                                       placeholder="0.0">
                                            </div>
                                        </div>
                                    </div>

                                    <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                                        <a href="/tasks" class="btn btn-secondary">Cancel</a>
                                        <button type="submit" class="btn btn-primary">
                                            <i class="fas fa-save me-2"></i>
                                            <c:choose>
                                                <c:when test="${not empty task.taskId}">Update Task</c:when>
                                                <c:otherwise>Create Task</c:otherwise>
                                            </c:choose>
                                        </button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
            </main>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>