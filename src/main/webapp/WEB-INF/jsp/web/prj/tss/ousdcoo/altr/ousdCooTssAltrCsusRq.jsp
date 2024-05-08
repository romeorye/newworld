<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*, java.util.*,devonframe.util.NullUtil,devonframe.util.DateUtil"%>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>

<%--
/*
 *************************************************************************
 * $Id      : ousdCooTssAltrCsusRq.jsp
 * @desc    : 대외협력과제 > 변경 품의서요청
              진행-GRS(변경) or 변경상태인 경우 진입
 *------------------------------------------------------------------------
 * VER  DATE        AUTHOR      DESCRIPTION
 * ---  ----------- ----------  -----------------------------------------
 * 1.0  2017.09.22  IRIS04		최초생성
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
    var innerCsusRqYn = '<c:out value="${inputData.innerCsusRqYn}"/>';

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
                	// 일반결재
					var pUrl = "<%=lghausysPath%>/lgchem/approval.front.document.RetrieveDocumentFormCmd.lgc?appCode=APP00332&from=iris&guid="+gvGuid;

					// 내부결재(GRS없는 변경)
					if(innerCsusRqYn == 'Y'){
						pUrl = "<%=lghausysPath%>/lgchem/approval.front.document.RetrieveDocumentFormCmd.lgc?appCode=APP00339&from=iris&guid="+gvGuid;
					}

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

                    record.set("tssCd"            , "${inputData.tssCd}");
                    record.set("userId"           , "${inputData._userId}");
                    record.set("affrGbn"          , "T");                    //T:과제

                    record.set("guid",             gvGuid);
                    record.set("affrCd"           , "${inputData.tssCd}");
                    record.set("approvalUserid"   , "${inputData._userId}");
                    record.set("approvalUsername" , "${inputData._userNm}");
                    record.set("approvalJobtitle" , "${inputData._userJobxName}");
                    record.set("approvalDeptname" , "${inputData._userDeptName}");
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

        /* [버튼] 목록 */
        var btnList = new Rui.ui.LButton('btnList');
        btnList.on('click', function() {
            nwinsActSubmit(aform, "<c:url value='/prj/tss/ousdcoo/ousdCooTssList.do'/>");
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
<!--         <div class="titleArea"> -->
<!-- 			<h2>대외협력과제 &gt;&gt;변경-품의서요청</h2> -->
<!--     	</div> -->

        <div class="sub-content">
            <form name="aform" id="aform" method="post">

<%-- 변경품의서 시작 --%>
                <div id="csusContents">
<div class="titArea"><h3>과제명 : <c:out value="${resultMst.tssNm}"/></h3></div>
<br/>
<div class="titArea"><h3>과제코드 : <c:out value="${resultMst.wbsCd}"/></h3></div>
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
		                                <c:choose>
				                            <c:when test="${fn:length(resultAltr) == 0}">
				                            	<tr><td colspan="3"></td></tr>
				                            </c:when>
				                            <c:otherwise>
				                            	<c:forEach var="resultAltr" items="${resultAltr}">
				                                <tr>
				                                    <td><c:out value="${resultAltr.prvs}" escapeXml="false"/></td>
				                                    <td><c:out value="${resultAltr.altrPre}" escapeXml="false"/></td>
				                                    <td><c:out value="${resultAltr.altrAft}" escapeXml="false"/></td>
				                                </tr>
				                            	</c:forEach>
			                            	</c:otherwise>
		                            	</c:choose>
		                            </tbody>
		                        </table>
<br/>
<table class="table">
		                            <colgroup>
		                                <col style="width:100%"/>
		                            </colgroup>
		                            <tbody>
		                                <tr>
		                                    <th>변경사유</th>
		                                </tr>
		                                <tr>
		                                    <td><c:out value="${resultSmry.altrRson}" escapeXml="false"/></td>
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
		                                    <td><c:out value="${resultSmry.addRson}" escapeXml="false"/></td>
		                                </tr>
		                            </tbody>
		                        </table>
<br/>
<table class="table">
                                <colgroup>
                                        <col style="width:100%"/>
                                    </colgroup>
                                    <tbody>
		                </tr>
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
<%-- 변경품의서 종료 --%>

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