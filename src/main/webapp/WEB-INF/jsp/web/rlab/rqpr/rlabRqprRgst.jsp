<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*,
				 java.util.*,
				 devonframe.util.NullUtil,
				 devonframe.util.DateUtil"%>

<%--
/*
 *************************************************************************
 * $Id		: rlabRqprRgst.jsp
 * @desc    : 시험의뢰서 등록
 *------------------------------------------------------------------------
 * VER	DATE		AUTHOR		DESCRIPTION
 * ---	-----------	----------	-----------------------------------------
 * 1.0  2018.08.07  정현웅		최초생성
 * ---	-----------	----------	-----------------------------------------
 * IRIS UPGRADE 2차 프로젝트
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
		var rlabRqprDataSet;
		var rlabChrgNm;

		Rui.onReady(function() {
            /*******************
             * 변수 및 객체 선언
             *******************/

			var dm = new Rui.data.LDataSetManager();

            dm.on('load', function(e) {
            });

            dm.on('success', function(e) {
                var data = rlabRqprSmpoDataSet.getReadData(e);

                alert(data.records[0].resultMsg);

                if(data.records[0].resultYn == 'Y') {
                	goRlabRqprList();
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

            //*******************필드 객체 설정********************//


            /* 시험명 */
            var rlabNm = new Rui.ui.form.LTextBox({
            	applyTo: 'rlabNm',
                placeholder: '시험명을 입력해주세요.',
                defaultValue: '',
                emptyValue: '',
                width: 980
            });


            /* 시험목적 */
            var rlabSbc = new Rui.ui.form.LTextArea({
                applyTo: 'rlabSbc',
                placeholder: '시험배경과 목적, 결과 활용방안을 자세히 기재하여 주시기 바랍니다.',
                emptyValue: '',
                width: 980,
                height: 75
            });


            /*사업부 조회*/
            var rlabDzdvCdDataSet = new Rui.data.LJsonDataSet({
                id: 'rlabDzdvCdDataSet',
                remainRemoved: true,
                lazyLoad: true,
                fields: [
                	  { id: 'COM_DTL_CD' }
                	, { id: 'COM_DTL_NM' }
                ]
            });
            rlabDzdvCdDataSet.load({
                url: '<c:url value="/common/code/retrieveCodeListForCache.do"/>',
                params :{
                	comCd : 'RLAB_DZDV_CD'
                }
            });
            var rlabDzdvCd = new Rui.ui.form.LCombo({
                applyTo: 'rlabDzdvCd',
                name: 'rlabDzdvCd',
                emptyText: '(선택)',
                defaultValue: '',
                emptyValue: '',
                width: 150,
                dataSet: rlabDzdvCdDataSet,
                displayField: 'COM_DTL_NM',
                valueField: 'COM_DTL_CD'
            });
/* 
            rlabDzdvCd.on('changed', function(e) {
	        	//alert(rlabDzdvCd.getValue());
	        	var selectDzdvCd = rlabDzdvCd.getValue();
	        	//제품군(하위selectBox) 데이터 조회
	        	rlabProdCdDataSet.load({
	                url: '<c:url value="/common/code/retrieveCodeListForCache.do"/>',
	                params :{
	                	comCd : selectDzdvCd
	                }
	            });
	        });
            
   */          
            /*사업부 조회 끝*/


            /*시료 제품군 조회
            var rlabProdCdDataSet = new Rui.data.LJsonDataSet({
                id: 'rlabProdCdDataSet',
                remainRemoved: true,
                lazyLoad: true,
                fields: [
                	  { id: 'COM_DTL_CD' }
                	, { id: 'COM_DTL_NM' }
                ]
            });

            var rlabProdCd = new Rui.ui.form.LCombo({
                applyTo: 'rlabProdCd',
                name: 'rlabProdCd',
                emptyText: '(선택)',
                defaultValue: '',
                emptyValue: '',
                width: 110,
                dataSet: rlabProdCdDataSet,
                displayField: 'COM_DTL_NM',
                valueField: 'COM_DTL_CD'
            });
            */
            
            /*제품군 조회 끝*/


            /*시험구분 조회*/
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

            var rlabScnCd = new Rui.ui.form.LCombo({
                applyTo: 'rlabScnCd',
                name: 'rlabScnCd',
                emptyText: '(선택)',
                defaultValue: '',
                emptyValue: '',
                width: 150,
                dataSet: rlabScnCdDataSet,
                displayField: 'COM_DTL_NM',
                valueField: 'COM_DTL_CD'
            });
            /*시험구분 조회 끝*/




		/* <c:if test="${fn:indexOf(inputData._roleId, 'WORK_IRI_T06') == -1}">
			rlabScnCdDataSet.on('load', function(e) {
				rlabScnCdDataSet.removeAt(rlabScnCdDataSet.findRow('COM_DTL_CD', 'O'));
	        });
        </c:if> */

	        /* 긴급유무 */
	        var rlabUgyYn = new Rui.ui.form.LCombo({
	            applyTo: 'rlabUgyYn',
	            name: 'rlabUgyYn',
	            emptyText: '(선택)',
	            defaultValue: '',
	            emptyValue: '',
	            width: 110,
	            url: '<c:url value="/common/code/retrieveCodeListForCache.do?comCd=ANL_UGY_YN"/>',
	            displayField: 'COM_DTL_NM',
	            valueField: 'COM_DTL_CD'
	        });


	        /* 통보유형 */
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


           /*시험담당자 팝업 설정*/
           /*  var rlabChrgNm = new Rui.ui.form.LPopupTextBox({
            	applyTo: 'rlabChrgNm',
                placeholder: '시험담당자를 입력해주세요.',
                defaultValue: '',
                emptyValue: '',
                editable: false,
                width: 200
            });
            rlabChrgNm.on('popup', function(e){
                openUserSearchDialog(setRlabChrgInfo, 1, '');
            }); */
            /*시험담당자 팝업 설정 끝*/

            /*시험담당자 필드 설정*/
            var rlabChrgNm = new Rui.ui.form.LPopupTextBox({
            	applyTo: 'rlabChrgNm',
                placeholder: '시험담당자를 입력해주세요.',
                defaultValue: '',
                emptyValue: '',
                editable: false,
                width: 200
            });
            rlabChrgNm.on('popup', function(e){
            	openRlabChrgListDialog(setRlabChrgInfo, 1, '');
            });

            /*시험담당자 팝업 설정*/
		    rlabChrgListDialog = new Rui.ui.LFrameDialog({
		        id: 'rlabChrgListDialog',
		        title: '시험담당자',
		        width: 500,
		        height: 570,
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

			//시험 담당자 리턴
			setRlabChrgInfo = function(rlabChrgInfo) {
            	rlabRqprDataSet.setNameValue(0, "rlabChrgId", rlabChrgInfo.id);
    			rlabRqprDataSet.setNameValue(0, "rlabChrgNm", rlabChrgInfo.name);
            };
			//시험담당자 팝업 설정 끝



            /* 시료처리 */
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


            /* WBS 팝업 설정
            var wbsCd = new Rui.ui.form.LPopupTextBox({
            	applyTo: 'wbsCd',
                placeholder: 'WBS코드를 입력해주세요.',
                defaultValue: '',
                emptyValue: '',
                editable: false,
                width: 200
            });
            wbsCd.on('popup', function(e){
            	var deptYn = "Y";
            	openWbsCdSearchDialog(setRlabWbsCd , deptYn);
            });
            */

            /* 통보자 팝업 설정*/
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

            /* 시험 담당자 코멘트 */
            var rlabCrgrComm = new Rui.ui.form.LTextArea({
                applyTo: 'rlabCrgrComm',
                placeholder: '담당자에게 전달하고자 하는 내용을 작성 바랍니다.',
                emptyValue: '',
                width: 980,
                height: 75
            });



            var vm = new Rui.validate.LValidatorManager({
                validators:[
                { id: 'rlabNm',				validExp: '시험명:true:maxByteLength=100' },
                { id: 'rlabSbc',			validExp: '시험목적:true' },
				/* { id: 'rlabProdCd',			validExp: '시료 제품군:true' }, */
                { id: 'rlabScnCd',			validExp: '시험구분:true' },
                { id: 'rlabUgyYn',			validExp: '긴급유무:true' },
                { id: 'infmTypeCd',			validExp: '통보유형:true' },
                { id: 'rlabChrgId',			validExp: '시험담당자:true' },
                { id: 'smpoTrtmCd',			validExp: '시료처리:true' },
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
                	  { id: 'rlabNm' }
  					, { id: 'rlabSbc' }
  					/* , { id: 'rlabProdCd' } */
                	, { id: 'rlabScnCd' }
					, { id: 'rlabUgyYn' }
					, { id: 'infmTypeCd' }
					, { id: 'rlabChrgId' }
					, { id: 'rlabChrgNm' }
					, { id: 'smpoTrtmCd' }
					, { id: 'infmPrsnIds' }
					, { id: 'rlabRqprInfmView' }
					, { id: 'rqprAttcFileId', defaultValue: '' }
					/* , { id: 'wbsCd' } */
					, { id: 'rlabDzdvCd' }
					, { id: 'rlabCrgrComm' }
                ]
            });

            rlabRqprDataSet.on('load', function(e) {
            	rlabRqprDataSet.setNameValue(0, 'rqprAttcFileId', '');
            	rlabRqprDataSet.setNameValue(0, 'infmPrsnIds', '');
            	rlabRqprDataSet.setNameValue(0, 'rlabRqprInfmView', '');
            });

            bind = new Rui.data.LBind({
                groupId: 'mainForm',
                dataSet: rlabRqprDataSet,
                bind: true,
                bindInfo: [
                    { id: 'rlabNm',				ctrlId:'rlabNm',			value:'value'},
                    { id: 'rlabSbc',			ctrlId:'rlabSbc',			value:'value'},
                    { id: 'rlabScnCd',			ctrlId:'rlabScnCd',			value:'value'},
                    { id: 'rlabUgyYn',			ctrlId:'rlabUgyYn',			value:'value'},
                    { id: 'infmTypeCd',			ctrlId:'infmTypeCd',		value:'value'},
                    { id: 'rlabChrgId',			ctrlId:'rlabChrgId',		value:'value'},
                    { id: 'rlabChrgNm',			ctrlId:'rlabChrgNm',		value:'value'},
                    { id: 'smpoTrtmCd',			ctrlId:'smpoTrtmCd',		value:'value'},
                    { id: 'rlabRqprInfmView',	ctrlId:'rlabRqprInfmView',	value:'value'},
                 /*    { id: 'wbsCd',				ctrlId:'wbsCd',				value:'value'}, */
                    { id: 'rlabDzdvCd',			ctrlId:'rlabDzdvCd',		value:'value'},
                  /*   { id: 'rlabProdCd',			ctrlId:'rlabProdCd',		value:'value'}, */
                    { id: 'rlabCrgrComm',		ctrlId:'rlabCrgrComm',		value:'value'}
                ]
            });

            rlabRqprDataSet.newRecord();

            var rlabRqprSmpoDataSet = new Rui.data.LJsonDataSet({
                id: 'rlabRqprSmpoDataSet',
                remainRemoved: false,
                lazyLoad: true,
                fields: [
                	  { id: 'smpoId', defaultValue: '' }
                	, { id: 'rqprId', defaultValue: '' }
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
                    , new Rui.ui.grid.LNumberColumn()
                    , { field: 'smpoNm',	label: '<span style="color:red;">* </span>시료명',	sortable: false,	editable: true, editor: textBox,	align:'center',	width: 395 }
                    , { field: 'mkrNm',		label: '<span style="color:red;">* </span>제조사',	sortable: false,	editable: true, editor: textBox,	align:'center',	width: 395 }
                    , { field: 'mdlNm',		label: '<span style="color:red;">* </span>모델명',	sortable: false,	editable: true, editor: textBox,	align:'center',	width: 395 }
                    , { field: 'smpoQty',	label: '<span style="color:red;">* </span>수량',		sortable: false,	editable: true, editor: numberBox,	align:'center',	width: 50 }
                ]
            });

            var rlabRqprSmpoGrid = new Rui.ui.grid.LGridPanel({
                columnModel: rlabRqprSmpoColumnModel,
                dataSet: rlabRqprSmpoDataSet,
                width: 700,
                height: 200,
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
					  { id: 'rltdId', defaultValue: '' }
					, { id: 'rqprId', defaultValue: '' }
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
                    , new Rui.ui.grid.LNumberColumn()
                    , { field: 'preAcpcNo',		label: '접수번호',	sortable: false,	align:'center',	width: 80 }
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

    	 	// 관련시험 세팅 //
    	    setRlabRqprRltd = function(rlabRqpr) {
				if(rlabRqprRltdDataSet.findRow('preRqprId', rlabRqpr.rqprId) > -1) {
					alert('이미 존재합니다.');
					return ;
				}

				var row = rlabRqprRltdDataSet.newRecord();
				var record = rlabRqprRltdDataSet.getAt(row);

				record.set('preRqprId', rlabRqpr.rqprId);
				record.set('preRlabNm', rlabRqpr.rlabNm);
				record.set('preAcpcNo', rlabRqpr.acpcNo);
				record.set('preRgstId', rlabRqpr.rgstId);
				record.set('preRgstNm', rlabRqpr.rgstNm);
				record.set('preRlabChrgNm', rlabRqpr.rlabChrgNm);
    	    };

    	    getRlabRqprInfo = function(rlabRqpr) {
            	resetMainForm();

    	    	dm.loadDataSet({
                    dataSets: [rlabRqprDataSet, rlabRqprSmpoDataSet],
                    url: '<c:url value="/rlab/getRlabRqprInfo.do"/>',
                    params: {
                        rqprId: rlabRqpr.rqprId
                    }
                });
    	    };



            /* 초기화 */
            resetMainForm = function() {
            	rlabRqprDataSet.clearData();
            	rlabRqprSmpoDataSet.clearData();
            	rlabRqprRltdDataSet.clearData();
            	rlabRqprAttachDataSet.clearData();

            	rlabRqprDataSet.newRecord();
            };

            /* 저장 */
            save = function() {
                if (vm.validateDataSet(rlabRqprDataSet) == false) {
                    alert(Rui.getMessageManager().get('$.base.msg052') + '\n' + vm.getMessageList().join('\n'));
                    return false;
                }

                if (rlabRqprSmpoDataSet.getCount() == 0) {
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

                if(confirm('저장 하시겠습니까?')) {
                    dm.updateDataSet({
                        dataSets:[rlabRqprDataSet, rlabRqprSmpoDataSet, rlabRqprRltdDataSet],
                        url:'<c:url value="/rlab/regstRlabRqpr.do"/>',
                        modifiedOnly: false
                    });
                }
            };

    	    goRlabRqprList = function() {
    	    	$('#searchForm > input[name=rlabNm]').val(encodeURIComponent($('#searchForm > input[name=rlabNm]').val()));
    	    	$('#searchForm > input[name=rgstNm]').val(encodeURIComponent($('#searchForm > input[name=rgstNm]').val()));
    	    	$('#searchForm > input[name=rlabChrgNm]').val(encodeURIComponent($('#searchForm > input[name=rlabChrgNm]').val()));

    	    	nwinsActSubmit(searchForm, "<c:url value="/rlab/rlabRqprList.do"/>");
    	    };
        });


		//시험담당자 팝업 셋팅
		/* function setRlabChrgInfo(userInfo) {
			rlabRqprDataSet.setNameValue(0, "rlabChrgId", userInfo.saUser);
			rlabRqprDataSet.setNameValue(0, "rlabChrgNm", userInfo.saName);
		} */

		/* 
		//WBS 코드 팝업 세팅
		function setRlabWbsCd(wbsInfo){
			//alert(wbsInfo.wbsCd);
			rlabRqprDataSet.setNameValue(0, "wbsCd", wbsInfo.wbsCd);
		}
 */

	</script>
    </head>
    <body>
    <form name="searchForm" id="searchForm">
		<input type="hidden" name="rlabNm" value="${inputData.rlabNm}"/>
		<input type="hidden" name="fromRqprDt" value="${inputData.fromRqprDt}"/>
		<input type="hidden" name="toRqprDt" value="${inputData.toRqprDt}"/>
		<input type="hidden" name="rgstNm" value="${inputData.rgstNm}"/>
		<input type="hidden" name="rlabChrgNm" value="${inputData.rlabChrgNm}"/>
		<input type="hidden" name="acpcNo" value="${inputData.acpcNo}"/>
		<input type="hidden" name="rlabAcpcStCd" value="${inputData.rlabAcpcStCd}"/>
    </form>
    <form name="fileDownloadForm" id="fileDownloadForm">
		<input type="hidden" id="attcFilId" name="attcFilId" value=""/>
		<input type="hidden" id="seq" name="seq" value=""/>
    </form>
	<form name="mainForm" id="mainForm" method="post">
		<input type="hidden" id="rlabChrgId" name="rlabChrgId" value=""/>
   		<div class="contents">
   			<div class="titleArea">
		    	<a class="leftCon" href="#">
			        <img src="/iris/resource/web/images/img_uxp/ico_leftCon.png" alt="Left Navigation Control">
			        <span class="hidden">Toggle 버튼</span>
				</a>
		        <h2>신뢰성 시험 의뢰서 등록</h2>
		    </div>


   			<div class="sub-content">
	   			<div class="titArea mt0">
					<div class="LblockButton">
						<button type="button" class="btn"  id="resetBtn" name="resetBtn" onclick="resetMainForm()">초기화</button>
						<button type="button" class="btn"  id="loadRlabRqprBtn" name="loadRlabRqprBtn" onclick="openRlabRqprSearchDialog(getRlabRqprInfo)">불러오기</button>
						<button type="button" class="btn"  id="saveBtn" name="saveBtn" onclick="save()">저장</button>
						<button type="button" class="btn"  id="listBtn" name="listBtn" onclick="goRlabRqprList()">목록</button>
					</div>
	   			</div>

   				<table class="table">
   					<colgroup>
   						<col style="width:15%;"/>
   						<col style="width:35%;"/>
   						<col style="width:15%;"/>
   						<col style="width:35%;"/>
   					</colgroup>
   					<tbody>
   						<tr>
   							<th align="right"><span style="color:red;">* </span>시험명</th>
   							<td colspan="3">
   								<input type="text" id="rlabNm">
   							</td>
   						</tr>
   						<tr>
   							<th align="right"><span style="color:red;">* </span>시험목적</th>
   							<td colspan="3">
   								<textarea id="rlabSbc"></textarea>
   							</td>
   						</tr>
   						<tr>
   							<th align="right"><span style="color:red;">* </span>사업부</th>
   							<td>
                                <div id="rlabDzdvCd"></div>
   							</td>
   							<th align="right"><span style="color:red;">* </span>긴급유무</th>
   							<td>
                                <div id="rlabUgyYn"></div>
   							</td>
   							<!-- 
   							<th align="right"><span style="color:red;">* </span>시료 제품군</th>
   							<td>
                                <div id="rlabProdCd"></div>
   							</td>
   							 -->
   						</tr>
   						<tr>
   							<th align="right"><span style="color:red;">* </span>시험구분</th>
   							<td>
                                <div id="rlabScnCd"></div>
   							</td>
   							<th align="right"><span style="color:red;">* </span>시험담당자</th>
   							<td>
   								<input type="text" id="rlabChrgNm">
   							</td>
   						</tr>
   						<tr>
   							<th align="right"><span style="color:red;">* </span>통보유형</th>
   							<td>
   								<div id="infmTypeCd"></div>
   							</td>
   							
   							<th align="right"><span style="color:red;">* </span>시료처리</th>
   							<td>
   								<div id="smpoTrtmCd"></div>
   							</td>
   						</tr>
   						<!-- 
   						<tr>
   							
   							<th align="right">WBS 코드</th>
   							<td>
   								<input type="text" id="wbsCd">
   							</td>
   						</tr>
   						 -->
   						<tr>
   							<th align="right">통보자</th>
   							<td colspan="3">
						        <div>
						            <div id="rlabRqprInfmView">
						            </div>
							          <!-- &nbsp;&nbsp;<span  style="color:red; font-weight:bold">주방욕실사업부문 관련 시험 의뢰시, 결과가 인테리어개발실장에게 자동통보됩니다.</span> -->
						        </div>
   							</td>
   						</tr>
   						<tr>
   							<th align="right">시험담당자코멘트</th>
   							<td colspan="3">
   								<textarea id="rlabCrgrComm"></textarea>
   							</td>
   						</tr>
   					</tbody>
   				</table>

   				<div class="titArea">
   					<h3><span style="color:red;">* </span>시료정보</h3>
   					<div class="LblockButton">
   						<button type="button" class="btn"  id="addRlabRqprSmpoBtn" name="addRlabRqprSmpoBtn" onclick="addRlabRqprSmpo()">추가</button>
   						<button type="button" class="btn"  id="deleteRlabRqprSmpoBtn" name="deleteRlabRqprSmpoBtn" onclick="deleteRlabRqprSmpo()">삭제</button>
   					</div>
   				</div>

   				<div id="rlabRqprSmpoGrid"></div>

   				<br/>

   				<table class="table" id="rlab_ta" style="table-layout:fixed;">
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
				   					<h3>첨부파일</h3>
				   					<div class="LblockButton">
				   						<button type="button" class="btn"  id="addRlabRqprAttachBtn" name="addRlabRqprAttachBtn" onclick="openAttachFileDialog(setRlabRqprAttach, rlabRqprDataSet.getNameValue(0, 'rqprAttcFileId'), 'rlabPolicy', '*', 'M', '첨부파일')">파일첨부</button>
				   					</div>
				   				</div>

				   				<div id="rlabRqprAttachGrid"></div>
   							</td>
   						</tr>
   					</tbody>
   				</table>

   			</div><!-- //sub-content -->
   		</div><!-- //contents -->
		</form>
    </body>
</html>