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
				<th align="center">사업분야</th>
				<th align="center">분석분야</th>
				<th align="center">담당자</th>
			</tr>
			<tr>
				<th align="center" rowspan="3">기반기술</th>
				<td align="center">형상분석</td>
				<td align="center">
					<a href="#" onClick="setAnlChrgInfo('kwonjihye', '권지혜')">권지혜</a>,
					<a href="#" onClick="setAnlChrgInfo('jihachoi', '최지하')">최지하</a>
					<!-- <a href="#" onClick="setAnlChrgInfo('soonbo', '이순보')">이순보</a> -->
				</td>
			</tr>
			<tr>
				<td align="center">유기분석</td>
				<td align="center">
					<a href="#" onClick="setAnlChrgInfo('kimsb', '김샛별')">김샛별</a>,
					<a href="#" onClick="setAnlChrgInfo('leesangheon', '이상헌')">이상헌</a>
				</td>
			</tr>
			<tr>
				<td align="center">유해물질분석</td>
				<td align="center">
					<a href="#" onClick="setAnlChrgInfo('chlee', '이종한')">TVOC 이종한</a></br>
					<a href="#" onClick="setAnlChrgInfo('kojaeyoon', '고재윤')">포름알데히드 고재윤</a></br>
					<a href="#" onClick="setAnlChrgInfo('sumin', '권수민')">중금속 권수민</a></br>
					<a href="#" onClick="setAnlChrgInfo('lejaaa', '이은주')">프탈레이트 이은주</a></br>
					<a href="#" onClick="setAnlChrgInfo('sumin', '권수민')">라돈(방사능농도) 권수민</a></br>
					<a href="#" onClick="setAnlChrgInfo('suyune', '김수연')">항균 김수연</a>
				</td>
			</tr>
			<tr>
				<th align="center" rowspan="3">인테리어</th>
				<td align="center">형상분석</td>
				<td align="center">
					<a href="#" onClick="setAnlChrgInfo('jihachoi', '최지하')">최지하</a>
				</td>
			</tr>
			<tr>
				<td align="center">유기분석</td>
				<td align="center">
					<!-- <a href="#" onClick="setAnlChrgInfo('suyune', '김수연')">김수연</a> -->
					<!-- <a href="#" onClick="setAnlChrgInfo('leesangheon', '이상헌')">이상헌</a> -->
					<a href="#" onClick="setAnlChrgInfo('kimsb', '김샛별')">김샛별</a>
				</td>
			</tr>
			<tr>
				<td align="center">유해물질분석</td>
				<td align="center">
					<a href="#" onClick="setAnlChrgInfo('chlee', '이종한')">TVOC 이종한</a></br>
					<a href="#" onClick="setAnlChrgInfo('kojaeyoon', '고재윤')">포름알데히드 고재윤</a></br>
					<a href="#" onClick="setAnlChrgInfo('sumin', '권수민')">중금속 권수민</a></br>
					<a href="#" onClick="setAnlChrgInfo('lejaaa', '이은주')">프탈레이트 이은주</a></br>
					<a href="#" onClick="setAnlChrgInfo('sumin', '권수민')">라돈(방사능농도) 권수민</a></br>
					<a href="#" onClick="setAnlChrgInfo('suyune', '김수연')">항균 김수연</a>
				</td>
			</tr>
			<tr>
				<th align="center" rowspan="3">자동차소재부품</th>
				<td align="center">형상분석</td>
				<td align="center">
					<a href="#" onClick="setAnlChrgInfo('jihee', '손지희')">손지희</a>
					<!-- <a href="#" onClick="setAnlChrgInfo('kwonjihye', '권지혜')">권지혜</a> -->
				</td>
			</tr>
			<tr>
				<td align="center">유기분석</td>
				<td align="center">
					<!-- <a href="#" onClick="setAnlChrgInfo('suyune', '김수연')">김수연</a> -->
					<a href="#" onClick="setAnlChrgInfo('leesangheon', '이상헌')">이상헌</a>
				</td>
			</tr>
			<tr>
				<td align="center">유해물질분석</td>
				<td align="center">
					<a href="#" onClick="setAnlChrgInfo('chlee', '이종한')">TVOC 이종한</a></br>
					<a href="#" onClick="setAnlChrgInfo('kojaeyoon', '고재윤')">포름알데히드 고재윤</a></br>
					<a href="#" onClick="setAnlChrgInfo('sumin', '권수민')">중금속 권수민</a></br>
					<a href="#" onClick="setAnlChrgInfo('lejaaa', '이은주')">프탈레이트 이은주</a></br>
					<a href="#" onClick="setAnlChrgInfo('sumin', '권수민')">라돈(방사능농도) 권수민</a></br>
					<a href="#" onClick="setAnlChrgInfo('suyune', '김수연')">항균 김수연</a>
				</td>
			</tr>
			<tr>
				<th align="center" rowspan="3">창호</th>
				<td align="center">형상분석</td>
				<td align="center">
					<!-- <a href="#" onClick="setAnlChrgInfo('jihachoi', '최지하')">최지하</a> -->
					<a href="#" onClick="setAnlChrgInfo('kwonjihye', '권지혜')">권지혜</a>
				</td>
			</tr>
			<tr>
				<td align="center">유기분석</td>
				<td align="center">
					<a href="#" onClick="setAnlChrgInfo('leesangheon', '이상헌')">이상헌</a>
				</td>
			</tr>
			<tr>
				<td align="center">유해물질분석</td>
				<td align="center">
					<a href="#" onClick="setAnlChrgInfo('chlee', '이종한')">TVOC 이종한</a></br>
					<a href="#" onClick="setAnlChrgInfo('kojaeyoon', '고재윤')">포름알데히드 고재윤</a></br>
					<a href="#" onClick="setAnlChrgInfo('sumin', '권수민')">중금속 권수민</a></br>
					<a href="#" onClick="setAnlChrgInfo('lejaaa', '이은주')">프탈레이트 이은주</a></br>
					<a href="#" onClick="setAnlChrgInfo('sumin', '권수민')">라돈(방사능농도) 권수민</a></br>
					<a href="#" onClick="setAnlChrgInfo('suyune', '김수연')">항균 김수연</a>
				</td>
			</tr>
			<tr>
				<th align="center" rowspan="3">장식재</th>
				<td align="center">형상분석</td>
				<td align="center">
					<a href="#" onClick="setAnlChrgInfo('jihee', '손지희')">손지희</a>
					<!-- <a href="#" onClick="setAnlChrgInfo('jihachoi', '최지하')">최지하</a> -->
				</td>
			</tr>
			<tr>
				<td align="center">유기분석</td>
				<td align="center">
					<a href="#" onClick="setAnlChrgInfo('kimsb', '김샛별')">김샛별</a>
				</td>
			</tr>
			<tr>
				<td align="center">유해물질분석</td>
				<td align="center">
					<a href="#" onClick="setAnlChrgInfo('chlee', '이종한')">TVOC 이종한</a></br>
					<a href="#" onClick="setAnlChrgInfo('kojaeyoon', '고재윤')">포름알데히드 고재윤</a></br>
					<a href="#" onClick="setAnlChrgInfo('sumin', '권수민')">중금속 권수민</a></br>
					<a href="#" onClick="setAnlChrgInfo('lejaaa', '이은주')">프탈레이트 이은주</a></br>
					<a href="#" onClick="setAnlChrgInfo('sumin', '권수민')">라돈(방사능농도) 권수민</a></br>
					<a href="#" onClick="setAnlChrgInfo('suyune', '김수연')">항균 김수연</a>
				</td>
			</tr>
			<tr>
				<th align="center" rowspan="3">표면소재</th>
				<td align="center">형상분석</td>
				<td align="center">
					<a href="#" onClick="setAnlChrgInfo('kwonjihye', '권지혜')">권지혜</a>,
					<a href="#" onClick="setAnlChrgInfo('jihachoi', '최지하')">최지하</a>
				</td>
			</tr>
			<tr>
				<td align="center">유기분석</td>
				<td align="center">
					<a href="#" onClick="setAnlChrgInfo('leesangheon', '이상헌')">이상헌</a>
				</td>
			</tr>
			<tr>
				<td align="center">유해물질분석</td>
				<td align="center">
					<a href="#" onClick="setAnlChrgInfo('chlee', '이종한')">TVOC 이종한</a></br>
					<a href="#" onClick="setAnlChrgInfo('kojaeyoon', '고재윤')">포름알데히드 고재윤</a></br>
					<a href="#" onClick="setAnlChrgInfo('sumin', '권수민')">중금속 권수민</a></br>
					<a href="#" onClick="setAnlChrgInfo('lejaaa', '이은주')">프탈레이트 이은주</a></br>
					<a href="#" onClick="setAnlChrgInfo('sumin', '권수민')">라돈(방사능농도) 권수민</a></br>
					<a href="#" onClick="setAnlChrgInfo('suyune', '김수연')">항균 김수연</a>
				</td>
			</tr>
		</tbody>
	</table>
	</body>
</html>