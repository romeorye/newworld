<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8"%>
<%@ page import="java.text.*, java.util.*,devonframe.util.NullUtil,devonframe.util.DateUtil"%>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>
<%--
/*
 *************************************************************************
 * $Id		: anlMachineList.jsp
 * @desc    : Instrument > 신뢰성시험 장비 > 보유 장비 > 보유기기 상세화면
 *------------------------------------------------------------------------
 * VER	DATE		AUTHOR		DESCRIPTION
 * ---	-----------	----------	-----------------------------------------
 * 1.0  2017.10.24    IRIS05		최초생성
 * ---	-----------	----------	-----------------------------------------
 * IRIS 구축 프로젝트
 *************************************************************************
 */
--%>
<html>
<head>
<%@ include file="/WEB-INF/jsp/include/rui_header.jspf"%>
<link type="text/css" href="<%=cssPath%>/main.css" rel="stylesheet">
<link type="text/css" href="<%=cssPath%>/common.css" rel="stylesheet">
</head>
<body>
<table>
	<tr>
		<td class="tabPadding1">
			<c:out value="${result.mchnSmry}" escapeXml="false"/>	
		</td>
	</tr>
</table>
</body>
</html>            