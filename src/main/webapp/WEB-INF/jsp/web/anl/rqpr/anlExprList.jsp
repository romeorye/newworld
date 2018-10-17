<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*,
				 java.util.*,
				 devonframe.util.NullUtil,
				 devonframe.util.DateUtil"%>

<%--
/*
 *************************************************************************
 * $Id		: anlExprList.jsp
 * @desc    : 실험정보 리스트 화면
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
            var selectExprCd = -1;
            var dm = new Rui.data.LDataSetManager();

            dm.on('load', function(e) {
            });

            dm.on('success', function(e) {
                var data = anlExprMstTreeDataSet.getReadData(e);

                alert(data.records[0].resultMsg);

                if(data.records[0].resultYn == 'Y') {
                	if(data.records[0].cmd == 'saveAnlExprMst') {
                		getAnlExprMstList();
                	} else if(data.records[0].cmd == 'saveAnlExprDtl') {
                		getAnlExprDtlList(selectExprCd);
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
                { id: 'exprNm',			validExp: '실험명:true:maxByteLength=100' },
                { id: 'dspNo',			validExp: '순서:true:number' }
                ]
            });

            var vm2 = new Rui.validate.LValidatorManager({
                validators:[
                { id: 'exprNm',			validExp: '실험명:true:maxByteLength=100' },
                { id: 'expCrtnScnCd',	validExp: '비용구분:true' },
                { id: 'utmExp',			validExp: '실험수가:true:number' },
                { id: 'dspNo',			validExp: '순서:true:number' }
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
                    , { id: 'exprCdL', type: 'number' }
                    , { id: 'sopNo' }
                    , { id: 'utmExp', type: 'number' }
                    , { id: 'expCrtnScnCd' }
                    , { id: 'utmSmpoQty', type: 'number', defaultValue: 1 }
                    , { id: 'utmExprTim', type: 'number', defaultValue: 0.5 }
                    , { id: 'dspNo', type: 'number' }
                    , { id: 'delYn', defaultValue: 'N' }
                    , { id: 'path' }
                    , { id: 'sort' }
                ]
            });

            anlExprMstTreeDataSet.on('canRowPosChange', function(e){
            	var vm = anlExprMstGridDataSetView.getNameValue(anlExprMstGridDataSetView.getRow(), 'exprCdL') == 4 ? vm2 : vm1;

            	if (vm.validateDataSet(anlExprMstGridDataSetView, anlExprMstGridDataSetView.getRow()) == false) {
                    alert(Rui.getMessageManager().get('$.base.msg052') + '\n' + vm.getMessageList().join('\n'));
                    return false;
                }
            });

            anlExprMstTreeDataSet.on('rowPosChanged', function (e) {
                if (e.row > -1) {
                	if(e.target.getNameValue(e.row, 'exprCdL') == 4) {
                		e.target.setRow(e.oldRow);
                	} else {
                		selectTreeRow = e.row;
                    	setAnlExprMstDataView(e.row);
                	}
                }
            });

            anlExprMstTreeDataSet.on('load', function () {
            	if(selectTreeRow > -1) {
                	anlExprMstTreeDataSet.setRow(selectTreeRow);
            	}

            	setAnlExprMstDataView(selectTreeRow);
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

            anlExprMstTreeView.render('anlExprMstTreeView');

            var anlExprMstTreeColumnModel = new Rui.ui.grid.LColumnModel({
                columns: [
                	  { field: 'path',			label: 'Path',		sortable: false,	editable: true,		editor: textBox,		align:'left',	width: 350 }
                    , { field: 'exprNm',		label: '실험명',		sortable: false,	editable: true,		editor: textBox,		align:'left',	width: 150 }
                    , { field: 'sopNo',			label: 'Sop No',	sortable: false,	editable: true, 	editor: textBox,		align:'left',	width: 150 }
                    , { field: 'expCrtnScnCd',	label: '비용구분',		sortable: false,	editable: true, 	editor: expCrtnScnCd,	align:'center',	width: 100 }
                    , { field: 'utmSmpoQty',	label: '단위실험수량',	sortable: false,	editable: false,	editor: numberBox,		align:'center',	width: 100 }
                    , { field: 'utmExprTim',	label: '단위실험시간',	sortable: false,	editable: false,	editor: numberBox,		align:'center',	width: 80 }
                    , { field: 'utmExp',		label: '실험수가',		sortable: false,	editable: true,		editor: numberBox,		align:'right',	width: 80,
                    	renderer: function(val, p, record, row, col) {
                    		return Rui.isNumber(val) ? Rui.util.LNumber.toMoney(val, '') + '원' : val;
                    } }
                    , { field: 'dspNo',			label: '순서',		sortable: false,	editable: true,		editor: numberBox,		align:'center',	width: 50 }
                    , { field: 'delYn',			label: '삭제여부',		sortable: false,	editable: true,		editor: useYn,			align:'center',	width: 60 }
                ]
            });

            var anlExprMstTreeGrid = new Rui.ui.grid.LGridPanel({
                columnModel: anlExprMstTreeColumnModel,
                dataSet: anlExprMstTreeDataSet,
                visible: false,
                autoWidth: true
            });

            anlExprMstTreeGrid.render('anlExprMstTreeGrid');

            var anlExprMstGridDataSetView = new Rui.data.LDataSetView({
                sourceDataSet: anlExprMstTreeDataSet
            });

            anlExprMstGridDataSetView.on('canRowPosChange', function(e){
            	var vm = anlExprMstGridDataSetView.getNameValue(anlExprMstGridDataSetView.getRow(), 'exprCdL') == 4 ? vm2 : vm1;

            	if (vm.validateDataSet(anlExprMstGridDataSetView, anlExprMstGridDataSetView.getRow()) == false) {
                    alert(Rui.getMessageManager().get('$.base.msg052') + '\n' + vm.getMessageList().join('\n'));
                    return false;
                }
            });

            var anlExprMstColumnModel = new Rui.ui.grid.LColumnModel({
                columns: [
                	  { field: 'exprNm',		label: '실험명',		sortable: false,	editable: true,		editor: textBox,		align:'left',	width: 250 }
                    , { field: 'sopNo',			label: 'Sop No',	sortable: false,	editable: true, 	editor: textBox,		align:'left',	width: 150 }
                    , { field: 'expCrtnScnCd',	label: '비용구분',		sortable: false,	editable: true, 	editor: expCrtnScnCd,	align:'center',	width: 90 }
                    , { field: 'utmSmpoQty',	label: '단위실험수량',	sortable: false,	editable: false,	editor: numberBox,		align:'center',	width: 90 }
                    , { field: 'utmExprTim',	label: '단위실험시간',	sortable: false,	editable: false,	editor: numberBox,		align:'center',	width: 90 }
                    , { field: 'utmExp',		label: '실험수가',		sortable: false,	editable: true,		editor: numberBox,		align:'right',	width: 90,
                    	renderer: function(val, p, record, row, col) {
                    		return Rui.isNumber(val) ? Rui.util.LNumber.toMoney(val, '') + '원' : val;
                    } }
                    , { field: 'dspNo',			label: '순서',		sortable: false,	editable: true,		editor: numberBox,		align:'center',	width: 70 }
                    , { field: 'delYn',			label: '삭제여부',		sortable: false,	editable: true,		editor: useYn,			align:'center',	width: 65 }
                    , { field: 'exprCdL',		label: '분석기기',		sortable: false,	editable: false,	editor: numberBox,		align:'center',	width: 65,
                    	renderer: function(val, p, record, row, i) {
                    		return (val == 4 && Rui.isEmpty(record.get('exprCd')) == false) ? '<button type="button" class="L-grid-button" onClick="getAnlExprDtlList(' + record.get('exprCd') + ')">관리</button>' : '';
                    } }
                ]
            });

            var anlExprMstGrid = new Rui.ui.grid.LGridPanel({
                columnModel: anlExprMstColumnModel,
                dataSet: anlExprMstGridDataSetView,
                width: 810,
                height: 288,
                autoToEdit: true,
                autoWidth: true
            });

            anlExprMstGrid.render('anlExprMstGrid');

            var anlExprDtlDataSet = new Rui.data.LJsonDataSet({
                id: 'anlExprDtlDataSet',
                remainRemoved: false,
                lazyLoad: true,
                fields: [
					  { id: 'exprCd' }
					, { id: 'mchnInfoId' }
					, { id: 'mchnInfoNm' }
					, { id: 'mdlNm' }
					, { id: 'mkrNm' }
					, { id: 'mchnClNm' }
					, { id: 'mchnCrgrNm' }
                ]
            });

            var anlExprDtlColumnModel = new Rui.ui.grid.LColumnModel({
                columns: [
                	  new Rui.ui.grid.LSelectionColumn()
                    , new Rui.ui.grid.LNumberColumn()
                    , { field: 'mchnInfoNm',	label: '기기명',		sortable: false,	align:'left',	width: 350 }
                    , { field: 'mdlNm',			label: '모델명',		sortable: false,	align:'center',	width: 250 }
                    , { field: 'mkrNm',			label: '제조사',		sortable: false,	align:'center',	width: 230 }
                    , { field: 'mchnClNm',		label: '분류',		sortable: false,	align:'center',	width: 230 }
                    , { field: 'mchnCrgrNm',	label: '담당자',		sortable: false,	align:'center',	width: 202 }
                ]
            });

            var anlExprDtlGrid = new Rui.ui.grid.LGridPanel({
                columnModel: anlExprDtlColumnModel,
                dataSet: anlExprDtlDataSet,
                width: 400,
                height: 340,
                autoToEdit: false,
                autoWidth: true
            });

            anlExprDtlGrid.render('anlExprDtlGrid');

            setAnlExprMstDataView = function(row) {
                var parentId;

                if (row > -1) {
                    parentId = anlExprMstTreeDataSet.getAt(row).get('exprCd');
                } else {
                    parentId = null;
                    anlExprMstTreeDataSet.setRow(-1);
                }

                anlExprMstGridDataSetView.loadView(function(recordId, record){
                    if (record.get('exprCd') != parentId && record.get('supiExprCd') == parentId)
                        return true;
                    else
                        return false;
                });
            };

            getAnlExprMstList = function() {
                anlExprMstTreeDataSet.load({
                    url: '<c:url value="/anl/getAnlExprMstList.do"/>',
                    params :{
                    	isMng : 1
                    }
                });
            };

            getAnlExprDtlList = function(exprCd) {
            	selectExprCd = exprCd;

            	anlExprDtlDataSet.load({
                    url: '<c:url value="/anl/getAnlExprDtlList.do"/>',
                    params :{
                    	exprCd : exprCd
                    }
                });
            };

    	    // 분산기기 검색 팝업 시작
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
		    	mchnDialog.setUrl('<c:url value="/mchn/open/eduAnl/retrieveMchnInfoPop.do"/>');
		    	mchnDialog.show();
		    };
    	    // 분산기기 검색 팝업 끝

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
				if(anlExprDtlDataSet.findRow('mchnInfoId', mchnInfo.get("mchnInfoId")) > -1) {
					alert('이미 존재합니다.');
					return ;
				}

            	var row = anlExprDtlDataSet.newRecord();
            	var record = anlExprDtlDataSet.getAt(row);

            	record.set('exprCd', selectExprCd);
            	record.set('mchnInfoId', mchnInfo.get("mchnInfoId"));
            	record.set('mchnInfoNm', mchnInfo.get("mchnNm"));
            	record.set('mdlNm', mchnInfo.get("mdlNm"));
            	record.set('mkrNm', mchnInfo.get("mkrNm"));
            	record.set('mchnClNm', mchnInfo.get("mchnClNm"));
            	record.set('mchnCrgrNm', mchnInfo.get("mchnCrgrNm"));
            }

            initAnlExprMst = function() {
            	anlExprMstTreeDataSet.undoAll();
            };

            addAnlExprMst = function() {
            	if(anlExprMstTreeDataSet.getRow() == -1) {
            		return ;
            	}

            	var parentRecord = anlExprMstTreeDataSet.getAt(anlExprMstTreeDataSet.getRow());
            	var exprCdL = parentRecord.get('exprCdL') + 1;
            	var dspNo = 0;

            	for(var i=0, cnt=anlExprMstGridDataSetView.getCount(); i<cnt; i++) {
            		if(dspNo < anlExprMstGridDataSetView.getNameValue(i, 'dspNo')) {
            			dspNo = anlExprMstGridDataSetView.getNameValue(i, 'dspNo');
            		}
            	}

            	var data = {
            			supiExprCd : parentRecord.get('exprCd'),
            			exprCdL : exprCdL,
            			utmExp : exprCdL == 4 ? 0 : null,
            			utmSmpoQty : exprCdL == 4 ? 1 : null,
            			utmExprTim : exprCdL == 4 ? 0.5 : null,
            			dspNo : dspNo + 1,
            			delYn : 'N'
            		};
           		var record = anlExprMstGridDataSetView.createRecord(data);

           		record.setState(Rui.data.LRecord.STATE_INSERT);

           		anlExprMstGridDataSetView.setRow(anlExprMstGridDataSetView.add(record));
            };

            saveAnlExprMst = function() {
            	var vm = anlExprMstGridDataSetView.getNameValue(anlExprMstGridDataSetView.getRow(), 'exprCdL') == 4 ? vm2 : vm1;

            	if (vm.validateDataSet(anlExprMstGridDataSetView, anlExprMstGridDataSetView.getRow()) == false) {
                    alert(Rui.getMessageManager().get('$.base.msg052') + '\n' + vm.getMessageList().join('\n'));
                    return false;
                }

            	if(confirm('저장 하시겠습니까?')) {
                    dm.updateDataSet({
                        dataSets:[anlExprMstTreeDataSet],
                        url:'<c:url value="/anl/saveAnlExprMst.do"/>'
                    });
            	}
            };

            /* 실험정보 리스트 엑셀 다운로드 */
        	downloadAnlExprMstListExcel = function() {

                anlExprMstTreeGrid.saveExcel(encodeURIComponent('실험정보_') + new Date().format('%Y%m%d') + '.xls');
            };

            addAnlExprDtl = function() {
            	if(selectExprCd == -1) {
            		alert('먼저 실험정보의 분석기기 관리 버튼을 눌러주세요.');
            	} else {
            		openMchnSearchDialog(setMchnInfo);
            	}
            };

            saveAnlExprDtl = function() {
            	if(selectExprCd == -1) {
            		alert('먼저 실험정보의 분석기기 관리 버튼을 눌러주세요.');
            	} else if(anlExprDtlDataSet.getModifiedRecords().length == 0) {
            		alert('먼저 신규 기기를 추가해주세요.');
            	} else {
                	if(confirm('저장 하시겠습니까?')) {
                        dm.updateDataSet({
                            dataSets:[anlExprDtlDataSet],
                            url:'<c:url value="/anl/saveAnlExprDtl.do"/>'
                        });
                	}
            	}
            };

            deleteAnlExprDtl = function() {
            	if(selectExprCd == -1) {
            		alert('먼저 실험정보의 분석기기 관리 버튼을 눌러주세요.');
            	} else if(anlExprDtlDataSet.getMarkedCount() == 0) {
                	alert('삭제 대상을 선택해주세요.');
                } else {
                	if(confirm('삭제 하시겠습니까?')) {
            	    	anlExprDtlDataSet.removeMarkedRows();

                        dm.updateDataSet({
                            dataSets:[anlExprDtlDataSet],
                            url:'<c:url value="/anl/deleteAnlExprDtl.do"/>'
                        });
                	}
                }
            };

            getAnlExprMstList();

        });

	</script>
    </head>
    <body>
	<form name="aform" id="aform" method="post" onSubmit="return false;">

   		<div class="contents">

   				<div class="titleArea">
		   			<a class="leftCon" href="#">
						<img src="/iris/resource/web/images/img_uxp/ico_leftCon.png" alt="Left Navigation Control">
						<span class="hidden">Toggle 버튼</span>
					</a>
	   				<h2>실험정보 관리</h2>
		   		</div>
		   		<div class="sub-content">
   					<div class="LblockButton mt0 mb5" style="width:100%; text-align:right;">
   						<button type="button" class="btn"  id="addAnlExprMstBtn" name="addAnlExprMstBtn" onclick="addAnlExprMst()">신규</button>
   						<button type="button" class="btn"  id="initAnlExprMstBtn" name="initAnlExprMstBtn" onclick="initAnlExprMst()">초기화</button>
   						<button type="button" class="btn"  id="saveAnlExprMstBtn" name="saveAnlExprMstBtn" onclick="saveAnlExprMst()">저장</button>
   						<button type="button" class="btn"  id="openUtmExpSimulationBtn" name="openUtmExpSimulationBtn" onclick="openUtmExpSimulationDialog()">수가계산</button>
   						<button type="button" class="btn"  id="excelBtn" name="excelBtn" onclick="downloadAnlExprMstListExcel()">Excel</button>
   					</div>


			    <div id="bd" style="height:335px !important;">
			        <div class="LblockMarkupCode">
			            <div id="contentWrapper">
			                <div id="anlExprMstTreeView" style="margin-top:0;"></div>
			            </div>
			            <div id="fieldWrapper">
			                <div id="anlExprMstTreeGrid"></div>
			                <div id="anlExprMstGrid"></div>
			            </div>
			        </div>
			    </div>

   				<div class="titArea mt20">
   					<h3>분석기기</h3>
   					<div class="LblockButton">
   						<button type="button" class="btn"  id="addAnlExprDtlBtn" name="addAnlExprDtlBtn" onclick="addAnlExprDtl()">신규</button>
   						<button type="button" class="btn"  id="saveAnlExprMstBtn" name="saveAnlExprMstBtn" onclick="saveAnlExprDtl()">저장</button>
   						<button type="button" class="btn"  id="deleteAnlExprDtlBtn" name="deleteAnlExprDtlBtn" onclick="deleteAnlExprDtl()">삭제</button>
   					</div>
   				</div>

			    <div id="anlExprDtlGrid"></div>

   			</div><!-- //sub-content -->
   		</div><!-- //contents -->
		</form>
    </body>
</html>