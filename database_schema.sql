-- Personal Productivity Tracker Database Schema
-- MySQL Database: productivity_tracker

CREATE DATABASE IF NOT EXISTS productivity_tracker;
USE productivity_tracker;

-- Users table
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE
);

-- Categories table for task categorization
CREATE TABLE categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    category_name VARCHAR(100) NOT NULL,
    description TEXT,
    color_code VARCHAR(7) DEFAULT '#007bff', -- Hex color code
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    UNIQUE KEY unique_user_category (user_id, category_name)
);

-- Tasks table
CREATE TABLE tasks (
    task_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    category_id INT,
    title VARCHAR(200) NOT NULL,
    description TEXT,
    priority ENUM('LOW', 'MEDIUM', 'HIGH', 'URGENT') DEFAULT 'MEDIUM',
    status ENUM('PENDING', 'IN_PROGRESS', 'COMPLETED', 'CANCELLED') DEFAULT 'PENDING',
    due_date DATE,
    estimated_hours DECIMAL(5,2) DEFAULT 0,
    actual_hours DECIMAL(5,2) DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    completed_at TIMESTAMP NULL,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (category_id) REFERENCES categories(category_id) ON DELETE SET NULL,
    INDEX idx_user_status (user_id, status),
    INDEX idx_due_date (due_date),
    INDEX idx_priority (priority)
);

-- Time logs table for tracking work sessions
CREATE TABLE time_logs (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    task_id INT NOT NULL,
    user_id INT NOT NULL,
    start_time TIMESTAMP NOT NULL,
    end_time TIMESTAMP,
    duration_minutes INT DEFAULT 0,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (task_id) REFERENCES tasks(task_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    INDEX idx_user_date (user_id, start_time),
    INDEX idx_task_time (task_id, start_time)
);

-- Daily productivity summary table
CREATE TABLE daily_summary (
    summary_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    summary_date DATE NOT NULL,
    total_tasks_created INT DEFAULT 0,
    total_tasks_completed INT DEFAULT 0,
    total_time_minutes INT DEFAULT 0,
    productivity_score DECIMAL(5,2) DEFAULT 0, -- 0-100 score
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    UNIQUE KEY unique_user_date (user_id, summary_date)
);

-- Goals table for setting productivity goals
CREATE TABLE goals (
    goal_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    title VARCHAR(200) NOT NULL,
    description TEXT,
    target_type ENUM('DAILY_HOURS', 'WEEKLY_TASKS', 'MONTHLY_GOALS') NOT NULL,
    target_value DECIMAL(10,2) NOT NULL,
    current_value DECIMAL(10,2) DEFAULT 0,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    status ENUM('ACTIVE', 'COMPLETED', 'PAUSED', 'CANCELLED') DEFAULT 'ACTIVE',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- Insert default data
INSERT INTO users (username, email, password_hash, first_name, last_name) 
VALUES ('demo_user', 'demo@productivity.com', 'hashed_password_here', 'Demo', 'User');

SET @demo_user_id = LAST_INSERT_ID();

-- Insert default categories
INSERT INTO categories (user_id, category_name, description, color_code) VALUES
(@demo_user_id, 'Work', 'Professional tasks and projects', '#007bff'),
(@demo_user_id, 'Personal', 'Personal tasks and activities', '#28a745'),
(@demo_user_id, 'Learning', 'Educational activities and skill development', '#ffc107'),
(@demo_user_id, 'Health', 'Exercise, diet, and wellness activities', '#dc3545'),
(@demo_user_id, 'Hobbies', 'Fun activities and personal interests', '#6f42c1');

-- Insert sample tasks
INSERT INTO tasks (user_id, category_id, title, description, priority, status, due_date, estimated_hours) VALUES
(@demo_user_id, (SELECT category_id FROM categories WHERE category_name = 'Work' AND user_id = @demo_user_id), 
 'Complete Project Report', 'Finalize the quarterly project report for management review', 'HIGH', 'IN_PROGRESS', '2025-11-15', 4.0),
(@demo_user_id, (SELECT category_id FROM categories WHERE category_name = 'Learning' AND user_id = @demo_user_id), 
 'Study Spring Boot Tutorial', 'Complete online tutorial on Spring Boot framework', 'MEDIUM', 'PENDING', '2025-11-20', 3.0),
(@demo_user_id, (SELECT category_id FROM categories WHERE category_name = 'Personal' AND user_id = @demo_user_id), 
 'Plan Weekend Trip', 'Research and book weekend getaway destination', 'LOW', 'PENDING', '2025-11-18', 2.0);

-- Insert sample goals
INSERT INTO goals (user_id, title, description, target_type, target_value, start_date, end_date) VALUES
(@demo_user_id, 'Daily Productivity', 'Work at least 6 hours per day', 'DAILY_HOURS', 6.0, '2025-11-01', '2025-11-30'),
(@demo_user_id, 'Weekly Task Completion', 'Complete at least 10 tasks per week', 'WEEKLY_TASKS', 10.0, '2025-11-04', '2025-12-02');