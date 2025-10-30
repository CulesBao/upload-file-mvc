<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Login - Upload File MVC</title>
<style>
*{margin:0;padding:0;box-sizing:border-box}
body{font-family:Arial,sans-serif;background:linear-gradient(135deg,#667eea 0%,#764ba2 100%);min-height:100vh;display:flex;align-items:center;justify-content:center}
.container{background:white;padding:40px;border-radius:10px;box-shadow:0 10px 25px rgba(0,0,0,0.2);width:100%;max-width:400px}
h2{text-align:center;color:#333;margin-bottom:30px}
.form-group{margin-bottom:20px}
label{display:block;margin-bottom:5px;color:#555;font-weight:bold}
input[type="text"],input[type="password"],input[type="email"]{width:100%;padding:12px;border:1px solid #ddd;border-radius:5px;font-size:14px}
input[type="text"]:focus,input[type="password"]:focus,input[type="email"]:focus{outline:none;border-color:#667eea}
.btn{width:100%;padding:12px;background:#667eea;color:white;border:none;border-radius:5px;font-size:16px;cursor:pointer;margin-top:10px}
.btn:hover{background:#5568d3}
.error{background:#ffebee;color:#c62828;padding:10px;border-radius:5px;margin-bottom:20px;text-align:center}
.success{background:#e8f5e9;color:#2e7d32;padding:10px;border-radius:5px;margin-bottom:20px;text-align:center}
.links{text-align:center;margin-top:20px}
.links a{color:#667eea;text-decoration:none}
.links a:hover{text-decoration:underline}
</style>
</head>
<body>
<div class="container">
<h2>Login</h2>
<% String error = (String) request.getAttribute("error"); if (error != null) { %>
<div class="error"><%= error %></div>
<% } %>
<% String success = (String) request.getAttribute("success"); if (success != null) { %>
<div class="success"><%= success %></div>
<% } %>
<% String message = request.getParameter("message"); if ("logout".equals(message)) { %>
<div class="success">You have successfully logged out!</div>
<% } else if ("deleted".equals(message)) { %>
<div class="success">Account has been deleted!</div>
<% } %>
<form method="post" action="<%= request.getContextPath() %>/login">
<div class="form-group">
<label>Email:</label>
<input type="email" name="email" required autofocus>
</div>
<div class="form-group">
<label>Password:</label>
<input type="password" name="password" required>
</div>
<button type="submit" class="btn">Login</button>
</form>
<div class="links">
<p>Don't have an account? <a href="<%= request.getContextPath() %>/register">Register here</a></p>
</div>
</div>
</body>
</html>
