<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>			
<%@ page import="java.text.*,
				 java.util.*,
				 devonframe.util.NullUtil,
				 devonframe.util.DateUtil"%>

<%--
/*
 *************************************************************************
 * $Id		: rlabRqprDetail4Chrg.jsp
 * @desc    : 분석의뢰서 상세
 *------------------------------------------------------------------------
 * VER	DATE		AUTHOR		DESCRIPTION
 * ---	-----------	----------	-----------------------------------------
 * 1.0  2018.08.17  정현웅		최초생성
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
		var rlabRqprDataSet;
		
		var exprWayDialog;
		
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
                	if(data.records[0].cmd == 'saveRlabRqpr') {
                		;
                	} else if(data.records[0].cmd == 'receipt') {
                    	goRlabRqprList4Chrg();
                	} else if(data.records[0].cmd == 'deleteRlabRqprExpr') {
                		getRlabRqprExprList();
                	} else if(data.records[0].cmd == 'saveRlabRqprRslt') {
                		;
                	} else if(data.records[0].cmd == 'requestRsltApproval') {
                    	var url = '<%=lghausysPath%>/lgchem/approval.front.document.RetrieveDocumentFormCmd.lgc?appCode=APP00333&approvalLineInform=SUB002&from=iris&guid=C${inputData.rqprId}';
                   		
                   		openWindow(url, 'rlabRqprCompleteApprovalPop', 800, 500, 'yes');
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
                    	label: '분석결과',
                        id: 'rlabRqprResultDiv'
                    }, {
                        label: '의견<span id="opinitionCnt"/>'
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
	            	if('03|05|06|07'.indexOf(rlabRqprDataSet.getNameValue(0, 'acpcStCd')) == -1) {
	            		return false;
	            	}
	            	
	                break;
	                
	            case 2:
	            	openRlabRqprOpinitionDialog();
	            	return false;
	            	
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
            
            var rlabNm = new Rui.ui.form.LTextBox({
            	applyTo: 'rlabNm',
                placeholder: '분석명을 입력해주세요.',
                defaultValue: '',
                emptyValue: '',
                width: 400
            });
            
            var rlabChrgNm = new Rui.ui.form.LTextBox({
            	applyTo: 'rlabChrgNm',
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
            
            var rlabScnCd = new Rui.ui.form.LCombo({
                applyTo: 'rlabScnCd',
                name: 'rlabScnCd',
                emptyText: '선택',
                defaultValue: '',
                emptyValue: '',
                width: 110,
                url: '<c:url value="/common/code/retrieveCodeListForCache.do?comCd=RLAB_SCN_CD"/>',
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
            
            var rlabSbc = new Rui.ui.form.LTextArea({
                applyTo: 'rlabSbc',
                placeholder: '분석배경과 목적, 결과 활용방안을 자세히 기재하여 주시기 바랍니다.',
                emptyValue: '',
                width: 980,
                height: 75
            });
            
            var rlabRsltSbc = new Rui.ui.form.LTextArea({
                applyTo: 'rlabRsltSbc',
                placeholder: '분석결과 내용을 입력해주세요.',
                emptyValue: '',
                width: 980,
                height: 175
            });
            
            var vm1 = new Rui.validate.LValidatorManager({
                validators:[
                { id: 'rlabNm',				validExp: '분석명:true:maxByteLength=100' },
                { id: 'rlabSbc',				validExp: '분석목적:true' },
                { id: 'cmplParrDt',			validExp: '완료예정일:true:date=YYYY-MM-DD' },
                { id: 'rlabScnCd',			validExp: '분석구분:true' },
                { id: 'rlabUgyYn',			validExp: '긴급유무:true' },
                { id: 'infmTypeCd',			validExp: '통보유형:true' },
                { id: 'smpoTrtmCd',			validExp: '시료처리:true' }
                ]
            });
            
            var vm2 = new Rui.validate.LValidatorManager({
                validators:[
                { id: 'rlabNm',				validExp: '분석명:true:maxByteLength=100' },
                { id: 'rlabSbc',				validExp: '분석목적:true' },
                { id: 'rlabScnCd',			validExp: '분석구분:true' },
                { id: 'rlabUgyYn',			validExp: '긴급유무:true' },
                { id: 'infmTypeCd',			validExp: '통보유형:true' },
                { id: 'smpoTrtmCd',			validExp: '시료처리:true' }
                ]
            });
            
            var vm3 = new Rui.validate.LValidatorManager({
                validators:[
                { id: 'rlabRsltSbc',			validExp: '분석결과:true' }
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
					, { id: 'rlabRqprInfmView' }
					, { id: 'rlabRsltSbc' }
					, { id: 'acpcStCd' }
					, { id: 'rqprAttcFileId' }
					, { id: 'rsltAttcFileId' }
					, { id: 'reqItgRdcsId' }
					, { id: 'rsltItgRdcsId' }
                ]
            });
            
            var acpcStCd;
            
            rlabRqprDataSet.on('load', function(e) {
            	var opinitionCnt = rlabRqprDataSet.getNameValue(0, 'opinitionCnt');
            	acpcStCd = rlabRqprDataSet.getNameValue(0, 'acpcStCd');
            	
            	//button controll
            	if( acpcStCd  == "04" ||  acpcStCd  == "05" || acpcStCd  == "06"  || acpcStCd  == "07" ){
            		//의뢰정보
            		$( '#saveBtn' ).hide();
            		$( '#receiptBtn' ).hide();
            		$( '#rejectBtn' ).hide();

            		//시료정보 
            		$( '#addRlabRqprSmpoBtn' ).hide();
            		$( '#deleteRlabRqprSmpoBtn' ).hide();
            		 
            		//관련분석
            		$( '#addRlabRqprRltdBtn' ).hide();
            		$( '#deleteRlabRqprRltdBtn' ).hide();
            		 
            		//첨부파일
            		$( '#addRlabRqprAttachBtn' ).hide();
            		 
            		//분석결과
            		$( '#saveRsltBtn' ).hide();
            		$( '#approvalBtn' ).hide();
            		$( '#stopBtn' ).hide();

            		//시료정보 
            		$( '#addRlabRqprExprBtn' ).hide();
            		$( '#deleteRlabRqprExprBtn' ).hide();
            	}
            	
            	if(Rui.isEmpty(rlabRqprDataSet.getNameValue(0, "rsltAttcFileId"))) {
            		rlabRqprDataSet.setNameValue(0, "rsltAttcFileId", '')
            	}
            	
            	if(opinitionCnt > 0) {
            		$('#opinitionCnt').html('(' + opinitionCnt + ')');
            	}
            	
            	if(!Rui.isEmpty(rlabRqprDataSet.getNameValue(0, 'rsltItgRdcsId'))) {
            		$('#rsltApprStateBtn').show();
            	}
            	
            	if(!Rui.isEmpty(rlabRqprDataSet.getNameValue(0, 'reqItgRdcsId'))) {
            		$('#reqApprStateBtn').show();
            	}
            	
            	if( acpcStCd =="04" || acpcStCd =="05" || acpcStCd =="07"  ){
            		$('#rlabSbcHtml').show();
            		$('#rlabSbc').hide();
            	}else{
            		$('#rlabSbcHtml').hide();
            		$('#rlabSbc').show();
            	}
            	
            	if( '${inputData._teamDept}' == "58141801" 
                    && ( acpcStCd =="00" || acpcStCd =="01" || acpcStCd =="02" || acpcStCd =="03" )  ){
    	    		
    	    		rlabRqprSmpoGrid.setEditable(true);
                }	
            });
        
            bind = new Rui.data.LBind({
                groupId: 'rlabRqprInfoDiv',
                dataSet: rlabRqprDataSet,
                bind: true,
                bindInfo: [
                    { id: 'rlabNm',				ctrlId:'rlabNm',				value:'value'},
                    { id: 'rlabSbc',				ctrlId:'rlabSbc',			value:'value'},
                    { id: 'rlabSbc',				ctrlId:'rlabSbcHtml',		value:'html'},
                    { id: 'acpcNo',				ctrlId:'acpcNo',			value:'html'},
                    { id: 'rgstNm',				ctrlId:'rgstNm',			value:'html'},
                    { id: 'rqprDeptNm',			ctrlId:'rqprDeptNm',		value:'html'},
                    { id: 'rqprDt',				ctrlId:'rqprDt',			value:'html'},
                    { id: 'acpcDt',				ctrlId:'acpcDt',			value:'html'},
                    { id: 'cmplParrDt',			ctrlId:'cmplParrDt',		value:'value'},
                    { id: 'cmplDt',				ctrlId:'cmplDt',			value:'html'},
                    { id: 'rlabScnCd',			ctrlId:'rlabScnCd',			value:'value'},
                    { id: 'rlabChrgId',			ctrlId:'rlabChrgId',			value:'value'},
                    { id: 'rlabChrgNm',			ctrlId:'rlabChrgNm',			value:'value'},
                    { id: 'rlabUgyYn',			ctrlId:'rlabUgyYn',			value:'value'},
                    { id: 'infmTypeCd',			ctrlId:'infmTypeCd',		value:'value'},
                    { id: 'smpoTrtmCd',			ctrlId:'smpoTrtmCd',		value:'value'},
                    { id: 'acpcStNm',			ctrlId:'acpcStNm',			value:'html'},
                    { id: 'rlabRqprInfmView',	ctrlId:'rlabRqprInfmView',	value:'html'}
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
                    { id: 'rlabRsltSbc',			ctrlId:'rlabRsltSbc',		value:'value'}
                ]
            });
			
            var rlabRqprSmpoDataSet = new Rui.data.LJsonDataSet({
                id: 'rlabRqprSmpoDataSet',
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

            var rlabRqprSmpoColumnModel = new Rui.ui.grid.LColumnModel({
                columns: [
                	  new Rui.ui.grid.LSelectionColumn()
                	, new Rui.ui.grid.LStateColumn()
                	, new Rui.ui.grid.LNumberColumn()
                    , { field: 'smpoNm',	label: '시료명',	editable: true, editor: textBox,	sortable: false,	align:'center',	width: 410 }
                    , { field: 'mkrNm',		label: '제조사',	editable: true, editor: textBox,	sortable: false,	align:'center',	width: 350 }
                    , { field: 'mdlNm',		label: '모델명',	editable: true, editor: textBox,	sortable: false,	align:'center',	width: 300 }
                    , { field: 'smpoQty',	label: '수량',		editable: true, editor: numberBox,	sortable: false,	align:'center',	width: 50 }
                ]
            });

            var rlabRqprSmpoGrid = new Rui.ui.grid.LGridPanel({
                columnModel: rlabRqprSmpoColumnModel,
                dataSet: rlabRqprSmpoDataSet,
                width: 700,
                height: 400,
                editable : true,
                autoWidth: true
            });
            
            rlabRqprSmpoGrid.render('rlabRqprSmpoGrid');
            
            
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
                    , { field: 'preRlabNm',		label: '분석명',		sortable: false,	align:'left',	width: 300 }
                    , { field: 'preRgstNm',		label: '의뢰자',		sortable: false,	align:'center',	width: 80 }
                    , { field: 'preRlabChrgNm',	label: '분석담당자',	sortable: false,	align:'center',	width: 80 }
                    , { field: 'rqprId',	hidden:true }
                    , { field: 'preRqprId',	hidden:true }
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
            
            rlabRqprRltdGrid.on('cellClick', function(e) {
            	 var record = rlabRqprRltdDataSet.getAt(rlabRqprRltdDataSet.getRow());
                 //var params = "?rqprId="+record.get("rqprId");
                 var params = "?rqprId="+record.get("preRqprId");
               
                 rlabRqprRltdDialog.setUrl('<c:url value="/rlab/rlabRqprSrchView.do"/>'+params);
                 rlabRqprRltdDialog.show(true);
            });
            
          	//관련분석 상세 이관
         	var rlabRqprRltdDialog = new Rui.ui.LFrameDialog({
    	        id: 'rlabRqprRltdDialog',
    	        title: '관련분석',
    	        width:  1000,
    	        height: 600,
    	        modal: true,
    	        visible: false
    	    });

         	rlabRqprRltdDialog.render(document.body);
         	
			
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
                    , { field: 'filNm',		label: '파일명',		sortable: false,	align:'left',	width: 510 }
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
    		
    	    // 분석결과 첨부파일 정보 설정
    	    setRlabRqprRsltAttach = function(attachFileList) {
    	    	rlabRqprRsltAttachDataSet.clearData();
    	    	
    	    	if(attachFileList.length > 0) {
    	    		rlabRqprDataSet.setNameValue(0, 'rsltAttcFileId', attachFileList[0].data.attcFilId);
    	    		
        	    	for(var i=0; i<attachFileList.length; i++) {
        	    		rlabRqprRsltAttachDataSet.add(attachFileList[i]);
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
			
            var rlabRqprExprDataSet = new Rui.data.LJsonDataSet({
                id: 'rlabRqprExprDataSet',
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
                ]
            });

            var rlabRqprExprColumnModel = new Rui.ui.grid.LColumnModel({
                columns: [
                	  new Rui.ui.grid.LSelectionColumn()
                    , new Rui.ui.grid.LNumberColumn()
                    , { field: 'exprNm',	label: '실험명',		sortable: false,	align:'left',	width: 400 }
                    , { field: 'smpoQty',	label: '실험수',		sortable: false,	align:'center',	width: 70 }
                    , { field: 'exprTim',	label: '실험시간',	sortable: false,	align:'center',	width: 80 }
                    , { field: 'exprExp',	label: '수가',		sortable: false,	align:'center',	width: 100, renderer: function(val, p, record, row, col) {
                    	return Rui.util.LNumber.toMoney(val, '') + '원';
                      } }
                    , { field: 'exprWay',	label: '실험방법',		sortable: false,	align:'left',	width: 430 }
                ]
            });

            var rlabRqprExprGrid = new Rui.ui.grid.LGridPanel({
                columnModel: rlabRqprExprColumnModel,
                dataSet: rlabRqprExprDataSet,
                width: 600,
                height: 200,
                autoToEdit: false,
                autoWidth: true
            });

            rlabRqprExprGrid.on('cellClick', function(e) {
            	if(e.col == 0) {
            		return ;
            	}
                if (rlabRqprDataSet.getNameValue(0, 'acpcStCd') != '03') {
                    //alert('분석진행 상태일때만 실험결과를 수정 할 수 있습니다.');
                    //return false;
                    openExprWayDialog(rlabRqprExprDataSet.getNameValue(e.row, 'rqprExprId'));
                }else{
	            	openRlabRqprExprRsltDialog(getRlabRqprExprList, rlabRqprExprDataSet.getNameValue(e.row, 'rqprExprId'));
                }
            });
            
            rlabRqprExprGrid.render('rlabRqprExprGrid');
    	    
            openExprWayDialog = function(rqprExprId) {
    	    	exprWayDialog.setUrl('<c:url value="/rlab/exprWayPopup.do?rqprId="/>' + rlabRqprDataSet.getNameValue(0, 'rqprId') + '&rqprExprId=' + rqprExprId);
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
		    rlabChrgListDialog = new Rui.ui.LFrameDialog({
		        id: 'rlabChrgListDialog',
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

		    rlabChrgListDialog.render(document.body);
		    
			openRlabChrgListDialog = function(f) {
				_callback = f;

				rlabChrgListDialog.setUrl('<c:url value="/rlab/rlabChrgDialog.do"/>');
				rlabChrgListDialog.show();
			};
			// 분석 담당자 선택팝업 끝
            
            setRlabChrgInfo = function(rlabChrgInfo) {
            	rlabRqprDataSet.setNameValue(0, 'rlabChrgId', rlabChrgInfo.id);
            	rlabRqprDataSet.setNameValue(0, 'rlabChrgNm', rlabChrgInfo.name);
            };
    	    
    	    // 분석의뢰 의견 팝업 시작
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
    	    // 분석의뢰 의견 팝업 끝
    	    
    	    // 분석의뢰 반려/분석중단 팝업 시작
    	    rlabRqprEndDialog = new Rui.ui.LFrameDialog({
    	        id: 'rlabRqprEndDialog', 
    	        title: '',
    	        width: 520,
    	        height: 230,
    	        modal: true,
    	        visible: false
    	    });
    	    
    	    rlabRqprEndDialog.render(document.body);
    	
    	    openRlabRqprEndDialog = function(type) {
    	    	$('#rlabRqprEndDialog_h').html(type == '반려' ? '분석의뢰 반려' : '분석중단');
    	    	rlabRqprEndDialog.setUrl('<c:url value="/rlab/rlabRqprEndPopup.do?type="/>' + escape(encodeURIComponent(type)));
    	    	rlabRqprEndDialog.show();
    	    };
    	    // 분석의뢰 반려/분석중단 팝업 끝
    	    
    	    // 실험정보 등록/수정 팝업 시작
    	    rlabRqprExprRsltDialog = new Rui.ui.LFrameDialog({
    	        id: 'rlabRqprExprRsltDialog', 
    	        title: '실험정보 등록/수정',
    	        width: 740,
    	        height: 520,
    	        modal: true,
    	        visible: false
    	    });
    	    
    	    rlabRqprExprRsltDialog.render(document.body);
    	
    	    openRlabRqprExprRsltDialog = function(f, rqprExprId) {
    	    	callback = f;
    	    	
    	    	rlabRqprExprRsltDialog.setUrl('<c:url value="/rlab/rlabRqprExprRsltPopup.do?rqprId="/>' + rlabRqprDataSet.getNameValue(0, 'rqprId') + '&rqprExprId=' + rqprExprId);
    	    	rlabRqprExprRsltDialog.show();
    	    };
    	    // 실험결과 등록/수정 팝업 끝
            
            /* 접수 */
            saveRlabRqpr = function() {
    	    	if('02|03'.indexOf(rlabRqprDataSet.getNameValue(0, 'acpcStCd')) == -1) {
    	    		alert('접수대기, 분석진행 상태일때만 저장 할 수 있습니다.');
    	    		return false;
    	    	}
    	    	
                if (vm2.validateDataSet(rlabRqprDataSet) == false) {
                    alert(Rui.getMessageManager().get('$.base.msg052') + '\n' + vm2.getMessageList().join('\n'));
                    return false;
                }
                
            	if(confirm('저장 하시겠습니까?')) {
                    dm.updateDataSet({
                        //dataSets:[rlabRqprDataSet],
                        dataSets:[rlabRqprDataSet, rlabRqprSmpoDataSet, rlabRqprRltdDataSet],
                        url:'<c:url value="/rlab/saveRlabRqpr.do"/>',
                        modifiedOnly: false
                    });
            	}
            };
            
            /* 접수 */
            receipt = function() {
    	    	if(rlabRqprDataSet.getNameValue(0, 'acpcStCd') != '02') {
    	    		alert('접수대기 상태일때만 접수 할 수 있습니다.');
    	    		return false;
    	    	}
    	    	
                if (vm1.validateDataSet(rlabRqprDataSet) == false) {
                    alert(Rui.getMessageManager().get('$.base.msg052') + '\n' + vm1.getMessageList().join('\n'));
                    return false;
                }
                
            	if(confirm('접수 하시겠습니까?')) {
                    dm.updateDataSet({
                        dataSets:[rlabRqprDataSet],
                        url:'<c:url value="/rlab/receiptRlabRqpr.do"/>',
                        modifiedOnly: false
                    });
            	}
            };
            
            /* 접수반려 */
            reject = function() {
                if (rlabRqprDataSet.getNameValue(0, 'acpcStCd') != '02') {
                    alert('접수대기 상태일때만 반려 할 수 있습니다.');
                    return false;
                }
                
            	openRlabRqprEndDialog('반려');
            };
            
            /* 분석결과 저장 */
            saveRlabRqprRslt = function() {
    	    	if(rlabRqprDataSet.getNameValue(0, 'acpcStCd') != '03') {
    	    		alert('분석진행 상태일때만 분석결과를 저장 할 수 있습니다.');
    	    		return false;
    	    	}
    	    	
//                 if (vm3.validateDataSet(rlabRqprDataSet) == false) {
//                     alert(Rui.getMessageManager().get('$.base.msg052') + '\n' + vm3.getMessageList().join('\n'));
//                     return false;
//                 }
                
            	if(confirm('저장 하시겠습니까?')) {
                    dm.updateDataSet({
                        dataSets:[rlabRqprDataSet],
                        url:'<c:url value="/rlab/saveRlabRqprRslt.do"/>',
                        modifiedOnly: false
                    });
            	}
            };
            
            /* 결재의뢰 */
            approval = function() {
    	    	if(rlabRqprDataSet.getNameValue(0, 'acpcStCd') != '03') {
    	    		alert('분석진행 상태일때만 결재의뢰 할 수 있습니다.');
    	    		return false;
    	    	}
    	    	
                if (vm3.validateDataSet(rlabRqprDataSet) == false) {
                    alert(Rui.getMessageManager().get('$.base.msg052') + '\n' + vm3.getMessageList().join('\n'));
                    return false;
                }
                
            	if(confirm('결재의뢰 하시겠습니까?')) {
                    dm.updateDataSet({
                        dataSets:[rlabRqprDataSet],
                        url:'<c:url value="/rlab/requestRlabRqprRsltApproval.do"/>',
                        modifiedOnly: false
                    });
            	}
            };
            
            /* 분석중단 */
            stop = function() {
                if ('03|06'.indexOf(rlabRqprDataSet.getNameValue(0, 'acpcStCd')) == -1) {
                    alert('분석진행, 결과검토 상태일때만 중단 할 수 있습니다.');
                    return false;
                }
                
            	openRlabRqprEndDialog('중단');
            };
            
            /* 실험결과 등록/수정 팝업 */
            addRlabRqprExpr = function() {
                if (rlabRqprDataSet.getNameValue(0, 'acpcStCd') != '03') {
                    alert('분석진행 상태일때만 실험결과를 등록 할 수 있습니다.');
                    return false;
                }
                
                openRlabRqprExprRsltDialog(getRlabRqprExprList, 0);
            };
            
            /* 실험결과 삭제 */
            deleteRlabRqprExpr = function() {
            	
				var chkAcpcSt = rlabRqprDataSet.getNameValue(0, 'acpcStCd');
            	
				if(chkAcpcSt == "06"){
					alert("결과검토 상태는 삭제를 할수없습니다.");
					return false;
					
				}else if( chkAcpcSt == "07"){
					alert("분석완료 상태는 삭제를 할수없습니다.");
					return false;
				}     
				
                if(rlabRqprExprDataSet.getMarkedCount() > 0) {
                	if(confirm('삭제 하시겠습니까?')) {
                    	rlabRqprExprDataSet.removeMarkedRows();
                    	
                        dm.updateDataSet({
                            dataSets:[rlabRqprExprDataSet],
                            url:'<c:url value="/rlab/deleteRlabRqprExpr.do"/>'
                        });
                	}
                } else {
                	alert('삭제 대상을 선택해주세요.');
                }
            };
    		
            getRlabRqprExprList = function() {
            	rlabRqprExprDataSet.load({
                    url: '<c:url value="/rlab/getRlabRqprExprList.do"/>',
                    params :{
                    	rqprId : '${inputData.rqprId}'
                    }
                });
    	    };
    	    
            goRlabRqprList4Chrg = function() {
    	    	$('#searchForm > input[name=rlabNm]').val(encodeURIComponent($('#searchForm > input[name=rlabNm]').val()));
    	    	$('#searchForm > input[name=rgstNm]').val(encodeURIComponent($('#searchForm > input[name=rgstNm]').val()));
    	    	$('#searchForm > input[name=rlabChrgNm]').val(encodeURIComponent($('#searchForm > input[name=rlabChrgNm]').val()));
    	    	
    	    	nwinsActSubmit(searchForm, "<c:url value="/rlab/rlabRqprList4Chrg.do"/>");
    	    };
    	
    	    openApprStatePopup = function(type) {
    	    	var seq = type == 'A' ? rlabRqprDataSet.getNameValue(0, 'reqItgRdcsId') : rlabRqprDataSet.getNameValue(0, 'rsltItgRdcsId');
            	var url = '<%=lghausysPath%>/lgchem/approval.front.approval.RetrieveAppTargetCmd.lgc?seq=' + seq;
           		
           		openWindow(url, 'openApprStatePopup', 800, 250, 'yes');
    	    };
    	    
    	    openRsltReportPopup = function(type) {
    	    	var width = 1200;
            	var url = '<%=lghausysReportPath%>/rlabRqprReportRslt.jsp?reportMode=HTML&clientURIEncoding=UTF-8&reportParams=skip_decimal_point:true&menu=old&RQPR_ID=<c:out value="${inputData.rqprId}"/>';
            	
            	if(rlabRqprDataSet.getNameValue(0, 'infmTypeCd') == 'T') {
            		width = 850;
            		url = '<%=lghausysReportPath%>/rlabRqprTestRslt.jsp?reportMode=HTML&clientURIEncoding=UTF-8&reportParams=skip_decimal_point:true&menu=old&RQPR_ID=<c:out value="${inputData.rqprId}"/>';
            	}
           		
           		openWindow(url, 'openRsltReportPopup', width, 500, 'yes');
    	    };
    	    
	    	dm.loadDataSet({
                dataSets: [rlabRqprDataSet, rlabRqprSmpoDataSet, rlabRqprRltdDataSet, rlabRqprAttachDataSet, rlabRqprRsltAttachDataSet, rlabRqprExprDataSet],
                url: '<c:url value="/rlab/getRlabRqprDetailInfo.do"/>',
                params: {
                    rqprId: '${inputData.rqprId}'
                }
            });
	    	
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
            
            
         // 관련분석 조회 팝업 시작
    	    rlabRqprSearchDialog = new Rui.ui.LFrameDialog({
    	        id: 'rlabRqprSearchDialog', 
    	        title: '관련분석 조회',
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
    	    
    	    /* 관련분석 삭제 */
            deleteRlabRqprRltd = function() {
                if(rlabRqprRltdDataSet.getMarkedCount() > 0) {
                	rlabRqprRltdDataSet.removeMarkedRows();
                } else {
                	alert('삭제 대상을 선택해주세요.');
                }
            };
            
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
    	    
        });
	</script>
    </head>
    <body>
    <form name="searchForm" id="searchForm">
		<input type="hidden" name="rlabNm" value="${inputData.rlabNm}"/>
		<input type="hidden" name="fromRqprDt" value="${inputData.fromRqprDt}"/>
		<input type="hidden" name="toRqprDt" value="${inputData.toRqprDt}"/>
		<input type="hidden" name="rqprDeptNm" value="${inputData.rqprDeptNm}"/>
		<input type="hidden" name="rqprDeptCd" value="${inputData.rqprDeptCd}"/>
		<input type="hidden" name="rgstNm" value="${inputData.rgstNm}"/>
		<input type="hidden" name="rlabChrgNm" value="${inputData.rlabChrgNm}"/>
		<input type="hidden" name="acpcNo" value="${inputData.acpcNo}"/>
		<input type="hidden" name="acpcStCd" value="${inputData.acpcStCd}"/>
    </form>
    <form name="fileDownloadForm" id="fileDownloadForm">
		<input type="hidden" id="attcFilId" name="attcFilId" value=""/>
		<input type="hidden" id="seq" name="seq" value=""/>
    </form>
   		<div class="contents">
   		
   			<div class="sub-content">
   				<div id="tabView"></div>
	            <div id="rlabRqprInfoDiv">
				<form name="aform" id="aform" method="post">
					<input type="hidden" id="rlabChrgId" name="rlabChrgId" value=""/>
   				<div class="titArea">
   					<div class="LblockButton">
   						<button type="button" class="btn"  id="reqApprStateBtn" name="reqApprStateBtn" onclick="openApprStatePopup('A')" style="display:none;">결재상태</button>
   						<button type="button" class="btn"  id="saveBtn" name="saveBtn" onclick="saveRlabRqpr()">저장</button>
   						<button type="button" class="btn"  id="receiptBtn" name="receiptBtn" onclick="receipt()">접수</button>
   						<button type="button" class="btn"  id="rejectBtn" name="rejectBtn" onclick="reject()">반려</button>
   						<button type="button" class="btn"  id="listBtn" name="listBtn" onclick="goRlabRqprList4Chrg()">목록</button>
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
   								<input type="text" id="rlabNm">
   							</td>
   							<th align="right">접수번호</th>
   							<td><span id="acpcNo"/></td>
   						</tr>
   						<tr>
   							<th align="right">분석목적</th>
   							<td colspan="3">
   								<textarea id="rlabSbc"></textarea>
   								<span id="rlabSbcHtml"></span>
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
                                <div id="rlabScnCd"></div>
   							</td>
   							<th align="right">분석담당자</th>
   							<td>
   								<input type="text" id="rlabChrgNm">
                                <a href="javascript:openRlabChrgListDialog(setRlabChrgInfo);" class="icoBtn">검색</a>
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
   							<td colspan="3"><span id="rlabRqprInfmView"/></td>
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
				   					<h3>관련분석</h3>
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
				<form name="bform" id="bform" method="post">
   				<div class="titArea">
   					<div class="LblockButton">
   						<button type="button" class="btn"  id="rsltApprStateBtn" name="rsltApprStateBtn" onclick="openApprStatePopup('C')" style="display:none;">결재상태</button>
   						<button type="button" class="btn"  id="rsltReportBtn" name="rsltReportBtn" onclick="openRsltReportPopup()">REPORT</button>
   						<button type="button" class="btn"  id="saveRsltBtn" name="saveRsltBtn" onclick="saveRlabRqprRslt()">저장</button>
   						<button type="button" class="btn"  id="approvalBtn" name="rejectBtn" onclick="approval()">결재의뢰</button>
   						<button type="button" class="btn"  id="stopBtn" name="stopBtn" onclick="stop()">분석중단</button>
   						<button type="button" class="btn"  id="listBtn" name="listBtn" onclick="goRlabRqprList4Chrg()">목록</button>
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
   					</tbody>
   				</table>
   				
   				<div class="titArea">
   					<h3>실험정보 등록</h3>
   					<div class="LblockButton">
   						<button type="button" class="btn"  id="addRlabRqprExprBtn" name="addRlabRqprExprBtn" onclick="addRlabRqprExpr()">등록</button>
   						<button type="button" class="btn"  id="deleteRlabRqprExprBtn" name="deleteRlabRqprExprBtn" onclick="deleteRlabRqprExpr()">삭제</button>
   					</div>
   				</div>

   				<div id="rlabRqprExprGrid"></div>
   				
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
   							<td colspan="3"><textarea id="rlabRsltSbc"></textarea></td>
   						</tr>
   						<tr>
   							<th align="right">분석결과서</th>
   							<td colspan="2">
   								<span id="rsltAttcFileView"></span>
   							</td>
   							<td>
				   				<button type="button" class="btn"  id="addRlabRqprAttachBtn" name="addRlabRqprAttachBtn" onclick="openAttachFileDialog(setRlabRqprRsltAttach, rlabRqprDataSet.getNameValue(0, 'rsltAttcFileId'), 'rlabPolicy', '*')">파일첨부</button>
   							</td>
   						</tr>
   					</tbody>
   				</table>
   				</form>
   				</div>
   				
   			</div><!-- //sub-content -->
   		</div><!-- //contents -->
    </body>
</html>