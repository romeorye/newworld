<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>

<%--
/*
 *************************************************************************
 * $Id		: anlChrgDialog.jsp
 * @desc    : 분석담당자 선택 팝업
 *------------------------------------------------------------------------
 * VER	DATE		AUTHOR		DESCRIPTION
 * ---	-----------	----------	-----------------------------------------
 * 1.0  2017.08.25  오명철		최초생성
 * ---	-----------	----------	-----------------------------------------
 * IRIS UPGRADE 1차 프로젝트
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

		setAnlChrgInfo = function(id, name) {
			var anlChrgInfo = {
					id : id,
					name : name
			};

			parent._callback(anlChrgInfo);

			parent.anlChrgListDialog.submit(true);
		};

	</script>
    </head>
    <body>
	* 기타 사업조직 분석의뢰 시, 분석 PJT PL과 상담해주시기 바랍니다.
	<table class="table anlch_ta">
		<colgroup>
			<col style="width:25%;"/>
			<col style="width:35%;"/>
			<col style="width:40%;"/>
		</colgroup>
		<tbody>
			<tr>
				<th align="center">분석분야</th>
				<th align="center">사업분야</th>
				<th align="center">담당자</th>
			</tr>
			<tr>
				<th align="center"  rowspan="7">형상</th>
				<th align="center">기반기술</th>
				<td align="center">
					<a href="#" onClick="setAnlChrgInfo('kwonjihye', '권지혜')">권지혜</a>
					<!-- ,<a href="#" onClick="setAnlChrgInfo('jihachoi', '최지하')">최지하</a> -->
					<!-- <a href="#" onClick="setAnlChrgInfo('soonbo', '이순보')">이순보</a> -->
				</td>
			</tr>
			<tr>
				<th align="center">자동차</th>
				<td align="center">
					<a href="#" onClick="setAnlChrgInfo('jihachoi', '최지하')">최지하</a>
				</td>
			</tr>
			<tr>
				<th align="center">단열재,벽지,바닥재</th>
				<td align="center">
					<a href="#" onClick="setAnlChrgInfo('jihee', '손지희')">손지희</a>
				</td>
			</tr>
			<tr>
				<th align="center">인테리어</th>
				<td align="center">
					<a href="#" onClick="setAnlChrgInfo('jihee', '손지희')">손지희</a>
				</td>
			</tr>
			<tr>
				<th align="center">창호</th>
				<td align="center">
					<a href="#" onClick="setAnlChrgInfo('kwonjihye', '권지혜')">권지혜</a>
				</td>
			</tr>
			<tr>
				<th align="center">표면소재</th>
				<td align="center">
					<a href="#" onClick="setAnlChrgInfo('kwonjihye', '권지혜')">권지혜</a>
				</td>
			</tr>
			<tr>
				<th align="center">산업용필름</th>
				<td align="center">
					<a href="#" onClick="setAnlChrgInfo('jihee', '손지희')">손지희</a>,
					<a href="#" onClick="setAnlChrgInfo('jihachoi', '최지하')">최지하</a>
				</td>
			</tr>
			<tr>
				<th align="center"  rowspan="7">유기</th>
				<th align="center">기반기술</th>
				<td align="center">
					<a href="#" onClick="setAnlChrgInfo('kimsb', '김샛별')">김샛별</a>
				</td>
			</tr>
			<tr>
				<th align="center">자동차</th>
				<td align="center">
					<a href="#" onClick="setAnlChrgInfo('leesangheon', '이상헌')">이상헌</a>
				</td>
			</tr>
			<tr>
				<th align="center">단열재,벽지,바닥재</th>
				<td align="center">
					<a href="#" onClick="setAnlChrgInfo('kimsb', '김샛별')">김샛별</a>,
					<a href="#" onClick="setAnlChrgInfo('yejee', '전예지')">전예지</a>
				</td>
			</tr>
			<tr>
				<th align="center">인테리어</th>
				<td align="center">
					<a href="#" onClick="setAnlChrgInfo('kimsb', '김샛별')">김샛별</a>
				</td>
			</tr>
			<tr>
				<th align="center">창호</th>
				<td align="center">
					<a href="#" onClick="setAnlChrgInfo('leesangheon', '이상헌')">이상헌</a>
				</td>
			</tr>
			<tr>
				<th align="center">표면소재</th>
				<td align="center">
					<a href="#" onClick="setAnlChrgInfo('leesangheon', '이상헌')">이상헌</a>
				</td>
			</tr>
			<tr>
				<th align="center">산업용필름</th>
				<td align="center">
					<a href="#" onClick="setAnlChrgInfo('leesangheon', '이상헌')">이상헌</a>
				</td>
			</tr>
			<tr>
				<th align="center">TVOC, 라돈</th>
				<td align="center" colspan="2">
					<a href="#" onClick="setAnlChrgInfo('chlee', '이종한')">이종한</a>
				</td>
			</tr>
			<tr>
				<th align="center">HCHO, 실내공기질</th>
				<td align="center" colspan="2">
					<a href="#" onClick="setAnlChrgInfo('kojaeyoon', '고재윤')">고재윤</a>
				</td>
			</tr>
			<tr>
				<th align="center">중금속, 방사능농도</th>
				<td align="center" colspan="2">
					<a href="#" onClick="setAnlChrgInfo('sumin', '권수민')">권수민</a>
				</td>
			</tr>
			<tr>
				<th align="center">프탈레이트, 할로겐,</br>Q-Gate유해물질분석</th>
				<td align="center" colspan="2">
					<a href="#" onClick="setAnlChrgInfo('lejaaa', '이은주')">이은주</a>
				</td>
			</tr>
			<tr>
				<th align="center">향균시험</th>
				<td align="center" colspan="2">
					<a href="#" onClick="setAnlChrgInfo('suyune', '김수연')">김수연</a>
				</td>
			</tr>
		</tbody>
	</table>
	</body>
</html>