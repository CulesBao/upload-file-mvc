package com.upload_file_mvc.dal;

import com.upload_file_mvc.dto.UploadTask;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class UploadTaskDAO {
    
    private Connection getConnection() {
        return DatabaseConnection.getInstance().getConnection();
    }

    public int createTask(UploadTask task) {
        String sql = "INSERT INTO upload_tasks (user_id, file_name, file_size, file_type, status, progress) " +
                    "VALUES (?, ?, ?, ?, ?, ?)";
        
        try (PreparedStatement stmt = getConnection().prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setInt(1, task.getUserId());
            stmt.setString(2, task.getFileName());
            stmt.setLong(3, task.getFileSize());
            stmt.setString(4, task.getFileType());
            stmt.setString(5, task.getStatus());
            stmt.setInt(6, task.getProgress());
            
            int affectedRows = stmt.executeUpdate();
            
            if (affectedRows > 0) {
                try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        int taskId = generatedKeys.getInt(1);
                        task.setId(taskId);
                        return taskId;
                    }
                }
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return -1;
    }

    public List<UploadTask> getTasksByUserId(int userId) {
        List<UploadTask> tasks = new ArrayList<>();
        String sql = "SELECT * FROM upload_tasks WHERE user_id = ? ORDER BY created_at DESC";
        
        try (PreparedStatement stmt = getConnection().prepareStatement(sql)) {
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                tasks.add(mapResultSetToTask(rs));
            }
            
            rs.close();
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return tasks;
    }

    public UploadTask getTaskById(int taskId, int userId) {
        String sql = "SELECT * FROM upload_tasks WHERE id = ? AND user_id = ?";
        
        try (PreparedStatement stmt = getConnection().prepareStatement(sql)) {
            stmt.setInt(1, taskId);
            stmt.setInt(2, userId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                UploadTask task = mapResultSetToTask(rs);
                rs.close();
                return task;
            }
            
            rs.close();
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return null;
    }

    public boolean updateTaskStatus(int taskId, String status, int progress) {
        String sql = "UPDATE upload_tasks SET status = ?, progress = ? WHERE id = ?";
        
        try (PreparedStatement stmt = getConnection().prepareStatement(sql)) {
            stmt.setString(1, status);
            stmt.setInt(2, progress);
            stmt.setInt(3, taskId);
            
            int rows = stmt.executeUpdate();
            if (rows > 0) {
                return true;
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }

    public boolean startTask(int taskId) {
        String sql = "UPDATE upload_tasks SET status = 'PROCESSING', started_at = NOW() WHERE id = ?";
        
        try (PreparedStatement stmt = getConnection().prepareStatement(sql)) {
            stmt.setInt(1, taskId);
            return stmt.executeUpdate() > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }

    public boolean completeTask(int taskId, String cloudinaryUrl, String publicId) {
        String sql = "UPDATE upload_tasks SET status = 'COMPLETED', progress = 100, " +
                    "cloudinary_url = ?, cloudinary_public_id = ?, completed_at = NOW() WHERE id = ?";
        
        try (PreparedStatement stmt = getConnection().prepareStatement(sql)) {
            stmt.setString(1, cloudinaryUrl);
            stmt.setString(2, publicId);
            stmt.setInt(3, taskId);
            
            int rows = stmt.executeUpdate();
            if (rows > 0) {
                return true;
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }

    public boolean failTask(int taskId, String errorMessage) {
        String sql = "UPDATE upload_tasks SET status = 'FAILED', error_message = ?, completed_at = NOW() WHERE id = ?";
        
        try (PreparedStatement stmt = getConnection().prepareStatement(sql)) {
            stmt.setString(1, errorMessage);
            stmt.setInt(2, taskId);
            
            int rows = stmt.executeUpdate();
            if (rows > 0) {
                return true;
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return false;
    }

    public int getTaskCountByStatus(int userId, String status) {
        String sql = "SELECT COUNT(*) FROM upload_tasks WHERE user_id = ? AND status = ?";
        
        try (PreparedStatement stmt = getConnection().prepareStatement(sql)) {
            stmt.setInt(1, userId);
            stmt.setString(2, status);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                int count = rs.getInt(1);
                rs.close();
                return count;
            }
            
            rs.close();
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return 0;
    }

    private UploadTask mapResultSetToTask(ResultSet rs) throws SQLException {
        UploadTask task = new UploadTask();
        task.setId(rs.getInt("id"));
        task.setUserId(rs.getInt("user_id"));
        task.setFileName(rs.getString("file_name"));
        task.setFileSize(rs.getLong("file_size"));
        task.setFileType(rs.getString("file_type"));
        task.setStatus(rs.getString("status"));
        task.setProgress(rs.getInt("progress"));
        task.setCloudinaryUrl(rs.getString("cloudinary_url"));
        task.setCloudinaryPublicId(rs.getString("cloudinary_public_id"));
        task.setErrorMessage(rs.getString("error_message"));
        task.setCreatedAt(rs.getTimestamp("created_at"));
        task.setStartedAt(rs.getTimestamp("started_at"));
        task.setCompletedAt(rs.getTimestamp("completed_at"));
        return task;
    }
}
