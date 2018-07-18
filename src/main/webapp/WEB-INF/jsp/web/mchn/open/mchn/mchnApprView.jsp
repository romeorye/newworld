<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8"%>
<%@ page import="java.text.*, java.util.*,devonframe.util.NullUtil,devonframe.util.DateUtil"%>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>


<%--
/*
 *************************************************************************
 * $Id		: mchnApprView.jsp
 * @desc    : 분석기기 >  관리 > 분석기기 view (통합검색용)
 *------------------------------------------------------------------------
 * VER	DATE		AUTHOR		DESCRIPTION
 * ---	-----------	----------	-----------------------------------------
 * 1.0  2017.11.01     IRIS05		최초생성
 * ---	-----------	----------	-----------------------------------------
 * IRIS 구축 프로젝트
 *************************************************************************
 */
--%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<%@ include file="/WEB-INF/jsp/include/rui_header.jspf"%>
<title><%=documentTitle%></title>

<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/form/LFileBox.js"></script>
<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/LFileUploadDialog.js"></script>
<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/form/LPopupTextBox.js"></script>

<link rel="stylesheet" type="text/css" href="<%=ruiPathPlugins%>/ui/form/LFileBox.css"/>
<link rel="stylesheet" type="text/css" href="<%=ruiPathPlugins%>/ui/LFileUploadDialog.css"/>
<link rel="stylesheet" type="text/css" href="<%=ruiPathPlugins%>/ui/form/LPopupTextBox.css"/>


<script type="text/javascript">


	Rui.onReady(function(){
		
/*************************첨부파일****************************/
		var attId;

		var attId = '${result.attcFilId}';
		var seq = '${result.seq}';

        if(!Rui.isEmpty(attId)) {
        	// 이미지표시
    		var param = "?attcFilId="+ attId+"&seq="+seq;
    		Rui.getDom('atthcFilVw').src = '<c:url value="/system/attach/downloadAttachFile.do"/>'+param;
        }
	});  //end ready


</script>
</head>
<body>
	<div class="contents">
		<div class="sub-content">
			<form name="aform" id="aform" method="post">
				<table class="table table_txt_right">
					<colgroup>
						<col style="width: 15%" />
						<col style="width: 30%" />
						<col style="width: 15%" />
						<col style="width: 30%" />
					</colgroup>
					<tbody>
						<tr>
							<th align="right">기기명(국문)</th>
							<td>
								<c:out value='${result.mchnHanNm}'/>
							</td>
							<th align="right">기기명(영문)</th>
							<td>
								<c:out value='${result.mchnEnNm}'/>
							</td>
						</tr>
						<tr>
							<th align="right">제조사</th>
							<td>
								<c:out value='${result.mkrNm}'/>
							</td>
							<th align="right">모델명</th>
							<td>
								<c:out value='${result.mdlNm}'/>
							</td>
						</tr>
						<tr>
							<th align="right">분류</th>
							<td>
								<c:out value='${result.mchnClNm}'/>
							</td>
							<th align="right">open기기</th>
							<td>
								<c:out value='${result.opnYn}'/>
							</td>
						</tr>
						
						<tr>
							<th align="right">기기사용상태</th>
							<td>
								<c:out value='${result.mchnUsePsblNm}'/>
							</td>
							<th align="right">사용료 구분</th>
							<td>
								<c:out value='${result.mchnUfeClCd}'/> &nbsp;<c:out value='${result.mchnUfe}'/>원
							</td>
						</tr>
						<tr>
							<th align="right">자산명</th>
							<td>
								<c:out value='${result.fxaNm}'/>
							</td>
							<th align="right">자산번호</th>
							<td>
								<c:out value='${result.fxaNo}'/>
							</td>
						</tr>
						<tr>
							<th align="right">담당자</th>
							<td>
								<c:out value='${result.mchnCrgrNm}'/>
							</td>
							<th align="right" >위치</th>
							<td>
								<c:out value='${result.mchnLoc}'/>
							</td>
						</tr>
						<tr>
							<th align="right">요약설명</th>
							<td colspan="3">
								<c:out value='${result.mchnExpl}'/>
							</td>
						</tr>
						<tr>
							<th align="right">첨부파일</th>
							<td colspan="3">
								<img id="atthcFilVw"/>
							</td>
						</tr>
						<tr>
							<th  align="right">개요</th>
							<td colspan="3">
								<c:out value='${result.mchnSmry}'  escapeXml="false"/>
							</td>
						</tr>
						</tbody>
				</table>
			</form>

		</div>
		<!-- //sub-content -->
	
	</div>
	<!-- //contents -->
</body>
</html>
