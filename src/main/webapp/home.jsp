<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.upload_file_mvc.model.User"%>
<%
User user = (User) request.getAttribute("user");
String successMessage = request.getParameter("success");
String errorMessage = request.getParameter("error");
String warningMessage = request.getParameter("warning");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Home - Upload File MVC</title>
<style>
*{margin:0;padding:0;box-sizing:border-box}
body{font-family:Arial,sans-serif;background:#f5f5f5}
.container{max-width:1200px;margin:40px auto;padding:0 20px}
.alert{padding:15px 20px;border-radius:8px;margin-bottom:20px;display:flex;align-items:center;gap:10px}
.alert-success{background:#d4edda;color:#155724;border:1px solid #c3e6cb}
.alert-error{background:#f8d7da;color:#721c24;border:1px solid #f5c6cb}
.alert-warning{background:#fff3cd;color:#856404;border:1px solid #ffeeba}
.welcome{background:white;padding:30px;border-radius:10px;box-shadow:0 2px 10px rgba(0,0,0,0.1);margin-bottom:30px}
.welcome h2{color:#333;margin-bottom:15px}
.welcome p{color:#666;line-height:1.6}
.cards{display:grid;grid-template-columns:repeat(auto-fit,minmax(300px,1fr));gap:20px;margin-top:30px}
.card{background:white;padding:30px;border-radius:10px;box-shadow:0 2px 10px rgba(0,0,0,0.1);text-align:center;transition:transform 0.3s}
.card:hover{transform:translateY(-5px)}
.card h3{color:#333;margin-bottom:15px}
.card p{color:#666;margin-bottom:20px}
.card a{display:inline-block;padding:10px 20px;background:#667eea;color:white;text-decoration:none;border-radius:5px;transition:background 0.3s}
.card a:hover{background:#5568d3}
.logout-btn{background:#e74c3c;padding:8px 15px;border-radius:5px;cursor:pointer}
.logout-btn:hover{background:#c0392b}
</style>
</head>
<body>
<%@ include file="/WEB-INF/includes/navbar.jsp" %>
<div class="container">
<% if (successMessage != null) { %>
<div class="alert alert-success">
<span>✅</span>
<div><%= successMessage %></div>
</div>
<% } %>

<% if (errorMessage != null) { %>
<div class="alert alert-error">
<span>❌</span>
<div><%= errorMessage %></div>
</div>
<% } %>

<% if (warningMessage != null) { %>
<div class="alert alert-warning">
<span>⚠️</span>
<div><%= warningMessage %></div>
</div>
<% } %>

<div class="welcome">
<h2>Welcome to Upload File MVC</h2>
<p>This is a file upload management system with user authentication. You can:</p>
<ul style="margin-left:20px;margin-top:10px;color:#666">
<li>Upload and manage your files</li>
<li>View and update your personal information</li>
<li>Manage user list</li>
</ul>
</div>
<div class="cards">
<div class="card">
<h3>File Management</h3>
<p>View and manage your uploaded files</p>
<a href="<%= request.getContextPath() %>/files">My Files</a>
</div>
<div class="card">
<h3>Profile Management</h3>
<p>View and update your personal information</p>
<a href="<%= request.getContextPath() %>/profile">View Profile</a>
</div>
<div class="card">
<h3>User List</h3>
<p>View list of all users</p>
<a href="<%= request.getContextPath() %>/users">View List</a>
</div>
</div>
</div>
</body>
</html>
