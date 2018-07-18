<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*,
				 java.util.*,
				 devonframe.util.NullUtil,
				 devonframe.util.DateUtil"%>

<%--
/*
 *************************************************************************
 * $Id		: PatentList.jsp
 * @desc    : 특허 리스트
 *------------------------------------------------------------------------
 * VER	DATE		AUTHOR		DESCRIPTION
 * ---	-----------	----------	-----------------------------------------
 * 1.0  2017.09.13  			최초생성
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

<%-- rui staus bar --%>
<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/grid/LGridStatusBar.js"></script>
<link rel="stylesheet" type="text/css" href="<%=ruiPathPlugins%>/ui/grid/LGridStatusBar.css"/>


   	<div class="contents">
   		<div class="sub-content">
	   		<div class="titleArea">
	   			<h2>공지/게시판 - 특허정보제공리스트</h2>
	   		</div>
	   	</div>
		&nbsp;&nbsp;
        <div>
	   		<iframe src="http://epapp.lghausys.com:9904/bt.type01.board125.list.laf?ispmis=Y&bbsid=board125" frameborder="0" width="800" height="500" scrolling="no">
	   		</iframe>
        </div>
       </div>


</head>
</html>