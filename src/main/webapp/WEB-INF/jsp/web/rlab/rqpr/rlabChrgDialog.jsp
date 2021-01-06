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
		<div>기타 산업조직 시험의뢰시, 제품신뢰성연구 PJT PL과 상의해 주시기 바랍니다.</div>
		<table class="table anlch_ta">
			<colgroup>
				<col style="width:25%;">
				<col style="width:25%;">
				<col style="width:50%;">
			</colgroup>
			<tbody>
				<th colspan="2">사업부</th>
				<th>담당자</th>
				<tr>
					<th rowspan="2"  align="center">인테리어</th>
					<th align="center">주방</th>
					<td align="center">
						<a href="#" onClick="setRlabChrgInfo('jndkim', '김지니다')">김지니다</a>,
						<a href="#" onClick="setRlabChrgInfo('duhwanlee', '이두환')">이두환</a>,
						<a href="#" onClick="setRlabChrgInfo('shmyoung', '명석한')">명석한</a>
					</td>
				</tr>
				<tr>
					<th align="center">욕실</th>
					<td align="center">
						<a href="#" onClick="setRlabChrgInfo('sheleemin', '이민')">이민,
						<a href="#" onClick="setRlabChrgInfo('tekang', '강태의')">강태의</a>,
						<a href="#" onClick="setRlabChrgInfo('jhbyun', '변재현')">변재현</a>
					</td>
				</tr>				
				<tr>
					<th colspan="2" align="center">장식재</th>
					<td align="center">
						<a href="#" onClick="setRlabChrgInfo('kangbg', '강봉규')">강봉규
					</td>
				</tr>
				<tr>
					<th colspan="2" align="center">창호, 표면소재, 자동차</th>
					<td align="center">
						<a href="#" onClick="setRlabChrgInfo('ehkang', '강은희')">강은희,
						<a href="#" onClick="setRlabChrgInfo('induohgee', '이동희')">이동희
					</td>
				</tr>
			</tbody>
		</table>
	</div>
	<!-- //pop컨텐츠 -->
	</body>
</html>