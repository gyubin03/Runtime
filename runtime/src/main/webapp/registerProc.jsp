<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    request.setCharacterEncoding("UTF-8");

    String id = request.getParameter("id");
    String pw = request.getParameter("pw");
    String pwConfirm = request.getParameter("pwConfirm");
    String name = request.getParameter("name");

    // 비밀번호 확인 체크
    if (!pw.equals(pwConfirm)) {
        out.println("<script>alert('비밀번호가 일치하지 않습니다.'); history.back();</script>");
        return;
    }

    // DB 연결 및 중복 아이디 체크
    boolean isDuplicate = false;

    /*
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        Class.forName("oracle.jdbc.driver.OracleDriver");
        conn = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe", "username", "password");

        // 아이디 중복 확인
        String checkSql = "SELECT id FROM member WHERE id = ?";
        pstmt = conn.prepareStatement(checkSql);
        pstmt.setString(1, id);
        rs = pstmt.executeQuery();

        if (rs.next()) {
            isDuplicate = true;
        }

        if (!isDuplicate) {
            rs.close();
            pstmt.close();

            String insertSql = "INSERT INTO member (id, pw, name) VALUES (?, ?, ?)";
            pstmt = conn.prepareStatement(insertSql);
            pstmt.setString(1, id);
            pstmt.setString(2, pw);
            pstmt.setString(3, name);
            pstmt.executeUpdate();
        }

    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        try { if (rs != null) rs.close(); } catch (Exception e) {}
        try { if (pstmt != null) pstmt.close(); } catch (Exception e) {}
        try { if (conn != null) conn.close(); } catch (Exception e) {}
    }
    */

    if (isDuplicate) {
        response.sendRedirect("register.jsp?idError=duplicate");
        return;
    }

    // 회원가입 성공 시 로그인 페이지로 이동
    response.sendRedirect("login.jsp");
%>
