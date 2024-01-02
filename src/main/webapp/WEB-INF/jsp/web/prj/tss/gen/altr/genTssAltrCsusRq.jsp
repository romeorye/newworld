<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*, java.util.*,devonframe.util.NullUtil,devonframe.util.DateUtil"%>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>

<%--
/*
 *************************************************************************
 * $Id      : genTssAltrCsusRq.jsp
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
	var gvGuid        = "${resultCsus.guid}";
	var gbnCd        = "${inputData.gbnCd}";
	var gvAprdocState = "${resultCsus.aprdocstate}";
    var csusCont = "";

    Rui.onReady(function() {
/* 
    	if (gbnCd == "DL"){
	       	 $("#tbDlView").hide(); 
        }
    	 */
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
                , { id: 'appCode'}              //과제구분

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

                if(stringNullChk(gvAprdocState) == "" || gvAprdocState == "A03") {
	                var pAppCode = data.records[0].appCode;
	                var pUrl = "<%=lghausysPath%>/lgchem/approval.front.document.RetrieveDocumentFormCmd.lgc?appCode="+pAppCode+"&from=iris&guid="+gvGuid;

	                window.open(pUrl, "_blank", "width=900,height=700,scrollbars=yes");
                }
            } else {
                Rui.alert(data.records[0].rtVal);
            }
        });


        /* [버튼] 결재품의 */
        var butCsur = new Rui.ui.LButton('butCsur');
        butCsur.on('click', function() {
        	if(stringNullChk(gvAprdocState) != ""){
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
                    record.set("appCode", "${inputData.appCode}");

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
            nwinsActSubmit(window.document.aform, "<c:url value='/prj/tss/gen/genTssList.do'/>");
        });


        downloadAttachFile = function(attcFilId, seq) {
            aform.action = "<c:url value='/system/attach/downloadAttachFile.do'/>" + "?attcFilId=" + attcFilId + "&seq=" + seq;
            aform.submit();
        };
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
						<p class="txt">아래와 같이, 연구/개발과제의 GRS 심의결과를 보고드리오니, 검토 후 재가 부탁드립니다. </p>
						
						<div class="docu_con">
							<p class="txt2">- 아&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;래 -</p>
							<div class="titArea"><h2>1. 일시 :${resultGrs.evDt}</h2></div>
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
                    <br/>
                        <table class="table">
                            <colgroup>
                                <col style="width:30%"/>
                                <col style="width:35%"/>
                                <col style="width:35%"/>
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th>항목</th>
                                    <th>변경전</th>
                                    <th>변경후</th>
                                </tr>
                                <c:forEach var="resultAltr" items="${resultAltr}">
                                    <tr>
                                        <td><c:out value="${resultAltr.prvs}" escapeXml="false"/></td>
                                        <td><c:out value="${resultAltr.altrPre}" escapeXml="false"/></td>
                                        <td><c:out value="${resultAltr.altrAft}" escapeXml="false"/></td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    <br/>
                    
                    	<table class="table" id="tbDlView">
                    		<colgroup>
                                <col style="width: 20%;" />
								<col style="width: 8%;" />
								<col style="width: 8%;" />
								<col style="width: 8%;" />
								<col style="width: 8%;" />
								<col style="width: 8%;" />
								<col style="width: 8%;" />
								<col style="width: 8%;" />
								<col style="width: 8%;" />
								<col style="width: 8%;" />
								<col style="width: 8%;" />
                            </colgroup>
	                    	<tbody>
	                    		<tr  id="trNprodSalHead">
					  				<th rowspan="2"></th>
					  				<th class="alignC"  colspan="2">출시년도</th>
					  				<th class="alignC"  colspan="2">출시년도+1</th>
					  				<th class="alignC"  colspan="2">출시년도+2</th>
					  				<th class="alignC"  colspan="2">출시년도+3</th>
					  				<th class="alignC"  colspan="2">출시년도+4</th>
					  			</tr>
					  			<tr>
					  				<th class="alignC">변경 前</th>
					  				<th class="alignC">변경 後</th>
					  				<th class="alignC">변경 前</th>
					  				<th class="alignC">변경 後</th>
					  				<th class="alignC">변경 前</th>
					  				<th class="alignC">변경 後</th>
					  				<th class="alignC">변경 前</th>
					  				<th class="alignC">변경 後</th>
					  				<th class="alignC">변경 前</th>
					  				<th class="alignC">변경 後</th>
					  			</tr>
					  			<tr id="trNprodSal">
					  				<th>영업이익율(%)</th>
					  				<td>${resultSmry.bizPrftProYBefore}</td>
					  				<td bgcolor='#E6E6E6'>${resultSmry.bizPrftProY}</td>
					  				<td>${resultSmry.bizPrftProY1Before}</td>
					  				<td bgcolor='#E6E6E6'>${resultSmry.bizPrftProY1}</td>
					  				<td>${resultSmry.bizPrftProY2Before}</td>
					  				<td bgcolor='#E6E6E6'>${resultSmry.bizPrftProY2}</td>
					  				<td></td>
					  				<td></td>
					  				<td></td>
					  				<td></td>
					  			</tr>
					  			<tr id="trNprodSal"  >
					  				<th>매출액(억원)</th>
					  				<td>${resultSmry.nprodSalsPlnYBefore}</td>
					  				<td bgcolor='#E6E6E6'>${resultSmry.nprodSalsPlnY}</td>
					  				<td>${resultSmry.nprodSalsPlnY1Before}</td>
					  				<td bgcolor='#E6E6E6'>${resultSmry.nprodSalsPlnY1}</td>
					  				<td>${resultSmry.nprodSalsPlnY2Before}</td>
					  				<td bgcolor='#E6E6E6'>${resultSmry.nprodSalsPlnY2}</td>
					  				<td></td>
					  				<td></td>
					  				<td></td>
					  				<td></td>
					  			</tr>
					  			<tr id="trbizPrftPln" >
					  				<th>영업이익(억원)</th>
					  				<td>${resultSmry.bizPrftPlnYBefore}</td>
					  				<td bgcolor='#E6E6E6'>${resultSmry.bizPrftPlnY}</td>
					  				<td>${resultSmry.bizPrftPlnY1Before}</td>
					  				<td bgcolor='#E6E6E6'>${resultSmry.bizPrftPlnY1}</td>
					  				<td>${resultSmry.bizPrftPlnY2Before}</td>
					  				<td bgcolor='#E6E6E6'>${resultSmry.bizPrftPlnY2}</td>
					  				<td></td>
					  				<td></td>
					  				<td></td>
					  				<td></td>
					  			</tr>
								<tr id="trPtcCpsnHead" >
					  				<th rowspan="2"></th>
					  				<th class="alignC"  colspan="2">과제시작년도</th>
					  				<th class="alignC"  colspan="2">과제시작년도+1</th>
					  				<th class="alignC"  colspan="2">과제시작년도+2</th>
					  				<th class="alignC"  colspan="2">과제시작년도+3</th>
					  				<th class="alignC"  colspan="2">과제시작년도+4</th>
					  			</tr>
					  			<tr>
					  				<th class="alignC">변경 前</th>
					  				<th class="alignC">변경 後</th>
					  				<th class="alignC">변경 前</th>
					  				<th class="alignC">변경 後</th>
					  				<th class="alignC">변경 前</th>
					  				<th class="alignC">변경 後</th>
					  				<th class="alignC">변경 前</th>
					  				<th class="alignC">변경 後</th>
					  				<th class="alignC">변경 前</th>
					  				<th class="alignC">변경 後</th>
					  			</tr>
					  			<tr id="trPtcCpsn" >
					  				<th>투입인원(명)</th>
					  				<td>${resultSmry.ptcCpsnYBefore}</td>
					  				<td bgcolor='#E6E6E6'>${resultSmry.ptcCpsnY}</td>
					  				<td>${resultSmry.ptcCpsnY1Before}</td>
					  				<td bgcolor='#E6E6E6'>${resultSmry.ptcCpsnY1}</td>
					  				<td>${resultSmry.ptcCpsnY2Before}</td>
					  				<td bgcolor='#E6E6E6'>${resultSmry.ptcCpsnY2}</td>
					  				<td>${resultSmry.ptcCpsnY3Before}</td>
					  				<td bgcolor='#E6E6E6'>${resultSmry.ptcCpsnY3}</td>
					  				<td>${resultSmry.ptcCpsnY4Before}</td>
					  				<td bgcolor='#E6E6E6'>${resultSmry.ptcCpsnY4}</td>
					  			</tr>
					  			<tr id="trExpArsl" >
					  				<th>투입비용(억원)</th>
					  				<td>${resultSmry.expArslYBefore}</td>
					  				<td bgcolor='#E6E6E6'>${resultSmry.expArslY}</td>
					  				<td>${resultSmry.expArslY1Before}</td>
					  				<td bgcolor='#E6E6E6'>${resultSmry.expArslY1}</td>
					  				<td>${resultSmry.expArslY2Before}</td>
					  				<td bgcolor='#E6E6E6'>${resultSmry.expArslY2}</td>
					  				<td>${resultSmry.expArslY3Before}</td>
					  				<td bgcolor='#E6E6E6'>${resultSmry.expArslY3}</td>
					  				<td>${resultSmry.expArslY4Before}</td>
					  				<td bgcolor='#E6E6E6'>${resultSmry.expArslY4}</td>
					  			</tr>
	                    	</tbody>
                    	</table>
                    </br>
                        <table class="table">
                            <colgroup>
                                <col style="width:100%"/>
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th>변경사유</th>
                                </tr>
                                <tr>
                                    <td><c:out value="${fn:replace(resultSmry.altrRsonTxt, cn, br)}" escapeXml="false"/></td>
                                </tr>
                            </tbody>
                        </table>
                    <br/>
                        <table class="table">
                            <colgroup>
                                <col style="width:100%"/>
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th>추가사유</th>
                                </tr>
                                <tr>
                                    <td><c:out value="${fn:replace(resultSmry.addRsonTxt, cn, br)}" escapeXml="false"/></td>
                                </tr>
                            </tbody>
                        </table>
                    <br/>
                        <table class="table">
                            <colgroup>
                                <col style="width:20%"/>
                                <col style="width:80%"/>
                            </colgroup>
                            <tbody>
                                <tr>
                                	<th>첨부파일</th>
                                	<td>
                                    	<c:forEach var="resultAttc" items="${resultAttc}">
                                        	<a href="http://<spring:eval expression='@jspProperties[defaultUrl]'/>:<spring:eval expression='@jspProperties[serverPort]'/>/<spring:eval expression='@jspProperties[contextPath]'/>/common/login/irisDirectLogin.do?reUrl=/system/attach/downloadAttachFile.do&attcFilId=${resultAttc.attcFilId}&seq=${resultAttc.seq}">${resultAttc.filNm} (${resultAttc.filSize}byte)</a><br/>
                                    	</c:forEach>
                                	</td>
                                </tr>
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