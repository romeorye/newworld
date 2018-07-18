<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>			
<%@ page import="java.text.*,
				 java.util.*,
				 devonframe.util.NullUtil,
				 devonframe.util.DateUtil"%>

<%--
/*
 *************************************************************************
 * $Id		: retrieveRequestPopup.jsp
 * @desc    : 조회요청 관련 팝업 샘플
 *------------------------------------------------------------------------
 * VER	DATE		AUTHOR		DESCRIPTION
 * ---	-----------	----------	-----------------------------------------
 * 1.0  2016.07.25  민길문		최초생성
 * ---	-----------	----------	-----------------------------------------
 * IRIS UPGRADE 1차 프로젝트
 *************************************************************************
 */
--%>
				 
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<%@ include file="/WEB-INF/jsp/include/rui_header.jspf"%>

<title><%=documentTitle%></title>

<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/grid/LEditButtonColumn.js"></script>
<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/grid/LGridView.js"></script>
<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/grid/LGridPanelExt.js"></script>
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
     	    
     	    // 조회요청 팝업 시작
     	    retrieveRequestInfoDialog = new Rui.ui.LFrameDialog({
     	        id: 'retrieveRequestInfoDialog', 
     	        title: '조회 요청',
     	        width: 850,
     	        height: 330,
     	        modal: true,
     	        visible: false
     	    });
     	    
     	    retrieveRequestInfoDialog.render(document.body);
     	    
     	    openRetrieveRequestInfoDialog = function() {
     	    	var params = '?rqDocNm=' + escape(encodeURIComponent($('#rqDocNm').val()))
     	    			   + '&rtrvRqDocCd=' + $('#rtrvRqDocCd').val()
     	    			   + '&rtrvRqDocNm=' + escape(encodeURIComponent($('#rtrvRqDocNm').val()))
     	    			   + '&docNo=' + $('#docNo').val()
     	    			   + '&pgmPath=' + escape(encodeURIComponent($('#pgmPath').val()))
     	    			   + '&rgstId=' + $('#rgstId').val()
     	    			   + '&rgstNm=' + escape(encodeURIComponent($('#rgstNm').val()))
     	    			   + '&rgstOpsId=' + $('#rgstOpsId').val()
     	    			   + '&rgstOpsNm=' + escape(encodeURIComponent($('#rgstOpsNm').val()));
     	    	
     	    	retrieveRequestInfoDialog.setUrl('<c:url value="/knld/rsst/retrieveRequestInfo.do"/>' + params);
     	    	retrieveRequestInfoDialog.show();
     	    };
     	    // 조회요청 팝업 끝
     	    
     	    // 조회요청 승인/반려 팝업 시작
     	    retrieveRequestTodoInfoDialog = new Rui.ui.LFrameDialog({
     	        id: 'retrieveRequestTodoInfoDialog', 
     	        title: '조회 요청',
     	        width: 700,
     	        height: 400,
     	        modal: true,
     	        visible: false
     	    });
     	    
     	    retrieveRequestTodoInfoDialog.render(document.body);
     	    
     	    openRetrieveRequestTodoInfoDialog = function(mwTodoReqNo) {
     	    	var params = '?MW_TODO_REQ_NO=' + mwTodoReqNo;
     	    	
     	    	retrieveRequestTodoInfoDialog.setUrl('<c:url value="/knld/rsst/retrieveRequestTodoInfo.do"/>' + params);
     	    	retrieveRequestTodoInfoDialog.show();
     	    };
     	    // 조회요청 승인/반려 팝업 끝
     	    
     	    openRetrieveRequestTodoInfoIFrm = function(mwTodoReqNo) {
     	    	$('#retrieveRequestTodoInfoIFrm').attr('src', '<c:url value="/knld/rsst/retrieveRequestTodoInfo.do?MW_TODO_REQ_NO="/>' + mwTodoReqNo);
     	    }
        });
	</script>
    </head>
    <body>
	<form name="aform" id="aform" method="post">
   		<div class="contents">
   		
   			<div class="sub-content">
   				<div class="titArea">
   					<div class="LblockButton">
						<button type="button" class="btn"  id="retrieveRequestInfoBtn" name="retrieveRequestInfoBtn" onclick="openRetrieveRequestInfoDialog()">조회요청</button>
