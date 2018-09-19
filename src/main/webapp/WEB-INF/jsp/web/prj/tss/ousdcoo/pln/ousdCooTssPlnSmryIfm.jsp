<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*, java.util.*,devonframe.util.NullUtil,devonframe.util.DateUtil"%>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>

<%--
/*
 *************************************************************************
 * $Id      : ousdCooTssPlnSmryIfm.jsp
 * @desc    : 대외협력과제 > 개요 탭 화면
 *------------------------------------------------------------------------
 * VER  DATE        AUTHOR      DESCRIPTION
 * ---  ----------- ----------  -----------------------------------------
 * 1.0  2017.09.18  IRIS04		최초생성
 * ---  ----------- ----------  -----------------------------------------
 * IRIS 프로젝트
 *************************************************************************
 */
--%>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<%@ include file="/WEB-INF/jsp/include/rui_header.jspf"%>

<title><%=documentTitle%></title>
<script type="text/javascript" src="<%=ruiPathPlugins%>/tab/rui_tab.js"></script>

<script type="text/javascript">
    var lvTssCd  = window.parent.gvTssCd;
    var lvUserId = window.parent.gvUserId;
    var lvTssSt  = window.parent.gvTssSt;
    var lvPageMode = window.parent.gvPageMode;
    
    var pageMode = (lvTssSt == "100" || lvTssSt == "") && (lvPageMode == "W" || lvPageMode == "") ? "W" : "R";
    
    var dataSet;
    var lvAttcFilId;

    Rui.onReady(function() {
        /*============================================================================
        =================================    Form     ================================
        ============================================================================*/
        //연구비(억원)
        rsstExp = new Rui.ui.form.LNumberBox({
            applyTo: 'rsstExp',
            width: 100,
            defaultValue: 0,
            attrs: {
//            	dir: 'rtl'	/*오른쪽정렬*/
			   }
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
        
        //독점권 : COMM_YN_T
        monoCd = new Rui.ui.form.LCombo({
            applyTo: 'monoCd',
            name: 'monoCd',
            useEmptyText: true,
            emptyText: '선택',
            url: '<c:url value="/common/code/retrieveCodeListForCache.do?comCd=COMM_YN_T"/>',
            displayField: 'COM_DTL_NM',
            valueField: 'COM_DTL_CD',
            width: 150
        });
      
        //연구비 지급조건
        rsstExpFnshCnd = new Rui.ui.form.LTextArea({
            applyTo: 'rsstExpFnshCnd',
            height: 100,
            width: 600
        });
      
        //법무팀 검토결과
        rvwRsltTxt = new Rui.ui.form.LTextArea({
            applyTo: 'rvwRsltTxt',
            height: 100,
            width: 600
        });

        //Form 비활성화
        disableFields = function() {
            if(pageMode == "W") return;
            
//            document.getElementById('nprodSalsPlnYAvg').style.border = 0;
//            document.getElementById('ptcCpsnYAvg').style.border = 0;
            
            document.getElementById('attchFileMngBtn').style.display = "none";
            btnSave.hide();
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
           		, { id: 'rsstExpConvertMil', defaultValue: 0 } /*연구비(억원)*/
           		, { id: 'userId' }
            ]
        });
        dataSet.on('load', function(e) {
            
            lvAttcFilId = dataSet.getNameValue(0, "attcFilId");
            if(!Rui.isEmpty(lvAttcFilId)) getAttachFileList();
            
            tabViewS.selectTab(0);
        });
        
      	//유효성 설정
        var vm = new Rui.validate.LValidatorManager({
            validators: [  
//                   { id: 'surrNcssTxt',       validExp: '연구과제 배경 및 필요성:true' }
//                 , { id: 'sbcSmryTxt',   validExp: '주요 연구개발 내용 요약:true' }
//                 , { id: 'oucmPlnTxt',  validExp: '목표기술 성과 계획:true' }
                   { id: 'rsstExp',         validExp: '연구비:true' }
                 , { id: 'cnttTypeCd',      validExp: '계약유형:true' }
                 , { id: 'monoCd',          validExp: '독점권:true' }
                 , { id: 'rsstExpFnshCnd',  validExp: '연구비 지급조건:true' }
                 , { id: 'rvwRsltTxt',      validExp: '법무팀 검토결과:true' }
                 , { id: 'attcFilId',       validExp: '첨부파일:true' }
            ]
        });
        
        //Form 바인드
        var bind = new Rui.data.LBind({
            groupId: 'smryFormDiv',
            dataSet: dataSet,
            bind: true,
            bindInfo: [
                  { id: 'tssCd',              ctrlId: 'tssCd',           value: 'value' }
//                , { id: 'oucmPlnTxt',         ctrlId: 'oucmPlnTxt',      value: 'value' }
                , { id: 'rsstExpConvertMil',  ctrlId: 'rsstExp',         value: 'value' }
                , { id: 'cnttTypeCd',         ctrlId: 'cnttTypeCd',      value: 'value' }
                , { id: 'monoCd',             ctrlId: 'monoCd',          value: 'value' }
                , { id: 'rsstExpFnshCnd',     ctrlId: 'rsstExpFnshCnd',  value: 'value' }
                , { id: 'rvwRsltTxt',         ctrlId: 'rvwRsltTxt',      value: 'value' }
//                , { id: 'surrNcssTxt',        ctrlId: 'surrNcssTxt',     value: 'value' }
//                , { id: 'sbcSmryTxt',         ctrlId: 'sbcSmryTxt',      value: 'value' }
                , { id: 'sttsTxt',            ctrlId: 'sttsTxt',         value: 'value' }
                , { id: 'ctqTxt',             ctrlId: 'ctqTxt',          value: 'value' }
                , { id: 'effSpheTxt',         ctrlId: 'effSpheTxt',      value: 'value' }
                , { id: 'fnoPlnTxt',          ctrlId: 'fnoPlnTxt',       value: 'value' }
                , { id: 'altrRson',           ctrlId: 'altrRson',        value: 'value' }
                , { id: 'addRson',            ctrlId: 'addRson',         value: 'value' }
                , { id: 'dcacRson',           ctrlId: 'dcacRson',        value: 'value' }
                , { id: 'attcFilId',          ctrlId: 'attcFilId',       value: 'value' }
                , { id: 'userId',             ctrlId: 'userId',          value: 'value' }
            ]
        });
        
        // 개요 에디터 탭
        tabViewS = new Rui.ui.tab.LTabView({
            contentHeight: 200,
            tabs: [
                {
                	label: '연구과제배경 및 필요성',
                    content: ''
                }, {
                    label: '주요 연구개발 내용 요약',
                    content: ''
                }, {
                    label: '목표기술 성과 계획',
                    content: ''
                }
            ]
        });
        
        tabViewS.on('activeTabChange', function(e){
        	var index = e.activeIndex;
        	fnDisplyNone();
        	$("#Wec"+index).ready(function(){
        		fnDisplyBlock(index);
        		if(e.isFirst){
        			if(index == 0) {
//                        initFrameSetHeight();

                        setTimeout(function () {
                        	fnSetDataEditor(index);
                            }, 1500);
                    } else {
                    	fnSetDataEditor(index);
                    }
        		}
        	});
		});

        /*============================================================================
        =================================    기능     ================================
        ============================================================================*/

        //저장
        var btnSave = new Rui.ui.LButton('btnSave');
        btnSave.on('click', function() {
        	var frm = document.smryForm;

        	var rsstExpCash = numberNullChk(rsstExp.getValue()) * 100000000;
        	dataSet.setNameValue(0, "rsstExp" , rsstExpCash );
        	
        	// 에디터 데이터 처리    	
        	frm.surrNcssTxt.value = fnEditorGetMimeValue(frm.Wec0.isDirty(),frm.Wec0,'');
        	frm.sbcSmryTxt.value  = fnEditorGetMimeValue(frm.Wec1.isDirty(),frm.Wec1,'');
        	frm.oucmPlnTxt.value  = fnEditorGetMimeValue(frm.Wec2.isDirty(),frm.Wec2,'');
        	
        	fncEditor();
        	
            window.parent.fnSave();
        });
        
        
        fncEditor = function(){
        	var frm = document.smryForm;
        	
        	frm.Wec0.CleanupOptions = "msoffice | empty | comment";
        	frm.Wec1.CleanupOptions = "msoffice | empty | comment";
        	frm.Wec2.CleanupOptions = "msoffice | empty | comment";
    		
        	frm.Wec0.value =frm.Wec0.CleanupHtml(frm.Wec0.value);
        	frm.Wec1.value =frm.Wec1.CleanupHtml(frm.Wec1.value);
        	frm.Wec2.value =frm.Wec2.CleanupHtml(frm.Wec2.value);
        	
        	var jsonString = JSON.stringify(${result});
            var obj = jQuery.parseJSON(jsonString);

            var surrNcssTxt  = fnEditorGetMimeValue(document.smryForm.Wec0.isDirty(),document.smryForm.Wec0,'body');
            var sbcSmryTxt   = fnEditorGetMimeValue(document.smryForm.Wec1.isDirty(),document.smryForm.Wec1,'body');
            var oucmPlnTxt   = fnEditorGetMimeValue(document.smryForm.Wec2.isDirty(),document.smryForm.Wec2,'body');
            
            if(lvTssCd !='') {
            	if(  surrNcssTxt == "<P>&nbsp;</P>" || surrNcssTxt == "") {
            		frm.Wec0.value = obj.records[0].surrNcssTxt;
                }
            	if(  sbcSmryTxt == "<P>&nbsp;</P>" || sbcSmryTxt == "") {
	            	frm.Wec1.value = obj.records[0].sbcSmryTxt;
                }
            	if(  oucmPlnTxt == "<P>&nbsp;</P>" || oucmPlnTxt == "") {
		            frm.Wec2.value = obj.records[0].oucmPlnTxt;
                }
	            
	        	frm.surrNcssTxt.value =  frm.Wec0.MIMEValue;
	            frm.sbcSmryTxt.value =  frm.Wec1.MIMEValue;
	            frm.oucmPlnTxt.value =  frm.Wec2.MIMEValue;
            }
        }
        
       /*  
        //목록
        var btnList = new Rui.ui.LButton('btnList');
        btnList.on('click', function() {    
            nwinsActSubmit(window.parent.document.mstForm, "<c:url value='/prj/tss/ousdcoo/ousdCooTssList.do'/>");
        });
        */ 
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
                url: "<c:url value='/system/attach/getAttachFileList.do'/>" ,
                params :{
                    attcFilId : lvAttcFilId
                },
                sync : true
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
        
        // 개요저장 validation 함수 : false : 항목없음 / true : 항목존재
        validation = function(){
        	
        	// 1. Rui 기본 validation
            if( !vm.validateGroup("smryForm") ) {
                 alert(Rui.getMessageManager().get('$.base.msg052') + '\n' + vm.getMessageList().join(''));
                 return true;
            }
        	
        	// 2. 연구비 0 이상 체크
        	if( Number(rsstExp.getValue()) <= 0 ){
        		alert("연구비는 0억원 이상 입력해야 합니다.");
        		return true;
        	}
        	
        	// 3. 에디터 필수입력 체크
        	// 에디터 로딩 전 값은 <P>&nbsp;</P> => 변경여부 체크추가
        	var testEditValue1 = fnEditorGetMimeValue(document.smryForm.Wec0.isDirty(),document.smryForm.Wec0,'body');
        	var testEditValue2 = fnEditorGetMimeValue(document.smryForm.Wec1.isDirty(),document.smryForm.Wec1,'body');
        	var testEditValue3 = fnEditorGetMimeValue(document.smryForm.Wec2.isDirty(),document.smryForm.Wec2,'body');
        	var testEditIsDirty1 = document.smryForm.Wec0.isDirty();
        	var testEditIsDirty2 = document.smryForm.Wec1.isDirty();
        	var testEditIsDirty3 = document.smryForm.Wec2.isDirty();

        	if( testEditValue1 == '' || testEditValue1 == "<P>&nbsp;</P>"){
        		alert("연구과제배경 및 필요성 은 필수입력입니다.");
        		return true;
        	}
        	if( testEditValue2 == '' || testEditValue2 == "<P>&nbsp;</P>"){
        		alert("주요 연구개발 내용 요약 은 필수입력입니다.");
        		return true;
        	}
        	if( testEditValue3 == '' || testEditValue3 == "<P>&nbsp;</P>"){
        		alert("목표기술 성과 계획 은 필수입력입니다.");
        		return true;
        	}

			// 4. 기타데이터 체크
			var filId = dataSet.getNameValue(0, "attcFilId");
			if( filId == null || filId == '' ){
        		alert("첨부파일 은 필수로 등록해야 합니다.");
        		return true;
        	}

        	return false;
        }
		
        /** ============================================= Editor ================================================================================= **/
        // 에디터 값 세팅
        fnSetDataEditor = function(val){
        	var resultCnt = Number('<c:out value="${resultCnt}"/>');
        	
       		var jsonString = JSON.stringify(${result});
        	var obj = jQuery.parseJSON(jsonString);
        	
       		var Wec = eval("document.smryForm.Wec"+val);
	       	Wec.BodyValue  =  Wec.value ;
	       	var txt = "";
	       	if(resultCnt > 0){
		       	txt = obj.records[0].surrNcssTxt;
		        if(val==0){
		       		txt = obj.records[0].surrNcssTxt;       
		        }else if(val==1){
		        	txt = obj.records[0].sbcSmryTxt;       
		        }else if(val==2){
		        	txt = obj.records[0].oucmPlnTxt;       
		        }
	       	}
	       	Wec.BodyValue = txt;
	       	Wec.setDirty(false);	// 변경상태 초기화처리
        }
        
        //editor show hide function
        fnDisplyBlock= function(val){
        	document.getElementById('divWec'+val).style.display = 'block';
        }
        fnDisplyNone = function(){
        	document.getElementById('divWec0').style.display = 'none';
        	document.getElementById('divWec1').style.display = 'none';
        	document.getElementById('divWec2').style.display = 'none';
        }
        
        // 에디터변경여부
        fnEditorIsUpdate = function(){
        	isUpdate = false;
        	var Wec0 = document.smryForm.Wec0;
        	var Wec1 = document.smryForm.Wec1;
        	var Wec2 = document.smryForm.Wec2;

        	if( (Wec0 != null && Wec0.IsDirty() == 1) || (Wec1 != null && Wec1.IsDirty() == 1) || (Wec2 != null && Wec2.IsDirty() == 1) ){
        		isUpdate = true;
        	}
        	return isUpdate;
        }
        /* 에디터값 가져오기(변경상태 유지) type(body, mime) */
        fnEditorGetMimeValue = function(beforeDirty,editor,type){
        	
        	var returnValue = editor.MIMEValue;
        	if(type == 'body'){ returnValue = editor.BodyValue; }
        	
        	editor.setDirty(beforeDirty);
        	return returnValue;
        }
     	// 에디터 생성
        createNamoEdit('Wec0', '100%', 400, 'divWec0');
    	createNamoEdit('Wec1', '100%', 400, 'divWec1');
    	createNamoEdit('Wec2', '100%', 400, 'divWec2');
    	/** ===============================================  Editor End ==================================================================================== **/
    	
        tabViewS.render('tabViewS');
        
        //최초 데이터 셋팅
        var resultCnt = Number('<c:out value="${resultCnt}"/>');
        if(resultCnt > 0) { 
            dataSet.loadData( ${result} ); 
        } else {
            dataSet.newRecord();
            tabViewS.selectTab(0);
        }
        
        //버튼 비활성화 셋팅
        disableFields();
        
//        $("#Wec0").ready(function(){
//        	tabViewS.selectTab(0);
//        });
    });
    
    // 내부 스크롤 제거
    $(window).load(function() {
    	setTimeout(function () {
    		initFrameSetHeight();
    	}, 1500);
    });
