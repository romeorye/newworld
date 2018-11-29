<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*,
				 java.util.*,
				 devonframe.util.NullUtil,
				 devonframe.util.DateUtil"%>

<%--
/*
 *************************************************************************
 * $Id		: spaceRqprRgst.jsp
 * @desc    : 평가의뢰서 등록
 *------------------------------------------------------------------------
 * VER	DATE		AUTHOR		DESCRIPTION
 * ---	-----------	----------	-----------------------------------------
 * 1.0  2017.08.21  정현웅		최초생성
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

<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/grid/LEditButtonColumn.js"></script>
<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/grid/LTotalSummary.js"></script>
<link rel="stylesheet" type="text/css" href="<%=ruiPathPlugins%>/ui/grid/LTotalSummary.css"/>

<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/grid/LGridStatusBar.js"></script>
<link rel="stylesheet" type="text/css" href="<%=ruiPathPlugins%>/ui/grid/LGridStatusBar.css"/>

<style>
 .bgcolor-gray {background-color: #999999}
 .bgcolor-white {background-color: #FFFFFF}
</style>

	<script type="text/javascript">

		var callback;
		var spaceRqprDataSet;


		Rui.onReady(function() {
            /*******************
             * 변수 및 객체 선언
             *******************/

            var dm = new Rui.data.LDataSetManager();

            dm.on('load', function(e) {
            });

            dm.on('success', function(e) {
                var data = spaceRqprWayCrgrDataSet.getReadData(e);

                alert(data.records[0].resultMsg);


            	$('#rqprId').val(data.records[0].newRqprId);
            	nwinsActSubmit(searchForm, "<c:url value='/space/spaceRqprDetail.do'/>");

                /* if(data.records[0].resultYn == 'Y') {
                	goSpaceRqprList();
                } */
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
                placeholder: '평가명 직접입력.',
                defaultValue: '',
                emptyValue: '',
                width: 980
            });
			/*평가상세*/
            var spaceSbc = new Rui.ui.form.LTextArea({
                applyTo: 'spaceSbc',
                placeholder: '평가배경과 목적, 결과 활용방안을 자세히 기재하여 주시기 바랍니다.',
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
            /* WBS 팝업 설정*/
            var spaceRqprWbsCd = new Rui.ui.form.LPopupTextBox({
            	applyTo: 'spaceRqprWbsCd',
                placeholder: 'WBS코드 검색',
                defaultValue: '',
                emptyValue: '',
                editable: false,
                width: 200
            });
            spaceRqprWbsCd.on('popup', function(e){
            	var deptYn = "Y";
            	openWbsCdSearchDialog(setSpaceWbsCd , deptYn);
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
                width: 305
            });

            /* 통보자 팝업 설정*/
            spaceRqprInfmView = new Rui.ui.form.LPopupTextBox({
                applyTo: 'spaceRqprInfmView',
                width: 600,
                editable: false,
                placeholder: '통보자 검색',
                emptyValue: '',
                enterToPopup: true
            });
            spaceRqprInfmView.on('popup', function(e){
            	openUserSearchDialog(setSpaceRqprInfm, 10, spaceRqprDataSet.getNameValue(0, 'infmPrsnIds'), 'space');
            });

            /* 평가대상명 */
            var evSubjNm = new Rui.ui.form.LTextBox({
            	applyTo: 'evSubjNm',
                placeholder: '예)IFC, 상평동 복합문화단지, 등',
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
                width: 860
            });
            /* 정량지표 */
            var qtasDpst = new Rui.ui.form.LTextBox({
            	applyTo: 'qtasDpst',
                placeholder: '예)영업, Spec-in 금액, 매출목표 등',
                defaultValue: '',
                emptyValue: '',
                width: 400
            });
            /* 정성지표 */
            var qnasDpst = new Rui.ui.form.LTextBox({
            	applyTo: 'qnasDpst',
                placeholder: '예)*** 개발 연구 등',
                defaultValue: '',
                emptyValue: '',
                width: 395
            });
            /* 목표성능 */
            var goalPfmc = new Rui.ui.form.LTextBox({
            	applyTo: 'goalPfmc',
                placeholder: '예)열관류율 1.2 W/㎡K 이하, 표면온도 15℃ 이상, 1차 에너지 소요량 90 kWh/㎡ 이하,등',
                defaultValue: '',
                emptyValue: '',
                width: 400
            });
            /* 결과지표 */
            var rsltDpst = new Rui.ui.form.LTextBox({
            	applyTo: 'rsltDpst',
                placeholder: '예)열관류율 (W/㎡K), 열전도율 (W/mK), 표면온도 (℃),등',
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
                width: 400
            });
            /* 평가대상 상세 */
            var evSubjDtl = new Rui.ui.form.LTextBox({
            	applyTo: 'evSubjDtl',
                placeholder: '기타사항, 특이점',
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
                width: 980
            });

            spaceRqprDataSet = new Rui.data.LJsonDataSet({
                id: 'spaceRqprDataSet',
                remainRemoved: true,
                lazyLoad: true,
                fields: [
					  { id: 'spaceNm'		}
					, { id: 'spaceScnCd'	}
					, { id: 'spaceSbc'		}
					, { id: 'spaceUgyYn'	}
					, { id: 'infmPrsnIds'	}
					, { id: 'oppbScpCd'		}
					, { id: 'spaceRqprWbsCd'}
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

                ]
            });

            spaceRqprDataSet.on('load', function(e) {
            	spaceRqprDataSet.setNameValue(0, 'rqprAttcFileId', '');
            	spaceRqprDataSet.setNameValue(0, 'infmPrsnIds', '');
            	spaceRqprDataSet.setNameValue(0, 'spaceRqprInfmView', '');
            });

            bind = new Rui.data.LBind({
                groupId: 'mainForm',
                dataSet: spaceRqprDataSet,
                bind: true,
                bindInfo: [
					{ id: 'spaceNm',			ctrlId: 'spaceNm',			value:'value'},
                    { id: 'spaceScnCd',			ctrlId: 'spaceScnCd',		value:'value'},
                    { id: 'spaceSbc',		 	ctrlId: 'spaceSbc',		 	value:'value'},
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
                    { id: 'tCloud',		 		ctrlId: 'tCloud',		 	value:'value'}
                ]
            });
            spaceRqprDataSet.newRecord();


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
                remainRemoved: false,
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
                	, { field: 'infmPrsnId',	label: '<span style="color:red;">* </span>담당자ID',		sortable: false,	editable: false, editor: textBox,	align:'center',	width: 300 , hidden:true}
                    , { field: 'infmPrsnNm',	label: '<span style="color:red;">* </span>담당자',		sortable: false,	editable: false, editor: textBox,	align:'center',	width: 300 }
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
		        title: '평가방법(Tool)',
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

			/* 평가방법/담당자 삭제 */
            deleteSpaceRqprWayCrgr = function() {
                if(spaceRqprWayCrgrDataSet.getMarkedCount() > 0) {
                	spaceRqprWayCrgrDataSet.removeMarkedRows();
                } else {
                	alert('삭제 대상을 선택해주세요.');
                }
            };
            /********** 평가방법 삭제 **********/


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

				//alert(cmbCtgr0Cd.getDisplayValue());
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
					  { id: 'rltdId', defaultValue: '' }
					, { id: 'rqprId', defaultValue: '' }
					, { id: 'preRqprId' }
					, { id: 'preSpaceNm' }
					, { id: 'preAcpcNo' }
					, { id: 'preRgstId' }
					, { id: 'preRgstNm' }
                ]
            });

            var spaceRqprRltdColumnModel = new Rui.ui.grid.LColumnModel({
                columns: [
                	  new Rui.ui.grid.LSelectionColumn()
                    , new Rui.ui.grid.LNumberColumn()
                    , { field: 'preAcpcNo',		label: '접수번호',	sortable: false,	align:'center',	width: 80 }
                    , { field: 'preSpaceNm',	label: '평가명',		sortable: false,	align:'left',	width: 300 }
                    , { field: 'preRgstNm',		label: '의뢰자',		sortable: false,	align:'center',	width: 80 }

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

    	 	// 관련평가 세팅 //
    	    setSpaceRqprRltd = function(spaceRqpr) {
				if(spaceRqprRltdDataSet.findRow('preRqprId', spaceRqpr.rqprId) > -1) {
					alert('이미 존재합니다.');
					return ;
				}

				var row = spaceRqprRltdDataSet.newRecord();
				var record = spaceRqprRltdDataSet.getAt(row);

				record.set('preRqprId', spaceRqpr.rqprId);
				record.set('preSpaceNm', spaceRqpr.spaceNm);
				record.set('preAcpcNo', spaceRqpr.acpcNo);
				record.set('preRgstId', spaceRqpr.rgstId);
				record.set('preRgstNm', spaceRqpr.rgstNm);

    	    };
    	    // 관련평가 세팅 끝 //

    	    // 불러오기 //
    	    getSpaceRqprInfo = function(spaceRqpr) {
            	resetMainForm();

    	    	dm.loadDataSet({
                    dataSets: [spaceRqprDataSet, spaceRqprWayCrgrDataSet],
                    url: '<c:url value="/space/getSpaceRqprInfo.do"/>',
                    params: {
                        rqprId: spaceRqpr.rqprId
                    }
                });
    	    };

            /* 초기화 */
            resetMainForm = function() {

            	spaceRqprDataSet.clearData();			//메인 초기화
            	spaceRqprWayCrgrDataSet.clearData();	//평가방법/담당자 초기화
            	spaceRqprProdDataSet.clearData();		//제품군 초기화
            	spaceRqprRltdDataSet.clearData();		//관련평가 초기화
            	spaceRqprAttachDataSet.clearData();		//첨부파일 초기화

            	/* spaceRqprDataSet.clearData();
            	spaceRqprWayCrgrDataSet.clearData();
            	spaceRqprRltdDataSet.clearData();
            	spaceRqprAttachDataSet.clearData(); */
            	spaceRqprDataSet.newRecord();
            };


            /* 필수항목 체크 */
            var vm = new Rui.validate.LValidatorManager({
                validators:[
                { id: 'spaceNm',		validExp: '평가명:true:maxByteLength=100' },
                { id: 'spaceSbc',		validExp: '평가상세:true' },
                { id: 'spaceScnCd',		validExp: '평가목적:true' },
                { id: 'spaceUgyYn',		validExp: '긴급유무:true' },
                { id: 'oppbScpCd',		validExp: '공개범위:true' },
                { id: 'evCtgr',			validExp: '평가카테고리:true' },
                { id: 'evPrvs',			validExp: '평가항목:true' },
                { id: 'infmPrsnId',		validExp: '담당자:true' },
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

            /* 저장 */
            save = function() {
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

                if(confirm('저장 하시겠습니까?')) {
                    dm.updateDataSet({
                        dataSets:[spaceRqprDataSet, spaceRqprWayCrgrDataSet, spaceRqprProdDataSet, spaceRqprRltdDataSet],
                        url:'<c:url value="/space/regstSpaceRqpr.do"/>',
                        modifiedOnly: false
                    });
                }
            };

            goSpaceRqprList = function() {
    	    	$('#searchForm > input[name=spaceNm]').val(encodeURIComponent($('#searchForm > input[name=spaceNm]').val()));
    	    	$('#searchForm > input[name=rgstNm]').val(encodeURIComponent($('#searchForm > input[name=rgstNm]').val()));
    	    	//$('#searchForm > input[name=anlChrgNm]').val(encodeURIComponent($('#searchForm > input[name=anlChrgNm]').val()));

    	    	nwinsActSubmit(searchForm, "<c:url value="/space/spaceRqprList.do"/>");
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
		<input type="hidden" name="rgstNm" value="${inputData.rgstNm}"/>

		<input type="hidden" name="acpcNo" value="${inputData.acpcNo}"/>
		<input type="hidden" name="spaceAcpcStCd" value="${inputData.spaceAcpcStCd}"/>

		<input type="hidden" id="rqprId" name="rqprId" value=""/>

    </form>
    <form name="fileDownloadForm" id="fileDownloadForm">
		<input type="hidden" id="attcFilId" name="attcFilId" value=""/>
		<input type="hidden" id="seq" name="seq" value=""/>
    </form>
	<form name="mainForm" id="mainForm" method="post">
		<input type="hidden" id="spaceChrgId" name="spaceChrgId" value=""/>
   		<div class="contents">
	   		<div class="titleArea">
  				<a class="leftCon" href="#">
				<img src="/iris/resource/web/images/img_uxp/ico_leftCon.png" alt="Left Navigation Control">
				<span class="hidden">Toggle 버튼</span>
			</a>
  				<h2>평가의뢰서 등록</h2>
  			</div>

	   		<div class="sub-content">
				<div class="LblockButton mt0 mb5">
					<button type="button" class="btn"  id="resetBtn" name="resetBtn" onclick="resetMainForm()">초기화</button>
					<button type="button" class="btn"  id="loadSpaceRqprBtn" name="loadSpaceRqprBtn" onclick="openSpaceRqprSearchDialog(getSpaceRqprInfo)">불러오기</button>
					<button type="button" class="btn"  id="saveBtn" name="saveBtn" onclick="save()">저장</button>
					<button type="button" class="btn"  id="listBtn" name="listBtn" onclick="goSpaceRqprList()">목록</button>
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
   							<td colspan="3" class="rlabrqpr_tain01">
   								<input type="text" id="spaceNm">
   							</td>
   						</tr>
   						<tr>
   							<th align="right"><span style="color:red;">* </span>평가상세</th>
   							<td colspan="3" class="rlabrqpr_tain01">
   								<textarea id="spaceSbc"></textarea>
   							</td>
   						</tr>
   						<tr>
   							<th align="right"><span style="color:red;">* </span>평가목적</th>
   							<td>
                                <div id="spaceScnCd"></div>
   							</td>
   							<th align="right">WBS 코드</th>
   							<td>
   								<input type="text" id="spaceRqprWbsCd">
   							</td>

   						</tr>
   						<tr>
   							<th align="right"><span style="color:red;">* </span>긴급유무</th>
   							<td>
                                <div id="spaceUgyYn"></div>
   							</td>
   							<th align="right"><span style="color:red;">* </span>공개범위</th>
   							<td class="rlabrqpr_tain04">
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
   							<td colspan="3" class="rlabrqpr_tain01">
   								<input type="text" id="evSubjNm">
   							</td>
   						</tr>
   						<tr>
   							<th align="right"><span style="color:red;">* </span>제출처</th>
   							<td colspan="3" class="rlabrqpr_tain05">
   								<div id="sbmpCd"></div>&nbsp;<input type="text" id="sbmpNm">
   							</td>
   						</tr>

   						<tr>
   							<th align="right">목표(정량지표)</th>
   							<td class="rlabrqpr_tain01">
   								<input type="text" id="qtasDpst">
   							</td>
   							<th align="right">목표(정성지표)</th>
   							<td class="rlabrqpr_tain01">
                                <input type="text" id="qnasDpst">
   							</td>
   						</tr>

   						<tr>
   							<th align="right"><span style="color:red;">* </span>목표성능</th>
   							<td class="rlabrqpr_tain01">
                                <input type="text" id="goalPfmc">
   							</td>
   							<th align="right"><span style="color:red;">* </span>결과지표</th>
   							<td class="rlabrqpr_tain01">
                                <input type="text" id="rsltDpst">
   							</td>
   						</tr>
   						<tr>
   							<th align="right"><span style="color:red;">* </span>평가 cases(개수)</th>
   							<td class="rlabrqpr_tain01">
                                <input type="text" id="evCases">
   							</td>
   							<th align="right"><span style="color:red;">* </span>평가대상 상세</th>
   							<td class="rlabrqpr_tain01">
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
   				<!-- <div class="titArea">
   					<h3><span style="color:red;">* </span>평가대상 정보</h3>
   				</div> -->
				<div class="space_txt">
   					<b>제출자료</b><br/>
   					&nbsp;&nbsp;1) Simulation <br/>
					&nbsp;&nbsp;&nbsp;&nbsp;공간단위 : 현장 사진, 평면도, 단면도, 적용자재 Spec (자재 도면, 물성 등) 및 시험성적서<br/>
					&nbsp;&nbsp;&nbsp;&nbsp;자재단위 : 적용자재 Spec (자재도면, 물성 등) 및 시험 성적서<br/>
					&nbsp;&nbsp;2) Mock-up : 적용자재 Spec (자재도면, 물성 등) 및 시험 성적서<br/>
					&nbsp;&nbsp;3) Certification : 적용자재 Spec (자재도면, 물성 등) 및 시험 성적서
   				</div>


   				<div class="titArea" style="margin-top:35px;">
   					<h3><span style="color:red;">* </span>평가방법</h3>
   					<div class="LblockButton">
   						<button type="button" class="btn"  id="penSpaceChrgListDialogBtn" name="penSpaceChrgListDialogBtn" onclick="openSpaceChrgListDialog(setSpaceChrgInfo);">추가</button>
   						<button type="button" class="btn"  id="deleteSpaceRqprWayCrgrBtn" name="deleteSpaceRqprWayCrgrBtn" onclick="deleteSpaceRqprWayCrgr();">삭제</button>
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





   				<table style="width:100%;border=0;">
   					<colgroup>
						<col style="width:49%;">
						<col style="width:2%;">
						<col style="width:49%;">
   					</colgroup>
   					<tbody>
   						<tr>
   							<td>
				   				<div class="titArea">
				   					<h3>관련평가</h3>
				   					<div class="LblockButton">
				   						<button type="button" class="btn"  id="addSpaceRqprRltdBtn" name="addSpaceRqprRltdBtn" onclick="openSpaceRqprSearchDialog(setSpaceRqprRltd)">추가</button>
				   						<button type="button" class="btn"  id="deleteSpaceRqprRltdBtn" name="deleteSpaceRqprRltdBtn" onclick="deleteSpaceRqprRltd()">삭제</button>
				   					</div>
				   				</div>

				   				<div id="spaceRqprRltdGrid"></div>
   							</td>
   							<td>&nbsp;</td>
   							<td>
				   				<div class="titArea">
				   					<h3>첨부파일</h3>
				   					<div class="LblockButton">
				   						<button type="button" class="btn"  id="addSpaceRqprAttachBtn" name="addSpaceRqprAttachBtn" onclick="openAttachFileDialog(setSpaceRqprAttach, spaceRqprDataSet.getNameValue(0, 'rqprAttcFileId'), 'spacePolicy', '*', 'M', '첨부파일')">파일첨부</button>
				   					</div>
				   				</div>

				   				<div id="spaceRqprAttachGrid"></div>
   							</td>
   						</tr>
   					</tbody>
   				</table>

   			</div><!-- //sub-content -->
   		</div><!-- //contents -->
		</form>
    </body>
</html>