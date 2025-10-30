package com.upload_file_mvc.listener;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;

import com.upload_file_mvc.service.FileUploadService;

/**
 * Application lifecycle listener
 * Initializes FileUploadService when app starts
 * Shuts down gracefully when app stops
 */
@WebListener
public class AppContextListener implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        System.out.println("===========================================");
        System.out.println("🚀 Application Starting...");
        System.out.println("===========================================");
        
        // Initialize FileUploadService (starts background workers)
        FileUploadService.getInstance();
        
        System.out.println("✅ FileUploadService initialized");
        System.out.println("✅ Background workers started");
        System.out.println("===========================================");
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        System.out.println("===========================================");
        System.out.println("🛑 Application Stopping...");
        System.out.println("===========================================");
        
        // Shutdown FileUploadService gracefully
        FileUploadService.getInstance().shutdown();
        
        System.out.println("✅ FileUploadService stopped");
        System.out.println("===========================================");
    }
}
