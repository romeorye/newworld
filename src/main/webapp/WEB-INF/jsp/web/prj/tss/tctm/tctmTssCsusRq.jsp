<%@ page import="iris.web.prj.tss.tctm.TctmUrl" %>
<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>

<%--
/*
 *************************************************************************
 * $Id      : tctmTssCsusRq.jsp
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
    var gvItgRdcsId   = "${resultCsus.itgRdcsId}";
    var appCode       = "APP00332";
    var csusCont      = "";
    var dm

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
            ]
        });
        
        
        /* [DataSet] 서버전송용 */
        dm = new Rui.data.LDataSetManager({defaultFailureHandler: false});
        dm.on('success', function(e) {
            var data = dataSet.getReadData(e);
            
            if(data.records[0].rtCd == "SUCCESS") {
                gvGuid = data.records[0].guid;
                
                if(stringNullChk(gvAprdocState) == "" || gvAprdocState == "A03") {
                    var pUrl = "<%=lghausysPath%>/lgchem/approval.front.document.RetrieveDocumentFormCmd.lgc?appCode="+ appCode +"&from=iris&guid="+gvGuid;
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
                //[20240830.siseo] 품의 체크로직 - 수정
                //if (gvAprdocState == "A01" || gvAprdocState == "A02" ) {    //결제요청, 최종승인완료
                if ( (gvAprdocState == "A01" && stringNullChk(gvItgRdcsId) != "") || gvAprdocState == "A02" ) {    //결제요청(&GUID!=""), 최종승인완료
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
                    record.set("appCode",          appCode);
                    
                    var url = "";
                    
                    if(gvGuid == ""){
                    	url = '<c:url value="/prj/tss/gen/insertGenTssCsusRq.do"/>';
                    }else{
                    	if(gvAprdocState == "A03" || gvAprdocState == "A04" ){  //반려, 취소
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
            location.href = "<%=request.getContextPath()+TctmUrl.doList%>";
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
                
                    <div class="docu_box">
                        <p class="txt"><font color="white">(6)</font>아래와 같이, 연구/개발과제의 GRS 심의결과를 보고드리오니, 검토 후 재가 부탁드립니다.</p>

                        <div class="docu_con">
                            <p class="txt2">- 아&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;래 -</p>
                            <div class="titArea"><h2>1. 일시 : ${resultGrs.evDt}</h2></div>
                            <div class="titArea"><h2>2. 장소 : ${resultGrs.evTitl}</h2></div>
                            <div class="titArea"><h2>3. 참석자 : ${resultGrs.cfrnAtdtCdTxtNm}</h2></div>
                            <div class="titArea"><h2>4. Agenda 및 심의결과</h2></div>
                            <table class="table">
                                <colgroup>
                                    <col style="width:6%;">
                                    <col style="width:26%;">
                                    <col style="width:;">
                                    <col style="width:9%;">
                                    <col style="width:6%;">
                                    <col style="width:6%;">
                                    <col style="width:6%;">
                                </colgroup>
                                <thead>
                                    <tr>
                                        <th rowspan="2">심의<br>단계</th>
                                        <th rowspan="2">PJT</th>
                                        <th rowspan="2">과제명</th>
                                        <th rowspan="2">과제<br>책임자</th>
                                        <th rowspan="2">개발<br>유형</th>
                                        <th colspan="2">심의결과</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td>${resultGrs.grsEvStNm}</td>
                                        <td>${resultGrs.prjNm}</td>
                                        <td>${resultGrs.tssNm}</td>
                                        <td>${resultGrs.saSabunName}</td>
                                        <td>${resultGrs.tssTypeNm}</td>
                                        <td colspan="2">${resultGrs.dropYn}</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                    
                    <div class="titArea"><h3>5. 개요</h3></div>
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
                                    <td>${resultMst.saSabunName}</td>
                                </tr>
                            </tbody>
                        </table>
                    <div class="titArea"><h3>6. 개발기간</h3></div>
                        <table class="table table_txt_right">
                            <colgroup>
                                <col style="width:15%"/>
                                <col style="width:35%"/>
                                <col style="width:15%"/>
                                <col style="width:35%"/>
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
                    <div class="titArea"><h3>7. 주요 concept</h3></div>
                        <table class="table">
                            <colgroup>
                                <col style="width:100%"/>
                            </colgroup>
                            <tbody class="table_concept">
                                <tr>
                                    <td>1. Summary 개요</td>
                                </tr>
                                <tr>
                                	<td valign="top"><c:out value="${fn:replace(fn:replace(fn:replace(fn:replace(resultSmry.smrSmryTxt, cn, br), n1, b1), n2, b2), n3, b3)}" escapeXml="false"/></td>
                                </tr>
                                <tr>
                                    <td>2. Summary 목표</td>
                                </tr>
                                <tr>
                                	<td valign="top"><c:out value="${fn:replace(fn:replace(fn:replace(fn:replace(resultSmry.smrGoalTxt, cn, br), n1, b1), n2, b2), n3, b3)}" escapeXml="false"/></td>
                                </tr>

                            </tbody>
                        </table>

                    <div class="titArea"><h3>8. 기대성과<span class="h3_stitle">(상품출시(계획), 신제품 매출계획)</span></h3></div>
                        <table class="table">
                            <colgroup>
                                <col style="width:15%"/>
                                <col style="width:35%"/>
                                <col style="width:15%"/>
                                <col style="width:35%"/>
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th>상품출시(계획)</th>
                                    <td>${resultSmry.ctyOtPlnM}</td>
                                    <th>신제품 매출계획(단위:억원)</th>
                                    <td>
                                        <fmt:parseNumber var="nprodSalsPlnYSub" value="${100000000}" pattern="#.##" />
                                        <fmt:parseNumber var="nprodSalsPlnYCnt" value="${0}" pattern="#.##" />
                                        <fmt:parseNumber var="nprodSalsPlnY" value="${resultSmry.nprodSalsPlnY}" pattern="#.##" />
                                        <fmt:formatNumber value="${nprodSalsPlnY/nprodSalsPlnYSub}" pattern="#,###.##"/>
                                    </td>
                                </tr>


                            </tbody>    
                        </table>


                    <div class="titArea"><h3>9. 첨부파일</h3></div>
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