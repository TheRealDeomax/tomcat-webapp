<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="javax.servlet.http.Part" %>
<%@ page import="java.util.Collection" %>
<%@ page import="java.io.IOException" %>
<%@ page import="java.io.InputStream" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Upload Results</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; background-color: #f5f5f5; }
        .container { background: white; padding: 30px; border-radius: 10px; box-shadow: 0 4px 6px rgba(0,0,0,0.1); }
        .success { background: #d4edda; color: #155724; padding: 15px; border-radius: 5px; margin: 10px 0; }
        .error { background: #f8d7da; color: #721c24; padding: 15px; border-radius: 5px; margin: 10px 0; }
        .file-result { background: #f8f9fa; padding: 15px; margin: 10px 0; border-radius: 5px; border-left: 4px solid #007bff; }
        .back-btn { background: #6c757d; color: white; padding: 10px 20px; text-decoration: none; border-radius: 5px; }
        table { width: 100%; border-collapse: collapse; margin: 15px 0; }
        th, td { padding: 10px; text-align: left; border-bottom: 1px solid #ddd; }
        th { background-color: #007bff; color: white; }
    </style>
</head>
<body>
    <div class="container">
        <h1>📊 Upload Results</h1>
        
        <%
        try {
            Collection<Part> parts = request.getParts();
            
            if (parts.isEmpty()) {
        %>
                <div class="error">
                    <h3>❌ No files received</h3>
                    <p>Please select at least one file to upload.</p>
                </div>
        <%
            } else {
                int fileCount = 0;
                long totalSize = 0;
        %>
                <div class="success">
                    <h3>✅ Files processed successfully!</h3>
                    <p>The following files were received and processed:</p>
                </div>
                
                <table>
                    <tr>
                        <th>File Name</th>
                        <th>Content Type</th>
                        <th>Size (bytes)</th>
                        <th>Status</th>
                    </tr>
        <%
                for (Part part : parts) {
                    if (part.getSubmittedFileName() != null && !part.getSubmittedFileName().isEmpty()) {
                        fileCount++;
                        long size = part.getSize();
                        totalSize += size;
                        
                        String fileName = part.getSubmittedFileName();
                        String contentType = part.getContentType();
        %>
                    <tr>
                        <td><%= fileName %></td>
                        <td><%= contentType != null ? contentType : "Unknown" %></td>
                        <td><%= size %></td>
                        <td>✅ Processed</td>
                    </tr>
        <%
                        // Read first few bytes for demonstration
                        try (InputStream is = part.getInputStream()) {
                            byte[] buffer = new byte[Math.min(100, (int)size)];
                            int bytesRead = is.read(buffer);
        %>
                </table>
                
                <div class="file-result">
                    <h4>📄 File Content Preview: <%= fileName %></h4>
                    <p><strong>First <%= bytesRead %> bytes:</strong></p>
                    <pre style="background: #f1f3f4; padding: 10px; border-radius: 3px; overflow-x: auto;"><%
                        for (int i = 0; i < bytesRead; i++) {
                            byte b = buffer[i];
                            if (b >= 32 && b <= 126) {
                                out.print((char)b);
                            } else {
                                out.print(".");
                            }
                        }
                    %></pre>
                </div>
                
                <table>
        <%
                        } catch (IOException e) {
        %>
                    <tr>
                        <td colspan="4">Error reading file: <%= e.getMessage() %></td>
                    </tr>
        <%
                        }
                    }
                }
        %>
                </table>
                
                <div class="success">
                    <h3>📈 Summary</h3>
                    <p><strong>Total files processed:</strong> <%= fileCount %></p>
                    <p><strong>Total size:</strong> <%= totalSize %> bytes (<%= String.format("%.2f", totalSize / 1024.0 / 1024.0) %> MB)</p>
                    <p><strong>Processing time:</strong> <%= new java.util.Date() %></p>
                </div>
        <%
            }
        } catch (Exception e) {
        %>
            <div class="error">
                <h3>❌ Error processing upload</h3>
                <p><strong>Error:</strong> <%= e.getMessage() %></p>
                <p><strong>Type:</strong> <%= e.getClass().getSimpleName() %></p>
            </div>
        <%
        }
        %>
        
        <p style="margin-top: 30px;">
            <a href="index.html" class="back-btn">← Back to Upload</a>
        </p>
    </div>
</body>
</html>
