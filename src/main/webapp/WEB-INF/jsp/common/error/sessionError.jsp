<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%-- <%@ include file="/WEB-INF/jsp/include/doctype.jspf"%> --%>
<%--
/*
 *************************************************************************
 * $Id		: sessionError.jsp
 * @desc    : 세션종료 에러페이지
 *------------------------------------------------------------------------
 * VER	DATE		AUTHOR		DESCRIPTION
 * ---	-----------	----------	-----------------------------------------
 * 1.0  2016.08.10    조종민		최초생성
 * ---	-----------	----------	-----------------------------------------
 * WINS UPGRADE 1차 프로젝트
 *************************************************************************
 */
--%>
<%-- 
<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<title>Session Error Page</title> --%>
<%@ include file="/WEB-INF/jsp/include/rui_header.jspf"%>
<script type="text/javascript">
setTimeout("relogin()",1000);

function relogin(){
	top.location = contextPath+"/sessionError.html";
}
</script> 

</head>
<body id="LblockBody">
<div id="LblockError">
	<div>
		<h1>세션연결이 종료되었습니다. 다시 로긴해 주시기 바랍니다.</h1>
	</div>
</div>

</body>
</html>
