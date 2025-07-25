<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Enumeration" %>
{
    "request_headers": {
<%
    Enumeration<String> headerNames = request.getHeaderNames();
    boolean first = true;
    while(headerNames.hasMoreElements()) {
        String headerName = headerNames.nextElement();
        String headerValue = request.getHeader(headerName);
        if (!first) out.print(",");
%>
        "<%= headerName %>": "<%= headerValue.replace("\"", "\\\"") %>"
<%
        first = false;
    }
%>
    },
    "request_info": {
        "method": "<%= request.getMethod() %>",
        "uri": "<%= request.getRequestURI() %>",
        "protocol": "<%= request.getProtocol() %>",
        "remote_addr": "<%= request.getRemoteAddr() %>",
        "remote_host": "<%= request.getRemoteHost() %>",
        "server_name": "<%= request.getServerName() %>",
        "server_port": <%= request.getServerPort() %>
    }
}
