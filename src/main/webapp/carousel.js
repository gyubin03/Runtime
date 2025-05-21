let currentIndex = 0;
const visibleCount = 3; // 한 번에 보여줄 포스터 개수

function showPosters() {
    const list = document.getElementById('poster-list');
    const posters = list.children;
    if (posters.length === 0) return;
    const cardWidth = posters[0].offsetWidth + 32; // 카드+gap
    list.style.transform = `translateX(-${currentIndex * cardWidth}px)`;
}

$(document).ready(function() {
    $('.carousel-arrow.left').click(function() {
        if (currentIndex > 0) {
            currentIndex--;
            showPosters();
        }
    });
    $('.carousel-arrow.right').click(function() {
        const posterList = document.getElementById('poster-list');
        const posters = posterList.children.length;
        if (currentIndex < posters - visibleCount) {
            currentIndex++;
            showPosters();
        }
    });
});
