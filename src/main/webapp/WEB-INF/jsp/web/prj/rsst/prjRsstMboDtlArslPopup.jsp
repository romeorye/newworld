<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*,
				 java.util.*,
				 devonframe.util.NullUtil,
				 devonframe.util.DateUtil"%>

<%--
/*
 *************************************************************************
 * $Id		: prjRsstMboDtlArslPopup.jsp
 * @desc    : MBO 실적 등록 팝업
 *------------------------------------------------------------------------
 * VER	DATE		AUTHOR		DESCRIPTION
 * ---	-----------	----------	-----------------------------------------
 * 1.0  2016.08.23  IRIS04		최초생성
 * ---	-----------	----------	-----------------------------------------
 * IRIS 구축 프로젝트
 *************************************************************************
 */
--%>
				 
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<%@ include file="/WEB-INF/jsp/include/rui_header.jspf"%>

<title><%=documentTitle%></title>

<%-- month Calendar --%>
<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/calendar/LMonthCalendar.js"></script>
<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/form/LMonthBox.js"></script>
<link rel="stylesheet" type="text/css" href="<%=ruiPathPlugins%>/ui/form/LMonthBox.css"/>

<script type="text/javascript">
var pTopForm = parent.parent.topForm;	// 프로젝트마스터 폼(탭기준)
var pTopFormMst = parent.topForm;		// 프로젝트마스터 폼(상단마스터기준)
var popupDataSet0302;					// 데이터셋
var mboAttachDataSet;					// 첨부파일 데이터셋
var vmTab0302;							// validator

var nowDate = new Date();
var nYear  = nowDate.getFullYear();
var nMonth = nowDate.getMonth() + 1; // 0부터 시작하므로 1더함 더함
if (("" + nMonth).length == 1) { nMonth = "0" + nMonth; }

var arslNewYn = 'N';
if( "Y" ==  "<c:out value='${inputData.arslNewYn}'/>" ){
	arslNewYn = 'Y';
}


