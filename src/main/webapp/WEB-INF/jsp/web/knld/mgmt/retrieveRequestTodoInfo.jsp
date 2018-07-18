<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*,
				 java.util.*,
				 devonframe.util.NullUtil,
				 devonframe.util.DateUtil"%>

<%--
/*
 *************************************************************************
 * $Id		: retrieveRequestTodoInfo.jsp
 * @desc    : 조회 요청 승인/반려 화면
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


<style>
 .bgcolor-gray {background-color: #999999}
 .bgcolor-white {background-color: #FFFFFF}
</style>

	<script type="text/javascript">
		
		document.domain = 'lghausys.com';
        
		Rui.onReady(function() {
            /*******************
             * 변수 및 객체 선언
             *******************/
            
            var dm = new Rui.data.LDataSetManager();
            
            dm.on('load', function(e) {
            });
            
            dm.on('success', function(e) {
                var data = knldRtrvRqDataSet.getReadData(e);
                
                alert(data.records[0].resultMsg);
                
                if(data.records[0].resultYn == 'Y') {
                	parent.TodoCallBack();
                	//parent.retrieveRequestTodoInfoDialog.cancel();
                }
            });
            
            var apprSbc = new Rui.ui.form.LTextArea({
                applyTo: 'apprSbc',
                placeholder: '결재내용을 입력해주세요.',
                emptyValue: '',
                width: 552,
                height: 75
            });
            
            apprSbc.on('blur', function(e) {
            	apprSbc.setValue(apprSbc.getValue().trim());
            });
            
            var vm = new Rui.validate.LValidatorManager({
                validators:[
                { id: 'apprSbc',				validExp: '결재내용:true:maxByteLength=1000' }
                ]
            });
            
            var knldRtrvRqDataSet = new Rui.data.LJsonDataSet({
                id: 'knldRtrvRqDataSet',
                remainRemoved: true,
                lazyLoad: true,
                fields: [
					  { id: 'rsstDocId' }
					, { id: 'rqDocNm' }
					, { id: 'rtrvRqDocCd' }
					, { id: 'rtrvRqDocNm' }
					, { id: 'docNo' }
					, { id: 'pgmPath' }
					, { id: 'sbcNm' }
					, { id: 'rqApprStCd' }
					, { id: 'rqNm' }
					, { id: 'apprSbc' }
					, { id: 'attcFileId' }
					, { id: 'rgstId' }
					, { id: 'rgstNm' }
					, { id: 'rgstOpsId' }
					, { id: 'rgstOpsNm' }
                ]
            });
            
            knldRtrvRqDataSet.on('load', function(e) {
            	var sbcNm = knldRtrvRqDataSet.getNameValue(0, 'sbcNm');
            	
            	if(Rui.isEmpty(sbcNm) == false) {
            		knldRtrvRqDataSet.setNameValue(0, 'sbcNm', sbcNm.replaceAll('\n', '<br/>'));
            	}
            });
        
            bind = new Rui.data.LBind({
                groupId: 'aform',
                dataSet: knldRtrvRqDataSet,
                bind: true,
                bindInfo: [
                    { id: 'rqDocNm',			ctrlId:'rqDocNm',			value:'html'},
                    { id: 'rtrvRqDocNm',		ctrlId:'rtrvRqDocNm',		value:'html'},
                    { id: 'pgmPath',			ctrlId:'pgmPath',			value:'html'},
                    { id: 'rqNm',				ctrlId:'rqNm',				value:'html'},
                    { id: 'rgstNm',				ctrlId:'rgstNm',			value:'html'},
                    { id: 'rgstOpsNm',			ctrlId:'rgstOpsNm',			value:'html'},
                    { id: 'sbcNm',				ctrlId:'sbcNm',				value:'html'},
                    { id: 'apprSbc',			ctrlId:'apprSbc',			value:'value'}
                ]
            });
            
            /* 조회 요청 승인 */
            approval = function(rqApprStCd) {
                if (vm.validateGroup('aform') == false) {
                    alert(Rui.getMessageManager().get('$.base.msg052') + '\n' + vm.getMessageList().join('\n'));
                    return false;
                }
                
            	if(confirm((rqApprStCd == 'APPR' ? '승인' : '반려') + ' 하시겠습니까?')) {
            		
        	    	knldRtrvRqDataSet.setNameValue(0, 'rqApprStCd', rqApprStCd);
        	    	
                    dm.updateDataSet({
                    	dataSets:[knldRtrvRqDataSet],
                        url:'<c:url value="/knld/mgmt/approvalKnldRtrvRv.do"/>'
                    });
            	}
            };
            
            knldRtrvRqDataSet.load({
                url: '<c:url value="/knld/mgmt/getKnldRtrvRqInfo.do"/>',
                params :{
                	rsstDocId : '<c:out value="${inputData.MW_TODO_REQ_NO}"/>'
                }
            });
			
        });

	</script>
    </head>
    <body>
	<form name="aform" id="aform" method="post" onSubmit="return false;">
		
   		<div class="LblockMainBody">

   			<div class="sub-content">
   				
   				<div class="titArea" style="width:800px;">
   					<div class="LblockButton">
   						<button type="button" class="btn"  id="approvalBtn" name="approvalBtn" onclick="approval('APPR')">승인</button>
   						<button type="button" class="btn"  id="rejectBtn" name="rejectBtn" onclick="approval('REJ')">반려</button>
   					</div>
   				</div>
	   			
   				<table class="table table_txt_right" style="width:800px;">
   					<colgroup>
   						<col style="width:100px;"/>
   						<col style="width:300px;"/>
   						<col style="width:100px;"/>
   						<col style="width:300px;"/>
   					</colgroup>
   					<tbody>
   						<tr>
   							<th align="right">문서명</th>
   							<td><span id="rqDocNm"/></td>
   							<th align="right">문서종류</th>
   							<td><span id="rtrvRqDocNm"/></td>
   						</tr>
   						<tr>
   							<th align="right">경로</th>
   							<td><span id="pgmPath"/></td>
   							<th align="right">요청자</th>
   							<td><span id="rqNm"/></td>
   						</tr>
   						<tr>
   							<th align="right">등록자</th>
   							<td><span id="rgstNm"/></td>
   							<th align="right">등록자부서</th>
   							<td><span id="rgstOpsNm"/></td>
   						</tr>
   						<tr>
   							<th align="right">요청내용</th>
   							<td colspan="3"><span id="sbcNm"/></td>
   						</tr>
   						<tr>
   							<th align="right">결재내용</th>
   							<td colspan="3">
   								<textarea id="apprSbc"></textarea>
   							</td>
   						</tr>
   					</tbody>
   				</table>
   				
   			</div><!-- //sub-content -->
   		</div><!-- //contents -->
		</form>
    </body>
</html>