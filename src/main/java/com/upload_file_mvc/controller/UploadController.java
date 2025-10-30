package com.upload_file_mvc.controller;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

import com.upload_file_mvc.dao.UploadedFileDAO;
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
    private UploadedFileDAO uploadedFileDAO;

    @Override
    public void init() {
        uploadedFileDAO = new UploadedFileDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/upload.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Integer userId = SessionUtil.getUserId(request);
        
        if (userId == null) {
            request.setAttribute("error", "You must be logged in to upload files!");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

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
                
                try {
                    inputStream = part.getInputStream();

                    Map<String, Object> uploadResult = CloudinaryUtil.uploadFile(inputStream, fileName, userId);
                    
                    String cloudinaryUrl = (String) uploadResult.get("secure_url");
                    String publicId = (String) uploadResult.get("public_id");

                    boolean saved = uploadedFileDAO.insertFile(
                        fileName, 
                        cloudinaryUrl, 
                        part.getSize(), 
                        part.getContentType(), 
                        userId, 
                        publicId
                    );
                    
                    if (saved) {
                        uploadCount++;
                    } else {
                        errorCount++;
                        errorMessages.append("Failed to save ").append(fileName).append(" to database<br>");
                    }
                    
                } catch (Exception e) {
                    errorCount++;
                    String errorMsg = e.getMessage() != null ? e.getMessage() : e.getClass().getSimpleName();
                    errorMessages.append("Failed to upload ").append(fileName).append(": ").append(errorMsg).append("<br>");
                    e.printStackTrace();
                } finally {
                    if (inputStream != null) {
                        try { inputStream.close(); } catch (IOException e) { e.printStackTrace(); }
                    }
                }
            }
        }

        String redirectUrl = request.getContextPath() + "/home";
        
        if (uploadCount > 0 && errorCount == 0) {
            redirectUrl += "?success=Successfully uploaded " + uploadCount + " file(s) to Cloudinary!";
        } else if (uploadCount > 0 && errorCount > 0) {
            redirectUrl += "?warning=Uploaded " + uploadCount + " file(s), but " + errorCount + " file(s) failed";
        } else if (errorCount > 0) {
            redirectUrl += "?error=Failed to upload files. " + errorMessages.toString().replaceAll("<br>", " ");
        }
        
        response.sendRedirect(redirectUrl);
    }
}
