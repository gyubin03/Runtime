<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.io.*, java.net.*, org.json.*, java.util.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>현재 상영작 | 영화</title>
    <link rel="stylesheet" href="poster.css">
    <link rel="stylesheet" href="style.css">
</head>
<body>
<%@ include file="./header.jsp" %>
<%@ include file="./menu.jsp" %>

<div class="main-container">

    <div style="display: flex; align-items: center; gap: 12px; width: 100%; justify-content: center;">
        <button class="carousel-arrow left" id="arrow-left">&#8592;</button>
        <div class="poster-list" id="poster-list"></div>
        <button class="carousel-arrow right" id="arrow-right">&#8594;</button>
    </div>

</div>



<%
    String apiKey = "145fdcc5c38edb0b087b81fd23472d56";
    java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyyMMdd");
    Calendar cal = Calendar.getInstance();
    cal.add(Calendar.DATE, -1);
    String targetDt = sdf.format(cal.getTime());

    String apiUrl = "http://www.kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json"
        + "?key=" + apiKey
        + "&targetDt=" + targetDt
        + "&itemPerPage=10";

    URL url = new URL(apiUrl);
    HttpURLConnection conn = (HttpURLConnection) url.openConnection();
    conn.setRequestMethod("GET");
    BufferedReader in = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"));
    String inputLine;
    StringBuilder content = new StringBuilder();
    while ((inputLine = in.readLine()) != null) content.append(inputLine);
    in.close();
    conn.disconnect();

    JSONObject json = new JSONObject(content.toString());
    JSONArray movieList = json.has("boxOfficeResult") ?
        json.getJSONObject("boxOfficeResult").getJSONArray("dailyBoxOfficeList") : new JSONArray();
%>
<script>
var MOVIES = [
<%
    for (int i = 0; i < movieList.length(); i++) {
        JSONObject movie = movieList.getJSONObject(i);
        String movieNm = movie.getString("movieNm");
        String rank = movie.optString("rank", "");
%>
    {
        rank: "<%=rank %>",
        movieNm: "<%=movieNm.replace("\"", "\\\"") %>"
    }<%= (i < movieList.length() - 1) ? "," : "" %>
<%
    }
%>
];
const TMDB_KEY = "6f7ffff3b12d1b29c674646d8f0258db";
</script>

<%@ include file="./footer.jsp" %>
<script src="movie.js"></script>
</body>
</html>
