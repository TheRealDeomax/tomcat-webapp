<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.File" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Delete File</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; background-color: #f5f5f5; }
        .container { background: white; padding: 30px; border-radius: 10px; box-shadow: 0 4px 6px rgba(0,0,0,0.1); }
        .success { background: #d4edda; color: #155724; padding: 15px; border-radius: 5px; margin: 10px 0; }
        .error { background: #f8d7da; color: #721c24; padding: 15px; border-radius: 5px; margin: 10px 0; }
        .back-btn { background: #6c757d; color: white; padding: 10px 20px; text-decoration: none; border-radius: 5px; }
    </style>
</head>
<body>
    <div class="container">
        <h1>🗑️ Delete File</h1>
        
        <%
        String fileName = request.getParameter("file");
        
        if (fileName == null || fileName.trim().isEmpty()) {
        %>
            <div class="error">
                <h3>❌ Error</h3>
                <p>No file specified for deletion.</p>
            </div>
        <%
        } else {
            // Security check - prevent directory traversal
            if (fileName.contains("..") || fileName.contains("/") || fileName.contains("\\")) {
        %>
                <div class="error">
                    <h3>❌ Security Error</h3>
                    <p>Invalid file name. File names cannot contain path separators.</p>
                </div>
        <%
            } else {
                String uploadPath = getServletContext().getRealPath("/uploads");
                File fileToDelete = new File(uploadPath, fileName);
                
                if (!fileToDelete.exists()) {
        %>
                    <div class="error">
                        <h3>❌ File Not Found</h3>
                        <p>The file "<%= fileName %>" does not exist.</p>
                    </div>
        <%
                } else {
                    boolean deleted = fileToDelete.delete();
                    
                    if (deleted) {
        %>
                        <div class="success">
                            <h3>✅ File Deleted Successfully</h3>
                            <p>The file "<%= fileName %>" has been deleted.</p>
                        </div>
        <%
                    } else {
        %>
                        <div class="error">
                            <h3>❌ Deletion Failed</h3>
                            <p>Could not delete the file "<%= fileName %>". The file may be in use or you may not have sufficient permissions.</p>
                        </div>
        <%
                    }
                }
            }
        }
        %>
        
        <p style="margin-top: 30px;">
            <a href="files.jsp" class="back-btn">📁 View Files</a>
            <a href="index.html" class="back-btn">📤 Upload Files</a>
        </p>
    </div>
</body>
</html>
