<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Register - Upload File MVC</title>
<style>
*{margin:0;padding:0;box-sizing:border-box}
body{font-family:Arial,sans-serif;background:#6366f1;min-height:100vh;display:flex;align-items:center;justify-content:center;padding:20px 0}
.container{background:white;padding:40px;border-radius:10px;box-shadow:0 10px 25px rgba(0,0,0,0.2);width:100%;max-width:400px}
h2{text-align:center;color:#333;margin-bottom:30px}
.form-group{margin-bottom:20px}
label{display:block;margin-bottom:5px;color:#555;font-weight:bold}
input[type="text"],input[type="password"],input[type="email"]{width:100%;padding:12px;border:1px solid #ddd;border-radius:5px;font-size:14px}
input[type="text"]:focus,input[type="password"]:focus,input[type="email"]:focus{outline:none;border-color:#6366f1}
.btn{width:100%;padding:12px;background:#6366f1;color:white;border:none;border-radius:5px;font-size:16px;cursor:pointer;margin-top:10px}
.btn:hover{background:#4f46e5}
.error{background:#fee2e2;color:#dc2626;padding:10px;border-radius:5px;margin-bottom:20px;text-align:center}
.links{text-align:center;margin-top:20px}
.links a{color:#6366f1;text-decoration:none}
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
<form method="post" action="<%= request.getContextPath() %>/register" onsubmit="return validateRegisterForm()">
<div class="form-group">
<label>Email:</label>
<input type="email" name="email" id="regEmail" required autofocus>
<div class="hint" style="color:#888">Your email will be used for login (e.g., user+tag@gmail.com)</div>
<div class="hint" id="regEmailError" style="color:#dc2626;display:none"></div>
</div>
<div class="form-group">
<label>Password:</label>
<input type="password" name="password" id="regPassword" required minlength="6">
<div class="hint" style="color:#888">Minimum 6 characters, including letters and numbers</div>
<div class="hint" id="regPasswordError" style="color:#dc2626;display:none"></div>
</div>
<div class="form-group">
<label>Confirm Password:</label>
<input type="password" name="confirmPassword" id="regConfirmPassword" required>
<div class="hint" id="regConfirmError" style="color:#dc2626;display:none"></div>
</div>
<div class="form-group">
<label>Full Name:</label>
<input type="text" name="fullName" id="regFullName" required minlength="2">
<div class="hint" id="regNameError" style="color:#dc2626;display:none"></div>
</div>
<button type="submit" class="btn">Register</button>
</form>

<script>
function validateRegisterForm() {
    const email = document.getElementById('regEmail').value.trim();
    const password = document.getElementById('regPassword').value;
    const confirmPassword = document.getElementById('regConfirmPassword').value;
    const fullName = document.getElementById('regFullName').value.trim();
    
    const emailError = document.getElementById('regEmailError');
    const passwordError = document.getElementById('regPasswordError');
    const confirmError = document.getElementById('regConfirmError');
    const nameError = document.getElementById('regNameError');
    
    // Reset errors
    emailError.style.display = 'none';
    passwordError.style.display = 'none';
    confirmError.style.display = 'none';
    nameError.style.display = 'none';
    
    let isValid = true;
    
    // Email validation: support format like baocules17+1@gmail.com
    const emailRegex = /^[a-zA-Z0-9._+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
    if (!emailRegex.test(email)) {
        emailError.textContent = 'Please enter a valid email address';
        emailError.style.display = 'block';
        isValid = false;
    }
    
    // Password validation: minimum 6 characters, must contain letters and numbers
    const passwordRegex = /^(?=.*[a-zA-Z])(?=.*\d).{6,}$/;
    if (password.length < 6) {
        passwordError.textContent = 'Password must be at least 6 characters';
        passwordError.style.display = 'block';
        isValid = false;
    } else if (!passwordRegex.test(password)) {
        passwordError.textContent = 'Password must contain both letters and numbers';
        passwordError.style.display = 'block';
        isValid = false;
    }
    
    // Confirm password validation
    if (password !== confirmPassword) {
        confirmError.textContent = 'Passwords do not match';
        confirmError.style.display = 'block';
        isValid = false;
    }
    
    // Full name validation: minimum 2 characters
    if (fullName.length < 2) {
        nameError.textContent = 'Full name must be at least 2 characters';
        nameError.style.display = 'block';
        isValid = false;
    }
    
    return isValid;
}

// Real-time validation
document.getElementById('regEmail').addEventListener('blur', function() {
    const email = this.value.trim();
    const emailError = document.getElementById('regEmailError');
    const emailRegex = /^[a-zA-Z0-9._+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
    
    if (email && !emailRegex.test(email)) {
        emailError.textContent = 'Invalid email format';
        emailError.style.display = 'block';
    } else {
        emailError.style.display = 'none';
    }
});

document.getElementById('regPassword').addEventListener('input', function() {
    const password = this.value;
    const passwordError = document.getElementById('regPasswordError');
    const passwordRegex = /^(?=.*[a-zA-Z])(?=.*\d).{6,}$/;
    
    if (password.length > 0) {
        if (password.length < 6) {
            passwordError.textContent = 'Password must be at least 6 characters';
            passwordError.style.display = 'block';
        } else if (!passwordRegex.test(password)) {
            passwordError.textContent = 'Must contain both letters and numbers';
            passwordError.style.display = 'block';
        } else {
            passwordError.style.display = 'none';
        }
    } else {
        passwordError.style.display = 'none';
    }
});

document.getElementById('regConfirmPassword').addEventListener('input', function() {
    const password = document.getElementById('regPassword').value;
    const confirmPassword = this.value;
    const confirmError = document.getElementById('regConfirmError');
    
    if (confirmPassword.length > 0) {
        if (password !== confirmPassword) {
            confirmError.textContent = 'Passwords do not match';
            confirmError.style.display = 'block';
        } else {
            confirmError.style.display = 'none';
        }
    } else {
        confirmError.style.display = 'none';
    }
});

document.getElementById('regFullName').addEventListener('blur', function() {
    const fullName = this.value.trim();
    const nameError = document.getElementById('regNameError');
    
    if (fullName.length > 0 && fullName.length < 2) {
        nameError.textContent = 'Full name must be at least 2 characters';
        nameError.style.display = 'block';
    } else {
        nameError.style.display = 'none';
    }
});
</script>
<div class="links">
<p>Already have an account? <a href="<%= request.getContextPath() %>/login">Login here</a></p>
</div>
</div>
</body>
</html>
