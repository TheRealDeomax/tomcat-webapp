<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    String currentTime = sdf.format(new Date());
    String timeZone = java.util.TimeZone.getDefault().getDisplayName();
%>
{
    "timestamp": "<%= currentTime %>",
    "timezone": "<%= timeZone %>",
    "epoch": <%= System.currentTimeMillis() %>,
    "message": "Current server time"
}
