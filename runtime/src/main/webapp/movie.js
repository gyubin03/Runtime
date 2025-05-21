let startIdx = 0;
const VISIBLE = 3;
const PLACEHOLDER = "https://via.placeholder.com/320x460?text=No+Image";

// TMDb에서 포스터 경로 불러오기
function fetchPoster(movieNm) {
    return fetch("https://api.themoviedb.org/3/search/movie?api_key=" + TMDB_KEY + "&query=" + encodeURIComponent(movieNm) + "&language=ko-KR")
      .then(function(res) { return res.json(); })
      .then(function(data) {
        if (data && data.results && data.results.length > 0 && data.results[0].poster_path) {
            return "https://image.tmdb.org/t/p/w500" + data.results[0].poster_path;
        } else {
            return PLACEHOLDER;
        }
      }).catch(function() {
        return PLACEHOLDER;
      });
}

// 한 줄에 들어가게 폰트 크기 자동 축소
function fitTextToOneLine(element, maxFontSize = 22, minFontSize = 12) {
    var fontSize = maxFontSize;
    element.style.fontSize = fontSize + "px";
    element.style.whiteSpace = "nowrap";
    element.style.overflow = "hidden";
    element.style.textOverflow = "ellipsis";
    while (element.scrollWidth > element.offsetWidth && fontSize > minFontSize) {
        fontSize -= 1;
        element.style.fontSize = fontSize + "px";
    }
}

// 캐러셀에 3개씩 포스터/라디오/예매버튼 그리기
async function renderPosters() {
    var posterList = document.getElementById("poster-list");
    posterList.innerHTML = "";

    var len = MOVIES.length;
    var promises = [];

    for (var i = 0; i < VISIBLE; i++) {
        var movieIdx = (startIdx + i) % len;
        var movie = MOVIES[movieIdx];
        promises.push(fetchPoster(movie.movieNm));
    }
    var posterUrls = await Promise.all(promises);

    for (var i = 0; i < VISIBLE; i++) {
        var movieIdx = (startIdx + i) % len;
        var movie = MOVIES[movieIdx];
        var posterUrl = posterUrls[i];

        posterList.innerHTML += 
            '<div class="poster-card">' +
                '<div class="poster-title">' + movie.rank + '. ' + movie.movieNm + '</div>' +
                '<div class="poster-img">' +
                    '<img src="' + posterUrl + '" alt="포스터" class="real-poster-img"/>' +
                '</div>' +
                '<div class="cinema-radio-group">' +
                    '<label><input type="radio" name="cinema_' + movieIdx + '" value="cgv" checked> CGV</label>' +
                    '<label><input type="radio" name="cinema_' + movieIdx + '" value="lotte"> 롯데시네마</label>' +
                    '<label><input type="radio" name="cinema_' + movieIdx + '" value="megabox"> 메가박스</label>' +
                '</div>' +
                '<button class="poster-book" onclick="reserveMovie(\'' + movie.movieNm.replace(/'/g, "\\'") + '\', ' + movieIdx + ')">예매하기</button>' +
            '</div>';
    }

    // 제목 한 줄 자동 축소
    setTimeout(function() {
        var titles = document.querySelectorAll('.poster-title');
        for (var i = 0; i < titles.length; i++) {
            fitTextToOneLine(titles[i], 22, 12);
        }
    }, 0);
}

// 예매 기능
function reserveMovie(movieName, idx) {
    var radios = document.getElementsByName("cinema_" + idx);
    var selected = null;
    for (var i = 0; i < radios.length; i++) {
        if (radios[i].checked) {
            selected = radios[i].value;
            break;
        }
    }
    if (!selected) {
        alert("극장을 선택하세요.");
        return;
    }
    var movieSearch = encodeURIComponent(movieName.trim());
    var url = "#";
    if (selected === "cgv") {
        url = "https://www.cgv.co.kr/movies/?search=" + movieSearch;
    } else if (selected === "lotte") {
        url = "https://www.lottecinema.co.kr/NLCHS/Movie/MovieDetailView?searchWord=" + movieSearch;
    } else if (selected === "megabox") {
        url = "https://www.megabox.co.kr/movie?searchText=" + movieSearch;
    }
    window.open(url, "_blank");
}

// 초기화 (순환 캐러셀 구조)
window.addEventListener("DOMContentLoaded", function() {
    if (!Array.isArray(MOVIES) || MOVIES.length === 0) return;
    renderPosters();

    document.getElementById("arrow-left").addEventListener("click", function() {
        startIdx = (startIdx - 1 + MOVIES.length) % MOVIES.length;
        renderPosters();
    });
    document.getElementById("arrow-right").addEventListener("click", function() {
        startIdx = (startIdx + 1) % MOVIES.length;
        renderPosters();
    });
});
