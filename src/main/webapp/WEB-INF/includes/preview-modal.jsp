<style>
.preview-modal{display:none;position:fixed;top:0;left:0;width:100%;height:100%;background:rgba(0,0,0,0.9);z-index:1000;justify-content:center;align-items:center;}
.preview-content{position:relative;max-width:90%;max-height:90%;background:white;border-radius:10px;padding:20px;}
.preview-close{position:absolute;top:-40px;right:0;background:white;border:none;font-size:36px;color:#333;cursor:pointer;width:40px;height:40px;border-radius:50%;display:flex;align-items:center;justify-content:center;}
.preview-close:hover{background:#f0f0f0;}
#previewMedia img,#previewMedia video{max-width:100%;max-height:80vh;border-radius:8px;}
</style>
<div class="preview-modal" id="previewModal">
    <div class="preview-content" id="previewContent">
        <button class="preview-close" onclick="closePreview()">×</button>
        <div id="previewMedia"></div>
    </div>
</div>
