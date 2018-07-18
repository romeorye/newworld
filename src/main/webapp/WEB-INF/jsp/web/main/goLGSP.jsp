<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>			
<%@ page import="java.text.*,
				 java.util.*,
				 devonframe.util.NullUtil,
				 devonframe.util.DateUtil"%>
				 
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
	response.setHeader("Pragma", "No-cache");
	response.setDateHeader("Expires", -1);
	response.setHeader("Cache-Control", "no-cache");

    String contextPath = request.getContextPath();
    
    String scriptPath = contextPath + "/resource/web/js";
%>

<%--
/*
 *************************************************************************
 * $Id		: goLGSP.jsp
 * @desc    : LG Science Part 화면이동
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

<title>  :::  연구정보통합시스템(IRIS)  :::  </title>

	<script type="text/javascript" src="<%=scriptPath%>/jquery.js"></script>

	<script type="text/javascript">
		$(document).ready(function(){
		    $("#form1").submit();
		});

	</script>
    </head>
    <body>
	    <form name="form1" id="form1" method="post" action="<c:out value="${lgspUrl}"/>">
	    	<input type="hidden" name="cid" value="<c:out value="${cid}"/>"/>
	    	<input type="hidden" name="userInfo" value="<c:out value="${userInfo}"/>"/>
	    </form>
    </body>
</html>