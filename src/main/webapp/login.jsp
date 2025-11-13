<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Login - Upload File MVC</title>
<style>
*{margin:0;padding:0;box-sizing:border-box}
body{font-family:Arial,sans-serif;background:#6366f1;min-height:100vh;display:flex;align-items:center;justify-content:center}
.container{background:white;padding:40px;border-radius:10px;box-shadow:0 10px 25px rgba(0,0,0,0.2);width:100%;max-width:400px}
h2{text-align:center;color:#333;margin-bottom:30px}
.form-group{margin-bottom:20px}
label{display:block;margin-bottom:5px;color:#555;font-weight:bold}
input[type="text"],input[type="password"],input[type="email"]{width:100%;padding:12px;border:1px solid #ddd;border-radius:5px;font-size:14px}
input[type="text"]:focus,input[type="password"]:focus,input[type="email"]:focus{outline:none;border-color:#6366f1}
.btn{width:100%;padding:12px;background:#6366f1;color:white;border:none;border-radius:5px;font-size:16px;cursor:pointer;margin-top:10px}
.btn:hover{background:#4f46e5}
.error{background:#fee2e2;color:#dc2626;padding:10px;border-radius:5px;margin-bottom:20px;text-align:center}
.success{background:#d1fae5;color:#065f46;padding:10px;border-radius:5px;margin-bottom:20px;text-align:center}
.links{text-align:center;margin-top:20px}
.links a{color:#6366f1;text-decoration:none}
.links a:hover{text-decoration:underline}
.hint{font-size:12px;margin-top:5px}
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
<form method="post" action="<%= request.getContextPath() %>/login" onsubmit="return validateLoginForm()">
<div class="form-group">
<label>Email:</label>
<input type="email" name="email" id="loginEmail" required autofocus>
<div class="hint" id="emailError" style="color:#dc2626;display:none;margin-top:5px"></div>
</div>
<div class="form-group">
<label>Password:</label>
<input type="password" name="password" id="loginPassword" required minlength="6">
<div class="hint" id="passwordError" style="color:#dc2626;display:none;margin-top:5px"></div>
</div>
<button type="submit" class="btn">Login</button>
</form>

<script>
function validateLoginForm() {
    const email = document.getElementById('loginEmail').value.trim();
    const password = document.getElementById('loginPassword').value;
    const emailError = document.getElementById('emailError');
    const passwordError = document.getElementById('passwordError');
    
    // Reset errors
    emailError.style.display = 'none';
    passwordError.style.display = 'none';
    
    let isValid = true;
    
    // Email validation: support format like baocules17+1@gmail.com
    const emailRegex = /^[a-zA-Z0-9._+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
    if (!emailRegex.test(email)) {
        emailError.textContent = 'Please enter a valid email address';
        emailError.style.display = 'block';
        isValid = false;
    }
    
    // Password validation: minimum 6 characters
    if (password.length < 6) {
        passwordError.textContent = 'Password must be at least 6 characters';
        passwordError.style.display = 'block';
        isValid = false;
    }
    
    return isValid;
}

// Real-time validation
document.getElementById('loginEmail').addEventListener('blur', function() {
    const email = this.value.trim();
    const emailError = document.getElementById('emailError');
    const emailRegex = /^[a-zA-Z0-9._+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
    
    if (email && !emailRegex.test(email)) {
        emailError.textContent = 'Invalid email format';
        emailError.style.display = 'block';
    } else {
        emailError.style.display = 'none';
    }
});

document.getElementById('loginPassword').addEventListener('input', function() {
    const passwordError = document.getElementById('passwordError');
    
    if (this.value.length > 0 && this.value.length < 6) {
        passwordError.textContent = 'Password must be at least 6 characters';
        passwordError.style.display = 'block';
    } else {
        passwordError.style.display = 'none';
    }
});
</script>
<div class="links">
<p>Don't have an account? <a href="<%= request.getContextPath() %>/register">Register here</a></p>
</div>
</div>
</body>
</html>
