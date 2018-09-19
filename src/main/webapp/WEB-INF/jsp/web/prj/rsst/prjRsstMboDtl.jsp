<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>			
<%@ page import="java.text.*, java.util.*,devonframe.util.NullUtil,devonframe.util.DateUtil"%>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>

<%--
/*
 *************************************************************************
 * $Id      : prjRsstMboDtl.jsp
 * @desc    : MBO 그리드 등록 탭
 *------------------------------------------------------------------------
 * VER  DATE        AUTHOR      DESCRIPTION
 * ---  ----------- ----------  -----------------------------------------
 * 1.0  2017.08.17  IRIS04      최초생성
 * ---  ----------- ----------  -----------------------------------------
 * IRIS 구축 프로젝트
 *************************************************************************
 */
--%>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<%@ include file="/WEB-INF/jsp/include/rui_header.jspf"%>
<title><%=documentTitle%></title>

<script type="text/javascript">
var pTopForm = parent.topForm;	// 프로젝트마스터 폼
var dataSet03;					// 데이터셋
var mboPlnDialog;  				// 계획MBO Dialog
var mboArslDialog; 				// 실적MBO Dialog
var fileUploadGridIndex;		// 첨부파일 업로드 그리드 인덱스
var vmTab03;					// 데이터셋 rui validation
var tmboArslDialog;

var nowDate = new Date();
var nYear  = nowDate.getFullYear();

