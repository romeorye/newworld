
//layer popup
function layer_open(el) {
    $('#layer1, #layer2, #layer3').css('display', 'none'); //팝업 레이어 n개수
    var temp = $('#' + el);
    var bg = temp.parents('bg');
    if (bg) {
        $('.layer').fadeIn();
    } else {
        temp.fadeIn();
    }

    temp.css('display', 'block');
    if (temp.outerHeight() < $(document).height()) temp.css('margin-top', '-' + temp.outerHeight() / 2 + 'px');
    else temp.css('top', '0px');
    if (temp.outerWidth() < $(document).width()) temp.css('margin-left', '-' + temp.outerWidth() / 2 + 'px');
    else temp.css('left', '0px');

	$("body").attr("style", "overflow:hidden");

    temp.find('a.popClose , button.popClose').click(function (e) {
        if (bg) {
            $('.layer').fadeOut();
        } else {
            temp.fadeOut();
        }
        e.preventDefault();
        $("body").attr("style", "overflo-y:scroll");
    });
	
    //$('.layer .bg').click(function (e) {
    //    $('.layer').fadeOut();
    //    e.preventDefault();
    //    $("body").attr("style", "overflow-y:scroll");
    //});
};



//텝메뉴
$(function(){	
    $(".tab_content").hide();
    $(".tab_content:first").show();	
	
    $("ul.tabs li").click(function () {
        $("ul.tabs li").removeClass("tabs_on");
        $(this).addClass("tabs_on");
        $(".tab_content").hide();
        var activeTab = $(this).attr("rel");
        $("#" + activeTab).fadeIn();
    });	
});

$(function(){	
   $(".tab_content1").hide();
   $(".tab_content1:first").show();	
	
    $("ul.tabs1 li").click(function () {
        $("ul.tabs1 li").removeClass("tabs_on");
        $(this).addClass("tabs_on");
        $(".tab_content1").hide();
        var activeTab = $(this).attr("rel");
        $("#" + activeTab).fadeIn();
    });	
});


//아코디언
var allPanels = $('.accordion > dd').hide();

//$('.accordion > dd:first-of-type').show();
//$('.accordion > dt:first-of-type').addClass('accordion-active');
//$('.accordion > dd:last-of-type').show();
//$('.accordion > dt:last-of-type').addClass('accordion-active');

jQuery('.accordion > dt').on('click', function () {
	$this = $(this);
	$target = $this.next();
	if (!$this.hasClass('accordion-active')) {
		$this.parent().children('dd').hide(); //slideUp / hide
		jQuery('.accordion > dt').removeClass('accordion-active');
		$this.addClass('accordion-active');
		$target.addClass('active').show();	 //slideDown / show  
	}else{
		$this.parent().children('dd').hide(); //slideUp / hide
		 $('.accordion > dt').removeClass('accordion-active');
	}
	return false;
});


// 상단이동버튼
$(function () {
	$(window).scroll(function(){
		if($(this).scrollTop() > 0){
			$('.btnTop').fadeIn();
		}else{
			$('.btnTop').fadeOut();
		}
	});
	$('.btnTop').click(function () {
		$('html, body').animate({scrollTop: 0}, 450);
		return false;
	});
});

// 별점
$(function () {
	$( ".star_rating a" ).click(function() {
		 $(this).parent().children("a").removeClass("on");
		 $(this).addClass("on").prevAll("a").addClass("on");
		 return false;
	});
});




// 사이드 메뉴
/* var */
var windowScrollTopPosition;
var mask = ".bg_dimmed";
var lastScroll 		= $(window).scrollTop();
var headerMainCheck = true;

/* layout */
$(function(){

	// total menu 
	var $total 					= $(".nav");
	var $totalbtn 				= $(".js-btn-total");
	var $totalCloseBtn			= $total.find(".btn_close");
	
	$totalbtn.on("click",function(e){	
		
		//$("#container").removeAttr("style");
		
		if($total.css("left") != 0){			
			$total.css("left",0);
			$(mask).fadeIn();
		} else {			
			$total.css("left","-100%");
			$(mask).fadeOut();
		}
		//reset();
		
		bodyScrollStop();
		e.preventDefault();
	});
	
	$(mask).add($totalCloseBtn).on("click",function(e){
		$(mask).fadeOut();
		bodyScrollStart();		
		
		$total.css("left","-100%",function(){
			//reset();			
		});
		e.preventDefault();
	});

	
});


function bodyScrollStop(){	
	windowScrollTopPosition = $(window).scrollTop();	
	$("body").css({ "overflow" : "hidden" , "position" : "absolute" });
	$('.header').append('<div id="fade" onclick="close_fade_bg();"></div>');
	$('#fade').addClass('layer_bg').css('height', $(document).height()).css("z-index", 1);
}

function bodyScrollStart(){
	$("body").css({ "overflow" : "auto" , "position" : "static" });
	$('#fade').removeClass('layer_bg');
	$('#wrap').css("z-index", 1);
	$('#fade').remove();
	$(window).scrollTop(windowScrollTopPosition);
}

function close_fade_bg(){
	$(mask).fadeOut();
	bodyScrollStart();
	$(".nav").css("left","-100%",function(){
		//reset();
		//$(".nav").find("[data-event='tab']").tabpannel({activeIndex:0});
	});
	e.preventDefault();
}


$(function(){
	$("input").focus(function(){		
		$(".btnAbl").css("position", "static");
	});

	$("input").blur(function(){		
		$(".btnAbl").css("position", "absolute");
	});
});