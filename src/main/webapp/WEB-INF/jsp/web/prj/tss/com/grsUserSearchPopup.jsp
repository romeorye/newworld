<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*,
				 java.util.*,
				 devonframe.util.NullUtil,
				 devonframe.util.DateUtil"%>

<%--
/*
 *************************************************************************
 * $Id		: tssUserSearchPopup.jsp
 * @desc    : 사용자 조회 공통 팝업
 *------------------------------------------------------------------------
 * VER	DATE		AUTHOR		DESCRIPTION
 * ---	-----------	----------	-----------------------------------------
 * 1.0  2016.07.25  민길문		최초생성
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
                 width : 160
            });
            
            deptNm.on('blur', function(e) {
            	deptNm.setValue(deptNm.getValue().trim());
            });
            
            deptNm.on('keypress', function(e) {
            	if(e.keyCode == 13) {
            		getUserList();
            	}
            });
            
            var userNm = new Rui.ui.form.LTextBox({
                 applyTo : 'userNm',
                 placeholder : '검색할 사용자명을 입력해주세요.',
                 defaultValue : '',
                 emptyValue: '',
                 width : 110
            });
            
            userNm.on('blur', function(e) {
            	userNm.setValue(userNm.getValue().trim());
            });
            
            userNm.on('keypress', function(e) {
            	if(e.keyCode == 13) {
            		getUserList();
            	}
            });
			
            /*******************
             * 변수 및 객체 선언
            *******************/
            var userDataSet = new Rui.data.LJsonDataSet({
                id : 'userDataSet',
                remainRemoved : true,
                lazyLoad : true,
                fields : [
                	  { id : 'saSabun'}
                	, { id : 'saUser'}
                	, { id : 'saName'}
                	, { id : 'saEName'}
                	, { id : 'saCName'}
                	, { id : 'deptName'}
                	, { id : 'deptCd'}
                	, { id : 'saJobxName'}
                	, { id : 'saJobx'}
                	, { id : 'saPhoneArea'}
                	, { id : 'saHand'}
                	, { id : 'saMail'}
                	
                ]
            });

            var userColumnModel = new Rui.ui.grid.LColumnModel({
                columns : [
                <c:if test="${inputData.cnt != 1}">
              	  	  new Rui.ui.grid.LSelectionColumn(),
              	</c:if>
                      { field : 'saName',		label : '이름',		sortable : false,	align :'center',	width : 100 }
                    , { field : 'saJobxName',	label : '직위',		sortable : false,	align :'center',	width : 100 }
                    , { field : 'deptName',		label : '부서',		sortable : false,	align :'center',	width : 200 }
                    , { field : 'saUser', hidden: true}
                ]
            });

            var userGrid = new Rui.ui.grid.LGridPanel({
                columnModel : userColumnModel,
                dataSet : userDataSet,
                width : 400,
                height : 200,
                autoToEdit : false,
                autoWidth : true
            });

            userGrid.on('cellDblClick', function(e) {
            	parent._callback(userDataSet.getAt(e.row).data);
            	
            	parent._userSearchDialog.submit(true);
            });
            
            userGrid.render('userGrid');
            
            /* [버튼] 조회 */
            getUserList = function() {
            	userDataSet.load({
                    url : '<c:url value="/com/tss/getGrsUserList.do"/>',
                    params : {
                    	deptNm : encodeURIComponent(deptNm.getValue()),
                    	userNm : encodeURIComponent(userNm.getValue()),
                    	userIds : ''
                    }
                });
            };

            getUserList();
			
        });

	</script>
    </head>
    <body>
	<form name="aform" id="aform" method="post">
		<input type="hidden" id="cnt" name="cnt" value="${inputData.cnt}"/>
		<input type="hidden" id="userIds" name="userIds" value="${inputData.userIds}"/>
		
   		<div class="LblockMainBody">

   			<div class="sub-content" style="padding:0 5px;">
	   			<div class="search mb5 ">
				<div class="search-content">
   				<table>
   					<colgroup>
   						<col style="width:90px;"/>
   						<col style=""/>
   						<col style="width:90px;"/>
   						<col style=""/>
   						<col style=""/>
   					</colgroup>
   					<tbody>
   						<tr>
   							<th align="right">부서</th>
   							<td>
   								<input type="text" id="deptNm" value="">
   							</td>
   							<th align="right">이름</th>
    						<td>
   								<input type="text" id="userNm" value="">
    						</td>
   							<td class="txt-right">
   								<a style="cursor: pointer;" onclick="getUserList();" class="btnL">검색</a>
   							</td>
   						</tr>
   					</tbody>
   				</table>
   				</div>
   				</div>

   				<div id="userGrid"></div>
   				
        	
   			</div><!-- //sub-content -->
   		</div><!-- //contents -->
		</form>
    </body>
</html>