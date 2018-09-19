<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*, java.util.*,devonframe.util.NullUtil,devonframe.util.DateUtil"%>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>

<%--
/*
 *************************************************************************
 * $Id      : mmClsList.jsp
 * @desc    : M/M 관리 > M/M 마감 목록 화면
                         메일보내기, 마감, 마감풀기, 엑셀다운
 *------------------------------------------------------------------------
 * VER  DATE        AUTHOR      DESCRIPTION
 * ---  ----------- ----------  -----------------------------------------
 * 1.0  2017.09.07  IRIS04      최초생성
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
var mmClsDataSet;	// 마감 데이터셋
var mmClsVm;		// 마감 VM
var mmClsGrid;		// 마감 그리드

var nowDate = new Date();
var strNowMonth = createDashMonthToString(nowDate);
var strPreMonth = addDashMonthToString(createDashMonthToString(nowDate), -1);

var searchDate = new Date();										// 화면로딩시검색월
var isTodoLink = false;												// todo link 여부
var loginSysCd = "<c:out value = '${inputData.LOGIN_SYS_CD}'/>";	// to-do 전달 파라미터(MW)
if(loginSysCd == "MW"){
	isTodoLink = true;
	searchDate = new Date ( searchDate.setMonth( searchDate.getMonth() - 1 ) );   // 이전달
}
var roleId = "<c:out value = '${inputData._roleId}'/>";				// roleId(권한)
var roleCheck = "PRD";
var chkRow;


Rui.onReady(function() {

	if("<c:out value='${inputData._roleId}'/>".indexOf('WORK_IRI_T01') > -1) {
		roleCheck = "ADM";
	}else if("<c:out value='${inputData._roleId}'/>".indexOf('WORK_IRI_T03') > -1) {
		roleCheck = "ADM";
	}else if("<c:out value='${inputData._roleId}'/>".indexOf('WORK_IRI_T05') > -1) {
		roleCheck = "ADM";
	}else if("<c:out value='${inputData._roleId}'/>".indexOf('WORK_IRI_T15') > -1) {
		roleCheck = "ADM";
	}else if("<c:out value='${inputData._roleId}'/>".indexOf('WORK_IRI_T16') > -1) {
		roleCheck = "ADM";
	}

	/* [달력] 기준월 */
	lmbSearchMonth = new Rui.ui.form.LMonthBox({
        applyTo: 'searchMonth',
        defaultValue: searchDate,
        dateType: 'string',
        width: 100
    });
	/* lmbSearchMonth.on('blur', function(){
    	if( ! Rui.util.LDate.isDate( Rui.util.LString.toDate(nwinsReplaceAll(lmbSearchMonth.getValue(),"-","")+'01' ) ) )  {
    		alert('날자형식이 올바르지 않습니다.!!');
    		lmbSearchMonth.setValue(new Date());
    	}
    });    */

    /* lmbSearchMonth.on('changed', function(e){
    	if(lmbSearchMonth.getValue() == ''){
    		Rui.alert('기준월를 선택해주세요.');
    		lmbSearchMonth.setValue(strNowMonth);
    		lmbSearchMonth.focus();
    		return false;
    	}
    }); */

    /* [숫자텍스트박스] 그리드 참여율 */
    var lnbPtcPro = new Rui.ui.form.LNumberBox({
        //applyTo: 'ptcPro',
        //placeholder: '숫자를 입력해주세요.',
        maxValue: 100,           // 최대값 입력제한 설정
        minValue: 0,                 // 최소값 입력제한 설정
        decimalPrecision: 0          // 소수점 자리수 3자리까지 허용
    });

    /* 참여율 0인건 체크 */
    var chkPtcPro = new Rui.ui.form.LCheckBox({
    	applyTo: 'chkPtcPro',
        label: '참여율 0건'
    });

    /* [팝업텍스트박스] 조직조회 */
    searchDeptName = new Rui.ui.form.LTextBox({
    //lpTbSearchDeptName = new Rui.ui.form.LPopupTextBox({
        applyTo: 'searchDeptName',
        width: 260,
        editable: true,
        placeholder: '',
        emptyValue: ''
    });

   /*  lpTbSearchDeptName.on('popup', function(e){
    	openDeptSearchDialog(setDeptInfo);
    }); */
    /* [함수] 조직조회 롤백 */
   /*  setDeptInfo = function(deptInfo) {
    	lpTbSearchDeptName.setValue(deptInfo.upperDeptNm);
    }; */

	/* [데이터셋] MM마감 */
	mmClsDataSet = new Rui.data.LJsonDataSet({
	    id: 'mmClsDataSet',
	    remainRemoved: true,
	    lazyLoad: true,
	    fields: [
              { id: 'chk' }
	    	, { id: 'clsDt' }
	    	, { id: 'saUser' }
		    , { id: 'saName' }
	    	, { id: 'uperdeptName' }
	        , { id: 'prjNm' }
	        , { id: 'tssCd' }
	        , { id: 'tssNm' }
	        , { id: 'prePtcPro' }
	        , { id: 'ptcPro' }
	        , { id: 'ilckSt'}
	        , { id: 'deptCode'}
	        , { id: 'clsYn'}       /*마감여부*/
	        , { id: 'mmYymm'}      /*마감월*/
	        , { id: 'saSabunNew'}  /*사번*/
	        , { id: 'prjCd'}       /*프로젝트코드*/
	        , { id: 'wbsCd'}       /*wbs코드*/
	        , { id: 'commTxt' }    /*메모*/
	        , { id: 'tssWbsCd' }   /*과제WBS코드*/
	        , { id: 'mailUser' }   /*메일발송 id*/
	    ]
	});
	mmClsDataSet.on('load', function(e){
		/*권한체크
		  1. 연동버튼(ADMIN, MM담당자만)
		 */
		if( lmbSearchMonth.getValue() ==  createDashMonthToString(new Date) ){
			if( roleId.indexOf("WORK_IRI_T01") != -1 || roleId.indexOf("WORK_IRI_T05") != -1 ){
				butSave.show();
				lbButIlck.show();
				lbButOpenSendMailPop.show();
				chkPtcPro.show()
			}else{
				butSave.hide();
				lbButIlck.hide();
				lbButOpenSendMailPop.hide();
				chkPtcPro.hide()

				if('${inputData._userSabun}' != '${inputData.plEmpNo}'){
					lbButClsClose.hide();
					lbButClsOpen.hide();
					lbButExcl.hide();
				}
			}
		}else{
			butSave.hide();
			lbButIlck.hide();
			lbButOpenSendMailPop.hide();
			lbButClsClose.hide();
			lbButClsOpen.hide();
		}


	});

	// 체크박스 클릭시
	mmClsDataSet.on('marked', function(e) {
		// 동일아이디 동시 체크/해제
	    var chkSaUser = mmClsDataSet.getNameValue(e.row, "saUser");
	    for(var i=0; i< mmClsDataSet.getCount(); i++){
	    	if( e.row != i && (chkSaUser == mmClsDataSet.getNameValue(i, "saUser")) ){
	    		mmClsDataSet.setMark(i, e.isSelect);
	    	}
	    }
	});

	// 데이터셋 업데이트시
	mmClsDataSet.on('update', function(e) {

		// 1. 변경자 참여율 총합계산
		var sum = 0;
		var chkSaUser = mmClsDataSet.getNameValue(e.row, "saUser");
	    for(var i=0; i< mmClsDataSet.getCount(); i++){
	    	if( chkSaUser == mmClsDataSet.getNameValue(i, "saUser") ){
	    		sum += Number(mmClsDataSet.getNameValue(i, "ptcPro"));
	    	}
	    }
    	if(sum > 100){
    		Rui.alert('참여율 총합은 100%를 넘을 수 없습니다.');
    		mmClsDataSet.setNameValue(e.row,'ptcPro',e.beforeValue);
    		return false;
    	}

    	// 2. 참여율, 메모 변경시 체크박스 체크처리
    	if( e.colId == 'ptcPro' || e.colId == 'commTxt' ){
    		// 동일아이디 동시 체크
    	    var chkSaUser = mmClsDataSet.getNameValue(e.row, "saUser");
    	    for(var i=0; i< mmClsDataSet.getCount(); i++){
    	    	if( chkSaUser == mmClsDataSet.getNameValue(i, "saUser") ){
    	    		mmClsDataSet.setMark(i, true);
    	    	}
    	    }
    	}
	});

	/* [컬럼] MM마감 */
	var mmClsColumnModel = new Rui.ui.grid.LColumnModel({
        groupMerge: true,
	    columns: [
	    	new Rui.ui.grid.LSelectionColumn({
				/*label: '체크',*/ width: 30,  align:'cneter'
				})
	    	, { field: 'clsYn',         label: '마감여부',   align:'center', width: 55 }
	    	, { field: 'clsDt',         label: '마감일자',   align:'center', width: 80 }
	       // , { field: 'saUser',        label: '아이디',     align:'center', width: 60 , vMerge: true }
	        , { field: 'saName',        label: '성명',       align:'center', width: 50 , vMerge: true }
	       // , { field: 'uperdeptName',  label: '조직',       align:'center', width: 150 , vMerge: true }
	        , { field: 'prjNm',         label: '프로젝트명', sortable: true,  align:'left', width: 220 , vMerge: true }
	        , { field: 'tssWbsCd',      label: '과제코드',   sortable: true, align:'center', width: 70 }
	        , { field: 'tssNm',         label: '과제명',     align:'left', width: 300  }
	        , { field: 'prePtcPro',     label: '전월참여율', align:'right', width: 80
	        	, renderer: function(value, p, record){
	        		if( !Rui.isEmpty(value) )	return value + '%'; }
	          }
	        , { field: 'ptcPro',        label: '참여율', sortable: true,  align:'right', width: 60, editor: lnbPtcPro
	        	, renderer: function(value, p, record){
	        		if(record.get("clsYn") == "Y"){  p.editable = false; }	// 마감여부 Y이면 수정불가
	        		return value + '%';
	        	  }
	          }
	        , { field: 'ilckSt',        label: '연동상태',   align:'center', width: 60 }
	        , { field: 'commTxt',       label: '메모',   align:'left', width: 300, editor: new Rui.ui.form.LTextBox({ attrs: { maxLength: 60 } })
		        , renderer: function(value, p, record){
	        		if(record.get("clsYn") == "Y"){  p.editable = false; }	// 마감여부 Y이면 수정불가
	        		return value;
	        	  }
	          }
	    ]
	});

	/* [그리드] MM마감 */
	mmClsGrid = new Rui.ui.grid.LGridPanel({
	    columnModel: mmClsColumnModel,
	    dataSet: mmClsDataSet,
	    width: 1200,
	    height: 580,
        autoWidth: true

	});
	mmClsGrid.render('defaultGrid');

	/**
	총 건수 표시
	**/
	mmClsDataSet.on('load', function(e){
		var seatCnt = 0;
	    var sumOrd = 0;
	    var sumMoOrd = 0;
	    var tmp;
	    var tmpArray;
		var str = "";

		document.getElementById("cnt_text").innerHTML = '총: '+ mmClsDataSet.getCount();

	});


	/* [다이얼로그] 메일발송 */
    _mailDialog = new Rui.ui.LFrameDialog({
        id: 'mailDialog',
        title: '메일',
        width: 600,
        height: 550,
        modal: true,
        visible: false,
        buttons: [
            { text:'닫기', isDefault: true, handler: function() {
                this.cancel(false);
            } }
        ]
    });
    _mailDialog.on('submit', function(e) {
    	Rui.alert('메일이 발송되었습니다.');
    });
    _mailDialog.render(document.body);

    /* [함수] 메일다이얼로그 오픈 */
	openMailDialog = function(f,userIds) {

		_callback = f;

		_mailDialog.setUrl('<c:url value="/prj/mm/mail/sendMailPopup.do"/>'+'?userIds=' + userIds);
		_mailDialog.show();
	};

    /* [버튼] 메일보내기  */
	var lbButOpenSendMailPop= new Rui.ui.LButton('butOpenSendMailPop');
	lbButOpenSendMailPop.on('click', function() {
		// 선택ID 목록 세팅
 		var chkUserIdList = [];
		var chkUserIds = '';
		for( var i = 0 ; i < mmClsDataSet.getCount() ; i++ ){
	    	if(mmClsDataSet.isMarked(i)){
	    		chkUserIdList.push(mmClsDataSet.getNameValue(i, 'mailUser'));
	    	}
		}
		chkUserIds = chkUserIdList.join(',');

		// 메일다이얼로그 오픈
		openMailDialog(null, chkUserIds);
	});

	var butSave = new Rui.ui.LButton('butSave');
	butSave.on('click', function() {
		var mmSaveDm = new Rui.data.LDataSetManager();

		// 1. 참여율총합 100% 체크
		if(!fnDataChkPtcProComp(mmClsDataSet)){
			return false;
		}

		Rui.confirm({
	        text: '저장 하시겠습니까?',
	        handlerYes: function() {

	        	// 3.2. 등록처리
        		mmSaveDm.updateDataSet({
        	        url: "<c:url value='/prj/mm/saveMmClsInfo.do'/>",
        	        dataSets:[mmClsDataSet],
        	        params: {
        	        	searchMonth : lmbSearchMonth.getValue()
        	        	,prjCd : mmClsDataSet.getNameValue(0, 'prjCd')
        	        }
        	    });
	        },
	        handlerNo: Rui.emptyFn
	    });

		mmSaveDm.on('success', function(e) {
			var data = Rui.util.LJson.decode(e.responseText);
	        Rui.alert(data[0].records[0].rtnMsg);

			// 재조회
			fnSearch();
		});
		mmSaveDm.on('failure', function(e) {
			var data = Rui.util.LJson.decode(e.responseText);
	        Rui.alert(data[0].records[0].rtnMsg);
		});

	});

	/* [버튼] 마감 => 마감여부 Y */
	var lbButClsClose = new Rui.ui.LButton('butClsClose');
	lbButClsClose.on('click', function() {

		var mmClsCloseDm = new Rui.data.LDataSetManager();

		if(mmClsDataSet.getMarkedCount() > 0) {
			// 1. 데이터셋 valid
			if(!validation(mmClsDataSet,'Y')){
	    		return false;
	    	}

			// 2. 참여율총합 100% 체크
			if(!fnDataChkPtcProComp(mmClsDataSet)){
				return false;
			}

			// 3. 데이터 업데이트
			Rui.confirm({
		        text: '마감 하시겠습니까?',
		        handlerYes: function() {

					// 3.1. chk 체크 및 데이터 마감여부 Y 처리
					fnDataSetChkMark(mmClsDataSet,'Y');

		        	// 3.2. 등록처리
	        		mmClsCloseDm.updateDataSet({
	        	        url: "<c:url value='/prj/mm/updateMmClsInfo.do'/>",
	        	        dataSets:[mmClsDataSet],
	        	        params: {
	        	        	searchMonth : lmbSearchMonth.getValue()
	        	        	,prjCd : mmClsDataSet.getNameValue(0, 'prjCd')
	        	        }
	        	    });
		        },
		        handlerNo: Rui.emptyFn
		    });
		}else{
			Rui.alert(Rui.getMessageManager().get('$.base.msg108'));
            return;
		}

		mmClsCloseDm.on('success', function(e) {
			var data = Rui.util.LJson.decode(e.responseText);
            Rui.alert(data[0].records[0].rtnMsg);

			// 재조회
			fnSearch();
		});
		mmClsCloseDm.on('failure', function(e) {
			var data = Rui.util.LJson.decode(e.responseText);
            Rui.alert(data[0].records[0].rtnMsg);
		});
	});

	/* [버튼] 마감풀기 */
	var lbButClsOpen = new Rui.ui.LButton('butClsOpen');
	lbButClsOpen.on('click', function() {
		var mmClsOpenDm = new Rui.data.LDataSetManager();

		if(mmClsDataSet.getMarkedCount() > 0) {

			// 1. 데이터셋 valid
			if(!validation(mmClsDataSet,'N')){
	    		return false;
	    	}

			// 2. 데이터 업데이트
			Rui.confirm({
		        text: '마감풀기를 하시겠습니까?',
		        handlerYes: function() {

					// 2.1. chk 체크 및 데이터 마감여부 N 처리
					fnDataSetChkMark(mmClsDataSet,'N');

		        	// 2.2. 등록처리
	        		mmClsOpenDm.updateDataSet({
	        	        url: "<c:url value='/prj/mm/updateMmClsInfo.do'/>",
	        	        dataSets:[mmClsDataSet],
	        	        params: {
	        	        	searchMonth : lmbSearchMonth.getValue()
	        	        	,prjCd : mmClsDataSet.getNameValue(0, 'prjCd')
	        	        }
	        	    });
		        },
		        handlerNo: Rui.emptyFn
		    });
		}else{
			Rui.alert(Rui.getMessageManager().get('$.base.msg108'));
            return;
		}

		mmClsOpenDm.on('success', function(e) {
			var data = Rui.util.LJson.decode(e.responseText);
            Rui.alert(data[0].records[0].rtnMsg);

			// 재조회
			fnSearch();
		});
		mmClsOpenDm.on('failure', function(e) {
			var data = Rui.util.LJson.decode(e.responseText);
            Rui.alert(data[0].records[0].rtnMsg);
		});

	});


	/* [버튼] 연동  */
	var lbButIlck = new Rui.ui.LButton('butIlck');
	lbButIlck.on('click', function() {
		// 연동로직 구현
		var mmClsCloseDm = new Rui.data.LDataSetManager();

		if(mmClsDataSet.getMarkedCount() > 0) {

			if(!validation(mmClsDataSet,'N')){ //마감이  'Y' 인건만 연동
	    		return false;
	    	}
			var markDataSet = mmClsDataSet;
			for( var i = 0 ; i < markDataSet.getCount() ; i++ ){ //check box한건에 대해 연동가능
		    	if(markDataSet.isMarked(i)){
		    		// 연동완료여부 체크
		    		if( markDataSet.getNameValue(i, 'ilckSt') == 'Y'){
		    			Rui.alert('이미 연동완료된 인원이 있습니다.');
		    			return false;
		    		}

		    		markDataSet.setNameValue(i, 'chk', '1' );
		    	}
		    }

			// 1. 데이터 업데이트
			Rui.confirm({
		        text: "연동하시겠습니까?",
		        handlerYes: function() {

		        	// 등록처리
	        		mmClsCloseDm.updateDataSet({
	        	        url: "<c:url value='/prj/mm/updateMmIlckSap.do'/>",
	        	        dataSets:[markDataSet],
	        	        params: {
	        	        	searchMonth : lmbSearchMonth.getValue()
	        	        }
	        	    });
		        },
		        handlerNo: Rui.emptyFn
		    });
		}else{
			Rui.alert(Rui.getMessageManager().get('$.base.msg108'));
            return;
		}

		mmClsCloseDm.on('success', function(e) {
			var data = Rui.util.LJson.decode(e.responseText);
            Rui.alert(data[0].records[0].rtnMsg);

			// 재조회
			fnSearch();
		});
		mmClsCloseDm.on('failure', function(e) {
			var data = Rui.util.LJson.decode(e.responseText);
            Rui.alert(data[0].records[0].rtnMsg);
		});


	});

	/* [버튼] 엑셀다운로드 */
	var lbButExcl = new Rui.ui.LButton('butExcl');
	lbButExcl.on('click', function() {
		fncExcelDown();
	});

	/* [함수] 화면초기화 */
	fnOnInit = function(){

		// to-do link시 조회영역 숨김
		if(isTodoLink){
			Rui.get('mmSearchTable').hide();
		}

		// 화면오픈시 조회
		fnSearch();
	}

	//화면초기화
	fnSearch = function(){
		// 데이터셋 조회
		mmClsDataSet.load({
	        url: '<c:url value="/prj/mm/retrieveMmClsSearchInfo.do"/>' ,
	        params :{
			    searchMonth    : lmbSearchMonth.getValue()
			  , searchDeptName : encodeURIComponent(searchDeptName.getValue())
			  , chkPtcPro : chkPtcPro.getValue()
			  , roleCheck : roleCheck
	        }
	    });
	}

	fnSearch()
});	<!-- //Rui.onReady end  -->

