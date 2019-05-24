<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*,
				 java.util.*,
				 devonframe.util.NullUtil,
				 devonframe.util.DateUtil"%>

<%--
/*
 *************************************************************************
 * $Id		: purRqPrjPop.jsp
 * @desc    : 프로젝트 조회 팝업 화면
 *------------------------------------------------------------------------
 * VER	DATE		AUTHOR		DESCRIPTION
 * ---	-----------	----------	-----------------------------------------
 * 1.0  2019.03.19   김연태		최초생성
 * ---	-----------	----------	-----------------------------------------
 * PRS 프로젝트
 *************************************************************************
 */
--%>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/include/rui_header.jspf"%>
<title><%=documentTitle%></title>

<script type="text/javascript">
var adminChk ="N";


	Rui.onReady(function() {
		
		if("<c:out value='${inputData._roleId}'/>".indexOf('WORK_IRI_T01') > -1) {
			adminChk = "Y";
		}
		
		var prjNm = new Rui.ui.form.LTextBox({
		     applyTo : 'prjNm',
		     placeholder : '검색할 프로젝트명을 입력해주세요.',
		     defaultValue : '',
		     emptyValue: '',
		     width : 250
		});

		prjNm.on('blur', function(e) {
			prjNm.setValue(prjNm.getValue().trim());
	    });

		prjNm.on('keypress', function(e) {
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
		    	, { id : 'posid'}
		    	, { id : 'post1'}
		    	, { id : 'ename'}
		    	, { id : 'plEmpNo'}
		    	, { id : 'prjStrDt'}
		    	, { id : 'prjEndDt'}
		    	, { id : 'deptCd'}	// WBS코드약어
		    ]
		});

		var prjColumnModel = new Rui.ui.grid.LColumnModel({
			columns : [
			      { field : 'posid',	label : 'WBS CODE',			align :'center',	width : 200 }
			    , { field : 'post1',		label : '프로젝트명',	align :'left',	    width : 250 }
			    , { field : 'ename',    label : 'PL명',	        align :'center',	width : 100 }
			    , { field : 'prjStrDt',    label : '프로젝트 시작일',	        align :'center',	width : 100 }
			    , { field : 'prjEndDt',    label : '프로젝트 종료일',	        align :'center',	width : 100 }
			    , { field : 'deptCd',    hidden:true }
			]
		});

		var prjGrid = new Rui.ui.grid.LGridPanel({
		    columnModel : prjColumnModel,
		    dataSet : prjDataSet,
		    width : 580,
		    height : 300,
		    autoToEdit : false,
		    autoWidth : true
		});

		prjGrid.on('cellDblClick', function(e) {
			parent._callback(prjDataSet.getAt(e.row).data);
			parent.openPrjSearchDialog.cancel(true);
		});

		prjGrid.render('prjGrid');

		/* [버튼] 조회 */
		getPrjList = function() {
			prjDataSet.load({
				url : '<c:url value="/prs/purRq/retrieveWbsCdInfoList.do"/>',
				params : {
					prjNm      : encodeURIComponent(prjNm.getValue())
				  , adminChk : adminChk
				}
			});
		};

		// onLoad 조회
		getPrjList();
		
	});
	
</script>

<body>

<form name="aform" id="aform" method="post" onSubmit="return false;">
		<div class="LblockMainBody">

   			<div class="sub-content" style="padding:0; padding-left:3px;">

 				<div class="search mb5">
					<div class="search-content">
		   				<table>
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
 				</div>
 				</div>

 				<div id="prjGrid"></div>

   			</div><!-- //sub-content -->
   		</div><!-- //contents -->

		</form>



</body>
</html>

