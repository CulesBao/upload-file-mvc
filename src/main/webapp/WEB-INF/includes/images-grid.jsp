<%@ page import="com.upload_file_mvc.model.UploadedFile"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%
@SuppressWarnings("unchecked")
List<UploadedFile> allImageFiles = (List<UploadedFile>) request.getAttribute("files");
List<UploadedFile> images = new ArrayList<>();
if (allImageFiles != null) {
    for (UploadedFile f : allImageFiles) {
        if (f.isImage()) images.add(f);
    }
}
SimpleDateFormat imgDateFormat = new SimpleDateFormat("dd/MM/yyyy HH:mm");
%>
<style>
.files-grid{display:grid;grid-template-columns:repeat(auto-fill,minmax(250px,1fr));gap:20px;padding:20px 0;}
.file-card{background:white;border:1px solid #e0e0e0;border-radius:10px;padding:20px;transition:all 0.3s;cursor:pointer;}
.file-card:hover{transform:translateY(-5px);box-shadow:0 8px 16px rgba(0,0,0,0.15);}
.file-icon{font-size:48px;text-align:center;margin-bottom:15px;}
.file-name{font-weight:600;font-size:14px;margin-bottom:10px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;}
.file-meta{font-size:12px;color:#666;margin:5px 0;}
.file-actions{display:flex;gap:5px;margin-top:15px;flex-wrap:wrap;}
.empty-state{text-align:center;padding:80px 20px;color:#999;}
.empty-state-icon{font-size:80px;margin-bottom:20px;}
.empty-state h3{color:#333;margin:10px 0;}
.btn{padding:8px 16px;border:none;border-radius:5px;cursor:pointer;font-size:13px;transition:all 0.3s;text-decoration:none;display:inline-block;}
.btn-primary{background:#667eea;color:white;}
.btn-primary:hover{background:#5568d3;}
.btn-danger{background:#ff3b30;color:white;}
.btn-danger:hover{background:#e02020;}
.btn-sm{padding:6px 12px;font-size:12px;}
</style>

<% if (images.isEmpty()) { %>
<div class="empty-state">
    <div class="empty-state-icon">&#128247;</div>
    <h3>No images found</h3>
</div>
<% } else { %>
<div class="files-grid">
    <% for (UploadedFile file : images) { %>
    <div class="file-card">
        <div class="file-icon"><%= file.getFileIcon() %></div>
        <div class="file-name"><%= file.getFileName() %></div>
        <div class="file-meta">&#128202; <%= file.getFormattedFileSize() %></div>
        <div class="file-meta">&#128197; <%= imgDateFormat.format(file.getUploadDate()) %></div>
        <div class="file-actions">
            <button class="btn btn-primary btn-sm" onclick="previewFile('<%= file.getCloudinaryUrl() %>', false)">&#128065; View</button>
            <a href="<%= request.getContextPath() %>/download?id=<%= file.getId() %>" class="btn btn-primary btn-sm">&#8595; Download</a>
            <button class="btn btn-danger btn-sm" onclick="confirmDelete(<%= file.getId() %>, this)" data-filename="<%= file.getFileName() %>">&#128465; Delete</button>
        </div>
    </div>
    <% } %>
</div>
<% } %>