Rui.onReady(function() {
	
	
	/* FORM OBJECT */
	
	/* COMBO : 목표년도 2011년~2030년 */ //pduGoalYear
    var lcbGoalYear = new Rui.ui.form.LCombo({
    	useEmptyText: true,
        emptyText: '선택',
        items: [
        	<c:forEach var="i" begin="0" varStatus="status" end="19">
     		{ value : "${ 2030 - i }" , text : "${ 2030 - i }" } ,
     		</c:forEach>
        ]
    });
    
    /* [Number Input] 목표배점 */
    var lnbMboGoalAltp = new Rui.ui.form.LNumberBox({
//        applyTo: 'mboGoalAltp',
        minValue: 0,
        maxValue: 100,
        width: 105
    });
    
    /* [Input] 목표항목 */
    var ltbMboGoalPrvs = new Rui.ui.form.LTextBox({
	     defaultValue : '',
	     emptyValue: '',
	     width : 350
	});
    
    /* [TEXT AREA] 목표수준 */
    var ltaMboGoalL = new Rui.ui.form.LTextArea({
 	   placeholder: '',
 	   width: 350,
 	});

	/* DATASET : grid */
	dataSet03 = new Rui.data.LJsonDataSet({
	    id: 'dataSet03',
	    remainRemoved: true,
	    lazyLoad: true,
	    fields: [
	    	  { id: 'chk'}
	        , { id: 'prjCd'}
	        , { id: 'wbsCd'}
	        , { id: 'seq'}
	        , { id: 'mboGoalYear', defaultValue: nYear} // 목표년도
	        , { id: 'mboGoalAltp', defaultValue: 0}     // 목표배점
	        , { id: 'mboGoalPrvs'}						// 목표항목
	        , { id: 'mboGoalL'}							// 목표수준
	        , { id: 'arlsYearMon'}
	        , { id: 'arlsStts'}
	        , { id: 'filId', defaultValue: ''}
	        , { id: 'goalSeq' }                        // 목표시퀀스
	        , { id: 'goalNo' }						   // 목표번호(목표시퀀스를 재계산해서 순차적으로 넘버링한 값)
	    ]
	});
	// 데이터셋 변경시 목표년도+ goalSeq 동일데이터셋 동기화 처리
	dataSet03.on('update', function(e) {
		var updateYear = dataSet03.getNameValue(e.row,'mboGoalYear');
		var updateGoalSeq  = dataSet03.getNameValue(e.row,'goalSeq');
		
//		alert(e.originValue);	// 데이터셋 원본
//		alert( e.beforeValue);	// 이전값
		if(e.colId == 'mboGoalYear'){	// 목표년도 변경시 변경이전값 세팅, 체크박스 체크
			updateYear = e.beforeValue;
			dataSet03.setMark(e.row, true);
		}
		
		// 년도+goalSeq 동일 데이터셋에 데이터 동기화
		for(var i=0;i< dataSet03.getCount(); i++){
			
// 			// 신규ROW 추가시는 skip
// 			if(updateGoalSeq == null || updateGoalSeq == '' || updateGoalSeq == undefined){
// 				break;
// 			}
			
			if( updateYear == dataSet03.getNameValue(i,'mboGoalYear') && updateGoalSeq == dataSet03.getNameValue(i,'goalSeq') && updateGoalSeq != undefined ){
				//1. 체크박스 체크
				dataSet03.setMark(i, true);
				
				//2. 동일목표 데이터값 동기화
				dataSet03.setNameValue(i, e.colId, e.value);
			}
		}
		
	});
	
	// 데이터셋 체크박스 클릭시
	dataSet03.on('marked', function(e) {
		// 동일목표(년도+목표번호) 동시체크
		var chkGoalYear = dataSet03.getNameValue(e.row, "mboGoalYear");
	    var chkGoalSeq  = dataSet03.getNameValue(e.row, "goalSeq");
	    for(var i=0; i< dataSet03.getCount(); i++){
	    	if( e.row != i && (chkGoalYear == dataSet03.getNameValue(i, "mboGoalYear"))            && 
	    		(chkGoalSeq == dataSet03.getNameValue(i, "goalSeq") && chkGoalSeq != undefined )   ){
	    		dataSet03.setMark(i, e.isSelect);
	    	}
	    }
	});

	<%-- RESULT DATASET --%>
    var resultDataSet = new Rui.data.LJsonDataSet({
        id: 'resultDataSet',
        remainRemoved: true,
        lazyLoad: true,
        fields: [
              { id: 'rtnSt' }   //결과코드
            , { id: 'rtnMsg' }  //결과메시지
        ]
    });

    resultDataSet.on('load', function(e) {
    	Rui.alert(resultDataSet.getRow());
    	Rui.alert(resultDataSet.getAt(0).get("rtnMsg"));
    });
    
	<%-- VALIDATOR --%>
	vmTab03 = new Rui.validate.LValidatorManager({
        validators:[
	        { id: 'mboGoalYear'  , validExp:'목표년도:true'},
	        { id: 'mboGoalAltp'  , validExp:'목표배점:true'},
	        { id: 'mboGoalPrvs'  , validExp:'목표항목:true'},
	        { id: 'mboGoalL'     , validExp:'목표수준:true'},
        ]
    });

	/* COLUMN : grid */
	var columnModel = new Rui.ui.grid.LColumnModel({
		groupMerge: true,
	    columns: [
	    	new Rui.ui.grid.LSelectionColumn({
			 	width: 30,  align:'center'
			})
	        , { field: 'prjCd',          label: '프로젝트코드', sortable: false, align:'center', width: 100, hidden: true}
	        , { field: 'mboGoalYear',    label: '목표년도', sortable: false, align:'center', width: 60 , editor: lcbGoalYear ,vMerge: true }
	        , { field: 'goalNo',         label: '번호'    , sortable: false, align:'center', width: 30 , vMerge: true }
	        , { field: 'mboGoalAltp',    label: '목표배점', sortable: false, align:'center', width: 60 , editor : lnbMboGoalAltp , vMerge: true }
	        , { field: 'mboGoalPrvs',    label: '목표항목', sortable: false, align:'left', width: 250, editor : ltbMboGoalPrvs , vMerge: true}  
	        , { field: 'mboGoalL',       label: '목표수준', sortable: false, align:'left', width: 300, editor : ltaMboGoalL , vMerge: true }	
	        , { field: 'arlsYearMon',    label: '실적년월', sortable: false, align:'center', width: 60 }
	        , { field: 'arlsStts',       label: '실적현황', sortable: false, align:'left', width: 300 , renderer: Rui.util.LRenderer.popupRenderer() }
	        , { field: 'filId',          label: '파일ID', sortable: false, align:'center', width: 100, hidden: true}
	        , { id: 'attchFileMngBtn',   label: '실적첨부파일',   sortable: false, align:'center', width: 80,
	            renderer: function(val, p, record, row, i){
	            	var recordFilId = nullToString(record.data.filId);
	            	var strBtnFun = "openAttachFileDialog(setMboAttachFileInfo, "+recordFilId+", 'prjPolicy', '*','R')";
	            	if(recordFilId != ""){
	            		return '<button type="button" class="L-grid-button L-popup-action" onclick="'+strBtnFun+'">첨부파일</button>';
	            	}
	            	return '';
	          }},
	    ]
	});
	
	/* GRID : grid */
	var grid = new Rui.ui.grid.LGridPanel({
	    columnModel: columnModel,
	    dataSet: dataSet03,
	    width: 600,
	    height: 450,
	    autoToEdit: true,
	    multiLineEditor: true,
	    autoWidth: true,
        clickToEdit: true,
        useRightActionMenu: false,
	});
    
	/* GRID-popup click : MBO 팝업호출 pageMode A or B */
	grid.on('popup', function(e) {
		// 목표항목
/* 		if(e.col == 3) {
			openMboPlnDialog(dataSet03.getAt(e.row));
        } */
		
		// 실적현황
		if(e.colId == 'arlsStts') {
			var clickSeq = dataSet03.getNameValue(e.row, "seq");
			if( clickSeq != null && clickSeq != "" || clickSeq != undefined ){
				openTmboArslDialog(dataSet03.getAt(e.row), dataSet03.getNameValue(e.row,'seq'));
			}else{
				Rui.alert('목표저장 먼저 해주세요.');
			}
        }
    });

	/* GRID-cellDblClick : MBO 팝업호출 pageMode A or B */
	grid.on('cellDblClick', function(e) {

		// 목표항목
/* 		if(e.col == 3) {
			openMboPlnDialog(dataSet03.getAt(e.row));
        } 
*/
		// 실적년월, 실적현황
		if(e.colId == 'arlsYearMon' || e.colId == 'arlsStts') {
			var clickSeq = dataSet03.getNameValue(e.row, "seq");
			if( clickSeq != null && clickSeq != "" || clickSeq != undefined ){
				openTmboArslDialog(dataSet03.getAt(e.row), dataSet03.getNameValue(e.row,'seq'));
			}else{
				Rui.alert('목표저장 먼저 해주세요.');
			}
        }
	});

	grid.render('defaultGrid');

	/* [버튼] 삭제 */
	var butDel = new Rui.ui.LButton('butDel');
	butDel.on('click', function() {
		var dm1 = new Rui.data.LDataSetManager({defaultFailureHandler: false});

//		console.log("chk rowCount :"+dataSet03.getMarkedCount());

		if(dataSet03.getMarkedCount() > 0) {
			Rui.confirm({
		        text: '목표를 삭제하시겠습니까?<BR>입력한 실적도 모두 삭제됩니다.',
		        handlerYes: function() {

	        		// chk 체크처리
	        		fnChkMark(dataSet03);

	        		dm1.updateDataSet({
	        	        url: "<c:url value='/prj/rsst/mbo/deletePrjRsstMboInfo.do'/>",
	        	        dataSets:[dataSet03],
	        	        params: {
	        	            prjCd : pTopForm.prjCd.value
	        	        }
	        	    });

		        },
		        handlerNo: Rui.emptyFn
		    });
		}else{
			Rui.alert(Rui.getMessageManager().get('$.base.msg108'));
            return;
		}

		dm1.on('success', function(e) {
			//Rui.alert("삭제되었습니다.");
			var resultData = resultDataSet.getReadData(e);
            Rui.alert(resultData.records[0].rtnMsg);

			// 재조회
			fnSearch();
		});

		dm1.on('failure', function(e) {
			ruiSessionFail(e);
		});
	});

	/* [버튼] 목록 */
	var butGoList = new Rui.ui.LButton('butGoList');
	butGoList.on('click', function() {
		nwinsActSubmit(document.tabForm03, "<c:url value='/prj/rsst/mst/retrievePrjRsstMstInfoList.do'/>",'_parent');
	});

	/* [버튼] 목표등록 : 등록팝업 호출 */
/* 	var butRgst = new Rui.ui.LButton('butRgst');
	butRgst.on('click', function() {
		openMboPlnDialog('');
	});
 */	
	/* [버튼] 목표추가 : 레코드추가 */
	var butRecordNew = new Rui.ui.LButton('butRecordNew');
	butRecordNew.on('click', function() {
		var row = dataSet03.newRecord();
	    var record = dataSet03.getAt(row);
	    record.set('prjCd', pTopForm.prjCd.value);
	    record.set('wbsCd', pTopForm.wbsCd.value);
	    
	    dataSet03.setMark(row, true);	//체크박스 체크
	});
	
	/* [버튼] 실적등록 : 실적등록 팝업호출[목표고정] */
	var butArslReg = new Rui.ui.LButton('butArslReg');
	butArslReg.on('click', function() {
		
		// 1. 체크박스 체크
		var chkGoalMarkCnt = 0;
		var chkGoalYear;
		var chkGoalSeq = 0;
		var chkGoalRow = -1;
		var chkNoGoalSeq = 0;
		for( var i = 0 ; i < dataSet03.getCount() ; i++ ){
	    	if(dataSet03.isMarked(i)){
	    		if(dataSet03.getNameValue(i, 'goalSeq') == undefined){
	    			chkNoGoalSeq++;
	    		}
	    		
	    		if( chkGoalSeq != dataSet03.getNameValue(i, 'goalSeq') || chkGoalYear != dataSet03.getNameValue(i, 'mboGoalYear') ){
	    			chkGoalYear = dataSet03.getNameValue(i, 'mboGoalYear');
	    			chkGoalSeq = dataSet03.getNameValue(i, 'goalSeq');
		    		chkGoalRow = i;
		    		chkGoalMarkCnt++;
		    		
		    		if(chkGoalMarkCnt >= 2) break;
	    		}
	    	}
	    }
//		alert(chkGoalMarkCnt);
		if(chkGoalMarkCnt == 0){
			Rui.alert('실적등록할 목표를 선택해 주세요.');
			return false;
		}
		if(chkGoalMarkCnt >= 2){
			Rui.alert('실적등록할 목표를 여러개 선택할 수 없습니다.');
			return false;
		}
		if(chkNoGoalSeq >= 1){
			Rui.alert('목표저장 먼저 해주세요.');
			return false;
		}
		
		// 팝업호출
		openTmboArslDialog(dataSet03.getAt(chkGoalRow),'');
	});
	
	/* [버튼] 저장 */
	var butSave = new Rui.ui.LButton('butSave');
	butSave.on('click', function() {
		var dm2 = new Rui.data.LDataSetManager({defaultFailureHandler: false});

		if(dataSet03.getMarkedCount() > 0) {
			// 1. chk 체크처리
			fnChkMark(dataSet03);

			// 2. 데이터셋 valid
			if(!validation(dataSet03)){
	    		return false;
	    	}

			// 3. 데이터입력
			Rui.confirm({
		        text: '저장하시겠습니까?',
		        handlerYes: function() {

		        	// 등록처리
	        		dm2.updateDataSet({
	        	        url: "<c:url value='/prj/rsst/mbo/savePrjRsstMboInfo.do'/>",
	        	        dataSets:[dataSet03],
	        	        params: {
	        	            prjCd : parent.topForm.prjCd.value
	          	          , wbsCd : parent.topForm.wbsCd.value
	        	        }
	        	    });
		        },
		        handlerNo: Rui.emptyFn
		    });
		}else{
			Rui.alert(Rui.getMessageManager().get('$.base.msg108'));
            return;
		}

		dm2.on('success', function(e) {
			var resultData = resultDataSet.getReadData(e);
            Rui.alert(resultData.records[0].rtnMsg);

			// 재조회
			fnSearch();
		});

		dm2.on('failure', function(e) {
				ruiSessionFail(e);
		});
	});
	
	/* [ 계획MBO Dialog] */
	mboPlnDialog = new Rui.ui.LFrameDialog({
        id: 'mboPlnDialog',
        title: '계획 MBO( 특성지표)',
        width:  500,
        height: 400,
        modal: true,
        visible: false,
        buttons : [
            { text:'닫기', handler: function() {
              	this.cancel(false);
              }
            }
        ]
    });

	mboPlnDialog.render(document.body);

	/* [ 실적MBO Dialog] */
	mboArslDialog = new Rui.ui.LFrameDialog({
        id: 'mboArslDialog',
        title: '실적 MBO( 특성지표)',
        width:  500,
        height: 500,
        modal: true,
        visible: false,
        buttons : [
            { text:'닫기', handler: function() {
              	this.cancel(false);
              }
            }
        ]
    });

	mboArslDialog.render(document.body);
	
	/**--------------------- 첨부파일 시작 -----------------------**/
	/* 첨부파일 팝업오픈 */
/* 	openMboAttachFilePopup = function(fid,row){
		var recordData;
		var vFilId= '';

		fileUploadGridIndex = row;
		vFilId = nullToString(fid);
		openAttachFileDialog(setAttachFileInfo, vFilId, 'anlPolicy', '*');
	} */
	
	
	/* 첨부파일 세팅 */
/*    	setAttachFileInfo = function(attachFileList) {

   		var recordFilId = '';
		if(fileUploadGridIndex != null){
			
			recordFilId = dataSet03.getAt(fileUploadGridIndex).get('filId');
			
			// 첨부파일ID가 신규이면 데이터셋 세팅, 데이터 업데이트
			if(Rui.util.LString.isEmpty(recordFilId) && attachFileList.length > 0){ 
				dataSet03.getAt(fileUploadGridIndex).set('filId',attachFileList[0].data.attcFilId);
				
				// 첨부파일 업데이트
				fnMboRecordFilIdUpdate(dataSet03.getAt(fileUploadGridIndex));
				
			}
		}
    	
    	fileUploadGridIndex = null;
    }; */
    /**--------------------- 첨부파일 끝 -----------------------**/
    
    /* 첨부파일 콜백 세팅 */
   	setMboAttachFileInfo = function(attachFileList) {
    };

	// 온로드 조회
	fnSearch();
    
	if("<c:out value='${inputData._roleId}'/>".indexOf('WORK_IRI_T15') > -1) {
    	$("#butArslReg").hide();
    	$("#butDel").hide();
    	$("#butRecordNew").hide();
    	$("#butSave").hide();
	}else if("<c:out value='${inputData._roleId}'/>".indexOf('WORK_IRI_T16') > -1) {
    	$("#butArslReg").hide();
    	$("#butDel").hide();
    	$("#butRecordNew").hide();
    	$("#butSave").hide();
	}
	
});

