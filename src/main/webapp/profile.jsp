<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.upload_file_mvc.model.User"%>
<%@ page import="com.upload_file_mvc.util.SessionUtil"%>
<% User user = SessionUtil.getUser(request); if (user == null) { response.sendRedirect(request.getContextPath() + "/login"); return; } %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Profile - Upload File MVC</title>
<style>
*{margin:0;padding:0;box-sizing:border-box}
body{font-family:Arial,sans-serif;background:#f5f5f5}
.navbar{background:#667eea;color:white;padding:15px 30px;display:flex;justify-content:space-between;align-items:center;box-shadow:0 2px 5px rgba(0,0,0,0.1)}
.navbar h1{font-size:24px}
.navbar a{color:white;text-decoration:none;padding:8px 15px;border-radius:5px;margin-left:10px}
.navbar a:hover{background:rgba(255,255,255,0.2)}
.container{max-width:600px;margin:40px auto;padding:0 20px}
.profile-card{background:white;padding:40px;border-radius:10px;box-shadow:0 2px 10px rgba(0,0,0,0.1)}
.profile-card h2{color:#333;margin-bottom:30px;text-align:center}
.form-group{margin-bottom:20px}
label{display:block;margin-bottom:5px;color:#555;font-weight:bold}
input[type="text"],input[type="email"]{width:100%;padding:12px;border:1px solid #ddd;border-radius:5px;font-size:14px}
input[type="text"]:focus,input[type="email"]:focus{outline:none;border-color:#667eea}
.btn{width:100%;padding:12px;background:#667eea;color:white;border:none;border-radius:5px;font-size:16px;cursor:pointer;margin-top:10px}
.btn:hover{background:#5568d3}
.error{background:#ffebee;color:#c62828;padding:10px;border-radius:5px;margin-bottom:20px;text-align:center}
.success{background:#e8f5e9;color:#2e7d32;padding:10px;border-radius:5px;margin-bottom:20px;text-align:center}
.info-group{margin-bottom:15px;padding:10px;background:#f9f9f9;border-radius:5px}
.info-group label{margin-bottom:5px}
.info-group span{color:#333;font-size:16px}
</style>
</head>
<body>
<div class="navbar">
<h1>Upload File MVC</h1>
<div>
<a href="<%= request.getContextPath() %>/home">Home</a>
<a href="<%= request.getContextPath() %>/users">Users</a>
<a href="<%= request.getContextPath() %>/logout">Logout</a>
</div>
</div>
<div class="container">
<div class="profile-card">
<h2>Personal Information</h2>
<% String error = (String) request.getAttribute("error"); if (error != null) { %>
<div class="error"><%= error %></div>
<% } %>
<% String success = (String) request.getAttribute("success"); if (success != null) { %>
<div class="success"><%= success %></div>
<% } %>
<div class="info-group">
<label>User ID:</label>
<span><%= user.getId() %></span>
</div>
<div class="info-group">
<label>Email (Login):</label>
<span><%= user.getEmail() %></span>
</div>
<div class="info-group">
<label>Member Since:</label>
<span><%= user.getCreatedAt() %></span>
</div>
<form method="post" action="<%= request.getContextPath() %>/user/edit">
<div class="form-group">
<label>Full Name:</label>
<input type="text" name="fullName" value="<%= user.getFullName() %>" required>
</div>
<button type="submit" class="btn">Update Information</button>
</form>
</div>
</div>
</body>
</html>
