package com.upload_file_mvc.listener;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;

import com.upload_file_mvc.bll.FileUploadService;

@WebListener
public class AppContextListener implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        System.out.println("Application Starting...");

        FileUploadService.getInstance();
        
        System.out.println("FileUploadService initialized");
        System.out.println("Background workers started");
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        System.out.println("Application Stopping...");
        
        FileUploadService.getInstance().shutdown();
        
        System.out.println("FileUploadService stopped");
    }
}
