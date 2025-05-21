<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.io.*, java.net.*, org.json.*, java.util.*" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8" />
    <title>영화 검색 페이지</title>
    <link rel="stylesheet" href="searchPage.css">
</head>
<body>

<%@ include file="./header.jsp" %>
<%@ include file="./menu.jsp" %>

<div class="content">

    <div class="sub-container" id="filter-buttons" style="margin-bottom:20px;">
        <button id="btnNowShowing" class="filter-btn active">상영중인 작품</button>
        <button id="btnComingSoon" class="filter-btn">상영예정 작품</button>
    </div>

    <div class="sub-container" id="search-sort-container" style="margin-bottom:30px; gap: 12px; align-items: center;">
        <input type="text" id="search-input" placeholder="영화명 검색" class="search-box" />
        <button id="search-btn" class="search-btn">검색</button>

        <div id="sort-buttons" style="margin-left:auto;">
            <button class="sort-btn active" data-sort="title" id="sort-title">가나다순</button>
            <button class="sort-btn" data-sort="audience" id="sort-audience">관람객순</button>
            <button class="sort-btn" data-sort="release" id="sort-release" style="display:none;">출시일순</button>
        </div>
    </div>

    <div id="main-container" class="main-container">
        <!-- 영화 카드가 JS로 동적 생성됩니다 -->
    </div>

</div>

<%@ include file="./footer.jsp" %>

<%
    String apiKey = "145fdcc5c38edb0b087b81fd23472d56";
    java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyyMMdd");
    Calendar cal = Calendar.getInstance();
    cal.add(Calendar.DATE, -1);
    String targetDt = sdf.format(cal.getTime());

    int pageNo = 1;
    int itemPerPage = 10;
    int maxPage = 3; // 최대 3페이지만 호출
    List<JSONObject> allMovies = new ArrayList<>();

    while(true) {
        if(pageNo > maxPage) break;

        String apiUrl = "http://www.kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json"
            + "?key=" + apiKey
            + "&targetDt=" + targetDt
            + "&itemPerPage=" + itemPerPage
            + "&pageNo=" + pageNo;

        URL url = new URL(apiUrl);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("GET");

        int responseCode = conn.getResponseCode();
        if(responseCode != 200) {
            break;
        }

        BufferedReader in = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"));
        String inputLine;
        StringBuilder content = new StringBuilder();
        while ((inputLine = in.readLine()) != null) content.append(inputLine);
        in.close();
        conn.disconnect();

        JSONObject json = new JSONObject(content.toString());
        JSONArray movieList = json.getJSONObject("boxOfficeResult").getJSONArray("dailyBoxOfficeList");

        for(int i=0; i<movieList.length(); i++) {
            allMovies.add(movieList.getJSONObject(i));
        }

        if(movieList.length() < itemPerPage) {
            break;
        }
        pageNo++;
    }
%>

<script src="searchPage.js"></script>

</body>
</html>
