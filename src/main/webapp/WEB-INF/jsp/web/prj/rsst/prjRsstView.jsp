<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8"%>
<%@ page import="java.util.*,devonframe.util.NullUtil" %>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<%@ include file="/WEB-INF/jsp/include/rui_header.jspf"%>
<title>Insert title here</title>
</head>
<body>

<div class="contents" >
   	<div class="sub-content">
   		<table class="table table_txt_right">
			<colgroup>
				<col style="width:15%"/>
				<col style="width:30%"/>
				<col style="width:15%"/>
				<col style="width:*"/>
			</colgroup>
			<tbody>
			    <tr>
					<th align="right">WBS 코드</th>
					<td>
						${prjMstData.wbsCd}
					</td>
					<th align="right"><label for="lPrjNm">프로젝트명</label></th>
					<td>
						${prjMstData.prjNm}
					</td>
				</tr>
					<tr>
					<th align="right">PL 명</th>
					<td>${prjMstData.saName}</td>
					<th align="right">조직</th>
					<td>
						${prjMstData.uperdeptName}
					</td>
				</tr>
				<tr>
					<th align="right">프로젝트기간</th>
					<td>
						${prjMstData.prjStrDt} ~ ${prjMstData.prjEndDt}
					</td>
					<th align="right">개발인원</th>
					<td>
						${prjMstData.prjCpsn}
					</td>
				</tr>
				
				<br/>
				<tr>
					<th>연구개발 범위</th>
					<td colspan="3" style="height:100px;">
						<c:out value="${prjDtlData.rsstDevScp}" escapeXml="false"/>	
					</td>
				</tr>
				<tr>
					<th>사업영역(제품군)</th>
					<td colspan="3" style="height:100px;">
						<c:out value="${prjDtlData.bizArea}" escapeXml="false"/>	
					</td>
				</tr>
				<tr>
					<th>핵심기반 기술</th>
					<td colspan="3" style="height:100px;">
						<c:out value="${prjDtlData.mnBaseTclg}" escapeXml="false"/>	
					</td>
				</tr>
			</tbody>
		</table>
	</div><!-- //sub-content -->

</div><!-- //contents -->

</body>
</html>