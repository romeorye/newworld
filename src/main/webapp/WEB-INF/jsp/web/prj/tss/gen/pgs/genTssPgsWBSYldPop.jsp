<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*, java.util.*,devonframe.util.NullUtil,devonframe.util.DateUtil"%>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>

<%--
/*
 *************************************************************************
 * $Id      : genTssPgsWBSYldPop.jsp
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

<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/grid/LTreeGridSelectionModel.js"></script>
<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/grid/LTreeGridView-debug.js"></script>

<link rel="stylesheet" type="text/css" href="<%=ruiPathPlugins%>/ui/grid/LTreeGridView.css"/> 
<%
    response.setHeader("Pragma", "No-cache");
    response.setDateHeader("Expires", 0);
    response.setHeader("Cache-Control", "no-cache");
    response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
%>
<script type="text/javascript">
    var lvTssCd    = window.parent.lvTssCd;
    var lvUserId   = window.parent.lvUserId;
    var lvPgsCd    = window.parent.lvPgsCd;
    var lvTssSt    = window.parent.lvTssSt;
    var pageMode   = window.parent.pageMode;
    
    var lvRecord = window.parent.popupRecord;
    var lvAttcFilId = lvRecord.attcFilId;
    var lvAttcFilCnt = 0;
    
    Rui.onReady(function() {
        /*============================================================================
        =================================    Form     ================================
        ============================================================================*/
        //첨부파일ID
        attcFilId = new Rui.ui.form.LTextBox({
            applyTo: 'attcFilId'
        });
        
        //산출물명
        yldItmNm = new Rui.ui.form.LTextBox({
            applyTo: 'yldItmNm',
            width: 500
        });
        
        //산출물내용
        yldItmTxt = new Rui.ui.form.LTextArea({
            applyTo: 'yldItmTxt',
            height: 100,
            width: 500
        });
        
        //키워드
        kwdTxt = new Rui.ui.form.LTextArea({
            applyTo: 'kwdTxt',
            height: 100,
            width: 500
        });
        
        //Form 비활성화
        disableFields = function() {
            attcFilId.hide();
            
            if(pageMode == "R") {
                document.getElementById('attchFileMngBtn').style.display = "none";
                
                Rui.select('.tssLableCss input').addClass('L-tssLable');
                Rui.select('.tssLableCss div').addClass('L-tssLable');
                Rui.select('.tssLableCss div').removeClass('L-disabled');
            }
        };
        
        
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
        
        //첨부파일 목록 조회
        getAttachFileList = function() {
            attachFileDataSet.load({
                url: '<c:url value="/system/attach/getAttachFileList.do"/>' ,
                params :{
                    attcFilId : lvAttcFilId
                }
            });
        };
        
        //첨부파일DS List형식으로 변환
        getAttachFileInfoList = function() {
            var attachFileInfoList = [];
            
            for(var i = 0, size = attachFileDataSet.getCount(); i < size ; i++ ) {
                attachFileInfoList.push(attachFileDataSet.getAt(i).clone());
            }
            
            setAttachFileInfo(attachFileInfoList);
        };
        
        //첨부파일 Key값 반환
        getAttachFileId = function() {
            return stringNullChk(lvAttcFilId);
        };
        
        //첨부파일 목록 화면에 만들기
        setAttachFileInfo = function(attachFileList) {
            $('#attchFileView').html('');
             
            for(var i = 0; i < attachFileList.length; i++) {
                $('#attchFileView').append($('<a/>', {
                    href: 'javascript:downloadAttachFile("' + attachFileList[i].data.attcFilId + '", "' + attachFileList[i].data.seq + '")',
                    text: attachFileList[i].data.filNm + '(' + attachFileList[i].data.filSize + 'byte)'
                })).append('<br/>');
            }
            
            lvAttcFilCnt = attachFileList.length;
            
            if(attachFileList.length > 0) {
                lvAttcFilId = attachFileList[0].data.attcFilId;    
                attcFilId.setValue(lvAttcFilId);
            }
        };
        
        //첨부파일 다운로드
        downloadAttachFile = function(attcFilId, seq) {
            attcForm.action = "<c:url value='/system/attach/downloadAttachFile.do'/>" + "?attcFilId=" + attcFilId + "&seq=" + seq;
            attcForm.submit();
        };
        
        //데이터 셋팅
        yldItmNm.setValue(lvRecord.yldItmNm);     //산출물명 
        yldItmTxt.setValue(lvRecord.yldItmTxt);   //산출물내용 
        kwdTxt.setValue(lvRecord.kwdTxt);         //키워드 
        attcFilId.setValue(lvRecord.attcFilId);   //첨부파일 
        
        disableFields();
        
        if(stringNullChk(lvAttcFilId) != "") getAttachFileList();
    });
</script>
</head>
<body>
<div id="aFormDiv">
    <form name="attcForm" id="attcForm" method="post" style="padding: 20px 1px 0 0;">
        <div class="LblockMainBody">
	        <input type="hidden" id="attcFilId">
	        <table class="table table_txt_right">
	            <colgroup>
	                <col style="width: 100px;" />
	                <col style="width: *" />
	                <col style="width: 150px;" />
	            </colgroup>
	            <tbody>
	                <tr>
	                    <th align="right">산출물명</th>
	                    <td colspan="2"><input type="text" id="yldItmNm"></td>
	                </tr>
	                <tr>
	                    <th align="right">산출물내용</th>
	                    <td colspan="2"><input type="text" id="yldItmTxt"></td>
	                </tr>
	                <tr>
	                    <th align="right">키워드</th>
	                    <td colspan="2"><input type="text" id="kwdTxt"></td>
	                </tr>
	                <tr>
	                    <th align="right">첨부파일</th>
	                    <td id="attchFileView">&nbsp;</td>
	                    <td><button type="button" class="btn" id="attchFileMngBtn" name="attchFileMngBtn" onclick="window.parent.openYldAttcDialog()">첨부파일등록</button></td>
	                </tr>
	            </tbody>
	        </table>
        </div>
    </form>
</div>
</body>
</html>