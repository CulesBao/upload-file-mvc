package com.upload_file_mvc.bll;

import java.io.ByteArrayInputStream;
import java.io.InputStream;
import java.util.Map;
import java.util.concurrent.ConcurrentLinkedQueue;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

import javax.servlet.http.Part;

import com.upload_file_mvc.dal.UploadTaskDAO;
import com.upload_file_mvc.dal.UploadedFileDAO;
import com.upload_file_mvc.dto.UploadTask;
import com.upload_file_mvc.util.CloudinaryUtil;

public class FileUploadService {
    private static FileUploadService instance;
    private final ConcurrentLinkedQueue<UploadTaskData> taskQueue;
    private final ExecutorService executor;
    private final UploadTaskDAO taskDAO;
    private final UploadedFileDAO fileDAO;
    private volatile boolean isRunning;

    private static class UploadTaskData {
        int taskId;
        byte[] fileData;
        String fileName;
        String fileType;
        int userId;

        UploadTaskData(int taskId, byte[] fileData, String fileName, String fileType, int userId) {
            this.taskId = taskId;
            this.fileData = fileData;
            this.fileName = fileName;
            this.fileType = fileType;
            this.userId = userId;
        }
    }

    private FileUploadService() {
        this.taskQueue = new ConcurrentLinkedQueue<>();
        this.executor = Executors.newFixedThreadPool(5);
        this.taskDAO = new UploadTaskDAO();
        this.fileDAO = new UploadedFileDAO();
        this.isRunning = true;

        System.out.println("FileUploadService initialized with 5 worker threads");
        startWorkers();
    }

    public static synchronized FileUploadService getInstance() {
        if (instance == null) {
            instance = new FileUploadService();
        }
        return instance;
    }

    public int submitUploadTask(int userId, Part filePart) {
        try {
            String fileName = filePart.getSubmittedFileName();
            long fileSize = filePart.getSize();
            String fileType = filePart.getContentType();

            InputStream inputStream = filePart.getInputStream();
            byte[] fileData = inputStream.readAllBytes();
            inputStream.close();

            UploadTask task = new UploadTask(userId, fileName, fileSize, fileType);
            int taskId = taskDAO.createTask(task);

            if (taskId > 0) {
                UploadTaskData taskData = new UploadTaskData(taskId, fileData, fileName, fileType, userId);
                taskQueue.offer(taskData);

                return taskId;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return -1;
    }

    private void startWorkers() {
        for (int i = 0; i < 5; i++) {
            final int workerId = i + 1;
            executor.submit(() -> workerLoop(workerId));
        }
    }

    private void workerLoop(int workerId) {
        System.out.println("Worker #" + workerId + " started");

        while (isRunning) {
            try {
                UploadTaskData taskData = taskQueue.poll();

                if (taskData != null) {
                    System.out.println("Worker #" + workerId + " picked up task #" + taskData.taskId);
                    processTask(workerId, taskData);
                } else {
                    Thread.sleep(1000);
                }

            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
                break;
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    private void processTask(int workerId, UploadTaskData taskData) {
        int taskId = taskData.taskId;

        try {
            taskDAO.startTask(taskId);
            taskDAO.updateTaskStatus(taskId, "PROCESSING", 10);

            Thread.sleep(500);
            taskDAO.updateTaskStatus(taskId, "PROCESSING", 25);

            taskDAO.updateTaskStatus(taskId, "PROCESSING", 50);

            InputStream fileInputStream = new ByteArrayInputStream(taskData.fileData);
            Map<String, Object> uploadResult = CloudinaryUtil.uploadFile(
                fileInputStream, 
                taskData.fileName, 
                taskData.userId
            );
            fileInputStream.close();

            if (uploadResult == null) {
                throw new Exception("Cloudinary upload returned null");
            }

            String cloudinaryUrl = (String) uploadResult.get("secure_url");
            String publicId = (String) uploadResult.get("public_id");

            taskDAO.updateTaskStatus(taskId, "PROCESSING", 75);

            taskDAO.updateTaskStatus(taskId, "PROCESSING", 90);
            boolean saved = fileDAO.insertFile(
                taskData.fileName,
                cloudinaryUrl,
                taskData.fileData.length,
                taskData.fileType,
                taskData.userId,
                publicId
            );

            if (!saved) {
                throw new Exception("Failed to save file record to database");
            }

            taskDAO.completeTask(taskId, cloudinaryUrl, publicId);

        } catch (Exception e) {
            String errorMsg = e.getMessage() != null ? e.getMessage() : e.getClass().getSimpleName();
            taskDAO.failTask(taskId, errorMsg);
            e.printStackTrace();
        }
    }

    public int getQueueSize() {
        return taskQueue.size();
    }

    public TaskStats getTaskStats(int userId) {
        int pending = taskDAO.getTaskCountByStatus(userId, "PENDING");
        int processing = taskDAO.getTaskCountByStatus(userId, "PROCESSING");
        int completed = taskDAO.getTaskCountByStatus(userId, "COMPLETED");
        int failed = taskDAO.getTaskCountByStatus(userId, "FAILED");
        
        return new TaskStats(pending, processing, completed, failed);
    }

    public void shutdown() {
        System.out.println("🛑 Shutting down FileUploadService...");
        isRunning = false;
        executor.shutdown();
    }

    public static class TaskStats {
        public final int pending;
        public final int processing;
        public final int completed;
        public final int failed;

        public TaskStats(int pending, int processing, int completed, int failed) {
            this.pending = pending;
            this.processing = processing;
            this.completed = completed;
            this.failed = failed;
        }

        public int getTotal() {
            return pending + processing + completed + failed;
        }
    }
}
