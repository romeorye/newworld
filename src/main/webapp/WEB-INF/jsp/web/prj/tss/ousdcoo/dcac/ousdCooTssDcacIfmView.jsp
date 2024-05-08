<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*, java.util.*,devonframe.util.NullUtil,devonframe.util.DateUtil"%>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>

<%--
/*
 *************************************************************************
 * $Id      : ousdCooTssDcacDetail.jsp
 * @desc    : 대외협력과제 > 중단 > 중단개요 화면
 *------------------------------------------------------------------------
 * VER  DATE        AUTHOR      DESCRIPTION
 * ---  ----------- ----------  -----------------------------------------
 * 1.0  2017.09.26  IRIS04		최초생성
 * ---  ----------- ----------  -----------------------------------------
 * IRIS 프로젝트
 ********************************************************************************
 */
--%>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<%@ include file="/WEB-INF/jsp/include/rui_header.jspf"%>

<title><%=documentTitle%></title>

<script type="text/javascript">
    var lvTssCd  = window.parent.dcacTssCd;
    var lvUserId = window.parent.gvUserId;
    var lvTssSt  = window.parent.gvTssSt;
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
          	       { id: 'dcacAttcFilId' }     /*중단첨부파일ID*/
         		, { id: 'userId' }
            ]
        });
        dataSet.on('load', function(e) {
            
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
                dataSet.setNameValue(0, "dcacAttcFilId", lvAttcFilId)
            }
            
            initFrameSetHeight();
        };
        
        downloadAttachFile = function(attcFilId, seq) {
            aForm.action = "<c:url value='/system/attach/downloadAttachFile.do'/>" + "?attcFilId=" + attcFilId + "&seq=" + seq;
            aForm.submit();
        };
        
      /*   
        //목록
        var btnList = new Rui.ui.LButton('btnList');
        btnList.on('click', function() {                
            nwinsActSubmit(window.parent.document.mstForm, "<c:url value='/prj/tss/ousdcoo/ousdCooTssList.do'/>");
        });
         */
        //데이터 셋팅 
        if(${resultCnt} > 0) { 
            console.log("smry searchData1");
            dataSet.loadData(${result}); 
        }
        

         if("<c:out value='${inputData._roleId}'/>".indexOf('WORK_IRI_T15') > -1) {
         	document.getElementById('attchFileMngBtn').style.display = "none";
     	}else if("<c:out value='${inputData._roleId}'/>".indexOf('WORK_IRI_T16') > -1) {
         	document.getElementById('attchFileMngBtn').style.display = "none";
 		}
    });
    
    
    // 내부 스크롤 제거
    $(window).load(function() {
        initFrameSetHeight();
    });
</script>
<script type="text/javascript">
</script>

</head>
<body>
<div id="aFormDiv">
	<br>
	
    <form name="aForm" id="aForm" method="post">
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
                    <th align="right">과제 개요</th>
                    <td colspan="2">
                        <table>
                            <colgroup>
                                <col style="width: 150px;" />
                                <col style="width: 150px;" />
                                <col style="width: *;" />
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th align="right">개발목적<br> 및 배경</th>
                                    <th align="right">과제 필요성<br> 및 사업기회</th>
                                    <td>
                                    	<c:choose>
				                        	<c:when test="${id eq 'MIG' }">
												${resultData.surrNcssTxt} 
											</c:when>
											<c:otherwise>
												<c:out value="${fn:replace(resultData.surrNcssTxt, cn, br)}" escapeXml="false"/>
											</c:otherwise>
				                        </c:choose>
                                    </td>
                                </tr>
                                <tr>
                                    <th align="right">개발목표</th>
                                    <th align="right">핵심 CTQ/품질 수준<br/>(경쟁사 비교)</th>
                                    <td>
                                    	<c:choose>
				                        	<c:when test="${id eq 'MIG' }">
												${resultData.ctqTxt} 
											</c:when>
											<c:otherwise>
												<c:out value="${fn:replace(resultData.ctqTxt, cn, br)}" escapeXml="false"/>
											</c:otherwise>
				                        </c:choose>
                                    </td>
                                </tr>
                                <tr>
                                    <th align="right" colspan="2">주요개발 내용</th>
                                    <td>
                                    	<c:choose>
				                        	<c:when test="${id eq 'MIG' }">
												${resultData.sbcSmryTxt} 
											</c:when>
											<c:otherwise>
												<c:out value="${fn:replace(resultData.sbcSmryTxt, cn, br)}" escapeXml="false"/>
											</c:otherwise>
				                        </c:choose>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </td>
                </tr>
                <tr>
                    <th align="right">연구 개발 성과</th>
                    <td colspan="2">
                        <table>
                            <colgroup>
                                <col style="width: 150px;" />
                                <col style="width: 150px;" />
                                <col style="width: *;" />
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th align="right">지적 재산권</th>
                                    <th align="right">지재권 출원현황<br/>(국내/해외)</th>
                                    <td>
                                    	<c:choose>
				                        	<c:when test="${id eq 'MIG' }">
												${resultData.sttsTxt} 
											</c:when>
											<c:otherwise>
												<c:out value="${fn:replace(resultData.sttsTxt, cn, br)}" escapeXml="false"/>
											</c:otherwise>
				                        </c:choose>
                                    </td>
                                </tr>
                                <tr>
                                    <th align="right" colspan="2">파급효과 및 응용분야</th>
                                    <td>
                                    	<c:choose>
				                        	<c:when test="${id eq 'MIG' }">
												${resultData.effSpheTxt} 
											</c:when>
											<c:otherwise>
												<c:out value="${fn:replace(resultData.effSpheTxt, cn, br)}" escapeXml="false"/>
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
                        <table>
                            <colgroup>
                                <col style="width: 300px;" />
                                <col style="width: *;" />
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th align="right">결론 및 향후 계획</th>
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
								${resultData.dcacRson} 
							</c:when>
							<c:otherwise>
								<c:out value="${fn:replace(resultData.dcacRson, cn, br)}" escapeXml="false"/>
							</c:otherwise>
                        </c:choose>
                     </td>
                </tr>
                <tr>
                    <th align="right">첨부파일<br/>(심의파일, 회의록 필수 첨부)</th>
                    <td id="attchFileView"style="width:600px;">&nbsp;</td>
                    <td><button type="button" class="btn" id="attchFileMngBtn" name="attchFileMngBtn" onclick="openAttachFileDialog(setAttachFileInfo, getAttachFileId(), 'prjPolicy', '*')">첨부파일등록</button></td>
                </tr>
            </tbody>
        </table>
    </form>
</div>
<div class="titArea">
    <div class="LblockButton">
        <!-- <button type="button" id="btnList" name="btnList">목록</button> -->
    </div>
</div>
</body>
</html>