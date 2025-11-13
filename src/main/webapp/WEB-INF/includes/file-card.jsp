<%@ page import="com.upload_file_mvc.model.UploadedFile"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%
UploadedFile cardFile = (UploadedFile) request.getAttribute("cardFile");
SimpleDateFormat cardDateFormat = new SimpleDateFormat("dd/MM/yyyy HH:mm");
if (cardFile != null) {
%>
<style>
.file-card{background:white;border:1px solid #e0e0e0;border-radius:10px;padding:20px;transition:all 0.3s;cursor:pointer;}
.file-card:hover{transform:translateY(-5px);box-shadow:0 8px 16px rgba(0,0,0,0.15);}
.file-icon{font-size:48px;text-align:center;margin-bottom:15px;}
.file-name{font-weight:600;font-size:14px;margin-bottom:10px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;}
.file-meta{font-size:12px;color:#666;margin:5px 0;}
.file-actions{display:flex;gap:5px;margin-top:15px;flex-wrap:wrap;}
.btn{padding:8px 16px;border:none;border-radius:5px;cursor:pointer;font-size:13px;transition:all 0.3s;text-decoration:none;display:inline-block;}
.btn-primary{background:#6366f1;color:white;}
.btn-primary:hover{background:#4f46e5;}
.btn-danger{background:#dc2626;color:white;}
.btn-danger:hover{background:#b91c1c;}
.btn-sm{padding:6px 12px;font-size:12px;}
</style>
<div class="file-card" data-type="<%= cardFile.isImage() ? "image" : cardFile.isVideo() ? "video" : "document" %>">
    <div class="file-icon"><%= cardFile.getFileIcon() %></div>
    <div class="file-name"><%= cardFile.getFileName() %></div>
    <div class="file-meta"><%= cardFile.getFormattedFileSize() %></div>
    <div class="file-meta"><%= cardDateFormat.format(cardFile.getUploadDate()) %></div>
    <% if (cardFile.getFileType() != null) { %>
    <div class="file-meta" style="font-size:11px;color:#999"><%= cardFile.getFileType() %></div>
    <% } %>
    <div class="file-actions">
        <% if (cardFile.isImage() || cardFile.isVideo()) { %>
        <button class="btn btn-primary btn-sm" onclick="previewFile('<%= cardFile.getCloudinaryUrl() %>', <%= cardFile.isVideo() %>)">View</button>
        <% } %>
        <a href="<%= request.getContextPath() %>/download?id=<%= cardFile.getId() %>" class="btn btn-primary btn-sm">Download</a>
        <button class="btn btn-danger btn-sm" onclick="confirmDelete(<%= cardFile.getId() %>, this)" data-filename="<%= cardFile.getFileName() %>">Delete</button>
    </div>
</div>
<%
}
%>
