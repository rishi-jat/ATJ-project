package com.productivity.tracker.controller;

import com.productivity.tracker.model.Task;
import com.productivity.tracker.service.TaskService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/")
public class DashboardController {

    @Autowired
    private TaskService taskService;

        @RequestMapping(value = "/", method = RequestMethod.GET)
    public String dashboard(Model model) {
        // For demo purposes, using user ID 2 (matching the default user in database)
        int userId = 2;
        
        // Get dashboard data
        List<Task> recentTasks = taskService.getRecentTasks(userId, 5);
        List<Task> upcomingTasks = taskService.getUpcomingTasks(userId, 5);
        List<Task> overdueTasks = taskService.getOverdueTasks(userId);
        Map<String, Integer> statusCounts = taskService.getTaskCountsByStatus(userId);
        Map<String, Integer> priorityCounts = taskService.getTaskCountsByPriority(userId);
        
        // Add data to model
        model.addAttribute("recentTasks", recentTasks);
        model.addAttribute("upcomingTasks", upcomingTasks);
        model.addAttribute("overdueTasks", overdueTasks);
        model.addAttribute("statusCounts", statusCounts);
        model.addAttribute("priorityCounts", priorityCounts);
        model.addAttribute("totalTasks", taskService.getTotalTaskCount(userId));
        
        return "dashboard";
    }

    @RequestMapping(value = "/dashboard/stats", method = RequestMethod.GET)
    @ResponseBody
    public ResponseEntity<Map<String, Object>> getDashboardStats() {
        // For demo purposes, using user ID 2 (matching the default user in database)
        int userId = 2;
        
        Map<String, Integer> statusCounts = taskService.getTaskCountsByStatus(userId);
        Map<String, Integer> priorityCounts = taskService.getTaskCountsByPriority(userId);
        
        Map<String, Object> stats = Map.of(
            "statusCounts", statusCounts,
            "priorityCounts", priorityCounts,
            "totalTasks", taskService.getTotalTaskCount(userId)
        );
        
        return ResponseEntity.ok(stats);
    }
}