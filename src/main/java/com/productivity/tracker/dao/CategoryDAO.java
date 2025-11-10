package com.productivity.tracker.dao;

import com.productivity.tracker.model.Category;
import java.util.List;

public interface CategoryDAO {
    
    // Basic CRUD operations
    int createCategory(Category category);
    Category getCategoryById(int categoryId);
    List<Category> getCategoriesByUserId(int userId);
    boolean updateCategory(Category category);
    boolean deleteCategory(int categoryId);
    
    // Check if category name exists for user
    boolean categoryNameExists(int userId, String categoryName);
    
    // Get category with task count
    List<Category> getCategoriesWithTaskCount(int userId);
}