</script>

</head>
<body>
<div id="smryFormDiv">

    <form name="smryForm" id="smryForm" method="post">
        <input type="hidden" id="tssCd"  name="tssCd"  value="">  <!-- 과제코드 -->
        <input type="hidden" id="userId" name="userId" value="">  <!-- 사용자ID -->
        <input type="hidden" id="surrNcssTxt" name="surrNcssTxt"> <!-- 연구과제배경 및 필요성 -->
        <input type="hidden" id="sbcSmryTxt" name="sbcSmryTxt">   <!-- 주요 연구개발 내용 요약 -->
        <input type="hidden" id="oucmPlnTxt" name="oucmPlnTxt">   <!-- 목표기술 성과 계획 -->
         
        <table class="table table_txt_right">
            <colgroup>
                <col style="width: 15%;" />
                <col style="width: 35%;" />
                <col style="width: 15%;" />
                <col style="width: 25%;" />
                <col style="width: 10%;" />
            </colgroup>
            <tbody>                         
                <tr>
                	<th align="right" rowspan="2">개요 상세</th>
                    <td colspan="4">
                    	<div id="tabViewS"></div>
					</td>
                </tr>
                <tr>
                    <td colspan="4">
						<div id="divWec0"></div>
                		<div id="divWec1"></div>
                		<div id="divWec2"></div>
					</td>
                </tr>          
                <tr>
                    <th align="right">연구비 (억원)</th>
                    <td><input type="text" id="rsstExp" name="rsstExp"></td>
                    <th align="right">계약유형</th>
                    <td colspan="2"><div id="cnttTypeCd" name="cnttTypeCd"></div></td>
                </tr>
                <tr>
                    <th align="right">독점권</th>
                    <td colspan="4"><div id="monoCd" name="monoCd"></div></td>
                </tr>
                <tr>
                    <th align="right">연구비 지급조건</th>
                    <td colspan="4"><textarea id="rsstExpFnshCnd" name="rsstExpFnshCnd"></textarea></td>
                </tr>
                <tr>
                    <th align="right">법무팀 검토결과</th>
                    <td colspan="4"><textarea id="rvwRsltTxt" name="rvwRsltTxt"></textarea></td>
                </tr>
                <tr>
                    <th align="right">첨부파일<br/>(심의파일, 회의록 필수 첨부)</th>
                    <td colspan="3" id="attchFileView">&nbsp;</td>
                    <td><button type="button" class="btn" id="attchFileMngBtn" name="attchFileMngBtn" onclick="openAttachFileDialog(setAttachFileInfo, getAttachFileId(), 'prjPolicy', '*')">첨부파일등록</button></td>
                </tr>
            </tbody>
        </table>
    </form>
</div>
<div class="titArea btn_btm">
    <div class="LblockButton">
        <button type="button" id="btnSave" name="btnSave">저장</button>
        <!-- <button type="button" id="btnList" name="btnList">목록</button> -->
    </div>
</div>
</body>
</html>