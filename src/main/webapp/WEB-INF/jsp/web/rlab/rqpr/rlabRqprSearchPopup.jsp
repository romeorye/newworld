<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*,
				 java.util.*,
				 devonframe.util.NullUtil,
				 devonframe.util.DateUtil"%>

<%--
/*
 *************************************************************************
 * $Id		: rlabRqprSearchPopup.jsp
 * @desc    : 관련시험 리스트 조회 팝업
 *------------------------------------------------------------------------
 * VER	DATE		AUTHOR		DESCRIPTION
 * ---	-----------	----------	-----------------------------------------
 * 1.0  2018.08.13  정현웅		최초생성
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
			if( '${inputData._userDept}' == "58141801" ){
				isRlabChrg = 1;
			}else{
				isRlabChrg = 0;
			}

            var rlabNm = new Rui.ui.form.LTextBox({
                 applyTo: 'rlabNm',
                 placeholder: '검색할 시험명을 입력해주세요.',
                 defaultValue: '',
                 emptyValue: '',
                 width: 300
            });
            
            rlabNm.on('blur', function(e) {
            	rlabNm.setValue(rlabNm.getValue().trim());
            });
            
            rlabNm.on('keypress', function(e) {
            	if(e.keyCode == 13) {
            		getRlabRqprList();
            	}
            });
             
            var rgstNm = new Rui.ui.form.LTextBox({
                 applyTo: 'rgstNm',
                 placeholder: '검색할 의뢰자를 입력해주세요.',
                 defaultValue: '',
                 emptyValue: '',
                 editable: false,
                 width: 260
            });
            
            rgstNm.on('focus', function(e) {
            	rgstNm.setValue('');
            	$('#rgstId').val('');
            });
            
            var rlabChrgId = new Rui.ui.form.LCombo({
                applyTo: 'rlabChrgId',
                name: 'rlabChrgId',
                emptyText: '전체',
                defaultValue: '',
                emptyValue: '',
                url: '<c:url value="/rlab/getRlabChrgList.do"/>',
                displayField: 'name',
                valueField: 'userId'
            });
            
            var acpcStCd = new Rui.ui.form.LCombo({
                applyTo: 'acpcStCd',
                name: 'acpcStCd',
                emptyText: '전체',
                defaultValue: '',
                emptyValue: '',
                url: '<c:url value="/common/code/retrieveCodeListForCache.do?comCd=ACPC_ST_CD"/>',
                displayField: 'COM_DTL_NM',
                valueField: 'COM_DTL_CD'
            });
			
            /*******************
             * 변수 및 객체 선언
            *******************/
            var rlabRqprDataSet = new Rui.data.LJsonDataSet({
                id : 'rlabRqprDataSet',
                remainRemoved : true,
                lazyLoad : true,
                fields : [
					  { id: 'rqprId'}
					, { id: 'acpcNo' }
					, { id: 'rlabScnNm' }
					, { id: 'rlabNm' }
					, { id: 'rgstId' }
					, { id: 'rgstNm' }
					, { id: 'rlabChrgNm' }
					, { id: 'rqprDt' }
					, { id: 'acpcDt' }
					, { id: 'cmplParrDt' }
					, { id: 'cmplDt' }
					, { id: 'rlabUgyYnNm' }
					, { id: 'acpcStNm' }
                ]
            });

            var rlabRqprColumnModel = new Rui.ui.grid.LColumnModel({
                columns : [
                      { field: 'acpcNo',		label: '접수번호',	sortable: false,	align:'center',	width: 80 }
                    , { field: 'rlabScnNm',		label: '시험구분',	sortable: false,	align:'center',	width: 80 }
                    , { field: 'rlabNm',		label: '시험명',		sortable: false,	align:'left',	width: 300 }
                    , { field: 'rgstNm',		label: '의뢰자',		sortable: false,	align:'center',	width: 80 }
					, { field: 'rlabChrgNm',	label: '담당자',		sortable: false, 	align:'center',	width: 80 }
                    , { field: 'cmplDt',		label: '완료일',		sortable: false, 	align:'center',	width: 80 }
                ]
            });

            var rlabRqprGrid = new Rui.ui.grid.LGridPanel({
                columnModel : rlabRqprColumnModel,
                dataSet : rlabRqprDataSet,
                width : 700,
                height : 300,
                autoToEdit : false,
                autoWidth : true
            });

            rlabRqprGrid.on('cellDblClick', function(e) {
            	parent.callback(rlabRqprDataSet.getAt(e.row).data);
            	parent.rlabRqprSearchDialog.submit(true);
            });
            
            rlabRqprGrid.render('rlabRqprGrid');
            
            /* 조회 */
            getRlabRqprList = function() {
            	rlabRqprDataSet.load({
                    url: '<c:url value="/rlab/getRlabRqprList.do"/>',
                    params :{
                    	rlabNm : encodeURIComponent(rlabNm.getValue()),
            		    rlabChrgId : rlabChrgId.getValue(),
            		    rgstId : $('#rgstId').val(),
            		    acpcStCd : acpcStCd.getValue(),
            		    isRlabChrg : isRlabChrg
                    }
                });
            };
    		
            setRgstInfo = function(userInfo) {
    	    	rgstNm.setValue(userInfo.saName);
    	    	$('#rgstId').val(userInfo.saUser);
    	    }
            
            getRlabRqprList();
			
        });

	</script>
    </head>
    <body>
	<form name="aform" id="aform" method="post" onSubmit="return false;">
		<input type="hidden" id="rgstId" name="rgstId" value=""/>
		
   		<div class="LblockMainBody">

   			<div class="sub-content">
	   			
   				<table class="searchBox">
   					<colgroup>
   						<col style="width:10%;"/>
   						<col style="width:45%;"/>
   						<col style="width:10%;"/>
   						<col style="width:20%;"/>
   						<col style="width:15%;"/>
   					</colgroup>
   					<tbody>
   						<tr>
   							<th align="right">시험명</th>
   							<td>
   								<input type="text" id="rlabNm" value="">
   							</td>
   							<th align="right">담당자</th>
    						<td>
                                <div id="rlabChrgId"></div>
    						</td>
   							<td class="t_center" rowspan="2">
   								<a style="cursor: pointer;" onclick="getRlabRqprList();" class="btnL">검색</a>
   							</td>
   						</tr>
   						<tr>
   							<th align="right">의뢰자</th>
   							<td>
   								<input type="text" id="rgstNm" value="">
                                <a href="javascript:openUserSearchDialog(setRgstInfo, 1, '', 'rlab');" class="icoBtn">검색</a>
   							</td>
   							<th align="right">상태</th>
   							<td>
                                <div id="acpcStCd"></div>
   							</td>
   						</tr>
   					</tbody>
   				</table>

   				<div id="rlabRqprGrid"></div>
   				
   			</div><!-- //sub-content -->
   		</div><!-- //contents -->
		</form>
    </body>
</html>