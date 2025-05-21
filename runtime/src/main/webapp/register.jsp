<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="header.jsp" %>
<%@ include file="menu.jsp" %>

<%
    String idError = request.getParameter("idError");
%>

<div class="form-container">
    <form action="registerProc.jsp" method="post" class="form-box">
        <h2>회원가입</h2>

        <input type="text" name="name" placeholder="이름" required />

        <input type="text" name="id" placeholder="아이디" required />
        <% if ("duplicate".equals(idError)) { %>
            <div style="color: red; font-size: 13px;">중복된 아이디입니다.</div>
        <% } %>

        <input type="password" name="pw" placeholder="비밀번호" required />
        <input type="password" name="pwConfirm" placeholder="비밀번호 확인" required />

        <button type="submit">가입하기</button>
    </form>
</div>

<%@ include file="footer.jsp" %>
