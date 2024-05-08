<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*,
				 java.util.*,
				 devonframe.util.NullUtil,
				 devonframe.util.DateUtil"%>

<%--
/*
 *************************************************************************
 * $Id		: retrieveRequestInfo.jsp
 * @desc    : 조회 요청 화면
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
                	parent.retrieveRequestInfoDialog.cancel();
                }
            });
            
            var sbcNm = new Rui.ui.form.LTextArea({
                applyTo: 'sbcNm',
                placeholder: '요청내용을 입력해주세요.',
                emptyValue: '',
                width: 690,
                height: 75
            });
            
            sbcNm.on('blur', function(e) {
            	sbcNm.setValue(sbcNm.getValue().trim());
            });
            
            var vm = new Rui.validate.LValidatorManager({
                validators:[
                { id: 'sbcNm',				validExp: '요청내용:true:maxByteLength=4000' }
                ]
            });
            
            var knldRtrvRqDataSet = new Rui.data.LJsonDataSet({
                id: 'knldRtrvRqDataSet',
                remainRemoved: true,
                lazyLoad: true,
                fields: [
					  { id: 'rqDocNm', defaultValue: '<c:out value="${inputData.rqDocNm}"/>' }
					, { id: 'rtrvRqDocCd', defaultValue: '<c:out value="${inputData.rtrvRqDocCd}"/>' }
					, { id: 'rtrvRqDocNm', defaultValue: '<c:out value="${inputData.rtrvRqDocNm}"/>' }
					, { id: 'docNo', defaultValue: '<c:out value="${inputData.docNo}"/>' }
					, { id: 'pgmPath', defaultValue: '<c:out value="${inputData.pgmPath}" escapeXml="false"/>' }
					, { id: 'sbcNm' }
					, { id: 'rqNm', defaultValue: '<c:out value="${inputData._userNm}"/>' }
					, { id: 'rgstId', defaultValue: '<c:out value="${inputData.rgstId}"/>' }
					, { id: 'rgstNm', defaultValue: '<c:out value="${inputData.rgstNm}"/>' }
					, { id: 'rgstOpsId', defaultValue: '<c:out value="${inputData.rgstOpsId}"/>' }
					, { id: 'rgstOpsNm', defaultValue: '<c:out value="${inputData.rgstOpsNm}"/>' }
					, { id: 'docUrl', defaultValue: '<c:out value="${inputData.docUrl}"/>' }
                ]
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
                    { id: 'sbcNm',				ctrlId:'sbcNm',				value:'value'}
                ]
            });
            
            knldRtrvRqDataSet.newRecord();
            
            /* 조회 요청 */
            request = function(type) {
                if (vm.validateGroup('aform') == false) {
                    alert(Rui.getMessageManager().get('$.base.msg052') + '\n' + vm.getMessageList().join('\n'));
                    return false;
                }
                
            	if(confirm('요청 하시겠습니까?')) {
                    dm.updateDataSet({
                    	dataSets:[knldRtrvRqDataSet],
                        url:'<c:url value="/knld/mgmt/requestKnldRtrvRv.do"/>'
                    });
            	}
            };
			
        });

	</script>
    </head>
    <body>
	<form name="aform" id="aform" method="post" onSubmit="return false;">
		
   		<div class="LblockMainBody">

   			<div class="sub-content" style="padding:0; margin-top:-25px;">
   				
   				<div class="titArea" style="width:800px;">
   					<div class="LblockButton">
   						<button type="button" class="btn"  id="requestBtn" name="requestBtn" onclick="request()">요청</button>
   						<button type="button" class="btn"  id="closeBtn" name="closeBtn" onclick="parent.retrieveRequestInfoDialog.cancel()">닫기</button>
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
   							<td colspan="3"><span id="rqDocNm"/></td>
   							<!-- <th align="right">문서종류</th>
   							<td><span id="rtrvRqDocNm"/></td> -->
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
   							<td colspan="3">
   								<textarea id="sbcNm"></textarea>
   							</td>
   						</tr>
   					</tbody>
   				</table>
   				
   			</div><!-- //sub-content -->
   		</div><!-- //contents -->
		</form>
    </body>
</html>