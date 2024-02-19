<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*, java.util.*,devonframe.util.NullUtil,devonframe.util.DateUtil"%>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>

<%--
/*
 *************************************************************************
 * $Id      :natTssPlnSmryIfm.jsp
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
<%
    response.setHeader("Pragma", "No-cache");
    response.setDateHeader("Expires", 0);
    response.setHeader("Cache-Control", "no-cache");
%>
<script type="text/javascript">
    var lvTssCd     = window.parent.gvTssCd; //Rui.get("tssCd").setValue(window.parent.gvTssCd);
    var lvUserId    = window.parent.gvUserId;
    var lvTssSt     = window.parent.gvTssSt;
    var lvPgsStepCd = stringNullChk(window.parent.gvPgsStepCd);
    var lvTssNosSt  = stringNullChk(window.parent.gvTssNosSt);
    var lvPageMode  = window.parent.gvPageMode;
    var lvPDS       = window.parent.dataSet;
    
    var pageMode = (lvTssSt == "100" || lvTssSt == "302" || lvTssSt == "") && (lvPageMode == "W" || lvPageMode == "") ? "W" : "R";

    var dataSet;
    var smryDataLstSet;
    var lvAttcFilId;

    Rui.onReady(function() {
        /*============================================================================
        =================================    Form     ================================
        ============================================================================*/
        //총과제 시작일
        ttlCrroStrtDt = new Rui.ui.form.LDateBox({
            applyTo: 'ttlCrroStrtDt',
            mask: '9999-99-99',
            width: 100,
            dateType: 'string'
        });
        ttlCrroStrtDt.on('blur', function() {
            fnDateStrtFnhCheck('S', 0);
        });

        //총과제 종료일
        ttlCrroFnhDt = new Rui.ui.form.LDateBox({
            applyTo: 'ttlCrroFnhDt',
            mask: '9999-99-99',
            width: 100,
            dateType: 'string'
        });
        ttlCrroFnhDt.on('blur', function() {
            fnDateStrtFnhCheck('F', 0);
        });

        //1차년도 시작일
        strtDt1 = new Rui.ui.form.LDateBox({
            applyTo: 'strtDt1',
            mask: '9999-99-99',
            width: 100,
            dateType: 'string'
        });
        strtDt1.on('blur', function() {
            fnDateStrtFnhCheck('S', 1);
        });

        //1차년도 종료일
        fnhDt1 = new Rui.ui.form.LDateBox({
            applyTo: 'fnhDt1',
            mask: '9999-99-99',
            width: 100,
            dateType: 'string'
        });
        fnhDt1.on('blur', function() {
            fnDateStrtFnhCheck('F', 1);
        });

        //2차년도 시작일
        strtDt2 = new Rui.ui.form.LDateBox({
            applyTo: 'strtDt2',
            mask: '9999-99-99',
            width: 100,
            dateType: 'string'
        });
        strtDt2.on('blur', function() {
            fnDateFrontCheck(2);
            fnDateStrtFnhCheck('S', 2);
        });

        //2차년도 종료일
        fnhDt2 = new Rui.ui.form.LDateBox({
            applyTo: 'fnhDt2',
            mask: '9999-99-99',
            width: 100,
            dateType: 'string'
        });
        fnhDt2.on('blur', function() {
            fnDateFrontCheck(2);
            fnDateStrtFnhCheck('F', 2);
        });

        //3차년도 시작일
        strtDt3 = new Rui.ui.form.LDateBox({
            applyTo: 'strtDt3',
            mask: '9999-99-99',
            width: 100,
            dateType: 'string'
        });
        strtDt3.on('blur', function() {
            fnDateFrontCheck(3);
            fnDateStrtFnhCheck('S', 3);
        });

        //3차년도 종료일
        fnhDt3 = new Rui.ui.form.LDateBox({
            applyTo: 'fnhDt3',
            mask: '9999-99-99',
            width: 100,
            dateType: 'string'
        });
        fnhDt3.on('blur', function() {
            fnDateFrontCheck(3);
            fnDateStrtFnhCheck('F', 3);
        });

        //4차년도 시작일
        strtDt4 = new Rui.ui.form.LDateBox({
            applyTo: 'strtDt4',
            mask: '9999-99-99',
            width: 100,
            dateType: 'string'
        });
        strtDt4.on('blur', function() {
            fnDateFrontCheck(4);
            fnDateStrtFnhCheck('S', 4);
        });

        //4차년도 종료일
        fnhDt4 = new Rui.ui.form.LDateBox({
            applyTo: 'fnhDt4',
            mask: '9999-99-99',
            width: 100,
            dateType: 'string'
        });
        fnhDt4.on('blur', function() {
            fnDateFrontCheck(4);
            fnDateStrtFnhCheck('F', 4);
        });

        //5차년도 시작일
        strtDt5 = new Rui.ui.form.LDateBox({
            applyTo: 'strtDt5',
            mask: '9999-99-99',
            width: 100,
            dateType: 'string'
        });
        strtDt5.on('blur', function() {
            fnDateFrontCheck(5);
            fnDateStrtFnhCheck('S', 5);
        });

        //5차년도 종료일
        fnhDt5 = new Rui.ui.form.LDateBox({
            applyTo: 'fnhDt5',
            mask: '9999-99-99',
            width: 100,
            dateType: 'string'
        });
        fnhDt5.on('blur', function() {
            fnDateFrontCheck(5);
            fnDateStrtFnhCheck('F', 5);
        });

        //기관유형
        cbYldItmType = new Rui.ui.form.LCombo({
            name: 'cbYldItmType',
            url: '<c:url value="/common/code/retrieveCodeListForCache.do?comCd=INST_TYPE_CD"/>',
            displayField: 'COM_DTL_NM',
            valueField: 'COM_DTL_CD',
            rendererField: 'value',
            listPosition: 'up',
            autoMapping: true
        });
        
        
        //Form 비활성화
        disableFields = function() {
            if(pageMode == "W") return;

            butAdd.hide();
            butDel.hide();
            btnSave.hide();
            
            grid2.setEditable(false);
            
            document.getElementById('attchFileMngBtn').style.display = "none";
        };

        
        
        /*============================================================================
        =================================    DataSet     =============================
        ============================================================================*/
        //DataSet 폼 
        dataSet = new Rui.data.LJsonDataSet({
            id: 'smryDataSet',
            remainRemoved: true,
            lazyLoad: true,
            fields: [
                  { id: 'tssCd' }                //과제코드
                , { id: 'ttlCrroStrtDt' }        //총수행시작일
                , { id: 'ttlCrroFnhDt' }         //총수행종료일
                , { id: 'strtDt1' }              //과제시작일1차
                , { id: 'fnhDt1' }               //과제종료일1차
                , { id: 'strtDt2' }              //과제시작일2차
                , { id: 'fnhDt2' }               //과제종료일2차
                , { id: 'strtDt3' }              //과제시작일3차
                , { id: 'fnhDt3' }               //과제종료일3차
                , { id: 'strtDt4' }              //과제시작일4차
                , { id: 'fnhDt4' }               //과제종료일4차
                , { id: 'strtDt5' }              //과제시작일5차
                , { id: 'fnhDt5' }               //과제종료일5차
                , { id: 'finYn' }                //최종차수여부
                , { id: 'smryTxt' }              //개발대상기술 및 제품개요
                , { id: 'attcFilId' }            //첨부파일ID
                , { id: 'userId' }               //로그인ID
                , { id: 'tssNosSt' }             //과제차수
            ]
        });
        dataSet.on('load', function(e) {
            console.log("smry load DataSet Success");
            
            Wec.SetBodyValue(dataSet.getNameValue(0, "smryTxt"));            
            lvAttcFilId = dataSet.getNameValue(0, "attcFilId");
            if(!Rui.isEmpty(lvAttcFilId)) getAttachFileList();
            
        });
        
        //dataSet 그리드
        smryDataLstSet = new Rui.data.LJsonDataSet({
            id: 'smryInstDataSet',
            remainRemoved: true,
            fields: [
                  { id:'tssCd' }         //과제코드
                , { id:'crroInstSn' }    //수행기관일련번호
                , { id:'instNm' }        //기관명
                , { id:'instTypeCd' }    //기관유형
                , { id:'userId' }        //사용자ID
            ]
        });
        smryDataLstSet.load({   
             url: '<c:url value="/prj/grs/retrieveSmryCrroInstList.do"/>',
             params :{
                tssCd :lvTssCd
             }
        });

        //폼에 출력 
        var bind = new Rui.data.LBind({
            groupId: 'smryFormDiv',
            dataSet: dataSet,
            bind: true,
            bindInfo: [
                  { id: 'tssCd',           ctrlId: 'tssCd',             value: 'value' }
                , { id: 'ttlCrroStrtDt',   ctrlId: 'ttlCrroStrtDt',     value: 'value' }
                , { id: 'ttlCrroFnhDt',    ctrlId: 'ttlCrroFnhDt',      value: 'value' }
                , { id: 'strtDt1',         ctrlId: 'strtDt1',           value: 'value' }
                , { id: 'fnhDt1',          ctrlId: 'fnhDt1',            value: 'value' }
                , { id: 'strtDt2',         ctrlId: 'strtDt2',           value: 'value' }
                , { id: 'fnhDt2',          ctrlId: 'fnhDt2',            value: 'value' }
                , { id: 'strtDt3',         ctrlId: 'strtDt3',           value: 'value' }
                , { id: 'fnhDt3',          ctrlId: 'fnhDt3',            value: 'value' }
                , { id: 'strtDt4',         ctrlId: 'strtDt4',           value: 'value' }
                , { id: 'fnhDt4',          ctrlId: 'fnhDt4',            value: 'value' }
                , { id: 'strtDt5',         ctrlId: 'strtDt5',           value: 'value' }
                , { id: 'fnhDt5',          ctrlId: 'fnhDt5',            value: 'value' }
//                 , { id: 'finYn',           ctrlId: 'finYn',             value: 'value' }
                , { id: 'smryTxt',         ctrlId: 'smryTxt',           value: 'value' }
                , { id: 'userId',          ctrlId: 'userId',            value: 'value' }
                , { id: 'attcFilId',       ctrlId: 'attcFilId',         value: 'value' }
            ]
        });

        var columnModel2 = new Rui.ui.grid.LColumnModel({
            autoWidth: true,
            columns: [
                  new Rui.ui.grid.LSelectionColumn()
                , new Rui.ui.grid.LStateColumn()
                , new Rui.ui.grid.LNumberColumn()
                  , { field: 'instNm', label: '기관명', sortable: false, align:'center', width: 150, editor: new Rui.ui.form.LTextBox() }
                  , { field: 'instTypeCd',  label: '기관유형', sortable: false, align:'center', width: 150, editor: cbYldItmType }
            ]
        });

        //패널설정 
        var grid2 = new Rui.ui.grid.LGridPanel({
            columnModel: columnModel2,
            dataSet: smryDataLstSet,
            width: 600,
            height: 200,
            autoToEdit: true,
            clickToEdit: true,
            enterToEdit: true,
            autoWidth: true,
            autoHeight: true,
            multiLineEditor: true,
            useRightActionMenu: false
        });

        grid2.render('defaultGrid');
        
        //서버전송용 
        var dm = new Rui.data.LDataSetManager({defaultFailureHandler: false});
        dm.on('success', function(e) {
            var data = dataSet.getReadData(e);

            alert(data.records[0].rtVal);

            gvTssCd = data.records[0].tssCd;

            if(data.records[0].rtCd == "FAIL") {
                dataSet.setState(0, 1);
            }
        });
        
        //유효성
        vm1 = new Rui.validate.LValidatorManager({
            validators: [  
                  { id: 'tssCd',         validExp: '과제코드:false' }
                , { id: 'ttlCrroStrtDt', validExp: '총수행시작일:true' }
                , { id: 'ttlCrroFnhDt',  validExp: '총수행종료일:true' }
                , { id: 'strtDt1',       validExp: '1차년 과제시작일:true' }
                , { id: 'fnhDt1',        validExp: '1차년 과제종료일:true' }
                , { id: 'strtDt2',       validExp: '2차년 과제시작일:false' }
                , { id: 'fnhDt2',        validExp: '2차년 과제종료일:false' }
                , { id: 'strtDt3',       validExp: '3차년 과제시작일:false' }
                , { id: 'fnhDt3',        validExp: '3차년 과제종료일:false' }
                , { id: 'strtDt4',       validExp: '4차년 과제시작일:false' }
                , { id: 'fnhDt4',        validExp: '4차년 과제종료일:false' }
                , { id: 'strtDt5',       validExp: '5차년 과제시작일:false' }
                , { id: 'fnhDt5',        validExp: '5차년 과제종료일:false' }
                , { id: 'attcFilId',     validExp: 'GRS심의파일:true' }
                , { id: 'userId',        validExp: '로그인ID:false' }
            ]
        });
        vm2 = new Rui.validate.LValidatorManager({
            validators: [  
                  { id:'tssCd',      validExp: '과제코드:false' }
                , { id:'crroInstSn', validExp: '수행기관일련번호:false' }
                , { id:'instNm',     validExp: '기관명:true' }
                , { id:'instTypeCd', validExp: '기관유형:true' }
                , { id:'userId',     validExp: '사용자ID:false' }
            ]
        });

        
        
        /*============================================================================
        =================================    기능     ================================
        ============================================================================*/
        //추가 
        var butAdd = new Rui.ui.LButton('butAdd');
        butAdd.on('click', function() {
            var row = smryDataLstSet.newRecord();
            var record = smryDataLstSet.getAt(row);

            record.set("tssCd",  lvTssCd);
            record.set("userId", lvUserId);
        });

        //삭제 
        var butDel = new Rui.ui.LButton('butDel');
        butDel.on('click', function() {
        		
                if(smryDataLstSet.getMarkedCount() > 0) {
                    smryDataLstSet.removeMarkedRows();
                } else {
                    var row = smryDataLstSet.getRow();
                    if(row < 0) return;
                    smryDataLstSet.removeAt(row);
                }

                //삭제된 레코드 외 상태 정상처리
                var delRowCnt = 0;
                for(var i = 0; i < smryDataLstSet.getCount(); i++) {
                    if(smryDataLstSet.getState(i) == 3) {
                        delRowCnt++;
                    }
                    else {
                        smryDataLstSet.setState(i, Rui.data.LRecord.STATE_NORMAL);
                    }
                }

        });


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
            if(Rui.isEmpty(lvAttcFilId)) lvAttcFilId = "";

            return lvAttcFilId;
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


        /* [버튼] 저장 */
        var btnSave = new Rui.ui.LButton('btnSave');
        btnSave.on('click', function() {
        	
        	// 에디터 데이터처리
			dataSet.setNameValue(0, "smryTxt", Wec.GetBodyValue() );
        	
    	    //시작일종료일 체크
    		var stDt;
            var fnDt;
    		for(var i = 2; i <= 5; i++) {
    		    stDt = eval("strtDt"+i);
                fnDt = eval("fnhDt"+i);
                
                if((Rui.isEmpty(stDt.getValue()) && !Rui.isEmpty(fnDt.getValue())) 
                        || (!Rui.isEmpty(stDt.getValue()) && Rui.isEmpty(fnDt.getValue()))) {
                    alert("과제 시작일과 종료일을 전부 입력해야 합니다.");
                    return false;
                }
    		}
    		
    		dataSet.setNameValue(0, "tssNosSt", lvTssNosSt);
        	
            if(lvPgsStepCd == "AL") {
                if(!vm1.validateGroup("smryForm")) {            
                    alert(Rui.getMessageManager().get('$.base.msg052') + '\n' + vm1.getMessageList().join(''));
                    return false;
                }
                
                if(!vm2.validateDataSet(smryDataLstSet, smryDataLstSet.getRow())) { 
                    alert(Rui.getMessageManager().get('$.base.msg052') + '\n' + vm2.getMessageList().join(''));
                    return false;
                }
             	// 에디터 필수값 처리
    			if( Wec.GetBodyValue() == "<p><br></p>" || Wec.GetBodyValue() == "" ){ // 크로스에디터 안의 컨텐츠 입력 확인
    				alert("개발대상기술 및 제품개요 은 필수입력입니다.");
    				Wec.SetFocusEditor(); // 크로스에디터 Focus 이동
         		    return false;
         		}
             	
                if(confirm("저장하시겠습니까?")) {
                    dataSet.setNameValue(0, "userId", lvUserId);
                    
                    dm.updateDataSet({
                        modifiedOnly: false,
                        url:'<c:url value="/prj/tss/nat/updateNatTssAltrSmry.do"/>',
                        dataSets:[lvPDS, dataSet, smryDataLstSet]
                    });
                }
            } else {
                window.parent.fnSave();
            }
        });

        //최초 데이터 셋팅 
        if(${resultCnt} > 0) {
            console.log("smry searchData1");
            dataSet.loadData(${result});
        } else {
            console.log("smry searchData2");
            dataSet.newRecord();
        }
        
        if("<c:out value='${inputData._roleId}'/>".indexOf('WORK_IRI_T15') > -1) {
        	$("#btnSave").hide();
        	document.getElementById('attchFileMngBtn').style.display = "none";
    	}else if("<c:out value='${inputData._roleId}'/>".indexOf('WORK_IRI_T16') > -1) {
        	$("#btnSave").hide();
        	document.getElementById('attchFileMngBtn').style.display = "none";
		}


        if(window.parent.isEditable){
            btnSave.show();
            $("#btnSave").show();
        }else{
            disableFields();
        }

    });
    
    
    //일자 validation
    function fnDateStrtFnhCheck(gbn, seq) {
        var stDt;
        var fnDt;
        
        if(seq == 0) {
            stDt = ttlCrroStrtDt;
            fnDt = ttlCrroFnhDt;
        } 
        else {
            stDt = eval("strtDt"+seq);
            fnDt = eval("fnhDt"+seq);
        }
        
        if(gbn == "S" && Rui.isEmpty(stDt.getValue())) return false;
        else if(gbn == "F" && Rui.isEmpty(fnDt.getValue())) return false;
        
        if((gbn == "S" && !Rui.isEmpty(stDt.getValue())) || (gbn == "F" && !Rui.isEmpty(fnDt.getValue()))) {
            var pStDt = stDt.getValue().replace(/\-/g, "").toDate();
            var pFnDt = fnDt.getValue().replace(/\-/g, "").toDate();
            
            if(stringNullChk(pStDt) != "" && stringNullChk(pFnDt)) {
	            var rtnValue = ((pFnDt - pStDt) / 60 / 60 / 24 / 1000) + 1;
	            
	            if(rtnValue <= 0) {
	                alert("시작일보다 종료일이 빠를 수 없습니다.");
	                
	                if(gbn == "S") stDt.setValue("");
	                else if(gbn == "F") fnDt.setValue("");
	                
	                return false;
	            }
            }
        }
    }
    
    
    //이전차수 validation
    function fnDateFrontCheck(seq) {
        var sBfDt;
        var fBfDt;
        var sAfDt;
        var fAfDt;
        
        //현재차수
        sAfDt = eval("strtDt"+seq);
        fAfDt = eval("fnhDt"+seq);
        
        seq = seq - 1;
        
        //이전차수
        sBfDt = eval("strtDt"+seq);
        fBfDt = eval("fnhDt"+seq);
        
        if(Rui.isEmpty(sAfDt.getValue()) && Rui.isEmpty(fAfDt.getValue())) return false;
        
	    if(Rui.isEmpty(sBfDt.getValue()) || Rui.isEmpty(fBfDt.getValue())) {
	        alert("이전차수를 먼저 입력해 주시기 바랍니다.");
	        sAfDt.setValue("");
	        fAfDt.setValue("");
	        return false;
	    }
    }
    
    
    //validation
    function fnIfmIsUpdate(gbn) {
        if(!vm1.validateGroup("smryForm")) {
            alert(Rui.getMessageManager().get('$.base.msg052') + '\n' + vm1.getMessageList().join(''));
            return false;
        }
        
        if(!vm2.validateDataSet(smryDataLstSet, smryDataLstSet.getRow())) { 
            alert(Rui.getMessageManager().get('$.base.msg052') + '\n' + vm2.getMessageList().join(''));
            return false;
        }
        
        // 에디터 필수값 처리
        if( Wec.GetBodyValue() == "<p><br></p>" || Wec.GetBodyValue() == "" ){ // 크로스에디터 안의 컨텐츠 입력 확인
			alert("개발대상기술 및 제품개요 은 필수입력입니다.");
			Wec.SetFocusEditor(); // 크로스에디터 Focus 이동
 		    return false;
 		}
    	
    	if(gbn == "SAVE") {
            var rCnt = smryDataLstSet.getCount();
            for(var i = 0; i < smryDataLstSet.getCount(); i++) {
                if(smryDataLstSet.getState(i) == 3) {
                    rCnt--;
                }
            }
            if(rCnt <= 0) {
                alert("수행기관을 추가해주시기 바랍니다.");
                return false;
            }
        }
        
        return true;
    }
