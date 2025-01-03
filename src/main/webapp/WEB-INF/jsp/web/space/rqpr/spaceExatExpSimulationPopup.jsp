<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*,
				 java.util.*,
				 devonframe.util.NullUtil,
				 devonframe.util.DateUtil"%>

<%--
/*
 *************************************************************************
 * $Id		: spaceExatExpSimulationPopup.jsp
 * @desc    : 평가수가 Simulation 팝업
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

                setExatExp();
            });

            var expCrtnScnCd = new Rui.ui.form.LCombo({
                name: 'expCrtnScnCd',
                autoMapping: true,
                emptyText: '(선택)',
                defaultValue: '',
                emptyValue: '',
                width: 80,
                items: [
                    { value: '1', text: '일'}
                ]
            });

            var spaceExatMstTreeDataSet = new Rui.data.LJsonDataSet({
                id: 'spaceExatMstTreeDataSet',
                remainRemoved: true,
                lazyLoad: true,
                focusFirstRow: -1,
                fields: [
                      { id: 'exatCd', type: 'number' }
                    , { id: 'exatNm' }
                    , { id: 'supiExatCd', type: 'number' }
                    , { id: 'exatCdL' }
                    , { id: 'exatMtdNo' }
                    , { id: 'utmExp', type: 'number' }
                    , { id: 'expCrtnScnCd' }
                    , { id: 'utmSmpoQty', type: 'number' }
                    , { id: 'utmExatTim', type: 'number' }
                    , { id: 'dspNo', type: 'number' }
                    , { id: 'path' }
                    , { id: 'sort' }
                ]
            });

            var spaceExatMstTreeView = new Rui.ui.tree.LTreeView({
                id: 'spaceExatMstTreeView',
                dataSet: spaceExatMstTreeDataSet,
                fields: {
                    rootValue: 0,
                    parentId: 'supiExatCd',
                    id: 'exatCd',
                    label: 'exatNm',
                    order: 'sort'
                },
                defaultOpenDepth: -1,
                width: 250,
                height: 300,
                useAnimation: true
            });

            spaceExatMstTreeView.on('labelClick', function(e) {
            	var treeRecord = e.node.getRecord();

            	if(treeRecord.get('exatCdL') < 2) {
            		return;
            	}

				if(spaceRqprExatDataSet.findRow('exatCd', treeRecord.get('exatCd')) > -1) {
					return ;
				}

            	var row = spaceRqprExatDataSet.newRecord();
            	var record = spaceRqprExatDataSet.getAt(row);

            	record.set('exatCd', treeRecord.get('exatCd'));
            	record.set('exatNm', treeRecord.get('path'));
            	record.set('expCrtnScnCd', treeRecord.get('expCrtnScnCd'));
            	record.set('utmSmpoQty', treeRecord.get('utmSmpoQty'));
            	record.set('utmExatTim', treeRecord.get('utmExatTim'));
            	record.set('utmExp', treeRecord.get('utmExp'));
            	record.set('smpoQty', null);
            	record.set('exatTim', null);
            	record.set('exatExp', null);
            });

            spaceExatMstTreeView.render('spaceExatMstTreeView');

            setExatExp = function() {
            	var row = spaceRqprExatDataSet.getRow();
            	var record = spaceRqprExatDataSet.getAt(row);


            		var exatTim = record.get('exatTim') / record.get('utmExatTim');

            		if(exatTim > 0) {
            			var exatExp = record.get('utmExp') * exatTim;

            			record.set('exatExp', exatExp);
            		} else {
            			record.set('exatExp', null);
            		}

            };

            var spaceRqprExatDataSet = new Rui.data.LJsonDataSet({
                id: 'spaceRqprExatDataSet',
                remainRemoved: true,
                lazyLoad: true,
                fields: [
                	  { id: 'exatCd' }
					, { id: 'exatNm' }
                    , { id: 'expCrtnScnCd' }
                    , { id: 'utmSmpoQty', type: 'number' }
                    , { id: 'utmExatTim', type: 'number' }
                    , { id: 'utmExp', type: 'number' }
					, { id: 'smpoQty', type: 'number' }
					, { id: 'exatTim', type: 'number' }
					, { id: 'exatExp', type: 'number' }
                ]
            });

            var spaceRqprExatColumnModel = new Rui.ui.grid.LColumnModel({
                columns: [
                	  new Rui.ui.grid.LSelectionColumn()
                    , { field: 'exatNm',		label: '평가명',		sortable: false,	editable: false,	editor: null,			align:'left',	width: 300 }
                    , { field: 'expCrtnScnCd',	label: '비용구분',		sortable: false,	editable: false, 	editor: expCrtnScnCd,	align:'center',	width: 85 }

                    , { field: 'exatTim',		label: '평가일수',		sortable: false,	editable: true,		editor: numberBox,		align:'center',	width: 115,
                    	renderer: function(value, p, record, row, col) {
                            p.editable = record.get('expCrtnScnCd') == '2' ? true : true;
                            return value;
                    } }
                    , { field: 'exatExp',		label: '평가수가',		sortable: false,	editable: false,	editor: null,			align:'right',	width: 115,
                    	renderer: function(val, p, record, row, col) {
                    		return Rui.isNumber(val) ? Rui.util.LNumber.toMoney(val, '') + '원' : val;
                    } }
                ]
            });

            var spaceRqprExatSumColumns = ['smpoQty', 'exatTim', 'exatExp'];
            var spaceRqprExatSummary = new Rui.ui.grid.LTotalSummary();

            spaceRqprExatSummary.on('renderTotalCell', spaceRqprExatSummary.renderer({
                label: {
                    id : 'exatNm',
                    text : 'Total',
                },
                columns: {
                	smpoQty : { type: 'sum', renderer: function(val, p, record, row, col) {
                    		return Rui.isNumber(val) ? Rui.util.LNumber.toMoney(val, '') : val;
                    } },
                	exatTim : { type: 'sum', renderer: function(val, p, record, row, col) {
                    		return Rui.isNumber(val) ? Rui.util.LNumber.toMoney(val, '') : val;
                    } },
                	exatExp : { type: 'sum', renderer: function(val, p, record, row, col) {
                    		return Rui.isNumber(val) ? Rui.util.LNumber.toMoney(val, '') + '원' : val;
                    } }
                }
            }));

            var spaceRqprExatGrid = new Rui.ui.grid.LGridPanel({
                columnModel: spaceRqprExatColumnModel,
                dataSet: spaceRqprExatDataSet,
                viewConfig: {
                    plugins: [ spaceRqprExatSummary ]
                },
                width: 570,
                height: 300,
                autoToEdit: true,
                autoWidth: true
            });

            spaceRqprExatGrid.render('spaceRqprExatGrid');

            deleteSpaceRqprExat = function() {
                if(spaceRqprExatDataSet.getMarkedCount() > 0) {
                	spaceRqprExatDataSet.removeMarkedRows();
                } else {
                	alert('삭제 대상을 선택해주세요.');
                }
            }

            spaceExatMstTreeDataSet.load({
                url: '<c:url value="/space/getSpaceExatMstList.do"/>',
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

   			<div class="sub-content" style="padding:0; margin-top:-25px;">

   				<div class="titArea">
   					<div class="LblockButton">
   						<button type="button" class="btn"  id="deleteBtn" name="deleteBtn" onclick="deleteSpaceRqprExat()">삭제</button>
   						<button type="button" class="btn"  id="closeBtn" name="closeBtn" onclick="parent.utmExpSimulationDialog.cancel()">닫기</button>
   					</div>
   				</div>

			    <div id="bd" class="pop_tree_grid">
			        <div class="LblockMarkupCode">
			            <div id="contentWrapper">
			                <div id="spaceExatMstTreeView"></div>
			            </div>
			            <div id="fieldWrapper">
			                <div id="spaceRqprExatGrid"></div>
			            </div>
			        </div>
			    </div>

   			</div><!-- //sub-content -->
   		</div><!-- //contents -->
		</form>
    </body>
</html>