<%--/*******************************************************************************
 * FUNCTION 명 : fnSearch
 * FUNCTION 기능설명 : MBO 그리드 조회(dataSet03)
 *******************************************************************************/--%>
function fnSearch(){

	dataSet03.load({
        url: '<c:url value="/prj/rsst/mbo/retrievePrjRsstMboSearchInfo.do"/>' ,
        params :{
		    prjCd : pTopForm.prjCd.value
        }
    });

}

<%--/*******************************************************************************
 * FUNCTION 명 : fnChkMark
 * FUNCTION 기능설명 : 데이터셋 체킹(isMarked : true 이면 chk 1
 *******************************************************************************/--%>
function fnChkMark(mDataSet){
	var markDataSet = mDataSet;
	for( var i = 0 ; i < markDataSet.getCount() ; i++ ){
    	if(markDataSet.isMarked(i))
    		markDataSet.setNameValue(i, 'chk', '1' );
    	else
    		markDataSet.setNameValue(i, 'chk', '0' );
    }
}

<%--/*******************************************************************************
 * FUNCTION 명 : 첨부파일 업로드 팝업 호출
 * FUNCTION 기능설명 : 선택데이터셋 체크 + 공통 첨부파일 팝업 호출 
 *******************************************************************************/--%>



<%--/*******************************************************************************
 * FUNCTION 명 : 계획MBO 팝업 호출 (openMboPlnDialog)
 * FUNCTION 기능설명 :
 *******************************************************************************/--%>
