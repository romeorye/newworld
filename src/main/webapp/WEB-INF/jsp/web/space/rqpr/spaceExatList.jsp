<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*,
				 java.util.*,
				 devonframe.util.NullUtil,
				 devonframe.util.DateUtil"%>

<%--
/*
 *************************************************************************
 * $Id		: spaceExatList.jsp
 * @desc    : 공간평가 시험정보 리스트 화면
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

<script type="text/javascript" src="<%=ruiPathPlugins%>/tree/rui_tree.js"></script>
<link rel="stylesheet" type="text/css" href="<%=ruiPathPlugins%>/tree/rui_tree.css"/>
<script type="text/javascript" src="<%=ruiPathPlugins%>/data/LDataSetView.js"></script>

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
            width: 810px;
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
            var selectTreeRow = 0;
            var selectExatCd = -1;
            var dm = new Rui.data.LDataSetManager();
            
            dm.on('load', function(e) {
            });
            
            dm.on('success', function(e) {
                var data = spaceExatMstTreeDataSet.getReadData(e);
                
                alert(data.records[0].resultMsg);
                
                if(data.records[0].resultYn == 'Y') {
                	if(data.records[0].cmd == 'saveSpaceExatMst') {
                		getSpaceExatMstList();
                	} else if(data.records[0].cmd == 'saveSpaceExatDtl') {
                		getSpaceExatDtlList(selectExatCd);
                	}
                }
            });
            
            var textBox = new Rui.ui.form.LTextBox({
                emptyValue: ''
            });
            
            var numberBox = new Rui.ui.form.LNumberBox({
                emptyValue: '',
                minValue: 0,
                maxValue: 9999999
            });
            
            var expCrtnScnCd = new Rui.ui.form.LCombo({
                name: 'expCrtnScnCd',
                autoMapping: true,
                emptyText: '선택',
                defaultValue: '',
                emptyValue: '',
                width: 80,
                items: [
                    { value: '1', text: '일'}
                ]
            });
            
            var useYn = new Rui.ui.form.LCombo({
                name: 'useYn',
                autoMapping: true,
                useEmptyText: false,
                defaultValue: 'Y',
                width: 60,
                items: [
                    { value: 'Y', text: '삭제'},
                    { value: 'N', text: '미삭제'}
                ]
            });
            
            var vm1 = new Rui.validate.LValidatorManager({
                validators:[
                { id: 'exatNm',			validExp: '실험명:true:maxByteLength=100' },
                { id: 'dspNo',			validExp: '순서:true:number' }
                ]
            });
            
            var vm2 = new Rui.validate.LValidatorManager({
                validators:[
                { id: 'exatNm',			validExp: '실험명:true:maxByteLength=100' },
                { id: 'expCrtnScnCd',	validExp: '비용구분:true' },
                { id: 'utmExp',			validExp: '실험수가:true:number' },
                { id: 'dspNo',			validExp: '순서:true:number' }
                ]
            });
            
            var spaceExatMstTreeDataSet = new Rui.data.LJsonDataSet({
                id: 'spaceExatMstTreeDataSet',
                remainRemoved: true,
                lazyLoad: true,
                focusFirstRow: -1,
                fields: [
                      { id: 'exatCd'}
                    , { id: 'exatNm' }
                    , { id: 'supiExatNm' }
                    , { id: 'supiExatCd', type: 'number' }
                    , { id: 'exatCdL', type: 'number' }
                    , { id: 'exatMtdNo' }
                    , { id: 'utmExp', type: 'number' }
                    , { id: 'expCrtnScnCd' }
                    , { id: 'utmSmpoQty', type: 'number', defaultValue: 1 }
                    , { id: 'utmExatTim', type: 'number', defaultValue: 0.5 }
                    , { id: 'dspNo', type: 'number' }
                    , { id: 'delYn', defaultValue: 'N' }
                    , { id: 'path' }
                    , { id: 'sort' }
                ]
            });
            
            spaceExatMstTreeDataSet.on('canRowPosChange', function(e){
            	var vm = spaceExatMstGridDataSetView.getNameValue(spaceExatMstGridDataSetView.getRow(), 'exatCdL') == 2 ? vm2 : vm1;
            	
            	if (vm.validateDataSet(spaceExatMstGridDataSetView, spaceExatMstGridDataSetView.getRow()) == false) {
                    alert(Rui.getMessageManager().get('$.base.msg052') + '\n' + vm.getMessageList().join('\n'));
                    return false;
                }
            });
            
            spaceExatMstTreeDataSet.on('rowPosChanged', function (e) {
                if (e.row > -1) {
                	if(e.target.getNameValue(e.row, 'exatCdL') == 2) {
                		e.target.setRow(e.oldRow);
                	} else {
                		selectTreeRow = e.row;
                    	setSpaceExatMstDataView(e.row);
                	}
                }
            });

            spaceExatMstTreeDataSet.on('load', function () {
            	if(selectTreeRow > -1) {
                	spaceExatMstTreeDataSet.setRow(selectTreeRow);
            	}
            	
            	setSpaceExatMstDataView(selectTreeRow);
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
            
            spaceExatMstTreeView.render('spaceExatMstTreeView');

            var spaceExatMstTreeColumnModel = new Rui.ui.grid.LColumnModel({
                columns: [
                	  { field: 'path',			label: 'Path',		sortable: false,	editable: true,		editor: textBox,		align:'left',	width: 300 }
                    , { field: 'exatNm',		label: '시험명(대분류)',		sortable: false,	editable: true,		editor: textBox,		align:'left',	width: 100 }
                    , { field: 'exatNm',		label: '시험명(소분류)',		sortable: false,	editable: true,		editor: textBox,		align:'left',	width: 100 }
                    , { field: 'exatMtdNo',			label: '시험법No',	sortable: false,	editable: true, 	editor: textBox,		align:'left',	width: 100 }
                    , { field: 'expCrtnScnCd',	label: '비용구분',		sortable: false,	editable: true, 	editor: expCrtnScnCd,	align:'center',	width: 80 }
                    , { field: 'utmSmpoQty',	label: '단위실험수량',	sortable: false,	editable: false,	editor: numberBox,		align:'center',	width: 80 }
                    , { field: 'utmExatTim',	label: '시험일수',	sortable: false,	editable: false,	editor: numberBox,		align:'center',	width: 80 }
                    , { field: 'utmExp',		label: '실험수가',		sortable: false,	editable: true,		editor: numberBox,		align:'right',	width: 80,
                    	renderer: function(val, p, record, row, col) {
                    		return Rui.isNumber(val) ? Rui.util.LNumber.toMoney(val, '') + '원' : val;
                    } }
                    , { field: 'delYn',			label: '삭제여부',		sortable: false,	editable: true,		editor: useYn,			align:'center',	width: 60 }
                ]
            });

            var spaceExatMstTreeGrid = new Rui.ui.grid.LGridPanel({
                columnModel: spaceExatMstTreeColumnModel,
                dataSet: spaceExatMstTreeDataSet,
                visible: false,
                autoWidth: true
            });
            
            spaceExatMstTreeGrid.render('spaceExatMstTreeGrid');
            
            var spaceExatMstGridDataSetView = new Rui.data.LDataSetView({
                sourceDataSet: spaceExatMstTreeDataSet
            });
            
            spaceExatMstGridDataSetView.on('canRowPosChange', function(e){
            	var vm = spaceExatMstGridDataSetView.getNameValue(spaceExatMstGridDataSetView.getRow(), 'exatCdL') == 2 ? vm2 : vm1;
            	
            	if (vm.validateDataSet(spaceExatMstGridDataSetView, spaceExatMstGridDataSetView.getRow()) == false) {
                    alert(Rui.getMessageManager().get('$.base.msg052') + '\n' + vm.getMessageList().join('\n'));
                    return false;
                }
            });

            var spaceExatMstColumnModel = new Rui.ui.grid.LColumnModel({
                columns: [
                	  { field: 'supiExatNm',		label: '평가명(대분류)',		sortable: false,	editable: false,		editor: textBox,		align:'left',	width: 180 }
                	, { field: 'exatNm',		label: '평가명(소분류)',		sortable: false,	editable: true,		editor: textBox,		align:'left',	width: 150 }
                    , { field: 'expCrtnScnCd',	label: '비용구분',		sortable: false,	editable: false, 	editor: expCrtnScnCd,	align:'center',	width: 80 }
                    , { field: 'utmSmpoQty',	label: '단위평가수량',	sortable: false,	editable: false,	editor: numberBox,		align:'center',	width: 80 }
                    , { field: 'utmExatTim',	label: '평가일수',	sortable: false,	editable: false,	editor: numberBox,		align:'center',	width: 80 }
                    , { field: 'utmExp',		label: '평가수가',		sortable: false,	editable: true,		editor: numberBox,		align:'right',	width: 80,
                    	renderer: function(val, p, record, row, col) {
                    		return Rui.isNumber(val) ? Rui.util.LNumber.toMoney(val, '') + '원' : val;
                    } }
                    , { field: 'delYn',			label: '삭제여부',		sortable: false,	editable: true,		editor: useYn,			align:'center',	width: 80 }
                    , { field: 'exatCdL',		label: 'Tool관리',		sortable: false,	editable: false,	editor: numberBox,		align:'center',	width: 80,
                    	renderer: function(val, p, record, row, i) {
                    		return (val == 2 && Rui.isEmpty(record.get('exatCd')) == false) ? '<button type="button" class="L-grid-button" onClick="getSpaceExatDtlList(' + record.get('exatCd') + ')">관리</button>' : '';
                    } }
                ]
            });

            var spaceExatMstGrid = new Rui.ui.grid.LGridPanel({
                columnModel: spaceExatMstColumnModel,
                dataSet: spaceExatMstGridDataSetView,
                width: 810,
                height: 300,
                autoToEdit: true,
                autoWidth: true
            });
            
            spaceExatMstGrid.render('spaceExatMstGrid');
			
            var spaceExatDtlDataSet = new Rui.data.LJsonDataSet({
                id: 'spaceExatDtlDataSet',
                remainRemoved: false,
                lazyLoad: true,
                fields: [
					  { id: 'exatCd' }
					, { id: 'mchnInfoId' }
					, { id: 'toolNm' }
					, { id: 'ver' }
					, { id: 'evCtgr' }
					, { id: 'cmpnNm' }
					, { id: 'evWay' }
					, { id: 'mchnCrgrNm' }
					, { id: 'evScn' }
                ]
            });

            var spaceExatDtlColumnModel = new Rui.ui.grid.LColumnModel({
                columns: [
                	  new Rui.ui.grid.LSelectionColumn()
                    , new Rui.ui.grid.LNumberColumn()
                    , { field: 'toolNm',	label: 'TOOL명',		sortable: false,	align:'center',	width: 275 }
                    , { field: 'ver',			label: '버전',		sortable: false,	align:'center',	width: 135 }
                    , { field: 'cmpnNm',		label: '기관',		sortable: false,	align:'center',	width: 150 }
                    , { field: 'evCtgr',			label: '평가카테고리',		sortable: false,	align:'center',	width: 190 }
                    , { field: 'evWay',	label: '평가방법',		sortable: false,	align:'center',	width: 150 }
                    , { field: 'mchnCrgrNm',	label: '담당자',		sortable: false,	align:'center',	width: 100 }
                    , { field: 'evScn',	label: '구분',		sortable: false,	align:'center',	width: 118 }
                ]
            });

            var spaceExatDtlGrid = new Rui.ui.grid.LGridPanel({
                columnModel: spaceExatDtlColumnModel,
                dataSet: spaceExatDtlDataSet,
                width: 400,
                height: 340,
                autoToEdit: false,
                autoWidth: true
            });
            
            spaceExatDtlGrid.render('spaceExatDtlGrid');
            
            setSpaceExatMstDataView = function(row) {
                var parentId;
                
                if (row > -1) {
                    parentId = spaceExatMstTreeDataSet.getAt(row).get('exatCd');
                } else {
                    parentId = null;
                    spaceExatMstTreeDataSet.setRow(-1);
                }

                spaceExatMstGridDataSetView.loadView(function(recordId, record){
                    if (record.get('exatCd') != parentId && record.get('supiExatCd') == parentId)
                        return true;
                    else
                        return false;
                });
            };
            
            getSpaceExatMstList = function() {
                spaceExatMstTreeDataSet.load({
                    url: '<c:url value="/space/getSpaceExatMstList.do"/>',
                    params :{
                    	isMng : 1
                    }
                });
            };
            
            getSpaceExatDtlList = function(exatCd) {
            	selectExatCd = exatCd;
            	
            	spaceExatDtlDataSet.load({
                    url: '<c:url value="/space/getSpaceExatDtlList.do"/>',
                    params :{
                    	exatCd : exatCd
                    }
                });
            };

    	    // 공간평가Tool 검색 팝업 시작
			mchnDialog = new Rui.ui.LFrameDialog({
		        id: 'mchnDialog',
		        title: '분석기기 조회',
		        width:  900,
		        height: 500,
		        modal: true,
		        visible: false,
		        buttons : [
		            { text:'닫기', handler: function() {
		              	this.cancel(false);
		              }
		            }
		        ]
		    });

			mchnDialog.render(document.body);

			openMchnSearchDialog = function(f) {
		    	_callback = f;
		    	mchnDialog.setUrl('<c:url value="/space/retrieveSpaceExatMchnInfoPop.do"/>');
		    	mchnDialog.show();
		    };
    	    // 공간평가Tool 검색 팝업 끝
    	    
    	    // 시험수가 Simulation 팝업 시작
    	    utmExpSimulationDialog = new Rui.ui.LFrameDialog({
    	        id: 'utmExpSimulationDialog', 
    	        title: '시험수가 Simulation',
    	        width: 920,
    	        height: 430,
    	        modal: true,
    	        visible: false
    	    });
    	    
    	    utmExpSimulationDialog.render(document.body);
    	
    	    openUtmExpSimulationDialog = function() {
    	    	utmExpSimulationDialog.setUrl('<c:url value="/space/spaceExatExpSimulationPopup.do"/>');
    	    	utmExpSimulationDialog.show();
    	    };
    	    // 시험수가 Simulation 팝업 끝
            
     	    setMchnInfoCheck = function(mchnInfo){
    	    	if(spaceExatDtlDataSet.findRow('mchnInfoId', mchnInfo.get("mchnInfoId")) > -1) {
    	    		alert('이미 존재합니다.');
    	    		return false;
    	    		
    	    	}else{
    	    		return true;
    	    	}
    	    	
    	    } 
    	    
            setMchnInfo = function(mchnInfo) {
				if(spaceExatDtlDataSet.findRow('mchnInfoId', mchnInfo.get("mchnInfoId")) > -1) {
					alert('이미 존재합니다.');
					return ;
				}
    	    	
            	var row = spaceExatDtlDataSet.newRecord();
            	var record = spaceExatDtlDataSet.getAt(row);
            	
            	record.set('exatCd', selectExatCd);
            	record.set('mchnInfoId', mchnInfo.get("mchnInfoId"));
            	record.set('toolNm', mchnInfo.get("toolNm"));
            	record.set('ver', mchnInfo.get("ver"));
            	record.set('evCtgr', mchnInfo.get("evCtgr"));
            	record.set('cmpnNm', mchnInfo.get("cmpnNm"));
            	record.set('evWay', mchnInfo.get("evWay"));
            	record.set('mchnCrgrNm', mchnInfo.get("mchnCrgrNm"));
            	record.set('evScn', mchnInfo.get("evScn"));
            	
            	
            }
    	    
            initSpaceExatMst = function() {
            	spaceExatMstTreeDataSet.undoAll();
            };
            
            addSpaceExatMst = function() {
            	if(spaceExatMstTreeDataSet.getRow() == -1) {
            		return ;
            	}
            	
            	var parentRecord = spaceExatMstTreeDataSet.getAt(spaceExatMstTreeDataSet.getRow());
            	var exatCdL = parentRecord.get('exatCdL') + 1;
            	var dspNo = 0;
            	
            	for(var i=0, cnt=spaceExatMstGridDataSetView.getCount(); i<cnt; i++) {
            		if(dspNo < spaceExatMstGridDataSetView.getNameValue(i, 'dspNo')) {
            			dspNo = spaceExatMstGridDataSetView.getNameValue(i, 'dspNo');
            		}
            	}
            	
            	var data = {
            			supiExatCd : parentRecord.get('exatCd'),
            			supiExatNm : parentRecord.get('exatNm'),
            			exatCdL : exatCdL,
            			utmExp : exatCdL == 4 ? 0 : null,
            			utmSmpoQty : exatCdL == 4 ? 1 : null,
            			utmExatTim : exatCdL == 4 ? 0.5 : null,
            			dspNo : dspNo + 1,
            			delYn : 'N'
            		};
           		var record = spaceExatMstGridDataSetView.createRecord(data);
           		
           		record.setState(Rui.data.LRecord.STATE_INSERT);
           		
           		spaceExatMstGridDataSetView.setRow(spaceExatMstGridDataSetView.add(record));
            };
            
            saveSpaceExatMst = function() {
            	var vm = spaceExatMstGridDataSetView.getNameValue(spaceExatMstGridDataSetView.getRow(), 'exatCdL') == 4 ? vm2 : vm1;
            	
            	if (vm.validateDataSet(spaceExatMstGridDataSetView, spaceExatMstGridDataSetView.getRow()) == false) {
                    alert(Rui.getMessageManager().get('$.base.msg052') + '\n' + vm.getMessageList().join('\n'));
                    return false;
                }
                
            	if(confirm('저장 하시겠습니까?')) {
                    dm.updateDataSet({
                        dataSets:[spaceExatMstTreeDataSet],
                        url:'<c:url value="/space/saveSpaceExatMst.do"/>'
                    });
            	}
            };
            
            /* 실험정보 리스트 엑셀 다운로드 */
        	downloadSpaceExatMstListExcel = function() {
        		spaceExatMstTreeGrid.saveExcel(encodeURIComponent('공간평가시험정보_') + new Date().format('%Y%m%d') + '.xls');
            };
            
            addSpaceExatDtl = function() {
            	if(selectExatCd == -1) {
            		alert('먼저 공간평가 시험정보 관리의 Tool관리 버튼을 눌러주세요.');
            	} else {
            		openMchnSearchDialog(setMchnInfo);
            	}
            };
            
            saveSpaceExatDtl = function() {
            	if(selectExatCd == -1) {
            		alert('먼저 공간평가 시험정보 관리의 Tool관리 버튼을 눌러주세요.');
            	} else if(spaceExatDtlDataSet.getModifiedRecords().length == 0) {
            		alert('먼저 신규 Tool을 추가해주세요.');
            	} else {
                	if(confirm('저장 하시겠습니까?')) {
                        dm.updateDataSet({
                            dataSets:[spaceExatDtlDataSet],
                            url:'<c:url value="/space/saveSpaceExatDtl.do"/>'
                        });
                	}
            	}
            };
            
            deleteSpaceExatDtl = function() {
            	if(selectExatCd == -1) {
            		alert('먼저 공간평가 시험정보 관리의 Tool관리 버튼을 눌러주세요.');
            	} else if(spaceExatDtlDataSet.getMarkedCount() == 0) {
                	alert('삭제 대상을 선택해주세요.');
                } else {
                	if(confirm('삭제 하시겠습니까?')) {
            	    	spaceExatDtlDataSet.removeMarkedRows();
                    	
                        dm.updateDataSet({
                            dataSets:[spaceExatDtlDataSet],
                            url:'<c:url value="/space/deleteSpaceExatDtl.do"/>'
                        });
                	}
                }
            };
            
            getSpaceExatMstList();
			
        });

	</script>
    </head>
    <body>
	<form name="aform" id="aform" method="post" onSubmit="return false;">
		
   		<div class="contents">

   			<div class="sub-content">
	   			
   				<div class="titleArea">
		   			<span class="titleArea" style="display:inline">
		   				<h2>공간평가 시험정보 관리</h2>
		   			</span>
   					<div class="LblockButton">
   						<button type="button" class="btn"  id="addSpaceExatMstBtn" name="addSpaceExatMstBtn" onclick="addSpaceExatMst()">신규</button>
   						<button type="button" class="btn"  id="initSpaceExatMstBtn" name="initSpaceExatMstBtn" onclick="initSpaceExatMst()">초기화</button>
   						<button type="button" class="btn"  id="saveSpaceExatMstBtn" name="saveSpaceExatMstBtn" onclick="saveSpaceExatMst()">저장</button>
   						<button type="button" class="btn"  id="openUtmExpSimulationBtn" name="openUtmExpSimulationBtn" onclick="openUtmExpSimulationDialog()">수가계산</button>
   						<button type="button" class="btn"  id="excelBtn" name="excelBtn" onclick="downloadSpaceExatMstListExcel()">Excel</button>
   					</div>
   				</div>
   				
			    <div id="bd" style="height: 310px">
			        <div class="LblockMarkupCode">
			            <div id="contentWrapper">
			        		<div class="L-panel L-grid-panel"></div> 
			                	<div id="spaceExatMstTreeView" style="float: left"></div>
			            </div>
			            <div id="fieldWrapper">
			                <div id="spaceExatMstTreeGrid"></div>
			                <div id="spaceExatMstGrid"></div>
			            </div>
			        </div>
			    </div>
   				
   				<div class="titArea">
   					<span class="Ltotal">공간평가Tool 관리</span>
   					<div class="LblockButton">
   						<button type="button" class="btn"  id="addSpaceExatDtlBtn" name="addSpaceExatDtlBtn" onclick="addSpaceExatDtl()">신규</button>
   						<button type="button" class="btn"  id="saveSpaceExatMstBtn" name="saveSpaceExatMstBtn" onclick="saveSpaceExatDtl()">저장</button>
   						<button type="button" class="btn"  id="deleteSpaceExatDtlBtn" name="deleteSpaceExatDtlBtn" onclick="deleteSpaceExatDtl()">삭제</button>
   					</div>
   				</div>

			    <div id="spaceExatDtlGrid"></div>
   				
   			</div><!-- //sub-content -->
   		</div><!-- //contents -->
		</form>
    </body>
</html>