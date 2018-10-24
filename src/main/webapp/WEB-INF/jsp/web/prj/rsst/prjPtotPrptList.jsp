<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*, java.util.*,devonframe.util.NullUtil,devonframe.util.DateUtil"%>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>

<%--
/*
 *************************************************************************
 * $Id      : prjPtotPrptInfoList.jsp
 * @desc    : 연구팀 > 프로젝트 등록 > 지적재산권 조회&등록&수정 화면
 *------------------------------------------------------------------------
 * VER  DATE        AUTHOR      DESCRIPTION
 * ---  ----------- ----------  -----------------------------------------
 * 1.0  2017.08.24  IRIS04      최초생성
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

<%-- toolTip --%>
<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/LTooltip.js"></script>
<link rel="stylesheet" type="text/css" href="<%=ruiPathPlugins%>/ui/LTooltip.css"/>

<script type="text/javascript">
var nowDate = new Date();
var nYear  = nowDate.getFullYear();

var pTopForm = parent.topForm;                 // 프로젝트마스터 폼
var pTrResultDataSet = parent.trResultDataSet; // 처리결과 호출용 데이터셋
var vmTab04;			                       // dataSet04 Validator
var dataSet04;                                 // 계획지적재산권 데이터셋
var erpDataSet;								   // 실적지적재산권 데이터셋

Rui.onReady(function() {

    /* COMBO : 목표년도 2011년~2030년 => prptGoalYear */
    var lcbPrptGoalYear = new Rui.ui.form.LCombo({
    	useEmptyText: true,
        emptyText: '선택',
        emptyValue: '',
        autoMapping: true,
        items: [
        	<c:forEach var="i" begin="0" varStatus="status" end="19">
     		{ value : "${ 2030 - i }" , text : "${ 2030 - i }" } ,
     		</c:forEach>
        ]
    });

    lcbPrptGoalYear.on('changed', function(e){
    	var prptGoalYear;
    	var dupCnt = 0;
    	for(var i=0; i<dataSet04.getCount(); i++){
    		prptGoalYear = dataSet04.getAt(i).get('prptGoalYear');
    		if(prptGoalYear == e.value){
    			dupCnt++;
    		}
    	}
		if(dupCnt > 0){
			Rui.alert('중복된 목표년도를 선택할 수 없습니다.');
			lcbPrptGoalYear.setValue('');
		}
    });

	/* COMBO : 특허구분(PRMW_TYPE_CD) => frnwScn */
    var lcbFrnwScn = new Rui.ui.form.LCombo({
        useEmptyText: true,
        emptyText: '선택',
        emptyValue: '',
        url: '<c:url value="/common/code/retrieveCodeListForCache.do?comCd=PRMW_TYPE_CD"/>',
        displayField: 'COM_DTL_NM',
        valueField: 'COM_DTL_CD',
        autoMapping: true
    });

	/* DATASET : grid */
	dataSet04 = new Rui.data.LJsonDataSet({
	    id: 'dataSet04',
	    remainRemoved: true,
	    lazyLoad: true,
	    fields: [
	    	  { id: 'chk' , defaultValue: 0}
		    , { id: 'prptId'}
	    	, { id: 'prjCd'}
	        , { id: 'wbsCd'}
	        , { id: 'prptGoalYear', defaultValue: nYear}
	        , { id: 'prptGoalCnt' , defaultValue: 0 }
	        , { id: 'frnwScn'}
	        , { id: 'patCnt' , defaultValue: 0 }	/*실적개수*/
	    ]
	});
	// 데이터셋 변경시 체크박스 체크
	dataSet04.on('update', function(e) {

	    dataSet04.setMark(e.row, true);
	});

	/* DATASET : grid */
	erpDataSet = new Rui.data.LJsonDataSet({
	    id: 'erpDataSet',
	    remainRemoved: true,
	    lazyLoad: true,
	    fields: [
		      { id: 'wbsCode' }    /*WBS코드*/
	    	, { id: 'patNo' }      /*출원번호*/
	        , { id: 'paHname' }    /*출원명*/
	        , { id: 'patDate' }    /*출원일*/
	        , { id: 'regNo' }      /*등록번호*/
	        , { id: 'regDate' }    /*등록일*/
	        , { id: 'statusName' } /*상태명*/
	        , { id: 'empHname' }   /*발행자*/
	        , { id: 'krOx' }       /*한국여부*/
	    ]
	});

	var gridTooltip = new Rui.ui.LTooltip({
        showmove: true
    });

	/* COLUMN : grid01 */
	var columnModel01 = new Rui.ui.grid.LColumnModel({
	    columns: [
	    	new Rui.ui.grid.LSelectionColumn({
				width: 30,  align:'cneter'
			})
	    	, { field: 'prptId',         label: '지적재산권ID', sortable: false, align:'center', width: 100, hidden: true}
	        , { field: 'prjCd',          label: '프로젝트코드', sortable: false, align:'center', width: 100, hidden: true}
	        , { field: 'wbsCd',          label: 'WBS코드', sortable: false, align:'center', width: 100, hidden: true }
	        , { field: 'prptGoalYear',   label: '목표년도', sortable: false, align:'center', width: 80 , editor: lcbPrptGoalYear }
	        , { field: 'prptGoalCnt',    label: '목표개수', sortable: false, align:'right', width: 80 ,editor: new Rui.ui.form.LNumberBox() }
	        , { field: 'frnwScn',        label: '특허유형', sortable: false, align:'center', width: 100 , editor: lcbFrnwScn }

	        , { field: 'patCnt',    label: '실적개수', sortable: false, align:'right', width: 80 }
	    ]
	});

	/* COLUMN : grid02 */
	var columnModel02 = new Rui.ui.grid.LColumnModel({
	    columns: [
	    	  { field: 'patNo',         label: '출원번호', sortable: false, align:'center', width: 120}
	        , { field: 'paHname',       label: '출원명', sortable: false, align:'left', width: 400
	        	, renderer: function(value, p, record){
	        		p.tooltipText = value;
        			return value;
	        	}
	          }
	        , { field: 'patDate',       label: '출원일', sortable: false, align:'center', width: 100 }
	        , { field: 'regNo',         label: '등록번호', sortable: false, align:'center', width: 100  }
	        , { field: 'regDate',       label: '등록일', sortable: false, align:'center', width: 80  }
	        , { field: 'statusName',    label: '상태', sortable: false, align:'center', width: 130  }
	        , { field: 'empHname',      label: '발명자', align:'center', width: 130
	        	, renderer: function(value, p, record){
                        p.tooltipText = value;
	        		return value;
	        	  }
	          }
	        , { field: 'krOx',          label: '해외출원', sortable: false, align:'center', width: 60  }
	    ]
	});

	/* GRID : grid01 */
	var grid01 = new Rui.ui.grid.LGridPanel({
	    columnModel: columnModel01,
	    dataSet: dataSet04,
	    width: 600,
	    height: 200,
	    autoToEdit: true,
	    autoWidth: true
	});
	grid01.render('defaultGrid01');

	/* GRID : grid02 */
	var grid02 = new Rui.ui.grid.LGridPanel({
	    columnModel: columnModel02,
	    dataSet: erpDataSet,
	    width: 600,
	    height: 400,
	    autoToEdit: true,
	    autoWidth: true,
	    viewConfig: {
            tooltip: gridTooltip
        }
	});
	/* grid02.on('resize', function(e) {
	    alert('resize가 호출되었습니다.');
	}); */

	grid02.render('defaultGrid02');

	<%-- VALIDATOR --%>
	vmTab04 = new Rui.validate.LValidatorManager({
        validators:[
	        { id: 'prptGoalYear' , validExp:'목표년도:true'}
	      , { id: 'prptGoalCnt'  , validExp:'목표개수:true:number'}
	      , { id: 'frnwScn'      , validExp:'특허유형:true'}
        ]
    });

	/* [버튼] 추가 */
	var butRecordNew = new Rui.ui.LButton('butRecordNew');
	butRecordNew.on('click', function() {
		var row = dataSet04.newRecord();
	    var record = dataSet04.getAt(row);
	    record.set('prjCd', pTopForm.prjCd.value);
	    record.set('wbsCd', pTopForm.wbsCd.value);
	});

	/* [버튼] 삭제 */
	var butRecordDel = new Rui.ui.LButton('butRecordDel');
	butRecordDel.on('click', function() {
		var dm1 = new Rui.data.LDataSetManager({defaultFailureHandler: false});
		//pTrResultDataSet.clearData();

		if(dataSet04.getMarkedCount() > 0) {
			Rui.confirm({
		        text: '변경된 데이터는 저장되지 않습니다.<br/>' + Rui.getMessageManager().get('$.base.msg107'),
		        handlerYes: function() {

		        	// 기존데이터 여부 확인
		        	var cntOrgData = 0;
		        	var rangeMap = dataSet04.getMarkedRange();
		        	for(var i=0; i<dataSet04.getMarkedCount();i++){
		        		if( !Rui.isEmpty(rangeMap.items[i].data.prptId) ){
		        			cntOrgData++;
		        		}
		        	}

		        	// 1. 기존데이터 삭제면 삭제처리
		        	if(cntOrgData > 0 ){

		        		// chk 체크처리
		        		fnChkMark(dataSet04);

		        		// 삭제처리
		        		dm1.updateDataSet({
		        	        url: "<c:url value='/prj/rsst/ptotprpt/deletePrjPtotPrptInfo.do'/>",
		        	        dataSets:[dataSet04]
		        	    });

		        	// 2. 등록했던 ROW만 제거시 제거
		        	}else{
		        		dataSet04.removeMarkedRows();
		        	}

		        },
		        handlerNo: Rui.emptyFn
		    });
		}else{
			Rui.alert(Rui.getMessageManager().get('$.base.msg108'));
            return;
		}

		dm1.on('success', function(e) {
			var resultData = pTrResultDataSet.getReadData(e);
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
		nwinsActSubmit(document.tabForm04, "<c:url value='/prj/rsst/mst/retrievePrjRsstMstInfoList.do'/>",'_parent');
	});

	/* [버튼] 저장 */
	var butRgst = new Rui.ui.LButton('butRgst');
	butRgst.on('click', function() {
		var dm2 = new Rui.data.LDataSetManager({defaultFailureHandler: false});
		//pTrResultDataSet.clearData();

		if(dataSet04.getMarkedCount() > 0) {
			// 1. chk 체크처리
			fnChkMark(dataSet04);

			// 2. 데이터셋 valid
			if(!validation(dataSet04)){
	    		return false;
	    	}

			// 3. 데이터입력
			Rui.confirm({
		        text: '저장하시겠습니까?', //Rui.getMessageManager().get('$.base.msg105'),
		        handlerYes: function() {

		        	// 등록처리
	        		dm2.updateDataSet({
	        	        url: "<c:url value='/prj/rsst/ptotprpt/insertPrjPtotPrptInfo.do'/>",
	        	        dataSets:[dataSet04]
	        	    });
		        },
		        handlerNo: Rui.emptyFn
		    });
		}else{
			Rui.alert(Rui.getMessageManager().get('$.base.msg108'));
            return;
		}

		dm2.on('success', function(e) {
			var resultData = pTrResultDataSet.getReadData(e);

            Rui.alert({
                text: resultData.records[0].rtnMsg,
                handler: function() {
                	// 재조회
        			fnSearch();
                }
            });

		});

		dm2.on('failure', function(e) {
			//ruiSessionFail(e);
			var resultData = pTrResultDataSet.getReadData(e);
            Rui.alert(resultData.records[0].rtnMsg);
		});
	});

	// 마스터폼 disable
	//var topForm = new Rui.ui.form.LForm('topForm');
	//parent.lfTopForm.disable();
	parent.fnChangeFormEdit('disable');

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
 * FUNCTION 명 : 목록조회(fnSearch)
 * FUNCTION 기능설명 :
 *******************************************************************************/--%>
function fnSearch() {

/* 	dataSet04.load({
        url: '<c:url value="/prj/rsst/ptotprpt/retrievePrjPtotPrptSearchInfo.do"/>' ,
        params :{
		    prjCd : pTopForm.prjCd.value
        }
    }); */

	var dm = new Rui.data.LDataSetManager();

	dm.loadDataSet({
		dataSets: [ dataSet04, erpDataSet ],
		url: '<c:url value="/prj/rsst/ptotprpt/retrievePrjPtotPrptSearchInfo.do"/>' ,
        params :{
        	prjCd : pTopForm.prjCd.value
          , wbsCd : pTopForm.wbsCd.value
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
 * FUNCTION 명 : validation
 * FUNCTION 기능설명 : 입력 데이터셋 점검
 *******************************************************************************/--%>
function validation(vDataSet){

	var vTestDataSet = vDataSet;
	var vTestValidManager = vmTab04;

	// 1. 기본 rui validation
	if(vTestValidManager.validateDataSet(vTestDataSet) == false) {
		Rui.alert(Rui.getMessageManager().get('$.base.msg052') + '<br>' + vTestValidManager.getMessageList().join('<br>') );
		return false;
	}

	// 2. 추가 validation

	// 2.1 목표년도와 특허유형으로 중복체크
	var testValue;	// 목표년도_특허유형
   	var isDup = false;
   	var dupCnt = 0;
   	for(var i=0; i<vTestDataSet.getCount(); i++){

		testValue = vTestDataSet.getNameValue(i,'prptGoalYear') + "_" + vTestDataSet.getNameValue(i,'frnwScn');

   		dupCnt = 0;
   		for(var j=0; j< vTestDataSet.getCount(); j++){
   			if(testValue == (vTestDataSet.getNameValue(j,'prptGoalYear')+"_"+vTestDataSet.getNameValue(j,'frnwScn')  ) ){
   				dupCnt++;
   			}
   		}
   		if(dupCnt > 1){
   			isDup = true;
   			break;
   		}
   	}
	if(isDup){
		Rui.alert('목표년도와 특허유형이 중복되면 저장할 수 없습니다.');
		return false;
	}

	return true;
 }
</script>
<script>
$(window).load(function() {
    initFrameSetHeight();
});
</script>
</head>
<body>
<form name="tabForm04" id="tabForm04" method="post">
<input type="hidden" name=pageNum value="${inputData.pageNum}"/>
</form>
    <%-- <Tag:saymessage /> --%>
    <%--<!--  sayMessage 사용시 필요 -->--%>

    <div class="titArea">
    	<h3>계획 지적재산권</h3>
        <div class="LblockButton">
            <button type="button" id="butRecordDel" name="butRecordDel">삭제</button>
            <button type="button" id="butRecordNew" name="butRecordNew">추가</button>
        </div>
    </div>

    <div id="defaultGrid01"></div>

    <div class="titArea btn_btm">
		<div class="LblockButton">
			<button type="button" id="butRgst" name="butRgst" >저장</button>
			<!-- <button type="button" id="butGoList" name="butGoList">목록</button> -->
		</div>
	</div>

	<br>

	<div class="titArea">
    	<h3>실적 지적재산권</h3>
    </div>

	<div id="defaultGrid02"></div>

	<div class="titArea btn_btm">
		<div class="LblockButton">
			<button type="button" id="butGoList" name="butGoList">목록</button>
		</div>
	</div>

</body>
</html>