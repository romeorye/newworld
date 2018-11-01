<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*,
				 java.util.*,
				 devonframe.util.NullUtil,
				 devonframe.util.DateUtil"%>

<%--
/*
 *************************************************************************
 * $Id		: prjUserInfoPop.jsp
 * @desc    : 자산 프로젝트 사용자 조회 팝업
 *------------------------------------------------------------------------
 * VER	DATE		AUTHOR		DESCRIPTION
 * ---	-----------	----------	-----------------------------------------
 * 1.0  2016.09.19  IRIS05		최초생성
 * ---	-----------	----------	-----------------------------------------
 * IRIS 구축 프로젝트
 *************************************************************************
 */
--%>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/include/rui_header.jspf"%>
<title><%=documentTitle%></title>

<%-- rui staus bar --%>
<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/grid/LGridStatusBar.js"></script>
<link rel="stylesheet" type="text/css" href="<%=ruiPathPlugins%>/ui/grid/LGridStatusBar.css"/>


<script type="text/javascript">
	Rui.onReady(function() {

		/*******************
         * 변수 및 객체 선언
        *******************/
        var userDataSet = new Rui.data.LJsonDataSet({
            id : 'userDataSet',
            remainRemoved : true,
            lazyLoad : true,
            fields : [
            	  { id : 'saSabun'}
            	, { id : 'saName'}
            	, { id : 'deptCd'}
            	, { id : 'prjNm'}
            	, { id : 'saJobx'}
            	, { id : 'saJobxName'}
            	, { id : 'wbsCd'}
            ]
        });

        userDataSet.on('load', function (e) {
        	if (userDataSet.getCount() == 1){
        		var row =userDataSet.getRow();
        		var record = userDataSet.getAt(0).data

        		parent._callback(record);
            	parent.fncDialogClose();
        	}
        });
        
        
        var columnModel = new Rui.ui.grid.LColumnModel({
            columns: [
                      { field: 'prjNm'      ,label: '프로젝트명',	sortable: false,	align:'left', width:350 }
                    , { field: 'saName'     ,label: '이름', 		sortable: false,	align:'center', width: 125}
					, { field: 'saJobxName' ,label: '직위',  		sortable: false,	align:'center', width: 125}
                    , { field: 'saSabun'  	,hidden : true }
                    , { field: 'wbsCd'  	,hidden : true }
            ]
        });


        /** default grid **/
        var grid = new Rui.ui.grid.LGridPanel({
            columnModel: columnModel,
            dataSet: userDataSet,
            width: 618,
            height: 180
        });

        grid.render('userGrid');

        /* [버튼] 조회 */
        getUserList = function() {
        	userDataSet.load({
                url : '<c:url value="/fxa/fxaInfo/retrievePrjUserSearch.do"/>',
                params : {
                	userNm : encodeURIComponent(document.aform.userNm.value),
                	teamNm : encodeURIComponent(document.aform.teamNm.value)
                }
            });
        };

		if(!Rui.isEmpty('${inputData.userNm}')){
			var frm = document.aform;
			frm.userNm.value = '${inputData.userNm}';
			getUserList();
		}
		
        grid.on('cellDblClick', function(e) {
        	parent._callback(userDataSet.getAt(e.row).data);
        	parent.fncDialogClose();
        });
	});

</script>
</head>
 <body onkeypress="if(event.keyCode==13) {getUserList();}">
<form name="aform" id="aform" method="post">
	<input type="hidden" id="cnt" name="cnt" value="${inputData.cnt}"/>
	<input type="hidden" id="userIds" name="userIds" value="${inputData.userIds}"/>

	   			<div class="search mb5">
				<div class="search-content">
			   				<table>
   					<colgroup>
   						<col style="width:80px;">
   						<col style="">
   						<col style="width:80px;">
   						<col style="">
   						<col style="width:80px;">
   					</colgroup>
   					<tbody>
					<tr>
						<th align="right">PJT명</th>
						<td>
							<input type="text" id="teamNm" value="">
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
		</div><!-- //sub-content -->
		
		<div id="userGrid"></div>

	</div><!-- //contents -->
</form>
</body>
</html>