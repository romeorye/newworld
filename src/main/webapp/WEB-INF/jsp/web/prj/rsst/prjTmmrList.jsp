<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*, java.util.*,devonframe.util.NullUtil,devonframe.util.DateUtil"%>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>

<%--
/*
 *************************************************************************
 * $Id      : prjTmmrList.jsp
 * @desc    : 연구팀 > 프로젝트 등록 > 팀원정보 목록조회 화면
 *------------------------------------------------------------------------
 * VER  DATE        AUTHOR      DESCRIPTION
 * ---  ----------- ----------  -----------------------------------------
 * 1.0  2017.08.25  IRIS04      최초생성
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
var pTopForm = parent.topForm;                 // 프로젝트마스터 폼
var dataSet05;                                 // 팀원정보 데이터셋

Rui.onReady(function() {

	/* DATASET : defaultGrid */
	dataSet05 = new Rui.data.LJsonDataSet({
	    id: 'dataSet05',
	    remainRemoved: true,
	    lazyLoad: true,
	    fields: [
	    	  { id: 'saName' }
		    , { id: 'saJobxName' }
	    	, { id: 'patcStrDt' }
	        , { id: 'patcEndDt' }
	        , { id: 'saFuncName' }
	    ]
	});

	/* COLUMN : defaultGrid */
	var columnModel = new Rui.ui.grid.LColumnModel({
	    columns: [
	    	  { field: 'saName',         label: '연구원'     , sortable: false, align:'center', width: 80 }
	        , { field: 'saJobxName',     label: '직급'       , sortable: false, align:'center', width: 80 }
	        , { field: 'patcStrDt',      label: '참여시작일' , sortable: false, align:'center', width: 100 }
	        , { field: 'patcEndDt',      label: '참여종료일' , sortable: false, align:'center', width: 100 }
	        , { field: 'saFuncName',     label: '역할'       , sortable: false, align:'center', width: 80 }
	    ]
	});

	/* GRID : defaultGrid */
	var grid = new Rui.ui.grid.LGridPanel({
	    columnModel: columnModel,
	    dataSet: dataSet05,
	    width: 600,
	    height: 450,
	    autoToEdit: true,
	    autoWidth: true
	});
	grid.render('defaultGrid');

	/* [버튼] 목록 */
	var butGoList = new Rui.ui.LButton('butGoList');
	butGoList.on('click', function() {
		nwinsActSubmit(document.tabForm05, "<c:url value='/prj/rsst/mst/retrievePrjRsstMstInfoList.do'/>",'_parent');
	});

	// 마스터폼 disable
	parent.fnChangeFormEdit('disable');

	// 온로드 조회
	fnSearch();

});

<%--/*******************************************************************************
 * FUNCTION 명 : 목록조회(fnSearch)
 * FUNCTION 기능설명 :
 *******************************************************************************/--%>
function fnSearch() {

	dataSet05.load({
        url: '<c:url value="/prj/rsst/tmmr/retrievePrjTmmrSearchInfo.do"/>' ,
        params :{
		    prjCd : pTopForm.prjCd.value
        }
    });

}
</script>

</head>
<body>
<form name="tabForm05" id="tabForm05" method="post"></form>
    <Tag:saymessage /><!--  sayMessage 사용시 필요 -->
<!--  
     <div class="titArea">
   	<h3>팀원정보</h3> 
    </div>-->
    <br><%-- 버튼없는 리스트 탭간 간격용 --%>

    <div id="defaultGrid"></div>

    <div class="titArea btn_btm">
		<div class="LblockButton">
			<button type="button" id="butGoList" name="butGoList">목록</button>
		</div>
	</div>

</body>
</html>