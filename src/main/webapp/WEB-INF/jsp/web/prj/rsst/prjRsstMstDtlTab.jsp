<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8"%>
<%@ page import="java.util.*,devonframe.util.NullUtil" %>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>

<%--
/*
 *************************************************************************
 * $Id		: prjRsstMstDtlTab.jsp
 * @desc    : 연구팀(Project) > 현황 > 프로젝트 등록
              연구팀(Project) 프로젝트 등록 탭
 *------------------------------------------------------------------------
 * VER	DATE		AUTHOR		DESCRIPTION
 * ---	-----------	----------	-----------------------------------------
 * 1.0  2017.08.10  IRIS04	    최초생성
 * ---	-----------	----------	-----------------------------------------
 * IRIS 구축 프로젝트
 *************************************************************************
 */
--%>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/include/rui_header.jspf"%>
<title><%=documentTitle%></title>

<%-- rui Tab --%>
<script type="text/javascript" src="<%=ruiPathPlugins%>/tab/rui_tab.js"></script>
<%-- <link rel="stylesheet" type="text/css" href="<%=ruiPathPlugins%>/tab/rui_tab.css" /> --%>

<script type="text/javascript">
var tabView;
var prjCd;
var dataSet;
var trResultDataSet;	// 처리결과 데이터셋
var lfTopForm;			// 프로젝트마스터 Lform
var prjSearchDialog;	// 프로젝트 조회 팝업 dialog
var openPrjSearchDialog;
var tfxaDtlDialog;		// 고정자산 탭 상세 dialog
var tmboArslDialog;		// MBO 탭 실적 dialog
var setPrjInfo;
var pageMode = nullToString("<c:out value='${inputData.pageMode}'/>"); // 페이지모드(C/V)
var tabCnt = 0;

var nowDate = new Date();
var nYear  = nowDate.getFullYear();
var oneYearAfterDate = new Date().add('Y', parseInt(1, 10));
var fYear  = oneYearAfterDate.getFullYear();



