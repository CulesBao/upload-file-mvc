package com.upload_file_mvc.database;

public class DBConfig {
    
    public static final String DB_HOST = "localhost";
    public static final String DB_PORT = "3306";
    public static final String DB_NAME = "upload_file_db";
    public static final String DB_URL = "jdbc:mysql://" + DB_HOST + ":" + DB_PORT + "/" + DB_NAME;
    
    public static final String DB_URL_FULL = DB_URL + 
            "?useSSL=false" +
            "&serverTimezone=UTC" +
            "&allowPublicKeyRetrieval=true" +
            "&characterEncoding=UTF-8";
    
    public static final String DB_USERNAME = "root";
    public static final String DB_PASSWORD = "password";
    public static final String DB_DRIVER = "com.mysql.cj.jdbc.Driver";
    
    public static final int MAX_CONNECTIONS = 10;
    public static final int INITIAL_CONNECTIONS = 2;
}
