<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.File" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Uploaded Files</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; background-color: #f5f5f5; }
        .container { background: white; padding: 30px; border-radius: 10px; box-shadow: 0 4px 6px rgba(0,0,0,0.1); }
        .back-btn { background: #6c757d; color: white; padding: 10px 20px; text-decoration: none; border-radius: 5px; margin-right: 10px; }
        .delete-btn { background: #dc3545; color: white; padding: 5px 10px; text-decoration: none; border-radius: 3px; font-size: 12px; }
        .download-btn { background: #28a745; color: white; padding: 5px 10px; text-decoration: none; border-radius: 3px; font-size: 12px; margin-right: 5px; }
        table { width: 100%; border-collapse: collapse; margin: 15px 0; }
        th, td { padding: 10px; text-align: left; border-bottom: 1px solid #ddd; }
        th { background-color: #007bff; color: white; }
        .file-size { text-align: right; }
        .actions { text-align: center; }
        .empty-state { text-align: center; padding: 40px; color: #6c757d; }
    </style>
</head>
<body>
    <div class="container">
        <h1>📁 Uploaded Files</h1>
        <p><strong>Server Instance:</strong> <%= System.getProperty("server.instance", "unknown") %></p>
        <p><em>Files are shared across all server instances via shared volume.</em></p>
        
        <%
        String uploadPath = getServletContext().getRealPath("/uploads");
        File uploadDir = new File(uploadPath);
        
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }
        
        File[] files = uploadDir.listFiles();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        
        if (files == null || files.length == 0) {
        %>
            <div class="empty-state">
                <h3>📂 No files uploaded yet</h3>
                <p>Upload some files to see them listed here.</p>
            </div>
        <%
        } else {
        %>
            <p><strong>Upload directory:</strong> <%= uploadPath %></p>
            <p><strong>Total files:</strong> <%= files.length %></p>
            
            <table>
                <tr>
                    <th>File Name</th>
                    <th>Size</th>
                    <th>Last Modified</th>
                    <th>Actions</th>
                </tr>
        <%
            long totalSize = 0;
            for (File file : files) {
                if (file.isFile()) {
                    totalSize += file.length();
                    String fileName = file.getName();
                    long fileSize = file.length();
                    Date lastModified = new Date(file.lastModified());
        %>
                <tr>
                    <td><%= fileName %></td>
                    <td class="file-size"><%= String.format("%.2f KB", fileSize / 1024.0) %></td>
                    <td><%= sdf.format(lastModified) %></td>
                    <td class="actions">
                        <a href="uploads/<%= fileName %>" class="download-btn" target="_blank">📥 Download</a>
                        <a href="delete.jsp?file=<%= fileName %>" class="delete-btn" onclick="return confirm('Delete <%= fileName %>?')">🗑️ Delete</a>
                    </td>
                </tr>
        <%
                }
            }
        %>
            </table>
            
            <p><strong>Total storage used:</strong> <%= String.format("%.2f MB", totalSize / 1024.0 / 1024.0) %></p>
        <%
        }
        %>
        
        <p style="margin-top: 30px;">
            <a href="index.html" class="back-btn">📤 Upload More Files</a>
            <a href="/" class="back-btn">🏠 Home</a>
        </p>
    </div>
</body>
</html>
