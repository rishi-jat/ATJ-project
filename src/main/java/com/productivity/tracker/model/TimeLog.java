package com.productivity.tracker.model;

import java.sql.Timestamp;

public class TimeLog {
    private int logId;
    private int taskId;
    private int userId;
    private Timestamp startTime;
    private Timestamp endTime;
    private int durationMinutes;
    private String description;
    private Timestamp createdAt;
    
    // Task information for display
    private String taskTitle;
    private String categoryName;

    // Default constructor
    public TimeLog() {}

    // Constructor for starting a time log
    public TimeLog(int taskId, int userId, Timestamp startTime, String description) {
        this.taskId = taskId;
        this.userId = userId;
        this.startTime = startTime;
        this.description = description;
    }

    // Getters and Setters
    public int getLogId() {
        return logId;
    }

    public void setLogId(int logId) {
        this.logId = logId;
    }

    public int getTaskId() {
        return taskId;
    }

    public void setTaskId(int taskId) {
        this.taskId = taskId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public Timestamp getStartTime() {
        return startTime;
    }

    public void setStartTime(Timestamp startTime) {
        this.startTime = startTime;
    }

    public Timestamp getEndTime() {
        return endTime;
    }

    public void setEndTime(Timestamp endTime) {
        this.endTime = endTime;
    }

    public int getDurationMinutes() {
        return durationMinutes;
    }

    public void setDurationMinutes(int durationMinutes) {
        this.durationMinutes = durationMinutes;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public String getTaskTitle() {
        return taskTitle;
    }

    public void setTaskTitle(String taskTitle) {
        this.taskTitle = taskTitle;
    }

    public String getCategoryName() {
        return categoryName;
    }

    public void setCategoryName(String categoryName) {
        this.categoryName = categoryName;
    }

    // Helper methods
    public boolean isActive() {
        return endTime == null;
    }

    public String getFormattedDuration() {
        if (durationMinutes < 60) {
            return durationMinutes + " min";
        } else {
            int hours = durationMinutes / 60;
            int mins = durationMinutes % 60;
            return hours + "h " + mins + "m";
        }
    }

    public double getDurationHours() {
        return durationMinutes / 60.0;
    }

    @Override
    public String toString() {
        return "TimeLog{" +
                "logId=" + logId +
                ", taskId=" + taskId +
                ", userId=" + userId +
                ", startTime=" + startTime +
                ", endTime=" + endTime +
                ", durationMinutes=" + durationMinutes +
                '}';
    }
}