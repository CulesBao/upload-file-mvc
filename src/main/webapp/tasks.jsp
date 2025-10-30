<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.upload_file_mvc.model.User"%>
<%@ page import="com.upload_file_mvc.model.UploadTask"%>
<%@ page import="com.upload_file_mvc.service.FileUploadService.TaskStats"%>
<%@ page import="java.util.List"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%
User user = (User) request.getAttribute("user");
if (user == null) {
    response.sendRedirect(request.getContextPath() + "/login");
    return;
}

@SuppressWarnings("unchecked")
List<UploadTask> tasks = (List<UploadTask>) request.getAttribute("tasks");
TaskStats stats = (TaskStats) request.getAttribute("stats");
Integer queueSize = (Integer) request.getAttribute("queueSize");
SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");

String successMsg = request.getParameter("success");
String errorMsg = request.getParameter("error");
String warningMsg = request.getParameter("warning");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Upload Tasks - Upload File MVC</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background: #f5f7fa; }
        .container { max-width: 1200px; margin: 0 auto; padding: 20px; }
        
        /* Stats Cards */
        .stats-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 20px; margin: 20px 0; }
        .stat-card { background: white; padding: 20px; border-radius: 10px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); text-align: center; }
        .stat-card h3 { font-size: 32px; margin-bottom: 5px; }
        .stat-card p { color: #666; font-size: 14px; }
        .stat-card.pending { border-left: 4px solid #ffa500; }
        .stat-card.processing { border-left: 4px solid #667eea; }
        .stat-card.completed { border-left: 4px solid #28a745; }
        .stat-card.failed { border-left: 4px solid #dc3545; }
        .stat-card.queue { border-left: 4px solid #17a2b8; }
        
        /* Tasks List */
        .tasks-header { display: flex; justify-content: space-between; align-items: center; margin: 30px 0 20px 0; }
        .tasks-header h2 { color: #333; }
        .refresh-btn { background: #667eea; color: white; border: none; padding: 10px 20px; border-radius: 5px; cursor: pointer; font-size: 14px; }
        .refresh-btn:hover { background: #5568d3; }
        
        .task-card { background: white; padding: 20px; border-radius: 10px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); margin-bottom: 15px; }
        .task-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 15px; }
        .task-info h3 { font-size: 18px; color: #333; margin-bottom: 5px; }
        .task-info .meta { color: #666; font-size: 13px; }
        
        .badge { padding: 5px 12px; border-radius: 20px; font-size: 12px; font-weight: 600; }
        .badge.PENDING { background: #fff3cd; color: #856404; }
        .badge.PROCESSING { background: #cfe2ff; color: #084298; }
        .badge.COMPLETED { background: #d1e7dd; color: #0a3622; }
        .badge.FAILED { background: #f8d7da; color: #842029; }
        
        /* Progress Bar */
        .progress-container { margin: 15px 0; }
        .progress-bar { background: #e9ecef; height: 30px; border-radius: 15px; overflow: hidden; position: relative; }
        .progress-fill { background: linear-gradient(90deg, #667eea 0%, #764ba2 100%); height: 100%; transition: width 0.3s ease; display: flex; align-items: center; justify-content: center; color: white; font-weight: 600; font-size: 14px; }
        .progress-fill.failed { background: #dc3545; }
        .progress-fill.completed { background: #28a745; }
        
        /* Task Actions */
        .task-actions { display: flex; gap: 10px; margin-top: 15px; }
        .btn { padding: 8px 16px; border: none; border-radius: 5px; cursor: pointer; font-size: 14px; text-decoration: none; display: inline-block; }
        .btn-primary { background: #667eea; color: white; }
        .btn-primary:hover { background: #5568d3; }
        .btn-success { background: #28a745; color: white; }
        .btn-success:hover { background: #218838; }
        
        /* Empty State */
        .empty-state { text-align: center; padding: 60px 20px; background: white; border-radius: 10px; margin: 20px 0; }
        .empty-state-icon { font-size: 64px; margin-bottom: 20px; }
        .empty-state h3 { color: #333; margin-bottom: 10px; }
        .empty-state p { color: #666; margin-bottom: 20px; }
        
        /* Auto-refresh indicator */
        .auto-refresh { background: #d1e7dd; color: #0a3622; padding: 10px 20px; border-radius: 5px; margin: 20px 0; text-align: center; font-size: 14px; }
    </style>
</head>
<body>
    <%@ include file="/WEB-INF/includes/navbar.jsp" %>
    
    <div class="container">
        <h1 style="margin: 20px 0; color: #333;">&#128202; My Upload Tasks</h1>
        
        <%@ include file="/WEB-INF/includes/alerts.jsp" %>
        
        <!-- Statistics Cards -->
        <div class="stats-grid">
            <div class="stat-card pending">
                <h3><%= stats != null ? stats.pending : 0 %></h3>
                <p>Pending</p>
            </div>
            <div class="stat-card processing">
                <h3><%= stats != null ? stats.processing : 0 %></h3>
                <p>Processing</p>
            </div>
            <div class="stat-card completed">
                <h3><%= stats != null ? stats.completed : 0 %></h3>
                <p>Completed</p>
            </div>
            <div class="stat-card failed">
                <h3><%= stats != null ? stats.failed : 0 %></h3>
                <p>Failed</p>
            </div>
            <div class="stat-card queue">
                <h3><%= queueSize != null ? queueSize : 0 %></h3>
                <p>In Queue</p>
            </div>
        </div>
        
        <!-- Auto-refresh indicator -->
        <div class="auto-refresh">
            &#8635; Auto-refreshing every 2 seconds... <span id="lastUpdate"></span>
        </div>
        
        <!-- Tasks Header -->
        <div class="tasks-header">
            <h2>All Tasks (<%= tasks != null ? tasks.size() : 0 %>)</h2>
            <button class="refresh-btn" onclick="location.reload()">&#8635; Refresh Now</button>
        </div>
        
        <!-- Tasks List -->
        <% if (tasks == null || tasks.isEmpty()) { %>
            <div class="empty-state">
                <div class="empty-state-icon">&#128193;</div>
                <h3>No upload tasks yet</h3>
                <p>Upload files to see tasks here</p>
                <a href="<%= request.getContextPath() %>/files" class="btn btn-primary">Go to Upload</a>
            </div>
        <% } else { %>
            <% for (UploadTask task : tasks) { %>
                <div class="task-card" data-task-id="<%= task.getId() %>">
                    <div class="task-header">
                        <div class="task-info">
                            <h3><%= task.getStatusIcon() %> <%= task.getFileName() %></h3>
                            <div class="meta">
                                Size: <%= task.getFormattedFileSize() %> | 
                                Created: <%= task.getCreatedAt() != null ? dateFormat.format(task.getCreatedAt()) : "N/A" %>
                                <% if (task.getCompletedAt() != null) { %>
                                    | Completed: <%= dateFormat.format(task.getCompletedAt()) %>
                                <% } %>
                            </div>
                        </div>
                        <span class="badge <%= task.getStatus() %>"><%= task.getStatus() %></span>
                    </div>
                    
                    <!-- Progress Bar -->
                    <% if (task.isPending() || task.isProcessing()) { %>
                        <div class="progress-container">
                            <div class="progress-bar">
                                <div class="progress-fill" data-progress="<%= task.getProgress() %>">
                                    <%= task.getProgress() %>%
                                </div>
                            </div>
                        </div>
                    <% } %>
                    
                    <% if (task.isCompleted()) { %>
                        <div class="progress-container">
                            <div class="progress-bar">
                                <div class="progress-fill completed" style="width: 100%">
                                    &#10004; Completed
                                </div>
                            </div>
                        </div>
                    <% } %>
                    
                    <% if (task.isFailed()) { %>
                        <div class="progress-container">
                            <div class="progress-bar">
                                <div class="progress-fill failed" style="width: 100%">
                                    &#10008; Failed
                                </div>
                            </div>
                        </div>
                        <div style="color: #dc3545; margin-top: 10px; font-size: 14px;">
                            Error: <%= task.getErrorMessage() != null ? task.getErrorMessage() : "Unknown error" %>
                        </div>
                    <% } %>
                    
                    <!-- Actions -->
                    <% if (task.isCompleted() && task.getCloudinaryUrl() != null) { %>
                        <div class="task-actions">
                            <a href="<%= task.getCloudinaryUrl() %>" target="_blank" class="btn btn-primary">
                                &#128065; View File
                            </a>
                            <a href="<%= task.getCloudinaryUrl() %>" download class="btn btn-success">
                                &#8595; Download
                            </a>
                        </div>
                    <% } %>
                </div>
            <% } %>
        <% } %>
    </div>
    
    <script>
        // Auto-refresh every 2 seconds
        let refreshInterval;
        
        function startAutoRefresh() {
            updateLastUpdateTime();
            
            refreshInterval = setInterval(() => {
                // Check status of all tasks via AJAX
                const taskCards = document.querySelectorAll('.task-card[data-task-id]');
                
                taskCards.forEach(card => {
                    const taskId = card.dataset.taskId;
                    const badge = card.querySelector('.badge');
                    
                    // Only update if not completed or failed
                    if (badge && (badge.textContent === 'PENDING' || badge.textContent === 'PROCESSING')) {
                        fetch('<%= request.getContextPath() %>/api/task-status?taskId=' + taskId)
                            .then(r => r.json())
                            .then(task => {
                                updateTaskCard(card, task);
                                updateLastUpdateTime();
                            })
                            .catch(err => console.error('Error fetching task status:', err));
                    }
                });
                
                // Reload page if there are active tasks and some might have completed
                const hasActiveTasks = document.querySelectorAll('.badge.PROCESSING, .badge.PENDING').length > 0;
                if (hasActiveTasks) {
                    // Reload every 10 seconds to update stats
                    setTimeout(() => location.reload(), 10000);
                }
            }, 2000);
        }
        
        function updateTaskCard(card, task) {
            const badge = card.querySelector('.badge');
            const progressFill = card.querySelector('.progress-fill');
            
            if (badge) {
                badge.className = 'badge ' + task.status;
                badge.textContent = task.status;
            }
            
            if (progressFill) {
                progressFill.style.width = task.progress + '%';
                progressFill.textContent = task.progress + '%';
                
                if (task.status === 'COMPLETED') {
                    progressFill.className = 'progress-fill completed';
                    progressFill.textContent = '✓ Completed';
                } else if (task.status === 'FAILED') {
                    progressFill.className = 'progress-fill failed';
                    progressFill.textContent = '✗ Failed';
                }
            }
            
            // If completed, reload page to show download button
            if (task.status === 'COMPLETED' || task.status === 'FAILED') {
                setTimeout(() => location.reload(), 1000);
            }
        }
        
        function updateLastUpdateTime() {
            const now = new Date();
            const timeStr = now.toLocaleTimeString();
            const lastUpdate = document.getElementById('lastUpdate');
            if (lastUpdate) {
                lastUpdate.textContent = '(Last update: ' + timeStr + ')';
            }
        }
        
        // Set initial progress bar widths from data attributes
        document.querySelectorAll('.progress-fill[data-progress]').forEach(el => {
            el.style.width = el.dataset.progress + '%';
        });
        
        // Start auto-refresh on page load
        window.addEventListener('load', startAutoRefresh);
        
        // Stop auto-refresh when page is hidden
        document.addEventListener('visibilitychange', () => {
            if (document.hidden) {
                clearInterval(refreshInterval);
            } else {
                startAutoRefresh();
            }
        });
    </script>
</body>
</html>
