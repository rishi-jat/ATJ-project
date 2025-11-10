package com.productivity.tracker.dao.impl;

import com.productivity.tracker.dao.TimeLogDAO;
import com.productivity.tracker.model.TimeLog;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.jdbc.support.KeyHolder;
import org.springframework.stereotype.Repository;

import java.sql.*;
import java.util.List;

@Repository
public class TimeLogDAOImpl implements TimeLogDAO {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    // Row mapper for TimeLog objects
    private RowMapper<TimeLog> timeLogRowMapper = (rs, rowNum) -> {
        TimeLog timeLog = new TimeLog();
        timeLog.setLogId(rs.getInt("log_id"));
        timeLog.setTaskId(rs.getInt("task_id"));
        timeLog.setUserId(rs.getInt("user_id"));
        timeLog.setStartTime(rs.getTimestamp("start_time"));
        timeLog.setEndTime(rs.getTimestamp("end_time"));
        timeLog.setDurationMinutes(rs.getInt("duration_minutes"));
        timeLog.setDescription(rs.getString("description"));
        timeLog.setCreatedAt(rs.getTimestamp("created_at"));
        
        // Task information if available
        try {
            timeLog.setTaskTitle(rs.getString("task_title"));
            timeLog.setCategoryName(rs.getString("category_name"));
        } catch (SQLException e) {
            // Task columns not present in this query
        }
        
        return timeLog;
    };

    @Override
    public int createTimeLog(TimeLog timeLog) {
        String sql = "INSERT INTO time_logs (task_id, user_id, start_time, end_time, description) " +
                     "VALUES (?, ?, ?, ?, ?)";
        
        KeyHolder keyHolder = new GeneratedKeyHolder();
        
        jdbcTemplate.update(connection -> {
            PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setInt(1, timeLog.getTaskId());
            ps.setInt(2, timeLog.getUserId());
            ps.setTimestamp(3, timeLog.getStartTime());
            ps.setTimestamp(4, timeLog.getEndTime());
            ps.setString(5, timeLog.getDescription());
            return ps;
        }, keyHolder);
        
        return keyHolder.getKey().intValue();
    }

    @Override
    public TimeLog getTimeLogById(int logId) {
        String sql = "SELECT tl.*, t.title as task_title, c.category_name " +
                     "FROM time_logs tl " +
                     "JOIN tasks t ON tl.task_id = t.task_id " +
                     "LEFT JOIN categories c ON t.category_id = c.category_id " +
                     "WHERE tl.log_id = ?";
        
        List<TimeLog> timeLogs = jdbcTemplate.query(sql, timeLogRowMapper, logId);
        return timeLogs.isEmpty() ? null : timeLogs.get(0);
    }

    @Override
    public List<TimeLog> getTimeLogsByUserId(int userId) {
        String sql = "SELECT tl.*, t.title as task_title, c.category_name " +
                     "FROM time_logs tl " +
                     "JOIN tasks t ON tl.task_id = t.task_id " +
                     "LEFT JOIN categories c ON t.category_id = c.category_id " +
                     "WHERE tl.user_id = ? ORDER BY tl.start_time DESC";
        
        return jdbcTemplate.query(sql, timeLogRowMapper, userId);
    }

    @Override
    public List<TimeLog> getTimeLogsByTaskId(int taskId) {
        String sql = "SELECT tl.*, t.title as task_title, c.category_name " +
                     "FROM time_logs tl " +
                     "JOIN tasks t ON tl.task_id = t.task_id " +
                     "LEFT JOIN categories c ON t.category_id = c.category_id " +
                     "WHERE tl.task_id = ? ORDER BY tl.start_time DESC";
        
        return jdbcTemplate.query(sql, timeLogRowMapper, taskId);
    }

