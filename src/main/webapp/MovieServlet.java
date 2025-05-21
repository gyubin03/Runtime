<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.io.*, java.net.*, org.json.*, java.util.*" %>
<%
    // 오늘 날짜 구하기 (API는 어제날짜 추천)
    java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyyMMdd");
    Calendar cal = Calendar.getInstance();
    cal.add(Calendar.DATE, -1);
    String targetDt = sdf.format(cal.getTime());

    String key = "여기에_본인_API_KEY_입력"; // ← 본인 API키로 교체
    String urlStr = "http://www.kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json?key=" + key + "&targetDt=" + targetDt;
    URL url = new URL(urlStr);
    HttpURLConnection conn = (HttpURLConnection) url.openConnection();
    conn.setRequestMethod("GET");
    BufferedReader in = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"));
    String inputLine;
    StringBuilder content = new StringBuilder();
    while ((inputLine = in.readLine()) != null) {
        content.append(inputLine);
    }
    in.close();
    conn.disconnect();

    JSONObject json = new JSONObject(content.toString());
    JSONArray movieList = json.getJSONObject("boxOfficeResult").getJSONArray("dailyBoxOfficeList");
%>

<div class="poster-list" id="poster-list">
<%
    for (int i = 0; i < movieList.length(); i++) {
        JSONObject movie = movieList.getJSONObject(i);
        String movieNm = movie.getString("movieNm");
        String movieCd = movie.getString("movieCd");
        String openDt = movie.getString("openDt");
%>
    <div class="poster-card">
        <div class="poster-title"><%=movieNm%></div>
        <div class="poster-img">
            <!-- 실제 포스터 이미지 주소가 없으므로, 임시 이미지를 랜덤으로 사용 -->
            <img src="https://picsum.photos/320/460?random=<%=i%>" alt="포스터" class="real-poster-img"/>
        </div>
        <div class="cinema-radio-group" style="display: flex; justify-content:center; gap:16px; margin: 16px 0;">
            <label><input type="radio" name="cinema_<%=i%>" value="cgv" checked>CGV</label>
            <label><input type="radio" name="cinema_<%=i%>" value="lotte">롯데시네마</label>
            <label><input type="radio" name="cinema_<%=i%>" value="megabox">메가박스</label>
        </div>
        <button class="poster-book" 
            onclick="reserveMovie('<%=movieNm%>', <%=i%>)"
        >예매하기</button>
    </div>
<%
    }
%>
</div>
