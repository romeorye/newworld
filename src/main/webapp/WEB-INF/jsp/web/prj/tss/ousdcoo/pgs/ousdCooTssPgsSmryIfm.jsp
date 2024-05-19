<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*, java.util.*,devonframe.util.NullUtil,devonframe.util.DateUtil"%>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>

<%--
/*
 *************************************************************************
 * $Id      : ousdCooTssPgsSmryIfm.jsp
 * @desc    : 대외협력과제 > 진행 개요 탭 화면
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
<script type="text/javascript">
    var lvTssCd    = window.parent.gvTssCd;     //과제코드
    var lvUserId   = window.parent.gvUserId;    //로그인ID
    var lvPgsCd = window.parent.gvPgsStepCd; //진행코드
    var lvTssSt = window.parent.gvTssSt;     //과제상태
    var lvPageMode = window.parent.gvPageMode;
    
    var pageMode = lvPgsCd == "PG" && lvTssSt == "100" && lvPageMode == "W" ? "W" : "R";
    
    var dataSet;
    var lvAttcFilId;
    
    Rui.onReady(function() {
        /*============================================================================
        =================================    Form     ================================
        ============================================================================*/
/*         //연구과제배경 및 필요성
        surrNcssTxt = new Rui.ui.form.LTextArea({
            applyTo: 'surrNcssTxt',
            editable: false,
            height: 100,
            width: 600
        });
      
        //주요 연구개발 내용 요약
        sbcSmryTxt = new Rui.ui.form.LTextArea({
            applyTo: 'sbcSmryTxt',
            editable: false,
            height: 100,
            width: 600
        });
      
        //목표기술 성과 계획
        oucmPlnTxt = new Rui.ui.form.LTextArea({
            applyTo: 'oucmPlnTxt',
            editable: false,
            height: 100,
            width: 600
        }); */
/*         
        //연구비(억원)
        rsstExp = new Rui.ui.form.LNumberBox({
            applyTo: 'rsstExp',
            width: 200
        });
        
        //계약유형
        cnttTypeCd = new Rui.ui.form.LCombo({
            applyTo: 'cnttTypeCd',
            name: 'cnttTypeCd',
            useEmptyText: true,
            emptyText: '선택',
            url: '<c:url value="/common/code/retrieveCodeListForCache.do?comCd=CNTT_TYPE_CD"/>',
            displayField: 'COM_DTL_NM',
            valueField: 'COM_DTL_CD',
            width: 150
        });
        
        //독점권
        monoCd = new Rui.ui.form.LCombo({
            applyTo: 'monoCd',
            name: 'monoCd',
            useEmptyText: true,
            emptyText: '선택',
            url: '<c:url value="/common/code/retrieveCodeListForCache.do?comCd=COMM_YN"/>',
            displayField: 'COM_DTL_NM',
            valueField: 'COM_DTL_CD',
            width: 150
        });
 */      
