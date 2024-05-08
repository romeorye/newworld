<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*,
				 java.util.*,
				 devonframe.util.NullUtil,
				 devonframe.util.DateUtil"%>

<%--
/*
 *************************************************************************
 * $Id		: anlExprExpSimulationPopup.jsp
 * @desc    : 실험수가 Simulation 팝업
 *------------------------------------------------------------------------
 * VER	DATE		AUTHOR		DESCRIPTION
 * ---	-----------	----------	-----------------------------------------
 * 1.0  2017.08.25  오명철		최초생성
 * ---	-----------	----------	-----------------------------------------
 * IRIS UPGRADE 1차 프로젝트
 *************************************************************************
 */
--%>
				 
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<%@ include file="/WEB-INF/jsp/include/rui_header.jspf"%>

<title><%=documentTitle%></title>

<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/grid/LEditButtonColumn.js"></script>
<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/grid/LTotalSummary.js"></script>
<link rel="stylesheet" type="text/css" href="<%=ruiPathPlugins%>/ui/grid/LTotalSummary.css"/>

<script type="text/javascript" src="<%=ruiPathPlugins%>/tree/rui_tree.js"></script>
<link rel="stylesheet" type="text/css" href="<%=ruiPathPlugins%>/tree/rui_tree.css"/>

