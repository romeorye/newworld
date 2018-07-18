<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*, java.util.*,devonframe.util.NullUtil,devonframe.util.DateUtil"%>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>

<%--
/*
 *************************************************************************
 * $Id      : ousdCooTssItgSrch.jsp
 * @desc    : 통합검색 > 대외협력과제 화면
 *------------------------------------------------------------------------
 * VER  DATE        AUTHOR      DESCRIPTION
 * ---  ----------- ----------  -----------------------------------------
 * 1.0  2017.09.19  IRIS04		최초생성
 * ---  ----------- ----------  -----------------------------------------
 * IRIS 프로젝트
 *************************************************************************
 */
--%>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/include/rui_header.jspf"%>

<title><%=documentTitle%></title>

</head>
<body>
    <div class="contents">
        <div class="sub-content">
            <form name="aform" id="aform" method="post">
                <div id="csusContents">
<div class="titArea"><h3>1. 개요</h3></div>
                            <table class="table table_txt_right">
	                            <colgroup>
	                                <col style="width:20%"/>
	                                <col style="width:30%"/>
	                                <col style="width:20%"/>
	                                <col style="width:30%"/>
	                            </colgroup>
	                            <tbody>
	                                <tr>
	                                    <th>프로젝트명</th>
	                                    <td><c:out value="${resultMst.prjNm}"/></td>
	                                    <th>조직</th>
	                                    <td><c:out value="${resultMst.deptName}"/></td>
	                                </tr>
	                                <tr>
	                                    <th>사업부문(Funding기준)</th>
	                                    <td colspan="3"><c:out value="${resultMst.bizDptNm}"/></td>
	                                </tr>
	                                <tr>
	                                    <th>과제명</th>
	                                    <td colspan="3"><c:out value="${resultMst.tssNm}"/></td>
	                                </tr>
	                                <tr>
	                                    <th>연구책임자</th>
	                                    <td colspan="3"><c:out value="${resultMst.saUserName}"/></td>
	                                </tr>
	                            </tbody>
	                        </table>
<div class="titArea"><h3>2. 협력기관</h3></div>
                            <table class="table">
	                            <colgroup>
	                                <col style="width:30%"/>
	                                <col style="width:20%"/>
	                                <col style="width:10%"/>
	                                <col style="width:10%"/>
	                                <col style="width:30%"/>
	                            </colgroup>
	                            <tbody>
	                            	<tr>
	                                    <th>협력기관명</th>
	                                    <th>소속</th>
	                                    <th>성명</th>
	                                    <th>직위</th>
	                                    <th>대표분야</th>
	                                </tr>
	                                <tr>
	                                	<c:choose>
			                            <c:when test="${fn:length(resultOsl) == 0}">
			                            	<td align="center" colspan="5"></td>
			                            </c:when>
			                            <c:otherwise>
		                                    <td class="alignC"><c:out value="${resultOsl.instNm}"/></td>
		                                    <td class="alignC"><c:out value="${resultOsl.opsNm}"/></td>
		                                    <td class="alignC"><c:out value="${resultOsl.spltNm}"/></td>
		                                    <td class="alignC"><c:out value="${resultOsl.poaNm}"/></td>
		                                    <td align="center"><c:out value="${resultOsl.repnSphe}"/></td>
	                                    </c:otherwise>
	                                    </c:choose>
	                                </tr>
	                            </tbody>
	                        </table>
<div class="titArea"><h3>3. 계약기간</h3></div>
                            <table class="table table_txt_right">
	                            <colgroup>
	                                <col style="width:20%"/>
	                                <col style="width:30%"/>
	                                <col style="width:20%"/>
	                                <col style="width:30%"/>
	                            </colgroup>
	                            <tbody>
	                                <tr>
	                                    <th>과제시작일</th>
	                                    <td><c:out value="${resultMst.tssStrtDd}"/></td>
	                                    <th>과제종료일</th>
	                                    <td><c:out value="${resultMst.tssFnhDd}"/></td>
	                                </tr>
	                            </tbody>
	                        </table>