/*         //연구비 지급조건
        rsstExpFnshCnd = new Rui.ui.form.LTextArea({
            applyTo: 'rsstExpFnshCnd',
            editable: false,
            height: 100,
            width: 600
        });
      
        //법무팀 검토결과
        rvwRsltTxt = new Rui.ui.form.LTextArea({
            applyTo: 'rvwRsltTxt',
            editable: false,
            height: 100,
            width: 600
        }); */
        
        //Form 비활성화
        disableFields = function() {
            if(pageMode == "W") return;
        };
      

        
        /*============================================================================
        =================================    DataSet     =============================
        ============================================================================*/
        //DataSet
        dataSet = new Rui.data.LJsonDataSet({
            id: 'smryDataSet',
            remainRemoved: true,
            lazyLoad: true,
            fields: [
          	      { id: 'tssCd' }             /*과제코드*/
         		, { id: 'oucmPlnTxt' }        /*목표기술 성과 계획*/
         		, { id: 'rsstExp' }           /*연구비*/
         		, { id: 'cnttTypeCd' }        /*계약유형코드*/
         		, { id: 'monoCd' }            /*독점권코드*/
         		, { id: 'rsstExpFnshCnd' }    /*연구비 지급조건*/
         		, { id: 'rvwRsltTxt' }        /*법무팀 검토결과*/
         		, { id: 'surrNcssTxt' }       /*연구과제 배경 및 필요성*/
         		, { id: 'sbcSmryTxt' }        /*주요 연구개발 내용 요약*/
         		, { id: 'sttsTxt' }           /*지재권 출원현황*/
         		, { id: 'ctqTxt' }            /*핵심 CTQ/ 품질 수준*/
         		, { id: 'effSpheTxt' }        /*파급효과 및 응용분야*/
         		, { id: 'fnoPlnTxt' }         /*결론 및 향후 계획*/
         		, { id: 'altrRson' }          /*변경사유*/
         		, { id: 'addRson' }           /*추가사유*/
         		, { id: 'dcacRson' }          /*중단사유*/
         		, { id: 'attcFilId' }         /*첨부파일ID*/
         		, { id: 'userId' }
         		, { id: 'cnttTypeNm' }        /*계약유형명*/
         		, { id: 'monoNm' }            /*독점권명*/
         		, { id: 'rsstExpConvertMil', defaultValue: 0 } /*연구비(억원)*/
            ]
        });
        dataSet.on('load', function(e) {
            console.log("smry load DataSet Success");
            
            lvAttcFilId = dataSet.getNameValue(0, "attcFilId");
            if(!Rui.isEmpty(lvAttcFilId)) getAttachFileList();
            
            document.getElementById("rsstExpFnshCnd").innerHTML = dataSet.getNameValue(0, "rsstExpFnshCnd").replace(/\n/g, "<br/>");
            document.getElementById("rvwRsltTxt").innerHTML = dataSet.getNameValue(0, "rvwRsltTxt").replace(/\n/g, "<br/>");
        });
        
        //폼에 출력 
        var bind = new Rui.data.LBind({
            groupId: 'smryFormDiv',
            dataSet: dataSet,
            bind: true,
            bindInfo: [
//                  { id: 'tssCd',              ctrlId: 'tssCd',           value: 'value' }
                  { id: 'oucmPlnTxt',         ctrlId: 'oucmPlnTxt',      value: 'html' }
//                , { id: 'rsstExp',            ctrlId: 'rsstExp',         value: 'html' }
                , { id: 'rsstExpConvertMil',    ctrlId: 'rsstExp',         value: 'html' }
//                , { id: 'cnttTypeCd',         ctrlId: 'cnttTypeCd',      value: 'value' }
//                , { id: 'monoCd',             ctrlId: 'monoCd',          value: 'value' }
//                 , { id: 'rsstExpFnshCnd',     ctrlId: 'rsstExpFnshCnd',  value: 'html' }
//                 , { id: 'rvwRsltTxt',         ctrlId: 'rvwRsltTxt',      value: 'html' }
                , { id: 'surrNcssTxt',        ctrlId: 'surrNcssTxt',     value: 'html' }
                , { id: 'sbcSmryTxt',         ctrlId: 'sbcSmryTxt',      value: 'html' }
//                , { id: 'sttsTxt',            ctrlId: 'sttsTxt',         value: 'value' }
//                , { id: 'ctqTxt',             ctrlId: 'ctqTxt',          value: 'value' }
//                , { id: 'effSpheTxt',         ctrlId: 'effSpheTxt',      value: 'value' }
//                , { id: 'fnoPlnTxt',          ctrlId: 'fnoPlnTxt',       value: 'value' }
//                , { id: 'altrRson',           ctrlId: 'altrRson',        value: 'value' }
//                , { id: 'addRson',            ctrlId: 'addRson',         value: 'value' }
//                , { id: 'dcacRson',           ctrlId: 'dcacRson',        value: 'value' }
//                , { id: 'attcFilId',          ctrlId: 'attcFilId',       value: 'value' }
//                , { id: 'userId',             ctrlId: 'userId',          value: 'value' }
                , { id: 'cnttTypeNm',         ctrlId: 'cnttTypeNm',      value: 'html' }
                , { id: 'monoNm',             ctrlId: 'monoNm',          value: 'html' }
            ]
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
            
            initFrameSetHeight();
        };
        
        downloadAttachFile = function(attcFilId, seq) {
            smryForm.action = "<c:url value='/system/attach/downloadAttachFile.do'/>" + "?attcFilId=" + attcFilId + "&seq=" + seq;
            smryForm.submit();
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
            dataSet.loadData(${result});
        } else {
            dataSet.newRecord();
        }
    });
    
    // 내부 스크롤 제거
    $(window).load(function() {
    	setTimeout(function () {
    		initFrameSetHeight('smryFormDiv');
    	}, 100);
    });
</script>
</head>
<body>
<div id="smryFormDiv">
    <form name="smryForm" id="smryForm" method="post" style="padding: 20px 1px 0 0;">
        <input type="hidden" id="tssCd"  name="tssCd"  value=""> <!-- 과제코드 -->
        <input type="hidden" id="userId" name="userId" value=""> <!-- 사용자ID -->
        
        <table class="table table_txt_right">
            <colgroup>
                <col style="width: 16%;" />
                <col style="width: 34%;" />
                <col style="width: 15%;" />
                <col style="width: 35%;" />
            </colgroup>
            <tbody>
                <tr>
                    <th align="right">연구과제배경 및 필요성</th>
                    <td colspan="3"><span id="surrNcssTxt" name="surrNcssTxt"></span></td>
                </tr>
                <tr>
                    <th align="right">주요 연구개발 내용 요약</th>
                    <td colspan="3"><span id="sbcSmryTxt" name="sbcSmryTxt"></span></td>
                </tr>
                <tr>
                    <th align="right">목표기술 성과 계획</th>
                    <td colspan="3"><span id="oucmPlnTxt" name="oucmPlnTxt"></span></td>
                </tr>
                <tr>
                    <th align="right">연구비 (억원)</th>
                    <td><span id="rsstExp" name="rsstExp"></span></td>
                    <th align="right">계약유형</th>
                    <td><span id="cnttTypeNm" name="cnttTypeNm"></span></td>
                </tr>
                <tr>
                    <th align="right">독점권</th>
                    <td colspan="3"><span id="monoNm" name="monoNm"></span></td>
                </tr>
                <tr>
                    <th align="right">연구비 지급조건</th>
                    <td colspan="3"><span id="rsstExpFnshCnd" name="rsstExpFnshCnd"></span></td>
                </tr>
                <tr>
                     <th align="right">법무팀 검토결과</th>
                    <td colspan="3"><span id="rvwRsltTxt"></span></td>
                </tr>
                <tr>
                    <th align="right">첨부파일<br/>(심의파일, 회의록 필수 첨부)</th>
                    <td colspan="3" id="attchFileView">&nbsp;</td>
                </tr>
            </tbody>
        </table>
        
    </form>
  <!--   <div class="titArea">
	    <div class="LblockButton">
	        <button type="button" id="btnList" name="btnList">목록</button>
	    </div>
	</div> -->
</div>
</body>
</html>