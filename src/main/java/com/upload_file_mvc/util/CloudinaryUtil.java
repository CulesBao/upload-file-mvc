package com.upload_file_mvc.util;

import com.cloudinary.Cloudinary;
import com.cloudinary.utils.ObjectUtils;
import com.upload_file_mvc.config.CloudinaryConfig;

import java.io.IOException;
import java.io.InputStream;
import java.util.Map;

public class CloudinaryUtil {
    private static Cloudinary cloudinary;
    
    // Singleton pattern
    private CloudinaryUtil() {}
    
    public static Cloudinary getInstance() {
        if (cloudinary == null) {
            synchronized (CloudinaryUtil.class) {
                if (cloudinary == null) {
                    try {
                        String cloudinaryUrl = String.format("cloudinary://%s:%s@%s",
                            CloudinaryConfig.API_KEY,
                            CloudinaryConfig.API_SECRET,
                            CloudinaryConfig.CLOUD_NAME);
                        
                        cloudinary = new Cloudinary(cloudinaryUrl);
                        
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                }
            }
        }
        return cloudinary;
    }

    @SuppressWarnings("unchecked")
	public static Map<String, Object> uploadFile(InputStream inputStream, String fileName, Integer userId) throws IOException {
        try {
            Cloudinary cloudinary = getInstance();

            String publicId = "user_" + userId + "_" + System.currentTimeMillis() + "_" + 
                             fileName.replaceAll("[^a-zA-Z0-9._-]", "_");

            Map<String, Object> uploadParams = ObjectUtils.asMap(
                "resource_type", "auto",
                "use_filename", true,
                "unique_filename", true,
                "timeout", 30000  // 30 seconds
            );

            byte[] fileBytes = inputStream.readAllBytes();
            Map<String, Object> result = cloudinary.uploader().upload(fileBytes, uploadParams);

            return result;
            
        } catch (Exception e) {
            e.printStackTrace();
        }
		return null;
    }

    @SuppressWarnings("unchecked")
	public static boolean deleteFile(String publicId) throws IOException {
        Cloudinary cloudinary = getInstance();
        cloudinary.uploader().destroy(publicId, ObjectUtils.emptyMap());
        return true;
    }

    public static String getFileUrl(String publicId) {
        Cloudinary cloudinary = getInstance();
        return cloudinary.url().generate(publicId);
    }
}
