<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>

<%--
/*
 *************************************************************************
 * $Id		: anlChrgStateList.jsp
 * @desc    : 담당자 분석 통계 리스트
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
            var fromAcpcDt = new Rui.ui.form.LMonthBox({
     			applyTo: 'fromAcpcDt',
     			defaultValue: '<c:out value="${inputData.fromAcpcDt}"/>',
     			width: 100,
     			dateType: 'string'
     		});
            fromAcpcDt.on('blur', function(){
				if( fromAcpcDt.getValue() > toAcpcDt.getValue() ) {
					alert('시작일이 종료일보다 클 수 없습니다.!!');
					fromAcpcDt.setValue(toAcpcDt.getValue());
				}
			});

            var toAcpcDt = new Rui.ui.form.LMonthBox({
     			applyTo: 'toAcpcDt',
     			defaultValue: '<c:out value="${inputData.toAcpcDt}"/>',
     			width: 100,
     			dateType: 'string'
     		});

            toAcpcDt.on('blur', function(){
				if( fromAcpcDt.getValue() > toAcpcDt.getValue() ) {
					alert('시작일이 종료일보다 클 수 없습니다.!!');
					fromAcpcDt.setValue(toAcpcDt.getValue());
				}
			});

             /*
            var fromAcpcDt = new Rui.ui.form.LDateBox({
				applyTo: 'fromAcpcDt',
				mask: '9999-99',
				displayValue: '%Y-%m',
				defaultValue: '<c:out value="${inputData.fromAcpcDt}"/>',
				editable: false,
				width: 70,
				dateType: 'string'
			});

            fromAcpcDt.on('blur', function(){
				if( ! Rui.util.LDate.isDate( Rui.util.LString.toDate(nwinsReplaceAll(fromAcpcDt.getValue(),"-","")) ) )  {
					alert('날짜형식이 올바르지 않습니다.!!');
					fromAcpcDt.setValue(new Date());
				}

				if( fromAcpcDt.getValue() > toAcpcDt.getValue() ) {
					alert('시작일이 종료일보다 클 수 없습니다.!!');
					fromAcpcDt.setValue(toAcpcDt.getValue());
				}
			});

            var toAcpcDt = new Rui.ui.form.LDateBox({
				applyTo: 'toAcpcDt',
				mask: '9999-99',
				displayValue: '%Y-%m',
				defaultValue: '<c:out value="${inputData.toAcpcDt}"/>',
				editable: false,
				width: 70,
				dateType: 'string'
			});

			toAcpcDt.on('blur', function(){
				if( ! Rui.util.LDate.isDate( Rui.util.LString.toDate(nwinsReplaceAll(toAcpcDt.getValue(),"-","")) ) )  {
					alert('날짜형식이 올바르지 않습니다.!!');
					toAcpcDt.setValue(new Date());
				}

				if( fromAcpcDt.getValue() > toAcpcDt.getValue() ) {
					alert('시작일이 종료일보다 클 수 없습니다.!!');
					fromAcpcDt.setValue(toAcpcDt.getValue());
				}
			});
            */
            var anlChrgId = new Rui.ui.form.LCombo({
                applyTo: 'anlChrgId',
                name: 'anlChrgId',
                useEmptyText: true,
                emptyText: '(전체)',
                defaultValue: '',
                emptyValue: '',
                url: '<c:url value="/anl/getAnlChrgList.do"/>',
                displayField: 'name',
                valueField: 'userId'
            });

            /*******************
             * 변수 및 객체 선언
            *******************/
            var anlChrgStateDataSet = new Rui.data.LJsonDataSet({
                id: 'anlChrgStateDataSet',
                remainRemoved: true,
                lazyLoad: true,
                fields: [
					  { id: 'anlChrgNm'}
					, { id: 'tatalCnt' }
					, { id: 'progressCnt' }
					, { id: 'completeCnt' }
					, { id: 'completeRate' }
					, { id: 'stopCnt' }
					, { id: 'exprCnt' }
					, { id: 'IncompleteCnt' }
					, { id: 'exprCompleteCnt' }
					, { id: 'avgCmplWkDdDate' }
					, { id: 'avgCmplWkDdRate' }
                ]
            });

            var anlChrgStateColumnModel = new Rui.ui.grid.LColumnModel({
                columns: [
                      { field: 'anlChrgNm',			label: '담당자',			sortable: false,	align:'center',	width: 213 }
                    , { field: 'IncompleteCnt',		label: '이월 건',			sortable: false,	align:'center',	width: 120 }
                    , { field: 'tatalCnt',			label: '분석접수',			sortable: false,	align:'center',	width: 120 }
					, { field: 'stopCnt',			label: '분석중단',			sortable: false, 	align:'center',	width: 120 }
                    , { field: 'completeCnt',		label: '분석완료',			sortable: false,	align:'center',	width: 120 }
                    , { field: 'completeRate',		label: '완료율(%)',			sortable: false,	align:'center',	width: 130}
					, { field: 'exprCompleteCnt',	label: '실험완료',			sortable: false, 	align:'center',	width: 120 }
					, { field: 'avgCmplWkDdDate',	label: '평균 완료기간(일)',	sortable: false, 	align:'center',	width: 190 }
                    , { field: 'avgCmplWkDdRate',	label: '결과통보 준수율(%)',	sortable: false, 	align:'center',	width: 190}
                ]
            });

            var anlChrgStateGrid = new Rui.ui.grid.LGridPanel({
                columnModel: anlChrgStateColumnModel,
                dataSet: anlChrgStateDataSet,
                width: 860,
                height: 580,
                autoToEdit: false,
                autoWidth: true
            });

            anlChrgStateGrid.render('anlChrgStateGrid');

            /* 조회 */
            getAnlChrgStateList = function() {
            	anlChrgStateDataSet.load({
                    url: '<c:url value="/stat/anl/getAnlChrgStateList.do"/>',
                    params :{
            		    anlChrgId : anlChrgId.getValue(),
            		    fromAcpcDt : fromAcpcDt.getValue(),
            		    toAcpcDt : toAcpcDt.getValue()
                    }
                });
            };

            anlChrgStateDataSet.on('load', function(e) {
   	    		$("#cnt_text").html('총 ' + anlChrgStateDataSet.getCount() + '건');
   	      	});

            /* 분석의뢰 리스트 엑셀 다운로드 */
        	downloadAnlChrgStateListExcel = function() {
                anlChrgStateGrid.saveExcel(encodeURIComponent('담당자 분석 통계_') + new Date().format('%Y%m%d') + '.xls');
            };

            getAnlChrgStateList();

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
   				<h2>담당자 분석통계</h2>
   			</div>

	   		<div class="sub-content">
	   			<div class="search">
			   		<div class="search-content">
		   				<table>
		   					<colgroup>
		   						<col style="width:120px;"/>
		   						<col style="width:300px;"/>
		   						<col style="width:120px;"/>
		   						<col style=""/>
		   						<col style=""/>
		   					</colgroup>
		   					<tbody>
		   						<tr>
		   							<th align="right">기간</th>
		    						<td>
		   								<input type="text" id="fromAcpcDt"/><em class="gab"> ~ </em>
		   								<input type="text" id="toAcpcDt"/>
		    						</td>
		   							<th align="right">담당자</th>
		    						<td>
		                                <div id="anlChrgId"></div>
		    						</td>
		   							<td class="txt-right">
		   								<a style="cursor: pointer;" onclick="getAnlChrgStateList();" class="btnL">검색</a>
		   							</td>
		   						</tr>
		   					</tbody>
		   				</table>
	   				</div>
   				</div>

   				<div class="titArea">
   					<span class="Ltotal" id="cnt_text">총  0건 </span>
   					<div class="LblockButton">
   						<button type="button" class="btn"  id="excelBtn" name="excelBtn" onclick="downloadAnlChrgStateListExcel()">Excel</button>
   					</div>
   				</div>

   				<div id="anlChrgStateGrid"></div>

   			</div><!-- //sub-content -->
   		</div><!-- //contents -->
		</form>
    </body>
</html>