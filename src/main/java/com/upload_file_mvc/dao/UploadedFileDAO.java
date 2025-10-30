package com.upload_file_mvc.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.upload_file_mvc.database.DatabaseConnection;
import com.upload_file_mvc.model.UploadedFile;

public class UploadedFileDAO {
    
    private Connection getConnection() {
        return DatabaseConnection.getInstance().getConnection();
    }

    public boolean insertFile(String fileName, String cloudinaryUrl, long fileSize, 
                             String fileType, int userId, String publicId) {
        String sql = "INSERT INTO uploaded_files (file_name, file_path, file_size, file_type, user_id, cloudinary_public_id, cloudinary_url) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?)";
        
        try (PreparedStatement stmt = getConnection().prepareStatement(sql)) {
            
            stmt.setString(1, fileName);
            stmt.setString(2, cloudinaryUrl);
            stmt.setLong(3, fileSize);
            stmt.setString(4, fileType);
            stmt.setInt(5, userId);
            stmt.setString(6, publicId);
            stmt.setString(7, cloudinaryUrl);
            
            int rows = stmt.executeUpdate();
            return rows > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<UploadedFile> getFilesByUserId(int userId) {
        List<UploadedFile> files = new ArrayList<>();
        String sql = "SELECT * FROM uploaded_files WHERE user_id = ? ORDER BY upload_date DESC";
        
        try (PreparedStatement stmt = getConnection().prepareStatement(sql)) {
            
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                UploadedFile file = new UploadedFile();
                file.setId(rs.getInt("id"));
                file.setFileName(rs.getString("file_name"));
                file.setFilePath(rs.getString("file_path"));
                file.setFileSize(rs.getLong("file_size"));
                file.setFileType(rs.getString("file_type"));
                file.setUserId(rs.getInt("user_id"));
                file.setCloudinaryPublicId(rs.getString("cloudinary_public_id"));
                file.setCloudinaryUrl(rs.getString("cloudinary_url"));
                file.setUploadDate(rs.getTimestamp("upload_date"));
                
                files.add(file);
            }
            
            rs.close();
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return files;
    }

    public UploadedFile getFileByIdAndUserId(int fileId, int userId) {
        String sql = "SELECT * FROM uploaded_files WHERE id = ? AND user_id = ?";
        
        try (PreparedStatement stmt = getConnection().prepareStatement(sql)) {
            
            stmt.setInt(1, fileId);
            stmt.setInt(2, userId);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                UploadedFile file = new UploadedFile();
                file.setId(rs.getInt("id"));
                file.setFileName(rs.getString("file_name"));
                file.setFilePath(rs.getString("file_path"));
                file.setFileSize(rs.getLong("file_size"));
                file.setFileType(rs.getString("file_type"));
                file.setUserId(rs.getInt("user_id"));
                file.setCloudinaryPublicId(rs.getString("cloudinary_public_id"));
                file.setCloudinaryUrl(rs.getString("cloudinary_url"));
                file.setUploadDate(rs.getTimestamp("upload_date"));
                
                rs.close();
                return file;
            }
            
            rs.close();
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return null;
    }

    public boolean deleteFile(int fileId, int userId) {
        String sql = "DELETE FROM uploaded_files WHERE id = ? AND user_id = ?";
        
        try (PreparedStatement stmt = getConnection().prepareStatement(sql)) {
            
            stmt.setInt(1, fileId);
            stmt.setInt(2, userId);
            
            int rows = stmt.executeUpdate();
            return rows > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
