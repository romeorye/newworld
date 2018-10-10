<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*, java.util.*,devonframe.util.NullUtil,devonframe.util.DateUtil"%>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>
<%--
/*
 *************************************************************************
 * $Id		: prjMain.jsp
 * @desc    : 프로젝트 메인
 *------------------------------------------------------------------------
 * VER	DATE		AUTHOR		DESCRIPTION
 * ---	-----------	----------	-----------------------------------------
 * 1.0  2017.00.19  IRIS04		최초생성
 * ---	-----------	----------	-----------------------------------------
 * IRIS 구축 프로젝트
 *************************************************************************
 */
--%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    
<!--     <meta http-equiv="X-UA-Compatible" content="IE=edge" /> -->
    
    <%@ include file="/WEB-INF/jsp/include/rui_header.jspf"%>
    <title><%=documentTitle%></title><!-- <title>엘지하우시스</title> -->
    <link type="text/css" href="<%=cssPath%>/main.css" rel="stylesheet">
    <link type="text/css" href="<%=cssPath%>/swiper.min.css" rel="stylesheet">
	<script src="<%=scriptPath%>/main.js" type="text/javascript" charset="utf-8"></script>
    <script src="<%=scriptPath%>/swiper.min.js"></script>
	
	<script type="text/javascript">
	var tssTabGbn = 'G';
		
	$(document).ready(function(){
			
		var popUrl =  '<c:url value="/prj/rsst/mainPopUp.do"/>';
	    var popupOption = "width=750, height=500, top=300, left=400";
	    
	    //var blnCookie  = getCookie( winName );

	    //if( !blnCookie ) {  
		//    window.open(popUrl,"",popupOption);
	    //}  

		
			var swiper = new Swiper('.swiper-container', {
				slidesPerView: 1,
				spaceBetween: 30,
				loop: true,
				pagination: {
					el: '.swiper-pagination',
			        clickable: true,
			    }
			});
			// quickMenu 링크 이벤트
			// M/M입력
			$('#quickMenu01').click(function(){
				moveMenu('PJ', 'IRIPJ0400', '/prj/mm/retrieveMmInInfo.do', 'IRIPJ0401');
			});
			// WBS
			$('#quickMenu02').click(function(){
				moveMenu('PJ', 'IRIPJ0500', '/prj/mgmt/wbsStd/wbsStdList.do', 'IRIPJ0501');
			});
			// 분석의뢰
			$('#quickMenu03').click(function(){
				moveMenu('AN', 'IRIAN0100', '/anl/anlRqprList.do', 'IRIAN0101');
			});
			
			// 나의 과제 현황 탭 클릭 이벤트(변수저장)
			$('#tssTab01').click(function(){
				tssTabGbn = 'G';
			});
			$('#tssTab02').click(function(){
				tssTabGbn = 'O';
			});
			$('#tssTab03').click(function(){
				tssTabGbn = 'N';
			});
		
		}); // end jQuery Ready
		
	    Rui.onReady(function() {    
	    	
	    }); // end Rui Ready
	
	   function fnTssPageMove(gbn, pPgsStepCd, pGrsEvSt, pTssCd, pTssSt, pProgressrate) {
	       var returnUrl;
	    
	       var rate;
	       var arryProg = pProgressrate.split("/");
	       var rWgvl = arryProg[0];
	       var gWgvl = arryProg[1];
	      
	       if(rWgvl > gWgvl   ){
	    	   rate = "S";
	       }else if (rWgvl < gWgvl   ){
	    	   rate = "D";
	       }else{
	    	   rate = "N";
	       }
	    
	       var progressParam = "&progressrateReal="+pProgressrate+"&progressrate="+rate;

	       if(gbn == "G") {
	           //계획
               if(pPgsStepCd == "PL") {
                   returnUrl = "/prj/tss/gen/genTssPlnDetail.do?tssCd=" + pTssCd ;
               }
               //진행
               else if(pPgsStepCd == "PG") {
                   if(pTssSt == "102") {
                       //진행_GRS완료_중단
                       if(pGrsEvSt == "D") {
                           returnUrl = "/prj/tss/gen/genTssDcacDetail.do?tssCd=" + pTssCd+progressParam;
                       }
                       //진행_GRS완료_완료
                       else if(pGrsEvSt == "P2") {
                           returnUrl = "/prj/tss/gen/genTssCmplDetail.do?tssCd=" + pTssCd+progressParam;
                       }
                       //진행_GRS완료_변경
                       else {
                           returnUrl = "/prj/tss/gen/genTssAltrDetail.do?tssCd=" + pTssCd+progressParam;
                       }
                   } else {
                       returnUrl = "/prj/tss/gen/genTssPgsDetail.do?tssCd=" + pTssCd+progressParam;
                   }
               }
               //완료
               else if(pPgsStepCd == "CM") {
                   returnUrl = "/prj/tss/gen/genTssCmplDetail.do?tssCd=" + pTssCd;
               }
               //변경
               else if(pPgsStepCd == "AL") {
                   returnUrl = "/prj/tss/gen/genTssAltrDetail.do?tssCd=" + pTssCd;
               }
               //중단
               else if(pPgsStepCd == "DC") {
                   returnUrl = "/prj/tss/gen/genTssDcacDetail.do?tssCd=" + pTssCd;
               }
	       }
	       else if(gbn == "O") {
	           //계획
               if(pPgsStepCd == "PL") {
                   returnUrl = "/prj/tss/ousdcoo/ousdCooTssPlnDetail.do?tssCd=" + pTssCd;
               }
               //진행
                else if(pPgsStepCd == "PG") {
                   if(pTssSt == "102") {
                       //진행_GRS완료_중단(신규등록)
                       if(pGrsEvSt == "D") {
                           returnUrl = "/prj/tss/ousdcoo/ousdCooTssDcacDetail.do?tssCd=" + pTssCd+progressParam;
                       }
                       //진행_GRS완료_완료(신규등록)
                       else if(pGrsEvSt == "P2") {
                           returnUrl = "/prj/tss/ousdcoo/ousdCooTssCmplDetail.do?tssCd=" + pTssCd+progressParam;
                       }
                       //진행_GRS완료_변경(신규등록)
                       else {
                           returnUrl = "/prj/tss/ousdcoo/ousdCooTssAltrDetail.do?tssCd=" + pTssCd+progressParam;
                       }
                   } else {
                       returnUrl = "/prj/tss/ousdcoo/ousdCooTssPgsDetail.do?tssCd=" + pTssCd+progressParam;
                   }
               }            
               //완료(조회 및 수정)
               else if(pPgsStepCd == "CM") {
                   returnUrl = "/prj/tss/ousdcoo/ousdCooTssCmplDetail.do?tssCd=" + pTssCd;
               }
               //변경(조회 및 수정)
               else if(pPgsStepCd == "AL") {
                   returnUrl = "/prj/tss/ousdcoo/ousdCooTssAltrDetail.do?tssCd=" + pTssCd;
               }
               //중단(조회 및 수정)
               else if(pPgsStepCd == "DC") {
                   returnUrl = "/prj/tss/ousdcoo/ousdCooTssDcacDetail.do?tssCd=" + pTssCd;
               }
	       }
	       else if(gbn == "N") {
	           //계획
               if(pPgsStepCd == "PL") {
                   returnUrl = "/prj/tss/nat/natTssPlnDetail.do?tssCd=" + pTssCd;
               }
               //진행
               else if(pPgsStepCd == "PG") {
                   if(pTssSt == "102") {
                       //진행_GRS완료_중단
                       if(pGrsEvSt == "D") {
                           returnUrl = "/prj/tss/nat/natTssDcacDetail.do?tssCd=" + pTssCd+progressParam;
                       }
                       //진행_GRS완료_완료
                       else if(pGrsEvSt == "P2") {
                           returnUrl = "/prj/tss/nat/natTssCmplDetail.do?tssCd=" + pTssCd+progressParam;
                       }
                       //진행_GRS완료_변경
                       else {
                           returnUrl = "/prj/tss/nat/natTssAltrDetail.do?tssCd=" + pTssCd+progressParam;
                       }
                   } else {
                       returnUrl = "/prj/tss/nat/natTssPgsDetail.do?tssCd=" + pTssCd+progressParam;
                   }
               }
               //완료
               else if(pPgsStepCd == "CM") {
                   returnUrl = "/prj/tss/nat/natTssCmplDetail.do?tssCd=" + pTssCd;
               }
               //변경
               else if(pPgsStepCd == "AL") {
                   returnUrl = "/prj/tss/nat/natTssAltrDetail.do?tssCd=" + pTssCd;
               }
               //중단
               else if(pPgsStepCd == "DC") {
                   returnUrl = "/prj/tss/nat/natTssDcacDetail.do?tssCd=" + pTssCd;
               }
	       }
	       
	       if(gbn == "G") {			// 일반과제
	    	   moveMenu('PJ', 'IRIPJ0200', returnUrl, 'IRIPJ0201');
	       }else if(gbn == "O") {	// 대외협력과제
	    	   moveMenu('PJ', 'IRIPJ0200', returnUrl, 'IRIPJ0202');
	       }else if(gbn == "N") {	// 국책과제
	    	   moveMenu('PJ', 'IRIPJ0200', returnUrl, 'IRIPJ0203');
	       }

//		<a href="javascript:moveMenu('PJ', 'IRIPJ0200', '/prj/tss/gen/genTssList.do', 'IRIPJ0201')">일반과제</a>
//		<a href="javascript:moveMenu('PJ', 'IRIPJ0200', '/prj/tss/ousdcoo/ousdCooTssList.do', 'IRIPJ0202')">대외협력과제</a>
//		<a href="javascript:moveMenu('PJ', 'IRIPJ0200', '/prj/tss/nat/natTssList.do', 'IRIPJ0203')">국책과제</a>
  
	   }// end function
	   
	   // 나의 과제 현황 +버튼 : 과제리스트 페이지이동
	   function fnTssListPageMove(){
		   
		   if(tssTabGbn == "G") {		// 일반과제
	    	   moveMenu('PJ', 'IRIPJ0200', '/prj/tss/gen/genTssList.do', 'IRIPJ0201');
	       }else if(tssTabGbn == "O") {	// 대외협력과제
	    	   moveMenu('PJ', 'IRIPJ0200', '/prj/tss/ousdcoo/ousdCooTssList.do', 'IRIPJ0202');
	       }else if(tssTabGbn == "N") {	// 국책과제
	    	   moveMenu('PJ', 'IRIPJ0200', '/prj/tss/nat/natTssList.do', 'IRIPJ0203');
	       }
	   }

	</script>
