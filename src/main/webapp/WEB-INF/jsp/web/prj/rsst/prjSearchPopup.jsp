<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*,
				 java.util.*,
				 devonframe.util.NullUtil,
				 devonframe.util.DateUtil"%>
<%--
/*
 *************************************************************************
 * $Id      : prjSearchPopup.jsp
 * @desc    : 프로젝트 조회 팝업
 *------------------------------------------------------------------------
 * VER  DATE        AUTHOR      DESCRIPTION
 * ---  ----------- ----------  -----------------------------------------
 * 1.0  2017.08.30  IRIS04      최초생성
 * ---  ----------- ----------  -----------------------------------------
 * IRIS 구축 프로젝트
 *************************************************************************
 */
--%>

<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<%@ include file="/WEB-INF/jsp/include/rui_header.jspf"%>

<title><%=documentTitle%></title>

<style>
 .bgcolor-gray {background-color: #999999}
 .bgcolor-white {background-color: #FFFFFF}
</style>

<script type="text/javascript">

Rui.onReady(function() {

	var ltbPrjNm = new Rui.ui.form.LTextBox({
	     applyTo : 'prjNm',
	     placeholder : '검색할 프로젝트명을 입력해주세요.',
	     defaultValue : '',
	     emptyValue: '',
	     width : 250
	});

	ltbPrjNm.on('blur', function(e) {
		ltbPrjNm.setValue(ltbPrjNm.getValue().trim());
    });

	ltbPrjNm.on('keypress', function(e) {
    	if(e.keyCode == 13) {
    		getPrjList();
    	}
    });

	var prjDataSet = new Rui.data.LJsonDataSet({
	    id : 'prjDataSet',
	    remainRemoved : true,
	    lazyLoad : true,
	    fields : [
	    	  { id : 'prjCd'}
	    	, { id : 'wbsCd'}
	    	, { id : 'prjNm'}
	    	, { id : 'deptCd'}
	    	, { id : 'deptName'}
	    	, { id : 'upDeptCd'}
	    	, { id : 'upDeptName'}
	    	, { id : 'deptCnt'}
	    	, { id : 'plEmpNo'}
	    	, { id : 'plEmpName'}
	    	, { id : 'prjStrDt'}
	    	, { id : 'prjEndDt'}
	    	, { id : 'wbsCdA'}	// WBS코드약어
	    ]
	});

	var prjColumnModel = new Rui.ui.grid.LColumnModel({
		columns : [
		      { field : 'upDeptName',	label : '조직',			align :'center',	width : 200 }
		    , { field : 'prjNm',		label : '프로젝트명',	align :'left',	    width : 250 }
		    , { field : 'plEmpName',    label : 'PL명',	        align :'center',	width : 100 }
		]
	});

	var prjGrid = new Rui.ui.grid.LGridPanel({
	    columnModel : prjColumnModel,
	    dataSet : prjDataSet,
	    width : 580,
	    height : 300,
	    autoToEdit : false,
	    autoWidth : false
	});

	prjGrid.on('cellDblClick', function(e) {

		parent._callback(prjDataSet.getAt(e.row).data);
		parent.prjSearchDialog.submit(true);
	});

	prjGrid.render('prjGrid');

	/* [버튼] 조회 */
	getPrjList = function() {
		prjDataSet.load({
			url : '<c:url value="/prj/rsst/mst/retrievePrjSearchPopupSearchList.do"/>',
			params : {
				prjNm      : encodeURIComponent(ltbPrjNm.getValue())
			  , searchType : aform.searchType.value
			}
		});
	};

	// onLoad 조회
	getPrjList();

});

</script>
    </head>
    <body>
	<form name="aform" id="aform" method="post" onSubmit="return false;">
		<input type="hidden" id="searchType" name="searchType" value="${inputData.searchType}"/>

		<div class="LblockMainBody">

   			<div class="sub-content">

 				<table class="searchBox">
 					<colgroup>
 						<col style="width:20%;"/>
 						<col style="width:*"/>
 						<col style="width:20%;"/>
 					</colgroup>
 					<tbody>
 						<tr>
 							<th align="right">프로젝트명</th>
 							<td>
 								<input type="text" id="prjNm" value="">
 							</td>
 							<td class="t_center">
 								<a style="cursor: pointer;" onclick="getPrjList();" class="btnL">검색</a>
 							</td>
 						</tr>
 					</tbody>
 				</table>

 				<div id="prjGrid"></div>

   			</div><!-- //sub-content -->
   		</div><!-- //contents -->

		</form>
    </body>
</html>