<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*,
				 java.util.*,
				 devonframe.util.NullUtil,
				 devonframe.util.DateUtil"%>

<%--
/*
 *************************************************************************
 * $Id		: spaceRqprSearchPopup.jsp
 * @desc    : 관련평가 리스트 조회 팝업
 *------------------------------------------------------------------------
 * VER	DATE		AUTHOR		DESCRIPTION
 * ---	-----------	----------	-----------------------------------------
 * 1.0  2018.09.07  정현웅		최초생성
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
			if( '${inputData._userDept}' == "58141801" ){
				isSpaceChrg = 1;
			}else{
				isSpaceChrg = 0;
			}

            var spaceNm = new Rui.ui.form.LTextBox({
                 applyTo: 'spaceNm',
                 placeholder: '검색할 평가명을 입력해주세요.',
                 defaultValue: '',
                 emptyValue: '',
                 width: 300
            });

            spaceNm.on('blur', function(e) {
            	spaceNm.setValue(spaceNm.getValue().trim());
            });

            spaceNm.on('keypress', function(e) {
            	if(e.keyCode == 13) {
            		getSpaceRqprList();
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

            var spaceChrgId = new Rui.ui.form.LCombo({
                applyTo: 'spaceChrgId',
                name: 'spaceChrgId',
                emptyText: '전체',
                defaultValue: '',
                emptyValue: '',
                url: '<c:url value="/space/getSpaceChrgList.do"/>',
                displayField: 'name',
                valueField: 'userId'
            });

            var spaceAcpcStCd = new Rui.ui.form.LCombo({
                applyTo: 'spaceAcpcStCd',
                name: 'spaceAcpcStCd',
                emptyText: '전체',
                defaultValue: '',
                emptyValue: '',
                url: '<c:url value="/common/code/retrieveCodeListForCache.do?comCd=SPACE_ACPC_ST_CD"/>',
                displayField: 'COM_DTL_NM',
                valueField: 'COM_DTL_CD'
            });

            /*******************
             * 변수 및 객체 선언
            *******************/
            var spaceRqprDataSet = new Rui.data.LJsonDataSet({
                id : 'spaceRqprDataSet',
                remainRemoved : true,
                lazyLoad : true,
                fields : [
					  { id: 'rqprId'}
					, { id: 'acpcNo' }
					, { id: 'spaceScnNm' }
					, { id: 'spaceNm' }
					, { id: 'rgstId' }
					, { id: 'rgstNm' }
					, { id: 'spaceChrgNm' }
					, { id: 'rqprDt' }
					, { id: 'acpcDt' }
					, { id: 'cmplParrDt' }
					, { id: 'cmplDt' }
					, { id: 'spaceUgyYnNm' }
					, { id: 'acpcStNm' }
                ]
            });

            var spaceRqprColumnModel = new Rui.ui.grid.LColumnModel({
                columns : [
                      { field: 'acpcNo',		label: '접수번호',	sortable: false,	align:'center',	width: 80 }
                    , { field: 'spaceScnNm',	label: '평가구분',	sortable: false,	align:'center',	width: 80 }
                    , { field: 'spaceNm',		label: '평가명',		sortable: false,	align:'left',	width: 300 }
                    , { field: 'rgstNm',		label: '의뢰자',		sortable: false,	align:'center',	width: 80 }
					, { field: 'spaceChrgNm',	label: '담당자',		sortable: false, 	align:'center',	width: 80 }
                    , { field: 'cmplDt',		label: '완료일',		sortable: false, 	align:'center',	width: 80 }
                ]
            });

            var spaceRqprGrid = new Rui.ui.grid.LGridPanel({
                columnModel : spaceRqprColumnModel,
                dataSet : spaceRqprDataSet,
                width : 700,
                height : 300,
                autoToEdit : false,
                autoWidth : true
            });

            spaceRqprGrid.on('cellDblClick', function(e) {
            	parent.callback(spaceRqprDataSet.getAt(e.row).data);

            	parent.spaceRqprSearchDialog.submit(true);
            });

            spaceRqprGrid.render('spaceRqprGrid');

            /* 조회 */
            getSpaceRqprList = function() {
            	spaceRqprDataSet.load({
                    url: '<c:url value="/space/getSpaceRqprList.do"/>',
                    params :{
                    	spaceNm : encodeURIComponent(spaceNm.getValue()),
            		    spaceChrgId : spaceChrgId.getValue(),
            		    rgstId : $('#rgstId').val(),
            		    spaceAcpcStCd : spaceAcpcStCd.getValue(),
            		    isSpaceChrg : isSpaceChrg
                    }
                });
            };

            setRgstInfo = function(userInfo) {
    	    	rgstNm.setValue(userInfo.saName);
    	    	$('#rgstId').val(userInfo.saUser);
    	    }

            getSpaceRqprList();

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
   							<th align="right">평가명</th>
   							<td>
   								<input type="text" id="spaceNm" value="">
   							</td>
   							<th align="right">담당자</th>
    						<td>
                                <div id="spaceChrgId"></div>
    						</td>
   							<td class="t_center" rowspan="2">
   								<a style="cursor: pointer;" onclick="getSpaceRqprList();" class="btnL">검색</a>
   							</td>
   						</tr>
   						<tr>
   							<th align="right">의뢰자</th>
   							<td>
   								<input type="text" id="rgstNm" value="">
                                <a href="javascript:openUserSearchDialog(setRgstInfo, 1, '', 'space');" class="icoBtn">검색</a>
   							</td>
   							<th align="right">상태</th>
   							<td>
                                <div id="spaceAcpcStCd"></div>
   							</td>
   						</tr>
   					</tbody>
   				</table>

   				<div id="spaceRqprGrid"></div>

   			</div><!-- //sub-content -->
   		</div><!-- //contents -->
		</form>
    </body>
</html>