function openMboPlnDialog(rd){
	var recordData;
	var url = '';
	if(rd != null && rd != ''){
		recordData = rd;
		url = '?prjCd='+recordData.get('prjCd')
			+ '&wbsCd='+recordData.get('wbsCd')
			+ '&seq='+recordData.get('seq')
			;
	}
	mboPlnDialog.setUrl('<c:url value="/prj/rsst/mbo/openPrjRsstMboDtlPlnPopup.do'+url+' "/>');
	mboPlnDialog.show();
}

<%--/*******************************************************************************
 * FUNCTION 명 : 실적MBO 팝업 호출 (openMboArslDialog)
 * FUNCTION 기능설명 : 
 * FUNCTION 파라미터 : 레코드, 시퀀스(신규 '')
 *******************************************************************************/--%>
function openMboArslDialog(rd,seq){
	var recordData;
	var url = '';
	var arslNewYn = 'N';
	if(seq == '' || seq == null || seq == undefined  ){
		arslNewYn = 'Y';
	}
	if(rd != null && rd != ''){
		recordData = rd;
		url = '?prjCd='+recordData.get('prjCd')
			+ '&wbsCd='+recordData.get('wbsCd')
			+ '&seq='+recordData.get('seq')
			+ '&goalSeq='+recordData.get('goalSeq')
			+ '&arslNewYn='+arslNewYn
			;
	}
	mboArslDialog.setUrl('<c:url value="/prj/rsst/mbo/openPrjRsstMboDtlArslPopup.do'+url+' "/>');
	mboArslDialog.show();
}