Rui.onReady(function() {
	
	/* form 세팅 */
	var popForm02 = new Rui.ui.form.LForm('popupForm02');
	
	/* var lcbMboGoalYear = new Rui.ui.form.LCombo({
		applyTo: 'mboGoalYear',
    	useEmptyText: true,
        emptyText: '선택',
        items: [
        	<c:forEach var="i" begin="0" varStatus="status" end="19">
     		{ value : "${ 2030 - i }" , text : "${ 2030 - i }" } ,
     		</c:forEach>
        ]
    }); */
	
/* 	var lnbMboGoalAltp = new Rui.ui.form.LNumberBox({
        applyTo: 'mboGoalAltp',
        minValue: 0,
        maxValue: 10000,
        width: 110
    }); */
    
/* 	var ltbMboGoalPrvs = new Rui.ui.form.LTextBox({
	     applyTo : 'mboGoalPrvs',
	     //placeholder : '',
	     defaultValue : '',
	     emptyValue: '',
	     width : 350
	}); */
	
	var ltaMboGoalL = new Rui.ui.form.LTextArea({
        applyTo: 'mboGoalL',
        placeholder: '',
        width: 360,
        height: 100,
        editable: false
    });
	
	
	// form03
	var popForm03 = new Rui.ui.form.LForm('popupForm03');
	
	var lmbArlsYearMon = new Rui.ui.form.LMonthBox({
        applyTo: 'arlsYearMon',
        defaultValue: new Date(),
        dateType: 'string',
        width: 100
    });

	/* lmbArlsYearMon.on('blur', function(){
		if( ! Rui.util.LDate.isDate( Rui.util.LString.toDate(nwinsReplaceAll(lmbArlsYearMon.getValue(),"-","")) ) )  {
			alert('날자형식이 올바르지 않습니다.!!');
			lmbArlsYearMon.setValue(new Date());
		}
	}); */
	
	ltaArlsStts = new Rui.ui.form.LTextArea({
       applyTo: 'arlsStts',
       placeholder: '',
       width: 360,
       height: 100
    });

	/* DATASET : grid */
	popupDataSet0302 = new Rui.data.LJsonDataSet({
	    id: 'popupDataSet0302',
	    remainRemoved: true,
	    lazyLoad: true,
	    fields: [
	          { id: 'prjCd'}
	        , { id: 'wbsCd'}
	        , { id: 'seq'}
	        , { id: 'mboGoalYear'}
	        , { id: 'mboGoalAltp'}
	        , { id: 'mboGoalPrvs'}
	        , { id: 'mboGoalL'}
	        , { id: 'arlsYearMon', defaultValue: nYear+"-"+nMonth}
	        , { id: 'arlsStts'}
	        , { id: 'filId'}
	        , { id: 'goalSeq' }                        // 목표시퀀스
	    ]
	});
	
	popupDataSet0302.on('load', function(e){
		if( popupDataSet0302.getCount() > 0 && Rui.isEmpty(popupDataSet0302.getAt(0).get('arlsYearMon')) ){
			popupDataSet0302.setNameValue(0, 'arlsYearMon', createDashMonthToString(new Date()));
		}
		
		if( popupDataSet0302.getCount() > 0 ){
//			alert(arslNewYn);
			
			// 실적등록 버튼으로 추가하는 경우 데이터셋 제거처리
			// 제거필드 seq, arlsYearMon, arlsStts, filId
			if( arslNewYn == 'Y'){
				popupDataSet0302.setNameValue(0, 'seq'         , '');
				popupDataSet0302.setNameValue(0, 'arlsYearMon' , createDashMonthToString(new Date()));
				popupDataSet0302.setNameValue(0, 'arlsStts'    , '');
				popupDataSet0302.setNameValue(0, 'filId'       , '');
			}
			
			if( Rui.isEmpty(popupDataSet0302.getAt(0).get('arlsYearMon')) ){
				popupDataSet0302.setNameValue(0, 'arlsYearMon', createDashMonthToString(new Date()));
			}
			
//			bind02.setBind(true);
		}
		
		arslNewYn
    });
	
	/* 첨부파일 */
    mboAttachDataSet = new Rui.data.LJsonDataSet({
	    id: 'mboAttachDataSet',
	    remainRemoved: true,
	    lazyLoad: true,
	    fields: [
	          { id: 'attcFilId'}
	        , { id: 'seq'}
	        , { id: 'filNm'}
	        , { id: 'filPath'}
	        , { id: 'filSize'}
	    ]
	});
    mboAttachDataSet.on('load', function(e) {
    	
    	if(mboAttachDataSet.getTotalCount() > 0){
    		// 신규등록시 태그표시 안함
    		if( arslNewYn == 'Y'){ return; }
    		
            // 로드시 첨부파일 다운로드 태그표시
            $('#spnMboFilId').html('');
            for(var i=0; i<mboAttachDataSet.getCount(); i++) {
	   	    	$('#spnMboFilId').append($('<a/>', {
	   	            href: 'javascript:downloadAttachFile("' + mboAttachDataSet.getAt(i).get('attcFilId') + '", "' + mboAttachDataSet.getAt(i).get('seq') + '")',
	   	            text: mboAttachDataSet.getAt(i).get('filNm') + '(' + mboAttachDataSet.getAt(i).get('filSize') + 'byte)'
	   	        })).append('<br/>');
	    	}
    	}
    });

	/* [DataSet] bind */
    var bind01 = new Rui.data.LBind({
        groupId: 'popupForm02',
        dataSet: popupDataSet0302,
        bind: true,
        bindInfo: [
        	  { id: 'mboGoalYear',  ctrlId: 'spnMboGoalYear',      value: 'html' }
            , { id: 'mboGoalAltp',  ctrlId: 'spnMboGoalAltp',      value: 'html' }
            , { id: 'mboGoalPrvs',  ctrlId: 'spnMboGoalPrvs',      value: 'html' }
            , { id: 'mboGoalL',     ctrlId: 'mboGoalL',            value: 'value' }
        ]
    });
	
    var bind02 = new Rui.data.LBind({
        groupId: 'popupForm03',
        dataSet: popupDataSet0302,
        bind: true,
        bindInfo: [
        	  { id: 'arlsYearMon',  ctrlId: 'arlsYearMon',      value: 'value' }
            , { id: 'arlsStts',     ctrlId: 'arlsStts',         value: 'value' }
            , { id: 'filId',        ctrlId: 'hfilId',           value: 'value' }
        ]
    });
    
    /* [버튼] 실적MBO 파일업로드 */
   	var lbutMboAttachFileMng = new Rui.ui.LButton('butMboAttachFileMng');
   	lbutMboAttachFileMng.on('click', function() {
   		parent.openAttachFileDialog(setMboAttachFileInfo, popupForm03.hfilId.value, 'prjPolicy', '*');
   	});

	/* [버튼] 저장 */
	var butRgst = new Rui.ui.LButton('butRgst');
	butRgst.on('click', function() {
		var dm1 = new Rui.data.LDataSetManager({defaultFailureHandler: false});

		if(popupDataSet0302.isUpdated()){
		
			// 1. 데이터셋 valid
			if(!validation('popupForm03')){
	    		return false;
	    	}
			
			// 2. 데이터 저장&업데이트
			Rui.confirm({
		        text: '저장하시겠습니까?', //Rui.getMessageManager().get('$.base.msg105'),
		        handlerYes: function() {
		    		
		        	//신규 실적등록시 hseq 초기화
		        	if(arslNewYn == 'Y'){
		        		popupForm03.hSeq.value = '';
		        	}
		        	//alert(popupForm03.hSeq.value);
		        	
		        	// 등록처리
	        	    dm1.updateDataSet({
	        	        url: "<c:url value='/prj/rsst/mbo/insertPrjRsstMboInfo.do'/>",
	        	        dataSets:[popupDataSet0302]
	        	    });
		        	
		        },
		        handlerNo: Rui.emptyFn
		    });
		
		}else{
			Rui.alert(Rui.getMessageManager().get('$.base.msg102'));
            return;
		}
		
    	// 성공시 메시지팝업창 후 부모창 재조회
		dm1.on('success', function(e) {
            var data = Rui.util.LJson.decode(e.responseText);
            var rtnYn = data[0].records[0].rtnYn;
            
            Rui.alert({
                text: data[0].records[0].rtnMsg,
                handler: function() {
                	// 재조회(submit)
                	if("Y" == rtnYn){
                    	parent.tmboArslDialog.submit(true);
                    }
                }
            });
		});
			
		// 실패시 메시지팝업창 노출
		dm1.on('failure', function(e) {        
			var data = Rui.util.LJson.decode(e.responseText);
            Rui.alert(data[0].records[0].rtnMsg);
		});
	});
	
	/* [버튼] 삭제 */
	var butDel = new Rui.ui.LButton('butDel');
	butDel.on('click', function() {
		var dm2 = new Rui.data.LDataSetManager({defaultFailureHandler: false});

		// 1. 데이터 삭제
		Rui.confirm({
	        text: '실적을 삭제 하시겠습니까?',
	        handlerYes: function() {
	        	
	        	// 실적 삭제처리
        	    dm2.updateDataSet({
        	    	modifiedOnly: false,
        	        url: "<c:url value='/prj/rsst/mbo/deletePrjRsstMboArslInfo.do'/>",
        	        dataSets:[popupDataSet0302]
        	    });
	        	
	        },
	        handlerNo: Rui.emptyFn
	    });
		
    	// 성공시 메시지팝업창 후 부모창 재조회
		dm2.on('success', function(e) {
            var data = Rui.util.LJson.decode(e.responseText);
            var rtnYn = data[0].records[0].rtnYn;
            
            Rui.alert({
                text: data[0].records[0].rtnMsg,
                handler: function() {
                	// 재조회(submit)
                	if("Y" == rtnYn){
                    	parent.tmboArslDialog.submit(true);
                    }
                }
            });
		});
			
		// 실패시 메시지팝업창 노출
		dm2.on('failure', function(e) {        
			var data = Rui.util.LJson.decode(e.responseText);
            Rui.alert(data[0].records[0].rtnMsg);
		});
	});
	
	
	
	<%-- VALIDATOR --%>
	vmTab0302 = new Rui.validate.LValidatorManager({
        validators:[
	      //  { id: 'mboGoalYear' , validExp:'목표년도:true'}
	      //, { id: 'mboGoalAltp' , validExp:'목표배점:true'}
	      //, { id: 'mboGoalPrvs' , validExp:'목표항목:true'}
	      //, { id: 'mboGoalL'    , validExp:'목표수준:true'}
        ]
    });
	
	/* 첨부파일 세팅 */
   	setMboAttachFileInfo = function(attachFileList) {
    	$('#spnMboFilId').html('');
    	
    	if(attachFileList.length > 0){
    		var orgFilId = popupForm03.hfilId.value;
    		if( orgFilId != attachFileList[0].data.attcFilId ){
    			popupForm03.hfilId.value = attachFileList[0].data.attcFilId;
    			popupDataSet0302.setNameValue(0,"filId", attachFileList[0].data.attcFilId );
    		}
    	}

    	for(var i=0; i<attachFileList.length; i++) {
   	    	$('#spnMboFilId').append($('<a/>', {
   	            href: 'javascript:downloadAttachFile("' + attachFileList[i].data.attcFilId + '", "' + attachFileList[i].data.seq + '")',
   	            text: attachFileList[i].data.filNm + '(' + attachFileList[i].data.filSize + 'byte)'
   	        })).append('<br/>');
    	}
    };
    
    /* 첨부파일 다운 */
    downloadAttachFile = function(attcFilId, seq) {
    	var param = "?attcFilId=" + attcFilId + "&seq=" + seq;
    	popupForm03.action = '<c:url value='/system/attach/downloadAttachFile.do'/>' + param;
    	popupForm03.submit();
	};
    
    /* 첨부파일 조회 */
    getAttachFileId = function() {
    	return popupForm03.hfilId.value;
    };
	
    // 화면처리
    // 실적등록의 경우 삭제버튼 hide
    if(arslNewYn == 'Y'){
    	butDel.hide();
    }
    
	// 데이터 초기 조회
    fnSearch();

}); // end RUI Lodd

