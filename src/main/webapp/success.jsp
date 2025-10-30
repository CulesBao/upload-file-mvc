<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.upload_file_mvc.model.User"%>
<%@ page import="com.upload_file_mvc.util.SessionUtil"%>
<% User user = SessionUtil.getUser(request); %>
<% 
    String message = (String) request.getAttribute("message");
    Integer uploadCount = (Integer) request.getAttribute("uploadCount");
    Integer errorCount = (Integer) request.getAttribute("errorCount");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Upload Result - Upload File MVC</title>
    <style>*{margin:0;padding:0;box-sizing:border-box}body{font-family:Arial,sans-serif;line-height:1.6;background:#f4f4f4}.navbar{background:#333;color:#fff;padding:1rem;display:flex;justify-content:space-between;align-items:center}.navbar h1{font-size:1.5rem}.navbar nav a{color:#fff;text-decoration:none;margin-left:1rem;padding:0.5rem 1rem;border-radius:4px;transition:background 0.3s}.navbar nav a:hover{background:#555}.container{max-width:800px;margin:2rem auto;padding:2rem;background:#fff;border-radius:8px;box-shadow:0 2px 5px rgba(0,0,0,0.1)}.user-info{background:#e8f4f8;padding:1rem;border-radius:4px;margin-bottom:2rem;border-left:4px solid #2196F3}.alert{padding:1.5rem;margin-bottom:1.5rem;border-radius:4px;font-size:1.1rem}.alert-success{background:#d4edda;color:#155724;border:1px solid #c3e6cb}.alert-error{background:#f8d7da;color:#721c24;border:1px solid #f5c6cb}.alert-warning{background:#fff3cd;color:#856404;border:1px solid #ffeaa7}.result-summary{background:#f8f9fa;padding:1.5rem;border-radius:4px;margin-bottom:1.5rem;border-left:4px solid #28a745}.result-summary h3{color:#333;margin-bottom:1rem}.result-stats{display:flex;justify-content:space-around;margin-top:1rem}.stat-item{text-align:center;padding:1rem}.stat-item .number{font-size:2rem;font-weight:bold;color:#28a745}.stat-item .label{font-size:0.9rem;color:#666}.btn{display:inline-block;padding:0.75rem 1.5rem;background:#2196F3;color:#fff;text-decoration:none;border-radius:4px;margin-right:1rem;transition:background 0.3s}.btn:hover{background:#0b7dda}.btn-secondary{background:#6c757d}.btn-secondary:hover{background:#545b62}h2{color:#333;margin-bottom:1rem}</style>
</head>
<body>
    <div class="navbar">
        <h1>Upload File MVC</h1>
        <nav>
            <a href="<%= request.getContextPath() %>/home">Home</a>
            <a href="<%= request.getContextPath() %>/profile">Profile</a>
            <a href="<%= request.getContextPath() %>/users">Users</a>
            <a href="<%= request.getContextPath() %>/upload">Upload</a>
            <a href="<%= request.getContextPath() %>/logout">Logout</a>
        </nav>
    </div>

    <div class="container">
        <% if (user != null) { %>
        <div class="user-info">
            <strong>Logged in as:</strong> <%= user.getFullName() %> (<%= user.getEmail() %>)
        </div>
        <% } %>

        <h2>Upload Result</h2>

        <% if (uploadCount != null && uploadCount > 0) { %>
        <div class="result-summary">
            <h3>✅ Upload Successful!</h3>
            <div class="result-stats">
                <div class="stat-item">
                    <div class="number" style="color:#28a745"><%= uploadCount %></div>
                    <div class="label">Files Uploaded</div>
                </div>
                <% if (errorCount != null && errorCount > 0) { %>
                <div class="stat-item">
                    <div class="number" style="color:#dc3545"><%= errorCount %></div>
                    <div class="label">Files Failed</div>
                </div>
                <% } %>
            </div>
        </div>
        <% } %>

        <% if (message != null && !message.isEmpty()) { %>
        <div class="alert <%= (errorCount != null && errorCount > 0) ? "alert-warning" : "alert-success" %>">
            <%= message %>
        </div>
        <% } %>

        <div style="margin-top:2rem">
            <a href="<%= request.getContextPath() %>/upload" class="btn">Upload More Files</a>
            <a href="<%= request.getContextPath() %>/home" class="btn btn-secondary">Back to Home</a>
        </div>
    </div>
</body>
</html>
