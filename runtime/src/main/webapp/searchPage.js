const API_KEY = "145fdcc5c38edb0b087b81fd23472d56";
const TMDB_KEY = "6f7ffff3b12d1b29c674646d8f0258db";

let currentTab = "nowShowing"; // nowShowing | comingSoon
let currentSort = "title";     // title | audience | release
let currentKeyword = "";

const mainContainer = document.getElementById("main-container");
const btnNowShowing = document.getElementById("btnNowShowing");
const btnComingSoon = document.getElementById("btnComingSoon");
const searchInput = document.getElementById("search-input");
const searchBtn = document.getElementById("search-btn");
const sortButtons = document.querySelectorAll("#sort-buttons .sort-btn");
const sortReleaseBtn = document.getElementById("sort-release");

function formatDate(date) {
  let y = date.getFullYear();
  let m = (date.getMonth() + 1).toString().padStart(2, "0");
  let d = date.getDate().toString().padStart(2, "0");
  return `${y}${m}${d}`;
}

async function fetchNowShowing() {
  let targetDt = formatDate(new Date(Date.now() - 86400000));
  const itemPerPage = 50; // 필요에 따라 조정
  let allMovies = [];
  let pageNo = 1;

  while (true) {
    const url = `http://www.kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json?key=${API_KEY}&targetDt=${targetDt}&itemPerPage=${itemPerPage}&pageNo=${pageNo}`;
    try {
      const res = await fetch(url);
      const data = await res.json();
      const list = data.boxOfficeResult?.dailyBoxOfficeList || [];
      if (list.length === 0) break;
      allMovies = allMovies.concat(list);
      if (list.length < itemPerPage) break;
      pageNo++;
    } catch (e) {
      console.error(e);
      break;
    }
  }
  return allMovies;
}

async function fetchMovieDetails(title) {
  try {
    const url = `https://api.themoviedb.org/3/search/movie?api_key=${TMDB_KEY}&query=${encodeURIComponent(title)}&language=ko-KR`;
    const res = await fetch(url);
    const data = await res.json();
    if (data.results && data.results.length > 0) {
      const movie = data.results[0];
      return {
        poster: movie.poster_path ? `https://image.tmdb.org/t/p/w500${movie.poster_path}` : "https://via.placeholder.com/320x460?text=No+Image",
        synopsis: movie.overview || "시놉시스 정보 없음",
        releaseDate: movie.release_date || "",
      };
    }
  } catch (e) {
    console.error(e);
  }
  return {
    poster: "https://via.placeholder.com/320x460?text=No+Image",
    synopsis: "시놉시스 정보 없음",
    releaseDate: "",
  };
}

async function fetchComingSoon() {
  const itemPerPage = 20;
  let allMovies = [];
  let page = 1;

  while (true) {
    try {
      const url = `https://api.themoviedb.org/3/movie/upcoming?api_key=${TMDB_KEY}&language=ko-KR&page=${page}&region=KR`;
      const res = await fetch(url);
      const data = await res.json();
      if (!data.results || data.results.length === 0) break;
      allMovies = allMovies.concat(data.results);
      if (data.results.length < itemPerPage) break;
      page++;
    } catch (e) {
      console.error(e);
      break;
    }
  }
  return allMovies;
}

async function renderMovies() {
  mainContainer.innerHTML = "";
  let movies = [];

  if (currentTab === "nowShowing") {
    movies = await fetchNowShowing();

    for (let i = 0; i < movies.length; i++) {
      const details = await fetchMovieDetails(movies[i].movieNm);
      movies[i].poster = details.poster;
      movies[i].synopsis = details.synopsis;
      movies[i].releaseDate = details.releaseDate;
    }

    if (currentKeyword) {
      movies = movies.filter(m => m.movieNm.toLowerCase().includes(currentKeyword.toLowerCase()));
    }

    if (currentSort === "title") {
      movies.sort((a, b) => a.movieNm.localeCompare(b.movieNm));
    } else if (currentSort === "audience") {
      movies.sort((a, b) => parseInt(b.audiAcc) - parseInt(a.audiAcc));
    }
  } else {
    movies = await fetchComingSoon();

    if (currentKeyword) {
      movies = movies.filter(m => m.title.toLowerCase().includes(currentKeyword.toLowerCase()));
    }

    if (currentSort === "title") {
      movies.sort((a, b) => a.title.localeCompare(b.title));
    } else if (currentSort === "release") {
      movies.sort((a, b) => new Date(a.release_date) - new Date(b.release_date));
    }
  }

  for (const movie of movies) {
    const card = document.createElement("div");
    card.className = "poster-card";

    let title = currentTab === "nowShowing" ? movie.movieNm : movie.title;
    let poster = currentTab === "nowShowing" ? movie.poster : (movie.poster_path ? `https://image.tmdb.org/t/p/w500${movie.poster_path}` : "https://via.placeholder.com/320x460?text=No+Image");
    let synopsis = currentTab === "nowShowing" ? movie.synopsis : (movie.overview || "시놉시스 정보 없음");

    card.innerHTML = `
      <div class="poster-title">${title}</div>
      <div class="poster-img"><img src="${poster}" alt="포스터" class="real-poster-img"></div>
      <div class="poster-synopsis">${synopsis}</div>
    `;

    mainContainer.appendChild(card);
  }
}

function updateUI() {
  btnNowShowing.classList.toggle("active", currentTab === "nowShowing");
  btnComingSoon.classList.toggle("active", currentTab === "comingSoon");

  if (currentTab === "nowShowing") {
    sortReleaseBtn.style.display = "none";
    document.getElementById("sort-title").style.display = "inline-block";
    document.getElementById("sort-audience").style.display = "inline-block";
  } else {
    sortReleaseBtn.style.display = "inline-block";
    document.getElementById("sort-title").style.display = "inline-block";
    document.getElementById("sort-audience").style.display = "none";

    if (currentSort !== "title" && currentSort !== "release") {
      currentSort = "title";
    }
  }

  sortButtons.forEach(btn => {
    btn.classList.toggle("active", btn.dataset.sort === currentSort);
  });
}

btnNowShowing.addEventListener("click", async () => {
  if (currentTab !== "nowShowing") {
    currentTab = "nowShowing";
    currentSort = "title"; // 기본 가나다순
    currentKeyword = "";
    searchInput.value = "";
    updateUI();
    await renderMovies();
  }
});

btnComingSoon.addEventListener("click", async () => {
  if (currentTab !== "comingSoon") {
    currentTab = "comingSoon";
    currentSort = "title"; // 기본 가나다순
    currentKeyword = "";
    searchInput.value = "";
    updateUI();
    await renderMovies();
  }
});

searchBtn.addEventListener("click", async () => {
  currentKeyword = searchInput.value.trim();
  await renderMovies();
});

sortButtons.forEach(btn => {
  btn.addEventListener("click", async () => {
    if (btn.dataset.sort !== currentSort) {
      currentSort = btn.dataset.sort;
      updateUI();
      await renderMovies();
    }
  });
});

window.addEventListener("DOMContentLoaded", async () => {
  updateUI();
  await renderMovies();
});
searchInput.addEventListener("keydown", async (e) => {
  if (e.key === "Enter") {
    currentKeyword = searchInput.value.trim();
    await renderMovies();
  }
});

