package com.upload_file_mvc.dto;

import java.sql.Timestamp;

public class UploadTask {
    private int id;
    private int userId;
    private String fileName;
    private long fileSize;
    private String fileType;
    private String status; 
    private int progress; 
    private String cloudinaryUrl;
    private String cloudinaryPublicId;
    private String errorMessage;
    private Timestamp createdAt;
    private Timestamp startedAt;
    private Timestamp completedAt;

    public UploadTask() {
    }

    public UploadTask(int userId, String fileName, long fileSize, String fileType) {
        this.userId = userId;
        this.fileName = fileName;
        this.fileSize = fileSize;
        this.fileType = fileType;
        this.status = "PENDING";
        this.progress = 0;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getFileName() {
        return fileName;
    }

    public void setFileName(String fileName) {
        this.fileName = fileName;
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

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public int getProgress() {
        return progress;
    }

    public void setProgress(int progress) {
        this.progress = progress;
    }

    public String getCloudinaryUrl() {
        return cloudinaryUrl;
    }

    public void setCloudinaryUrl(String cloudinaryUrl) {
        this.cloudinaryUrl = cloudinaryUrl;
    }

    public String getCloudinaryPublicId() {
        return cloudinaryPublicId;
    }

    public void setCloudinaryPublicId(String cloudinaryPublicId) {
        this.cloudinaryPublicId = cloudinaryPublicId;
    }

    public String getErrorMessage() {
        return errorMessage;
    }

    public void setErrorMessage(String errorMessage) {
        this.errorMessage = errorMessage;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Timestamp getStartedAt() {
        return startedAt;
    }

    public void setStartedAt(Timestamp startedAt) {
        this.startedAt = startedAt;
    }

    public Timestamp getCompletedAt() {
        return completedAt;
    }

    public void setCompletedAt(Timestamp completedAt) {
        this.completedAt = completedAt;
    }

    public boolean isPending() {
        return "PENDING".equals(status);
    }

    public boolean isProcessing() {
        return "PROCESSING".equals(status);
    }

    public boolean isCompleted() {
        return "COMPLETED".equals(status);
    }

    public boolean isFailed() {
        return "FAILED".equals(status);
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

    public String getStatusBadgeClass() {
        switch (status) {
            case "PENDING": return "badge-secondary";
            case "PROCESSING": return "badge-primary";
            case "COMPLETED": return "badge-success";
            case "FAILED": return "badge-danger";
            default: return "badge-light";
        }
    }

    public String getStatusIcon() {
        switch (status) {
            case "PENDING": return "&#9203;"; // Clock
            case "PROCESSING": return "&#9881;"; // Gear
            case "COMPLETED": return "&#10004;"; // Check
            case "FAILED": return "&#10008;"; // X
            default: return "&#9679;"; // Circle
        }
    }

    @Override
    public String toString() {
        return "UploadTask{" +
                "id=" + id +
                ", userId=" + userId +
                ", fileName='" + fileName + '\'' +
                ", status='" + status + '\'' +
                ", progress=" + progress +
                '}';
    }
}
