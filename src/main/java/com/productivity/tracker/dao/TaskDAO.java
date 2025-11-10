package com.productivity.tracker.dao;

import com.productivity.tracker.model.Task;
import java.sql.Date;
import java.util.List;

public interface TaskDAO {
    
    // Basic CRUD operations
    int createTask(Task task);
    Task getTaskById(int taskId);
    List<Task> getTasksByUserId(int userId);
    boolean updateTask(Task task);
    boolean deleteTask(int taskId);
    
    // Filter operations
    List<Task> getTasksByStatus(int userId, Task.Status status);
    List<Task> getTasksByPriority(int userId, Task.Priority priority);
    List<Task> getTasksByCategory(int userId, int categoryId);
    List<Task> getTasksByDateRange(int userId, Date startDate, Date endDate);
    List<Task> getOverdueTasks(int userId);
    
    // Statistics
    int getTaskCountByStatus(int userId, Task.Status status);
    int getTotalTaskCount(int userId);
    
    // Search functionality
    List<Task> searchTasks(int userId, String keyword);
}