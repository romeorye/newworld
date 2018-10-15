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
		       else if(gbn == "E") {
		           //계획
	               if(pPgsStepCd == "notice") {
	                   returnUrl = "/knld/pub/pubNoticeInfo.do?pwiId=" + pTssCd;
	               }
	               //진행
	               else if(pPgsStepCd == "qna") {
	            	   returnUrl = "/knld/qna/generalQnaInfo.do?qnaId=" + pTssCd;
	               }
	               //완료
	               else if(pPgsStepCd == "know") {
	                   if(pGrsEvSt == "A") {
	                       returnUrl = "/knld/rsst/productListInfo.do?prdtId=" + pTssCd;
	                   }
	                   //진행_GRS완료_완료
	                   else if(pGrsEvSt == "B") {
	                	   returnUrl = "/knld/rsst/productListInfo.do?prdtId=" + pTssCd;
	                   }
	                   else if(pGrsEvSt == "C") {
	                	   returnUrl = "/knld/rsst/productListInfo.do?prdtId=" + pTssCd;
	                   }
	                   else if(pGrsEvSt == "D") {
	                	   returnUrl = "/knld/rsst/productListInfo.do?prdtId=" + pTssCd;
	                   }
	                   else if(pGrsEvSt == "E") {
	                	   returnUrl = "/knld/rsst/productListInfo.do?prdtId=" + pTssCd;
	                   }
	                   else if(pGrsEvSt == "F") {
	                	   returnUrl = "/knld/rsst/productListInfo.do?prdtId=" + pTssCd;
	                   }
	                   else if(pGrsEvSt == "G") {
	                	   returnUrl = "/knld/rsst/productListInfo.do?prdtId=" + pTssCd;
	                   }
	                   else if(pGrsEvSt == "H") {
	                	   returnUrl = "/knld/rsst/productListInfo.do?prdtId=" + pTssCd;
	                   }
	                   else if(pGrsEvSt == "I") {
	                       returnUrl = "/knld/pub/technologyInfo.do?techId=" + pTssCd;
	                   }
	                   else if(pGrsEvSt == "J") {
	                       returnUrl = "/knld/pub/eduInfo.do?eduId=" + pTssCd;
	                   }
	                   else if(pGrsEvSt == "K") {
	                       returnUrl = "/knld/pub/conferenceInfo.do?conferenceId=" + pTssCd;
	                   }
	                   else if(pGrsEvSt == "L") {
	                       returnUrl = "/knld/pub/showInfo.do?showId=" + pTssCd;
	                   }
	                   else if(pGrsEvSt == "M") {
	                       returnUrl = "/knld/pub/patentInfo.do?patentId=" + pTssCd;
	                   }
	                   else if(pGrsEvSt == "N") {
	                       returnUrl = "/knld/pub/modalityInfo.do?modalityId=" + pTssCd;
	                   }
	                   else if(pGrsEvSt == "O") {
	                       returnUrl = "/knld/pub/saftyInfo.do?saftyId=" + pTssCd;
	                   }
	                   else if(pGrsEvSt == "P") {
	                       returnUrl = "/knld/pub/manualInfo.do?manualId=" + pTssCd;
	                   }

	               }

		       }
		       if(gbn == "G") {			// 일반과제
		    	   moveMenu('PJ', 'IRIPJ0200', returnUrl, 'IRIPJ0201');
		       }else if(gbn == "O") {	// 대외협력과제
		    	   moveMenu('PJ', 'IRIPJ0200', returnUrl, 'IRIPJ0202');
		       }else if(gbn == "N") {	// 국책과제
		    	   moveMenu('PJ', 'IRIPJ0200', returnUrl, 'IRIPJ0203');
		       }else if(gbn == "E") {	// 연구게시판
		    	   if(pPgsStepCd == "notice") {
		    	       moveMenu('KL', 'IRIKL0100', returnUrl, 'IRIKL0101');
		    	   }
		    	   else if(pPgsStepCd == "qna") {
		    		   moveMenu('KL', 'IRIKL0200', returnUrl, 'IRIKL0202');
	               }
	               //완료
	               else if(pPgsStepCd == "know") {
	            	   if(pGrsEvSt == "A") {
	            		   moveMenu('KL', 'IRIKL0300', returnUrl, 'IRIKL0301');
	                   }
	                   else if(pGrsEvSt == "B") {
	                	   moveMenu('KL', 'IRIKL0300', returnUrl, 'IRIKL0302');
	                   }
	                   else if(pGrsEvSt == "C") {
	                	   moveMenu('KL', 'IRIKL0300', returnUrl, 'IRIKL0303');
	                   }
	                   else if(pGrsEvSt == "D") {
	                	   moveMenu('KL', 'IRIKL0300', returnUrl, 'IRIKL0304');
	                   }
	                   else if(pGrsEvSt == "E") {
	                	   moveMenu('KL', 'IRIKL0300', returnUrl, 'IRIKL0305');
	                   }
	                   else if(pGrsEvSt == "F") {
	                	   moveMenu('KL', 'IRIKL0300', returnUrl, 'IRIKL0306');
	                   }
	                   else if(pGrsEvSt == "G") {
	                	   moveMenu('KL', 'IRIKL0300', returnUrl, 'IRIKL0307');
	                   }
	                   else if(pGrsEvSt == "H") {
	                	   moveMenu('KL', 'IRIKL0300', returnUrl, 'IRIKL0308');
	                   }
	                   else if(pGrsEvSt == "I") {
	                	   moveMenu('KL', 'IRIKL0100', returnUrl, 'IRIKL0102');
	                   }
	                   else if(pGrsEvSt == "J") {
	                	   moveMenu('KL', 'IRIKL0100', returnUrl, 'IRIKL0103');
	                   }
	                   else if(pGrsEvSt == "K") {
	                	   moveMenu('KL', 'IRIKL0100', returnUrl, 'IRIKL0104');
	                   }
	                   else if(pGrsEvSt == "L") {
	                	   moveMenu('KL', 'IRIKL0100', returnUrl, 'IRIKL0105');
	                   }
	                   else if(pGrsEvSt == "M") {
	                	   moveMenu('KL', 'IRIKL0100', returnUrl, 'IRIKL0106');
	                   }
	                   else if(pGrsEvSt == "N") {
	                	   moveMenu('KL', 'IRIKL0100', returnUrl, 'IRIKL0107');
	                   }
	                   else if(pGrsEvSt == "O") {
	                	   moveMenu('KL', 'IRIKL0100', returnUrl, 'IRIKL0109');
	                   }
	                   else if(pGrsEvSt == "P") {
	                	   moveMenu('KL', 'IRIKL0100', returnUrl, 'IRIKL0110');
	                   }
	               }
		       }