<%--/*******************************************************************************
 * FUNCTION 명 : fnDataSetChkMark
 * FUNCTION 기능설명 : 1. 데이터셋 체킹(isMarked : true 이면 chk 1)
                       2. mClsYn : 마감여부(Y/N) 데이터 입력
                       3. 마감, 마감풀기 valid 체크
                       4. mLlckSt : 연동여부(Y/N) 체크
 *******************************************************************************/--%>
function fnDataSetChkMark(mDataSet, mClsYn, mLlckSt){
/* 	if(mLlckSt == null || mLlckSt == '' || mLlckSt == undefined ){
		mLlckSt = 'N'
	} */
	var markDataSet = mDataSet;
	for( var i = 0 ; i < markDataSet.getCount() ; i++ ){
    	if(markDataSet.isMarked(i)){

    		markDataSet.setNameValue(i, 'chk', '1' );
    	    markDataSet.setNameValue(i, 'clsYn', mClsYn );
    	    if(mClsYn == 'Y'){
    	    	markDataSet.setNameValue(i, 'clsDt', createDashDateToString(new Date()) );
    	    }
//    	}else{
//    		markDataSet.setNameValue(i, 'chk', '0' );
    	}
    }
}

<%--/*******************************************************************************
* FUNCTION 명 : fncExcelDown (default Grid 엑셀다운)
* FUNCTION 기능설명 : M/M 마감목록 엑셀다운(추가조회, 추가 그리드 없음)
*******************************************************************************/--%>
function fncExcelDown() {

    if( mmClsDataSet.getCount() > 0){
    	mmClsGrid.saveExcel(toUTF8('MM마감 목록_') + new Date().format('%Y%m%d') + '.xls');
    } else {
    	Rui.alert('조회된 데이타가 없습니다.!!');
    }
}