<%--/*******************************************************************************
 * FUNCTION 명 : 실적MBO 팝업 호출 (openTmboArslDialog)
 * FUNCTION 기능설명 : 
 * FUNCTION 파라미터 : 레코드, 시퀀스(신규 '')
 *******************************************************************************/--%>
function openTmboArslDialog(rd,seq){
	var recordData;
	var url = '';
	var arslNewYn = 'N';
	if(seq == '' || seq == null || seq == undefined  ){
		arslNewYn = 'Y';
	}
	if(rd != null && rd != ''){
		recordData = rd;
		url = '?prjCd='+recordData.get('prjCd')
			+ '&wbsCd='+recordData.get('wbsCd')
			+ '&seq='+recordData.get('seq')
			+ '&goalSeq='+recordData.get('goalSeq')
			+ '&arslNewYn='+arslNewYn
			;
	}
	
	parent.tmboArslDialog.setUrl('<c:url value="/prj/rsst/mbo/openPrjRsstMboDtlArslPopup.do'+url+' "/>');
	parent.tmboArslDialog.show();
}

<%--/*******************************************************************************
 * FUNCTION 명 : 첨부파일ID 업데이트
 * FUNCTION 기능설명 :
 *******************************************************************************/--%>
function fnMboRecordFilIdUpdate(rd)
{
	
	var recordData;
	var dm1 = new Rui.data.LDataSetManager({defaultFailureHandler: false});
	
	if(rd != null && rd != ''){
		recordData = rd;
	}
	
	// 폼 업데이트
	dm1.updateForm({
	    url: "<c:url value='/prj/rsst/mbo/insertPrjRsstMboInfo.do'/>",
	    form: 'tabForm03',
	    params: {
	        prjCd : pTopForm.prjCd.value
	      , wbsCd : pTopForm.wbsCd.value
	      , hSeq  : recordData.get('seq')
	      , filId : recordData.get('filId')
	    }
	});
}

