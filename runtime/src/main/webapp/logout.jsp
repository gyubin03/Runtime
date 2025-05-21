<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
    session.invalidate();
    response.sendRedirect("index.jsp"); // 로그아웃 후 메인 페이지 이동
%>
