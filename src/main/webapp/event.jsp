<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>이벤트</title>
    <link rel="stylesheet" href="style.css">
    <style>
        .sub-container { margin: 24px auto; display: flex; gap: 18px; width: 80%; }
        .event-btn { padding: 10px 30px; border: 1px solid #888; border-radius: 7px; background: #ccc; font-size: 18px; cursor: pointer; }
        .event-btn.active { background: #888; color: #fff; }
        .search-box { flex: 1; display: flex; align-items: center; gap: 8px; }
        .event-grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 40px; width: 80%; margin: 40px auto 0 auto; }
        .event-card { background: #19647e; display: flex; flex-direction: column; }
        .event-thumb { height: 230px; display: flex; align-items: center; justify-content: center; color: #fff; font-size: 22px; }
        .event-title { background: #ddd; text-align: center; font-size: 18px; padding: 13px 0; }
    </style>
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script src="event.js"></script>
</head>
<body>
<%@ include file="./header.jsp" %>
<%@ include file="./menu.jsp" %>

<div class="sub-container">
    <div id="theater-btns" style="display:flex;gap:10px;">
        <button type="button" class="event-btn active" data-theater="CGV">CGV</button>
        <button type="button" class="event-btn" data-theater="롯데시네마">롯데시네마</button>
        <button type="button" class="event-btn" data-theater="메가박스">메가박스</button>
    </div>
    <div class="search-box">
        <input type="text" id="search" placeholder="이벤트명 검색" style="flex:1;padding:7px;font-size:16px;">
        <button id="search-btn" class="event-btn">검색</button>
    </div>
    <div style="display:flex;gap:10px;">
        <button type="button" id="status-progress" class="event-btn active" data-status="진행중">진행중 이벤트</button>
        <button type="button" id="status-end" class="event-btn" data-status="종료">종료된 이벤트</button>
    </div>
</div>


<div id="event-grid" class="event-grid">
    <!-- ajax로 로딩됨 -->
</div>

<%@ include file="./footer.jsp" %>
</body>
</html>