<%--/*******************************************************************************
 * FUNCTION 명 : fnSearch 
 * FUNCTION 기능설명 : MBO 단건 조회(popupDataSet0302)
 *******************************************************************************/--%>
function fnSearch(){
		
    var dm = new Rui.data.LDataSetManager();
	
	dm.loadDataSet({
		dataSets: [ popupDataSet0302, mboAttachDataSet ],
        url: '<c:url value="/prj/rsst/mbo/retrievePrjRsstMboSearchDtlInfo.do"/>' ,
        params :{
		    prjCd : popupForm02.hPrjCd.value
		  , wbsCd : popupForm02.hWbsCd.value
		  , seq   : popupForm02.hSeq.value
        }
    });
	    
}
<%--/*******************************************************************************
 * FUNCTION 명 : validation 
 * FUNCTION 기능설명 : 입력 폼 점검
 *******************************************************************************/--%>
function validation(vForm){
	
 	var vTestForm = vForm;
 	if(vmTab0302.validateGroup(vTestForm) == false) {
 		Rui.alert(Rui.getMessageManager().get('$.base.msg052') + '<br>' + vmTab0302.getMessageList().join('<br>') );
 		return false;
 	}
 	
 	return true;
 }

</script>
</head>

<body>

   			<div class="titArea">