<%--/*******************************************************************************
 * FUNCTION 명 : validation
 * FUNCTION 기능설명 : 입력 데이터셋 점검
 *******************************************************************************/--%>
function validation(vDataSet, vClsYn){

	var vTestDataSet = vDataSet;

	// 1. 기본 rui validation

	// 2. 추가 validation

	// 마감/마감풀기 valid 처리
 	// 1. 마감(Y) -> 마감여부 Y
 	// 2. 마감풀기(N) -> 마감여부 N
	for( var i = 0 ; i < vTestDataSet.getCount() ; i++ ){
    	if(vTestDataSet.isMarked(i)){
    		var msg = '';
    		if(vClsYn == vTestDataSet.getAt(i).get('clsYn')){
    			if(vClsYn == 'Y'){
    				msg = (i+1)+'번째 목록은 이미 마감되었습니다';
    			}else if(vClsYn == 'N'){
    				msg = (i+1)+'번째 목록은 마감되지 않았습니다.';
    			}
    			Rui.alert(msg);
        		return false;
    		}
    	}
	}

	return true;
}

<%--/*******************************************************************************
 * FUNCTION 명 : fnDataChkPtcProComp
 * FUNCTION 기능설명 : 체크된 데이터셋에서 참여율 100% 체크
 *******************************************************************************/--%>
