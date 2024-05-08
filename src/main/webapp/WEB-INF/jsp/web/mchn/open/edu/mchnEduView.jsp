<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8"%>
<%@ page import="java.text.*, java.util.*,devonframe.util.NullUtil,devonframe.util.DateUtil, org.apache.logging.log4j.Logger, org.apache.logging.log4j.LogManager"%>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>
<%--
/*
 *************************************************************************
 * $Id		: mchnEduView.jsp
 * @desc    : 분석기기 > open기기 > 보유기기 관리 > 보유 기기관리 상세 (통합검색)
 *------------------------------------------------------------------------
 * VER	DATE		AUTHOR		DESCRIPTION
 * ---	-----------	----------	-----------------------------------------
 * 1.0  2017.11.02    IRIS05		최초생성
 * ---	-----------	----------	-----------------------------------------
 * IRIS 구축 프로젝트
 *************************************************************************
 */
--%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<%@ include file="/WEB-INF/jsp/include/rui_header.jspf"%>
<title><%=documentTitle%></title>
<script type="text/javascript">

	Rui.onReady(function(){
	


	});	//end ready

	//첨부파일 다운로드
	function fncDownload(attId, seq){
		document.aform.attcFilId.value = attId;
	 	document.aform.seq.value = seq;
	 	document.aform.action = "<c:url value='/system/attach/downloadAttachFile.do'/>";
	 	document.aform.submit();
	}


</script>
</head>
<body>
	<div class="contents">
	<div class="sub-content">
			<form name="aform" id="aform"  method="post">
				<input type="hidden" id="attcFilId" name="attcFilId" />
				<input type="hidden" id="seq" name="seq" />
				
				<table class="table table_txt_right">
					<colgroup>
						<col style="width: 15%" />
						<col style="width: 30%" />
						<col style="width: 15%" />
						<col style="width:" />
						<col style="width: 10%" />
					</colgroup>
					<tbody>
						<tr>
							<th align="right">교육명</th>
							<td colspan="3">
								<c:out value='${inputData.eduPttStNm}'/> - [<c:out value='${inputData.eduScnNm}'/>]<c:out value='${inputData.eduNm}'/>
							</td>
						</tr>
						<tr>
							<th align="right">담당자</th>
							<td>
								<c:out value='${inputData.eduCrgrNm}'/>
							</td>
							<th align="right">분석기기</th>
							<td>
								<c:out value='${inputData.mchnNm}'/>
							</td>
							<%-- <th align="right">최종교육일</th>
							<td>
								<c:out value='${inputData.ccsDt}'/>
							</td> --%>
						</tr>
						<tr>
							<th align="right">신청기간</th>
							<td>
								<c:out value='${inputData.pttFromDt}'/> ~ <c:out value='${inputData.pttToDt}'/>
							</td>
							<th align="right">모집인원</th>
							<td>
								신청 : <c:out value='${inputData.pttCpsn}'/> /  정원 : <c:out value='${inputData.ivttCpsn}'/>
							</td>
						</tr>
						<tr>
							<th align="right">교육일시</th>
							<td>
								<c:out value='${inputData.eduDt}'/> <c:out value='${inputData.eduFromTim}'/>시 ~ <c:out value='${inputData.eduToTim}'/>시
							</td>
							<th align="right">교육장소</th>
							<td>
								<c:out value='${inputData.eduPl}'/>
							</td>
						</tr>
						<tr>
							<td colspan="4">
								<c:out value='${inputData.dtlSbc}' escapeXml="false"/>
							</td>
						</tr>
						<tr>
							<th align="right">첨부파일</th>
							<td colspan="3">
								<c:forEach var="attachFileList" items="${attachFileList}">
                        			<a href="javascript:fncDownload('${attachFileList.attcFilId}','${attachFileList.seq}');">${attachFileList.filNm}</a><br>
								</c:forEach>
							</td>
						</tr>
						</tbody>
				</table>
			</form>

		</div>
		<!-- //sub-content -->
	</div>
	<!-- //contents -->
</body>
</html>