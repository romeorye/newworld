<%@ page language="java" pageEncoding="EUC-KR" contentType="text/html; charset=EUC-KR"%>
<%@ page import="java.util.*" %>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>
<%
    //LData data = (LData)LActionContext.getAttribute("data");
	//LMultiData useSession = (LMultiData)LActionContext.getAttribute("UseSession");
	
	HashMap data = (HashMap)request.getAttribute("data");
	ArrayList useSession = (ArrayList)request.getAttribute("UseSession");
	
	//System.out.println("data => " + data);
	//System.out.println("useSession => " + useSession);
	
	String useSess = "";
//	out.println("size:"+useSession.getDataCount()+"<br>");
    
	for(int i=0; i < useSession.size(); i++){
		HashMap sess = (HashMap)useSession.get(i);
		if(i==0){
			useSess = sess.get("UseSession").toString();
		}else{
			useSess = useSess + "," + sess.get("UseSession").toString();
		}
	}
    
	
%>

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
	  var sysScn = "T";		<%--// 시스템구분--%>
	  var xcmkCd = "<%=data.get("xcmkCd")%>";	<%--// 대리점코드--%>
	  var eeId = "<%=data.get("eeId")%>";	<%--// 사용자아이디--%>
	  var pwd = "<%=data.get("pwd")%>";	  
	  var sess = "<%=useSess%>";

	  if(confirm("<spring:message code='msg.alert.login.already'/>")){
		  document.loginForm.sysScn.value = sysScn;
		  document.loginForm.xcmkCd.value = xcmkCd;
		  document.loginForm.eeId.value = eeId;
		  document.loginForm.pwd.value = pwd;
		  document.loginForm.UseSession.value = sess;
		  
			  
		  if (xcmkCd == "" && eeId == "") {
		    document.loginForm.xcmkCd.focus();
		  } else if (xcmkCd != "" && eeId == "") {
		    document.loginForm.eeId.focus();
		  } else if (xcmkCd != "" && eeId != "") {
		    document.loginForm.pwd.focus();
		  }
		  //alert("tryLogin()");
		  tryLogin();
	  }else{
			  
		  if (xcmkCd == "" && eeId == "") {
		    document.loginForm.xcmkCd.focus();
		  } else if (xcmkCd != "" && eeId == "") {
		    document.loginForm.eeId.focus();
		  } else if (xcmkCd != "" && eeId != "") {
		    document.loginForm.pwd.focus();
		  }
	  }


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
        Rui.alert();        
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
	
  if (true) {				<%--// 윈스 로그인시 --%>

    	var url = window.location.hostname;
	  	var sysScn = "";
	
	  	if(url == "wins.lghausys.com" || url == "wins-l.lghausys.com" ||url == "wins-o.lghausys.com"){ 
	  		sysScn = "OA";
	  	}else {
	  		sysScn = "DEV";
	  	}
	  	
	  	//alert(sysScn);

		if(document.loginForm.xcmkCd.value == "1078718122"){
			
			if(url != "wins-l.lghausys.com" && sysScn == "OA"){
				alert("LG 사용자인 경우  다음 URL로 접근 하시기 바랍니다.\nhttp://wins-l.lghausys.com");
				parent.location.href = "http://wins-l.lghausys.com";
				return;
			}
		}else if(document.loginForm.xcmkCd.value == "107531" || //(주)그린시스템
				 document.loginForm.xcmkCd.value == "107956" ||	//(주)유진윈시스
				 document.loginForm.xcmkCd.value == "101941" ||	//건일산업(주)
				 document.loginForm.xcmkCd.value == "526371" 	//(주)조은글라스
				 ){
			if(url != "wins-o.lghausys.com" && sysScn == "OA"){
				alert("협력사 사용자인 경우  다음 URL로 접근 하시기 바랍니다.\nhttp://wins-o.lghausys.com");
				parent.location.href = "http://wins-o.lghausys.com";
				return;
			}
		}

		//actSubmit(document.loginForm, "<c:url value='/user/login_Navi/tryTwmsReLogin.dev'/>");
		//actSubmit(document.loginForm, "<c:url value="/common/login/tryTwmsReLogin.do"/>");
		document.loginForm.method = "post";
		document.loginForm.target = "_self";
		document.loginForm.action = "<c:url value="/common/login/tryTwmsReLogin.do"/>";
		
		//alert("action=>"+ "<c:url value="/common/login/tryTwmsReLogin.do"/>");
		
		document.loginForm.submit();		
	} 
}

