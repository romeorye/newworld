<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*,
				 java.util.*,
				 devonframe.util.NullUtil,
				 devonframe.util.DateUtil"%>

<%--
/*
 *************************************************************************
 * $Id		: spaceRqprDetail4Chrg.jsp
 * @desc    : 평가의뢰서 상세
 *------------------------------------------------------------------------
 * VER	DATE		AUTHOR		DESCRIPTION
 * ---	-----------	----------	-----------------------------------------
 * 1.0  2018.09.03  정현웅		최초생성
 * ---	-----------	----------	-----------------------------------------
 * WINS UPGRADE 2차 프로젝트
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

<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/grid/LGridStatusBar.js"></script>
<link rel="stylesheet" type="text/css" href="<%=ruiPathPlugins%>/ui/grid/LGridStatusBar.css"/>

<script type="text/javascript" src="<%=ruiPathPlugins%>/tab/rui_tab.js"></script>
<link rel="stylesheet" type="text/css" href="<%=ruiPathPlugins%>/tab/rui_tab.css"/>

<style>
 .bgcolor-gray {background-color: #999999}
 .bgcolor-white {background-color: #FFFFFF}
 .L-navset {overflow:hidden;}
</style>

	<script type="text/javascript">

		var callback;
		var spaceRqprDataSet;

		var exatWayDialog;

		var opiId;
		var rqprId = '${inputData.rqprId}';

		Rui.onReady(function() {
            /*******************
             * 변수 및 객체 선언
             *******************/

            var dm = new Rui.data.LDataSetManager();

            dm.on('load', function(e) {
            });

            dm.on('success', function(e) {
                var data = spaceRqprWayCrgrDataSet.getReadData(e);

                if(Rui.isEmpty(data.records[0].resultMsg) == false) {
                    alert(data.records[0].resultMsg);
                }

                if(data.records[0].resultYn == 'Y') {
                	if(data.records[0].cmd == 'saveSpaceRqpr') {
                		;
                	} else if(data.records[0].cmd == 'receipt') {
                    	goSpaceRqprList4Chrg();
                	} else if(data.records[0].cmd == 'deleteSpaceRqprExat') {
                		getSpaceRqprExatList();
                	} else if(data.records[0].cmd == 'saveSpaceRqprRslt') {
                		;
                	} else if(data.records[0].cmd == 'requestRsltApproval') {
                		// guid= B : 신뢰성 분석의뢰, D : 신뢰성 분석완료, E : 공간성능 평가의뢰, G : 공간성능 평가완료 + rqprId
                    	var url = '<%=lghausysPath%>/lgchem/approval.front.document.RetrieveDocumentFormCmd.lgc?appCode=APP00383&approvalLineInform=SUB002&from=iris&guid=G${inputData.rqprId}';

                   		openWindow(url, 'spaceRqprCompleteApprovalPop', 800, 500, 'yes');
                	}
                }
            });

    	    /* 평가결과 */
    	    var spaceRsltSbc = new Rui.ui.form.LTextArea({
                applyTo: 'spaceRsltSbc',
                emptyValue: '',
                width: 970,
                height: 175
            });

            var tabView = new Rui.ui.tab.LTabView({
                tabs: [ {
                        active: true,
                        label: '의뢰정보',
                        id: 'spaceRqprInfoDiv'
                    }, {
                    	label: '평가결과',
                        id: 'spaceRqprResultDiv'
                    }, {
                        label: '의견<span id="opinitionCnt"/>',
                        id: 'spaceRqprOpinitionDiv'
                    }, {
                        label: '의견 피드백',
                        id: 'spaceRqprOpinitionFbDiv'
                    }]
            });


            /********************
             * 버튼 및 이벤트 처리와 랜더링
             ********************/

           tabView.on('canActiveTabChange', function(e){

	            switch(e.activeIndex){
	            case 0:

	                break;

	            case 1:

	            	if('03|05|06|07|08'.indexOf(spaceRqprDataSet.getNameValue(0, 'spaceAcpcStCd')) == -1) {
	            		return false;
	            	}

	                break;

	            case 2:

	                break;

	            case 3:

	                break;

	            default:
	                break;
	            }
            });

            tabView.on('activeTabChange', function(e){

                switch(e.activeIndex){
                case 0:
                    break;

                case 1:
                    if(e.isFirst){
                    }

                    break;

                case 2:
                    if(e.isFirst){
                    }

                    break;

                case 3:
                    if(e.isFirst){
                    }

                    break;

                default:
                    break;
                }

            });

            tabView.render('tabView');



            var textBox = new Rui.ui.form.LTextBox({
                emptyValue: ''
            });

            var numberBox = new Rui.ui.form.LNumberBox({
                emptyValue: '',
                minValue: 0,
                maxValue: 99999
            });

            /* 평가명 */
            var spaceNm = new Rui.ui.form.LTextBox({
            	applyTo: 'spaceNm',
                placeholder: '',
                defaultValue: '',
                emptyValue: '',
                width: 390
            });
			/*평가상세*/
            var spaceSbc = new Rui.ui.form.LTextArea({
                applyTo: 'spaceSbc',
                placeholder: '',
                emptyValue: '',
                width: 980,
                height: 75
            });
            /* 평가목적 */
        	var spaceScnCd = new Rui.ui.form.LCombo({
                applyTo: 'spaceScnCd',
                name: 'spaceScnCd',
                emptyText: '선택',
                defaultValue: '',
                emptyValue: '',
                width: 110,
                url: '<c:url value="/common/code/retrieveCodeListForCache.do?comCd=SPACE_SCN_CD"/>',
                displayField: 'COM_DTL_NM',
                valueField: 'COM_DTL_CD'
            });
			/* 완료예정일 */
            var cmplParrDt = new Rui.ui.form.LDateBox({
				applyTo: 'cmplParrDt',
				mask: '9999-99-99',
				displayValue: '%Y-%m-%d',
				defaultValue: '',
				editable: false,
				width: 100,
				dateType: 'string'
			});

            /* WBS 팝업 설정*/
            var spaceRqprWbsCd = new Rui.ui.form.LPopupTextBox({
            	applyTo: 'spaceRqprWbsCd',
                placeholder: '',
                defaultValue: '',
                emptyValue: '',
                editable: false,
                width: 200
            });
            spaceRqprWbsCd.on('popup', function(e){
            	openWbsCdSearchDialog(setSpaceWbsCd);
            });
			/* 긴급유무 */
            var spaceUgyYn = new Rui.ui.form.LCombo({
                applyTo: 'spaceUgyYn',
                name: 'spaceUgyYn',
                emptyText: '선택',
                defaultValue: '',
                emptyValue: '',
                width: 110,
                url: '<c:url value="/common/code/retrieveCodeListForCache.do?comCd=ANL_UGY_YN"/>',
                displayField: 'COM_DTL_NM',
                valueField: 'COM_DTL_CD'
            });
			/* 공개범위 */
			var oppbScpCd = new Rui.ui.form.LCombo({
                applyTo: 'oppbScpCd',
                name: 'oppbScpCd',
                emptyText: '선택',
                defaultValue: '',
                emptyValue: '',
                width: 80,
                url: '<c:url value="/common/code/retrieveCodeListForCache.do?comCd=OPPB_SCP_CD"/>',
                displayField: 'COM_DTL_NM',
                valueField: 'COM_DTL_CD'
            });
			oppbScpCd.on('changed', function(e) {
            	//비밀사유 초기화 및 hidden
            	if( oppbScpCd.getValue() == 1 ){
            		Rui.get('scrtRson').show();
            	}else{
            		Rui.get('scrtRson').hide();
            		scrtRson.setValue("");
            	}
            });
			/* 비밀사유 */
            var scrtRson = new Rui.ui.form.LTextBox({
            	applyTo: 'scrtRson',
            	placeholder: '',
                defaultValue: '',
                emptyValue: '',
                width: 300
            });
            /* 통보자 팝업 설정*/
            spaceRqprInfmView = new Rui.ui.form.LPopupTextBox({
                applyTo: 'spaceRqprInfmView',
                width: 450,
                editable: false,
                placeholder: '',
                emptyValue: '',
                enterToPopup: true
            });
            spaceRqprInfmView.on('popup', function(e){
            	openUserSearchDialog(setSpaceRqprInfm, 10, spaceRqprDataSet.getNameValue(0, 'infmPrsnIds'), 'space');
            });
            setSpaceRqprInfm = function(userList) {
    	    	var idList = [];
    	    	var nameList = [];

    	    	for(var i=0, size=userList.length; i<size; i++) {
    	    		idList.push(userList[i].saUser);
    	    		nameList.push(userList[i].saName);
    	    	}

    	    	spaceRqprInfmView.setValue(nameList.join(', '));
    	    	spaceRqprDataSet.setNameValue(0, 'infmPrsnIds', idList);
    	    };

            /* 평가대상명 */
            var evSubjNm = new Rui.ui.form.LTextBox({
            	applyTo: 'evSubjNm',
                placeholder: '',
                defaultValue: '',
                emptyValue: '',
                width: 970
            });
            /* 제출처 코드 */
            var sbmpCd = new Rui.ui.form.LCombo({
                applyTo: 'sbmpCd',
                name: 'sbmpCd',
                emptyText: '선택',
                defaultValue: '',
                emptyValue: '',
                width: 120,
                url: '<c:url value="/common/code/retrieveCodeListForCache.do?comCd=SBMP_CD"/>',
                displayField: 'COM_DTL_NM',
                valueField: 'COM_DTL_CD'
            });
            /* 제출처 명*/
            var sbmpNm = new Rui.ui.form.LTextBox({
            	applyTo: 'sbmpNm',
                placeholder: '',
                defaultValue: '',
                emptyValue: '',
                width: 845
            });
            /* 정량지표 */
            var qtasDpst = new Rui.ui.form.LTextBox({
            	applyTo: 'qtasDpst',
                placeholder: '',
                defaultValue: '',
                emptyValue: '',
                width: 390
            });
            /* 정성지표 */
            var qnasDpst = new Rui.ui.form.LTextBox({
            	applyTo: 'qnasDpst',
                placeholder: '',
                defaultValue: '',
                emptyValue: '',
                width: 385
            });
            /* 목표성능 */
            var goalPfmc = new Rui.ui.form.LTextBox({
            	applyTo: 'goalPfmc',
                placeholder: '',
                defaultValue: '',
                emptyValue: '',
                width: 390
            });
            /* 결과지표 */
            var rsltDpst = new Rui.ui.form.LTextBox({
            	applyTo: 'rsltDpst',
                placeholder: '',
                defaultValue: '',
                emptyValue: '',
                width: 385
            });
            /* 평가 cases(개수) */
            var evCases = new Rui.ui.form.LTextBox({
            	applyTo: 'evCases',
                placeholder: '',
                defaultValue: '',
                emptyValue: '',
                width: 390
            });
            /* 평가대상 상세 */
            var evSubjDtl = new Rui.ui.form.LTextBox({
            	applyTo: 'evSubjDtl',
                placeholder: '',
                defaultValue: '',
                emptyValue: '',
                width: 385
            });

            /* T-Cloud 링크*/
            var tCloud = new Rui.ui.form.LTextBox({
            	applyTo: 'tCloud',
                placeholder: '',
                defaultValue: '',
                emptyValue: '',
                width: 10
            });

            spaceRqprDataSet = new Rui.data.LJsonDataSet({
                id: 'spaceRqprDataSet',
                remainRemoved: true,
                lazyLoad: true,
                fields: [
					  { id: 'rqprId'		}	//의뢰ID
					, { id: 'spaceNm'		}	//평가명
					, { id: 'spaceScnCd'	}	//평가목적코드
					, { id: 'spaceSbc'		}	//평가상세
					, { id: 'acpcNo'		}	//접수번호
					, { id: 'rgstNm'		}	//의뢰자
					, { id: 'rqprDeptNm'	}	//부서
					, { id: 'rqprDt'		}	//의뢰일
					, { id: 'acpcDt'		}	//접수일
					, { id: 'acpcDt'		}	//접수일
					, { id: 'spaceUgyYn'	}	//긴급유무코드
					, { id: 'infmPrsnIds'	}	//통보자ID
					, { id: 'oppbScpCd'		}	//공개범위
					, { id: 'spaceRqprWbsCd'}	//wbs코드
					, { id: 'scrtRson'		}
					, { id: 'evSubjNm'		}
					, { id: 'sbmpCd'		}
					, { id: 'sbmpNm'		}
					, { id: 'qtasDpst'		}
					, { id: 'qnasDpst'		}
					, { id: 'goalPfmc'		}
					, { id: 'rsltDpst'		}
					, { id: 'evCases'		}
					, { id: 'evSubjDtl'		}
					, { id: 'tCloud'		}
					, { id: 'spaceRqprInfmView' } //통보자 명
					, { id: 'spaceAcpcStCd'		}
					, { id: 'spaceRsltSbc'	}
					, { id: 'rqprAttcFileId'}
					, { id: 'rsltAttcFileId'}
					, { id: 'cmplParrDt'	}
                ]
            });

            spaceRqprDataSet.on('load', function(e) {
            	//spaceRqprDataSet.setNameValue(0, 'rqprAttcFileId', '');
            	//spaceRqprDataSet.setNameValue(0, 'infmPrsnIds', '');
            	//spaceRqprDataSet.setNameValue(0, 'spaceRqprInfmView', '');

            	var opinitionCnt = spaceRqprDataSet.getNameValue(0, 'opinitionCnt');
            	var spaceRsltSbc = spaceRqprDataSet.getNameValue(0, 'spaceRsltSbc');

            	if(opinitionCnt > 0) {
            		$('#opinitionCnt').html('(' + opinitionCnt + ')');
            	}

            	if(Rui.isEmpty(spaceRsltSbc) == false) {
                	//spaceRqprDataSet.setNameValue(0, 'spaceRsltSbc', spaceRsltSbc.replaceAll('\n', '<br/>'));
            	}

            	if(!Rui.isEmpty(spaceRqprDataSet.getNameValue(0, 'reqItgRdcsId'))) {
            		$('#reqApprStateBtn').show();
            	}

            	//button controll
            	if( spaceRqprDataSet.getNameValue(0, 'spaceAcpcStCd')  == "07" ){
            		 $( '#saveBtn' ).hide();
            		 $( '#approvalBtn' ).hide();
            		 $( '#deleteBtn' ).hide();
            	}

            	if(Rui.isEmpty(spaceRqprDataSet.getNameValue(0, "rsltAttcFileId"))) {
            		spaceRqprDataSet.setNameValue(0, "rsltAttcFileId", '')
            	}

            });

            var spaceRqprOpinitionDataSet = new Rui.data.LJsonDataSet({
                id: 'spaceRqprOpinitionDataSet',
                remainRemoved: true,
                lazyLoad: true,
                fields: [
                	  { id: 'opiId' }
                	, { id: 'rqprId' }
                	, { id: 'rgstId' }
                	, { id: 'rgstNm' }
                	, { id: 'rgstDt' }
					, { id: 'opiSbc' }
					, { id: 'attcFilId' }
					, { id: 'opiId' }
					, { id: 'userYn' }
                ]
            });

            spaceRqprOpinitionDataSet.on('load', function(e) {
            	var cnt = spaceRqprOpinitionDataSet.getCount();

            	parent.$("#opinitionCnt").html(cnt == 0 ? '' : '(' + cnt + ')');
   	      	});

            var spaceRqprOpinitionColumnModel = new Rui.ui.grid.LColumnModel({
            	autoWidth:true
                ,columns: [
                	  { field: 'rgstNm',		label: '작성자',		sortable: false,	align:'center',	width: 100 }
                    , { field: 'rgstDt',		label: '작성일',		sortable: false,	align:'center',	width: 100 }
                    , { field: 'opiSbc',		label: '의견',		sortable: false,	align:'left',	width: 800,
                    	renderer: function(val, p, record, row, col) {
                    		var splitVal = val.split('\n');
                    		if(splitVal.length<=1){
                    			var rtnStr="";
                        		for(var j=0;j<splitVal.length;j++){
                        			var k=0;
    	                    		for(var i=0;i<splitVal[j].length;i++){
    	                    			if(i%66==0&&i!=0){
    	                    				rtnStr+='\n';

    	                    			}
    	                    			rtnStr+=splitVal[j].charAt(i);
    	                    		}
                        		}
                    			val=rtnStr;
                    		}

                    		return val.replaceAll('\n', '<br/>');
                    } }
                    , { id: 'attachDownBtn',  label: '첨부파일',  width: 65 ,
  		  	    	  renderer: function(val, p, record, row, i){
  		  	    		  var recordFilId = nullToString(record.data.attcFilId);
  		  	    		  var strBtnFun = "openAttachFileDialog(setAttachFileInfo, "+recordFilId+", 'spacedPolicy', '*' ,'R')";
  		  	    			if(record.get('attcFilId').length<1){
  		  	    				return '';
	  	    				}else{
	  	    					return '<button type="button"  class="L-grid-button" onclick="'+strBtnFun+'">다운로드</button>';
	  	    				}
                        }}
                    , { field: 'attcFilId',	hidden : true}
                    , { field: 'opiId',	hidden : true}
                    , { field: 'userYn',	hidden : true}
                ]
            });

            var spaceRqprOpinitionGrid = new Rui.ui.grid.LGridPanel({
                columnModel: spaceRqprOpinitionColumnModel,
                dataSet: spaceRqprOpinitionDataSet,
                width: 980,
                height: 380,
                autoToEdit: true,
                autoWidth: true,
                autoHeight: true
            });

            spaceRqprOpinitionGrid.render('spaceRqprOpinitionGrid');

            spaceRqprOpinitionGrid.on('dblclick', function() {
            	opinitionUpdate();
            });

            /* 의뢰정보 데이터 바인드 */
            bind = new Rui.data.LBind({
                groupId: 'spaceRqprInfoDiv',
                dataSet: spaceRqprDataSet,
                bind: true,
                bindInfo: [
					{ id: 'rqprId',				ctrlId: 'rqprId',			value:'value'},
					{ id: 'spaceNm',			ctrlId: 'spaceNm',			value:'value'},
                    { id: 'spaceScnCd',			ctrlId: 'spaceScnCd',		value:'value'},
                    { id: 'spaceSbc',		 	ctrlId: 'spaceSbc',		 	value:'value'},
                    { id: 'rgstNm',		 		ctrlId: 'rgstNm',		 	value:'html'},	//의뢰자
                    { id: 'acpcNo',		 		ctrlId: 'acpcNo',		 	value:'html'},	//접수번호
                    { id: 'rqprDeptNm',		 	ctrlId: 'rqprDeptNm',		value:'html'},	//부서
                    { id: 'rqprDt',		 		ctrlId: 'rqprDt',		 	value:'html'},	//의뢰일
                    { id: 'acpcDt',		 		ctrlId: 'acpcDt',		 	value:'html'},	//접수일
                    { id: 'spaceUgyYn',			ctrlId: 'spaceUgyYn',		value:'value'},
                    { id: 'infmPrsnIds',		ctrlId: 'infmPrsnIds',		value:'value'},
                    { id: 'oppbScpCd',			ctrlId: 'oppbScpCd',		value:'value'},
                    { id: 'spaceRqprWbsCd',		ctrlId: 'spaceRqprWbsCd',	value:'value'},
                    { id: 'scrtRson',			ctrlId: 'scrtRson',			value:'value'},
                    { id: 'spaceRqprInfmView',	ctrlId: 'spaceRqprInfmView',value:'value'},
                    { id: 'evSubjNm',			ctrlId: 'evSubjNm',			value:'value'},
                    { id: 'sbmpCd',				ctrlId: 'sbmpCd',			value:'value'},
                    { id: 'sbmpNm',				ctrlId: 'sbmpNm',			value:'value'},
                    { id: 'qtasDpst',			ctrlId: 'qtasDpst',			value:'value'},
                    { id: 'qnasDpst',		 	ctrlId: 'qnasDpst',		 	value:'value'},
                    { id: 'goalPfmc',		 	ctrlId: 'goalPfmc',		 	value:'value'},
                    { id: 'rsltDpst',		 	ctrlId: 'rsltDpst',		 	value:'value'},
                    { id: 'evCases',			ctrlId: 'evCases',			value:'value'},
                    { id: 'evSubjDtl',		 	ctrlId: 'evSubjDtl',		value:'value'},
                    { id: 'tCloud',		 		ctrlId: 'tCloud',		 	value:'value'},
                    { id: 'spaceAcpcStCd',		ctrlId: 'spaceAcpcStCd',	value:'value'},
                    { id: 'cmplParrDt',			ctrlId: 'cmplParrDt',		value:'value'}
                ]
            });

            opinitionBind = new Rui.data.LBind({
                groupId: 'spaceRqprOpinitionDiv',
                dataSet: spaceRqprOpinitionDataSet,
                bind: true,
                bindInfo: [
                    { id: 'rgstNm',				ctrlId:'rgstNm',				value:'html'},
                    { id: 'rgstDt',				ctrlId:'rgstDt',			value:'html'},
                    { id: 'opiSbc',				ctrlId:'opiSbc',		value:'html'}
                ]
            });

            /* 평가결과 데이터 바인드 */
            resultBind = new Rui.data.LBind({
                groupId: 'spaceRqprResultDiv',
                dataSet: spaceRqprDataSet,
                bind: true,
                bindInfo: [
                    { id: 'spaceNm',			ctrlId:'spaceNm',			value:'html'},
                    { id: 'acpcNo',				ctrlId:'acpcNo',			value:'html'},
                    { id: 'cmplParrDt',			ctrlId:'cmplParrDt',		value:'html'},
                    { id: 'cmplDt',				ctrlId:'cmplDt',			value:'html'},
                    { id: 'spaceRsltSbc',		ctrlId:'spaceRsltSbc',		value:'value'}
                ]
            });


			/********** 평가방법 설정 **********/
			// 평가카테고리 combo 설정
			var evCtgrCombo = new Rui.ui.form.LCombo({
                rendererField: 'value',
                autoMapping: true,
                url: '<c:url value="/common/code/retrieveCodeListForCache.do?comCd=SPACE_EV_CTGR"/>',
                displayField: 'COM_DTL_NM',
                valueField: 'COM_DTL_CD'
            });

			// 평가항목 combo 설정
			var evPrvsCombo = new Rui.ui.form.LCombo({
                rendererField: 'value',
                autoMapping: true,
                url: '<c:url value="/common/code/retrieveCodeListForCache.do?comCd=SPACE_EV_PRVS"/>',
                displayField: 'COM_DTL_NM',
                valueField: 'COM_DTL_CD'
            });



            //평가방법 / 담당자 데이터셋
            var spaceRqprWayCrgrDataSet = new Rui.data.LJsonDataSet({
                id: 'spaceRqprWayCrgrDataSet',
                remainRemoved: true,
                lazyLoad: true,
                fields: [
                	  { id: 'crgrId', defaultValue: '' }
                	, { id: 'rqprId', defaultValue: '' }
					, { id: 'evCtgr' }
					, { id: 'evPrvs' }
					, { id: 'infmPrsnId' }
					, { id: 'infmPrsnNm' }

                ]
            });

			//평가방법 / 담당자 그리드
            var spaceRqprWayCrgrColumnModel = new Rui.ui.grid.LColumnModel({
                columns: [
                	  new Rui.ui.grid.LSelectionColumn()
                    , new Rui.ui.grid.LNumberColumn()
                	, { field: 'evCtgr',		label: '<span style="color:red;">* </span>평가카테고리',	sortable: false,	editable: false, editor: evCtgrCombo,	align:'center',	width: 400}
                	, { field: 'evPrvs',		label: '<span style="color:red;">* </span>평가항목',		sortable: false,	editable: false, editor: evPrvsCombo,	align:'center',	width: 400 }
                	, { field: 'infmPrsnId',	label: '<span style="color:red;">* </span>담당자ID',		sortable: false,	editable: false,	align:'center',	width: 300 , hidden:true}
                    , { field: 'infmPrsnNm',	label: '<span style="color:red;">* </span>담당자',		sortable: false,	editable: false,	align:'center',	width: 300 }
                ]
            });
            var spaceRqprWayCrgrGrid = new Rui.ui.grid.LGridPanel({
                columnModel: spaceRqprWayCrgrColumnModel,
                dataSet: spaceRqprWayCrgrDataSet,
                width: 700,
                height: 200,
                autoToEdit: true,
                autoWidth: true
            });
            spaceRqprWayCrgrGrid.render('spaceRqprWayCrgrGrid');


			// 평가 방법 / 담당자 선택팝업 시작
		    spaceChrgListDialog = new Rui.ui.LFrameDialog({
		        id: 'spaceChrgListDialog',
		        title: '평가담당자(Working Day, W:Week)',
		        width: 1100,
		        height: 530,
		        modal: true,
		        visible: false,
		        buttons: [
		            { text:'닫기', isDefault: true, handler: function() {
		            	this.cancel();
		            } }
		        ]
		    });

		    spaceChrgListDialog.render(document.body);

			openSpaceChrgListDialog = function(f) {
				_callback = f;

				spaceChrgListDialog.setUrl('<c:url value="/space/spaceChrgDialog.do"/>');
				spaceChrgListDialog.show();
			};

			//평가방법/담당자 리턴
			setSpaceChrgInfo = function(spaceChrgInfo) {
				//alert(spaceChrgInfo.spaceEvCtgr +" : "+ spaceChrgInfo.spaceEvPrvs +" : "+ spaceChrgInfo.id +" : "+ spaceChrgInfo.name);
				spaceRqprWayCrgrDataSet.newRecord();
            	spaceRqprWayCrgrDataSet.setNameValue(spaceRqprWayCrgrDataSet.getRow(), 'evCtgr', spaceChrgInfo.spaceEvCtgr);
            	spaceRqprWayCrgrDataSet.setNameValue(spaceRqprWayCrgrDataSet.getRow(), 'evPrvs', spaceChrgInfo.spaceEvPrvs);
            	spaceRqprWayCrgrDataSet.setNameValue(spaceRqprWayCrgrDataSet.getRow(), 'infmPrsnId', spaceChrgInfo.id);
            	spaceRqprWayCrgrDataSet.setNameValue(spaceRqprWayCrgrDataSet.getRow(), 'infmPrsnNm', spaceChrgInfo.name);
            };
			// 평가 담당자 선택팝업 끝


			/***** 제품군 선택 *****/
			//사업부
            var spaceEvBzdvDataSet = new Rui.data.LJsonDataSet({
                id: 'spaceEvBzdvDataSet',
                remainRemoved: true,
                lazyLoad: true,
                fields: [
                   { id: 'ctgrCd' }
                 , { id: 'ctgrNm' }
                ]
            });
            //제품군
            var spaceEvProdClDataSet = new Rui.data.LJsonDataSet({
                id: 'spaceEvProdClDataSet',
                remainRemoved: true,
                lazyLoad: true,
                fields: [
                   { id: 'ctgrCd' }
                 , { id: 'ctgrNm' }
                ]
            });
            //분류
            var spaceEvClDataSet = new Rui.data.LJsonDataSet({
                id: 'spaceEvClDataSet',
                remainRemoved: true,
                lazyLoad: true,
                fields: [
                   { id: 'ctgrCd' }
                 , { id: 'ctgrNm' }
                ]
            });
            //제품
            var spaceEvProdDataSet = new Rui.data.LJsonDataSet({
                id: 'spaceEvProdDataSet',
                remainRemoved: true,
                lazyLoad: true,
                fields: [
                   { id: 'ctgrCd' }
                 , { id: 'ctgrNm' }
                ]
            });

            //combo
            /*사업부 조회*/
            spaceEvBzdvDataSet.load({
                url: '<c:url value="/space/spaceEvBzdvList.do"/>'
            });

            var cmbCtgr0Cd = new Rui.ui.form.LCombo({
                applyTo: 'cmbCtgr0Cd',
                name: 'cmbCtgr0Cd',
                emptyText: '사업부 선택',
                defaultValue: '',
                emptyValue: '',
                width: 200,
                dataSet: spaceEvBzdvDataSet,
                displayField: 'ctgrNm',
                valueField: 'ctgrCd'
            });

            cmbCtgr0Cd.on('changed', function(e) {
            	//제품군 초기화
            	spaceEvProdClDataSet.clearData();
            	//분류 초기화
            	spaceEvClDataSet.clearData();
                var selectctgr0Cd = cmbCtgr0Cd.getValue();
                spaceEvProdClDataSet.load({
                	url: '<c:url value="/space/spaceEvProdClList.do"/>',
                    params :{ supiCd:selectctgr0Cd }
                });
            });
            /*사업부 조회 끝*/

            /*제품군 조회*/
            var cmbCtgr1Cd = new Rui.ui.form.LCombo({
                applyTo: 'cmbCtgr1Cd',
                name: 'cmbCtgr1Cd',
                emptyText: '제품군 선택',
                defaultValue: '',
                emptyValue: '',
                width: 200,
                dataSet: spaceEvProdClDataSet,
                displayField: 'ctgrNm',
                valueField: 'ctgrCd'
            });

            cmbCtgr1Cd.on('changed', function(e) {
            	//분류 초기화
            	spaceEvClDataSet.clearData();
                var selectctgr1Cd = cmbCtgr1Cd.getValue();
                spaceEvClDataSet.load({
                	url: '<c:url value="/space/spaceEvClList.do"/>',
                    params :{ supiCd:selectctgr1Cd }
                });
            });
            /*제품군 조회 끝*/

            /*분류 조회*/
            var cmbCtgr2Cd = new Rui.ui.form.LCombo({
                applyTo: 'cmbCtgr2Cd',
                name: 'cmbCtgr2Cd',
                emptyText: '분류 선택',
                defaultValue: '',
                emptyValue: '',
                width: 200,
                dataSet: spaceEvClDataSet,
                displayField: 'ctgrNm',
                valueField: 'ctgrCd'
            });

            cmbCtgr2Cd.on('changed', function(e) {
            	//분류 초기화
            	spaceEvProdDataSet.clearData();
                var selectctgr2Cd = cmbCtgr2Cd.getValue();
                spaceEvProdDataSet.load({
                	url: '<c:url value="/space/spaceEvProdList.do"/>',
                    params :{ supiCd:selectctgr2Cd }
                });
            });
            /*분류 조회 끝*/

            /*제품 조회*/
            var cmbCtgr3Cd = new Rui.ui.form.LCombo({
                applyTo: 'cmbCtgr3Cd',
                name: 'cmbCtgr3Cd',
                emptyText: '제품 선택',
                defaultValue: '',
                emptyValue: '',
                width: 200,
                dataSet: spaceEvProdDataSet,
                displayField: 'ctgrNm',
                valueField: 'ctgrCd'
            });
            /*제품 조회 끝*/

            //제품군 그리드 데이터셋
            var spaceRqprProdDataSet = new Rui.data.LJsonDataSet({
                id: 'spaceRqprProdDataSet',
                remainRemoved: false,
                lazyLoad: true,
                fields: [
                	  { id: 'evCtgr0' }
                	, { id: 'evCtgr1' }
					, { id: 'evCtgr2' }
					, { id: 'evCtgr3' }
					, { id: 'evCtgr0Nm' }
					, { id: 'evCtgr1Nm' }
					, { id: 'evCtgr2Nm' }
					, { id: 'evCtgr3Nm' }
					, { id: 'evCtgrNm' }
                ]
            });
            //제품군 그리드 설정
            var spaceRqprProdColumnModel = new Rui.ui.grid.LColumnModel({
                columns: [
                	  new Rui.ui.grid.LSelectionColumn()
                    , new Rui.ui.grid.LNumberColumn()
                	, { field: 'evCtgr0',	label: 'evCtgr0',	sortable: false,	editable: false, editor: textBox,	align:'center',	width: 100,	hidden:true }
                	, { field: 'evCtgr1',	label: 'evCtgr1',	sortable: false,	editable: false, editor: textBox,	align:'center',	width: 100,	hidden:true }
                	, { field: 'evCtgr2',	label: 'evCtgr2',	sortable: false,	editable: false, editor: textBox,	align:'center',	width: 100,	hidden:true }
                    , { field: 'evCtgr3',	label: 'evCtgr3',	sortable: false,	editable: false, editor: textBox,	align:'center',	width: 100,	hidden:true }

                    , { field: 'evCtgr0Nm',	label: '<span style="color:red;">* </span>사업부',	sortable: false,	editable: false, editor: textBox,	align:'center',	width: 250 }
                	, { field: 'evCtgr1Nm',	label: '<span style="color:red;">* </span>제품군',	sortable: false,	editable: false, editor: textBox,	align:'center',	width: 250 }
                	, { field: 'evCtgr2Nm',	label: '<span style="color:red;">* </span>분류',		sortable: false,	editable: false, editor: textBox,	align:'center',	width: 250 }
                    , { field: 'evCtgr3Nm',	label: '<span style="color:red;">* </span>제품',		sortable: false,	editable: false, editor: textBox,	align:'center',	width: 250 }
                    , { field: 'evCtgrNm',	label: '제품명(직접입력)',							sortable: false,	editable: true,	 editor: textBox,	align:'left',	width: 250 }
                ]
            });
            var spaceRqprProdGrid = new Rui.ui.grid.LGridPanel({
                columnModel: spaceRqprProdColumnModel,
                dataSet: spaceRqprProdDataSet,
                width: 700,
                height: 200,
                autoToEdit: true,
                autoWidth: true
            });
            spaceRqprProdGrid.render('spaceRqprProdGrid');

			/* 제품군 추가 */
			addSpaceRqprProd = function() {

				if (cmbCtgr0Cd.getValue() == ""){
					alert("사업부를 선택해 주세요.");
					return;
				}else if (cmbCtgr1Cd.getValue() == ""){
					alert("제품군을 선택해 주세요.");
					return;
				}else if (cmbCtgr2Cd.getValue() == ""){
					alert("분류를 선택해 주세요.");
					return;
				}else if (cmbCtgr3Cd.getValue() == ""){
					alert("제품을 선택해 주세요.");
					return;
				}

				spaceRqprProdDataSet.newRecord();

            	spaceRqprProdDataSet.setNameValue(spaceRqprProdDataSet.getRow(), 'evCtgr0', cmbCtgr0Cd.getValue());
            	spaceRqprProdDataSet.setNameValue(spaceRqprProdDataSet.getRow(), 'evCtgr1', cmbCtgr1Cd.getValue());
            	spaceRqprProdDataSet.setNameValue(spaceRqprProdDataSet.getRow(), 'evCtgr2', cmbCtgr2Cd.getValue());
            	spaceRqprProdDataSet.setNameValue(spaceRqprProdDataSet.getRow(), 'evCtgr3', cmbCtgr3Cd.getValue());

            	spaceRqprProdDataSet.setNameValue(spaceRqprProdDataSet.getRow(), 'evCtgr0Nm', cmbCtgr0Cd.getDisplayValue());
            	spaceRqprProdDataSet.setNameValue(spaceRqprProdDataSet.getRow(), 'evCtgr1Nm', cmbCtgr1Cd.getDisplayValue());
            	spaceRqprProdDataSet.setNameValue(spaceRqprProdDataSet.getRow(), 'evCtgr2Nm', cmbCtgr2Cd.getDisplayValue());
            	spaceRqprProdDataSet.setNameValue(spaceRqprProdDataSet.getRow(), 'evCtgr3Nm', cmbCtgr3Cd.getDisplayValue());

            };

            /* 제품군 삭제 */
            deleteSpaceRqprProd = function() {
                if(spaceRqprProdDataSet.getMarkedCount() > 0) {
                	spaceRqprProdDataSet.removeMarkedRows();
                } else {
                	alert('삭제 대상을 선택해주세요.');
                }
            };
            /*****제품군 선택 끝*****/




            var spaceRqprRltdDataSet = new Rui.data.LJsonDataSet({
                id: 'spaceRqprRltdDataSet',
                remainRemoved: true,
                lazyLoad: true,
                fields: [
					  { id: 'rltdId' }
					, { id: 'rqprId' }
					, { id: 'preRqprId' }
					, { id: 'preSpaceNm' }
					, { id: 'preAcpcNo' }
					, { id: 'preSpaceChrgNm' }
					, { id: 'preRgstId' }
					, { id: 'preRgstNm' }
                ]
            });

            var spaceRqprRltdColumnModel = new Rui.ui.grid.LColumnModel({
                columns: [
                	  new Rui.ui.grid.LSelectionColumn()
                	, new Rui.ui.grid.LStateColumn()
                	, new Rui.ui.grid.LNumberColumn()
                    , { field: 'preAcpcNo',			label: '접수번호',	sortable: false,	align:'center',	width: 80 }
                    , { field: 'preSpaceNm',		label: '평가명',		sortable: false,	align:'left',	width: 300 }
                    , { field: 'preRgstNm',			label: '의뢰자',		sortable: false,	align:'center',	width: 80 }
                    , { field: 'preSpaceChrgNm',	label: '평가담당자',	sortable: false,	align:'center',	width: 80 }
                    , { field: 'rqprId',	hidden:true }
                    , { field: 'preRqprId',	hidden:true }
                ]
            });

            var spaceRqprRltdGrid = new Rui.ui.grid.LGridPanel({
                columnModel: spaceRqprRltdColumnModel,
                dataSet: spaceRqprRltdDataSet,
                width: 540,
                height: 200,
                autoToEdit: false,
                autoWidth: true
            });

            spaceRqprRltdGrid.render('spaceRqprRltdGrid');

            spaceRqprRltdGrid.on('cellClick', function(e) {
            	 var record = spaceRqprRltdDataSet.getAt(spaceRqprRltdDataSet.getRow());
                 //var params = "?rqprId="+record.get("rqprId");
                 var params = "?rqprId="+record.get("preRqprId");

                 spaceRqprRltdDialog.setUrl('<c:url value="/space/spaceRqprSrchView.do"/>'+params);
                 spaceRqprRltdDialog.show(true);
            });

          	//관련평가 상세 이관
         	var spaceRqprRltdDialog = new Rui.ui.LFrameDialog({
    	        id: 'spaceRqprRltdDialog',
    	        title: '관련평가',
    	        width:  1000,
    	        height: 600,
    	        modal: true,
    	        visible: false
    	    });

         	spaceRqprRltdDialog.render(document.body);


            var spaceRqprAttachDataSet = new Rui.data.LJsonDataSet({
                id: 'spaceRqprAttachDataSet',
                remainRemoved: true,
                lazyLoad: true,
                fields: [
					  { id: 'attcFilId'}
					, { id: 'seq' }
					, { id: 'filNm' }
					, { id: 'filSize' }
                ]
            });

            var spaceRqprAttachColumnModel = new Rui.ui.grid.LColumnModel({
                columns: [
                      new Rui.ui.grid.LNumberColumn()
                    , { field: 'filNm',		label: '파일명',		sortable: false,	align:'left',	width: 510 }
                ]
            });

            var spaceRqprAttachGrid = new Rui.ui.grid.LGridPanel({
                columnModel: spaceRqprAttachColumnModel,
                dataSet: spaceRqprAttachDataSet,
                width: 300,
                height: 200,
                autoToEdit: false,
                autoWidth: true
            });

            spaceRqprAttachGrid.on('cellClick', function(e) {
                if(e.colId == "filNm") {
                	downloadAttachFile(spaceRqprAttachDataSet.getAt(e.row).data.attcFilId, spaceRqprAttachDataSet.getAt(e.row).data.seq);
                }
            });

            spaceRqprAttachGrid.render('spaceRqprAttachGrid');

    	    // 첨부파일 정보 설정
    	    setSpaceRqprAttach = function(attachFileList) {
    	    	spaceRqprAttachDataSet.clearData();

    	    	if(attachFileList.length > 0) {
    	    		spaceRqprDataSet.setNameValue(0, 'rqprAttcFileId', attachFileList[0].data.attcFilId);

        	    	for(var i=0; i<attachFileList.length; i++) {
        	    		spaceRqprAttachDataSet.add(attachFileList[i]);
        	    	}
    	    	}
    	    };

			downloadAttachFile = function(attcFilId, seq) {
				fileDownloadForm.action = '<c:url value='/system/attach/downloadAttachFile.do'/>';
				$('#attcFilId', fileDownloadForm).val(attcFilId);
				$('#seq', fileDownloadForm).val(seq);
				fileDownloadForm.submit();
			};

			var spaceRqprRsltAttachDataSet = spaceRqprAttachDataSet.clone('spaceRqprRsltAttachDataSet');

            spaceRqprRsltAttachDataSet.on('load', function(e) {
				for( var i = 0, size = spaceRqprRsltAttachDataSet.getCount(); i < size ; i++ ) {
        	    	$('#rsltAttcFileView').append($('<a/>', {
        	            href: 'javascript:downloadAttachFile("' + spaceRqprRsltAttachDataSet.getAt(i).data.attcFilId + '", "' + spaceRqprRsltAttachDataSet.getAt(i).data.seq + '")',
        	            text: spaceRqprRsltAttachDataSet.getAt(i).data.filNm
        	        })).append('<br/>');
				}
            });

    	    // 평가결과 첨부파일 정보 설정
    	    setSpaceRqprRsltAttach = function(attachFileList) {
    	    	spaceRqprRsltAttachDataSet.clearData();

    	    	if(attachFileList.length > 0) {
    	    		spaceRqprDataSet.setNameValue(0, 'rsltAttcFileId', attachFileList[0].data.attcFilId);

        	    	for(var i=0; i<attachFileList.length; i++) {
        	    		spaceRqprRsltAttachDataSet.add(attachFileList[i]);
        	    	}
    	    	}

    	    	$('#rsltAttcFileView').html('');

    	    	for(var i=0; i<attachFileList.length; i++) {
        	    	$('#rsltAttcFileView').append($('<a/>', {
        	            href: 'javascript:downloadAttachFile("' + attachFileList[i].data.attcFilId + '", "' + attachFileList[i].data.seq + '")',
        	            text: attachFileList[i].data.filNm
        	        })).append('<br/>');
    	    	}
    	    };

    	    /* 평가정보 */
            var spaceRqprExatDataSet = new Rui.data.LJsonDataSet({
                id: 'spaceRqprExatDataSet',
                remainRemoved: false,
                lazyLoad: true,
                fields: [
                	  { id: 'rqprExatId', type: 'number' }
                	, { id: 'rqprId', type: 'number' }
					, { id: 'exatNm' }
					, { id: 'exatCaseQty' }
					, { id: 'exatDct' }
					, { id: 'exatExp' }
					, { id: 'exatWay' }
                ]
            });

            /* 평가정보 */
            var spaceRqprExatColumnModel = new Rui.ui.grid.LColumnModel({
                columns: [
                	  new Rui.ui.grid.LSelectionColumn()
                    , new Rui.ui.grid.LNumberColumn()
                    , { field: 'exatNm',		label: '평가 실험명',		sortable: false,	align:'left',	width: 380 }
                    , { field: 'exatCaseQty',	label: '평가케이스수',	sortable: false,	align:'center',	width: 100 }
                    , { field: 'exatDct',		label: '평가일수',		sortable: false,	align:'center',	width: 80 }
                    , { field: 'exatExp',		label: '수가',			sortable: false,	align:'center',	width: 100, renderer: function(val, p, record, row, col) {
                    	return Rui.util.LNumber.toMoney(val, '') + '원';
                      } }
                    , { field: 'exatWay',		label: '평가방법',		sortable: false,	align:'left',	width: 430 }
                ]
            });

            var spaceRqprExatGrid = new Rui.ui.grid.LGridPanel({
                columnModel: spaceRqprExatColumnModel,
                dataSet: spaceRqprExatDataSet,
                width: 600,
                height: 200,
                autoToEdit: false,
                autoWidth: true
            });

            spaceRqprExatGrid.on('cellClick', function(e) {
            	if(e.col == 0) {
            		return ;
            	}
                if (spaceRqprDataSet.getNameValue(0, 'spaceAcpcStCd') != '03') {
                    //alert('평가진행 상태일때만 실험결과를 수정 할 수 있습니다.');
                    //return false;
                    openexatWayDialog(spaceRqprExatDataSet.getNameValue(e.row, 'rqprExatId'));
                }else{
	            	openSpaceRqprExatRsltDialog(getSpaceRqprExatList, spaceRqprExatDataSet.getNameValue(e.row, 'rqprExatId'));
                }
            });

            spaceRqprExatGrid.render('spaceRqprExatGrid');

            openexatWayDialog = function(rqprExatId) {
    	    	exatWayDialog.setUrl('<c:url value="/space/exatWayPopup.do?rqprId="/>' + spaceRqprDataSet.getNameValue(0, 'rqprId') + '&rqprExatId=' + rqprExatId);
    	    	exatWayDialog.show();
    	    };



    	    // 실험방법 팝업
	       	exatWayDialog = new Rui.ui.LFrameDialog({
	       	        id: 'exatWayDialog',
	       	        title: '실험방법',
	       	        width: 640,
	       	        height: 420,
	       	        modal: true,
	       	        visible: false
	       	 });

	        exatWayDialog.render(document.body);



    	    // 평가의뢰 의견 팝업 시작
    	    spaceRqprOpinitionDialog = new Rui.ui.LFrameDialog({
    	        id: 'spaceRqprOpinitionDialog',
    	        title: '의견 교환',
    	        width: 830,
    	        height: 500,
    	        modal: true,
    	        visible: false
    	    });

    	    spaceRqprOpinitionDialog.render(document.body);

    	    openSpaceRqprOpinitionDialog = function() {
    	    	spaceRqprOpinitionDialog.setUrl('<c:url value="/space/spaceRqprOpinitionPopup.do?rqprId=${inputData.rqprId}"/>');
    	    	spaceRqprOpinitionDialog.show();
    	    };
    	    // 평가의뢰 의견 팝업 끝

    	    // 평가의뢰 반려/평가중단 팝업 시작
    	    spaceRqprEndDialog = new Rui.ui.LFrameDialog({
    	        id: 'spaceRqprEndDialog',
    	        title: '',
    	        width: 550,
    	        height: 300,
    	        modal: true,
    	        visible: false
    	    });

    	    spaceRqprEndDialog.render(document.body);

    	    openSpaceRqprEndDialog = function(type) {
    	    	$('#spaceRqprEndDialog_h').html(type == '반려' ? '평가의뢰 반려' : '평가중단');
    	    	spaceRqprEndDialog.setUrl('<c:url value="/space/spaceRqprEndPopup.do?type="/>' + escape(encodeURIComponent(type)));
    	    	spaceRqprEndDialog.show();
    	    };
    	    // 평가의뢰 반려/평가중단 팝업 끝

    	    // 평가정보 등록/수정 팝업 시작
    	    spaceRqprExatRsltDialog = new Rui.ui.LFrameDialog({
    	        id: 'spaceRqprExatRsltDialog',
    	        title: '평가정보 등록/수정',
    	        width: 740,
    	        height: 580,
    	        modal: true,
    	        visible: false
    	    });

    	    spaceRqprExatRsltDialog.render(document.body);

    	    openSpaceRqprExatRsltDialog = function(f, rqprExatId) {
    	    	callback = f;

    	    	spaceRqprExatRsltDialog.setUrl('<c:url value="/space/spaceRqprExatRsltPopup.do?rqprId="/>' + spaceRqprDataSet.getNameValue(0, 'rqprId') + '&rqprExatId=' + rqprExatId);
    	    	spaceRqprExatRsltDialog.show();
    	    };
    	    // 실험결과 등록/수정 팝업 끝

      	  //의견등록팝업///////////////////////////////////////////
            //의견등록 팝업 저장
            callChildSave = function() {
            	opinitionDialog.getFrameWindow().fnSave();
            }

         	// 의견등록 팝업 시작
			opinitionDialog = new Rui.ui.LFrameDialog({
		        id: 'opinitionDialog',
		        title: '의견 등록',
		        width:  800,
		        height: 700,
		        modal: true,
		        visible: false,
		        buttons : [
		            { text: '저장', handler: callChildSave, isDefault: true },
		            { text:'닫기', handler: function() {
		              	this.cancel(false);
		              }
		            }
		        ]
		    });

			opinitionDialog.render(document.body);

			openOpinitionDialog = function(f) {
		    	_callback = f;
		    	opinitionDialog.setUrl('<c:url value="/space/openAddOpinitionPopup.do"/>');
		    	opinitionDialog.show();
		    };

		    // 등록 버튼
            opinitionSave = function() {
            	opiId="0";
            	openOpinitionDialog(setOpinitionInfo);
            };

            setOpinitionInfo = function(opinitionInfo) {
            }

          //의견수정팝업///////////////////////////////////////////
            //의견수정 팝업 저장
            callChildUpdate = function() {
            	opinitionUpdateDialog.getFrameWindow().fnSave();
            }

            //의견수정 팝업 삭제
            callChildDel = function() {
            	opinitionUpdateDialog.getFrameWindow().fnDel();
            }

         	// 의견수정 팝업 시작
			opinitionUpdateDialog = new Rui.ui.LFrameDialog({
		        id: 'opinitionUpdateDialog',
		        title: '의견 수정',
		        width:  800,
		        height: 700,
		        modal: true,
		        visible: false,
		        buttons : []
		    });

			opinitionUpdateDialog.render(document.body);

			openOpinitionUpdateDialog = function(f) {
				var record = spaceRqprOpinitionDataSet.getAt(spaceRqprOpinitionDataSet.rowPosition);
            	var userYn = record.data.userYn;
				if(userYn=="Y"){
					opinitionUpdateDialog.setButtons([
		            { text: '저장', handler: callChildUpdate, isDefault: true },
		            { text: '삭제', handler: callChildDel, isDefault: true },
		            { text:'닫기', handler: function() {
		              	this.cancel(false);
		              }
		            }
            	       ]);
				}else{
					opinitionUpdateDialog.setButtons([
                	            { text:'닫기', handler: function() {
                	              	this.cancel(false);
                	              }
                	            }
                	      ]);
				}
		    	_callback = f;
		    	opinitionUpdateDialog.setUrl('<c:url value="/space/openAddOpinitionPopup.do"/>');
		    	opinitionUpdateDialog.show();
		    };

		    /* 평가의뢰 의견 리스트 조회 */
            getSpaceRqprOpinitionList = function(msg) {
            	closePop = function(){
            		opinitionDialog.cancel(false);
                	opinitionUpdateDialog.cancel(false);
                	Rui.alert(msg);
            	}
            	spaceRqprOpinitionDataSet.load({
                    url: '<c:url value="/space/getSpaceRqprOpinitionList.do"/>',
                    params :{
                    	rqprId : '${inputData.rqprId}'
                    }
                });
            	if(!Rui.isUndefined(msg)){
	            	closePop();
            	}
            };

            getSpaceRqprOpinitionList();

         	// 수정 버튼
            opinitionUpdate = function() {
         		if(spaceRqprOpinitionDataSet.getCount()<1){
         			alert("선택된 의견이 없습니다.");
         			return;
         		}else{
	            	opiId=spaceRqprOpinitionDataSet.getAt(spaceRqprOpinitionDataSet.rowPosition).data.opiId;
	            	openOpinitionUpdateDialog(setOpinitionUpdateInfo);
         		}
            };

            setOpinitionUpdateInfo = function(opinitionUpdateInfo) {
            }
          //첨부파일 callback
    		setAttachFileInfo = function(attcFilList) {

               /* if(attcFilList.length > 1 ){
            	   alert("첨부파일은 한개만 가능합니다.");
            	   return;
               }else{
    	           $('#atthcFilVw').html('');
               } */

               /* for(var i = 0; i < attcFilList.length; i++) {
                   $('#atthcFilVw').append($('<a/>', {
                       href: 'javascript:downloadAttcFil("' + attcFilList[i].data.attcFilId + '", "' + attcFilList[i].data.seq + '")',
                       text: attcFilList[i].data.filNm
                   })).append('<br/>');
               document.aform.attcFilId.value = attcFilList[i].data.attcFilId;
               dataSet.setNameValue(0, "attcFilId",  document.aform.attcFilId.value);
               } */
           	};
          	//첨부파일 다운로드
            downloadMnalFil = function(attId, seq){
     	       var param = "?attcFilId=" + attId + "&seq=" + seq;
     	       	document.aform.action = '<c:url value='/system/attach/downloadAttachFile.do'/>' + param;
     	       	document.aform.submit();
         	    /*var param = "?attcFilId="+ attId+"&seq="+seq;
     			Rui.getDom('dialogImage').src = '<c:url value="/system/attach/downloadAttachFile.do"/>'+param;
     			Rui.get('imgDialTitle').html('기기이미지');
     			imageDialog.clearInvalid();
     			imageDialog.show(true);*/

            }

          	/////////////////////////////////////////////////
          	//의견 피드백
          	/* 피드백카테고리 */
        	var fbRsltCtgr = new Rui.ui.form.LCombo({
                applyTo: 'fbRsltCtgr',
                name: 'fbRsltCtgr',
                emptyText: '선택',
                defaultValue: '',
                emptyValue: '',
                width: 300,
                url: '<c:url value="/common/code/retrieveCodeListForCache.do?comCd=FB_RSLT_CTGR"/>',
                displayField: 'COM_DTL_NM',
                valueField: 'COM_DTL_CD'
            });

        	/* 피드백내용 */
             var fbRsltSbcTxtArea = new Rui.ui.form.LTextArea({
            	 applyTo: 'fbRsltSbc',
                 editable: true,
                 width: 800,
                 height:100
             });

             /* 피드백과제진행단계구분 */
          	var fbTssPgsStep = new Rui.ui.form.LCombo({
                  applyTo: 'fbTssPgsStep',
                  name: 'fbTssPgsStep',
                  emptyText: '선택',
                  defaultValue: '',
                  emptyValue: '',
                  width: 400,
                  url: '<c:url value="/common/code/retrieveCodeListForCache.do?comCd=FB_TSS_PGS_STEP"/>',
                  displayField: 'COM_DTL_NM',
                  valueField: 'COM_DTL_CD'
              });

             /* 피드백구분 */
         	var fbRsltScn = new Rui.ui.form.LCombo({
                 applyTo: 'fbRsltScn',
                 name: 'fbRsltScn',
                 emptyText: '선택',
                 defaultValue: '',
                 emptyValue: '',
                 width: 300,
                 url: '<c:url value="/common/code/retrieveCodeListForCache.do?comCd=FB_RSLT_SCN"/>',
                 displayField: 'COM_DTL_NM',
                 valueField: 'COM_DTL_CD'
             });

         	/* 피드백 개선요청사항 */
              var fbRsltBttmTxtArea = new Rui.ui.form.LTextArea({
             	 applyTo: 'fbRsltBttm',
                   editable: true,
                   width: 800,
                   height:100
              });

			fbRsltCtgr.on('changed', function(e) {
				if(e.value=="03"){
					fbRsltSbcTxtArea.setValue("");
					fbRsltSbcTxtArea.hide();
					fbTssPgsStep.show();
				}else{
					fbRsltSbcTxtArea.show();
					fbTssPgsStep.hide();
					fbTssPgsStep.setValue("")
				}

            });
			var spaceRqprFbDataSet = new Rui.data.LJsonDataSet({
                id: 'spaceRqprFbDataSet',
                remainRemoved: true,
                lazyLoad: true,
                fields: [
                	  { id: 'rqprId' }
                	, { id: 'fbRsltCtgr'	}
					, { id: 'fbRsltSbc'		}
					, { id: 'fbRsltScn'		}
					, { id: 'fbRsltBttm'	}
					, { id: 'spaceStpt'		}
					, { id: 'fbCmplYn'		}
					, { id: 'fbTssPgsStep'	}
                ]
            });

          	spaceRqprFbBind = new Rui.data.LBind({
                groupId: 'cform',
                dataSet: spaceRqprFbDataSet,
                bind: true,
                bindInfo: [
					{ id: 'rqprId',				ctrlId: 'rqprId',			value:'value'},
                    { id: 'fbRsltCtgr',			ctrlId: 'fbRsltCtgr',		value:'value'},
					{ id: 'fbRsltSbc',			ctrlId: 'fbRsltSbc',		value:'value'},
					{ id: 'fbRsltScn',			ctrlId: 'fbRsltScn',		value:'value'},
					{ id: 'fbRsltBttm',			ctrlId: 'fbRsltBttm',		value:'value'},
					{ id: 'spaceStpt',			ctrlId: 'spaceStpt',		value:'value'},
					{ id: 'fbCmplYn',			ctrlId: 'fbCmplYn',			value:'value'},
					{ id: 'fbTssPgsStep',		ctrlId: 'fbTssPgsStep',		value:'value'}
                ]
            });

			spaceRqprFbDataSet.on('load', function(e) {
				if(spaceRqprFbDataSet.getNameValue(0, 'fbRsltCtgr')=="03"){
					fbRsltSbcTxtArea.hide();
					fbTssPgsStep.show();
				}else{
					fbRsltSbcTxtArea.show();
					fbTssPgsStep.hide();
				}
				fbRsltSbcTxtArea.disable();
				fbTssPgsStep.disable();
				fbRsltCtgr.disable();
				fbRsltScn.disable();
				fbRsltBttmTxtArea.disable();
            });
          	/////////////////////////////////////////////////


            var vm1 = new Rui.validate.LValidatorManager({
                validators:[
                { id: 'spaceNm',		validExp: '평가명:true:maxByteLength=100' },
                { id: 'spaceSbc',		validExp: '평가상세:true' },
                { id: 'spaceScnCd',		validExp: '평가목적:true' },
				{ id: 'cmplParrDt',		validExp: '완료예정일:true:date=YYYY-MM-DD' },
                { id: 'spaceUgyYn',		validExp: '긴급유무:true' },
                { id: 'oppbScpCd',		validExp: '공개범위:true' },
                { id: 'evSubjNm',		validExp: '평가대상명:true:maxByteLength=100' },
				{ id: 'sbmpCd',			validExp: '제출처:true' },
				{ id: 'sbmpNm',			validExp: '제출기관명:true:maxByteLength=100' },
				/* { id: 'qtasDpst',		validExp: '정량지표:true:maxByteLength=100' },
				{ id: 'qnasDpst',		validExp: '정성지표:true:maxByteLength=100' }, */
				{ id: 'goalPfmc',		validExp: '목표성능:true:maxByteLength=100' },
				{ id: 'rsltDpst',		validExp: '결과지표:true:maxByteLength=100' },
				{ id: 'evCases',		validExp: '평가case(개수):true' },
				{ id: 'evSubjDtl',		validExp: '평가대상 상세:true:maxByteLength=100' }
                ]
            });


            /* 유효성 검사 */
    	    isValidate = function(type) {

                if (vm1.validateDataSet(spaceRqprDataSet) == false) {
                    alert(Rui.getMessageManager().get('$.base.msg052') + '\n' + vm1.getMessageList().join('\n'));
                    return false;
                }

                if (spaceRqprWayCrgrDataSet.getCount() == 0) {
                    alert('평가방법을 입력해주세요.');
                    return false;
                } else if (vm1.validateDataSet(spaceRqprWayCrgrDataSet) == false) {
                    alert(Rui.getMessageManager().get('$.base.msg052') + '\n' + vm1.getMessageList().join('\n'));
                    return false;
                }

                if (spaceRqprProdDataSet.getCount() == 0) {
                    alert('제품군을 입력해주세요.');
                    return false;
                } else if (vm1.validateDataSet(spaceRqprProdDataSet) == false) {
                    alert(Rui.getMessageManager().get('$.base.msg052') + '\n' + vm1.getMessageList().join('\n'));
                    return false;
                }

                return true;
    	    }

            /* 저장 */
            saveSpaceRqpr = function() {
    	    	if('02|03'.indexOf(spaceRqprDataSet.getNameValue(0, 'spaceAcpcStCd')) == -1) {
    	    		alert('접수대기, 평가진행 상태일때만 저장 할 수 있습니다.');
    	    		return false;
    	    	}

    	    	if(isValidate()) {
	            	if(confirm('저장 하시겠습니까?')) {
	                    dm.updateDataSet({
	                        dataSets:[spaceRqprDataSet,spaceRqprWayCrgrDataSet,spaceRqprProdDataSet,spaceRqprRltdDataSet],
	                        url:'<c:url value="/space/updateSpaceRqpr.do"/>',
	                        modifiedOnly: false
	                    });
	            	}
    	    	}
            };

            /* 접수 */
            receipt = function() {
    	    	if(spaceRqprDataSet.getNameValue(0, 'spaceAcpcStCd') != '02') {
    	    		alert('접수대기 상태일때만 접수 할 수 있습니다.');
    	    		return false;
    	    	}

            	if (vm1.validateDataSet(spaceRqprDataSet) == false) {
                    alert(Rui.getMessageManager().get('$.base.msg052') + '\n' + vm1.getMessageList().join('\n'));
                    return false;
                }

            	if(confirm('접수 하시겠습니까?')) {
                    dm.updateDataSet({
                        dataSets:[spaceRqprDataSet],
                        url:'<c:url value="/space/receiptSpaceRqpr.do"/>',
                        modifiedOnly: false
                    });
            	}

            };

            /* 접수반려 */
            reject = function() {
                if (spaceRqprDataSet.getNameValue(0, 'spaceAcpcStCd') != '02') {
                    alert('접수대기 상태일때만 반려 할 수 있습니다.');
                    return false;
                }

            	openSpaceRqprEndDialog('반려');
            };


            var vm2 = new Rui.validate.LValidatorManager({
                validators:[
				{ id: 'spaceRsltSbc',	validExp: '평가결과:true' }
                ]
            });

            /* 평가결과 저장 */
            saveSpaceRqprRslt = function() {

    	    	if(spaceRqprDataSet.getNameValue(0, 'spaceAcpcStCd') != '03') {
    	    		alert('평가진행 상태일때만 평가결과를 저장 할 수 있습니다.');
    	    		return false;
    	    	}

   	    		if(confirm('저장 하시겠습니까?')) {
                       dm.updateDataSet({
                           dataSets:[spaceRqprDataSet],
                           url:'<c:url value="/space/saveSpaceRqprRslt.do"/>',
                           modifiedOnly: false
                       });
               	}

            };

            /* 결재의뢰 */
            approval = function() {

    	    	if(spaceRqprDataSet.getNameValue(0, 'spaceAcpcStCd') != '03') {
    	    		alert('평가진행 상태일때만 결재의뢰 할 수 있습니다.');
    	    		return false;
    	    	}

    	    	if (spaceRqprExatDataSet.getCount() == 0) {
                    alert('평가정보를 등록 해 주세요');
                    return false;
                } else if (vm2.validateDataSet(spaceRqprExatDataSet) == false) {
                    alert(Rui.getMessageManager().get('$.base.msg052') + '\n' + vm2.getMessageList().join('\n'));
                    return false;
                }

                if (vm2.validateDataSet(spaceRqprDataSet) == false) {
                    alert(Rui.getMessageManager().get('$.base.msg052') + '\n' + vm2.getMessageList().join('\n'));
                    return false;
                }

               	if($('#rsltAttcFileView').html() == ""){
                   	alert('평가 결과서를 등록해 주시기 바랍니다.');
       	    		return false;
                }

            	if(confirm('결재의뢰 하시겠습니까?')) {
                    dm.updateDataSet({
                        dataSets:[spaceRqprDataSet],
                        url:'<c:url value="/space/requestSpaceRqprRsltApproval.do"/>',
                        modifiedOnly: false
                    });
            	}
            };

            /* 평가중단 */
            stop = function() {
                if ('03|06'.indexOf(spaceRqprDataSet.getNameValue(0, 'spaceAcpcStCd')) == -1) {
                    alert('평가진행, 결과검토 상태일때만 중단 할 수 있습니다.');
                    return false;
                }

            	openSpaceRqprEndDialog('중단');
            };

            /* 실험결과 등록/수정 팝업 */
            addSpaceRqprExat = function() {
                if (spaceRqprDataSet.getNameValue(0, 'spaceAcpcStCd') != '03') {
                    alert('평가진행 상태일때만 실험결과를 등록 할 수 있습니다.');
                    return false;
                }

                openSpaceRqprExatRsltDialog(getSpaceRqprExatList, 0);
            };

            /* 실험결과 삭제 */
            deleteSpaceRqprExat = function() {

				var chkAcpcSt = spaceRqprDataSet.getNameValue(0, 'spaceAcpcStCd');

				if(chkAcpcSt == "06"){
					alert("결과검토 상태는 삭제를 할수없습니다.");
					return false;

				}else if( chkAcpcSt == "07"){
					alert("평가완료 상태는 삭제를 할수없습니다.");
					return false;
				}

                if(spaceRqprExatDataSet.getMarkedCount() > 0) {
                	if(confirm('삭제 하시겠습니까?')) {
                    	spaceRqprExatDataSet.removeMarkedRows();

                        dm.updateDataSet({
                            dataSets:[spaceRqprExatDataSet],
                            url:'<c:url value="/space/deleteSpaceRqprExat.do"/>'
                        });
                	}
                } else {
                	alert('삭제 대상을 선택해주세요.');
                }
            };

            getSpaceRqprExatList = function() {
            	spaceRqprExatDataSet.load({
                    url: '<c:url value="/space/getSpaceRqprExatList.do"/>',
                    params :{
                    	rqprId : '${inputData.rqprId}'
                    }
                });
    	    };

            goSpaceRqprList4Chrg = function() {
    	    	$('#searchForm > input[name=spaceNm]').val(encodeURIComponent($('#searchForm > input[name=spaceNm]').val()));
    	    	$('#searchForm > input[name=rgstNm]').val(encodeURIComponent($('#searchForm > input[name=rgstNm]').val()));
    	    	$('#searchForm > input[name=spaceChrgNm]').val(encodeURIComponent($('#searchForm > input[name=spaceChrgNm]').val()));

    	    	nwinsActSubmit(searchForm, "<c:url value="/space/spaceRqprList4Chrg.do"/>");
    	    };

    	    openApprStatePopup = function(type) {
    	    	var seq = type == 'A' ? spaceRqprDataSet.getNameValue(0, 'reqItgRdcsId') : spaceRqprDataSet.getNameValue(0, 'rsltItgRdcsId');
            	var url = '<%=lghausysPath%>/lgchem/approval.front.approval.RetrieveAppTargetCmd.lgc?seq=' + seq;

           		openWindow(url, 'openApprStatePopup', 800, 250, 'yes');
    	    };

    	    <%-- report 사용안함
    	    openRsltReportPopup = function(type) {
    	    	var width = 1200;
            	var url = '<%=lghausysReportPath%>/spaceRqprReportRslt.jsp?reportMode=HTML&clientURIEncoding=UTF-8&reportParams=skip_decimal_point:true&menu=old&RQPR_ID=<c:out value="${inputData.rqprId}"/>';

            	if(spaceRqprDataSet.getNameValue(0, 'infmTypeCd') == 'T') {
            		width = 850;
            		url = '<%=lghausysReportPath%>/spaceRqprTestRslt.jsp?reportMode=HTML&clientURIEncoding=UTF-8&reportParams=skip_decimal_point:true&menu=old&RQPR_ID=<c:out value="${inputData.rqprId}"/>';
            	}

           		openWindow(url, 'openRsltReportPopup', width, 500, 'yes');
    	    }; --%>

	    	dm.loadDataSet({
                dataSets: 	[spaceRqprDataSet,
							 spaceRqprWayCrgrDataSet,
							 spaceRqprProdDataSet,
							 spaceRqprRltdDataSet,
							 spaceRqprAttachDataSet,
							 spaceRqprRsltAttachDataSet,
							 spaceRqprExatDataSet,
							 spaceRqprFbDataSet],
                url: '<c:url value="/space/getSpaceRqprDetailInfo.do"/>',
                params: {
                    rqprId: '${inputData.rqprId}'
                }
            });


         	// 관련평가 조회 팝업 시작
    	    spaceRqprSearchDialog = new Rui.ui.LFrameDialog({
    	        id: 'spaceRqprSearchDialog',
    	        title: '관련평가 조회',
    	        width: 850,
    	        height: 500,
    	        modal: true,
    	        visible: false
    	    });

    	    spaceRqprSearchDialog.render(document.body);

    	    openSpaceRqprSearchDialog = function(f) {
    	    	callback = f;

    	    	spaceRqprSearchDialog.setUrl('<c:url value="/space/spaceRqprSearchPopup.do"/>');
    		    spaceRqprSearchDialog.show();
    	    };

    	    /* 관련평가 삭제 */
            deleteSpaceRqprRltd = function() {
                if(spaceRqprRltdDataSet.getMarkedCount() > 0) {
                	spaceRqprRltdDataSet.removeMarkedRows();
                } else {
                	alert('삭제 대상을 선택해주세요.');
                }
            };

            setSpaceRqprRltd = function(spaceRqpr) {
				if(spaceRqprRltdDataSet.findRow('preRqprId', spaceRqpr.rqprId) > -1) {
					alert('이미 존재합니다.');
					return ;
				}

				var row = spaceRqprRltdDataSet.newRecord();
				var record = spaceRqprRltdDataSet.getAt(row);

                record.set('rqprId', spaceRqprDataSet.getNameValue(0, 'rqprId'));
				record.set('preRqprId', spaceRqpr.rqprId);
				record.set('preSpaceNm', spaceRqpr.spaceNm);
				record.set('preAcpcNo', spaceRqpr.acpcNo);
				record.set('preRgstId', spaceRqpr.rgstId);
				record.set('preRgstNm', spaceRqpr.rgstNm);
				record.set('preSpaceChrgNm', spaceRqpr.spaceChrgNm);
    	    };

    	  	//비밀사유 히든처리
        	Rui.get('scrtRson').hide();

        });

		//WBS 코드 팝업 세팅
		function setSpaceWbsCd(wbsInfo){
			//alert(wbsInfo.wbsCd);
			spaceRqprDataSet.setNameValue(0, "spaceRqprWbsCd", wbsInfo.wbsCd);
		}
	</script>
    </head>
    <body>
    <form name="searchForm" id="searchForm">
		<input type="hidden" name="spaceNm" value="${inputData.spaceNm}"/>
		<input type="hidden" name="fromRqprDt" value="${inputData.fromRqprDt}"/>
		<input type="hidden" name="toRqprDt" value="${inputData.toRqprDt}"/>
		<input type="hidden" name="rqprDeptNm" value="${inputData.rqprDeptNm}"/>
		<input type="hidden" name="rqprDeptCd" value="${inputData.rqprDeptCd}"/>
		<input type="hidden" name="rgstNm" value="${inputData.rgstNm}"/>
		<input type="hidden" name="spaceChrgNm" value="${inputData.spaceChrgNm}"/>
		<input type="hidden" name="acpcNo" value="${inputData.acpcNo}"/>
		<input type="hidden" name="spaceAcpcStCd" value="${inputData.spaceAcpcStCd}"/>
		<input type="hidden" name="pageNum" value="${inputData.pageNum}"/>
    </form>
    <form name="fileDownloadForm" id="fileDownloadForm">
		<input type="hidden" id="attcFilId" name="attcFilId" value=""/>
		<input type="hidden" id="seq" name="seq" value=""/>
    </form>
   		<div class="contents">
			<div class="titleArea">
   				<a class="leftCon" href="#">
		        	<img src="/iris/resource/web/images/img_uxp/ico_leftCon.png" alt="Left Navigation Control">
		        	<span class="hidden">Toggle 버튼</span>
	        	</a>
   				<h2>평가목록 상세</h2>
   			</div>

   			<div class="sub-content">
   				<div id="tabView"></div>
	            <div id="spaceRqprInfoDiv">
				<form name="aform" id="aform" method="post">
					<input type="hidden" id="spaceChrgId" name="spaceChrgId" value=""/>
   				<div class="titArea mt10">
   					<div class="LblockButton">
   						<button type="button" class="btn"  id="reqApprStateBtn" name="reqApprStateBtn" onclick="openApprStatePopup('A')" style="display:none;">결재상태</button>
   						<button type="button" class="btn"  id="saveBtn" name="saveBtn" onclick="saveSpaceRqpr()">저장</button>
   						<button type="button" class="btn"  id="receiptBtn" name="receiptBtn" onclick="receipt()">접수</button>
   						<button type="button" class="btn"  id="rejectBtn" name="rejectBtn" onclick="reject()">반려</button>
   						<button type="button" class="btn"  id="listBtn" name="listBtn" onclick="goSpaceRqprList4Chrg()">목록</button>
   					</div>
   				</div>

   				<table class="table table_txt_right" style="table-layout:fixed;">
   					<colgroup>
   						<col style="width:15%;"/>
   						<col style="width:35%;"/>
   						<col style="width:15%;"/>
   						<col style="width:35%;"/>
   					</colgroup>
   					<tbody>
   						<tr>
   							<th align="right"><span style="color:red;">* </span>평가명</th>
   							<td>
   								<input type="text" id="spaceNm">
   							</td>
   							<th align="right">접수번호</th>
   							<td><span id="acpcNo"/></td>
   						</tr>
   						<tr>
   							<th align="right"><span style="color:red;">* </span>평가상세</th>
   							<td colspan="3" class="rlabrqpr_tain01">
   								<textarea id="spaceSbc"></textarea>
   							</td>
   						</tr>
   						<tr>
   							<th align="right">의뢰자</th>
   							<td><span id="rgstNm"/></td>
   							<th align="right">부서</th>
    						<td><span id="rqprDeptNm"/></td>
   						</tr>
   						<tr>
   							<th align="right">의뢰일</th>
    						<td><span id="rqprDt"/></td>
   							<th align="right">접수일</th>
    						<td><span id="acpcDt"/></td>
   						</tr>
   						<tr>
   							<th align="right"><span style="color:red;">* </span>평가목적</th>
   							<td>
                                <div id="spaceScnCd"></div>
   							</td>
							<th align="right"><span style="color:red;">* </span>완료예정일</th>
   							<td><input type="text" id="cmplParrDt"/></td>
   						</tr>
   						<tr>
   							<th align="right"><span style="color:red;">* </span>긴급유무</th>
   							<td>
                                <div id="spaceUgyYn"></div>
   							</td>
   							<th align="right">WBS 코드</th>
   							<td>
   								<!-- <input type="text" id="spaceRqprWbsCd"> -->
   								<div class="LblockMarkupCode">
						            <div id="spaceRqprWbsCd"></div>
						        </div>
   							</td>
   						</tr>
   						<tr>
   							<th align="right">통보자</th>
   							<td>
						        <div class="LblockMarkupCode">
						            <div id="spaceRqprInfmView"></div>
						        </div>
   							</td>
   							<th align="right"><span style="color:red;">* </span>공개범위</th>
   							<td  class="space_tain2">
                                <div id="oppbScpCd"></div>&nbsp;<input type="text" id="scrtRson">
   							</td>
   						</tr>


   						<tr>
   							<th align="right"><span style="color:red;">* </span>평가대상명</th>
   							<td colspan="3" class="space_tain">
   								<input type="text" id="evSubjNm">
   							</td>
   						</tr>
   						<tr>
   							<th align="right"><span style="color:red;">* </span>제출처</th>
   							<td colspan="3">
   								<div id="sbmpCd"></div>&nbsp;<input type="text" id="sbmpNm">
   							</td>
   						</tr>

   						<tr>
   							<th align="right"><span style="color:red;">* </span>목표(정량지표)</th>
   							<td class="space_tain">
   								<input type="text" id="qtasDpst">
   							</td>
   							<th align="right"><span style="color:red;">* </span>목표(정성지표)</th>
   							<td class="space_tain">
                                <input type="text" id="qnasDpst">
   							</td>
   						</tr>

   						<tr>
   							<th align="right"><span style="color:red;">* </span>목표성능</th>
   							<td class="space_tain">
                                <input type="text" id="goalPfmc">
   							</td>
   							<th align="right"><span style="color:red;">* </span>결과지표</th>
   							<td class="space_tain">
                                <input type="text" id="rsltDpst">
   							</td>
   						</tr>
   						<tr>
   							<th align="right"><span style="color:red;">* </span>평가 cases(개수)</th>
   							<td class="space_tain">
                                <input type="text" id="evCases">
   							</td>
   							<th align="right"><span style="color:red;">* </span>평가대상 상세</th>
   							<td class="space_tain">
                                <input type="text" id="evSubjDtl">
   							</td>
   						</tr>
   						<tr>
   							<th align="right">T-Cloud Link</th>
   							<td class="rlabrqpr_tain01" colspan="3">
                                <input type="text" id="tCloud">
   							</td>
   						</tr>
   					</tbody>
   				</table>

   				<br/>

   				<div class="space_txt">
   					<b>제출자료</b><br/>
   					&nbsp;&nbsp;1) Simulation <br/>
					&nbsp;&nbsp;&nbsp;&nbsp;공간단위 : 현장 사진, 평면도, 단면도, 적용자재 Spec (자재 도면, 물성 등) 및 시험성적서<br/>
					&nbsp;&nbsp;&nbsp;&nbsp;자재단위 : 적용자재 Spec (자재도면, 물성 등) 및 시험 성적서<br/>
					&nbsp;&nbsp;2) Mock-up : 적용자재 Spec (자재도면, 물성 등) 및 시험 성적서<br/>
					&nbsp;&nbsp;3) Certification : 적용자재 Spec (자재도면, 물성 등) 및 시험 성적서
   				</div>

   				<div class="titArea" style="margin-top:20px;">
   					<h3><span style="color:red;">* </span>평가방법</h3>
   					<div class="LblockButton">
   						<button type="button" class="btn"  id="penSpaceChrgListDialogBtn" name="penSpaceChrgListDialogBtn" onclick="openSpaceChrgListDialog(setSpaceChrgInfo);">추가</button>
   						<button type="button" class="btn"  id="deleteSpaceRqprChrgBtn" name="deleteSpaceRqprChrgBtn" onclick="deleteSpaceRqprChrg()">삭제</button>
   					</div>
   				</div>

   				<div id="spaceRqprWayCrgrGrid"></div>

   				<br/>

   				<div class="titArea">
   					<h3><span style="color:red;">* </span>제품군</h3>
   					<div class="LblockButton">
   						<select id="cmbCtgr0Cd"></select>
   						<select id="cmbCtgr1Cd"></select>
   						<select id="cmbCtgr2Cd"></select>
   						<select id="cmbCtgr3Cd"></select>
   						<button type="button" class="btn"  id="addSpaceRqprProdBtn" name="addSpaceRqprProdBtn" onclick="addSpaceRqprProd();">추가</button>
   						<button type="button" class="btn"  id="deleteSpaceRqprProdBtn" name="deleteSpaceRqprProdBtn" onclick="deleteSpaceRqprProd()">삭제</button>
   					</div>
   				</div>

   				<div id="spaceRqprProdGrid"></div>

				<br/>

   				<div class="rlabrqpr01">
   					<div class="left">
				   				<div class="titArea">
				   					<h3>관련평가</h3>
				   					<div class="LblockButton">
				   						<button type="button" class="btn"  id="addSpaceRqprRltdBtn" name="addSpaceRqprRltdBtn" onclick="openSpaceRqprSearchDialog(setSpaceRqprRltd)">추가</button>
				   						<button type="button" class="btn"  id="deleteSpaceRqprRltdBtn" name="deleteSpaceRqprRltdBtn" onclick="deleteSpaceRqprRltd()">삭제</button>
				   					</div>
				   				</div>

				   				<div id="spaceRqprRltdGrid"></div>
   					</div>
   					<div class="right">
				   				<div class="titArea">
				   					<h3>첨부파일</h3>
				   					<div class="LblockButton">
				   						<button type="button" class="btn"  id="addSpaceRqprAttachBtn" name="addSpaceRqprAttachBtn" onclick="openAttachFileDialog(setSpaceRqprAttach, spaceRqprDataSet.getNameValue(0, 'rqprAttcFileId'), 'spacePolicy', '*', 'M', '첨부파일')">파일첨부</button>
				   					</div>
				   				</div>

				   				<div id="spaceRqprAttachGrid"></div>
   					</div>
   				</div>
				</form>
   				</div>

   				<div id="spaceRqprResultDiv">
				<form name="bform" id="bform" method="post">
   				<div class="titArea">
   					<div class="LblockButton">
   						<button type="button" class="btn"  id="rsltApprStateBtn" name="rsltApprStateBtn" onclick="openApprStatePopup('C')" style="display:none;">결재상태</button>
   						<!-- <button type="button" class="btn"  id="rsltReportBtn" name="rsltReportBtn" onclick="openRsltReportPopup()">REPORT</button> -->
   						<button type="button" class="btn"  id="saveRsltBtn" name="saveRsltBtn" onclick="saveSpaceRqprRslt()">저장</button>
   						<button type="button" class="btn"  id="approvalBtn" name="rejectBtn" onclick="approval()">결재의뢰</button>
   						<button type="button" class="btn"  id="stopBtn" name="stopBtn" onclick="stop()">평가중단</button>
   						<button type="button" class="btn"  id="listBtn" name="listBtn" onclick="goSpaceRqprList4Chrg()">목록</button>
   					</div>
   				</div>

   				<table class="table table_txt_right">
   					<colgroup>
   						<col style="width:15%;"/>
   						<col style="width:35%;"/>
   						<col style="width:15%;"/>
   						<col style="width:35%;"/>
   					</colgroup>
   					<tbody>
   						<tr>
   							<th align="right">평가명</th>
   							<td><span id="spaceNm"/></td>
   							<th align="right">접수번호</th>
   							<td><span id="acpcNo"/></td>
   						</tr>
   						<tr>
   							<th align="right">완료예정일</th>
   							<td><span id="cmplParrDt"/></td>
   							<th align="right">완료일</th>
    						<td><span id="cmplDt"/></td>
   						</tr>
   					</tbody>
   				</table>

   				<div class="titArea" style="margin-top:35px;">
   					<h3>평가정보 등록</h3>
   					<div class="LblockButton">
   						<button type="button" class="btn"  id="addSpaceRqprExatBtn" name="addSpaceRqprExatBtn" onclick="addSpaceRqprExat()">등록</button>
   						<button type="button" class="btn"  id="deleteSpaceRqprExatBtn" name="deleteSpaceRqprExatBtn" onclick="deleteSpaceRqprExat()">삭제</button>
   					</div>
   				</div>

   				<div id="spaceRqprExatGrid"></div>

   				<table class="table table_txt_right space_ta01" style="table-layout:fixed;">
   					<colgroup>
   						<col style="width:15%;"/>
   						<col style="width:35%;"/>
   						<col style="width:15%;"/>
   						<col style="width:35%;"/>
   					</colgroup>
   					<tbody>
   						<tr>
   							<th align="right"><span style="color:red;">* </span>평가결과</th>
   							<td colspan="3"><textarea id="spaceRsltSbc"></textarea></td>
   						</tr>
   						<tr>
   							<th align="right"><span style="color:red;">* </span>평가결과서</th>
   							<td colspan="2">
   								<span id="rsltAttcFileView"></span>
   							</td>
   							<td>
				   				<button type="button" class="btn"  id="addSpaceRqprAttachBtn" name="addSpaceRqprAttachBtn" onclick="openAttachFileDialog(setSpaceRqprRsltAttach, spaceRqprDataSet.getNameValue(0, 'rsltAttcFileId'), 'spacePolicy', '*')">파일첨부</button>
   							</td>
   						</tr>
   					</tbody>
   				</table>
   				</form>
   				</div>
				<div id="spaceRqprOpinitionDiv">
   				<div class="titArea">
   					<div class="LblockButton">
   						<button type="button" class="btn"  id="saveBtn" name="saveBtn" onclick="opinitionSave()">추가</button>
   						<button type="button" class="btn"  id="deleteBtn" name="deleteBtn" onclick="opinitionUpdate()">수정</button>
   						<button type="button" class="btn"  id="listBtn" name="listBtn" onclick="goSpaceRqprList4Chrg()">목록</button>
   					</div>
   				</div>
   				<div id="spaceRqprOpinitionGrid"></div>
   				<br/>
   				</div>
   				<div id="spaceRqprOpinitionFbDiv">
   				<form name="cform" id="cform" method="post">
   				<div class="titArea">
   					<h3><span style="color:red;">* </span>프로젝트 결과</h3>
   					<div class="LblockButton">
   						<button type="button" class="btn"  id="listBtn" name="listBtn" onclick="goSpaceRqprList4Chrg()">목록</button>
   					</div>
   				</div>
   				<table class="table">
   					<colgroup>
						<col style="width:30%;">
						<col style="width:70%;">
   					</colgroup>
   					<tbody>
   						<tr>
   							<th>평가카테고리</th>
   							<th colspan="2">평가명</th>
   						</tr>
   						<tr>
   							<td>
   								<div id="fbRsltCtgr"></div>
   							</td>
   							<td cass="spacerqpr_tain">
   								<div id="fbTssPgsStep"></div>
   								<input id="fbRsltSbc" type="text">
   							</td>
   						</tr>
   					</tbody>
   				</table>
   				<div class="titArea">
   					<h3><span style="color:red;">* </span>공간평가시스템 개선 요청 사항</h3>
   					<div class="LblockButton">
   					</div>
   				</div>
   				<table class="table">
   					<colgroup>
						<col style="width:30%;">
						<col style="width:70%;">
   					</colgroup>
   					<tbody>
   						<tr>
   							<th>구분</th>
   							<th>비고</th>
   						</tr>
   						<tr>
   							<td>
   								<div id="fbRsltScn"></div>
   							</td>
   							<td cass="spacerqpr_tain">
   								<textarea id="fbRsltBttm"></textarea>
   							</td>
   						</tr>
   					</tbody>
   				</table>
   				<br/>
   				</form>
   				</div>
   			</div><!-- //sub-content -->
   		</div><!-- //contents -->
    </body>
</html>