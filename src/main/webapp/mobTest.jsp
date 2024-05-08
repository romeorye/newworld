<%@ page language="java" pageEncoding="EUC-KR" contentType="text/html; charset=EUC-KR"%>

<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>



<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=edge" /> 
<%@ include file="/WEB-INF/jsp/include/rui_header.jspf"%>
<title><%=documentTitle%></title>
<!-- CSS -->
<link rel="stylesheet" href="<%=cssPath%>/common.css" type="text/css" />
<script type="text/javascript" src="<%=scriptPath%>/jquery.bgslider.js"></script>
<!-- javascript -->
<script type="text/javascript">
// �α��� ��׶��� �����̵�
$(document).ready(function(){
	$(".loginWrap").bgSlider({
		item:3, 
		interval:"5000", 
		//speed:"1000"
	});
});
</script>

<script language="JavaScript" type="text/javascript">
/*******************************************************************************
* FUNCTION �� : init()
* FUNCTION ��ɼ��� : �ű�
*******************************************************************************/
function init(){

	var sysScn = getCookie("sysScn");		<%--// �ý��۱���--%>
	var xcmkCd = getCookie("xcmkCd");	<%--// �븮���ڵ�--%>
	var eeId = getCookie("eeId");	<%--// ����ھ��̵�--%>
	var pw = "";

	document.loginForm.sysScn.value = sysScn;
	document.loginForm.xcmkCd.value = xcmkCd;
	document.loginForm.eeId.value = eeId;
	document.loginForm.pwd.value = pw;
		  
	if (xcmkCd == "" && eeId == "") {
	  document.loginForm.xcmkCd.focus();
	} else if (xcmkCd != "" && eeId == "") {
	  document.loginForm.eeId.focus();
	} else if (xcmkCd != "" && eeId != "") {
	  document.loginForm.pwd.focus();
	}


}
/*******************************************************************************
* FUNCTION �� : setCookie()
* FUNCTION ��ɼ��� : ��Ű����
*******************************************************************************/
function setCookie(name, value, expiredays) {
	var todayDate = new Date();
	todayDate.setDate(todayDate.getDate() + expiredays)
	document.cookie = name + "=" + escape (value) + "; path=/; expires=" + todayDate.toGMTString() + ";";
}

/*******************************************************************************
* FUNCTION �� : getCookie()
* FUNCTION ��ɼ��� : ��Ű�� �������� 
*******************************************************************************/
function getCookie(name) {
	var found = false;
	var start, end;
	var i = 0;
	
	while(i <= document.cookie.length) {
	start = i;
	end = start + name.length;
	if (document.cookie.substring(start, end) == name) {
	found = true;
	break;
	}
	i++;
	}
	if (found == true) {
	start = end + 1;
	end = document.cookie.indexOf(";", start);
	if (end < start) {
	end = document.cookie.length;
	}
	return document.cookie.substring(start, end);
	}
	return "";
}

<%--/*******************************************************************************
* FUNCTION �� : tryLogin()
* FUNCTION ��ɼ��� : �Է��� ������ ���ο� ��Ű���� �����ϰ�, ������ ������ư�� ���� �ش� �ý��ۿ� �α����� �õ��մϴ�. 
*******************************************************************************/--%>
function tryLogin() {
	//if (! dui.wv.validate($('loginForm')) ) return false;
	
    var inputValidator = new Rui.validate.LValidatorManager({
        validators:[
            //�ʼ��� ���� 4�ڸ��� �Է°���
            { id: 'xcmkCd', validExp:'Length:true:maxLength=18&number'},
            { id: 'eeId', validExp:'Length:true:maxLength=20'}
        ]
    });	
	
    var fieldEl = Rui.get('xcmkCd');
    var fieldE2 = Rui.get('eeId');
    
    var value1 = fieldEl.getValue();
    var value2 = fieldE2.getValue();
    //var value3 = fieldE3.getValue();
    
    //alert(value1 + " : " + value2 + " : " + value3+ " : " + document.loginForm.pwd.value);
    //alert(value3.getByteLength() + " : " + document.loginForm.pwd.value.getByteLength());
    
    var result1 = inputValidator.validateField('xcmkCd', value1);
    var result2 = inputValidator.validateField('eeId', value2);
    
    //alert(result1 + " : " + result2 + " : " + result3);
    
    if(!result1.isValid){
    	//alert('1-false');
        fieldEl.invalid();
        Rui.alert('�븮���ڵ�� ' + result1.messages.join('<BR/>'));
        document.loginForm.xcmkCd.clicked();
        return ;
    }else {
    	//alert('1-true');
        fieldEl.valid();
    }
    if(!result2.isValid){
    	//alert('2-false');
        fieldE2.invalid();
        Rui.alert('���̵�� ' + result2.messages.join('<BR/>'));
        document.loginForm.eeId.focus();
        return ;
    }else {
    	//alert('2-true');
        fieldE2.valid();
    }
    
   	    
   	    
	/*	��Ű �� ���� ���� */
	setCookie("xcmkCd", document.loginForm.xcmkCd.value, 365);
	setCookie("eeId", document.loginForm.eeId.value, 365); 
	setCookie("sysScn", "T", 365);
	
	//alert('tryLogin step2');
	
	/*	*/
	
	var url = window.location.hostname;
	var sysScn = "";
	
	if(url == "wins.lghausys.com" || url == "wins-l.lghausys.com" ||url == "wins-o.lghausys.com"){ 
		sysScn = "OA";
	}else {
		sysScn = "DEV";
	}
	
	/* �űԷα� ���� */
	//actSubmit(document.loginForm, "<c:url value="/common/login/tryIrisLogin.mo"/>");
	document.loginForm.method = "post";
	document.loginForm.action = "<c:url value="/mob/system/NwinsMobSystem/mobLogin.mo"/>";
	document.loginForm.submit();

}

