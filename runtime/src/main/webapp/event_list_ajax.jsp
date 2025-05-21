<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*, java.util.*" %>
<%
    String DB_URL = "jdbc:mysql://localhost:3306/your_db";
    String DB_USER = "your_user";
    String DB_PASS = "your_pw";
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    try {
        Class.forName("com.mysql.jdbc.Driver");
        conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);

        String sql = "SELECT * FROM events WHERE 1=1";
        List<String> params = new ArrayList<>();

        String theater = request.getParameter("theater");
        if (theater != null && !theater.trim().isEmpty()) {
            sql += " AND theater = ?";
            params.add(theater);
        }
        String status = request.getParameter("status");
        if (status != null && !status.trim().isEmpty()) {
            sql += " AND status = ?";
            params.add(status);
        } else {
            sql += " AND status = ?";
            params.add("진행중");
        }
        String search = request.getParameter("search");
        if (search != null && !search.trim().isEmpty()) {
            sql += " AND title LIKE ?";
            params.add("%" + search + "%");
        }
        sql += " ORDER BY id DESC LIMIT 32";

        pstmt = conn.prepareStatement(sql);
        for (int i = 0; i < params.size(); i++) {
            pstmt.setString(i+1, params.get(i));
        }
        rs = pstmt.executeQuery();
        boolean empty = true;
        while (rs.next()) {
            empty = false;
%>
    <div class="event-card">
        <div class="event-thumb">
            <% if (rs.getString("thumbnail") != null && !rs.getString("thumbnail").isEmpty()) { %>
                <img src="<%= rs.getString("thumbnail") %>" alt="이벤트 썸네일" style="width:100%;height:100%;object-fit:cover;">
            <% } else { %>
                이벤트 썸네일
            <% } %>
        </div>
        <div class="event-title"><%= rs.getString("title") %></div>
    </div>
<%
        }
        if (empty) {
%>
    <div style="grid-column: 1/-1;text-align:center;color:#888;font-size:20px;padding:50px 0;">
        해당 조건의 이벤트가 없습니다.
    </div>
<%
        }
    } catch (Exception e) {
%>
    <div style="grid-column: 1/-1;color:red;text-align:center">데이터베이스 오류: <%= e.getMessage() %></div>
<%
    } finally {
        if (rs != null) try { rs.close(); } catch (Exception e) {}
        if (pstmt != null) try { pstmt.close(); } catch (Exception e) {}
        if (conn != null) try { conn.close(); } catch (Exception e) {}
    }
%>
