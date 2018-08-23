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

	<script type="text/javascript">
		setSpaceChrgInfo = function(spaceEvCtgr, spaceEvPrvs, id, name) {
			var spaceChrgInfo = {
					spaceEvCtgr : spaceEvCtgr,
					spaceEvPrvs : spaceEvPrvs,
					id : id,
					name : name,
			};

			parent._callback(spaceChrgInfo);
			parent.spaceChrgListDialog.submit(true);
		};

	</script>
    </head>
    <body>
	<!-- * 기타 사업조직 분석의뢰 시, 분석 PJT PL과 상담해주시기 바랍니다. -->
	<table class="table">
		<colgroup>
			<col style="width:25%;"/>
			<col style="width:25%;"/>
			<col style="width:25%;"/>
			<col style="width:25%;"/>
		</colgroup>
		<tbody>
			<tr>
				<th align="center">담당자</th>
				<th align="center">Simulation</th>
				<th align="center">Mock-up</th>
				<th align="center">Certification</th>
			</tr>
			<tr>
				<th align="center">에너지</th>
				<td align="center">
					<!--
					setSpaceChrgInfo( 평가카테고리 , 평가항목 , 담당자아이디 , 담당자명 )
					평가카테고리 : 01:Simulation, 02:Mock-up, 03:Certification
					평가항목     : 01:에너지, 02:열, 03:빛, 04:공기질
					-->
					<a href="#" onClick="setSpaceChrgInfo('01','01','jollypeas', '송수빈')">송수빈</a></br>
					<a href="#" onClick="setSpaceChrgInfo('01','01','rumor',     '이진욱')">이진욱</a></br>
					<a href="#" onClick="setSpaceChrgInfo('01','01','yujilee',   '이유지')">이유지</a></br>
					<a href="#" onClick="setSpaceChrgInfo('01','01','nhahn',     '안남혁')">안남혁</a>
				</td>
				<td align="center">
					<a href="#" onClick="setSpaceChrgInfo('02','01','hyokeun',    '황효근')">황효근</a></br>
					<a href="#" onClick="setSpaceChrgInfo('02','01','yujilee',   '이유지')">이유지</a></br>
					<a href="#" onClick="setSpaceChrgInfo('02','01','jollypeas', '송수빈')">송수빈</a></br>
					<a href="#" onClick="setSpaceChrgInfo('02','01','rumor',     '이진욱')">이진욱</a>
				</td>
				<td align="center">
					<a href="#" onClick="setSpaceChrgInfo('03','01','shoonpark', '박상훈')">박상훈</a></br>
					<a href="#" onClick="setSpaceChrgInfo('03','01','nhahn',     '안남혁')">안남혁</a>
				</td>
			</tr>
			<tr>
				<th align="center">열</th>
				<td align="center">
					<a href="#" onClick="setSpaceChrgInfo('01','02','jollypeas', '송수빈')">송수빈</a></br>
					<a href="#" onClick="setSpaceChrgInfo('01','02','rumor',     '이진욱')">이진욱</a></br>
					<a href="#" onClick="setSpaceChrgInfo('01','02','yujilee',   '이유지')">이유지</a></br>
					<a href="#" onClick="setSpaceChrgInfo('01','02','nhahn',     '안남혁')">안남혁</a></br>
					<a href="#" onClick="setSpaceChrgInfo('01','02','giantsteps','김준혁')">김준혁</a>
				</td>
				<td align="center">
					<a href="#" onClick="setSpaceChrgInfo('02','02','hyokeun',   '황효근')">황효근</a></br>
					<a href="#" onClick="setSpaceChrgInfo('02','02','yujilee',   '이유지')">이유지</a></br>
					<a href="#" onClick="setSpaceChrgInfo('02','02','jollypeas', '송수빈')">송수빈</a></br>
					<a href="#" onClick="setSpaceChrgInfo('02','02','rumor',     '이진욱')">이진욱</a>
				</td>
				<td align="center">
					<a href="#" onClick="setSpaceChrgInfo('03','02','shoonpark', '박상훈')">박상훈</a></br>
					<a href="#" onClick="setSpaceChrgInfo('03','02','nhahn',     '안남혁')">안남혁</a>
				</td>
			</tr>
			<tr>
				<th align="center">빛</th>
				<td align="center">
					<a href="#" onClick="setSpaceChrgInfo('01','03','rumor',     '이진욱')">이진욱</a></br>
					<a href="#" onClick="setSpaceChrgInfo('01','03','giantsteps','김준혁')">김준혁</a>
				</td>
				<td align="center">
					<a href="#" onClick="setSpaceChrgInfo('02','03','shoonpark', '박상훈')">박상훈</a></br>
					<a href="#" onClick="setSpaceChrgInfo('02','03','nhahn',     '안남혁')">안남혁</a></br>
					<a href="#" onClick="setSpaceChrgInfo('02','03','jollypeas', '송수빈')">송수빈</a></br>
					<a href="#" onClick="setSpaceChrgInfo('02','03','rumor',     '이진욱')">이진욱</a>
				</td>
				<td align="center">
					<a href="#" onClick="setSpaceChrgInfo('03','03','shoonpark', '박상훈')">박상훈</a></br>
					<a href="#" onClick="setSpaceChrgInfo('03','03','nhahn',     '안남혁')">안남혁</a>
				</td>
			</tr>
			<tr>
				<th align="center">공기질</th>
				<td align="center">
					<a href="#" onClick="setSpaceChrgInfo('01','04','hyokeun',   '황효근')">황효근</a></br>
					<a href="#" onClick="setSpaceChrgInfo('01','04','nhahn',     '안남혁')">안남혁</a>
				</td>
				<td align="center">
					<a href="#" onClick="setSpaceChrgInfo('02','04','giantsteps','김준혁')">김준혁</a></br>
					<a href="#" onClick="setSpaceChrgInfo('02','04','nhahn',     '안남혁')">안남혁</a></br>
					<a href="#" onClick="setSpaceChrgInfo('02','04','jollypeas', '송수빈')">송수빈</a></br>
					<a href="#" onClick="setSpaceChrgInfo('02','04','rumor',     '이진욱')">이진욱</a>
				</td>
				<td align="center">
					<a href="#" onClick="setSpaceChrgInfo('03','04','shoonpark', '박상훈')">박상훈</a></br>
					<a href="#" onClick="setSpaceChrgInfo('03','04','nhahn',     '안남혁')">안남혁</a>
				</td>
			</tr>
		</tbody>
	</table>
	</body>
</html>