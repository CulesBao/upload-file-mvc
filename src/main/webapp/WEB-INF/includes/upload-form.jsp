<style>
.upload-zone{border:3px dashed #667eea;border-radius:10px;padding:60px 20px;text-align:center;cursor:pointer;transition:all 0.3s;background:#f8f9ff;}
.upload-zone:hover{background:#e8ebff;border-color:#764ba2;}
.upload-zone.drag-over{background:#667eea;border-color:#764ba2;transform:scale(1.02);}
.upload-zone.drag-over .upload-icon,.upload-zone.drag-over .upload-text,.upload-zone.drag-over .upload-hint{color:white;}
.upload-icon{font-size:64px;margin-bottom:20px;}
.upload-text{font-size:20px;font-weight:600;color:#333;margin-bottom:10px;}
.upload-hint{color:#666;font-size:14px;}
#fileInput{display:none;}
#selectedFiles{font-size:14px;color:#666;}
#uploadForm .btn{width:100%;margin-top:20px;padding:15px;font-size:16px;}
.upload-mode{display:flex;gap:10px;margin-bottom:20px;justify-content:center;}
.upload-mode label{display:flex;align-items:center;gap:5px;cursor:pointer;padding:10px 20px;border:2px solid #667eea;border-radius:5px;background:white;transition:all 0.3s;}
.upload-mode input[type="radio"]{cursor:pointer;}
.upload-mode label:has(input:checked){background:#667eea;color:white;font-weight:bold;}
</style>

<!-- Upload Mode Selection -->
<div class="upload-mode">
    <label>
        <input type="radio" name="uploadMode" value="sync" checked>
        &#9889; Sync Upload (Wait)
    </label>
    <label>
        <input type="radio" name="uploadMode" value="async">
        &#128640; Async Upload (Background)
    </label>
</div>

<form action="<%= request.getContextPath() %>/upload" method="post" enctype="multipart/form-data" id="uploadForm">
    <div class="upload-zone" onclick="document.getElementById('fileInput').click()">
        <input type="file" name="files" id="fileInput" multiple onchange="handleFileSelect(this)">
        <div class="upload-icon">&#9784;</div>
        <div class="upload-text">Click to upload files</div>
        <div class="upload-hint">or drag and drop files here</div>
        <div class="upload-hint" style="margin-top:10px">Max 10 MB per file</div>
    </div>
    <div id="selectedFiles" style="margin-top:20px"></div>
    <button type="submit" class="btn btn-primary" style="width:100%;margin-top:20px;padding:15px;font-size:16px" id="uploadBtn" disabled>
        &#8593; Upload Files
    </button>
</form>
