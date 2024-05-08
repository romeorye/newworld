<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*,
				 java.util.*,
				 devonframe.util.NullUtil,
				 devonframe.util.DateUtil"%>

<%--
/*
 *************************************************************************
 * $Id		: anlReq.jsp
 * @desc    : 분석의뢰절차
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
				<h2>분석의뢰 절차</h2>
		    </div>

			<div class="sub-content">

				<div class="analy_proce">
		            <div class="analy_proce_box">
		                <div class="analy_proce_img img01"></div>
		                <div class="analy_proce_txt">분석의뢰절차</div>
		            </div>
		            <div class="analy_proce_arrow arrow01"></div>
		            <div class="analy_proce_box">
		                <div class="analy_proce_img img02"></div>
		                <div class="analy_proce_txt">1. 분석상담(방문 및 유선)</div>
		            </div>
		            <div class="analy_proce_arrow arrow01"></div>
		            <div class="analy_proce_box">
		                <div class="analy_proce_img img03"></div>
		                <div class="analy_proce_txt">2. 분석의뢰서 작성</div>
		            </div>

		            <div class="clear"></div>
		            <div class="analy_proce_arrow arrow03"></div>
		        </div>
		        <div class="clear"></div>
		        <div class="analy_proce_lay">
		            <div class="analy_proce_box">
		                <div class="analy_proce_img img06"></div>
		                <div class="analy_proce_txt">5. 분석결과 확인</div>
		            </div>
		            <div class="analy_proce_arrow arrow02"></div>
		            <div class="analy_proce_box">
		                <div class="analy_proce_img img05"></div>
		                <div class="analy_proce_txt">4. 분석진행</div>
		            </div>
		            <div class="analy_proce_arrow arrow02"></div>
		            <div class="analy_proce_box">
		                <div class="analy_proce_img img04"></div>
		                <div class="analy_proce_txt">3. 시료접수</div>
		            </div>
		        </div>
				<div class="clear"></div>
		         <div class="analy_adress">
		            <div class="analy_adress_box">
		                <div class="adress_txt_box"><div class="adress_txt">주소</div></div>
		                <div class="adress_txt_s">서울특별시 강서구 마곡중앙10로 30 (마곡동) LG사이언스파크 LG하우시스.중앙연구소.분석PJT</div>
		                <div class="adress_txt_ss">* 수령인에 분석담당자의 이름과 연락처를 기재하여 발송해 주시기 바랍니다.</div>
		            </div>
		        </div>
			</div><!-- //sub-content -->

		</div><!-- //contents -->

</body>
</html>