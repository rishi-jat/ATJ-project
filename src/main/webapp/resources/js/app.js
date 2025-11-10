// Personal Productivity Tracker JavaScript Functions

// Global variables
let currentUser = 1; // Demo user ID
let activeTimer = null;

// Document ready function
$(document).ready(function() {
    initializeApp();
});

// Initialize the application
function initializeApp() {
    // Set up event listeners
    setupEventListeners();
    
    // Load initial data if on dashboard
    if (window.location.pathname === '/' || window.location.pathname === '/dashboard') {
        loadDashboardData();
    }
    
    // Auto-save form data
    setupAutoSave();
    
    // Setup tooltips
    setupTooltips();
    
    console.log('Productivity Tracker initialized successfully');
}

// Setup event listeners
function setupEventListeners() {
    // Task status update buttons
    $('.status-update-btn').on('click', function() {
        const taskId = $(this).data('task-id');
        const status = $(this).data('status');
        updateTaskStatus(taskId, status);
    });
    
    // Task priority buttons
    $('.priority-filter-btn').on('click', function() {
        const priority = $(this).data('priority');
        filterTasksByPriority(priority);
    });
    
    // Search functionality
    $('#taskSearch').on('keyup', debounce(function() {
        const searchTerm = $(this).val();
        searchTasks(searchTerm);
    }, 300));
    
    // Form validation
    $('.needs-validation').on('submit', function(e) {
        if (!this.checkValidity()) {
            e.preventDefault();
            e.stopPropagation();
        }
        $(this).addClass('was-validated');
    });
    
    // Auto-resize textareas
    $('textarea').on('input', function() {
        this.style.height = 'auto';
        this.style.height = (this.scrollHeight) + 'px';
    });
}

// Update task status via AJAX
function updateTaskStatus(taskId, status) {
    showLoading(true);
    
    $.ajax({
        url: '/tasks/' + taskId + '/status',
        method: 'POST',
        data: { status: status },
        success: function(response) {
            showToast('Task status updated successfully', 'success');
            // Refresh the current view
            setTimeout(() => {
                window.location.reload();
            }, 1000);
        },
        error: function(xhr, status, error) {
            showToast('Failed to update task status: ' + error, 'error');
        },
        complete: function() {
            showLoading(false);
        }
    });
}

// Search tasks
function searchTasks(searchTerm) {
    if (searchTerm.length < 2) {
        $('.task-card').show();
        return;
    }
    
    $('.task-card').each(function() {
        const taskTitle = $(this).find('.card-title').text().toLowerCase();
        const taskDescription = $(this).find('.card-text').text().toLowerCase();
        const searchLower = searchTerm.toLowerCase();
        
        if (taskTitle.includes(searchLower) || taskDescription.includes(searchLower)) {
            $(this).show();
        } else {
            $(this).hide();
        }
    });
}

// Filter tasks by priority
function filterTasksByPriority(priority) {
    if (priority === 'all') {
        $('.task-card').show();
        return;
    }
    
    $('.task-card').each(function() {
        if ($(this).hasClass('task-priority-' + priority.toLowerCase())) {
            $(this).show();
        } else {
            $(this).hide();
        }
    });
    
    // Update active filter button
    $('.priority-filter-btn').removeClass('active');
    $(`[data-priority="${priority}"]`).addClass('active');
}

// Load dashboard data
function loadDashboardData() {
    $.ajax({
        url: '/dashboard/stats',
        method: 'GET',
        success: function(data) {
            updateDashboardStats(data);
        },
        error: function(xhr, status, error) {
            console.error('Failed to load dashboard data:', error);
        }
    });
}

// Update dashboard statistics
function updateDashboardStats(data) {
    // Update stat cards
    $('#totalTasks').text(data.totalTasks);
    $('#completedTasks').text(data.statusCounts.COMPLETED || 0);
    $('#inProgressTasks').text(data.statusCounts.IN_PROGRESS || 0);
    $('#pendingTasks').text(data.statusCounts.PENDING || 0);
    
    // Update charts if they exist
    if (window.statusChart) {
        updateStatusChart(data.statusCounts);
    }
    if (window.priorityChart) {
        updatePriorityChart(data.priorityCounts);
    }
}

// Update status chart
function updateStatusChart(statusCounts) {
    const data = [
        statusCounts.PENDING || 0,
        statusCounts.IN_PROGRESS || 0,
        statusCounts.COMPLETED || 0,
        statusCounts.CANCELLED || 0
    ];
    
    window.statusChart.data.datasets[0].data = data;
    window.statusChart.update();
}

// Update priority chart
function updatePriorityChart(priorityCounts) {
    const data = [
        priorityCounts.LOW || 0,
        priorityCounts.MEDIUM || 0,
        priorityCounts.HIGH || 0,
        priorityCounts.URGENT || 0
    ];
    
    window.priorityChart.data.datasets[0].data = data;
    window.priorityChart.update();
}

