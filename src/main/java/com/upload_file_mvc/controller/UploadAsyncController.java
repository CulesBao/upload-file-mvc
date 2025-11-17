package com.upload_file_mvc.controller;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

import com.upload_file_mvc.bll.FileUploadService;
import com.upload_file_mvc.util.SessionUtil;
import com.upload_file_mvc.config.CloudinaryConfig;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/upload-async")
@MultipartConfig(
    maxFileSize = 100 * 1024 * 1024,      // 100 MB
    maxRequestSize = 100 * 1024 * 1024 * 10 // 1 GB total request
)
public class UploadAsyncController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private FileUploadService uploadService;

    @Override
    public void init() {
        uploadService = FileUploadService.getInstance();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        Integer userId = SessionUtil.getUserId(request);
        
        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/login?error=Please login first");
            return;
        }

        List<Integer> taskIds = new ArrayList<>();
        List<String> errors = new ArrayList<>();
        int totalFiles = 0;

        try {
            for (Part part : request.getParts()) {
                String fileName = part.getSubmittedFileName();
                
                if (fileName != null && !fileName.isEmpty()) {
                    totalFiles++;
                    
                    if (part.getSize() > CloudinaryConfig.MAX_FILE_SIZE) {
                        errors.add(fileName + " is too large (max 100MB)");
                        continue;
                    }
                    
                    if (part.getSize() == 0) {
                        errors.add(fileName + " is empty");
                        continue;
                    }
                    
                    int taskId = uploadService.submitUploadTask(userId, part);
                    
                    if (taskId > 0) {
                        taskIds.add(taskId);
                        System.out.println("✅ Created task #" + taskId + " for: " + fileName);
                    } else {
                        errors.add(fileName + " failed to create task");
                    }
                }
            }

            // Build redirect message
            StringBuilder message = new StringBuilder();
            
            if (taskIds.isEmpty() && totalFiles == 0) {
                message.append("error=No files selected");
            } else if (taskIds.isEmpty() && !errors.isEmpty()) {
                message.append("error=All files failed: ").append(String.join(", ", errors));
            } else if (!taskIds.isEmpty() && errors.isEmpty()) {
                message.append("success=")
                       .append(taskIds.size())
                       .append(" file(s) submitted for upload. Check Tasks page for progress.");
            } else if (!taskIds.isEmpty() && !errors.isEmpty()) {
                message.append("warning=")
                       .append(taskIds.size())
                       .append(" file(s) submitted successfully, but ")
                       .append(errors.size())
                       .append(" file(s) failed");
            }

            // Redirect to tasks page
            response.sendRedirect(request.getContextPath() + "/tasks?" + message.toString());
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/tasks?error=Upload failed: " + e.getMessage());
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Redirect to home or upload page
        response.sendRedirect(request.getContextPath() + "/home");
    }
}
