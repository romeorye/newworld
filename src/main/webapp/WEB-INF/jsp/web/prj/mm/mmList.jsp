<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*, java.util.*,devonframe.util.NullUtil,devonframe.util.DateUtil"%>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>

<%--
/*
 *************************************************************************
 * $Id      : mmList.jsp
 * @desc    : M/M 관리 > M/M 입력(내가 참여중인  과제) 목록 화면
              진입경로 1. IRIS 메뉴
                       2. TO-DO 링크
 *------------------------------------------------------------------------
 * VER  DATE        AUTHOR      DESCRIPTION
 * ---  ----------- ----------  -----------------------------------------
 * 1.0  2017.09.05  IRIS04      최초생성
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

<%-- rui total summary  --%>
<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/grid/LTotalSummary.js"></script>
<link rel="stylesheet" type="text/css" href="<%=ruiPathPlugins%>/ui/grid/LTotalSummary.css"/>

<script type="text/javascript">
var mmClsDataSet;	// 참여과제 데이터셋
var mmClsVm;		// 참여과제 VM
var lmbSearchMonth; // 조회달력

var nowDate = new Date();
var strNowMonth = createDashMonthToString(nowDate);
var strPreMonth = addDashMonthToString(createDashMonthToString(nowDate), -1);

var userSabun = "<c:out value = '${inputData._userSabun}'/>";
var testSabun = '';
//userSabun = testSabun;

var userDept = "<c:out value = '${inputData._userDept}'/>";	// 유저 부서코드
var testUserDept = "";
//userDept = testUserDept;

var userJoinProjects = "<c:out value = '${inputData.userJoinProjects}'/>";	// 유저조직의 프로젝트코드 문자열
var testUserJoinProjects = "";
//userJoinProjects = testUserJoinProjects;

var searchDate = new Date();										// 화면로딩시검색월
var isTodoLink = false;												// todo link 여부
var loginSysCd  = "<c:out value = '${inputData.LOGIN_SYS_CD}'/>";	// to-do 인입여부(MW)
var mwTodoReqNo = "<c:out value = '${inputData.MW_TODO_REQ_NO}'/>"; // to-do req-no
if(loginSysCd == "MW"){
	isTodoLink = true;
	searchDate = new Date ( searchDate.setMonth( searchDate.getMonth() - 1 ) );   // 이전달
}

Rui.onReady(function() {

	/* [달력] 내가 참여중인  과제 */
	lmbSearchMonth = new Rui.ui.form.LMonthBox({
        applyTo: 'searchMonth',
        defaultValue: searchDate,
        dateType: 'string',
        width: 100
    });
    lmbSearchMonth.on('changed', function(e){
    	if(lmbSearchMonth.getValue() == ''){
    		Rui.alert('기준월를 선택해주세요.');
    		lmbSearchMonth.setValue(strNowMonth);
    		lmbSearchMonth.focus();
    		return false;
    	}
    });

    /* [숫자텍스트박스] 그리드 참여율 */
    var lnbPtcPro = new Rui.ui.form.LNumberBox({
        //applyTo: 'ptcPro',
        //placeholder: '숫자를 입력해주세요.',
        maxValue: 100,           // 최대값 입력제한 설정
        minValue: 0,                 // 최소값 입력제한 설정
        decimalPrecision: 0          // 소수점 자리수 3자리까지 허용
    });

    /* [팝업텍스트박스] 타과제추가 */
    var lpTEtcTssNm = new Rui.ui.form.LPopupTextBox({
        applyTo: 'etcTssNm',
        width: 300,
        editable: true,
        placeholder: '',
        emptyValue: '',
        enterToPopup: true
    });
    lpTEtcTssNm.on('popup', function(e){
    	openTssSearchDialog(setTssInfo);
    });

    /* [숫자텍스트박스] 타과제 참여율 */
    var lnbEtcTssPtcPro = new Rui.ui.form.LNumberBox({
        applyTo: 'etcTssPtcPro',
        //placeholder: '숫자를 입력해주세요.',
        maxValue: 100,           	  // 최대값 입력제한 설정
        minValue: 0,                  // 최소값 입력제한 설정
        decimalPrecision: 0           // 소수점 자리수 0자리까지 허용
    });

    /* [텍스트AREA] 타과제 메모 */
    var ltaEtcTssCommTxt = new Rui.ui.form.LTextArea({
 	   applyTo: 'etcTssCommTxt',
 	   placeholder: '',
 	   width: 350,
 	   height: 100
 	});

	/* [데이터셋] 내가 참여중인  과제 */
	mmClsDataSet = new Rui.data.LJsonDataSet({
	    id: 'mmClsDataSet',
	    remainRemoved: true,
	    lazyLoad: true,
	    fields: [
	    	  { id: 'prjNm' }
	    	, { id: 'prjCd' }
		    , { id: 'tssCd' }       /*과제코드*/
	    	, { id: 'tssNm' }		/*과제명*/
	        , { id: 'tssStrtDd' }   /*과제시작일(yyyy-mm-dd)*/
	        , { id: 'tssFnhDd' }    /*과제종료일(yyyy-mm-dd)*/
	        , { id: 'prePtcPro' }   /*전월참여율*/
	        , { id: 'ptcPro' }      /*이번달참여율*/
	        , { id: 'commTxt' }     /*메모*/
	        , { id: 'clsDataYn'}    /*해당월 IRIS_MM_CLS 데이터 존재유무*/
	        , { id: 'mmYymm' }      /*마감월*/
	        , { id: 'saSabunNew' }  /*사번*/
	        , { id: 'ousdTssYn' }   /*타과제여부*/
	        , { id: 'clsToDoYn'}    /*TODO 여부(완료여부)*/
	        , { id: 'clsYn'}        /*마감여부*/
	        , { id: 'tssWbsCd'}		/*과제wbs코드*/
	    ]
	});
	mmClsDataSet.on('load', function(e){
		// 1.완료버튼 저장, 2. 마감완료 시 화면수정불가 처리
		if( mmClsDataSet.getCount() > 0 &&
		  ( "Y" == mmClsDataSet.getNameValue(0,'clsToDoYn') || "Y" == mmClsDataSet.getNameValue(0,'clsYn') ) ){
			Rui.get('btnBlock').hide();	    //버튼 블럭
			mmClsGrid.setEditable(false);	//그리드수정 블가
		}else{
			Rui.get('btnBlock').show();	    //버튼 블럭
			mmClsGrid.setEditable(true);	//그리드수정 블가
		}
	});

	mmClsDataSet.on('update', function(e) {

		// 1. 총합계산 valid 처리
	    var mmClsRowCount = mmClsDataSet.getCount();
    	var startIndex = 0;
    	var endInedx = mmClsRowCount -1;
    	var sum = 0;
    	if(mmClsRowCount > -1){
    		sum = mmClsDataSet.sum('ptcPro', startIndex, endInedx);
    	}

    	if(sum > 100){
    		Rui.alert('참여율 총합은 100%를 넘을 수 없습니다.');
    		mmClsDataSet.setNameValue(e.row,'ptcPro',0);
    		return false;
    	}
	});

	/* [컬럼] 내가 참여중인  과제 */
	var mmClsColumnModel = new Rui.ui.grid.LColumnModel({
		//freezeColumnId: 'tssNm',
        groupMerge: true,
	    columns: [
	    	  { field: 'prjNm',         label: '프로젝트명', align:'left', width: 260 }
	        , { field: 'tssWbsCd',      label: '과제코드',  align:'center', width: 80 }
	        , { field: 'tssNm',         label: '과제명',  align:'left', width: 337 }
	        , { id : '과제기간'},
	        , { field: 'tssStrtDd',     groupId: '과제기간', hMerge: true, label: '시작일',   align:'center', width: 100 }
	        , { field: 'tssFnhDd',      groupId: '과제기간', hMerge: true, label: '종료일',   align:'center', width: 100 }
	        , { field: 'prePtcPro',     label: '전월 참여율',   align:'right', width: 90
	        	, renderer: function(value, p, record){
	        		if( !Rui.isEmpty(value) )	return value + '%'; }
	          }
	        , { field: 'ptcPro',        label: '참여율',   align:'right', width: 77 ,editor: lnbPtcPro
	        	, renderer: function(value, p, record){
	        		if( !Rui.isEmpty(value) )	return value + '%'; }
	          }
	        , { field: 'commTxt',       label: '메모',   align:'left', width: 280, editor: new Rui.ui.form.LTextBox() }
	    ]
	});
	/* [총합그리드] 내가 참여중인  과제 */
	var mmClsTotalSum = new Rui.ui.grid.LTotalSummary();
	mmClsTotalSum.on('renderTotalCell', mmClsTotalSum.renderer({
        label: {
            id: 'prePtcPro',
            text: '합계'
        },
        columns: {
        	ptcPro: { type: 'sum', renderer: 'number' }
        }
    }));

	/* [그리드] 내가 참여중인  과제 */
	var mmClsGrid = new Rui.ui.grid.LGridPanel({
	    columnModel: mmClsColumnModel,
	    dataSet: mmClsDataSet,
	    width: 600,
	    height: 560,
        viewConfig: {
        	plugins: [mmClsTotalSum]
  		},
	    autoWidth: true
	});
	mmClsGrid.render('defaultGrid');

	/* [필수데이터체크] 내가 참여중인  과제 */
	mmClsVm = new Rui.validate.LValidatorManager({
        validators:[
	        { id: 'ptcPro' , validExp:'참여율:true'}
        ]
    });

	/* [폼] 타과제추가 */
	var lfEtcTssForm = new Rui.ui.form.LForm('etcTssForm');

	/* [다이얼로그] 타과제추가 */
	var etcTssDialog = new Rui.ui.LDialog({
        applyTo: 'divEtcTss',
        width: 500,
        visible: false,
        postmethod: 'none',
        buttons: [
            { text:'닫기', isDefault: true, handler: function() {
                this.cancel(false);
            } }
        ]
    });

	/* [다이얼로그] 과제조회 */
    tssSearchDialog = new Rui.ui.LFrameDialog({
        id: 'tssSearchDialog',
        title: '과제 조회',
        width: 700,
        height: 500,
        modal: true,
        visible: false,
        buttons: [
            { text:'적용', handler: function() {
                this.submit(true);
            } },
            { text:'닫기', isDefault: true, handler: function() {
                this.cancel(false);
            } }
        ]
    });
    tssSearchDialog.render(document.body);

	/* [버튼] 타과제추가 */
	var lbButEctTssPtc = new Rui.ui.LButton('butEctTssPtc');
	lbButEctTssPtc.on('click', function() {

		// 다이어로그 show
		lfEtcTssForm.reset();
		var hiddenInputSetArr = Rui.get('etcTssForm').select('input[type=hidden]');
	    for(var i=0; i< hiddenInputSetArr.length; i++){
	    	var hiddenInputSet = hiddenInputSetArr.getAt(i);
	    	// linput hidden data 무시
	    	/*
	    	if(hiddenInputSet.hasClass('L-hidden-field')){
	    		continue;
	    	}
	    	*/
	    	hiddenInputSet.setValue('');
	    }

		etcTssDialog.show(true);
	});

	/* [버튼] 임시저장 */
	var lbButRgst = new Rui.ui.LButton('butRgst');
	lbButRgst.on('click', function() {
		var mmClsSaveDm = new Rui.data.LDataSetManager();

		// 1. 데이터셋 valid
		if(!validation(mmClsDataSet)){
    		return false;
    	}

		// 2. 데이터입력
		Rui.confirm({
	        text: '임시저장하시겠습니까?',
	        handlerYes: function() {

	        	// 등록처리
        		mmClsSaveDm.updateDataSet({
        	        url: "<c:url value='/prj/mm/insertMmIn.do'/>",
        	        dataSets:[mmClsDataSet],
        	        params :{
        			    searchMonth : lmbSearchMonth.getValue()
        	        }
        	    });
	        },
	        handlerNo: Rui.emptyFn
	    });

		mmClsSaveDm.on('success', function(e) {
			var data = Rui.util.LJson.decode(e.responseText);
            Rui.alert(data[0].records[0].rtnMsg);

			// 재조회
			fnSearch();
		});
		mmClsSaveDm.on('failure', function(e) {
			var data = Rui.util.LJson.decode(e.responseText);
            Rui.alert(data[0].records[0].rtnMsg);
		});

	});

	/* [버튼] 완료 */
	var lbButComp = new Rui.ui.LButton('butComp');
	lbButComp.on('click', function() {
		var mmClsSaveDm1 = new Rui.data.LDataSetManager();

		// 1. 데이터셋 valid
 		if(!validation(mmClsDataSet)){
    		return false;
    	}

		// 2. 참여율 총합 100 체크
		var nowSum = dataSetColSum(mmClsDataSet,'ptcPro');
		if( nowSum != 100){
			Rui.alert('참여율 총합이 100%가 아닙니다.');
    		return false;
		}

		// 3. 완료처리()
		Rui.confirm({
	        text: '완료하시겠습니까?',
	        handlerYes: function() {

	        	// 등록처리
        		mmClsSaveDm1.updateDataSet({
        			modifiedOnly: false,
        	        url: "<c:url value='/prj/mm/insertMmIn.do'/>",
        	        dataSets:[mmClsDataSet],
        	        params :{
        			    searchMonth : lmbSearchMonth.getValue()
        			  , toDoYn : 'Y'
        	        }
        	    });
	        },
	        handlerNo: Rui.emptyFn
	    });

		mmClsSaveDm1.on('success', function(e) {
			var data = Rui.util.LJson.decode(e.responseText);
            Rui.alert(data[0].records[0].rtnMsg);

			// 재조회
			fnSearch();
		});
		mmClsSaveDm1.on('failure', function(e) {
			var data = Rui.util.LJson.decode(e.responseText);
            Rui.alert(data[0].records[0].rtnMsg);
		});

	});

	/* [버튼] 초기화 : 타과제추가  */
	var lbButEtcTssClear = new Rui.ui.LButton('butEtcTssClear');
	lbButEtcTssClear.on('click', function() {
		lfEtcTssForm.reset();
		var hiddenInputSetArr = Rui.get('etcTssForm').select('input[type=hidden]');
	    for(var i=0; i< hiddenInputSetArr.length; i++){
	    	var hiddenInputSet = hiddenInputSetArr.getAt(i);
	    	// linput hidden data 무시
	    	/*
	    	if(hiddenInputSet.hasClass('L-hidden-field')){
	    		continue;
	    	}
	    	*/
	    	hiddenInputSet.setValue('');
	    }
	});

	/* [버튼] 저장 : 타과제추가*/
	var lbButEtcTssRgst = new Rui.ui.LButton('butEtcTssRgst');
	lbButEtcTssRgst.on('click', function() {

		// 1. 과제코드 VALID 체크
		var dupTssCdInx = mmClsDataSet.findRow('tssCd', etcTssForm.hEtcTssCd.value);
		if(dupTssCdInx > -1){
			Rui.alert('해당과제는 이미 참여중입니다.');
			return false;
		}

		// 2. 프로젝트 팀원여부 체크(조직체크)
		var etcPrjCd = etcTssForm.hEtcTssPrjCd.value;
		if( userJoinProjects.indexOf(etcPrjCd) == -1 ){
			Rui.alert('타 프로젝트 과제입니다.');
			return false;
		}

		// 2. 참여율 총합 valid 체크
		var nowSum = dataSetColSum(mmClsDataSet,'ptcPro');
		if( nowSum + lnbEtcTssPtcPro.getValue() > 100){
			lnbEtcTssPtcPro.focus();
			Rui.alert('참여율 총합은 100%를 넘을 수 없습니다.');
    		return false;
		}

		// 3. 과제기간 체크
		var nowSum = dataSetColSum(mmClsDataSet,'ptcPro');
		var hEtcTssStrtDd = etcTssForm.hEtcTssStrtDd.value;
		hEtcTssStrtDd = hEtcTssStrtDd.substring(0,7);
		var tssFnhDd = etcTssForm.hEtctssFnhDd.value;
		tssFnhDd = tssFnhDd.substring(0,7);
		if( (hEtcTssStrtDd > strNowMonth) || (tssFnhDd < strNowMonth) ){
			lnbEtcTssPtcPro.focus();
			Rui.alert('현재월이 과제기간 내에 포함되어 있지 않습니다.');
    		return false;
		}

		// 3. 신규ROW추가, 데이터 세팅
		var row = mmClsDataSet.newRecord();
	    var record = mmClsDataSet.getAt(row);
	    record.set('tssNm'     , lpTEtcTssNm.getValue());
	    record.set('ptcPro'    , lnbEtcTssPtcPro.getValue());
	    record.set('commTxt'   , ltaEtcTssCommTxt.getValue());
	    record.set('prjCd'     , etcTssForm.hEtcTssPrjCd.value);
	    record.set('prjNm'     , etcTssForm.hEtcTssPrjNm.value);
	    record.set('tssCd'     , etcTssForm.hEtcTssCd.value);
	    record.set('tssNm'     , etcTssForm.etcTssNm.value);
	    record.set('tssStrtDd' , etcTssForm.hEtcTssStrtDd.value);
	    record.set('tssFnhDd'  , etcTssForm.hEtctssFnhDd.value);
	    record.set('clsDataYn' , 'N');
	    record.set('ousdTssYn' , 'Y');
	    record.set('tssWbsCd'  , etcTssForm.hEtcTssWbsCd.value);

	    etcTssDialog.submit();
	});

	/* [함수] 과제팝업 오픈 */
	openTssSearchDialog = function(f) {
		_callback = f;
		var params = "?userDeptCd="+userDept;
		tssSearchDialog.setUrl('<c:url value="/prj/tss/com/tssSearchPopup.do"/>' + params);
		tssSearchDialog.show();
	};
	/* [함수] 과제팝업 콜백함수 : 데이터세팅 */
	setTssInfo = function(tssInfo) {
		lpTEtcTssNm.setValue(tssInfo.tssNm);
	    etcTssForm.hEtcTssPrjCd.value = tssInfo.prjCd;
	    etcTssForm.hEtcTssPrjNm.value = tssInfo.prjNm;
	    etcTssForm.hEtcTssCd.value = tssInfo.tssCd;
	    etcTssForm.hEtcTssStrtDd.value = tssInfo.tssStrtDd;
	    etcTssForm.hEtctssFnhDd.value = tssInfo.tssFnhDd;
	    etcTssForm.hEtcTssDeptCode.value = tssInfo.deptCode;
	    etcTssForm.hEtcTssWbsCd.value = tssInfo.wbsCd;
    };

	/* [함수] 화면초기화 */
	fnOnInit = function(){
		// 다이얼로그 숨김
		etcTssDialog.hide();

		// to-do link시 조회영역 숨김
		if(isTodoLink){
			Rui.get('mmSearchTable').hide();
		}
	}

	//화면초기화
	fnOnInit();

	// 화면오픈시 조회
	fnSearch();

});	<!-- //Rui.onReady end  -->

