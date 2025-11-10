package com.productivity.tracker.dao.impl;

import com.productivity.tracker.dao.TaskDAO;
import com.productivity.tracker.model.Task;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.jdbc.support.KeyHolder;
import org.springframework.stereotype.Repository;

import java.sql.*;
import java.util.List;

@Repository
public class TaskDAOImpl implements TaskDAO {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    // Row mapper for Task objects
    private RowMapper<Task> taskRowMapper = (rs, rowNum) -> {
        Task task = new Task();
        task.setTaskId(rs.getInt("task_id"));
        task.setUserId(rs.getInt("user_id"));
        task.setCategoryId(rs.getObject("category_id", Integer.class));
        task.setTitle(rs.getString("title"));
        task.setDescription(rs.getString("description"));
        task.setPriority(Task.Priority.valueOf(rs.getString("priority")));
        task.setStatus(Task.Status.valueOf(rs.getString("status")));
        task.setDueDate(rs.getDate("due_date"));
        task.setEstimatedHours(rs.getBigDecimal("estimated_hours"));
        task.setActualHours(rs.getBigDecimal("actual_hours"));
        task.setCreatedAt(rs.getTimestamp("created_at"));
        task.setUpdatedAt(rs.getTimestamp("updated_at"));
        task.setCompletedAt(rs.getTimestamp("completed_at"));
        
        // Category information if available
        try {
            task.setCategoryName(rs.getString("category_name"));
            task.setCategoryColor(rs.getString("color_code"));
        } catch (SQLException e) {
            // Category columns not present in this query
        }
        
        return task;
    };

    @Override
    public int createTask(Task task) {
        String sql = "INSERT INTO tasks (user_id, category_id, title, description, priority, status, " +
                     "due_date, estimated_hours) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        
        KeyHolder keyHolder = new GeneratedKeyHolder();
        
        jdbcTemplate.update(connection -> {
            PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setInt(1, task.getUserId());
            ps.setObject(2, task.getCategoryId());
            ps.setString(3, task.getTitle());
            ps.setString(4, task.getDescription());
            ps.setString(5, task.getPriority().name());
            ps.setString(6, task.getStatus().name());
            ps.setDate(7, task.getDueDate());
            ps.setBigDecimal(8, task.getEstimatedHours());
            return ps;
        }, keyHolder);
        
        return keyHolder.getKey().intValue();
    }

    @Override
    public Task getTaskById(int taskId) {
        String sql = "SELECT t.*, c.category_name, c.color_code " +
                     "FROM tasks t LEFT JOIN categories c ON t.category_id = c.category_id " +
                     "WHERE t.task_id = ?";
        
        List<Task> tasks = jdbcTemplate.query(sql, taskRowMapper, taskId);
        return tasks.isEmpty() ? null : tasks.get(0);
    }

    @Override
    public List<Task> getTasksByUserId(int userId) {
        String sql = "SELECT t.*, c.category_name, c.color_code " +
                     "FROM tasks t LEFT JOIN categories c ON t.category_id = c.category_id " +
                     "WHERE t.user_id = ? ORDER BY t.created_at DESC";
        
        return jdbcTemplate.query(sql, taskRowMapper, userId);
    }

    @Override
    public boolean updateTask(Task task) {
        String sql = "UPDATE tasks SET category_id = ?, title = ?, description = ?, " +
                     "priority = ?, status = ?, due_date = ?, estimated_hours = ?, actual_hours = ?, " +
                     "completed_at = ?, updated_at = CURRENT_TIMESTAMP WHERE task_id = ?";
        
        int rowsAffected = jdbcTemplate.update(sql,
            task.getCategoryId(), task.getTitle(), task.getDescription(),
            task.getPriority().name(), task.getStatus().name(), task.getDueDate(),
            task.getEstimatedHours(), task.getActualHours(), task.getCompletedAt(),
            task.getTaskId());
        
        return rowsAffected > 0;
    }

    @Override
    public boolean deleteTask(int taskId) {
        String sql = "DELETE FROM tasks WHERE task_id = ?";
        int rowsAffected = jdbcTemplate.update(sql, taskId);
        return rowsAffected > 0;
    }

    @Override
    public List<Task> getTasksByStatus(int userId, Task.Status status) {
        String sql = "SELECT t.*, c.category_name, c.color_code " +
                     "FROM tasks t LEFT JOIN categories c ON t.category_id = c.category_id " +
                     "WHERE t.user_id = ? AND t.status = ? ORDER BY t.priority DESC, t.due_date ASC";
        
        return jdbcTemplate.query(sql, taskRowMapper, userId, status.name());
    }

    @Override
    public List<Task> getTasksByPriority(int userId, Task.Priority priority) {
        String sql = "SELECT t.*, c.category_name, c.color_code " +
                     "FROM tasks t LEFT JOIN categories c ON t.category_id = c.category_id " +
                     "WHERE t.user_id = ? AND t.priority = ? ORDER BY t.due_date ASC";
        
        return jdbcTemplate.query(sql, taskRowMapper, userId, priority.name());
    }

    @Override
    public List<Task> getTasksByCategory(int userId, int categoryId) {
        String sql = "SELECT t.*, c.category_name, c.color_code " +
                     "FROM tasks t LEFT JOIN categories c ON t.category_id = c.category_id " +
                     "WHERE t.user_id = ? AND t.category_id = ? ORDER BY t.created_at DESC";
        
        return jdbcTemplate.query(sql, taskRowMapper, userId, categoryId);
    }

    @Override
    public List<Task> getTasksByDateRange(int userId, Date startDate, Date endDate) {
        String sql = "SELECT t.*, c.category_name, c.color_code " +
                     "FROM tasks t LEFT JOIN categories c ON t.category_id = c.category_id " +
                     "WHERE t.user_id = ? AND t.due_date BETWEEN ? AND ? ORDER BY t.due_date ASC";
        
        return jdbcTemplate.query(sql, taskRowMapper, userId, startDate, endDate);
    }

    @Override
    public List<Task> getOverdueTasks(int userId) {
        String sql = "SELECT t.*, c.category_name, c.color_code " +
                     "FROM tasks t LEFT JOIN categories c ON t.category_id = c.category_id " +
                     "WHERE t.user_id = ? AND t.due_date < CURDATE() AND t.status != 'COMPLETED' " +
                     "ORDER BY t.due_date ASC";
        
        return jdbcTemplate.query(sql, taskRowMapper, userId);
    }

    @Override
    public int getTaskCountByStatus(int userId, Task.Status status) {
        String sql = "SELECT COUNT(*) FROM tasks WHERE user_id = ? AND status = ?";
        return jdbcTemplate.queryForObject(sql, Integer.class, userId, status.name());
    }

    @Override
    public int getTotalTaskCount(int userId) {
        String sql = "SELECT COUNT(*) FROM tasks WHERE user_id = ?";
        return jdbcTemplate.queryForObject(sql, Integer.class, userId);
    }

    @Override
    public List<Task> searchTasks(int userId, String keyword) {
        String sql = "SELECT t.*, c.category_name, c.color_code " +
                     "FROM tasks t LEFT JOIN categories c ON t.category_id = c.category_id " +
                     "WHERE t.user_id = ? AND (t.title LIKE ? OR t.description LIKE ?) " +
                     "ORDER BY t.created_at DESC";
        
        String searchPattern = "%" + keyword + "%";
        return jdbcTemplate.query(sql, taskRowMapper, userId, searchPattern, searchPattern);
    }
}