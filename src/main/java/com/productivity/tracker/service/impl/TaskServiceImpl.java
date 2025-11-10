package com.productivity.tracker.service.impl;

import com.productivity.tracker.dao.TaskDAO;
import com.productivity.tracker.model.Task;
import com.productivity.tracker.service.TaskService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.sql.Timestamp;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
@Transactional
public class TaskServiceImpl implements TaskService {

    @Autowired
    private TaskDAO taskDAO;

    @Override
    public Task createTask(Task task) {
        int taskId = taskDAO.createTask(task);
        task.setTaskId(taskId);
        return task;
    }

    @Override
    public Task getTaskById(int taskId) {
        return taskDAO.getTaskById(taskId);
    }

    @Override
    public List<Task> getTasksByUserId(int userId) {
        return taskDAO.getTasksByUserId(userId);
    }

    @Override
    public Task updateTask(Task task) {
        // If task is being marked as completed, set completed timestamp
        if (task.getStatus() == Task.Status.COMPLETED && task.getCompletedAt() == null) {
            task.setCompletedAt(new Timestamp(System.currentTimeMillis()));
        }
        
        boolean updated = taskDAO.updateTask(task);
        return updated ? task : null;
    }

    @Override
    public boolean deleteTask(int taskId) {
        return taskDAO.deleteTask(taskId);
    }

    @Override
    public Task updateTaskStatus(int taskId, Task.Status status) {
        Task task = taskDAO.getTaskById(taskId);
        if (task != null) {
            task.setStatus(status);
            if (status == Task.Status.COMPLETED) {
                task.setCompletedAt(new Timestamp(System.currentTimeMillis()));
            }
            taskDAO.updateTask(task);
        }
        return task;
    }

    @Override
    public List<Task> getTasksByStatus(int userId, Task.Status status) {
        return taskDAO.getTasksByStatus(userId, status);
    }

    @Override
    public List<Task> getTasksByPriority(int userId, Task.Priority priority) {
        return taskDAO.getTasksByPriority(userId, priority);
    }

    @Override
    public List<Task> getTasksByCategory(int userId, int categoryId) {
        return taskDAO.getTasksByCategory(userId, categoryId);
    }

    @Override
    public List<Task> getOverdueTasks(int userId) {
        return taskDAO.getOverdueTasks(userId);
    }

    @Override
    public List<Task> searchTasks(int userId, String keyword) {
        return taskDAO.searchTasks(userId, keyword);
    }

    @Override
    public Map<String, Integer> getTaskCountsByStatus(int userId) {
        Map<String, Integer> statusCounts = new HashMap<>();
        
        for (Task.Status status : Task.Status.values()) {
            int count = taskDAO.getTaskCountByStatus(userId, status);
            statusCounts.put(status.name(), count);
        }
        
        return statusCounts;
    }

    @Override
    public Map<String, Integer> getTaskCountsByPriority(int userId) {
        Map<String, Integer> priorityCounts = new HashMap<>();
        List<Task> allTasks = taskDAO.getTasksByUserId(userId);
        
        // Initialize counts
        for (Task.Priority priority : Task.Priority.values()) {
            priorityCounts.put(priority.name(), 0);
        }
        
        // Count tasks by priority
        for (Task task : allTasks) {
            String priority = task.getPriority().name();
            priorityCounts.put(priority, priorityCounts.get(priority) + 1);
        }
        
        return priorityCounts;
    }

    @Override
    public int getTotalTaskCount(int userId) {
        return taskDAO.getTotalTaskCount(userId);
    }

    @Override
    public List<Task> getUpcomingTasks(int userId, int limit) {
        List<Task> pendingTasks = taskDAO.getTasksByStatus(userId, Task.Status.PENDING);
        List<Task> inProgressTasks = taskDAO.getTasksByStatus(userId, Task.Status.IN_PROGRESS);
        
        // Combine and limit results (this could be optimized with a specific DAO method)
        pendingTasks.addAll(inProgressTasks);
        return pendingTasks.size() > limit ? pendingTasks.subList(0, limit) : pendingTasks;
    }

    @Override
    public List<Task> getRecentTasks(int userId, int limit) {
        List<Task> allTasks = taskDAO.getTasksByUserId(userId);
        return allTasks.size() > limit ? allTasks.subList(0, limit) : allTasks;
    }
}