<%--/*******************************************************************************
 * FUNCTION 명 : 내가 참여중인 과제 목록조회 (fnSearch)
 * FUNCTION 기능설명 :
 *******************************************************************************/--%>
function fnSearch() {

	// 그리드타이틀 세팅
	Rui.get('spnDefaultGridTitle').html("");
	var strTitle;
	var strSearchMonth = lmbSearchMonth.getValue();
	if('0' == strSearchMonth.substring(5,6)){
		strTitle = strSearchMonth.substring(6,7);
	}else{
		strTitle = strSearchMonth.substring(5,7);
	}
	Rui.get('spnDefaultGridTitle').html("<h3>내가 참여중인 과제 – " + strTitle + "월 마감</h3>");

	// 데이터셋 조회
	mmClsDataSet.load({
        url: '<c:url value="/prj/mm/retrieveMmInSearchInfo.do"/>' ,
        params :{
		    searchMonth : lmbSearchMonth.getValue()
		  , searchPreMonth : addDashMonthToString(lmbSearchMonth.getValue(), -1)
		  , _userSabun  : userSabun
        }
    });
}

<%--/*******************************************************************************
 * FUNCTION 명 : fnDataSetChkMark
 * FUNCTION 기능설명 : 데이터셋 체킹(isMarked : true 이면 chk 1
 *******************************************************************************/--%>
