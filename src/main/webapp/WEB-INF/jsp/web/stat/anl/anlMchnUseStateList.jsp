<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>			
<%@ page import="java.text.*,
				 java.util.*,
				 devonframe.util.NullUtil,
				 devonframe.util.DateUtil"%>

<%--
/*
 *************************************************************************
 * $Id		: anlMchnUseStateList.jsp
 * @desc    : 분석 기기사용 통계 리스트
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

<style>
 .bgcolor-gray {background-color: #999999}
 .bgcolor-white {background-color: #FFFFFF}
</style>

	<script type="text/javascript">
        
		Rui.onReady(function() {
            /*******************
             * 변수 및 객체 선언
             *******************/
            
            var fromExprStrtDt = new Rui.ui.form.LDateBox({
				applyTo: 'fromExprStrtDt',
				mask: '9999-99-99',
				displayValue: '%Y-%m-%d',
				defaultValue: '<c:out value="${inputData.fromExprStrtDt}"/>',
				editable: false,
				width: 100,
				dateType: 'string'
			});

            fromExprStrtDt.on('blur', function(){
				if( ! Rui.util.LDate.isDate( Rui.util.LString.toDate(nwinsReplaceAll(fromExprStrtDt.getValue(),"-","")) ) )  {
					alert('날자형식이 올바르지 않습니다.!!');
					fromExprStrtDt.setValue(new Date());
				}
				
				if( fromExprStrtDt.getValue() > toExprStrtDt.getValue() ) {
					alert('시작일이 종료일보다 클 수 없습니다.!!');
					fromExprStrtDt.setValue(toExprStrtDt.getValue());
				}
			});

            var toExprStrtDt = new Rui.ui.form.LDateBox({
				applyTo: 'toExprStrtDt',
				mask: '9999-99-99',
				displayValue: '%Y-%m-%d',
				defaultValue: '<c:out value="${inputData.toExprStrtDt}"/>',
				editable: false,
				width: 100,
				dateType: 'string'
			});
			 
			toExprStrtDt.on('blur', function(){
				if( ! Rui.util.LDate.isDate( Rui.util.LString.toDate(nwinsReplaceAll(toExprStrtDt.getValue(),"-","")) ) )  {
					alert('날자형식이 올바르지 않습니다.!!');
					toExprStrtDt.setValue(new Date());
				}
				
				if( fromExprStrtDt.getValue() > toExprStrtDt.getValue() ) {
					alert('시작일이 종료일보다 클 수 없습니다.!!');
					fromExprStrtDt.setValue(toExprStrtDt.getValue());
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
            var anlMchnUseStatDataSet = new Rui.data.LJsonDataSet({
                id: 'anlMchnUseStatDataSet',
                remainRemoved: true,
                lazyLoad: true,
                fields: [
					  { id: 'acpcNo' }
					, { id: 'busiDeptNm' }
					, { id: 'rqprDeptNm' }
					, { id: 'rgstNm' }
					, { id: 'anlChrgNm' }
					, { id: 'cmplDt' }
					, { id: 'exprLv1Nm' }
					, { id: 'exprLv2Nm' }
					, { id: 'exprLv3Nm' }
					, { id: 'exprLv4Nm' }
					, { id: 'mchnInfoNm' }
					, { id: 'smpoQty' }
					, { id: 'exprQty' }
					, { id: 'exprTim' }
					, { id: 'exprExp' }
					, { id: 'exprStrtDt' }
					, { id: 'exprFnhDt' }
                ]
            });

            var anlMchnUseStatColumnModel = new Rui.ui.grid.LColumnModel({
                columns: [
                      { field: 'acpcNo',		label: '접수번호',		sortable: false,	align:'center',	width: 80 }
                    , { field: 'busiDeptNm',	label: '사업부',		sortable: false,	align:'center',	width: 150 }
                    , { field: 'rqprDeptNm',	label: '팀(PJT)',	sortable: false,	align:'center',	width: 150 }
                    , { field: 'rgstNm',		label: '의뢰자',		sortable: false,	align:'center',	width: 70 }
					, { field: 'anlChrgNm',		label: '분석담당자',	sortable: false, 	align:'center',	width: 80 }
					, { field: 'cmplDt',		label: '분석 완료일',	sortable: false, 	align:'center',	width: 80 }
					, { field: 'exprLv1Nm',		label: '대분류',		sortable: false, 	align:'center',	width: 100 }
					, { field: 'exprLv2Nm',		label: '중분류',		sortable: false, 	align:'center',	width: 100 }
					, { field: 'exprLv3Nm',		label: '소분류',		sortable: false, 	align:'center',	width: 100 }
                    , { field: 'exprLv4Nm',		label: '세분류',		sortable: false, 	align:'center',	width: 100 }
                    , { field: 'mchnInfoNm',	label: '분석기기',		sortable: false,  	align:'center',	width: 250 }
					, { field: 'smpoQty',		label: '실험 수',		sortable: false, 	align:'center',	width: 80 }
					, { field: 'exprQty',		label: '가동 횟수',		sortable: false, 	align:'center',	width: 80 }
					, { field: 'exprTim',		label: '실험시간',		sortable: false, 	align:'center',	width: 80 }
					, { field: 'exprStrtDt',	label: '실험 시작일',	sortable: false, 	align:'center',	width: 80 }
					, { field: 'exprFnhDt',		label: '실험 종료일',	sortable: false, 	align:'center',	width: 80 }
					, { field: 'exprExp',		label: '실험 비용',		sortable: false, 	align:'center',	width: 80,
						renderer: Rui.util.LRenderer.moneyRenderer() }
                ]
            });

            var anlMchnUseStatGrid = new Rui.ui.grid.LGridPanel({
                columnModel: anlMchnUseStatColumnModel,
                dataSet: anlMchnUseStatDataSet,
                width: 1000,
                height: 580,
                autoToEdit: false,
                autoWidth: true
            });
            
            anlMchnUseStatGrid.render('anlMchnUseStatGrid');
            
            /* 조회 */
            getAnlMchnUseStateList = function() {
            	anlMchnUseStatDataSet.load({
                    url: '<c:url value="/stat/anl/getAnlMchnUseStateList.do"/>',
                    params :{
            		    anlChrgId : anlChrgId.getValue(),
            		    fromExprStrtDt : fromExprStrtDt.getValue(), 
            		    toExprStrtDt : toExprStrtDt.getValue()
                    }
                });
            };
            
            anlMchnUseStatDataSet.on('load', function(e) {
   	    		$("#cnt_text").html('총 ' + anlMchnUseStatDataSet.getCount() + '건');
   	      	});
            
            /* 분석의뢰 리스트 엑셀 다운로드 */
        	downloadAnlMchnUseStateListExcel = function() {
                anlMchnUseStatGrid.saveExcel(encodeURIComponent('분석 기기사용 통계_') + new Date().format('%Y%m%d') + '.xls');
            };
            
            getAnlMchnUseStateList();
			
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
   				<h2>분석 기기사용</h2>
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
		   							<th align="right">실험일</th>
		    						<td>
		   								<input type="text" id="fromExprStrtDt"/><em class="gab"> ~ </em>
		   								<input type="text" id="toExprStrtDt"/>
		    						</td>
		   							<td class="txt-right">
		   								<a style="cursor: pointer;" onclick="getAnlMchnUseStateList();" class="btnL">검색</a>
		   							</td>
		   						</tr>
		   					</tbody>
		   				</table>
		   			</div>
		   		</div>
   				
   				<div class="titArea">
   					<span class="Ltotal" id="cnt_text">총  0건 </span>
   					<div class="LblockButton">
   						<button type="button" class="btn"  id="excelBtn" name="excelBtn" onclick="downloadAnlMchnUseStateListExcel()">Excel</button>
   					</div>
   				</div>

   				<div id="anlMchnUseStatGrid"></div>
   				
   			</div><!-- //sub-content -->
   		</div><!-- //contents -->
		</form>
    </body>
</html>