<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>			
<%@ page import="java.text.*,
				 java.util.*,
				 devonframe.util.NullUtil,
				 devonframe.util.DateUtil"%>

<%--
/*
 *************************************************************************
 * $Id		: anlBusinessStateList.jsp
 * @desc    : 분석 업무현황 통계 리스트
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
           //관리일(시작)
     		var fromCmplDt = new Rui.ui.form.LMonthBox({
     			applyTo: 'fromCmplDt',
     			defaultValue: '<c:out value="${inputData.fromCmplDt}"/>',
     			width: 100,
     			dateType: 'string'
     		});
            
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
			*/
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
			/* 
            var toCmplDt = new Rui.ui.form.LDateBox({
				applyTo: 'toCmplDt',
				mask: '9999-99',
				displayValue: '%Y-%m',
				defaultValue: '<c:out value="${inputData.toCmplDt}"/>',
				editable: false,
				width: 70,
				dateType: 'string'
			});
			 */ 
			toCmplDt.on('blur', function(){
				if( fromCmplDt.getValue() > toCmplDt.getValue() ) {
					alert('시작일이 종료일보다 클 수 없습니다.!!');
					fromCmplDt.setValue(toCmplDt.getValue());
				}
			});
            
            var anlChrgId = new Rui.ui.form.LCombo({
                applyTo: 'anlChrgId',
                name: 'anlChrgId',
                useEmptyText: true,
                emptyText: '전체',
                defaultValue: '',
                emptyValue: '',
                url: '<c:url value="/anl/getAnlChrgList.do"/>',
                displayField: 'name',
                valueField: 'userId'
            });
			
            /*******************
             * 변수 및 객체 선언
            *******************/
            var anlBusinessStateDataSet = new Rui.data.LJsonDataSet({
                id: 'anlBusinessStateDataSet',
                remainRemoved: true,
                lazyLoad: true,
                focusFirstRow: false,
                fields: [
					  { id: 'typeUgyNm'}
					, { id: 'typeNm' }
					, { id: 'completeCnt' }
					, { id: 'typeDesc' }
                ]
            });

            var anlBusinessStateColumnModel = new Rui.ui.grid.LColumnModel({
            	groupMerge: true,
                columns: [
                      { field: 'typeUgyNm',			label: '분석유형',		sortable: false,	align:'center',	width: 100,	vMerge: true }
                    , { field: 'typeNm',			label: '구분',		sortable: false,	align:'left',	width: 150 }
                    , { field: 'completeCnt',		label: '건',			sortable: false,	align:'center',	width: 100 }
                    , { field: 'typeDesc',			label: '설명',		sortable: false,	align:'left',	width: 800 }
                ]
            });

            var anlBusinessStateGrid = new Rui.ui.grid.LGridPanel({
                columnModel: anlBusinessStateColumnModel,
                dataSet: anlBusinessStateDataSet,
                width: 860,
                height: 600,
                autoToEdit: false,
                autoWidth: true
            });
            
            anlBusinessStateGrid.render('anlBusinessStateGrid');
            
            /* 조회 */
            getAnlBusinessStateList = function() {
            	anlBusinessStateDataSet.load({
                    url: '<c:url value="/stat/anl/getAnlBusinessStateList.do"/>',
                    params :{
            		    anlChrgId : anlChrgId.getValue(),
            		    fromCmplDt : fromCmplDt.getValue().substring(0, 7), 
            		    toCmplDt : toCmplDt.getValue().substring(0, 7)
                    }
                });
            };
            
            anlBusinessStateDataSet.on('load', function(e) {
   	    		$("#cnt_text").html('총 ' + anlBusinessStateDataSet.getCount() + '건');
   	      	});
            
            /* 분석의뢰 리스트 엑셀 다운로드 */
        	downloadAnlBusinessStateListExcel = function() {
        		anlBusinessStateGrid.saveExcel(encodeURIComponent('분석 업무현황 통계_') + new Date().format('%Y%m%d') + '.xls');
            };
            
            getAnlBusinessStateList();
			
        });

	</script>
    </head>
    <body>
	<form name="aform" id="aform" method="post">
		
   		<div class="contents">

   			<div class="sub-content">
	   			<div class="titleArea">
	   				<h2>분석 업무현황</h2>
	   			</div>
	   			
   				<table class="searchBox">
   					<colgroup>
   						<col style="width:10%;"/>
   						<col style="width:35%;"/>
   						<col style="width:10%;"/>
   						<col style="width:35%;"/>
   						<col style="width:10%;"/>
   					</colgroup>
   					<tbody>
   						<tr>
   							<th align="right">기간</th>
    						<td>
   								<input type="text" id="fromCmplDt"/><em class="gab"> ~ </em>
   								<input type="text" id="toCmplDt"/>
    						</td>
   							<th align="right">담당자</th>
    						<td>
                                <div id="anlChrgId"></div>
    						</td>
   							<td class="t_center">
   								<a style="cursor: pointer;" onclick="getAnlBusinessStateList();" class="btnL">검색</a>
   							</td>
   						</tr>
   					</tbody>
   				</table>
   				
   				<div class="titArea">
   					<span class="Ltotal" id="cnt_text">총  0건 </span>
   					<div class="LblockButton">
   						<button type="button" class="btn"  id="excelBtn" name="excelBtn" onclick="downloadAnlBusinessStateListExcel()">Excel</button>
   					</div>
   				</div>

   				<div id="anlBusinessStateGrid"></div>
   				
   			</div><!-- //sub-content -->
   		</div><!-- //contents -->
		</form>
    </body>
</html>