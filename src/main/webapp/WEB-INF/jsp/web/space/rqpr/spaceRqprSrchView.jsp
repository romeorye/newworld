<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*,
				 java.util.*,
				 devonframe.util.NullUtil,
				 devonframe.util.DateUtil"%>

<%--
/*
 *************************************************************************
 * $Id		: spaceRqprSrchView.jsp
 * @desc    : 평가의뢰서 상세
 *------------------------------------------------------------------------
 * VER	DATE		AUTHOR		DESCRIPTION
 * ---	-----------	----------	-----------------------------------------
 * 1.0  2018.11.01  정현웅		최초생성
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

            spaceRqprDataSet = new Rui.data.LJsonDataSet({
                id: 'spaceRqprDataSet',
                remainRemoved: true,
                lazyLoad: true,
                fields: [
                	  { id: 'rqprId'		}	//의뢰ID
					, { id: 'spaceNm'		}	//평가명
					, { id: 'spaceScnCd'	}	//평가구분코드
					, { id: 'spaceScnNm'	}	//평가구분명
					, { id: 'spaceSbc'		}	//평가목적
					, { id: 'acpcNo'		}	//접수번호
					, { id: 'rgstNm'		}	//의뢰자
					, { id: 'rqprDeptNm'	}	//부서
					, { id: 'rqprDt'		}	//의뢰일
					, { id: 'acpcDt'		}	//접수일
					, { id: 'acpcDt'		}	//접수일
					, { id: 'spaceUgyYnNm'	}	//긴급유무코드
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
					, { id: 'rqprAttcFileId'}
					, { id: 'spaceAcpcStCd'		}
					, { id: 'cmplDt'}
					, { id: 'cmplParrDt'		}
                ]
            });

            spaceRqprDataSet.on('load', function(e) {
            	var spaceSbc = spaceRqprDataSet.getNameValue(0, 'spaceSbc');
            	var idChk = spaceRqprDataSet.getNameValue(0, 'lastMdfyId');

            	if(Rui.isEmpty(spaceSbc) == false) {
            		if(Rui.isEmpty(idChk) == false) {
            			if(idChk != "MIG"){
		                	spaceRqprDataSet.setNameValue(0, 'spaceSbc', spaceSbc.replaceAll('\n', '<br/>'));
            			}
            		}
            	}
            });

            bind = new Rui.data.LBind({
                groupId: 'aform',
                dataSet: spaceRqprDataSet,
                bind: true,
                bindInfo: [
                    { id: 'rqprId',				ctrlId: 'rqprId',			value:'html'},
					{ id: 'spaceNm',			ctrlId: 'spaceNm',			value:'html'},
                    { id: 'spaceScnCd',			ctrlId: 'spaceScnCd',		value:'html'},
                    { id: 'spaceScnNm',			ctrlId: 'spaceScnNm',		value:'html'},
                    { id: 'spaceSbc',		 	ctrlId: 'spaceSbc',		 	value:'html'},
                    { id: 'rgstNm',		 		ctrlId: 'rgstNm',		 	value:'html'},	//의뢰자
                    { id: 'acpcNo',		 		ctrlId: 'acpcNo',		 	value:'html'},	//접수번호
                    { id: 'rqprDeptNm',		 	ctrlId: 'rqprDeptNm',		value:'html'},	//부서
                    { id: 'rqprDt',		 		ctrlId: 'rqprDt',		 	value:'html'},	//의뢰일
                    { id: 'acpcDt',		 		ctrlId: 'acpcDt',		 	value:'html'},	//접수일
                    { id: 'spaceUgyYnNm',		ctrlId: 'spaceUgyYnNm',		value:'html'},
                    { id: 'infmPrsnIds',		ctrlId: 'infmPrsnIds',		value:'html'},
                    { id: 'oppbScpCd',			ctrlId: 'oppbScpCd',		value:'html'},
                    { id: 'spaceRqprWbsCd',		ctrlId: 'spaceRqprWbsCd',	value:'html'},
                    { id: 'scrtRson',			ctrlId: 'scrtRson',			value:'html'},
                    { id: 'spaceRqprInfmView',	ctrlId: 'spaceRqprInfmView',value:'html'},
                    { id: 'evSubjNm',			ctrlId: 'evSubjNm',			value:'html'},
                    { id: 'sbmpCd',				ctrlId: 'sbmpCd',			value:'html'},
                    { id: 'sbmpNm',				ctrlId: 'sbmpNm',			value:'html'},
                    { id: 'qtasDpst',			ctrlId: 'qtasDpst',			value:'html'},
                    { id: 'qnasDpst',		 	ctrlId: 'qnasDpst',		 	value:'html'},
                    { id: 'goalPfmc',		 	ctrlId: 'goalPfmc',		 	value:'html'},
                    { id: 'rsltDpst',		 	ctrlId: 'rsltDpst',		 	value:'html'},
                    { id: 'evCases',			ctrlId: 'evCases',			value:'html'},
                    { id: 'evSubjDtl',		 	ctrlId: 'evSubjDtl',		value:'html'},
                    { id: 'tCloud',		 		ctrlId: 'tCloud',		 	value:'html'},
                    { id: 'spaceAcpcStCd',		ctrlId: 'spaceAcpcStCd',	value:'html'},

                    { id: 'cmplDt',				ctrlId: 'cmplDt',		value:'html'},
                    { id: 'cmplParrDt',			ctrlId: 'cmplParrDt',	value:'html'}

                ]
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
                      { field: 'evCtgr',		label: '<span style="color:red;">* </span>평가카테고리',	sortable: false,	editable: false,	align:'center',	width: 400}
                	, { field: 'evPrvs',		label: '<span style="color:red;">* </span>평가항목',		sortable: false,	editable: false,	align:'center',	width: 400 }
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
                	  { field: 'evCtgr0',	label: 'evCtgr0',		sortable: false,	editable: false,	align:'center',	width: 100,	hidden:true }
                	, { field: 'evCtgr1',	label: 'evCtgr1',		sortable: false,	editable: false,	align:'center',	width: 100,	hidden:true }
                	, { field: 'evCtgr2',	label: 'evCtgr2',		sortable: false,	editable: false,	align:'center',	width: 100,	hidden:true }
                    , { field: 'evCtgr3',	label: 'evCtgr3',		sortable: false,	editable: false,	align:'center',	width: 100,	hidden:true }

                    , { field: 'evCtgr0Nm',	label: '사업부',			sortable: false,	editable: false,	align:'center',	width: 250 }
                	, { field: 'evCtgr1Nm',	label: '제품군',			sortable: false,	editable: false,	align:'center',	width: 250 }
                	, { field: 'evCtgr2Nm',	label: '분류',			sortable: false,	editable: false,	align:'center',	width: 250 }
                    , { field: 'evCtgr3Nm',	label: '제품',			sortable: false,	editable: false,	align:'center',	width: 250 }
                    , { field: 'evCtgr4Nm',	label: '제품명(직접입력)',sortable: false,	editable: true, 	align:'left',	width: 250 }

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
                	  { field: 'preAcpcNo',		label: '접수번호',	sortable: false,	align:'center',	width: 80 }
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


            /* 실험정보 */
            var spaceRqprExatDataSet = new Rui.data.LJsonDataSet({
                id: 'spaceRqprExatDataSet',
                remainRemoved: false,
                lazyLoad: true,
                fields: [
                	  { id: 'rqprExatId', type: 'number' }
                	, { id: 'rqprId', type: 'number' }
					, { id: 'exatNm' }
					, { id: 'exatCaseQty' }
					, { id: 'exatDct' }
					, { id: 'exatExp' }
					, { id: 'exatWay' }
                ]
            });

            /* 평가결과 실험정보 */
            var spaceRqprExatColumnModel = new Rui.ui.grid.LColumnModel({
                columns: [
                	  { field: 'exatNm',		label: '평가 실험명',		sortable: false,	align:'left',	width: 420 }
                    , { field: 'exatCaseQty',	label: '평가케이스수',	sortable: false,	align:'center',	width: 100 }
                    , { field: 'exatDct',		label: '평가일수',		sortable: false,	align:'center',	width: 80 }
                    , { field: 'exatWay',		label: '평가방법',		sortable: false,	align:'left',	width: 800 }
                ]
            });

            var spaceRqprExatGrid = new Rui.ui.grid.LGridPanel({
                columnModel: spaceRqprExatColumnModel,
                dataSet: spaceRqprExatDataSet,
                width: 600,
                height: 200,
                autoToEdit: false,
                autoWidth: true
            });

            spaceRqprExatGrid.render('spaceRqprExatGrid');


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
                    , { field: 'filNm',		label: '파일명',		sortable: false,	align:'left',	width: 300 }
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

			downloadAttachFile = function(attcFilId, seq) {
				fileDownloadForm.action = '<c:url value='/system/attach/downloadAttachFile.do'/>';
				$('#attcFilId', fileDownloadForm).val(attcFilId);
				$('#seq', fileDownloadForm).val(seq);
				fileDownloadForm.submit();
			};

            var spaceRqprRsltAttachDataSet = new Rui.data.LJsonDataSet({
                id: 'spaceRqprRsltAttachDataSet',
                remainRemoved: true,
                lazyLoad: true,
                fields: [
					  { id: 'attcFilId'}
					, { id: 'seq' }
					, { id: 'filNm' }
					, { id: 'filSize' }
                ]
            });

            spaceRqprRsltAttachDataSet.on('load', function(e) {
            	if( spaceRqprRsltAttachDataSet.getCount() > 0  ){
           			$('#rsltAttcFileView').html('');

           			for(var i = 0; i < spaceRqprRsltAttachDataSet.getCount(); i++) {
                        $('#rsltAttcFileView').append($('<a/>', {
                            href: 'javascript:downloadAttachFile("' + spaceRqprRsltAttachDataSet.getNameValue(i, "attcFilId") + '", "' +  spaceRqprRsltAttachDataSet.getNameValue(i, "seq") + '")',
                            text: spaceRqprRsltAttachDataSet.getNameValue(i, "filNm")
                        })).append('<br/>');
                    }
           		}
            });


	    	dm.loadDataSet({
	    		dataSets: [spaceRqprDataSet,
                           spaceRqprWayCrgrDataSet,
                           spaceRqprProdDataSet,
                           spaceRqprRltdDataSet,
                           spaceRqprExatDataSet,
                           spaceRqprAttachDataSet,
                           spaceRqprRsltAttachDataSet],
                url: '<c:url value="/space/getSpaceRqprDetailInfo.do"/>',
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
   							<th align="right">평가명</th>
   							<td><span id="spaceNm"/></td>
   							<th align="right">접수번호</th>
   							<td><span id="acpcNo"/></td>
   						</tr>
   						<tr>
   							<th align="right">평가목적</th>
   							<td colspan="3"><span id="spaceSbc"/></td>
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
   							<th align="right">평가구분</th>
   							<td><span id="spaceScnNm"/></td>
							<th align="right">긴급유무</th>
   							<td><span id="spaceUgyYnNm"/></td>
   						</tr>
   						<tr>
   							<th align="right">통보자</th>
   							<td colspan="3"><span id="spaceRqprInfmView"/></td>
   						</tr>



   						<tr>
   							<th align="right"><span style="color:red;">* </span>평가대상명</th>
   							<td colspan="3" class="space_tain">
   								<span type="text" id="evSubjNm"/>
   							</td>
   						</tr>
   						<tr>
   							<th align="right"><span style="color:red;">* </span>제출처</th>
   							<td colspan="3">
   								<div id="sbmpCd"></div>&nbsp;<span id="sbmpNm"/>
   							</td>
   						</tr>

   						<tr>
   							<th align="right"><span style="color:red;">* </span>목표(정량지표)</th>
   							<td class="space_tain">
   								<span id="qtasDpst">
   							</td>
   							<th align="right"><span style="color:red;">* </span>목표(정성지표)</th>
   							<td class="space_tain">
                                <span id="qnasDpst">
   							</td>
   						</tr>

   						<tr>
   							<th align="right"><span style="color:red;">* </span>목표성능</th>
   							<td class="space_tain">
                                <span id="goalPfmc">
   							</td>
   							<th align="right"><span style="color:red;">* </span>결과지표</th>
   							<td class="space_tain">
                                <span id="rsltDpst">
   							</td>
   						</tr>
   						<tr>
   							<th align="right"><span style="color:red;">* </span>평가 cases(개수)</th>
   							<td class="space_tain">
                                <span id="evCases">
   							</td>
   							<th align="right"><span style="color:red;">* </span>평가대상 상세</th>
   							<td class="space_tain">
                                <span id="evSubjDtl">
   							</td>
   						</tr>
   						<tr>
   							<th align="right"><span style="color:red;">* </span>T-Cloud Link</th>
   							<td class="rlabrqpr_tain01" colspan="3">
                                <span id="tCloud">
   							</td>
   						</tr>
   					</tbody>
   				</table>

   				<div class="titArea">
   					<span class="Ltotal">평가방법 / 담당자</span>
   				</div>

   				<div id="spaceRqprWayCrgrGrid"></div>

   				<br/>


   				<div class="titArea">
   					<span class="Ltotal">제품군</span>
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
				   					<span class="Ltotal">관련평가</span>
				   				</div>

				   				<div id="spaceRqprRltdGrid"></div>
   							</td>
   							<td>&nbsp;</td>
   							<td>
				   				<div class="titArea">
				   					<span class="Ltotal">시료사진/첨부파일</span>
				   				</div>

				   				<div id="spaceRqprAttachGrid"></div>
   							</td>
   						</tr>
   					</tbody>
   				</table>





   				<br/>
   				<div class="titArea">
   					<span class="Ltotal">실험정보 등록</span>
   				</div>

   				<div>
   					<div id="spaceRqprExatGrid"></div>
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
   							<th align="right">평가결과</th>
   							<td colspan="3"><span id="spaceRsltSbc"/></td>
   						</tr>
   						<tr>
   							<th align="right">평가결과서</th>
   							<td colspan="3"><span id="rsltAttcFileView"/></td>
   						</tr>
   					</tbody>
   				</table>
				</form>

   			</div><!-- //sub-content -->
   		</div><!-- //contents -->
    </body>
</html>