<!-- 						<button type="button" class="btn"  id="retrieveRequestTotoInfoBtn" name="retrieveRequestTotoInfoBtn" onclick="openRetrieveRequestTodoInfoDialog($('#mwTodoReqNo').val())">조회요청승인</button> -->
						<button type="button" class="btn"  id="retrieveRequestTotoInfoBtn" name="retrieveRequestTotoInfoBtn" onclick="openRetrieveRequestTodoInfoIFrm($('#mwTodoReqNo').val())">조회요청승인</button>
   					</div>
   				</div>
   				
   				<table class="table table_txt_right">
   					<colgroup>
   						<col style="width:15%;"/>
   						<col style="width:35%;"/>
   						<col style="width:15%;"/>
   						<col style="width:35%;"/>
   					</colgroup>
   					<tbody>
   						<tr>
   							<th align="right">요청문서명</th>
   							<td>
   								<input type="text" id="rqDocNm" name="rqDocNm" value="2 테스트 분석 요청 입니다." style="width:200px;">
   							</td>
   							<th align="right">문서번호</th>
   							<td>
   								<input type="text" id="docNo" name="docNo" value="8" style="width:200px;">
   							</td>
   						</tr>
   						<tr>
   							<th align="right">경로</th>
   							<td colspan="3">
   								<input type="text" id="pgmPath" name="pgmPath" value="분석의뢰 > 분석 결과서" style="width:200px;">
   							</td>
   						</tr>
   						<tr>
   							<th align="right">조회요청문서종류명</th>
   							<td>
   								<input type="text" id="rtrvRqDocNm" name="rtrvRqDocNm" value="분석" style="width:200px;">
   							</td>
   							<th align="right">조회요청문서종류코드</th>
   							<td>
   								<input type="text" id="rtrvRqDocCd" name="rtrvRqDocCd" value="AA" style="width:200px;">
   							</td>
   						</tr>
   						<tr>
   							<th align="right">등록자명</th>
   							<td>
   								<input type="text" id="rgstNm" name="rgstNm" value="조윤혜" style="width:200px;">
   							</td>
   							<th align="right">등록자ID</th>
   							<td>
   								<input type="text" id="rgstId" name="rgstId" value="youngken" style="width:200px;">
   							</td>
   						</tr>
   						<tr>
   							<th align="right">등록자부서명</th>
   							<td>
   								<input type="text" id="rgstOpsNm" name="rgstOpsNm" value="LG CNS" style="width:200px;">
   							</td>
   							<th align="right">등록자부서ID</th>
   							<td>
   								<input type="text" id="rgstOpsId" name="rgstOpsId" value="IC" style="width:200px;">
   							</td>
   						</tr>
   					</tbody>
   				</table>
   				<br/><br/>
   				<table class="table table_txt_right">
   					<colgroup>
   						<col style="width:15%;"/>
   						<col style="width:85%;"/>
   					</colgroup>
   					<tbody>
   						<tr>
   							<th align="right">조회요청ID</th>
   							<td>
   								<input type="text" id="mwTodoReqNo" name="mwTodoReqNo" value="" style="width:200px;">
   							</td>
   						</tr>
   					</tbody>
   				</table>
   				<br/>
   				<iframe id="retrieveRequestTodoInfoIFrm" src="" frameborder="0" scrolling="auto" style="width:100%;height:400px;"></iframe>
   				
   			</div><!-- //sub-content -->
   		</div><!-- //contents -->
		</form>
    </body>
</html>