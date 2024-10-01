<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*, java.util.*,devonframe.util.NullUtil,devonframe.util.DateUtil"%>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>

<%--
/*
 *************************************************************************
 * $Id      : natTssCmplCsusRq.jsp
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
%>
<script type="text/javascript">
	var gvTssSt       = "${resultMst.tssSt}";
	var gvCsusCnt     = stringNullChk("${resultCsus.csusCnt}");
	var gvGuid        = "${resultCsus.guid}";
	var gvAprdocState = stringNullChk("${resultCsus.aprdocstate}");
    var csusCont = "";

    Rui.onReady(function() {

        /* [DataSet] 설정 */
        var dataSet = new Rui.data.LJsonDataSet({
            id: 'dataSet',
            remainRemoved: true,
            lazyLoad: true,
            fields: [
                  {id: 'tssCd' }                //과제코드
                , {id: 'userId' }               //사용자ID
                , {id: 'tssSt' }                //과제상태
                , {id: 'affrGbn' }              //과제구분
                , {id: 'appCode' }              //결재양식코드
                
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

                var pAppCode = data.records[0].appCode;
                if(gvTssSt == "100") gvCsusCnt = "1"; //완료작성중단계
                else if(gvTssSt == "500") {
                    if(gvCsusCnt == "1" && gvAprdocState != "") gvAprdocState = "";
                    gvCsusCnt = "2";
                } 
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
            if(stringNullChk(gvAprdocState) != "" && gvCsusCnt == "2") {
                Rui.alert("이미 품의가 요청되었습니다.");
                return;
            }

            Rui.confirm({
                text: '결재품의 하시겠습니까?',
                handlerYes: function() {
                    var row = 0;
                    var record;

                    if(dataSet.getCount() <= 0) row = dataSet.newRecord();

                    record = dataSet.getAt(row);

//                     fnCsusContentsCreate("SAVE");

                    record.set("tssCd",   "${inputData.tssCd}");
                    record.set("userId",  "${inputData._userId}");
                    record.set("affrGbn", "T"); //T:과제
                    record.set("appCode",          "${inputData.appCode}");
                    record.set("guid",             gvGuid);
                    record.set("affrCd",           "${inputData.tssCd}");
                    record.set("approvalUserid",   "${inputData._userId}");
                    record.set("approvalUsername", "${inputData._userNm}");
                    record.set("approvalJobtitle", "${inputData._userJobxName}");
                    record.set("approvalDeptname", "${inputData._userDeptName}");
                    record.set("body", Rui.get('csusContents').getHtml().trim());
                    
                    var url = "";
                    //완료작성중단계
                    if(gvTssSt == "100" || gvTssSt == "102") {
                        if(gvCsusCnt == "" || gvCsusCnt == "0") {
                            url = '<c:url value="/prj/tss/gen/insertGenTssCsusRq.do"/>';
                        }
                        else url = '<c:url value="/prj/tss/gen/updateGenTssCsusRq.do"/>';
                    }
                    //정산작성중단계
                    else if(gvTssSt == "500") {
                        if(gvCsusCnt == "" || gvCsusCnt == "1") {
                            url = '<c:url value="/prj/tss/gen/insertGenTssCsusRq.do"/>';
                        }
                        else url = '<c:url value="/prj/tss/gen/updateGenTssCsusRq.do"/>';
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

        fnCsusContentsCreate = function(gbn) { //사용X
            var resultJson = ${resultJson};
            var tssSmryTxt      = stringNullChk(resultJson.jsonSmry.tssSmryTxt)      == "" ? "" : resultJson.jsonSmry.tssSmryTxt.replace(/\n/g, "<p>");            
            var rsstDvlpOucmTxt = stringNullChk(resultJson.jsonSmry.rsstDvlpOucmTxt) == "" ? "" : resultJson.jsonSmry.rsstDvlpOucmTxt.replace(/\n/g, "<p>");          
            var fnoPlnTxt       = stringNullChk(resultJson.jsonSmry.fnoPlnTxt)       == "" ? "" : resultJson.jsonSmry.fnoPlnTxt.replace(/\n/g, "<p>");                  
            
            csusCont = '';
            csusCont += '<div class="titleArea"><h2>${resultMst.tssNm}</h2></div>';
            csusCont += '<br/>';
            csusCont += '<div class="titArea alignR">';
            csusCont += '            과제리더: ${resultMst.saUserName}, 작성일: ${resultInfo.createDate}';
            csusCont += '</div>';
            csusCont += '<div class="titArea"><h3>1. 개요기본 사항</h3></div>';
            csusCont += '            <table class="table table_txt_right">';
            csusCont += '                <colgroup>';
            csusCont += '                    <col style="width:20%"/>';
            csusCont += '                    <col style="width:30%"/>';
            csusCont += '                    <col style="width:20%"/>';
            csusCont += '                    <col style="width:30%"/>';
            csusCont += '                </colgroup>';
            csusCont += '                <tbody>';
            csusCont += '                    <tr>';
            csusCont += '                        <th>과제코드</th>';
            csusCont += '                        <td class="txt_layout">${resultMst.wbsCd}</td>';
            csusCont += '                        <th>프로젝트명</th>';
            csusCont += '                        <td class="txt_layout">${resultMst.prjNm}</td>';
            csusCont += '                    </tr>';
            csusCont += '                    <tr>';
            csusCont += '                        <th>주관부처</th>';
            csusCont += '                        <td class="txt_layout">${resultMst.supvOpsNm}</td>';
            csusCont += '                        <th>전담기관</th>';
            csusCont += '                        <td class="txt_layout">${resultMst.exrsInstNm}</td>';
            csusCont += '                    </tr>';
            csusCont += '                    <tr>';
            csusCont += '                        <th>사업명</th>';
            csusCont += '                        <td class="txt_layout" colspan="3">${resultMst.bizNm}</td>';
            csusCont += '                    </tr>';
            csusCont += '                    <tr>';
            csusCont += '                        <th>총수행기간</th>';
            csusCont += '                        <td class="txt_layout">${resultSmry.ttlCrroStrtDt} ~ ${resultSmry.ttlCrroFnhDt}</td>';
            csusCont += '                        <th>소요기간</th>';
            csusCont += '                        <td class="txt_layout">${resultInfo.mMDiff} 개월</td>';
            csusCont += '                    </tr>';
            csusCont += '                    <tr>';
            csusCont += '                        <th>참여연구원</th>';
            csusCont += '                        <td class="txt_layout" colspan="3">${resultInfo.mbrNmList}</td>';
            csusCont += '                    </tr>';
            csusCont += '                </tbody>';
            csusCont += '            </table>';
            csusCont += '<br/>';
            csusCont += '            <table class="table">';
            csusCont += '                <tr>';
            csusCont += '                    <th colspan="${fn:length(resultBudg) + 2}">비용실적(백만원)</th>';
            csusCont += '                </tr>';
            csusCont += '                <tr>';
            csusCont += '                    <th>연도별</th>';
            csusCont += '                    <th>합계</th>';
            
            <c:forEach var="resultBudg" items="${resultBudg}">
            csusCont += '                    <th>${resultBudg.yy}</th>';
            </c:forEach>
            
            csusCont += '                </tr>';
            csusCont += '                <tr>';
            csusCont += '                    <td align="center">총투자비용</td>';
            <c:forEach var="resultBudg" items="${resultBudg}" varStatus="status">
                <c:if test="${status.index eq 0}">
            csusCont += '                    <td class="alignR" align="right">${resultBudg.yyNosSum}</td>';
                </c:if>
            csusCont += '                    <td class="alignR" align="right">${resultBudg.yyNos}</td>';
            </c:forEach>
            
            <c:if test="${fn:length(resultBudg) eq 0}">
            csusCont += '                    <td></td>';
            </c:if>
            
            csusCont += '                </tr>';
            csusCont += '            </table>';
            csusCont += '<div class="titArea"><h3>2. 과제 개요</h3></div>';
            csusCont += '            <table class="table table_txt_right">';
            csusCont += '                <colgroup>';
            csusCont += '                    <col style="width:20%"/>';
            csusCont += '                    <col style="width:*"/>';
            csusCont += '                </colgroup>';
            csusCont += '                <tbody>';
            csusCont += '                    <tr>';
            csusCont += '                        <th>개발 대상 기술,<br/>제품 개요 및 주요 개발 내용</th>';
            csusCont += '                        <td class="txt_layout">'+tssSmryTxt+'</td>';
            csusCont += '                    </tr>';
            csusCont += '                </tbody>';
            csusCont += '            </table>';
            csusCont += '<div class="titArea"><h3>3. 연구개발 성과</h3></div>';
            csusCont += '            <table class="table table_txt_right">';
            csusCont += '                <colgroup>';
            csusCont += '                    <col style="width:20%"/>';
            csusCont += '                    <col style="width:*"/>';
            csusCont += '                </colgroup>';
            csusCont += '                <tbody>';
            csusCont += '                    <tr>';
            csusCont += '                        <th>목표 기술성과</th>';
            csusCont += '                        <td class="txt_layout">'+rsstDvlpOucmTxt+'</td>';
            csusCont += '                    </tr>';
            csusCont += '                </tbody>';
            csusCont += '            </table>';
            csusCont += '<div class="titArea"><h3>4. 향후 계획</h3></div>';
            csusCont += '            <table class="table table_txt_right">';
            csusCont += '                <colgroup>';
            csusCont += '                    <col style="width:20%"/>';
            csusCont += '                    <col style="width:*"/>';
            csusCont += '                </colgroup>';
            csusCont += '                <tbody>';
            csusCont += '                    <tr>';
            csusCont += '                        <th>결론 및 향후 계획</th>';
            csusCont += '                        <td class="txt_layout">'+fnoPlnTxt+'</td>';
            csusCont += '                    </tr>';
            csusCont += '                </tbody>';
            csusCont += '            </table>';
            
            if("${inputData.pageRqType}" == "stoa") {
                var remTxt = stringNullChk(resultJson.jsonStoa.remTxt) == "" ? "" : resultJson.jsonStoa.remTxt.replace(/\n/g, "<br/>"); 
            csusCont += '<div class="titArea"><h3>5. 비고</h3></div>';
            csusCont += '            <table class="table table_txt_right">';
            csusCont += '                <colgroup>';
            csusCont += '                    <col style="width:20%"/>';
            csusCont += '                    <col style="width:*"/>';
            csusCont += '                </colgroup>';
            csusCont += '                <tbody>';
            csusCont += '                    <tr>';
            csusCont += '                        <th>비고</th>';
            csusCont += '                        <td class="txt_layout">'+remTxt+'</td>';
            csusCont += '                    </tr>';
            csusCont += '                </tbody>';
            csusCont += '            </table>';
            csusCont += '<div class="titArea"><h3>6. 첨부파일</h3></div>';
            } 
            else {
            csusCont += '<div class="titArea"><h3>5. 첨부파일</h3></div>';
            }
            csusCont += '            <table class="table table_txt_right">';
            csusCont += '                <colgroup>';
            csusCont += '                    <col style="width:100%"/>';
            csusCont += '                </colgroup>';
            csusCont += '                <tbody>';
            csusCont += '                    <tr><td>';

            <c:forEach var="resultAttc" items="${resultAttc}">
            if(gbn == "SAVE") {
                var url = "<c:url value='/system/attach/downloadAttachFile.do'/>"+"?attcFilId=${resultAttc.attcFilId}&seq=${resultAttc.seq}";
                csusCont += '            <a href='+url+'>${resultAttc.filNm} (${resultAttc.filSize}byte)</a><br/>';
            } else {
                csusCont += '            <a href="javascript:downloadAttachFile(${resultAttc.attcFilId}, ${resultAttc.seq})">${resultAttc.filNm} (${resultAttc.filSize}byte)</a><br/>';
            }
            </c:forEach>
            csusCont += '                    </td></tr>';
            csusCont += '                </tbody>';
            csusCont += '            </table>';
            
            if(gbn != "SAVE") {
                document.getElementById("csusContents").innerHTML = csusCont;
            }
        }
        
//         fnCsusContentsCreate();

    });
</script>
</head>
<body>
    <Tag:saymessage />
    <%--<!--  sayMessage 사용시 필요 -->--%>
    <div class="contents">
            <form name="aform" id="aform" method="post">
                <div id="csusContents">
            <div class="titleArea"><h2>${resultMst.tssNm}</h2></div>
            <br/>
            <div class="titArea alignR">
                        과제리더: ${resultMst.saUserName}, 작성일: ${resultInfo.createDate}
            </div>
            <div class="titArea"><h3>1. 개요기본 사항</h3></div>
                        <table class="table table_txt_right">
                            <colgroup>
                                <col style="width:15%"/>
                                <col style="width:35%"/>
                                <col style="width:15%"/>
                                <col style="width:35%"/>
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th>과제코드</th>
                                    <td class="txt_layout">${resultMst.wbsCd}</td>
                                    <th>프로젝트명</th>
                                    <td class="txt_layout">${resultMst.prjNm}</td>
                                </tr>
                                <tr>
                                    <th>주관부처</th>
                                    <td class="txt_layout">${resultMst.supvOpsNm}</td>
                                    <th>전담기관</th>
                                    <td class="txt_layout">${resultMst.exrsInstNm}</td>
                                </tr>
                                <tr>
                                    <th>사업명</th>
                                    <td class="txt_layout" colspan="3">${resultMst.bizNm}</td>
                                </tr>
                                <tr>
                                    <th>총수행기간</th>
                                    <td class="txt_layout">${resultSmry.ttlCrroStrtDt} ~ ${resultSmry.ttlCrroFnhDt}</td>
                                    <th>소요기간</th>
                                    <td class="txt_layout">${resultInfo.mMDiff} 개월</td>
                                </tr>
                                <tr>
                                    <th>참여연구원</th>
                                    <td class="txt_layout" colspan="3">${resultInfo.mbrNmList}</td>
                                </tr>
                            </tbody>
                        </table>
            <br/>
                        <table class="table">
                            <tr>
                                <th colspan="${fn:length(resultBudg) + 2}">비용실적(백만원)</th>
                            </tr>
                            <tr>
                                <th>연도별</th>
                                <th>합계</th>
            
            <c:forEach var="resultBudg" items="${resultBudg}">
                                <th>${resultBudg.yy}</th>
            </c:forEach>
            
                            </tr>
                            <tr>
                                <td align="center">총투자비용</td>
            <c:forEach var="resultBudg" items="${resultBudg}" varStatus="status">
                <c:if test="${status.index eq 0}">
                                <td class="alignR" align="right"><fmt:formatNumber value="${resultBudg.yyNosSum}" pattern="#,###.##" /></td>
                </c:if>
                                <td class="alignR" align="right"><fmt:formatNumber value="${resultBudg.yyNos}" pattern="#,###.##" /></td>
            </c:forEach>
            
            <c:if test="${fn:length(resultBudg) eq 0}">
                                <td></td>
            </c:if>
            
                            </tr>
                        </table>
            <div class="titArea"><h3>2. 과제 개요</h3></div>
                        <table class="table table_txt_right">
                            <colgroup>
                                <col style="width:20%"/>
                                <col style="width:*"/>
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th>개발 대상 기술,<br/>제품 개요 및 주요 개발 내용</th>
                                    <td class="txt_layout"><c:out value="${fn:replace(resultSmry.tssSmryTxt, cn, br)}" escapeXml="false"/></td>
                                </tr>
                            </tbody>
                        </table>
            <div class="titArea"><h3>3. 연구개발 성과</h3></div>
                        <table class="table table_txt_right">
                            <colgroup>
                                <col style="width:20%"/>
                                <col style="width:*"/>
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th>목표 기술성과</th>
                                    <td class="txt_layout"><c:out value="${fn:replace(resultSmry.rsstDvlpOucmTxt, cn, br)}" escapeXml="false"/></td>
                                </tr>
                            </tbody>
                        </table>
            <div class="titArea"><h3>4. 향후 계획</h3></div>
                        <table class="table table_txt_right">
                            <colgroup>
                                <col style="width:20%"/>
                                <col style="width:*"/>
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th>결론 및 향후 계획</th>
                                    <td class="txt_layout"><c:out value="${fn:replace(resultSmry.fnoPlnTxt, cn, br)}" escapeXml="false"/></td>
                                </tr>
                            </tbody>
                        </table>
            <c:choose>
                <c:when test="${inputData.pageRqType == 'stoa'}">
                    <div class="titArea"><h3>5. 정산내역</h3></div>
                        <table class="table table_txt_right">
                            <colgroup>
                                <col style="width:20%"/>
                                <col style="width:*"/>
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th>정산내역</th>
                                    <td class="txt_layout"><c:out value="${resultStoa.remTxt}" escapeXml="false"/></td>
                                </tr>
                            </tbody>
                        </table>
                    <div class="titArea"><h3>6. 첨부파일</h3></div>
                </c:when>
                <c:otherwise>    
                    <div class="titArea"><h3>5. 첨부파일</h3></div>
                </c:otherwise>
            </c:choose>
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

        <div class="sub-content">
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