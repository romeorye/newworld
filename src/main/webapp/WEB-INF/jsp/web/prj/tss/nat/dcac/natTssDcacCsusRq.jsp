<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*, java.util.*,devonframe.util.NullUtil,devonframe.util.DateUtil"%>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>

<%--
/*
 *************************************************************************
 * $Id      : natTssDcacCsusRq.jsp
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
                
                if(gvTssSt == "100") gvCsusCnt = "1"; //완료작성중단계
                else if(gvTssSt == "500") {
                    if(gvCsusCnt == "1" && gvAprdocState != "") gvAprdocState = "";
                    gvCsusCnt = "2";
                } 
                
                if(stringNullChk(gvAprdocState) == "" || gvAprdocState == "A03" || gvAprdocState == "A04") {
	                var pUrl = "<%=lghausysPath%>/lgchem/approval.front.document.RetrieveDocumentFormCmd.lgc?appCode=APP00339&from=iris&guid="+gvGuid;
	                window.open(pUrl, "_blank", "width=900,height=700,scrollbars=yes");
                }
            } else {
                Rui.alert(data.records[0].rtVal);
            }
        });
        
        
        /* [버튼] 결재품의 */
        var butCsur = new Rui.ui.LButton('butCsur');
        butCsur.on('click', function() {
            Rui.confirm({
                text: '결재품의 하시겠습니까?',
                handlerYes: function() {
                    var row = 0;
                    var record;
        
                    if(dataSet.getCount() <= 0) row = dataSet.newRecord();

                    record = dataSet.getAt(row);
                    
                    //fnCsusContentsCreate("SAVE");
                    
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
                    
                    //중단작성중단계
                    if(gvTssSt == "100") {
                        if(gvCsusCnt == "" || gvCsusCnt == "0") {
                            url = '<c:url value="/prj/tss/gen/insertGenTssCsusRq.do"/>';
                        }
                        else url = '<c:url value="/prj/tss/gen/updateGenTssCsusRq.do"/>';
                    }
                    //정산작성중단계
                    else if(gvTssSt == "500") {
                        if(gvCsusCnt == "1") {
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
        
//         fnCsusContentsCreate();
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
                    <div class="titleArea"><h2>${resultMst.tssNm}</h2></div>
            <br/>
            <div class="titArea alignR">
                        과제리더: ${resultMst.saUserName}, 작성일: ${resultInfo.createDate}
            </div>
            <div class="titArea"><h3>1. 프로젝트 기본사항</h3></div>
                        <table class="table table_txt_right">
                            <colgroup>
                                <col style="width:15%"/>
                                <col style="width:35%"/>
                                <col style="width:15%"/>
                                <col style="width:35%"/>
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th>프로젝트코드</th>
                                    <td>${resultMst.wbsCd}</td>
                                    <th>연구부서명</th>
                                    <td>${resultMst.deptName}</td>
                                </tr>
                                <tr>
                                    <th>연구개발기간</th>
                                    <td>${resultSmry.ttlCrroStrtDt} ~ ${resultSmry.ttlCrroFnhDt}</td>
                                    <th>소요기간</th>
                                    <td>${resultInfo.mMDiff} 개월</td>
                                </tr>
                                <tr>
                                    <th>참여연구원</th>
                                    <td colspan="3">${resultInfo.mbrNmList}</td>
                                </tr>
                            </tbody>
                        </table>
            <div class="titArea"><h3>2. 과제 개요</h3></div>
                        <table class="table table_txt_right">
                            <colgroup>
                                <col style="width:20%"/>
                                <col style="width:*"/>
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th>과제개요</th>
                                    <td><c:out value="${fn:replace(resultSmry.tssSmryTxt, cn, br)}" escapeXml="false"/></td>
                                </tr>
                            </tbody>
                        </table>
            <div class="titArea"><h3>3. 개밸계획 대비 실적 개요</h3></div>
                        <table class="table table_txt_right">
                            <colgroup>
                                <col style="width:20%"/>
                                <col style="width:40%"/>
                                <col style="width:40%"/>
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th class="alignC">항목</th>
                                    <th class="alignC">계획(개발계획시점)</th>
                                    <th class="alignC">실적(개발중단시점)</th>
                                </tr>
                                <tr>
                                    <td>개발기간</td>
                                    <td class="alignC">${resultMst.dcacBStrtDd} ~ ${resultMst.dcacBFnhDd}</td>
                                    <td class="alignC">${resultMst.dcacNxStrtDd} ~ ${resultMst.dcacNxFnhDd}</td>
                                </tr>
                                <tr>
                                    <td>총 개발비 투자</td>
                                    <td class="alignR"><fmt:formatNumber value="${resultInfo.bizAtmSum}" pattern="#,###.##" /></td>
                                    <td class="alignR"><fmt:formatNumber value="${resultSmry.bizExp}" pattern="#,###.##" /></td>
                                </tr>
                            </tbody>
                        </table>
            <div class="titArea"><h3>4. 연구개발 성과</h3></div>
                        <table class="table table_txt_right">
                            <colgroup>
                                <col style="width:20%"/>
                                <col style="width:*"/>
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th>목표 기술성과</th>
                                    <td><c:out value="${fn:replace(resultSmry.rsstDvlpOucmTxt, cn, br)}" escapeXml="false"/></td>
                                </tr>
                            </tbody>
                        </table>
            <div class="titArea"><h3>5. 향후 계획</h3></div>
                        <table class="table table_txt_right">
                            <colgroup>
                                <col style="width:20%"/>
                                <col style="width:*"/>
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th>결론 및 향후 계획</th>
                                    <td><c:out value="${fn:replace(resultSmry.fnoPlnTxt, cn, br)}" escapeXml="false"/></td>
                                </tr>
                            </tbody>
                        </table>
            <c:choose>
                <c:when test="${inputData.pageRqType == 'stoa'}">
                    <div class="titArea"><h3>6. 비고</h3></div>
                        <table class="table table_txt_right">
                            <colgroup>
                                <col style="width:20%"/>
                                <col style="width:*"/>
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th>비고</th>
                                    <td class="txt_layout"><c:out value="${resultStoa.remTxt}" escapeXml="false"/></td>
                                </tr>
                            </tbody>
                        </table>
                    <div class="titArea"><h3>7. 첨부파일</h3></div>
                </c:when>
                <c:otherwise>    
                    <div class="titArea"><h3>6. 첨부파일</h3></div>
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