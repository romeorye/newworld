<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*,
				 java.util.*,
				 devonframe.util.NullUtil,
				 devonframe.util.DateUtil"%>

<%--
/*
 *************************************************************************
 * $Id		: rlabRqprSrchView.jsp
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
		var rlabRqprDataSet;
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

            rlabRqprDataSet = new Rui.data.LJsonDataSet({
                id: 'rlabRqprDataSet',
                remainRemoved: true,
                lazyLoad: true,
                fields: [
                	  { id: 'rqprId' }
                	, { id: 'rlabNm' }
					, { id: 'acpcNo' }
					, { id: 'rgstNm' }
					, { id: 'rqprDeptNm' }
					, { id: 'rqprDt' }
					, { id: 'acpcDt' }
					, { id: 'cmplParrDt' }
					, { id: 'cmplDt' }
					, { id: 'rlabScnNm' }
					, { id: 'rlabChrgNm' }
					, { id: 'rlabUgyYnNm' }
					, { id: 'infmTypeNm' }
					, { id: 'smpoTrtmNm' }
					, { id: 'rlabRqprInfmView'  }
					, { id: 'rlabSbc'}
					, { id: 'rlabRsltSbc'}
					, { id: 'rqprAttcFileId' }
					, { id: 'lastMdfyId' }
                ]
            });

            rlabRqprDataSet.on('load', function(e) {
            	var rlabSbc = rlabRqprDataSet.getNameValue(0, 'rlabSbc');
            	var idChk = rlabRqprDataSet.getNameValue(0, 'lastMdfyId');

            	if(Rui.isEmpty(rlabSbc) == false) {
            		if(Rui.isEmpty(idChk) == false) {
            			if(idChk != "MIG"){
		                	rlabRqprDataSet.setNameValue(0, 'rlabSbc', rlabSbc.replaceAll('\n', '<br/>'));
            			}
            		}
            	}
            });

            bind = new Rui.data.LBind({
                groupId: 'aform',
                dataSet: rlabRqprDataSet,
                bind: true,
                bindInfo: [
                    { id: 'rlabNm',				ctrlId:'rlabNm',			value:'html'},
                    { id: 'rlabSbc',			ctrlId:'rlabSbc',			value:'html'},
                    { id: 'acpcNo',				ctrlId:'acpcNo',			value:'html'},
                    { id: 'rgstNm',				ctrlId:'rgstNm',			value:'html'},
                    { id: 'rqprDeptNm',			ctrlId:'rqprDeptNm',		value:'html'},
                    { id: 'rqprDt',				ctrlId:'rqprDt',			value:'html'},
                    { id: 'acpcDt',				ctrlId:'acpcDt',			value:'html'},
                    { id: 'cmplParrDt',			ctrlId:'cmplParrDt',		value:'html'},
                    { id: 'cmplDt',				ctrlId:'cmplDt',			value:'html'},
                    { id: 'rlabScnNm',			ctrlId:'rlabScnNm',			value:'html'},
                    { id: 'rlabChrgNm',			ctrlId:'rlabChrgNm',		value:'html'},
                    { id: 'rlabUgyYnNm',		ctrlId:'rlabUgyYnNm',		value:'html'},
                    { id: 'infmTypeNm',			ctrlId:'infmTypeNm',		value:'html'},
                    { id: 'smpoTrtmNm',			ctrlId:'smpoTrtmNm',		value:'html'},
                    { id: 'rlabRqprInfmView',	ctrlId:'rlabRqprInfmView',	value:'html'},
                    { id: 'rlabRsltSbc',		ctrlId:'rlabRsltSbc',		value:'html'}
                ]
            });

            var rlabRqprSmpoDataSet = new Rui.data.LJsonDataSet({
                id: 'rlabRqprSmpoDataSet',
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

            var rlabRqprSmpoColumnModel = new Rui.ui.grid.LColumnModel({
                columns: [
                	  new Rui.ui.grid.LNumberColumn()
                    , { field: 'smpoNm',	label: '시료명',		sortable: false,	align:'center',	width: 200 }
                    , { field: 'mkrNm',		label: '제조사',		sortable: false,	align:'center',	width: 150 }
                    , { field: 'mdlNm',		label: '모델명',		sortable: false,	align:'center',	width: 300 }
                    , { field: 'smpoQty',	label: '수량',		sortable: false,	align:'center',	width: 50 }
                ]
            });

            var rlabRqprSmpoGrid = new Rui.ui.grid.LGridPanel({
                columnModel: rlabRqprSmpoColumnModel,
                dataSet: rlabRqprSmpoDataSet,
                width: 700,
                height: 200,
                autoToEdit: false,
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
                	  new Rui.ui.grid.LNumberColumn()
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


            var rlabRqprExatDataSet = new Rui.data.LJsonDataSet({
                id: 'rlabRqprExatDataSet',
                remainRemoved: false,
                lazyLoad: true,
                fields: [
                	  { id: 'rqprexatId', type: 'number' }
                	, { id: 'rqprId', type: 'number' }
					, { id: 'exatNm' }
					, { id: 'smpoQty' }
					, { id: 'exatTim' }
					, { id: 'exatExp' }
                ]
            });

            var rlabRqprExatColumnModel = new Rui.ui.grid.LColumnModel({
                columns: [
                	  new Rui.ui.grid.LSelectionColumn()
                    , new Rui.ui.grid.LNumberColumn()
                    , { field: 'exatNm',	label: '실험명',		sortable: false,	align:'left',	width: 400 }
                    , { field: 'smpoQty',	label: '실험수',		sortable: false,	align:'center',	width: 70 }
                    , { field: 'exatTim',	label: '실험시간',	sortable: false,	align:'center',	width: 80 }
                    , { field: 'exatExp',	label: '수가',		sortable: false,	align:'center',	width: 100, renderer: function(val, p, record, row, col) {
                    	return Rui.util.LNumber.toMoney(val, '') + '원';
                      } }
                ]
            });

            var rlabRqprExatGrid = new Rui.ui.grid.LGridPanel({
                columnModel: rlabRqprExatColumnModel,
                dataSet: rlabRqprExatDataSet,
                width: 600,
                height: 200,
                autoToEdit: false,
                autoWidth: true
            });

            rlabRqprExatGrid.render('rlabRqprExatGrid');


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
                    , { field: 'filNm',		label: '파일명',		sortable: false,	align:'left',	width: 300 }
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

			downloadAttachFile = function(attcFilId, seq) {
				fileDownloadForm.action = '<c:url value='/system/attach/downloadAttachFile.do'/>';
				$('#attcFilId', fileDownloadForm).val(attcFilId);
				$('#seq', fileDownloadForm).val(seq);
				fileDownloadForm.submit();
			};

            var rlabRqprRsltAttachDataSet = new Rui.data.LJsonDataSet({
                id: 'rlabRqprRsltAttachDataSet',
                remainRemoved: true,
                lazyLoad: true,
                fields: [
					  { id: 'attcFilId'}
					, { id: 'seq' }
					, { id: 'filNm' }
					, { id: 'filSize' }
                ]
            });

            rlabRqprRsltAttachDataSet.on('load', function(e) {
            	if( rlabRqprRsltAttachDataSet.getCount() > 0  ){
           			$('#rsltAttcFileView').html('');

           			for(var i = 0; i < rlabRqprRsltAttachDataSet.getCount(); i++) {
                        $('#rsltAttcFileView').append($('<a/>', {
                            href: 'javascript:downloadAttachFile("' + rlabRqprRsltAttachDataSet.getNameValue(i, "attcFilId") + '", "' +  rlabRqprRsltAttachDataSet.getNameValue(i, "seq") + '")',
                            text: rlabRqprRsltAttachDataSet.getNameValue(i, "filNm")
                        })).append('<br/>');
                    }
           		}
            });


	    	dm.loadDataSet({
                dataSets: [rlabRqprDataSet,
                           rlabRqprSmpoDataSet,
                           rlabRqprRltdDataSet,
                           rlabRqprAttachDataSet,
                           rlabRqprExatDataSet,
                           rlabRqprRsltAttachDataSet],
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
   							<td><span id="rlabNm"/></td>
   							<th align="right">접수번호</th>
   							<td><span id="acpcNo"/></td>
   						</tr>
   						<tr>
   							<th align="right">시험목적</th>
   							<td colspan="3"><span id="rlabSbc"/></td>
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
   							<td><span id="rlabScnNm"/></td>
   							<th align="right">시험담당자</th>
   							<td><span id="rlabChrgNm"/></td>
   						</tr>
   						<tr>
   							<th align="right">긴급유무</th>
   							<td><span id="rlabUgyYnNm"/></td>
   							<th align="right">통보유형</th>
   							<td><span id="infmTypeNm"/></td>
   						</tr>
   						<tr>
   							<th align="right">시료처리</th>
   							<td><span id="smpoTrtmNm"/></td>
   							<th align="right">통보자</th>
   							<td><span id="rlabRqprInfmView"/></td>
   						</tr>
   					</tbody>
   				</table>

   				<div class="titArea">
   					<span class="Ltotal">시료정보</span>
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
				   					<span class="Ltotal">관련시험</span>
				   				</div>

				   				<div id="rlabRqprRltdGrid"></div>
   							</td>
   							<td>&nbsp;</td>
   							<td>
				   				<div class="titArea">
				   					<span class="Ltotal">시료사진/첨부파일</span>
				   				</div>

				   				<div id="rlabRqprAttachGrid"></div>
   							</td>
   						</tr>
   					</tbody>
   				</table>

   				<br/>
   				<div class="titArea">
   					<span class="Ltotal">실험정보 등록</span>
   				</div>

   				<div>
   					<div id="rlabRqprExatGrid"></div>
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
   							<td colspan="3"><span id="rlabRsltSbc"/></td>
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