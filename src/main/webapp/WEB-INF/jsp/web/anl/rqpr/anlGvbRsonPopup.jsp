<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*, java.util.*,devonframe.util.NullUtil,devonframe.util.DateUtil"%>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>
<%--
/*
 *************************************************************************
 * $Id		: anlGvbRsonPopup.jsp
 * @desc    : 분석 > 분석의뢰 > 분석목록 > 반려의견 > 
 *------------------------------------------------------------------------
 * VER	DATE		AUTHOR		DESCRIPTION
 * ---	-----------	----------	-----------------------------------------
 * 1.0  2019.12.03     IRIS05		최초생성
 * ---	-----------	----------	-----------------------------------------
 * IRIS 구축 프로젝트
 *************************************************************************
 */
--%>
<html>
<head>
<%@ include file="/WEB-INF/jsp/include/rui_header.jspf"%>
<title>Insert title here</title>
<script>
Rui.onReady(function() {
	
	
	
	
})
</script>
</head>
<body>
<div class="bd">
	<div class="sub-content" style="padding:0;">
		<table class="table table_txt_right">
			<tr>
				<td>
					<c:out value="${inputData.anlGvbRson}" escapeXml="false"></c:out>
				</td>
			</tr>	
		</table>
	</div>	
</div>
</body>
</html>