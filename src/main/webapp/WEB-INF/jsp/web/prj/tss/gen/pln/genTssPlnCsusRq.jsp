<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*, java.util.*,devonframe.util.NullUtil,devonframe.util.DateUtil"%>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>

<%--
/*
 *************************************************************************
 * $Id      : genTssPlnCsusRq.jsp
 * @desc    : 
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

<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/grid/LEditButtonColumn.js"></script>
<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/grid/LGridView.js"></script>
<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/grid/LGridPanelExt.js"></script>
<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/grid/LTotalSummary.js"></script>
<link rel="stylesheet" type="text/css" href="<%=ruiPathPlugins%>/ui/grid/LTotalSummary.css"/>

<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/grid/LGridStatusBar.js"></script>
<link rel="stylesheet" type="text/css" href="<%=ruiPathPlugins%>/ui/grid/LGridStatusBar.css"/>

<%
    //치환 변수 선언
    pageContext.setAttribute("cn", "\n");    //Enter
    pageContext.setAttribute("br", "<br/>"); //br 태그

    pageContext.setAttribute("n1", "&#8226;");
    pageContext.setAttribute("b1", "•");

    pageContext.setAttribute("n2", "&#9656;");
    pageContext.setAttribute("b2", "▸");

    pageContext.setAttribute("n3", "&#8228;");
    pageContext.setAttribute("b3", "․");

%>
<script type="text/javascript">
    var gvGuid        = "${resultCsus.guid}";
    var gvAprdocState = "${resultCsus.aprdocstate}";
    var csusCont = "";

    Rui.onReady(function() {

        /* [DataSet] 설정 */
        var dataSet = new Rui.data.LJsonDataSet({
            id: 'dataSet',
            remainRemoved: true,
            lazyLoad: true,
            fields: [
                  { id: 'tssCd'}        //과제코드
                , { id: 'userId'}       //사용자ID
                , { id: 'tssSt'}        //과제상태
                , { id: 'affrGbn'}      //과제구분
                
                , {id: 'guid' }         //고유코드      
                , {id: 'affrCd' }       //업무코드      
                , {id: 'aprdocstate' }  //결재상태코드    
                , {id: 'approvalUserid' }//결재 요청자 ID 
                , {id: 'approvalUsername' }//결재 요청자명   
                , {id: 'approvalJobtitle' }//결재 요청자 직위 
                , {id: 'approvalDeptname' }//결재 요청자 부서명
                , {id: 'approvalProcessdate' }//결재 요청 일자  
                , {id: 'approverProcessdate' }//승인일자      
                , {id: 'body' }         //결재 내용     
                , {id: 'title' }        //결재 제목     
                , {id: 'updateDate' }   //수정일       
                , {id: 'url' }          //결재문서 url  
                , { id: 'pmisTxt' }       //지적재산권 통보
            ]
        });
        
        
        /* [DataSet] 서버전송용 */
        var dm = new Rui.data.LDataSetManager({defaultFailureHandler: false});
        dm.on('success', function(e) {
            var data = dataSet.getReadData(e);
            
            if(data.records[0].rtCd == "SUCCESS") {
                gvGuid = data.records[0].guid;
                
                if(stringNullChk(gvAprdocState) == "" || gvAprdocState == "A03") {
                    var pUrl = "<%=lghausysPath%>/lgchem/approval.front.document.RetrieveDocumentFormCmd.lgc?appCode=APP00332&from=iris&guid="+gvGuid;
                    window.open(pUrl, "_blank", "width=900,height=700,scrollbars=yes");
                }
            }else {
                Rui.alert(data.records[0].rtVal);
            }
        });
        
        
        /* [버튼] 결재품의 */
        var butCsur = new Rui.ui.LButton('butCsur');
        butCsur.on('click', function() {
            if(stringNullChk(gvAprdocState) != "" ){
             	if (gvAprdocState == "A01" || gvAprdocState == "A02" ) {
                	Rui.alert("이미 품의가 요청되었습니다.");
                	return;
        		} 
            }
            
            Rui.confirm({
                text: '결재품의 하시겠습니까?',
                handlerYes: function() {
                    var row = 0;
                    var record;
        
                    if(dataSet.getCount() <= 0) row = dataSet.newRecord();

                    record = dataSet.getAt(row);
                    
                    record.set("tssCd",   "${inputData.tssCd}");
                    record.set("userId",  "${inputData._userId}");
                    record.set("affrGbn", "T"); //T:과제
                    
                    record.set("guid",             gvGuid);
                    record.set("affrCd",           "${inputData.tssCd}");
                    record.set("approvalUserid",   "${inputData._userId}");
                    record.set("approvalUsername", "${inputData._userNm}");
                    record.set("approvalJobtitle", "${inputData._userJobxName}");
                    record.set("approvalDeptname", "${inputData._userDeptName}");
                    record.set("body", Rui.get('csusContents').getHtml().trim());
                    
                    var url = "";
                    
                    if(gvGuid == ""){
                    	url = '<c:url value="/prj/tss/gen/insertGenTssCsusRq.do"/>';
                    }else{
                    	if(gvAprdocState == "A03" || gvAprdocState == "A04" ){
                    		url = '<c:url value="/prj/tss/gen/insertGenTssCsusRq.do"/>';
                    	}else{
		                    url = '<c:url value="/prj/tss/gen/updateGenTssCsusRq.do"/>';
                    	}
                    }
                    
                    dm.updateDataSet({
                        modifiedOnly: false,
                        url: url,
                        dataSets:[dataSet]
                    });
                },
                handlerNo: Rui.emptyFn
            });
        });
        
        
        /* [버튼] 인쇄 */
        var btnPrint = new Rui.ui.LButton('btnPrint');
        btnPrint.on('click', function() {
            print();
        });
        
        if("<c:out value='${inputData._roleId}'/>".indexOf('WORK_IRI_T15') > -1) {
        	$("#butCsur").hide();
    	}else if("<c:out value='${inputData._roleId}'/>".indexOf('WORK_IRI_T16') > -1) {
        	$("#butCsur").hide();
		}
        /* [버튼] 목록 */
        var btnList = new Rui.ui.LButton('btnList');
        btnList.on('click', function() {                
            nwinsActSubmit(window.document.aform, "<c:url value='/prj/tss/gen/genTssList.do'/>");
        });
        
