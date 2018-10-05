<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*,
				 java.util.*,
				 devonframe.util.NullUtil,
				 devonframe.util.DateUtil"%>

<%--
/*
 *************************************************************************
 * $Id		: anlKind.jsp
 * @desc    : 분석분야소개
 *------------------------------------------------------------------------
 * VER	DATE		AUTHOR		DESCRIPTION
 * ---	-----------	----------	-----------------------------------------
 * 1.0  2017.10.24  			최초생성
 * ---	-----------	----------	-----------------------------------------
 * WINS UPGRADE 1차 프로젝트
 *************************************************************************
 */
--%>

<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/include/rui_header.jspf"%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

	<title><%=documentTitle%></title>
    <link type="text/css" href="<%=cssPath%>/main.css" rel="stylesheet">
    <link type="text/css" href="<%=cssPath%>/common.css" rel="stylesheet">
    <script type="text/javascript" src="http://code.jquery.com/jquery-1.11.3.js"></script>
</head>

  <body style="overflow:auto">
		<div class="contents">
			<div class="titleArea">
				<a class="leftCon" href="#">
					<img src="/iris/resource/web/images/img_uxp/ico_leftCon.png" alt="Left Navigation Control">
					<span class="hidden">Toggle 버튼</span>
				</a>    
				<h2>신뢰성시험 안내</h2>
		    </div>

			<div class="sub-content">

				<div class="analyze_field">
			        <div class="analyze_box"><div class="analyze_img1"></div></div>

			        <div class="analyze_cont">
			            <div class="analyze_b_txt">
			                형상분석
			            </div>
			            <div class="analyze_s_txt">Micro 및 Nano Level 에서의 형상, 성분, 상태, 물리적  특성 분석</div>
			            <div class="analyze_s_txt">Atomic Structure, Crystallinity 분석</div>
			        </div>
			     </div>

			     <div class="clear"></div>

			    <div class="analyze_line margin-10"></div>

			    <div class="analyze_field">
			        <div class="analyze_box"><div class="analyze_img2"></div></div>

			        <div class="analyze_cont">
			            <div class="analyze_b_txt">
			                유기분석
			            </div>
			            <div class="analyze_s_txt">소재의 판별 및 조성 분석</div>
			            <div class="analyze_s_txt">유기 첨가제의 정성 및 정량 분석</div>
			        </div>
			     </div>

			     <div class="clear"></div>

			    <div class="analyze_line margin-10"></div>

			    <div class="analyze_field">
			        <div class="analyze_box"><div class="analyze_img3"></div></div>

			        <div class="analyze_cont">
			            <div class="analyze_b_txt">
			                유해물질분석
			            </div>
			            <div class="analyze_s_txt">수입/수출 규제 및 환경 관련 유해물질의 극미량 분석 </div>
			            <div class="analyze_s_txt">전성분 분석을 통한 비의도적 유해물질분석</div>
			        </div>
			     </div>

			     <div class="clear"></div>

			    <div class="analyze_line margin-10"></div>

			</div><!-- //sub-content -->
		</div><!-- //contents -->

</body>
</html>