//			<a href="javascript:moveMenu('PJ', 'IRIPJ0200', '/prj/tss/gen/genTssList.do', 'IRIPJ0201')">일반과제</a>
//			<a href="javascript:moveMenu('PJ', 'IRIPJ0200', '/prj/tss/ousdcoo/ousdCooTssList.do', 'IRIPJ0202')">대외협력과제</a>
//			<a href="javascript:moveMenu('PJ', 'IRIPJ0200', '/prj/tss/nat/natTssList.do', 'IRIPJ0203')">국책과제</a>

		   }// end function

	   // 나의 과제 현황 +버튼 : 과제리스트 페이지이동
	   function fnTssListPageMove(){

		   if(tssTabGbn == "G") {		// 공지사항
	    	   moveMenu('KL', 'IRIKL0100', '/knld/pub/retrievePubNoticeList.do', 'IRIKL0101');
	       }else if(tssTabGbn == "O") {	// 대외협력과제
	    	   moveMenu('KL', 'IRIKL0100', '/knld/pub/retrieveTechnologyList.do', 'IRIKL0102');
	       }else if(tssTabGbn == "N") {	// 국책과제
	    	   moveMenu('KL', 'IRIKL0200', '/knld/qna/retrieveGeneralQnaList.do', 'IRIKL0202');
	       }
	   }

	</script>
	<style>
	html, body {height:100%;}
	*html .pj_body .Main_content_w {height:100%;} /* IE */
	</style>
</head>

<body class="pj_body">

