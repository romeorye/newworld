<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*, java.util.*,devonframe.util.NullUtil,devonframe.util.DateUtil"%>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>

<%--
/*
 *************************************************************************
 * $Id      : ousdCooTssCmplIfm.jsp
 * @desc    : 대외협력과제 > 완료 개요 탭
              진행-GRS(완료) or 완료상태인 경우 진입
 *------------------------------------------------------------------------
 * VER  DATE        AUTHOR      DESCRIPTION
 * ---  ----------- ----------  -----------------------------------------
 * 1.0  2017.09.21  IRIS04		최초생성
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
    var lvTssCd  = window.parent.cmplTssCd;
    var lvUserId = window.parent.gvUserId;
    var lvPageMode = window.parent.gvPageMode;
    var lvTssSt    = window.parent.gvTssSt;
    
    var pageMode = (lvTssSt == "100" || lvTssSt == "") && lvPageMode == "W" ? "W" : "R";
    
    var dataSet;
    var lvAttcFilId;
    var tmpAttchFileList;
    
    Rui.onReady(function() {
        /*============================================================================
        =================================    Form     ================================
        ============================================================================*/
        //과제개요_연구과제배경
        ltaSurrNcssTxt = new Rui.ui.form.LTextArea({
            applyTo: 'iptSurrNcssTxt',
            height: 80,
            width: 600
        });
      
        //과제개요_주요연구개발내용
        ltaSbcSmryTxt = new Rui.ui.form.LTextArea({
            applyTo: 'iptSbcSmryTxt',
            height: 80,
            width: 600
        });
      
        //연구개발성과_지재권
        ltaSttsTxt = new Rui.ui.form.LTextArea({
            applyTo: 'iptSttsTxt',
            height: 80,
            width: 600
        });
      
        //연구개발성과_CTQ
        ltaCtqTxt = new Rui.ui.form.LTextArea({
            applyTo: 'iptCtqTxt',
            height: 80,
            width: 600
        });
      
        //연구개발성과_파급효과
        ltaEffSpheTxt = new Rui.ui.form.LTextArea({
            applyTo: 'iptEffSpheTxt',
            height: 80,
            width: 600
        });
      
        //향후 계획
        ltaFnoPlnTxt = new Rui.ui.form.LTextArea({
            applyTo: 'iptFnoPlnTxt',
            height: 80,
            width: 600
        });
        
        //Form 비활성화
        disableFields = function() {
            Rui.select('.tssLableCss input').addClass('L-tssLable');
            Rui.select('.tssLableCss div').addClass('L-tssLable');
            
            if(pageMode == "W") return;
            
            btnSave.hide();
        };

        /*============================================================================
        =================================    DataSet     =============================
        ============================================================================*/
        //DataSet 설정 
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
         		
         		// 추가 데이터셋
         		, { id: 'userId' }
                , { id: 'cmplAttcFilId' }       //첨부파일
            ]
        });
        dataSet.on('load', function(e) {
            
            lvAttcFilId = stringNullChk(dataSet.getNameValue(0, "cmplAttcFilId"));
            if(lvAttcFilId != "") getAttachFileList();
        });
        
        //폼에 출력 
        var bind = new Rui.data.LBind({
            groupId: 'aFormDiv',
            dataSet: dataSet,
            bind: true,
            bindInfo: [
                  { id: 'tssCd',              ctrlId: 'tssCd',                 value: 'value' }
                , { id: 'userId',             ctrlId: 'userId',                value: 'value' }
	         	, { id: 'surrNcssTxt',        ctrlId: 'iptSurrNcssTxt',        value: 'value' }       /*연구과제 배경 및 필요성*/
	         	, { id: 'sbcSmryTxt',         ctrlId: 'iptSbcSmryTxt',         value: 'value' }       /*주요 연구개발 내용 요약*/
	         	, { id: 'sttsTxt',            ctrlId: 'iptSttsTxt',            value: 'value' }       /*지재권 출원현황*/
	         	, { id: 'ctqTxt',             ctrlId: 'iptCtqTxt',             value: 'value' }       /*핵심 CTQ/ 품질 수준*/
	         	, { id: 'effSpheTxt',         ctrlId: 'iptEffSpheTxt',         value: 'value' }       /*파급효과 및 응용분야*/
	         	, { id: 'fnoPlnTxt',          ctrlId: 'iptFnoPlnTxt',          value: 'value' }       /*결론 및 향후 계획*/
	         	, { id: 'cmplAttcFilId',      ctrlId: 'iptAttcFilId',          value: 'value' }       /*첨부파일ID*/
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
                dataSet.setNameValue(0, "cmplAttcFilId", lvAttcFilId)
                
                tmpAttchFileList = attachFileList;
            }
            
            initFrameSetHeight();
        };
        
        downloadAttachFile = function(attcFilId, seq) {
            aForm.action = "<c:url value='/system/attach/downloadAttachFile.do'/>" + "?attcFilId=" + attcFilId + "&seq=" + seq;
            aForm.submit();
        };
        
        
        //저장
        var btnSave = new Rui.ui.LButton('btnSave');
        btnSave.on('click', function() {
        	window.parent.fnSave();
        });
        
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
        
        disableFields();
        
        if("<c:out value='${inputData._roleId}'/>".indexOf('WORK_IRI_T15') > -1) {
        	$("#btnSave").hide();
        	document.getElementById('attchFileMngBtn').style.display = "none";
    	}else if("<c:out value='${inputData._roleId}'/>".indexOf('WORK_IRI_T16') > -1) {
        	$("#btnSave").hide();
        	document.getElementById('attchFileMngBtn').style.display = "none";
		}
    });
    
    function fnAttchValid(){
    	var chkNum = 0;

    	for(var i = 0; i < tmpAttchFileList.length; i++) {
    		if( tmpAttchFileList[i].data.filNm.indexOf('완료') > -1 || tmpAttchFileList[i].data.filNm.indexOf('결과') > -1 || tmpAttchFileList[i].data.filNm.indexOf('최종') > -1 ){
				chkNum++;    
			}               
        }
		return chkNum;
    }
    
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
    <form name="aForm" id="aForm" method="post" style="padding: 20px 1px 0 0;">
        <input type="hidden" id="tssCd"  name="tssCd"  value=""> <!-- 과제코드 -->
        <input type="hidden" id="userId" name="userId" value=""> <!-- 사용자ID -->
        
        <table class="table table_txt_right">
            <colgroup>
                <col style="width: 15%;" />
                <col style="width: 70%;" />
                <col style="width: *;" />
            </colgroup>
            <tbody>
                <tr>
                    <th align="right">과제개요</th>
                    <td colspan="2">
                        <table width="100%">
                            <colgroup>
                                 <col style="width: 20%;" />
                                <col style="width: 80%;" />
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th align="right">연구과제 배경<br/>및 필요성</th>
                                    <td><input type="text" id="iptSurrNcssTxt" /></td>
                                </tr>
                                <tr>
                                    <th align="right">주요 연구<br/>개발 내용</th>
                                    <td><input type="text" id="iptSbcSmryTxt" /></td>
                                </tr>
                            </tbody>
                        </table>
                    </td>
                </tr>
                <tr>
                    <th align="right">연구개발성과</th>
                    <td colspan="2">
                        <table width="100%">
                            <colgroup>
                                <col style="width: 10%;" />
                                <col style="width: 10%;" />
                                <col style="width: 80%;" />
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th align="right">지적 재산권</th>
                                    <th align="right">지재권<br/>출원현황<br/>(국내/해외)</th>
                                    <td><input type="text" id="iptSttsTxt" /></td>
                                </tr>
                                <tr>
                                    <th align="right">목표 기술성과</th>
                                    <th align="right">핵심 CTQ/<br/>품질 수준<br/>(경쟁사 비교)</th>
                                    <td><input type="text" id="iptCtqTxt" /></td>
                                </tr>
                                <tr>
                                    <th align="right" colspan="2">파급효과 및 응용분야</th>
                                    <td><input type="text" id="iptEffSpheTxt" /></td>
                                </tr>
                            </tbody>
                        </table>
                    </td>
                </tr>
                <tr>
                    <th align="right">향후 계획</th>
                    <td colspan="2">
                    	<table width="100%">
                            <colgroup>
                                <col style="width: 20%;" />
                                <col style="width: 80%;" />
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th align="right">결론 및 향후 계획</th>
                                    <td><input type="text" id="iptFnoPlnTxt" /></td>
                                </tr>
                            </tbody>
                        </table>
                    </td>
                </tr>
                <tr>
                    <th align="right">과제완료보고서 및 기타</th>
                    <td id="attchFileView" style="width:160px;">&nbsp;</td>
                    <td><button type="button" class="btn" id="attchFileMngBtn" name="attchFileMngBtn" onclick="openAttachFileDialog(setAttachFileInfo, getAttachFileId(), 'prjPolicy', '*')">첨부파일등록</button></td>
                </tr>
            </tbody>
        </table>
    </form>
</div>
<div class="titArea btn_btm">
<div><font color="red">첨부 : 과제완료보고서(협력기관 작성파일), 심의보고서(ppt), 심의회의록</font></div>
    <div class="LblockButton">
        <button type="button" id="btnSave" name="btnSave">저장</button>
        <!-- <button type="button" id="btnList" name="btnList">목록</button> -->
    </div>
</div>
</body>
</html>