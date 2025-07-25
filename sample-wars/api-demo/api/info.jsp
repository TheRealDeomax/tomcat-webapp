<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.net.InetAddress" %>
<%
    Runtime runtime = Runtime.getRuntime();
    long totalMemory = runtime.totalMemory() / 1024 / 1024;
    long freeMemory = runtime.freeMemory() / 1024 / 1024;
    long usedMemory = totalMemory - freeMemory;
    String hostname = InetAddress.getLocalHost().getHostName();
%>
{
    "server": {
        "info": "<%= application.getServerInfo() %>",
        "hostname": "<%= hostname %>",
        "servlet_version": "<%= application.getMajorVersion() %>.<%= application.getMinorVersion() %>"
    },
    "java": {
        "version": "<%= System.getProperty("java.version") %>",
        "vendor": "<%= System.getProperty("java.vendor") %>"
    },
    "system": {
        "os": "<%= System.getProperty("os.name") %>",
        "arch": "<%= System.getProperty("os.arch") %>",
        "processors": <%= Runtime.getRuntime().availableProcessors() %>
    },
    "memory": {
        "total_mb": <%= totalMemory %>,
        "used_mb": <%= usedMemory %>,
        "free_mb": <%= freeMemory %>
    }
}
