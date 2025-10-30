package com.upload_file_mvc.controller;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

import com.upload_file_mvc.dao.UploadTaskDAO;
import com.upload_file_mvc.model.UploadTask;
import com.upload_file_mvc.model.User;
import com.upload_file_mvc.service.FileUploadService;
import com.upload_file_mvc.service.FileUploadService.TaskStats;
import com.upload_file_mvc.util.SessionUtil;

@WebServlet("/tasks")
public class TasksController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UploadTaskDAO taskDAO;
    private FileUploadService uploadService;

    @Override
    public void init() {
        taskDAO = new UploadTaskDAO();
        uploadService = FileUploadService.getInstance();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        Integer userId = SessionUtil.getUserId(request);
        
        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/login?error=Please login first");
            return;
        }

        User user = SessionUtil.getUser(request);
        
        // Get all tasks for user
        List<UploadTask> tasks = taskDAO.getTasksByUserId(userId);
        
        // Get statistics
        TaskStats stats = uploadService.getTaskStats(userId);
        int queueSize = uploadService.getQueueSize();
        
        // Set attributes
        request.setAttribute("user", user);
        request.setAttribute("tasks", tasks);
        request.setAttribute("stats", stats);
        request.setAttribute("queueSize", queueSize);
        
        // Forward to JSP
        request.getRequestDispatcher("/tasks.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