<%--/*******************************************************************************
* FUNCTION 명 : tryLoginInt()
* FUNCTION 기능설명 : 입력한 값으로 새로운 쿠키값을 설정하고, 선택한 라디오버튼에 따라 해당 시스템에 로그인을 시도합니다. 
*******************************************************************************/--%>
function tryLoginInt() {
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
	
  if (true) {				<%--// 윈스 로그인시 --%>
    	var url = window.location.hostname;
	  	var sysScn = "";
	
	  	if(url == "wins.lghausys.com" || url == "wins-l.lghausys.com" ||url == "wins-o.lghausys.com"){ 
	  		sysScn = "OA";
	  	}else {
	  		sysScn = "DEV";
	  	}
	
		if(document.loginForm.xcmkCd.value == "1078718122"){
			
			if(url != "wins-l.lghausys.com" && sysScn == "OA"){
				alert("LG 사용자인 경우  다음 URL로 접근 하시기 바랍니다.\nhttp://wins-l.lghausys.com");
				parent.location.href = "http://wins-l.lghausys.com";
				return;
			}
		}else if(document.loginForm.xcmkCd.value == "107531" || //(주)그린시스템
				 document.loginForm.xcmkCd.value == "107956" ||	//(주)유진윈시스
				 document.loginForm.xcmkCd.value == "101941" ||	//건일산업(주)
				 document.loginForm.xcmkCd.value == "526371" 	//(주)조은글라스
				 ){
			if(url != "wins-o.lghausys.com" && sysScn == "OA"){
				alert("협력사 사용자인 경우  다음 URL로 접근 하시기 바랍니다.\nhttp://wins-o.lghausys.com");
				parent.location.href = "http://wins-o.lghausys.com";
				return;
			}
		}
	
		//actSubmit(document.loginForm, "<c:url value='/user/login_Navi/tryIrisLogin.dev'/>");
		//actSubmit(document.loginForm, "<c:url value="/common/login/tryIrisLogin.do"/>");
		document.loginForm.method = "post";
		document.loginForm.target = "_self";
		document.loginForm.action = "<c:url value="/common/login/tryIrisLogin.do"/>";
		document.loginForm.submit();
		
		
		
	} 
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

</script>


</head>
<body class="body-login" onload="init();">
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
		<form name="loginForm" id="loginForm" method="post" onSubmit="tryLoginInt();">
		    <input type="hidden" name="sysScn" id="sysScn" value="T">
		    <input name="UseSession" id="UseSession" type="hidden" value=""/>
			<h2>LOGIN</h2>
			<p class="welcome">WINS PMS에 오신 것을 환영합니다.</p>
			<div class="inputArea">
				<label class="inputCode"><input name="xcmkCd" id="xcmkCd" type="text" placeholder="대리점 코드" class="inpLogin" onkeypress="if(event.keyCode == 13){tryLoginInt();}" onfocus="this.select();"></label>
				<label class="inputId"><input  name="eeId" id="eeId" type="text" placeholder="아이디" class="inpLogin" onkeypress="if(event.keyCode == 13){tryLoginInt();}" style="ime-mode:disabled" onfocus="this.select();"></label>
				<label class="inputPw"><input type="password" name="pwd" id="pwd" placeholder="비밀번호" class="inpLogin" onkeypress="if(event.keyCode == 13){tryLoginInt();};checkCapsLock(event);" onkeydown="fnCapsDown(event);" onfocus="this.select();"></label>
			</div>
			<a href="javascript:tryLoginInt();" class="loginBtn">로그인</a>
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