<%--/*******************************************************************************
 * FUNCTION 명 : validation
 * FUNCTION 기능설명 : 입력 데이터셋 점검
 *******************************************************************************/--%>
 function validation(vDataSet){
	
	// 1. 데이터셋 rui valid
 	var vTestDataSet = vDataSet;
 	if(vmTab03.validateDataSet(vTestDataSet) == false) {
 		Rui.alert(Rui.getMessageManager().get('$.base.msg052') + '<br>' + vmTab03.getMessageList().join('<br>') );
 		return false;

 	}
 	
 	// 2. 년도별 목표배점(goalSeq별) 총합 100 저장 valid
 	// 2.1 전체 데이터셋 반복 -> 년도 데이터셋 반복 
 	var testMboGoalYear = '';
 	var sumGoalAltp = 0;
 	var testGoalSeq = 0;
 	for(var i=0; i< vTestDataSet.getCount(); i++ ){
 		sumGoalAltp = 0;
 		var iMboGoalYear = vTestDataSet.getNameValue(i,"mboGoalYear");
 		if( testMboGoalYear != iMboGoalYear ){
 			testMboGoalYear = iMboGoalYear;
 			
 			// 년도별 총합 구하기
 			testGoalSeq = 0;
 			for(var j=0; j< vTestDataSet.getCount(); j++){
				
 				// 목표년도가 같고, goalSeq가 다른경우 총합계산
 				if( (vTestDataSet.getNameValue(j,"mboGoalYear") == testMboGoalYear) && 
 					( (vTestDataSet.getNameValue(j,"goalSeq") != testGoalSeq)  || (vTestDataSet.getNameValue(j,"goalSeq") == testGoalSeq && testGoalSeq == undefined)  ) ){
 					
 					sumGoalAltp += Number(vTestDataSet.getNameValue(j,"mboGoalAltp"));
 					testGoalSeq = vTestDataSet.getNameValue(j,"goalSeq");
 				}
 			}
// 			alert(sumGoalAltp);
 			if( sumGoalAltp != 100 ){
 		 		Rui.alert( testMboGoalYear+"년도 목표배점 총합이 100 이 아닙니다.");
 		 		return false;
 		 	}
 		}
 	}
 	
 	return true;
 }

</script>
</head>
<body>
<form name="tabForm03" id="tabForm03" method="post"></form>
    <%-- <Tag:saymessage /> --%>
    <%--<!--  sayMessage 사용시 필요 -->--%>

    <div class="titArea">
<!--     	<h3>  MBO ( 특성지표)</h3> -->
        <div class="LblockButton">
        	<button type="button" id="butArslReg" name="butArslReg">실적추가</button>
            <button type="button" id="butDel" name="butDel">목표삭제</button>
<!--             <button type="button" id="butRgst" name="butRgst">목표등록</button> -->
            <button type="button" id="butRecordNew" name="butRecordNew">목표추가</button>
        </div>
    </div>

    <div id="defaultGrid"></div>

    <div class="titArea btn_btm">
		<div class="LblockButton">
			<button type="button btn_btm" id="butSave" name="butSave">저장</button>
			<button type="button" id="butGoList" name="butGoList">목록</button>
		</div>
	</div>

</body>
</html>