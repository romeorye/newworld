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

                if(data.records[0].resultYn == 'Y') {
                	goSpaceRqprList();
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

        /* <c:if test="${fn:indexOf(inputData._roleId, 'WORK_IRI_T06') == -1}">
	        spaceScnCdDataSet.on('load', function(e) {
	        	spaceScnCdDataSet.removeAt(spaceScnCdDataSet.findRow('COM_DTL_CD', 'O'));
	        });
        </c:if> */



			/* 평가명 */
            var spaceNm = new Rui.ui.form.LTextBox({
            	applyTo: 'spaceNm',
                placeholder: '평가명을 입력해주세요.',
                defaultValue: '',
                emptyValue: '',
                width: 980
            });


			/*평가목적*/
            var spaceSbc = new Rui.ui.form.LTextArea({
                applyTo: 'spaceSbc',
                placeholder: '평가배경과 목적, 결과 활용방안을 자세히 기재하여 주시기 바랍니다.',
                emptyValue: '',
                width: 980,
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
                width: 110,
                url: '<c:url value="/common/code/retrieveCodeListForCache.do?comCd=OPPB_SCP_CD"/>',
                displayField: 'COM_DTL_NM',
                valueField: 'COM_DTL_CD'
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


            /* 필수항목 체크 */
            var vm = new Rui.validate.LValidatorManager({
                validators:[
                { id: 'spaceNm',			validExp: '평가명:true:maxByteLength=100' },
                { id: 'spaceSbc',			validExp: '평가목적:true' },
                { id: 'spaceScnCd',			validExp: '평가구분:true' },
                { id: 'spaceUgyYn',			validExp: '긴급유무:true' },
                { id: 'spaceRqprInfmView',	validExp: '통보자:true' },
                { id: 'smpoNm',				validExp: '시료명:true:maxByteLength=100' },
                { id: 'mkrNm',				validExp: '제조사:true:maxByteLength=100' },
                { id: 'mdlNm',				validExp: '모델명:true:maxByteLength=100' },
                { id: 'smpoQty',			validExp: '수량:true:number' }
                ]
            });

            spaceRqprDataSet = new Rui.data.LJsonDataSet({
                id: 'spaceRqprDataSet',
                remainRemoved: true,
                lazyLoad: true,
                fields: [
                	  { id: 'spaceNm' }
  					, { id: 'spaceSbc' }
                	, { id: 'spaceScnCd' }
					, { id: 'spaceUgyYn' }
					, { id: 'infmPrsnIds' } //통보자 아이디
					, { id: 'spaceRqprInfmView' } //통보자 명
					, { id: 'rqprAttcFileId', defaultValue: '' }
					, { id: 'spaceRqprWbsCd' }
					, { id: 'oppbScpCd' }
                ]
            });

            spaceRqprDataSet.on('load', function(e) {
            	spaceRqprDataSet.setNameValue(0, 'rqprAttcFileId', '');
            	spaceRqprDataSet.setNameValue(0, 'infmPrsnIds', '');
            	spaceRqprDataSet.setNameValue(0, 'spaceRqprInfmView', '');
            });

            bind = new Rui.data.LBind({
                groupId: 'aform',
                dataSet: spaceRqprDataSet,
                bind: true,
                bindInfo: [
                    { id: 'spaceNm',			ctrlId:'spaceNm',			value:'value'},
                    { id: 'spaceSbc',			ctrlId:'spaceSbc',			value:'value'},
                    { id: 'spaceScnCd',			ctrlId:'spaceScnCd',		value:'value'},
                    { id: 'spaceUgyYn',			ctrlId:'spaceUgyYn',		value:'value'},
                    { id: 'infmPrsnIds',		ctrlId:'infmPrsnIds',		value:'value'},
                    { id: 'spaceRqprInfmView',	ctrlId:'spaceRqprInfmView',	value:'value'},
                    { id: 'spaceRqprWbsCd',		ctrlId:'spaceRqprWbsCd',	value:'value'},
                    { id: 'oppbScpCd',			ctrlId:'oppbScpCd',			value:'value'}
                ]
            });
            spaceRqprDataSet.newRecord();


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
		        title: '평가담당자',
		        width: 600,
		        height: 500,
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
    	        width: 750,
    	        height: 470,
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

    	 	// 관련분석 세팅 //
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
    	    // 관련분석 세팅 끝 //

    	    // 불러오기 //
    	    getSpaceRqprInfo = function(spaceRqpr) {
            	resetAForm();

    	    	dm.loadDataSet({
                    dataSets: [spaceRqprDataSet, spaceRqprWayCrgrDataSet],
                    url: '<c:url value="/space/getSpaceRqprInfo.do"/>',
                    params: {
                        rqprId: spaceRqpr.rqprId
                    }
                });
    	    };

            /* 초기화 */
            resetAForm = function() {
            	spaceRqprDataSet.clearData();
            	spaceRqprWayCrgrDataSet.clearData();
            	spaceRqprRltdDataSet.clearData();
            	spaceRqprAttachDataSet.clearData();

            	spaceRqprDataSet.newRecord();
            };

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

//                 if (spaceRqprAttachDataSet.getCount() == 0) {
//                 	alert('시료사진/첨부파일을 첨부해주세요.');
//                 	return false;
//                 }

                if(confirm('저장 하시겠습니까?')) {
                    dm.updateDataSet({
                        dataSets:[spaceRqprDataSet, spaceRqprWayCrgrDataSet, spaceRqprRltdDataSet],
                        url:'<c:url value="/space/regstSpaceRqpr.do"/>',
                        modifiedOnly: false
                    });
                }
            };

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
		<input type="hidden" name="acpcStCd" value="${inputData.acpcStCd}"/>
    </form>
    <form name="fileDownloadForm" id="fileDownloadForm">
		<input type="hidden" id="attcFilId" name="attcFilId" value=""/>
		<input type="hidden" id="seq" name="seq" value=""/>
    </form>
	<form name="aform" id="aform" method="post">
		<input type="hidden" id="spaceChrgId" name="spaceChrgId" value=""/>
   		<div class="contents">

   			<div class="sub-content">
	   			<div class="titArea">
		   			<span class="titleArea" style="display:inline">
		   				<h2>평가의뢰서 등록</h2>
		   			</span>
					<div class="LblockButton">
						<button type="button" class="btn"  id="resetBtn" name="resetBtn" onclick="resetAForm()">초기화</button>
						<button type="button" class="btn"  id="loadSpaceRqprBtn" name="loadSpaceRqprBtn" onclick="openSpaceRqprSearchDialog(getSpaceRqprInfo)">불러오기</button>
						<button type="button" class="btn"  id="saveBtn" name="saveBtn" onclick="save()">저장</button>
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
   							<td colspan="3">
   								<input type="text" id="spaceNm">
   							</td>
   						</tr>
   						<tr>
   							<th align="right"><span style="color:red;">* </span>평가목적</th>
   							<td colspan="3">
   								<textarea id="spaceSbc"></textarea>
   							</td>
   						</tr>
   						<tr>
   							<th align="right"><span style="color:red;">* </span>평가구분</th>
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
   							<td>
                                <div id="oppbScpCd"></div>
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
   					</tbody>
   				</table>

   				<div class="titArea">
   					<h3><span style="color:red;">* </span>평가방법</h3>
   					<div class="LblockButton">
   						<button type="button" class="btn"  id="penSpaceChrgListDialogBtn" name="penSpaceChrgListDialogBtn" onclick="openSpaceChrgListDialog(setSpaceChrgInfo);">추가</button>
   						<button type="button" class="btn"  id="deleteSpaceRqprSmpoBtn" name="deleteSpaceRqprSmpoBtn" onclick="deleteSpaceRqprSmpo()">삭제</button>
   					</div>
   				</div>

   				<div id="spaceRqprWayCrgrGrid"></div>

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
				   					<h3>시료사진/첨부파일</h3>
				   					<div class="LblockButton">
				   						<button type="button" class="btn"  id="addSpaceRqprAttachBtn" name="addSpaceRqprAttachBtn" onclick="openAttachFileDialog(setSpaceRqprAttach, spaceRqprDataSet.getNameValue(0, 'rqprAttcFileId'), 'spacePolicy', '*', 'M', '시료사진/첨부파일')">파일첨부</button>
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