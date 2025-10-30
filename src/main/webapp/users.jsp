<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.upload_file_mvc.model.User"%>
<%@ page import="java.util.List"%>
<%
@SuppressWarnings("unchecked")
List<User> users = (List<User>) request.getAttribute("users");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Users List - Upload File MVC</title>
<style>
*{margin:0;padding:0;box-sizing:border-box}
body{font-family:Arial,sans-serif;background:#f5f5f5}
.navbar{background:#667eea;color:white;padding:15px 30px;display:flex;justify-content:space-between;align-items:center;box-shadow:0 2px 5px rgba(0,0,0,0.1)}
.navbar h1{font-size:24px}
.navbar a{color:white;text-decoration:none;padding:8px 15px;border-radius:5px;margin-left:10px}
.navbar a:hover{background:rgba(255,255,255,0.2)}
.container{max-width:1200px;margin:40px auto;padding:0 20px}
.users-card{background:white;padding:30px;border-radius:10px;box-shadow:0 2px 10px rgba(0,0,0,0.1)}
.users-card h2{color:#333;margin-bottom:20px}
table{width:100%;border-collapse:collapse}
th,td{padding:12px;text-align:left;border-bottom:1px solid #ddd}
th{background:#667eea;color:white;font-weight:bold}
tr:hover{background:#f5f5f5}
.error{background:#ffebee;color:#c62828;padding:10px;border-radius:5px;margin-bottom:20px;text-align:center}
.success{background:#e8f5e9;color:#2e7d32;padding:10px;border-radius:5px;margin-bottom:20px;text-align:center}
</style>
</head>
<body>
<div class="navbar">
<h1>Upload File MVC</h1>
<div>
<a href="<%= request.getContextPath() %>/home">Home</a>
<a href="<%= request.getContextPath() %>/profile">Profile</a>
<a href="<%= request.getContextPath() %>/users">Users</a>
<a href="<%= request.getContextPath() %>/upload">Upload</a>
<a href="<%= request.getContextPath() %>/files">My Files</a>
<a href="<%= request.getContextPath() %>/logout">Logout</a>
</div>
</div>
<div class="container">
<div class="users-card">
<h2>User List</h2>
<% String error = (String) request.getAttribute("error"); if (error != null) { %>
<div class="error"><%= error %></div>
<% } %>
<% String success = request.getParameter("success"); if ("deleted".equals(success)) { %>
<div class="success">User deleted successfully!</div>
<% } %>
<table>
<thead>
<tr>
<th>ID</th>
<th>Email</th>
<th>Full Name</th>
<th>Created Date</th>
</tr>
</thead>
<tbody>
<% if (users != null && !users.isEmpty()) { for (User u : users) { %>
<tr>
<td><%= u.getId() %></td>
<td><%= u.getEmail() %></td>
<td><%= u.getFullName() %></td>
<td><%= u.getCreatedAt() %></td>
</tr>
<% } } else { %>
<tr>
<td colspan="4" style="text-align:center;color:#999">No users found</td>
</tr>
<% } %>
</tbody>
</table>
<p style="margin-top:20px;color:#666">Total: <%= users != null ? users.size() : 0 %> user(s)</p>
</div>
</div>
</body>
</html>
