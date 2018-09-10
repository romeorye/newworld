<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*,
				 java.util.*,
				 devonframe.util.NullUtil,
				 devonframe.util.DateUtil"%>
<%--
/*
 *************************************************************************
 * $Id      : sendMailPopup.jsp
 * @desc    : 메일전송 팝업
 *------------------------------------------------------------------------
 * VER  DATE        AUTHOR      DESCRIPTION
 * ---  ----------- ----------  -----------------------------------------
 * 1.0  2017.09.08  IRIS04      최초생성
 * ---  ----------- ----------  -----------------------------------------
 * IRIS 구축 프로젝트
 *************************************************************************
 */
--%>

<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<%@ include file="/WEB-INF/jsp/include/rui_header.jspf"%>

<title><%=documentTitle%></title>

<script type="text/javascript">
Rui.onReady(function() {
	var receiverNameList = [];
	var receiverMailList = [];
	
	var userIds   = '<c:out value="${inputData.userIds}"/>';
	var userNames = '<c:out value="${inputData.userNames}"/>';
	var userMails = '<c:out value="${inputData.userMails}"/>';
	var bbsTitl = '<c:out value="${inputData.bbsTitl}"/>';

	/* [폼] 메일폼 */
	var lfMailForm = new Rui.ui.form.LForm('mailForm');
	
	/* [팝업텍스트박스] 수신자조회 */
	var lptbSendSaNames = new Rui.ui.form.LPopupTextBox({
        applyTo: 'sendSaNames',
        width: 450,
        editable: false,
        placeholder: '수신자를 선택해주세요.',
        emptyValue: '',
        enterToPopup: true
    });
	
	lptbSendSaNames.on('popup', function(e){
    	parent.openUserSearchDialog(setMailUsersInfo, 10, $('#sendSaNames').val());
    });
	
	/* [텍스트박스] 제목 */
	var ltbMailTitle = new Rui.ui.form.LTextBox({
	     applyTo : 'mailTitle',
	     placeholder : '',
	     emptyValue: '',
	     width : 450
	});
	
    /* [텍스트AREA] 내용 */
    var ltaMailText = new Rui.ui.form.LTextArea({
 	   applyTo: 'mailText',
 	   placeholder: '',
 	   width: 450,
 	   height: 300
	});

    /* [버튼] 초기화 */
	var lbutClear = new Rui.ui.LButton('butClear');
	lbutClear.on('click', function() {
		
		lfMailForm.reset();
		var hiddenInputSetArr = Rui.get('mailForm').select('input[type=hidden]');
	    for(var i=0; i< hiddenInputSetArr.length; i++){
	    	var hiddenInputSet = hiddenInputSetArr.getAt(i);
	    	hiddenInputSet.setValue('');
	    }
	    
	});
	
	/* [버튼] 발송 */
	var lbutSend = new Rui.ui.LButton('butSend');
	lbutSend.on('click', function() {
		var dmSendMail = new Rui.data.LDataSetManager();
		
		Rui.confirm({
 			text: '메일을 발송하시겠습니까?',
 	        handlerYes: function() {
 	        	dmSendMail.updateForm({
 	        	    url: "<c:url value='/prj/mm/mail/sendMail.do'/>"
 	        	  , form: 'mailForm'
 	        	  , params: {
 	        		    receiverNameList : receiverNameList
 	        	      , receiverMailList : receiverMailList
 	        	    }
 	        	});
 	        }
	    });
		
		dmSendMail.on('success', function(e) {
			var data = Rui.util.LJson.decode(e.responseText);
            Rui.alert(data[0].records[0].rtnMsg);

            if(parent._mailDialog != null){
            	parent._mailDialog.submit(true);
            }
		});
		dmSendMail.on('failure', function(e) {
			var data = Rui.util.LJson.decode(e.responseText);
            Rui.alert(data[0].records[0].rtnMsg);
		});
	});
	
	/*[함수] 수신자 콜백세팅 */
	var setMailUsersInfo = function(userList) {
    	var idList = [];
    	var nameList = [];
    	var emailList = [];
    	
    	for(var i=0, size=userList.length; i<size; i++) {
    		idList.push(userList[i].saUser);
    		nameList.push(userList[i].saName);
    		emailList.push(userList[i].saMail);
    	}
    	
    	// 데이터 세팅
    	lptbSendSaNames.setValue(nameList.join(', '));
    	receiverNameList = nameList;
    	receiverMailList = emailList;
    	
    	$('#sendSaNames').val(idList);
    };
    
    /* [함수] 화면초기화 */
    onInit = function(){
        // inputParameter 데이터세팅
    	receiverNameList = userNames.split(',');
    	receiverMailList = userMails.split(',');
    	lptbSendSaNames.setValue(userNames);
    	$('#sendSaNames').val(userIds);

    };
    
    onInit();
});	// end RUI on load

</script>
    </head>
    <body>
    	<div class="titArea" style="padding-top : 0;">
			<div class="LblockButton">
				<button type="button" id="butClear" name="butClear">초기화1</button>
				<button type="button" id="butSend" name="butSend">발송</button>
			</div>
		</div>
		<form name="mailForm" id="mailForm" method="post">
			<input type="hidden" id="hSenderEmail" name="hSenderEmail" value="<c:out value='${inputData._userEmail}'/>"/>
			<input type="hidden" id="hSenderName" name="hSenderName" value="<c:out value='${inputData._userNm}'/>"/>
			<table class="table table_txt_right">
				<colgroup>
					<col style="width:20%;"/>
					<col style="width:80%;"/>
				</colgroup>
				<tbody>
					<tr>
						<th align="right">수신자</th>
						<td>
							<div id="sendSaNames"></div>
						</td>
					</tr>
					<tr>
						<th align="right">제목</th>
						<td>
							<input type="text" id="mailTitle" value="<c:out value='${inputData.bbsTitl}'/>"/>
						</td>
					</tr>
					<tr>
						<th align="right">내용</th>
						<td>
							<textarea id="mailText"><c:out value='${inputData.bbsSbc}' escapeXml="false"/>
							                        <c:out value='${inputData.bbsSbc}'/></textarea>
							
						</td>
					</tr>
				</tbody>
			</table>
		</form>
	
    </body>
</html>