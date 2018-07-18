<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*, java.util.*,devonframe.util.NullUtil,devonframe.util.DateUtil"%>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %> 

<%--
/*
 *************************************************************************
 * $Id      : natTssPlnCsusRq.jsp
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
    response.setHeader("Pragma", "No-cache");
    response.setDateHeader("Expires", 0);
    response.setHeader("Cache-Control", "no-cache");
    
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
                  { id: 'tssCd'}                //과제코드
                , { id: 'userId'}               //사용자ID
                , { id: 'tssSt'}                //과제상태
                , { id: 'affrGbn'}              //과제구분
                
                , {id: 'guid' }                 //고유코드      
                , {id: 'affrCd' }               //업무코드      
                , {id: 'aprdocstate' }          //결재상태코드    
                , {id: 'approvalUserid' }       //결재 요청자 ID 
                , {id: 'approvalUsername' }     //결재 요청자명   
                , {id: 'approvalJobtitle' }     //결재 요청자 직위 
                , {id: 'approvalDeptname' }     //결재 요청자 부서명
                , {id: 'approvalProcessdate' }  //결재 요청 일자  
                , {id: 'approverProcessdate' }  //승인일자      
                , {id: 'body' }                 //결재 내용     
                , {id: 'title' }                //결재 제목     
                , {id: 'updateDate' }           //수정일       
                , {id: 'url' }                  //결재문서 url  
            ]
        });
        
        
        /* [DataSet] 서버전송용 */
        var dm = new Rui.data.LDataSetManager({defaultFailureHandler: false});
        dm.on('success', function(e) {
            var data = dataSet.getReadData(e);
            
            if(data.records[0].rtCd == "SUCCESS") {
                gvGuid = data.records[0].guid;
                
                if(stringNullChk(gvAprdocState) == "" || gvAprdocState == "A03" || gvAprdocState == "A04") {
	                var pUrl = "<%=lghausysPath%>/lgchem/approval.front.document.RetrieveDocumentFormCmd.lgc?appCode=APP00332&from=iris&guid="+gvGuid;
	                window.open(pUrl, "_blank", "width=900,height=700,scrollbars=yes");
                }
            } else {
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
        	/* 
        	if(stringNullChk(gvAprdocState) != "" && (gvAprdocState != "A03" || gvAprdocState != "A04" )) {
        	//if(stringNullChk(gvAprdocState) != "" && gvAprdocState != "A03") {
                Rui.alert("이미 품의가 요청되었습니다.");
                return;
            }
             */
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
        
        
        /* [버튼] 목록 */
        var btnList = new Rui.ui.LButton('btnList');
        btnList.on('click', function() {                
            nwinsActSubmit(window.document.aform, "<c:url value='/prj/tss/nat/natTssList.do'/>");
        });
         
        
        downloadAttachFile = function(attcFilId, seq) {
            aform.action = "<c:url value='/system/attach/downloadAttachFile.do'/>" + "?attcFilId=" + attcFilId + "&seq=" + seq;
            aform.submit();
        };
        
        if("<c:out value='${inputData._roleId}'/>".indexOf('WORK_IRI_T15') > -1) {
        	$("#butCsur").hide();
    	}else if("<c:out value='${inputData._roleId}'/>".indexOf('WORK_IRI_T16') > -1) {
        	$("#butCsur").hide();
		}
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
            <div class="titArea"><h3>5. 참여연구원</h3></div>
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
                                    <td class="alignC">${resultMbr.ptcStrtDt} ~ ${resultMbr.ptcFnhDt}</td>
                                    <td class="alignC">${resultMbr.ptcRoleNm}</td>
                                </tr>
            </c:forEach>   
                            </tbody>
                        </table>
            <div class="titArea"><h3>6. 년도별 추정예산(단위:천원)</h3></div>
                        <table class="table" style="width:1200px">
                            <colgroup>
                                <col style="width:10%"/>
                                <col style="width:10%"/>
                                <col style="width:*"/>
                                <col style="width:*"/>
                                <col style="width:*"/>
                                <col style="width:*"/>
                                <col style="width:*"/>
                                <col style="width:*"/>
                                <col style="width:*"/>
                                <col style="width:*"/>
                                <col style="width:*"/>
                                <col style="width:*"/>
                                <col style="width:*"/>
                                <col style="width:*"/>
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th colspan="2">기간</th>
                                    <th colspan="2">1차년도</th>
                                    <th colspan="2">2차년도</th>
                                    <th colspan="2">3차년도</th>
                                    <th colspan="2">4차년도</th>
                                    <th colspan="2">5차년도</th>
                                    <th colspan="2">년도별합계</th>
                                </tr>
                                <tr>
                                    <td align="center" rowspan="${fn:length(resultBudg1) + 1}">과제 총 사업비</td>
                                    <td align="right">내역</td>
                                    <td class="alignC">현금</td>
                                    <td class="alignC">현물</td>
                                    <td class="alignC">현금</td>
                                    <td class="alignC">현물</td>
                                    <td class="alignC">현금</td>
                                    <td class="alignC">현물</td>
                                    <td class="alignC">현금</td>
                                    <td class="alignC">현물</td>
                                    <td class="alignC">현금</td>
                                    <td class="alignC">현물</td>
                                    <td class="alignC">현금</td>
                                    <td class="alignC">현물</td>
                                </tr>
            <c:forEach var="resultBudg1" items="${resultBudg1}">
                                <tr>
                                    <td>${resultBudg1.bizExpNm}</td>
                                    <td class="alignR"><fmt:formatNumber value="${resultBudg1.yyNosAthg1}"   pattern="#,###.##" /></td>
                                    <td class="alignR"><fmt:formatNumber value="${resultBudg1.yyNosCash1}"   pattern="#,###.##" /></td>
                                    <td class="alignR"><fmt:formatNumber value="${resultBudg1.yyNosAthg2}"   pattern="#,###.##" /></td>
                                    <td class="alignR"><fmt:formatNumber value="${resultBudg1.yyNosCash2}"   pattern="#,###.##" /></td>
                                    <td class="alignR"><fmt:formatNumber value="${resultBudg1.yyNosAthg3}"   pattern="#,###.##" /></td>
                                    <td class="alignR"><fmt:formatNumber value="${resultBudg1.yyNosCash3}"   pattern="#,###.##" /></td>
                                    <td class="alignR"><fmt:formatNumber value="${resultBudg1.yyNosAthg4}"   pattern="#,###.##" /></td>
                                    <td class="alignR"><fmt:formatNumber value="${resultBudg1.yyNosCash4}"   pattern="#,###.##" /></td>
                                    <td class="alignR"><fmt:formatNumber value="${resultBudg1.yyNosAthg5}"   pattern="#,###.##" /></td>
                                    <td class="alignR"><fmt:formatNumber value="${resultBudg1.yyNosCash5}"   pattern="#,###.##" /></td>
                                    <td class="alignR"><fmt:formatNumber value="${resultBudg1.yyNosAthgSum}" pattern="#,###.##" /></td>
                                    <td class="alignR"><fmt:formatNumber value="${resultBudg1.yyNosCashSum}" pattern="#,###.##" /></td>
                                </tr>
            </c:forEach>   
                            </tbody>
                        </table>
            <div class="titArea"><h3>6. 년도별 추정예산(단위:천원)</h3></div>
                        <table class="table" style="width:1200px">
                            <colgroup>
                                <col style="width:10%"/>
                                <col style="width:10%"/>
                                <col style="width:*"/>
                                <col style="width:*"/>
                                <col style="width:*"/>
                                <col style="width:*"/>
                                <col style="width:*"/>
                                <col style="width:*"/>
                                <col style="width:*"/>
                                <col style="width:*"/>
                                <col style="width:*"/>
                                <col style="width:*"/>
                                <col style="width:*"/>
                                <col style="width:*"/>
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th colspan="2">기간</th>
                                    <th colspan="2">1차년도</th>
                                    <th colspan="2">2차년도</th>
                                    <th colspan="2">3차년도</th>
                                    <th colspan="2">4차년도</th>
                                    <th colspan="2">5차년도</th>
                                    <th colspan="2">년도별합계</th>
                                </tr>
                                <tr>
                                    <td align="center" rowspan="${fn:length(resultBudg2) + 1}">하우시스 사업비</td>
                                    <td align="right">내역</td>
                                    <td class="alignC">현금</td>
                                    <td class="alignC">현물</td>
                                    <td class="alignC">현금</td>
                                    <td class="alignC">현물</td>
                                    <td class="alignC">현금</td>
                                    <td class="alignC">현물</td>
                                    <td class="alignC">현금</td>
                                    <td class="alignC">현물</td>
                                    <td class="alignC">현금</td>
                                    <td class="alignC">현물</td>
                                    <td class="alignC">현금</td>
                                    <td class="alignC">현물</td>
                                </tr>
            <c:forEach var="resultBudg2" items="${resultBudg2}">
                                <tr>
                                    <td>${resultBudg2.bizExpNm}</td>
                                    <td class="alignR"><fmt:formatNumber value="${resultBudg2.yyNosAthg1}"   pattern="#,###.##" /></td>
                                    <td class="alignR"><fmt:formatNumber value="${resultBudg2.yyNosCash1}"   pattern="#,###.##" /></td>
                                    <td class="alignR"><fmt:formatNumber value="${resultBudg2.yyNosAthg2}"   pattern="#,###.##" /></td>
                                    <td class="alignR"><fmt:formatNumber value="${resultBudg2.yyNosCash2}"   pattern="#,###.##" /></td>
                                    <td class="alignR"><fmt:formatNumber value="${resultBudg2.yyNosAthg3}"   pattern="#,###.##" /></td>
                                    <td class="alignR"><fmt:formatNumber value="${resultBudg2.yyNosCash3}"   pattern="#,###.##" /></td>
                                    <td class="alignR"><fmt:formatNumber value="${resultBudg2.yyNosAthg4}"   pattern="#,###.##" /></td>
                                    <td class="alignR"><fmt:formatNumber value="${resultBudg2.yyNosCash4}"   pattern="#,###.##" /></td>
                                    <td class="alignR"><fmt:formatNumber value="${resultBudg2.yyNosAthg5}"   pattern="#,###.##" /></td>
                                    <td class="alignR"><fmt:formatNumber value="${resultBudg2.yyNosCash5}"   pattern="#,###.##" /></td>
                                    <td class="alignR"><fmt:formatNumber value="${resultBudg2.yyNosAthgSum}" pattern="#,###.##" /></td>
                                    <td class="alignR"><fmt:formatNumber value="${resultBudg2.yyNosCashSum}" pattern="#,###.##" /></td>
                                </tr>
            </c:forEach>   
                            </tbody>
                        </table>
            <div class="titArea"><h3>7. 목표기술성과</h3></div>
                        <table class="table">
                            <colgroup>
                                <col style="width:4%"/>
                                <col style="width:29%"/>
                                <col style="width:9%"/>
                                <col style="width:29%"/>
                                <col style="width:29%"/>
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th>년차</th>
                                    <th>평가항목</th>
                                    <th>단위</th>
                                    <th>현재수준</th>
                                    <th>목표수준</th>
                                </tr>
                                <c:choose>
                                    <c:when test="${fn:length(resultGoal) == 0}">
                                        <tr><td align="center" colspan="5"></td></tr>
                                    </c:when>
                                    <c:otherwise>    
                                        <c:forEach var="resultGoal" items="${resultGoal}">
                                            <tr>
                                                <td class="alignC">${resultMst.tssNosSt}</td>
                                                <td valign="top"><c:out value="${fn:replace(fn:replace(fn:replace(fn:replace(resultGoal.prvs, cn, br), n1, b1), n2, b2), n3, b3)}" escapeXml="false"/></td>
                                                <td valign="top"><c:out value="${fn:replace(fn:replace(fn:replace(fn:replace(resultGoal.utm, cn, br), n1, b1), n2, b2), n3, b3)}" escapeXml="false"/></td>
                                                <td valign="top"><c:out value="${fn:replace(fn:replace(fn:replace(fn:replace(resultGoal.cur, cn, br), n1, b1), n2, b2), n3, b3)}" escapeXml="false"/></td>
                                                <td valign="top"><c:out value="${fn:replace(fn:replace(fn:replace(fn:replace(resultGoal.goal, cn, br), n1, b1), n2, b2), n3, b3)}" escapeXml="false"/></td>
                                            </tr>
                                        </c:forEach>
                                    </c:otherwise>
                                </c:choose>
                            </tbody>
                        </table>
            <div class="titArea"><h3>8. 첨부파일</h3></div>
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
                    </td>
                </tr>
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