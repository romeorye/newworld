<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*, java.util.*,devonframe.util.NullUtil,devonframe.util.DateUtil"%>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>

<%--
/*
 *************************************************************************
 * $Id      : prjMmList.jsp
 * @desc    : 연구팀 > 프로젝트 등록 > 투입M/M 통계조회 화면
 *------------------------------------------------------------------------
 * VER  DATE        AUTHOR      DESCRIPTION
 * ---  ----------- ----------  -----------------------------------------
 * 1.0  2017.08.29  IRIS04      최초생성
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
var pTopForm = parent.topForm;                   // 프로젝트마스터 폼
var dataSet0701;                                 // 투입M/M 데이터셋
var dataSet0702;                                 // 투입M/M 데이터셋
var lcbSearchYear;                               // 투입M/M 조회년도 콤보
var nowDate = new Date();
var nYear = nowDate.getFullYear();			     // 현재년도(yyyy)
var grid0701;									 // 투입M/M 그리드
var grid0702;									 // 투입M/M 그리드
var lrSearchType;							     // 조회유형

Rui.onReady(function() {

    /* COMBO : 목표년도 2011년~2030년 => searchYear */
     lcbSearchYear = new Rui.ui.form.LCombo({
        applyTo: 'cbSearchYear',
    	useEmptyText: true,
        emptyText: '선택',
        emptyValue: '',
        items: [
        	<c:forEach var="i" begin="0" varStatus="status" end="19">
     		{ value : "${ 2025 - i }" , text : "${ 2025 - i }" } ,
     		</c:forEach>
        ]
    });

  	// 선택한 년도로 조회
    lcbSearchYear.on('changed', function(e){
    	if(lcbSearchYear.getValue() == ''){
    		Rui.alert('년도를 선택해주세요.');
    		lcbSearchYear.setValue(nYear);
    		lcbSearchYear.focus();
    		return false;
    	}

    	var searchType = lrSearchType.getValue();
		if(searchType == '01'){
			fnSearchByMonth();
		}else if(searchType == '02'){
			fnSearchByYear();
		}
    });

    /* RADIO : 월별 01 년도별 02 => searchType */
	lrSearchType = new Rui.ui.form.LRadioGroup({
		applyTo : 'divRadioSearchType',
		//name : '주문유형',
        defaultValue: '01',
        items : [
			       { label : "월별"   , value : "01"}
			     , { label : "년도별" , value : "02"}
                ]
	});

	// 선택한 조회타입으로 조회
	lrSearchType.on('changed', function(e){
		if(lcbSearchYear.getValue() == ''){
    		Rui.alert('년도를 선택해주세요.');
    		lcbSearchYear.setValue(nYear);
    		lcbSearchYear.focus();
    		return false;
    	}

		var searchType = lrSearchType.getValue();
		if(searchType == '01'){
			fnSearchByMonth();
		}else if(searchType == '02'){
			fnSearchByYear();
		}
    });

	/* DATASET : defaultGrid01 : 월별투입MM */
	dataSet0701 = new Rui.data.LJsonDataSet({
	    id: 'dataSet0701',
	    remainRemoved: true,
	    lazyLoad: true,
	    fields: [
	    	  { id: 'tssNm' }
		    , { id: 'saDeptName' }
	    	, { id: 'saName' }
	        , { id: 'm01'      , type: 'number', defaultValue: 0.00}
	        , { id: 'm02'      , type: 'number', defaultValue: 0.00}
	        , { id: 'm03'      , type: 'number', defaultValue: 0.00}
	        , { id: 'm04'      , type: 'number', defaultValue: 0.00}
	        , { id: 'm05'      , type: 'number', defaultValue: 0.00}
	        , { id: 'm06'      , type: 'number', defaultValue: 0.00}
	        , { id: 'm07'      , type: 'number', defaultValue: 0.00}
	        , { id: 'm08'      , type: 'number', defaultValue: 0.00}
	        , { id: 'm09'      , type: 'number', defaultValue: 0.00}
	        , { id: 'm10'      , type: 'number', defaultValue: 0.00}
	        , { id: 'm11'      , type: 'number', defaultValue: 0.00}
	        , { id: 'm12'      , type: 'number', defaultValue: 0.00}
	        , { id: 'monthSum' , type: 'number', defaultValue: 0.00}

	    ]
	});

	/* DATASET : defaultGrid02 : 년도별투입MM */
	dataSet0702 = new Rui.data.LJsonDataSet({
	    id: 'dataSet0702',
	    remainRemoved: true,
	    lazyLoad: true,
	    fields: [
	    	  { id: 'tssNm' }
		    , { id: 'saDeptName' }
	    	, { id: 'saName' }
	        , { id: 'yearSum'  , type: 'number', defaultValue: 0.00}
	    ]
	});

	/* COLUMN : defaultGrid */
	var columnModel01 = new Rui.ui.grid.LColumnModel({
		freezeColumnId: 'saName',
        groupMerge: true,
	    columns: [
	          { field: 'saName',        label: '연구원',  vMerge: true, hMerge: true, align:'center', width: 70 }
	    	, { field: 'tssNm',         label: '과제명',  vMerge: true, hMerge: true, align:'left', width: 245 }
	        , { field: 'saDeptName',    label: '소속명',  vMerge: true, hMerge: true, align:'left', width: 260 }
	        , { field: 'm01',           label: '1월',   align:'right', width: 55 }
	        , { field: 'm02',           label: '2월',   align:'right', width: 55 }
	        , { field: 'm03',           label: '3월',   align:'right', width: 55 }
	        , { field: 'm04',           label: '4월',   align:'right', width: 55 }
	        , { field: 'm05',           label: '5월',   align:'right', width: 55 }
	        , { field: 'm06',           label: '6월',   align:'right', width: 55 }
	        , { field: 'm07',           label: '7월',   align:'right', width: 55 }
	        , { field: 'm08',           label: '8월',   align:'right', width: 55 }
	        , { field: 'm09',           label: '9월',   align:'right', width: 55 }
	        , { field: 'm10',           label: '10월',  align:'right', width: 55 }
	        , { field: 'm11',           label: '11월',  align:'right', width: 55 }
	        , { field: 'm12',           label: '12월',  align:'right', width: 55 }
	        , { field: 'monthSum',      label: '합계',  align:'right', width: 90 }
	    ]
	});

	/* COLUMN : defaultGrid */
	var columnModel02 = new Rui.ui.grid.LColumnModel({
		freezeColumnId: 'saName',
        groupMerge: true,
	    columns: [
	    	  { field: 'tssNm',        label: '과제명',   vMerge: true, hMerge: true, align:'center', width: 230 }
	        , { field: 'saDeptName',   label: '소속명',   vMerge: true, hMerge: true, align:'center', width: 250 }
	        , { field: 'saName',       label: '연구원',   vMerge: true, hMerge: true, align:'center', width: 150 }
	        , { field: 'yearSum',      label: '합계',     align:'right', width: 150 }
	    ]
	});

	/* GRID : defaultGrid01 */
	grid0701 = new Rui.ui.grid.LGridPanel({
	    columnModel: columnModel01,
	    dataSet: dataSet0701,
	    width: 600,
	    height: 450,
	    autoWidth: true
	});
	grid0701.render('defaultGrid01');

	/* GRID : defaultGrid01 */
	grid0702 = new Rui.ui.grid.LGridPanel({
	    columnModel: columnModel02,
	    dataSet: dataSet0702,
	    width: 600,
	    height: 450,
	    autoWidth: true
	});
	grid0702.render('defaultGrid02');
	grid0702.hide();

	/* [버튼] 목록 */
	var butGoList = new Rui.ui.LButton('butGoList');
	butGoList.on('click', function() {
		nwinsActSubmit(document.tabForm07, "<c:url value='/prj/rsst/mst/retrievePrjRsstMstInfoList.do'/>",'_parent');
	});

	 /* [버튼] EXCEL다운로드 */
	var lbButExcl = new Rui.ui.LButton('butExcl');
	lbButExcl.on('click', function() {
		fncExcelDown();
	});


	// 화면초기화
	lcbSearchYear.setValue(nYear);
	//lrSearchType.setValue('01');

	// 마스터폼 disable
	parent.fnChangeFormEdit('disable');

	// 온로드 조회
	//fnSearchByMonth();

});

