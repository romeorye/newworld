<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*,
				 java.util.*,
				 devonframe.util.NullUtil,
				 devonframe.util.DateUtil"%>

<%--
/*
 *************************************************************************
 * $Id		: rlabRqprDetail.jsp
 * @desc    : 시험의뢰서 상세
 *------------------------------------------------------------------------
 * VER	DATE		AUTHOR		DESCRIPTION
 * ---	-----------	----------	-----------------------------------------
 * 1.0  2018.08.16  정현웅		최초생성
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
		var rlabRqprDataSet;
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
                var data = rlabRqprSmpoDataSet.getReadData(e);

                if(Rui.isEmpty(data.records[0].resultMsg) == false) {
                    alert(data.records[0].resultMsg);
                }

                if(data.records[0].resultYn == 'Y') {
                	if(data.records[0].cmd == 'update') {
                		;
                	} else if(data.records[0].cmd == 'requestApproval') {
                		// guid= B : 신뢰성 분석의뢰, D : 신뢰성 분석완료, E : 공간성능 평가의뢰, G : 공간성능 평가완료 + rqprId
                    	var url = '<%=lghausysPath%>/lgchem/approval.front.document.RetrieveDocumentFormCmd.lgc?appCode=APP00333&approvalLineInform=SUB001&from=iris&guid=B${inputData.rqprId}';

                   		openWindow(url, 'rlabRqprApprovalPop', 800, 500, 'yes');
                	} else {
                    	goRlabRqprList();
                	}
                }
            });

            var tabView = new Rui.ui.tab.LTabView({
            	height: 1250,
                tabs: [ {
                        active: true,
                        label: '의뢰정보',
                        id: 'rlabRqprInfoDiv'
                    }, {
                    	label: '시험결과',
                        id: 'rlabRqprResultDiv'
                    }, {
                        label: '의견<span id="opinitionCnt"/>',
                        id: 'rlabRqprOpinitionDiv'
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
	            	if(rlabRqprDataSet.getNameValue(0, 'rlabAcpcStCd') != '07') {
	            		alert('시험 결과 확인은 시험이 완료 된 후 확인이 가능 합니다.');
	            		return false;
	            	}

	                break;

	            case 2:

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

                default:
                    break;
                }

            });

            tabView.render('tabView');

            rlabScnCdDataSet = new Rui.data.LJsonDataSet({
                id: 'rlabScnCdDataSet',
                remainRemoved: true,
                lazyLoad: true,
                fields: [
                	  { id: 'COM_DTL_CD' }
                	, { id: 'COM_DTL_NM' }
                ]
            });

            rlabScnCdDataSet.load({
                url: '<c:url value="/common/code/retrieveCodeListForCache.do"/>',
                params :{
                	comCd : 'RLAB_SCN_CD'
                }
            });

        /* <c:if test="${fn:indexOf(inputData._roleId, 'WORK_IRI_T06') == -1}">
	        rlabScnCdDataSet.on('load', function(e) {
	        	rlabScnCdDataSet.removeAt(rlabScnCdDataSet.findRow('COM_DTL_CD', 'O'));
	        });
        </c:if> */

            var textBox = new Rui.ui.form.LTextBox({
                emptyValue: ''
            });

            var numberBox = new Rui.ui.form.LNumberBox({
                emptyValue: '',
                minValue: 0,
                maxValue: 99999
            });

            var rlabNm = new Rui.ui.form.LTextBox({
            	applyTo: 'rlabNm',
                placeholder: '시험명을 입력해주세요.',
                defaultValue: '',
                emptyValue: '',
                width: 400
            });

            var rlabChrgNm = new Rui.ui.form.LPopupTextBox({
            	applyTo: 'rlabChrgNm',
                placeholder: '시험담당자를 입력해주세요.',
                defaultValue: '',
                emptyValue: '',
                editable: false,
                width: 200
            });
            rlabChrgNm.on('popup', function(e){
                openUserSearchDialog(setRlabChrgInfo, 1, '');
            });

            var rlabScnCd = new Rui.ui.form.LCombo({
                applyTo: 'rlabScnCd',
                name: 'rlabScnCd',
                emptyText: '선택',
                defaultValue: '',
                emptyValue: '',
                width: 110,
                dataSet: rlabScnCdDataSet,
                displayField: 'COM_DTL_NM',
                valueField: 'COM_DTL_CD'
            });

            var rlabUgyYn = new Rui.ui.form.LCombo({
                applyTo: 'rlabUgyYn',
                name: 'rlabUgyYn',
                emptyText: '선택',
                defaultValue: '',
                emptyValue: '',
                width: 110,
                url: '<c:url value="/common/code/retrieveCodeListForCache.do?comCd=ANL_UGY_YN"/>',
                displayField: 'COM_DTL_NM',
                valueField: 'COM_DTL_CD'
            });

            /*통보유형*/
            var infmTypeCd = new Rui.ui.form.LRadioGroup({
                applyTo : 'infmTypeCd',
                name : 'infmTypeCd',
                items : [
					<c:forEach var="data" items="${ infmTypeCdList }" varStatus="status">
						<c:choose>
							<c:when test="${status.index == 0}">
			                   { label : "${ data.COM_DTL_NM }" , name: "infmTypeCd" , value : "${ data.COM_DTL_CD }" }
							</c:when>
							<c:otherwise>
			   	        	, { label: '${ data.COM_DTL_NM }', value: '${ data.COM_DTL_CD }'}
							</c:otherwise>
						</c:choose>
			    	</c:forEach>
                ]
            });

            var smpoTrtmCd = new Rui.ui.form.LRadioGroup({
                applyTo : 'smpoTrtmCd',
                name : 'smpoTrtmCd',
                items : [
					<c:forEach var="data" items="${ smpoTrtmCdList }" varStatus="status">
						<c:choose>
							<c:when test="${status.index == 0}">
			                   { label : "${ data.COM_DTL_NM }" , name: "smpoTrtmCd" , value : "${ data.COM_DTL_CD }" }
							</c:when>
							<c:otherwise>
			   	        	, { label: '${ data.COM_DTL_NM }', value: '${ data.COM_DTL_CD }'}
							</c:otherwise>
						</c:choose>
			    	</c:forEach>
                ]
            });

            rlabRqprInfmView = new Rui.ui.form.LPopupTextBox({
                applyTo: 'rlabRqprInfmView',
                width: 400,
                editable: false,
                placeholder: '통보자를 입력해주세요.',
                emptyValue: '',
                enterToPopup: true
            });

            rlabRqprInfmView.on('popup', function(e){
            	openUserSearchDialog(setRlabRqprInfm, 10, rlabRqprDataSet.getNameValue(0, 'infmPrsnIds'), 'rlab');
            });

            var rlabSbc = new Rui.ui.form.LTextArea({
                applyTo: 'rlabSbc',
                placeholder: '시험배경과 목적, 결과 활용방안을 자세히 기재하여 주시기 바랍니다.',
                emptyValue: '',
                width: 980,
                height: 75
            });

            var vm = new Rui.validate.LValidatorManager({
                validators:[
                { id: 'rlabNm',				validExp: '시험명:true:maxByteLength=100' },
                { id: 'rlabSbc',				validExp: '시험내용:true' },
                { id: 'rlabScnCd',			validExp: '시험구분:true' },
                { id: 'rlabChrgId',			validExp: '시험담당자:true' },
                { id: 'rlabUgyYn',			validExp: '긴급유무:true' },
                { id: 'infmTypeCd',			validExp: '통보유형:true' },
                { id: 'smpoTrtmCd',			validExp: '시료처리:true' },
//                 { id: 'rlabRqprInfmView',	validExp: '통보자:true' },
                { id: 'smpoNm',				validExp: '시료명:true:maxByteLength=100' },
                { id: 'mkrNm',				validExp: '제조사:true:maxByteLength=100' },
                { id: 'mdlNm',				validExp: '모델명:true:maxByteLength=100' },
                { id: 'smpoQty',			validExp: '수량:true:number' }
                ]
            });

            rlabRqprDataSet = new Rui.data.LJsonDataSet({
                id: 'rlabRqprDataSet',
                remainRemoved: true,
                lazyLoad: true,
                fields: [
                	  { id: 'rqprId' }
                	, { id: 'rlabNm' }
					, { id: 'rlabSbc' }
					, { id: 'acpcNo' }
					, { id: 'acpcStNm' }
					, { id: 'rgstNm' }
					, { id: 'rqprDeptNm' }
					, { id: 'rqprDt' }
					, { id: 'acpcDt' }
					, { id: 'cmplParrDt' }
					, { id: 'cmplDt' }
					, { id: 'rlabScnCd' }
					, { id: 'rlabChrgId' }
					, { id: 'rlabChrgNm' }
					, { id: 'rlabUgyYn' }
					, { id: 'infmTypeCd' }
					, { id: 'smpoTrtmCd' }
					, { id: 'infmPrsnIds' }
					, { id: 'rlabRqprInfmView' }
					, { id: 'rlabRsltSbc' }
					, { id: 'rlabAcpcStCd' }
					, { id: 'rqprAttcFileId', defaultValue: '' }
					, { id: 'reqItgRdcsId' }
                ]
            });

            rlabRqprDataSet.on('load', function(e) {
            	var opinitionCnt = rlabRqprDataSet.getNameValue(0, 'opinitionCnt');
            	var rlabRsltSbc = rlabRqprDataSet.getNameValue(0, 'rlabRsltSbc');

            	if(opinitionCnt > 0) {
            		$('#opinitionCnt').html('(' + opinitionCnt + ')');
            	}

            	if(Rui.isEmpty(rlabRsltSbc) == false) {
                	rlabRqprDataSet.setNameValue(0, 'rlabRsltSbc', rlabRsltSbc.replaceAll('\n', '<br/>'));
            	}

            	if(!Rui.isEmpty(rlabRqprDataSet.getNameValue(0, 'reqItgRdcsId'))) {
            		$('#reqApprStateBtn').show();
            	}

            	//button controll
            	if( rlabRqprDataSet.getNameValue(0, 'rlabAcpcStCd')  == "07" ){
            		 $( '#saveBtn' ).hide();
            		 $( '#approvalBtn' ).hide();
            		 $( '#deleteBtn' ).hide();
            	}
            });

            var rlabRqprOpinitionDataSet = new Rui.data.LJsonDataSet({
                id: 'rlabRqprOpinitionDataSet',
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
                ]
            });

            rlabRqprOpinitionDataSet.on('load', function(e) {
            	var cnt = rlabRqprOpinitionDataSet.getCount();

            	parent.$("#opinitionCnt").html(cnt == 0 ? '' : '(' + cnt + ')');
   	      	});

            var rlabRqprOpinitionColumnModel = new Rui.ui.grid.LColumnModel({
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
  		  	    		  var strBtnFun = "openAttachFileDialog(setAttachFileInfo, "+recordFilId+", 'knldPolicy', '*' ,'R')";
  		  	    		  //return Rui.isUndefined(record.get('attcFilId')) ? '' : '<button type="button"  class="L-grid-button" onclick="'+strBtnFun+'">다운로드</button>';
  		  	    			if(record.get('attcFilId').length<1){
  		  	    				return '';
	  	    				}else{
	  	    					return '<button type="button"  class="L-grid-button" onclick="'+strBtnFun+'">다운로드</button>';
	  	    				}
                        }}
                    , { field: 'attcFilId',	hidden : true}
                    , { field: 'opiId',	hidden : true}
                ]
            });

            var rlabRqprOpinitionGrid = new Rui.ui.grid.LGridPanel({
                columnModel: rlabRqprOpinitionColumnModel,
                dataSet: rlabRqprOpinitionDataSet,
                width: 980,
                height: 380,
                autoToEdit: true,
                autoWidth: true,
                autoHeight: true
            });

            rlabRqprOpinitionGrid.render('rlabRqprOpinitionGrid');

            bind = new Rui.data.LBind({
                groupId: 'rlabRqprInfoDiv',
                dataSet: rlabRqprDataSet,
                bind: true,
                bindInfo: [
                    { id: 'rlabNm',				ctrlId:'rlabNm',			value:'value'},
                    { id: 'rlabSbc',			ctrlId:'rlabSbc',			value:'value'},
                    { id: 'acpcNo',				ctrlId:'acpcNo',			value:'html'},
                    { id: 'rgstNm',				ctrlId:'rgstNm',			value:'html'},
                    { id: 'rqprDeptNm',			ctrlId:'rqprDeptNm',		value:'html'},
                    { id: 'rqprDt',				ctrlId:'rqprDt',			value:'html'},
                    { id: 'acpcDt',				ctrlId:'acpcDt',			value:'html'},
                    { id: 'rlabScnCd',			ctrlId:'rlabScnCd',			value:'value'},
                    { id: 'rlabChrgId',			ctrlId:'rlabChrgId',		value:'value'},
                    { id: 'rlabChrgNm',			ctrlId:'rlabChrgNm',		value:'value'},
                    { id: 'rlabUgyYn',			ctrlId:'rlabUgyYn',			value:'value'},
                    { id: 'infmTypeCd',			ctrlId:'infmTypeCd',		value:'value'},
                    { id: 'smpoTrtmCd',			ctrlId:'smpoTrtmCd',		value:'value'},
                    { id: 'acpcStNm',			ctrlId:'acpcStNm',			value:'html'},
                    { id: 'rlabRqprInfmView',	ctrlId:'rlabRqprInfmView',	value:'value'}
                ]
            });


            resultBind = new Rui.data.LBind({
                groupId: 'rlabRqprResultDiv',
                dataSet: rlabRqprDataSet,
                bind: true,
                bindInfo: [
                    { id: 'rlabNm',				ctrlId:'rlabNm',				value:'html'},
                    { id: 'acpcNo',				ctrlId:'acpcNo',			value:'html'},
                    { id: 'cmplParrDt',			ctrlId:'cmplParrDt',		value:'html'},
                    { id: 'cmplDt',				ctrlId:'cmplDt',			value:'html'},
                    { id: 'rlabRqprInfmView',	ctrlId:'rlabRqprInfmView',	value:'html'},
                    { id: 'rlabRsltSbc',			ctrlId:'rlabRsltSbc',		value:'html'}
                ]
            });

            opinitionBind = new Rui.data.LBind({
                groupId: 'rlabRqprOpinitionDiv',
                dataSet: rlabRqprOpinitionDataSet,
                bind: true,
                bindInfo: [
                    { id: 'rgstNm',				ctrlId:'rgstNm',				value:'html'},
                    { id: 'rgstDt',				ctrlId:'rgstDt',			value:'html'},
                    { id: 'opiSbc',				ctrlId:'opiSbc',		value:'html'}
                ]
            });

            var rlabRqprSmpoDataSet = new Rui.data.LJsonDataSet({
                id: 'rlabRqprSmpoDataSet',
                remainRemoved: true,
                lazyLoad: true,
                fields: [
                	  { id: 'smpoId' }
                	, { id: 'rqprId', defaultValue: '${inputData.rqprId}' }
					, { id: 'smpoNm' }
					, { id: 'mkrNm' }
					, { id: 'mdlNm' }
					, { id: 'smpoQty', type: 'number' }
                ]
            });

            rlabRqprSmpoDataSet.on('canRowPosChange', function(e){
            	if (vm.validateDataSet(rlabRqprSmpoDataSet, rlabRqprSmpoDataSet.getRow()) == false) {
                    alert(Rui.getMessageManager().get('$.base.msg052') + '\n' + vm.getMessageList().join('\n'));
                    return false;
                }
            });

            var rlabRqprSmpoColumnModel = new Rui.ui.grid.LColumnModel({
                columns: [
                	  new Rui.ui.grid.LSelectionColumn()
                	, new Rui.ui.grid.LStateColumn()
                    , new Rui.ui.grid.LNumberColumn()
                    , { field: 'smpoNm',	label: '시료명',		sortable: false,	editable: true, editor: textBox,	align:'center',	width: 400 }
                    , { field: 'mkrNm',		label: '제조사',		sortable: false,	editable: true, editor: textBox,	align:'center',	width: 320 }
                    , { field: 'mdlNm',		label: '모델명',		sortable: false,	editable: true, editor: textBox,	align:'center',	width: 300 }
                    , { field: 'smpoQty',	label: '수량',		sortable: false,	editable: true, editor: numberBox,	align:'center',	width: 50 }
                ]
            });

            var rlabRqprSmpoGrid = new Rui.ui.grid.LGridPanel({
                columnModel: rlabRqprSmpoColumnModel,
                dataSet: rlabRqprSmpoDataSet,
                width: 700,
                height: 400,
                autoToEdit: true,
                autoWidth: true
            });

            rlabRqprSmpoGrid.render('rlabRqprSmpoGrid');

            /* 시료정보 추가 */
            addRlabRqprSmpo = function() {
				rlabRqprSmpoDataSet.newRecord();
            };

            /* 시료정보 삭제 */
            deleteRlabRqprSmpo = function() {
                if(rlabRqprSmpoDataSet.getMarkedCount() > 0) {
                	rlabRqprSmpoDataSet.removeMarkedRows();
                } else {
                	alert('삭제 대상을 선택해주세요.');
                }
            };

            var rlabRqprRltdDataSet = new Rui.data.LJsonDataSet({
                id: 'rlabRqprRltdDataSet',
                remainRemoved: true,
                lazyLoad: true,
                fields: [
					  { id: 'rltdId' }
					, { id: 'rqprId' }
					, { id: 'preRqprId' }
					, { id: 'preRlabNm' }
					, { id: 'preAcpcNo' }
					, { id: 'preRlabChrgNm' }
					, { id: 'preRgstId' }
					, { id: 'preRgstNm' }
                ]
            });

            var rlabRqprRltdColumnModel = new Rui.ui.grid.LColumnModel({
                columns: [
                	  new Rui.ui.grid.LSelectionColumn()
                  	, new Rui.ui.grid.LStateColumn()
                    , new Rui.ui.grid.LNumberColumn()
                    , { field: 'preAcpcNo',		label: '접수번호',		sortable: false,	align:'center',	width: 80 }
                    , { field: 'preRlabNm',		label: '시험명',		sortable: false,	align:'left',	width: 300 }
                    , { field: 'preRgstNm',		label: '의뢰자',		sortable: false,	align:'center',	width: 80 }
                    , { field: 'preRlabChrgNm',	label: '시험담당자',	sortable: false,	align:'center',	width: 80 }
                ]
            });

            var rlabRqprRltdGrid = new Rui.ui.grid.LGridPanel({
                columnModel: rlabRqprRltdColumnModel,
                dataSet: rlabRqprRltdDataSet,
                width: 540,
                height: 200,
                autoToEdit: false,
                autoWidth: true
            });

            rlabRqprRltdGrid.render('rlabRqprRltdGrid');

            /* 관련시험 삭제 */
            deleteRlabRqprRltd = function() {
                if(rlabRqprRltdDataSet.getMarkedCount() > 0) {
                	rlabRqprRltdDataSet.removeMarkedRows();
                } else {
                	alert('삭제 대상을 선택해주세요.');
                }
            };

            var rlabRqprAttachDataSet = new Rui.data.LJsonDataSet({
                id: 'rlabRqprAttachDataSet',
                remainRemoved: true,
                lazyLoad: true,
                fields: [
					  { id: 'attcFilId'}
					, { id: 'seq' }
					, { id: 'filNm' }
					, { id: 'filSize' }
                ]
            });

            var rlabRqprAttachColumnModel = new Rui.ui.grid.LColumnModel({
                columns: [
                      new Rui.ui.grid.LNumberColumn()
                    , { field: 'filNm',		label: '파일명',		sortable: false,	align:'left',	width: 470 }
                ]
            });

            var rlabRqprAttachGrid = new Rui.ui.grid.LGridPanel({
                columnModel: rlabRqprAttachColumnModel,
                dataSet: rlabRqprAttachDataSet,
                width: 300,
                height: 200,
                autoToEdit: false,
                autoWidth: true
            });

            rlabRqprAttachGrid.on('cellClick', function(e) {
                if(e.colId == "filNm") {
                	downloadAttachFile(rlabRqprAttachDataSet.getAt(e.row).data.attcFilId, rlabRqprAttachDataSet.getAt(e.row).data.seq);
                }
            });

            rlabRqprAttachGrid.render('rlabRqprAttachGrid');

    	    // 첨부파일 정보 설정
    	    setRlabRqprAttach = function(attachFileList) {
    	    	rlabRqprAttachDataSet.clearData();

    	    	if(attachFileList.length > 0) {
    	    		rlabRqprDataSet.setNameValue(0, 'rqprAttcFileId', attachFileList[0].data.attcFilId);

        	    	for(var i=0; i<attachFileList.length; i++) {
        	    		rlabRqprAttachDataSet.add(attachFileList[i]);
        	    	}
    	    	}
    	    };

			downloadAttachFile = function(attcFilId, seq) {
				fileDownloadForm.action = '<c:url value='/system/attach/downloadAttachFile.do'/>';
				$('#attcFilId', fileDownloadForm).val(attcFilId);
				$('#seq', fileDownloadForm).val(seq);
				fileDownloadForm.submit();
			};

			var rlabRqprRsltAttachDataSet = rlabRqprAttachDataSet.clone('rlabRqprRsltAttachDataSet');

            rlabRqprRsltAttachDataSet.on('load', function(e) {
				for( var i = 0, size = rlabRqprRsltAttachDataSet.getCount(); i < size ; i++ ) {
        	    	$('#rsltAttcFileView').append($('<a/>', {
        	            href: 'javascript:downloadAttachFile("' + rlabRqprRsltAttachDataSet.getAt(i).data.attcFilId + '", "' + rlabRqprRsltAttachDataSet.getAt(i).data.seq + '")',
        	            text: rlabRqprRsltAttachDataSet.getAt(i).data.filNm
        	        })).append('<br/>');
				}
            });

    	    setRlabRqprInfm = function(userList) {
    	    	var idList = [];
    	    	var nameList = [];

    	    	for(var i=0, size=userList.length; i<size; i++) {
    	    		idList.push(userList[i].saUser);
    	    		nameList.push(userList[i].saName);
    	    	}

    	    	rlabRqprInfmView.setValue(nameList.join(', '));
    	    	rlabRqprDataSet.setNameValue(0, 'infmPrsnIds', idList);
    	    };

			// 시험 담당자 선택팝업 시작
		    rlabChrgListDialog = new Rui.ui.LFrameDialog({
		        id: 'rlabChrgListDialog',
		        title: '시험담당자',
		        width: 530,
		        height: 500,
		        modal: true,
		        visible: false,
		        buttons: [
		            { text:'닫기', isDefault: true, handler: function() {
		            	this.cancel();
		            } }
		        ]
		    });

		    rlabChrgListDialog.render(document.body);

			openRlabChrgListDialog = function(f) {
				_callback = f;

				rlabChrgListDialog.setUrl('<c:url value="/rlab/rlabChrgDialog.do"/>');
				rlabChrgListDialog.show();
			};
			// 시험 담당자 선택팝업 끝

            setRlabChrgInfo = function(rlabChrgInfo) {
            	rlabRqprDataSet.setNameValue(0, 'rlabChrgId', rlabChrgInfo.saUser);
            	rlabRqprDataSet.setNameValue(0, 'rlabChrgNm', rlabChrgInfo.saName);
            };

    	    // 관련시험 조회 팝업 시작
    	    rlabRqprSearchDialog = new Rui.ui.LFrameDialog({
    	        id: 'rlabRqprSearchDialog',
    	        title: '관련시험 조회',
    	        width: 750,
    	        height: 470,
    	        modal: true,
    	        visible: false
    	    });

    	    rlabRqprSearchDialog.render(document.body);

    	    openRlabRqprSearchDialog = function(f) {
    	    	callback = f;

    	    	rlabRqprSearchDialog.setUrl('<c:url value="/rlab/rlabRqprSearchPopup.do"/>');
    		    rlabRqprSearchDialog.show();
    	    };
    	    // 관련시험 조회 팝업 끝

    	    setRlabRqprRltd = function(rlabRqpr) {
				if(rlabRqprRltdDataSet.findRow('preRqprId', rlabRqpr.rqprId) > -1) {
					alert('이미 존재합니다.');
					return ;
				}

				var row = rlabRqprRltdDataSet.newRecord();
				var record = rlabRqprRltdDataSet.getAt(row);

                record.set('rqprId', rlabRqprDataSet.getNameValue(0, 'rqprId'));
				record.set('preRqprId', rlabRqpr.rqprId);
				record.set('preRlabNm', rlabRqpr.rlabNm);
				record.set('preAcpcNo', rlabRqpr.acpcNo);
				record.set('preRgstId', rlabRqpr.rgstId);
				record.set('preRgstNm', rlabRqpr.rgstNm);
				record.set('preRlabChrgNm', rlabRqpr.rlabChrgNm);
    	    };

    	    // 시험의뢰 의견 팝업 시작
    	    rlabRqprOpinitionDialog = new Rui.ui.LFrameDialog({
    	        id: 'rlabRqprOpinitionDialog',
    	        title: '의견 교환',
    	        width: 830,
    	        height: 500,
    	        modal: true,
    	        visible: false
    	    });

    	    rlabRqprOpinitionDialog.render(document.body);

    	    openRlabRqprOpinitionDialog = function() {
    	    	rlabRqprOpinitionDialog.setUrl('<c:url value="/rlab/rlabRqprOpinitionPopup.do?rqprId=${inputData.rqprId}"/>');
    	    	rlabRqprOpinitionDialog.show();
    	    };
    	    // 시험의뢰 의견 팝업 끝

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
		    	opinitionDialog.setUrl('<c:url value="/rlab/openAddOpinitionPopup.do"/>');
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
		        buttons : [
		            { text: '저장', handler: callChildUpdate, isDefault: true },
		            { text: '삭제', handler: callChildDel, isDefault: true },
		            { text:'닫기', handler: function() {
		              	this.cancel(false);
		              }
		            }
		        ]
		    });

			opinitionUpdateDialog.render(document.body);

			openOpinitionUpdateDialog = function(f) {
		    	_callback = f;
		    	opinitionUpdateDialog.setUrl('<c:url value="/rlab/openAddOpinitionPopup.do"/>');
		    	opinitionUpdateDialog.show();
		    };

		    /* 시험의뢰 의견 리스트 조회 */
            getRlabRqprOpinitionList = function(msg) {
            	closePop = function(){
            		opinitionDialog.cancel(false);
                	opinitionUpdateDialog.cancel(false);
                	Rui.alert(msg);
            	}
            	rlabRqprOpinitionDataSet.load({
                    url: '<c:url value="/rlab/getRlabRqprOpinitionList.do"/>',
                    params :{
                    	rqprId : '${inputData.rqprId}'
                    }
                });
            	if(!Rui.isUndefined(msg)){
	            	closePop();
            	}
            };

            getRlabRqprOpinitionList();

         	// 수정 버튼
            opinitionUpdate = function() {
            	opiId=rlabRqprOpinitionDataSet.getAt(rlabRqprOpinitionDataSet.rowPosition).data.opiId;
            	openOpinitionUpdateDialog(setOpinitionUpdateInfo);
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

    	    /* 유효성 검사 */
    	    isValidate = function(type) {
                if (rlabRqprDataSet.getNameValue(0, 'rlabAcpcStCd') != '00') {
                    alert('작성중 상태일때만 ' + type + ' 할 수 있습니다.');
                    return false;
                }

                if (vm.validateDataSet(rlabRqprDataSet) == false) {
                    alert(Rui.getMessageManager().get('$.base.msg052') + '\n' + vm.getMessageList().join('\n'));
                    return false;
                }

                var rlabRqprSmpoDataSetCnt = rlabRqprSmpoDataSet.getCount();
                var rlabRqprSmpoDataSetDelCnt = 0;

                for(var i=0; i<rlabRqprSmpoDataSetCnt; i++) {
                	if(rlabRqprSmpoDataSet.isRowDeleted(i)) {
                		rlabRqprSmpoDataSetDelCnt++;
                	}
                }

                if (rlabRqprSmpoDataSetCnt == rlabRqprSmpoDataSetDelCnt) {
                    alert('시료정보를 입력해주세요.');
                    return false;
                } else if (vm.validateDataSet(rlabRqprSmpoDataSet) == false) {
                    alert(Rui.getMessageManager().get('$.base.msg052') + '\n' + vm.getMessageList().join('\n'));
                    return false;
                }

//                 if (rlabRqprAttachDataSet.getCount() == 0) {
//                 	alert('시료사진/첨부파일을 첨부해주세요.');
//                 	return false;
//                 }

                return true;
    	    }

            /* 저장 */
            save = function() {
                if(isValidate('작성')) {
                	if(confirm('저장 하시겠습니까?')) {
                        dm.updateDataSet({
                            dataSets:[rlabRqprDataSet, rlabRqprSmpoDataSet, rlabRqprRltdDataSet],
                            url:'<c:url value="/rlab/updateRlabRqpr.do"/>',
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
                            dataSets:[rlabRqprDataSet, rlabRqprSmpoDataSet, rlabRqprRltdDataSet],
                            url:'<c:url value="/rlab/requestRlabRqprApproval.do"/>',
                            modifiedOnly: false
                        });
                	}
                }
            };

            /* 삭제 */
            deleteRlabRqpr = function() {
                if ('00|04'.indexOf(rlabRqprDataSet.getNameValue(0, 'rlabAcpcStCd')) == -1) {
                    alert('작성중, 접수반려 상태일때만 삭제할 수 있습니다.');
                    return false;
                }

            	if(confirm('삭제 하시겠습니까?')) {
                    dm.updateDataSet({
                        url:'<c:url value="/rlab/deleteRlabRqpr.do"/>',
                        params: {
                            rqprId: rlabRqprDataSet.getNameValue(0, 'rqprId')
                        }
                    });
            	}
            };

            //통보자 추가 저장
            addRlabRqprInfm = function(){
            	if ('07'.indexOf(rlabRqprDataSet.getNameValue(0, 'rlabAcpcStCd')) == -1) {
                    alert('완료 상태일때만 삭제할 수 있습니다.');
                    return false;
                }

            	dm.updateDataSet({
                    url:'<c:url value="/rlab/insertRlabRqprInfm.do"/>',
                    dataSets:[rlabRqprDataSet, rlabRqprSmpoDataSet, rlabRqprRltdDataSet],
                    params: {
                        rqprId: rlabRqprDataSet.getNameValue(0, 'rqprId')
                    }
                });
            }

    	    goRlabRqprList = function() {
    	    	$('#searchForm > input[name=rlabNm]').val(encodeURIComponent($('#searchForm > input[name=rlabNm]').val()));
    	    	$('#searchForm > input[name=rgstNm]').val(encodeURIComponent($('#searchForm > input[name=rgstNm]').val()));
    	    	$('#searchForm > input[name=rlabChrgNm]').val(encodeURIComponent($('#searchForm > input[name=rlabChrgNm]').val()));

    	    	nwinsActSubmit(searchForm, "<c:url value="/rlab/rlabRqprList.do"/>");
    	    };

    	    openApprStatePopup = function(type) {
    	    	var seq = rlabRqprDataSet.getNameValue(0, 'reqItgRdcsId');
            	var url = '<%=lghausysPath%>/lgchem/approval.front.approval.RetrieveAppTargetCmd.lgc?seq=' + seq;

           		openWindow(url, 'openApprStatePopup', 800, 250, 'yes');
    	    };

	    	dm.loadDataSet({
                dataSets: [rlabRqprDataSet, rlabRqprSmpoDataSet, rlabRqprRltdDataSet, rlabRqprAttachDataSet, rlabRqprRsltAttachDataSet],
                url: '<c:url value="/rlab/getRlabRqprDetailInfo.do"/>',
                params: {
                    rqprId: '${inputData.rqprId}'
                }
            });
        });
	</script>
    </head>
    <body>
    <form name="searchForm" id="searchForm">
		<input type="hidden" name="rlabNm" value="${inputData.rlabNm}"/>
		<input type="hidden" name="fromRqprDt" value="${inputData.fromRqprDt}"/>
		<input type="hidden" name="toRqprDt" value="${inputData.toRqprDt}"/>
		<input type="hidden" name="rgstNm" value="${inputData.rgstNm}"/>
		<input type="hidden" name="rgstId" value="${inputData.rgstId}"/>
		<input type="hidden" name="rlabChrgNm" value="${inputData.rlabChrgNm}"/>
		<input type="hidden" name="acpcNo" value="${inputData.acpcNo}"/>
		<input type="hidden" name="rlabAcpcStCd" value="${inputData.rlabAcpcStCd}"/>
    </form>
    <form name="fileDownloadForm" id="fileDownloadForm">
		<input type="hidden" id="attcFilId" name="attcFilId" value=""/>
		<input type="hidden" id="seq" name="seq" value=""/>
    </form>
   		<div class="contents">

   			<div class="sub-content">
	   			<div class="titleArea">
	   				<h2>시험의뢰서 상세</h2>
	   			</div>
   				<div id="tabView"></div>
	            <div id="rlabRqprInfoDiv">
				<form name="aform" id="aform" method="post">
					<input type="hidden" id="rlabChrgId" name="rlabChrgId" value=""/>
   				<div class="titArea">
   					<div class="LblockButton">
   						<button type="button" class="btn"  id="reqApprStateBtn" name="reqApprStateBtn" onclick="openApprStatePopup()" style="display:none;">결재상태</button>
   						<button type="button" class="btn"  id="saveBtn" name="saveBtn" onclick="save()">저장</button>
   						<button type="button" class="btn"  id="approvalBtn" name="approvalBtn" onclick="approval()">결재</button>
   						<button type="button" class="btn"  id="deleteBtn" name="deleteBtn" onclick="deleteRlabRqpr()">삭제</button>
   						<button type="button" class="btn"  id="listBtn" name="listBtn" onclick="goRlabRqprList()">목록</button>
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
   							<th align="right">시험명</th>
   							<td>
   								<input type="text" id="rlabNm">
   							</td>
   							<th align="right">접수번호</th>
   							<td><span id="acpcNo"/></td>
   						</tr>
   						<tr>
   							<th align="right">시험목적</th>
   							<td colspan="3">
   								<textarea id="rlabSbc"></textarea>
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
   							<th align="right">시험구분</th>
   							<td>
                                <div id="rlabScnCd"></div>
   							</td>
   							<th align="right">시험담당자</th>
   							<td>
   								<input type="text" id="rlabChrgNm">
                                <!-- <a href="javascript:openRlabChrgListDialog(setRlabChrgInfo);" class="icoBtn">검색</a> -->
                            </td>
   						</tr>
   						<tr>
   							<th align="right">긴급유무</th>
   							<td>
                                <div id="rlabUgyYn"></div>
   							</td>
   							<th align="right">통보유형</th>
   							<td>
   								<div id="infmTypeCd"></div>
   							</td>
   						</tr>
   						<tr>
   							<th align="right">시료처리</th>
   							<td>
   								<div id="smpoTrtmCd"></div>
   							</td>
   							<th align="right">상태</th>
   							<td><span id="acpcStNm"/></td>
   						</tr>
   						<tr>
   							<th align="right">통보자</th>
   							<td colspan="3">
						        <div class="LblockMarkupCode">
						            <div id="rlabRqprInfmView"></div>
									<button type="button" class="btn"  id="addRlabRqprInfmBtn" name="addRlabRqprInfmBtn" onclick="addRlabRqprInfm()">저장</button>
						        </div>
   							</td>
   						</tr>
   					</tbody>
   				</table>

   				<div class="titArea">
   					<h3>시료정보</h3>
   					<div class="LblockButton">
   						<button type="button" class="btn"  id="addRlabRqprSmpoBtn" name="addRlabRqprSmpoBtn" onclick="addRlabRqprSmpo()">추가</button>
   						<button type="button" class="btn"  id="deleteRlabRqprSmpoBtn" name="deleteRlabRqprSmpoBtn" onclick="deleteRlabRqprSmpo()">삭제</button>
   					</div>
   				</div>

   				<div id="rlabRqprSmpoGrid"></div>

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
				   					<h3>관련시험</h3>
				   					<div class="LblockButton">
				   						<button type="button" class="btn"  id="addRlabRqprRltdBtn" name="addRlabRqprRltdBtn" onclick="openRlabRqprSearchDialog(setRlabRqprRltd)">추가</button>
				   						<button type="button" class="btn"  id="deleteRlabRqprRltdBtn" name="deleteRlabRqprRltdBtn" onclick="deleteRlabRqprRltd()">삭제</button>
				   					</div>
				   				</div>

				   				<div id="rlabRqprRltdGrid"></div>
   							</td>
   							<td>&nbsp;</td>
   							<td>
				   				<div class="titArea">
				   					<h3>시료사진/첨부파일</h3>
				   					<div class="LblockButton">
				   						<button type="button" class="btn"  id="addRlabRqprAttachBtn" name="addRlabRqprAttachBtn" onclick="openAttachFileDialog(setRlabRqprAttach, rlabRqprDataSet.getNameValue(0, 'rqprAttcFileId'), 'rlabPolicy', '*', 'M', '시료사진/첨부파일')">파일첨부</button>
				   					</div>
				   				</div>

				   				<div id="rlabRqprAttachGrid"></div>
   							</td>
   						</tr>
   					</tbody>
   				</table>
				</form>
   				</div>

   				<div id="rlabRqprResultDiv">
   				<div class="titArea">
   					<div class="LblockButton">
   						<button type="button" class="btn"  id="resultTabListBtn" name="resultTabListBtn" onclick="goRlabRqprList()">목록</button>
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
   							<th align="right">시험명</th>
   							<td><span id="rlabNm"/></td>
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
    						<td colspan="3"><span id="rlabRqprInfmView"/></td>
   						</tr>
   						<tr>
   							<th align="right">시험결과</th>
   							<td colspan="3"><span id="rlabRsltSbc"/></td>
   						</tr>
   						<tr>
   							<th align="right">시험결과서</th>
   							<td id="rsltAttcFileView" colspan="3"></td>
   						</tr>
   					</tbody>
   				</table>
   				</div>
   				<div id="rlabRqprOpinitionDiv">
   				<div class="titArea">
   					<div class="LblockButton">
   						<button type="button" class="btn"  id="saveBtn" name="saveBtn" onclick="opinitionSave()">추가</button>
   						<button type="button" class="btn"  id="deleteBtn" name="deleteBtn" onclick="opinitionUpdate()">수정</button>
   						<button type="button" class="btn"  id="listBtn" name="listBtn" onclick="goRlabRqprList()">목록</button>
   					</div>
   				</div>
   				<div id="rlabRqprOpinitionGrid"></div>
   				<br/>
   				</div>
   			</div><!-- //sub-content -->
   		</div><!-- //contents -->
    </body>
</html>