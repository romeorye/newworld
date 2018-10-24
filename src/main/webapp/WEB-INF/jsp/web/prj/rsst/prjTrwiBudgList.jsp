<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*, java.util.*,devonframe.util.NullUtil,devonframe.util.DateUtil"%>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>

<%--
/*
 *************************************************************************
 * $Id      : prjTrwiBudgList.jsp
 * @desc    : 연구팀 > 프로젝트 등록 > 비용/예산 통계조회 화면
 *------------------------------------------------------------------------
 * VER  DATE        AUTHOR      DESCRIPTION
 * ---  ----------- ----------  -----------------------------------------
 * 1.0  2017.08.28  IRIS04      최초생성
 * ---  ----------- ----------  -----------------------------------------
 * IRIS 구축 프로젝트
 *************************************************************************
 */
--%>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<%@ include file="/WEB-INF/jsp/include/rui_header.jspf"%>
<title><%=documentTitle%></title>

<%-- rui total summary  --%>
<%-- <script type="text/javascript" src="<%=ruiPathPlugins%>/ui/grid/LTotalSummary.js"></script>
<link rel="stylesheet" type="text/css" href="<%=ruiPathPlugins%>/ui/grid/LTotalSummary.css"/> --%>

<script type="text/javascript">
var pTopForm = parent.topForm;                 // 프로젝트마스터 폼
var dataSet06;                                 // 비용/예산 데이터셋
var lcbSearchYear;                             // 비용/예산 조회년도 콤보
var nowDate = new Date();
var nYear  = nowDate.getFullYear();			   // 현재년도(yyyy)
var grid06;									   // 비용/예산 그리드

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

    lcbSearchYear.on('changed', function(e){
    	if(lcbSearchYear.getValue() == ''){
    		Rui.alert('년도를 선택해주세요.');
    		lcbSearchYear.setValue(nYear);
    		lcbSearchYear.focus();
    		return false;
    	}

    	// 해당년도로 조회
    	fnSearch();
    });

	/* DATASET : defaultGrid */
	dataSet06 = new Rui.data.LJsonDataSet({
	    id: 'dataSet06',
	    remainRemoved: true,
	    lazyLoad: true,
	    fields: [
	    	  { id: 'expScnCd' }
		    , { id: 'expScnCdNm' }
	    	, { id: 'upExpScnCd' }
	        , { id: 'upExpScnCdNm' }
	        , { id: 'type' }
	        , { id: 'm01'      , type: 'number', defaultValue: 0.000000}
	        , { id: 'm02'      , type: 'number', defaultValue: 0.000000}
	        , { id: 'm03'      , type: 'number', defaultValue: 0.000000}
	        , { id: 'm04'      , type: 'number', defaultValue: 0.000000}
	        , { id: 'm05'      , type: 'number', defaultValue: 0.000000}
	        , { id: 'm06'      , type: 'number', defaultValue: 0.000000}
	        , { id: 'm07'      , type: 'number', defaultValue: 0.000000}
	        , { id: 'm08'      , type: 'number', defaultValue: 0.000000}
	        , { id: 'm09'      , type: 'number', defaultValue: 0.000000}
	        , { id: 'm10'      , type: 'number', defaultValue: 0.000000}
	        , { id: 'm11'      , type: 'number', defaultValue: 0.000000}
	        , { id: 'm12'      , type: 'number', defaultValue: 0.000000}
	        , { id: 'monthSum' , type: 'number', defaultValue: 0.000000 }

	    ]
	});

	/* COLUMN : defaultGrid */
	var columnModel = new Rui.ui.grid.LColumnModel({
		freezeColumnId: 'type',
        groupMerge: true,
	    columns: [
	    	  { field: 'upExpScnCdNm',  label: '계정',  vMerge: true, hMerge: true, align:'center', width: 110 }
	        , { field: 'expScnCdNm',    label: '계정',  vMerge: true, hMerge: true, align:'center', width: 155 }
	        , { field: 'type',          label: '구분',  align:'center', width: 70 }
	        , { field: 'm01',           label: '1월',   align:'right', width: 75 }
	        , { field: 'm02',           label: '2월',   align:'right', width: 75 }
	        , { field: 'm03',           label: '3월',   align:'right', width: 75 }
	        , { field: 'm04',           label: '4월',   align:'right', width: 75 }
	        , { field: 'm05',           label: '5월',   align:'right', width: 75 }
	        , { field: 'm06',           label: '6월',   align:'right', width: 75 }
	        , { field: 'm07',           label: '7월',   align:'right', width: 75 }
	        , { field: 'm08',           label: '8월',   align:'right', width: 75 }
	        , { field: 'm09',           label: '9월',   align:'right', width: 75 }
	        , { field: 'm10',           label: '10월',  align:'right', width: 75 }
	        , { field: 'm11',           label: '11월',  align:'right', width: 75 }
	        , { field: 'm12',           label: '12월',  align:'right', width: 75 }
	        , { field: 'monthSum',      label: '합계',  align:'right', width: 90 }
	        // row합계 컬럼
	       /*  , { id: 'rowSum',            label: '합계' , align:'right', width: 200,
	        	renderRow: true, renderer: function(val, p, record){
	        		var calVal = record.get('m01') + record.get('m02') + record.get('m03') + record.get('m04') + record.get('m05') + record.get('m06')
                               + record.get('m07') + record.get('m08') + record.get('m09') + record.get('m10') + record.get('m11') + record.get('m12');
                    return Math.floor(calVal*1000000)/1000000;
	               }
	          } */
	    ]
	});

    // 총합계 total summary
 	/* var ltsumType01 = new Rui.ui.grid.LTotalSummary();
	ltsumType01.on('renderTotalCell', ltsumType01.renderer({
		label: {
		 id: 'upExpScnCdNm',
		 text: '합 계'
		},
		columns: {
			m01: 		{ type: 'sum', renderer: 'number' }
		}
	})); */

	/* GRID : defaultGrid */
	grid06 = new Rui.ui.grid.LGridPanel({
	    columnModel: columnModel,
	    dataSet: dataSet06,
	    width: 600,
	    height: 450,
	    autoWidth: true
	    // 총합계 total summary 표시옵션
	    /* viewConfig: {
	 		plugins: [ltsumType01]
		} */
	});
	grid06.render('defaultGrid');

	/* [버튼] 목록 */
	var butGoList = new Rui.ui.LButton('butGoList');
	butGoList.on('click', function() {
		nwinsActSubmit(document.tabForm06, "<c:url value='/prj/rsst/mst/retrievePrjRsstMstInfoList.do'/>",'_parent');
	});

	 /* [버튼] EXCEL다운로드 */
	var lbButExcl = new Rui.ui.LButton('butExcl');
	lbButExcl.on('click', function() {
		fncExcelDown();
	});

	// 화면초기화
	nowYear = Rui.util.LDate.YEAR;
	lcbSearchYear.setValue(nYear);

	// 마스터폼 disable
	parent.fnChangeFormEdit('disable');

	// 온로드 조회
	//fnSearch();

});

