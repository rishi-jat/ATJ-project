package com.productivity.tracker.model;

import java.sql.Timestamp;

public class Category {
    private int categoryId;
    private int userId;
    private String categoryName;
    private String description;
    private String colorCode;
    private Timestamp createdAt;

    // Default constructor
    public Category() {}

    // Constructor with essential fields
    public Category(int userId, String categoryName, String description, String colorCode) {
        this.userId = userId;
        this.categoryName = categoryName;
        this.description = description;
        this.colorCode = colorCode;
    }

    // Getters and Setters
    public int getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(int categoryId) {
        this.categoryId = categoryId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getCategoryName() {
        return categoryName;
    }

    public void setCategoryName(String categoryName) {
        this.categoryName = categoryName;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getColorCode() {
        return colorCode;
    }

    public void setColorCode(String colorCode) {
        this.colorCode = colorCode;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    @Override
    public String toString() {
        return "Category{" +
                "categoryId=" + categoryId +
                ", userId=" + userId +
                ", categoryName='" + categoryName + '\'' +
                ", description='" + description + '\'' +
                ", colorCode='" + colorCode + '\'' +
                '}';
    }
}