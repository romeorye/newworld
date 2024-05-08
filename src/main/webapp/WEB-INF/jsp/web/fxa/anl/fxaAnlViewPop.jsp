<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*,
				 java.util.*,
				 devonframe.util.NullUtil,
				 devonframe.util.DateUtil"%>

<%--
/*
 *************************************************************************
 * $Id		: fxaInfoDtl.jsp
 * @desc    : 자산 상세정보 팝업(통합검색용)
 *------------------------------------------------------------------------
 * VER	DATE		AUTHOR		DESCRIPTION
 * ---	-----------	----------	-----------------------------------------
 * 1.0  2016.11.01  IRIS05		최초생성
 * ---	-----------	----------	-----------------------------------------
 * IRIS 구축 프로젝트
 *************************************************************************
 */
--%>

<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<%@ include file="/WEB-INF/jsp/include/rui_header.jspf"%>

<title><%=documentTitle%></title>

<%-- rui staus bar --%>
<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/grid/LGridStatusBar.js"></script>
<link rel="stylesheet" type="text/css" href="<%=ruiPathPlugins%>/ui/grid/LGridStatusBar.css"/>

<script type="text/javascript">
	Rui.onReady(function() {
		var attId = '${result.attcFilId}';
		var seq = '${result.seq}';
		var param = "?attcFilId="+attId+"&seq="+seq;
	
		Rui.getDom('fxaImage').src = '<c:url value="/system/attach/downloadAttachFile.do"/>'+param;
		
	}); // end RUI Lodd


</script>
</head>

<body>
	<form name="aform" id="aform">
		<table class="table table_txt_right">
			<colgroup>
				<col style="width:10%;"/>
				<col style="width:40%;"/>
				<col style="width:10%;"/>
				<col style="width:40%;"/>
			</colgroup>
			<tbody>
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
					<th align="right">wbsCd</th>
					<td>
						<c:out value='${result.wbsCd}'/>
					</td>
					<th align="right">프로젝트명</th>
					<td>
						<c:out value='${result.prjNm}'/>
					</td>
				</tr>
				<tr>
					<th align="right">담당자</th>
					<td>
						<c:out value='${result.spnCrgrNm}'/>
					</td>
					<th align="right">위치</th>
					<td>
						<c:out value='${result.fxaLoc}'/>
					</td>
				</tr>
				<tr>
					<th align="right">자산클래스</th>
					<td>
						<c:out value='${result.fxaClss}'/>
					</td>
					<th align="right">수량(단위)</th>
					<td>
						<c:out value='${result.fxaQty}'/>(<c:out value='${result.fxaUtmNm}'/>)
					</td>
				</tr>

				<tr>
					<th align="right">취득가</th>
					<td>
						<c:out value='${result.otPce}'/>
					</td>
					<th align="right">장부가</th>
					<td>
						<c:out value='${result.bkpPce}'/>
					</td>
				</tr>
				<tr>
					<th align="right">취득일</th>
					<td>
						<c:out value='${result.obtDt}'/>
					</td>
					<th align="right">실사일</th>
					<td>
						<c:out value='${result.rlisDt}'/>
					</td>
				</tr>
				</tr>
				<tr>
					<th align="right">Maker/모델명</th>
					<td>
						<c:out value='${result.mkNm}'/>
					</td>
					<th align="right">용도</th>
					<td>
						<c:out value='${result.useUsf}'/>
					</td>
				</tr>
				<tr>
					<th align="right">태그</th>
					<td>
						<c:out value='${result.tagYn}'/>
					</td>
					<th align="right">구입처</th>
					<td>
						<c:out value='${result.prcDpt}'/>
						<span id="spnPrcDpt"></span>
					</td>
				</tr>
				<tr>
					<th align="right">Spec</th>
					<td colspan="3">
						<c:out value='${result.fxaSpc}'/>
						<span id="spnFxaSpc"></span>
					</td>
				</tr>
				<tr>
					<th align="right">이미지</th>
					<td colspan="3">
						<img id="fxaImage"/>
					</td>
				</tr>
			</tbody>
		</table>
	</form>

</body>
</html>