//         fnCsusContentsCreate();
    });
</script>
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
                    <div class="titArea"><h3>4. 참여연구원</h3></div>
                        <table class="table">
                            <colgroup>
                                <col style="width:20%"/>
                                <col style="width:40%"/>
                                <col style="width:40%"/>
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th>연구원</th>
                                    <th>참여기간</th>
                                    <th>참여역할</th>
                                </tr>
                                <c:forEach var="resultMbr" items="${resultMbr}">
                                <tr>
                                    <td class="alignC">${resultMbr.saUserName}</td>
                                    <td class="alignC">${resultMbr.ptcStrtDt}~ ${resultMbr.ptcFnhDt}</td>
                                    <td>${resultMbr.ptcRoleNm}</td>
                                </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    <div class="titArea"><h3>5. 기대성과<span class="h3_stitle">(영업이익률, 상품출시(계획), 신제품 매출계획)</span></h3></div>
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
                    <div class="titArea"><h3>6.전체 추정 예산<span class="h3_stitle">(단위: 백만원)</span></h3></div>
                        <table class="table table_txt_right">
                            <colgroup>
                                <col style="width:20%"/>
                                <col style="width:30%"/>
                                <col style="width:20%"/>
                                <col style="width:30%"/>
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th>합계</th>
                                    <td colspan="3" class="alignR"><fmt:formatNumber value="${resultSmry.total}" pattern="#,###.##" /></td>
                                </tr>
                                <tr>
                                    <th>인건비</th>
                                    <td class="alignR"><fmt:formatNumber value="${resultSmry.ingun}" pattern="#,###.##" /></td>
                                    <th>감가상각비</th>
                                    <td class="alignR""><fmt:formatNumber value="${resultSmry.gamgaDev}" pattern="#,###.##" /></td>
                                </tr>
                                <tr>
                                    <th>운영경비</th>
                                    <td class="alignR"><fmt:formatNumber value="${resultSmry.ounYoung}" pattern="#,###.##" /></td>
                                    <th>경상개발비</th>
                                    <td class="alignR"><fmt:formatNumber value="${resultSmry.kungDev}" pattern="#,###.##" /></td>
                                </tr>
                            </tbody>
                        </table>
                    <div class="titArea"><h3>7. 년도별추정예산<span class="h3_stitle">(단위: 백만원)</span></h3></div>
                        <table class="table">
                            <tr>
                                <th>&nbsp;</th>
                                <th>합계</th>
                                <c:forEach var="resultTssYy" items="${resultTssYy}">
                                    <th>${resultTssYy.tssYy}</th>
                                </c:forEach>
                            </tr>
                            <c:forEach var="resultBudg" items="${resultBudg}">
                                <tr>
                                    <td align="left">${resultBudg.expScnNm}</td>
                                    <td class="alignR"><fmt:formatNumber value="${resultBudg.totSum}" pattern="#,###.##" /></td>
                                    <c:forEach var="resultTssYy" items="${resultTssYy}">
                                       <td class="alignR"><fmt:formatNumber value="${resultBudg[resultTssYy.tssYy]}" pattern="#,###.##" /></td>    
                                    </c:forEach>
                                </tr>
                            </c:forEach>
                        </table>
                    <div class="titArea"><h3>8.목표기술성과</h3></div>
                        <table class="table">
                            <colgroup>
                                <col style="width:34%"/>
                                <col style="width:33%"/>
                                <col style="width:33%"/>
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th>주요항목</th>
                                    <th>현재수준</th>
                                    <th>목표수준</th>
                                </tr>
                                <c:choose>
                                    <c:when test="${fn:length(resultGoal) == 0}">
                                        <tr><td align="center" colspan="3"></td></tr>
                                    </c:when>
                                    <c:otherwise>    
                                        <c:forEach var="resultGoal" items="${resultGoal}">
                                            <tr>
                                          		<td valign="top"><c:out value="${fn:replace(fn:replace(fn:replace(fn:replace(resultGoal.prvs, cn, br), n1, b1), n2, b2), n3, b3)}" escapeXml="false"/></td>
                                                <td valign="top"><c:out value="${fn:replace(fn:replace(fn:replace(fn:replace(resultGoal.cur, cn, br), n1, b1), n2, b2), n3, b3)}" escapeXml="false"/></td>
                                                <td valign="top"><c:out value="${fn:replace(fn:replace(fn:replace(fn:replace(resultGoal.goal, cn, br), n1, b1), n2, b2), n3, b3)}" escapeXml="false"/></td>
                                            </tr>
                                        </c:forEach>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
                    <div class="titArea"><h3>9. 지적재산팀 검토의견</h3></div>
                        <table class="table">
                        	<tbody>
                        		<tr>
									<td><c:out value="${resultSmry.pmisTxt}" escapeXml="false"/></td>                       		
                        		</tr>
                        	</tbody>
                        </table>        
                    <div class="titArea"><h3>10. 첨부파일</h3></div>
                        <table class="table table_txt_right">
                            <colgroup>
                                <col style="width:100%"/>
                            </colgroup>
                            <tbody>
                                <tr><td>
                                    <c:forEach var="resultAttc" items="${resultAttc}">
                                        <a href="http://<spring:eval expression='@jspProperties[defaultUrl]'/>:<spring:eval expression='@jspProperties[serverPort]'/>/<spring:eval expression='@jspProperties[contextPath]'/>/common/login/irisDirectLogin.do?reUrl=/system/attach/downloadAttachFile.do&attcFilId=${resultAttc.attcFilId}&seq=${resultAttc.seq}">${resultAttc.filNm} (${resultAttc.filSize}byte)</a><br/>
                                    </c:forEach> 
                                </td></tr>
                            </tbody>
                        </table>
                </div>
            </form>
            <div class="titArea">
                <div class="LblockButton">
                    <button type="button" id="butCsur" name="butCsur">결재품의</button>
                    <button type="button" id="btnPrint" name="btnPrint">인쇄</button>
                    <button type="button" id="btnList" name="btnList">목록</button>
                </div>
            </div>
        </div>
    </div>
</body>
</html>