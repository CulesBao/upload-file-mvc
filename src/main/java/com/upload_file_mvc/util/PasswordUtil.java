package com.upload_file_mvc.util;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.util.Base64;

public class PasswordUtil {
    
    private static final int SALT_LENGTH = 16;

    private static String generateSalt() {
        SecureRandom random = new SecureRandom();
        byte[] salt = new byte[SALT_LENGTH];
        random.nextBytes(salt);
        return Base64.getEncoder().encodeToString(salt);
    }

    private static String hashPassword(String password, String salt) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            md.update(salt.getBytes());
            byte[] hashedPassword = md.digest(password.getBytes());
            return Base64.getEncoder().encodeToString(hashedPassword);
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("Error hashing password", e);
        }
    }

    public static String encryptPassword(String password) {
        String salt = generateSalt();
        String hash = hashPassword(password, salt);
        return salt + ":" + hash;
    }
    
    public static boolean verifyPassword(String password, String storedPassword) {
        if (storedPassword == null || !storedPassword.contains(":")) {
            return false;
        }
        
        String[] parts = storedPassword.split(":");
        if (parts.length != 2) {
            return false;
        }
        
        String salt = parts[0];
        String storedHash = parts[1];
        String hash = hashPassword(password, salt);
        
        return hash.equals(storedHash);
    }
}
