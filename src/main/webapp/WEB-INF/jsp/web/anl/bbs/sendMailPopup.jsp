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
	var anlBbsRgstDataSet;
	var userIds   = '<c:out value="${inputData.userIds}"/>';
	var userNames = '<c:out value="${inputData.userNames}"/>';
	var userMails = '<c:out value="${inputData.userMails}"/>';
	var bbsTitl = '<c:out value="${inputData.bbsTitl}"/>';

	/* [폼] 메일폼 */
	var lfMailForm = new Rui.ui.form.LForm('mailForm');
	
    var bbsSbc = new Rui.ui.form.LTextArea({
        applyTo: 'bbsSbc'
    });

	/* [팝업텍스트박스] 수신자조회 */
	var lptbSendSaNames = new Rui.ui.form.LPopupTextBox({
        applyTo: 'sendSaNames',
        width: 450,
        editable: false,
        placeholder: '수신자를 선택해주세요.',
        emptyValue: '',
        enterToPopup: true
    });
	
    <%-- DATASET --%>
    anlBbsRgstDataSet = new Rui.data.LJsonDataSet({
        id: 'anlBbsRgstDataSet',
        remainRemoved: true,
        lazyLoad: true,
        fields: [
   		      { id: 'bbsId' }       /*게시판ID*/
   			, { id: 'bbsCd' }       /*분석게시판코드*/
   			, { id: 'bbsNm' }       /*게시판명*/
   			, { id: 'bbsTitl'}      /*게시판제목*/
   			, { id: 'bbsSbc' }      /*게시판내용*/
   			, { id: 'rgstId' }      /*등록자ID*/
   			, { id: 'rgstNm' }      /*등록자이름*/
   			, { id: 'rtrvCt' }      /*조회건수*/
   			, { id: 'bbsKwd' }      /*키워드*/
   			, { id: 'attcFilId' }   /*첨부파일ID*/
   			, { id: 'docNo' }       /*문서번호*/
   			, { id: 'anlBbsCd' }       /*SOP번호*/
   			, { id: 'anlTlcgClNm' } /*분석기술정보분류이름*/
   			, { id: 'qnaClCd' }     /*질문답변구분코드*/
   			, { id: 'qnaClNm' }     /*질문답변구분이름*/
   			, { id: 'frstRgstDt'}   /*등록일*/
   			, { id: 'delYn' }       /*삭제여부*/
	  		]
    });
    
    anlBbsRgstDataSet.on('load', function(e) {
        if(anlBbsRgstDataSet.getNameValue(0, "bbsId")  != "" ||  anlBbsRgstDataSet.getNameValue(0, "bbsId")  !=  undefined ){
			CrossEditor.SetBodyValue( anlBbsRgstDataSet.getNameValue(0, "bbsSbc") );
		}
    });
    
    /* [DataSet] bind */
    var anlBbsRgstBind = new Rui.data.LBind({
        groupId: 'mailForm',
        dataSet: anlBbsRgstDataSet,
        bind: true,
        bindInfo: [
              { id: 'bbsTitl',    ctrlId: 'bbsTitl',    value: 'value' }
            , { id: 'bbsSbc',     ctrlId: 'bbsSbc',     value: 'value' }
            , { id: 'docNo',      ctrlId: 'docNo',      value: 'value' }
            , { id: 'anlBbsCd',   ctrlId: 'anlBbsCd',   value: 'value' }
            , { id: 'txtAnlBbsCd',   ctrlId: 'txtAnlBbsCd',   value: 'value' }
            , { id: 'attcFilId',  ctrlId: 'attcFilId',  value: 'value' }
            , { id: 'bbsKwd',     ctrlId: 'bbsKwd',     value: 'value' }
            , { id: 'rgstNm',     ctrlId: 'rgstNm',     value: 'html' }     //등록자
            , { id: 'frstRgstDt', ctrlId: 'frstRgstDt', value: 'html' }     //등록일

        ]
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
		
		if( Rui.isEmpty(lptbSendSaNames.getValue())){
			Rui.alert("수신자를 입력하여 주세요.");
			lptbSendSaNames.focus();
			return false;
		}
		
		if( Rui.isEmpty(ltbMailTitle.getValue())){
			Rui.alert("제목을 입력하여 주세요.");
			ltbMailTitle.focus();
			return false;
		}
		
		// 에디터 valid
 		if(CrossEditor.GetBodyValue()=="" || CrossEditor.GetBodyValue()=="<p><br></p>"){
 		    alert("내용을 입력해 주세요!!");
 		    CrossEditor.SetFocusEditor(); // 크로스에디터 Focus 이동
 		    return false;
 		}
		
		Rui.confirm({
 			text: '메일을 발송하시겠습니까?',
 	        handlerYes: function() {
 	        	dmSendMail.updateForm({
 	        	    url: "<c:url value='/anl/bbs/sendMail.do'/>"
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
    	
		var bbsId = '${inputData.bbsId}';

        /* 상세내역 가져오기 */
        getAnlBbsInfo = function() {
            anlBbsRgstDataSet.load({
                 url: '<c:url value="/anl/bbs/getAnlBbsInfo.do"/>',
                 params :{
                     bbsId : bbsId
                 }
             });
        };

        getAnlBbsInfo();

    };
    
    onInit();
    
});	// end RUI on load

</script>
    </head>
    <body>
    	<div class="titArea" style="padding-top : 0;">
			<div class="LblockButton">
				<button type="button" id="butClear" name="butClear">초기화</button>
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
								<textarea id="bbsSbc" name="bbsSbc"></textarea>
									<script type="text/javascript" language="javascript">
										var CrossEditor = new NamoSE('bbsSbc');
										CrossEditor.params.Width = "100%";
										CrossEditor.params.UserLang = "auto";
										CrossEditor.params.Font = fontParam;

										var uploadPath = "<%=uploadPath%>";
										CrossEditor.params.ImageSavePath = uploadPath+"/anl";
										CrossEditor.params.FullScreen = false;
										CrossEditor.params.Height = 320;
										CrossEditor.EditorStart();
										
										function OnInitCompleted(e){
											e.editorTarget.SetBodyValue(document.getElementById("bbsSbc").value);
										}
									</script>

						</td>
					</tr>
				</tbody>
			</table>
		</form>
	
    </body>
</html>