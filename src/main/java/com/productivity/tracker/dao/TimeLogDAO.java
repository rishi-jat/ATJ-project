package com.productivity.tracker.dao;

import com.productivity.tracker.model.TimeLog;
import java.sql.Date;
import java.sql.Timestamp;
import java.util.List;

public interface TimeLogDAO {
    
    // Basic CRUD operations
    int createTimeLog(TimeLog timeLog);
    TimeLog getTimeLogById(int logId);
    List<TimeLog> getTimeLogsByUserId(int userId);
    List<TimeLog> getTimeLogsByTaskId(int taskId);
    boolean updateTimeLog(TimeLog timeLog);
    boolean deleteTimeLog(int logId);
    
    // Time tracking specific operations
    TimeLog getActiveTimeLog(int userId);
    boolean stopTimeLog(int logId, Timestamp endTime);
    List<TimeLog> getTimeLogsByDateRange(int userId, Date startDate, Date endDate);
    
    // Analytics
    int getTotalTimeMinutesForTask(int taskId);
    int getTotalTimeMinutesForUser(int userId, Date date);
    int getTotalTimeMinutesForUserInRange(int userId, Date startDate, Date endDate);
    
    // Recent activity
    List<TimeLog> getRecentTimeLogs(int userId, int limit);
}