<%--/*******************************************************************************
 * FUNCTION 명 : 월별 목록조회(fnSearchByMonth)
 * FUNCTION 기능설명 :
 *******************************************************************************/--%>
function fnSearchByMonth() {

	grid0702.hide();
	grid0701.show();
//	Rui.get('spnTitle').html("월별 투입 M/M");

	dataSet0701.load({
        url: '<c:url value="/prj/rsst/mm/retrieveMmByMonthSearchInfo.do"/>' ,
        params :{
		    prjCd      : pTopForm.prjCd.value
		  , searchYear : lcbSearchYear.getValue()
        }
    });
}

<%--/*******************************************************************************
 * FUNCTION 명 : 년도별 목록조회(fnSearchByYear)
 * FUNCTION 기능설명 :
 *******************************************************************************/--%>
function fnSearchByYear() {
	var selYear = lcbSearchYear.getValue();

	grid0701.hide();
	grid0702.show();
//	Rui.get('spnTitle').html(selYear+"년 투입 M/M");

	dataSet0702.load({
        url: '<c:url value="/prj/rsst/mm/retrieveMmByYearSearchInfo.do"/>' ,
        params :{
		    prjCd      : pTopForm.prjCd.value
		  , searchYear : selYear
        }
    });
}

<%--/*******************************************************************************
* FUNCTION 명 : fncExcelDown (default Grid 엑셀다운)
* FUNCTION 기능설명 : 월별/년도별 투입M/M 엑셀다운(추가조회, 추가 그리드 없음)
*******************************************************************************/--%>
function fncExcelDown() {

	var searchType = lrSearchType.getValue();
	var selYear = lcbSearchYear.getValue();

	//월별조회
	if(searchType == '01'){
	    if( dataSet0701.getCount() > 0){
	    	grid0701.saveExcel(toUTF8('Project 월별투입MM_') + new Date().format('%Y%m%d') + '.xls');
	    } else {
	    	Rui.alert('조회된 데이타가 없습니다.!!');
	    }
	//년도별 조회
	}else if(searchType == '02'){
		if( dataSet0702.getCount() > 0){
	    	grid0702.saveExcel(toUTF8('Project '+selYear+'년 투입MM_') + new Date().format('%Y%m%d') + '.xls');
	    } else {
	    	Rui.alert('조회된 데이타가 없습니다.!!');
	    }
	}
}
</script>

</head>
<body>
<form name="tabForm07" id="tabForm07" method="post"></form>
    <Tag:saymessage /><!--  sayMessage 사용시 필요 -->

    <div class="titArea">
<!--     	<h3><span id="spnTitle">월별 투입M/M</span></h3> &nbsp;&nbsp; -->
    	<select name="cbSearchYear" id="cbSearchYear"></select>
    	<div id="divRadioSearchType"></div>
    	<div class="LblockButton">
            <button type="button" id="butExcl" name="butExcl" >EXCEL다운로드</button>
            <button type="button" id="butGoList" name="butGoList">목록</button>
        </div>
    </div>

    <div id="defaultGrid01"></div>
    <div id="defaultGrid02"></div>

</body>
</html>