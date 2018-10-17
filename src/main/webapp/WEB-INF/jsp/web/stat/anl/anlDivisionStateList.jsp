<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*,
				 java.util.*,
				 devonframe.util.NullUtil,
				 devonframe.util.DateUtil"%>

<%--
/*
 *************************************************************************
 * $Id		: anlDivisionStateList.jsp
 * @desc    : 사업부 통계 리스트
 *------------------------------------------------------------------------
 * VER	DATE		AUTHOR		DESCRIPTION
 * ---	-----------	----------	-----------------------------------------
 * 1.0  2017.08.25  오명철		최초생성
 * ---	-----------	----------	-----------------------------------------
 * WINS UPGRADE 1차 프로젝트
 *************************************************************************
 */
--%>

<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<%@ include file="/WEB-INF/jsp/include/rui_header.jspf"%>

<title><%=documentTitle%></title>
<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/calendar/LMonthCalendar.js"></script>
<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/form/LMonthBox.js"></script>
<link rel="stylesheet" type="text/css" href="<%=ruiPathPlugins%>/ui/form/LMonthBox.css"/>

<style>
 .bgcolor-gray {background-color: #999999}
 .bgcolor-white {background-color: #FFFFFF}
</style>

	<script type="text/javascript">

		Rui.onReady(function() {
            /*******************
             * 변수 및 객체 선언
             *******************/
            /*
            var fromCmplDt = new Rui.ui.form.LDateBox({
				applyTo: 'fromCmplDt',
				mask: '9999-99',
				displayValue: '%Y-%m',
				defaultValue: '<c:out value="${inputData.fromCmplDt}"/>',
				editable: false,
				width: 70,
				dateType: 'string'
			});

            fromCmplDt.on('blur', function(){
				if( ! Rui.util.LDate.isDate( Rui.util.LString.toDate(nwinsReplaceAll(fromCmplDt.getValue(),"-","")) ) )  {
					alert('날자형식이 올바르지 않습니다.!!');
					fromCmplDt.setValue(new Date());
				}

				if( fromCmplDt.getValue() > toCmplDt.getValue() ) {
					alert('시작일이 종료일보다 클 수 없습니다.!!');
					fromCmplDt.setValue(toCmplDt.getValue());
				}
			});

            var toCmplDt = new Rui.ui.form.LDateBox({
				applyTo: 'toCmplDt',
				mask: '9999-99',
				displayValue: '%Y-%m',
				defaultValue: '<c:out value="${inputData.toCmplDt}"/>',
				editable: false,
				width: 70,
				dateType: 'string'
			});

			toCmplDt.on('blur', function(){
				if( ! Rui.util.LDate.isDate( Rui.util.LString.toDate(nwinsReplaceAll(toCmplDt.getValue(),"-","")) ) )  {
					alert('날자형식이 올바르지 않습니다.!!');
					toCmplDt.setValue(new Date());
				}

				if( fromCmplDt.getValue() > toCmplDt.getValue() ) {
					alert('시작일이 종료일보다 클 수 없습니다.!!');
					fromCmplDt.setValue(toCmplDt.getValue());
				}
			});

           */

           var fromCmplDt = new Rui.ui.form.LMonthBox({
				applyTo: 'fromCmplDt',
				defaultValue: '<c:out value="${inputData.fromCmplDt}"/>',
				width: 100,
				dateType: 'string'
			});

           fromCmplDt.on('blur', function(){
				if( fromCmplDt.getValue() > toCmplDt.getValue() ) {
					alert('시작일이 종료일보다 클 수 없습니다.!!');
					fromCmplDt.setValue(toCmplDt.getValue());
				}
			});

           var toCmplDt = new Rui.ui.form.LMonthBox({
				applyTo: 'toCmplDt',
				defaultValue: '<c:out value="${inputData.toCmplDt}"/>',
				width: 100,
				dateType: 'string'
			});

           toCmplDt.on('blur', function(){
				if( fromCmplDt.getValue() > toCmplDt.getValue() ) {
					alert('시작일이 종료일보다 클 수 없습니다.!!');
					fromCmplDt.setValue(toCmplDt.getValue());
				}
			});

            /*******************
             * 변수 및 객체 선언
            *******************/
            var anlDivisionStateDataSet = new Rui.data.LJsonDataSet({
                id: 'anlDivisionStateDataSet',
                remainRemoved: true,
                lazyLoad: true,
                focusFirstRow: false,
                fields: [
					  { id: 'deptNm'}
					, { id: 'bun' }
					, { id: 'sil' }
					, { id: 'suga' }
					, { id: 'gigi' }
					, { id: 'tot' }
					, { id: 'av' }
                ]
            });

            var anlDivisionStateColumnModel = new Rui.ui.grid.LColumnModel({
            	groupMerge: true,
                columns: [
                	  { field: 'deptNm',		label: '사업부',		sortable: false,	align:'center',	width: 287,	vMerge: true }
                    , { field: 'bun',			label: '분석 건',		sortable: false,	align:'center',	width: 170,	vMerge: true }
                    , { field: 'sil',			label: '실험 수',		sortable: false,	align:'center',	width: 170,	vMerge: true }
                    , { field: 'suga',			label: '분석수가(&#8361)',		sortable: false,	align:'center',	width: 170,	vMerge: true, renderer: function(value, p, record){
                    	return Rui.util.LFormat.numberFormat(parseInt(value));
                    }}
                    , { field: 'gigi',			label: '기기이용료(&#8361)',	sortable: false,	align:'center',	width: 170,	vMerge: true , renderer: function(value, p, record){
                    	return Rui.util.LFormat.numberFormat(parseInt(value));
                    }}
                    , { field: 'tot',			label: '비용합계(&#8361)',		sortable: false,	align:'center',	width: 177,	vMerge: true , renderer: function(value, p, record){
                    	return Rui.util.LFormat.numberFormat(parseInt(value));
                    }}
                    , { field: 'av',			label: '비율(%)',			sortable: false,	align:'center',	width: 180,	vMerge: true}

                ]
            });

            var anlDivisionStateGrid = new Rui.ui.grid.LGridPanel({
                columnModel: anlDivisionStateColumnModel,
                dataSet: anlDivisionStateDataSet,
                width: 1180,
                height: 480,
                autoWidth: true

            });

            anlDivisionStateGrid.render('anlDivisionStateGrid');

            /* 조회 */
            getAnlDivisionStateList = function() {
            	anlDivisionStateDataSet.load({
                    url: '<c:url value="/stat/anl/getAnlDivisionStateList.do"/>',
                    params :{
            		    //type : type.getValue(),
            		    fromCmplDt : fromCmplDt.getValue(),
            		    toCmplDt : toCmplDt.getValue()
                    }
                });
            };

            anlDivisionStateDataSet.on('load', function(e) {
   	    		$("#cnt_text").html('총 ' + anlDivisionStateDataSet.getCount() + '건');
   	      	});

            /* 분석의뢰 리스트 엑셀 다운로드 */
        	downloadAnlDivisionStateListExcel = function() {
nG.saveExcel(encodeURIComponent('사업부 통계_') + new Date().format('%Y%m%d') + '.xls');
            };

            getAnlDivisionStateList();

        });

	</script>
    </head>
    <body>
	<form name="aform" id="aform" method="post">

   		<div class="contents">
   			<div class="titleArea">
   				<a class="leftCon" href="#">
	   				<img src="/iris/resource/web/images/img_uxp/ico_leftCon.png" alt="Left Navigation Control">
	   				<span class="hidden">Toggle 버튼</span>
   				</a>
   				<h2>사업부 통계</h2>
   			</div>

	   		<div class="sub-content">
	   			<div class="search">
			   		<div class="search-content">
		   				<table>
		   					<colgroup>
		   						<col style="width:120px;"/>
		   						<col style="width:276px;"/>
		   						<col style=""/>
		   					</colgroup>
		   					<tbody>
		   						<tr>
		   							<th align="right">기간</th>
		    						<td>
		   								<input type="text" id="fromCmplDt"/><em class="gab"> ~ </em>
		   								<input type="text" id="toCmplDt"/>
		    						</td>
		   							<td>
		   								<a style="cursor: pointer;" onclick="getAnlDivisionStateList();" class="btnL">검색</a>
		   							</td>
		    						<!--
		   							<th align="right">구분</th>
		    						<td>
		                                <div id="type"></div>
		    						</td>
		   							<td class="txt-right">
		   								<a style="cursor: pointer;" onclick="getAnlDivisionStateList();" class="btnL">검색</a>
		   							</td>
		   							-->
		   						</tr>
		   					</tbody>
		   				</table>
	   				</div>
   				</div>

   				<div class="titArea">
   					<span class="Ltotal" id="cnt_text">총  0건 </span>
   					<div class="LblockButton">
   						<button type="button" class="btn"  id="excelBtn" name="excelBtn" onclick="downloadAnlDivisionStateListExcel()">Excel</button>
   					</div>
   				</div>

   				<div id="anlDivisionStateGrid"></div>

   			</div><!-- //sub-content -->
   		</div><!-- //contents -->
		</form>
    </body>
</html>