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
</style>

<form action="<%= request.getContextPath() %>/upload-async" method="post" enctype="multipart/form-data" id="uploadForm">
    <div class="upload-zone" onclick="document.getElementById('fileInput').click()">
        <input type="file" name="files" id="fileInput" multiple onchange="handleFileSelect(this)">
        <div class="upload-icon">&#9784;</div>
        <div class="upload-text">Click to upload files</div>
        <div class="upload-hint">or drag and drop files here</div>
        <div class="upload-hint" style="margin-top:10px">Max 100 MB per file</div>
    </div>
    <div id="selectedFiles" style="margin-top:20px"></div>
    <button type="submit" class="btn btn-primary" style="width:100%;margin-top:20px;padding:15px;font-size:16px" id="uploadBtn" disabled>
        &#8593; Upload Files
    </button>
</form>
