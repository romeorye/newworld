<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>

<%--
/*
 *************************************************************************
 * $Id      : grsRegFnhPop.jsp
 * @desc    :
 *------------------------------------------------------------------------
 * VER  DATE        AUTHOR      DESCRIPTION
 * ---  ----------- ----------  -----------------------------------------
 * 1.0  2020.03.31
 * ---  ----------- ----------  -----------------------------------------
 * IRIS 프로젝트
 *************************************************************************
 */
--%>

<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/include/rui_header.jspf"%>
<title><%=documentTitle%></title>
<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/grid/LTotalSummary.js"></script>
<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/grid/LGridStatusBar.js"></script>
<link rel="stylesheet" type="text/css" href="<%=ruiPathPlugins%>/ui/grid/LTotalSummary.css"/>
<link rel="stylesheet" type="text/css" href="<%=ruiPathPlugins%>/ui/grid/LGridStatusBar.css"/>

<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/calendar/LMonthCalendar.js"></script>
<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/form/LMonthBox.js"></script>
<link rel="stylesheet" type="text/css" href="<%=ruiPathPlugins%>/ui/form/LMonthBox.css"/>

<script type="text/javascript">

var lvAttcFilId;
var grsEvSnDialog;
var userIds;
var strDt;
var endDt;
var tmpAttchFileList;
var chkVaild;
var roleCheck = '${inputData.roleCheck}';


	Rui.onReady(function() {
    	<%-- RESULT DATASET --%>
		resultDataSet = new Rui.data.LJsonDataSet({
            id: 'resultDataSet',
            remainRemoved: true,
            lazyLoad: true,
            fields: [
                  { id: 'rtnSt' }   //결과코드
                , { id: 'rtnMsg' }  //결과메시지
            ]
        });

        resultDataSet.on('load', function(e) {
        });
        
        /* 평가표 */
    	grsEvSnNm = new Rui.ui.form.LPopupTextBox({
    		applyTo : 'grsEvSnNm',
    		width : 300,
    		editable : false,
    		placeholder : '',
    		emptyValue : '',
    		enterToPopup : true
    	});
    	grsEvSnNm.on('popup', function(e) {
    		openGrsEvSnDialog();
    	});

    	openGrsEvSnDialog = function() {
    		grsEvSnDialog.setUrl('/iris/prj/grs/grsEvStdPop.do?tssCd=' + dataSet.getNameValue(0, "tssCd") + '&userId=' + dataSet.getNameValue(0, "saSabunNew"));
    		grsEvSnDialog.show();
    	};

    	// 팝업: 평가표
    	grsEvSnDialog = new Rui.ui.LFrameDialog({
    		id : 'grsEvSnDialog',
    		title : 'GRS 평가항목선택',
    		width : 700,
    		height : 500,
    		modal : true,
    		visible : false
    	});

    	grsEvSnDialog.render(document.body);
    	
    	var ancpOtPlnDt = new Rui.ui.form.LDateBox({
            applyTo: 'ancpOtPlnDt',
            mask: '9999-99-99',
            displayValue: '%Y-%m-%d',
            width: 180,
            dateType: 'string'
        });
    	
        dataSet = new Rui.data.LJsonDataSet({
            id: 'dataSet',
            focusFirstRow: 0,
            remainRemoved: true,
            lazyLoad: true,
            fields: [
            	  {id: 'prjNm'}
		    	,{ id: 'bizDptNm'}
		    	,{ id: 'tssNm'}
		    	,{ id: 'grsEvSt'}
		    	,{ id: 'tssAttrNm'}
		    	,{ id: 'cmYn'}
		    	,{ id: 'tssDd'}
		    	,{ id: 'dlbrCrgrNm'}
		    	,{ id: 'evTitl'}
		    	,{ id: 'cfrnAtdtCdTxtNm'}
		    	,{ id: 'commTxt'}
		    	,{ id: 'grsEvSn'}
		    	,{ id: 'ancpOtPlnDt'}
		    	,{ id: 'nprodNm'}
		    	,{ id: 'nprodSalsPlnY'}
		    	,{ id: 'nprodSalsPlnY1'}
		    	,{ id: 'nprodSalsPlnY2'}
		    	,{ id: 'nprodSalsCurY'}
		    	,{ id: 'nprodSalsCurY1'}
		    	,{ id: 'nprodSalsCurY2'}
		    	,{ id: 'bizPrftPlnY'}
		    	,{ id: 'bizPrftPlnY1'}
		    	,{ id: 'bizPrftPlnY2'}
		    	,{ id: 'bizPrftCurY'}
		    	,{ id: 'bizPrftCurY1'}
		    	,{ id: 'bizPrftCurY2'}
		    	,{ id: 'bizPrftProY'}
		    	,{ id: 'bizPrftProY1'}
		    	,{ id: 'bizPrftProY2'}
		    	,{ id: 'bizPrftProY3'}
		    	,{ id: 'bizPrftProY4'}
		    	,{ id: 'bizPrftProCurY'}
		    	,{ id: 'bizPrftProCurY1'}
		    	,{ id: 'bizPrftProCurY2'}
		    	,{ id: 'ptcCpsnY'}
		    	,{ id: 'ptcCpsnY1'}
		    	,{ id: 'ptcCpsnY2'}
		    	,{ id: 'ptcCpsnY3'}
		    	,{ id: 'ptcCpsnY4'}
		    	,{ id: 'ptcCpsnCurY'}
		    	,{ id: 'ptcCpsnCurY1'}
		    	,{ id: 'ptcCpsnCurY2'}
		    	,{ id: 'ptcCpsnCurY3'}
		    	,{ id: 'ptcCpsnCurY4'}
		    	,{ id: 'expArslY'}
		    	,{ id: 'expArslY1'}
		    	,{ id: 'expArslY2'}
		    	,{ id: 'expArslY3'}
		    	,{ id: 'expArslY4'}
		    	,{ id: 'expArslCurY'}
		    	,{ id: 'expArslCurY1'}
		    	,{ id: 'expArslCurY2'}
		    	,{ id: 'expArslCurY3'}
		    	,{ id: 'expArslCurY4'}
		    	,{ id: 'tssScnCd'}
		    	,{ id: 'prjCd'}
		    	,{ id: 'bizDptCd'}
		    	,{ id: 'tssAttrCd'}
		    	,{ id: 'tssStrtDd'}
		    	,{ id: 'tssFnhDd'}
		    	,{ id: 'cfrnAtdtCdTxt'}
		    	,{ id: 'attcFilId'}
		    	,{ id: 'tssCd'}
		    	,{ id: 'wbsCd'}
		    	,{ id: 'grsStCd'}
		    	,{ id: 'tssCdSn'}
		    	,{ id: 'pgsStepCd'}
		    	,{ id: 'userId'}
		    	,{ id: 'evSbcNm'}
		    	,{ id: 'dropYn'}
		    	,{ id: 'evResult'}
		    	,{ id: 'evDt'}
	             ]
        });
		
        
		dataSet.on('load', function(e){
			if (roleCheck == "Y" ){
				$("#butImSave").show()
				$("#btnGrsSave").show()
			}else{
				$("#butTssNew").hide()
				$("#btnGrsSave").hide()
			}
			
			//일반과제일 경우
			if( dataSet.getNameValue(0, 'tssScnCd') == "G"  ){
				$("#grsDev").show();
				
				strDt = dataSet.getNameValue(0, 'tssStrtDd');
				endDt = dataSet.getNameValue(0, 'tssFnhDd');
				
				fncPtcCpsnYDisable();
			}else{
				$("#grsDev").hide();
			}
			
			//평가요청일 경우
			//if ( dataSet.getNameValue(0, 'grsStCd') == '301' &&  dataSet.getNameValue(0, 'pgsStepCd') == 'PL'  ){
			if ( dataSet.getNameValue(0, 'grsStCd') == '101'){
				$("#trEv").show();
			}else{
				$("#trEv").hide();
				$("#trEvResult").show();
			}
			
			lvAttcFilId = dataSet.getNameValue(0, 'attcFilId');
			dataSet.setNameValue(0, 'userId', '${inputData._userId}');
			getAttachFileList();
		});
		
		gridDataSet = new Rui.data.LJsonDataSet({ //listGrid dataSet
	        id: 'gridDataSet',
	        lazyLoad: true,
	        fields: [
	                { id: 'grsEvSn'},           					//GRS 일련번호
	                { id: 'grsEvSeq'},          					//평가STEP1
	                { id: 'evPrvsNm_1'},        					//평가항목명1
	                { id: 'evPrvsNm_2'},        					//평가항목명2
	                { id: 'evCrtnNm'},          					//평가기준명
	                { id: 'evSbcTxt'},          					//평가내용
	                { id: 'dtlSbcTitl_1'},    						//상세내용1
	                { id: 'dtlSbcTitl_2'},      						//상세내용2
	                { id: 'dtlSbcTitl_3'},     						//상세내용3
	                { id: 'dtlSbcTitl_4'},      						//상세내용4
	                { id: 'dtlSbcTitl_5'},      						//상세내용5
	                { id: 'evScr', type: 'number' },              //평가점수 , defaultValue: 0
	                { id: 'wgvl' , type: 'number' },              //가중치
	                { id: 'calScr'  },          						//환산점수
	                { id: 'grsY'},              						//년도
	                { id: 'grsType'},           					//유형
	                { id: 'evSbcNm'},           					//템플릿명
	                { id: 'useYn'}            					//
	                ]
	    });
		
		gridDataSet.on('load', function(e) {
			//환산점수 - 화면 로드 시
			for (var i = 0; i < gridDataSet.getCount(); i++) {
				var evScr = gridDataSet.getNameValue(i, "evScr");
				var wgvl = gridDataSet.getNameValue(i, "wgvl");
				var val = evScr / 5 * wgvl;
				var cal = Rui.util.LNumber.round(val, 1);

				if (evScr == null || evScr == "") {
					gridDataSet.setNameValue(i, "calScr", "");
					continue;
				}
				if (!isNaN(cal)) {
					gridDataSet.setNameValue(i, "calScr", cal);
					continue;
				}
			}
		});

		gridDataSet.on('update', function(e) {
			if (e.colId == "evScr") {
				if (e.value > 5) {
					Rui.alert("평가점수는 5점이상을 입력할수 없습니다.");
					gridDataSet.setNameValue(e.row, e.colId, "");
					return;
				}
				if (e.value == '') {
					gridDataSet.setNameValue(e.row, e.colId, "");
					gridDataSet.setNameValue(e.row, "calScr", "");
					return;
				}

				//환산점수 - 평가점수 입력 시
				for (var i = 0; i < gridDataSet.getCount(); i++) {
					var evScr = gridDataSet.getNameValue(i, "evScr");
					var wgvl = gridDataSet.getNameValue(i, "wgvl");
					var val = evScr / 5 * wgvl;
					var cal = Rui.util.LNumber.round(val, 1);

					if (evScr == null || evScr == "") {
						gridDataSet.setNameValue(i, "calScr", "");
						continue;
					}
					if (!isNaN(cal)) {
						gridDataSet.setNameValue(i, "calScr", cal);
						continue;
					}
				}
			}
		});
		
		var numberBox = new Rui.ui.form.LNumberBox({
			emptyValue : '',
			minValue : 0,
			maxValue : 99999
		});

		
		mGridColumnModel = new Rui.ui.grid.LColumnModel({ //listGrid column
			columns : [ {field : 'evPrvsNm_1',	label : '평가항목',	sortable : false,	align : 'center',	width : 120,	editable : false,	vMerge : true	}
					  , {field : 'evPrvsNm_2',	label : '평가항목',	sortable : false,	align : 'center',	width : 100,	editable : false,	vMerge : true	}
					  , {field : 'evCrtnNm',	label : '평가기준',	sortable : false,	align : 'center',	width : 130,	editable : false,	vMerge : true	}
					  , {field : 'evSbcTxt',	label : '평가내용',	sortable : false,	align : 'left',		width : 220,	editable : false}
					  , {id : 'G1',	label : '평가 기준및 배점'}
					  , {field : 'dtlSbcTitl_1',	groupId : 'G1',	label : '5점',	sortable : false,	align : 'left',		width : 82,		editable : false}
					  , {field : 'dtlSbcTitl_2',	groupId : 'G1',	label : '4점',	sortable : false,	align : 'left',		width : 82,		editable : false}
					  , {field : 'dtlSbcTitl_3',	groupId : 'G1',	label : '3점',	sortable : false,	align : 'left',		width : 82,		editable : false}
					  , {field : 'dtlSbcTitl_4',	groupId : 'G1',	label : '2점',	sortable : false,	align : 'left',		width : 82,		editable : false}
					  , {field : 'dtlSbcTitl_5',	groupId : 'G1',	label : '1점',	sortable : false,	align : 'left',		width : 82,		editable : false}
					  , {field : 'evScr',	label : '평가점수',	sortable : false,	align : 'center',	width : 60,	editor : numberBox,		editable : true}
					  , {field : 'wgvl',	label : '가중치',		sortable : false,	align : 'center',	width : 45,	editable : false}
					  , {field : 'calScr',	label : '환산점수',	sortable : false,	align : 'center',	width : 55,	editable : false} 
					  ]
		});

		/* 합계 */

		var sumColumns = [ 'evScr', 'wgvl', 'calScr' ];
		summary = new Rui.ui.grid.LTotalSummary();
		summary.on('renderTotalCell', summary.renderer({
			label : {
				id : 'evPrvsNm_1',
				text : '합 계'
			},
			columns : {
				//evScr: { type: 'avg', renderer: function(val) { return Rui.util.LNumber.round(val, 2); } }
				//evScr: { type: 'sum', renderer: 'number' }  //평가점수 합계 삭제 요청 : 20171219
				wgvl : {
					type : 'sum',
					renderer : 'number'
				},
				calScr : {
					type : 'sum',
					renderer : function(val) {
						return Rui.util.LNumber.round(val, 1);
					}
				}
			}
		}));

		evTableGrid = new Rui.ui.grid.LGridPanel({ //listGrid
			columnModel : mGridColumnModel,
			dataSet : gridDataSet,
			height : 280,
			width : 600,
			autoToEdit : true,
			clickToEdit : true,
			enterToEdit : true,
			autoWidth : true,
			autoHeight : true,
			multiLineEditor : true,
			useRightActionMenu : false,
			viewConfig : {
				plugins : [ summary ]
			}
		});

		evTableGrid.render('evTableGrid'); //listGrid render
		
		
		var commTxt = new Rui.ui.form.LTextArea({
            applyTo: 'commTxt',
            placeholder: 'Comment를 입력해주세요.',
            width: 600,
            height: 122
        });
		/* 
		commTxt.on('blur', function(e) {
			commTxt.setValue(commTxt.getValue().trim());
        });
		 */
		 
		//회의일자 
	        var evDt = new Rui.ui.form.LDateBox({
	            applyTo: 'evDt',
	            mask: '9999-99-99',
	            width: 100,
	            listPosition : 'down',
	            dateType: 'string'
	        });
		 
		var evTitl = new Rui.ui.form.LTextBox({
            applyTo: 'evTitl',
            width: 200,
            dateType: 'string'
        }); 
		nprodNm = new Rui.ui.form.LTextBox({
            applyTo: 'nprodNm',
            width: 230
        });
		
		nprodSalsCurY = new Rui.ui.form.LNumberBox({
            applyTo: 'nprodSalsCurY',
            decimalPrecision: 2,
            maxValue: 9999,
            width: 70
        });
		
		nprodSalsCurY1 = new Rui.ui.form.LNumberBox({
            applyTo: 'nprodSalsCurY1',
            decimalPrecision: 2,
            maxValue: 9999,
            width: 70
        });
		
		nprodSalsCur2 = new Rui.ui.form.LNumberBox({
            applyTo: 'nprodSalsCurY2',
            decimalPrecision: 2,
            maxValue: 9999,
            width: 70
        });
		
		bizPrftCurY = new Rui.ui.form.LNumberBox({
            applyTo: 'bizPrftCurY',
            decimalPrecision: 2,
            maxValue: 9999,
            width: 70
        });
		
		bizPrftCurY1 = new Rui.ui.form.LNumberBox({
            applyTo: 'bizPrftCurY1',
            decimalPrecision: 2,
            maxValue: 9999,
            width: 70
        });
		
		bizPrftCurY2 = new Rui.ui.form.LNumberBox({
            applyTo: 'bizPrftCurY2',
            decimalPrecision: 2,
            maxValue: 9999,
            width: 70
        });
		
		bizPrftProCurY = new Rui.ui.form.LNumberBox({
            applyTo: 'bizPrftProCurY',
            decimalPrecision: 2,
            maxValue: 9999,
            width: 70
        });
		
		bizPrftProCurY1 = new Rui.ui.form.LNumberBox({
            applyTo: 'bizPrftProCurY1',
            decimalPrecision: 2,
            maxValue: 9999,
            width: 70
        });
		
		bizPrftProCurY2 = new Rui.ui.form.LNumberBox({
            applyTo: 'bizPrftProCurY2',
            decimalPrecision: 2,
            maxValue: 9999,
            width: 70
        });
		
		ptcCpsnCurY = new Rui.ui.form.LNumberBox({
            applyTo: 'ptcCpsnCurY',
            decimalPrecision: 0,
            maxValue: 9999,
            width: 70
        });
		
		ptcCpsnCurY1 = new Rui.ui.form.LNumberBox({
            applyTo: 'ptcCpsnCurY1',
            decimalPrecision: 0,
            maxValue: 9999,
            width: 70
        });
		
		ptcCpsnCurY2 = new Rui.ui.form.LNumberBox({
            applyTo: 'ptcCpsnCurY2',
            decimalPrecision: 0,
            maxValue: 9999,
            width: 70
        });
		
		ptcCpsnCurY3 = new Rui.ui.form.LNumberBox({
            applyTo: 'ptcCpsnCurY3',
            decimalPrecision: 0,
            maxValue: 9999,
            width: 70
        });
		
		ptcCpsnCurY4 = new Rui.ui.form.LNumberBox({
            applyTo: 'ptcCpsnCurY4',
            decimalPrecision: 0,
            maxValue: 9999,
            width: 70
        });
		
		expArslCurY = new Rui.ui.form.LNumberBox({
            applyTo: 'expArslCurY',
            decimalPrecision: 2,
            maxValue: 9999,
            width: 70
        });
		
		expArslCurY1 = new Rui.ui.form.LNumberBox({
            applyTo: 'expArslCurY1',
            decimalPrecision: 2,
            maxValue: 9999,
            width: 70
        });
		
		expArslCurY2 = new Rui.ui.form.LNumberBox({
            applyTo: 'expArslCurY2',
            decimalPrecision: 2,
            maxValue: 9999,
            width: 70
        });
		
		expArslCurY3 = new Rui.ui.form.LNumberBox({
            applyTo: 'expArslCurY3',
            decimalPrecision: 2,
            maxValue: 9999,
            width: 70
        });
		
		expArslCurY4 = new Rui.ui.form.LNumberBox({
            applyTo: 'expArslCurY4',
            decimalPrecision: 2,
            maxValue: 9999,
            width: 70
        });
		
		var cfrnAtdtCdTxtNm = new Rui.ui.form.LPopupTextBox({
	        applyTo: 'cfrnAtdtCdTxtNm',
	        width: 600,
	        editable: false,
	        placeholder: '회의참석자를 입력해주세요.',
	        emptyValue: '',
	        enterToPopup: true
	    });
		 
		cfrnAtdtCdTxtNm.on('popup', function(e){
	           openUserSearchDialog(setUsersInfo, 10, userIds, null, 700, 500);
	    });
		 
		setUsersInfo = function(userList) {
	        var idList = [];
	        var nameList = [];
	        var saSabunList = [];

	        for(var i=0, size=userList.length; i<size; i++) {
	            idList.push(userList[i].saUser);
	            nameList.push(userList[i].saName);
	            saSabunList.push(userList[i].saSabun);
	        }
	        
	        cfrnAtdtCdTxtNm.setValue(nameList.join(', '));
	        dataSet.setNameValue(0, 'cfrnAtdtCdTxt', saSabunList);
	       	userIds = idList;
	    };
	    
		fnSearch = function() {
			var dm = new Rui.data.LDataSetManager();
			
			dm.loadDataSet({
                dataSets: [dataSet, gridDataSet],
                url: '<c:url value="/prj/grs/retrievveGrsInfo.do"/>',
                params : {
                    tssCd : '${inputData.tssCd}'                        //과제코드
                   ,tssCdSn :'${inputData.tssCdSn}'   
                   ,grsEvSn :'${inputData.grsEvSn}'   
                   ,roleCheck :'${inputData.roleCheck}'   
                }
            });
        };
        
        fnSearch();
        
        bind = new Rui.data.LBind({
    		groupId: 'aform',
            dataSet: dataSet,
            bind: true,
            bindInfo: [
            	 { id: 'prjNm'             , ctrlId : 'prjNm'            ,value : 'html' }    
            	,{ id: 'bizDptNm'          , ctrlId : 'bizDptNm'         ,value : 'html' }    
            	,{ id: 'tssNm'             , ctrlId : 'tssNm'            ,value : 'html' }
            	,{ id: 'grsEvSt'           , ctrlId : 'grsEvSt'          ,value : 'html' }
            	,{ id: 'cmYn'              , ctrlId : 'cmYn'             ,value : 'html' }
            	,{ id: 'tssDd'             , ctrlId : 'tssDd'            ,value : 'html' }
            	,{ id: 'dlbrCrgrNm'        , ctrlId : 'dlbrCrgrNm'       ,value : 'html' }
            	,{ id: 'commTxt'           , ctrlId : 'commTxt'          ,value : 'value' }
            	,{ id: 'evTitl'            , ctrlId : 'evTitl'           ,value : 'value' }
            	,{ id: 'evDt'            , ctrlId : 'evDt'           ,value : 'value' }
            	,{ id: 'cfrnAtdtCdTxtNm'   , ctrlId : 'cfrnAtdtCdTxtNm'  ,value : 'value' }
            	,{ id: 'grsEvSn'           , ctrlId : 'grsEvSn'          ,value : 'value' }
            	,{ id: 'ancpOtPlnDt'       , ctrlId : 'ancpOtPlnDt'      ,value : 'value' }
            	,{ id: 'nprodNm'           , ctrlId : 'nprodNm'          ,value : 'value' }
            	,{ id: 'nprodSalsPlnY'     , ctrlId : 'nprodSalsPlnY'    ,value : 'html' , renderer: function(value) {
        			return Rui.util.LFormat.numberFormat(value);
        		}
        	}
            	,{ id: 'nprodSalsPlnY1'    , ctrlId : 'nprodSalsPlnY1'   ,value : 'html' , renderer: function(value) {
        			return Rui.util.LFormat.numberFormat(value);
        		}
        	}
            	,{ id: 'nprodSalsPlnY2'    , ctrlId : 'nprodSalsPlnY2'   ,value : 'html' , renderer: function(value) {
        			return Rui.util.LFormat.numberFormat(value);
        		}
        	}
            	,{ id: 'nprodSalsCurY'     , ctrlId : 'nprodSalsCurY'    ,value : 'value' }
            	,{ id: 'nprodSalsCurY1'    , ctrlId : 'nprodSalsCurY1'   ,value : 'value' }
            	,{ id: 'nprodSalsCurY2'    , ctrlId : 'nprodSalsCurY2'   ,value : 'value' }
            	,{ id: 'bizPrftPlnY'       , ctrlId : 'bizPrftPlnY'      ,value : 'html' , renderer: function(value) {
        			return Rui.util.LFormat.numberFormat(value);
        		}
        	}
            	,{ id: 'bizPrftPlnY1'      , ctrlId : 'bizPrftPlnY1'     ,value : 'html' , renderer: function(value) {
        			return Rui.util.LFormat.numberFormat(value);
        		}
        	}
            	,{ id: 'bizPrftPlnY2'      , ctrlId : 'bizPrftPlnY2'     ,value : 'html' , renderer: function(value) {
        			return Rui.util.LFormat.numberFormat(value);
        		}
        	}
            	,{ id: 'bizPrftCurY'       , ctrlId : 'bizPrftCurY'      ,value : 'value' }
            	,{ id: 'bizPrftCurY1'      , ctrlId : 'bizPrftCurY1'     ,value : 'value' }
            	,{ id: 'bizPrftCurY2'      , ctrlId : 'bizPrftCurY2'     ,value : 'value' }
            	,{ id: 'bizPrftProY'       , ctrlId : 'bizPrftProY'      ,value : 'html' , renderer: function(value) {
        			return Rui.util.LFormat.numberFormat(value);
        		}
        	}
            	,{ id: 'bizPrftProY1'      , ctrlId : 'bizPrftProY1'     ,value : 'html' , renderer: function(value) {
        			return Rui.util.LFormat.numberFormat(value);
        		}
        	}
            	,{ id: 'bizPrftProY2'      , ctrlId : 'bizPrftProY2'     ,value : 'html' , renderer: function(value) {
        			return Rui.util.LFormat.numberFormat(value);
        		}
        	}
            	,{ id: 'bizPrftProY3'      , ctrlId : 'bizPrftProY3'     ,value : 'html' , renderer: function(value) {
        			return Rui.util.LFormat.numberFormat(value);
        		}
        	}
            	,{ id: 'bizPrftProY4'      , ctrlId : 'bizPrftProY4'     ,value : 'html' , renderer: function(value) {
        			return Rui.util.LFormat.numberFormat(value);
        		}
        	}
            	,{ id: 'bizPrftProCurY'    , ctrlId : 'bizPrftProCurY'   ,value : 'value' }
            	,{ id: 'bizPrftProCurY1'   , ctrlId : 'bizPrftProCurY1'  ,value : 'value' }
            	,{ id: 'bizPrftProCurY2'   , ctrlId : 'bizPrftProCurY2'  ,value : 'value' }
            	,{ id: 'ptcCpsnY'          , ctrlId : 'ptcCpsnY'         ,value : 'html' }
            	,{ id: 'ptcCpsnY1'         , ctrlId : 'ptcCpsnY1'        ,value : 'html' }
            	,{ id: 'ptcCpsnY2'         , ctrlId : 'ptcCpsnY2'        ,value : 'html' }
            	,{ id: 'ptcCpsnY3'         , ctrlId : 'ptcCpsnY3'        ,value : 'html' }
            	,{ id: 'ptcCpsnY4'         , ctrlId : 'ptcCpsnY4'        ,value : 'html' }
            	,{ id: 'ptcCpsnCurY'       , ctrlId : 'ptcCpsnCurY'      ,value : 'value' }
            	,{ id: 'ptcCpsnCurY1'      , ctrlId : 'ptcCpsnCurY1'     ,value : 'value' }
            	,{ id: 'ptcCpsnCurY2'      , ctrlId : 'ptcCpsnCurY2'     ,value : 'value' }
            	,{ id: 'ptcCpsnCurY3'      , ctrlId : 'ptcCpsnCurY3'     ,value : 'value' }
            	,{ id: 'ptcCpsnCurY4'      , ctrlId : 'ptcCpsnCurY4'     ,value : 'value' }
            	,{ id: 'expArslY'          , ctrlId : 'expArslY'         ,value : 'html' , renderer: function(value) {
        			return Rui.util.LFormat.numberFormat(value);
        		}
        	}
            	,{ id: 'expArslY1'         , ctrlId : 'expArslY1'        ,value : 'html' , renderer: function(value) {
        			return Rui.util.LFormat.numberFormat(value);
        		}
        	}
            	,{ id: 'expArslY2'         , ctrlId : 'expArslY2'        ,value : 'html' , renderer: function(value) {
        			return Rui.util.LFormat.numberFormat(value);
        		}
        	}
            	,{ id: 'expArslY3'         , ctrlId : 'expArslY3'        ,value : 'html' , renderer: function(value) {
        			return Rui.util.LFormat.numberFormat(value);
        		}
        	}
            	,{ id: 'expArslY4'         , ctrlId : 'expArslY4'        ,value : 'html' , renderer: function(value) {
        			return Rui.util.LFormat.numberFormat(value);
        		}
        	}
            	,{ id: 'expArslCurY'       , ctrlId : 'expArslCurY'      ,value : 'value' }
            	,{ id: 'expArslCurY1'      , ctrlId : 'expArslCurY1'     ,value : 'value' }
            	,{ id: 'expArslCurY2'      , ctrlId : 'expArslCurY2'     ,value : 'value' }
            	,{ id: 'expArslCurY3'      , ctrlId : 'expArslCurY3'     ,value : 'value' }
            	,{ id: 'expArslCurY4'      , ctrlId : 'expArslCurY4'     ,value : 'value' }
            	,{ id: 'prjCd'             , ctrlId : 'prjCd'            ,value : 'value' }
            	,{ id: 'bizDptCd'          , ctrlId : 'bizDptCd'         ,value : 'value' }
            	,{ id: 'tssAttrCd'         , ctrlId : 'tssAttrCd'        ,value : 'html' }
            	,{ id: 'tssAttrNm'         , ctrlId : 'tssAttrNm'        ,value : 'html' }
            	,{ id: 'cfrnAtdtCdTxt'     , ctrlId : 'cfrnAtdtCdTxt'    ,value : 'value' }
            	,{ id: 'attcFilId'         , ctrlId : 'attcFilId'        ,value : 'value' }
            	,{ id: 'tssCd'             , ctrlId : 'tssCd'            ,value : 'value' }
            	,{ id: 'wbsCd'             , ctrlId : 'wbsCd'            ,value : 'value' } 
            	,{ id: 'tssCdSn'           , ctrlId : 'tssCdSn'          ,value : 'value' } 
            	,{ id: 'evSbcNm'           , ctrlId : 'grsEvSnNm'        ,value : 'value' } 
            ]
        });
    	
    	
        <%--/*******************************************************************************
         * 첨부파일
         *******************************************************************************/--%>

         /* [기능] 첨부파일 조회 */
         var attachFileDataSet = new Rui.data.LJsonDataSet({
             id: 'attachFileDataSet',
             remainRemoved: true,
             lazyLoad: true,
             fields: [
                   { id: 'attcFilId'}
                 , { id: 'seq' }
                 , { id: 'filNm' }
                 , { id: 'filSize' }
             ]
         });
         attachFileDataSet.on('load', function(e) {
             getAttachFileInfoList();
         });

         getAttachFileList = function() {
             attachFileDataSet.clearData();
             attachFileDataSet.load({
                 url: '<c:url value="/system/attach/getAttachFileList.do"/>' ,
                 params :{
                     attcFilId : lvAttcFilId
                 }
             });
         };

         getAttachFileInfoList = function() {
             var attachFileInfoList = [];

             for( var i = 0, size = attachFileDataSet.getCount(); i < size ; i++ ) {
                 attachFileInfoList.push(attachFileDataSet.getAt(i).clone());
             }

             setAttachFileInfo(attachFileInfoList);
         };

         getAttachFileId = function() {
             if(Rui.isEmpty(lvAttcFilId)) lvAttcFilId = "";

             return lvAttcFilId;
         };
         setAttachFileInfo = function(attachFileList) {
             $('#attchFileView').html('');

             for(var i = 0; i < attachFileList.length; i++) {
                 $('#attchFileView').append($('<a/>', {
                     href: 'javascript:downloadAttachFile("' + attachFileList[i].data.attcFilId + '", "' + attachFileList[i].data.seq + '")',
                     text: attachFileList[i].data.filNm + '(' + attachFileList[i].data.filSize + 'byte)'
                 })).append('<br/>');
             }

             if(attachFileList.length > 0) {
                 lvAttcFilId = attachFileList[0].data.attcFilId;
                 dataSet.setNameValue(0, "attcFilId", lvAttcFilId)
                 tmpAttchFileList = attachFileList;
             }
         };

    	 downloadAttachFile = function(attcFilId, seq) {
    		document.pform.attcFilId.value = attcFilId;
       		document.pform.seq.value = seq;
       		pform.action = "<c:url value='/system/attach/downloadAttachFile.do'/>";
       		pform.submit();
         };
         
         //임시저장
         fncImSave = function(){
        	 var dm = new Rui.data.LDataSetManager({defaultFailureHandler: false});
             dm.on('success', function (e) {      // 업데이트 성공시
                 var resultData = resultDataSet.getReadData(e);

				 alert(resultData.records[0].rtnMsg);
                 
				 if( resultData.records[0].rtnSt == "S"  ){
					 parent.grsPopupDialog.submit(true);
	                 parent.fnSearch();
				 }
             });

             dm.on('failure', function (e) {      // 업데이트 실패시
                 var resultData = resultDataSet.getReadData(e);
                 alert(resultData.records[0].rtnMsg);
             });
             
             if(confirm('임시저장 하시겠습니까?')) {
        		 dm.updateDataSet({
                     modifiedOnly: false,
                     url: '<c:url value="/prj/grs/saveTmpGrsEvRsltInfo.do"/>',
                     dataSets: [gridDataSet, dataSet]
                 });
        	 }
         }
         
         fncInputChk = function(){
        	 if (chkVaild ==2 ){
				//인원체크
        		if(  ptcCpsnCurY1.getValue() == 0 ||   Rui.isEmpty( ptcCpsnCurY1.getValue() )   ){
					alert("2차년도 투입인원을 입력하세요");
					return true;
				}
				
				// 투입비용
        		if(  expArslCurY1.getValue() == 0 ||   Rui.isEmpty( expArslCurY1.getValue() )   ){
					alert("2차년도 투입비용을 입력하세요");
					return true;
				}        	
        	 }else if (  chkVaild ==3 ){
				//인원체크
				if(  ptcCpsnCurY1.getValue() == 0 ||   Rui.isEmpty( ptcCpsnCurY1.getValue() )   ){
					alert("2차년도 투입인원을 입력하세요");
					return true;
				}        		 
				if(  ptcCpsnCurY2.getValue() == 0 ||   Rui.isEmpty( ptcCpsnCurY2.getValue() )   ){
					alert("3차년도 투입인원을 입력하세요");
					return true;
				}    
				
				// 투입비용
        		if(  expArslCurY1.getValue() == 0 ||   Rui.isEmpty( expArslCurY1.getValue() )   ){
					alert("2차년도 투입비용을 입력하세요");
					return true;
				}        	
        		if(  expArslCurY2.getValue() == 0 ||   Rui.isEmpty( expArslCurY2.getValue() )   ){
					alert("3차년도 투입비용을 입력하세요");
					return true;
				}        	
				
        	 }else if (  chkVaild == 4 ){
				//인원체크
				if(  ptcCpsnCurY1.getValue() == 0 ||   Rui.isEmpty( ptcCpsnCurY1.getValue() )   ){
					alert("2차년도 투입인원을 입력하세요");
					return true;
				}        		 
				if(  ptcCpsnCurY2.getValue() == 0 ||   Rui.isEmpty( ptcCpsnCurY2.getValue() )   ){
					alert("3차년도 투입인원을 입력하세요");
					return true;
				}        		 
				if(  ptcCpsnCurY3.getValue() == 0 ||   Rui.isEmpty( ptcCpsnCurY3.getValue() )   ){
					alert("4차년도 투입인원을 입력하세요");
					return true;
				}        		 

				// 투입비용
        		if(  expArslCurY1.getValue() == 0 ||   Rui.isEmpty( expArslCurY1.getValue() )   ){
					alert("2차년도 투입비용을 입력하세요");
					return true;
				}        	
        		if(  expArslCurY2.getValue() == 0 ||   Rui.isEmpty( expArslCurY2.getValue() )   ){
					alert("3차년도 투입비용을 입력하세요");
					return true;
				}        	
        		if(  expArslCurY3.getValue() == 0 ||   Rui.isEmpty( expArslCurY3.getValue() )   ){
					alert("4차년도 투입비용을 입력하세요");
					return true;
				}        	
				
        	 }else if (  chkVaild > 4 ){
				//인원체크
				if(  ptcCpsnCurY1.getValue() == 0 ||   Rui.isEmpty( ptcCpsnCurY1.getValue() )   ){
					alert("2차년도 투입인원을 입력하세요");
					return true;
				}        		 
				if(  ptcCpsnCurY2.getValue() == 0 ||   Rui.isEmpty( ptcCpsnCurY2.getValue() )   ){
					alert("3차년도 투입인원을 입력하세요");
					return true;
				}        		 
				if(  ptcCpsnCurY3.getValue() == 0 ||   Rui.isEmpty( ptcCpsnCurY3.getValue() )   ){
					alert("4차년도 투입인원을 입력하세요");
					return true;
				}        		 
				if(  ptcCpsnCurY4.getValue() == 0 ||   Rui.isEmpty( ptcCpsnCurY4.getValue() )   ){
					alert("5차년도 투입인원을 입력하세요");
					return true;
				}        		 
        		 
				// 투입비용
        		if(  expArslY1.getValue() == 0 ||   Rui.isEmpty( expArslY1.getValue() )   ){
					alert("2차년도 투입비용을 입력하세요");
					return true;
				}        	
        		if(  expArslY2.getValue() == 0 ||   Rui.isEmpty( expArslY2.getValue() )   ){
					alert("3차년도 투입비용을 입력하세요");
					return true;
				}        	
        		if(  expArslY3.getValue() == 0 ||   Rui.isEmpty( expArslY3.getValue() )   ){
					alert("4차년도 투입비용을 입력하세요");
					return true;
				}   
        		if(  expArslY4.getValue() == 0 ||   Rui.isEmpty( expArslY4.getValue() )   ){
					alert("5차년도 투입비용을 입력하세요");
					return true;
				}
        	 }
       		return false;
         }
         
         //GRS 평가등록
         fncGrsSave= function(){
        	 var dm = new Rui.data.LDataSetManager({defaultFailureHandler: false});
             dm.on('success', function (e) {      // 업데이트 성공시
                 var resultData = resultDataSet.getReadData(e);

				 alert(resultData.records[0].rtnMsg);
                 
				 if( resultData.records[0].rtnSt == "S"  ){
					 parent.grsPopupDialog.submit(true);
	                 parent.fnSearch();
				 }
             });

             dm.on('failure', function (e) {      // 업데이트 실패시
                 var resultData = resultDataSet.getReadData(e);
                 alert(resultData.records[0].rtnMsg);
             });
             
             var gbGrsEvSt = dataSet.getNameValue(0, 'gbGrsEvSt');
             var evPoint = $(".L-grid-cell-inner.L-grid-col-calScr:last").html();
             var grsMsg = "";
             
             if( evPoint < 70  ){
             	if (gbGrsEvSt == "P2"){
             		alert("최종 평가 점수 합계는 70점 미만일 수 없습니다.");
                    return;
             	}else{
	            	dataSet.setNameValue(0, 'dropYn', "Y");
	            	grsMsg ="<font color='#DA1C5A'>※ 평가 환산점수 합계가  70점 미만 입니다.</font><br><br>";
             	}
            	 
             }else{
             	dataSet.setNameValue(0, 'dropYn', "N");
             }
             
             dataSet.setNameValue(0, 'grsStCd', '102');
             
             if( dataSet.getNameValue(0, 'tssScnCd') == "G" ){
            	 if(valid1.validateGroup('aform') == false) {
                   	 alert(Rui.getMessageManager().get('$.base.msg052') + '\n' + valid1.getMessageList().join(''));
                     return;
                 }
            	
               	 if(Rui.isEmpty( ancpOtPlnDt.getValue())   ){
               		alert("상품출시일는 필수입력값입니다.");
               		return;
               	 }
               	 
               	var chkCnt = fnAttchValid();

                if (chkCnt < 3  ){
               	 alert("첨부파일이 누락되어있습니다. ");
               	 return;
                }
                
                if( fncInputChk()  ){
                	return true;
                }
                
             }else{
            	 
            	 if ( dataSet.getNameValue(0, 'tssScnCd') == "D" ){
            		 var chkCnt = fnAttchValid();

                     if (chkCnt < 3  ){
                    	 alert("첨부파일이 누락되어있습니다. ");
                    	 return;
                     }
            	 }
            	 
            	 if(valid.validateGroup('aform') == false) {
                   	 alert(Rui.getMessageManager().get('$.base.msg052') + '\n' + valid.getMessageList().join(''));
                     return;
                 }
             }
             
             if( gridDataSet.getCount() == 0  ){
            	 alert("GRS평가표를 작성하세요");
            	 return;
             }
             
             Rui.confirm({
                 text: grsMsg+'평가완료하시겠습니까?<br>완료후에는 수정/삭제가 불가능합니다.',
                 handlerYes: function () {
                	 dm.updateDataSet({
                         modifiedOnly: false,
                         url: '<c:url value="/prj/grs/saveGrsEvRsltInfo.do"/>',
                         dataSets: [gridDataSet, dataSet]
                     });

                 }
             });
         }        
         
         fnAttchValid = function (){
           	var chkNum = 0;
           	
           	if( !Rui.isEmpty(tmpAttchFileList) ){
       	    	for(var i = 0; i < tmpAttchFileList.length; i++) {
       	    		if( tmpAttchFileList[i].data.filNm.indexOf('통합 심의서') > -1 || tmpAttchFileList[i].data.filNm.indexOf('회의록') > -1 || tmpAttchFileList[i].data.filNm.indexOf('평가표') > -1 ){
       					chkNum++;    
       				}               
       	        }
           	}
       		return chkNum;
          }
         
         //닫기
         fncCancel = function(){
        	 parent.grsPopupDialog.submit(true);
         }
         
         var valid = new Rui.validate.LValidatorManager({
        	 validators:[
            	  { id: 'evTitl'            , validExp:'회의일정/장소:true' }
            	 ,{ id: 'cfrnAtdtCdTxtNm'   , validExp:'회의 참석자:true' }
            	 ,{ id: 'attcFilId'         , validExp:'첨부파일:true' }
            	 ,{ id: 'commTxt'           , validExp:'Comment:true' }
            	 ,{ id: 'grsEvSn'           , validExp:'평가표:true' }
             ]
         });
        
         var valid1 = new Rui.validate.LValidatorManager({
        	 validators:[
            	  { id: 'evTitl'            , validExp:'회의 장소:true'}
            	 ,{ id: 'evDt'              , validExp:'회의일정:true'}
            	 ,{ id: 'cfrnAtdtCdTxtNm'   , validExp:'회의 참석자:true'}
            	 ,{ id: 'attcFilId'         , validExp:'첨부파일:true'}
            	 ,{ id: 'commTxt'           , validExp:'Comment:true'}
            	 ,{ id: 'nprodNm'           , validExp:'신체품명:true'}
            	 ,{ id: 'grsEvSn'           , validExp:'평가표:true'}
            	 ,{ id: 'nprodSalsCurY'     , validExp:'매출액:true:minNumber=0.01'}
            	 ,{ id: 'nprodSalsCurY1'    , validExp:'매출액:true:minNumber=0.01'}
            	 ,{ id: 'nprodSalsCurY2'    , validExp:'매출액:true:minNumber=0.01'}
            	 ,{ id: 'bizPrftProCurY'    , validExp:'영업이익률:true:minNumber=0.01'}
            	 ,{ id: 'bizPrftProCurY1'   , validExp:'영업이익률:true:minNumber=0.01'}
            	 ,{ id: 'bizPrftProCurY2'   , validExp:'영업이익룰:true:minNumber=0.01'}
            	 ,{ id: 'bizPrftCurY'       , validExp:'영업이익:true:minNumber=0.01'}
            	 ,{ id: 'bizPrftCurY1'      , validExp:'영업이익:true:minNumber=0.01'}
            	 ,{ id: 'bizPrftCurY2'      , validExp:'영업이익:true:minNumber=0.01'}
            	 ,{ id: 'ptcCpsnCurY'       , validExp:'투입인원:true:minNumber=1'}
            /* 
            	 ,{ id: 'ptcCpsnCurY1'      , validExp:'투입인원:true'}
            	 ,{ id: 'ptcCpsnCurY2'      , validExp:'투입인원:true'}
            	 ,{ id: 'ptcCpsnCurY3'      , validExp:'투입인원:true'}
            	 ,{ id: 'ptcCpsnCurY4'      , validExp:'투입인원:true'}
          */
            	 ,{ id: 'expArslCurY'       , validExp:'투입비용:true:minNumber=0.01'}
          /*
            	 ,{ id: 'expArslCurY1'      , validExp:'투입비용:true'}
            	 ,{ id: 'expArslCurY2'      , validExp:'투입비용:true'}
            	 ,{ id: 'expArslCurY3'      , validExp:'투입비용:true'}
            	 ,{ id: 'expArslCurY4'      , validExp:'투입비용:true'}
            	 */ 
             ]
         });
         
         
         fncPtcCpsnYDisable = function(){
        	 var arr1 = strDt.split("-"); 
             var arr2 = endDt.split("-"); 
			
             var diffCnt = (Number(arr2[0]) - Number(arr1[0])) + 1;
             
             if( diffCnt == 1 ){
            	ptcCpsnCurY1.disable();            	 
             	ptcCpsnCurY2.disable();		
             	ptcCpsnCurY3.disable();		
             	ptcCpsnCurY4.disable();	
             	
             	expArslCurY1.disable();		
             	expArslCurY2.disable();		
             	expArslCurY3.disable();		
             	expArslCurY4.disable();	
             	
             	chkVaild =1;
             }else if( diffCnt == 2 ){
             	ptcCpsnCurY1.enable();	
             	ptcCpsnCurY2.disable();		
             	ptcCpsnCurY3.disable();		
             	ptcCpsnCurY4.disable();	
             	
             	expArslCurY1.enable();	
             	expArslCurY2.disable();		
             	expArslCurY3.disable();		
             	expArslCurY4.disable();	
             	
             	chkVaild =2;
             }else if( diffCnt == 3 ){
             	ptcCpsnCurY1.enable();		
             	ptcCpsnCurY2.enable();		
             	ptcCpsnCurY3.disable();		
             	ptcCpsnCurY4.disable();	
             	
             	expArslCurY1.enable();		
             	expArslCurY2.enable();		
             	expArslCurY3.disable();		
             	expArslCurY4.disable();	
             	
             	chkVaild =3;
             }else if( diffCnt == 4 ){
             	ptcCpsnCurY1.enable();		
             	ptcCpsnCurY2.enable();		
             	ptcCpsnCurY3.enable();	
             	ptcCpsnCurY4.disable();	
             	
             	expArslCurY1.enable();		
             	expArslCurY2.enable();		
             	expArslCurY3.enable();	
             	expArslCurY4.disable();	
             	
             	chkVaild =4;
             }else if( diffCnt > 4 ){
             	ptcCpsnCurY1.enable();		
             	ptcCpsnCurY2.enable();		
             	ptcCpsnCurY3.enable();	
             	ptcCpsnCurY4.enable();	
             	
             	expArslCurY1.enable();		
             	expArslCurY2.enable();		
             	expArslCurY3.enable();	
             	expArslCurY4.enable();
             	
             	chkVaild =5;
             }
         }
         
    });
	
	function setGrsEvSnInfo(grsInfo) {
		grsEvSnNm.setValue(grsInfo.evSbcNm);
		dataSet.setNameValue(0, 'grsEvSn' , grsInfo.grsEvSn);
	    gridDataSet.clearData();
	    gridDataSet.load({
	           url: '<c:url value="/prj/grs/selectGrsEvRsltInfo.do"/>',
	           params: {
	               grsEvSn: grsInfo.grsEvSn,
	               tssCd   : dataSet.getNameValue(0, 'tssCd'),
	               tssCdSn : dataSet.getNameValue(0, 'tssCdSn') 
	           }
	       });
	   }
