<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*,
				 java.util.*,
				 devonframe.util.NullUtil,
				 devonframe.util.DateUtil"%>

<%--
/*
 *************************************************************************
 * $Id		: spaceRqprDetail.jsp
 * @desc    : 평가의뢰서 상세
 *------------------------------------------------------------------------
 * VER	DATE		AUTHOR		DESCRIPTION
 * ---	-----------	----------	-----------------------------------------
 * 1.0  2018.08.25  정현웅		최초생성
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
                	if(data.records[0].cmd == 'update') {
                		;
                	} else if(data.records[0].cmd == 'requestApproval') {
                		// guid= B : 신뢰성 분석의뢰, D : 신뢰성 분석완료, E : 공간성능 평가의뢰, G : 공간성능 평가완료 + rqprId
                    	var url = '<%=lghausysPath%>/lgchem/approval.front.document.RetrieveDocumentFormCmd.lgc?appCode=APP00333&approvalLineInform=SUB001&from=iris&guid=E${inputData.rqprId}';

                   		openWindow(url, 'spaceRqprApprovalPop', 800, 500, 'yes');
                	} else {
                    	goSpaceRqprList();
                	}
                }
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
	            	if(spaceRqprDataSet.getNameValue(0, 'spaceAcpcStCd') != '07') {
	            		alert('평가 결과 확인은 평가 완료 된 후 확인이 가능 합니다.');
	            		return false;
	            	}

	                break;

	            case 2:

	                break;

	            case 3:
	            	if(spaceRqprDataSet.getNameValue(0, 'spaceAcpcStCd') != '07') {
	            		alert('결과 통보 이후 의견 피드백을 작성해 주시기 바랍니다.');
	            		return false;
	            	}

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

            spaceScnCdDataSet = new Rui.data.LJsonDataSet({
                id: 'spaceScnCdDataSet',
                remainRemoved: true,
                lazyLoad: true,
                fields: [
                	  { id: 'COM_DTL_CD' }
                	, { id: 'COM_DTL_NM' }
                ]
            });

            spaceScnCdDataSet.load({
                url: '<c:url value="/common/code/retrieveCodeListForCache.do"/>',
                params :{
                	comCd : 'SPACE_SCN_CD'
                }
            });

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
                placeholder: '평가명을 입력해주세요.',
                defaultValue: '',
                emptyValue: '',
                width: 390
            });
			/*평가목적*/
            var spaceSbc = new Rui.ui.form.LTextArea({
                applyTo: 'spaceSbc',
                placeholder: '평가배경과 목적, 결과 활용방안을 자세히 기재하여 주시기 바랍니다.',
                emptyValue: '',
                width: 950,
                height: 75
            });
            /* 평가구분 */
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
            /* WBS 팝업 설정*/
            var spaceRqprWbsCd = new Rui.ui.form.LPopupTextBox({
            	applyTo: 'spaceRqprWbsCd',
                placeholder: 'WBS코드를 입력해주세요.',
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
            	placeholder: '상세 사유 기재',
                defaultValue: '',
                emptyValue: '',
                width: 300
            });
            /* 통보자 팝업 설정*/
            spaceRqprInfmView = new Rui.ui.form.LPopupTextBox({
                applyTo: 'spaceRqprInfmView',
                width: 600,
                editable: false,
                placeholder: '통보자를 입력해주세요.',
                emptyValue: '',
                enterToPopup: true
            });
            spaceRqprInfmView.on('popup', function(e){
            	openUserSearchDialog(setSpaceRqprInfm, 10, spaceRqprDataSet.getNameValue(0, 'infmPrsnIds'), 'space');
            });

            /* 평가대상명 */
            var evSubjNm = new Rui.ui.form.LTextBox({
            	applyTo: 'evSubjNm',
                placeholder: 'IFC, 상평동 복합문화단지(假稱)…',
                defaultValue: '',
                emptyValue: '',
                width: 985
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
                placeholder: '제출기관명 직접 입력',
                defaultValue: '',
                emptyValue: '',
                width: 845
            });
            /* 정량지표 */
            var qtasDpst = new Rui.ui.form.LTextBox({
            	applyTo: 'qtasDpst',
                placeholder: '영업, Spec-in 금액, 매출목표 등',
                defaultValue: '',
                emptyValue: '',
                width: 390
            });
            /* 정성지표 */
            var qnasDpst = new Rui.ui.form.LTextBox({
            	applyTo: 'qnasDpst',
                placeholder: '*** 개발 연구 등',
                defaultValue: '',
                emptyValue: '',
                width: 395
            });
            /* 목표성능 */
            var goalPfmc = new Rui.ui.form.LTextBox({
            	applyTo: 'goalPfmc',
                placeholder: '열관류율 1.2 W/㎡K 이하, 표면온도 15℃ 이상, 1차 에너지 소요량 90 kWh/㎡ 이하',
                defaultValue: '',
                emptyValue: '',
                width: 390
            });
            /* 결과지표 */
            var rsltDpst = new Rui.ui.form.LTextBox({
            	applyTo: 'rsltDpst',
                placeholder: '열관류율 (W/㎡K), 열전도율 (W/mK), 표면온도 (℃)…',
                defaultValue: '',
                emptyValue: '',
                width: 395
            });
            /* 평가 cases(개수) */
            var evCases = new Rui.ui.form.LTextBox({
            	applyTo: 'evCases',
                placeholder: '5건 (창호 1~5등급, 5케이스 적용)',
                defaultValue: '',
                emptyValue: '',
                width: 390
            });
            /* 평가대상 상세 */
            var evSubjDtl = new Rui.ui.form.LTextBox({
            	applyTo: 'evSubjDtl',
                placeholder: '넷마블 사옥, 시행사 XX, 시공사 XX…',
                defaultValue: '',
                emptyValue: '',
                width: 395
            });

            /* T-Cloud 링크*/
            var tCloud = new Rui.ui.form.LTextBox({
            	applyTo: 'tCloud',
                placeholder: '대용량 첨부파일 링크 입력.',
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
					, { id: 'spaceScnCd'	}	//평가구분코드
					, { id: 'spaceSbc'		}	//평가목적
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
					, { id: 'rqprAttcFileId', defaultValue: '' }
					, { id: 'spaceAcpcStCd'		}

                ]
            });

            spaceRqprDataSet.on('load', function(e) {

            	var opinitionCnt = spaceRqprDataSet.getNameValue(0, 'opinitionCnt');
            	var spaceRsltSbc = spaceRqprDataSet.getNameValue(0, 'spaceRsltSbc');

            	if(opinitionCnt > 0) {
            		$('#opinitionCnt').html('(' + opinitionCnt + ')');
            	}

            	if(Rui.isEmpty(spaceRsltSbc) == false) {
                	spaceRqprDataSet.setNameValue(0, 'spaceRsltSbc', spaceRsltSbc.replaceAll('\n', '<br/>'));
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
                        		//alert(splitVal.length);
                        		for(var j=0;j<splitVal.length;j++){
                        			var k=0;
    	                    		for(var i=0;i<splitVal[j].length;i++){
    	                    			if(i%66==0&&i!=0){
    	                    				rtnStr+='\n';
    	                    				//k=K+1;
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
  		  	    		  var strBtnFun = "openAttachFileDialog(setAttachFileInfo, "+recordFilId+", 'spacePolicy', '*' ,'R')";
  		  	    		  //return Rui.isUndefined(record.get('attcFilId')) ? '' : '<button type="button"  class="L-grid-button" onclick="'+strBtnFun+'">다운로드</button>';
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

            bind = new Rui.data.LBind({
                groupId: 'aform',
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
                    { id: 'spaceAcpcStCd',		ctrlId: 'spaceAcpcStCd',	value:'value'}
                ]
            });
            spaceRqprDataSet.newRecord();

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
				alert(spaceChrgInfo.spaceEvCtgr +" : "+ spaceChrgInfo.spaceEvPrvs +" : "+ spaceChrgInfo.id +" : "+ spaceChrgInfo.name);
				spaceRqprWayCrgrDataSet.newRecord();
            	spaceRqprWayCrgrDataSet.setNameValue(spaceRqprWayCrgrDataSet.getRow(), 'evCtgr', spaceChrgInfo.spaceEvCtgr);
            	spaceRqprWayCrgrDataSet.setNameValue(spaceRqprWayCrgrDataSet.getRow(), 'evPrvs', spaceChrgInfo.spaceEvPrvs);
            	spaceRqprWayCrgrDataSet.setNameValue(spaceRqprWayCrgrDataSet.getRow(), 'infmPrsnId', spaceChrgInfo.id);
            	spaceRqprWayCrgrDataSet.setNameValue(spaceRqprWayCrgrDataSet.getRow(), 'infmPrsnNm', spaceChrgInfo.name);
            };
			// 평가 담당자 선택팝업 끝

			/* 평가담당자 삭제 */
            deleteSpaceRqprWayCrgr = function() {
                if(spaceRqprWayCrgrDataSet.getMarkedCount() > 0) {
                	spaceRqprWayCrgrDataSet.removeMarkedRows();
                } else {
                	alert('삭제 대상을 선택해주세요.');
                }
            };
            /* 평가담당자 삭제 끝 */


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
					, { id: 'evCtgr4Nm' }
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
                    , { field: 'evCtgr4Nm',	label: '제품명(직접입력)',		sortable: false,	editable: true, 	editor: textBox,	align:'left',	width: 250 }

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


			/* 관련평가 */
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
                    , { field: 'preAcpcNo',		label: '접수번호',	sortable: false,	align:'center',	width: 80 }
                    , { field: 'preSpaceNm',	label: '평가명',		sortable: false,	align:'left',	width: 300 }
                    , { field: 'preRgstNm',		label: '의뢰자',		sortable: false,	align:'center',	width: 80 }
                    , { field: 'preSpaceChrgNm',label: '평가담당자',	sortable: false,	align:'center',	width: 80 }
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

            /* 관련평가 삭제 */
            deleteSpaceRqprRltd = function() {
                if(spaceRqprRltdDataSet.getMarkedCount() > 0) {
                	spaceRqprRltdDataSet.removeMarkedRows();
                } else {
                	alert('삭제 대상을 선택해주세요.');
                }
            };

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
                    , { field: 'filNm',		label: '파일명',		sortable: false,	align:'left',	width: 470 }
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
    	    // 관련평가 조회 팝업 끝

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
		    	opinitionUpdateDialog.setUrl('<c:url value="/space/openAddOpinitionPopup.do"/>'+'?opiId=' + opiId);
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

           	};
          	//첨부파일 다운로드
            downloadMnalFil = function(attId, seq){
     	       var param = "?attcFilId=" + attId + "&seq=" + seq;
     	       	document.aform.action = '<c:url value='/system/attach/downloadAttachFile.do'/>' + param;
     	       	document.aform.submit();
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
            	 placeholder: '- Spec-in 혹은 영업 매출 규모 : 창호+유리 50억\n- 과제 진행 단계 : SEED 검토, GRS 1 통과, GRS 2 통과, Drop…',
                  editable: true,
                  disabled:false,
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
                   disabled:false,
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
                groupId: 'bform',
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
				if(spaceRqprFbDataSet.getNameValue(0, 'fbCmplYn')=="Y"){
					$("#saveFbBtn").hide();
					$("#cmplFbBtn").hide();
				}else{
					$("#saveFbBtn").show();
					$("#cmplFbBtn").show();
				}
				if(spaceRqprFbDataSet.getNameValue(0, 'fbRsltCtgr')=="03"){
					fbRsltSbcTxtArea.hide();
					fbTssPgsStep.show();
					if(spaceRqprFbDataSet.getNameValue(0, 'fbCmplYn')=="Y"){
						fbRsltSbcTxtArea.disable();
						fbTssPgsStep.disable();
						fbRsltCtgr.disable();
						fbRsltScn.disable();
						fbRsltBttmTxtArea.disable();
					}else{
						fbRsltSbcTxtArea.enable();
						fbTssPgsStep.enable();
						fbRsltCtgr.enable();
						fbRsltScn.enable();
						fbRsltBttmTxtArea.enable();
					}
				}else{
					fbRsltSbcTxtArea.show();
					fbTssPgsStep.hide();
					if(spaceRqprFbDataSet.getNameValue(0, 'fbCmplYn')=="Y"){
						fbRsltSbcTxtArea.disable();
						fbTssPgsStep.disable();
						fbRsltCtgr.disable();
						fbRsltScn.disable();
						fbRsltBttmTxtArea.disable();
					}else{
						fbRsltSbcTxtArea.enable();
						fbTssPgsStep.enable();
						fbRsltCtgr.enable();
						fbRsltScn.enable();
						fbRsltBttmTxtArea.enable();
					}
				}
            });

			//피드백저장
            opinitionFbSave = function() {
            	var fbRsltCtgr = document.bform.fbRsltCtgr.value;
            	var fbRsltSbc = document.bform.fbRsltSbc.value;
            	var fbRsltScn = document.bform.fbRsltScn.value;
            	var fbRsltBttm = document.bform.fbRsltBttm.value;
            	var fbTssPgsStep = document.bform.fbTssPgsStep.value;

            	if(fbRsltCtgr==""){
            		alert("평가 카테고리를 선택해 주세요.");
            		return;
            	}

            	if(fbRsltScn==""){
            		alert("구분값을 선택해 주세요.");
            		return;
            	}

            	if(fbRsltCtgr=="03"){
            		if(fbTssPgsStep==""){
            			alert("평가명을 선택해 주세요.");
            			return;
            		}
            	}else{
            		if(fbRsltSbc=""){
            			alert("평가명을 입력해 주세요.")
            		}
            	}

            	if(confirm('저장 하시겠습니까?')) {
               		dm.updateDataSet({
                        url:'<c:url value="/space/saveSpaceRqprFb.do"/>',
                        //dataSets:[dataSet]
                        params: {
                        	rqprId : spaceRqprDataSet.getNameValue(0, 'rqprId')
                        	, fbRsltCtgr : document.bform.fbRsltCtgr.value
    	    	         	, fbRsltSbc : document.bform.fbRsltSbc.value
    	    	         	, fbRsltScn : document.bform.fbRsltScn.value
    	    	         	, fbRsltBttm : document.bform.fbRsltBttm.value
    	    	         	, fbTssPgsStep : document.bform.fbTssPgsStep.value
    	    	       }
                    });
               	}
            };

          //피드백확정
            cmplFbSave = function() {
            	var fbRsltCtgr = document.bform.fbRsltCtgr.value;
            	var fbRsltSbc = document.bform.fbRsltSbc.value;
            	var fbRsltScn = document.bform.fbRsltScn.value;
            	var fbRsltBttm = document.bform.fbRsltBttm.value;
            	var fbTssPgsStep = document.bform.fbTssPgsStep.value;

            	if(fbRsltCtgr==""){
            		alert("평가 카테고리를 선택해 주세요.");
            		return;
            	}

            	if(fbRsltScn==""){
            		alert("구분값을 선택해 주세요.");
            		return;
            	}

            	if(fbRsltCtgr=="03"){
            		if(fbTssPgsStep==""){
            			alert("평가명을 선택해 주세요.");
            			return;
            		}
            	}else{
            		if(fbRsltSbc=""){
            			alert("평가명을 입력해 주세요.")
            		}
            	}
               	if(confirm('확정 하시겠습니까?')) {
               		dm.updateDataSet({
                        url:'<c:url value="/space/saveSpaceRqprFbCmpl.do"/>',
                        //dataSets:[dataSet]
                        params: {
                        	rqprId : spaceRqprDataSet.getNameValue(0, 'rqprId')
                        	, fbRsltCtgr : document.bform.fbRsltCtgr.value
    	    	         	, fbRsltSbc : document.bform.fbRsltSbc.value
    	    	         	, fbRsltScn : document.bform.fbRsltScn.value
    	    	         	, fbRsltBttm : document.bform.fbRsltBttm.value
    	    	         	, fbTssPgsStep : document.bform.fbTssPgsStep.value
    	    	       }
                    });
               	}
            };
          	/////////////////////////////////////////////////


			/* 필수항목 체크 */
            var vm = new Rui.validate.LValidatorManager({
                validators:[
                { id: 'spaceNm',		validExp: '평가명:true:maxByteLength=100' },
                { id: 'spaceSbc',		validExp: '평가목적:true' },
                { id: 'spaceScnCd',		validExp: '평가구분:true' },
                { id: 'spaceUgyYn',		validExp: '긴급유무:true' },
                { id: 'oppbScpCd',		validExp: '공개범위:true' },
				{ id: 'evSubjNm',		validExp: '평가대상명:true:maxByteLength=100' },
				{ id: 'sbmpCd',			validExp: '제출처:true' },
				{ id: 'sbmpNm',			validExp: '제출기관명:true:maxByteLength=100' },
				{ id: 'qtasDpst',		validExp: '정량지표:true:maxByteLength=100' },
				{ id: 'qnasDpst',		validExp: '정성지표:true:maxByteLength=100' },
				{ id: 'goalPfmc',		validExp: '목표성능:true:maxByteLength=100' },
				{ id: 'rsltDpst',		validExp: '결과지표:true:maxByteLength=100' },
				{ id: 'evCases',		validExp: '평가case(개수):true:number' },
				{ id: 'evSubjDtl',		validExp: '평가대상 상세:true:maxByteLength=100' }
                ]
            });

    	    /* 유효성 검사 */
    	    isValidate = function(type) {
    	    	if (vm.validateDataSet(spaceRqprDataSet) == false) {
                    alert(Rui.getMessageManager().get('$.base.msg052') + '\n' + vm.getMessageList().join('\n'));
                    return false;
                }

                if (spaceRqprWayCrgrDataSet.getCount() == 0) {
                    alert('평가방법을 입력해주세요.');
                    return false;
                } else if (vm.validateDataSet(spaceRqprWayCrgrDataSet) == false) {
                    alert(Rui.getMessageManager().get('$.base.msg052') + '\n' + vm.getMessageList().join('\n'));
                    return false;
                }

                if (spaceRqprProdDataSet.getCount() == 0) {
                    alert('제품군을 입력해주세요.');
                    return false;
                } else if (vm.validateDataSet(spaceRqprProdDataSet) == false) {
                    alert(Rui.getMessageManager().get('$.base.msg052') + '\n' + vm.getMessageList().join('\n'));
                    return false;
                }

                return true;
    	    }

            /* 저장 */
            save = function() {
                if(isValidate('작성')) {
                	if(confirm('저장 하시겠습니까?')) {
                        dm.updateDataSet({
                            dataSets:[spaceRqprDataSet,spaceRqprWayCrgrDataSet,spaceRqprProdDataSet,spaceRqprRltdDataSet],
                            url:'<c:url value="/space/updateSpaceRqpr.do"/>',
                            modifiedOnly: false
                        });
                	}
                }
            };

            /* 결재의뢰 */
            approval = function() {
                if(isValidate('결재의뢰')) {
                	if(confirm('결재의뢰 하시겠습니까?')) {
                        dm.updateDataSet({
                        	dataSets:[spaceRqprDataSet,spaceRqprWayCrgrDataSet,spaceRqprProdDataSet,spaceRqprRltdDataSet],
                            url:'<c:url value="/space/requestSpaceRqprApproval.do"/>',
                            modifiedOnly: false
                        });
                	}
                }
            };

            /* 삭제 */
            deleteSpaceRqpr = function() {
                if ('00|04'.indexOf(spaceRqprDataSet.getNameValue(0, 'spaceAcpcStCd')) == -1) {
                    alert('작성중, 접수반려 상태일때만 삭제할 수 있습니다.');
                    return false;
                }

            	if(confirm('삭제 하시겠습니까?')) {
                    dm.updateDataSet({
                        url:'<c:url value="/space/deleteSpaceRqpr.do"/>',
                        params: {
                            rqprId: spaceRqprDataSet.getNameValue(0, 'rqprId')
                        }
                    });
            	}
            };

            //통보자 추가 저장
            addSpaceRqprInfm = function(){
            	if ('07'.indexOf(spaceRqprDataSet.getNameValue(0, 'spaceAcpcStCd')) == -1) {
                    alert('완료 상태일때만 삭제할 수 있습니다.');
                    return false;
                }

            	dm.updateDataSet({
                    url:'<c:url value="/space/insertSpaceRqprInfm.do"/>',
                    dataSets:[spaceRqprDataSet, spaceRqprWayCrgrDataSet, spaceRqprRltdDataSet],
                    params: {
                        rqprId: spaceRqprDataSet.getNameValue(0, 'rqprId')
                    }
                });
            }

    	    goSpaceRqprList = function() {
    	    	$('#searchForm > input[name=spaceNm]').val(encodeURIComponent($('#searchForm > input[name=spaceNm]').val()));
    	    	$('#searchForm > input[name=rgstNm]').val(encodeURIComponent($('#searchForm > input[name=rgstNm]').val()));
    	    	$('#searchForm > input[name=spaceChrgNm]').val(encodeURIComponent($('#searchForm > input[name=spaceChrgNm]').val()));

    	    	nwinsActSubmit(searchForm, "<c:url value="/space/spaceRqprList.do"/>");
    	    };

    	    openApprStatePopup = function(type) {
    	    	var seq = spaceRqprDataSet.getNameValue(0, 'reqItgRdcsId');
            	var url = '<%=lghausysPath%>/lgchem/approval.front.approval.RetrieveAppTargetCmd.lgc?seq=' + seq;

           		openWindow(url, 'openApprStatePopup', 800, 250, 'yes');
    	    };

	    	dm.loadDataSet({
                dataSets: [spaceRqprDataSet,
                           spaceRqprWayCrgrDataSet,
                           spaceRqprProdDataSet,
                           spaceRqprRltdDataSet,
                           spaceRqprAttachDataSet,
                           spaceRqprRsltAttachDataSet,
                           spaceRqprFbDataSet],
                url: '<c:url value="/space/getSpaceRqprDetailInfo.do"/>',
                params: {
                    rqprId: '${inputData.rqprId}'
                }
            });

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
		<input type="hidden" name="cmbCtgr0Cd" value="${inputData.cmbCtgr0Cd}"/>
		<input type="hidden" name="spaceNm" value="${inputData.spaceNm}"/>
		<input type="hidden" name="fromRqprDt" value="${inputData.fromRqprDt}"/>
		<input type="hidden" name="toRqprDt" value="${inputData.toRqprDt}"/>
		<input type="hidden" name="rgstNm" value="${inputData.rgstNm}"/>
		<input type="hidden" name="rgstId" value="${inputData.rgstId}"/>
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
   				<h2>평가의뢰서 상세</h2>
   			</div>
   			<div class="sub-content">
   				<div id="tabView"></div>
	            <div id="spaceRqprInfoDiv">
				<form name="aform" id="aform" method="post">
					<input type="hidden" id="spaceChrgId" name="spaceChrgId" value=""/>
   				<div class="titArea">
   					<div class="LblockButton">
   						<button type="button" class="btn"  id="reqApprStateBtn" name="reqApprStateBtn" onclick="openApprStatePopup()" style="display:none;">결재상태</button>
   						<button type="button" class="btn"  id="saveBtn" name="saveBtn" onclick="save()">등록</button>
   						<button type="button" class="btn"  id="approvalBtn" name="approvalBtn" onclick="approval()">결재</button>
   						<button type="button" class="btn"  id="deleteBtn" name="deleteBtn" onclick="deleteSpaceRqpr()">삭제</button>
   						<button type="button" class="btn"  id="listBtn" name="listBtn" onclick="goSpaceRqprList()">목록</button>
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
   							<td class="rlabrqpr_tain03">
   								<input type="text" id="spaceNm">
   							</td>
   							<th align="right">접수번호</th>
   							<td><span id="acpcNo"/></td>
   						</tr>
   						<tr>
   							<th align="right"><span style="color:red;">* </span>평가목적</th>
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
   							<th align="right"><span style="color:red;">* </span>평가구분</th>
   							<td>
                                <div id="spaceScnCd"></div>
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
   							<th align="right"><span style="color:red;">* </span>긴급유무</th>
   							<td>
                                <div id="spaceUgyYn"></div>
   							</td>
   							<th align="right"><span style="color:red;">* </span>공개범위</th>
   							<td class="space_tain2">
                                <div id="oppbScpCd"></div>&nbsp;<input type="text" id="scrtRson">
   							</td>
   						</tr>
   						<tr>
   							<th align="right">통보자</th>
   							<td colspan="3">
						        <div class="LblockMarkupCode">
						            <div id="spaceRqprInfmView"></div>
						        </div>
   							</td>
   						</tr>


   						<tr>
   							<th align="right"><span style="color:red;">* </span>평가대상명</th>
   							<td colspan="3" class="rlabrqpr_tain03">
   								<input type="text" id="evSubjNm">
   							</td>
   						</tr>
   						<tr>
   							<th align="right"><span style="color:red;">* </span>제출처</th>
   							<td colspan="3" class="space_tain2">
   								<div id="sbmpCd"></div>&nbsp;<input type="text" id="sbmpNm">
   							</td>
   						</tr>

   						<tr>
   							<th align="right"><span style="color:red;">* </span>기대효과(정량지표)</th>
   							<td class="rlabrqpr_tain03">
   								<input type="text" id="qtasDpst">
   							</td>
   							<th align="right"><span style="color:red;">* </span>기대효과(정성지표)</th>
   							<td class="rlabrqpr_tain03">
                                <input type="text" id="qnasDpst">
   							</td>
   						</tr>

   						<tr>
   							<th align="right"><span style="color:red;">* </span>목표성능</th>
   							<td class="rlabrqpr_tain03">
                                <input type="text" id="goalPfmc">
   							</td>
   							<th align="right"><span style="color:red;">* </span>결과지표</th>
   							<td class="rlabrqpr_tain03">
                                <input type="text" id="rsltDpst">
   							</td>
   						</tr>
   						<tr>
   							<th align="right"><span style="color:red;">* </span>평가 cases(개수)</th>
   							<td class="rlabrqpr_tain03">
                                <input type="text" id="evCases">
   							</td>
   							<th align="right"><span style="color:red;">* </span>평가대상 상세</th>
   							<td class="rlabrqpr_tain03">
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


   				<div class="titArea" style="margin-top:30px;">
   					<h3><span style="color:red;">* </span>평가방법</h3>
   					<div class="LblockButton">
   						<button type="button" class="btn"  id="penSpaceChrgListDialogBtn" name="penSpaceChrgListDialogBtn" onclick="openSpaceChrgListDialog(setSpaceChrgInfo);">추가</button>
   						<button type="button" class="btn"  id="deleteSpaceRqprWayCrgrBtn" name="deleteSpaceRqprWayCrgrBtn" onclick="deleteSpaceRqprWayCrgr()">삭제</button>
   					</div>
   				</div>

   				<div id="spaceRqprWayCrgrGrid"></div>

   				<br/>

   				<div class="titArea">
   					<h3><span style="color:red;">* </span>제품군</h3>
   					<div class="LblockButton box_fl">
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

				<div class="rlabrqpr01" id="rlab_ta" >
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
   				<div class="titArea">
   					<div class="LblockButton">
   						<button type="button" class="btn"  id="resultTabListBtn" name="resultTabListBtn" onclick="goSpaceRqprList()">목록</button>
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
   						<tr>
   							<th align="right">통보자</th>
    						<td colspan="3"><span id="spaceRqprInfmView"/></td>
   						</tr>
   						<tr>
   							<th align="right">평가결과</th>
   							<td colspan="3"><span id="spaceRsltSbc"/></td>
   						</tr>
   						<tr>
   							<th align="right">평가결과서</th>
   							<td id="rsltAttcFileView" colspan="3"></td>
   						</tr>
   					</tbody>
   				</table>
   				</div>
				<div id="spaceRqprOpinitionDiv">
   				<div class="titArea">
   					<div class="LblockButton">
   						<button type="button" class="btn"  id="saveBtn" name="saveBtn" onclick="opinitionSave()">추가</button>
   						<!-- <button type="button" class="btn"  id="deleteBtn" name="deleteBtn" onclick="opinitionUpdate()">수정</button> -->
   						<button type="button" class="btn"  id="listBtn" name="listBtn" onclick="goSpaceRqprList()">목록</button>
   					</div>
   				</div>
   				<div id="spaceRqprOpinitionGrid"></div>
   				<br/>
   				</div>

   				<div id="spaceRqprOpinitionFbDiv">
   				<form name="bform" id="bform" method="post">
   				<div class="titArea">
   					<h3><span style="color:red;">* </span>프로젝트 결과</h3>
   					<div class="LblockButton">
   						<button type="button" class="btn"  id="saveFbBtn" name="saveFbBtn" onclick="opinitionFbSave()">임시저장</button>
   						<button type="button" class="btn"  id="cmplFbBtn" name="cmplFbBtn" onclick="cmplFbSave()">확정</button>
   						<button type="button" class="btn"  id="listBtn" name="listBtn" onclick="goSpaceRqprList()">목록</button>
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
   							<td class="spacerqpr_tain">
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
   							<td class="spacerqpr_tain">
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