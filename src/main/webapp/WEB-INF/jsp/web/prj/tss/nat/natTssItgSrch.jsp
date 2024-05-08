<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*, java.util.*,devonframe.util.NullUtil,devonframe.util.DateUtil"%>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %> 

<%--
/*
 *************************************************************************
 * $Id      : natTssItgSrch.jsp
 * @desc    : 통합검색 > 국책과제
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
                                <col style="width:15%"/>
                                <col style="width:35%"/>
                                <col style="width:15%"/>
                                <col style="width:35%"/>
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
                                    <td>${resultMst.bizNm}</td>
                                    <th>사업부문(Funding기준)</th>
                                    <td>${resultMst.bizDptNm}</td>
                                </tr>
                                <tr>
                                    <th>과제명</th>
                                    <td>${resultMst.tssNm}</td>
                                    <th>연구책임자</th>
                                    <td>${resultMst.saUserName}</td>
                                </tr>
                            </tbody>
                        </table>
            <br/>
                        <table class="table">
                            <colgroup>
                                <col style="width:33%"/>
                                <col style="width:33%"/>
                                <col style="width:34%"/>
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th>사업명</th>
                                    <th>주관부처</th>
                                    <th>전담기관</th>
                                </tr>
                                <tr>
                                    <td>${resultMst.bizNm}</td>
                                    <td>${resultMst.supvOpsNm}</td>
                                    <td>${resultMst.exrsInstNm}</td>
                                </tr>
                            </tbody>
                        </table>
            <br/>
                        <table class="table table_txt_right">
                            <colgroup>
                                <col style="width:20%"/>
                                <col style="width:40%"/>
                                <col style="width:40%"/>
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th rowspan="${fn:length(resultCrro) + 1}">수행기관</th>
                                    <th class="alignC">기관명</th>
                                    <th class="alignC">유형</th>
                                </tr>
            <c:forEach var="resultCrro" items="${resultCrro}">
                                <tr>
                                    <td>${resultCrro.instNm}</td>
                                    <td>${resultCrro.instTypeNM}</td>
                                </tr>
            </c:forEach>   
                            </tbody>
                        </table>
            <div class="titArea"><h3>2. 총 수행기간</h3></div>
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
                                    <td>${resultSmry.ttlCrroStrtDt}</td>
                                    <th>과제종료일</th>
                                    <td>${resultSmry.ttlCrroFnhDt}</td>
                                </tr>
                            </tbody>
                        </table>
            <div class="titArea"><h3>3. 년차별 수행기간</h3></div>
                        <table class="table table_txt_right">
                            <colgroup>
                                <col style="width:20%"/>
                                <col style="width:30%"/>
                                <col style="width:20%"/>
                                <col style="width:30%"/>
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th>1차년도 시작일</th>
                                    <td>${resultSmry.strtDt1}</td>
                                    <th>1차년도 종료일</th>
                                    <td>${resultSmry.fnhDt1}</td>
                                </tr>
                                <tr>
                                    <th>2차년도 시작일</th>
                                    <td>${resultSmry.strtDt2}</td>
                                    <th>2차년도 종료일</th>
                                    <td>${resultSmry.fnhDt2}</td>
                                </tr>
                                <tr>
                                    <th>3차년도 시작일</th>
                                    <td>${resultSmry.strtDt3}</td>
                                    <th>3차년도 종료일</th>
                                    <td>${resultSmry.fnhDt3}</td>
                                </tr>
                                <tr>
                                    <th>4차년도 시작일</th>
                                    <td>${resultSmry.strtDt4}</td>
                                    <th>4차년도 종료일</th>
                                    <td>${resultSmry.fnhDt4}</td>
                                </tr>
                                <tr>
                                    <th>5차년도 시작일</th>
                                    <td>${resultSmry.strtDt5}</td>
                                    <th>5차년도 종료일</th>
                                    <td>${resultSmry.fnhDt5}</td>
                                </tr>
                            </tbody>
                        </table>
            <div class="titArea"><h3>4. 개발대상 기술 및 제품개요</h3></div>
                        <table class="table table_txt_right">
                            <colgroup>
                                <col style="width:*"/>
                            </colgroup>
                            <tbody>
                                <tr>
                                    <td><c:out value="${resultSmry.smryTxt}" escapeXml="false"/></td>
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
                                            <a href="http://iris.lxhausys.com:7030/iris/common/login/irisDirectLogin.do?reUrl=/system/attach/downloadAttachFile.do&attcFilId=${resultAttc.attcFilId}&seq=${resultAttc.seq}">${resultAttc.filNm} (${resultAttc.filSize}byte)</a><br/>
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