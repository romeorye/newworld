/*$(".split_l").click(function () {
	var _this = $(this);
	var pth = $(this).find("img")[0];
	
	var $lnbFrame = parent.$("#frameSet");	

	
	if (!_this.hasClass("down")) {
		$lnbFrame.attr('cols', '30, *');
		$(".lnbArea").css("left", "-155px");
		$(".lnbMenuArea").css("display", "none");
		$(pth).attr("src", $(pth).attr("src").replace(/lnb_off./g, 'lnb_on.'));
		_this.addClass("down");
	}
	else {					
		$(pth).attr("src", $(pth).attr("src").replace(/lnb_on./g, 'lnb_off.'));
		$lnbFrame.attr('cols', '233, *');
		$(".lnbArea").css("left", "0px");
		$(".lnbMenuArea").css("display", "block");
		_this.removeClass("down");
	}
});*/

$(document).ready(function () {

    $(".totalMenuWrap").hide();
    $(".siteMap").click(function () {
        $(".totalMenuWrap").slideToggle(300);
    });

    $(".tmenu_header").click(function () {
        $(".totalMenuWrap").slideUp(300);
    });

/*    $(".split_l").click(function () {
		
        var pth = $(this).find("img")[0];
        var $lnb = $('.lnbArea > .inner');

        if (!$(".contents").hasClass("down")) {
            $lnb.hide();
            $(".contents").addClass("down");
			$("#container").css("padding-left", "25px");
			$(".split_l").css("margin-left", "0");
            $(pth).attr("src", $(pth).attr("src").replace(/lnb_off./g, 'lnb_on.'));

        }
        else {
            $lnb.show();
            $(".contents").removeClass("down");
			$("#container").css("padding-left", "205px");
			$(".split_l").css("margin-left", "-22px");
            $(pth).attr("src", $(pth).attr("src").replace(/lnb_on./g, 'lnb_off.'));
        }
    });*/
	
});

// 테이블 접고 펼치기
$(function () {
    $(".foldBtn , .foldBtnTit").click(function (){
		$(this).toggleClass("on");
		$(".foldCont").toggle();
		
	});
});
/*
function fontValue(){
	var font = {"맑은 고딕" : "맑은 고딕","돋움" : "돋움","굴림" : "굴림","바탕" : "바탕","궁서" : "궁서","David" : "David","LG스마트체" : "LG스마트체", "LG스마트체2.0" : "LG스마트체2.0","MS PGothic" : "MS PGothic","New MingLiu" : "New MingLiu","Simplified Arabic" : "Simplified Arabic","simsun" : "simsun","Arial" : "Arial","Courier New" : "Courier New","Tahoma" : "Tahoma","Times New Roman" : "Times New Roman","Verdana" : "Verdana", };
	
	return font;
}
*/