</head>

<body>

<form name="tssMove"></form>
    
<div id="Wrap" style="background:#f4f4f4;">
    <!--header-->
    <div class=gnb_bg></div>
    <div class="width_layout">
	<%@ include file="/WEB-INF/jsp/web/main/top.jspf" %>
    </div>      
    <div class="gnb_line"></div>
<style>
#main_iris {padding-bottom:0; overflow:hidden;}
#main_iris #prj_lnb { width:234px;padding:0;}

#main_iris #prj_lnb .side_layout {width:100%; margin-top:0;}
#main_iris #prj_lnb .side_layout > div {border-radius:16px;}
.profile_wrap {background:#fff; padding:18px 0 0 0; text-algin:center;}
.profile_wrap .profile_naming {display:table; margin:0 auto;}
.profile_wrap .profile_naming span, .profile_wrap .profile_naming div {display:table-cell; vertical-align:middle;} 
.profile_wrap .profile_naming div {padding-top:0; padding-left:10px; position:relative;}
.profile_wrap .request_numbering {padding:15px 0 5px 0;}

#prj_lnb .side_scroll_con ul {overflow:hidden; width:100%; border-radius:16px; background:#fff;margin:0;  margin-top:15px; }
#prj_lnb .side_scroll_con ul li {height:54px; line-height:54px; }
#prj_lnb .side_scroll_con ul li:nth-child(1) {display:none;}
#prj_lnb .side_scroll_con ul li:nth-child(2) {padding:6px 0; background-position: 60px center;}
/*#prj_lnb .side_scroll_con ul li:nth-child(3) {background-position:32px 0px;}
#prj_lnb .side_scroll_con ul li:nth-child(4) {background-position:32px -120px;}
#prj_lnb .side_scroll_con ul li:nth-child(5) {background-position:32px -240px;}
#prj_lnb .side_scroll_con ul li:nth-child(6) {background-position:32px -360px;}
#prj_lnb .side_scroll_con ul li:nth-child(7) {background-position:32px -480px;}
#prj_lnb .side_scroll_con ul li:nth-child(8) {background-position:32px -600px;}
#prj_lnb .side_scroll_con ul li:nth-child(9) {background-position:32px -720px;}
#prj_lnb .side_scroll_con ul li:nth-child(10) {background-position:32px -840px;}*/
#prj_lnb .side_scroll_con ul li a { margin: 0 0 0 60px;}

#main_iris #prj_content {margin-left:280px; margin-right:264px;}
#prj_content h4 {font-size:16px; margin-bottom:17px;}
#prj_content table { border-top: 1px solid #be034c;}
.fir_subject_con {width:100%;}
.fir_subject_con.section1 {height:290px; overflow:hidden; position:relative;}
.fir_subject_con.section1 .visual { margin-right:360px;height:290px; background:url(/iris/resource/web/images/newIris/main_visual.png) no-repeat left top;border-radius:16px; }
.fir_subject_con.section1 .visual img {width:100%;background:#555; display:none;}
.fir_subject_con.section1 .schedule_con {width:340px;height:290px; position:absolute !important; top:0; right:0; margin:0; padding:16px; box-sizing:border-box; background:#fff; border-radius:15px;}
.schedule_con .main_sec_table01 tr th:first-child {width:60% !important;}
.task_con.section2 {width:100%;  box-sizing:border-box; background:#fff; border-radius:16px; padding:25px 24px;}

.section2 .tab_con02 ul {border-top:0; overflow:hidden;height:35px; position:relative;}
.section2 .tab_con02 ul:after {content:""; position:absolute; left:0;right:0; width:100%; height:1px; display:block; top:34px; background:#ccc;}
.section2 .tab_con02 ul li {height:35px; margin-bottom:-1px;  background: #eee;height: unset; color: #666;box-sizing: border-box;}
.section2 .tab_con02 ul li:last-child a {border-right:1px solid #d8d8d8;}
.section2 .tab_con02 ul li a {border: 1px solid #d8d8d8; border-right:0; height:100%; font-size:13px; padding:0 20px; line-height:35px; display:block; box-sizing: border-box;}
.section2 .tab_con02 ul li a.on {margin-top:0; border-bottom:1px solid #fff; background:#fff; border-top:1px solid #d8d8d8 !important;}

.task_con.section2 {padding-bottom:28px !important;}
.task_con.section2 .table02 tbody tr td:nth-of-type(2) {text-align:center;}
.task_con.section2 .table02 tbody tr td:nth-of-type(3) {text-align:left;}
 #prj_right {position:absolute; right:1%; top:0; width:220px;}
 #prj_right > div {width:100%; border-radius:16px; background:#fff; position:relative; margin-top:18px;}
 #prj_right .btn_menu {background:#da1c5a; line-height:3.5; text-align:center; border-radius:11px !important;}
 #prj_right .btn_menu a {color:#fff; font-weight:bold; font-size:13px; display:inline-block;}
 #prj_right .btn_menu a i {  display:inline-block; width:20px; height:15px; background:url(/iris/resource/web/images/newIris/bullet_meu.png) no-repeat left center;}
.menu_link {overflow:hidden;}
.menu_link p {line-height:2.8; text-align:center; font-weight:bold; font-size:13px; }
.menu_link ul {width:92%; margin:0 auto;}
.menu_link ul li {border-top:1px dashed #ccc; height:72px;}
.menu_link ul li a {display:block; height:100%;text-indent:98px;line-height:72px; font-size:13px;}
.menu_link ul li a:hover {color:#da1c5a;}
.menu_link ul li:nth-child(1) a { background:url(/iris/resource/web/images/newIris/main_right.png) no-repeat 30px 20px;}
.menu_link ul li:nth-child(2) a { background:url(/iris/resource/web/images/newIris/main_right.png) no-repeat 30px -80px;}
.menu_link ul li:nth-child(3) a { background:url(/iris/resource/web/images/newIris/main_right.png) no-repeat 30px -177px;}
.menu_link ul li:nth-child(4) a { background:url(/iris/resource/web/images/newIris/main_right.png) no-repeat 32px -275px;}
.menu_link ul li:nth-child(1) a:hover { background:url(/iris/resource/web/images/newIris/main_right.png) no-repeat 30px -380px;}
.menu_link ul li:nth-child(2) a:hover { background:url(/iris/resource/web/images/newIris/main_right.png) no-repeat 30px -480px;}
.menu_link ul li:nth-child(3) a:hover { background:url(/iris/resource/web/images/newIris/main_right.png) no-repeat 30px -577px;}
.menu_link ul li:nth-child(4) a:hover { background:url(/iris/resource/web/images/newIris/main_right.png) no-repeat 32px -675px;}

.left_phone.help {padding:15px;box-sizing: border-box;}
</style>
    <!--content-->
    <div class="Main_content" id="main_iris">
        <!--left-->
        <div class="side_bar_con" id="prj_lnb">
            <div class="side_layout">
            	<!-- profile -->
            	<div class="profile_wrap">
	                <div class="profile_naming">
	                    <span><img src="<%=imagePath%>/newIris/profile_img.png" class="profile_img"></span>
	                    <div class="name_con">
	                        <p class="name"><c:out value="${inputData._userNm}"/>(<c:out value="${inputData._userId}"/>)</p>
	                        <p class="grade"><c:out value="${inputData._userJobxName}"/></p>
	                    </div>    
	                </div>
	                <ul class="request_numbering">
	<!--                     <li>
	                        <div class="number"><span>353</span></div>
	                        <div class="txt">승인요청</div>
	                    </li> -->
	                    <c:choose>
		                	<c:when test="${fn:length(tssReqCntInfo) == 0}">
		                    <li>
		                        <div class="number"><span>0</span></div>
		                        <div class="txt">GRS요청</div>
		                    </li>
		                    <li>
		                        <div class="number"><span>0</span></div>
		                        <div class="txt">품의요청</div>
	                    	</li>
		                   	</c:when>
		                   	<c:otherwise>
		                        <li>
		                        	<a href="javascript:moveMenu('PJ', 'IRIPJ0300', '/prj/grs/grsReqList.do', 'IRIPJ0301')">
				                        <div class="number"><span><c:out value="${tssReqCntInfo.reqGrs}"/></span></div>
				                        <div class="txt">GRS요청</div>
			                        </a>
			                    </li>
			                    <li>
			                    	<a href="javascript:moveMenu('PJ', 'IRIPJ0200', '/prj/tss/itg/tssItgRdcsList.do', 'IRIPJ0204')">
				                        <div class="number"><span><c:out value="${tssReqCntInfo.reqCsus}"/></span></div>
				                        <div class="txt">품의요청</div>
				                    </a>
		                    	</li>
		                   	</c:otherwise>
		                </c:choose>
	                </ul>
                </div>
                <!-- //profile -->
                
                
                <!-- 하드코딩 영역 시작 : 추후 오픈시 내용 추가 -->
                <div class="side_scroll_con">
                	<!--  20181008 주석 ( 하드코딩 영역 시작 : 내용이 없어서 높이 하드코딩  )  
                    <div class="swiper-container">
                        <div class="swiper-wrapper" style="height:30px;"> 
                            
                        </div>
                        <div class="swiper-pagination"></div>    
                    </div>
                      // 20181008 주석 -->
					<%@ include file="/WEB-INF/jsp/web/main/leftBanner.jspf" %>
                </div>    
            </div>    
        </div>
		<!--//left-->	
				
        <!--right-->
        <div class="body_con" id="prj_content">
        	<!-- section1 -->
        	<div class="fir_subject_con section1">
        		<div class="visual"><img src="<%=imagePath%>/newIris/main_img.png" /></div>

        		
        		
        		<div class="sec_subject_con schedule_con">
                <div class="schedule_con">
                    <h4 class="notice_title">연구소 주요일정<span class="plus"><a href="javascript:moveMenu('KL', 'IRIKL0100', '/knld/pub/retrieveLabSchedule.do', 'IRIKL0112')">&#43;</a></span></h4>
                    <!--tab-->
                    <div class="tab_con tabbox">
                        <ul class="Mtabs" style="display:none;>
                            <li><a href="#panel1" >금주일정</a></li>
                            <li><a href="#panel2" >차주일정</a></li>
                        </ul>
                        <div class="panels">
                            <div id="panel1" class="panel">
                                <table class="main_sec_table01">
                                    <colgrop>
                                    	<col style="width:60%;">
                                    	<col style="width:40%;">
                                    </colgrop>
                                    <thead>
                                        <tr>
                                            <th><c:out value="${inputData.nowDate}"/></th>
                                            <th><c:out value="${inputData.nowEngDay}"/></th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                    	<c:choose>
	                					<c:when test="${fn:length(scheduleList) == 0}">
		                					<tr>
	                                            <td><a href="#"></a></td>
	                                            <td></td> 
	                                        </tr>
	                					</c:when>
	                					<c:otherwise>
		                                    <c:forEach var="schedule" items="${scheduleList}">
		                                    <c:if test="${schedule.type eq '1' }">
												<tr>
		                                            <td><a href="#"><c:out value="${schedule.adscTitl}"/></a></td>
		                                            <td><c:out value="${schedule.adscDt}"/></td>
		                                        </tr>
		                                    </c:if>
											</c:forEach>
										</c:otherwise>
										</c:choose>
                                    </tbody>
                                </table>                               
                            </div>
                            
                            <div id="panel2" class="panel" style="display:none;">
                                <table class="main_sec_table01">
                                    <colgrop></colgrop>
                                    <thead>
                                        <tr>
                                            <th style="width:269px"><c:out value="${inputData.nowDate}"/></th>
                                            <th><c:out value="${inputData.nowEngDay}"/></th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                    	<c:choose>
	                					<c:when test="${fn:length(scheduleList) == 0}">
		                					<tr>
	                                            <td style="width:269px"><a href="#"></a></td>
	                                            <td></td>
	                                        </tr>
	                					</c:when>
	                					<c:otherwise>
	                                    	<c:forEach var="schedule" items="${scheduleList}">
		                                    <c:if test="${schedule.type eq '2' }">
												<tr>
		                                            <td style="width:269"><a href="#"><c:out value="${schedule.adscTitl}"/></a></td>
		                                            <td><c:out value="${schedule.adscDt}"/></td>
		                                        </tr>
		                                    </c:if>
											</c:forEach>
										</c:otherwise>
										</c:choose>
                                    </tbody>
                                </table>  
                            </div>
                        </div>
                    </div>
                    <!--//tab-->
                </div>
            </div>
 
        	</div>
        	<!-- //section1 -->
    
            <!--thi-->
           <!--  <div class="task_con"> -->
           <div class="task_con section2">
                <h4 class="notice_title">연구 게시판<span class="plus"><a href="javascript:fnTssListPageMove();">&#43;</a></span></h4>
                <!--tab-->
                <div class="tab_con02 tabbox02">
                    <ul class="tabs02">
                        <li id="tssTab01"><a href="#panel3" >공지사항</a></li>
                        <li id="tssTab02"><a href="#panel4" >Knowledge</a></li>
                        <li id="tssTab03"><a href="#panel5" >Q & A</a></li>
                    </ul>
                </div>
                <div class="panels">
                    <div id="panel3" class="panel">
                    <!--table-->
                    <div class="">

                      <table class="table02 " summary="분류">
                            <caption>분류</caption>
                            <colgroup>
	                            <col width="140px" />
	                            <col width="120px" />
	                            <col width="" />
	                            <col width="100px" />
	                            <col width="140px" />
                            </colgroup>
                            <thead>
                                <tr>
                                    <th>조직</th>
                                    <th>프로젝트명</th>
                                    <th>과제명</th>
                                    <th>과제리더</th>
                                    <th>기간</th>
                                </tr>
                            </thead>
                            <tbody>
								<tr>
                                    <td>중앙연구소</td>
                                    <td>코팅PJP</td>
                                    <td>가전 필름용 코팅 기술</td>
                                    <td>이한나 </td>
                                    <td>2018.07.01 ~ 2018.12.31</td>
                                </tr>
                                <tr>
                                    <td>창호 사업부</td>
                                    <td>유리연구소</td>
                                    <td>고단열 고자폐 더블로이</td>
                                    <td>이한나</td>
                                    <td>2018.07.01 ~ 2018.12.31</td>
                                </tr>
                                <tr>
                                    <td>창호 사업부</td>
                                    <td>창호개발연구</td>
                                    <td>E9 소형창</td>
                                    <td>권대훈</td>
                                    <td>2018.07.01 ~ 2018.12.31</td>
                                </tr>
                                <tr>
                                    <td>장식재 사업부</td>
                                    <td>탕일연구</td>
                                    <td>Prestige</td>
                                    <td>정우경</td>
                                    <td>2018.07.01 ~ 2018.12.31</td>
                                </tr>
                                <tr>
                                    <td>자동차소재부품 사업부</td>
                                    <td>경량화 Spec-In팀</td>
                                    <td>경량화 백빙</td>
                                    <td>이중기</td>
                                    <td>2018.07.01 ~ 2018.12.31</td>
                                </tr>
                            </tbody>
                        </table> 
                    </div>    
                    
                    </div>
                    
                    <div id="panel4" class="panel">
                        <!--table-->
                    <div class="">
                    <br/><br/>
<!--                         <ul class="progress"> -->
<!--                             <li>진척도</li> -->
<!--                             <li><span class="progress_bg01"></span>정상</li> -->
<!--                             <li><span class="progress_bg02"></span>단축</li> -->
<!--                             <li><span class="progress_bg03"></span>지연</li> -->
<!--                         </ul> -->
					    <table class="table02 " summary="분류">
                        	<caption>분류</caption>
                        	<colgroup>
	                            <col width="14%" />
	                            <col width="21%" />
	                            <col width="33%" />
	                            <col width="7%" />
	                            <col width="19%" />
	                            <col width="6%" />
                            </colgroup>
                            <thead>
                                <tr>
                                    <th>조직</th>
                                    <th>프로젝트명</th>
                                    <th>과제명</th>
                                    <th>과제리더</th>
                                    <th>기간</th>
                                    <th>상태</th>
                                </tr>
                            </thead>
                            <tbody>
                            
                            <c:choose>
                            <c:when test="${fn:length(ousList) == 0}">
                            	<tr><td colspan="6">진행중인 과제가 없습니다.</td></tr>
                            </c:when>
                            <c:otherwise>
	                            <c:forEach var="ousList" items="${ousList}">
							    <tr>
	                                <td><c:out value="${ousList.deptName}"/></td>
	                                <td><a href="javascript:fnTssPageMove('O','${ousList.pgsStepCd}', '${ousList.grsEvSt}', '${ousList.tssCd}', '${ousList.tssSt}', '${ousList.progressrate}');" ><c:out value="${ousList.prjNm}"/></a></td>
	                                <td align="left"><a href="javascript:fnTssPageMove('O','${ousList.pgsStepCd}', '${ousList.grsEvSt}', '${ousList.tssCd}', '${ousList.tssSt}', '${ousList.progressrate}');" ><c:out value="${ousList.tssNm}"/></a></td>
	                                <td><c:out value="${ousList.saUserName}"/></td>
	                                <td><c:out value="${ousList.tssStrtDd}"/>~<c:out value="${ousList.tssFnhDd}"/></td>
	                                <td><c:out value="${ousList.pgsStepNm}"/></td>
	                            </tr>
								</c:forEach>
							</c:otherwise>
							</c:choose>	
                            
                            </tbody>
                        </table>
                    </div>
                    </div>
                    <div id="panel5" class="panel">
                        <!--table-->
                    <div class="">
                    <br/><br/>
<!--                         <ul class="progress"> -->
<!--                             <li>진척도</li> -->
<!--                             <li><span class="progress_bg01"></span>정상</li> -->
<!--                             <li><span class="progress_bg02"></span>단축</li> -->
<!--                             <li><span class="progress_bg03"></span>지연</li> -->
<!--                         </ul> -->
                        <table class="table02 " summary="분류">
                            <caption>분류</caption>
                            <colgroup>
	                            <col width="14%" />
	                            <col width="21%" />
	                            <col width="33%" />
	                            <col width="7%" />
	                            <col width="19%" />
	                            <col width="6%" />
                            </colgroup>
                            <thead>
                               <tr>
                                    <th>조직</th>
                                    <th>프로젝트명</th>
                                    <th>과제명</th>
                                    <th>과제리더</th>
                                    <th>기간</th>
                                    <th>상태</th>
                                </tr>
                            </thead>
                            <tbody>
                            
                            <c:choose>
                            <c:when test="${fn:length(natList) == 0}">
                            	<tr><td colspan="6">진행중인 과제가 없습니다.</td></tr>
                            </c:when>
                            <c:otherwise>
	                             <c:forEach var="natList" items="${natList}">
	                                 <tr>
		                                <td><c:out value="${natList.deptName}"/></td>
		                                <td><a href="javascript:fnTssPageMove('N','${natList.pgsStepCd}', '${natList.grsEvSt}', '${natList.tssCd}', '${natList.tssSt}', '${natList.progressrate}');" ><c:out value="${natList.prjNm}"/></a></td>
		                                <td align="left"><a href="javascript:fnTssPageMove('N','${natList.pgsStepCd}', '${natList.grsEvSt}', '${natList.tssCd}', '${natList.tssSt}', '${natList.progressrate}');" ><c:out value="${natList.tssNm}"/></a></td>
		                                <td><c:out value="${natList.saUserName}"/></td>
		                                <td><c:out value="${natList.ttlCrroStrtDt}"/>~<c:out value="${natList.ttlCrroFnhDt}"/></td>
		                                <td><c:out value="${natList.pgsStepNm}"/></td>
		                            </tr>
	                             </c:forEach>
	                        </c:otherwise>
	                        </c:choose>    

                            </tbody>
                        </table>
                    </div>
                    </div>
                </div>
            </div>
        </div>
 
 		<!-- 좌측 추가 영역 -->    
        <div id="prj_right">
        	<div class="btn_menu"><a href="#"><i></i>전체메뉴</a></div>
        	
        	<div class="menu_link">
        		<p>주요메뉴</p>
        		<ul>
        			<li><a href="#">M/M 입력</a></li>
        			<li><a href="#">월마감</a></li>
        			<li><a href="#">분석의뢰</a></li>
        			<li><a href="#">분석 Main</a></li>
        		</ul>        	
        	</div>
        	
        	<div class="left_phone help">
        		<img src="/iris/resource/web/images/common/sub_left_m_contact.png" style="cursor: pointer;" onclick="goHelpDesk()">
        	</div>
       	
        	
        </div>
        <!-- //좌측 추가 영역 -->   
    </div>
    <!--footer-->
	<%@ include file="/WEB-INF/jsp/web/main/footer.jspf" %>
    
</div>
    
</body>
</html>