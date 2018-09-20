<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*,
				 java.util.*,
				 devonframe.util.NullUtil,
				 devonframe.util.DateUtil"%>

<%--
/*
 *************************************************************************
 * $Id		: deptSearchPopup.jsp
 * @desc    : 부서 조회 공통 팝업
 *------------------------------------------------------------------------
 * VER	DATE		AUTHOR		DESCRIPTION
 * ---	-----------	----------	-----------------------------------------
 * 1.0  2016.07.25  민길문		최초생성
 * ---	-----------	----------	-----------------------------------------
 * IRIS UPGRADE 1차 프로젝트
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
            /*******************
             * 변수 및 객체 선언
             *******************/
            var deptNm = new Rui.ui.form.LTextBox({
                 applyTo : 'deptNm',
                 placeholder : '검색할 부서명을 입력해주세요.',
                 defaultValue : '',
                 emptyValue: '',
                 width : 220
            });
            
            deptNm.on('blur', function(e) {
            	deptNm.setValue(deptNm.getValue().trim());
            });
            
            deptNm.on('keypress', function(e) {
            	if(e.keyCode == 13) {
            		getDeptList();
            	}
            });
			
            /*******************
             * 변수 및 객체 선언
            *******************/
            var deptDataSet = new Rui.data.LJsonDataSet({
                id : 'deptDataSet',
                remainRemoved : true,
                lazyLoad : true,
                fields : [
                	  { id : 'deptCd'}
                	, { id : 'deptNm'}
                	, { id : 'deptENm'}
                	, { id : 'deptCNm'}
                	, { id : 'upperDeptCd'}
                	, { id : 'upperDeptNm'}
                ]
            });

            var deptColumnModel = new Rui.ui.grid.LColumnModel({
                columns : [
                      { field : 'upperDeptNm',	label : '조직',		sortable : false,	align :'center',	width : 200 }
                    , { field : 'deptNm',		label : '팀',		sortable : false,	align :'center',	width : 200 }
                ]
            });

            var deptGrid = new Rui.ui.grid.LGridPanel({
                columnModel : deptColumnModel,
                dataSet : deptDataSet,
                width : 400,
                height : 160,
                autoToEdit : false,
                autoWidth : true
            });

            deptGrid.on('cellDblClick', function(e) {
            	parent._callback(deptDataSet.getAt(e.row).data);
            	
            	parent._deptSearchDialog.submit(true);
            });
            
            deptGrid.render('deptGrid');
            
            /* [버튼] 조회 */
            getDeptList = function() {
            	deptDataSet.load({
                    url : '<c:url value="/system/dept/getDeptList.do"/>',
                    params : {
                    	task : '${inputData.task}',
                    	deptNm : encodeURIComponent(deptNm.getValue())
                    }
                });
            };
			
        });

	</script>
    </head>
    <body>
	<form name="aform" id="aform" method="post" onSubmit="return false;">
		
   		<div class="LblockMainBody">

   			<div class="sub-content" style="padding:0;">
	   			
   				<div class="search mb5">
					<div class="search-content">
						<table>
		   					<colgroup>
		   						<col style="width:20%;"/>
		   						<col style="width:*"/>
		   						<col style="width:25%;"/>
		   					</colgroup>
		   					<tbody>
		   						<tr>
		   							<th align="right">부서</th>
		   							<td>
		   								<input type="text" id="deptNm" value="">
		   							</td>
		   							<td class="txt-right">
		   								<a style="cursor: pointer;" onclick="getDeptList();" class="btnL">검색</a>
		   							</td>
		   						</tr>
		   					</tbody>
		   				</table>
	   				</div>
   				</div>

   				<div id="deptGrid"></div>
   				
   			</div><!-- //sub-content -->
   		</div><!-- //contents -->
		</form>
    </body>
</html>