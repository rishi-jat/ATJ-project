package com.productivity.tracker.model;

import java.math.BigDecimal;
import java.sql.Date;
import java.sql.Timestamp;

public class DailySummary {
    private int summaryId;
    private int userId;
    private Date summaryDate;
    private int totalTasksCreated;
    private int totalTasksCompleted;
    private int totalTimeMinutes;
    private BigDecimal productivityScore;
    private String notes;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    // Default constructor
    public DailySummary() {
        this.productivityScore = BigDecimal.ZERO;
    }

    // Constructor with essential fields
    public DailySummary(int userId, Date summaryDate) {
        this();
        this.userId = userId;
        this.summaryDate = summaryDate;
    }

    // Getters and Setters
    public int getSummaryId() {
        return summaryId;
    }

    public void setSummaryId(int summaryId) {
        this.summaryId = summaryId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public Date getSummaryDate() {
        return summaryDate;
    }

    public void setSummaryDate(Date summaryDate) {
        this.summaryDate = summaryDate;
    }

    public int getTotalTasksCreated() {
        return totalTasksCreated;
    }

    public void setTotalTasksCreated(int totalTasksCreated) {
        this.totalTasksCreated = totalTasksCreated;
    }

    public int getTotalTasksCompleted() {
        return totalTasksCompleted;
    }

    public void setTotalTasksCompleted(int totalTasksCompleted) {
        this.totalTasksCompleted = totalTasksCompleted;
    }

    public int getTotalTimeMinutes() {
        return totalTimeMinutes;
    }

    public void setTotalTimeMinutes(int totalTimeMinutes) {
        this.totalTimeMinutes = totalTimeMinutes;
    }

    public BigDecimal getProductivityScore() {
        return productivityScore;
    }

    public void setProductivityScore(BigDecimal productivityScore) {
        this.productivityScore = productivityScore;
    }

    public String getNotes() {
        return notes;
    }

    public void setNotes(String notes) {
        this.notes = notes;
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

    // Helper methods
    public String getFormattedTotalTime() {
        if (totalTimeMinutes < 60) {
            return totalTimeMinutes + " min";
        } else {
            int hours = totalTimeMinutes / 60;
            int mins = totalTimeMinutes % 60;
            return hours + "h " + mins + "m";
        }
    }

    public double getTotalHours() {
        return totalTimeMinutes / 60.0;
    }

    public double getCompletionRate() {
        if (totalTasksCreated == 0) return 0.0;
        return (double) totalTasksCompleted / totalTasksCreated * 100;
    }

    @Override
    public String toString() {
        return "DailySummary{" +
                "summaryId=" + summaryId +
                ", userId=" + userId +
                ", summaryDate=" + summaryDate +
                ", totalTasksCreated=" + totalTasksCreated +
                ", totalTasksCompleted=" + totalTasksCompleted +
                ", totalTimeMinutes=" + totalTimeMinutes +
                ", productivityScore=" + productivityScore +
                '}';
    }
}