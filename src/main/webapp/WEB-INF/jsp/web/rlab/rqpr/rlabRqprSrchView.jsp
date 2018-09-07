<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*,
				 java.util.*,
				 devonframe.util.NullUtil,
				 devonframe.util.DateUtil"%>

<%--
/*
 *************************************************************************
 * $Id		: anlRqprSrchView.jsp
 * @desc    : 시험의뢰서 상세
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
</style>

	<script type="text/javascript">

		var callback;
		var anlRqprDataSet;
		var rsltAttcFileId;

		Rui.onReady(function() {
            /*******************
             * 변수 및 객체 선언
             *******************/
             rsltAttcFileId = '${inputDat}';
            var dm = new Rui.data.LDataSetManager();

            dm.on('load', function(e) {
            });

            dm.on('success', function(e) {
            });

            anlRqprDataSet = new Rui.data.LJsonDataSet({
                id: 'anlRqprDataSet',
                remainRemoved: true,
                lazyLoad: true,
                fields: [
                	  { id: 'rqprId' }
                	, { id: 'anlNm' }
					, { id: 'acpcNo' }
					, { id: 'rgstNm' }
					, { id: 'rqprDeptNm' }
					, { id: 'rqprDt' }
					, { id: 'acpcDt' }
					, { id: 'cmplParrDt' }
					, { id: 'cmplDt' }
					, { id: 'anlScnNm' }
					, { id: 'anlChrgNm' }
					, { id: 'anlUgyYnNm' }
					, { id: 'infmTypeNm' }
					, { id: 'smpoTrtmNm' }
					, { id: 'anlRqprInfmView'  }
					, { id: 'anlSbc'}
					, { id: 'anlRsltSbc'}
					, { id: 'rqprAttcFileId' }
					, { id: 'lastMdfyId' }
                ]
            });

            anlRqprDataSet.on('load', function(e) {
            	var anlSbc = anlRqprDataSet.getNameValue(0, 'anlSbc');
            	var idChk = anlRqprDataSet.getNameValue(0, 'lastMdfyId');

            	if(Rui.isEmpty(anlSbc) == false) {
            		if(Rui.isEmpty(idChk) == false) {
            			if(idChk != "MIG"){
		                	anlRqprDataSet.setNameValue(0, 'anlSbc', anlSbc.replaceAll('\n', '<br/>'));
            			}
            		}
            	}
            });

            bind = new Rui.data.LBind({
                groupId: 'aform',
                dataSet: anlRqprDataSet,
                bind: true,
                bindInfo: [
                    { id: 'anlNm',				ctrlId:'anlNm',				value:'html'},
                    { id: 'anlSbc',				ctrlId:'anlSbc',			value:'html'},
                    { id: 'acpcNo',				ctrlId:'acpcNo',			value:'html'},
                    { id: 'rgstNm',				ctrlId:'rgstNm',			value:'html'},
                    { id: 'rqprDeptNm',			ctrlId:'rqprDeptNm',		value:'html'},
                    { id: 'rqprDt',				ctrlId:'rqprDt',			value:'html'},
                    { id: 'acpcDt',				ctrlId:'acpcDt',			value:'html'},
                    { id: 'cmplParrDt',			ctrlId:'cmplParrDt',		value:'html'},
                    { id: 'cmplDt',				ctrlId:'cmplDt',			value:'html'},
                    { id: 'anlScnNm',			ctrlId:'anlScnNm',			value:'html'},
                    { id: 'anlChrgNm',			ctrlId:'anlChrgNm',			value:'html'},
                    { id: 'anlUgyYnNm',			ctrlId:'anlUgyYnNm',		value:'html'},
                    { id: 'infmTypeNm',			ctrlId:'infmTypeNm',		value:'html'},
                    { id: 'smpoTrtmNm',			ctrlId:'smpoTrtmNm',		value:'html'},
                    { id: 'anlRqprInfmView',	ctrlId:'anlRqprInfmView',	value:'html'},
                    { id: 'anlRsltSbc',			ctrlId:'anlRsltSbc',		value:'html'}
                ]
            });

            var anlRqprSmpoDataSet = new Rui.data.LJsonDataSet({
                id: 'anlRqprSmpoDataSet',
                remainRemoved: true,
                lazyLoad: true,
                fields: [
                	  { id: 'smpoId' }
                	, { id: 'rqprId' }
					, { id: 'smpoNm' }
					, { id: 'mkrNm' }
					, { id: 'mdlNm' }
					, { id: 'smpoQty' }
                ]
            });

            var anlRqprSmpoColumnModel = new Rui.ui.grid.LColumnModel({
                columns: [
                	  new Rui.ui.grid.LNumberColumn()
                    , { field: 'smpoNm',	label: '시료명',		sortable: false,	align:'center',	width: 200 }
                    , { field: 'mkrNm',		label: '제조사',		sortable: false,	align:'center',	width: 150 }
                    , { field: 'mdlNm',		label: '모델명',		sortable: false,	align:'center',	width: 300 }
                    , { field: 'smpoQty',	label: '수량',		sortable: false,	align:'center',	width: 50 }
                ]
            });

            var anlRqprSmpoGrid = new Rui.ui.grid.LGridPanel({
                columnModel: anlRqprSmpoColumnModel,
                dataSet: anlRqprSmpoDataSet,
                width: 700,
                height: 200,
                autoToEdit: false,
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
                	  new Rui.ui.grid.LNumberColumn()
                    , { field: 'preAcpcNo',		label: '접수번호',		sortable: false,	align:'center',	width: 80 }
                    , { field: 'preAnlNm',		label: '시험명',		sortable: false,	align:'left',	width: 300 }
                    , { field: 'preRgstNm',		label: '의뢰자',		sortable: false,	align:'center',	width: 80 }
                    , { field: 'preAnlChrgNm',	label: '시험담당자',	sortable: false,	align:'center',	width: 80 }
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
                ]
            });

            var anlRqprExprColumnModel = new Rui.ui.grid.LColumnModel({
                columns: [
                	  new Rui.ui.grid.LSelectionColumn()
                    , new Rui.ui.grid.LNumberColumn()
                    , { field: 'exprNm',	label: '실험명',		sortable: false,	align:'left',	width: 400 }
                    , { field: 'smpoQty',	label: '실험수',		sortable: false,	align:'center',	width: 70 }
                    , { field: 'exprTim',	label: '실험시간',		sortable: false,	align:'center',	width: 80 }
                    , { field: 'exprExp',	label: '수가',		sortable: false,	align:'center',	width: 100, renderer: function(val, p, record, row, col) {
                    	return Rui.util.LNumber.toMoney(val, '') + '원';
                      } }
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

            anlRqprExprGrid.render('anlRqprExprGrid');


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
                    , { field: 'filNm',		label: '파일명',		sortable: false,	align:'left',	width: 300 }
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

			downloadAttachFile = function(attcFilId, seq) {
				fileDownloadForm.action = '<c:url value='/system/attach/downloadAttachFile.do'/>';
				$('#attcFilId', fileDownloadForm).val(attcFilId);
				$('#seq', fileDownloadForm).val(seq);
				fileDownloadForm.submit();
			};

            var anlRqprRsltAttachDataSet = new Rui.data.LJsonDataSet({
                id: 'anlRqprRsltAttachDataSet',
                remainRemoved: true,
                lazyLoad: true,
                fields: [
					  { id: 'attcFilId'}
					, { id: 'seq' }
					, { id: 'filNm' }
					, { id: 'filSize' }
                ]
            });

            anlRqprRsltAttachDataSet.on('load', function(e) {
            	if( anlRqprRsltAttachDataSet.getCount() > 0  ){
           			$('#rsltAttcFileView').html('');

           			for(var i = 0; i < anlRqprRsltAttachDataSet.getCount(); i++) {
                        $('#rsltAttcFileView').append($('<a/>', {
                            href: 'javascript:downloadAttachFile("' + anlRqprRsltAttachDataSet.getNameValue(i, "attcFilId") + '", "' +  anlRqprRsltAttachDataSet.getNameValue(i, "seq") + '")',
                            text: anlRqprRsltAttachDataSet.getNameValue(i, "filNm")
                        })).append('<br/>');
                    }
           		}
            });


	    	dm.loadDataSet({
                dataSets: [anlRqprDataSet, anlRqprSmpoDataSet, anlRqprRltdDataSet, anlRqprAttachDataSet, anlRqprExprDataSet,anlRqprRsltAttachDataSet],
                url: '<c:url value="/anl/getAnlRqprDetailInfo.do"/>',
                params: {
                    rqprId: '${inputData.rqprId}'
                }
            });

        });
	</script>
    </head>
    <body>
    <form name="searchForm" id="searchForm">
		<input type="hidden" name="rqDocNm" value="${inputData.rqDocNm}"/>
		<input type="hidden" name="sbcNm" value="${inputData.sbcNm}"/>
    </form>
    <form name="fileDownloadForm" id="fileDownloadForm">
		<input type="hidden" id="attcFilId" name="attcFilId" value=""/>
		<input type="hidden" id="seq" name="seq" value=""/>
    </form>
   		<div class="contents">

   			<div class="sub-content">
				<form name="aform" id="aform" method="post">

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
   							<td><span id="anlNm"/></td>
   							<th align="right">접수번호</th>
   							<td><span id="acpcNo"/></td>
   						</tr>
   						<tr>
   							<th align="right">시험목적</th>
   							<td colspan="3"><span id="anlSbc"/></td>
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
    						<td><span id="cmplParrDt"/></td>
   							<th align="right">완료일</th>
    						<td><span id="cmplDt"/></td>
   						</tr>
   						<tr>
   							<th align="right">시험구분</th>
   							<td><span id="anlScnNm"/></td>
   							<th align="right">시험담당자</th>
   							<td><span id="anlChrgNm"/></td>
   						</tr>
   						<tr>
   							<th align="right">긴급유무</th>
   							<td><span id="anlUgyYnNm"/></td>
   							<th align="right">통보유형</th>
   							<td><span id="infmTypeNm"/></td>
   						</tr>
   						<tr>
   							<th align="right">시료처리</th>
   							<td><span id="smpoTrtmNm"/></td>
   							<th align="right">통보자</th>
   							<td><span id="anlRqprInfmView"/></td>
   						</tr>
   					</tbody>
   				</table>

   				<div class="titArea">
   					<span class="Ltotal">시료정보</span>
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
				   					<span class="Ltotal">관련시험</span>
				   				</div>

				   				<div id="anlRqprRltdGrid"></div>
   							</td>
   							<td>&nbsp;</td>
   							<td>
				   				<div class="titArea">
				   					<span class="Ltotal">시료사진/첨부파일</span>
				   				</div>

				   				<div id="anlRqprAttachGrid"></div>
   							</td>
   						</tr>
   					</tbody>
   				</table>

   				<br/>
   				<div class="titArea">
   					<span class="Ltotal">실험정보 등록</span>
   				</div>

   				<div>
   					<div id="anlRqprExprGrid"></div>
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
   							<th align="right">시험결과</th>
   							<td colspan="3"><span id="anlRsltSbc"/></td>
   						</tr>
   						<tr>
   							<th align="right">시험결과서</th>
   							<td colspan="3"><span id="rsltAttcFileView"/></td>
   						</tr>
   					</tbody>
   				</table>
				</form>

   			</div><!-- //sub-content -->
   		</div><!-- //contents -->
    </body>
</html>