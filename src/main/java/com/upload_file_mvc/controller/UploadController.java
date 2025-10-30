package com.upload_file_mvc.controller;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import com.upload_file_mvc.database.DatabaseConnection;
import com.upload_file_mvc.util.SessionUtil;
import com.upload_file_mvc.util.CloudinaryUtil;
import com.upload_file_mvc.config.CloudinaryConfig;

import java.io.IOException;
import java.io.InputStream;
import java.util.Map;

@WebServlet("/upload")
@MultipartConfig(
    maxFileSize = 1 * 1024 * 1024 * 1024,      // 1 GB
    maxRequestSize = 1 * 1024 * 1024 * 1024    // 1 GB
)
public class UploadController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/upload.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get user ID from session
        Integer userId = SessionUtil.getUserId(request);
        
        if (userId == null) {
            request.setAttribute("error", "You must be logged in to upload files!");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        DatabaseConnection dbConnection = DatabaseConnection.getInstance();
        Connection conn = dbConnection.getConnection();

        int uploadCount = 0;
        int errorCount = 0;
        StringBuilder errorMessages = new StringBuilder();

        for (Part part : request.getParts()) {
            String fileName = part.getSubmittedFileName();
            if (fileName != null && !fileName.isEmpty()) {
                if (part.getSize() > CloudinaryConfig.MAX_FILE_SIZE) {
                    errorCount++;
                    errorMessages.append("File too large: ").append(fileName).append(" (max 10MB)<br>");
                    continue;
                }
                
                InputStream inputStream = null;
                PreparedStatement stmt = null;
                
                try {
                    inputStream = part.getInputStream();

                    Map<String, Object> uploadResult = CloudinaryUtil.uploadFile(inputStream, fileName, userId);
                    
                    String cloudinaryUrl = (String) uploadResult.get("secure_url");
                    String publicId = (String) uploadResult.get("public_id");

                    String sql = "INSERT INTO uploaded_files (file_name, file_path, file_size, file_type, user_id, cloudinary_public_id, cloudinary_url) VALUES (?, ?, ?, ?, ?, ?, ?)";
                    stmt = conn.prepareStatement(sql);
                    stmt.setString(1, fileName);
                    stmt.setString(2, cloudinaryUrl);
                    stmt.setLong(3, part.getSize());
                    stmt.setString(4, part.getContentType());
                    stmt.setInt(5, userId);
                    stmt.setString(6, publicId);
                    stmt.setString(7, cloudinaryUrl);
                    
                    int rows = stmt.executeUpdate();
                    if (rows > 0) {
                        uploadCount++;
                        System.out.println("💾 Saved to database: " + fileName);
                    }
                    
                } catch (Exception e) {
                    errorCount++;
                    String errorMsg = e.getMessage() != null ? e.getMessage() : e.getClass().getSimpleName();
                    errorMessages.append("Failed to upload ").append(fileName).append(": ").append(errorMsg).append("<br>");
                    e.printStackTrace();
                } finally {
                    if (stmt != null) {
                        try { stmt.close(); } catch (SQLException e) { e.printStackTrace(); }
                    }
                    if (inputStream != null) {
                        try { inputStream.close(); } catch (IOException e) { e.printStackTrace(); }
                    }
                }
            }
        }

        StringBuilder message = new StringBuilder();
        if (uploadCount > 0) {
            message.append("Successfully uploaded ").append(uploadCount).append(" file(s)!<br>");
        }
        if (errorCount > 0) {
            message.append("Failed to upload ").append(errorCount).append(" file(s):<br>")
                   .append(errorMessages.toString());
        }

        request.setAttribute("message", message.toString());
        request.setAttribute("uploadCount", uploadCount);
        request.setAttribute("errorCount", errorCount);
        request.getRequestDispatcher("success.jsp").forward(request, response);
    }
}