function checkCapsLock(e) {
	var myKeyCode=0;
	var myShiftKey=false;
	
	
	<%--// Internet Explorer 4+--%>
	if ( document.all ) {
	  myKeyCode=e.keyCode;
	  myShiftKey=e.shiftKey;
	<%--// Netscape 4--%>
	} else if ( document.layers ) {
	  myKeyCode=e.which;
	  myShiftKey=( myKeyCode == 16 ) ? true : false;
	<%--// Netscape 6--%>
	} else if ( document.getElementById ) {
	  myKeyCode=e.which;
	  myShiftKey=( myKeyCode == 16 ) ? true : false;
	}
	
	<%--// Upper case letters are seen without depressing the Shift key, therefore Caps Lock is on--%>
	if ( ( myKeyCode >= 65 && myKeyCode <= 90 ) && !myShiftKey ) {
		fnShowCapsLockMsg();
	<%--// Lower case letters are seen while depressing the Shift key, therefore Caps Lock is on--%>
	} else {
		fnHiddenCapsLockMsg();
	}

}
function fnCapsDown(e){
	var myKeyCode=0;
	myKeyCode=e.keyCode;
	
	if(myKeyCode == 20){
		fnHiddenCapsLockMsg();
	}
}
function fnShowCapsLockMsg(){
	var divCapsLock = document.getElementById("capsLock");
	divCapsLock.style.display = "block";
}

function fnHiddenCapsLockMsg(){
	var divCapsLock = document.getElementById("capsLock");
	divCapsLock.style.display = "none";
} 

function setUserInfo(str){
	var info = str.split("|");
	var frm = document.loginForm
	with(frm){
		xcmkCd.value = info[0];
		eeId.value = info[1];
		pwd.value = info[2];
	}
	tryLogin();
}

</script>


</head>
<body class="body-login" onload="init();">
<Tag:saymessage/>
	<form name="woasisForm" id="woasisForm" method="post">	<%--<!-- �����ƽý� �α��� �Ķ���� ���߱� ���� �� -->--%>
		<input type="hidden" name="xcmk_cd" id="xcmk_cd"/>
		<input type="hidden" name="login_id" id="login_id"/>
		<input type="hidden" name="pwd" id="pwd"/>
	</form>

<div class="wrap-login">
	<div class="header h-login">
		<div class="header_inner">
			<h1 class="logo">WINS PMS</h1>
		</div>
	</div><!-- //header -->

	<div class="loginBg">
		<div class="loginWrap">
			<div class="loginArea">
				<div class="loginTop">
		<form name="loginForm" id="loginForm" method="post" onSubmit="tryLogin()">
		    <input type="hidden" name="sysScn" id="sysScn" value="T">				
					<h2>LOGIN</h2>
					<p class="welcome">WINS(MOBILE)�� ���� ���� ȯ���մϴ�.</p>
					<div class="inputArea">
				<label class="inputCode"><input name="xcmkCd" id="xcmkCd" type="text" placeholder="�븮�� �ڵ�" class="inpLogin" onkeypress="if(event.keyCode == 13){tryLogin();}" onfocus="this.select();"></label>
				<label class="inputId"><input  name="eeId" id="eeId" type="text" placeholder="���̵�" class="inpLogin" onkeypress="if(event.keyCode == 13){tryLogin();}" style="ime-mode:disabled" onfocus="this.select();"></label>
				<%--
				<label class="inputPw"><input type="password" name="pwd" id="pwd" placeholder="��й�ȣ" class="inpLogin" onkeypress="if(event.keyCode == 13){tryLogin();};checkCapsLock(event);" onkeydown="fnCapsDown(event);" onfocus="this.select();"></label>
				<input type="hidden" id="phoneNum" name="phoneNum" value="01190877746">
				 --%>
				<label class="inputPw"><input type="text" name="phoneNum" id="phoneNum" placeholder="��ȭ��ȣ" class="inpLogin" onkeypress="if(event.keyCode == 13){tryLogin();};checkCapsLock(event);" onkeydown="fnCapsDown(event);" onfocus="this.select();" value="01190877746"></label>
				<input type="hidden" id="pwd" name="pwd" value="12345">				 
					</div>
					<a href="javascript:tryLogin();" class="loginBtn">�α���</a>
       </form>						
       <div id="capsLock"  style="display:none;position:absolute; left:475px; top: 375px;"><img src="<%=imagePath%>/common/capslock_alert.gif"/></div>
				</div>
				<ul class="loginBottom">
					<li>
						�ý��۹��� :
						<span class="num">02-6930-1395</span>
						<span class="num">02-6930-1396</span>
					</li>
					<li>
						Explorer 11.0�� ����ȭ �Ǿ� �ֽ��ϴ�.
					</li>
				</ul>
			</div>
		</div>
	</div>
    


	<div class="footer f-login">
		<div class="inner">
			<div class="copyright">
				<p >COPYRIGHT 2010 BY LG HAUSYS,LTD ALL RIGHT RESERVED.</p>
			</div>

		</div>
	</div><!-- //footer -->
</div>
</body>

</html>