Rui.onReady(function() {

	/* form 세팅 */
	lfTopForm = new Rui.ui.form.LForm('topForm');

	<%-- DateBox --%>
	fromDate = new Rui.ui.form.LDateBox({
		applyTo: 'fromDate',
		defaultValue: new Date(),
		width: 100,
		dateType: 'string'
	});

	toDate = new Rui.ui.form.LDateBox({
		applyTo: 'toDate',
		width: 100,
		dateType: 'string'
	});

	/* [TAB] */
    tabView = new Rui.ui.tab.LTabView({
    	tabs: [
    	<c:if test="${inputData.pageMode == 'C' }">
    		{ active :true , label: '개요' }
    	</c:if>
    	<c:if test="${inputData.pageMode == 'V' }">
			{ active :true , label: '개요' },
    		{ label: '산출물' } ,
            { label: 'MBO(특성지표)' },
            { label: '지적재산권' },
            { label: '팀원정보' },
            { label: '비용/예산' },
            { label: '투입M/M' },
            { label: '고정자산' }
        </c:if>
       ]
    });

//    tabCnt = tabView.getTabCount();
	tabCnt = 8;

    tabView.on('activeTabChange', function(e){

    	//iframe 숨기기
        for(var i = 0; i < tabCnt; i++) {
            if(i == e.activeIndex) {
                Rui.get('tabContent' + i).show();
            } else {
                Rui.get('tabContent' + i).hide();
            }
        }

        switch(e.activeIndex){
        <c:if test="${inputData.pageMode == 'C' }">
        	/** 개요 **/
        	case 0:
        		if(e.isFirst) {
		       		var url = '?prjCd=' + document.topForm.prjCd.value
		        	nwinsActSubmit(document.topForm, "<c:url value='/prj/rsst/mst/retrievePrjRsstDtlDtlInfo.do'/>"+url, 'tabContent0');

        		}
        		fnChangeFormEdit(true);
	        break;
	    </c:if>
	    <c:if test="${inputData.pageMode == 'V' }">
	    	/** 개요 **/
        	case 0:
        		if(e.isFirst) {
		       		var url = '?prjCd=' + document.topForm.prjCd.value
		        	nwinsActSubmit(document.topForm, "<c:url value='/prj/rsst/mst/retrievePrjRsstDtlDtlInfo.do'/>"+url, 'tabContent0');
        		}
        		fnChangeFormEdit(true);
	        break;
	        /** 산출물 **/
        	case 1:
        		if(e.isFirst) {
	        		nwinsActSubmit(document.topForm, "<c:url value='/prj/rsst/pdu/retrievePrjRsstPduInfo.do'/>", 'tabContent1');
        		}
        		fnChangeFormEdit(false);

            break;

        	/** MBO(특성지표) **/
	        case 2:
	        	if(e.isFirst) {
	        		nwinsActSubmit(document.topForm, "<c:url value='/prj/rsst/mbo/retrievePrjRsstMboInfo.do'/>", 'tabContent2');
	        	}
	        	fnChangeFormEdit(false);
	        break;

        	/** 지적재산권 **/
	        case 3:
	        	if(e.isFirst) {
	        		nwinsActSubmit(document.topForm, "<c:url value='/prj/rsst/ptotprpt/retrievePrjPtotPrptInfo.do'/>", 'tabContent3');
	        	}
	        	fnChangeFormEdit(false);
	        break;

	        /** 팀원정보 **/
	        case 4:
	        	if(e.isFirst) {
	        		nwinsActSubmit(document.topForm, "<c:url value='/prj/rsst/tmmr/retrievePrjTmmrInfo.do'/>", 'tabContent4');
	        	}
	        	fnChangeFormEdit(false);
	        break;

	        /** 비용/예산 **/
	        case 5:
	        	if(e.isFirst) {
	        		nwinsActSubmit(document.topForm, "<c:url value='/prj/rsst/trwiBudg/retrievePrjTrwiBudgInfo.do'/>", 'tabContent5');
	        	}
	        	fnChangeFormEdit(false);
	        break;

	        /** 투입MM **/
	        case 6:
	        	if(e.isFirst) {
	        		nwinsActSubmit(document.topForm, "<c:url value='/prj/rsst/mm/retrievePrjMmInfo.do'/>", 'tabContent6');
	        	}
	        	fnChangeFormEdit(false);
	        break;

	        /** 고정자산 **/
	        case 7:
	        	if(e.isFirst) {
	        		nwinsActSubmit(document.topForm, "<c:url value='/prj/rsst/retrievePrjFxaInfo.do'/>", 'tabContent7');
	        	}
	        	fnChangeFormEdit(false);
	        break;
	    </c:if>

	        default:
            break;
        }

    });
    tabView.render('tabView');

    <%-- TextBox --%>
    var ltWbsCd = new Rui.ui.form.LTextBox({
    	applyTo: 'wbsCd',
    	attrs: {
    			maxLength: 6
    			}
    	});
    var ltPrjNm = new Rui.ui.form.LPopupTextBox({
    	applyTo: 'prjNm',
    	width : 300,
    	editable: false,
    	attrs: {
    			maxLength: 33
    			}
    	});
    ltPrjNm.on('popup', function(e){
    	openPrjSearchDialog(setPrjInfo,'ALL');
    });
    var ltWbsCdA = new Rui.ui.form.LTextBox({
    	applyTo: 'wbsCdA',
    	mask: '**',
    	maskPlaceholder: '_',
    	editable: false,
    	attrs: {
    			maxLength: 2
    			}
    	});

    <%-- DATASET --%>
    dataSet = new Rui.data.LJsonDataSet({
        id: 'dataSetTop',
        remainRemoved: true,
        lazyLoad: true,
        fields: [
              { id: 'prjCd' }       //프로젝트코드
            , { id: 'wbsCd' }       //프로젝트명
            , { id: 'prjNm' }
            , { id: 'plEmpNo' }
            , { id: 'saName' }
            , { id: 'deptCd' }
            , { id: 'deptName' }
            , { id: 'uperdeptName' }
            , { id: 'prjStrDt'  }
            , { id: 'prjEndDt'  }
            , { id: 'prjCpsn'  }
            , { id: 'wbsCdA'}		// WBS코드 약어
            , { id: 'orgWbsCd' }
            , { id: 'orgWbsCdA'}
            , { id: 'deptUper'}     // 상위부서코드
        ]
    });

    dataSet.on('load', function(e) {
		// 신규등록인 경우 기초 데이터 세팅
    	if( dataSet.getCount() > 0 && Rui.isEmpty(dataSet.getAt(0).get('prjCd')) ){
    		dataSet.setNameValue(0,  "prjNm", "<c:out value = '${teamInfo.deptName}'/>");
    		dataSet.setNameValue(0,  "saName", "<c:out value = '${teamInfo.plSaName}'/>");
    		dataSet.setNameValue(0,  "deptName", "<c:out value = '${teamInfo.deptName}'/>");
    		dataSet.setNameValue(0,  "uperdeptName", "<c:out value = '${teamInfo.uperdeptName}'/>");
    		dataSet.setNameValue(0,  "prjStrDt", new Date().format('%Y-%m-%d'));
    		//dataSet.setNameValue(0,  "prjEndDt", (new Date().add('Y', parseInt(1, 10))).format('%Y-%m-%d'));

    		// 신규등록의 경우 팀정보 세팅
    		dataSet.setNameValue(0,  "prjCpsn"  , "<c:out value = '${teamInfo.teamUserCnt}'/>");		// 팀 총인원
    		dataSet.setNameValue(0,  "plEmpNo"  , "<c:out value = '${teamInfo.plSaSabunNew}'/>");		// 팀 PL명
    		dataSet.setNameValue(0,  "deptCd"   , "<c:out value = '${teamInfo.deptCode}'/>");			// 팀 코드
    		dataSet.setNameValue(0,  "wbsCdA"   , "<c:out value = '${teamInfo.deptCodeA}'/>");			// 팀 WBS코드 약어
    		dataSet.setNameValue(0,  "deptUper" , "<c:out value = '${teamInfo.deptUper}'/>");			// 팀 상위부서코드

    		dataSet.setNameValue(0, "orgWbsCdA" , '');	// 변경상태 비교를 위한 wbsCdA코드
    	}

    	// 데이터셋 로딩시 기존wbsCd 세팅
    	else if( dataSet.getCount() > 0 && !Rui.isEmpty(dataSet.getAt(0).get('prjCd')) ){
    		dataSet.setNameValue(0, "orgWbsCd"  , dataSet.getNameValue(0,"wbsCd"));
    		dataSet.setNameValue(0, "orgWbsCdA" , dataSet.getNameValue(0,"wbsCdA"));
    	}
    });

	<%-- RESULT DATASET : 처리결과 데이터셋 --%>
    trResultDataSet = new Rui.data.LJsonDataSet({
        id: 'trResultDataSet',
        remainRemoved: true,
        lazyLoad: true,
        fields: [
              { id: 'rtnSt' }   //결과코드
            , { id: 'rtnMsg' }  //결과메시지
        ]
    });

    /* [DataSet] bind */
    var bind = new Rui.data.LBind({
        groupId: 'topForm',
        dataSet: dataSet,
        bind: true,
        bindInfo: [
              { id: 'prjCd',       ctrlId: 'prjCd',        value: 'value' }
            , { id: 'wbsCd',       ctrlId: 'wbsCd',        value: 'value' }
            , { id: 'prjNm',       ctrlId: 'prjNm',        value: 'value' }
            , { id: 'prjStrDt',    ctrlId: 'fromDate',     value: 'value' }
            , { id: 'prjEndDt',    ctrlId: 'toDate',       value: 'value' }
            // 화면표시 정보
            , { id: 'saName',          ctrlId: 'spnSaName',    value: 'html' }	// SPAN : PL명
            , { id: 'uperdeptName',    ctrlId: 'spnDeptName',  value: 'html' }	// SPAN : 조직명
            , { id: 'prjCpsn',         ctrlId: 'spnDeptCnt',   value: 'html' }	// SPAN : 조직총인원
            , { id: 'wbsCd',           ctrlId: 'spnWbsCd',     value: 'html' }	// SPAN : WBS코드
            , { id: 'wbsCdA',          ctrlId: 'spnWbsCdA',    value: 'html' }	// SPAN : WBS코드약어
            , { id: 'prjNm',           ctrlId: 'spnPrjNm',     value: 'html' }	// SPAN : 프로젝트명
            , { id: 'prjStrDt',        ctrlId: 'spnPrjDate',   value: 'html' ,
            	renderer: function(value) {
                	return dataSet.getAt(0).get('prjStrDt')+' ~ '+dataSet.getAt(0).get('prjEndDt');
                }
              }
            , { id: 'wbsCdA',       ctrlId: 'wbsCdA',        value: 'value' }	// WBS코드 약어
            // hidden 정보
            , { id: 'plEmpNo',     ctrlId: 'hPlEmpNo',      value: 'value' }
            , { id: 'deptCd',      ctrlId: 'hDeptCd',       value: 'value' }
            , { id: 'prjCpsn',     ctrlId: 'userDeptCnt',   value: 'value' }
            , { id: 'deptUper',    ctrlId: 'deptUper',      value: 'value' }
        ]
    });

    // 프로젝트 팝업 DIALOG
    prjSearchDialog = new Rui.ui.LFrameDialog({
        id: 'prjSearchDialog',
        title: '프로젝트 조회',
        width: 620,
        height: 500,
        modal: true,
        visible: false
    });
    prjSearchDialog.on('cancel', function(e) {
    	try{
    		tabContent0.$('object').css('visibility', 'visible');
    	}catch(e){}
    });
    prjSearchDialog.on('submit', function(e) {
    	try{
    		tabContent0.$('object').css('visibility', 'visible');
    	}catch(e){}
    });
    prjSearchDialog.on('show', function(e) {
    	try{
    		tabContent0.$('object').css('visibility', 'hidden');
    	}catch(e){}
    });

    prjSearchDialog.render(document.body);

	openPrjSearchDialog = function(f,p) {
		var param = '?searchType=';
		if( !Rui.isEmpty(p)){
		//if( !Rui.isNull(p) && p != ''){
			param += p;
		}

		_callback = f;

		prjSearchDialog.setUrl('<c:url value="/prj/rsst/mst/createPrjSearchPopup.do"/>' + param);
		//prjSearchDialog.setUrl('<c:url value="/prj/rsst/mst/retrievePrjSearchPopup.do"/>' + param);
		prjSearchDialog.show();
	};

	/* [ 고정자산 탭 > 자산 상세정보 Dialog] */
	tfxaDtlDialog = new Rui.ui.LFrameDialog({
        id: 'tfxaDtlDialog',
        title: '자산 상세정보',
        width:  700,
        height: 600,
        modal: true,
        visible: false,
        buttons : [
            { text:'닫기', handler: function() {
              	this.cancel(false);
              }
            }
        ]
    });
	tfxaDtlDialog.render(document.body);

	/* [ MBO(특성지표) 탭 > 실적MBO Dialog] */
	tmboArslDialog = new Rui.ui.LFrameDialog({
        id: 'mboArslDialog',
        title: '실적 MBO( 특성지표)',
        width:  600,
        height: 600,
        modal: true,
        visible: false,
        buttons : [
            { text:'닫기', handler: function() {
              	this.cancel(false);
              }
            }
        ]
    });
/* 	tmboArslDialog.on('cancel', function(e) {
    	try{
    		tabContent2.fnSearch();
    	}catch(e){}
    }); */
	tmboArslDialog.on('submit', function(e) {
    	try{
    		tabContent2.fnSearch();
    	}catch(e){}
    });
	tmboArslDialog.render(document.body);

	/* 프로젝트 조회팝업 닫은 후 세팅 */
	setPrjInfo = function(prjInfo) {

		/* 등록된 프로젝트 체크
			1. 신규 -> 유저팀세팅 -> 체크안함
			2. 신규 -> 팝업 -> ORG PRJ_CD = '' / PRJ_CD = ''/ ORG PRJ_CD = PRJ_CD -> OK
			   신규 -> 팝업 -> ORG PRJ_CD = '' / PRJ_CD = 존재 -> FAIL
			   신규 -> 팝업 -> ORG PRJ_CD = 존재 / PRJ_CD = 존재 / ORG PRJ_CD = PRJ_CD -> OK
			3. 기존 -> 조회세팅 -> 체크안함
			4. 기존 -> 팝업 -> ORG PRJ_CD = 존재 / PRJ_CD = ''/ ORG PRJ_CD = PRJ_CD -> OK
			   기존 -> 팝업 -> ORG PRJ_CD = 존재 / PRJ_CD = 존재 -> FAIL
			   기존 -> 팝업 -> ORG PRJ_CD = 존재 / PRJ_CD = 존재 / ORG PRJ_CD = PRJ_CD -> OK
		*/
		var orgPrjCd = document.topForm.prjCd.value;

		// 1.팝업 프로젝트코드가 존재
		if( (prjInfo.prjCd != '' && prjInfo.prjCd != null  && prjInfo.prjCd != "undefined" ) ){

			if( (orgPrjCd != '' && orgPrjCd != null  && orgPrjCd != "undefined" ) &&
				( prjInfo.prjCd == orgPrjCd )                                     ){

			// 기존프로젝트 코드가 존재하는데 팝업프로젝트 코드와 일치하는 경우를 제외하고 프로젝트 중복알림
			}else{
				alert('이미 등록된 프로젝트입니다.');
				return false;
			}
		}

		clearPrjInfo();

		// 화면표시 세팅
		ltPrjNm.setValue(prjInfo.prjNm);
		Rui.get('spnSaName').html(prjInfo.plEmpName);
		Rui.get('spnDeptName').html(prjInfo.upDeptName);
		Rui.get('spnDeptCnt').html(prjInfo.deptCnt);

		// 폼 데이터 세팅
        dataSet.setNameValue(0,"plEmpNo"  , prjInfo.plEmpNo);
        dataSet.setNameValue(0,"deptCd"   , prjInfo.deptCd);
        dataSet.setNameValue(0,"prjCpsn"  , prjInfo.deptCnt);
        dataSet.setNameValue(0,"deptUper" , prjInfo.upDeptCd);

        document.topForm.hPlEmpNo.value    = prjInfo.plEmpNo;
        document.topForm.hDeptCd.value     = prjInfo.deptCd;
        document.topForm.userDeptCnt.value = prjInfo.deptCnt;
        document.topForm.deptUper.value    = prjInfo.upDeptCd;

		// rui 폼 데이터 세팅
		ltWbsCdA.setValue(prjInfo.wbsCdA);	// wbs코드약어
    };

    var clearPrjInfo = function(prjInfo) {
		ltPrjNm.setValue('');
		Rui.get('spnSaName').html('');
		Rui.get('spnDeptName').html('');
		Rui.get('spnDeptCnt').html('');

		// 폼 데이터 클린
		topForm.hPlEmpNo.value = '';
		topForm.hDeptCd.value = '';
		topForm.userDeptCnt.value = '';
		topForm.deptUper.value = '';

		// rui 폼 데이터 클린
		ltWbsCdA.setValue('');		// wbs코드약어
    };

    fnPrjMstSearch = function() {

    	dataSet.load({
            url: '<c:url value="/prj/rsst/mst/retrievePrjRsstMstDtlSearchInfo.do"/>' ,
            params :{
    		    prjCd : document.topForm.prjCd.value
            }
        });

    }

    // 프로젝트 마스터 조회
	fnPrjMstSearch();
	//fnChangeFormEdit('enable');


	// 초기값 세팅
    if(pageMode == 'C'){	//등록화면]
    	topForm.hPlEmpNo.value    = "<c:out value = '${teamInfo.plSaSabunNew}'/>";
    	topForm.hSaName.value     = "<c:out value = '${teamInfo.plSaName}'/>";
    	topForm.hDeptCd.value     = "<c:out value = '${teamInfo.deptCode}'/>";
    	topForm.userDeptCnt.value = "<c:out value = '${teamInfo.teamUserCnt}'/>";
    	topForm.deptUper.value    = "<c:out value = '${teamInfo.deptUper}'/>";

    }else if(pageMode == 'V'){	// 뷰화면
    }

    fromDate.setValue(new Date());
});

