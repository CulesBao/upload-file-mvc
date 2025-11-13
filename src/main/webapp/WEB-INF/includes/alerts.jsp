<%
String alertSuccess = request.getParameter("success");
String alertError = request.getParameter("error");
String alertWarning = request.getParameter("warning");
%>
<style>
.alert{display:flex;align-items:center;gap:15px;padding:15px 20px;border-radius:8px;margin:20px 0;font-size:15px;animation:slideIn 0.3s ease-out;}
.alert-success{background:#d1fae5;color:#065f46;border:1px solid #a7f3d0;}
.alert-error{background:#fee2e2;color:#991b1b;border:1px solid #fecaca;}
.alert-warning{background:#fef3c7;color:#92400e;border:1px solid #fde68a;}
@keyframes slideIn{from{opacity:0;transform:translateY(-20px)}to{opacity:1;transform:translateY(0)}}
</style>

<% if (alertSuccess != null && !alertSuccess.isEmpty()) { %>
<div class="alert alert-success">
    <div><%= alertSuccess %></div>
</div>
<% } %>

<% if (alertError != null && !alertError.isEmpty()) { %>
<div class="alert alert-error">
    <div><%= alertError %></div>
</div>
<% } %>

<% if (alertWarning != null && !alertWarning.isEmpty()) { %>
<div class="alert alert-warning">
    <div><%= alertWarning %></div>
</div>
<% } %>
