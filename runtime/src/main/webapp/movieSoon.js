let startIdx = 0;
const VISIBLE = 3;
const PLACEHOLDER = "https://via.placeholder.com/320x460?text=No+Image";

function getPosterUrl(posterPath) {
    return posterPath ? "https://image.tmdb.org/t/p/w500" + posterPath : PLACEHOLDER;
}

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

function renderPosters() {
    var posterList = document.getElementById("poster-list");
    posterList.innerHTML = "";

    var len = MOVIE_SOONS.length;
    for (var i = 0; i < VISIBLE; i++) {
        var movieIdx = (startIdx + i) % len;
        var movie = MOVIE_SOONS[movieIdx];
        var posterUrl = getPosterUrl(movie.posterPath);

        posterList.innerHTML += 
            '<div class="poster-card">' +
                '<div class="poster-title">' + movie.title + '</div>' +
                '<div class="poster-img">' +
                    '<img src="' + posterUrl + '" alt="포스터" class="real-poster-img"/>' +
                '</div>' +
                '<div class="movie-release-date">개봉 예정: ' + movie.releaseDate + '</div>' +
                '<div class="movie-overview">' + (movie.overview || '설명이 없습니다.') + '</div>' +
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

window.addEventListener("DOMContentLoaded", function() {
    if (!Array.isArray(MOVIE_SOONS) || MOVIE_SOONS.length === 0) return;
    renderPosters();

    document.getElementById("arrow-left").addEventListener("click", function() {
        startIdx = (startIdx - 1 + MOVIE_SOONS.length) % MOVIE_SOONS.length;
        renderPosters();
    });
    document.getElementById("arrow-right").addEventListener("click", function() {
        startIdx = (startIdx + 1) % MOVIE_SOONS.length;
        renderPosters();
    });
});