<form name="tssMove"></form>

<div id="Wrap" style="background:#f4f4f4; height:66px !important;overflow: visible;">
    <!--header-->
    <div class=gnb_bg></div>
    <div class="width_layout">
	<%@ include file="/WEB-INF/jsp/web/main/top.jspf" %>
    </div>
    <div class="gnb_line"></div>

    <!--content-->
    <div class="Main_content_w">
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
		                        	<a href="javascript:moveMenu('PJ', 'IRIPJ0600', '/prj/grs//listGrsMngInfo.do', 'IRIPJ0601')">
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
        	<style>
.visual {position:relative;}
.visual .main_txt {position:absolute; z-index:999; left:30px; color:#fff; width:90%; height:100%; display:table;}
.visual .main_txt div {display:table-cell; vertical-align:middle;height:100%;}
.visual .main_txt span:before {content:""; position:absolute; left:0; top:-15px; width:30px; height:1px; background:#fff; z-index:999;}
.visual .main_txt span {font-size:15px;letter-spacing:-1px; display:inline-block; line-height:1.2; margin-bottom:1px; position:relative;}
.visual .main_txt p {font-size:18px; font-weight:bold; text-shadow:3px 3px 3px rgba(0,0,0, 0.1)}
</style>

        	<div class="fir_subject_con section1">
        		<div class="visual" style="position:relative;">
	        		<div class="main_txt">
	        			<div>
		        			<span>LG하우시스의 미래기술, 서울 LG Science Park에서 </span>
							<p>새로운 도약의 꿈을 키웁니다!</p>
						</div>
	        		</div>
	        		<img src="<%=imagePath%>/newIris/main_img.png" />
        		</div>



        		<div class="sec_subject_con schedule_con">
                <div class="schedule_con">
                    <h4 class="notice_title">연구소 주요일정<span class="plus"><a href="javascript:moveMenu('KL', 'IRIKL0100', '/knld/pub/retrieveLabSchedule.do', 'IRIKL0112')">&#43;</a></span></h4>
                    <!--tab-->
                    <div class="tab_con tabbox">
                        <ul class="Mtabs" style="display:none;">
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
                                    <thead style="display:none;">
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
		                                    <c:forEach var="schedule" end="4" items="${scheduleList}">
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
	                            <col width="20%" />
	                            <col width="40%" />
	                            <col width="20%" />
	                            <col width="20%" />
                            </colgroup>
                            <thead>
                                <tr>
                                    <th>분류</th>
                                    <th>제목</th>
                                    <th>등록자</th>
                                    <th>등록일</th>
                                </tr>
                            </thead>
                            <tbody>
                                    	<c:choose>
	                					<c:when test="${fn:length(noticeList) == 0}">
	                                            <tr><td colspan="4">공지사항이 존재하지 않습니다.</td></tr>
	                					</c:when>
	                					<c:otherwise>
	                                    	<c:forEach var="notice" items="${noticeList}">
												<tr>
		                                            <td style="text-align:Center"><c:out value="${notice.pwiScnNm}"/></td>
		                                            <td style="text-align:left">
		                                                <a href="javascript:fnTssPageMove('E','notice', '', '${notice.pwiId}', '', '');" >
		                                                   <c:if test="${notice.ugyYn eq 'U' }"><span style = "color : #FF5E00">[긴급]</span></c:if>
		                                                   <c:out value="${notice.titlNm}"/>
		                                                </a>
		                                            </td>
		                                            <td style="text-align:Center"><c:out value="${notice.rgstNm}"/></td>
		                                            <td style="text-align:Center"><c:out value="${notice.frstRgstDt}"/></td>
		                                        </tr>
											</c:forEach>
										</c:otherwise>
										</c:choose>
                                    </tbody>
                        </table>
                    </div>

                    </div>

                    <div id="panel4" class="panel">
                        <!--table-->
                    <div class="">

					    <table class="table02 " summary="분류">
                        	<caption>분류</caption>
                        	<colgroup>
	                            <col width="20%" />
	                            <col width="40%" />
	                            <col width="20%" />
	                            <col width="20%" />
                            </colgroup>
                            <thead>
                                <tr>
                                    <th>메뉴명</th>
                                    <th>제목</th>
                                    <th>등록자</th>
                                    <th>등록일</th>
                                </tr>
                            </thead>
                            <tbody>

                            <c:choose>
                            <c:when test="${fn:length(knowList) == 0}">
                            	<tr><td colspan="4">Knowledge가 존재하지 않습니다.</td></tr>
                            </c:when>
                            <c:otherwise>
	                            <c:forEach var="knowList" items="${knowList}">
							    <tr>
	                                <td style="text-align:Center"><c:out value="${knowList.menuNm}"/></td>
	                                <td style="text-align:left"><a href="javascript:fnTssPageMove('E','know', '${knowList.menuId}', '${knowList.docId}', '${knowList.clGroup}', '');" ><c:out value="${knowList.titlNm}"/></a></td>
	                                <td style="text-align:Center"><c:out value="${knowList.rgstNm}"/></td>
	                                <td style="text-align:Center"><c:out value="${knowList.frstRgstDt}"/></td>
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

                        <table class="table02 " summary="분류">
                            <caption>분류</caption>
                            <colgroup>
	                            <col width="20%" />
	                            <col width="40%" />
	                            <col width="20%" />
	                            <col width="20%" />
                            </colgroup>
                            <thead>
                               <tr>
                                    <th>질문유형</th>
                                    <th>제목</th>
                                    <th>등록자</th>
                                    <th>등록일</th>
                                </tr>
                            </thead>
                            <tbody>

                            <c:choose>
                            <c:when test="${fn:length(qnaList) == 0}">
                            	<tr><td colspan="4">Q&A가 존재하지 않습니다.</td></tr>
                            </c:when>
                            <c:otherwise>
	                             <c:forEach var="qnaList" items="${qnaList}">
	                                 <tr>
		                                <td style="text-align:Center"><c:out value="${qnaList.qustClNm}"/></td>
		                                <td style="text-align:left"><a href="javascript:fnTssPageMove('E','qna', '', '${qnaList.qnaId}', '', '');" ><c:out value="${qnaList.titlNm}"/></a></td>
		                                <td style="text-align:Center"><c:out value="${qnaList.rgstNm}"/></td>
		                                <td style="text-align:Center"><c:out value="${qnaList.frstRgstDt}"/></td>
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

<style>

.btn_menu:hover #tmpMenu {display:block !important; overflow: hidden;}
.btn_menu #tmpMenu
{display:none !important;position: absolute;z-index: 9999; text-align:left; position: absolute; z-index:999;width:1050px; background:#fff; top:38px; border:1px solid #ccc;
padding: 10px; padding-left:36px; right:0;background:#fff; border:1px solid #ccc; box-sizing:border-box; border-radius:16px;}
.btn_menu #tmpMenu #horizontalContainer {    overflow: hidden;
    min-height: 600px;}
.btn_menu #tmpMenu #horizontalContainer .gnb_height {    overflow: hidden; min-height: 600px;}
.btn_menu #tmpMenu #horizontalContainer .gnb_height .nav.Mgnb {height:auto !important;}
.btn_menu #tmpMenu  nav.Mgnb .top_gnb {top:10px !important;}

.menu_mm_ss_g > li {margin-top:10px;}
.menu_mm_ss_g > li.mainMenuTitle {height:22px;font-size:15px; font-weight:bold; position:relative;line-height:1.5;}
.menu_mm_ss_g > li.mainMenuTitle:before { content: ""; position:absolute; display: block; top: 0; left: 0; width:20px; height: 1px; background: #da1c5a;}
#horizontalContainer > span strong:first-child {margin-bottom:-10px;}
.btn_menu .top_gnb  {border:0; width:100%;}
.btn_menu .top_gnb .m_gnb {background-image:none !important; border:0; width:100%; height:600px;}

.top_gnb .menu {width:95%; margin-left:30px; height:600px !important;}
.top_gnb .menu ul.menu_mm {width:100%; overflow:hidden; margin-top:20px;}
.top_gnb .menu > ul > li {border:0; min-width:155px;    height: unset;}
.top_gnb .menu > ul > li span {margin:10px 0 6px 0 !important;}
.btn_menu #tmpMenu .top_gnb  {display:block !important;}
#prj_right .btn_menu ul li ul li {margin-bottom:2px;}
#prj_right .btn_menu ul li span a, #prj_right .btn_menu ul li ul li a {color:#555 !important; display:inline; line-height:1; font-size:12px; font-weight:normal; letter-spacing:-1px;}

</style>
 		<!-- 좌측 추가 영역 -->
        <div id="prj_right">
        	<div class="btn_menu">
        		<a href="#"><img src="/iris/resource/web/images/newIris/bullet_menu.png"> 전체메뉴</a>
        		<!-- 전체메뉴 리스트 -->
        		<div id="tmpMenu" class="allmneu">
					<!-- <div><input type="button" value="닫기" onclick="hideTmpMenu()"></div> -->
					<div id="horizontalContainer" style="float: none">
        			<%@ include file="/WEB-INF/jsp/web/main/allMenuTop.jspf" %>
					<!-- 	<span id="m01" style="float: left;margin-right: 20px;"><strong><br>Project<br></strong><u><a href="javascript:moveMenu('PJ', 'IRIPJ0300', '/prj/main.do', 'IRIPJ0301')">Main</a></u><br><strong><br>연구팀(Project)<br></strong>현황<br>월마감<br><strong><br>GRS<br></strong><u><a href="/iris/prj/grs//listGrsMngInfo.do">GRS관리</a></u><br><strong><br>과제관리<br></strong>일반과제<br>대외협력과제<br>국책과제<br><u><a href="/iris/prj/tss/tctm/tctmTssList.do">기술팀과제</a></u><br>O/I협력과제<br>RFP요청관리<br>결재현황<br><strong><br>M/M관리<br></strong>M/M입력<br>M/M마감<br><strong><br>관리<br></strong>신제품코드매핑<br>표준WBS관리<br>GRS템플릿관리<br>투입예산관리<br>조직코드약어관리<br>일반과제개요/분류관리<br></span>
						<span id="m02" style="float: left;margin-right: 20px;"><strong><br>Technical Service<br></strong><u><a href="/iris/anl/main.do">Main</a></u><br><strong><br>기기분석<br></strong>분석의뢰<br>분석목록<br>자료실<br>안내<br><strong><br>신뢰성시험<br></strong><u><a href="/iris/rlab/rlabRqprList.do">시험의뢰</a></u><br><u><a href="/iris/rlab/rlabRqprList4Chrg.do">시험목록</a></u><br><u><a href="/iris/rlab/lib/retrieveRlabLibList.do">자료실</a></u><br><u><a href="/iris/rlab/gid/rlabSphereInfo.do">안내</a></u><br><strong><br>공간평가<br></strong><u><a href="/iris/space/spaceRqprList.do">평가의뢰</a></u><br><u><a href="/iris/space/spaceRqprList4Chrg.do">평가목록</a></u><br><u><a href="/iris/space/spacePfmcMst.do">성능 Master</a></u><br><u><a href="/iris/space/lib/retrieveSpaceLibList.do">자료실</a></u><br><u><a href="/iris/space/gid/spaceSphereInfo.do">안내</a></u><br><strong><br>통합게시판<br></strong><u><a href="/iris/anl/bbs/retrieveAnlBbsList.do">공지사항</a></u><br><u><a href="/iris/anl/bbs/retrieveAnlQnaList.do">Q&amp;A</a></u><br><strong><br>관리<br></strong>기기분석 시험정보관리<br><u><a href="/iris/rlab/rlabExprList.do">신뢰성 시험정보관리</a></u><br><u><a href="/iris/space/spaceExatList.do">공간평가 시험정보관리</a></u><br><u><a href="/iris/space/spaceEvaluationMgmt.do">공간평가 평가법관리</a></u><br></span>
						<span id="m03" style="float: left;margin-right: 20px;"><strong><br>Instrument<br></strong><strong><br>분석기기<br></strong>보유 기기<br>기기 교육<br><strong><br>신뢰성시험 장비<br></strong><u><a href="/iris/mchn/open/rlabMchn/retrieveMachineList.do">보유 장비</a></u><br><strong><br>공간성능평가 Tool<br></strong>보유 TOOL<br><strong><br>관리<br></strong>분석기기 예약관리<br><u><a href="/iris/mchn/mgmt/retrieveRlabTestEqipPrctMgmtList.do">신뢰성시험장비 예약관리</a></u><br><u><a href="/iris/mchn/mgmt/spaceEvToolUseMgmtList.do">공간평가Tool 사용관리</a></u><br>분석기기 교육관리<br>소모품 관리<br><u><a href="/iris/mchn/mgmt/rlabTestEqipList.do">신뢰성시험 장비관리</a></u><br>분석기기 관리<br>신뢰성시험 장비관리<br><u><a href="/iris/mchn/mgmt/retrieveSpaceEvToolList.do">공간성능평가 Tool관리</a></u><br></span>
						<span id="m04" style="float: left;margin-right: 20px;"><strong><br>Fixed Assets<br></strong><strong><br>고정자산<br></strong>자산관리<br>자산이관목록<br>자산실사<br>자산폐기<br>실사기간관리<br>자산담당자관리<br></span>
						<span id="m05" style="float: left;margin-right: 20px;"><strong><br>Knowledge<br></strong><strong><br>공지/게시판<br></strong>공지사항<br>시장/기술정보<br>교육/세미나<br>학회/컨퍼런스<br>전시회<br>특허<br>표준양식<br>특허정보 리스트<br>안전/환경/보건<br>규정/업무Manual<br>사외전문가<br>연구소주요일정<br><strong><br>Q&amp;A<br></strong>Group R&amp;D<br>일반 Q&amp;A<br><strong><br>연구산출물<br></strong>고분자재료 Lab<br>점착기술 Lab<br>무기소재 Lab<br>코팅기술 Lab<br>연구소  공통<br>LG화학 연구소<br>LG화학 테크센터<br>LG하우시스 연구소<br></span>
						<span id="m05" style="float: left;margin-right: 20px;"></span>
						<span id="m06" style="float: left;margin-right: 20px;"><strong><br>Statistics<br></strong><strong><br>연구과제<br></strong>프로젝트통계<br>일반과제통계<br>대외협력과제통계<br>국책과제통계<br>포트폴리오<br>신제품매출실적<br><strong><br>기기분석<br></strong>분석완료<br>분석 기기사용<br>OPEN 기기사용<br>분석 업무현황<br>사업부 통계<br>담당자 분석통계<br><strong><br>신뢰성시험<br></strong>연도별 통계<br>기간별 통계<br>장비사용 통계<br><strong><br>공간평가<br></strong>통계1<br>통계2<br>통계3<br>통계4<br>통계5<br><strong><br>관리<br></strong>공통코드관리<br></span>
					 -->
					</div>
				</div>
				<!-- //전체메뉴 리스트 -->
        	</div>

        	<div class="menu_link">
        		<p>주요메뉴</p>
        		<ul>
        			<li><a href="javascript:moveMenu('PJ', 'IRIPJ0400', '/prj/mm/retrieveMmInInfo.do', 'IRIPJ0401')">M/M 입력</a></li>
        			<li><a href="javascript:moveMenu('PJ', 'IRIPJ0100', '/prj/rsst/retrievePrjClsList.do', 'IRIPJ0102')">월마감</a></li>
        			<li><a href="javascript:moveMenu('AN', 'IRIAN0100', '/anl/anlRqprList.do', 'IRIAN0101')">분석의뢰</a></li>
        			<li><a href="javascript:moveMenu('AN', '', '/anl/main.do', 'IRIAN0001')">분석 Main</a></li>
        		</ul>
        	</div>

        	<div class="left_phone help">
        		<img src="/iris/resource/web/images/common/sub_left_m_contact.png" style="cursor: pointer;" onclick="goHelpDesk()">
        	</div>


        </div>
        <!-- //좌측 추가 영역 -->
    </div>
    </div>
    <!--footer-->
	<%@ include file="/WEB-INF/jsp/web/main/footer.jspf" %>

</div>

</body>
</html>