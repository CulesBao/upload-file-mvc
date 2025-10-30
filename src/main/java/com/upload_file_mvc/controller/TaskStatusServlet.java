package com.upload_file_mvc.controller;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;

import com.upload_file_mvc.dao.UploadTaskDAO;
import com.upload_file_mvc.model.UploadTask;
import com.upload_file_mvc.util.SessionUtil;

@WebServlet("/api/task-status")
public class TaskStatusServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UploadTaskDAO taskDAO;

    @Override
    public void init() {
        taskDAO = new UploadTaskDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        Integer userId = SessionUtil.getUserId(request);
        
        if (userId == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.setContentType("application/json");
            response.getWriter().write("{\"error\":\"Not authenticated\"}");
            return;
        }

        String taskIdStr = request.getParameter("taskId");
        
        if (taskIdStr == null || taskIdStr.isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.setContentType("application/json");
            response.getWriter().write("{\"error\":\"Missing taskId parameter\"}");
            return;
        }

        try {
            int taskId = Integer.parseInt(taskIdStr);
            
            // Get task (with userId check for security)
            UploadTask task = taskDAO.getTaskById(taskId, userId);
            
            if (task == null) {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                response.setContentType("application/json");
                response.getWriter().write("{\"error\":\"Task not found\"}");
                return;
            }

            // Return JSON response
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            
            PrintWriter out = response.getWriter();
            out.write(taskToJson(task));
            out.flush();
            
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.setContentType("application/json");
            response.getWriter().write("{\"error\":\"Invalid taskId format\"}");
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.setContentType("application/json");
            response.getWriter().write("{\"error\":\"Server error: " + e.getMessage() + "\"}");
            e.printStackTrace();
        }
    }

    /**
     * Convert UploadTask to JSON string
     */
    private String taskToJson(UploadTask task) {
        StringBuilder json = new StringBuilder();
        json.append("{");
        json.append("\"id\":").append(task.getId()).append(",");
        json.append("\"fileName\":\"").append(escapeJson(task.getFileName())).append("\",");
        json.append("\"fileSize\":").append(task.getFileSize()).append(",");
        json.append("\"status\":\"").append(task.getStatus()).append("\",");
        json.append("\"progress\":").append(task.getProgress()).append(",");
        
        if (task.getCloudinaryUrl() != null) {
            json.append("\"cloudinaryUrl\":\"").append(escapeJson(task.getCloudinaryUrl())).append("\",");
        }
        
        if (task.getErrorMessage() != null) {
            json.append("\"errorMessage\":\"").append(escapeJson(task.getErrorMessage())).append("\",");
        }
        
        if (task.getCreatedAt() != null) {
            json.append("\"createdAt\":\"").append(task.getCreatedAt().toString()).append("\",");
        }
        
        if (task.getCompletedAt() != null) {
            json.append("\"completedAt\":\"").append(task.getCompletedAt().toString()).append("\",");
        }
        
        // Remove trailing comma if exists
        if (json.charAt(json.length() - 1) == ',') {
            json.setLength(json.length() - 1);
        }
        
        json.append("}");
        return json.toString();
    }

    private String escapeJson(String str) {
        if (str == null) return "";
        return str.replace("\\", "\\\\")
                  .replace("\"", "\\\"")
                  .replace("\n", "\\n")
                  .replace("\r", "\\r")
                  .replace("\t", "\\t");
    }
}