<!-- 		    	<h3>실적 MBO( 특성지표)</h3> -->
		        <div class="LblockButton">
		            <!-- <button type="button" id="butClear" name="butClear">초기화</button> -->
		            <button type="button" id="butDel" name="butDel">삭제</button>
		            <button type="button" id="butRgst" name="butRgst">저장</button>
	        	</div>
	    	</div>
			
			<form name="popupForm02" id="popupForm02" method="post">
				<input type="hidden" id="hPrjCd" name="hPrjCd" value="<c:out value='${inputData.prjCd}'/>"/>
				<input type="hidden" id="hWbsCd" name="hWbsCd" value="<c:out value='${inputData.wbsCd}'/>"/>
				<input type="hidden" id="hSeq" name="hSeq" value="<c:out value='${inputData.seq}'/>"/>
  				<table class="table table_txt_right">
  					<colgroup>
  						<col style="width:20%;"/>
  						<col style="width:30%;"/>
  						<col style="width:20%;"/>
  						<col style="width:*;"/>
  					</colgroup>
  					<tbody>
  						<tr>
  							<th align="right">목표년도</th>
  							<td>
  								<!-- <select id="mboGoalYear"></select> -->
  								<span id="spnMboGoalYear"></span>
  							</td>
  							<th align="right">목표배점</th>
   							<td>
  								<!-- <input type="text" id="mboGoalAltp" value=""> -->
  								<span id="spnMboGoalAltp"></span>
   							</td>
  						</tr>
  						<tr>
  							<th align="right">목표항목</th>
  							<td colspan="3">
  								<!-- <input type="text" id="mboGoalPrvs" value=""> -->
  								<span id="spnMboGoalPrvs"></span>
  							</td>
  						</tr>
  						<tr>
  							<th align="right">목표수준</th>
  							<td colspan="3">
  								<textarea id="mboGoalL"></textarea>
  							</td>
  						</tr>
  					</tbody>
  				</table>
  			</form>

	    	<br>

  			<form name="popupForm03" id="popupForm03" method="post">
				<input type="hidden" id="hPrjCd" name="hPrjCd" value="<c:out value='${inputData.prjCd}'/>"/>
				<input type="hidden" id="hWbsCd" name="hWbsCd" value="<c:out value='${inputData.wbsCd}'/>"/>
				<input type="hidden" id="hSeq" name="hSeq" value="<c:out value='${inputData.seq}'/>"/>
				<input type="hidden" id="hfilId" name="hfilId" value=""/>
				<input type="hidden" id="hDownFilSeq" name="hDownFilSeq" value=""/>
  				<table class="table table_txt_right">
  					<colgroup>
  						<col style="width:20%;"/>
  						<col style="width:*;"/>
  						<col style="width:125px;"/>
  					</colgroup>
  					<tbody>
  						<tr>
  							<th align="right">실적년월</th>
  							<td colspan="2" >
  								<input type="text" id="arlsYearMon" value="">
  							</td>
  						</tr>
  						<tr>
  							<th align="right">실적현황</th>
  							<td colspan="2" >
  								<input type="text" id="arlsStts" value="">
  							</td>
  						</tr>
  						<tr>
  							<th align="right">첨부파일</th>
							<td align="left">
								<span id="spnMboFilId">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>
							</td>
							<td align="right" style="width:50px ">
								<button type="button" id="butMboAttachFileMng" name="butMboAttachFileMng">파일업로드</button>
							</td>
  						</tr>
  					</tbody>
  				</table>
  			</form>

</body>
</html>