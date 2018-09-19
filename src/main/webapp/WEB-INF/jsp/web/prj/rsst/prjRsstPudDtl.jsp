<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*, java.util.*,devonframe.util.NullUtil,devonframe.util.DateUtil"%>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>

<%--
/*
 *************************************************************************
 * $Id      : prjRsstPudDtl.jsp
 * @desc    : 연구팀 > 현황 > 프로젝트 등록 > 산출물 탭
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

<%-- month Calendar --%>
<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/calendar/LMonthCalendar.js"></script>
<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/form/LMonthBox.js"></script>
<link rel="stylesheet" type="text/css" href="<%=ruiPathPlugins%>/ui/form/LMonthBox.css"/>

<script type="text/javascript">
var nowDate = new Date();
var nYear  = nowDate.getFullYear();
var nMonth = nowDate.getMonth() + 1; // 0부터 시작하므로 1더함 더함
if (("" + nMonth).length == 1) { nMonth = "0" + nMonth; }

var pTopForm = parent.topForm;
var vmTab02;				// dataSet02 Validator
var fileUploadGridIndex; 	// 첨부파일 그리드 인덱스
var lcbYldType;		  		// 그리드 산출물유형 콤보
var grid;

Rui.onReady(function() {

	/* COMBO : PRJ_PDU_TYPE_CD(산출물유형) => yldType */
    lcbYldType = new Rui.ui.form.LCombo({
        useEmptyText: true,
        emptyText: '선택',
        url: '<c:url value="/common/code/retrieveCodeListForCache.do?comCd=PRJ_PDU_TYPE_CD"/>',
        displayField: 'COM_DTL_NM',
        valueField: 'COM_DTL_CD',
        autoMapping: true
    });
    lcbYldType.on('changed', function(e) {
        //e.target; //this객체
        //e.value; //code값
        //e.displayValue; //displayValue값
    });

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

	/* DATASET : grid */
	var dataSet02 = new Rui.data.LJsonDataSet({
	    id: 'dataSet02',
	    remainRemoved: true,
	    lazyLoad: true,
	    fields: [
	    	  { id: 'chk'}
	        , { id: 'prjCd'}
	        , { id: 'wbsCd'}
	        , { id: 'seq'}
	        , { id: 'pduGoalYear', defaultValue: nYear }
	        , { id: 'pduGoalCnt', defaultValue: 0 }
	        , { id: 'yldType' }
	        , { id: 'yldTitle'}
	        , { id: 'arslYearMon' }
	        , { id: 'arslCnt', defaultValue: 0 }
	        , { id: 'filId'}
	    ]
	});
	// 데이터셋 변경시 체크박스 체크
	dataSet02.on('update', function(e) {
		if( e.colId != 'chk' ){
			dataSet02.setMark(e.row, true);
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

	/* COLUMN : grid */
	var columnModel = new Rui.ui.grid.LColumnModel({
	    columns: [
	    	new Rui.ui.grid.LSelectionColumn({
				width: 30,  align:'cneter'
			})
	        , { field: 'prjCd',          label: '프로젝트코드', sortable: false, align:'center', width: 100, hidden: true}
	        , { field: 'wbsCd',          label: 'WBS코드', sortable: false, align:'center', width: 100, hidden: true }
	        , { field: 'seq',            label: '순서', sortable: false, align:'center', width: 100, hidden: true }
	        , { field: 'pduGoalYear',    label: '목표년도', sortable: false, align:'center', width: 80 , editor: lcbGoalYear }
	        , { field: 'pduGoalCnt',     label: '목표개수', sortable: false, align:'right', width: 80 ,editor: new Rui.ui.form.LNumberBox() }
	        , { field: 'yldType',        label: '산출물유형', sortable: false, align:'center', width: 120 , editor: lcbYldType }
	        , { field: 'yldTitle',       label: '산출물제목', sortable: false, align:'left', width: 300 , editor: new Rui.ui.form.LTextBox({ attrs: { maxLength: 60 } }) }
	        , { field: 'arslYearMon',    label: '실적년월', sortable: false, align:'center', width: 100
	        	, editor: new Rui.ui.form.LMonthBox({
	        		mask: '9999-99',
	        		displayValue: '%Y-%m',
//	        		defaultValue: new Date(),
	        		dateType: 'string',
	        		maskValue: true
	        	})
	          }
	        , { field: 'arslCnt',        label: '실적개수', sortable: false, align:'right', width: 80 }
//	        , { field: 'filId',          label: '파일ID', sortable: false, align:'center', width: 100, hidden: true }
	        , { id: 'filId',            label: '첨부파일',   sortable: false, align:'right', width: 100,
	            renderer: function(val, p, record, row, i){
	            	var recordFilId = nullToString(val);
	            	var strBtnFun = "openMboAttachFilePopup('" + recordFilId + "','" + row + "')";
	            	return '<button type="button" class="L-grid-button L-popup-action" onclick="'+strBtnFun+'">첨부파일</button>';
	          }},
	    ]
	});

	/* GRID : grid */
	grid = new Rui.ui.grid.LGridPanel({
	    columnModel: columnModel,
	    dataSet: dataSet02,
	    width: 600,
	    height: 450,
	    autoToEdit: true,
	    autoWidth: true
	});

	<%-- VALIDATOR --%>
	vmTab02 = new Rui.validate.LValidatorManager({
        validators:[
	          { id: 'pduGoalYear' , validExp:'목표년도:true'}
	        , { id: 'pduGoalCnt'  , validExp:'목표개수:true'}
	        , { id: 'yldType'     , validExp:'산출물유형:true'}
//	        , { id: 'yldTitle'    , validExp:'산출물제목:true'}
//	        , { id: 'arslYearMon' , validExp:'실적년월:true'}
//	        , { id: 'arslCnt'     , validExp:'실적개수:true'}
        ]
    });

	grid.on('cellClick', function(e) {
	});

	grid.render('defaultGrid');


	/* [버튼] 등록 */
	var butRecordNew = new Rui.ui.LButton('butRecordNew');
	butRecordNew.on('click', function() {
		var row = dataSet02.newRecord();
	    var record = dataSet02.getAt(row);
	    record.set('prjCd', pTopForm.prjCd.value);
	    record.set('wbsCd', pTopForm.wbsCd.value);
	});

	/* [버튼] 삭제 */
	var butRecordDel = new Rui.ui.LButton('butRecordDel');
	butRecordDel.on('click', function() {
		var dm1 = new Rui.data.LDataSetManager({defaultFailureHandler: false});

		if(dataSet02.getMarkedCount() > 0) {
			Rui.confirm({
		        text: '변경된 데이터는 저장되지 않습니다.<br/>' + Rui.getMessageManager().get('$.base.msg107'),
		        handlerYes: function() {

		        	// 기존데이터 여부 확인
		        	var cntOrgData = 0;
		        	var rangeMap = dataSet02.getMarkedRange();
		        	for(var i=0; i<dataSet02.getMarkedCount();i++){
		        		console.log("rangeMap seq :"+rangeMap.items[i].data.seq);
		        		if( !Rui.isEmpty(rangeMap.items[i].data.seq) ){
		        			cntOrgData++;
		        		}
		        	}

		        	// 1. 기존데이터 삭제면 삭제처리
		        	if(cntOrgData > 0 ){

		        		// chk 체크처리
		        		fnChkMark(dataSet02);

		        		dm1.updateDataSet({
		        	        url: "<c:url value='/prj/rsst/pdu/deletePrjRsstPduInfo.do'/>",
		        	        dataSets:[dataSet02],
		        	        params: {
		        	            prjCd : parent.topForm.prjCd.value
		        	        }
		        	    });

		        	// 2. 등록했던 ROW만 제거시 제거
		        	}else{
		        		dataSet02.removeMarkedRows();
		        	}

		        },
		        handlerNo: Rui.emptyFn
		    });
		}else{
			Rui.alert(Rui.getMessageManager().get('$.base.msg108'));
            return;
		}

		dm1.on('success', function(e) {
			var resultData = resultDataSet.getReadData(e);
			
            Rui.alert({
                text: resultData.records[0].rtnMsg,
                handler: function() {
                	// 재조회
        			fnSearch();
                }
            });
            
		});

		dm1.on('failure', function(e) {
				ruiSessionFail(e);
		});
	});

	/* [버튼] 목록 */
	var butGoList = new Rui.ui.LButton('butGoList');
	butGoList.on('click', function() {
		nwinsActSubmit(document.tabForm02, "<c:url value='/prj/rsst/mst/retrievePrjRsstMstInfoList.do'/>",'_parent');
	});

	/* [버튼] 저장 */
	var butRgst = new Rui.ui.LButton('butRgst');
	butRgst.on('click', function() {
		var dm2 = new Rui.data.LDataSetManager({defaultFailureHandler: false});

		if(dataSet02.getMarkedCount() > 0) {
			// 1. chk 체크처리
			fnChkMark(dataSet02);

			// 2. 데이터셋 valid
			if(!validation(dataSet02)){
	    		return false;
	    	}

			// 3. 데이터입력
			Rui.confirm({
		        text: '저장하시겠습니까?', //Rui.getMessageManager().get('$.base.msg105'),
		        handlerYes: function() {

		        	// 등록처리
	        		dm2.updateDataSet({
	        	        url: "<c:url value='/prj/rsst/pdu/insertPrjRsstPduInfo.do'/>",
	        	        dataSets:[dataSet02],
	        	        params: {
	        	            prjCd : parent.topForm.prjCd.value
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

            Rui.alert({
                text: resultData.records[0].rtnMsg,
                handler: function() {
                	// 재조회
        			fnSearch();
                }
            });

		});

		dm2.on('failure', function(e) {
				ruiSessionFail(e);
		});
	});

	/* [조회] */
	fnSearch = function() {

		dataSet02.load({
	        url: '<c:url value="/prj/rsst/pdu/retrievePrjRsstPduSearchInfo.do"/>' ,
	        params :{
			    prjCd : parent.topForm.prjCd.value
	        }
	    });

	}
	/**--------------------- 첨부파일 시작 -----------------------**/
	/* 첨부파일 팝업오픈 */
	openMboAttachFilePopup = function(fid,row){
		var recordData;
		var vFilId= '';

		fileUploadGridIndex = row;
		vFilId = nullToString(dataSet02.getNameValue(row,'filId'));
		
		openAttachFileDialog(setAttachFileInfo, vFilId, 'prjPolicy', '*');
	}

	/* 첨부파일 세팅 */
   	setAttachFileInfo = function(attachFileList) {
		
   		var recordFilId = '';
		if(fileUploadGridIndex != null){
			
			recordFilId = dataSet02.getAt(fileUploadGridIndex).get('filId');
			
			// 첨부파일ID가 신규이면 데이터셋 세팅
			if(Rui.util.LString.isEmpty(recordFilId) && attachFileList.length > 0){ 
				dataSet02.getAt(fileUploadGridIndex).set('filId',attachFileList[0].data.attcFilId);
			}
		}

    	fileUploadGridIndex = -1;
    };
    /**--------------------- 첨부파일 끝 -----------------------**/
	

	// 온로드 조회
	fnSearch();
    
	if("<c:out value='${inputData._roleId}'/>".indexOf('WORK_IRI_T15') > -1) {
    	$("#butRecordDel").hide();
    	$("#butRecordNew").hide();
    	$("#butRgst").hide();
	}else if("<c:out value='${inputData._roleId}'/>".indexOf('WORK_IRI_T16') > -1) {
    	$("#butRecordDel").hide();
    	$("#butRecordNew").hide();
    	$("#butRgst").hide();
	}

});

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
 * FUNCTION 명 : validation
 * FUNCTION 기능설명 : 입력 데이터셋 점검
 *******************************************************************************/--%>
 function validation(vDataSet){

 	var vTestDataSet = vDataSet;
 	
 	for(var i=0; i < vTestDataSet.getCount(); i++ ){
 		if( vTestDataSet.isMarked(i) ){
 			// 1.Rui valid
		 	if(vmTab02.validateDataSet(vTestDataSet,i) == false) {
		 		Rui.alert(Rui.getMessageManager().get('$.base.msg052') + '<br>' + vmTab02.getMessageList().join('<br>') );
		 		return false;
		 	}
 			
 			// 2. 동일 목표년도,  동일 산출물유형인 경우 목표개수 동일체크
 			var testPduGoalYear = stringNullChk(vTestDataSet.getNameValue(i,'pduGoalYear'));
 			var testYldType     = stringNullChk(vTestDataSet.getNameValue(i,'yldType'));
 			var testPduGoalCnt  = stringNullChk(vTestDataSet.getNameValue(i,'pduGoalCnt'));
 			for( var j=0; j< vTestDataSet.getCount(); j++ ){
 				if(i == j) continue;
 				if( testPduGoalYear == stringNullChk(vTestDataSet.getNameValue(j,'pduGoalYear')) && testYldType == stringNullChk(vTestDataSet.getNameValue(j,'yldType')) &&
 					testPduGoalCnt != stringNullChk(vTestDataSet.getNameValue(j,'pduGoalCnt'))	 ){
 					
					var yldNm = '';
					try{
						yldNm = $(grid.getView().getValue(i,3)).text();
					}catch(e){ }
						
 					Rui.alert( testPduGoalYear +'년도 ' + yldNm + '의 목표개수가 서로 다릅니다.');
		 			return false;
 				}
 			}
 			
		 	// 3. 실적을 입력했을 경우 실적 필수 체크(산출물제목, 실적년월, 첨부파일은 한꺼번에 등록)
		 	var testYldTitle = vTestDataSet.getNameValue(i,'yldTitle');			// 산출물제목
		 	var testArslYearMon = vTestDataSet.getNameValue(i,'arslYearMon');	// 실적년월
		 	var testFilId = vTestDataSet.getNameValue(i,'filId');				// 산출물파일ID
		 	if( (testYldTitle != null && testYldTitle != '' && testYldTitle != undefined) || 
		 		(testArslYearMon != null && testArslYearMon != '' && testArslYearMon != undefined) || 
		 		(testFilId != null && testFilId != '' && testFilId != undefined) ){
		 		
		 		if( (testYldTitle == null || testYldTitle == '' || testYldTitle == undefined) ){
		 			Rui.alert( (i+1) +' row 산출물제목은 필수입력입니다.');
		 			return false;
		 		}
		 		
		 		if( (testArslYearMon == null || testArslYearMon == '' || testArslYearMon == undefined) ){
		 			Rui.alert( (i+1) +' row 실적년월은 필수입력입니다.');
		 			return false;
		 		}
		 		
		 		if( (testFilId == null || testFilId == '' || testFilId == undefined) ){
		 			Rui.alert( (i+1) +' row 첨부파일은 필수등록입니다.');
		 			return false;
		 		}
		 	}
 		}// marking check for loop
 	}// dataset for loop
 	
 	return true;
 }
</script>

</head>
<body>
<form name="tabForm02" id="tabForm02" method="post"></form>
    <%-- <Tag:saymessage /> --%>
    <%--<!--  sayMessage 사용시 필요 -->--%>

    <div class="titArea">
<!--     	<h3>산출물 등록</h3> -->
        <div class="LblockButton">
            <button type="button" id="butRecordDel" name="butRecordDel">삭제</button>
            <button type="button" id="butRecordNew" name="butRecordNew">등록</button>
        </div>
    </div>

    <div id="defaultGrid"></div>

    <div class="titArea btn_btm">
		<div class="LblockButton">
			<button type="button" id="butRgst" name="butRgst" >저장</button>
			<button type="button" id="butGoList" name="butGoList">목록</button>
		</div>
	</div>

</body>
</html>