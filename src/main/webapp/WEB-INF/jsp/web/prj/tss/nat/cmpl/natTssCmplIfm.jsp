<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*, java.util.*,devonframe.util.NullUtil,devonframe.util.DateUtil"%>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>

<%--
/*
 *************************************************************************
 * $Id      : natTssCmplIfm.jsp
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
<style>
 .L-tssLable {
 border: 0px
 }
</style>
<%
    response.setHeader("Pragma", "No-cache");
    response.setDateHeader("Expires", 0);
    response.setHeader("Cache-Control", "no-cache");
%>
<script type="text/javascript">
    var lvTssCd    = window.parent.cmplTssCd;
    var lvUserId   = window.parent.gvUserId;
    var lvTssSt    = window.parent.gvTssSt;
    var lvTssNosSt = stringNullChk(window.parent.gvTssNosSt);
   
    var lvPageMode = window.parent.gvPageMode;
    
    var pageMode = (lvTssSt == "100" || lvTssSt == "") && lvPageMode == "W" ? "W" : "R";
    
    var dataSet;
    var lvAttcFilId;
    var lvIsSave = false;
    
 
    
    Rui.onReady(function() {
        /*============================================================================
        =================================    Form     ================================
        ============================================================================*/
        //과제개요
        tssSmryTxt = new Rui.ui.form.LTextArea({
            applyTo: 'tssSmryTxt',
            height: 80,
            width: 600
        });
      
        //연구개발성과
        rsstDvlpOucmTxt = new Rui.ui.form.LTextArea({
            applyTo: 'rsstDvlpOucmTxt',
            height: 80,
            width: 600
        });
        
        //향후 계획
        fnoPlnTxt = new Rui.ui.form.LTextArea({
            applyTo: 'fnoPlnTxt',
            height: 80,
            width: 600
        });
        
        //사업비실적
        bizExpArslTxt = new Rui.ui.form.LTextArea({
            applyTo: 'bizExpArslTxt',
            height: 80,
            width: 600
        });
        //정산 비고
        remTxt = new Rui.ui.form.LTextArea({
            applyTo: 'remTxt',
            height: 100,
            width: 600
        });
        
        //Form 비활성화
        disableFields = function() {
            Rui.select('.tssLableCss input').addClass('L-tssLable');
            Rui.select('.tssLableCss div').addClass('L-tssLable');
            
            if(pageMode == "W") return;

            btnSave.hide();

            document.getElementById('attchFileMngBtn').style.display = "none";
            
            if(lvTssSt=="503" || lvTssSt=="504") {
            	document.getElementById('tr1').style.display = "";
			}
                
            
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
                  { id: 'tssCd' }           //과제코드
                , { id: 'userId' }          //로그인ID
                , { id: 'pgTssCd' }         //진행단계과제코드
                , { id: 'tssSmryTxt' }      //과제개요
                , { id: 'rsstDvlpOucmTxt' } //연구개발성과
                , { id: 'fnoPlnTxt' }       //향후 계획
                , { id: 'bizExpArslTxt' }   //사업비실적
                , { id: 'attcFilId' }       //첨부파일
                , { id: 'cmplAttcFilId' }   //첨부파일
                , { id: 'finYn' }           //최종차수여부
                , { id: 'remTxt' }           //정산비고
                , { id: 'tssNosSt' }             //과제차수
            ]
        });
        dataSet.on('load', function(e) {
            console.log("smry load DataSet Success");
            
            lvAttcFilId = stringNullChk(dataSet.getNameValue(0, "cmplAttcFilId"));
            if(lvAttcFilId != "") getAttachFileList();
            
            lvIsSave = true;
        });
        
        
        //폼에 출력 
        var bind = new Rui.data.LBind({
            groupId: 'aFormDiv',
            dataSet: dataSet,
            bind: true,
            bindInfo: [
                  { id: 'tssCd',           ctrlId: 'tssCd',           value: 'value' }
                , { id: 'userId',          ctrlId: 'userId',          value: 'value' }
                , { id: 'tssSmryTxt',      ctrlId: 'tssSmryTxt',      value: 'value' }
                , { id: 'rsstDvlpOucmTxt', ctrlId: 'rsstDvlpOucmTxt', value: 'value' }
                , { id: 'fnoPlnTxt',       ctrlId: 'fnoPlnTxt',       value: 'value' }
                , { id: 'bizExpArslTxt',   ctrlId: 'bizExpArslTxt',   value: 'value' }
                , { id: 'remTxt',  		   ctrlId: 'remTxt',   value: 'value' }
            ]
        });
        
        
        //유효성
        vm = new Rui.validate.LValidatorManager({
            validators: [  
                  { id: 'tssCd',             validExp: '과제코드:false' }
                , { id: 'userId',            validExp: '로그인ID:false' }
                , { id: 'pgTssCd',           validExp: '진행단계과제코드:false' }
                , { id: 'tssSmryTxt',        validExp: '과제개요:true' }
                , { id: 'rsstDvlpOucmTxt',   validExp: '연구개발성과:false' }
                , { id: 'fnoPlnTxt',         validExp: '향후 계획:false' }
                , { id: 'bizExpArslTxt',     validExp: '사업비실적:false' }
                , { id: 'attcFilId',         validExp: '첨부파일:false' }
                , { id: 'cmplAttcFilId',     validExp: '첨부파일:false' }
                , { id: 'finYn',             validExp: '최종차수여부:false' }
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
                dataSet.setNameValue(0, "cmplAttcFilId", lvAttcFilId);
                dataSet.setNameValue(0, "attcFilId", lvAttcFilId);
                initFrameSetHeight();
            }
        };
        
        downloadAttachFile = function(attcFilId, seq) {
            aForm.action = "<c:url value='/system/attach/downloadAttachFile.do'/>" + "?attcFilId=" + attcFilId + "&seq=" + seq;
            aForm.submit();
        };
        
        
        //저장
        var btnSave = new Rui.ui.LButton('btnSave');
        btnSave.on('click', function() {
            dataSet.setNameValue(0, "tssNosSt", lvTssNosSt);
            window.parent.fnSave();
        });
        
        
        //목록
        /* var btnList = new Rui.ui.LButton('btnList');
        btnList.on('click', function() {                
            nwinsActSubmit(window.parent.document.mstForm, "<c:url value='/prj/tss/nat/natTssList.do'/>");
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
        //parentBtn(); >>>>????
        		
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
        
        return true;
    }
</script>
<script type="text/javascript">
$(window).load(function() {
    initFrameSetHeight("aFormDiv");
}); 
</script>
</head>
<body>
<div id="aFormDiv">
    <form name="aForm" id="aForm" method="post" style="padding: 20px 1px 0px 0;">
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
                    <th rowspan="2">과제개요</th>
                    <td colspan="2"><input type="text" id="tssSmryTxt" /></td>
                </tr>
                <tr>
                    <td colspan="2">개발 대상 기술, 제품 개요 및 주요 연구 개발 내용</td>
                </tr>
                <tr>
                    <th rowspan="2">연구개발성과</th>
                    <td colspan="2"><input type="text" id="rsstDvlpOucmTxt" /></td>
                </tr>
                <tr>
                    <td colspan="2">지재권 출원현황 (국내/해외) 및 품질 수준 (경쟁사 비교)</td>
                </tr>
                <tr>
                    <th rowspan="2">향후 계획</th>
                    <td colspan="2"><input type="text" id="fnoPlnTxt" /></td>
                </tr>
                <tr>
                    <td colspan="2">결론 및 향후 계획</td>
                </tr>
                <tr>
                    <th rowspan="2">사업비 실적</th>
                    <td colspan="2"><input type="text" id="bizExpArslTxt" /></td>
                </tr>
                <tr>
                    <td colspan="2">특이사항</td>
                </tr>
                <tr>
                    <th>과제완료보고서 및 기타</th>
                    <td id="attchFileView">&nbsp;</td>
                    <td><button type="button" class="btn" id="attchFileMngBtn" name="attchFileMngBtn" onclick="openAttachFileDialog(setAttachFileInfo, getAttachFileId(), 'prjPolicy', '*')">첨부파일등록</button></td>
                </tr>
                <tr id="tr1" style="display:none">
                    <th>정산 비고</th>
                    <td colspan="2"><input type="text" id="remTxt" /></td>
                </tr>
            </tbody>
        </table>
    </form>
	<div class="titArea">
	    <div class="LblockButton">
	        <button type="button" id="btnSave" name="btnSave">저장</button>
	        <!-- <button type="button" id="btnList" name="btnList">목록</button> -->
	    </div>
	</div>
</div>
</body>
</html>