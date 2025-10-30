<%
String alertSuccess = request.getParameter("success");
String alertError = request.getParameter("error");
String alertWarning = request.getParameter("warning");
%>
<style>
.alert{display:flex;align-items:center;gap:15px;padding:15px 20px;border-radius:8px;margin:20px 0;font-size:15px;animation:slideIn 0.3s ease-out;}
.alert span{font-size:24px;}
.alert-success{background:#d4edda;color:#155724;border:1px solid #c3e6cb;}
.alert-error{background:#f8d7da;color:#721c24;border:1px solid #f5c6cb;}
.alert-warning{background:#fff3cd;color:#856404;border:1px solid #ffeaa7;}
@keyframes slideIn{from{opacity:0;transform:translateY(-20px)}to{opacity:1;transform:translateY(0)}}
</style>

<% if (alertSuccess != null && !alertSuccess.isEmpty()) { %>
<div class="alert alert-success">
    <span>&#10004;</span>
    <div><%= alertSuccess %></div>
</div>
<% } %>

<% if (alertError != null && !alertError.isEmpty()) { %>
<div class="alert alert-error">
    <span>&#10008;</span>
    <div><%= alertError %></div>
</div>
<% } %>

<% if (alertWarning != null && !alertWarning.isEmpty()) { %>
<div class="alert alert-warning">
    <span>&#9888;</span>
    <div><%= alertWarning %></div>
</div>
<% } %>
