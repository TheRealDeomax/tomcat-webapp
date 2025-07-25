<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Date" %>
<%@ page import="java.util.Enumeration" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>JSP Test Page</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; background-color: #f5f5f5; }
        .container { background: white; padding: 30px; border-radius: 10px; box-shadow: 0 4px 6px rgba(0,0,0,0.1); }
        h1 { color: #333; }
        .info-section { margin: 20px 0; padding: 15px; background: #f8f9fa; border-radius: 5px; }
        table { width: 100%; border-collapse: collapse; margin: 10px 0; }
        th, td { padding: 8px; text-align: left; border-bottom: 1px solid #ddd; }
        th { background-color: #007bff; color: white; }
        .back-btn { background: #6c757d; color: white; padding: 10px 20px; text-decoration: none; border-radius: 5px; }
    </style>
</head>
<body>
    <div class="container">
        <h1>🔧 JSP Test Page</h1>
        
        <div class="info-section">
            <h3>📅 Server Information</h3>
            <p><strong>Current Date/Time:</strong> <%= new Date() %></p>
            <p><strong>Server Info:</strong> <%= application.getServerInfo() %></p>
            <p><strong>Servlet Version:</strong> <%= application.getMajorVersion() %>.<%= application.getMinorVersion() %></p>
        </div>
        
        <div class="info-section">
            <h3>🌐 Request Information</h3>
            <p><strong>Request Method:</strong> <%= request.getMethod() %></p>
            <p><strong>Request URI:</strong> <%= request.getRequestURI() %></p>
            <p><strong>Protocol:</strong> <%= request.getProtocol() %></p>
            <p><strong>Remote Address:</strong> <%= request.getRemoteAddr() %></p>
            <p><strong>Remote Host:</strong> <%= request.getRemoteHost() %></p>
        </div>
        
        <div class="info-section">
            <h3>📋 Request Headers</h3>
            <table>
                <tr><th>Header Name</th><th>Header Value</th></tr>
                <%
                Enumeration<String> headerNames = request.getHeaderNames();
                while(headerNames.hasMoreElements()) {
                    String headerName = headerNames.nextElement();
                    String headerValue = request.getHeader(headerName);
                %>
                <tr>
                    <td><%= headerName %></td>
                    <td><%= headerValue %></td>
                </tr>
                <% } %>
            </table>
        </div>
        
        <div class="info-section">
            <h3>⚙️ System Properties (Sample)</h3>
            <p><strong>Java Version:</strong> <%= System.getProperty("java.version") %></p>
            <p><strong>Operating System:</strong> <%= System.getProperty("os.name") %></p>
            <p><strong>JVM Memory:</strong> 
                Total: <%= Runtime.getRuntime().totalMemory() / 1024 / 1024 %> MB, 
                Free: <%= Runtime.getRuntime().freeMemory() / 1024 / 1024 %> MB
            </p>
        </div>
        
        <p style="margin-top: 30px;">
            <a href="index.html" class="back-btn">← Back to Home</a>
        </p>
    </div>
</body>
</html>
