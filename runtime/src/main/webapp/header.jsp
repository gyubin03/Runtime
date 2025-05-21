<%@ page contentType="text/html; charset=UTF-8" %>
<%
    String userName = (String)session.getAttribute("userName");
%>
<div class="header">
    <div class="user-info">
        <% if(userName != null) { %>
            <span><%= userName %>님</span>
            <a href="memberInfo.jsp">회원정보</a>
            <a href="logout.jsp">로그아웃</a>
        <% } else { %>
            <a href="login.jsp">로그인</a>
            <a href="register.jsp">회원가입</a>
        <% } %>
    </div>
</div>
