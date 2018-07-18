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
    
<div id="Wrap">
    <!--header-->
    <div class=gnb_bg></div>
    <div class="width_layout">
	<%@ include file="/WEB-INF/jsp/web/main/top.jspf" %>
    </div>      
    <div class="gnb_line"></div>

    <!--content-->
    <div class="Main_content">
        <!--left-->
        <div class="side_bar_con">
            <div class="side_layout">
                <div class="profile_naming">
                    <img src="<%=imagePath%>/newIris/profile_img.png" class="profile_img">
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
                
                <!-- 하드코딩 영역 시작 : 추후 오픈시 내용 추가 -->
                <div class="side_scroll_con">
                    <div class="swiper-container">
                        <div class="swiper-wrapper" style="height:30px;"><!-- 하드코딩 영역 시작 : 내용이 없어서 높이 하드코딩 -->
                            
                        </div>
                        <div class="swiper-pagination"></div>    
                    </div>
					<%@ include file="/WEB-INF/jsp/web/main/leftBanner.jspf" %>
                </div>    
            </div>    
        </div>
					
        <!--right-->
        <div class="body_con">
            <!--fir-->
            <div class="fir_subject_con">
            	<div class="main_img"><img src="<%=imagePath%>/newIris/main_img.png" /></div> 
                <div class="notice_con">
                <div class="album-wrap">
                    <h4 class="notice_title">NOTICE<span class="plus"><a href="javascript:moveMenu('KL', 'IRIKL0100', '/knld/pub/retrievePubNoticeList.do', 'IRIKL0101')">&#43;</a></span></h4>
                    <ul class="album clfix">
	                    <c:choose>
	                	<c:when test="${fn:length(noticeList) == 0}">
	                    	<li>데이터가 존재하지 않습니다.</li>
	                    </c:when>
	                    <c:otherwise>	
		                    <c:forEach var="notice" items="${noticeList}">
							    <li>
							    	<a href="javascript:moveMenu('KL', 'IRIKL0100', '/knld/pub/pubNoticeInfo.do?pwiId=${notice.pwiId}&pageMode=V', 'IRIKL0101')">
			                            <div class="title"><c:out value="${notice.titleNm}"/></div>
			                            <span class="news_icon">소식</span>
			                            <div class="contxt"><c:out value="${notice.sbcNm}" escapeXml="false"/></div>
			                        </a>
		                        </li>
							</c:forEach>
						</c:otherwise>
		                </c:choose>
                    </ul>
                </div>
                <ul class="bt-roll">
                	<c:choose>
	                <c:when test="${fn:length(noticeList) == 0}">
	                	<li><a href="#"><img src="<%=imagePath%>/newIris/btn_circle_.png"></a></li>
	                </c:when>
	                <c:otherwise>
	                	<c:forEach var="notice" items="${noticeList}" varStatus="status">
		                	<c:choose>
							    <c:when test="${status.count eq 1}">
							        <li><a href="#"><img src="<%=imagePath%>/newIris/btn_circle_.png"></a></li>
							    </c:when>
							    <c:otherwise>
									<li><a href="#"><img src="<%=imagePath%>/newIris/btn_circle.png"></a></li>
							    </c:otherwise>
							</c:choose>
						</c:forEach>
					</c:otherwise>
					</c:choose>
                </ul>
                </div>    
                
                <div class="quickMenu_con">
                    <h4 class="notice_title">QUICK MENU<!-- <span class="plus"><a href="javascript:void(0);">&#43;</a></span> --></h4>
                    <ul>
                        <li id="quickMenu01"><a href="javascript:moveMenu('PJ', 'IRIPJ0400', '/prj/mm/retrieveMmInInfo.do', 'IRIPJ0401')"><span>M/M입력</span></a></li>
                        <li id="quickMenu02"><a href="javascript:moveMenu('PJ', 'IRIPJ0500', '/prj/mgmt/wbsStd/wbsStdList.do', 'IRIPJ0501')"><span>WBS</span></a></li>
                        <li id="quickMenu03"><a href="javascript:moveMenu('AN', 'IRIAN0100', '/anl/anlRqprList.do', 'IRIAN0101')"><span>분석의뢰</span></a></li>
                    </ul>
                </div>
            </div>
            <!--sec-->
            <div class="sec_subject_con mt25">
                <div class="schedule_con">
                    <h4 class="notice_title">연구소 주요일정<span class="plus"><a href="javascript:moveMenu('KL', 'IRIKL0100', '/knld/pub/retrieveLabSchedule.do', 'IRIKL0112')">&#43;</a></span></h4>
                    <!--tab-->
                    <div class="tab_con tabbox">
                        <ul class="Mtabs">
                            <li><a href="#panel1" >금주일정</a></li>
                            <li><a href="#panel2" >차주일정</a></li>
                        </ul>
                        <div class="panels">
                            <div id="panel1" class="panel">
                                <table class="main_sec_table01">
                                    <colgrop></colgrop>
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
                            
                            <div id="panel2" class="panel">
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
                <div class="qna_con">
                    <h4 class="notice_title">Q&amp;A<span class="plus"><a href="javascript:moveMenu('KL', 'IRIKL0200', '/knld/qna/retrieveGeneralQnaList.do', 'IRIKL0202')">&#43;</a></span></h4>
                    <ul>
                    	<c:choose>
	                	<c:when test="${fn:length(qnaList) == 0}">
		                	<li>데이터가 존재하지 않습니다.</li>
	                	</c:when>
	                	<c:otherwise>
	                    	<c:forEach var="qna" items="${qnaList}">
								<li>
		                        	<div><a href="javascript:moveMenu('KL', 'IRIKL0200', '/knld/qna/generalQnaInfo.do?qnaId=${qna.qnaId}', 'IRIKL0202')"><c:out value="${qna.titleNm}"/></a> 
			                            <c:if test="${qna.newFlag eq 'Y' }">
			                            	<span class="new">new</span>
			                            </c:if>
		                           	</div>
		                            <p><c:out value="${qna.frstRgstDt}"/></p>
		                        </li>
							</c:forEach>
						</c:otherwise>
						</c:choose>
                    </ul>
                </div>
            </div>
            <!--thi-->
           <!--  <div class="task_con"> -->
           <div class="task_con">
                <h4 class="notice_title">나의 과제 현황<span class="plus"><a href="javascript:fnTssListPageMove();">&#43;</a></span></h4>
                <!--tab-->
                <div class="tab_con02 tabbox02">
                    <ul class="tabs02">
                        <li id="tssTab01"><a href="#panel3" >일반</a></li>
                        <li id="tssTab02"><a href="#panel4" >대외협력</a></li>
                        <li id="tssTab03"><a href="#panel5" >국책</a></li>
                    </ul>
                </div>
                <div class="panels">
                    <div id="panel3" class="panel">
                    <!--table-->
                    <div class="">
                       <!-- 
                        <ul class="progress">
                            <li>진척도</li>
                            <li><span class="progress_bg01"></span>정상</li>
                            <li><span class="progress_bg02"></span>단축</li>
                            <li><span class="progress_bg03"></span>지연</li>
                        </ul>
                        -->
                        <table class="table02 " summary="분류">
                            <caption>분류</caption>
                            <colgroup>
	                            <col width="17%" />
	                            <col width="18%" />
	                            <col width="39%" />
	                            <col width="8%" />
	                            <col width="18%" />
	                            <!-- <col width="6%" />
	                            <col width="6%" /> -->
                            </colgroup>
                            <thead>
                                <tr>
                                    <th>조직</th>
                                    <th>프로젝트명</th>
                                    <th>과제명</th>
                                    <th>과제리더</th>
                                    <th>기간</th>
                                    <!-- <th>상태</th>
                                    <th>진척도</th> -->
                                </tr>
                            </thead>
                            <tbody>
                            
                            <c:choose>
                            <c:when test="${fn:length(genList) == 0}">
                            	<tr><td colspan="7">진행중인 과제가 없습니다.</td></tr>
                            </c:when>
                            <c:otherwise>
	                            <c:forEach var="genList" items="${genList}">
							    <tr>
	                                <td><c:out value="${genList.deptName}"/></td>
	                                <td><a href="javascript:fnTssPageMove('G','${genList.pgsStepCd}', '${genList.grsEvSt}', '${genList.tssCd}', '${genList.tssSt}', '${genList.progressrate}');" ><c:out value="${genList.prjNm}"/></a></td>
	                                <td align="left"><a href="javascript:fnTssPageMove('G','${genList.pgsStepCd}', '${genList.grsEvSt}', '${genList.tssCd}', '${genList.tssSt}','${genList.progressrate}');" ><c:out value="${genList.tssNm}"/></a></td>
	                                <td><c:out value="${genList.saUserName}"/></td>
	                                <td><c:out value="${genList.tssStrtDd}"/>~<c:out value="${genList.tssFnhDd}"/></td>
	                                <%-- 
	                                <td><c:out value="${genList.pgsStepNm}"/></td>
	                                <td>
	                                                                	
	                                 <c:set var = "progressrate" value = "${genList.progressrate}"/>
	                                 <c:set var = "arrPrg" value = "${fn:split(progressrate, '/')}" />
	                                 
	                               
	                                 <c:set var = "rWgvl" value = "${arrPrg[0]}" /> <!-- // 실적 -->
	                                 <c:set var = "gWgvl" value = "${arrPrg[1]}" /> <!-- // 목표 -->
	                           
	                                 <c:if test="${rWgvl==''}">
									     <c:set var = "rWgvl" value = "0" /> <!-- // 실적 -->
									 </c:if>
	                                  <c:if test="${gWgvl==''}">
									     <c:set var = "gWgvl" value = "0" /> <!-- // 목표 -->
									 </c:if>
	                             
								    <c:choose>
									    <c:when test="${rWgvl > gWgvl}">
									        <img src="<%=contextPath%>/resource/images/icon/sign_blue.png"/>
									    </c:when>
									     <c:when test="${rWgvl < gWgvl}">
									        <img src="<%=contextPath%>/resource/images/icon/sign_red.png"/>
									    </c:when>
									    <c:otherwise>
									       <img src="<%=contextPath%>/resource/images/icon/sign_green.png"/>
									    </c:otherwise>
									</c:choose>                       
	                                </td> --%>
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
    </div>
    <!--footer-->
	<%@ include file="/WEB-INF/jsp/web/main/footer.jspf" %>
    
</div>
    
</body>
</html>