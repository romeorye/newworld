<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*,
				 java.util.*,
				 devonframe.util.NullUtil,
				 devonframe.util.DateUtil"%>

<%--
/*
 *************************************************************************
 * $Id		: anlRqprSearchPopup.jsp
 * @desc    : 관련분석 리스트 조회 팝업
 *------------------------------------------------------------------------
 * VER	DATE		AUTHOR		DESCRIPTION
 * ---	-----------	----------	-----------------------------------------
 * 1.0  2017.08.25  오명철		최초생성
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
			if( '${inputData._userDept}' == "58141801"  ||  '${inputData._userDept}' == "58171352" ){
				isAnlChrg = 1;
			}else{
				isAnlChrg = 0;
			}

            var anlNm = new Rui.ui.form.LTextBox({
                 applyTo: 'anlNm',
                 placeholder: '검색할 분석명을 입력해주세요.',
                 defaultValue: '',
                 emptyValue: '',
                 width: 300
            });
            
            anlNm.on('blur', function(e) {
            	anlNm.setValue(anlNm.getValue().trim());
            });
            
            anlNm.on('keypress', function(e) {
            	if(e.keyCode == 13) {
            		getAnlRqprList();
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
            
            var anlChrgId = new Rui.ui.form.LCombo({
                applyTo: 'anlChrgId',
                name: 'anlChrgId',
                emptyText: '(전체)',
                defaultValue: '',
                emptyValue: '',
                url: '<c:url value="/anl/getAnlChrgList.do"/>',
                displayField: 'name',
                valueField: 'userId'
            });
            
            var acpcStCd = new Rui.ui.form.LCombo({
                applyTo: 'acpcStCd',
                name: 'acpcStCd',
                emptyText: '(전체)',
                defaultValue: '',
                emptyValue: '',
                url: '<c:url value="/common/code/retrieveCodeListForCache.do?comCd=ACPC_ST_CD"/>',
                displayField: 'COM_DTL_NM',
                valueField: 'COM_DTL_CD'
            });
			
            /*******************
             * 변수 및 객체 선언
            *******************/
            var anlRqprDataSet = new Rui.data.LJsonDataSet({
                id : 'anlRqprDataSet',
                remainRemoved : true,
                lazyLoad : true,
                fields : [
					  { id: 'rqprId'}
					, { id: 'acpcNo' }
					, { id: 'anlScnNm' }
					, { id: 'anlNm' }
					, { id: 'rgstId' }
					, { id: 'rgstNm' }
					, { id: 'anlChrgNm' }
					, { id: 'rqprDt' }
					, { id: 'acpcDt' }
					, { id: 'cmplParrDt' }
					, { id: 'cmplDt' }
					, { id: 'anlUgyYnNm' }
					, { id: 'acpcStNm' }
                ]
            });

            var anlRqprColumnModel = new Rui.ui.grid.LColumnModel({
                columns : [
                      { field: 'acpcNo',		label: '접수번호',		sortable: false,	align:'center',	width: 80 }
                    , { field: 'anlScnNm',		label: '분석구분',		sortable: false,	align:'center',	width: 80 }
                    , { field: 'anlNm',			label: '분석명',		sortable: false,	align:'left',	width: 300 }
                    , { field: 'rgstNm',		label: '의뢰자',		sortable: false,	align:'center',	width: 80 }
					, { field: 'anlChrgNm',		label: '담당자',		sortable: false, 	align:'center',	width: 80 }
                    , { field: 'cmplDt',		label: '완료일',		sortable: false, 	align:'center',	width: 80 }
                ]
            });

            var anlRqprGrid = new Rui.ui.grid.LGridPanel({
                columnModel : anlRqprColumnModel,
                dataSet : anlRqprDataSet,
                width : 700,
                height : 300,
                autoToEdit : false,
                autoWidth : true
            });

            anlRqprGrid.on('cellDblClick', function(e) {
            	parent.callback(anlRqprDataSet.getAt(e.row).data);
            	
            	parent.anlRqprSearchDialog.submit(true);
            });
            
            anlRqprGrid.render('anlRqprGrid');
            
            /* 조회 */
            getAnlRqprList = function() {
            	anlRqprDataSet.load({
                    url: '<c:url value="/anl/getAnlRqprList.do"/>',
                    params :{
                    	anlNm : encodeURIComponent(anlNm.getValue()),
            		    anlChrgId : anlChrgId.getValue(),
            		    rgstId : $('#rgstId').val(),
            		    acpcStCd : acpcStCd.getValue(),
            		    isAnlChrg : isAnlChrg
                    }
                });
            };
    		
            setRgstInfo = function(userInfo) {
    	    	rgstNm.setValue(userInfo.saName);
    	    	$('#rgstId').val(userInfo.saUser);
    	    }
            
            getAnlRqprList();
			
        });

	</script>
    </head>
    <body>
	<form name="aform" id="aform" method="post" onSubmit="return false;">
		<input type="hidden" id="rgstId" name="rgstId" value=""/>
		
   		<div class="LblockMainBody">

   			<div class="sub-content" style="padding:0;">
	   			
   				<div class="search mb5">
					<div class="search-content">
					<table>
	   					<colgroup>
	   						<col style="width:80px;"/>
	   						<col style="width:45%;"/>
	   						<col style="width:80px;"/>
	   						<col style="width:20%;"/>
	   						<col style="width:15%;"/>
	   					</colgroup>
	   					<tbody>
	   						<tr>
	   							<th align="right">분석명</th>
	   							<td>
	   								<input type="text" id="anlNm" value="">
	   							</td>
	   							<th align="right">담당자</th>
	    						<td>
	                                <div id="anlChrgId"></div>
	    						</td>
	   							<td></td>
	   						</tr>
	   						<tr>
	   							<th align="right">의뢰자</th>
	   							<td>
	   								<input type="text" id="rgstNm" value="">
	                                <a href="javascript:openUserSearchDialog(setRgstInfo, 1, '', 'anl');" class="icoBtn">검색</a>
	   							</td>
	   							<th align="right">상태</th>
	   							<td>
	                                <div id="acpcStCd"></div>
	   							</td>
	   							<td class="txt-right">
	   								<a style="cursor: pointer;" onclick="getAnlRqprList();" class="btnL">검색</a>
	   							</td>
	   						</tr>
	   					</tbody>
	   				</table>
					</div>
				</div>
   				<div id="anlRqprGrid"></div>
   				
   			</div><!-- //sub-content -->
   		</div><!-- //contents -->
		</form>
    </body>
</html>