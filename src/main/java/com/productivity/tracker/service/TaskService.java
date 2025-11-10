package com.productivity.tracker.service;

import com.productivity.tracker.model.Task;
import java.sql.Date;
import java.util.List;
import java.util.Map;

public interface TaskService {
    
    // Basic operations
    Task createTask(Task task);
    Task getTaskById(int taskId);
    List<Task> getTasksByUserId(int userId);
    Task updateTask(Task task);
    boolean deleteTask(int taskId);
    
    // Status management
    Task updateTaskStatus(int taskId, Task.Status status);
    List<Task> getTasksByStatus(int userId, Task.Status status);
    
    // Filter and search
    List<Task> getTasksByPriority(int userId, Task.Priority priority);
    List<Task> getTasksByCategory(int userId, int categoryId);
    List<Task> getOverdueTasks(int userId);
    List<Task> searchTasks(int userId, String keyword);
    
    // Analytics
    Map<String, Integer> getTaskCountsByStatus(int userId);
    Map<String, Integer> getTaskCountsByPriority(int userId);
    int getTotalTaskCount(int userId);
    
    // Dashboard data
    List<Task> getUpcomingTasks(int userId, int limit);
    List<Task> getRecentTasks(int userId, int limit);
}