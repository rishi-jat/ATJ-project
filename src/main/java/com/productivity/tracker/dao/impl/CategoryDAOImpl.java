package com.productivity.tracker.dao.impl;

import com.productivity.tracker.dao.CategoryDAO;
import com.productivity.tracker.model.Category;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.jdbc.support.KeyHolder;
import org.springframework.stereotype.Repository;

import java.sql.PreparedStatement;
import java.sql.Statement;
import java.util.List;

@Repository
public class CategoryDAOImpl implements CategoryDAO {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    // Row mapper for Category objects
    private RowMapper<Category> categoryRowMapper = (rs, rowNum) -> {
        Category category = new Category();
        category.setCategoryId(rs.getInt("category_id"));
        category.setUserId(rs.getInt("user_id"));
        category.setCategoryName(rs.getString("category_name"));
        category.setDescription(rs.getString("description"));
        category.setColorCode(rs.getString("color_code"));
        category.setCreatedAt(rs.getTimestamp("created_at"));
        return category;
    };

    @Override
    public int createCategory(Category category) {
        String sql = "INSERT INTO categories (user_id, category_name, description, color_code) " +
                     "VALUES (?, ?, ?, ?)";
        
        KeyHolder keyHolder = new GeneratedKeyHolder();
        
        jdbcTemplate.update(connection -> {
            PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setInt(1, category.getUserId());
            ps.setString(2, category.getCategoryName());
            ps.setString(3, category.getDescription());
            ps.setString(4, category.getColorCode());
            return ps;
        }, keyHolder);
        
        return keyHolder.getKey().intValue();
    }

    @Override
    public Category getCategoryById(int categoryId) {
        String sql = "SELECT * FROM categories WHERE category_id = ?";
        List<Category> categories = jdbcTemplate.query(sql, categoryRowMapper, categoryId);
        return categories.isEmpty() ? null : categories.get(0);
    }

    @Override
    public List<Category> getCategoriesByUserId(int userId) {
        String sql = "SELECT * FROM categories WHERE user_id = ? ORDER BY category_name";
        return jdbcTemplate.query(sql, categoryRowMapper, userId);
    }

    @Override
    public boolean updateCategory(Category category) {
        String sql = "UPDATE categories SET category_name = ?, description = ?, color_code = ? " +
                     "WHERE category_id = ?";
        
        int rowsAffected = jdbcTemplate.update(sql,
            category.getCategoryName(), category.getDescription(), category.getColorCode(),
            category.getCategoryId());
        
        return rowsAffected > 0;
    }

    @Override
    public boolean deleteCategory(int categoryId) {
        String sql = "DELETE FROM categories WHERE category_id = ?";
        int rowsAffected = jdbcTemplate.update(sql, categoryId);
        return rowsAffected > 0;
    }

    @Override
    public boolean categoryNameExists(int userId, String categoryName) {
        String sql = "SELECT COUNT(*) FROM categories WHERE user_id = ? AND category_name = ?";
        Integer count = jdbcTemplate.queryForObject(sql, Integer.class, userId, categoryName);
        return count != null && count > 0;
    }

    @Override
    public List<Category> getCategoriesWithTaskCount(int userId) {
        String sql = "SELECT c.*, COUNT(t.task_id) as task_count " +
                     "FROM categories c LEFT JOIN tasks t ON c.category_id = t.category_id " +
                     "WHERE c.user_id = ? GROUP BY c.category_id ORDER BY c.category_name";
        
        return jdbcTemplate.query(sql, (rs, rowNum) -> {
            Category category = new Category();
            category.setCategoryId(rs.getInt("category_id"));
            category.setUserId(rs.getInt("user_id"));
            category.setCategoryName(rs.getString("category_name"));
            category.setDescription(rs.getString("description"));
            category.setColorCode(rs.getString("color_code"));
            category.setCreatedAt(rs.getTimestamp("created_at"));
            // Note: task_count would need to be added as a field if needed for display
            return category;
        }, userId);
    }
}