<%--/*******************************************************************************
 * FUNCTION 명 : 프로젝트마스터 폼 disable(false)/enable(true) 처리
 * FUNCTION 기능설명 :
 *******************************************************************************/--%>
function fnChangeFormEdit(isEnable) {
    $('#wbsCdA').attr('style', "border-color:white;");

	if(isEnable == true){
		console.log(isEnable);

		lfTopForm.enable();
		fromDate.enable();
		toDate.enable();

		Rui.get('divTopView01').hide();
		Rui.get('divTopView02').hide();
		Rui.get('divTopView03').hide();
		Rui.get('divTopCreate01').show();
		Rui.get('divTopCreate02').show();
		Rui.get('divTopCreate03').show();

	}else if(isEnable == false){

		lfTopForm.disable();
		fromDate.disable();
		toDate.disable();

		Rui.get('divTopCreate01').hide();
		Rui.get('divTopCreate02').hide();
		Rui.get('divTopCreate03').hide();
		Rui.get('divTopView01').show();
		Rui.get('divTopView02').show();
		Rui.get('divTopView03').show();
	}
}

</script>
</head>
<body>


<div class="contents" >
	<div class="titleArea">
		<a class="leftCon" href="#">
	        <img src="/iris/resource/web/images/img_uxp/ico_leftCon.png" alt="Left Navigation Control">
	        <span class="hidden">Toggle 버튼</span>
		</a>
 		<h2>프로젝트 등록</h2>
 	</div>

   	<div class="sub-content">

   		<form name="topForm" id="topForm" method="post">
		<input type="hidden" id="prjCd" name="prjCd" value="<c:out value='${inputData.prjCd}'/>">
		<input type="hidden" id="pageMode" name="pageMode" value="<c:out value='${inputData.pageMode}'/>">
		<input type="hidden" id="hPlEmpNo" name="hPlEmpNo" value=""/>
		<input type="hidden" id="hSaName" name="hSaName" value=""/>
		<input type="hidden" id="hDeptCd" name="hDeptCd" value=""/>
		<input type="hidden" id="userDeptCnt" name="userDeptCnt" value=""/>
		<input type="hidden" id="orgWbsCd" name="orgWbsCd" value=""/>
		<input type="hidden" id="deptUper" name="deptUper" value=""/>
		<input type="hidden" name="pageNum" value="${inputData.pageNum}"/>

   		<table class="table table_txt_right">
			<colgroup>
				<col style="width:15%"/>
				<col style="width:30%"/>
				<col style="width:15%"/>
				<col style="width:*"/>
			</colgroup>
			<tbody>
			    <tr>
					<th align="right">WBS 코드 / WBS 코드 약어</th>
					<td>
						<div id="divTopCreate01" class="topCreate">
							<input type="text" class="" id="wbsCd" name="wbsCd" value="" >&nbsp;&#47;&nbsp;
							<input type="text" class="" id="wbsCdA" name="wbsCdA" value="" >
						</div>
						<div id="divTopView01" class="topView"><span id="spnWbsCd"></span>&nbsp;&#47;&nbsp;<span id="spnWbsCdA"></span></div>
					</td>
					<th align="right"><label for="lPrjNm">프로젝트명</label></th>
					<td>
						<div id="divTopCreate02" class="topCreate">
							<input type="text" class="" id="prjNm" name="prjNm" value="" >
							<!-- <a id="aButOpenPrjNm" style="cursor: pointer;" onclick="openPrjSearchDialog(setPrjInfo,'ALL');" class="icoBtn">검색</a> -->
						</div>
						<div id="divTopView02" class="topView"><span id="spnPrjNm"></span></div>
					</td>
				</tr>
					<tr>
					<th align="right">PL 명</th>
					<td><span id="spnSaName"></span></td>
					<th align="right">조직</th>
					<td>
						<span id="spnDeptName"></span>
					</td>
				</tr>
				<tr>
					<th align="right">프로젝트기간</th>
					<td>
						<div id="divTopCreate03" class="topCreate">
							<input type="text" id="fromDate" /><em class="gab"> ~ </em>
							<input type="text" id="toDate" />
						</div>
						<div id="divTopView03" class="topView"><span id="spnPrjDate"></span></div>
					</td>
					<th align="right">개발인원</th>
					<td>
						<span id="spnDeptCnt"></span>
					</td>
				</tr>
			</tbody>
		</table>
   		</form>
		<br>

		<div id="tabView" style="style="overflow-x: hidden; overflow-y: hidden;"></div>
		<iframe name="tabContent0" id="tabContent0" scrolling="yes" width="100%" height="600px" frameborder="0" ></iframe>
		<iframe name="tabContent1" id="tabContent1" scrolling="yes" width="100%" height="600px" frameborder="0" ></iframe>
		<iframe name="tabContent2" id="tabContent2" scrolling="yes" width="100%" height="600px" frameborder="0" ></iframe>
		<iframe name="tabContent3" id="tabContent3" scrolling="yes" width="100%" height="600px" frameborder="0" ></iframe>
		<iframe name="tabContent4" id="tabContent4" scrolling="yes" width="100%" height="600px" frameborder="0" ></iframe>
		<iframe name="tabContent5" id="tabContent5" scrolling="yes" width="100%" height="600px" frameborder="0" ></iframe>
		<iframe name="tabContent6" id="tabContent6" scrolling="yes" width="100%" height="600px" frameborder="0" ></iframe>
		<iframe name="tabContent7" id="tabContent7" scrolling="yes" width="100%" height="600px" frameborder="0" ></iframe>

	</div><!-- //sub-content -->

</div><!-- //contents -->

</body>
</html>