<div class="titArea"><h3>4. 계약 유형 및 독점권</h3></div>
                            <table class="table table_txt_right">
	                            <colgroup>
	                                <col style="width:20%"/>
	                                <col style="width:30%"/>
	                                <col style="width:20%"/>
	                                <col style="width:30%"/>
	                            </colgroup>
	                            <tbody>
	                                <tr>
	                                    <th>계약유형</th>
	                                    <td><c:out value="${resultSmry.cnttTypeNm}"/></td>
	                                    <th>독점권</th>
	                                    <td><c:out value="${resultSmry.monoNm}"/></td>
	                                </tr>
	                            </tbody>
	                        </table>
<div class="titArea"><h3>5. 연구비 / 지급 조건</h3></div>
                            <table class="table table_txt_right">
	                            <colgroup>
	                                <col style="width:100%"/>
	                            </colgroup>
	                            <tbody>
	                                <tr>
	                                    <td><fmt:formatNumber value="${resultSmry.rsstExpConvertMil}" type="number"/> 억원</td>
	                                </tr>
	                                <tr>
	                                    <td><c:out value="${resultSmry.rsstExpFnshCnd}" escapeXml="false"/></td>
	                                </tr>
	                            </tbody>
	                        </table>
<div class="titArea"><h3>6. 법무팀 검토 결과</h3></div>
                            <table class="table table_txt_right">
	                            <colgroup>
	                                <col style="width:100%"/>
	                            </colgroup>
	                            <tbody>
	                                <tr>
	                                    <td><c:out value="${resultSmry.rvwRsltTxt}" escapeXml="false"/></td>
	                                </tr>
	                            </tbody>
	                        </table>
<div class="titArea"><h3>7. 연구과제배경 및 필요성</h3></div>
                            <table class="table table_txt_right">
	                            <colgroup>
	                                <col style="width:100%"/>
	                            </colgroup>
	                            <tbody>
	                                <tr>
	                                    <td><c:out value="${resultSmry.surrNcssTxt}" escapeXml="false"/></td>
	                                </tr>
	                            </tbody>
	                        </table>
<div class="titArea"><h3>8. 주요 연구개발 내용 요약</h3></div>
                            <table class="table table_txt_right">
	                            <colgroup>
	                                <col style="width:100%"/>
	                            </colgroup>
	                            <tbody>
	                                <tr>
	                                    <td><c:out value="${resultSmry.sbcSmryTxt}" escapeXml="false"/></td>
	                                </tr>
	                            </tbody>
	                        </table>
<div class="titArea"><h3>9. 목표기술 성과 계획</h3></div>
                            <table class="table table_txt_right">
	                            <colgroup>
	                                <col style="width:100%"/>
	                            </colgroup>
	                            <tbody>
	                                <tr>
	                                    <td><c:out value="${resultSmry.oucmPlnTxt}" escapeXml="false"/></td>
	                                </tr>
	                            </tbody>
	                        </table>
<div class="titArea"><h3>10. 첨부파일</h3></div>
                            <table class="table table_txt_right">
                                <colgroup>
                                    <col style="width:100%"/>
                                </colgroup>
                                <tbody>
				                    <tr>
				                        <td>
				                            <c:forEach var="resultAttc" items="${resultAttc}">
				                                <a href="http://iris.lghausys.com:7030/iris/common/login/irisDirectLogin.do?reUrl=/system/attach/downloadAttachFile.do&attcFilId=${resultAttc.attcFilId}&seq=${resultAttc.seq}">${resultAttc.filNm} (${resultAttc.filSize}byte)</a><br/>
				                            </c:forEach>
				                        </td>
				                    </tr>
				                    </tbody>
				                </table> 
                </div>
            </form>
        </div>
    </div>
</body>
</html>