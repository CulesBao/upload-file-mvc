package com.upload_file_mvc.controller;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.util.List;

import com.upload_file_mvc.dao.UploadedFileDAO;
import com.upload_file_mvc.dto.UploadedFile;
import com.upload_file_mvc.util.SessionUtil;
import com.upload_file_mvc.util.CloudinaryUtil;

import java.io.IOException;

@WebServlet("/files")
public class FilesController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UploadedFileDAO uploadedFileDAO;

    @Override
    public void init() {
        uploadedFileDAO = new UploadedFileDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        Integer userId = SessionUtil.getUserId(request);
        
        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        
        if ("delete".equals(action)) {
            handleDelete(request, response, userId);
            return;
        }

        List<UploadedFile> files = uploadedFileDAO.getFilesByUserId(userId);

        request.setAttribute("user", SessionUtil.getUser(request));
        request.setAttribute("files", files);
        
        request.getRequestDispatcher("/files.jsp").forward(request, response);
    }

    private void handleDelete(HttpServletRequest request, HttpServletResponse response, Integer userId) 
            throws IOException, ServletException {
        
        String fileIdStr = request.getParameter("id");
        if (fileIdStr == null || fileIdStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/files?error=Invalid file ID");
            return;
        }

        try {
            int fileId = Integer.parseInt(fileIdStr);
            
            UploadedFile file = uploadedFileDAO.getFileByIdAndUserId(fileId, userId);
            
            if (file != null) {
                String publicId = file.getCloudinaryPublicId();
                String fileName = file.getFileName();
                
                boolean cloudinaryDeleted = false;
                if (publicId != null && !publicId.isEmpty()) {
                    try {
                        cloudinaryDeleted = CloudinaryUtil.deleteFile(publicId);
                    } catch (Exception e) {
                        response.sendRedirect(request.getContextPath() + "/files?error=Failed to delete from Cloudinary: " + e.getMessage());
                    }
                }
                
                boolean dbDeleted = uploadedFileDAO.deleteFile(fileId, userId);
                
                if (dbDeleted) {
                    String message = "File '" + fileName + "' deleted successfully!";
                    if (!cloudinaryDeleted) {
                        message += " (Warning: Could not delete from Cloudinary)";
                    }
                    response.sendRedirect(request.getContextPath() + "/files?success=" + message);
                } else {
                    response.sendRedirect(request.getContextPath() + "/files?error=Failed to delete file from database");
                }
            } else {
                response.sendRedirect(request.getContextPath() + "/files?error=File not found or access denied");
            }
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/files?error=Invalid file ID format");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/files?error=Error: " + e.getMessage());
        }
    }
}
