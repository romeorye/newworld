<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*,
				 java.util.*,
				 devonframe.util.NullUtil,
				 devonframe.util.DateUtil"%>

<%--
/*
 *************************************************************************
 * $Id		: anlRqprRgst.jsp
 * @desc    : 분석의뢰서 등록
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

<style>
 .bgcolor-gray {background-color: #999999}
 .bgcolor-white {background-color: #FFFFFF}
 .search-toggleBtn {display:none;}
</style>

	<script type="text/javascript">

		var callback;
		var anlRqprDataSet;

		Rui.onReady(function() {
            /*******************
             * 변수 및 객체 선언
             *******************/

            var dm = new Rui.data.LDataSetManager();

            dm.on('load', function(e) {
            });

            dm.on('success', function(e) {
                var data = anlRqprSmpoDataSet.getReadData(e);

                alert(data.records[0].resultMsg);

                if(data.records[0].resultYn == 'Y') {
                	goAnlRqprList();
                }
            });

            anlScnCdDataSet = new Rui.data.LJsonDataSet({
                id: 'anlScnCdDataSet',
                remainRemoved: true,
                lazyLoad: true,
                fields: [
                	  { id: 'COM_DTL_CD' }
                	, { id: 'COM_DTL_NM' }
                ]
            });

            anlScnCdDataSet.load({
                url: '<c:url value="/common/code/retrieveCodeListForCache.do"/>',
                params :{
                	comCd : 'ANL_SCN_CD'
                }
            });

        <c:if test="${fn:indexOf(inputData._roleId, 'WORK_IRI_T06') == -1}">
	        anlScnCdDataSet.on('load', function(e) {
	        	anlScnCdDataSet.removeAt(anlScnCdDataSet.findRow('COM_DTL_CD', 'O'));
	        });
        </c:if>

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
                width: 980
            });

            var anlChrgNm = new Rui.ui.form.LTextBox({
            	applyTo: 'anlChrgNm',
                placeholder: '분석담당자를 입력해주세요.',
                defaultValue: '',
                emptyValue: '',
                editable: false,
                width: 160
            });

            var anlScnCd = new Rui.ui.form.LCombo({
                applyTo: 'anlScnCd',
                name: 'anlScnCd',
                emptyText: '선택',
                defaultValue: '',
                emptyValue: '',
                width: 110,
                dataSet: anlScnCdDataSet,
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

            anlRqprInfmView = new Rui.ui.form.LPopupTextBox({
                applyTo: 'anlRqprInfmView',
                width: 600,
                editable: false,
                placeholder: '통보자를 입력해주세요.',
                emptyValue: '',
                enterToPopup: true
            });

            anlRqprInfmView.on('popup', function(e){
            	openUserSearchDialog(setAnlRqprInfm, 10, anlRqprDataSet.getNameValue(0, 'infmPrsnIds'), 'anl');
            });

            var anlSbc = new Rui.ui.form.LTextArea({
                applyTo: 'anlSbc',
                placeholder: '분석배경과 목적, 결과 활용방안을 자세히 기재하여 주시기 바랍니다.',
                emptyValue: '',
                width: 980,
                height: 75
            });

            var vm = new Rui.validate.LValidatorManager({
                validators:[
                { id: 'anlNm',				validExp: '분석명:true:maxByteLength=100' },
                { id: 'anlSbc',				validExp: '분석목적:true' },
                { id: 'anlScnCd',			validExp: '분석구분:true' },
                { id: 'anlUgyYn',			validExp: '긴급유무:true' },
                { id: 'infmTypeCd',			validExp: '통보유형:true' },
                { id: 'anlChrgId',			validExp: '분석담당자:true' },
                { id: 'smpoTrtmCd',			validExp: '시료처리:true' },
//                 { id: 'anlRqprInfmView',	validExp: '통보자:true' },
                { id: 'smpoNm',				validExp: '시료명:true:maxByteLength=100' },
                { id: 'mkrNm',				validExp: '제조사:true:maxByteLength=100' },
                { id: 'mdlNm',				validExp: '모델명:true:maxByteLength=100' },
                { id: 'smpoQty',			validExp: '수량:true:number' }
                ]
            });

            anlRqprDataSet = new Rui.data.LJsonDataSet({
                id: 'anlRqprDataSet',
                remainRemoved: true,
                lazyLoad: true,
                fields: [
                	  { id: 'anlNm' }
  					, { id: 'anlSbc' }
                	, { id: 'anlScnCd' }
					, { id: 'anlUgyYn' }
					, { id: 'infmTypeCd' }
					, { id: 'anlChrgId' }
					, { id: 'anlChrgNm' }
					, { id: 'smpoTrtmCd' }
					, { id: 'infmPrsnIds' }
					, { id: 'anlRqprInfmView' }
					, { id: 'rqprAttcFileId', defaultValue: '' }
                ]
            });

            anlRqprDataSet.on('load', function(e) {
            	anlRqprDataSet.setNameValue(0, 'rqprAttcFileId', '');
            	anlRqprDataSet.setNameValue(0, 'infmPrsnIds', '');
            	anlRqprDataSet.setNameValue(0, 'anlRqprInfmView', '');
            });

            bind = new Rui.data.LBind({
                groupId: 'aform',
                dataSet: anlRqprDataSet,
                bind: true,
                bindInfo: [
                    { id: 'anlNm',				ctrlId:'anlNm',				value:'value'},
                    { id: 'anlSbc',				ctrlId:'anlSbc',			value:'value'},
                    { id: 'anlScnCd',			ctrlId:'anlScnCd',			value:'value'},
                    { id: 'anlUgyYn',			ctrlId:'anlUgyYn',			value:'value'},
                    { id: 'infmTypeCd',			ctrlId:'infmTypeCd',		value:'value'},
                    { id: 'anlChrgId',			ctrlId:'anlChrgId',			value:'value'},
                    { id: 'anlChrgNm',			ctrlId:'anlChrgNm',			value:'value'},
                    { id: 'smpoTrtmCd',			ctrlId:'smpoTrtmCd',		value:'value'},
                    { id: 'anlRqprInfmView',	ctrlId:'anlRqprInfmView',	value:'value'}
                ]
            });

            anlRqprDataSet.newRecord();

            var anlRqprSmpoDataSet = new Rui.data.LJsonDataSet({
                id: 'anlRqprSmpoDataSet',
                remainRemoved: false,
                lazyLoad: true,
                fields: [
                	  { id: 'smpoId', defaultValue: '' }
                	, { id: 'rqprId', defaultValue: '' }
					, { id: 'smpoNm' }
					, { id: 'mkrNm' }
					, { id: 'mdlNm' }
					, { id: 'smpoQty', type: 'number', defaultValue : 1  }
                ]
            });

            anlRqprSmpoDataSet.on('canRowPosChange', function(e){
            	if (vm.validateDataSet(anlRqprSmpoDataSet, anlRqprSmpoDataSet.getRow()) == false) {
                    alert(Rui.getMessageManager().get('$.base.msg052') + '\n' + vm.getMessageList().join('\n'));
                    return false;
                }
            });

            var anlRqprSmpoColumnModel = new Rui.ui.grid.LColumnModel({
                columns: [
                	  new Rui.ui.grid.LSelectionColumn()
                    , new Rui.ui.grid.LNumberColumn()
                    , { field: 'smpoNm',	label: '<span style="color:red;">* </span>시료명',		sortable: false,	editable: true, editor: textBox,	align:'center',	width: 400 }
                    , { field: 'mkrNm',		label: '<span style="color:red;">* </span>제조사',		sortable: false,	editable: true, editor: textBox,	align:'center',	width: 350 }
                    , { field: 'mdlNm',		label: '<span style="color:red;">* </span>모델명',		sortable: false,	editable: true, editor: textBox,	align:'center',	width: 300 }
                    //, { field: 'smpoQty',	label: '<span style="color:red;">* </span>수량',		sortable: false,	editable: true, editor: numberBox,	align:'center',	width: 50 }
                ]
            });

            var anlRqprSmpoGrid = new Rui.ui.grid.LGridPanel({
                columnModel: anlRqprSmpoColumnModel,
                dataSet: anlRqprSmpoDataSet,
                width: 700,
                height: 200,
                autoToEdit: true,
                autoWidth: true
            });

            anlRqprSmpoGrid.render('anlRqprSmpoGrid');

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

            var anlRqprRltdDataSet = new Rui.data.LJsonDataSet({
                id: 'anlRqprRltdDataSet',
                remainRemoved: true,
                lazyLoad: true,
                fields: [
					  { id: 'rltdId', defaultValue: '' }
					, { id: 'rqprId', defaultValue: '' }
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
                    , new Rui.ui.grid.LNumberColumn()
                    , { field: 'preAcpcNo',		label: '접수번호',		sortable: false,	align:'center',	width: 80 }
                    , { field: 'preAnlNm',		label: '분석명',		sortable: false,	align:'left',	width: 300 }
                    , { field: 'preRgstNm',		label: '의뢰자',		sortable: false,	align:'center',	width: 80 }
                    , { field: 'preAnlChrgNm',	label: '분석담당자',	sortable: false,	align:'center',	width: 80 }
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

            /* 관련분석 삭제 */
            deleteAnlRqprRltd = function() {
                if(anlRqprRltdDataSet.getMarkedCount() > 0) {
                	anlRqprRltdDataSet.removeMarkedRows();
                } else {
                	alert('삭제 대상을 선택해주세요.');
                }
            };

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
                    , { field: 'filNm',		label: '파일명',		sortable: false,	align:'left',	width: 510 }
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

    	    setAnlRqprInfm = function(userList) {
    	    	var idList = [];
    	    	var nameList = [];

    	    	for(var i=0, size=userList.length; i<size; i++) {
    	    		idList.push(userList[i].saUser);
    	    		nameList.push(userList[i].saName);
    	    	}

    	    	anlRqprInfmView.setValue(nameList.join(', '));
    	    	anlRqprDataSet.setNameValue(0, 'infmPrsnIds', idList);
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
    	 	// 관련분석 조회 팝업 끝

    	    setAnlRqprRltd = function(anlRqpr) {
				if(anlRqprRltdDataSet.findRow('preRqprId', anlRqpr.rqprId) > -1) {
					alert('이미 존재합니다.');
					return ;
				}

				var row = anlRqprRltdDataSet.newRecord();
				var record = anlRqprRltdDataSet.getAt(row);

				record.set('preRqprId', anlRqpr.rqprId);
				record.set('preAnlNm', anlRqpr.anlNm);
				record.set('preAcpcNo', anlRqpr.acpcNo);
				record.set('preRgstId', anlRqpr.rgstId);
				record.set('preRgstNm', anlRqpr.rgstNm);
				record.set('preAnlChrgNm', anlRqpr.anlChrgNm);
    	    };

    	    getAnlRqprInfo = function(anlRqpr) {
            	resetAForm();

    	    	dm.loadDataSet({
                    dataSets: [anlRqprDataSet, anlRqprSmpoDataSet],
                    url: '<c:url value="/anl/getAnlRqprInfo.do"/>',
                    params: {
                        rqprId: anlRqpr.rqprId
                    }
                });
    	    };

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

            /* 초기화 */
            resetAForm = function() {
            	anlRqprDataSet.clearData();
            	anlRqprSmpoDataSet.clearData();
            	anlRqprRltdDataSet.clearData();
            	anlRqprAttachDataSet.clearData();

            	anlRqprDataSet.newRecord();
            };

            /* 저장 */
            save = function() {
                if (vm.validateDataSet(anlRqprDataSet) == false) {
                    alert(Rui.getMessageManager().get('$.base.msg052') + '\n' + vm.getMessageList().join('\n'));
                    return false;
                }

                if (anlRqprSmpoDataSet.getCount() == 0) {
                    alert('시료정보를 입력해주세요.');
                    return false;
                } else if (vm.validateDataSet(anlRqprSmpoDataSet) == false) {
                    alert(Rui.getMessageManager().get('$.base.msg052') + '\n' + vm.getMessageList().join('\n'));
                    return false;
                }

//                 if (anlRqprAttachDataSet.getCount() == 0) {
//                 	alert('시료사진/첨부파일을 첨부해주세요.');
//                 	return false;
//                 }

                if(confirm('저장 하시겠습니까?')) {
                    dm.updateDataSet({
                        dataSets:[anlRqprDataSet, anlRqprSmpoDataSet, anlRqprRltdDataSet],
                        url:'<c:url value="/anl/regstAnlRqpr.do"/>',
                        modifiedOnly: false
                    });
                }
            };

    	    goAnlRqprList = function() {
    	    	$('#searchForm > input[name=anlNm]').val(encodeURIComponent($('#searchForm > input[name=anlNm]').val()));
    	    	$('#searchForm > input[name=rgstNm]').val(encodeURIComponent($('#searchForm > input[name=rgstNm]').val()));
    	    	$('#searchForm > input[name=anlChrgNm]').val(encodeURIComponent($('#searchForm > input[name=anlChrgNm]').val()));

    	    	nwinsActSubmit(searchForm, "<c:url value="/anl/anlRqprList.do"/>");
    	    };
        });
	</script>
    </head>
    <body>
    <form name="searchForm" id="searchForm">
		<input type="hidden" name="anlNm" value="${inputData.anlNm}"/>
		<input type="hidden" name="fromRqprDt" value="${inputData.fromRqprDt}"/>
		<input type="hidden" name="toRqprDt" value="${inputData.toRqprDt}"/>
		<input type="hidden" name="rgstNm" value="${inputData.rgstNm}"/>
		<input type="hidden" name="anlChrgNm" value="${inputData.anlChrgNm}"/>
		<input type="hidden" name="acpcNo" value="${inputData.acpcNo}"/>
		<input type="hidden" name="acpcStCd" value="${inputData.acpcStCd}"/>
    </form>
    <form name="fileDownloadForm" id="fileDownloadForm">
		<input type="hidden" id="attcFilId" name="attcFilId" value=""/>
		<input type="hidden" id="seq" name="seq" value=""/>
    </form>
	<form name="aform" id="aform" method="post">
		<input type="hidden" id="anlChrgId" name="anlChrgId" value=""/>
		
   		 <div class="contents">
		    <div class="titleArea">
		    	<a class="leftCon" href="#">
			        <img src="/iris/resource/web/images/img_uxp/ico_leftCon.png" alt="Left Navigation Control">
			        <span class="hidden">Toggle 버튼</span>
				</a>
		        <h2>분석의뢰서 등록</h2>
		    </div>

   			<div class="sub-content">
	   			<div class="titArea mt0">
					<div class="LblockButton">
						<button type="button" class="btn"  id="resetBtn" name="resetBtn" onclick="resetAForm()">초기화</button>
						<button type="button" class="btn"  id="loadAnlRqprBtn" name="loadAnlRqprBtn" onclick="openAnlRqprSearchDialog(getAnlRqprInfo)">불러오기</button>
						<button type="button" class="btn"  id="saveBtn" name="saveBtn" onclick="save()">저장</button>
						<button type="button" class="btn"  id="listBtn" name="listBtn" onclick="goAnlRqprList()">목록</button>
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
   							<th align="right"><span style="color:red;">* </span>분석명</th>
   							<td colspan="3" class="tain_formsize">
   								<input type="text" id="anlNm">
   							</td>
   						</tr>
   						<tr>
   							<th align="right"><span style="color:red;">* </span>분석목적</th>
   							<td colspan="3" class="tain_formsize">
   								<textarea id="anlSbc"></textarea>
   							</td>
   						</tr>
   						<tr>
   							<th align="right"><span style="color:red;">* </span>분석구분</th>
   							<td>
                                <div id="anlScnCd"></div>
   							</td>
   							<th align="right"><span style="color:red;">* </span>긴급유무</th>
   							<td>
                                <div id="anlUgyYn"></div>
   							</td>
   						</tr>
   						<tr>
   							<th align="right"><span style="color:red;">* </span>통보유형</th>
   							<td>
   								<div id="infmTypeCd"></div>
   							</td>
   							<th align="right"><span style="color:red;">* </span>분석담당자</th>
   							<td>
   								<input type="text" id="anlChrgNm">
                                <a href="javascript:openAnlChrgListDialog(setAnlChrgInfo);" class="icoBtn">검색</a>
   							</td>
   						</tr>
   						<tr>
   							<th align="right"><span style="color:red;">* </span>시료처리</th>
   							<td>
   								<div id="smpoTrtmCd"></div>
   							</td>
   							<th align="right"></th>
   							<td></td>
   						</tr>
   						<tr>
   							<th align="right">통보자</th>
   							<td colspan="3">
						        <div class="LblockMarkupCode">
						            <div id="anlRqprInfmView"></div>
						        </div>
   							</td>
   						</tr>
   					</tbody>
   				</table>

   				<div class="titArea">
   					<h3><span style="color:red;">* </span>시료정보</h3>
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

   			</div><!-- //sub-content -->
   		</div><!-- //contents -->
		</form>
    </body>
</html>