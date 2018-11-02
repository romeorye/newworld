<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*,
				 java.util.*,
				 devonframe.util.NullUtil,
				 devonframe.util.DateUtil"%>

<%--
/*
 *************************************************************************
 * $Id		: anlRqprSrchView.jsp
 * @desc    : 분석의뢰서 상세
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

<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/grid/LEditButtonColumn.js"></script>
<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/grid/LTotalSummary.js"></script>
<link rel="stylesheet" type="text/css" href="<%=ruiPathPlugins%>/ui/grid/LTotalSummary.css"/>

<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/grid/LGridStatusBar.js"></script>
<link rel="stylesheet" type="text/css" href="<%=ruiPathPlugins%>/ui/grid/LGridStatusBar.css"/>

<style>
 .bgcolor-gray {background-color: #999999}
 .bgcolor-white {background-color: #FFFFFF}
</style>

	<script type="text/javascript">
		Rui.onReady(function() {
            /*******************
             * 변수 및 객체 선언
             *******************/
    	    var rtrvRqDocCd = '<c:out value="${inputData.rtrvRqDocCd}"/>';
            var docNo = '<c:out value="${inputData.docNo}"/>';
            var authYn = '<c:out value="${inputData.authYn}"/>';
            var reUrl = '<c:url value="${inputData.reUrl}"/>';
            var params; 

            if(authYn == "Y"){
	            if(rtrvRqDocCd == 'AA') {
	            	params = "?rqprId="+docNo;
	            } else if(rtrvRqDocCd == 'KC') {
	            	params = "?conferenceId="+docNo;
	            } else if(rtrvRqDocCd == 'KD') {
	            	params = "?prdtId="+docNo;
	            } else if(rtrvRqDocCd == 'KE') {
	            	params = "?eduId="+docNo;
	            } else if(rtrvRqDocCd == 'KF') {
	            	params = "?modalityId="+docNo;
	            } else if(rtrvRqDocCd == 'KM') {
	            	params = "?techId="+docNo;
	            } else if(rtrvRqDocCd == 'KN') {
	            	params = "?saftyId="+docNo;
	            } else if(rtrvRqDocCd == 'KO') {
	            	params = "?outSpclId="+docNo;
	            } else if(rtrvRqDocCd == 'KP') {
	            	params = "?pwiId="+docNo;
	            } else if(rtrvRqDocCd == 'KQ') {
	            	params = "?qnaId="+docNo;
	            } else if(rtrvRqDocCd == 'KR') {
	            	params = "?manualId="+docNo;
	            } else if(rtrvRqDocCd == 'KS') {
	            	params = "?showId="+docNo;
	            } else if(rtrvRqDocCd == 'KT') {
	            	params = "?patentId="+docNo;
	            } else if(rtrvRqDocCd == 'PRJ') {
	            	params = "?prjCd="+docNo;
	            } else if(rtrvRqDocCd == 'GRS' || rtrvRqDocCd == 'O' || rtrvRqDocCd == 'G' || rtrvRqDocCd == 'N') {
	            	params = "?tssCd="+docNo;
	            } else if(rtrvRqDocCd == 'MP') {
	            	params = "?mchnInfoId="+docNo;
	            } else if(rtrvRqDocCd == 'ME') {
	            	params = "?mchnEduId="+docNo;
	            } else if(rtrvRqDocCd == 'FA') {
	            	params = "?fxaInfoId="+docNo;
	            }else if(rtrvRqDocCd == '00'  || rtrvRqDocCd == '01'  || rtrvRqDocCd == '02'  ||  rtrvRqDocCd == '03'  || rtrvRqDocCd == '04' || rtrvRqDocCd == '05') {
	            	params = "?bbsId="+docNo;
	            } else if(rtrvRqDocCd == 'SPACE') {
	            	params = "?attcFilId="+docNo;
	            }
			}
           
            $('#detailIFrm').attr('src', reUrl+params);
            
            goKnldRtrvRqList = function() {
    	    	$('#searchForm > input[name=rqDocNm]').val(encodeURIComponent($('#searchForm > input[name=rqDocNm]').val()));
    	    	$('#searchForm > input[name=sbcNm]').val(encodeURIComponent($('#searchForm > input[name=sbcNm]').val()));

    	    	nwinsActSubmit(searchForm, "<c:url value="/knld/rsst/retrieveRequestList.do"/>");
    	    };
        });
	</script>
    </head>
    <body style="overflow-y:hidden !important;">
    <form name="searchForm" id="searchForm">
		<input type="hidden" name="rqDocNm" value="${inputData.rqDocNm}"/>
		<input type="hidden" name="sbcNm" value="${inputData.sbcNm}"/>
    </form>
   		<div class="contents"  style="width:100%;">

   			<div class="sub-content"  style="padding:0; max-width:100%;">
				<form name="aform" id="aform" method="post">
   				<div class="titleArea">
   					<span class="leftCon">
				          <img src="/iris/resource/web/images/img_uxp/ico_leftCon.png" alt="Left Navigation Control">
				          <span class="hidden">Toggle 버튼</span>
					</span>
	   				<h2><c:out value='${inputData.pgmPath}'/></h2>
   					<div class="LblockButton">
   						<!-- <button type="button" class="btn"  id="listBtn" name="listBtn" onclick="goKnldRtrvRqList()">목록</button> -->
   					</div>
   				</div>
   				<iframe id="detailIFrm" src="" frameborder="0" scrolling="yes" style="width:1220px;height:650px;"></iframe>
				</form>

   			</div><!-- //sub-content -->
   		</div><!-- //contents -->
    </body>
</html>