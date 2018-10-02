<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8"%>
<%@ page import="java.text.*, java.util.*,devonframe.util.NullUtil,devonframe.util.DateUtil"%>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>
<%--
/*
 *************************************************************************
 * $Id		: rlabYyrStat.jsp
 * @desc    : 통계 > 신뢰성시험 > 연도별통계
 *------------------------------------------------------------------------
 * VER	DATE		AUTHOR		DESCRIPTION
 * ---	-----------	----------	-----------------------------------------
 * 1.0  2018.09.04    		최초생성
 * ---	-----------	----------	-----------------------------------------
 * IRIS 구축 프로젝트
 *************************************************************************
 */
--%>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>
<html>
<head>
<%@ include file="/WEB-INF/jsp/include/rui_header.jspf"%>
<title><%=documentTitle%></title>
<link type="text/css" href="<%=cssPath%>/main.css" rel="stylesheet">
<link type="text/css" href="<%=cssPath%>/common.css" rel="stylesheet">
<script type="text/javascript" src="<%=ruiPathPlugins%>/tab/rui_tab.js"></script>
<link rel="stylesheet" type="text/css" href="<%=ruiPathPlugins%>/tab/rui_tab.css"/>
<style>
 .bgcolor-gray {background-color: #999999}
 .bgcolor-white {background-color: #FFFFFF}
 .L-navset {overflow:hidden;}
</style>
<script type="text/javascript">
var mchnPrctInfoDialog;
var mchnPrctId;

var frtTab;
var rtnUrl;
var mchnInfoId;

	Rui.onReady(function() {
		var tabView = new Rui.ui.tab.LTabView({
        	height: 1250,
            tabs: [ {
                    active: true,
                    label: '시험구분별 통계',
                    id: 'rlabScnStatDiv'
                }, {
                	label: '사업부별 통계',
                    id: 'rlabDzdvStatDiv'
                }, {
                    label: '시험법별 통계',
                    id: 'rlabExprStatDiv'
                }, {
                    label: '담당자별 통계',
                    id: 'rlabChrgStatDiv'
                }]
        });

		/********************
         * 버튼 및 이벤트 처리와 랜더링
         ********************/

        tabView.on('canActiveTabChange', function(e){

            switch(e.activeIndex){
            case 0:

                break;

            case 1:

                break;

            case 2:

            	break;

            case 3:

            	break;

            default:
                break;
            }
        });

        tabView.on('activeTabChange', function(e){

            switch(e.activeIndex){
            case 0:
                break;

            case 1:
                if(e.isFirst){
                }

                break;

            case 2:
                if(e.isFirst){
                }

                break;

            case 3:
                if(e.isFirst){
                }

                break;

            default:
                break;
            }

        });

        tabView.render('tabView');

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

        //시험구분별
        rlabScnStatDataSet = new Rui.data.LJsonDataSet({
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

        //사업부별
        rlabDzdvStatDataSet = new Rui.data.LJsonDataSet({
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

        //시험법별
        rlabExprStatDataSet = new Rui.data.LJsonDataSet({
            id: 'rlabExprStatDataSet',
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

        //담당자별
        rlabChrgStatDataSet = new Rui.data.LJsonDataSet({
            id: 'rlabChrgStatDataSet',
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

        //시험구분별
        var rlabScnStatColumnModel = new Rui.ui.grid.LColumnModel({
        	autoWidth:true
            ,columns: [
            	  { field: 'statGbn',		label: '시험구분',		sortable: false,	align:'center',	width: 100 }
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

        var rlabScnStatGrid = new Rui.ui.grid.LGridPanel({
            columnModel: rlabScnStatColumnModel,
            dataSet: rlabScnStatDataSet,
            width: 980,
            height: 380,
            autoToEdit: true,
            autoWidth: true
        });

        rlabScnStatGrid.render('rlabScnStatGrid');

        rlabScnStatBind = new Rui.data.LBind({
            groupId: 'rlabScnStatDiv',
            dataSet: rlabScnStatDataSet,
            bind: true,
            bindInfo: [
                { id: 'statGbn',			ctrlId:'statGbn',		value:'html'},
                { id: 'm1',					ctrlId:'m1',			value:'html'},
                { id: 'm2',					ctrlId:'m2',			value:'html'},
                { id: 'm3',					ctrlId:'m3',			value:'html'},
                { id: 'm4',					ctrlId:'m4',			value:'html'},
                { id: 'm5',					ctrlId:'m5',			value:'html'},
                { id: 'm6',					ctrlId:'m6',			value:'html'},
                { id: 'm7',					ctrlId:'m7',			value:'html'},
                { id: 'm8',					ctrlId:'m8',			value:'html'},
                { id: 'm9',					ctrlId:'m9',			value:'html'},
                { id: 'm10',				ctrlId:'m10',			value:'html'},
                { id: 'm11',				ctrlId:'m11',			value:'html'},
                { id: 'm12',				ctrlId:'m12',			value:'html'},
                { id: 'etc',				ctrlId:'etc',			value:'html'}
            ]
        });

      //사업부별
        var rlabDzdvStatColumnModel = new Rui.ui.grid.LColumnModel({
        	autoWidth:true
            ,columns: [
            	  { field: 'statGbn',		label: '시험구분',		sortable: false,	align:'center',	width: 100 }
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

        var rlabDzdvStatGrid = new Rui.ui.grid.LGridPanel({
            columnModel: rlabDzdvStatColumnModel,
            dataSet: rlabDzdvStatDataSet,
            width: 980,
            height: 380,
            autoToEdit: true,
            autoWidth: true
        });

        rlabDzdvStatGrid.render('rlabDzdvStatGrid');

        rlabDzdvStatBind = new Rui.data.LBind({
            groupId: 'rlabDzdvStatDiv',
            dataSet: rlabDzdvStatDataSet,
            bind: true,
            bindInfo: [
                { id: 'statGbn',			ctrlId:'statGbn',		value:'html'},
                { id: 'm1',					ctrlId:'m1',			value:'html'},
                { id: 'm2',					ctrlId:'m2',			value:'html'},
                { id: 'm3',					ctrlId:'m3',			value:'html'},
                { id: 'm4',					ctrlId:'m4',			value:'html'},
                { id: 'm5',					ctrlId:'m5',			value:'html'},
                { id: 'm6',					ctrlId:'m6',			value:'html'},
                { id: 'm7',					ctrlId:'m7',			value:'html'},
                { id: 'm8',					ctrlId:'m8',			value:'html'},
                { id: 'm9',					ctrlId:'m9',			value:'html'},
                { id: 'm10',				ctrlId:'m10',			value:'html'},
                { id: 'm11',				ctrlId:'m11',			value:'html'},
                { id: 'm12',				ctrlId:'m12',			value:'html'},
                { id: 'etc',				ctrlId:'etc',			value:'html'}
            ]
        });

      //시험법별
        var rlabExprStatColumnModel = new Rui.ui.grid.LColumnModel({
        	autoWidth:true
            ,columns: [
            	  { field: 'statGbn',		label: '시험구분',		sortable: false,	align:'center',	width: 100 }
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

        var rlabExprStatGrid = new Rui.ui.grid.LGridPanel({
            columnModel: rlabExprStatColumnModel,
            dataSet: rlabExprStatDataSet,
            width: 980,
            height: 380,
            autoToEdit: true,
            autoWidth: true
        });

        rlabExprStatGrid.render('rlabExprStatGrid');

        rlabExprStatBind = new Rui.data.LBind({
            groupId: 'rlabExprStatDiv',
            dataSet: rlabExprStatDataSet,
            bind: true,
            bindInfo: [
                { id: 'statGbn',			ctrlId:'statGbn',		value:'html'},
                { id: 'm1',					ctrlId:'m1',			value:'html'},
                { id: 'm2',					ctrlId:'m2',			value:'html'},
                { id: 'm3',					ctrlId:'m3',			value:'html'},
                { id: 'm4',					ctrlId:'m4',			value:'html'},
                { id: 'm5',					ctrlId:'m5',			value:'html'},
                { id: 'm6',					ctrlId:'m6',			value:'html'},
                { id: 'm7',					ctrlId:'m7',			value:'html'},
                { id: 'm8',					ctrlId:'m8',			value:'html'},
                { id: 'm9',					ctrlId:'m9',			value:'html'},
                { id: 'm10',				ctrlId:'m10',			value:'html'},
                { id: 'm11',				ctrlId:'m11',			value:'html'},
                { id: 'm12',				ctrlId:'m12',			value:'html'},
                { id: 'etc',				ctrlId:'etc',			value:'html'}
            ]
        });

      //담당자별
        var rlabChrgStatColumnModel = new Rui.ui.grid.LColumnModel({
        	autoWidth:true
            ,columns: [
            	  { field: 'statGbn',		label: '시험구분',		sortable: false,	align:'center',	width: 100 }
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
                , { field: 'etc',		label: '비고',		vMerge: true ,sortable: false,	align:'center',	width: 100 }
            ]
        });

        var rlabChrgStatGrid = new Rui.ui.grid.LGridPanel({
            columnModel: rlabChrgStatColumnModel,
            dataSet: rlabChrgStatDataSet,
            width: 980,
            height: 380,
            autoToEdit: true,
            autoWidth: true
        });

        rlabChrgStatGrid.render('rlabChrgStatGrid');

        rlabChrgStatBind = new Rui.data.LBind({
            groupId: 'rlabChrgStatDiv',
            dataSet: rlabChrgStatDataSet,
            bind: true,
            bindInfo: [
                { id: 'statGbn',			ctrlId:'statGbn',		value:'html'},
                { id: 'm1',					ctrlId:'m1',			value:'html'},
                { id: 'm2',					ctrlId:'m2',			value:'html'},
                { id: 'm3',					ctrlId:'m3',			value:'html'},
                { id: 'm4',					ctrlId:'m4',			value:'html'},
                { id: 'm5',					ctrlId:'m5',			value:'html'},
                { id: 'm6',					ctrlId:'m6',			value:'html'},
                { id: 'm7',					ctrlId:'m7',			value:'html'},
                { id: 'm8',					ctrlId:'m8',			value:'html'},
                { id: 'm9',					ctrlId:'m9',			value:'html'},
                { id: 'm10',				ctrlId:'m10',			value:'html'},
                { id: 'm11',				ctrlId:'m11',			value:'html'},
                { id: 'm12',				ctrlId:'m12',			value:'html'},
                { id: 'etc',				ctrlId:'etc',			value:'html'}
            ]
        });

        /* 시험구분별통계 리스트 조회 */
        getRlabScnStatList = function(msg) {

        	rlabScnStatDataSet.load({
                url: '<c:url value="/stat/rlab/retrieveRlabScnStatList.do"/>',
                params :{
                	yyyy :  yy.getValue()
                	//yyyy : '2018'
                }
            });
        };

        //getRlabScnStatList();

        /* 사업부별통계 리스트 조회 */
        getRlabDzdvStatList = function(msg) {
        	rlabDzdvStatDataSet.load({
                url: '<c:url value="/stat/rlab/retrieveRlabDzdvStatList.do"/>',
                params :{
                	yyyy :  yy.getValue()
                	//yyyy : '2018'
                }
            });
        };

        //getRlabDzdvStatList();

        /* 시험법별통계 리스트 조회 */
        getRlabExprStatList = function(msg) {
        	rlabExprStatDataSet.load({
                url: '<c:url value="/stat/rlab/retrieveRlabExprStatList.do"/>',
                params :{
                	//yyyy : $("#yyyy option:selected").val()
                	yyyy :  yy.getValue()
                }
            });
        };

        //getRlabExprStatList();

        /* 담당자별통계 리스트 조회 */
        getRlabChrgStatList = function(msg) {
        	rlabChrgStatDataSet.load({
                url: '<c:url value="/stat/rlab/retrieveRlabChrgStatList.do"/>',
                params :{
                	yyyy : yy.getValue()
                	//yyyy : '2018'
                }
            });
        };

        //getRlabChrgStatList();

        /* 조회 */
        fnSearch = function() {
        	getRlabScnStatList();
        	getRlabDzdvStatList();
        	getRlabExprStatList();
        	getRlabChrgStatList();
        };
	});	//end ready

</script>
</head>


<body>
   			<form name="aform" id="aform" method="post">
 <!-- contents -->
<div class="contents">
	<div class="titleArea">
		<a class="leftCon" href="#">
	    	<img src="/iris/resource/web/images/img_uxp/ico_leftCon.png" alt="Left Navigation Control">
	    	<span class="hidden">Toggle 버튼</span>
        </a>
		<h2>연도별 통계</h2>
    </div>
    <div class="sub-content">
    		<div class="search">
			<div class="search-content">
    			<table>
   					<colgroup>
						<col style="width: 120px;" />
                        <col style="width: 300px;" />
                        <col style="width: 120px;" />
                        <col style="width: 300px;" />
                        <col style="" />
					</colgroup>
   					<tbody>
   						<tr>
   							<th align="right">연도</th>
    						<td>
    							<div id="yy" class="form_bd"></div>
   							</td>
   							<td></td>
   							<td></td>
   							<td class="txt-right"><a style="cursor: pointer;" onclick="fnSearch();" class="btnL">검색</a></td>
   						</tr>
   					</tbody>
   				</table>
   				</div>
   				</div>
	<!-- sub-content -->
		<div id="tabView"></div>
		<!-- 시험구분별통계 -->
		<div id="rlabScnStatDiv">
   			<div class="titArea">
   				<div class="LblockButton">
   				</div>
   			</div>
   			<div id="rlabScnStatGrid"></div>
   			<br/>
   		</div>
   		<!-- 사업부별 통계 -->
		<div id="rlabDzdvStatDiv">
   			<div class="titArea">
   				<div class="LblockButton">
   				</div>
   			</div>
   			<div id="rlabDzdvStatGrid"></div>
   			<br/>
   		</div>
   		<!-- 시험법별 통계 -->
		<div id="rlabExprStatDiv">
   			<div class="titArea">
   				<div class="LblockButton">
   				</div>
   			</div>
   			<div id="rlabExprStatGrid"></div>
   			<br/>
   		</div>
   		<!-- 담당자별 통계 -->
		<div id="rlabChrgStatDiv">
   			<div class="titArea">
   				<div class="LblockButton">
   				</div>
   			</div>
   			<div id="rlabChrgStatGrid"></div>
   			<br/>
   		</div>

	</div>
	<!-- //sub-content -->

</div>
<!-- //contents -->
</form>
</body>
</html>