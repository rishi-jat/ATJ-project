package com.productivity.tracker.model;

import java.math.BigDecimal;
import java.sql.Date;
import java.sql.Timestamp;

public class Task {
    private int taskId;
    private int userId;
    private Integer categoryId; // Nullable
    private String title;
    private String description;
    private Priority priority;
    private Status status;
    private Date dueDate;
    private BigDecimal estimatedHours;
    private BigDecimal actualHours;
    private Timestamp createdAt;
    private Timestamp updatedAt;
    private Timestamp completedAt;
    
    // Category information for display
    private String categoryName;
    private String categoryColor;

    // Enums for priority and status
    public enum Priority {
        LOW, MEDIUM, HIGH, URGENT
    }

    public enum Status {
        PENDING, IN_PROGRESS, COMPLETED, CANCELLED
    }

    // Default constructor
    public Task() {
        this.priority = Priority.MEDIUM;
        this.status = Status.PENDING;
        this.estimatedHours = BigDecimal.ZERO;
        this.actualHours = BigDecimal.ZERO;
    }

    // Constructor with essential fields
    public Task(int userId, String title, String description, Priority priority) {
        this();
        this.userId = userId;
        this.title = title;
        this.description = description;
        this.priority = priority;
    }

    // Getters and Setters
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

    public Integer getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(Integer categoryId) {
        this.categoryId = categoryId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Priority getPriority() {
        return priority;
    }

    public void setPriority(Priority priority) {
        this.priority = priority;
    }

    public Status getStatus() {
        return status;
    }

    public void setStatus(Status status) {
        this.status = status;
    }

    public Date getDueDate() {
        return dueDate;
    }

    public void setDueDate(Date dueDate) {
        this.dueDate = dueDate;
    }

    public BigDecimal getEstimatedHours() {
        return estimatedHours;
    }

    public void setEstimatedHours(BigDecimal estimatedHours) {
        this.estimatedHours = estimatedHours;
    }

    public BigDecimal getActualHours() {
        return actualHours;
    }

    public void setActualHours(BigDecimal actualHours) {
        this.actualHours = actualHours;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Timestamp getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }

    public Timestamp getCompletedAt() {
        return completedAt;
    }

    public void setCompletedAt(Timestamp completedAt) {
        this.completedAt = completedAt;
    }

    public String getCategoryName() {
        return categoryName;
    }

    public void setCategoryName(String categoryName) {
        this.categoryName = categoryName;
    }

    public String getCategoryColor() {
        return categoryColor;
    }

    public void setCategoryColor(String categoryColor) {
        this.categoryColor = categoryColor;
    }

    // Helper methods
    public boolean isOverdue() {
        if (dueDate == null || status == Status.COMPLETED) {
            return false;
        }
        return dueDate.before(new Date(System.currentTimeMillis()));
    }

    public String getPriorityStyle() {
        switch (priority) {
            case URGENT: return "badge-danger";
            case HIGH: return "badge-warning";
            case MEDIUM: return "badge-info";
            case LOW: return "badge-secondary";
            default: return "badge-secondary";
        }
    }

    public String getStatusStyle() {
        switch (status) {
            case COMPLETED: return "badge-success";
            case IN_PROGRESS: return "badge-primary";
            case CANCELLED: return "badge-dark";
            case PENDING: return "badge-light";
            default: return "badge-light";
        }
    }

    @Override
    public String toString() {
        return "Task{" +
                "taskId=" + taskId +
                ", userId=" + userId +
                ", categoryId=" + categoryId +
                ", title='" + title + '\'' +
                ", priority=" + priority +
                ", status=" + status +
                ", dueDate=" + dueDate +
                '}';
    }
}