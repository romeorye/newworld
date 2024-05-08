<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>

<%--
/*
 *************************************************************************
 * $Id      : grsEvFnhDtlPop.jsp
 * @desc    :
 *------------------------------------------------------------------------
 * VER  DATE        AUTHOR      DESCRIPTION
 * ---  ----------- ----------  -----------------------------------------
 * 1.0  2020.03.31
 * 1.1  2020.04.01
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

	Rui.onReady(function() {
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
		    	,{ id: 'nprodSalsPlnY3'}
		    	,{ id: 'nprodSalsPlnY4'}
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
		    	,{ id: 'grsEvStNm'}
		    	,{ id: 'tssTypeNm'}
	             ]
        });
		
        
		dataSet.on('load', function(e){
			//일반과제일 경우
			if( dataSet.getNameValue(0, 'tssScnCd') == "G"  ){
				$("#grsDev").show();
			}else{
				if ( dataSet.getNameValue(0, 'tssScnCd') == "D" ){
					if ( dataSet.getNameValue(0, 'bizDptCd') == "05" && dataSet.getNameValue(0, 'custSqlt') == "05"    ){
						$("#grsDev").hide();
					}else{
						$("#grsDev").show();
					}					
				}else{
					$("#grsDev").hide();
				}
			}

			$("#trEv").hide();
			$("#trEvResult").show();
			commTxt.setEditable(false);
			lvAttcFilId = dataSet.getNameValue(0, 'attcFilId');
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
					  , {field : 'evScr',	label : '평가점수',	sortable : false,	align : 'center',	width : 60,	editor : numberBox,		editable : false}
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
		
		fnSearch = function() {
			var dm = new Rui.data.LDataSetManager();
			
			dm.loadDataSet({
                dataSets: [dataSet, gridDataSet],
                url: '<c:url value="/prj/grs/retrievveGrsInfo.do"/>',
                params : {
                    tssCd : '${inputData.tssCd}'                        //과제코드
                   ,tssCdSn :'${inputData.tssCdSn}'   
                   ,grsEvSn :'${inputData.grsEvSn}'   
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
            	,{ id: 'tssTypeNm'         , ctrlId : 'tssTypeNm'        ,value : 'html' }
            	,{ id: 'tssDd'             , ctrlId : 'tssDd'            ,value : 'html' }
            	,{ id: 'dlbrCrgrNm'        , ctrlId : 'dlbrCrgrNm'       ,value : 'html' }
            	,{ id: 'commTxt'           , ctrlId : 'commTxt'          ,value : 'value' }
            	,{ id: 'evTitl'            , ctrlId : 'evTitl'           ,value : 'html' }
            	,{ id: 'evDt'              , ctrlId : 'evDt'             ,value : 'html' }
            	,{ id: 'cfrnAtdtCdTxtNm'   , ctrlId : 'cfrnAtdtCdTxtNm'  ,value : 'html' }
            	,{ id: 'grsEvSn'           , ctrlId : 'grsEvSn'          ,value : 'html' }
            	,{ id: 'ancpOtPlnDt'       , ctrlId : 'ancpOtPlnDt'      ,value : 'html' }
            	,{ id: 'nprodNm'           , ctrlId : 'nprodNm'          ,value : 'html' }
            	,{ id: 'bizPrftPlnY'       , ctrlId : 'bizPrftProY'      ,value : 'html' , renderer: function(value) {
	        			return Rui.util.LFormat.numberFormat(value);
	        		}
	        	}
            	,{ id: 'bizPrftPlnY1'      , ctrlId : 'bizPrftProY1'     ,value : 'html' , renderer: function(value) {
	        			return Rui.util.LFormat.numberFormat(value);
	        		}
	        	}
            	,{ id: 'bizPrftPlnY2'      , ctrlId : 'bizPrftProY2'     ,value : 'html' , renderer: function(value) {
	        			return Rui.util.LFormat.numberFormat(value);
	        		}
	        	}
            	,{ id: 'bizPrftPlnY3'      , ctrlId : 'bizPrftProY3'     ,value : 'html' , renderer: function(value) {
	        			return Rui.util.LFormat.numberFormat(value);
	        		}
	        	}
            	,{ id: 'bizPrftPlnY4'      , ctrlId : 'bizPrftProY4'     ,value : 'html' , renderer: function(value) {
	        			return Rui.util.LFormat.numberFormat(value);
	        		}
	        	}
            	,{ id: 'bizPrftProCurY'    , ctrlId : 'bizPrftProCurY'   ,value : 'html' , renderer: function(value) {
	        			return Rui.util.LFormat.numberFormat(value);
	        		}
	        	}
            	,{ id: 'bizPrftProCurY1'   , ctrlId : 'bizPrftProCurY1'  ,value : 'html' , renderer: function(value) {
	        			return Rui.util.LFormat.numberFormat(value);
	        		}
	        	}
            	,{ id: 'bizPrftProCurY2'   , ctrlId : 'bizPrftProCurY2'  ,value : 'html' , renderer: function(value) {
	        			return Rui.util.LFormat.numberFormat(value);
	        		}
	        	}
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
            	,{ id: 'nprodSalsPlnY3'    , ctrlId : 'nprodSalsPlnY3'   ,value : 'html' , renderer: function(value) {
	        			return Rui.util.LFormat.numberFormat(value);
	        		}
	        	}
            	,{ id: 'nprodSalsPlnY4'    , ctrlId : 'nprodSalsPlnY4'   ,value : 'html' , renderer: function(value) {
	        			return Rui.util.LFormat.numberFormat(value);
	        		}
	        	}
            	,{ id: 'nprodSalsCurY'     , ctrlId : 'nprodSalsCurY'    ,value : 'html' , renderer: function(value) {
	        			return Rui.util.LFormat.numberFormat(value);
	        		}
	        	}
            	,{ id: 'nprodSalsCurY1'    , ctrlId : 'nprodSalsCurY1'   ,value : 'html' , renderer: function(value) {
	        			return Rui.util.LFormat.numberFormat(value);
	        		}
	        	}
            	,{ id: 'nprodSalsCurY2'    , ctrlId : 'nprodSalsCurY2'   ,value : 'html' , renderer: function(value) {
	        			return Rui.util.LFormat.numberFormat(value);
	        		}
	        	}
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
            	,{ id: 'bizPrftCurY'       , ctrlId : 'bizPrftCurY'      ,value : 'html' , renderer: function(value) {
	        			return Rui.util.LFormat.numberFormat(value);
	        		}
	        	}
            	,{ id: 'bizPrftCurY1'      , ctrlId : 'bizPrftCurY1'     ,value : 'html' , renderer: function(value) {
        			return Rui.util.LFormat.numberFormat(value);
        		}
        	}
            	,{ id: 'bizPrftCurY2'      , ctrlId : 'bizPrftCurY2'     ,value : 'html' , renderer: function(value) {
        			return Rui.util.LFormat.numberFormat(value);
        		}
        	}
            	,{ id: 'ptcCpsnY'          , ctrlId : 'ptcCpsnY'         ,value : 'html' }
            	,{ id: 'ptcCpsnY1'         , ctrlId : 'ptcCpsnY1'        ,value : 'html' }
            	,{ id: 'ptcCpsnY2'         , ctrlId : 'ptcCpsnY2'        ,value : 'html' }
            	,{ id: 'ptcCpsnY3'         , ctrlId : 'ptcCpsnY3'        ,value : 'html' }
            	,{ id: 'ptcCpsnY4'         , ctrlId : 'ptcCpsnY4'        ,value : 'html' }
            	,{ id: 'ptcCpsnCurY'       , ctrlId : 'ptcCpsnCurY'      ,value : 'html' }
            	,{ id: 'ptcCpsnCurY1'      , ctrlId : 'ptcCpsnCurY1'     ,value : 'html' }
            	,{ id: 'ptcCpsnCurY2'      , ctrlId : 'ptcCpsnCurY2'     ,value : 'html' }
            	,{ id: 'ptcCpsnCurY3'      , ctrlId : 'ptcCpsnCurY3'     ,value : 'html' }
            	,{ id: 'ptcCpsnCurY4'      , ctrlId : 'ptcCpsnCurY4'     ,value : 'html' }
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
            	,{ id: 'expArslCurY'       , ctrlId : 'expArslCurY'      ,value : 'html' , renderer: function(value) {
        			return Rui.util.LFormat.numberFormat(value);
        		}
        	}
            	,{ id: 'expArslCurY1'      , ctrlId : 'expArslCurY1'     ,value : 'html' , renderer: function(value) {
        			return Rui.util.LFormat.numberFormat(value);
        		}
        	}
            	,{ id: 'expArslCurY2'      , ctrlId : 'expArslCurY2'     ,value : 'html' , renderer: function(value) {
        			return Rui.util.LFormat.numberFormat(value);
        		}
        	}
            	,{ id: 'expArslCurY3'      , ctrlId : 'expArslCurY3'     ,value : 'html' , renderer: function(value) {
        			return Rui.util.LFormat.numberFormat(value);
        		}
        	}
            	,{ id: 'expArslCurY4'      , ctrlId : 'expArslCurY4'     ,value : 'html' , renderer: function(value) {
        			return Rui.util.LFormat.numberFormat(value);
        		}
        	}
            	,{ id: 'prjCd'             , ctrlId : 'prjCd'            ,value : 'html' }
            	,{ id: 'bizDptCd'          , ctrlId : 'bizDptCd'         ,value : 'html' }
            	,{ id: 'tssAttrCd'         , ctrlId : 'tssAttrCd'        ,value : 'html' }
            	,{ id: 'tssAttrNm'         , ctrlId : 'tssAttrNm'        ,value : 'html' }
            	,{ id: 'cfrnAtdtCdTxt'     , ctrlId : 'cfrnAtdtCdTxt'    ,value : 'html' }
            	,{ id: 'attcFilId'         , ctrlId : 'attcFilId'        ,value : 'value' }
            	,{ id: 'tssCd'             , ctrlId : 'tssCd'            ,value : 'value' }
            	,{ id: 'wbsCd'             , ctrlId : 'wbsCd'            ,value : 'html' } 
            	,{ id: 'tssCdSn'           , ctrlId : 'tssCdSn'          ,value : 'value' } 
            	,{ id: 'evSbcNm'           , ctrlId : 'grsEvSnNm'        ,value : 'html' } 
            	,{ id: 'evResult'           , ctrlId : 'evResult'        ,value : 'html' } 
            	,{ id: 'grsEvStNm'           , ctrlId : 'grsEvStNm'        ,value : 'html' } 
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
             }
         };

    	 downloadAttachFile = function(attcFilId, seq) {
    		 document.pform.attcFilId.value = attcFilId;
       		document.pform.seq.value = seq;
       		pform.action = "<c:url value='/system/attach/downloadAttachFile.do'/>";
       		pform.submit();
         };
         
         //닫기
         fncCancel = function(){
        	 parent.grsPopupDialog.submit(true);
         }
         
    });
	
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
					<span id="grsEvStNm"></<span>
					<!-- <span id="grsEvSt"></<span> -->
				</td>
				<th align="right">개발등급</th>
				<td ><span type="text" id="tssTypeNm"></span></td>
			</tr>
			<tr>
				<th align="right">과제기간</th>
				<td><span id="tssDd"></span>  </td>
				<th align="right">심의담당자</th>
				<td><span id="dlbrCrgrNm"/></td>
			</tr>
			<tr>
				<th align="right"><span style="color:red;">* </span>회의 일정</th>
				<td><span id="evDt" /></td>
				<th align="right"><span style="color:red;">* </span>회의 장소</th>
				<td><span id="evTitl" /></td>
			</tr>
			<tr>
				<th align="right"><span style="color:red;">* </span>회의 참석자</th>
				<td colspan="3">
					<span id="cfrnAtdtCdTxtNm" />
				</td>
			</tr>
			<tr>
				<th align="right"><span style="color:red;">* </span>Comment</th>
				<td colspan="3"><textarea id="commTxt"></textarea></td>
			</tr>
			<tr>
				<th align="right"><span style="color:red;">* </span>첨부파일</th>
				<td  colspan="3" id="attchFileView" />
			</tr>
			<tr id="trEvResult" style="display:none;">
					<th align="right">평가결과</th>
					<td colspan="3"><span id="evResult"/></td>
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
				<tr>
					<th>상품출시계획</th>
					<td colspan="4">
						<span id="ancpOtPlnDt" />
					</td>  	
					<th colspan="2">신제품명</th>
					<td colspan="4">
						<span id=nprodNm />
					</td>  	
	  			</tr>
				<tr  id="trNprodSalHead">
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
	  			<tr id="trNprodSal">
	  				<th>영업이익률(%)</th>
	  				<td class="alignR" ><span id="bizPrftProY" /></td>
	  				<td class="alignR" ><span id="bizPrftProCurY" /></td>
	  				<td class="alignR" ><span id="bizPrftProY1"/></td>
	  				<td class="alignR" ><span id="bizPrftProCurY1"/></td>
	  				<td class="alignR" ><span id="bizPrftProY2"/></td>
	  				<td class="alignR" ><span id="bizPrftProCurY2"/></td>
	  				<td class="alignR" ></td>
	  				<td class="alignR" ></td>
	  				<td class="alignR" ></td>
	  				<td class="alignR" ></td>
	  			</tr>
	  			<tr id="trNprodSal"  >
	  				<th>매출액(억원)</th>
	  				<td class="alignR" ><span id="nprodSalsPlnY" /></td>
	  				<td class="alignR" ><span id="nprodSalsCurY" /></td>
	  				<td class="alignR" ><span id="nprodSalsPlnY1"/></td>
	  				<td class="alignR" ><span id="nprodSalsCurY1"/></td>
	  				<td class="alignR" ><span id="nprodSalsPlnY2"/></td>
	  				<td class="alignR" ><span id="nprodSalsCurY2"/></td>
	  				<td class="alignR" ></td>
	  				<td class="alignR" ></td>
	  				<td class="alignR" ></td>
	  				<td class="alignR" ></td>
	  			</tr>
	  			<tr id="trbizPrftPln" >
	  				<th>영업이익(억원)</th>
	  				<td class="alignR" ><span id="bizPrftPlnY"/></td>
	  				<td class="alignR" ><span id="bizPrftCurY"/></td>
	  				<td class="alignR" ><span id="bizPrftPlnY1"/></td>
	  				<td class="alignR" ><span id="bizPrftCurY1"/></td>
	  				<td class="alignR" ><span id="bizPrftPlnY2"/></td>
	  				<td class="alignR" ><span id="bizPrftCurY2"/></td>
	  				<td class="alignR" ></td>
	  				<td class="alignR" ></td>
	  				<td class="alignR" ></td>
	  				<td class="alignR" ></td>
	  			</tr>
				<tr id="trPtcCpsnHead" >
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
	  			<tr id="trPtcCpsn" >
	  				<th>투입인원(명)</th>
	  				<td class="alignR" ><span id="ptcCpsnY"/></td>
	  				<td class="alignR" ><span id="ptcCpsnCurY"/></td>
	  				<td class="alignR" ><span id="ptcCpsnY1"/></td>
	  				<td class="alignR" ><span id="ptcCpsnCurY1"/></td>
	  				<td class="alignR" ><span id="ptcCpsnY2"/></td>
	  				<td class="alignR" ><span id="ptcCpsnCurY2"/></td>
	  				<td class="alignR" ><span id="ptcCpsnY3"/></td>
	  				<td class="alignR" ><span id="ptcCpsnCurY3"/></td>
	  				<td class="alignR" ><span id="ptcCpsnY4"/></td>
	  				<td class="alignR" ><span id="ptcCpsnCurY4"/></td>
	  			</tr>
	  			<tr id="trExpArsl" >
	  				<th>투입비용(억원)</th>
	  				<td class="alignR" ><span id="expArslY" /></td>
	  				<td class="alignR" ><span id="expArslCurY"/></td>
	  				<td class="alignR" ><span id="expArslY1"/></td>
	  				<td class="alignR" ><span id="expArslCurY1"/></td>
	  				<td class="alignR" ><span id="expArslY2"/></td>
	  				<td class="alignR" ><span id="expArslCurY2"/></td>
	  				<td class="alignR" ><span id="expArslY3"/></td>
	  				<td class="alignR" ><span id="expArslCurY3"/></td>
	  				<td class="alignR" ><span id="expArslY4"/></td>
	  				<td class="alignR" ><span id="expArslCurY4"/></td>
	  			</tr>
			</tbody>
		</table>
		<table class="table table_txt_right">
			<colgroup>
				<col style="width: 20%;" />
				<col style="width: 30%;" />
				<col style="width: 20%;" />
				<col style="width: 30%;" />
			</colgroup>
			<tbody>
				<tr id="trEv" style="display:none;">
					<th align="right"><span style="color:red;">* </span>평가표 선택</th>
					<td colspan="4"><span id="grsEvSnNm"/></td>
				</tr>
			</tbody>
		</table>
		<div id="evTableGrid" style="margin-top: 20px"></div>
  	</form>
	  	</div>
	  	<div class="titArea">
		    <div class="LblockButton">
		        <button type="button" id="butCancel" onClick="fncCancel();">닫기</button>
		    </div>
		</div>  
  	</div>		
</div>  
</body>
</html>


