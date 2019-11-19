<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>

<%--
/*
 *************************************************************************
 * $Id      : mkInnoTssPlnCsusRq.jsp
 * @desc    :
 *------------------------------------------------------------------------
 * VER  DATE        AUTHOR      DESCRIPTION
 * ---  ----------- ----------  -----------------------------------------
 * 1.0  2019.10.14  IRIS005      신규생성
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

var guid        = "${resultCsus.guid}";
var aprdocState = "${resultCsus.aprdocstate}";  


	Rui.onReady(function(){
    	/* [DataSet] 설정 */
        var dataSet = new Rui.data.LJsonDataSet({
            id: 'dataSet',
            remainRemoved: true,
            lazyLoad: true,
            fields: [
                  {id: 'tssCd'}        //과제코드
                , {id: 'userId'}       //사용자ID
                , {id: 'tssSt'}        //과제상태
                , {id: 'affrGbn'}      //과제구분
                , {id: 'guid'}         //고유코드      
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
                , {id: 'pmisTxt' }       //지적재산권 통보
            ]
        });
        
        /* [DataSet] 서버전송용 */
        var dm = new Rui.data.LDataSetManager({defaultFailureHandler: false});
        dm.on('success', function(e) {
            var data = dataSet.getReadData(e);
            
            if(data.records[0].rtCd == "SUCCESS") {
                gvGuid = data.records[0].guid;
                var pUrl = "<%=lghausysPath%>/lgchem/approval.front.document.RetrieveDocumentFormCmd.lgc?appCode=APP00332&from=iris&guid="+gvGuid;
                window.open(pUrl, "_blank", "width=900,height=700,scrollbars=yes");
            }else {
                Rui.alert(data.records[0].rtVal);
            }
        });
        
        fncSaveCsus = function(){
        	if( !Rui.isEmpty(aprdocState) ){
        		if( aprdocState == "A01" || aprdocState == "A02" ){
            		Rui.alert("이미 품의가 요청되었습니다.");
                	return;
            	}
        	}else{
        		if(confirm('결재요청 하시겠습니까?')) {
        			var row = 0;
    				var record;
            		
    				if(dataSet.getCount() <= 0) row = dataSet.newRecord();
    	       	 	
    				record = dataSet.getAt(row);
    				
    				record.set("tssCd",   "${inputData.tssCd}");
    	            record.set("userId",  "${inputData._userId}");
    	            record.set("affrGbn", "T"); //T:과제
    	            record.set("guid",             guid);
    	            record.set("affrCd",           "${inputData.tssCd}");
    	            record.set("approvalUserid",   "${inputData._userId}");
    	            record.set("approvalUsername", "${inputData._userNm}");
    	            record.set("approvalJobtitle", "${inputData._userJobxName}");
    	            record.set("approvalDeptname", "${inputData._userDeptName}");
    	            record.set("body", Rui.get('csusContents').getHtml().trim());
            	
    	            var url = "";
    	            
    	            if( Rui.isEmpty(guid) == "" || guid ==""){
    	            	url = '<c:url value="/prj/tss/mkInno/insertMkInnoTssCsusRq.do"/>';
    	            }else{
    	            	if(aprdocState == "A03" || aprdocState == "A04"){
    	            		url = '<c:url value="/prj/tss/mkInno/insertMkInnoTssCsusRq.do"/>';
    	            	}else{
    	            		url = '<c:url value="/prj/tss/mkInno/updateMkInnoTssCsusRq.do"/>';
    	            	} 
    	            }
    	            
    	            dm.updateDataSet({
                        modifiedOnly: false,
                        url: url,
                        dataSets:[dataSet]
                    });
        		}
        	}
        }
        
        
        fncList = function(){
	        nwinsActSubmit(window.document.aform, "<c:url value='/prj/tss/mkInno/mkInnoTssList.do'/>");
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
                                <col style="width:20%;"/>
                                <col style="width:30%;"/>
                                <col style="width:20%;"/>
                                <col style="width:30%;"/>
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th>프로젝트명</th>
                                    <td>${resultMst.prjNm}</td>
                                    <th>조직</th>
                                    <td>${resultMst.deptName}</td>
                                </tr>
                                <tr>
                                    <th>사업부문(Funding기준)</th>
                                    <td>${resultMst.bizDptNm}</td>
                                    <th>과제리더</th>
                                    <td>${resultMst.saUserName}</td>
                                </tr>
                                <tr>
                                    <th>과제명</th>
                                    <td colspan="3">${resultMst.tssNm}</td>
                                </tr>
                            </tbody>
                        </table>
                    <div class="titArea"><h3>2. 개발기간</h3></div>
                        <table class="table table_txt_right">
                            <colgroup>
                                <col style="width:20%;"/>
                                <col style="width:30%;"/>
                                <col style="width:20%;"/>
                                <col style="width:30%;"/>
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
                                <col style="width:100%;"/>
                            </colgroup>
                            <tbody class="table_concept">
                                <tr>
                                    <td>개발목표</td>
                                </tr>
                                <tr>
                                	<td valign="top"><c:out value="${fn:replace(fn:replace(fn:replace(fn:replace(resultSmry.dvlpGoalTxt, cn, br), n1, b1), n2, b2), n3, b3)}" escapeXml="false"/></td>
                                </tr>
                                <tr>
                                    <td>주요기술</td>
                                </tr>
                                <tr>
                                	<td valign="top"><c:out value="${fn:replace(fn:replace(fn:replace(fn:replace(resultSmry.sbcTclgTxt, cn, br), n1, b1), n2, b2), n3, b3)}" escapeXml="false"/></td>
                                </tr>
                                <tr>
                                    <td>품의</td>
                                </tr>
                                <tr>
                                    <td valign="top"><c:out value="${fn:replace(fn:replace(fn:replace(fn:replace(resultSmry.cnsu, cn, br), n1, b1), n2, b2), n3, b3)}" escapeXml="false"/></td>
                                </tr>
                                <tr>
                                    <td>발주</td>
                                </tr>
                                <tr>
                                    <td valign="top"><c:out value="${fn:replace(fn:replace(fn:replace(fn:replace(resultSmry.ordn, cn, br), n1, b1), n2, b2), n3, b3)}" escapeXml="false"/></td>
                                </tr>
                                <tr>
                                    <td>입고</td>
                                </tr>
                                <tr>
                                    <td valign="top"><c:out value="${fn:replace(fn:replace(fn:replace(fn:replace(resultSmry.whsn, cn, br), n1, b1), n2, b2), n3, b3)}" escapeXml="false"/></td>
                                </tr>
                                <tr>
                                    <td>양산</td>
                                </tr>
                                <tr>
                                    <td valign="top"><c:out value="${fn:replace(fn:replace(fn:replace(fn:replace(resultSmry.mssp, cn, br), n1, b1), n2, b2), n3, b3)}" escapeXml="false"/></td>
                                </tr>
                                <tr>
                                    <td>정량적</td>
                                </tr>
                                <tr>
                                    <td valign="top"><c:out value="${fn:replace(fn:replace(fn:replace(fn:replace(resultSmry.quan, cn, br), n1, b1), n2, b2), n3, b3)}" escapeXml="false"/></td>
                                </tr>
                                <tr>
                                    <td>정성적</td>
                                </tr>
                                <tr>
                                    <td valign="top"><c:out value="${fn:replace(fn:replace(fn:replace(fn:replace(resultSmry.qtTxt, cn, br), n1, b1), n2, b2), n3, b3)}" escapeXml="false"/></td>
                                </tr>
                                <tr>
                                    <td>과제 성격(Ⅰ)</td>
                                </tr>
                                <tr>
                                    <td valign="top"><c:out value="${fn:replace(fn:replace(fn:replace(fn:replace(resultSmry.tssStatF, cn, br), n1, b1), n2, b2), n3, b3)}" escapeXml="false"/></td>
                                </tr>
                                <tr>
                                    <td>과제 성격(Ⅱ)</td>
                                </tr>
                                <tr>
                                    <td valign="top"><c:out value="${fn:replace(fn:replace(fn:replace(fn:replace(resultSmry.tssStatS, cn, br), n1, b1), n2, b2), n3, b3)}" escapeXml="false"/></td>
                                </tr>
                                <tr>
                                    <td>과제난이도</td>
                                </tr>
                                <tr>
                                    <td valign="top"><c:out value="${fn:replace(fn:replace(fn:replace(fn:replace(resultSmry.tssDfcr, cn, br), n1, b1), n2, b2), n3, b3)}" escapeXml="false"/></td>
                                </tr>
                                <tr>
                                    <td>예상투자규모</td>
                                </tr>
                                <tr>
                                    <td valign="top"><c:out value="${fn:replace(fn:replace(fn:replace(fn:replace(resultSmry.ancpSclTxt, cn, br), n1, b1), n2, b2), n3, b3)}" escapeXml="false"/></td>
                                </tr>
                                <tr>
                                    <td>설치장소</td>
                                </tr>
                                <tr>
                                    <td valign="top"><c:out value="${fn:replace(fn:replace(fn:replace(fn:replace(resultSmry.istlPlTxt, cn, br), n1, b1), n2, b2), n3, b3)}" escapeXml="false"/></td>
                                </tr>
                                <tr>
                                    <td>추천업체</td>
                                </tr>
                                <tr>
                                    <td valign="top"><c:out value="${fn:replace(fn:replace(fn:replace(fn:replace(resultSmry.rcmCofTxt, cn, br), n1, b1), n2, b2), n3, b3)}" escapeXml="false"/></td>
                                </tr>
                                <tr>
                                    <td>과제 개요</td>
                                </tr>
                                <tr>
                                    <td valign="top"><c:out value="${fn:replace(fn:replace(fn:replace(fn:replace(resultSmry.tssTxt, cn, br), n1, b1), n2, b2), n3, b3)}" escapeXml="false"/></td>
                                </tr>
                                <tr>
                                    <td>중점요청 사항</td>
                                </tr>
                                <tr>
                                    <td valign="top"><c:out value="${fn:replace(fn:replace(fn:replace(fn:replace(resultSmry.empsReqTxt, cn, br), n1, b1), n2, b2), n3, b3)}" escapeXml="false"/></td>
                                </tr>
                                <tr>
                                    <td>협력요청 사항</td>
                                </tr>
                                <tr>
                                    <td valign="top"><c:out value="${fn:replace(fn:replace(fn:replace(fn:replace(resultSmry.cooReqTxt, cn, br), n1, b1), n2, b2), n3, b3)}" escapeXml="false"/></td>
                                </tr>
                            </tbody>
                        </table>
                    <div class="titArea"><h3>4. 참여연구원</h3></div>
                        <table class="table">
                            <colgroup>
                                <col style="width:20%;"/>
                                <col style="width:40%;"/>
                                <col style="width:40%;"/>
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
                       
                    <div class="titArea"><h3>5. 첨부파일</h3></div>
                        <table class="table table_txt_right">
                            <colgroup>
                                <col style="width:100%;"/>
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
                    <button type="button" id="butCsur" name="butCsur" onClick="fncSaveCsus()">결재품의</button>
                    <button type="button" id="btnPrint" name="btnPrint">인쇄</button>
                    <button type="button" id="btnList" name="btnList" onClick="fncList()">목록</button>
                </div>
            </div>
        </div>
    </div>

</body>
</html>

