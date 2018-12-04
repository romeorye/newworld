<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*,
				 java.util.*,
				 devonframe.util.NullUtil,
				 devonframe.util.DateUtil"%>

<%--
/*
 *************************************************************************
 * $Id		: anlRqprDetail4Chrg.jsp
 * @desc    : 분석의뢰서 상세
 *------------------------------------------------------------------------
 * VER	DATE		AUTHOR		DESCRIPTION
 * ---	-----------	----------	-----------------------------------------
 * 1.0  2017.08.25  오명철		최초생성
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

<script type="text/javascript" src="<%=ruiPathPlugins%>/tab/rui_tab.js"></script>
<link rel="stylesheet" type="text/css" href="<%=ruiPathPlugins%>/tab/rui_tab.css"/>

<style>
 .bgcolor-gray {background-color: #999999}
 .bgcolor-white {background-color: #FFFFFF}
 .L-navset {overflow:hidden;}
</style>

	<script type="text/javascript">

		var callback;
		var anlRqprDataSet;

		var exprWayDialog;

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
                var data = anlRqprSmpoDataSet.getReadData(e);

                if(Rui.isEmpty(data.records[0].resultMsg) == false) {
                    alert(data.records[0].resultMsg);
                }

                if(data.records[0].resultYn == 'Y') {
                	if(data.records[0].cmd == 'saveAnlRqpr') {
                		;
                	} else if(data.records[0].cmd == 'receipt') {
                    	goAnlRqprList4Chrg();
                	} else if(data.records[0].cmd == 'deleteAnlRqprExpr') {
                		getAnlRqprExprList();
                	} else if(data.records[0].cmd == 'saveAnlRqprRslt') {
                		;
                	} else if(data.records[0].cmd == 'requestRsltApproval') {
                    	var url = '<%=lghausysPath%>/lgchem/approval.front.document.RetrieveDocumentFormCmd.lgc?appCode=APP00333&approvalLineInform=SUB002&from=iris&guid=C${inputData.rqprId}';

                   		openWindow(url, 'anlRqprCompleteApprovalPop', 800, 500, 'yes');
                	}
                }
            });

            var tabView = new Rui.ui.tab.LTabView({
            	//height: 1250,
                tabs: [ {
                        active: true,
                        label: '의뢰정보',
                        id: 'anlRqprInfoDiv'
                    }, {
                    	label: '분석결과',
                        id: 'anlRqprResultDiv'
                    }, {
                        label: '의견<span id="opinitionCnt"/>',
                        id: 'anlRqprOpinitionDiv'
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
	            	if('03|05|06|07'.indexOf(anlRqprDataSet.getNameValue(0, 'acpcStCd')) == -1) {
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

            var textBox = new Rui.ui.form.LTextBox({
                emptyValue: ''
            });

            var numberBox = new Rui.ui.form.LNumberBox({
                emptyValue: '',
                minValue: 0,
                maxValue: 99999
            });

            var anlNm = new Rui.ui.form.LTextBox({
            	applyTo: 'anlNm',
                placeholder: '분석명을 입력해주세요.',
                defaultValue: '',
                emptyValue: '',
                width: 400
            });

            var anlChrgNm = new Rui.ui.form.LTextBox({
            	applyTo: 'anlChrgNm',
                placeholder: '분석담당자를 입력해주세요.',
                defaultValue: '',
                emptyValue: '',
                editable: false,
                width: 160
            });

            var cmplParrDt = new Rui.ui.form.LDateBox({
				applyTo: 'cmplParrDt',
				mask: '9999-99-99',
				displayValue: '%Y-%m-%d',
				defaultValue: '',
				editable: false,
				width: 100,
				dateType: 'string'
			});

            var anlScnCd = new Rui.ui.form.LCombo({
                applyTo: 'anlScnCd',
                name: 'anlScnCd',
                emptyText: '선택',
                defaultValue: '',
                emptyValue: '',
                width: 110,
                url: '<c:url value="/common/code/retrieveCodeListForCache.do?comCd=ANL_SCN_CD"/>',
                displayField: 'COM_DTL_NM',
                valueField: 'COM_DTL_CD'
            });

            var anlUgyYn = new Rui.ui.form.LCombo({
                applyTo: 'anlUgyYn',
                name: 'anlUgyYn',
                emptyText: '선택',
                defaultValue: '',
                emptyValue: '',
                width: 110,
                url: '<c:url value="/common/code/retrieveCodeListForCache.do?comCd=ANL_UGY_YN"/>',
                displayField: 'COM_DTL_NM',
                valueField: 'COM_DTL_CD'
            });

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

            var anlSbc = new Rui.ui.form.LTextArea({
                applyTo: 'anlSbc',
                placeholder: '분석배경과 목적, 결과 활용방안을 자세히 기재하여 주시기 바랍니다.',
                emptyValue: '',
                width: 980,
                height: 75
            });

            var anlRsltSbc = new Rui.ui.form.LTextArea({
                applyTo: 'anlRsltSbc',
                placeholder: '분석결과 내용을 입력해주세요.',
                emptyValue: '',
                width: 980,
                height: 175
            });

            var vm1 = new Rui.validate.LValidatorManager({
                validators:[
                { id: 'anlNm',				validExp: '분석명:true:maxByteLength=100' },
                { id: 'anlSbc',				validExp: '분석목적:true' },
                { id: 'cmplParrDt',			validExp: '완료예정일:true:date=YYYY-MM-DD' },
                { id: 'anlScnCd',			validExp: '분석구분:true' },
                { id: 'anlUgyYn',			validExp: '긴급유무:true' },
                { id: 'infmTypeCd',			validExp: '통보유형:true' },
                { id: 'smpoTrtmCd',			validExp: '시료처리:true' }
                ]
            });

            var vm2 = new Rui.validate.LValidatorManager({
                validators:[
                { id: 'anlNm',				validExp: '분석명:true:maxByteLength=100' },
                { id: 'anlSbc',				validExp: '분석목적:true' },
                { id: 'anlScnCd',			validExp: '분석구분:true' },
                { id: 'anlUgyYn',			validExp: '긴급유무:true' },
                { id: 'infmTypeCd',			validExp: '통보유형:true' },
                { id: 'smpoTrtmCd',			validExp: '시료처리:true' }
                ]
            });

            var vm3 = new Rui.validate.LValidatorManager({
                validators:[
                { id: 'anlRsltSbc',			validExp: '분석결과:true' }
                ]
            });

            anlRqprDataSet = new Rui.data.LJsonDataSet({
                id: 'anlRqprDataSet',
                remainRemoved: true,
                lazyLoad: true,
                fields: [
                	  { id: 'rqprId' }
                	, { id: 'anlNm' }
					, { id: 'anlSbc' }
					, { id: 'acpcNo' }
					, { id: 'acpcStNm' }
					, { id: 'rgstNm' }
					, { id: 'rqprDeptNm' }
					, { id: 'rqprDt' }
					, { id: 'acpcDt' }
					, { id: 'cmplParrDt' }
					, { id: 'cmplDt' }
					, { id: 'anlScnCd' }
					, { id: 'anlChrgId' }
					, { id: 'anlChrgNm' }
					, { id: 'anlUgyYn' }
					, { id: 'infmTypeCd' }
					, { id: 'smpoTrtmCd' }
					, { id: 'anlRqprInfmView' }
					, { id: 'anlRsltSbc' }
					, { id: 'acpcStCd' }
					, { id: 'rqprAttcFileId' }
					, { id: 'rsltAttcFileId' }
					, { id: 'reqItgRdcsId' }
					, { id: 'rsltItgRdcsId' }
                ]
            });

            var acpcStCd;

            anlRqprDataSet.on('load', function(e) {
            	var opinitionCnt = anlRqprDataSet.getNameValue(0, 'opinitionCnt');
            	acpcStCd = anlRqprDataSet.getNameValue(0, 'acpcStCd');

            	//button controll
            	if( acpcStCd  == "04" ||  acpcStCd  == "05" || acpcStCd  == "06"  || acpcStCd  == "07" ){
            		//의뢰정보
            		$( '#saveBtn' ).hide();
            		$( '#receiptBtn' ).hide();
            		$( '#rejectBtn' ).hide();

            		//시료정보
            		$( '#addAnlRqprSmpoBtn' ).hide();
            		$( '#deleteAnlRqprSmpoBtn' ).hide();

            		//관련분석
            		$( '#addAnlRqprRltdBtn' ).hide();
            		$( '#deleteAnlRqprRltdBtn' ).hide();

            		//첨부파일
            		$( '#addAnlRqprAttachBtn' ).hide();

            		//분석결과
            		$( '#saveRsltBtn' ).hide();
            		$( '#approvalBtn' ).hide();
            		$( '#stopBtn' ).hide();

            		//시료정보
            		$( '#addAnlRqprExprBtn' ).hide();
            		$( '#deleteAnlRqprExprBtn' ).hide();
            	}

            	if(Rui.isEmpty(anlRqprDataSet.getNameValue(0, "rsltAttcFileId"))) {
            		anlRqprDataSet.setNameValue(0, "rsltAttcFileId", '')
            	}

            	if(opinitionCnt > 0) {
            		$('#opinitionCnt').html('(' + opinitionCnt + ')');
            	}

            	if(!Rui.isEmpty(anlRqprDataSet.getNameValue(0, 'rsltItgRdcsId'))) {
            		$('#rsltApprStateBtn').show();
            	}

            	if(!Rui.isEmpty(anlRqprDataSet.getNameValue(0, 'reqItgRdcsId'))) {
            		$('#reqApprStateBtn').show();
            	}

            	if( acpcStCd =="04" || acpcStCd =="05" || acpcStCd =="07"  ){
            		$('#anlSbcHtml').show();
            		$('#anlSbc').hide();
            	}else{
            		$('#anlSbcHtml').hide();
            		$('#anlSbc').show();
            	}

            	if( '${inputData._teamDept}' == "58141801"
                    && ( acpcStCd =="00" || acpcStCd =="01" || acpcStCd =="02" || acpcStCd =="03" )  ){

    	    		anlRqprSmpoGrid.setEditable(true);
                }
            });

            var anlRqprOpinitionDataSet = new Rui.data.LJsonDataSet({
                id: 'anlRqprOpinitionDataSet',
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

            anlRqprOpinitionDataSet.on('load', function(e) {
            	var cnt = anlRqprOpinitionDataSet.getCount();

            	parent.$("#opinitionCnt").html(cnt == 0 ? '' : '(' + cnt + ')');
   	      	});

            var anlRqprOpinitionColumnModel = new Rui.ui.grid.LColumnModel({
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
                    , { field: 'userYn',	hidden : true}
                ]
            });

            var anlRqprOpinitionGrid = new Rui.ui.grid.LGridPanel({
                columnModel: anlRqprOpinitionColumnModel,
                dataSet: anlRqprOpinitionDataSet,
                width: 980,
                height: 380,
                autoToEdit: true,
                autoWidth: true,
                autoHeight: true
            });

            anlRqprOpinitionGrid.render('anlRqprOpinitionGrid');

            anlRqprOpinitionGrid.on('dblclick', function() {
            	opinitionUpdate();
            });

            bind = new Rui.data.LBind({
                groupId: 'anlRqprInfoDiv',
                dataSet: anlRqprDataSet,
                bind: true,
                bindInfo: [
                    { id: 'anlNm',				ctrlId:'anlNm',				value:'value'},
                    { id: 'anlSbc',				ctrlId:'anlSbc',			value:'value'},
                    { id: 'anlSbc',				ctrlId:'anlSbcHtml',		value:'html'},
                    { id: 'acpcNo',				ctrlId:'acpcNo',			value:'html'},
                    { id: 'rgstNm',				ctrlId:'rgstNm',			value:'html'},
                    { id: 'rqprDeptNm',			ctrlId:'rqprDeptNm',		value:'html'},
                    { id: 'rqprDt',				ctrlId:'rqprDt',			value:'html'},
                    { id: 'acpcDt',				ctrlId:'acpcDt',			value:'html'},
                    { id: 'cmplParrDt',			ctrlId:'cmplParrDt',		value:'value'},
                    { id: 'cmplDt',				ctrlId:'cmplDt',			value:'html'},
                    { id: 'anlScnCd',			ctrlId:'anlScnCd',			value:'value'},
                    { id: 'anlChrgId',			ctrlId:'anlChrgId',			value:'value'},
                    { id: 'anlChrgNm',			ctrlId:'anlChrgNm',			value:'value'},
                    { id: 'anlUgyYn',			ctrlId:'anlUgyYn',			value:'value'},
                    { id: 'infmTypeCd',			ctrlId:'infmTypeCd',		value:'value'},
                    { id: 'smpoTrtmCd',			ctrlId:'smpoTrtmCd',		value:'value'},
                    { id: 'acpcStNm',			ctrlId:'acpcStNm',			value:'html'},
                    { id: 'anlRqprInfmView',	ctrlId:'anlRqprInfmView',	value:'html'}
                ]
            });

            resultBind = new Rui.data.LBind({
                groupId: 'anlRqprResultDiv',
                dataSet: anlRqprDataSet,
                bind: true,
                bindInfo: [
                    { id: 'anlNm',				ctrlId:'anlNm',				value:'html'},
                    { id: 'acpcNo',				ctrlId:'acpcNo',			value:'html'},
                    { id: 'cmplParrDt',			ctrlId:'cmplParrDt',		value:'html'},
                    { id: 'cmplDt',				ctrlId:'cmplDt',			value:'html'},
                    { id: 'anlRsltSbc',			ctrlId:'anlRsltSbc',		value:'value'}
                ]
            });

            opinitionBind = new Rui.data.LBind({
                groupId: 'anlRqprOpinitionDiv',
                dataSet: anlRqprOpinitionDataSet,
                bind: true,
                bindInfo: [
                    { id: 'rgstNm',				ctrlId:'rgstNm',				value:'html'},
                    { id: 'rgstDt',				ctrlId:'rgstDt',			value:'html'},
                    { id: 'opiSbc',				ctrlId:'opiSbc',		value:'html'}
                ]
            });

            var anlRqprSmpoDataSet = new Rui.data.LJsonDataSet({
                id: 'anlRqprSmpoDataSet',
                remainRemoved: true,
                lazyLoad: true,
                fields: [
                	  { id: 'smpoId' }
                	, { id: 'rqprId' , defaultValue: '${inputData.rqprId}' }
					, { id: 'smpoNm' }
					, { id: 'mkrNm' }
					, { id: 'mdlNm' }
					, { id: 'smpoQty' }
                ]
            });

            var anlRqprSmpoColumnModel = new Rui.ui.grid.LColumnModel({
                columns: [
                	  new Rui.ui.grid.LSelectionColumn()
                	, new Rui.ui.grid.LStateColumn()
                	, new Rui.ui.grid.LNumberColumn()
                    , { field: 'smpoNm',	label: '시료명',	editable: true, editor: textBox,	sortable: false,	align:'center',	width: 410 }
                    , { field: 'mkrNm',		label: '제조사',	editable: true, editor: textBox,	sortable: false,	align:'center',	width: 410 }
                    , { field: 'mdlNm',		label: '모델명',	editable: true, editor: textBox,	sortable: false,	align:'center',	width: 325 }
                    , { field: 'smpoQty',	label: '수량',		editable: true, editor: numberBox,	sortable: false,	align:'center',	width: 100 }
                ]
            });

            var anlRqprSmpoGrid = new Rui.ui.grid.LGridPanel({
                columnModel: anlRqprSmpoColumnModel,
                dataSet: anlRqprSmpoDataSet,
                width: 700,
                height: 400,
                editable : true,
                autoWidth: true
            });

            anlRqprSmpoGrid.render('anlRqprSmpoGrid');


            var anlRqprRltdDataSet = new Rui.data.LJsonDataSet({
                id: 'anlRqprRltdDataSet',
                remainRemoved: true,
                lazyLoad: true,
                fields: [
					  { id: 'rltdId' }
					, { id: 'rqprId' }
					, { id: 'preRqprId' }
					, { id: 'preAnlNm' }
					, { id: 'preAcpcNo' }
					, { id: 'preAnlChrgNm' }
					, { id: 'preRgstId' }
					, { id: 'preRgstNm' }
                ]
            });

            var anlRqprRltdColumnModel = new Rui.ui.grid.LColumnModel({
                columns: [
                	  new Rui.ui.grid.LSelectionColumn()
                	, new Rui.ui.grid.LStateColumn()
                	, new Rui.ui.grid.LNumberColumn()
                    , { field: 'preAcpcNo',		label: '접수번호',		sortable: false,	align:'center',	width: 80 }
                    , { field: 'preAnlNm',		label: '분석명',		sortable: false,	align:'left',	width: 300 }
                    , { field: 'preRgstNm',		label: '의뢰자',		sortable: false,	align:'center',	width: 80 }
                    , { field: 'preAnlChrgNm',	label: '분석담당자',	sortable: false,	align:'center',	width: 80 }
                    , { field: 'rqprId',	hidden:true }
                    , { field: 'preRqprId',	hidden:true }
                ]
            });

            var anlRqprRltdGrid = new Rui.ui.grid.LGridPanel({
                columnModel: anlRqprRltdColumnModel,
                dataSet: anlRqprRltdDataSet,
                width: 540,
                height: 200,
                autoToEdit: false,
                autoWidth: true
            });

            anlRqprRltdGrid.render('anlRqprRltdGrid');

            anlRqprRltdGrid.on('cellClick', function(e) {
            	 var record = anlRqprRltdDataSet.getAt(anlRqprRltdDataSet.getRow());
                 //var params = "?rqprId="+record.get("rqprId");
                 var params = "?rqprId="+record.get("preRqprId");

                 anlRqprRltdDialog.setUrl('<c:url value="/anl/anlRqprSrchView.do"/>'+params);
                 anlRqprRltdDialog.show(true);
            });

          	//관련분석 상세 이관
         	var anlRqprRltdDialog = new Rui.ui.LFrameDialog({
    	        id: 'anlRqprRltdDialog',
    	        title: '관련분석',
    	        width:  1000,
    	        height: 600,
    	        modal: true,
    	        visible: false
    	    });

         	anlRqprRltdDialog.render(document.body);


            var anlRqprAttachDataSet = new Rui.data.LJsonDataSet({
                id: 'anlRqprAttachDataSet',
                remainRemoved: true,
                lazyLoad: true,
                fields: [
					  { id: 'attcFilId'}
					, { id: 'seq' }
					, { id: 'filNm' }
					, { id: 'filSize' }
                ]
            });

            var anlRqprAttachColumnModel = new Rui.ui.grid.LColumnModel({
                columns: [
                      new Rui.ui.grid.LNumberColumn()
                    , { field: 'filNm',		label: '파일명',		sortable: false,	align:'left',	width: 570 }
                ]
            });

            var anlRqprAttachGrid = new Rui.ui.grid.LGridPanel({
                columnModel: anlRqprAttachColumnModel,
                dataSet: anlRqprAttachDataSet,
                width: 300,
                height: 200,
                autoToEdit: false,
                autoWidth: true
            });

            anlRqprAttachGrid.on('cellClick', function(e) {
                if(e.colId == "filNm") {
                	downloadAttachFile(anlRqprAttachDataSet.getAt(e.row).data.attcFilId, anlRqprAttachDataSet.getAt(e.row).data.seq);
                }
            });

            anlRqprAttachGrid.render('anlRqprAttachGrid');

    	    // 첨부파일 정보 설정
    	    setAnlRqprAttach = function(attachFileList) {
    	    	anlRqprAttachDataSet.clearData();

    	    	if(attachFileList.length > 0) {
    	    		anlRqprDataSet.setNameValue(0, 'rqprAttcFileId', attachFileList[0].data.attcFilId);

        	    	for(var i=0; i<attachFileList.length; i++) {
        	    		anlRqprAttachDataSet.add(attachFileList[i]);
        	    	}
    	    	}
    	    };

			downloadAttachFile = function(attcFilId, seq) {
				fileDownloadForm.action = '<c:url value='/system/attach/downloadAttachFile.do'/>';
				$('#attcFilId', fileDownloadForm).val(attcFilId);
				$('#seq', fileDownloadForm).val(seq);
				fileDownloadForm.submit();
			};

			var anlRqprRsltAttachDataSet = anlRqprAttachDataSet.clone('anlRqprRsltAttachDataSet');

            anlRqprRsltAttachDataSet.on('load', function(e) {
				for( var i = 0, size = anlRqprRsltAttachDataSet.getCount(); i < size ; i++ ) {
        	    	$('#rsltAttcFileView').append($('<a/>', {
        	            href: 'javascript:downloadAttachFile("' + anlRqprRsltAttachDataSet.getAt(i).data.attcFilId + '", "' + anlRqprRsltAttachDataSet.getAt(i).data.seq + '")',
        	            text: anlRqprRsltAttachDataSet.getAt(i).data.filNm
        	        })).append('<br/>');
				}
            });

    	    // 분석결과 첨부파일 정보 설정
    	    setAnlRqprRsltAttach = function(attachFileList) {
    	    	anlRqprRsltAttachDataSet.clearData();

    	    	if(attachFileList.length > 0) {
    	    		anlRqprDataSet.setNameValue(0, 'rsltAttcFileId', attachFileList[0].data.attcFilId);

        	    	for(var i=0; i<attachFileList.length; i++) {
        	    		anlRqprRsltAttachDataSet.add(attachFileList[i]);
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

            var anlRqprExprDataSet = new Rui.data.LJsonDataSet({
                id: 'anlRqprExprDataSet',
                remainRemoved: false,
                lazyLoad: true,
                fields: [
                	  { id: 'rqprExprId', type: 'number' }
                	, { id: 'rqprId', type: 'number' }
					, { id: 'exprNm' }
					, { id: 'smpoQty' }
					, { id: 'exprTim' }
					, { id: 'exprExp' }
					, { id: 'exprWay' }
					, { id: 'exprDt' }
					, { id: 'exprStrtDt' }
					, { id: 'exprFnhDt' }
                ]
            });

            var anlRqprExprColumnModel = new Rui.ui.grid.LColumnModel({
                columns: [
                	  new Rui.ui.grid.LSelectionColumn()
                    , new Rui.ui.grid.LNumberColumn()
                    , { field: 'exprNm',	label: '실험명',		sortable: false,	align:'left',	width: 400 }
                    , { field: 'smpoQty',	label: '실험수',		sortable: false,	align:'center',	width: 65 }
                    , { field: 'exprTim',	label: '실험시간',		sortable: false,	align:'center',	width: 80 }
                    , { field: 'exprDt',	label: '실험기간',		sortable: false,	align:'center',	width: 170}
                    , { field: 'exprExp',	label: '수가',		sortable: false,	align:'center',	width: 95, renderer: function(val, p, record, row, col) {
                    	return Rui.util.LNumber.toMoney(val, '') + '원';
                      } }
                    , { field: 'exprWay',	label: '실험방법',		sortable: false,	align:'left',	width: 430 }
                    , { field: 'exprStrtDt',	hidden: true }
                    , { field: 'exprFnhDt',	hidden: true}
                ]
            });

            var anlRqprExprGrid = new Rui.ui.grid.LGridPanel({
                columnModel: anlRqprExprColumnModel,
                dataSet: anlRqprExprDataSet,
                width: 600,
                height: 200,
                autoToEdit: false,
                autoWidth: true
            });

            anlRqprExprGrid.on('cellClick', function(e) {
            	if(e.col == 0) {
            		return ;
            	}
                if (anlRqprDataSet.getNameValue(0, 'acpcStCd') != '03') {
                    //alert('분석진행 상태일때만 실험결과를 수정 할 수 있습니다.');
                    //return false;
                    openExprWayDialog(anlRqprExprDataSet.getNameValue(e.row, 'rqprExprId'));
                }else{
	            	openAnlRqprExprRsltDialog(getAnlRqprExprList, anlRqprExprDataSet.getNameValue(e.row, 'rqprExprId'));
                }
            });

            anlRqprExprGrid.render('anlRqprExprGrid');

            openExprWayDialog = function(rqprExprId) {
    	    	exprWayDialog.setUrl('<c:url value="/anl/exprWayPopup.do?rqprId="/>' + anlRqprDataSet.getNameValue(0, 'rqprId') + '&rqprExprId=' + rqprExprId);
    	    	exprWayDialog.show();
    	    };



    	    // 실험방법 팝업
       	 exprWayDialog = new Rui.ui.LFrameDialog({
       	        id: 'exprWayDialog',
       	        title: '실험방법',
       	        width: 640,
       	        height: 420,
       	        modal: true,
       	        visible: false
       	 });

         exprWayDialog.render(document.body);

			// 분석 담당자 선택팝업 시작
		    anlChrgListDialog = new Rui.ui.LFrameDialog({
		        id: 'anlChrgListDialog',
		        title: '분석담당자',
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

		    anlChrgListDialog.render(document.body);

			openAnlChrgListDialog = function(f) {
				_callback = f;

				anlChrgListDialog.setUrl('<c:url value="/anl/anlChrgDialog.do"/>');
				anlChrgListDialog.show();
			};
			// 분석 담당자 선택팝업 끝

            setAnlChrgInfo = function(anlChrgInfo) {
            	anlRqprDataSet.setNameValue(0, 'anlChrgId', anlChrgInfo.id);
            	anlRqprDataSet.setNameValue(0, 'anlChrgNm', anlChrgInfo.name);
            };

    	    // 분석의뢰 의견 팝업 시작
    	    anlRqprOpinitionDialog = new Rui.ui.LFrameDialog({
    	        id: 'anlRqprOpinitionDialog',
    	        title: '의견 교환',
    	        width: 830,
    	        height: 500,
    	        modal: true,
    	        visible: false
    	    });

    	    anlRqprOpinitionDialog.render(document.body);

    	    openAnlRqprOpinitionDialog = function() {
    	    	anlRqprOpinitionDialog.setUrl('<c:url value="/anl/anlRqprOpinitionPopup.do?rqprId=${inputData.rqprId}"/>');
    	    	anlRqprOpinitionDialog.show();
    	    };
    	    // 분석의뢰 의견 팝업 끝

    	    // 분석의뢰 반려/분석중단 팝업 시작
    	    anlRqprEndDialog = new Rui.ui.LFrameDialog({
    	        id: 'anlRqprEndDialog',
    	        title: '',
    	        width: 520,
    	        height: 230,
    	        modal: true,
    	        visible: false
    	    });

    	    anlRqprEndDialog.render(document.body);

    	    openAnlRqprEndDialog = function(type) {
    	    	$('#anlRqprEndDialog_h').html(type == '반려' ? '분석의뢰 반려' : '분석중단');
    	    	anlRqprEndDialog.setUrl('<c:url value="/anl/anlRqprEndPopup.do?type="/>' + escape(encodeURIComponent(type)));
    	    	anlRqprEndDialog.show();
    	    };
    	    // 분석의뢰 반려/분석중단 팝업 끝

    	    // 실험정보 등록/수정 팝업 시작
    	    anlRqprExprRsltDialog = new Rui.ui.LFrameDialog({
    	        id: 'anlRqprExprRsltDialog',
    	        title: '실험정보 등록/수정',
    	        width: 740,
    	        height: 580,
    	        modal: true,
    	        visible: false
    	    });

    	    anlRqprExprRsltDialog.render(document.body);

    	    openAnlRqprExprRsltDialog = function(f, rqprExprId) {
    	    	callback = f;

    	    	anlRqprExprRsltDialog.setUrl('<c:url value="/anl/anlRqprExprRsltPopup.do?rqprId="/>' + anlRqprDataSet.getNameValue(0, 'rqprId') + '&rqprExprId=' + rqprExprId);
    	    	anlRqprExprRsltDialog.show();
    	    };
    	    // 실험결과 등록/수정 팝업 끝

    	    // 시험의뢰 의견 팝업 시작
    	    anlRqprOpinitionDialog = new Rui.ui.LFrameDialog({
    	        id: 'anlRqprOpinitionDialog',
    	        title: '의견 교환',
    	        width: 830,
    	        height: 500,
    	        modal: true,
    	        visible: false
    	    });

    	    anlRqprOpinitionDialog.render(document.body);

    	    openAnlRqprOpinitionDialog = function() {
    	    	anlRqprOpinitionDialog.setUrl('<c:url value="/anl/anlRqprOpinitionPopup.do?rqprId=${inputData.rqprId}"/>');
    	    	anlRqprOpinitionDialog.show();
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
		    	opinitionDialog.setUrl('<c:url value="/anl/openAddOpinitionPopup.do"/>');
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
				var record = anlRqprOpinitionDataSet.getAt(anlRqprOpinitionDataSet.rowPosition);
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
		    	opinitionUpdateDialog.setUrl('<c:url value="/anl/openAddOpinitionPopup.do"/>'+'?opiId=' + opiId);
		    	opinitionUpdateDialog.show();
		    };

		    /* 시험의뢰 의견 리스트 조회 */
            getAnlRqprOpinitionList = function(msg) {
            	closePop = function(){
            		opinitionDialog.cancel(false);
                	opinitionUpdateDialog.cancel(false);
                	Rui.alert(msg);
            	}
            	anlRqprOpinitionDataSet.load({
                    url: '<c:url value="/anl/getAnlRqprOpinitionList.do"/>',
                    params :{
                    	rqprId : '${inputData.rqprId}'
                    }
                });
            	if(!Rui.isUndefined(msg)){
	            	closePop();
            	}
            };

            getAnlRqprOpinitionList();

         	// 수정 버튼
            opinitionUpdate = function() {
            	opiId=anlRqprOpinitionDataSet.getAt(anlRqprOpinitionDataSet.rowPosition).data.opiId;
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

            /* 접수 */
            saveAnlRqpr = function() {
    	    	if('02|03'.indexOf(anlRqprDataSet.getNameValue(0, 'acpcStCd')) == -1) {
    	    		alert('접수대기, 분석진행 상태일때만 저장 할 수 있습니다.');
    	    		return false;
    	    	}

                if (vm2.validateDataSet(anlRqprDataSet) == false) {
                    alert(Rui.getMessageManager().get('$.base.msg052') + '\n' + vm2.getMessageList().join('\n'));
                    return false;
                }

            	if(confirm('저장 하시겠습니까?')) {
                    dm.updateDataSet({
                        //dataSets:[anlRqprDataSet],
                        dataSets:[anlRqprDataSet, anlRqprSmpoDataSet, anlRqprRltdDataSet],
                        url:'<c:url value="/anl/saveAnlRqpr.do"/>',
                        modifiedOnly: false
                    });
            	}
            };

            /* 접수 */
            receipt = function() {
    	    	if(anlRqprDataSet.getNameValue(0, 'acpcStCd') != '02') {
    	    		alert('접수대기 상태일때만 접수 할 수 있습니다.');
    	    		return false;
    	    	}

                if (vm1.validateDataSet(anlRqprDataSet) == false) {
                    alert(Rui.getMessageManager().get('$.base.msg052') + '\n' + vm1.getMessageList().join('\n'));
                    return false;
                }

            	if(confirm('접수 하시겠습니까?')) {
                    dm.updateDataSet({
                        dataSets:[anlRqprDataSet],
                        url:'<c:url value="/anl/receiptAnlRqpr.do"/>',
                        modifiedOnly: false
                    });
            	}
            };

            /* 접수반려 */
            reject = function() {
                if (anlRqprDataSet.getNameValue(0, 'acpcStCd') != '02') {
                    alert('접수대기 상태일때만 반려 할 수 있습니다.');
                    return false;
                }

            	openAnlRqprEndDialog('반려');
            };

            /* 분석결과 저장 */
            saveAnlRqprRslt = function() {
    	    	if(anlRqprDataSet.getNameValue(0, 'acpcStCd') != '03') {
    	    		alert('분석진행 상태일때만 분석결과를 저장 할 수 있습니다.');
    	    		return false;
    	    	}

//                 if (vm3.validateDataSet(anlRqprDataSet) == false) {
//                     alert(Rui.getMessageManager().get('$.base.msg052') + '\n' + vm3.getMessageList().join('\n'));
//                     return false;
//                 }

            	if(confirm('저장 하시겠습니까?')) {
                    dm.updateDataSet({
                        dataSets:[anlRqprDataSet],
                        url:'<c:url value="/anl/saveAnlRqprRslt.do"/>',
                        modifiedOnly: false
                    });
            	}
            };

            /* 결재의뢰 */
            approval = function() {
    	    	if(anlRqprDataSet.getNameValue(0, 'acpcStCd') != '03') {
    	    		alert('분석진행 상태일때만 결재의뢰 할 수 있습니다.');
    	    		return false;
    	    	}

                if (vm3.validateDataSet(anlRqprDataSet) == false) {
                    alert(Rui.getMessageManager().get('$.base.msg052') + '\n' + vm3.getMessageList().join('\n'));
                    return false;
                }

            	if(confirm('결재의뢰 하시겠습니까?')) {
                    dm.updateDataSet({
                        dataSets:[anlRqprDataSet],
                        url:'<c:url value="/anl/requestAnlRqprRsltApproval.do"/>',
                        modifiedOnly: false
                    });
            	}
            };

            /* 분석중단 */
            stop = function() {
                if ('03|06'.indexOf(anlRqprDataSet.getNameValue(0, 'acpcStCd')) == -1) {
                    alert('분석진행, 결과검토 상태일때만 중단 할 수 있습니다.');
                    return false;
                }

            	openAnlRqprEndDialog('중단');
            };

            /* 실험결과 등록/수정 팝업 */
            addAnlRqprExpr = function() {
                if (anlRqprDataSet.getNameValue(0, 'acpcStCd') != '03') {
                    alert('분석진행 상태일때만 실험결과를 등록 할 수 있습니다.');
                    return false;
                }

                openAnlRqprExprRsltDialog(getAnlRqprExprList, 0);
            };

            /* 실험결과 삭제 */
            deleteAnlRqprExpr = function() {

				var chkAcpcSt = anlRqprDataSet.getNameValue(0, 'acpcStCd');

				if(chkAcpcSt == "06"){
					alert("결과검토 상태는 삭제를 할수없습니다.");
					return false;

				}else if( chkAcpcSt == "07"){
					alert("분석완료 상태는 삭제를 할수없습니다.");
					return false;
				}

                if(anlRqprExprDataSet.getMarkedCount() > 0) {
                	if(confirm('삭제 하시겠습니까?')) {
                    	anlRqprExprDataSet.removeMarkedRows();

                        dm.updateDataSet({
                            dataSets:[anlRqprExprDataSet],
                            url:'<c:url value="/anl/deleteAnlRqprExpr.do"/>'
                        });
                	}
                } else {
                	alert('삭제 대상을 선택해주세요.');
                }
            };

            getAnlRqprExprList = function() {
            	anlRqprExprDataSet.load({
                    url: '<c:url value="/anl/getAnlRqprExprList.do"/>',
                    params :{
                    	rqprId : '${inputData.rqprId}'
                    }
                });
    	    };

            goAnlRqprList4Chrg = function() {
    	    	$('#searchForm > input[name=anlNm]').val(encodeURIComponent($('#searchForm > input[name=anlNm]').val()));
    	    	$('#searchForm > input[name=rgstNm]').val(encodeURIComponent($('#searchForm > input[name=rgstNm]').val()));
    	    	$('#searchForm > input[name=anlChrgNm]').val(encodeURIComponent($('#searchForm > input[name=anlChrgNm]').val()));

    	    	nwinsActSubmit(searchForm, "<c:url value="/anl/anlRqprList4Chrg.do"/>");
    	    };

    	    openApprStatePopup = function(type) {
    	    	var seq = type == 'A' ? anlRqprDataSet.getNameValue(0, 'reqItgRdcsId') : anlRqprDataSet.getNameValue(0, 'rsltItgRdcsId');
            	var url = '<%=lghausysPath%>/lgchem/approval.front.approval.RetrieveAppTargetCmd.lgc?seq=' + seq;

           		openWindow(url, 'openApprStatePopup', 800, 250, 'yes');
    	    };

    	    openRsltReportPopup = function(type) {
    	    	var width = 1200;
            	var url = '<%=lghausysReportPath%>/anlRqprReportRslt.jsp?reportMode=HTML&clientURIEncoding=UTF-8&reportParams=skip_decimal_point:true&menu=old&RQPR_ID=<c:out value="${inputData.rqprId}"/>';

            	if(anlRqprDataSet.getNameValue(0, 'infmTypeCd') == 'T') {
            		width = 850;
            		url = '<%=lghausysReportPath%>/anlRqprTestRslt.jsp?reportMode=HTML&clientURIEncoding=UTF-8&reportParams=skip_decimal_point:true&menu=old&RQPR_ID=<c:out value="${inputData.rqprId}"/>';
            	}

           		openWindow(url, 'openRsltReportPopup', width, 500, 'yes');
    	    };

	    	dm.loadDataSet({
                dataSets: [anlRqprDataSet, anlRqprSmpoDataSet, anlRqprRltdDataSet, anlRqprAttachDataSet, anlRqprRsltAttachDataSet, anlRqprExprDataSet],
                url: '<c:url value="/anl/getAnlRqprDetailInfo.do"/>',
                params: {
                    rqprId: '${inputData.rqprId}'
                }
            });

	    	/* 시료정보 추가 */
            addAnlRqprSmpo = function() {
				anlRqprSmpoDataSet.newRecord();
            };

            /* 시료정보 삭제 */
            deleteAnlRqprSmpo = function() {
                if(anlRqprSmpoDataSet.getMarkedCount() > 0) {
                	anlRqprSmpoDataSet.removeMarkedRows();
                } else {
                	alert('삭제 대상을 선택해주세요.');
                }
            };


         // 관련분석 조회 팝업 시작
    	    anlRqprSearchDialog = new Rui.ui.LFrameDialog({
    	        id: 'anlRqprSearchDialog',
    	        title: '관련분석 조회',
    	        width: 750,
    	        height: 470,
    	        modal: true,
    	        visible: false
    	    });

    	    anlRqprSearchDialog.render(document.body);

    	    openAnlRqprSearchDialog = function(f) {
    	    	callback = f;

    	    	anlRqprSearchDialog.setUrl('<c:url value="/anl/anlRqprSearchPopup.do"/>');
    		    anlRqprSearchDialog.show();
    	    };

    	    /* 관련분석 삭제 */
            deleteAnlRqprRltd = function() {
                if(anlRqprRltdDataSet.getMarkedCount() > 0) {
                	anlRqprRltdDataSet.removeMarkedRows();
                } else {
                	alert('삭제 대상을 선택해주세요.');
                }
            };

            setAnlRqprRltd = function(anlRqpr) {
				if(anlRqprRltdDataSet.findRow('preRqprId', anlRqpr.rqprId) > -1) {
					alert('이미 존재합니다.');
					return ;
				}

				var row = anlRqprRltdDataSet.newRecord();
				var record = anlRqprRltdDataSet.getAt(row);

                record.set('rqprId', anlRqprDataSet.getNameValue(0, 'rqprId'));
				record.set('preRqprId', anlRqpr.rqprId);
				record.set('preAnlNm', anlRqpr.anlNm);
				record.set('preAcpcNo', anlRqpr.acpcNo);
				record.set('preRgstId', anlRqpr.rgstId);
				record.set('preRgstNm', anlRqpr.rgstNm);
				record.set('preAnlChrgNm', anlRqpr.anlChrgNm);
    	    };

        });
	</script>
    </head>
    <body>
    <form name="searchForm" id="searchForm">
		<input type="hidden" name="anlNm" value="${inputData.anlNm}"/>
		<input type="hidden" name="fromRqprDt" value="${inputData.fromRqprDt}"/>
		<input type="hidden" name="toRqprDt" value="${inputData.toRqprDt}"/>
		<input type="hidden" name="rqprDeptNm" value="${inputData.rqprDeptNm}"/>
		<input type="hidden" name="rqprDeptCd" value="${inputData.rqprDeptCd}"/>
		<input type="hidden" name="rgstNm" value="${inputData.rgstNm}"/>
		<input type="hidden" name="anlChrgNm" value="${inputData.anlChrgNm}"/>
		<input type="hidden" name="acpcNo" value="${inputData.acpcNo}"/>
		<input type="hidden" name="acpcStCd" value="${inputData.acpcStCd}"/>
		<input type="hidden" name="pageNum" value="${inputData.pageNum}"/>
    </form>
    <form name="fileDownloadForm" id="fileDownloadForm">
		<input type="hidden" id="attcFilId" name="attcFilId" value=""/>
		<input type="hidden" id="seq" name="seq" value=""/>
    </form>
   		<div class="contents">

   			<div class="sub-content">
   				<div id="tabView"></div>
	            <div id="anlRqprInfoDiv">
				<form name="aform" id="aform" method="post">
					<input type="hidden" id="anlChrgId" name="anlChrgId" value=""/>
   				<div class="titArea">
   					<div class="LblockButton">
   						<button type="button" class="btn"  id="reqApprStateBtn" name="reqApprStateBtn" onclick="openApprStatePopup('A')" style="display:none;">결재상태</button>
   						<button type="button" class="btn"  id="saveBtn" name="saveBtn" onclick="saveAnlRqpr()">저장</button>
   						<button type="button" class="btn"  id="receiptBtn" name="receiptBtn" onclick="receipt()">접수</button>
   						<button type="button" class="btn"  id="rejectBtn" name="rejectBtn" onclick="reject()">반려</button>
   						<button type="button" class="btn"  id="listBtn" name="listBtn" onclick="goAnlRqprList4Chrg()">목록</button>
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
   							<th align="right">분석명</th>
   							<td>
   								<input type="text" id="anlNm">
   							</td>
   							<th align="right">접수번호</th>
   							<td><span id="acpcNo"/></td>
   						</tr>
   						<tr>
   							<th align="right">분석목적</th>
   							<td colspan="3">
   								<textarea id="anlSbc"></textarea>
   								<span id="anlSbcHtml"></span>
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
   							<th align="right">완료예정일</th>
    						<td><input type="text" id="cmplParrDt"/></td>
   							<th align="right">완료일</th>
    						<td><span id="cmplDt"/></td>
   						</tr>
   						<tr>
   							<th align="right">분석구분</th>
   							<td>
                                <div id="anlScnCd"></div>
   							</td>
   							<th align="right">분석담당자</th>
   							<td>
   								<input type="text" id="anlChrgNm">
                                <a href="javascript:openAnlChrgListDialog(setAnlChrgInfo);" class="icoBtn">검색</a>
                            </td>
   						</tr>
   						<tr>
   							<th align="right">긴급유무</th>
   							<td>
                                <div id="anlUgyYn"></div>
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
   							<td colspan="3"><span id="anlRqprInfmView"/></td>
   						</tr>
   					</tbody>
   				</table>

   				<div class="titArea">
   					<h3>시료정보</h3>
   					<div class="LblockButton">
   						<button type="button" class="btn"  id="addAnlRqprSmpoBtn" name="addAnlRqprSmpoBtn" onclick="addAnlRqprSmpo()">추가</button>
   						<button type="button" class="btn"  id="deleteAnlRqprSmpoBtn" name="deleteAnlRqprSmpoBtn" onclick="deleteAnlRqprSmpo()">삭제</button>
   					</div>
   				</div>

   				<div id="anlRqprSmpoGrid"></div>

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
				   					<h3>관련분석</h3>
				   					<div class="LblockButton">
				   						<button type="button" class="btn"  id="addAnlRqprRltdBtn" name="addAnlRqprRltdBtn" onclick="openAnlRqprSearchDialog(setAnlRqprRltd)">추가</button>
				   						<button type="button" class="btn"  id="deleteAnlRqprRltdBtn" name="deleteAnlRqprRltdBtn" onclick="deleteAnlRqprRltd()">삭제</button>
				   					</div>
				   				</div>

				   				<div id="anlRqprRltdGrid"></div>
   							</td>
   							<td>&nbsp;</td>
   							<td>
				   				<div class="titArea">
				   					<h3>시료사진/첨부파일</h3>
				   					<div class="LblockButton">
				   						<button type="button" class="btn"  id="addAnlRqprAttachBtn" name="addAnlRqprAttachBtn" onclick="openAttachFileDialog(setAnlRqprAttach, anlRqprDataSet.getNameValue(0, 'rqprAttcFileId'), 'anlPolicy', '*', 'M', '시료사진/첨부파일')">파일첨부</button>
				   					</div>
				   				</div>

				   				<div id="anlRqprAttachGrid"></div>
   							</td>
   						</tr>
   					</tbody>
   				</table>
				</form>
   				</div>

   				<div id="anlRqprResultDiv">
				<form name="bform" id="bform" method="post">
   				<div class="titArea">
   					<div class="LblockButton">
   						<button type="button" class="btn"  id="rsltApprStateBtn" name="rsltApprStateBtn" onclick="openApprStatePopup('C')" style="display:none;">결재상태</button>
   						<button type="button" class="btn"  id="rsltReportBtn" name="rsltReportBtn" onclick="openRsltReportPopup()">REPORT</button>
   						<button type="button" class="btn"  id="saveRsltBtn" name="saveRsltBtn" onclick="saveAnlRqprRslt()">저장</button>
   						<button type="button" class="btn"  id="approvalBtn" name="rejectBtn" onclick="approval()">결재의뢰</button>
   						<button type="button" class="btn"  id="stopBtn" name="stopBtn" onclick="stop()">분석중단</button>
   						<button type="button" class="btn"  id="listBtn" name="listBtn" onclick="goAnlRqprList4Chrg()">목록</button>
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
   							<th align="right">분석명</th>
   							<td><span id="anlNm"/></td>
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

   				<div class="titArea">
   					<h3>실험정보 등록</h3>
   					<div class="LblockButton">
   						<button type="button" class="btn"  id="addAnlRqprExprBtn" name="addAnlRqprExprBtn" onclick="addAnlRqprExpr()">등록</button>
   						<button type="button" class="btn"  id="deleteAnlRqprExprBtn" name="deleteAnlRqprExprBtn" onclick="deleteAnlRqprExpr()">삭제</button>
   					</div>
   				</div>

   				<div id="anlRqprExprGrid"></div>

   				<table class="table table_txt_right" style="table-layout:fixed;">
   					<colgroup>
   						<col style="width:15%;"/>
   						<col style="width:35%;"/>
   						<col style="width:15%;"/>
   						<col style="width:35%;"/>
   					</colgroup>
   					<tbody>
   						<tr>
   							<th align="right">분석결과</th>
   							<td colspan="3"><textarea id="anlRsltSbc"></textarea></td>
   						</tr>
   						<tr>
   							<th align="right">분석결과서</th>
   							<td colspan="2">
   								<span id="rsltAttcFileView"></span>
   							</td>
   							<td>
				   				<button type="button" class="btn"  id="addAnlRqprAttachBtn" name="addAnlRqprAttachBtn" onclick="openAttachFileDialog(setAnlRqprRsltAttach, anlRqprDataSet.getNameValue(0, 'rsltAttcFileId'), 'anlPolicy', '*')">파일첨부</button>
   							</td>
   						</tr>
   					</tbody>
   				</table>
   				</form>
   				</div>
   				<div id="anlRqprOpinitionDiv">
   				<div class="titArea">
   					<div class="LblockButton">
   						<button type="button" class="btn"  id="saveBtn" name="saveBtn" onclick="opinitionSave()">추가</button>
   						<!-- <button type="button" class="btn"  id="deleteBtn" name="deleteBtn" onclick="opinitionUpdate()">수정</button> -->
   						<button type="button" class="btn"  id="listBtn" name="listBtn" onclick="goAnlRqprList4Chrg()">목록</button>
   					</div>
   				</div>
   				<div id="anlRqprOpinitionGrid"></div>
   				<br/>
   				</div>

   			</div><!-- //sub-content -->
   		</div><!-- //contents -->
    </body>
</html>