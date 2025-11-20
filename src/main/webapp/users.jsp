<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.upload_file_mvc.dto.User"%>
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
.container{max-width:1200px;margin:40px auto;padding:0 20px}
.users-card{background:white;padding:30px;border-radius:10px;box-shadow:0 2px 10px rgba(0,0,0,0.1)}
.users-card h2{color:#333;margin-bottom:20px}
table{width:100%;border-collapse:collapse}
th,td{padding:12px;text-align:left;border-bottom:1px solid #ddd}
th{background:#6366f1;color:white;font-weight:bold}
tr:hover{background:#f5f5f5}
.error{background:#fee2e2;color:#991b1b;padding:10px;border-radius:5px;margin-bottom:20px;text-align:center}
.success{background:#d1fae5;color:#065f46;padding:10px;border-radius:5px;margin-bottom:20px;text-align:center}
</style>
</head>
<body>
<%@ include file="/WEB-INF/includes/navbar.jsp" %>
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
