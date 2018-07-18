<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*, java.util.*,devonframe.util.NullUtil,devonframe.util.DateUtil"%>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>

<%--
/*
 *************************************************************************
 * $Id      : ousdCooTssPlnCsusRq.jsp
 * @desc    : 대외협력과제 > 계획 품의서요청 화면
 *------------------------------------------------------------------------
 * VER  DATE        AUTHOR      DESCRIPTION
 * ---  ----------- ----------  -----------------------------------------
 * 1.0  2017.09.19  IRIS04		최초생성
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
                , { id: 'affrGbn'}              //업무구분
                , { id: 'tssSt'}                //과제상태
                
                , { id: 'oid' }                 //전자결재코드
                , { id: 'guid' }                //고유코드
                , { id: 'affrCd' }              //업무코드
                , { id: 'aprdocstate' }         //결재상태코드
                , { id: 'dockind' }             //결재종류
                , { id: 'approvalUserid' }      //결재 요청자 ID
                , { id: 'approvalUsername' }    //결재 요청자명
                , { id: 'approvalJobtitle' }    //결재 요청자 직위
                , { id: 'approvalDeptname' }    //결재 요청자 부서명
                , { id: 'approvalProcessdate' } //결재일자
                , { id: 'body' }                //결재 내용
                , { id: 'title' }               //결재 제목
                , { id: 'filename' }            //결재문서 첨부파일명
                , { id: 'updateDate' }          //수정일
                , { id: 'url' }                 //결재문서 url
            ]
        });
        
        
        /* [DataSet] 서버전송용 */
        var dm = new Rui.data.LDataSetManager({defaultFailureHandler: false});
        dm.on('success', function(e) {
            var data = dataSet.getReadData(e);
            
            if(data.records[0].rtCd == "SUCCESS") {
                gvGuid = data.records[0].guid;
                
                if(stringNullChk(gvAprdocState) == "" || gvAprdocState == "A03" || gvAprdocState == "A04") {
                	// 일반결재
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
        	
            Rui.confirm({
                text: '결재품의 하시겠습니까?',
                handlerYes: function() {
                    var row = 0;
                    var record;
                    
                    if(dataSet.getCount() <= 0) row = dataSet.newRecord();

                    record = dataSet.getAt(row);
                    
                    record.set("tssCd"           , '<c:out value="${inputData.tssCd}"/>');
                    record.set("userId"          , '<c:out value="${inputData._userId}"/>');
                    record.set("affrGbn"         , "T");
                    
                    record.set("guid",             gvGuid);
                    record.set("affrCd"           , '<c:out value="${inputData.tssCd}"/>');
                    record.set("approvalUserid"   , '<c:out value="${inputData._userId}"/>');
                    record.set("approvalUsername" , '<c:out value="${inputData._userNm}"/>');
                    record.set("approvalJobtitle" , '<c:out value="${inputData._userJobxName}"/>');
                    record.set("approvalDeptname" , '<c:out value="${inputData._userDeptName}"/>');
                    //record.set("body", csusCont);
                    record.set("body"             , Rui.get('csusContents').getHtml().trim());
                    
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
        	nwinsActSubmit(aform, "<c:url value='/prj/tss/ousdcoo/ousdCooTssList.do'/>");
        });
        
        /* 파일 다운로드 */
        downloadAttachFile = function(attcFilId, seq) {
            aform.action = "<c:url value='/system/attach/downloadAttachFile.do'/>" + "?attcFilId=" + attcFilId + "&seq=" + seq;
            aform.submit();
        };
    });
</script>
</head>
<body>
    <Tag:saymessage /><%--<!--  sayMessage 사용시 필요 -->--%>
    <div class="contents">
    
<!--     	<div class="titleArea"> -->
<!-- 			<h2>대외협력과제 &gt;&gt;계획-품의서요청</h2> -->
<!-- 	    </div> -->
<%--         <%@ include file="/WEB-INF/jsp/include/navigator.jspf"%> --%>

        <div class="sub-content">
            <form name="aform" id="aform" method="post">
                
                <!--  품의서폼 시작 -->
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
	                                    <td><c:out value="${resultMst.prjNm}"/></td>
	                                    <th>조직</th>
	                                    <td><c:out value="${resultMst.deptName}"/></td>
	                                </tr>
	                                <tr>
	                                    <th>사업부문(Funding기준)</th>
	                                    <td colspan="3"><c:out value="${resultMst.bizDptNm}"/></td>
	                                </tr>
	                                <tr>
	                                    <th>과제명</th>
	                                    <td colspan="3"><c:out value="${resultMst.tssNm}"/></td>
	                                </tr>
	                                <tr>
	                                    <th>연구책임자</th>
	                                    <td colspan="3"><c:out value="${resultMst.saUserName}"/></td>
	                                </tr>
	                            </tbody>
	                        </table>
<br/>
<table class="table">
	                            <colgroup>
	                                <col style="width:10%"/>
	                                <col style="width:20%"/>
	                                <col style="width:30%"/>
	                                <col style="width:40%"/>
	                            </colgroup>
	                            <tbody>
	                                <tr>
	                                    <th colspan="4">참여연구원</th>
	                                </tr> 
	                                <tr>
	                                    <th>연구원</th>
	                                    <th>소속</th>
	                                    <th>참여기간</th>
	                                    <th>참여역할</th>
	                                </tr>
	                                <c:choose>
			                            <c:when test="${fn:length(resultMbr) == 0}">
			                            	<tr><td class="alignC" colspan="4"></td></tr>
			                            </c:when>
			                            <c:otherwise>
				            				<c:forEach var="resultMbr" items="${resultMbr}">
				                                <tr>
				                                    <td class="alignC"><c:out value="${resultMbr.saUserName}"/></td>
				                                    <td class="alignC"><c:out value="${resultMbr.deptName}"/></td>
				                                    <td class="alignC"><c:out value="${resultMbr.ptcStrtDt}"/> ~ <c:out value="${resultMbr.ptcFnhDt}"/></td>
				                                    <td class="alignC"><c:out value="${resultMbr.ptcRoleNm}"/></td>
				                                </tr>
				            				</c:forEach>
			            				</c:otherwise>
	                                </c:choose>
	                            </tbody>
	                        </table>
<div class="titArea"><h3>2. 협력기관</h3></div>
<table class="table">
	                            <colgroup>
	                                <col style="width:30%"/>
	                                <col style="width:20%"/>
	                                <col style="width:10%"/>
	                                <col style="width:10%"/>
	                                <col style="width:30%"/>
	                            </colgroup>
	                            <tbody>
	                            	<tr>
	                                    <th>협력기관명</th>
	                                    <th>소속</th>
	                                    <th>성명</th>
	                                    <th>직위</th>
	                                    <th>대표분야</th>
	                                </tr>
	                                <tr>
	                                	<c:choose>
			                            <c:when test="${fn:length(resultOsl) == 0}">
			                            	<td align="center" colspan="5"></td>
			                            </c:when>
			                            <c:otherwise>
		                                    <td class="alignC"><c:out value="${resultOsl.instNm}"/></td>
		                                    <td class="alignC"><c:out value="${resultOsl.opsNm}"/></td>
		                                    <td class="alignC"><c:out value="${resultOsl.spltNm}"/></td>
		                                    <td class="alignC"><c:out value="${resultOsl.poaNm}"/></td>
		                                    <td align="center"><c:out value="${resultOsl.repnSphe}"/></td>
	                                    </c:otherwise>
	                                    </c:choose>
	                                </tr>
	                            </tbody>
	                        </table>
<div class="titArea"><h3>3. 계약기간</h3></div>
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
	                                    <td><c:out value="${resultMst.tssStrtDd}"/></td>
	                                    <th>과제종료일</th>
	                                    <td><c:out value="${resultMst.tssFnhDd}"/></td>
	                                </tr>
	                            </tbody>
	                        </table>
<div class="titArea"><h3>4. 계약 유형 및 독점권</h3></div>
<table class="table table_txt_right">
	                            <colgroup>
	                                <col style="width:20%"/>
	                                <col style="width:30%"/>
	                                <col style="width:20%"/>
	                                <col style="width:30%"/>
	                            </colgroup>
	                            <tbody>
	                                <tr>
	                                    <th>계약유형</th>
	                                    <td><c:out value="${resultSmry.cnttTypeNm}"/></td>
	                                    <th>독점권</th>
	                                    <td><c:out value="${resultSmry.monoNm}"/></td>
	                                </tr>
	                            </tbody>
	                        </table>
<div class="titArea"><h3>5. 연구비 / 지급 조건</h3></div>
<table class="table table_txt_right">
	                            <colgroup>
	                                <col style="width:100%"/>
	                            </colgroup>
	                            <tbody>
	                                <tr>
	                                    <td><fmt:formatNumber value="${resultSmry.rsstExpConvertMil}" type="number"/> 억원</td>
	                                </tr>
	                                <tr>
	                                    <td><c:out value="${resultSmry.rsstExpFnshCnd}" escapeXml="false"/></td>
	                                </tr>
	                            </tbody>
	                        </table>
<div class="titArea"><h3>6. 법무팀 검토 결과</h3></div>
<table class="table table_txt_right">
	                            <colgroup>
	                                <col style="width:100%"/>
	                            </colgroup>
	                            <tbody>
	                                <tr>
	                                    <td><c:out value="${resultSmry.rvwRsltTxt}" escapeXml="false"/></td>
	                                </tr>
	                            </tbody>
	                        </table>
<div class="titArea"><h3>7. 연구과제배경 및 필요성</h3></div>
<table class="table table_txt_right">
	                            <colgroup>
	                                <col style="width:100%"/>
	                            </colgroup>
	                            <tbody>
	                                <tr>
	                                    <td><c:out value="${resultSmry.surrNcssTxt}" escapeXml="false"/></td>
	                                </tr>
	                            </tbody>
	                        </table>
<div class="titArea"><h3>8. 주요 연구개발 내용 요약</h3></div>
<table class="table table_txt_right">
	                            <colgroup>
	                                <col style="width:100%"/>
	                            </colgroup>
	                            <tbody>
	                                <tr>
	                                    <td><c:out value="${resultSmry.sbcSmryTxt}" escapeXml="false"/></td>
	                                </tr>
	                            </tbody>
	                        </table>
<div class="titArea"><h3>9. 목표기술성과</h3></div>
<table class="table">
	                            <colgroup>
	                                <col style="width:10%"/>
	                                <col style="width:30%"/>
	                                <col style="width:30%"/>
	                                <col style="width:30%"/>
	                            </colgroup>
	                            <tbody>
	                                <tr>
	                                    <th>단계</th>
	                                    <th>평가항목</th>
	                                    <th>현재수준</th>
	                                    <th>목표수준</th>
	                                </tr>
	                                
	                            <c:choose>
		                            <c:when test="${fn:length(resultGoal) == 0}">
		                            	<tr><td align="center" colspan="4"></td></tr>
		                            </c:when>
		                            <c:otherwise>    
			            				<c:forEach var="resultGoal" items="${resultGoal}">
			                                <tr>
			                                    <td valign="top"><c:out value="${fn:replace(fn:replace(fn:replace(fn:replace(resultGoal.step, cn, br), n1, b1), n2, b2), n3, b3)}" escapeXml="false"/></td>
			                                    <td valign="top"><c:out value="${fn:replace(fn:replace(fn:replace(fn:replace(resultGoal.prvs, cn, br), n1, b1), n2, b2), n3, b3)}" escapeXml="false"/></td>
                                                <td valign="top"><c:out value="${fn:replace(fn:replace(fn:replace(fn:replace(resultGoal.cur, cn, br), n1, b1), n2, b2), n3, b3)}" escapeXml="false"/></td>
                                                <td valign="top"><c:out value="${fn:replace(fn:replace(fn:replace(fn:replace(resultGoal.goal, cn, br), n1, b1), n2, b2), n3, b3)}" escapeXml="false"/></td>
			                                </tr>
			            				</c:forEach>
	            					</c:otherwise>
	            				</c:choose>
	                            
	                            </tbody>
	                        </table>
<div class="titArea"><h3>10. 첨부파일</h3></div>
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
            <!--  품의서폼 종료 -->
            
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