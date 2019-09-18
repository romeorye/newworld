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
        //과제개요_연구과제배경
        surrNcssTxt = new Rui.ui.form.LTextArea({
            applyTo: 'surrNcssTxt',
            height: 80,
            width: 600
        });
        
        //연구개발성과_CTQ
        ctqTxt = new Rui.ui.form.LTextArea({
            applyTo: 'ctqTxt',
            height: 80,
            width: 600
        });
      
        //과제개요_주요연구개발내용
        sbcSmryTxt = new Rui.ui.form.LTextArea({
            applyTo: 'sbcSmryTxt',
            height: 80,
            width: 600
        });
      
        //연구개발성과_지재권
        sttsTxt = new Rui.ui.form.LTextArea({
            applyTo: 'sttsTxt',
            height: 80,
            width: 600
        });
      
        //연구개발성과_파급효과
        effSpheTxt = new Rui.ui.form.LTextArea({
            applyTo: 'effSpheTxt',
            height: 80,
            width: 600
        });

        //향후 계획
        fnoPlnTxt = new Rui.ui.form.LTextArea({
            applyTo: 'fnoPlnTxt',
            height: 80,
            width: 600
        });

        //중단사유
        dcacRson = new Rui.ui.form.LTextArea({
            applyTo: 'dcacRson',
            height: 80,
            width: 905
        });       
        
        //Form 비활성화
        disableFields = function() {
//            Rui.select('.tssLableCss input').addClass('L-tssLable');
//            Rui.select('.tssLableCss div').addClass('L-tssLable');
            
            if(pageMode == "W") return;
            
            btnSave.hide();
            
            document.getElementById('attchFileMngBtn').style.display = "none";
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
         		, { id: 'surrNcssTxt' }       /*연구과제 배경 및 필요성*/
         		, { id: 'sbcSmryTxt' }        /*주요 연구개발 내용 요약*/
         		, { id: 'sttsTxt' }           /*지재권 출원현황*/
         		, { id: 'ctqTxt' }            /*핵심 CTQ/ 품질 수준*/
         		, { id: 'effSpheTxt' }        /*파급효과 및 응용분야*/
         		, { id: 'fnoPlnTxt' }         /*결론 및 향후 계획*/
         		, { id: 'dcacRson' }          /*중단사유*/
         		, { id: 'dcacAttcFilId' }     /*중단첨부파일ID*/
         		, { id: 'userId' }
            ]
        });
        dataSet.on('load', function(e) {
            
            lvAttcFilId = stringNullChk(dataSet.getNameValue(0, "dcacAttcFilId"));
            if(lvAttcFilId != "") getAttachFileList();
        });
        
        //폼에 출력 
        var bind = new Rui.data.LBind({
            groupId: 'aFormDiv',
            dataSet: dataSet,
            bind: true,
            bindInfo: [
                  { id: 'tssCd',           ctrlId: 'tssCd',           value: 'value' }
                , { id: 'userId',          ctrlId: 'userId',          value: 'value' }
                , { id: 'surrNcssTxt',     ctrlId: 'surrNcssTxt',     value: 'value' }
                , { id: 'sbcSmryTxt',      ctrlId: 'sbcSmryTxt',      value: 'value' }
                , { id: 'sttsTxt',         ctrlId: 'sttsTxt',         value: 'value' }
                , { id: 'ctqTxt',          ctrlId: 'ctqTxt',          value: 'value' }
                , { id: 'effSpheTxt',      ctrlId: 'effSpheTxt',      value: 'value' }
                , { id: 'fnoPlnTxt',       ctrlId: 'fnoPlnTxt',       value: 'value' }
                , { id: 'dcacRson',        ctrlId: 'dcacRson',        value: 'value' }
            ]
        });
        
        //유효성 설정
        vm = new Rui.validate.LValidatorManager({
            validators: [  
                  { id: 'tssCd',              validExp: '과제코드:false' }
                , { id: 'userId',             validExp: '로그인ID:false' }
                , { id: 'surrNcssTxt',        validExp: '과제 필요성 및 사업기회:false' }
                , { id: 'ctqTxt',             validExp: '핵심 CTQ/품질 수준:false' }
                , { id: 'sbcSmryTxt',         validExp: '주요개발 내용:false' }
                , { id: 'sttsTxt',            validExp: '지재권 출원현황:false' }
                , { id: 'effSpheTxt',         validExp: '파급효과 및 응용분야:false' }
                , { id: 'fnoPlnTxt',          validExp: '향후계획:false' }
                , { id: 'dcacRson',           validExp: '중단사유:false' }
                , { id: 'dcacAttcFilId',      validExp: '첨부파일:false' }
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
                dataSet.setNameValue(0, "dcacAttcFilId", lvAttcFilId)
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
            console.log("smry searchData1");
            dataSet.loadData(${result}); 
        } else {
            console.log("smry searchData2");
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
    
    //validation
    function fnIfmIsUpdate(gbn) {
        if(!vm.validateGroup("aForm")) {            
            Rui.alert(Rui.getMessageManager().get('$.base.msg052') + '<br>' + vm.getMessageList().join('<br>'));
            return false;
        }
       
        if(gbn != "SAVE" && dataSet.isUpdated()) {
           Rui.alert("완료탭 저장을 먼저 해주시기 바랍니다.");
           return false;
        }
        
        return true;
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
	<br>
	
    <form name="aForm" id="aForm" method="post">
        <input type="hidden" id="tssCd"  name="tssCd"  value=""> <!-- 과제코드 -->
        <input type="hidden" id="userId" name="userId" value=""> <!-- 사용자ID -->
        
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
                                    <td><input type="text" id="surrNcssTxt" /></td>
                                </tr>
                                <tr>
                                    <th align="right">개발목표</th>
                                    <th align="right">핵심 CTQ/품질 수준<br/>(경쟁사 비교)</th>
                                    <td><input type="text" id="ctqTxt" /></td>
                                </tr>
                                <tr>
                                    <th align="right" colspan="2">주요개발 내용</th>
                                    <td><input type="text" id="sbcSmryTxt" /></td>
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
                                    <td><input type="text" id="sttsTxt" /></td>
                                </tr>
                                <tr>
                                    <th align="right" colspan="2">파급효과 및 응용분야</th>
                                    <td><input type="text" id="effSpheTxt" /></td>
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
                                    <td><input type="text" id="fnoPlnTxt" /></td>
                                </tr>
                            </tbody>
                        </table>
                    </td>
                </tr>
                <tr>
                    <th align="right">중단 사유</th>
                    <td colspan="2"><input type="text" id="dcacRson" /></td>
                </tr>
                <tr>
                    <th align="right">첨부파일</th>
                    <td id="attchFileView"style="width:600px;">&nbsp;</td>
                    <td><button type="button" class="btn" id="attchFileMngBtn" name="attchFileMngBtn" onclick="openAttachFileDialog(setAttachFileInfo, getAttachFileId(), 'prjPolicy', '*')">첨부파일등록</button></td>
                </tr>
            </tbody>
        </table>
    </form>
</div>
<div class="titArea">
<div><font color="red">첨부 : 과제중단보고서(word파일), 심의보고서(ppt), 심의회의록</font></div>
    <div class="LblockButton">
        <button type="button" id="btnSave" name="btnSave">저장</button>
        <!-- <button type="button" id="btnList" name="btnList">목록</button> -->
    </div>
</div>
</body>
</html>