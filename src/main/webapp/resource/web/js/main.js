$(function(){

	/*$('nav').hover(function(){
		$(this).find('.sub_wrap').stop().slideDown(500);

	},function(){
		$(this).find('.sub_wrap').stop().slideUp(300);
	})*/

})

/*.gnb_bg{background:#fff; width:100%; position:absolute; top:83px; z-index:99; height:580px;}*/

/*테이블 tr 줄 색상 바꿈*/
$(document).ready(function(){

	var $menuNum;

	$menuNum = $('.Mgnb .title li').length;

	if($menuNum == 7) $(".Mgnb").addClass('all');
	else $(".Mgnb").removeClass('all');

	$(".Mgnb .top_gnb").hide();

	$('#Wrap').hover(function() {
	  $('.Mgnb .top_gnb').slideDown('fast');
	  return false;
	}
	, function() {
		$('.Mgnb .top_gnb').slideUp('fast');
	});

/*	$('#Wrap').blur(function() {
	  $('.Mgnb .top_gnb').slideUp('fast');
	});
*/


  $('.table_bgcolor tr:odd').css("backgroundColor","#fff");
  $('.table_bgcolor tr:even').css("backgroundColor","#f1f3f3");
});

/*popup*/
function wrapWindowByMask(){
        var maskHeight = $(document).height();
        var maskWidth = $(window).width();
        $('#mask').css({'width':maskWidth,'height':maskHeight});
        $('#mask').fadeIn(0);
        $('.wirte_pop_back').fadeOut(150);
        $('#mask').fadeTo("slow",0.85);
        $('.wirte_pop_back').show();
    }
    $(document).ready(function(){
        $('.writr_pop_click').click(function(e){
            e.preventDefault();
            wrapWindowByMask();
        });
        $('.wirte_pop_back .wirte_pop_close').click(function (e) {
            e.preventDefault();
            $('#mask, .wirte_pop_back').hide();
        });
    });

/*$(function(){
	$('.side_iconList>li>a').each(function() {
        var a=$(this);
		var img=a.find('img')
    	var origin_src=img.attr('src');
		var over_src=origin_src.replace('_off','_on');
		$('<img>').attr('src',over_src);
		a.hover(function(){
			img.attr('src',over_src);
		},function(){
			img.attr('src',origin_src);
		})
		a.focus(function(){
			img.attr('src',over_src);
		})
		a.blur(function(){
			img.attr('src',origin_src);
		})
	});
})
*/

$(function(){
	var tabDiv = $('.tabbox');
	var tabBtn = tabDiv.find('.Mtabs a');
	var panelBox = tabDiv.find( 'div.panel' );
	var currentBtn = tabBtn.filter('.on');
	var currentPanel = $(currentBtn.attr('href'));
	panelBox.hide();
	currentPanel.show();

	tabBtn.click( function(event){
		event.preventDefault();
		var newBtn = $(this);
		var newPanel = $(newBtn.attr('href'));
		currentBtn.removeClass('on');
		newBtn.addClass('on');
		currentPanel.hide();
		newPanel.show();
		currentBtn = newBtn;
		currentPanel = newPanel;
	})
    $(tabBtn[0]).trigger("click");
})

$(function(){
	var tabDiv = $('.tabbox02');
	var tabBtn = tabDiv.find('.tabs02 a');
	var panelBox = tabDiv.find( 'div.panel' );
	var currentBtn = tabBtn.filter('.on');
	var currentPanel = $(currentBtn.attr('href'));
	panelBox.hide();
	currentPanel.show();

	tabBtn.click( function(event){
		event.preventDefault();
		var newBtn = $(this);
		var newPanel = $(newBtn.attr('href'));
		currentBtn.removeClass('on');
		newBtn.addClass('on');
		currentPanel.hide();
		newPanel.show();
		currentBtn = newBtn;
		currentPanel = newPanel;
	})
    $(tabBtn[0]).trigger("click");
})

$(function(){
	var $list = $('ul.album');
	var size = $list.children().outerWidth();
	var len =  $list.children().length;
	var speed = 5000;
	var timer = null;
	var auto = true;
	var cnt = 1;

	$list.css('width',len*size);

	if(auto) timer = setInterval(autoSlide, speed);

	$list.children().bind({
		'mouseenter': function(){
			if(!auto) return false;
			clearInterval(timer);
			auto = false;
		},
		'mouseleave': function(){
			timer = setInterval(autoSlide, speed);
			auto = true;
		}
	})

	$('.bt-roll').children().bind({
		'click': function(){
			var idx = $('.bt-roll').children().index(this);
			cnt = idx;
			autoSlide();
			return false;
		},
		'mouseenter': function(){
			if(!auto) return false;
			clearInterval(timer);
			auto = false;
		},
		'mouseleave': function(){
			timer = setInterval(autoSlide, speed);
			auto = true;
		}
	});

	function autoSlide(){
		/*if(cnt>len-1){
			cnt = 0;
		}

		$list.animate({'left': -(cnt*size)+'px' },'normal');

		var source2 = $('.bt-roll').children().find('img').attr('src').replace('_.png','.png');
		$('.bt-roll').children().find('img').attr('src',source2);

		var source = $('.bt-roll').children().find('img').attr('src').replace('.png','_.png');
		$('.bt-roll').children().eq(cnt).find('img').attr('src',source);

		cnt++;*/
		cnt = 0;
	}

    })

/*******************************************************************************
* FUNCTION 명 : moveMenu()
* FUNCTION 기능설명 : 화면 이동
*******************************************************************************/
function moveMenu(vMenuId, parentMenuId, scrnUrl, menuId) {
	if(scrnUrl == "")  return;

	var target = '_self';
	var action = contextPath + '/index.do';

	if('IRIAN0001|IRIPJ0001'.indexOf(menuId) > -1) {
		action = contextPath + scrnUrl;
	}

	//[EAM추가] - 변수 Start
	$("#menuForm").find("#parentMenuId").val(parentMenuId);
	$("#menuForm").find("#vMenuId").val(vMenuId);
	$("#menuForm").find("#menuPath").val(scrnUrl);
	$("#menuForm").find("#menuId").val(menuId);
	//[EAM추가] - 변수 Start

	$("#vMenuId").val(vMenuId);
	$("#menuForm").attr("action", action);
	$("#menuForm").attr("target", target);
	$("#menuForm").submit();
}

// 개인정보처리방침 팝업호출
function privacyPopup(){
	var args = new Object();
	//var url	= contextPath + "/security/WINS_Security.jsp";
	var url	= "http://portal.lghausys.com/epWeb/resources/notice/sequrityguide/Tip-Top_Security.html";
	var result = window.showModalDialog(url, "privacyPopup", "dialogWidth:820px;dialogHeight:700px;x-scroll:no;y-scroll:yes;status:no;resizable=yes");
}