$(function() {
    function fetchEvents() {
        var theater = $('#theater-btns .event-btn.active').data('theater');
        var search = $('#search').val();
        var status = $('.event-btn[data-status].active').data('status') || "진행중";
        $.get('event_list_ajax.jsp', {
            theater: theater,
            search: search,
            status: status
        }, function(html) {
            $('#event-grid').html(html);
        });
    }

    // 극장 버튼 클릭
    $('#theater-btns .event-btn').on('click', function(){
        $('#theater-btns .event-btn').removeClass('active');
        $(this).addClass('active');
        fetchEvents();
    });

    // 검색버튼 클릭
    $('#search-btn').on('click', function(e){
        e.preventDefault();
        fetchEvents();
    });

    // 상태 버튼(진행중/종료)
    $('.event-btn[data-status]').on('click', function(){
        $('.event-btn[data-status]').removeClass('active');
        $(this).addClass('active');
        fetchEvents();
    });

    // 엔터로 검색
    $('#search').on('keydown', function(e){
        if(e.keyCode === 13) {
            e.preventDefault();
            fetchEvents();
        }
    });

    // 페이지 로딩시 최초 한 번 불러오기
    fetchEvents();
});
