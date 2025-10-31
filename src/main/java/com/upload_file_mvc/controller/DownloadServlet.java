package com.upload_file_mvc.controller;

import com.upload_file_mvc.dao.UploadedFileDAO;
import com.upload_file_mvc.model.UploadedFile;
import com.upload_file_mvc.util.CloudinaryUtil;
import com.upload_file_mvc.util.SessionUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.net.URLEncoder;

@WebServlet("/download")
public class DownloadServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UploadedFileDAO uploadedFileDAO;

    @Override
    public void init() throws ServletException {
        uploadedFileDAO = new UploadedFileDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        Integer userId = SessionUtil.getUserId(request);
        if (userId == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "Please login to download files");
            return;
        }

        String fileIdParam = request.getParameter("id");
        if (fileIdParam == null || fileIdParam.isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "File ID is required");
            return;
        }

        int fileId;
        try {
            fileId = Integer.parseInt(fileIdParam);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid file ID");
            return;
        }

        UploadedFile file = uploadedFileDAO.getFileByIdAndUserId(fileId, userId);
        if (file == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "File not found or access denied");
            return;
        }

        streamFileToClient(file, response);
    }

    private void streamFileToClient(UploadedFile file, HttpServletResponse response) 
            throws IOException {
        
        String resourceType = detectResourceType(file);
        String freshUrl = generateCloudinaryUrl(file.getCloudinaryPublicId(), resourceType, file);

        java.net.URL cloudinaryUrl = new java.net.URL(freshUrl);

        response.setContentType(file.getFileType() != null ? file.getFileType() : "application/octet-stream");
        response.setContentLengthLong(file.getFileSize());

        String encodedFilename = URLEncoder.encode(file.getFileName(), "UTF-8")
            .replaceAll("\\+", "%20");
        
        response.setHeader("Content-Disposition", 
            "attachment; filename*=UTF-8''" + encodedFilename);
        
        try (java.io.InputStream in = new java.io.BufferedInputStream(cloudinaryUrl.openStream());
             java.io.OutputStream out = response.getOutputStream()) {
            
            byte[] buffer = new byte[8192];
            int bytesRead;
            
            while ((bytesRead = in.read(buffer)) != -1) {
                out.write(buffer, 0, bytesRead);
            }
            
            out.flush();
        } catch (IOException e) {
            throw e;
        }
    }

    private String detectResourceType(UploadedFile file) {
        String fileType = file.getFileType();
        if (fileType == null) return "raw";
        
        fileType = fileType.toLowerCase();
        
        if (fileType.startsWith("image/")) {
            return "image";
        } else if (fileType.startsWith("video/")) {
            return "video";
        } else {
            return "raw";
        }
    }

    private String generateCloudinaryUrl(String publicId, String resourceType, UploadedFile file) {
        String cloudName = com.upload_file_mvc.config.CloudinaryConfig.CLOUD_NAME;
        if ("raw".equals(resourceType)) {
            String storedUrl = file.getCloudinaryUrl();
            
            int lastSlash = storedUrl.lastIndexOf('/');
            if (lastSlash > 0) {
                String filenamePart = storedUrl.substring(lastSlash + 1);
                return String.format("https://res.cloudinary.com/%s/raw/upload/%s",
                    cloudName, filenamePart);
            }
        }
        
        return String.format("https://res.cloudinary.com/%s/%s/upload/%s",
            cloudName, resourceType, publicId);
    }
}