// Time tracking functions
function startTimer(taskId) {
    if (activeTimer) {
        showToast('Please stop the current timer before starting a new one', 'warning');
        return;
    }
    
    $.ajax({
        url: '/time-logs/start',
        method: 'POST',
        data: { taskId: taskId },
        success: function(response) {
            activeTimer = {
                logId: response.logId,
                taskId: taskId,
                startTime: new Date()
            };
            updateTimerDisplay();
            showToast('Timer started successfully', 'success');
        },
        error: function(xhr, status, error) {
            showToast('Failed to start timer: ' + error, 'error');
        }
    });
}

function stopTimer() {
    if (!activeTimer) {
        showToast('No active timer found', 'warning');
        return;
    }
    
    $.ajax({
        url: '/time-logs/' + activeTimer.logId + '/stop',
        method: 'POST',
        success: function(response) {
            showToast('Timer stopped successfully', 'success');
            activeTimer = null;
            updateTimerDisplay();
            loadDashboardData(); // Refresh stats
        },
        error: function(xhr, status, error) {
            showToast('Failed to stop timer: ' + error, 'error');
        }
    });
}

// Update timer display
function updateTimerDisplay() {
    if (!activeTimer) {
        $('#timerDisplay').text('00:00:00');
        $('#timerStatus').text('No active timer');
        return;
    }
    
    const now = new Date();
    const elapsed = Math.floor((now - activeTimer.startTime) / 1000);
    const hours = Math.floor(elapsed / 3600);
    const minutes = Math.floor((elapsed % 3600) / 60);
    const seconds = elapsed % 60;
    
    const display = `${hours.toString().padStart(2, '0')}:${minutes.toString().padStart(2, '0')}:${seconds.toString().padStart(2, '0')}`;
    $('#timerDisplay').text(display);
    $('#timerStatus').text('Timer running');
}

// Auto-save functionality
function setupAutoSave() {
    let autoSaveTimeout;
    
    $('.auto-save').on('input', function() {
        clearTimeout(autoSaveTimeout);
        const $input = $(this);
        
        autoSaveTimeout = setTimeout(function() {
            const data = {
                field: $input.attr('name'),
                value: $input.val(),
                id: $input.data('id')
            };
            
            if (data.id && data.field && data.value) {
                autoSaveField(data);
            }
        }, 1000);
    });
}

// Auto-save field
function autoSaveField(data) {
    $.ajax({
        url: '/api/auto-save',
        method: 'POST',
        data: data,
        success: function(response) {
            showToast('Changes saved automatically', 'info', 2000);
        },
        error: function(xhr, status, error) {
            console.error('Auto-save failed:', error);
        }
    });
}

// Utility functions
function debounce(func, wait) {
    let timeout;
    return function executedFunction(...args) {
        const later = () => {
            clearTimeout(timeout);
            func(...args);
        };
        clearTimeout(timeout);
        timeout = setTimeout(later, wait);
    };
}

function showLoading(show) {
    if (show) {
        $('body').addClass('loading');
        $('#loadingSpinner').show();
    } else {
        $('body').removeClass('loading');
        $('#loadingSpinner').hide();
    }
}

function showToast(message, type = 'info', duration = 3000) {
    // Remove existing toasts
    $('.toast-custom').remove();
    
    const toast = $(`
        <div class="toast-custom alert alert-${type} alert-dismissible fade show" 
             style="position: fixed; top: 20px; right: 20px; z-index: 9999; min-width: 300px;">
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            ${message}
        </div>
    `);
    
    $('body').append(toast);
    
    setTimeout(() => {
        toast.alert('close');
    }, duration);
}

function setupTooltips() {
    // Initialize Bootstrap tooltips
    const tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
    tooltipTriggerList.map(function (tooltipTriggerEl) {
        return new bootstrap.Tooltip(tooltipTriggerEl);
    });
}

function formatDate(date) {
    return new Date(date).toLocaleDateString('en-US', {
        year: 'numeric',
        month: 'short',
        day: 'numeric'
    });
}

function formatTime(minutes) {
    if (minutes < 60) {
        return `${minutes} min`;
    }
    const hours = Math.floor(minutes / 60);
    const mins = minutes % 60;
    return `${hours}h ${mins}m`;
}

function exportData(format = 'csv') {
    showLoading(true);
    
    $.ajax({
        url: '/api/export',
        method: 'GET',
        data: { format: format },
        success: function(data) {
            const blob = new Blob([data], { type: 'text/csv' });
            const url = window.URL.createObjectURL(blob);
            const a = document.createElement('a');
            a.href = url;
            a.download = `productivity-data-${new Date().toISOString().split('T')[0]}.csv`;
            document.body.appendChild(a);
            a.click();
            document.body.removeChild(a);
            window.URL.revokeObjectURL(url);
            showToast('Data exported successfully', 'success');
        },
        error: function(xhr, status, error) {
            showToast('Failed to export data: ' + error, 'error');
        },
        complete: function() {
            showLoading(false);
        }
    });
}

// Update timer every second if there's an active timer
setInterval(() => {
    if (activeTimer) {
        updateTimerDisplay();
    }
}, 1000);