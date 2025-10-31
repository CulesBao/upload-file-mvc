<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.upload_file_mvc.model.User"%>
<%@ page import="com.upload_file_mvc.model.UploadedFile"%>
<%@ page import="java.util.List"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%
User user = (User) request.getAttribute("user");
@SuppressWarnings("unchecked")
List<UploadedFile> files = (List<UploadedFile>) request.getAttribute("files");
SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy HH:mm");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Files - Upload File MVC</title>
    <style>
*{margin:0;padding:0;box-sizing:border-box}
body{font-family:Arial,sans-serif;background:#f5f5f5}
.container{max-width:1400px;margin:30px auto;padding:0 20px}
.tabs{background:white;border-radius:10px 10px 0 0;box-shadow:0 2px 10px rgba(0,0,0,0.1);display:flex;overflow:hidden}
.tab{flex:1;padding:20px;text-align:center;background:#f8f9fa;border:none;cursor:pointer;font-size:16px;font-weight:600;color:#666;transition:all 0.3s;border-bottom:3px solid transparent}
.tab:hover{background:#e9ecef;color:#333}
.tab.active{background:white;color:#667eea;border-bottom:3px solid #667eea}
.tab-content{background:white;padding:30px;border-radius:0 0 10px 10px;box-shadow:0 2px 10px rgba(0,0,0,0.1);min-height:400px}
.tab-panel{display:none}
.tab-panel.active{display:block}
.alert{padding:15px 20px;border-radius:8px;margin-bottom:20px;display:flex;align-items:center;gap:10px}
.alert-success{background:#d4edda;color:#155724;border:1px solid #c3e6cb}
.alert-error{background:#f8d7da;color:#721c24;border:1px solid #f5c6cb}
.alert-warning{background:#fff3cd;color:#856404;border:1px solid #ffeeba}
.stats{display:grid;grid-template-columns:repeat(auto-fit,minmax(200px,1fr));gap:20px;margin-bottom:30px}
.stat-card{background:linear-gradient(135deg,#667eea 0%,#764ba2 100%);color:white;padding:20px;border-radius:10px;text-align:center}
.stat-card h3{font-size:36px;margin-bottom:5px}
.stat-card p{opacity:0.9;font-size:14px}
.files-grid{display:grid;grid-template-columns:repeat(auto-fill,minmax(280px,1fr));gap:20px}
.file-card{background:#f8f9fa;border:1px solid #dee2e6;border-radius:10px;padding:20px;transition:all 0.3s;cursor:pointer}
.file-card:hover{transform:translateY(-5px);box-shadow:0 5px 15px rgba(0,0,0,0.1)}
.file-icon{font-size:48px;text-align:center;margin-bottom:15px}
.file-name{font-weight:600;color:#333;margin-bottom:10px;word-break:break-word}
.file-meta{font-size:13px;color:#666;margin-bottom:5px}
.file-actions{display:flex;gap:10px;margin-top:15px;padding-top:15px;border-top:1px solid #dee2e6;flex-wrap:wrap}
.btn{padding:8px 15px;border:none;border-radius:5px;cursor:pointer;font-size:14px;font-weight:600;transition:all 0.3s;text-decoration:none;display:inline-block}
.btn-primary{background:#667eea;color:white}
.btn-primary:hover{background:#5568d3}
.btn-danger{background:#e74c3c;color:white}
.btn-danger:hover{background:#c0392b}
.btn-sm{padding:6px 12px;font-size:13px}
.empty-state{text-align:center;padding:60px 20px;color:#999}
.empty-state-icon{font-size:64px;margin-bottom:20px}
.preview-modal{display:none;position:fixed;top:0;left:0;width:100%;height:100%;background:rgba(0,0,0,0.9);z-index:1000;justify-content:center;align-items:center}
.preview-modal.active{display:flex}
.preview-content{max-width:90%;max-height:90%;background:white;border-radius:10px;overflow:hidden;position:relative}
.preview-content img,.preview-content video{max-width:100%;max-height:80vh;display:block}
.preview-close{position:absolute;top:20px;right:20px;background:rgba(0,0,0,0.7);color:white;border:none;width:40px;height:40px;border-radius:50%;cursor:pointer;font-size:24px;z-index:10}
.preview-close:hover{background:rgba(0,0,0,0.9)}
.upload-zone{border:2px dashed #667eea;border-radius:10px;padding:60px 20px;text-align:center;background:#f8f9ff;cursor:pointer;transition:all 0.3s}
.upload-zone:hover{border-color:#5568d3;background:#f0f2ff}
.upload-zone input{display:none}
.upload-icon{font-size:64px;margin-bottom:20px}
.upload-text{color:#667eea;font-size:18px;font-weight:600;margin-bottom:10px}
.upload-hint{color:#999;font-size:14px}
    </style>
</head>
<body>
<%@ include file="/WEB-INF/includes/navbar.jsp" %>

<div class="container">
    <%@ include file="/WEB-INF/includes/alerts.jsp" %>

    <div class="tabs">
        <button class="tab active" onclick="switchTab('all')">📁 All Files (<%= files != null ? files.size() : 0 %>)</button>
        <button class="tab" onclick="switchTab('images')">🖼️ Images</button>
        <button class="tab" onclick="switchTab('videos')">🎬 Videos</button>
        <button class="tab" onclick="switchTab('documents')">📄 Documents</button>
        <button class="tab" onclick="switchTab('upload')">⬆️ Upload New</button>
    </div>

    <div class="tab-content">
        <!-- All Files Tab -->
        <div id="tab-all" class="tab-panel active">
            <%@ include file="/WEB-INF/includes/file-stats.jsp" %>
            <%@ include file="/WEB-INF/includes/all-files-grid.jsp" %>
        </div>

        <!-- Images Tab -->
        <div id="tab-images" class="tab-panel">
            <%@ include file="/WEB-INF/includes/images-grid.jsp" %>
        </div>

        <!-- Videos Tab -->
        <div id="tab-videos" class="tab-panel">
            <%@ include file="/WEB-INF/includes/videos-grid.jsp" %>
        </div>

        <!-- Documents Tab -->
        <div id="tab-documents" class="tab-panel">
            <%@ include file="/WEB-INF/includes/documents-grid.jsp" %>
        </div>

        <!-- Upload Tab -->
        <div id="tab-upload" class="tab-panel">
            <%@ include file="/WEB-INF/includes/upload-form.jsp" %>
        </div>
    </div>
</div>

<%@ include file="/WEB-INF/includes/preview-modal.jsp" %>

<script>
function switchTab(tabName) {
    const tabs = document.querySelectorAll('.tab');
    const panels = document.querySelectorAll('.tab-panel');
    
    tabs.forEach(tab => tab.classList.remove('active'));
    panels.forEach(panel => panel.classList.remove('active'));
    
    event.target.classList.add('active');
    document.getElementById('tab-' + tabName).classList.add('active');
}

function previewFile(url, isVideo) {
    const modal = document.getElementById('previewModal');
    const mediaContainer = document.getElementById('previewMedia');
    
    if (isVideo) {
        mediaContainer.innerHTML = '<video controls autoplay style="max-width:100%;max-height:80vh"><source src="' + url + '"></video>';
    } else {
        mediaContainer.innerHTML = '<img src="' + url + '" style="max-width:100%;max-height:80vh">';
    }
    
    modal.classList.add('active');
}

function closePreview() {
    const modal = document.getElementById('previewModal');
    modal.classList.remove('active');
    document.getElementById('previewMedia').innerHTML = '';
}

function confirmDelete(fileId, btn) {
    const fileName = btn.getAttribute('data-filename');
    if (confirm('Are you sure you want to delete "' + fileName + '"?\n\nThis action cannot be undone!')) {
        window.location.href = '<%= request.getContextPath() %>/files?action=delete&id=' + fileId;
    }
}

function handleFileSelect(input) {
    const files = input.files;
    const uploadBtn = document.getElementById('uploadBtn');
    const selectedFiles = document.getElementById('selectedFiles');
    const MAX_FILE_SIZE = 100 * 1024 * 1024; // 100MB in bytes
    
    if (files.length > 0) {
        let hasError = false;
        let html = '<div style="background:#f8f9fa;padding:20px;border-radius:8px"><strong>Selected Files:</strong><br><br>';
        
        for (let i = 0; i < files.length; i++) {
            const file = files[i];
            const sizeInMB = (file.size / (1024 * 1024)).toFixed(2);
            const isTooBig = file.size > MAX_FILE_SIZE;
            
            if (isTooBig) hasError = true;
            
            html += '<div style="padding:8px 0;display:flex;align-items:center;gap:10px">';
            html += '<span style="font-size:20px">' + (isTooBig ? '❌' : '📎') + '</span>';
            html += '<span style="flex:1' + (isTooBig ? ';color:#dc3545' : '') + '"><strong>' + file.name + '</strong> ';
            html += '<span style="color:' + (isTooBig ? '#dc3545' : '#999') + '">(' + sizeInMB + ' MB)</span>';
            if (isTooBig) {
                html += ' <strong style="color:#dc3545">- Too large! Max 100MB</strong>';
            }
            html += '</span></div>';
        }
        
        html += '</div>';
        selectedFiles.innerHTML = html;
        uploadBtn.disabled = hasError;
    } else {
        uploadBtn.disabled = true;
        selectedFiles.innerHTML = '';
    }
}

document.addEventListener('DOMContentLoaded', function() {
    const previewModal = document.getElementById('previewModal');
    if (previewModal) {
        previewModal.addEventListener('click', function(e) {
            if (e.target === this) {
                closePreview();
            }
        });
    }

    const uploadZone = document.querySelector('.upload-zone');
    if (uploadZone) {
        uploadZone.addEventListener('dragover', function(e) {
            e.preventDefault();
            this.style.borderColor = '#5568d3';
            this.style.background = '#f0f2ff';
        });
        
        uploadZone.addEventListener('dragleave', function(e) {
            e.preventDefault();
            this.style.borderColor = '#667eea';
            this.style.background = '#f8f9ff';
        });
        
        uploadZone.addEventListener('drop', function(e) {
            e.preventDefault();
            this.style.borderColor = '#667eea';
            this.style.background = '#f8f9ff';
            
            const files = e.dataTransfer.files;
            const fileInput = document.getElementById('fileInput');
            if (fileInput) {
                fileInput.files = files;
                handleFileSelect(fileInput);
            }
        });
    }
});
</script>
</body>
</html>
