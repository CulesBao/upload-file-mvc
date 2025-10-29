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

import java.io.File;
import java.io.IOException;

@WebServlet("/upload")
@MultipartConfig
public class UploadController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Lấy user ID từ session
        Integer userId = SessionUtil.getUserId(request);
        
        // Test kết nối database
        DatabaseConnection dbConnection = DatabaseConnection.getInstance();
        Connection conn = dbConnection.getConnection();
        
        if (dbConnection.testConnection()) {
            System.out.println("✅ Kết nối database thành công!");
            System.out.println("📊 Connection object: " + conn);
        } else {
            System.out.println("❌ Kết nối database thất bại!");
        }

        String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads";
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) uploadDir.mkdir();

        int uploadCount = 0;
        for (Part part : request.getParts()) {
            String fileName = part.getSubmittedFileName();
            if (fileName != null && !fileName.isEmpty()) {
                String filePath = uploadPath + File.separator + fileName;
                part.write(filePath);
                uploadCount++;
                
                // Lưu thông tin file vào database (bao gồm user_id)
                try {
                    String sql = "INSERT INTO uploaded_files (file_name, file_path, file_size, file_type, user_id) VALUES (?, ?, ?, ?, ?)";
                    PreparedStatement stmt = conn.prepareStatement(sql);
                    stmt.setString(1, fileName);
                    stmt.setString(2, filePath);
                    stmt.setLong(3, part.getSize());
                    stmt.setString(4, part.getContentType());
                    if (userId != null) {
                        stmt.setInt(5, userId);
                    } else {
                        stmt.setNull(5, java.sql.Types.INTEGER);
                    }
                    
                    int rows = stmt.executeUpdate();
                    System.out.println("💾 Đã lưu file vào database: " + fileName + " (User ID: " + userId + ", " + rows + " row affected)");
                    
                    stmt.close();
                } catch (SQLException e) {
                    System.err.println("❌ Lỗi khi lưu file vào database: " + fileName);
                    e.printStackTrace();
                }
            }
        }

        request.setAttribute("message", "Upload thành công " + uploadCount + " file(s)!");
        request.getRequestDispatcher("success.jsp").forward(request, response);
    }
}
