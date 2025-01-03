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
 * $Id		: spaceAnlWayStat.jsp
 * @desc    : 통계 > 공간성능평가 > 분석방법별 통계
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
            useEmptyText: false,
            defaultValue : new Date().format('%Y'),
            items: [
                <c:forEach var="i" begin="0" varStatus="status" end="19">
                    { value : "${ 2030 - i }" , text : "${ 2030 - i }" } ,
                </c:forEach>
            ]
        });

        //전체
        spaceAnlWayStatDataSet = new Rui.data.LJsonDataSet({
            id: 'spaceAnlWayStatDataSet',
            remainRemoved: true,
            lazyLoad: true,
            fields: [
            	  { id: 'ALL_EV_PRVS' }
            	, { id: 'ALL_EV_PRVS_NM' }
            	, { id: 'ALL_EV_CTGR' }
            	, { id: 'ALL_EV_CTGR_NM' }
            	, { id: 'CNT' }
            	, { id: 'AVG_CNT' }
            	, { id: 'M1' }
				, { id: 'M2' }
				, { id: 'M3' }
				, { id: 'M4' }
				, { id: 'M5' }
				, { id: 'M6' }
				, { id: 'M7' }
				, { id: 'M8' }
				, { id: 'M9' }
				, { id: 'M10' }
				, { id: 'M11' }
				, { id: 'M12' }
            ]
        });



        //
        var spaceAnlWayStatColumnModel = new Rui.ui.grid.LColumnModel({
        	autoWidth:true
            ,columns: [
            	  { field: 'ALL_EV_PRVS_NM',		label: '분석유형',		sortable: false,	align:'center',	width: 100, vMerge:true}
                , { field: 'ALL_EV_CTGR_NM',		label: '상세구분',		sortable: false,	align:'center',	width: 50}
                , { field: 'CNT',				label: '합계',		sortable: false,	align:'center',	width: 50
                	, renderer: function(value, p, record, row, col){
                		if( record.get('ALL_EV_CTGR_NM')=='비율' ){
                			return value + '%';
                		}else{
                			return value;
                		}
                	}}
                , { field: 'AVG_CNT',			label: '월평균',		sortable: false,	align:'center',	width: 50
                	, renderer: function(value, p, record, row, col){
                		if( record.get('ALL_EV_CTGR_NM')=='비율' ){
                			return value + '%';
                		}else{
                			return value;
                		}
                	}}
                , { field: 'M1',				label: '1월',		sortable: false,	align:'center',	width: 50
                	, renderer: function(value, p, record, row, col){
                		if( record.get('ALL_EV_CTGR_NM')=='비율' ){
                			return value + '%';
                		}else{
                			return value;
                		}
                	}}
                , { field: 'M2',				label: '2월',		sortable: false,	align:'center',	width: 50
                	, renderer: function(value, p, record, row, col){
                		if( record.get('ALL_EV_CTGR_NM')=='비율' ){
                			return value + '%';
                		}else{
                			return value;
                		}
                	}}
                , { field: 'M3',				label: '3월',		sortable: false,	align:'center',	width: 50
                	, renderer: function(value, p, record, row, col){
                		if( record.get('ALL_EV_CTGR_NM')=='비율' ){
                			return value + '%';
                		}else{
                			return value;
                		}
                	}}
                , { field: 'M4',				label: '4월',		sortable: false,	align:'center',	width: 50
                	, renderer: function(value, p, record, row, col){
                		if( record.get('ALL_EV_CTGR_NM')=='비율' ){
                			return value + '%';
                		}else{
                			return value;
                		}
                	}}
                , { field: 'M5',				label: '5월',		sortable: false,	align:'center',	width: 50
                	, renderer: function(value, p, record, row, col){
                		if( record.get('ALL_EV_CTGR_NM')=='비율' ){
                			return value + '%';
                		}else{
                			return value;
                		}
                	}}
                , { field: 'M6',				label: '6월',		sortable: false,	align:'center',	width: 50
                	, renderer: function(value, p, record, row, col){
                		if( record.get('ALL_EV_CTGR_NM')=='비율' ){
                			return value + '%';
                		}else{
                			return value;
                		}
                	}}
                , { field: 'M7',				label: '7월',		sortable: false,	align:'center',	width: 50
                	, renderer: function(value, p, record, row, col){
                		if( record.get('ALL_EV_CTGR_NM')=='비율' ){
                			return value + '%';
                		}else{
                			return value;
                		}
                	}}
                , { field: 'M8',				label: '8월',		sortable: false,	align:'center',	width: 50
                	, renderer: function(value, p, record, row, col){
                		if( record.get('ALL_EV_CTGR_NM')=='비율' ){
                			return value + '%';
                		}else{
                			return value;
                		}
                	}}
                , { field: 'M9',				label: '9월',		sortable: false,	align:'center',	width: 50
                	, renderer: function(value, p, record, row, col){
                		if( record.get('ALL_EV_CTGR_NM')=='비율' ){
                			return value + '%';
                		}else{
                			return value;
                		}
                	}}
                , { field: 'M10',				label: '10월',		sortable: false,	align:'center',	width: 50
                	, renderer: function(value, p, record, row, col){
                		if( record.get('ALL_EV_CTGR_NM')=='비율' ){
                			return value + '%';
                		}else{
                			return value;
                		}
                	}}
                , { field: 'M11',				label: '11월',		sortable: false,	align:'center',	width: 50
                	, renderer: function(value, p, record, row, col){
                		if( record.get('ALL_EV_CTGR_NM')=='비율' ){
                			return value + '%';
                		}else{
                			return value;
                		}
                	}}
                , { field: 'M12',				label: '12월',		sortable: false,	align:'center',	width: 50
                	, renderer: function(value, p, record, row, col){
                		if( record.get('ALL_EV_CTGR_NM')=='비율' ){
                			return value + '%';
                		}else{
                			return value;
                		}
                	}}
            ]
        });

        var spaceAnlWayStatGrid = new Rui.ui.grid.LGridPanel({
            columnModel: spaceAnlWayStatColumnModel,
            dataSet: spaceAnlWayStatDataSet,
            width: 980,
            height: 380,
            autoToEdit: true,
            autoWidth: true
        });

        spaceAnlWayStatGrid.render('spaceAnlWayStatGrid');




        /* 분석방법별 통계 리스트 조회 */
        getSpaceAnlWayStatList = function(msg) {

        	spaceAnlWayStatDataSet.load({
                url: '<c:url value="/stat/space/getSpaceAnlWayStatList.do"/>',
                params :{
                	yyyy :  yy.getValue()
                	//yyyy : '2018'
                }
            });
        };




        /* 조회 */
        fnSearch = function() {
        	getSpaceAnlWayStatList();
        };
	});	//end ready

</script>
</head>


<body>
	<!-- contents -->
	<div class="contents">
		<div class="titleArea">
			<a class="leftCon" href="#">
				<img src="/iris/resource/web/images/img_uxp/ico_leftCon.png" alt="Left Navigation Control">
				<span class="hidden">Toggle 버튼</span>
			</a>
			<h2>분석방법별 통계</h2>
		</div>

		<div class="sub-content">
			<div class="search mb20">
				<div class="search-content">
					<table>
						<colgroup>
							<col style="width:120px" />
							<col style="width: 300px;" />
                        	<col style="width: 120px;" />
                        	<col style="width: 300px;" />
							<col style="" />
						</colgroup>
						<tbody>
							<tr>
								<th align="right">연도</th>
								<td class="tain_bo">
									<div id="yy"></div>
								</td>
								<td></td>
								<td></td>
								<td class="txt-right">
									<a style="cursor: pointer;margin-left:5px;"
									onclick="fnSearch();" class="btnL">검색</a>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
			</div>

			<!--
			<div class="titArea">
				<div class="LblockButton"></div>
			</div> -->
			<div id="spaceAnlWayStatGrid"></div>
		</div>
			<!-- //sub-content -->

	</div>
		<!-- //contents -->
</body>
</html>