    @Override
    public boolean updateTimeLog(TimeLog timeLog) {
        String sql = "UPDATE time_logs SET task_id = ?, start_time = ?, end_time = ?, " +
                     "description = ? WHERE log_id = ?";
        
        int rowsAffected = jdbcTemplate.update(sql,
            timeLog.getTaskId(), timeLog.getStartTime(), timeLog.getEndTime(),
            timeLog.getDescription(), timeLog.getLogId());
        
        return rowsAffected > 0;
    }

    @Override
    public boolean deleteTimeLog(int logId) {
        String sql = "DELETE FROM time_logs WHERE log_id = ?";
        int rowsAffected = jdbcTemplate.update(sql, logId);
        return rowsAffected > 0;
    }

    @Override
    public TimeLog getActiveTimeLog(int userId) {
        String sql = "SELECT tl.*, t.title as task_title, c.category_name " +
                     "FROM time_logs tl " +
                     "JOIN tasks t ON tl.task_id = t.task_id " +
                     "LEFT JOIN categories c ON t.category_id = c.category_id " +
                     "WHERE tl.user_id = ? AND tl.end_time IS NULL " +
                     "ORDER BY tl.start_time DESC LIMIT 1";
        
        List<TimeLog> timeLogs = jdbcTemplate.query(sql, timeLogRowMapper, userId);
        return timeLogs.isEmpty() ? null : timeLogs.get(0);
    }

    @Override
    public boolean stopTimeLog(int logId, Timestamp endTime) {
        String sql = "UPDATE time_logs SET end_time = ? WHERE log_id = ?";
        int rowsAffected = jdbcTemplate.update(sql, endTime, logId);
        return rowsAffected > 0;
    }

    @Override
    public List<TimeLog> getTimeLogsByDateRange(int userId, Date startDate, Date endDate) {
        String sql = "SELECT tl.*, t.title as task_title, c.category_name " +
                     "FROM time_logs tl " +
                     "JOIN tasks t ON tl.task_id = t.task_id " +
                     "LEFT JOIN categories c ON t.category_id = c.category_id " +
                     "WHERE tl.user_id = ? AND DATE(tl.start_time) BETWEEN ? AND ? " +
                     "ORDER BY tl.start_time DESC";
        
        return jdbcTemplate.query(sql, timeLogRowMapper, userId, startDate, endDate);
    }

    @Override
    public int getTotalTimeMinutesForTask(int taskId) {
        String sql = "SELECT COALESCE(SUM(duration_minutes), 0) FROM time_logs " +
                     "WHERE task_id = ? AND end_time IS NOT NULL";
        
        Integer total = jdbcTemplate.queryForObject(sql, Integer.class, taskId);
        return total != null ? total : 0;
    }

    @Override
    public int getTotalTimeMinutesForUser(int userId, Date date) {
        String sql = "SELECT COALESCE(SUM(duration_minutes), 0) FROM time_logs " +
                     "WHERE user_id = ? AND DATE(start_time) = ? AND end_time IS NOT NULL";
        
        Integer total = jdbcTemplate.queryForObject(sql, Integer.class, userId, date);
        return total != null ? total : 0;
    }

    @Override
    public int getTotalTimeMinutesForUserInRange(int userId, Date startDate, Date endDate) {
        String sql = "SELECT COALESCE(SUM(duration_minutes), 0) FROM time_logs " +
                     "WHERE user_id = ? AND DATE(start_time) BETWEEN ? AND ? AND end_time IS NOT NULL";
        
        Integer total = jdbcTemplate.queryForObject(sql, Integer.class, userId, startDate, endDate);
        return total != null ? total : 0;
    }

    @Override
    public List<TimeLog> getRecentTimeLogs(int userId, int limit) {
        String sql = "SELECT tl.*, t.title as task_title, c.category_name " +
                     "FROM time_logs tl " +
                     "JOIN tasks t ON tl.task_id = t.task_id " +
                     "LEFT JOIN categories c ON t.category_id = c.category_id " +
                     "WHERE tl.user_id = ? ORDER BY tl.start_time DESC LIMIT ?";
        
        return jdbcTemplate.query(sql, timeLogRowMapper, userId, limit);
    }
}