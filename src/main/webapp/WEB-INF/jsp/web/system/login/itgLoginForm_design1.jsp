<%@ page language="java" pageEncoding="EUC-KR" contentType="text/html; charset=EUC-KR"%>

<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>



<html xmlns="http://www.w3.org/1999/xhtml">
<%@ include file="/WEB-INF/jsp/include/rui_header.jspf"%>
<head>
<title><%=documentTitle%></title>
<!-- CSS -->
<link rel="stylesheet" href="<%=cssPath%>/common.css" type="text/css" />
<!-- javascript -->
<script type="text/javascript" src="<%=scriptPath%>/jquery.js"></script>
<script type="text/javascript" src="<%=scriptPath%>/jquery-ui.js"></script>
<script type="text/javascript" src="<%=scriptPath%>/common.js"></script>
<script type="text/javascript" src="<%=scriptPath%>/rand.bg.js"></script>
<script type="text/javascript" src="<%=scriptPath%>/jquery.bgslider.js"></script>

<script type="text/javascript">
// 로그인 백그라운드 슬라이드
$(document).ready(function(){
	$(".loginWrap").bgSlider({
		item:5, 
		interval:"5000", 
		speed:"5000"
	});
});
</script>
<script language="JavaScript" type="text/javascript">

function init(){

	var sysScn = getCookie("sysScn");		<%--// 시스템구분--%>
	var xcmkCd = getCookie("xcmkCd");	<%--// 대리점코드--%>
	var eeId = getCookie("eeId");	<%--// 사용자아이디--%>
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
* FUNCTION 명 : setCookie()
* FUNCTION 기능설명 : 쿠키생성
*******************************************************************************/
function setCookie(name, value, expiredays) {
	var todayDate = new Date();
	todayDate.setDate(todayDate.getDate() + expiredays)
	document.cookie = name + "=" + escape (value) + "; path=/; expires=" + todayDate.toGMTString() + ";";
}

/*******************************************************************************
* FUNCTION 명 : getCookie()
* FUNCTION 기능설명 : 쿠키값 가져오기 
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
* FUNCTION 명 : tryLogin()
* FUNCTION 기능설명 : 입력한 값으로 새로운 쿠키값을 설정하고, 선택한 라디오버튼에 따라 해당 시스템에 로그인을 시도합니다. 
*******************************************************************************/--%>
function tryLogin() {

	//if (! dui.wv.validate($('loginForm')) ) return false;
	
    var inputValidator = new Rui.validate.LValidatorManager({
        validators:[
            //필수로 수자 4자리만 입력가능
            { id: 'xcmkCd', validExp:'Length:true:maxLength=18&number'},
            { id: 'eeId', validExp:'Length:true:maxLength=20'},
            { id: 'pwd', validExp:'Length:true:maxLength=30'}
        ]
    });	
	
    var fieldEl = Rui.get('xcmkCd');
    var fieldE2 = Rui.get('eeId');
    var fieldE3 = Rui.get('pwd');
    
    var value1 = fieldEl.getValue();
    var value2 = fieldE2.getValue();
    //var value3 = fieldE3.getValue();
    var value3 = document.loginForm.pwd.value;
    
    //alert(value1 + " : " + value2 + " : " + value3+ " : " + document.loginForm.pwd.value);
    //alert(value3.getByteLength() + " : " + document.loginForm.pwd.value.getByteLength());
    
    var result1 = inputValidator.validateField('xcmkCd', value1);
    var result2 = inputValidator.validateField('eeId', value2);
    var result3 = inputValidator.validateField('pwd', value3);
    
    //alert(result1 + " : " + result2 + " : " + result3);
    
    if(!result1.isValid){
    	//alert('1-false');
        fieldEl.invalid();
        Rui.alert('대리점코드는 ' + result1.messages.join('<BR/>'));
        document.loginForm.xcmkCd.clicked();
        return ;
    }else {
    	//alert('1-true');
        fieldEl.valid();
    }
    if(!result2.isValid){
    	//alert('2-false');
        fieldE2.invalid();
        Rui.alert('아이디는 ' + result2.messages.join('<BR/>'));
        document.loginForm.eeId.focus();
        return ;
    }else {
    	//alert('2-true');
        fieldE2.valid();
    }
    
    if(!result3.isValid){
    	//alert('3-false');
        fieldE3.invalid();
        Rui.alert('비밀번호는 ' + result3.messages.join('<BR/>'));
        document.loginForm.pwd.focus();
        return ;
    }else {
    	//alert('3-true');
        fieldE3.valid();
    }       
    
    /*
    if( value3.getByteLength() > 0 ) {
	    if(!result3.isValid){
	    	//alert('3-false');
	        fieldE3.invalid();
	        Rui.alert(result3.messages.join('<BR/>'));
	        return ;
	    }else {
	    	//alert('3-true');
	        fieldE3.valid();
	    }    	
    } else {
    	Rui.alert('필수 입력 항목입니다.');
    	//alert('4-false');
        fieldE3.valid();
        return;
    }
    */
	
    //alert('tryLogin step1');	
	//return ;	   	    
   	    
   	    
	/*	쿠키 값 설정 삭제 */
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
	
	/* 신규로긴 수행 */
	//actSubmit(document.loginForm, "<c:url value="/common/login/tryIrisLogin.do"/>");
	document.loginForm.method = "post";
	document.loginForm.action = "<c:url value="/common/login/tryIrisLogin.do"/>";
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
	<form name="woasisForm" id="woasisForm" method="post">	<%--<!-- 웹오아시스 로그인 파라미터 맞추기 위한 폼 -->--%>
		<input type="hidden" name="xcmk_cd" id="xcmk_cd"/>
		<input type="hidden" name="login_id" id="login_id"/>
		<input type="hidden" name="pwd" id="pwd"/>
	</form>

<div class="header h-login">
	<div class="header_inner">
		<h1 class="logo">WINS PMS</h1>
	</div>
</div><!-- //header -->

<div class="loginWrap">
	<div class="loginArea">
		<div class="loginTop">
		<form name="loginForm" id="loginForm" method="post" onSubmit="tryLogin()">
		    <input type="hidden" name="sysScn" id="sysScn" value="T">
			<h2>LOGIN</h2>
			<p class="welcome">WINS PMS에 오신 것을 환영합니다.</p>
			<div class="inputArea">
				<label class="inputCode"><input name="xcmkCd" id="xcmkCd" type="text" placeholder="대리점 코드" class="inpLogin" onkeypress="if(event.keyCode == 13){tryLogin();}" onfocus="this.select();"></label>
				<label class="inputId"><input  name="eeId" id="eeId" type="text" placeholder="아이디" class="inpLogin" onkeypress="if(event.keyCode == 13){tryLogin();}" style="ime-mode:disabled" onfocus="this.select();"></label>
				<label class="inputPw"><input type="password" name="pwd" id="pwd" placeholder="비밀번호" class="inpLogin" onkeypress="if(event.keyCode == 13){tryLogin();};checkCapsLock(event);" onkeydown="fnCapsDown(event);" onfocus="this.select();"></label>
			</div>
			<a href="javascript:tryLogin();" class="loginBtn">로그인</a>
		</form>	
		<div id="capsLock"  style="display:none;position:absolute; left:475px; top: 375px;"><img src="<%=imagePath%>/common/capslock_alert.gif"/></div>
		</div>
		<ul class="loginBottom">
			<li>
				시스템문의 :
				<span class="num">02-6930-1395</span>
				<span class="num">02-6930-1396</span>
			</li>
			<li>
				Explorer 11.0에 최적화 되어 있습니다.
			</li>
		</ul>
	</div>
</div>
    


<div class="footer f-login">
	<div class="inner">
        <div class="copyright">
            <span><a href="#none">개인정보취급방침</a></span><span class="tel">TEL : 080-005-4000 ( 평일 09:00~ 18:00 토, 일요일 및 공휴일 휴무 )</span>
		    <address>서울시 영등포구 국제금융로 10 ONE IFC빌딩 15-19F LG하우시스</address>
            <p >Copyright (C) 2016  All Rights Reserved.</p>
		</div>

	</div>
</div><!-- //footer -->
</body>

</html>

