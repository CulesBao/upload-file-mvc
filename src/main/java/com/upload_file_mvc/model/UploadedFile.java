package com.upload_file_mvc.model;

import java.sql.Timestamp;

public class UploadedFile {
    private int id;
    private String fileName;
    private String filePath;
    private long fileSize;
    private String fileType;
    private int userId;
    private String cloudinaryPublicId;
    private String cloudinaryUrl;
    private Timestamp uploadDate;

    public UploadedFile() {
    }

    public UploadedFile(int id, String fileName, String filePath, long fileSize, String fileType, 
                       int userId, String cloudinaryPublicId, String cloudinaryUrl, Timestamp uploadDate) {
        this.id = id;
        this.fileName = fileName;
        this.filePath = filePath;
        this.fileSize = fileSize;
        this.fileType = fileType;
        this.userId = userId;
        this.cloudinaryPublicId = cloudinaryPublicId;
        this.cloudinaryUrl = cloudinaryUrl;
        this.uploadDate = uploadDate;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getFileName() {
        return fileName;
    }

    public void setFileName(String fileName) {
        this.fileName = fileName;
    }

    public String getFilePath() {
        return filePath;
    }

    public void setFilePath(String filePath) {
        this.filePath = filePath;
    }

    public long getFileSize() {
        return fileSize;
    }

    public void setFileSize(long fileSize) {
        this.fileSize = fileSize;
    }

    public String getFileType() {
        return fileType;
    }

    public void setFileType(String fileType) {
        this.fileType = fileType;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getCloudinaryPublicId() {
        return cloudinaryPublicId;
    }

    public void setCloudinaryPublicId(String cloudinaryPublicId) {
        this.cloudinaryPublicId = cloudinaryPublicId;
    }

    public String getCloudinaryUrl() {
        return cloudinaryUrl;
    }

    public void setCloudinaryUrl(String cloudinaryUrl) {
        this.cloudinaryUrl = cloudinaryUrl;
    }

    public Timestamp getUploadDate() {
        return uploadDate;
    }

    public void setUploadDate(Timestamp uploadDate) {
        this.uploadDate = uploadDate;
    }

    public String getFormattedFileSize() {
        if (fileSize < 1024) {
            return fileSize + " B";
        } else if (fileSize < 1024 * 1024) {
            return String.format("%.2f KB", fileSize / 1024.0);
        } else if (fileSize < 1024 * 1024 * 1024) {
            return String.format("%.2f MB", fileSize / (1024.0 * 1024.0));
        } else {
            return String.format("%.2f GB", fileSize / (1024.0 * 1024.0 * 1024.0));
        }
    }

    public boolean isImage() {
        if (fileType == null) return false;
        return fileType.startsWith("image/");
    }

    public boolean isVideo() {
        if (fileType == null) return false;
        return fileType.startsWith("video/");
    }

    public String getFileIcon() {
        if (isImage()) return "🖼️";
        if (isVideo()) return "🎬";
        if (fileType != null && fileType.contains("pdf")) return "📄";
        if (fileType != null && fileType.contains("word")) return "📝";
        if (fileType != null && fileType.contains("excel")) return "📊";
        if (fileType != null && fileType.contains("zip")) return "📦";
        return "📎";
    }
}
