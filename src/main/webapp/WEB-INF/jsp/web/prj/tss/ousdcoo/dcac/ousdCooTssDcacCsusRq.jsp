<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*, java.util.*,devonframe.util.NullUtil,devonframe.util.DateUtil"%>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>

<%--
/*
 *************************************************************************
 * $Id      : ousdCooTssDcacCsusRq.jsp
 * @desc    : 대외협력과제 > 중단 품의서요청 화면
 *------------------------------------------------------------------------
 * VER  DATE        AUTHOR      DESCRIPTION
 * ---  ----------- ----------  -----------------------------------------
 * 1.0  2017.09.26  IRIS04		최초생성
 * ---  ----------- ----------  -----------------------------------------
 * IRIS 프로젝트
 *************************************************************************
 */
--%>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<%@ include file="/WEB-INF/jsp/include/rui_header.jspf"%>

<title><%=documentTitle%></title>

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
					// GRS없는 변경
					var pUrl = "http://dv.lghausys.com:7001/lgchem/approval.front.document.RetrieveDocumentFormCmd.lgc?appCode=APP00339&from=iris&guid="+gvGuid;
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
            
            Rui.confirm({
                text: '결재품의 하시겠습니까?',
                handlerYes: function() {
                    var row = 0;
                    var record;
                    
                    if(dataSet.getCount() <= 0) row = dataSet.newRecord();

                    record = dataSet.getAt(row);
                    
                    record.set("tssCd"            , '<c:out value="${inputData.tssCd}"/>');
                    record.set("userId"           , '<c:out value="${inputData._userId}"/>');
                    record.set("affrGbn"          , "T"); //T:과제
                    
                    record.set("guid",             gvGuid);
                    record.set("affrCd"           , '<c:out value="${inputData.tssCd}"/>');
                    record.set("approvalUserid"   , '<c:out value="${inputData._userId}"/>');
                    record.set("approvalUsername" , '<c:out value="${inputData._userNm}"/>');
                    record.set("approvalJobtitle" , '<c:out value="${inputData._userJobxName}"/>');
                    record.set("approvalDeptname" , '<c:out value="${inputData._userDeptName}"/>');
//                    record.set("body", csusCont);
                    record.set("body"              , Rui.get('csusContents').getHtml().trim());
                    
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
       /*  
        /* [버튼] 목록 */
        var btnList = new Rui.ui.LButton('btnList');
        btnList.on('click', function() {                
            nwinsActSubmit(window.document.aform, "<c:url value='/prj/tss/ousdcoo/ousdCooTssList.do'/>");
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
    <Tag:saymessage /><%--<!--  sayMessage 사용시 필요 -->--%>

    <div class="contents">
<%--         <%@ include file="/WEB-INF/jsp/include/navigator.jspf"%> --%>
<!-- 		<div class="titleArea"> -->
<!-- 			<h2>대외협력과제 &gt;&gt;중단 - 품의서요청</h2> -->
<!-- 	    </div> -->

        <div class="sub-content">
            <form name="aform" id="aform" method="post">
<%-- 품의서 시작 --%>                
                <div id="csusContents">
<div class="titleArea"><h2><c:out value="${resultMst.tssNm}"/></h2></div>
<br/>
<div class="titArea alignR">과제리더: <c:out value="${resultMst.saUserName}"/>, 작성일: <c:out value="${resultRqEtc.nowDate}"/></div>
<div class="titArea"><h3>1. PROJECT 기본 사항</h3></div>
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
		                                    <td><c:out value="${resultMst.tssCd}"/></td>
		                                    <th>연구부서명</th>
		                                    <td><c:out value="${resultMst.deptName}"/></td>
		                                </tr>
		                                <tr>
		                                    <th>연구개발기간</th>
		                                    <td colspan="3"><c:out value="${resultMst.tssStrtDd}"/> ~ <c:out value="${resultMst.tssFnhDd}"/></td>
		                                </tr>
		                                <tr>
		                                    <th>참여연구원</th>
		                                    <td colspan="3"><c:out value="${resultRqEtc.mbrNmList}"/></td>
		                                </tr>
		                            </tbody>
		                        </table>
<br/>
<table class="table">
							        <colgroup>
							            <col style="width: 8%;" />
							            <col style="width: 7%;" />
							            <col style="width: 7%;" />
							            <col style="width: 7%;" />
							            <col style="width: 7%;" />
							            <col style="width: 7%;" />
							            <col style="width: 7%;" />
							            <col style="width: 7%;" />
							            <col style="width: 7%;" />
							            <col style="width: 7%;" />
							            <col style="width: 7%;" />
							            <col style="width: 7%;" />
							            <col style="width: 7%;" />
							            <col style="width: 8%;" />
							        </colgroup>
							        <tbody>
							       		<tr>
							        		<th colspan="14">비용실적</th>
							        	</tr>
										<tr>
											<th>WBS코드</th>
											<th>1월</th>
											<th>2월</th>
											<th>3월</th>
											<th>4월</th>
											<th>5월</th>
											<th>6월</th>
											<th>7월</th>
											<th>8월</th>
											<th>9월</th>
											<th>10월</th>
											<th>11월</th>
											<th>12월</th>
											<th>합계</th>
										</tr>
								
						<c:choose>
              				<c:when test="${fn:length(resultExpStoa) == 0}">
                            			<tr><td colspan="14"></td></tr>
              				</c:when>
              				<c:otherwise>
								<c:forEach var="list" items="${resultExpStoa}" varStatus="status">
										<tr>
											<td>${list.wbsCd}</td>
											<td><fmt:formatNumber value="${list.mm1}" pattern="#,###" /> </td>
											<td><fmt:formatNumber value="${list.mm2}" pattern="#,###" /> </td>
											<td><fmt:formatNumber value="${list.mm3}" pattern="#,###" /> </td>
											<td><fmt:formatNumber value="${list.mm4}" pattern="#,###" /> </td>
											<td><fmt:formatNumber value="${list.mm5}" pattern="#,###" /> </td>
											<td><fmt:formatNumber value="${list.mm6}" pattern="#,###" /> </td>
											<td><fmt:formatNumber value="${list.mm7}" pattern="#,###" /> </td>
											<td><fmt:formatNumber value="${list.mm8}" pattern="#,###" /> </td>
											<td><fmt:formatNumber value="${list.mm9}" pattern="#,###" /> </td>
											<td><fmt:formatNumber value="${list.mm10}" pattern="#,###" /> </td>
											<td><fmt:formatNumber value="${list.mm11}" pattern="#,###" /> </td>
											<td><fmt:formatNumber value="${list.mm12}" pattern="#,###" /> </td>
											<td><fmt:formatNumber value="${list.totSum}" pattern="#,###" /> </td>
										</tr>					        	
							    </c:forEach>
							</c:otherwise>
						</c:choose>	       			 	
							        	</tr>
							        </tbody>
							    </table>
<div class="titArea"><h3>2. 과제 개요</h3></div>
<table class="table table_txt_right">
		                            <colgroup>
		                                <col style="width:15%"/>
		                                <col style="width:15%"/>
		                                <col style="width:70%"/>
		                            </colgroup>
		                            <tbody>
		                                <tr>
		                                    <th>개발목적<br> 및 배경</th>
		                                    <th>과제 필요성<br> 및 사업기회</th>
		                                    <td><c:out value="${resultSmry.surrNcssTxt}" escapeXml="false"/></td>
		                                </tr>
		                                <tr>
		                                    <th>개발목표</th>
		                                    <th>핵심 CTQ/<br>품질 수준<br/>(경쟁사 비교)</th>
		                                    <td><c:out value="${resultSmry.ctqTxt}" escapeXml="false"/></td>
		                                </tr>
		                                <tr>
		                                    <th colspan="2">주요개발 내용</th>
		                                    <td><c:out value="${resultSmry.sbcSmryTxt}" escapeXml="false"/></td>
		                                </tr>
		                            </tbody>
		                        </table>
<div class="titArea"><h3>3. 연구개발 성과</h3></div>
<table class="table table_txt_right">
		                            <colgroup>
		                                <col style="width:15%"/>
		                                <col style="width:15%"/>
		                                <col style="width:70%"/>
		                            </colgroup>
		                            <tbody>
		                                <tr>
		                                    <th>지적재산권</th>
		                                    <th>지재권 출원현황<br/>(국내/해외)</th>
		                                    <td><c:out value="${resultSmry.sttsTxt}" escapeXml="false"/></td>
		                                </tr>
		                                <tr>
		                                    <th colspan="2">파급효과 및 응용분야</th>
		                                    <td><c:out value="${resultSmry.effSpheTxt}" escapeXml="false"/></td>
		                                </tr>
		                            </tbody>
		                        </table>
<div class="titArea"><h3>4. 향후 계획</h3></div>
<table class="table table_txt_right">
		                            <colgroup>
		                                <col style="width:20%"/>
		                                <col style="width:80%"/>
		                            </colgroup>
		                            <tbody>
		                                <tr>
		                                    <th>사업화(출시) 및<br> 양산이관계획</th>
		                                    <td><c:out value="${resultSmry.fnoPlnTxt}" escapeXml="false"/></td>
		                                </tr>
		                            </tbody>
		                        </table>
<div class="titArea"><h3>5. 중단 사유</h3></div>
<table class="table table_txt_right">
		                            <colgroup>
		                                <col style="width:100%"/>
		                            </colgroup>
		                            <tbody>
		                                <tr>
		                                    <td><c:out value="${resultSmry.dcacRson}" escapeXml="false"/></td>
		                                </tr>
		                            </tbody>
		                        </table>
<div class="titArea"><h3>6. 첨부파일</h3></div>
<table class="table table_txt_right">
                                <colgroup>
                                        <col style="width:100%"/>
                                    </colgroup>
                                    <tbody>
		                <tr>
		                    <td>
			            	<c:forEach var="resultAttc" items="${resultAttc}">
			                    <a href="http://<spring:eval expression='@jspProperties[defaultUrl]'/>:<spring:eval expression='@jspProperties[serverPort]'/>/<spring:eval expression='@jspProperties[contextPath]'/>/common/login/irisDirectLogin.do?reUrl=/system/attach/downloadAttachFile.do&attcFilId=${resultAttc.attcFilId}&seq=${resultAttc.seq}">${resultAttc.filNm} (${resultAttc.filSize}byte)</a><br/>
			            	</c:forEach>
		                    </td>
		                </tr>
		                </tbody>
		            </table>
                </div>
<%-- 품의서 종료 --%>               
            </form>
            <div class="titArea">
                <div class="LblockButton">
                    <button type="button" id="butCsur" name="butCsur">결재품의</button>
<!--                     <button type="button" id="butExcel" name="butExcel">EXCEL다운로드</button> -->
                    <button type="button" id="btnPrint" name="btnPrint">인쇄</button>
                    <button type="button" id="btnList" name="btnList">목록</button> 
                </div>
            </div>
        </div>
    </div>
</body>
</html>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

