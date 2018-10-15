<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*,
				 java.util.*,
				 devonframe.util.NullUtil,
				 devonframe.util.DateUtil"%>

<%--
/*
 *************************************************************************
 * $Id		: anlMain.jsp
 * @desc    : 분석 메인 화면
 *------------------------------------------------------------------------
 * VER	DATE		AUTHOR		DESCRIPTION
 * ---	-----------	----------	-----------------------------------------
 * 1.0  2017.08.25  오명철		최초생성
 * ---	-----------	----------	-----------------------------------------
 * WINS UPGRADE 1차 프로젝트
 *************************************************************************
 */
--%>

<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<%@ include file="/WEB-INF/jsp/include/rui_header.jspf"%>

<title><%=documentTitle%></title>
    <link type="text/css" href="<%=cssPath%>/main.css" rel="stylesheet">
    <link type="text/css" href="<%=cssPath%>/swiper.min.css" rel="stylesheet">
	<script src="<%=scriptPath%>/main.js" type="text/javascript" charset="utf-8"></script>
    <script src="<%=scriptPath%>/swiper.min.js"></script>

<style>
 .bgcolor-gray {background-color: #999999}
 .bgcolor-white {background-color: #FFFFFF}
</style>

	<script type="text/javascript">

	var   adminChk = 'N';


		Rui.onReady(function() {

			if("<c:out value='${inputData._roleId}'/>".indexOf('WORK_IRI_T06') > -1) {
				adminChk = "Y";
			}

			var swiper = new Swiper('.swiper-container', {
				slidesPerView: 1,
				spaceBetween: 30,
				loop: true,
				pagination: {
					el: '.swiper-pagination',
			        clickable: true,
			    },
				autoplay :{
					delay:3000,
					disabldOnInteraction:true
				},
				loop: true
			});
        });

		function fncMovemenu(cd){

			var userNm = encodeURIComponent('${inputData._userNm}');

			if(adminChk == "Y"){
				var setUrl = "/anl/anlRqprList4Chrg.do?acpcStCd="+cd+"&anlChrgNm="+userNm;
				moveMenu('AN', 'IRIAN0100', setUrl, 'IRIAN0102')
			}else{
				var setUrl = encodeURIComponent("/anl/anlRqprList.do?acpcStCd="+cd+"&anlChrgNm="+userNm);
				moveMenu('AN', 'IRIAN0100', setUrl, 'IRIAN0102')
			}
		}
	</script>
    </head>
    <body class="pj_body">
		<div id="Wrap" style="background:#f4f4f4; height:66px !important;overflow: visible;">
		    <!--header-->
		    <div class=gnb_bg></div>
		    <div class="width_layout">
		    <%@ include file="/WEB-INF/jsp/web/main/top.jspf" %>
		    </div>
		    <div class="gnb_line"></div>

<style>
.ts_main .side_bar_con {width:215px !important; height:634px !important;}
.side_bar_con .swiper-pagination.swiper-pagination-clickable {text-align:center;}
.ts_main .body_con {
    margin-left: 273px !important;
    margin-right: 226px;
}
.swiper-wrapper > div  {bakcground:#ddd !important;; height:150px !important;}
.ts_main .body_con > div {width:100%; border-radius: 16px; background: #fff; position: relative; margin-top:0; margin-bottom: 18px; box-sizing:border-box; padding:27px 30px;}
.ts_main .body_con > div.fir_subject_con {height:300px;}
.ts_main .body_con > div > div {width:47.5% !important;}
.ts_main .body_con > div > div:first-child {margin-right:5% !important;}
.ts_main .body_con > div > div.notice_con {height:150px;}

.reser_txt li:nth-child(2) {width:330px; height:150px;}
.reser_txt li:nth-child(2) p {height:150px; width:330px;overflow: hidden;
    /*white-space: nowrap;
    text-overflow: ellipsis;*/}

.swiper-pagination.swiper-pagination-clickable {text-align:left;}
.notice_con, .notice_con .swiper-container {width:100%; height:205px;height:205px;}
.fir_subject_con .reservation_con {height:150px;}
.fir_subject_con .reservation_con .reser_txt  {width:92%;} 

.fir_subject_con .notice_con .album-wrap {width:100% !important;}
.ts_main .main_footer_w {position:fixed;}
.body_con.pj_content .side_scroll_con .swiper-container02 {margin-left:0; height:210px;}

.edu_con ul li {position:relative;}
.edu_con ul li .speech {position:absolute; left:0;top:0; width:25px;}
.edu_con ul li .contxt {width:auto !important; padding-left:45px; font-size:12.5px;}
.edu_con ul li .day { font-size:12px;}
.analysis_con.edu_con ul li .list_txt {display:table-cell; width:100%;}
.analysis_con.edu_con .speech { width:21%; position:relative; }
.analysis_con.edu_con ul li .contxt {display:table-cell; padding-left:0; width:54% !important;}
.analysis_con.edu_con .day {display:table-cell; font-size:12px;width:85px; text-align:right; width:18%; padding-left:0;}

.ts_main #prj_right { position: absolute; right: 1%; top: 0; width: 190px;}
.ts_main #prj_right .QuickMenu_con02  { width: 100%;height:440px; border-radius: 16px;box-sizing:border-box;background: #fff; position: relative; margin-top:16px; overflow:hidden;}
.ts_main #prj_right h4 { color: #c40452; font-weight: 600; text-align:center; font-size: 16px; padding-top:5px; border-bottom:1px solid #ddd; padding-left:20px;  margin-bottom:0; line-height:2.5;}
.ts_main #prj_right .QuickMenu_con02 ul { margin:0 auto;margin-bottom:10px;margin-top:10px; width:80%;}
.ts_main #prj_right .QuickMenu_con02 ul li {border:0 none; float:none; width:100%; padding:5px 0 10px 0;}
.ts_main #prj_right .QuickMenu_con02 ul li + li {border-top:1px dotted #888;}
.QuickMenu_con02 h5 {margin-top:0;}
</style>
		    <!--content-->
		    <div class="Main_content ts_main" id="main_iris">
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

		        	<c:set var="listLink02" value="moveMenu('AN', 'IRIAN0100', '/anl/anlRqprList.do?acpcStCd=02', 'IRIAN0101')"/>
		        	<c:set var="listLink03" value="moveMenu('AN', 'IRIAN0100', '/anl/anlRqprList.do?acpcStCd=03, 'IRIAN0101')"/>
		        	<c:set var="listLink06" value="moveMenu('AN', 'IRIAN0100', '/anl/anlRqprList.do?acpcStCd=06', 'IRIAN0101')"/>

		        	<c:if test="${fn:indexOf(inputData._roleId, 'WORK_IRI_T06') > -1}">
			        	<c:set var="listLink02" value="moveMenu('AN', 'IRIAN0100', '/anl/anlRqprList4Chrg.do?acpcStCd=02', 'IRIAN0102')"/>
			        	<c:set var="listLink03" value="moveMenu('AN', 'IRIAN0100', '/anl/anlRqprList4Chrg.do?acpcStCd=03', 'IRIAN0102')"/>
			        	<c:set var="listLink06" value="moveMenu('AN', 'IRIAN0100', '/anl/anlRqprList4Chrg.do?acpcStCd=06', 'IRIAN0102')"/>
		        	</c:if>
		                <ul class="request_numbering">
		                    <li>
		                        <div class="number" onClick="fncMovemenu('02')" style="cursor:pointer;"><span><c:out value="${anlCntInfo1.acpcCnt}" default="0"/></span></div>
		                        <div class="txt" onClick="fncMovemenu('02')" style="cursor:pointer;">접수대기</div>
		                    </li>
		                    <li>
		                        <div class="number" onClick="fncMovemenu('03')" style="cursor:pointer;"><span><c:out value="${anlCntInfo1.rqprCnt}" default="0"/></span></div>
		                        <div class="txt" onClick="fncMovemenu('03')" style="cursor:pointer;">분석진행</div>
		                    </li>
		                    <li>
		                        <div class="number" onClick="fncMovemenu('06')" style="cursor:pointer;"><span><c:out value="${anlCntInfo1.completeCnt}" default="0"/></span></div>
		                        <div class="txt" onClick="fncMovemenu('06')" style="cursor:pointer;">결과검토</div>
		                    </li>
		                </ul>
		                <div class="side_scroll_con">
		                    <div class="swiper-container">
		                        <div class="swiper-wrapper mb20">
			                <c:choose>
			                	<c:when test="${fn:indexOf(inputData._roleId, 'WORK_IRI_T06') > -1}">
		                            <div class="swiper-slide">
		                                <ul class="side_scroll_fir">
		                                    <li>
		                                        <span class="circle"></span>
		                                        <div><p>전월 미완료 건</p><span class="number"><strong><c:out value="${anlCntInfo2.IncompleteCnt}" default="0"/></strong>건</span></div>
		                                    </li>
		                                    <li>
		                                        <span class="circle"></span>
		                                        <div><p>이번 달 접수 건</p><span class="number"><strong><c:out value="${anlCntInfo2.recpetCnt}" default="0"/></strong>건</span></div>
		                                    </li>
		                                  <%--   <li>
		                                        <span class="circle"></span>
		                                        <div><p>이번 달 진행 건</p><span class="number"><strong><c:out value="${anlCntInfo2.progressCnt}" default="0"/></strong>건</span></div>
		                                    </li> --%>
		                                    <li>
		                                        <span class="circle"></span>
		                                        <div><p>이번 달 완료 건</p><span class="number"><strong><c:out value="${anlCntInfo2.completeCnt}" default="0"/></strong>건</span></div>
		                                    </li>
		                                    <li>
		                                        <span class="circle02"></span>
		                                        <div><p>분석 완료율</p><span class="number"><strong><c:out value="${anlCntInfo2.completeRate}" default="0"/></strong>%</span></div>
		                                    </li>
		                                    <li>
		                                        <span class="circle02"></span>
		                                        <div><p>결과통보 준수율</p><span class="number"><strong><c:out value="${anlCntInfo2.avgCmplWkDdRate}" default="0"/></strong>%</span></div>
		                                    </li>
		                                </ul>
		                                <div class="cir_line"></div>
		                            </div>
			                	</c:when>
			                	<c:otherwise>
		                            <div class="swiper-slide">
		                                <ul class="side_scroll_fir" style="min-height:213px;">
		                        <c:choose>
		                        	<c:when test="${fn:length(anlRqprList) == 0}">
		                                    <li>데이터가 존재하지 않습니다.</li>
		                        	</c:when>
		                        	<c:otherwise>
		                                <c:forEach items="${anlRqprList}" var="data" varStatus="status">
		                                    <li>
		                                        <span class="circle<c:if test="${status.last}">02</c:if>"></span>
		                                        <div onClick="moveMenu('AN', 'IRIAN0100', '/anl/anlRqprDetail.do?rqprId=<c:out value="${data.rqprId}"/>', 'IRIAN0101')" style="cursor:pointer;"><p>[<c:out value="${data.acpcStNm}"/>]</p>/<c:out value="${data.acpcNo}"/><br/>- <c:out value="${data.anlNm}"/></div>
		                                    </li>
		                                </c:forEach>
		                        	</c:otherwise>
		                        </c:choose>
		                                </ul>
		                                <div class="cir_line"></div>
		                            </div>

		                            <div class="swiper-slide">
		                                <ul class="side_scroll_fir">
		                        <c:choose>
		                        	<c:when test="${fn:length(anlMchnEduReqList) == 0}">
		                                    <li>데이터가 존재하지 않습니다.</li>
		                        	</c:when>
		                        	<c:otherwise>
		                                <c:forEach items="${anlMchnEduReqList}" var="data" varStatus="status">
		                                    <li>
		                                        <span class="circle<c:if test="${status.last}">02</c:if>"></span>
		                                        <div><p>[<c:out value="${data.eduStNm}"/>]</p> <c:out value="${data.eduDt}"/> (<c:out value="${data.eduFromTim}"/>~<c:out value="${data.eduToTim}"/>)<br/>- <c:out value="${data.eduNm}"/></div>
		                                    </li>
		                                </c:forEach>
		                        	</c:otherwise>
		                        </c:choose>
		                                </ul>
		                                <div class="cir_line"></div>
		                            </div>

		                            <div class="swiper-slide">
		                                <ul class="side_scroll_fir">
		                        <c:choose>
		                        	<c:when test="${fn:length(anlMchnReqList) == 0}">
		                                    <li>데이터가 존재하지 않습니다.</li>
		                        	</c:when>
		                        	<c:otherwise>
		                                <c:forEach items="${anlMchnReqList}" var="data" varStatus="status">
		                                    <li>
		                                        <span class="circle<c:if test="${status.last}">02</c:if>"></span>
		                                        <div><p>[<c:out value="${data.prctScnNm}"/>]</p> <c:out value="${data.prctDt}"/> (<c:out value="${data.prctFromTim}"/>~<c:out value="${data.prctToTim}"/>)<br/>- <c:out value="${data.prctTitl}"/></div>
		                                    </li>
		                                </c:forEach>
		                        	</c:otherwise>
		                        </c:choose>
		                                </ul>
		                                <div class="cir_line"></div>
		                            </div>
			                	</c:otherwise>
			                </c:choose>
		                        </div>
		                    <c:if test="${fn:indexOf(inputData._roleId, 'WORK_IRI_T06') == -1}">
		                        <div class="swiper-pagination"></div>
		                    </c:if>
		                    </div>
		                </div>
		            </div>
		        </div>

		        <!--right-->
		        <div class="body_con pj_content">
		            <!--fir-->
		            <div class="fir_subject_con">
		                		                <div class="notice_con">
		                <h4 class="notice_title">NOTICE<span class="plus"><a href="javascript:moveMenu('AN', 'IRIAN0200', '/anl/bbs/retrieveAnlBbsList.do', 'IRIAN0201')">&#43;</a></span></h4>
		                <div class="side_scroll_con">
		                        <div class="swiper-container swiper-container03">
		                            <div class="swiper-wrapper">

                    <c:choose>
                    	<c:when test="${fn:length(anlNoticeList) == 0}">
                                <li>데이터가 존재하지 않습니다.</li>
                    	</c:when>
                    	<c:otherwise>
                            <c:forEach items="${anlNoticeList}" var="noticeInfo" varStatus="status">
		                        <div class="swiper-slide">
		                                    <ul class="reser_txt" onClick="moveMenu('AN', 'IRIAN0200', '/anl/lib/anlNoticeInfo.do?bbsId=<c:out value="${noticeInfo.bbsId}"/>', 'IRIAN0201')">
		                                        <li><c:out value="${noticeInfo.bbsTitl}"/></li>
		                                        <li><c:out value="${noticeInfo.bbsSbc}" escapeXml="false"/></li>
		                                    </ul>
		                                </div>
                            </c:forEach>
                    	</c:otherwise>
                    </c:choose>
		                </div>
		                <div class="swiper-pagination"></div>
		                </div>
		                </div>
		                </div>

		                <div class="reservation_con">
		                    <h4 class="notice_title">분석기기 예약현황<span class="plus"><a href="javascript:moveMenu('DE', 'IRIDE0100', '/mchn/open/mchn/retrieveMachineList.do', 'IRIDE0102')">&#43;</a></span></h4>
		                    <div class="side_scroll_con">
		                        <div class="swiper-container swiper-container02">
		                            <div class="swiper-wrapper">
	                    <c:choose>
	                    	<c:when test="${fn:length(anlMchnSettingList) == 0}">
                                <li>데이터가 존재하지 않습니다.</li>
	                    	</c:when>
	                    	<c:otherwise>
	                            <c:forEach items="${anlMchnSettingList}" var="mchnInfo" varStatus="status">
		                                <div class="swiper-slide">
		                                    <ul class="reser_txt" onClick="moveMenu('DE', 'IRIDE0100', '/mchn/open/mchn/retrieveMchnDtl.do?mchnInfoId=<c:out value="${mchnInfo.mchnInfoId}"/>&tabId=PRCT', 'IRIDE0102')">
		                                        <li><c:out value="${mchnInfo.mchnNm}"/></li>
				                    <c:choose>
				                    	<c:when test="${fn:length(mchnInfo.anlMchnReservList) == 0}">
			                                	<li>데이터가 존재하지 않습니다.</li>
				                    	</c:when>
				                    	<c:otherwise>
				                            <c:forEach items="${mchnInfo.anlMchnReservList}" var="data" varStatus="status">
		                                        <li><c:out value="${data.prctTim}"/> <span><c:out value="${data.rgstNm}"/> / <c:out value="${data.rgstDeptNm}"/></span></li>
				                            </c:forEach>
				                    	</c:otherwise>
				                    </c:choose>
		                                    </ul>
		                                </div>
	                            </c:forEach>
	                    	</c:otherwise>
	                    </c:choose>
		                            </div>
		                            <div class="swiper-pagination"></div>
		                        </div>
		                    </div>
		                </div>
		            </div>
		            <!--sec-->
		            <div class="sec_subject_con mt25">
		                <div class="edu_con">
		                    <h4 class="notice_title">교육신청<span class="plus"><a href="javascript:moveMenu('DE', 'IRIDE0100', '/mchn/open/edu/retrieveEduList.do', 'IRIDE0104')">&#43;</a></span></h4>
		                    <ul>
                    <c:choose>
                    	<c:when test="${fn:length(anlEduReqList) == 0}">
                                <li>데이터가 존재하지 않습니다.</li>
                    	</c:when>
                    	<c:otherwise>
                            <c:forEach items="${anlEduReqList}" var="data" varStatus="status">
		                        <li>
		                            <div class="list_txt" onClick="moveMenu('DE', 'IRIDE0100', '/mchn/open/edu/retrieveEduInfo.do?mchnEduId=<c:out value="${data.mchnEduId}"/>', 'IRIDE0104')">
		                                <span class="speech<c:if test="${data.eduScnNm == '정시'}"> purple</c:if>"><c:out value="${data.eduScnNm}"/></span>
		                                <p class="contxt" style="width:250px; overflow:hidden; white-space:nowrap; text-overflow:ellipsis;"><c:out value="${data.eduNm}"/></p>
		                                <p class="day"><c:out value="${data.pttFromDt}"/> ~ <c:out value="${data.pttToDt}"/></p>
		                            </div>
		                            <div class="icon_recruitment_active<c:if test="${data.eduPttStNm == '마감' }"> icon_recruitment_disa</c:if>"><c:out value="${data.eduPttStNm}"/></div>
		                        </li>
                            </c:forEach>
                    	</c:otherwise>
                    </c:choose>
		                    </ul>
		                </div>
		                <div class="analysis_con edu_con">
		                    <h4 class="notice_title">주요 분석자료<span class="plus"><a href="javascript:moveMenu('AN', 'IRIAN0200', '/anl/lib/retrieveAnlLibList.do', 'IRIAN0202')">&#43;</a></span></h4>
		                    <ul>
                    <c:choose>
                    	<c:when test="${fn:length(anlMainDataList) == 0}">
                                <li>데이터가 존재하지 않습니다.</li>
                    	</c:when>
                    	<c:otherwise>
                            <c:forEach items="${anlMainDataList}" var="data" varStatus="status">
		                        <li>
		                            <div class="list_txt" onClick="moveMenu('AN', 'IRIAN0200', '/anl/lib/retrieveAnlLibList.do?bbsId=<c:out value="${data.bbsId}"/>&bbsCd=<c:out value="${data.bbsCd}"/>', 'IRIAN0202')">
	                            <c:choose>
	                            	<c:when test="${data.bbsCd == '02'}">
		                                <span class="speech mint"><c:out value="${data.bbsNm}"/></span>
	                            	</c:when>
	                            	<c:when test="${data.bbsCd == '03'}">
		                                <span class="speech brown"><c:out value="${data.bbsNm}"/></span>
	                            	</c:when>
	                            	<c:otherwise>
		                                <span class="speech orange"><c:out value="${data.bbsNm}"/></span>
	                            	</c:otherwise>
	                            </c:choose>
		                                <p class="contxt" style="width:210px; overflow:hidden; white-space:nowrap; text-overflow:ellipsis;"><c:out value="${data.bbsTitl}"/></p>
		                                <p class="day"><c:out value="${data.rgstDt}"/></p>
		                            </div>
		                        </li>
                            </c:forEach>
                    	</c:otherwise>
                    </c:choose>
		                    </ul>
		                </div>
		            </div>
		            <!--thi-->
		            <!--
		            <div class="QuickMenu_con02">
		                <h4 class="notice_title">Quick Menu</h4>
		                <ul>
		                    <li>
		                        <a href="javascript:moveMenu('AN', 'IRIAN0100', '/anl/anlRqprList.do', 'IRIAN0101')"><p class="icon_quick"></p></a>
		                        <h5><a href="javascript:moveMenu('AN', 'IRIAN0100', '/anl/anlRqprList.do', 'IRIAN0101')">분석의뢰</a></h5>
		                    </li>
		                    <li>
		                        <a href="javascript:moveMenu('DE', 'IRIDE0100', '/mchn/open/mchn/retrieveMachineList.do', 'IRIDE0102')"><p class="icon_quick"></p></a>
		                        <h5><a href="javascript:moveMenu('DE', 'IRIDE0100', '/mchn/open/mchn/retrieveMachineList.do', 'IRIDE0102')">보유기기</a></h5>
		                    </li>
		                    <li>
		                        <a href="javascript:moveMenu('AN', 'IRIAN0200', '/anl/lib/retrieveAnlLibList.do', 'IRIAN0202')"><p class="icon_quick"></p></a>
		                        <h5><a href="javascript:moveMenu('AN', 'IRIAN0200', '/anl/lib/retrieveAnlLibList.do', 'IRIAN0202')">분석자료실</a></h5>
		                    </li>
		                </ul>
		            </div> -->
		        </div>
<style>
/*분석메인, 프로젝트메인 공통 */
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
				<!-- Right -->
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
        	
		   			<div class="QuickMenu_con02">
		   				<h4 class="notice_title">Quick Menu</h4>
		                <ul>
		                    <li>
		                        <a href="javascript:moveMenu('AN', 'IRIAN0100', '/anl/anlRqprList.do', 'IRIAN0101')"><p class="icon_quick"></p></a>
		                        <h5><a href="javascript:moveMenu('AN', 'IRIAN0100', '/anl/anlRqprList.do', 'IRIAN0101')">분석의뢰</a></h5>
		                    </li>
		                    <li>
		                        <a href="javascript:moveMenu('DE', 'IRIDE0100', '/mchn/open/mchn/retrieveMachineList.do', 'IRIDE0102')"><p class="icon_quick"></p></a>
		                        <h5><a href="javascript:moveMenu('DE', 'IRIDE0100', '/mchn/open/mchn/retrieveMachineList.do', 'IRIDE0102')">보유기기</a></h5>
		                    </li>
		                    <li>
		                        <a href="javascript:moveMenu('AN', 'IRIAN0200', '/anl/lib/retrieveAnlLibList.do', 'IRIAN0202')"><p class="icon_quick"></p></a>
		                        <h5><a href="javascript:moveMenu('AN', 'IRIAN0200', '/anl/lib/retrieveAnlLibList.do', 'IRIAN0202')">분석자료실</a></h5>
		                    </li>
		                </ul>
		   			</div>
		   			
		   			<div class="left_phone help">
		        		<img src="/iris/resource/web/images/common/sub_left_m_contact.png" style="cursor: pointer;" onclick="goHelpDesk()">
		        	</div>
		   		</div>
		   		<!-- //Right -->
		    </div>
		    <!--footer-->
			<%@ include file="/WEB-INF/jsp/web/main/footer.jspf" %>
		</div>
    </body>
</html>