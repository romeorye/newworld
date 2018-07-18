<%@ page language="java" session="false" pageEncoding="utf-8" contentType="text/html; charset=utf-8"%>


<%@page import="iris.web.common.util.HelpDesk" %>
<%@ include file="/WEB-INF/jsp/include/rui_header.jspf"%>
	
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link rel="stylesheet" href="<%=cssPath%>/common.css" type="text/css" />
<script type="text/javascript" src="<%=scriptPath%>/jquery.js"></script>
<style type="text/css">
.lnbBanner {height:35px; background-color:#f9f4ef; border-bottom:1px solid #d9d9d9;}
.lnbBanner h2 {padding:0px 10px;line-height:35px;font-size:14px;color:#000000;font-weight:normal;cursor:pointer;font-weight:bold;margin:0!important;}
</style>
<script>
$(function(){
	
	$(".split_l").bind("click", function(){

		 var _this = $(this);
		 var pth = $(this).find('img')[0];		
		 var obj = parent.document.getElementById('main_frameset');		

		 if(obj.cols == '202,*'){

			 obj.cols='47,*';

			 	$('.lnbArea').css("left", "-148px");
			 	$('.lnbMenuArea').css('display', 'none');
			 	$('.accordionBtn').css('display', 'none');
			 	$('.lnbTitle').css('display', 'none');
			 	$(pth).attr('src', $(pth).attr('src').replace(/lnb_off./g, 'lnb_on.'));
		 }else if(obj.cols == '47,*'){

			 obj.cols='202,*';
			 $('.lnbArea').css("left", "10px");
			 $('.lnbMenuArea').css("display", "block");
			 $('.accordionBtn').css("display", "block");
			 $('.lnbTitle').css("display", "block");
			 $(pth).attr('src', $(pth).attr('src').replace(/lnb_on./g, 'lnb_off.'));
		 }

	});
		
	<c:if test ="${menuMoveYn eq 'Y'}">		
		var _this = $(this);
	    var pth = $(this).find('img')[0];		
	    var obj = parent.document.getElementById('main_frameset');	 

		obj.cols='202,*';
		$('.lnbArea').css("left", "10px");
		$('.lnbMenuArea').css("display", "block");
		$('.accordionBtn').css("display", "block");
		$('.lnbTitle').css("display", "block");
		$(pth).attr('src', $(pth).attr('src').replace(/lnb_on./g, 'lnb_off.'));
		 	
	</c:if>


	//아코디언
	var accordion_all = "close";

	$('.accordion > dt').on('click', function () {

	    $this = $(this);
	    $target = $this.next();

	    <%-- Left Menu 하위에 존재하는 모든 'li(3depth메뉴)'에서 'on' 클래스 제거 --%>
// 	    $('.accordion').find('li').removeClass('on');

	    if(!$this.hasClass('accordion-active')){
	      $this.parent().children('dd').hide(); <%-- slideUp / hide --%>
	      $('.accordion > dt').removeClass('accordion-active');
	      $this.addClass('accordion-active');
	      $target.addClass('active').show();   <%--  slideDown / show--%>
// 	      $target.children('ul').children('li').first().addClass('on'); 하위메뉴 중 첫번째
	    }else{
	      $this.parent().children('dd').hide(); <%-- slideUp / hide --%>
	      $('.accordion > dt').removeClass('accordion-active');
	    }
	   // return false;
	});

	$('.accordion > dd > ul > li').on('click', function () {

	    $this = $(this);
	    $target = $this.next();

	    if(!$this.hasClass('on')){
    		$('.accordion > dd > ul > li').removeClass('on');
    		$this.addClass('on');
	    }<%-- else{
        $this.removeClass('on');
	    } --%>

	});


	// 아코디언 전체 열고 닫기

	$(".accordionBtn").click(function(){

		var dlc = $(".accordion").children();

		dlc.each(function (i) {
	    if (this.nodeName == "DD") {
	    	if (accordion_all == "close") {
	    		$(this).addClass('active').show();
	    	}
	    	else{
	    		$(this).addClass('active').hide();
	    	}
	   	 }

		});

		if (accordion_all == "close") {
  			accordion_all = "open";
	  	}
	  	else{
	  		accordion_all = "close";
	  	}
		//$(".lnbMenuArea dl.accordion dd").toggleClass("open");

	});

<%-- //Top Menu를 선택하여 들어온 경우에 실행 --%>
<c:if test ="${menuMoveYn eq 'Y'}">
<%-- 선택한 Top Menu의 하위메뉴(2depth) 중 최상위 메뉴의 vMenuId와 scrnUrl로 메뉴를 이동 시킨다. --%>
<%-- vMenuId : 3depth가 존재하면 해당 메뉴의 하위메뉴 중 최상위 메뉴ID 아니라면 해당 메뉴의 메뉴ID --%>
<%-- scrnUrl : 3depth가 존재하면 해당 메뉴의 하위메뉴 중 최상위 메뉴URL 아니라면 해당 메뉴의 메뉴URL --%>
	<c:choose>
		<c:when test="${!empty param.menuId}">
			moveMenu("<c:out value="${param.vMenuId}"/>", "<c:out value="${param.menuPath}"/><c:out value="${params}" escapeXml="false"/>", "<c:out value="${param.menuId}"/>");
			
			setMenuView('<c:out value="${param.parentMenuId}"/>');
			
    		$('.accordion > dd > ul > li').removeClass('on');
			$('#lvl3_<c:out value="${param.menuId}"/>').addClass('on');
		</c:when>
		<c:when test="${subMenuList[0].subSysId == 'AN' || subMenuList[0].subSysId == 'PJ'}">
			moveMenu("<c:out value="${subMenuList[1].subSysId}"/>", "<c:out value="${subMenuList[1].menuPath}"/>", "<c:out value="${subMenuList[1].menuId}"/>");  /*[EAM변경]*/
			
			if('${subMenuList[1].menuPath}' == '') {
				moveMenu("<c:out value="${subMenuList[2].subSysId}"/>", "<c:out value="${subMenuList[2].menuPath}"/>", "<c:out value="${subMenuList[2].menuId}"/>");
			}
			
			setMenuView('<c:out value="${subMenuList[1].menuId}"/>');
		</c:when>
		<c:otherwise>
			moveMenu("<c:out value="${subMenuList[0].subSysId}"/>", "<c:out value="${subMenuList[0].menuPath}"/>", "<c:out value="${subMenuList[0].menuId}"/>");  /*[EAM변경]*/
			
			if('${subMenuList[0].menuPath}' == '') {
				moveMenu("<c:out value="${subMenuList[1].subSysId}"/>", "<c:out value="${subMenuList[1].menuPath}"/>", "<c:out value="${subMenuList[1].menuId}"/>");
			}
			
			setMenuView('<c:out value="${subMenuList[0].menuId}"/>');
		</c:otherwise>
	</c:choose>
<%-- Left Menu Class 변경// --%>
</c:if>
<%-- Top Menu를 선택하여 들어온 경우에 실행// --%>
});


function goHelpDesk(){
	var sa = '${inputData._userSabun}';
    <%
	String sabun =  (String)((HashMap<String, String>)request.getAttribute("inputData")).get("_userSabun");
	HelpDesk hd = new HelpDesk();
	%>

	var emp_no = "921700"+sa;
	var fmd5_emp_no = "<%=hd.fmd5_user_id(sabun)%>";
	var popUrl =  '<c:url value="/prj/rsst/helpdesPopUp.do"/>';
    var popupOption = "width=1200, height=700, top=200, left=400";
    
    alert("IRIS+ 문의사항은 02-6987-7396 으로 연락바랍니다.");
    popUrl = popUrl+"?emp_no="+emp_no+"&fmd5_emp_no="+fmd5_emp_no;
    window.open(popUrl,"",popupOption);
}

<%--/*******************************************************************************
* FUNCTION 명 : moveMenu()
* FUNCTION 기능설명 : 화면 이동
*******************************************************************************/--%>
function moveMenu(vMenuId, scrnUrl, menuId){
	if(scrnUrl == "")  return;
	var target = 'contentFrame';
	
	if('IRIAN0001|IRIPJ0001'.indexOf(menuId) > -1) {
		target = '_top';
	}
	
	if( '${inputData.anlChrgNm}' != "" ||   '${inputData.anlChrgNm}' != null ||   '${inputData.anlChrgNm}' != undefined ){
		var urlString = scrnUrl.split("&");
		
		if(urlString.length > 1 ){
			var nmString = urlString[1].split("=");
			scrnUrl = urlString[0];
			$("#menuForm").find("#anlChrgNm").val('${inputData._userNm}');
		}
	}
	
	if( '${inputData.progressrateReal}' != "" ||   '${inputData.progressrateReal}' != null ||   '${inputData.progressrateReal}' != undefined ){
		$("#menuForm").find("#progressrateReal").val('${inputData.progressrateReal}');
	}
	
	if( '${inputData.progressrate}' != "" ||   '${inputData.progressrate}' != null ||   '${inputData.progressrate}' != undefined ){
		$("#menuForm").find("#progressrate").val('${inputData.progressrate}');
	}
	
	//[EAM추가] - 변수 Start
	$("#menuForm").find("#subSysId").val(vMenuId);
	$("#menuForm").find("#menuPath").val(scrnUrl);
	$("#menuForm").find("#menuId").val(menuId);
	//[EAM추가] - 변수 Start

	$("#vMenuId").val(vMenuId);
	$("#menuForm").attr("target", target);
	$("#menuForm").attr("action", contextPath + scrnUrl);
	$("#menuForm").submit();
	
	$("#menuForm").find("#anlChrgNm").val('');
	$("#menuForm").find("#progressrateReal").val('');
	$("#menuForm").find("#progressrate").val('');
}

<%--/*******************************************************************************
* FUNCTION 명 : setMenuView()
* FUNCTION 기능설명 : 메뉴 보기 설정
*******************************************************************************/--%>
function setMenuView(menuId) {
	if(!$("#lvl2_" + menuId).hasClass('accordion-active')) {
		$("#lvl2_" + menuId).parent().children('dd').hide();
		$('.accordion > dt').removeClass('accordion-active');
		$("#lvl2_" + menuId).addClass('accordion-active');
		$("#lvl2_" + menuId).next().addClass('active').show();
		$("#lvl2_" + menuId).next().children('ul').children('li').first().addClass('on');
	}else{
		$("#lvl2_" + menuId).parent().children('dd').hide();
		$('.accordion > dt').removeClass('accordion-active');
	}
}

</script>
</head>
<body>
<form  name="mainForm2" method="post">
 <input type="hidden" name="emp_no" />
 <input type="hidden" name="fmd5_emp_no" />
 <input type="hidden" name="comp_no" value="921700">
</form>

<form id="menuForm" name="menuForm" method="post">
<input type="hidden" id="vMenuId" name="vMenuId" value="" />
<input type="hidden" id="menuMoveYn" name="menuMoveYn" value="N"/>
<input type="hidden" id="anlChrgNm" name="anlChrgNm"/>
<input type="hidden" id="progressrateReal" name="progressrateReal"/>
<input type="hidden" id="progressrate" name="progressrate"/>
<!-- [EAM추가]Start ===================================================================================== -->
<input type="hidden" id="menuId" name="menuId"/>
<input type="hidden" id="menuPath" name="menuPath"/>
<!-- [EAM추가]End ======================================================================================= -->

</form>
	<div class="lnbArea">
		<div class="inner">
			<div class="lnbTitle">
				<h2><c:out value="${parentMenuNm}"/></h2>
				<a href="#none" class="accordionBtn"></a>
			</div>
			<div class="lnbMenuArea">
				<dl class="accordion lnbMenu">
					<c:set var="prevLevel" value="0"/>
					<c:if test="${fn:length(subMenuList) ne 0}">
					<c:forEach var="item" items="${subMenuList}" varStatus="inx">
						<c:set var="currentLevel" value="${item.menuLevel}"/>			<!-- [EAM변경] level 하나씩 낮춤-->
						<c:choose>
						<c:when test="${currentLevel eq '1'}">
							<c:if test ="${currentLevel eq '1' && prevLevel eq '2'}">
								</ul>
								</dd>
							</c:if>
							<dt id="lvl2_${item.menuId}">
							 <a href="javascript:moveMenu('${item.subSysId}', '${item.menuPath}', '${item.menuId}')"><c:out value="${item.menuNm}"/></a>  <!-- [EAM변경] -->
							</dt>
						</c:when>
						<c:when test="${currentLevel eq '2' && prevLevel eq '1'}">
							<dd>
								<ul class="submenu">
									<li id="lvl3_${item.menuId}"><a href="javascript:moveMenu('${item.subSysId}', '${item.menuPath}', '${item.menuId}')"><c:out value="${item.menuNm}"/></a></li>  <!-- [EAM변경] -->
							<c:if test="${inx.last}">
									</ul>
									</dd>
							</c:if>
						</c:when>
						<c:otherwise>
									<li id="lvl3_${item.menuId}"><a href="javascript:moveMenu('${item.subSysId}', '${item.menuPath}', '${item.menuId}')"><c:out value="${item.menuNm}"/></a></li> <!-- [EAM변경] -->
							<c:if test="${inx.last}">
									</ul>
									</dd>
							</c:if>
						</c:otherwise>
						</c:choose>
						<c:set var="prevLevel" value="${currentLevel}"/>
					</c:forEach>
					</c:if>
				</dl>
				</div>
				<div ><img src="<%=imagePath%>/common/sub_left_m_contact.png" style="cursor: pointer;" onclick="goHelpDesk()" /></div>
			</div>
		<div class="split_l" ><img src="<%=imagePath%>/common/lnb_off.png" /></div>
	</div><!-- //lnbArea -->


</body>
</html>