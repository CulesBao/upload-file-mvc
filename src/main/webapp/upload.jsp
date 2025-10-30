<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.upload_file_mvc.model.User"%>
<%@ page import="com.upload_file_mvc.util.SessionUtil"%>
<% User user = SessionUtil.getUser(request); %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Upload Files - Upload File MVC</title>
    <style>*{margin:0;padding:0;box-sizing:border-box}body{font-family:Arial,sans-serif;line-height:1.6;background:#f4f4f4}.navbar{background:#333;color:#fff;padding:1rem;display:flex;justify-content:space-between;align-items:center}.navbar h1{font-size:1.5rem}.navbar nav a{color:#fff;text-decoration:none;margin-left:1rem;padding:0.5rem 1rem;border-radius:4px;transition:background 0.3s}.navbar nav a:hover{background:#555}.container{max-width:800px;margin:2rem auto;padding:2rem;background:#fff;border-radius:8px;box-shadow:0 2px 5px rgba(0,0,0,0.1)}.user-info{background:#e8f4f8;padding:1rem;border-radius:4px;margin-bottom:2rem;border-left:4px solid #2196F3}.upload-form{margin-top:2rem}.form-group{margin-bottom:1.5rem}.form-group label{display:block;margin-bottom:0.5rem;font-weight:bold;color:#333}.file-input-wrapper{position:relative;display:inline-block;width:100%}.file-input-wrapper input[type="file"]{width:100%;padding:1rem;border:2px dashed #ccc;border-radius:4px;background:#f9f9f9;cursor:pointer;transition:border-color 0.3s}.file-input-wrapper input[type="file"]:hover{border-color:#2196F3}.file-info{margin-top:0.5rem;font-size:0.9rem;color:#666}.btn{padding:0.75rem 1.5rem;background:#2196F3;color:#fff;border:none;border-radius:4px;cursor:pointer;font-size:1rem;transition:background 0.3s}.btn:hover{background:#0b7dda}.btn:disabled{background:#ccc;cursor:not-allowed}.alert{padding:1rem;margin-bottom:1rem;border-radius:4px}.alert-info{background:#d1ecf1;color:#0c5460;border:1px solid #bee5eb}.alert-error{background:#f8d7da;color:#721c24;border:1px solid #f5c6cb}h2{color:#333;margin-bottom:1rem}ul{margin-left:2rem;margin-top:0.5rem}li{margin-bottom:0.5rem}</style>
</head>
<body>
    <div class="navbar">
        <h1>Upload File MVC</h1>
        <nav>
            <a href="<%= request.getContextPath() %>/home">Home</a>
            <a href="<%= request.getContextPath() %>/profile">Profile</a>
            <a href="<%= request.getContextPath() %>/users">Users</a>
            <a href="<%= request.getContextPath() %>/upload">Upload</a>
            <a href="<%= request.getContextPath() %>/logout">Logout</a>
        </nav>
    </div>

    <div class="container">
        <% if (user != null) { %>
        <div class="user-info">
            <strong>Logged in as:</strong> <%= user.getFullName() %> (<%= user.getEmail() %>)
        </div>
        <% } %>

        <h2>Upload Files to Cloudinary</h2>

        <div class="alert alert-info">
            <strong>Upload Instructions:</strong>
            <ul>
                <li>Maximum file size: 10 MB per file</li>
                <li>You can select multiple files at once</li>
                <li>Supported formats: Images, Videos, Documents, and more</li>
                <li>Files will be stored securely on Cloudinary</li>
            </ul>
        </div>

        <div class="upload-form">
            <form action="<%= request.getContextPath() %>/upload" method="post" enctype="multipart/form-data" id="uploadForm" onsubmit="return handleSubmit()">
                <div class="form-group">
                    <label for="files">Select Files:</label>
                    <div class="file-input-wrapper">
                        <input type="file" name="files" id="files" multiple required accept="*/*">
                    </div>
                    <div class="file-info" id="fileInfo"></div>
                </div>
                
                <div id="uploadProgress" style="display:none;margin-top:1rem">
                    <div style="background:#f0f0f0;border-radius:4px;padding:0.5rem">
                        <div id="progressText" style="text-align:center;margin-bottom:0.5rem">Uploading...</div>
                        <div style="background:#ddd;height:20px;border-radius:10px;overflow:hidden">
                            <div id="progressBar" style="background:#2196F3;height:100%;width:0%;transition:width 0.3s"></div>
                        </div>
                    </div>
                </div>
                
                <button type="submit" class="btn" id="uploadBtn">
                    Upload Files
                </button>
            </form>
        </div>
    </div>

    <script>
        const fileInput = document.getElementById('files');
        const fileInfo = document.getElementById('fileInfo');
        const uploadBtn = document.getElementById('uploadBtn');
        const uploadForm = document.getElementById('uploadForm');
        const uploadProgress = document.getElementById('uploadProgress');
        const progressBar = document.getElementById('progressBar');
        const progressText = document.getElementById('progressText');

        fileInput.addEventListener('change', function() {
            const files = this.files;
            if (files.length > 0) {
                let totalSize = 0;
                let fileList = '<strong>Selected files:</strong><br>';
                
                for (let i = 0; i < files.length; i++) {
                    const file = files[i];
                    totalSize += file.size;
                    const sizeInMB = (file.size / (1024 * 1024)).toFixed(2);
                    fileList += (i + 1) + '. ' + file.name + ' (' + sizeInMB + ' MB)<br>';
                }
                
                const totalSizeInMB = (totalSize / (1024 * 1024)).toFixed(2);
                fileList += '<br><strong>Total size:</strong> ' + totalSizeInMB + ' MB';
                
                fileInfo.innerHTML = fileList;
            } else {
                fileInfo.innerHTML = '';
            }
        });

        function handleSubmit() {
            const files = fileInput.files;
            if (files.length === 0) {
                alert('Please select at least one file!');
                return false;
            }
            
            uploadBtn.disabled = true;
            uploadBtn.textContent = 'Uploading...';
            uploadProgress.style.display = 'block';
            
            // Simulate progress (since we can't track actual upload progress with form submit)
            let progress = 0;
            const interval = setInterval(function() {
                progress += 5;
                if (progress >= 90) {
                    clearInterval(interval);
                    progressText.textContent = 'Processing...';
                } else {
                    progressBar.style.width = progress + '%';
                    progressText.textContent = 'Uploading... ' + progress + '%';
                }
            }, 200);
            
            return true;
        }
    </script>
</body>
</html>
