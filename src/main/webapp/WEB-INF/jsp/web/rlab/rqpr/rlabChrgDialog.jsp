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
		<div class="p_contit">기타 산업조직 실험의뢰시, 신뢰성연구 PJT PL과 상의해 주시기 바랍니다.</div>
		<table class="table p-admin">
			<colgroup>
				<col style="width:50%;">
				<col style="width:50%;">
			</colgroup>
			<thead>
				<th>사업부</th>
				<th>담당자</th>
			</thead>
			<tbody>
				<tr>
					<td>중앙연구소</td>
					<td>
						<a href="#" onClick="setRlabChrgInfo('keunjung', '정근')">정근</a>,
						<a href="#" onClick="setRlabChrgInfo('duhwanlee', '이두환')">이두환</a>
					</td>
				</tr>
				<tr>
					<td>자동차 소재부품</td>
					<td>
						<a href="#" onClick="setRlabChrgInfo('tekang', '강태의')">강태의</a>
					</td>
				</tr>
				<tr>
					<td>창호</td>
					<td>
						<a href="#" onClick="setRlabChrgInfo('jndkim', '김지니다')">김지니다</a>,
						<a href="#" onClick="setRlabChrgInfo('induohgee', '이동희')">이동희</a>
					</td>
				</tr>
				<tr>
					<td>장식재</td>
					<td>
						<a href="#" onClick="setRlabChrgInfo('sheleemin', '이민')">이민,
						<a href="#" onClick="setRlabChrgInfo('kangbg', '강봉규')">강봉규
					</td>
				</tr>
				<tr>
					<td>표면소재</td>
					<td>
						<a href="#" onClick="setRlabChrgInfo('keunjung', '정근')">정근,
						<a href="#" onClick="setRlabChrgInfo('duhwanlee', '이두환')">이두환
					</td>
				</tr>
			</tbody>
		</table>
	</div>
	<!-- //pop컨텐츠 -->


	</body>
</html>