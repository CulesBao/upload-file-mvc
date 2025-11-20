package com.upload_file_mvc.database;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DatabaseConnection {
    
    private static DatabaseConnection instance;
    private Connection connection;
    
    private static final String URL = DBConfig.DB_URL_FULL;
    private static final String USERNAME = DBConfig.DB_USERNAME;
    private static final String PASSWORD = DBConfig.DB_PASSWORD;
    private static final String DRIVER = DBConfig.DB_DRIVER;

    private DatabaseConnection() {
        try {
            Class.forName(DRIVER);
            
            this.connection = DriverManager.getConnection(URL, USERNAME, PASSWORD);
            System.out.println("Connected to the database successfully!");
            
        } catch (ClassNotFoundException e) {
            System.err.println("MySQL JDBC Driver not found!");
            e.printStackTrace();
        } catch (SQLException e) {
            System.err.println("Database connection error!");
            e.printStackTrace();
        }
    }

    public static synchronized DatabaseConnection getInstance() {
        if (instance == null) {
            instance = new DatabaseConnection();
        } else {
            try {
                if (instance.connection == null || instance.connection.isClosed()) {
                    instance = new DatabaseConnection();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return instance;
    }

    public Connection getConnection() {
        return connection;
    }

    public void closeConnection() {
        try {
            if (connection != null && !connection.isClosed()) {
                connection.close();
                System.out.println("Database connection closed!");
            }
        } catch (SQLException e) {
            System.err.println("Error closing database connection!");
            e.printStackTrace();
        }
    }

    public boolean testConnection() {
        try {
            return connection != null && !connection.isClosed();
        } catch (SQLException e) {
            return false;
        }
    }
}
