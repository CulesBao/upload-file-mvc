<%@ page import="com.upload_file_mvc.model.UploadedFile"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%
@SuppressWarnings("unchecked")
List<UploadedFile> allDocFiles = (List<UploadedFile>) request.getAttribute("files");
List<UploadedFile> documents = new ArrayList<>();
if (allDocFiles != null) {
    for (UploadedFile f : allDocFiles) {
        if (!f.isImage() && !f.isVideo()) documents.add(f);
    }
}
SimpleDateFormat docDateFormat = new SimpleDateFormat("dd/MM/yyyy HH:mm");
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

<% if (documents.isEmpty()) { %>
<div class="empty-state">
    <div class="empty-state-icon">&#128196;</div>
    <h3>No documents found</h3>
</div>
<% } else { %>
<div class="files-grid">
    <% for (UploadedFile file : documents) { %>
    <div class="file-card">
        <div class="file-icon"><%= file.getFileIcon() %></div>
        <div class="file-name"><%= file.getFileName() %></div>
        <div class="file-meta">&#128202; <%= file.getFormattedFileSize() %></div>
        <div class="file-meta">&#128197; <%= docDateFormat.format(file.getUploadDate()) %></div>
        <div class="file-meta" style="font-size:11px;color:#999"><%= file.getFileType() %></div>
        <div class="file-actions">
            <a href="<%= file.getCloudinaryUrl() %>" target="_blank" class="btn btn-primary btn-sm">&#8595; Open</a>
            <button class="btn btn-danger btn-sm" onclick="confirmDelete(<%= file.getId() %>, this)" data-filename="<%= file.getFileName() %>">&#128465; Delete</button>
        </div>
    </div>
    <% } %>
</div>
<% } %>