function fnDataChkPtcProComp(vDataSet){
	var vTestDataSet = vDataSet;
	var msg = "";
	var chkSaUser = "";
	var totalPtcPro = 0;

	for( var i = 0 ; i < vTestDataSet.getCount() ; i++ ){
		if(vTestDataSet.isMarked(i) &&
		   chkSaUser != mmClsDataSet.getNameValue(i, "saUser")){

			chkSaUser = mmClsDataSet.getNameValue(i, "saUser");
			totalPtcPro = 0;

			for( var j=0; j < vTestDataSet.getCount() ; j++  ){
				if( chkSaUser == mmClsDataSet.getNameValue(j, "saUser") ){
					totalPtcPro += Number(mmClsDataSet.getNameValue(j, "ptcPro"));
				}
			}
//			alert(totalPtcPro);
			if(totalPtcPro != 100){
				msg = mmClsDataSet.getNameValue(i, "saName")+' 님의 참여율 총합이 100%가 아닙니다. ';
				Rui.alert(msg);
				return false;
			}
		}
    }

	return true;
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
 			<h2>M/M 마감</h2>
		</div>
		<div class="sub-content">

			<form name="searchForm" id="searchForm" method="post">
				<div class="search">
					<div class="search-content">
			   			<table id="mmSearchTable">
		   					<colgroup>
		   						<col style="width:120px" />
								<col style="width:200px" />
								<col style="width:120px" />
								<col style="width:200px" />
								<col style="width:200px" />
								<col style="" />
		   					</colgroup>
		   					<tbody>
		   					    <tr>
		   					    	<th align="right">프로젝트명</th>
		   							<td>
		   								<input type="text" id="searchDeptName" />
									</td>
		   							<th align="right">기준월</th>
		   							<td>
		   								<input type="text" id="searchMonth" name="searchMonth"/>
									</td>
		   							<td>
		   								<input type="checkbox" id="chkPtcPro" name="chkPtcPro"/>
									</td>
									<td class="txt-right">
										<a style="cursor: pointer;" onclick="fnSearch();" class="btnL">검색</a>
									</td>
		   						</tr>
		   					</tbody>
		   				</table>
	   				</div>
   				</div>
   			</form>

			<form name="clsForm" id="clsForm" method="post"></form>
			<div class="titArea">
				 <span class="Ltotal" id="cnt_text">총 : 0 건</span>
				<div class="LblockButton">
					<span><b> ※ 전월 프로젝트 월마감이 진행되지 않으면, <span style="color:red">현재월 M/M마감 진행이 불가능</span>합니다.</b></span>&nbsp;&nbsp;&nbsp;
					<button type="button" id="butOpenSendMailPop" name="butOpenSendMailPop" >메일보내기</button>
					<button type="button" id="butSave" name="butSave">저장</button>
					<button type="button" id="butClsClose" name="butClsClose"  class="redBtn">마감</button>
					<button type="button" id="butClsOpen" name="butClsOpen" >마감풀기</button>
					<button type="button" id="butIlck" name="butIlck" >연동</button>
					<button type="button" id="butExcl" name="butExcl" >Excel 다운로드</button>
				</div>
			</div>

   			<div id="defaultGrid"></div>

   		</div><!-- //sub-content -->
   	</div><!-- //contents -->
</body>
</html>