function fnDataSetChkMark(mDataSet){
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
	var vTestValidManager = mmClsVm;

	// 1. 기본 rui validation
	if(vTestValidManager.validateDataSet(vTestDataSet) == false) {
		Rui.alert(Rui.getMessageManager().get('$.base.msg052') + '<br>' + vTestValidManager.getMessageList().join('<br>') );
		return false;
	}

	// 2. 추가 validation

	return true;
}

<%--/*******************************************************************************
 * FUNCTION 명 : 데이터셋 특정필드 총합(SUM)
 * FUNCTION 기능설명 :
 *******************************************************************************/--%>
function dataSetColSum(sumDataSet,colNm){
	var rowCount = sumDataSet.getCount();
	var sum = 0;
	if(rowCount > 0){
		var startIndex = 0;
		var endInedx = rowCount -1;
		sum = sumDataSet.sum(colNm, startIndex, endInedx);
	}
	return sum;
}
</script>

</head>
<body onkeypress="if(event.keyCode==13) {fnSearch();}">
	<div class="contents">
		<div class="titleArea">
			<a class="leftCon" href="#">
		        <img src="/iris/resource/web/images/img_uxp/ico_leftCon.png" alt="Left Navigation Control">
		        <span class="hidden">Toggle 버튼</span>
			</a>
 			<h2>M/M 입력</h2>
		</div>
		<div class="sub-content">

			<form name="searchForm" id="searchForm" method="post">
   				<div class="search">
					<div class="search-content">
		   				<table>
		   					<colgroup>
		   						<col style="width:10%"/>
		   						<col style="width:80%"/>
		   						<col style="width:10%"/>
		   					</colgroup>
		   					<tbody>
		   					    <tr>
		   							<th align="right">기준월</th>
		   							<td>
		   								<input type="text" id="searchMonth" name="searchMonth"/>
									</td>
									<td align="center">
										<a style="cursor: pointer;" onclick="fnSearch();" class="btnL">검색</a>
									</td>
		   						</tr>
		   					</tbody>
		   				</table>
	   				</div>
   				</div>
   			</form>

			<div class="titArea">
				<span id="spnDefaultGridTitle"><h3>내가 참여중인 과제 – 7월 마감</h3></span>
				<div class="LblockButton" id="btnBlock">
					<button type="button" id="butEctTssPtc" name="butEctTssPtc" >타과제추가</button>
					<button type="button" id="butRgst" name="butRgst" >저장</button>
					<button type="button" id="butComp" name="butComp"  class="redBtn">완료</button>
				</div>
			</div>

   			<div id="defaultGrid"></div>

			<!-- DIV DIALOG  -->
			<div id="divEtcTss">
                <div class="hd">타과제추가</div>
                <div class="bd">
                    <!-- <div class="titArea"> -->
						<div class="LblockButton" style="margin-bottom:4px;">
							<button type="button" id="butEtcTssClear" name="butEtcTssClear" >초기화</button>
							<button type="button" id="butEtcTssRgst" name="butEtcTssRgst" >저장</button>
						</div>
					<!-- </div> -->
					<form name="etcTssForm" id="etcTssForm" method="post">
						<input type="hidden" id="hEtcTssPrjCd" name="hEtcTssPrjCd">
						<input type="hidden" id="hEtcTssPrjNm" name="hEtcTssPrjNm">
						<input type="hidden" id="hEtcTssCd" name="hEtcTssCd">
						<input type="hidden" id="hEtcTssStrtDd" name="hEtcTssStrtDd">
						<input type="hidden" id="hEtctssFnhDd" name="hEtctssFnhDd">
						<input type="hidden" id="hEtcTssDeptCode" name="hEtcTssDeptCode">
						<input type="hidden" id="hEtcTssWbsCd" name="hEtcTssWbsCd">
						<table class="table table_txt_right">
							<colgroup>
								<col style="width:20%;"/>
								<col style="width:80%;"/>
							</colgroup>
							<tbody>
								<tr>
									<th align="right">타과제추가</th>
									<td>
										<input type="text" id ="etcTssNm" name="etcTssNm" >
										<!-- <a style="cursor: pointer;" onclick="openTssSearchDialog(setTssInfo);" class="icoBtn">검색</a> -->
									</td>
								</tr>
								<tr>
									<th align="right">참여율</th>
									<td>
										<input type="text" id ="etcTssPtcPro" name="etcTssPtcPro" >
									</td>
								</tr>
								<tr>
									<th align="right">메모</th>
									<td>
										<textarea id="etcTssCommTxt"></textarea>
									</td>
								</tr>
							</tbody>
						</table>
					</form>

               </div>
            </div><!-- //divEtcTss -->


   		</div><!-- //sub-content -->
   	</div><!-- //contents -->
</body>
</html>