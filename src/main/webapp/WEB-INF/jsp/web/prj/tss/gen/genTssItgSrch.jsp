<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*, java.util.*,devonframe.util.NullUtil,devonframe.util.DateUtil"%>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>

<%--
/*
 *************************************************************************
 * $Id      : genTssItgSrch.jsp
 * @desc    : 통합검색 > 일반과제
 *------------------------------------------------------------------------
 * VER  DATE        AUTHOR      DESCRIPTION
 * ---  ----------- ----------  -----------------------------------------
 * 1.0  2017.08.08
 * ---  ----------- ----------  -----------------------------------------
 * IRIS 프로젝트
 *************************************************************************
 */
--%>

<html xmlns="http://www.w3.org/1999/xhtml">
<style>
.search-toggleBtn {display:none;}
</style>
<head>

<%@ include file="/WEB-INF/jsp/include/rui_header.jspf"%>

<title><%=documentTitle%></title>

<%
    response.setHeader("Pragma", "No-cache");
    response.setDateHeader("Expires", 0);
    response.setHeader("Cache-Control", "no-cache");

    //치환 변수 선언
    pageContext.setAttribute("cn", "\n");    //Enter
    pageContext.setAttribute("br", "<br/>"); //br 태그

%>
</head>
<body>
    <Tag:saymessage />
    <%--<!--  sayMessage 사용시 필요 -->--%>
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
                                    <td>${resultMst.prjNm}</td>
                                    <th>조직</th>
                                    <td>${resultMst.deptName}</td>
                                </tr>
                                <tr>
                                    <th>발의주체</th>
                                    <td>${resultMst.ppslMbdNm}</td>
                                    <th>사업부문(Funding기준)</th>
                                    <td>${resultMst.bizDptNm}</td>
                                </tr>
                                <tr>
                                    <th>과제명</th>
                                    <td colspan="3">${resultMst.tssNm}</td>
                                </tr>
                                <tr>
                                    <th>과제속성</th>
                                    <td>${resultMst.tssAttrNm}</td>
                                    <th>과제리더</th>
                                    <td>${resultMst.saUserName}</td>
                                </tr>
                            </tbody>
                        </table>
                    <div class="titArea"><h3>2. 개발기간</h3></div>
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
                                    <td>${resultMst.tssStrtDd}</td>
                                    <th>과제종료일</th>
                                    <td>${resultMst.tssFnhDd}</td>
                                </tr>
                            </tbody>
                        </table>
                    <div class="titArea"><h3>3. 주요 concept</h3></div>
                        <table class="table">
                            <colgroup>
                                <col style="width:100%"/>
                            </colgroup>
                            <tbody class="table_concept">
                                <tr>
                                    <td>1) Needs</td>
                                </tr>
                                <tr>
                                    <td><c:out value="${resultSmry.smryNTxt}" escapeXml="false"/></td>
                                </tr>
                                <tr>
                                    <td>2) Approach</td>
                                </tr>
                                <tr>
                                    <td><c:out value="${resultSmry.smryATxt}" escapeXml="false"/></td>
                                </tr>
                                <tr>
                                    <td>3) Benefit</td>
                                </tr>
                                <tr>
                                    <td><c:out value="${resultSmry.smryBTxt}" escapeXml="false"/></td>
                                </tr>
                                <tr>
                                    <td>4) Competition</td>
                                </tr>
                                <tr>
                                    <td><c:out value="${resultSmry.smryCTxt}" escapeXml="false"/></td>
                                </tr>
                                <tr>
                                    <td>5) Deliverables</td>
                                </tr>
                                <tr>
                                    <td><c:out value="${resultSmry.smryDTxt}" escapeXml="false"/></td>
                                </tr>
                            </tbody>
                        </table>
                    <div class="titArea"><h3>4. 기대성과<span class="h3_stitle">(영업이익률, 상품출시(계획), 신제품 매출계획)</span></h3></div>
                        <table class="table">
                            <colgroup>
                                <col style="width:18%"/>
                                <col style="width:16%"/>
                                <col style="width:16%"/>
                                <col style="width:16%"/>
                                <col style="width:16%"/>
                                <col style="width:16%"/>
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th>상품출시(계획)</th>
                                    <td colspan="5">${resultSmry.ctyOtPlnM}</td>
                                </tr>
                                <tr>
                                    <th colspan="6">영업이익율(%)</th>
                                </tr>
                                <tr>
                                    <th>Y</th>
                                    <th>Y+1</th>
                                    <th>Y+2</th>
                                    <th>Y+3</th>
                                    <th>Y+4</th>
                                    <th>평균</th>
                                </tr>
                                <tr>
                                    <fmt:parseNumber var="bizPrftProYCnt" value="${0}" pattern="#.##" />
                                    <td class="alignR">
                                        <fmt:parseNumber var="bizPrftProY" value="${resultSmry.bizPrftProY}" pattern="#.##" />
                                        <fmt:formatNumber value="${bizPrftProY}" pattern="#,###.##"/>
                                    </td>
                                    <td class="alignR">
                                        <fmt:parseNumber var="bizPrftProY1" value="${resultSmry.bizPrftProY1}" pattern="#.##" />
                                        <fmt:formatNumber value="${bizPrftProY1}" pattern="#,###.##"/>
                                    </td>
                                    <td class="alignR">
                                        <fmt:parseNumber var="bizPrftProY2" value="${resultSmry.bizPrftProY2}" pattern="#.##" />
                                        <fmt:formatNumber value="${bizPrftProY2}" pattern="#,###.##"/>
                                    </td>
                                    <td class="alignR">
                                        <fmt:parseNumber var="bizPrftProY3" value="${resultSmry.bizPrftProY3}" pattern="#.##" />
                                        <fmt:formatNumber value="${bizPrftProY3}" pattern="#,###.##"/>
                                    </td>
                                    <td class="alignR">
                                        <fmt:parseNumber var="bizPrftProY4" value="${resultSmry.bizPrftProY4}" pattern="#.##" />
                                        <fmt:formatNumber value="${bizPrftProY4}" pattern="#,###.##"/>
                                    </td>
                                    <td class="alignR">
                                        <c:if test="${bizPrftProY > 0}"><c:set var="bizPrftProYCnt" value="${bizPrftProYCnt + 1}" /></c:if>
                                        <c:if test="${bizPrftProY1 > 0}"><c:set var="bizPrftProYCnt" value="${bizPrftProYCnt + 1}" /></c:if>
                                        <c:if test="${bizPrftProY2 > 0}"><c:set var="bizPrftProYCnt" value="${bizPrftProYCnt + 1}" /></c:if>
                                        <c:if test="${bizPrftProY3 > 0}"><c:set var="bizPrftProYCnt" value="${bizPrftProYCnt + 1}" /></c:if>
                                        <c:if test="${bizPrftProY4 > 0}"><c:set var="bizPrftProYCnt" value="${bizPrftProYCnt + 1}" /></c:if>
                                        <c:if test="${bizPrftProYCnt eq 0}"><c:set var="bizPrftProYCnt" value="${bizPrftProYCnt + 1}" /></c:if>
                                        <fmt:formatNumber value="${(bizPrftProY + bizPrftProY1 + bizPrftProY2 + bizPrftProY3 + bizPrftProY4) / bizPrftProYCnt}" pattern="#,###.##" />
                                    </td>
                                </tr>
                                <tr>
                                    <th colspan="6">신제품 매출계획(단위:억원)</th>
                                </tr>
                                <tr>
                                    <th>Y</th>
                                    <th>Y+1</th>
                                    <th>Y+2</th>
                                    <th>Y+3</th>
                                    <th>Y+4</th>
                                    <th>평균</th>
                                </tr>
                                <tr>
                                    <fmt:parseNumber var="nprodSalsPlnYSub" value="${100000000}" pattern="#.##" />
                                    <fmt:parseNumber var="nprodSalsPlnYCnt" value="${0}" pattern="#.##" />
                                    <td class="alignR">
                                        <fmt:parseNumber var="nprodSalsPlnY" value="${resultSmry.nprodSalsPlnY}" pattern="#.##" />
                                        <fmt:formatNumber value="${nprodSalsPlnY/nprodSalsPlnYSub}" pattern="#,###.##"/>
                                    </td>
                                    <td class="alignR">
                                        <fmt:parseNumber var="nprodSalsPlnY1" value="${resultSmry.nprodSalsPlnY1}" pattern="#.##" />
                                        <fmt:formatNumber value="${nprodSalsPlnY1/nprodSalsPlnYSub}" pattern="#,###.##"/>
                                    </td>
                                    <td class="alignR">
                                        <fmt:parseNumber var="nprodSalsPlnY2" value="${resultSmry.nprodSalsPlnY2}" pattern="#.##" />
                                        <fmt:formatNumber value="${nprodSalsPlnY2/nprodSalsPlnYSub}" pattern="#,###.##"/>
                                    </td>
                                    <td class="alignR">
                                        <fmt:parseNumber var="nprodSalsPlnY3" value="${resultSmry.nprodSalsPlnY3}" pattern="#.##" />
                                        <fmt:formatNumber value="${nprodSalsPlnY3/nprodSalsPlnYSub}" pattern="#,###.##"/>
                                    </td>
                                    <td class="alignR">
                                        <fmt:parseNumber var="nprodSalsPlnY4" value="${resultSmry.nprodSalsPlnY4}" pattern="#.##" />
                                        <fmt:formatNumber value="${nprodSalsPlnY4/nprodSalsPlnYSub}" pattern="#,###.##"/>
                                    </td>
                                    <td class="alignR">
                                        <c:if test="${nprodSalsPlnY > 0}"><c:set var="nprodSalsPlnYCnt" value="${nprodSalsPlnYCnt + 1}" /></c:if>
                                        <c:if test="${nprodSalsPlnY1 > 0}"><c:set var="nprodSalsPlnYCnt" value="${nprodSalsPlnYCnt + 1}" /></c:if>
                                        <c:if test="${nprodSalsPlnY2 > 0}"><c:set var="nprodSalsPlnYCnt" value="${nprodSalsPlnYCnt + 1}" /></c:if>
                                        <c:if test="${nprodSalsPlnY3 > 0}"><c:set var="nprodSalsPlnYCnt" value="${nprodSalsPlnYCnt + 1}" /></c:if>
                                        <c:if test="${nprodSalsPlnY4 > 0}"><c:set var="nprodSalsPlnYCnt" value="${nprodSalsPlnYCnt + 1}" /></c:if>
                                        <c:if test="${nprodSalsPlnYCnt eq 0}"><c:set var="nprodSalsPlnYCnt" value="${nprodSalsPlnYCnt + 1}" /></c:if>
                                        <fmt:formatNumber value="${((nprodSalsPlnY + nprodSalsPlnY1 + nprodSalsPlnY2 + nprodSalsPlnY3 + nprodSalsPlnY4) / nprodSalsPlnYCnt) / nprodSalsPlnYSub}" pattern="#,###.##" />
                                    </td>
                                </tr>
                                <tr>
                                    <th colspan="6">투입인원(M/M)</th>
                                </tr>
                                <tr>
                                    <th>Y</th>
                                    <th>Y+1</th>
                                    <th>Y+2</th>
                                    <th>Y+3</th>
                                    <th>Y+4</th>
                                    <th>평균</th>
                                </tr>
                                <tr>
                                    <fmt:parseNumber var="ptcCpsnYCnt" value="${0}" pattern="#.##" />
                                    <td class="alignR"><fmt:formatNumber value="${resultSmry.ptcCpsnY}" pattern="#,###.##" /></td>
                                    <td class="alignR"><fmt:formatNumber value="${resultSmry.ptcCpsnY1}" pattern="#,###.##" /></td>
                                    <td class="alignR"><fmt:formatNumber value="${resultSmry.ptcCpsnY2}" pattern="#,###.##" /></td>
                                    <td class="alignR"><fmt:formatNumber value="${resultSmry.ptcCpsnY3}" pattern="#,###.##" /></td>
                                    <td class="alignR"><fmt:formatNumber value="${resultSmry.ptcCpsnY4}" pattern="#,###.##" /></td>
                                    <td class="alignR">
                                        <c:if test="${resultSmry.ptcCpsnY > 0}"><c:set var="ptcCpsnYCnt" value="${ptcCpsnYCnt + 1}" /></c:if>
                                        <c:if test="${resultSmry.ptcCpsnY1 > 0}"><c:set var="ptcCpsnYCnt" value="${ptcCpsnYCnt + 1}" /></c:if>
                                        <c:if test="${resultSmry.ptcCpsnY2 > 0}"><c:set var="ptcCpsnYCnt" value="${ptcCpsnYCnt + 1}" /></c:if>
                                        <c:if test="${resultSmry.ptcCpsnY3 > 0}"><c:set var="ptcCpsnYCnt" value="${ptcCpsnYCnt + 1}" /></c:if>
                                        <c:if test="${resultSmry.ptcCpsnY4 > 0}"><c:set var="ptcCpsnYCnt" value="${ptcCpsnYCnt + 1}" /></c:if>
                                        <c:if test="${ptcCpsnYCnt eq 0}"><c:set var="ptcCpsnYCnt" value="${ptcCpsnYCnt + 1}" /></c:if>
                                        <fmt:formatNumber value="${(resultSmry.ptcCpsnY + resultSmry.ptcCpsnY1 + resultSmry.ptcCpsnY2 + resultSmry.ptcCpsnY3 + resultSmry.ptcCpsnY4) / ptcCpsnYCnt}" pattern="#,###.##" />
                                    </td>
                                </tr>
                            </tbody>    
                        </table>
                    <div class="titArea"><h3>5. 첨부파일</h3></div>
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