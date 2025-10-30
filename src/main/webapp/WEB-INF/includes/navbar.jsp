<%@ page import="com.upload_file_mvc.model.User"%>
<%
User navUser = (User) request.getAttribute("user");
String currentPage = request.getServletPath();
%>
<style>
.navbar{background:linear-gradient(135deg,#667eea 0%,#764ba2 100%);padding:20px 40px;display:flex;justify-content:space-between;align-items:center;box-shadow:0 2px 10px rgba(0,0,0,0.1);}
.navbar h1{margin:0;color:white;font-size:24px;}
.user-info{display:flex;gap:20px;align-items:center;}
.user-info span{color:white;font-weight:500;}
.user-info a{color:white;text-decoration:none;padding:8px 16px;border-radius:5px;transition:all 0.3s;}
.user-info a:hover{background:rgba(255,255,255,0.2);}
.user-info a.active{background:rgba(255,255,255,0.3);font-weight:bold;}
.logout-btn{background:rgba(255,59,48,0.8)!important;}
.logout-btn:hover{background:rgba(255,59,48,1)!important;}
</style>
<div class="navbar">
    <h1>Upload File MVC</h1>
    <div class="user-info">
        <span>Welcome, <%= navUser != null ? navUser.getFullName() : "Guest" %>!</span>
        <a href="<%= request.getContextPath() %>/home" <%= currentPage.equals("/home.jsp") ? "class=\"active\"" : "" %>>Home</a>
        <a href="<%= request.getContextPath() %>/profile" <%= currentPage.equals("/profile.jsp") ? "class=\"active\"" : "" %>>Profile</a>
        <a href="<%= request.getContextPath() %>/users" <%= currentPage.equals("/users.jsp") ? "class=\"active\"" : "" %>>Users</a>
        <a href="<%= request.getContextPath() %>/files" <%= currentPage.equals("/files.jsp") ? "class=\"active\"" : "" %>>My Files</a>
        <a href="<%= request.getContextPath() %>/tasks" <%= currentPage.equals("/tasks.jsp") ? "class=\"active\"" : "" %>>&#128202; Tasks</a>
        <a href="<%= request.getContextPath() %>/logout" class="logout-btn">Logout</a>
    </div>
</div>
