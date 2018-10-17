<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*,
				 java.util.*,
				 devonframe.util.NullUtil,
				 devonframe.util.DateUtil"%>

<%--
/*
 *************************************************************************
 * $Id		: anlCompleteStateList.jsp
 * @desc    : 분석완료 통계 리스트
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
<script type="text/javascript" src="<%=scriptPath%>/gridPaging.js"></script>

<title><%=documentTitle%></title>

<style>
 .bgcolor-gray {background-color: #999999}
 .bgcolor-white {background-color: #FFFFFF}
</style>

	<script type="text/javascript">

		Rui.onReady(function() {
            /*******************
             * 변수 및 객체 선언
             *******************/

            var fromCmplDt = new Rui.ui.form.LDateBox({
				applyTo: 'fromCmplDt',
				mask: '9999-99-99',
				displayValue: '%Y-%m-%d',
				defaultValue: '<c:out value="${inputData.fromCmplDt}"/>',
				editable: false,
				width: 100,
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
				mask: '9999-99-99',
				displayValue: '%Y-%m-%d',
				defaultValue: '<c:out value="${inputData.toCmplDt}"/>',
				editable: false,
				width: 100,
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
            var anlCompleteStateDataSet = new Rui.data.LJsonDataSet({
                id: 'anlCompleteStateDataSet',
                remainRemoved: true,
                lazyLoad: true,
                fields: [
					  { id: 'acpcStNm'}
					, { id: 'acpcNo' }
					, { id: 'busiDeptNm' }
					, { id: 'rqprDeptNm' }
					, { id: 'rgstNm' }
					, { id: 'anlChrgNm' }
					, { id: 'anlUgyYnNm' }
					, { id: 'anlScnNm' }
					, { id: 'anlNm' }
					, { id: 'smpoCnt', type:'number' }
					, { id: 'exprSmpoCnt' }
					, { id: 'exprExp' }
					, { id: 'acpcDt' }
					, { id: 'cmplDt' }
					, { id: 'cmplWkDdCnt' }
					, { id: 'cmplParrDt' }
					, { id: 'complObservanceYn' }
                ]
            });

            var anlCompleteStateColumnModel = new Rui.ui.grid.LColumnModel({
                columns: [
                      { field: 'acpcStNm',			label: '상태',		sortable: false,	align:'center',	width: 80 }
                    , { field: 'acpcNo',			label: '접수번호',		sortable: false,	align:'center',	width: 80 }
                    , { field: 'busiDeptNm',		label: '사업부',		sortable: false,	align:'center',	width: 150 }
                    , { field: 'rqprDeptNm',		label: '팀(PJT)',	sortable: false,	align:'center',	width: 150 }
                    , { field: 'rgstNm',			label: '의뢰자',		sortable: false,	align:'center',	width: 70 }
					, { field: 'anlChrgNm',			label: '분석담당자',	sortable: false, 	align:'center',	width: 80 }
					, { field: 'anlUgyYnNm',		label: '긴급여부',		sortable: false, 	align:'center',	width: 80 }
					, { field: 'anlScnNm',			label: '분석구분',		sortable: false, 	align:'center',	width: 80 }
					, { field: 'anlNm',				label: '분석명',		sortable: false, 	align:'left',	width: 370 }
                    , { field: 'smpoCnt',			label: '시료 수',		sortable: false, 	align:'center',	width: 60}
                    , { field: 'exprSmpoCnt',		label: '실험 수',		sortable: false,  	align:'center',	width: 60 }
					, { field: 'exprExp',			label: '분석 수가',		sortable: false, 	align:'center',	width: 80,
						renderer: Rui.util.LRenderer.moneyRenderer() }
					, { field: 'acpcDt',			label: '접수일',		sortable: false, 	align:'center',	width: 80 }
					, { field: 'cmplDt',			label: '분석 완료일',	sortable: false, 	align:'center',	width: 80 }
					, { field: 'cmplWkDdCnt',		label: '완료기간',		sortable: false, 	align:'center',	width: 80 }
					, { field: 'cmplParrDt',		label: '완료 예정일',	sortable: false, 	align:'center',	width: 80 }
					, { field: 'complObservanceYn',	label: '결과통보 준수',	sortable: false, 	align:'center',	width: 80 }
                ]
            });

            var anlCompleteStateGrid = new Rui.ui.grid.LGridPanel({
                columnModel: anlCompleteStateColumnModel,
                dataSet: anlCompleteStateDataSet,
                width: 1000,
                height: 400,
                autoToEdit: false,
                autoWidth: true
            });

            anlCompleteStateGrid.render('anlCompleteStateGrid');

            /* 조회 */
            getAnlCompleteStateList = function() {
            	anlCompleteStateDataSet.load({
                    url: '<c:url value="/stat/anl/getAnlCompleteStateList.do"/>',
                    params :{
            		    anlChrgId : anlChrgId.getValue(),
            		    fromCmplDt : fromCmplDt.getValue(),
            		    toCmplDt : toCmplDt.getValue()
                    }
                });
            };

            anlCompleteStateDataSet.on('load', function(e) {
   	    		$("#cnt_text").html('총 ' + anlCompleteStateDataSet.getCount() + '건');
   	    	// 목록 페이징
   	    		paging(anlCompleteStateDataSet,"anlCompleteStateGrid");

   	      	});

            /* 분석의뢰 리스트 엑셀 다운로드 */
        	downloadAnlCompleteStateListExcel = function() {
        		// 엑셀 다운로드시 전체 다운로드를 위해 추가
        		anlCompleteStateDataSet.clearFilter();

        		 var excelColumnModel = new Rui.ui.grid.LColumnModel({
                     gridView: anlCompleteStateColumnModel,
                     columns: [
                    	   { field: 'acpcStNm',			label: '상태',		sortable: false,	align:'center',	width: 80 }
                         , { field: 'acpcNo',			label: '접수번호',		sortable: false,	align:'center',	width: 80 }
                         , { field: 'busiDeptNm',		label: '사업부',		sortable: false,	align:'center',	width: 150 }
                         , { field: 'rqprDeptNm',		label: '팀(PJT)',	sortable: false,	align:'center',	width: 150 }
                         , { field: 'rgstNm',			label: '의뢰자',		sortable: false,	align:'center',	width: 70 }
     					 , { field: 'anlChrgNm',			label: '분석담당자',	sortable: false, 	align:'center',	width: 80 }
     					 , { field: 'anlUgyYnNm',		label: '긴급여부',		sortable: false, 	align:'center',	width: 80 }
     					 , { field: 'anlScnNm',			label: '분석구분',		sortable: false, 	align:'center',	width: 80 }
     					 , { field: 'anlNm',				label: '분석명',		sortable: false, 	align:'left',	width: 370 }
                         , { field: 'smpoCnt',			label: '시료 수',		sortable: false, 	align:'center',	width: 60,  renderer : 'number'}
                         , { field: 'exprSmpoCnt',		label: '실험 수',		sortable: false,  	align:'center',	width: 60 }
     					 , { field: 'exprExp',			label: '분석 수가',		sortable: false, 	align:'center',	width: 80,
     						renderer: Rui.util.LRenderer.moneyRenderer() }
     					 , { field: 'acpcDt',			label: '접수일',		sortable: false, 	align:'center',	width: 80 }
     					 , { field: 'cmplDt',			label: '분석 완료일',	sortable: false, 	align:'center',	width: 80 }
     					 , { field: 'cmplWkDdCnt',		label: '완료기간',		sortable: false, 	align:'center',	width: 80 }
     					 , { field: 'cmplParrDt',		label: '완료 예정일',	sortable: false, 	align:'center',	width: 80 }
     					 , { field: 'complObservanceYn',	label: '결과통보 준수',	sortable: false, 	align:'center',	width: 80 }
                         ]
                 });

        		 //anlCompleteStateGrid.saveExcel('export.xls',{columnModel:excelColumnModel});
        		 var excelColumnModel = columnModel.createExcelColumnModel(false);
                duplicateExcelGrid(excelColumnModel);
nG.saveExcel(encodeURIComponent('분석완료 통계_') + new Date().format('%Y%m%d') + '.xls');
        		// 목록 페이징
        		 paging(anlCompleteStateDataSet,"anlCompleteStateGrid");
            };

            getAnlCompleteStateList();

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
   				<h2>분석완료</h2>
   			</div>

	   		<div class="sub-content">
	   			<div class="search">
			   		<div class="search-content">
		   				<table>
		   					<colgroup>
		   						<col style="width:120px;"/>
		   						<col style="width:160px;"/>
		   						<col style="width:100px;"/>
		   						<col style=""/>
		   						<col style=""/>
		   					</colgroup>
		   					<tbody>
		   						<tr>
		   							<th align="right">담당자</th>
		    						<td>
		                                <div id="anlChrgId"></div>
		    						</td>
		   							<th align="right">분석 완료일</th>
		    						<td>
		   								<input type="text" id="fromCmplDt"/> <em class="date_txt"> ~ </em>
		   								<input type="text" id="toCmplDt"/>
		    						</td>
		   							<td class="txt-right">
		   								<a style="cursor: pointer;" onclick="getAnlCompleteStateList();" class="btnL">검색</a>
		   							</td>
		   						</tr>
		   					</tbody>
		   				</table>
		   			</div>
   				</div>

   				<div class="titArea">
   					<span class="Ltotal" id="cnt_text">총  0건 </span>
   					<div class="LblockButton">
   						<button type="button" class="btn"  id="excelBtn" name="excelBtn" onclick="downloadAnlCompleteStateListExcel()">Excel</button>
   					</div>
   				</div>

   				<div id="anlCompleteStateGrid"></div>

   			</div><!-- //sub-content -->
   		</div><!-- //contents -->
		</form>
    </body>
</html>