</script>
<script type="text/javascript">
$(window).load(function() {
    initFrameSetHeight("smryFormDiv");
}); 
</script>
</head>
<body>

<div id="smryFormDiv">
    <form name="smryForm" id="smryForm" method="post" style="padding: 20px 1px 0 0;">
        <input type="hidden" id="userId" name="userId" value=""> <!-- 사용자ID -->
        <input type="hidden" id="attcFilId" name="attcFilId" value=""/>
        <input type="hidden" id="seq" name="seq" value=""/>
        <table class="table table_txt_right">
            <colgroup>
                <col style="width: 150px;" />
                <col style="width: 150px;" />
                <col style="width: *;" />
                <col style="width: 100px;" />
            </colgroup>
            <tbody>
                <tr>
                    <th align="right">총과제수행기간</th>
                    <th align="right">과제기간</th>
                    <td colspan="3">    
                        <div class="tssComboCss">
                            <input type="text" id="ttlCrroStrtDt" value="" /><em class="gab"> ~ </em>
                            <input type="text" id="ttlCrroFnhDt" value="" />
                        </div>
                    </td>
                </tr>
                <tr>
                    <th align="right" rowspan="5">년별수행기간</th>
                    <th align="right">1차년도</th>
                    <td colspan="3"> 
                        <div class="tssComboCss">
                            <input type="text" id="strtDt1" value="" /><em class="gab"> ~ </em>
                            <input type="text" id="fnhDt1" value="" />
                        </div>
                    </td>
                </tr>
                <tr>
                    <th align="right">2차년도</th>
                    <td colspan="3"> 
                        <div class="tssComboCss">
                            <input type="text" id="strtDt2" value="" /><em class="gab"> ~ </em>
                            <input type="text" id="fnhDt2" value="" />
                        </div>
                    </td>
                </tr>
                <tr>
                    <th align="right">3차년도</th>
                    <td colspan="3"> 
                        <div class="tssComboCss">
                            <input type="text" id="strtDt3" value="" /><em class="gab"> ~ </em>
                            <input type="text" id="fnhDt3" value="" />
                        </div>
                    </td>
                </tr>
                <tr>
                    <th align="right">4차년도</th>
                    <td colspan="3"> 
                        <div class="tssComboCss">
                            <input type="text" id="strtDt4" value="" /><em class="gab"> ~ </em>
                            <input type="text" id="fnhDt4" value="" />
                        </div>
                    </td>
                </tr>
                <tr>
                    <th align="right">5차년도</th>
                    <td colspan="3"> 
                        <div class="tssComboCss">
                            <input type="text" id="strtDt5" value="" /><em class="gab"> ~ </em>
                            <input type="text" id="fnhDt5" value="" />
                        </div>
                    </td>
                </tr>
            </tbody>
        </table>

        <div class="titArea mt20">
            <h4>수행기관</h4>
            <div class="LblockButton">
                <button type="button" id="butAdd" name="butAdd">+</button>
                <button type="button" id="butDel" name="butDel">-</button>
            </div>
        </div>
        
        <div id="mbrFormDiv">
            <form name="crroForm" id="crroForm" method="post">
                <input type="hidden" id="tssCd"  name="tssCd"  value=""> <!-- 과제코드 -->
                <input type="hidden" id="userId" name="userId" value=""> <!-- 사용자ID -->
            </form>
            <div id="defaultGrid"></div>
        </div>
		
		<form name="smryEditorForm" id="smryEditorForm" method="post" style="padding: 10px 1px 0 0;">
	        <table class="table table_txt_right">
	            <colgroup>
	                <col style="width: 170px;" />
	                <col style="width: *;" />
	                <col style="width: 150px;" />
	    
	            </colgroup>
	            <tbody>
	                <tr>
	                    <th align="right">개발대상기술 및 제품개요</th>
	                    <td colspan="2">
	                        <div id="divWec">
							<textarea id="smryTxt" name="smryTxt"></textarea>
							<script>
                                Wec = new NamoSE('smryTxt');
                                Wec.params.Width = "100%";
                                Wec.params.UserLang = "auto";
                                Wec.params.Font = fontParam;
                                uploadPath = "<%=uploadPath%>";
                                Wec.params.ImageSavePath = uploadPath+"/prj";		//하위메뉴 폴더명은 변경  project.properties KeyStore.UPLOAD_ 참조
                                Wec.params.FullScreen = false;
                                Wec.EditorStart();
                                
                                function OnInitCompleted(e){
	                                e.editorTarget.SetBodyValue(document.getElementById("divWec").value);
	                            }
                            </script>
						</div>
	                    </td>
	                </tr>
	                <tr>
	                    <th align="right">GRS심의파일<br/>(1차년도 사업계획서)</th>
	                    <td id="attchFileView">&nbsp;</td>
	                    <td><button type="button" class="btn" id="attchFileMngBtn" name="attchFileMngBtn" onclick="openAttachFileDialog(setAttachFileInfo, getAttachFileId(), 'prjPolicy', '*')">첨부파일등록</button></td>
	                </tr>
	    
	            </tbody>
	        </table>
        </form>
    </form>
	<div class="titArea btn_btm">
	    <div class="LblockButton">
	        <button type="button" id="btnSave" name="btnSave">저장</button>
	        <!-- <button type="button" id="btnList" name="btnList">목록</button> -->
	    </div>
	</div>
</div>
</body>
</html>