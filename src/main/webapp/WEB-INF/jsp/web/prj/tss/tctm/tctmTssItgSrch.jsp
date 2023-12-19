<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>

<%--
/*
 *************************************************************************
 * $Id      :  tctmTssItgSrch.jsp
 * @desc    : 기술팀 과제 개요 (통합검색화면용)
 *------------------------------------------------------------------------
 * VER  DATE        AUTHOR      DESCRIPTION
 * ---  ----------- ----------  -----------------------------------------
 * 1.0  2018.10.15
 * ---  ----------- ----------  -----------------------------------------
 * IRIS 프로젝트
 *************************************************************************
 */
--%>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<%@ include file="/WEB-INF/jsp/include/rui_header.jspf"%>

<title><%=documentTitle%></title>

<script type="text/javascript">


</script>

</head>
<body style="overflow-y : hidden">
        <table class="table table_txt_right">
            <colgroup>
                <col style="width: 18%;"/>
                <col style="width: 32%;"/>
                <col style="width: 18%;"/>
                <col style="width: 32%;"/>
            </colgroup>
            <tbody>
				<tr>
					<th align="right" onclick="setTestCode()"">개발부서</th>
					<td>${resultMst.prjNm}</td>
					<th align="right">사업부</th>
					<td>
						${resultMst.deptName}
					</td>
				</tr>

				<tr>
					<th align="right">WBS Code / 과제명</th>
					<td class="tssLableCss" colspan="3">
						<span id='seed'/>
						${resultMst.wbsCd}<em>/</em>${resultMst.tssNm}
					</td>
				</tr>
				<tr>
					<th align="right">과제담당자</th>
					<td>${resultMst.saSabunName}</td>
					<th align="right">사업부문(Funding기준)</th>
					<td>
						${resultMst.bizDptNm}
					</td>
				</tr>
				<tr>
					<th align="right">제품군</th>
					<td class="tssLableCss">
						${resultMst.prodGNm}
					</td>
					<th align="right">과제기간</th>
					<td class="tssLableCss">
						${resultMst.tssStrtDd}<em class="gab"> ~ </em>${resultMst.tssFnhDd}
					</td>
				</tr>
				<tr>
					<th align="right">발의주체</th>
					<td class="tssLableCss">
						<div id="ppslMbdCd"/>
					</td>

				</tr>
				<tr>
					<th align="right">연구분야</th>
					<td>
						<div id="rsstSphe"/>
					</td>
					<th align="right">과제속성</th>
					<td class="tssLableCss">
						<div id="tssAttrCd"/>
					</td>
				</tr>
				<tr>
					<th align="right">신제품 유형</th>
					<td>
						<div id="tssType"/>
					</td>
					<th align="right">Q-gate 단계</th>
					<td><span id="qgateStepNm"/> </td>
				</tr>
				<tr>
					<th align="right">진행단계</th>
					<td><span id="tssStepNm"/></td>
					<th align="right" id="grsYnTd0101" style="display: none">GRS 사용여부</th>
                          <td id="grsYnTd0102" style="display: none"><div id="grsYn"/></td>
                          <th align="right" id="grsYnTd0201"">GRS 상태</th>
                          <td id="grsYnTd0202"><span id="grsStepNm"/> </td>
				</tr>
				<tr id="cmDdRow" style="display: none">
					<th align="right">실적(개발완료시점)</th>
					<td colspan="3">
						<input type="text" id="cmplBStrtDd" value="" /><em class="gab"> ~ </em>
						<input type="text" id="cmplBFnhDd" value="" />
					</td>
				</tr>
				<tr id="dcDdRow" style="display: none">
					<th align="right">실적(개발중단시점)</th>
					<td colspan="3">
						<input type="text" id="dcacBStrtDd" value="" /><em class="gab"> ~ </em>
						<input type="text" id="dcacBFnhDd" value="" />
					</td>
				</tr>
            <tr>
                <th align="right" onclick="setTestVal()">Summary 개요</th>
                <td colspan="3" class="space_tain"><c:out value="${resultSmry.smrSmryTxt}" escapeXml="false"/></td>
            </tr>
            <tr>
                <th align="right">Summary 목표</th>
                <td colspan="3"  class="space_tain"><c:out value="${resultSmry.smrGoalTxt}" escapeXml="false"/></td>
            </tr>
            <tr>
                <th align="right">상품출시(계획)</th>
                <td class="space_tain"><c:out value="${resultSmry.ctyOtPlnM}" escapeXml="false"/></td>
                <th>신제품 매출계획(단위:억원)</th>
                <td class="space_tain">${resultSmry.nprodSalsPlnY}</td>
            </tr>
            <tr>
                <th align="right">GRS심의파일<br/>(심의파일, 회의록 필수 첨부)</th>
                <td colspan="2" id="attchFileView">&nbsp;</td>
                <td colspan="1">
                    <button type="button" class="btn" id="attchFileMngBtn" name="attchFileMngBtn" onclick="openAttachFileDialog(setAttachFileInfo, getAttachFileId(), 'prjPolicy', '*')">
                        첨부파일등록
                    </button>
                </td>
            </tr>
            </tbody>
        </table>
</div>
</body>
</html>