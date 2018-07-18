<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*, java.util.*,devonframe.util.NullUtil,devonframe.util.DateUtil"%>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>

<%--
/*
 *************************************************************************
 * $Id      : genTssDcacIfm.jsp
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

<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/calendar/LMonthCalendar.js"></script>
<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/form/LMonthBox.js"></script>

<link rel="stylesheet" type="text/css" href="<%=ruiPathPlugins%>/ui/form/LMonthBox.css"/>
<style>
 .L-tssLable {
 border: 0px
 }
</style>
<%
	pageContext.setAttribute("cn", "\n");    //Enter
	pageContext.setAttribute("br", "<br/>");    //Enter
%>
<script type="text/javascript">
    var lvTssCd    = window.parent.dcacTssCd;
    var lvUserId   = window.parent.gvUserId;
    var lvTssSt    = window.parent.gvTssSt;
    var lvPageMode = window.parent.gvPageMode;

    var pageMode = (lvTssSt == "100" || lvTssSt == "") && lvPageMode == "W" ? "W" : "R";

    var dataSet;
    var vm;
    var lvAttcFilId;

    Rui.onReady(function() {
        /*============================================================================
        =================================    Form     ================================
        ============================================================================*/
       

        /*============================================================================
        =================================    DataSet     =============================
        ============================================================================*/
        //DataSet 설정
        dataSet = new Rui.data.LJsonDataSet({
            id: 'smryDataSet',
            remainRemoved: true,
            lazyLoad: true,
            fields: [
                  { id: 'attcFilId' }          //첨부파일
                , { id: 'dcacAttcFilId' }      //첨부파일
            ]
        });
        dataSet.on('load', function(e) {
            console.log("smry load DataSet Success");

            lvAttcFilId = stringNullChk(dataSet.getNameValue(0, "dcacAttcFilId"));
            if(lvAttcFilId != "") getAttachFileList();
        });

        /*============================================================================
        =================================    기능     ================================
        ============================================================================*/
        //첨부파일 조회
        var attachFileDataSet = new Rui.data.LJsonDataSet({
            id: 'attachFileDataSet',
            remainRemoved: true,
            lazyLoad: true,
            fields: [
                  { id: 'attcFilId'}
                , { id: 'seq' }
                , { id: 'filNm' }
                , { id: 'filSize' }
            ]
        });
        attachFileDataSet.on('load', function(e) {
            getAttachFileInfoList();
        });

        getAttachFileList = function() {
            attachFileDataSet.load({
                url: '<c:url value="/system/attach/getAttachFileList.do"/>' ,
                params :{
                    attcFilId : lvAttcFilId
                }
            });
        };

        getAttachFileInfoList = function() {
            var attachFileInfoList = [];

            for( var i = 0, size = attachFileDataSet.getCount(); i < size ; i++ ) {
                attachFileInfoList.push(attachFileDataSet.getAt(i).clone());
            }

            setAttachFileInfo(attachFileInfoList);
        };

        //첨부파일 등록 팝업
        getAttachFileId = function() {
            return stringNullChk(lvAttcFilId);
        };

        setAttachFileInfo = function(attachFileList) {
            $('#attchFileView').html('');

            for(var i = 0; i < attachFileList.length; i++) {
                $('#attchFileView').append($('<a/>', {
                    href: 'javascript:downloadAttachFile("' + attachFileList[i].data.attcFilId + '", "' + attachFileList[i].data.seq + '")',
                    text: attachFileList[i].data.filNm + '(' + attachFileList[i].data.filSize + 'byte)'
                })).append('<br/>');
            }

            if(attachFileList.length > 0) {
                lvAttcFilId = attachFileList[0].data.attcFilId;
                dataSet.setNameValue(0, "attcFilId", lvAttcFilId)
            }
        };

        downloadAttachFile = function(attcFilId, seq) {
            aForm.action = "<c:url value='/system/attach/downloadAttachFile.do'/>" + "?attcFilId=" + attcFilId + "&seq=" + seq;
            aForm.submit();
        };



        //목록
       /*  var btnList = new Rui.ui.LButton('btnList');
        btnList.on('click', function() {
            nwinsActSubmit(window.parent.document.mstForm, "<c:url value='/prj/tss/gen/genTssList.do'/>");
        });
 */

        //데이터 셋팅
        if(${resultCnt} > 0) {
            console.log("smry searchData1");
            dataSet.loadData(${result});
        }
    });

    
