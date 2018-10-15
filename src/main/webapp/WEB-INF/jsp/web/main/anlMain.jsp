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
			    }
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
.ts_main .side_bar_con {width:215px !important;}
.ts_main .body_con {
    margin-left: 280px !important;
    margin-right: 225px;
}
.ts_main .body_con > div {width:100%; border-radius: 16px; background: #fff; position: relative; margin-top:0; margin-bottom: 18px; box-sizing:border-box; padding:27px 30px;}
.ts_main .body_con > div > div {width:47.5% !important;}
.ts_main .body_con > div > div:first-child {margin-right:5% !important;}
.fir_subject_con .reservation_con {height:150px;}
 
.fir_subject_con .notice_con .album-wrap {width:100% !important;}
.ts_main .main_footer_w {position:fixed;}
.body_con.pj_content .side_scroll_con .swiper-container02 {margin-left:0;}

.edu_con ul li {position:relative;}
.edu_con ul li .speech {position:absolute; left:0;top:0; width:25px;}
.edu_con ul li .contxt {width:auto !important; padding-left:45px; font-size:12.5px;}
.edu_con ul li .day { font-size:12px;}
.analysis_con.edu_con ul li .list_txt {display:table-cell; width:100%;}
.analysis_con.edu_con .speech { width:17%; position:relative; }
.analysis_con.edu_con ul li .contxt {display:table-cell; padding-left:0; width:58% !important;}
.analysis_con.edu_con .day {display:table-cell; font-size:12px;width:85px; text-align:right; width:18%; padding-left:0;}



.ts_main #prj_right { position: absolute; right: 1%; top: 0; width: 190px;}
.ts_main #prj_right .QuickMenu_con02  { width: 100%; border-radius: 16px;box-sizing:border-box;background: #fff; position: relative; margin-top: 24px; overflow:hidden;}
.ts_main #prj_right h4 { color: #c40452; font-weight: 600; font-size: 16px; padding-top:18px; padding-left:20px;  margin-bottom:0; line-height:2;}
.ts_main #prj_right ul { margin:0 auto;margin-bottom:10px;margin-top:10px; width:80%;}
.ts_main #prj_right ul li {border:0 none; float:none; width:100%; padding:10px 0;}
.ts_main #prj_right ul li + li {border-top:1px dotted #888;}
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
		                <div class="album-wrap">
		                    <h4 class="notice_title">NOTICE<span class="plus"><a href="javascript:moveMenu('AN', 'IRIAN0200', '/anl/lib/retrievePubNoticeList.do', 'IRIAN0201')">&#43;</a></span></h4>
		                    <ul class="album clfix">
                    <c:choose>
                    	<c:when test="${fn:length(anlNoticeList) == 0}">
                                <li>데이터가 존재하지 않습니다.</li>
                    	</c:when>
                    	<c:otherwise>
                            <c:forEach items="${anlNoticeList}" var="data" varStatus="status">
		                        <li>
		                            <div class="title"><c:out value="${data.bbsTitl}"/></div>
		                        <c:if test="${data.newFlag == 'N'}">
		                            <span class="news_icon">New</span>
		                        </c:if>
		                            <div class="contxt" onClick="moveMenu('AN', 'IRIAN0200', '/anl/lib/anlNoticeInfo.do?bbsId=<c:out value="${data.bbsId}"/>', 'IRIAN0201')"><c:out value="${data.bbsSbc}" escapeXml="false"/></div>
		                        </li>
                            </c:forEach>
                    	</c:otherwise>
                    </c:choose>
		                    </ul>
		                </div>
		                <ul class="bt-roll">
                        <c:forEach items="${anlNoticeList}" var="data" varStatus="status">
		                    <li><a href="#"><img src="<%=imagePath%>/newIris/btn_circle<c:if test="${status.index == 0}">_</c:if>.png"></a></li>
                        </c:forEach>
		                </ul>
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
		   
		   		<div id="prj_right">
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
		   		</div>
		    </div>
		    <!--footer-->
			<%@ include file="/WEB-INF/jsp/web/main/footer.jspf" %>
		</div>
    </body>
</html>