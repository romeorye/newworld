<%@ page language="java" pageEncoding="utf-8"
	contentType="text/html; charset=utf-8"%>
<%@ page
	import="java.text.*, java.util.*,devonframe.util.NullUtil,devonframe.util.DateUtil"%>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>
<%--
/*
 *************************************************************************
 * $Id		: spaceEvAffrStts.jsp
 * @desc    : 통계 > 공간성능평가 > 평가업무현황
 *------------------------------------------------------------------------
 * VER	DATE		AUTHOR		DESCRIPTION
 * ---	-----------	----------	-----------------------------------------
 * 1.0  2018.09.14    		최초생성
 * ---	-----------	----------	-----------------------------------------
 * IRIS 구축 프로젝트
 *************************************************************************
 */
--%>
<html>
<head>
<%@ include file="/WEB-INF/jsp/include/rui_header.jspf"%>
<title><%=documentTitle%></title>
<link type="text/css" href="<%=cssPath%>/main.css" rel="stylesheet">
<link type="text/css" href="<%=cssPath%>/common.css" rel="stylesheet">
<script type="text/javascript" src="<%=ruiPathPlugins%>/tab/rui_tab.js"></script>
<link rel="stylesheet" type="text/css"
	href="<%=ruiPathPlugins%>/tab/rui_tab.css" />
<style>
.bgcolor-gray {
	background-color: #999999
}

.bgcolor-white {
	background-color: #FFFFFF
}

.L-navset {
	overflow: hidden;
}
</style>
<script type="text/javascript">
var mchnPrctInfoDialog;
var mchnPrctId;

var frtTab;
var rtnUrl;
var mchnInfoId;

	Rui.onReady(function() {


		/********************
         * 버튼 및 이벤트 처리와 랜더링
         ********************/



        var yy = new Rui.ui.form.LCombo({
            applyTo: 'yy',
            name: 'yy',
            emptyText: '선택',
            defaultValue: '',
            emptyValue: '',
            width: 110,
            selectedIndex:0,
            useEmptyText: false,
            url: '<c:url value="/stat/rlab/retrieveRlabYyList.do"/>',
            displayField: 'yy',
            valueField: 'yy'
        });

        //전체
        spaceEvAffrSttsDataSet = new Rui.data.LJsonDataSet({
            id: 'rlabDzdvStatDataSet',
            remainRemoved: true,
            lazyLoad: true,
            fields: [
            	  { id: 'statGbn' }
            	, { id: 'm1' }
				, { id: 'm2' }
				, { id: 'm3' }
				, { id: 'm4' }
				, { id: 'm5' }
				, { id: 'm6' }
				, { id: 'm7' }
				, { id: 'm8' }
				, { id: 'm9' }
				, { id: 'm10' }
				, { id: 'm11' }
				, { id: 'm12' }
				, { id: 'sum' }
				, { id: 'etc' }
            ]
        });



        //
        var spaceEvAffrSttsColumnModel = new Rui.ui.grid.LColumnModel({
        	autoWidth:true
            ,columns: [
            	  { field: 'statGbn',		label: '시험구분',		sortable: false,	align:'center',	width: 100 }
                , { field: '',		label: '합계',		sortable: false,	align:'center',	width: 50 }
                , { field: '',		label: '월평균',		sortable: false,	align:'center',	width: 50 }
                , { field: 'm1',		label: '1월',		sortable: false,	align:'center',	width: 50 }
                , { field: 'm2',		label: '2월',		sortable: false,	align:'center',	width: 50 }
                , { field: 'm3',		label: '3월',		sortable: false,	align:'center',	width: 50 }
                , { field: 'm4',		label: '4월',		sortable: false,	align:'center',	width: 50 }
                , { field: 'm5',		label: '5월',		sortable: false,	align:'center',	width: 50 }
                , { field: 'm6',		label: '6월',		sortable: false,	align:'center',	width: 50 }
                , { field: 'm7',		label: '7월',		sortable: false,	align:'center',	width: 50 }
                , { field: 'm8',		label: '8월',		sortable: false,	align:'center',	width: 50 }
                , { field: 'm9',		label: '9월',		sortable: false,	align:'center',	width: 50 }
                , { field: 'm10',		label: '10월',		sortable: false,	align:'center',	width: 50 }
                , { field: 'm11',		label: '11월',		sortable: false,	align:'center',	width: 50 }
                , { field: 'm12',		label: '12월',		sortable: false,	align:'center',	width: 50 }
                , { field: 'sum',		label: '합계',		sortable: false,	align:'center',	width: 50 }
                , { field: 'etc',		label: '비고',		vMerge: true,sortable: false,	align:'center',	width: 100 }
            ]
        });

        var spaceEvAffrSttsGrid = new Rui.ui.grid.LGridPanel({
            columnModel: spaceEvAffrSttsColumnModel,
            dataSet: spaceEvAffrSttsDataSet,
            width: 980,
            height: 380,
            autoToEdit: true,
            autoWidth: true
        });

        spaceEvAffrSttsGrid.render('spaceEvAffrSttsGrid');





        var rlabDzdvStatGrid = new Rui.ui.grid.LGridPanel({
            columnModel: rlabDzdvStatColumnModel,
            dataSet: rlabDzdvStatDataSet,
            width: 980,
            height: 380,
            autoToEdit: true,
            autoWidth: true
        });

        rlabDzdvStatGrid.render('rlabDzdvStatGrid');





        var rlabExprStatGrid = new Rui.ui.grid.LGridPanel({
            columnModel: rlabExprStatColumnModel,
            dataSet: rlabExprStatDataSet,
            width: 980,
            height: 380,
            autoToEdit: true,
            autoWidth: true
        });

        rlabExprStatGrid.render('rlabExprStatGrid');





        /* 시험구분별통계 리스트 조회 */
        getRlabScnStatList = function(msg) {

        	spaceEvAffrSttsDataSet.load({
                url: '<c:url value="/stat/rlab/retrieveRlabScnStatList.do"/>',
                params :{
                	yyyy :  yy.getValue()
                	//yyyy : '2018'
                }
            });
        };





        //getRlabChrgStatList();

        /* 조회 */
        fnSearch = function() {
        	//getRlabScnStatList();
        };
	});	//end ready

</script>
</head>


<body>
	<!-- contents -->
	<div class="contents">
		<div class="titleArea">
			<h2>연도별 통계</h2>
		</div>
		<table class="searchBox">
			<colgroup>
				<col style="width: 10%;" />
				<col style="width: 35%;" />
				<col style="width: 10%;" />
				<col style="width: 35%;" />
				<col style="width: 10%;" />
			</colgroup>
			<tbody>
				<tr>
					<th align="right">연도</th>
					<td>
						<div id="yy"></div>
					</td>
					<td class="t_center"><a style="cursor: pointer;"
						onclick="fnSearch();" class="btnL">검색</a></td>
				</tr>
			</tbody>
		</table>
		<br>
		<!-- sub-content -->
		<div class="sub-content">
			<!-- 전체 -->
			<div class="titArea">
				<div class="LblockButton"></div>
			</div>
			<div id="spaceEvAffrSttsGrid"></div>




			<!-- //sub-content -->

		</div>
		<!-- //contents -->
</body>
</html>