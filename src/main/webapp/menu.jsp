<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    // 현재 메뉴 정보를 받아서 액티브 표시 (파라미터나 변수 활용)
    String activeMenu = request.getParameter("menu");
    if (activeMenu == null) activeMenu = "";
%>
<div class="menu-bar">
    <a href="movie.jsp?menu=movie" class="menu-btn <%= "movie".equals(activeMenu) ? "active" : "" %>">영화</a>
    <a href="movieSoon.jsp?menu=movieSoon" class="menu-btn <%= "movieSoon".equals(activeMenu) ? "active" : "" %>">상영 예정</a>
    <a href="event.jsp?menu=event" class="menu-btn <%= "event".equals(activeMenu) ? "active" : "" %>">이벤트</a>
    <a href="searchPage.jsp?menu=searchPage" class="menu-btn <%= "searchPage".equals(activeMenu) ? "active" : "" %>">영화검색</a>
</div>
