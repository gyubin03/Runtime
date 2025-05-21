<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>

<%
    // 1. 파라미터로부터 입력받은 아이디와 비밀번호 가져오기
    String userId = request.getParameter("userId");
    String userPwd = request.getParameter("userPwd");

    // 2. DB 연결 정보 (주석 처리)
    /*
    String jdbcDriver = "oracle.jdbc.driver.OracleDriver";
    String dbUrl = "jdbc:oracle:thin:@localhost:1521:xe";
    String dbUser = "your_db_user";
    String dbPass = "your_db_password";
    */

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        // 3. JDBC 드라이버 로드 (주석)
        // Class.forName(jdbcDriver);

        // 4. DB 연결 (주석)
        // conn = DriverManager.getConnection(dbUrl, dbUser, dbPass);

        // 5. 로그인 확인 쿼리 (userId, userPwd에 맞는 사용자 조회)
        String sql = "SELECT name FROM members WHERE user_id = ? AND user_pwd = ?";

        // pstmt = conn.prepareStatement(sql);
        // pstmt.setString(1, userId);
        // pstmt.setString(2, userPwd);

        // rs = pstmt.executeQuery();

        // 6. 결과 확인
        if (/*rs.next()*/ true) {  // true는 테스트용, 실제론 rs.next()로 변경
            // String userName = rs.getString("name");
            String userName = "이해진";  // 테스트용 값

            // 7. 로그인 성공 시 세션에 사용자 이름 저장
            session.setAttribute("userName", userName);

            // 8. 로그인 성공 후 메인 페이지 이동
            response.sendRedirect("index.jsp");
        } else {
            // 로그인 실패 시 로그인 페이지로 다시 이동
            response.sendRedirect("login.jsp?error=1");
        }
    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect("login.jsp?error=2");
    } finally {
        // 9. 자원 해제 (주석)
        /*
        if (rs != null) try { rs.close(); } catch(Exception e) {}
        if (pstmt != null) try { pstmt.close(); } catch(Exception e) {}
        if (conn != null) try { conn.close(); } catch(Exception e) {}
        */
    }
%>
