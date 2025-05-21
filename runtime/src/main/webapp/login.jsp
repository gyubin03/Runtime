<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>로그인</title>
    <link rel="stylesheet" href="style.css" />
</head>
<body>
    <%@ include file="header.jsp" %>
    <%@ include file="menu.jsp" %>

    <div class="form-container">
        <form action="loginProc.jsp" method="post" class="form-box">
            <h2>로그인</h2>
            <input type="text" name="userId" placeholder="아이디" required />
            <input type="password" name="userPwd" placeholder="비밀번호" required />
            <button type="submit">로그인</button>
        </form>
    </div>

    <%@ include file="footer.jsp" %>
</body>
</html>
