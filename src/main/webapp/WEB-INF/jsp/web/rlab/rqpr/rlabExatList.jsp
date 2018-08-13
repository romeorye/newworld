<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*,
				 java.util.*,
				 devonframe.util.NullUtil,
				 devonframe.util.DateUtil"%>

<%--
/*
 *************************************************************************
 * $Id		: rlabExatList.jsp
 * @desc    : 신뢰성 시험정보 리스트 화면
 *------------------------------------------------------------------------
 * VER	DATE		AUTHOR		DESCRIPTION
 * ---	-----------	----------	-----------------------------------------
 * 1.0  2018.08.09  		
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
                var data = rlabExatMstTreeDataSet.getReadData(e);
                
                alert(data.records[0].resultMsg);
                
                if(data.records[0].resultYn == 'Y') {
                	if(data.records[0].cmd == 'saveRlabExatMst') {
                		getRlabExatMstList();
                	} else if(data.records[0].cmd == 'saveRlabExatDtl') {
                		getRlabExatDtlList(selectExatCd);
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
                    { value: '1', text: '실험수'},
                    { value: '2', text: '시간'}
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
                { id: 'exatNm',			validExp: '시험명:true:maxByteLength=100' },
                { id: 'dspNo',			validExp: '순서:true:number' }
                ]
            });
            
            var vm2 = new Rui.validate.LValidatorManager({
                validators:[
                { id: 'exatNm',			validExp: '시험명:true:maxByteLength=100' },
                { id: 'expCrtnScnCd',	validExp: '비용구분:true' },
                { id: 'utmExp',			validExp: '시험수가:true:number' },
                { id: 'dspNo',			validExp: '순서:true:number' }
                ]
            });
            
            var rlabExatMstTreeDataSet = new Rui.data.LJsonDataSet({
                id: 'rlabExatMstTreeDataSet',
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
            
            rlabExatMstTreeDataSet.on('canRowPosChange', function(e){
            	var vm = rlabExatMstGridDataSetView.getNameValue(rlabExatMstGridDataSetView.getRow(), 'exatCdL') == 2 ? vm2 : vm1;
            	
            	if (vm.validateDataSet(rlabExatMstGridDataSetView, rlabExatMstGridDataSetView.getRow()) == false) {
                    alert(Rui.getMessageManager().get('$.base.msg052') + '\n' + vm.getMessageList().join('\n'));
                    return false;
                }
            });
            
            rlabExatMstTreeDataSet.on('rowPosChanged', function (e) {
                if (e.row > -1) {
                	if(e.target.getNameValue(e.row, 'exatCdL') == 2) {
                		e.target.setRow(e.oldRow);
                	} else {
                		selectTreeRow = e.row;
                    	setRlabExatMstDataView(e.row);
                	}
                }
            });

            rlabExatMstTreeDataSet.on('load', function () {
            	if(selectTreeRow > -1) {
                	rlabExatMstTreeDataSet.setRow(selectTreeRow);
            	}
            	
            	setRlabExatMstDataView(selectTreeRow);
            });

            var rlabExatMstTreeView = new Rui.ui.tree.LTreeView({
                id: 'rlabExatMstTreeView',
                dataSet: rlabExatMstTreeDataSet,
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
            
            rlabExatMstTreeView.render('rlabExatMstTreeView');

            var rlabExatMstTreeColumnModel = new Rui.ui.grid.LColumnModel({
                columns: [
                	  { field: 'path',			label: 'Path',		sortable: false,	editable: true,		editor: textBox,		align:'left',	width: 300 }
                    , { field: 'exatNm',		label: '시험명(대분류)',		sortable: false,	editable: true,		editor: textBox,		align:'left',	width: 100 }
                    , { field: 'exatNm',		label: '시험명(소분류)',		sortable: false,	editable: true,		editor: textBox,		align:'left',	width: 100 }
                    , { field: 'exatMtdNo',			label: '시험법 No',	sortable: false,	editable: true, 	editor: textBox,		align:'left',	width: 100 }
                    , { field: 'expCrtnScnCd',	label: '비용구분',		sortable: false,	editable: true, 	editor: expCrtnScnCd,	align:'center',	width: 80 }
                    , { field: 'utmSmpoQty',	label: '단위실험수량',	sortable: false,	editable: false,	editor: numberBox,		align:'center',	width: 80 }
                    , { field: 'utmExatTim',	label: '단위실험시간',	sortable: false,	editable: false,	editor: numberBox,		align:'center',	width: 80 }
                    , { field: 'utmExp',		label: '실험수가',		sortable: false,	editable: true,		editor: numberBox,		align:'right',	width: 80,
                    	renderer: function(val, p, record, row, col) {
                    		return Rui.isNumber(val) ? Rui.util.LNumber.toMoney(val, '') + '원' : val;
                    } }
                    , { field: 'delYn',			label: '삭제여부',		sortable: false,	editable: true,		editor: useYn,			align:'center',	width: 60 }
                ]
            });

            var rlabExatMstTreeGrid = new Rui.ui.grid.LGridPanel({
                columnModel: rlabExatMstTreeColumnModel,
                dataSet: rlabExatMstTreeDataSet,
                visible: false,
                autoWidth: true
            });
            
            rlabExatMstTreeGrid.render('rlabExatMstTreeGrid');
            
            var rlabExatMstGridDataSetView = new Rui.data.LDataSetView({
                sourceDataSet: rlabExatMstTreeDataSet
            });
            
            rlabExatMstGridDataSetView.on('canRowPosChange', function(e){
            	var vm = rlabExatMstGridDataSetView.getNameValue(rlabExatMstGridDataSetView.getRow(), 'exatCdL') == 2 ? vm2 : vm1;
            	
            	if (vm.validateDataSet(rlabExatMstGridDataSetView, rlabExatMstGridDataSetView.getRow()) == false) {
                    alert(Rui.getMessageManager().get('$.base.msg052') + '\n' + vm.getMessageList().join('\n'));
                    return false;
                }
            });

            var rlabExatMstColumnModel = new Rui.ui.grid.LColumnModel({
                columns: [
                	  { field: 'supiExatNm',		label: '시험명(대분류)',		sortable: false,	editable: true,		editor: textBox,		align:'left',	width: 190 }
                    , { field: 'exatNm',			label: '시험명(소분류)',	sortable: false,	editable: true, 	editor: textBox,		align:'left',	width: 90 }
                    , { field: 'exatMtdNo',	label: '시험법No',		sortable: false,	editable: true, 	editor: textBox,	align:'center',	width: 70 }
                    , { field: 'expCrtnScnCd',	label: '비용구분',	sortable: false,	editable: true,	editor: expCrtnScnCd,		align:'center',	width: 70 }
                    , { field: 'utmSmpoQty',	label: '단위실험수량',	sortable: false,	editable: false,	editor: numberBox,		align:'center',	width: 80 }
                    , { field: 'utmExatTim',	label: '단위실험시간',	sortable: false,	editable: false,	editor: numberBox,		align:'center',	width: 80 }
                    , { field: 'utmExp',		label: '실험수가',		sortable: false,	editable: true,		editor: numberBox,		align:'right',	width: 80,
                    	renderer: function(val, p, record, row, col) {
                    		return Rui.isNumber(val) ? Rui.util.LNumber.toMoney(val, '') + '원' : val;
                    } }
                    , { field: 'delYn',			label: '삭제여부',		sortable: false,	editable: true,		editor: useYn,			align:'center',	width: 70 }
                    , { field: 'exatCdL',		label: '시험장비',		sortable: false,	editable: false,	editor: numberBox,		align:'center',	width: 63,
                    	renderer: function(val, p, record, row, i) {
                    		return (val == 2 && Rui.isEmpty(record.get('exatCd')) == false) ? '<button type="button" class="L-grid-button" onClick="getRlabExatDtlList(' + record.get('exatCd') + ')">관리</button>' : '';
                    } }
                ]
            });

            var rlabExatMstGrid = new Rui.ui.grid.LGridPanel({
                columnModel: rlabExatMstColumnModel,
                dataSet: rlabExatMstGridDataSetView,
                width: 810,
                height: 300,
                autoToEdit: true,
                autoWidth: true
            });
            
            rlabExatMstGrid.render('rlabExatMstGrid');
			
             var rlabExatDtlDataSet = new Rui.data.LJsonDataSet({
                id: 'rlabExatDtlDataSet',
                remainRemoved: false,
                lazyLoad: true,
                fields: [
					  { id: 'exatCd' }
					, { id: 'mchnInfoId' }
					, { id: 'mchnHanNm' }
					, { id: 'mdlNm' }
					, { id: 'mkrNm' }
					, { id: 'mchnClNm' }
					, { id: 'mchnCrgrNm' }
					, { id: 'mchnExpl' }                ]
            });

            var rlabExatDtlColumnModel = new Rui.ui.grid.LColumnModel({
                columns: [
                	  new Rui.ui.grid.LSelectionColumn()
                    , new Rui.ui.grid.LNumberColumn()
                    , { field: 'mchnHanNm',	label: '장비명',		sortable: false,	align:'center',	width: 200 }
                    , { field: 'mdlNm',			label: '모델명',		sortable: false,	align:'center',	width: 150 }
                    , { field: 'mkrNm',			label: '제조사',		sortable: false,	align:'center',	width: 150 }
                    , { field: 'mchnClNm',		label: '분류',		sortable: false,	align:'center',	width: 150 }
                    , { field: 'mchnCrgrNm',	label: '담당자',		sortable: false,	align:'center',	width: 100 }
                    , { field: 'mchnExpl',	label: '비고',		sortable: false,	align:'center',	width: 168 }
                ]
            });

            var rlabExatDtlGrid = new Rui.ui.grid.LGridPanel({
                columnModel: rlabExatDtlColumnModel,
                dataSet: rlabExatDtlDataSet,
                width: 400,
                height: 340,
                autoToEdit: false,
                autoWidth: true
            });
            rlabExatDtlGrid.render('rlabExatDtlGrid');
            
            setRlabExatMstDataView = function(row) {
                var parentId;
                
                if (row > -1) {
                    parentId = rlabExatMstTreeDataSet.getAt(row).get('exatCd');
                } else {
                    parentId = null;
                    rlabExatMstTreeDataSet.setRow(-1);
                }

                rlabExatMstGridDataSetView.loadView(function(recordId, record){
                    if (record.get('exatCd') != parentId && record.get('supiExatCd') == parentId)
                        return true;
                    else
                        return false;
                });
            };
            
            getRlabExatMstList = function() {
                rlabExatMstTreeDataSet.load({
                    url: '<c:url value="/rlab/getRlabExatMstList.do"/>',
                    params :{
                    	isMng : 1
                    }
                });
            };
            
            getRlabExatDtlList = function(exatCd) {
            	selectExatCd = exatCd;
            	
            	rlabExatDtlDataSet.load({
                    url: '<c:url value="/rlab/getRlabExatDtlList.do"/>',
                    params :{
                    	exatCd : exatCd
                    }
                });
            };

    	    // 신뢰성시험장비 검색 팝업 시작
			mchnDialog = new Rui.ui.LFrameDialog({
		        id: 'mchnDialog',
		        title: '신뢰성시험 장비 조회',
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
		    	mchnDialog.setUrl('<c:url value="/rlab/retrieveRlabExatMchnInfoPop.do"/>');
		    	mchnDialog.show();
		    };
    	    // 신뢰성시험장비 검색 팝업 끝
    	 
    	    // 실험수가 Simulation 팝업 시작
    	    utmExpSimulationDialog = new Rui.ui.LFrameDialog({
    	        id: 'utmExpSimulationDialog', 
    	        title: '실험수가 Simulation',
    	        width: 920,
    	        height: 430,
    	        modal: true,
    	        visible: false
    	    });
    	    
    	    utmExpSimulationDialog.render(document.body);
    	
    	    openUtmExpSimulationDialog = function() {
    	    	utmExpSimulationDialog.setUrl('<c:url value="/anl/anlExprExpSimulationPopup.do"/>');
    	    	utmExpSimulationDialog.show();
    	    };
    	    // 실험수가 Simulation 팝업 끝
            
            setMchnInfo = function(mchnInfo) {
				if(rlabExatDtlDataSet.findRow('mchnInfoId', mchnInfo.get("mchnInfoId")) > -1) {
					alert('이미 존재합니다.');
					return ;
				}
    	    	
            	var row = rlabExatDtlDataSet.newRecord();
            	var record = rlabExatDtlDataSet.getAt(row);
            	
            	record.set('exatCd', selectExatCd);
            	record.set('mchnInfoId', mchnInfo.get("mchnInfoId"));
            	record.set('mchnHanNm', mchnInfo.get("mchnNm"));
            	record.set('mdlNm', mchnInfo.get("mdlNm"));
            	record.set('mkrNm', mchnInfo.get("mkrNm"));
            	record.set('mchnClNm', mchnInfo.get("mchnClNm"));
            	record.set('mchnCrgrNm', mchnInfo.get("mchnCrgrNm"));
            }
    	    
    	  initRlabExatMst = function() {
            	rlabExatMstTreeDataSet.undoAll();
            };
            
            addRlabExatMst = function() {
            	if(rlabExatMstTreeDataSet.getRow() == -1) {
            		return ;
            	}
            	
            	var parentRecord = rlabExatMstTreeDataSet.getAt(rlabExatMstTreeDataSet.getRow());
            	var exatCdL = parentRecord.get('exatCdL') + 1;
            	var dspNo = 0;
            	
            	for(var i=0, cnt=rlabExatMstGridDataSetView.getCount(); i<cnt; i++) {
            		if(dspNo < rlabExatMstGridDataSetView.getNameValue(i, 'dspNo')) {
            			dspNo = rlabExatMstGridDataSetView.getNameValue(i, 'dspNo');
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
           		var record = rlabExatMstGridDataSetView.createRecord(data);
           		
           		record.setState(Rui.data.LRecord.STATE_INSERT);
           		
           		rlabExatMstGridDataSetView.setRow(rlabExatMstGridDataSetView.add(record));
            };
            
            saveRlabExatMst = function() {
            	var vm = rlabExatMstGridDataSetView.getNameValue(rlabExatMstGridDataSetView.getRow(), 'exatCdL') == 4 ? vm2 : vm1;
            	
            	if (vm.validateDataSet(rlabExatMstGridDataSetView, rlabExatMstGridDataSetView.getRow()) == false) {
                    alert(Rui.getMessageManager().get('$.base.msg052') + '\n' + vm.getMessageList().join('\n'));
                    return false;
                }
                
            	if(confirm('저장 하시겠습니까?')) {
                    dm.updateDataSet({
                        dataSets:[rlabExatMstTreeDataSet],
                        url:'<c:url value="/rlab/saveRlabExatMst.do"/>'
                    });
            	}
            };
            
            /* 신뢰성정보 리스트 엑셀 다운로드 */
         	downloadRlabExatMstListExcel = function() {
        		rlabExatMstTreeGrid.saveExcel(encodeURIComponent('신뢰성정보_') + new Date().format('%Y%m%d') + '.xls');
            };
            
            addRlabExatDtl = function() {
            	if(selectExatCd == -1) {
            		alert('먼저 신뢰성정보의 분석기기 관리 버튼을 눌러주세요.');
            	} else {
            		openMchnSearchDialog(setMchnInfo);
            	}
            };
                      
            saveRlabExatDtl = function() {
            	if(selectExatCd == -1) {
            		alert('먼저 신뢰성정보의 분석기기 관리 버튼을 눌러주세요.');
            	} else if(rlabExatDtlDataSet.getModifiedRecords().length == 0) {
            		alert('먼저 신규 기기를 추가해주세요.');
            	} else {
                	if(confirm('저장 하시겠습니까?')) {
                        dm.updateDataSet({
                            dataSets:[rlabExatDtlDataSet],
                            url:'<c:url value="/rlab/saveRlabExatDtl.do"/>'
                        });
                	}
            	}
            };
            
            deleteRlabExatDtl = function() {
            	if(selectExatCd == -1) {
            		alert('먼저 신뢰성정보의 분석기기 관리 버튼을 눌러주세요.');
            	} else if(rlabExatDtlDataSet.getMarkedCount() == 0) {
                	alert('삭제 대상을 선택해주세요.');
                } else {
                	if(confirm('삭제 하시겠습니까?')) {
            	    	rlabExatDtlDataSet.removeMarkedRows();
                    	
                        dm.updateDataSet({
                            dataSets:[rlabExatDtlDataSet],
                            url:'<c:url value="/rlab/deleteRlabExatDtl.do"/>'
                        });
                	}
                }
            };
            
            getRlabExatMstList();
			
        });  

	</script>
    </head>
    <body>
	<form name="aform" id="aform" method="post" onSubmit="return false;">
		
   		<div class="contents">

   			<div class="sub-content">
	   			
   				<div class="titleArea">
		   			<span class="titleArea" style="display:inline">
		   				<h2>신뢰성 시험정보 관리</h2>
		   			</span>
   					<div class="LblockButton">
   						<button type="button" class="btn"  id="addRlabExatMstBtn" name="addRlabExatMstBtn" onclick="addRlabExatMst()">신규</button>
   						<button type="button" class="btn"  id="initRlabExatMstBtn" name="initRlabExatMstBtn" onclick="initRlabExatMst()">초기화</button>
   						<button type="button" class="btn"  id="saveRlabExatMstBtn" name="saveRlabExatMstBtn" onclick="saveRlabExatMst()">저장</button>
   						<button type="button" class="btn"  id="openUtmExpSimulationBtn" name="openUtmExpSimulationBtn" onclick="openUtmExpSimulationDialog()">수가계산</button>
   						<button type="button" class="btn"  id="excelBtn" name="excelBtn" onclick="downloadRlabExatMstListExcel()">Excel</button>
   					</div>
   				</div>
   				
			    <div id="bd">
			        <div class="LblockMarkupCode">
			            <div id="contentWrapper">
			                <div id="rlabExatMstTreeView"></div>
			            </div>
			            <div id="fieldWrapper">
			                <div id="rlabExatMstTreeGrid"></div>
			                <div id="rlabExatMstGrid"></div>
			            </div>
			        </div>
			    </div>
   				
   				<div class="titArea">
   					<span class="Ltotal">신뢰성 시험/평가 장비</span>
   					<div class="LblockButton">
   						<button type="button" class="btn"  id="addRlabExatDtlBtn" name="addRlabExatDtlBtn" onclick="addRlabExatDtl()">신규</button>
   						<button type="button" class="btn"  id="saveRlabExatMstBtn" name="saveRlabExatMstBtn" onclick="saveRlabExatDtl()">저장</button>
   						<button type="button" class="btn"  id="deleteRlabExatDtlBtn" name="deleteRlabExatDtlBtn" onclick="deleteRlabExatDtl()">삭제</button>
   					</div>
   				</div>

			    <div id="rlabExatDtlGrid"></div>
   				
   			</div><!-- //sub-content -->
   		</div><!-- //contents -->
		</form>
    </body>
</html>