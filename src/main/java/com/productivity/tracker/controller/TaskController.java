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
public class TaskController {

    @Autowired
    private TaskService taskService;

    @RequestMapping(value = "/tasks", method = RequestMethod.GET)
    public String listTasks(Model model, 
                           @RequestParam(required = false) String status,
                           @RequestParam(required = false) String priority,
                           @RequestParam(required = false) String search) {
        // For demo purposes, using user ID 1
        int userId = 1;
        List<Task> tasks;
        
        // Apply filters
        if (status != null && !status.isEmpty()) {
            tasks = taskService.getTasksByStatus(userId, Task.Status.valueOf(status));
        } else if (priority != null && !priority.isEmpty()) {
            tasks = taskService.getTasksByPriority(userId, Task.Priority.valueOf(priority));
        } else if (search != null && !search.isEmpty()) {
            tasks = taskService.searchTasks(userId, search);
        } else {
            tasks = taskService.getTasksByUserId(userId);
        }
        
        model.addAttribute("tasks", tasks);
        model.addAttribute("currentStatus", status);
        model.addAttribute("currentPriority", priority);
        model.addAttribute("currentSearch", search);
        
        return "tasks/list";
    }

    // API Endpoints for AJAX
    @ResponseBody
    @RequestMapping(value = "/api/tasks", method = RequestMethod.POST)
    public ResponseEntity<Task> createTask(@RequestBody Map<String, Object> taskData) {
        Task task = new Task();
        task.setUserId(2); // Use the existing default user ID
        task.setTitle((String) taskData.get("title"));
        task.setDescription((String) taskData.get("description"));
        task.setPriority(Task.Priority.valueOf((String) taskData.get("priority")));
        task.setStatus(Task.Status.valueOf((String) taskData.get("status")));
        
        Task createdTask = taskService.createTask(task);
        return ResponseEntity.ok(createdTask);
    }

    @ResponseBody
    @RequestMapping(value = "/api/tasks/{id}", method = RequestMethod.PUT)
    public ResponseEntity<Task> updateTask(@PathVariable int id, @RequestBody Map<String, Object> taskData) {
        Task task = taskService.getTaskById(id);
        if (task != null) {
            if (taskData.containsKey("title")) {
                task.setTitle((String) taskData.get("title"));
            }
            if (taskData.containsKey("description")) {
                task.setDescription((String) taskData.get("description"));
            }
            if (taskData.containsKey("priority")) {
                task.setPriority(Task.Priority.valueOf((String) taskData.get("priority")));
            }
            if (taskData.containsKey("status")) {
                task.setStatus(Task.Status.valueOf((String) taskData.get("status")));
            }
            Task updatedTask = taskService.updateTask(task);
            return ResponseEntity.ok(updatedTask);
        }
        return ResponseEntity.notFound().build();
    }

    @ResponseBody
    @RequestMapping(value = "/api/tasks/{id}/toggle", method = RequestMethod.PUT)
    public ResponseEntity<Void> toggleTask(@PathVariable int id) {
        Task task = taskService.getTaskById(id);
        if (task != null) {
            if (task.getStatus() == Task.Status.COMPLETED) {
                task.setStatus(Task.Status.PENDING);
            } else {
                task.setStatus(Task.Status.COMPLETED);
            }
            taskService.updateTask(task);
            return ResponseEntity.ok().build();
        }
        return ResponseEntity.notFound().build();
    }

    @ResponseBody
    @RequestMapping(value = "/api/tasks/{id}", method = RequestMethod.DELETE)
    public ResponseEntity<Void> deleteTaskAPI(@PathVariable int id) {
        boolean deleted = taskService.deleteTask(id);
        if (deleted) {
            return ResponseEntity.ok().build();
        }
        return ResponseEntity.notFound().build();
    }

    @RequestMapping(value = "/new", method = RequestMethod.GET)
    public String newTaskForm(Model model) {
        model.addAttribute("task", new Task());
        return "tasks/form";
    }

    @RequestMapping(value = "/create", method = RequestMethod.POST)
    public String createTask(@ModelAttribute Task task) {
        // For demo purposes, using user ID 1
        task.setUserId(1);
        taskService.createTask(task);
        return "redirect:/tasks";
    }

    @RequestMapping(value = "/{id}/edit", method = RequestMethod.GET)
    public String editTaskForm(@PathVariable int id, Model model) {
        Task task = taskService.getTaskById(id);
        if (task == null) {
            return "redirect:/tasks";
        }
        model.addAttribute("task", task);
        return "tasks/form";
    }

    @RequestMapping(value = "/{id}/update", method = RequestMethod.POST)
    public String updateTask(@PathVariable int id, @ModelAttribute Task task) {
        task.setTaskId(id);
        task.setUserId(1); // For demo purposes
        taskService.updateTask(task);
        return "redirect:/tasks";
    }

    @RequestMapping(value = "/{id}/delete", method = RequestMethod.POST)
    public String deleteTask(@PathVariable int id) {
        taskService.deleteTask(id);
        return "redirect:/tasks";
    }

    @RequestMapping(value = "/{id}/status", method = RequestMethod.POST)
    @ResponseBody
    public ResponseEntity<String> updateTaskStatus(@PathVariable int id, 
                                                   @RequestParam String status) {
        try {
            Task.Status newStatus = Task.Status.valueOf(status);
            taskService.updateTaskStatus(id, newStatus);
            return ResponseEntity.ok("Status updated successfully");
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Failed to update status");
        }
    }

    @RequestMapping(value = "/{id}/details", method = RequestMethod.GET)
    public String taskDetails(@PathVariable int id, Model model) {
        Task task = taskService.getTaskById(id);
        if (task == null) {
            return "redirect:/tasks";
        }
        model.addAttribute("task", task);
        return "tasks/details";
    }

    @RequestMapping(value = "/api/list", method = RequestMethod.GET)
    @ResponseBody
    public ResponseEntity<List<Task>> getTasksJson(@RequestParam(required = false) String status) {
        // For demo purposes, using user ID 1
        int userId = 1;
        List<Task> tasks;
        
        if (status != null && !status.isEmpty()) {
            tasks = taskService.getTasksByStatus(userId, Task.Status.valueOf(status));
        } else {
            tasks = taskService.getTasksByUserId(userId);
        }
        
        return ResponseEntity.ok(tasks);
    }
}