<%--/*******************************************************************************
 * FUNCTION 명 : 목록조회(fnSearch)
 * FUNCTION 기능설명 :
 *******************************************************************************/--%>
function fnSearch() {

	dataSet06.load({
        url: '<c:url value="/prj/rsst/trwiBudg/retrievePrjTrwiBudgSearchInfo.do"/>' ,
        params :{
		    prjCd      : pTopForm.prjCd.value
		  , searchYear : lcbSearchYear.getValue()
        }
    });

}

<%--/*******************************************************************************
* FUNCTION 명 : fncExcelDown (default Grid 엑셀다운)
* FUNCTION 기능설명 : 프로젝트 현황 목록 엑셀다운(추가조회, 추가 그리드 없음)
*******************************************************************************/--%>
function fncExcelDown() {

    if( dataSet06.getCount() > 0){
    	grid06.saveExcel(toUTF8('Project 비용/예산_') + new Date().format('%Y%m%d') + '.xls');
    } else {
    	Rui.alert('조회된 데이타가 없습니다.!!');
    }
}
</script>

</head>
<body>
<form name="tabForm06" id="tabForm06" method="post">
<input type="hidden" name=pageNum value="${inputData.pageNum}"/>
</form>
    <Tag:saymessage /><!--  sayMessage 사용시 필요 -->

    <div class="titArea">
<!--     	<h3>비용/예산</h3> -->
    	<div class="LblockButton">
	    	<select name="cbSearchYear" id="cbSearchYear"></select>
            <button type="button" id="butExcl" name="butExcl" >EXCEL다운로드</button>
        </div>
    </div>

    <div id="defaultGrid"></div>

    <div class="titArea btn_btm">
		<div class="LblockButton">
			<button type="button" id="butGoList" name="butGoList">목록</button>
		</div>
	</div>

</body>
</html>