<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Random" %>
<%
    Random random = new Random();
    int randomNumber = random.nextInt(1000);
    double randomDouble = random.nextDouble();
    boolean randomBoolean = random.nextBoolean();
%>
{
    "random_integer": <%= randomNumber %>,
    "random_decimal": <%= randomDouble %>,
    "random_boolean": <%= randomBoolean %>,
    "range_1_to_100": <%= random.nextInt(100) + 1 %>,
    "uuid": "<%= java.util.UUID.randomUUID().toString() %>",
    "generated_at": "<%= new java.util.Date() %>"
}
