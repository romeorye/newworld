<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*,
				 java.util.*,
				 devonframe.util.NullUtil,
				 devonframe.util.DateUtil"%>

<%--
/*
 *************************************************************************
 * $Id		: wbsCdSearchPopup.jsp
 * @desc    : WBS코드 조회 공통 팝업
 *------------------------------------------------------------------------
 * VER	DATE		AUTHOR		DESCRIPTION
 * ---	-----------	----------	-----------------------------------------
 * 1.0  2018.08.09  정현웅		최초생성
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
<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/grid/LGridView.js"></script>
<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/grid/LGridPanelExt.js"></script>
<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/grid/LTotalSummary.js"></script>
<link rel="stylesheet" type="text/css" href="<%=ruiPathPlugins%>/ui/grid/LTotalSummary.css"/>

<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/grid/LGridStatusBar.js"></script>
<link rel="stylesheet" type="text/css" href="<%=ruiPathPlugins%>/ui/grid/LGridStatusBar.css"/>

<style>
 .bgcolor-gray {background-color: #999999}
 .bgcolor-white {background-color: #FFFFFF}
</style>

	<script type="text/javascript">
        
		Rui.onReady(function() {
            
			if("<c:out value='${inputData._roleId}'/>".indexOf('WORK_IRI_T01') > -1) {
				roleCheck = "ADM";
			}else if("<c:out value='${inputData._roleId}'/>".indexOf('WORK_IRI_T03') > -1) {
				roleCheck = "ADM";
			}else if("<c:out value='${inputData._roleId}'/>".indexOf('WORK_IRI_T15') > -1) {
				roleCheck = "ADM";
			}else if("<c:out value='${inputData._roleId}'/>".indexOf('WORK_IRI_T16') > -1) {
				roleCheck = "ADM";
			}
			
			/** dateBox **/
			var fromDate = new Rui.ui.form.LDateBox({
				applyTo: 'fromDate',
				mask: '9999-99-99',
				displayValue: '%Y-%m-%d',
				//defaultValue: new Date(),
//				defaultValue : new Date().add('Y', parseInt(-1, 10)),		// default -1년
				width: 100,
				dateType: 'string'
			});

			fromDate.on('blur', function(){
				if( nwinsReplaceAll(fromDate.getValue(),"-","") != "" && ! Rui.util.LDate.isDate( Rui.util.LString.toDate(nwinsReplaceAll(fromDate.getValue(),"-","")) ) )  {
					alert('날자형식이 올바르지 않습니다.!!');
					fromDate.setValue(new Date());
				}
			});
			
			var toDate = new Rui.ui.form.LDateBox({
				applyTo: 'toDate',
				mask: '9999-99-99',
				displayValue: '%Y-%m-%d',
//				defaultValue: new Date(),
				width: 100,
				dateType: 'string'
			});

			toDate.on('blur', function(){
				if( nwinsReplaceAll(toDate.getValue(),"-","") != "" && ! Rui.util.LDate.isDate( Rui.util.LString.toDate(nwinsReplaceAll(toDate.getValue(),"-","")) ) )  {
					alert('날자형식이 올바르지 않습니다.!!');
					toDate.setValue(new Date());
				}
			});

			var ltWbsCd = new Rui.ui.form.LTextBox({
		    	applyTo: 'wbsCd',
		    	width : 200,
//		    	inputType: Rui.util.LString.PATTERN_TYPE_STRING,
//		    	imeMode: 'disabled' ,
		    	defaultValue: '',
		    	emptyValue: '',
		    	attrs: {
		    			maxLength: 6
		    			}
		    });
			
			var ltSaName = new Rui.ui.form.LTextBox({
		    	applyTo: 'saName',
		    	width : 200,
		    	defaultValue: '',
		    	emptyValue: '',
		    	attrs: {
		    			maxLength: 10
		    			}
		    });
			ltSaName.on('blur', function(e) {
				ltSaName.setValue(ltSaName.getValue().trim());
		    });
		    
		    var ltPrjNm = new Rui.ui.form.LTextBox({
		    	applyTo: 'prjNm',
		    	width : 200,
		    	defaultValue: '',
		    	emptyValue: '',
		    	attrs: {
		    			maxLength: 33
		    			}
		    });
		    ltPrjNm.on('blur', function(e) {
		    	ltPrjNm.setValue((ltPrjNm.getValue()).trim());
		    });
		 
		    var deptName = new Rui.ui.form.LTextBox({
		    	applyTo: 'deptName',
		    	width : 200,
		    	defaultValue: '',
		    	emptyValue: ''
		    });
		    deptName.on('blur', function(e) {
		    	deptName.setValue(deptName.getValue().trim());
		    });
		    
		    
			/** dataSet **/
			wbsCdDataset = new Rui.data.LJsonDataSet({
			    id: 'wbsCdDataset',
			    remainRemoved: true,
			    lazyLoad: true,
			    //defaultFailureHandler:false,
			    fields: [
			    	  { id: 'wbsCd' }
					, { id: 'deptName' }
					, { id: 'saSabunName'}
					, { id: 'tssNm'}
					, { id: 'tssStrtDd'}
					, { id: 'tssFnhDd'}
				]
			});

			/** columnModel **/
			var columnModel = new Rui.ui.grid.LColumnModel({
				columns: [
					  { field: 'wbsCd'        , label: 'WBS CODE',			sortable: false,	align:'center', width: 90 }
					, { field: 'tssNm'        , label: '프로젝트명',			sortable: false,	align:'left', width: 350 }
					, { field: 'saSabunName'  , label: 'PL 명',  			sortable: false,	align:'center', width: 90 }
					, { field: 'deptName' 	  , label: '조직',				sortable: false,	align:'left', width: 220 }
					, { id : '프로젝트기간'},
					, { field: 'tssStrtDd'    , groupId: '프로젝트기간', label: '시작일',      sortable: false, align:'center', width: 100 }
					, { field: 'tssFnhDd'     , groupId: '프로젝트기간', label: '종료일',      sortable: false, align:'center', width: 100 }
			   ]
			});
			
			

			/** default grid **/
			defaultGrid = new Rui.ui.grid.LGridPanel({
			    columnModel: columnModel,
			    dataSet: wbsCdDataset,
			    width: 600,
			    height: 530,
			    autoToEdit: false,
			    autoWidth: true
			});
			defaultGrid.render('defaultGrid');
			
			/* 더블클릭 이벤트 */
            defaultGrid.on('cellDblClick', function(e) {
            	parent._callback(wbsCdDataset.getAt(e.row).data);
            	parent._wbsCdSearchDialog.submit(true);
            });
            

			/**
			총 건수 표시
			**/
			wbsCdDataset.on('load', function(e){
				document.getElementById("cnt_text").innerHTML = '총: '+ wbsCdDataset.getCount();
			});
			
			// 조회
			fnSearch = function() {
			
				wbsCdDataset.load({
			       /* url: '<c:url value="/prj/rsst/mst/retrievePrjRsstMstSearchInfoList.do"/>' , */
			       url: '<c:url value="/system/etc/getWbsCdList.do"/>' ,
			       params :{
					    fromDate : fromDate.getValue(),
					    toDate   : toDate.getValue(),
					    wbsCd    : document.aform.wbsCd.value,
					    roleCheck    : roleCheck,
					    prjNm    : encodeURIComponent(document.aform.prjNm.value),
					    saName   : encodeURIComponent(document.aform.saName.value),
					    uperdeptName   : encodeURIComponent(document.aform.deptName.value)
			          }
			      });
			}

		    /** dataSet Manager : 결과값 처리 **/
			dm = new Rui.data.LDataSetManager({defaultFailureHandler: false});
		    dm.on('success', function(e) {
		    });
		    dm.on('failure', function(e) {
		   		ruiSessionFail(e);
			});

			// 화면로드시 조회
			fnSearch();

			if("<c:out value='${inputData._roleId}'/>".indexOf('WORK_IRI_T15') > -1) {
				$('#butRgst').hide();
			}else if("<c:out value='${inputData._roleId}'/>".indexOf('WORK_IRI_T16') > -1) {
				$('#butRgst').hide();
			}
        });

	</script>
    </head>
    <body onkeypress="if(event.keyCode==13) {fnSearch();}">
	<form name="aform" id="aform" method="post" onSubmit="return false;">
		
   		<div class="LblockMainBody">
   			
   			<div class="sub-content" style="padding:0 0 0 2px;">

				<form name="aform" id="aform" method="post">
				<input type="hidden" name="_GRANT" value='${inputData._GRANT}' />
				<input type="hidden" name="pageMode" value='' />
				<input type="hidden" name="prjCd" value='' />

   				<div class="search mb5">
					<div class="search-content">
						<table>
		   					<colgroup>
		   						<col style="width:100px" />
								<col style="" />
								<col style="width:100px" />
								<col style="" />
								<col style="" />
		   					</colgroup>
		   					<tbody>
		   					    <tr>
		   							<th align="right">WBS 코드</th>
		   							<td>
		   								<span>
											<input type="text" id="wbsCd" name="wbsCd" value="" >
										</span>
		   							</td>
		   							<th align="right">프로젝트명</th>
		    						<td>
		    							<input type="text"  id="prjNm" name="prjNm" value="" >
		    						</td>
		    						<td></td>
		   						</tr>
			   					<tr>
		   							<th align="right">PL 명</th>
		    						<td>
		    							<input type="text" id="saName" name="saName" value="" >
		    						</td>
		   							<th align="right">조직</th>
		   							<td>
		   								<input type="text" id="deptName" name="deptName" value="" >
		   							</td>
		   							<td class="txt-right">
		   								<a style="cursor: pointer;" onclick="fnSearch();" class="btnL">검색</a>
		   							</td>
		   						</tr>
		   						<tr>
		   							<th align="right">프로젝트기간</th>
		   							<td colspan="3">
		   								<input type="text" id="fromDate" /><em class="gab"> ~ </em>
		   								<input type="text" id="toDate" />
		   							</td>
		   							<td></td>
		   						</tr>
		   					</tbody>
		   				</table>
	   				</div>
   				</div>

   				 <div class="titArea">
   					<span class="Ltotal" id="cnt_text"></span>
   				</div>
				<div id="defaultGrid"></div>

			</form>
   			</div><!-- //sub-content -->
   			
   		</div><!-- //contents -->
		</form>
    </body>
</html>