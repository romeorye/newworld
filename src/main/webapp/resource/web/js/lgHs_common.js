var w_width = 0;
var w_height = 0;
// Elements Size Control
$(window).on('load', function(){
    $(window).resize(function () {
        w_height = $(window).height();
        w_width = $(window).width();
        var pageHead = $('.container').offset();
        var lnb_height = $('.page-navigation').offset();
        $('.container').css({'height':w_height - pageHead.top});
        $('.page-navigation').css('height', w_height - lnb_height.top);
        $('.page-left').hasClass('leftOpen') ? $('.container').css('width', (w_width - ($('.page-left').width())) + "px") : $('.container').css('width', (w_width) + "px");
    }).resize();
});
$(function () {

    // Header GNB
    $('.gnb-header .gnb li a').on('click', function(){
        $('.gnb-header .gnb li a').removeClass('select');
        $(this).addClass('select');
    })

    // List table even row color
    $('.listTable > table > tbody > tr:nth-child(odd)').addClass('even');

    // Page-left control
    /*$('.leftCon').on('click', function () {
        if ($('.page-left').hasClass('leftOpen')) {
            $('.page-left').animate({left: -211}, 300);
            $('.page-content').animate({left: 0}, 300);
            $('.page-left').removeClass('leftOpen');
            $('.container').animate({width: w_width}, 300);
        } else {
            $('.page-left').animate({left: 0}, 300);
            $('.page-content').animate({left: 211}, 300);
            $('.page-left').addClass('leftOpen');
            $('.container').animate({width: (w_width - ($('.page-left').width()))}, 300);
        }
    });*/
    $('.leftCon').on('click', function () {
        parent.setMenuFrame();
    });


    // Search toggle
    var searhButton = '';
        searhButton += '<div class="search-toggleBtn">';
        searhButton +=   '<button type="button" class="btn btn-default">';
        searhButton +=       '<span>Fold</span>';
        searhButton +=   '</button>';
        searhButton += '</div>';
    $('form[name="aform"] table').each(function(){
        var searchTr = $(this).children().find('tr');
        if(searchTr.length > 2) {
            searchTr.eq(1).addClass('display-row');
            $(this).parent().append(searhButton);
        };
        if($(this).hasClass('in') == true) {
               searchTr.eq(1).removeClass('display-row');
               $('.search-toggleBtn').addClass('spread');
            };
        $('.search-toggleBtn').on('click', function(){
            if(searchTr.eq(2).css('display') == 'none') {
               searchTr.eq(1).removeClass('display-row');
               $(this).addClass('spread');
            } else{
                searchTr.eq(1).addClass('display-row');
                $(this).removeClass('spread');
            }
        });
    });

    //Accordion
    $('.accordion > [data-toggle="collapse"] > a').each(function(){
        if($(this).parent().next().hasClass('in') == false){
            $(this).addClass('rotate180');
        }
        $(this).on('click', function(){
            $(this).toggleClass('rotate180');
        });
    });

    // Tooltip
    $('[data-toggle="tooltip"]').tooltip();


    // Checkbox check all
    $('.listTable thead th input[type="checkbox"]').on('click', function () {
        var chk = $(this).parents('.table').find('tbody td:first-child input[type="checkbox"]');
        this.checked ? chk.each(function () {this.checked = true;}) : chk.each(function(){ this.checked = false; });
    });

    // File attach
    $('input[type="file"]').on('change', function () {
        $('input[type="file"').parents('.inline-data').find('input[type="text"]').val(this.value.split(/(\\|\/)/g).pop());
    });

    // LNB
    var lnb = {
        click : function (target){
            $(target).each(function(){
                if($(this).next().html() == undefined){
                    $(this).addClass('finalDepth');
                }
            })

            $(target).on('click', function(i){
                var $depthTarget = $(this).next(),
                    $siblings = $(this).parent().siblings();

                $siblings.find('ul').slideUp();
                $('.lnb > li > a').removeClass('select');
                $siblings.find('a').removeClass('select');
                $(target).removeClass('color');
                $(this).addClass('select');

                if($(this).next().html() == undefined){
                    $(this).addClass('color');
                }

                if($depthTarget.css('display') == 'none'){
                    $(this).addClass('select');
                    $depthTarget.slideDown();
                } else{
                    $depthTarget.not(':animated').slideUp();
                    $(this).removeClass('select');
                }
            });
        },
    };
    lnb.click('.lnb li a');
});

// Tree toggle all
function toggleTree(em, id) {
    var tree = id;
    $(tree).toggleClass('openedAll');
    if($(tree).hasClass('openedAll')) {
        $(tree).jstree('open_all');
        $(em).text('- All');
    } else {
        $(tree).jstree('close_all');
        $(em).text('+ All');
    };
}


