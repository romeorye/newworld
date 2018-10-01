<%@ page language ="java"  pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<%@ include file="/WEB-INF/jsp/include/rui_header.jspf"%>
<title><%=documentTitle%></title>

<link rel="stylesheet" href="<%=cssPath%>/common.css" type="text/css" />
<link rel="stylesheet" href="<%=cssPath%>/bootstrap.css" type="text/css"/>
<link rel="stylesheet" href="<%=cssPath%>/lgHs_style.css" type="text/css" />

</head>

<style type="text/css">
    .mpanefset { top: 0px; left:260px; width: 1422px; height: 100% ; margin:auto;}
</style>


<script type="text/javascript" src="<%=scriptPath%>/jquery-3.3.1.min.js"></script>
<script type="text/javascript" src="<%=scriptPath%>/lgHs_common.js"></script>

	<script type="text/javascript">

function setMenuFrame(){
	 if ($('.page-left').hasClass('leftOpen')) {
		 //alert(1);
         $('.page-left').animate({left: -211}, 300);
         $('.page-content').animate({left: 0}, 300);
         $('.page-left').removeClass('leftOpen');
         $('.container').animate({width: w_width}, 300);
         //alert(2);
     } else {
    	 //alert(11);
    	 $('.page-left').animate({left: 0}, 300);
         $('.page-content').animate({left: 211}, 300);
         $('.page-left').addClass('leftOpen');
         $('.container').animate({width: (w_width - ($('.page-left').width()))}, 300);
    	 //alert(22);
     }
}
	</script>



	<frameset rows="66,*,51" border="0"  class="mpanefset">
		<frame name="topFrame" id="topFrame" src="<c:url value="/system/menu/irisFrameMenu/top.do"/>" scrolling="no" frameborder="0" title="상단프레임" noresize/>
		<frameset cols="211,*" border="0" id="main_frameset">

			<!-- [EAM변경] - 20170420 left 메뉴 정보 세팅 Start -->
			<nav class="page-left leftOpen">
				<frame  class="page-left" name="leftFrame" id="leftFrame" src="<c:url value="/system/menu/irisFrameMenu/left.do${params}"/>" scrolling="no" frameborder="0" title="왼쪽메뉴프레임" noresize/>
			</nav>
			<!-- [EAM변경] - 20170420 left 메뉴 정보 세팅 End -->

			<section class="page-content">
				<frame name="contentFrame" id="contentFrame" src="" frameborder="0" title="컨텐트프레임" noresize/>
			</section>

		</frameset>
		<frame name="footerFrame" id="footerFrame" src="<c:url value="/system/menu/irisFrameMenu/footer.do"/>" scrolling="no" frameborder="0" title="하단프레임" noresize/>
	</frameset>

</html>