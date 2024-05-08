<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8"%>

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

String.prototype.string = function(len){var s = '', i = 0; while (i++ < len) { s += this; } return s;};
String.prototype.zf = function(len){return "0".string(len - this.length) + this;};
Number.prototype.zf = function(len){return this.toString().zf(len);};
Date.prototype.format = function(f) {
    if (!this.valueOf()) return " ";
 
    var weekName = ["일요일", "월요일", "화요일", "수요일", "목요일", "금요일", "토요일"];
    var d = this;
     
    return f.replace(/(yyyy|yy|MM|dd|E|hh|mm|ss|a\/p)/gi, function($1) {
        switch ($1) {
            case "yyyy": return d.getFullYear();
            case "yy": return (d.getFullYear() % 1000).zf(2);
            case "MM": return (d.getMonth() + 1).zf(2);
            case "dd": return d.getDate().zf(2);
            case "E": return weekName[d.getDay()];
            case "HH": return d.getHours().zf(2);
            case "hh": return ((h = d.getHours() % 12) ? h : 12).zf(2);
            case "mm": return d.getMinutes().zf(2);
            case "ss": return d.getSeconds().zf(2);
            case "a/p": return d.getHours() < 12 ? "오전" : "오후";
            default: return $1;
        }
    });
};



// 로그인 백그라운드 슬라이드
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
* FUNCTION 명 : init()
* FUNCTION 기능설명 : 신규
*******************************************************************************/
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

	var word; 
	 //var version = "N/A"; 
	 var version = "1";
	 var agent = navigator.userAgent.toLowerCase(); 
	 var name = navigator.appName; 

	 // IE old version ( IE 10 or Lower ) 
	 if ( name == "Microsoft Internet Explorer" ) word = "msie "; 
	 else { 
		 // IE 11 
		 if ( agent.search("trident") > -1 ) word = "trident/.*rv:"; 
		 // Microsoft Edge  
		 else if ( agent.search("edge/") > -1 ) word = "edge/"; 
	 } 
     <%--//alert(word);--%>
	 var reg = new RegExp( word + "([0-9]{1,})(\\.{0,}[0-9]{0,1})" ); 
	 if (  reg.exec( agent ) != null  ) version = RegExp.$1 + RegExp.$2; 
	 <%--//alert('version=>'+version);--%>
	
	if(parseInt(version) < 11){
		/* alert('Explorer 11에서만 사용할 수 있습니다.!!');
		return;	 */	
	}


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
					<p class="welcome">WINS에 오신 것을 환영합니다.</p>
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
						<span class="faq1">&nbsp;&nbsp;
							<a href="#" onclick="window.open('<%=contextPath%>/resource/web/popup/faq.html','openFaq', 'width=1030, height=800, top=100, left=100, toolbar=no, directories=no, status=no, resizable=no, scrollbars=yes');"><h1>FAQ 바로가기</h1></a> 
						</span>
					</li>
					<li>
						Explorer 11.0에 최적화 되어 있습니다.
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

