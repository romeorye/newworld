<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*, java.util.*,devonframe.util.NullUtil,devonframe.util.DateUtil"%>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>

<%--
/*
/*
 *************************************************************************
 * $Id      : ousdCooTssAltrIfm.jsp
 * @desc    : 대외협력과제 > 변경개요
              진행-GRS(변경) or 변경상태인 경우 진입
 *------------------------------------------------------------------------
 * VER  DATE        AUTHOR      DESCRIPTION
 * ---  ----------- ----------  -----------------------------------------
 * 1.0  2017.09.25  IRIS04		최초생성
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
    var lvTssCd  = window.parent.gvTssCd;
    var lvUserId = window.parent.gvUserId;
    var lvTssSt  = window.parent.gvTssSt;
    var lvPageMode = window.parent.gvPageMode;
    
    var pageMode = (lvTssSt == "100" || lvTssSt == "") && (lvPageMode == "W" || lvPageMode == "") ? "W" : "R";
    
    var dataSet1;
    var dataSet2;
    var vm1;
    var vm2;
    var lvAttcFilId;
    
    Rui.onReady(function() {
        /*============================================================================
        =================================    Form     ================================
        ============================================================================*/
        //변경사유
        altrRsonTxt = new Rui.ui.form.LTextArea({
            applyTo: 'altrRsonTxt',
            height: 80,
            width: 600
        });
      
        //추가사유
        addRsonTxt = new Rui.ui.form.LTextArea({
            applyTo: 'addRsonTxt',
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
        dataSet1 = new Rui.data.LJsonDataSet({
            id: 'smryDataSet',
            remainRemoved: true,
            lazyLoad: true,
            fields: [
                  { id: 'tssCd' }         //과제코드
                , { id: 'userId' }        //로그인ID
                , { id: 'altrRson' }      //변경사유
                , { id: 'addRson' }       //추가사유
                , { id: 'attcFilId' }     //첨부파일
                , { id: 'altrAttcFilId' } //변경첨부파일
            ]
        });
        dataSet1.on('load', function(e) {
            
            disableFields();

            dataSet2.load({
                url: '<c:url value="/prj/tss/ousdcoo/retrieveOusdCooTssAltrSmryList.do"/>',
                params :{
                    tssCd : lvTssCd
                }
            });
            
            lvAttcFilId = stringNullChk(dataSet1.getNameValue(0, "altrAttcFilId"));
            if(lvAttcFilId != "") getAttachFileList();
        });
        
        //폼에 출력 
        var bind = new Rui.data.LBind({
            groupId: 'aFormDiv',
            dataSet: dataSet1,
            bind: true,
            bindInfo: [
                  { id: 'tssCd',       ctrlId: 'tssCd',       value: 'value' }
                , { id: 'userId',      ctrlId: 'userId',      value: 'value' }
                , { id: 'altrRson',    ctrlId: 'altrRsonTxt', value: 'value' }
                , { id: 'addRson',     ctrlId: 'addRsonTxt',  value: 'value' }
            ]
        });
        
        //유효성 설정
        vm1 = new Rui.validate.LValidatorManager({
            validators: [  
                { id: 'altrRson', validExp: '변경사유:true' }
            ]
        });  
        
        //DataSet 설정 
        dataSet2 = new Rui.data.LJsonDataSet({
            id: 'altrDataSet',
            remainRemoved: true,
            lazyLoad: true,
            fields: [
                  { id: 'tssCd' }   //과제코드
                , { id: 'userId' }  //로그인ID
                , { id: 'altrSn' }  //변경일련번호
                , { id: 'prvs' }    //항목
                , { id: 'altrPre' } //변경전
                , { id: 'altrAft' } //변경후
            ]
        });
        dataSet2.on('load', function(e) {
            console.log("altr load DataSet Success");
        });
        
        
        //유효성 설정
        vm2 = new Rui.validate.LValidatorManager({
            validators: [  
                { id: 'prvs', validExp: '항목:true' }
            ]
        });  
        
        //그리드
        var columnModel = new Rui.ui.grid.LColumnModel({
            autoWidth: true,
            columns: [
                  new Rui.ui.grid.LSelectionColumn()
                , new Rui.ui.grid.LStateColumn()
                , new Rui.ui.grid.LNumberColumn()
                , { field: 'prvs', label: '항목', sortable: false, align:'left', width: 150, editor: new Rui.ui.form.LTextBox() }
                , { field: 'altrPre', label: '변경전', sortable: false, align:'left', width: 300, editor: new Rui.ui.form.LTextBox() }
                , { field: 'altrAft', label: '변경후', sortable: false, align:'left', width: 300, editor: new Rui.ui.form.LTextBox() }
            ]
        });
        
        var grid = new Rui.ui.grid.LGridPanel({
            columnModel: columnModel,
            dataSet: dataSet2,
            width: 600,
            height: 308,
            autoToEdit: true,
            clickToEdit: true,
            enterToEdit: true,
            autoWidth: true,
            autoHeight: true,
            multiLineEditor: true,
            useRightActionMenu: false
        });
        grid.render('defaultGrid');

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
                dataSet1.setNameValue(0, "altrAttcFilId", lvAttcFilId)
            }
            
            initFrameSetHeight();
        };
        
        downloadAttachFile = function(attcFilId, seq) {
            aForm.action = "<c:url value='/system/attach/downloadAttachFile.do'/>" + "?attcFilId=" + attcFilId + "&seq=" + seq;
            aForm.submit();
        };
        
        
        //추가
        var butRecordNew = new Rui.ui.LButton('butRecordNew');
        butRecordNew.on('click', function() {
            var record = dataSet2.createRecord({tssCd: lvTssCd, userId: lvUserId});
            dataSet2.add(record);
        });
        
        
        //삭제
        var butRecordDel = new Rui.ui.LButton('butRecordDel');
        butRecordDel.on('click', function() {                
            if(dataSet2.getMarkedCount() > 0) {
                dataSet2.removeMarkedRows();
            } else {
                var row = dataSet2.getRow();
                if(row < 0) return;
                
                dataSet2.removeAt(row);
            }
        });
        
        //저장
        var btnSave = new Rui.ui.LButton('btnSave');
        btnSave.on('click', function() {
            window.parent.fnSave1();
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
            dataSet1.loadData(${result}); 
        } else {
            dataSet1.newRecord();
        }
        
        disableFields();
        
        if("<c:out value='${inputData._roleId}'/>".indexOf('WORK_IRI_T15') > -1) {
        	$("#btnSave").hide();
    	}else if("<c:out value='${inputData._roleId}'/>".indexOf('WORK_IRI_T16') > -1) {
        	$("#btnSave").hide();
		}
    });
    
    
    function fnIfmIsUpdate(gbn) {
        if(!vm1.validateGroup("aForm")) { 
             Rui.alert(Rui.getMessageManager().get('$.base.msg052') + '<br>' + vm1.getMessageList().join('<br>'));
             return false;
        }
        
        if(!vm2.validateDataSet(dataSet2, dataSet2.getRow())) { 
             Rui.alert(Rui.getMessageManager().get('$.base.msg052') + '<br>' + vm2.getMessageList().join('<br>'));
             return false;
        }
        
        if(gbn == "SAVE") {
            if(dataSet2.getCount() <= 0) {
                Rui.alert("변경 개요 항목을 추가해주시기 바랍니다.");
                return false;
            }
        } else {
        	console.log(dataSet1.isUpdated());
        	console.log(dataSet2.isUpdated());
        	
            if(dataSet1.isUpdated() || dataSet2.isUpdated()) {
                Rui.alert("개요 저장을 먼저 해주시기 바랍니다.");
                return false;
            }
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
<div class="titArea">
    <div class="LblockButton">
        <button type="button" id="butRecordNew">추가</button>
        <button type="button" id="butRecordDel">삭제</button>
    </div>
</div>
<div id="defaultGrid"></div>
<div id="aFormDiv">
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
                    <th align="right">변경사유</th>
                    <td colspan="2">
                        <input type="text" id="altrRsonTxt" />
                    </td>
                </tr>
                <tr>
                    <td align="left" colspan="3">* 기타 변경사항은 아래 추가내용란에 입력하시기 바랍니다.</td>
                </tr>
                <tr>
                    <th align="right">추가사유</th>
                    <td colspan="2">
                        <input type="text" id="addRsonTxt" />
                    </td>
                </tr>
                <tr>
                    <th align="right">첨부파일</th>
                    <td id="attchFileView">&nbsp;</td>
                    <td><button type="button" class="btn" id="attchFileMngBtn" name="attchFileMngBtn" onclick="openAttachFileDialog(setAttachFileInfo, getAttachFileId(), 'prjPolicy', '*')">첨부파일등록</button></td>
                </tr>
            </tbody>
        </table>
    </form>
</div>
<div class="titArea">
    <div class="LblockButton">
        <button type="button" id="btnSave" name="btnSave">저장</button>
        <!-- <button type="button" id="btnList" name="btnList">목록</button> -->
    </div>
</div>
</body>
</html>