</script>
<script type="text/javascript">
$(window).load(function() {
    initFrameSetHeight();
});
</script>
</head>
<body>
<div id="aFormDiv">
    <form name="aForm" id="aForm" method="post" style="padding: 20px 1px 0 0;">
        <input type="hidden" id="tssCd"  name="tssCd"  value=""> <!-- 과제코드 -->
        <input type="hidden" id="userId" name="userId" value=""> <!-- 사용자ID -->

		<c:set var="id" value="${fn:substring(resultData.lastMdfyId, 0, 3)}" />

        <table class="table table_txt_right">
            <colgroup>
                <col style="width: 150px;" />
                <col style="width: *;" />
                <col style="width: 150px;" />
            </colgroup>
            <tbody>
                <tr>
                    <th align="right">과재개요</th>
                    <td colspan="2">
                        <table class="table table_txt_right">
                            <colgroup>
                                <col style="width: 150px;" />
                                <col style="width: 150px;" />
                                <col style="width: *;" />
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th align="right">개발목적 및 배경</th>
                                    <th align="right">과제 필요성 및 사업기회</th>
                                    <td>
                                    	<c:choose>
				                        	<c:when test="${id eq 'MIG' }">
												${resultData.tssSmryTxt} 
											</c:when>
											<c:otherwise>
												<c:out value="${fn:replace(resultData.tssSmryTxt, cn, br)}" escapeXml="false"/>
											</c:otherwise>
				                        </c:choose>
                                    </td>
                                </tr>
                                <tr>
                                    <th align="right">개발목표</th>
                                    <th align="right">핵심 CTQ/품질 수준 (경쟁사 비교)</th>
                                    <td>
                                    	<c:choose>
				                        	<c:when test="${id eq 'MIG' }">
												${resultData.rsstDvlpOucmCtqTxt} 
											</c:when>
											<c:otherwise>
												<c:out value="${fn:replace(resultData.rsstDvlpOucmCtqTxt, cn, br)}" escapeXml="false"/>
											</c:otherwise>
				                        </c:choose>
                                    </td>
                                </tr>
                                <tr>
                                    <th align="right" colspan="2">주요개발 내용</th>
                                    <td>
                                    	<c:choose>
				                        	<c:when test="${id eq 'MIG' }">
												${resultData.tssSmryDvlpTxt} 
											</c:when>
											<c:otherwise>
												<c:out value="${fn:replace(resultData.tssSmryDvlpTxt, cn, br)}" escapeXml="false"/>
											</c:otherwise>
				                        </c:choose>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </td>
                </tr>
                <tr>
                    <th align="right">연구개발성과</th>
                    <td colspan="2">
                        <table class="table table_txt_right">
                            <colgroup>
                                <col style="width: 150px;" />
                                <col style="width: 150px;" />
                                <col style="width: *;" />
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th align="right">지적재산권</th>
                                    <th align="right">지재권 출원현황<br/>(국내/해외)</th>
                                    <td>
                                    	<c:choose>
				                        	<c:when test="${id eq 'MIG' }">
												${resultData.rsstDvlpOucmTxt} 
											</c:when>
											<c:otherwise>
												<c:out value="${fn:replace(resultData.rsstDvlpOucmTxt, cn, br)}" escapeXml="false"/>
											</c:otherwise>
				                        </c:choose>
                                    </td>
                                </tr>
                                <tr>
                                    <th align="right" colspan="2">파급효과 및 응용분야</th>
                                    <td>
                                    	<c:choose>
				                        	<c:when test="${id eq 'MIG' }">
												${resultData.rsstDvlpOucmEffTxt} 
											</c:when>
											<c:otherwise>
												<c:out value="${fn:replace(resultData.rsstDvlpOucmEffTxt, cn, br)}" escapeXml="false"/>
											</c:otherwise>
				                        </c:choose>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </td>
                </tr>
                <tr>
                    <th align="right">향후 계획</th>
                    <td colspan="2">
                        <table class="table table_txt_right">
                            <colgroup>
                                <col style="width: 150px;" />
                                <col style="width: *;" />
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th align="right">사업화(출시) 및 양산이관계획</th>
                                    <td>
                                    	<c:choose>
				                        	<c:when test="${id eq 'MIG' }">
												${resultData.fnoPlnTxt} 
											</c:when>
											<c:otherwise>
												<c:out value="${fn:replace(resultData.fnoPlnTxt, cn, br)}" escapeXml="false"/>
											</c:otherwise>
				                        </c:choose>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </td>
                </tr>
                <tr>
                    <th align="right">중단 사유</th>
                    <td>
                    	<c:choose>
                        	<c:when test="${id eq 'MIG' }">
								${resultData.dcacRsonTxt} 
							</c:when>
							<c:otherwise>
								<c:out value="${fn:replace(resultData.dcacRsonTxt, cn, br)}" escapeXml="false"/>
							</c:otherwise>
                        </c:choose>
                    </td>
                </tr>
                <tr>
                    <th align="right">과제완료보고서 및 기타</th>
                    <td id="attchFileView">&nbsp;</td>
                    <td><button type="button" class="btn" id="attchFileMngBtn" name="attchFileMngBtn" onclick="openAttachFileDialog(setAttachFileInfo, getAttachFileId(), 'prjPolicy', '*')">첨부파일등록</button></td>
                </tr>
            </tbody>
        </table>
    </form>
</div>
<!-- 
<div class="titArea">
    <div class="LblockButton">
        <button type="button" id="btnList" name="btnList">목록</button>
    </div>
</div> -->
</body>
</html>