</script>
</head>
<body>
<div class="contents">
	<div class="sub-content">  
  	
  	<form  id="pform" name="pform" method="post">
	<input type="hidden" id="attcFilId" name="attcFilId" />
	<input type="hidden" id="seq" name="seq" />
</form>
  	
  	
  	<form id="aform" name="aform">	
  		<table class="table table_txt_right">
			<colgroup>
				<col style="width: 20%;" />
				<col style="width: 30%;" />
				<col style="width: 20%;" />
				<col style="width: 30%;" />
			</colgroup>
			<tbody>
			<tr>
				<th align="right">프로젝트명</th>
				<td><span id="prjNm"></span></td>
				<th align="right">사업부문(Funding기준)</th>
				<td><span id="bizDptNm"></span></td>
			</tr>
			<tr>
				<th align="right">과제속성</th>
				<td class="tssLableCss">
					<span id="tssAttrNm"></<span>
				</td>
				<th align="right">과제명</th>
				<td><span id="tssNm"></span></td>
			</tr>
			<tr>
				<th align="right">심의단계</th>
				<td class="tssLableCss">
					<span id="grsEvSt"></<span>
				</td>
				<th align="right">C&M여부</th>
				<td ><span type="text" id="cmYn"></span></td>
			</tr>
			<tr>
				<th align="right">과제기간</th>
				<td><span id="tssDd"></span>  </td>
				<th align="right">심의담당자</th>
				<td><span id="dlbrCrgrNm"/></td>
			</tr>
			<tr>
				<th align="right"><span style="color:red;">* </span>회의 일정</th>
				<td><input type="text" id="evDt" /></td>
				<th align="right"><span style="color:red;">* </span>회의 장소</th>
				<td><input type="text" id="evTitl" /></td>
			</tr>
			<tr>
				<th align="right"><span style="color:red;">* </span>회의 참석자</th>
				<td colspan="3">
					<div class="LblockMarkupCode">
						<div id="cfrnAtdtCdTxtNm"></div>
					</div>
				</td>
			</tr>
			<tr>
				<th align="right"><span style="color:red;">* </span>Comment</th>
				<td colspan="3"><textarea id="commTxt"></textarea></td>
			</tr>
			<tr>
				<th align="right"><span style="color:red;">* </span>첨부파일</th>
				<td  colspan="2" id="attchFileView" />
				<td ><button type="button" class="btn" id="attchFileMngBtn" name="attchFileMngBtn" onclick="openAttachFileDialog(setAttachFileInfo, getAttachFileId(), 'prjPolicy', '*')">첨부파일등록</button></td>
			</tr>
			<tr id="trEvResult" style="display:none;">
					<th align="right">평가결과</th>
					<td colspan="3"><input type="text" id="evResult"/></td>
			</tr>
			</tbody>
		</table>
		
		<table class="table table_txt_right" id="grsDev">
			<colgroup>
				<col style="width: 20%;" />
				<col style="width: 8%;" />
				<col style="width: 8%;" />
				<col style="width: 8%;" />
				<col style="width: 8%;" />
				<col style="width: 8%;" />
				<col style="width: 8%;" />
				<col style="width: 8%;" />
				<col style="width: 8%;" />
				<col style="width: 8%;" />
				<col style="width: 8%;" />
			</colgroup>
			<tbody>
				<tr  id="trCtyOtPlnM">
					<th><span style="color:red;">* </span>상품출시계획</th>
					<td colspan="4">
						<input type="text" id="ancpOtPlnDt" />
					</td>  	
					<th colspan="2"><span style="color:red;">* </span>신제품명</th>
					<td colspan="4">
						<input type="text" id=nprodNm />
					</td>  	
	  			</tr>
				<tr  id="trNprodSalHead"">
	  				<th rowspan="2"></th>
	  				<th class="alignC"  colspan="2">출시년도</th>
	  				<th class="alignC"  colspan="2">출시년도+1</th>
	  				<th class="alignC"  colspan="2">출시년도+2</th>
	  				<th class="alignC"  colspan="2">출시년도+3</th>
	  				<th class="alignC"  colspan="2">출시년도+4</th>
	  			</tr>
	  			<tr>
	  				<th class="alignC">前단계</th>
	  				<th class="alignC">현재</th>
	  				<th class="alignC">前단계</th>
	  				<th class="alignC">현재</th>
	  				<th class="alignC">前단계</th>
	  				<th class="alignC">현재</th>
	  				<th class="alignC">前단계</th>
	  				<th class="alignC">현재</th>
	  				<th class="alignC">前단계</th>
	  				<th class="alignC">현재</th>
	  			</tr>
	  			<tr id="trNprodSal"">
	  				<th>매출이익률(%)</th>
	  				<td><span id="bizPrftProY" /></td>
	  				<td><input type="text" id="bizPrftProCurY" /></td>
	  				<td><span id="bizPrftProY1"/></td>
	  				<td><input type="text" id="bizPrftProCurY1"/></td>
	  				<td><span id="bizPrftProY2"/></td>
	  				<td><input type="text" id="bizPrftProCurY2"/></td>
	  				<td><span id="bizPrftProY3"/></td>
	  				<td></td>
	  				<td><span id="bizPrftProY4"/></td>
	  				<td></td>
	  			</tr>
	  			<tr id="trbizPrftPln">
	  				<th>영업이익(억원)</th>
	  				<td><span id="bizPrftPlnY"/></td>
	  				<td><input type="text" id="bizPrftCurY"/></td>
	  				<td><span id="bizPrftPlnY1"/></td>
	  				<td><input type="text" id="bizPrftCurY1"/></td>
	  				<td><span id="bizPrftPlnY2"/></td>
	  				<td><input type="text" id="bizPrftCurY2"/></td>
	  				<td></td>
	  				<td></td>
	  				<td></td>
	  				<td></td>
	  			</tr>
	  			<tr id="trNprodSal">
	  				<th>매출액(억원)</th>
	  				<td><span id="nprodSalsPlnY" /></td>
	  				<td><input type="text" id="nprodSalsCurY" /></td>
	  				<td><span id="nprodSalsPlnY1"/></td>
	  				<td><input type="text" id="nprodSalsCurY1"/></td>
	  				<td><span id="nprodSalsPlnY2"/></td>
	  				<td><input type="text" id="nprodSalsCurY2"/></td>
	  				<td></td>
	  				<td></td>
	  				<td></td>
	  				<td></td>
	  			</tr>
				<tr id="trPtcCpsnHead"">
	  				<th rowspan="2"></th>
	  				<th class="alignC"  colspan="2">과제시작년도</th>
	  				<th class="alignC"  colspan="2">과제시작년도+1</th>
	  				<th class="alignC"  colspan="2">과제시작년도+2</th>
	  				<th class="alignC"  colspan="2">과제시작년도+3</th>
	  				<th class="alignC"  colspan="2">과제시작년도+4</th>
	  			</tr>
	  			<tr>
	  				<th class="alignC">계획</th>
	  				<th class="alignC">실적</th>
	  				<th class="alignC">계획</th>
	  				<th class="alignC">실적</th>
	  				<th class="alignC">계획</th>
	  				<th class="alignC">실적</th>
	  				<th class="alignC">계획</th>
	  				<th class="alignC">실적</th>
	  				<th class="alignC">계획</th>
	  				<th class="alignC">실적</th>
	  			</tr>
	  			<tr id="trPtcCpsn"">
	  				<th>투입인원(명)</th>
	  				<td><span id="ptcCpsnY"/></td>
	  				<td><input type="text" id="ptcCpsnCurY"/></td>
	  				<td><span id="ptcCpsnY1"/></td>
	  				<td><input type="text" id="ptcCpsnCurY1"/></td>
	  				<td><span id="ptcCpsnY2"/></td>
	  				<td><input type="text" id="ptcCpsnCurY2"/></td>
	  				<td><span id="ptcCpsnY3"/></td>
	  				<td><input type="text" id="ptcCpsnCurY3"/></td>
	  				<td><span id="ptcCpsnY4"/></td>
	  				<td><input type="text" id="ptcCpsnCurY4"/></td>
	  			</tr>
	  			<tr id="trExpArsl"">
	  				<th>투입비용(억원)</th>
	  				<td><span id="expArslY" /></td>
	  				<td><input type="text" id="expArslCurY"/></td>
	  				<td><span id="expArslY1"/></td>
	  				<td><input type="text" id="expArslCurY1"/></td>
	  				<td><span id="expArslY2"/></td>
	  				<td><input type="text" id="expArslCurY2"/></td>
	  				<td><span id="expArslY3"/></td>
	  				<td><input type="text" id="expArslCurY3"/></td>
	  				<td><span id="expArslY4"/></td>
	  				<td><input type="text" id="expArslCurY4"/></td>
	  			</tr>
			</tbody>
		</table>
		<table class="table table_txt_right">
			<colgroup>
				<col style="width: 20%;" />
				<col style="width: 80%;" />
			</colgroup>
			<tbody>
				<tr id="trEv" style="display:none;">
					<th align="right"><span style="color:red;">* </span>평가표 선택</th>
					<td><input type="text" id="grsEvSnNm"/>
				</tr>
			</tbody>
		</table>
		<div id="evTableGrid" style="margin-top: 20px"></div>
  	</form>
	  	</div>
	  	<div class="titArea">
		    <div class="LblockButton">
		        <button type="button" id="butImSave" onClick="fncImSave();">임시저장</button>
		        <button type="button" id="btnGrsSave" onclick="fncGrsSave();">등록</button>
		        <button type="button" id="butCancel" onClick="fncCancel();">닫기</button>
		    </div>
		</div>  
  	</div>		
</div>  
</body>
</html>


