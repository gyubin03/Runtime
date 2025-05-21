<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.io.*, java.net.*, org.json.*, java.util.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>상영 예정작 | 영화</title>
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
    // TMDb "상영 예정작" API (한국 기준, 페이지 1)
    String tmdbApiKey = "6f7ffff3b12d1b29c674646d8f0258db";
    String tmdbApiUrl = "https://api.themoviedb.org/3/movie/upcoming?api_key=" + tmdbApiKey + "&language=ko-KR&page=1&region=KR";

    URL url = new URL(tmdbApiUrl);
    HttpURLConnection conn = (HttpURLConnection) url.openConnection();
    conn.setRequestMethod("GET");
    BufferedReader in = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"));
    String inputLine;
    StringBuilder content = new StringBuilder();
    while ((inputLine = in.readLine()) != null) content.append(inputLine);
    in.close();
    conn.disconnect();

    JSONObject json = new JSONObject(content.toString());
    JSONArray results = json.has("results") ? json.getJSONArray("results") : new JSONArray();
%>
<script>
var MOVIE_SOONS = [
<%
    for (int i = 0; i < results.length(); i++) {
        JSONObject movie = results.getJSONObject(i);
        String title = movie.optString("title", "-");
        String releaseDate = movie.optString("release_date", "-");
        String overview = movie.optString("overview", "");
        String posterPath = movie.optString("poster_path", "");
%>
    {
        title: "<%=title.replace("\"", "\\\"")%>",
        releaseDate: "<%=releaseDate%>",
        overview: "<%=overview.replace("\"", "\\\"")%>",
        posterPath: "<%=posterPath%>"
    }<%= (i < results.length() - 1) ? "," : "" %>
<%
    }
%>
];
</script>

<%@ include file="./footer.jsp" %>
<script src="movieSoon.js"></script>
</body>
</html>