<style>
 .bgcolor-gray {background-color: #999999}
 .bgcolor-white {background-color: #FFFFFF}
</style>


    <style type="text/css" >
        #bd {
            height: 300px;
        }
        h3 {
            margin: 0px !important;
            padding-left: 10px !important;
        }
        #contentWrapper, #fieldWrapper, #buttonWrapper{
            float: left;
        }
        #LblockFields {
            padding: 10px;
        }
        #fieldWrapper {
            margin-left: 20px;
            width: 600px;
        }
        #buttonWrapper {
            margin-left: 20px;
            width: 300px;
        }
        #LblockFields div {
            padding: 5px 0;
        }
        #LblockFields input[readonly]{
            background-color: #ddd;
        }

    </style>
	<script type="text/javascript">
        
		Rui.onReady(function() {
            /*******************
             * 변수 및 객체 선언
             *******************/
             
            var dm = new Rui.data.LDataSetManager();
            
            dm.on('load', function(e) {
            });
            
            dm.on('success', function(e) {
            });
            
            var numberBox = new Rui.ui.form.LNumberBox({
                emptyValue: '',
                minValue: 0,
                maxValue: 99999
            });
            
            numberBox.on('blur', function(e) {
                setExprExp();
            });
            
            var expCrtnScnCd = new Rui.ui.form.LCombo({
                name: 'expCrtnScnCd',
                autoMapping: true,
                emptyText: '선택',
                defaultValue: '',
                emptyValue: '',
                width: 80,
                items: [
                    { value: '1', text: '실험수'},
                    { value: '2', text: '시간'}
                ]
            });
            
            var vm1 = new Rui.validate.LValidatorManager({
                validators:[
                { id: 'smpoQty',			validExp: '실험수:true:number' }
                ]
            });
            
            var vm2 = new Rui.validate.LValidatorManager({
                validators:[
                { id: 'exprTim',			validExp: '실험시간:true:number' }
                ]
            });
            
            var anlExprMstTreeDataSet = new Rui.data.LJsonDataSet({
                id: 'anlExprMstTreeDataSet',
                remainRemoved: true,
                lazyLoad: true,
                focusFirstRow: -1,
                fields: [
                      { id: 'exprCd', type: 'number' }
                    , { id: 'exprNm' }
                    , { id: 'supiExprCd', type: 'number' }
                    , { id: 'exprCdL' }
                    , { id: 'sopNo' }
                    , { id: 'utmExp', type: 'number' }
                    , { id: 'expCrtnScnCd' }
                    , { id: 'utmSmpoQty', type: 'number' }
                    , { id: 'utmExprTim', type: 'number' }
                    , { id: 'dspNo', type: 'number' }
                    , { id: 'path' }
                    , { id: 'sort' }
                ]
            });

            var anlExprMstTreeView = new Rui.ui.tree.LTreeView({
                id: 'anlExprMstTreeView',
                dataSet: anlExprMstTreeDataSet,
                fields: {
                    rootValue: 0,
                    parentId: 'supiExprCd',
                    id: 'exprCd',
                    label: 'exprNm',
                    order: 'sort'
                },
                defaultOpenDepth: -1,
                width: 250,
                height: 300,
                useAnimation: true
            });
            
            anlExprMstTreeView.on('labelClick', function(e) {
            	var treeRecord = e.node.getRecord();
            	
            	if(treeRecord.get('exprCdL') < 4) {
            		return;
            	}

				if(anlRqprExprDataSet.findRow('exprCd', treeRecord.get('exprCd')) > -1) {
					return ;
				}

            	var row = anlRqprExprDataSet.newRecord();
            	var record = anlRqprExprDataSet.getAt(row);
            	
            	record.set('exprCd', treeRecord.get('exprCd'));
            	record.set('exprNm', treeRecord.get('path'));
            	record.set('expCrtnScnCd', treeRecord.get('expCrtnScnCd'));
            	record.set('utmSmpoQty', treeRecord.get('utmSmpoQty'));
            	record.set('utmExprTim', treeRecord.get('utmExprTim'));
            	record.set('utmExp', treeRecord.get('utmExp'));
            	record.set('smpoQty', null);
            	record.set('exprTim', null);
            	record.set('exprExp', null);
            });
            
            anlExprMstTreeView.render('anlExprMstTreeView');
            
            setExprExp = function() {
            	var row = anlRqprExprDataSet.getRow();
            	var record = anlRqprExprDataSet.getAt(row);
            	
            	if(record.get('expCrtnScnCd') == '1') {
            		var smpoQty = record.get('smpoQty');
            		
            		if(Rui.isNumber(smpoQty)) {
            			var exprExp = record.get('utmExp') * smpoQty;
            			
            			record.set('exprExp', exprExp);
            		} else {
            			record.set('exprExp', null);
            		}
            	} else {
            		var exprTim = record.get('exprTim') / record.get('utmExprTim');
            		
            		if(exprTim > 0) {
            			var exprExp = record.get('utmExp') * exprTim;
            			
            			record.set('exprExp', exprExp);
            		} else {
            			record.set('exprExp', null);
            		}
            	}
            };
			
            var anlRqprExprDataSet = new Rui.data.LJsonDataSet({
                id: 'anlRqprExprDataSet',
                remainRemoved: true,
                lazyLoad: true,
                fields: [
                	  { id: 'exprCd' }
					, { id: 'exprNm' }
                    , { id: 'expCrtnScnCd' }
                    , { id: 'utmSmpoQty', type: 'number' }
                    , { id: 'utmExprTim', type: 'number' }
                    , { id: 'utmExp', type: 'number' }
					, { id: 'smpoQty', type: 'number' }
					, { id: 'exprTim', type: 'number' }
					, { id: 'exprExp', type: 'number' }
                ]
            });

            var anlRqprExprColumnModel = new Rui.ui.grid.LColumnModel({
                columns: [
                	  new Rui.ui.grid.LSelectionColumn()
                    , { field: 'exprNm',		label: '실험명',		sortable: false,	editable: false,	editor: null,			align:'left',	width: 290 }
                    , { field: 'expCrtnScnCd',	label: '비용구분',		sortable: false,	editable: false, 	editor: expCrtnScnCd,	align:'center',	width: 60 }
                    , { field: 'smpoQty',		label: '실험수',		sortable: false,	editable: true,		editor: numberBox,		align:'center',	width: 50,
                    	renderer: function(value, p, record, row, col) {
                            p.editable = record.get('expCrtnScnCd') == '1' ? true : false;
                            return value;
                    } }
                    , { field: 'exprTim',		label: '실험시간',		sortable: false,	editable: true,		editor: numberBox,		align:'center',	width: 60,
                    	renderer: function(value, p, record, row, col) {
                            p.editable = record.get('expCrtnScnCd') == '2' ? true : false;
                            return value;
                    } }
                    , { field: 'exprExp',		label: '실험수가',		sortable: false,	editable: false,	editor: null,			align:'right',	width: 90,
                    	renderer: function(val, p, record, row, col) {
                    		return Rui.isNumber(val) ? Rui.util.LNumber.toMoney(val, '') + '원' : val;
                    } }
                ]
            });

            var anlRqprExprSumColumns = ['smpoQty', 'exprTim', 'exprExp'];
            var anlRqprExprSummary = new Rui.ui.grid.LTotalSummary();

            anlRqprExprSummary.on('renderTotalCell', anlRqprExprSummary.renderer({
                label: {
                    id : 'exprNm',
                    text : 'Total',
                }, 
                columns: {
                	smpoQty : { type: 'sum', renderer: function(val, p, record, row, col) {
                    		return Rui.isNumber(val) ? Rui.util.LNumber.toMoney(val, '') : val;
                    } },
                	exprTim : { type: 'sum', renderer: function(val, p, record, row, col) {
                    		return Rui.isNumber(val) ? Rui.util.LNumber.toMoney(val, '') : val;
                    } },
                	exprExp : { type: 'sum', renderer: function(val, p, record, row, col) {
                    		return Rui.isNumber(val) ? Rui.util.LNumber.toMoney(val, '') + '원' : val;
                    } }
                }
            }));

            var anlRqprExprGrid = new Rui.ui.grid.LGridPanel({
                columnModel: anlRqprExprColumnModel,
                dataSet: anlRqprExprDataSet,
                viewConfig: {
                    plugins: [ anlRqprExprSummary ]
                },
                width: 570,
                height: 300,
                autoToEdit: true,
                autoWidth: true
            });
            
            anlRqprExprGrid.render('anlRqprExprGrid');
            
            deleteAnlRqprExpr = function() {
                if(anlRqprExprDataSet.getMarkedCount() > 0) {
                	anlRqprExprDataSet.removeMarkedRows();
                } else {
                	alert('삭제 대상을 선택해주세요.');
                }
            }
            
            anlExprMstTreeDataSet.load({
                url: '<c:url value="/anl/getAnlExprMstList.do"/>',
                params :{
                	isMng : 0
                }
            });
			
        });

	</script>
    </head>
    <body>
	<form name="aform" id="aform" method="post" onSubmit="return false;">
		
   		<div class="LblockMainBody">

   			<div class="sub-content" style="padding:0;">
   			
	   			
   				<div class="titArea mt0">
   					<div class="LblockButton">
   						<button type="button" class="btn"  id="deleteBtn" name="deleteBtn" onclick="deleteAnlRqprExpr()">삭제</button>
   						<button type="button" class="btn"  id="closeBtn" name="closeBtn" onclick="parent.utmExpSimulationDialog.cancel()">닫기</button>
   					</div>
   				</div>
   				
			    <div id="bd">
			        <div class="LblockMarkupCode">
			            <div id="contentWrapper">
			                <div id="anlExprMstTreeView"></div>
			            </div>
			            <div id="fieldWrapper">
			                <div id="anlRqprExprGrid"></div>
			            </div>
			        </div>
			    </div>
   				
   			</div><!-- //sub-content -->
   		</div><!-- //contents -->
		</form>
    </body>
</html>