<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>

<%--
/*
 *************************************************************************
 * $Id		: spaceChrgDialog.jsp
 * @desc    : 평가방법 선택 팝업
 *------------------------------------------------------------------------
 * VER	DATE		AUTHOR		DESCRIPTION
 * ---	-----------	----------	-----------------------------------------
 * 1.0  2018.08.23  정현웅		최초생성
 * ---	-----------	----------	-----------------------------------------
 * IRIS UPGRADE 2차 프로젝트
 *************************************************************************
 */
--%>

<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<%@ include file="/WEB-INF/jsp/include/rui_header.jspf"%>

<title><%=documentTitle%></title>

<style>
 .bgcolor-gray {background-color: #999999}
 .bgcolor-white {background-color: #FFFFFF}
</style>

<link rel="stylesheet" type="text/css" href="<%=cssPath%>/common.css">
<link rel="stylesheet" type="text/css" href="<%=cssPath%>/rui.css">
<link rel="stylesheet" type="text/css" href="<%=cssPath%>/rui_skin_new.css">
<link rel="stylesheet" type="text/css" href="<%=cssPath%>/common.css">
<link rel="stylesheet" type="text/css" href="<%=cssPath%>/iris_style.css">

	<script type="text/javascript">
		setRlabChrgInfo = function(id, name) {
			var rlabChrgInfo = {
					id : id,
					name : name
			};

			parent._callback(rlabChrgInfo);
			parent.rlabChrgListDialog.submit(true);
		};

	</script>
    </head>
    <body>


	<!-- pop컨텐츠 -->
	<div class="bd pop_conin">
		<div align="right">※ 신뢰성시험 의뢰 시, 시험 담당자 or 제품신뢰성연구PJT PL에게 문의 바랍니다.</div>
		<table class="table anlch_ta">
			<colgroup>
				<col style="width:25%;">
				<col style="width:25%;">
				<col style="width:50%;">
			</colgroup>
			<tbody>
				<th colspan="2">사업부/사업담당</th>
				<th>시험 담당자</th>
				<tr>
					<th colspan="2" align="center">총괄</th>
					<td style="text-align:center;vertical-align:middle !important;">
						<a href="#" onClick="setRlabChrgInfo('sheleemin', '이민')">이민</a>
					</td>
				</tr>
				<tr>
					<th rowspan="2" align="center">창호</th>
					<th align="center">시스템창, 중문, 통합시공</th>
					<td style="text-align:center;vertical-align:middle !important;">
						<a href="#" onClick="setRlabChrgInfo('hobaly', '임호연')">임호연</a>
					</td>
				</tr>
				<tr>
					<th align="center">PL창</th>
					<td style="text-align:center;vertical-align:middle !important;">
						<a href="#" onClick="setRlabChrgInfo('jhbyun', '변재현')">변재현</a>
					</td>
				</tr>
				<tr>
					<th colspan="2" align="center">인테리어</th>
					<td style="text-align:center;vertical-align:middle !important;">
						<a href="#" onClick="setRlabChrgInfo('induohgee', '이동희')">이동희</a>
					</td>
				</tr>
				<tr>
					<th colspan="2" align="center">표면소재</th>
					<td style="text-align:center;vertical-align:middle !important;">
						<a href="#" onClick="setRlabChrgInfo('jndkim', '김지니다')">김지니다</a>
					</td>
				</tr>
				<tr>
					<th colspan="2" align="center">산업용필름</th>
					<td style="text-align:center;vertical-align:middle !important;">
						<a href="#" onClick="setRlabChrgInfo('tekang', '강태의')">강태의</a>
					</td>
				</tr>
				<tr>
					<th colspan="2" align="center">바닥재</th>
					<td rowspan="2" style="text-align:center;vertical-align:middle !important;">
						<a href="#" onClick="setRlabChrgInfo('sungfepark', '박성철')">박성철</a>
					</td>
				</tr>
				<tr>
					<th colspan="2" align="center">벽지</th>
				</tr>
				<tr>
					<th colspan="2" align="center">단열재</th>
					<td style="text-align:center;vertical-align:middle !important;">
						<a href="#" onClick="setRlabChrgInfo('jndkim', '김지니다')">김지니다 책임</a>,
						<a href="#" onClick="setRlabChrgInfo('sungfepark', '박성철')">박성철 사원</a>
					</td> 
				</tr>
			</tbody>
		</table>
	</div>
	<!-- //pop컨텐츠 -->
	</body>
</html>