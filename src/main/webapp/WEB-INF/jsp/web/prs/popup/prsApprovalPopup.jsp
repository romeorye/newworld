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

<style>
 .bgcolor-gray {background-color: #999999}
 .bgcolor-white {background-color: #FFFFFF}
</style>

<script type="text/javascript">
var banfnPrs; 

		Rui.onReady(function() {
			var frm = document.aform;
			var dm = new Rui.data.LDataSetManager({defaultFailureHandler: false});
			
			banfnPrs = '${inputData.banfnPrs}';
			
			<%-- RESULT DATASET --%>
			resultDataSet = new Rui.data.LJsonDataSet({
	            id: 'resultDataSet',
	            remainRemoved: true,
	            lazyLoad: true,
	            fields: [
	                  { id: 'rtnSt' }   //결과코드
	                , { id: 'rtnMsg' }  //결과메시지
	            ]
	        });

	        resultDataSet.on('load', function(e) {
	        });
	        
	        _userSearchDialog = new Rui.ui.LFrameDialog({
		        id: '_userSearchDialog',
		        title: '사용자 조회',
		        width: 550,
		        height: 350,
		        modal: true,
		        visible: false
		    });
			
			_userSearchDialog.render(document.body);
			
			/* 심의/협의1 팝업 설정*/
	        var apr1 = new Rui.ui.form.LPopupTextBox({
	        	applyTo: 'apr1Ename',
	            placeholder: '담당자를 선택해주세요.',
	            defaultValue: '',
	            emptyValue: '',
	            editable: false,
	            width: 130
	        });
			
	        apr1.on('popup', function(e){
	        	openUserSearchDialog(setAprInfo, 1, "", "", "apr1","540", "310");
	        });
	        
	        var apr1Sabun = new Rui.ui.form.LTextBox({
	        	applyTo: 'apr1Pernr'
	        });
	        
	        apr1Sabun.hide();
	        
			
			/* 심의/협의2 팝업 설정*/
	        var apr2 = new Rui.ui.form.LPopupTextBox({
	        	applyTo: 'apr2Ename',
	            placeholder: '담당자를 선택해주세요.',
	            defaultValue: '',
	            emptyValue: '',
	            editable: false,
	            width: 130
	        });
			
	        apr2.on('popup', function(e){
	        	openUserSearchDialog(setAprInfo, 1, "", "", "apr2","540", "310");
	        });

	        var apr2Sabun = new Rui.ui.form.LTextBox({
	        	applyTo: 'apr2Pernr'
	        });
	        
	        apr2Sabun.hide();
	        
			/* 심의/협의3 팝업 설정*/
	        var apr3 = new Rui.ui.form.LPopupTextBox({
	        	applyTo: 'apr3Ename',
	            placeholder: '담당자를 선택해주세요.',
	            defaultValue: '',
	            emptyValue: '',
	            editable: false,
	            width: 130
	        });
			
	        apr3.on('popup', function(e){
	        	openUserSearchDialog(setAprInfo, 1, "", "", "apr3","540", "310");
	        });
	        
	        var apr3Sabun = new Rui.ui.form.LTextBox({
	        	applyTo: 'apr3Pernr'
	        });
	        
	        apr3Sabun.hide();
	        
			/* 확정자 팝업 설정*/
	        var apr4 = new Rui.ui.form.LPopupTextBox({
	        	applyTo: 'apr4Ename',
	        	placeholder: '확정자를 선택해주세요.',
	            defaultValue: '',
	            emptyValue: '',
	            editable: false,
	            width: 130
	        });
			
	        apr4.on('popup', function(e){
	        	openUserSearchDialog(setAprInfo, 1, "", "", "apr4","540", "310");
	        });

	        var apr4Sabun = new Rui.ui.form.LTextBox({
	        	applyTo: 'apr4Pernr'
	        });
	        
	        apr4Sabun.hide();
	        
	        //의견
		    var itemTxt = new Rui.ui.form.LTextArea({
	            applyTo: 'opinDoc',
	            placeholder: '의견을 입력하여 주십시요.',
	            width: 470,
	            height: 80
	        });
			
			//담당자 정보 세팅
			function setAprInfo(aprInfo, field){
				switch(field) {
					case 'apr1' :
						apr1.setValue(aprInfo.saName);
						apr1Sabun.setValue(aprInfo.saSabun);
						break;
					case 'apr2' :
						apr2.setValue(aprInfo.saName);
						apr2Sabun.setValue(aprInfo.saSabun);
						break;
					case 'apr3' :
						apr3.setValue(aprInfo.saName);
						apr3Sabun.setValue(aprInfo.saSabun);
						break;
					case 'apr4' :
						apr4.setValue(aprInfo.saName);
						apr4Sabun.setValue(aprInfo.saSabun);
						break;
				    default :
				    	alert('임직원 정보를 반영할 수 없습니다.');
				    	break;
				};
				
				return;
			}
			
			
		    openUserSearchDialog = function(f, cnt, userIds, task, field, width, height) {
		    	_callback = f;
		    	
		    	if(cnt == 1) {
		    	    if(stringNullChk(width) > 0) _userSearchDialog.setWidth(width);
		    	    if(stringNullChk(height) > 0) _userSearchDialog.setHeight(height);

			        _userSearchDialog.setUrl('/iris/prs/popup/userSearchPopup.do?cnt=1&userIds=&task=' + task + '&field=' + field);
			        _userSearchDialog.show();
		    	} else {
		    	    if(stringNullChk(width) > 0) _userSearchDialogMulti.setWidth(width);
	                if(stringNullChk(height) > 0) _userSearchDialogMulti.setHeight(height);

		    		_userSearchDialogMulti.setUrl('/iris/prs/popup/userSearchPopup.do?cnt=' + cnt + '&userIds=' + userIds + '&task=' + task + '&field=' + field);
		    		_userSearchDialogMulti.show();
		    	}
		    };
			
		    /* [버튼] 의뢰 시작 */
		    var btnApprovalSave = new Rui.ui.LButton('btnApprovalSave');
		    btnApprovalSave.on('click', function() {
		    	if(isApprovalSaveValidate('의뢰')) {
		    		fncApprovalSave();
		    	};   	
			});
		    /* [버튼] 의뢰 끝 */
		    
		    /* 결재의뢰 유효성 검사 */
		    isApprovalSaveValidate = function(type) {
	            if (apr4.getValue() == '' || apr4Sabun.getValue() == '') {
	                alert('확정자를 확인하여 주세요.');
	                return false;
	            }

	            return true;
		    }
		    
		    /* 결재의뢰 저장 */
			fncApprovalSave = function(){
		    	if( confirm("결재의뢰 하시겠습니까?") == true ){
		    		dm.updateForm({
		    			url:'<c:url value="/prs/purRq/insertApprovalInfo.do"/>',
		    			form : 'aform',
		    			params: {                                  
		    				wbsCdNm: $('#wbsCdName', aform).html(),
		    				banfnPrs: '<c:out value="${inputData.banfnPrs}"/>'
		    	        }
		    		});
		    	} 
			}
		    
			dm.on('success', function(e) {
				var resultData = resultDataSet.getReadData(e);
				
				if( resultData.records[0].rtnSt == "S"){
					alert(resultData.records[0].rtnMsg);
 				} else if( resultData.records[0].rtnSt == "E"){
 					alert(resultData.records[0].rtnMsg);
				} else if( resultData.records[0].rtnSt == "F"){
 					alert(resultData.records[0].rtnMsg);
 				};
 				parent._callback();
 				parent._prsApprovalDialog.submit(true);
	        });
	        dm.on('failure', function(e) {
	        	var resultData = resultDataSet.getReadData(e);
	   			Rui.alert(resultData.records[0].rtnMsg);
	   			parent._prsApprovalDialog.submit(true);
	        });		    
		});

	</script>
    </head>
    <body>
	<form name="aform" id="aform" method="post" onSubmit="return false;">
	<input type="hidden" id="banfnPrs" name="banfnPrs" value="<c:out value='${inputData.banfnPrs}'/>">
   	<div class="LblockMainBody">
			<table class="table table_txt_right">
            	<colgroup>
                	<col width="150px">
                    <col width="*">
                 </colgroup>
			     <tbody>
			        <tr>
			        	<th>요청자</th>
			            <td>
			            	${inputData._userNm}
			            </td>
					</tr>
					<tr>
					   	<th>심의/협의1</th>
			            <td>
			            	<input type="text" id="apr1Ename" name="apr1Ename" />
			            	<input type="text" id="apr1Pernr" name="apr1Pernr" hidden="true" />
			            </td>
					</tr>
					<tr>
					   	<th>심의/협의2</th>
			            <td>
			            	<input type="text" id="apr2Ename" name="apr2Ename" />
			            	<input type="text" id="apr2Pernr" name="apr2Pernr" hidden="true" />
			            </td>
					</tr>
					<tr>
					   	<th>심의/협의3</th>
			            <td>
			            	<input type="text" id="apr3Ename" name="apr3Ename" />
			            	<input type="text" id="apr3Pernr" name="apr3Pernr" hidden="true" />
			            </td>
					</tr>
					<tr>
					   	<th><span style="color:red;">* </span>확정자</th>
			            <td>
			            	<input type="text" id="apr4Ename" name="apr4Ename" />
			            	<input type="text" id="apr4Pernr" name="apr4Pernr" hidden="true" />
			            </td>
					</tr>
					<tr>
					   	<th>메일발송</th>
			            <td>
			            	<input type="checkbox" id="gCheck" name="gCheck" value="Y" checked  />
			            </td>
					</tr>
					<tr>
					   	<th>확정메일</th>
			            <td>
			            	<input type="checkbox" id="gCheck2" name="gCheck2" value="Y" checked />
			            </td>
					</tr>
			        <tr>
			         	<th>의견</th>
			            <td>
			            	<textarea id="opinDoc" name="opinDoc"></textarea>
			            </td>
					</tr>	
				</tbody>
			</table>
			<div class="titArea">
	    		<div class="LblockButton">
	    	 		<button type="button" id="btnApprovalSave" name="btnApprovalSave" class="redBtn">의뢰</button>
	    		</div>
	    	</div>
	</div><!-- //LblockMainBody -->
	</form>
    </body>
</html>