<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Register - Upload File MVC</title>
<style>
*{margin:0;padding:0;box-sizing:border-box}
body{font-family:Arial,sans-serif;background:linear-gradient(135deg,#667eea 0%,#764ba2 100%);min-height:100vh;display:flex;align-items:center;justify-content:center;padding:20px 0}
.container{background:white;padding:40px;border-radius:10px;box-shadow:0 10px 25px rgba(0,0,0,0.2);width:100%;max-width:400px}
h2{text-align:center;color:#333;margin-bottom:30px}
.form-group{margin-bottom:20px}
label{display:block;margin-bottom:5px;color:#555;font-weight:bold}
input[type="text"],input[type="password"],input[type="email"]{width:100%;padding:12px;border:1px solid #ddd;border-radius:5px;font-size:14px}
input[type="text"]:focus,input[type="password"]:focus,input[type="email"]:focus{outline:none;border-color:#667eea}
.btn{width:100%;padding:12px;background:#667eea;color:white;border:none;border-radius:5px;font-size:16px;cursor:pointer;margin-top:10px}
.btn:hover{background:#5568d3}
.error{background:#ffebee;color:#c62828;padding:10px;border-radius:5px;margin-bottom:20px;text-align:center}
.links{text-align:center;margin-top:20px}
.links a{color:#667eea;text-decoration:none}
.links a:hover{text-decoration:underline}
.hint{font-size:12px;color:#888;margin-top:5px}
</style>
</head>
<body>
<div class="container">
<h2>Create Account</h2>
<% String error = (String) request.getAttribute("error"); if (error != null) { %>
<div class="error"><%= error %></div>
<% } %>
<form method="post" action="<%= request.getContextPath() %>/register">
<div class="form-group">
<label>Email:</label>
<input type="email" name="email" required autofocus>
<div class="hint">Your email will be used for login</div>
</div>
<div class="form-group">
<label>Password:</label>
<input type="password" name="password" required>
<div class="hint">Minimum 6 characters, including letters and numbers</div>
</div>
<div class="form-group">
<label>Confirm Password:</label>
<input type="password" name="confirmPassword" required>
</div>
<div class="form-group">
<label>Full Name:</label>
<input type="text" name="fullName" required>
</div>
<button type="submit" class="btn">Register</button>
</form>
<div class="links">
<p>Already have an account? <a href="<%= request.getContextPath() %>/login">Login here</a></p>
</div>
</div>
</body>
</html>
