<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>
<%--
/*
 *************************************************************************
 * $Id		: vpnError.jsp
 * @desc    : vpn 에러페이지
 *------------------------------------------------------------------------
 * VER	DATE		AUTHOR		DESCRIPTION
 * ---	-----------	----------	-----------------------------------------
 * 1.0  2018.01.04    IRIS005		최초생성
 * ---	-----------	----------	-----------------------------------------
 *************************************************************************
 */
--%>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/include/rui_header.jspf"%>
<title>Session Error Page</title>
<script type="text/javascript">
setTimeout("relogin()",1000);

function relogin(){
	top.location = contextPath+"/vpnError.html";
	//top.location = "http://portal.lghausys.com/epWeb/index.jsp";
}
</script> 
</head>
<body id="LblockBody">
<div id="LblockError">
	<div>
		<h1>IRIS 시스템은 VPN 접속서비스를 지원하지 않습니다.</h1>
	</div>
</div>

</body>
</html>
