<%@ page import="com.upload_file_mvc.model.UploadedFile"%>
<%@ page import="java.util.List"%>
<%
@SuppressWarnings("unchecked")
List<UploadedFile> statsFiles = (List<UploadedFile>) request.getAttribute("files");
long totalSize = 0;
int imageCount = 0;
int videoCount = 0;

if (statsFiles != null) {
    for (UploadedFile f : statsFiles) {
        totalSize += f.getFileSize();
        if (f.isImage()) imageCount++;
        if (f.isVideo()) videoCount++;
    }
}
%>
<style>
.stats{display:grid;grid-template-columns:repeat(auto-fit,minmax(200px,1fr));gap:20px;margin:20px 0;}
.stat-card{background:#6366f1;color:white;padding:25px;border-radius:10px;text-align:center;box-shadow:0 4px 6px rgba(0,0,0,0.1);transition:transform 0.3s;}
.stat-card:hover{transform:translateY(-5px);box-shadow:0 6px 12px rgba(0,0,0,0.15);}
.stat-card h3{margin:0;font-size:32px;font-weight:bold;}
.stat-card p{margin:10px 0 0 0;opacity:0.9;font-size:14px;}
</style>
<div class="stats">
    <div class="stat-card">
        <h3><%= statsFiles != null ? statsFiles.size() : 0 %></h3>
        <p>Total Files</p>
    </div>
    <div class="stat-card">
        <h3><%= imageCount %></h3>
        <p>Images</p>
    </div>
    <div class="stat-card">
        <h3><%= videoCount %></h3>
        <p>Videos</p>
    </div>
    <div class="stat-card">
        <h3><%= String.format("%.2f MB", totalSize / (1024.0 * 1024.0)) %></h3>
        <p>Total Storage</p>
    </div>
</div>
