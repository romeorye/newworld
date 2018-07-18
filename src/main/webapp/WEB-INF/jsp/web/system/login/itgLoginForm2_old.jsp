<%--
/*------------------------------------------------------------------------------
 * NAME : loginForm.java
 * DESC : 로그인화면
 * VER  : V1.0
 * PROJ : LG CNS 창호완성창시스템 프로젝트
 * Copyright 2010 LG CNS All rights reserved
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG                       
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION                        
 * ----------  ------  --------------------------------------------------------- 
 * 2010/02/17  jdi     
 * 2010/03/20   parkey14	WOASIS, WINS 통합 로그인 화면 구성              
 * 2010/04/14 	parkey14	쿠키설정. 웹오아시스 로그인 연결
 *------------------------------------------------------------------------------*/
--%>

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
<head>
<%@ include file="/WEB-INF/jsp/include/header.jspf"%>
<title><%=documentTitle%></title>
<link rel="stylesheet" type="text/css" href="<%=duiPathCss%>/login.css" />

<script language="JavaScript" type="text/javascript">

<%--/*******************************************************************************
* FUNCTION 명 : init(페이지초기화)
* FUNCTION 기능설명 : 쿠키에 저장되어 있는  시스템구분, 대리점코드, 사용자 아이디를 가져와 세팅해줍니다. 
*******************************************************************************/--%>
function init(){
	  var sysScn = "<%=data.get("sysScn")%>";		<%--// 시스템구분--%>
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

		  if(sysScn == 'W'){
			  document.loginForm.sysScn[1].checked = true;
		  } else {
			  document.loginForm.sysScn[0].checked = true;
		  }
		  
		  fnSetTextColor();
			  
		  if (xcmkCd == "" && eeId == "") {
		    document.loginForm.xcmkCd.focus();
		  } else if (xcmkCd != "" && eeId == "") {
		    document.loginForm.eeId.focus();
		  } else if (xcmkCd != "" && eeId != "") {
		    document.loginForm.pwd.focus();
		  }
		  tryLogin();
	  }else{
		  if(sysScn == 'W'){
			  document.loginForm.sysScn[1].checked = true;
		  } else {
			  document.loginForm.sysScn[0].checked = true;
		  }
		  
		  fnSetTextColor();
			  
		  if (xcmkCd == "" && eeId == "") {
		    document.loginForm.xcmkCd.focus();
		  } else if (xcmkCd != "" && eeId == "") {
		    document.loginForm.eeId.focus();
		  } else if (xcmkCd != "" && eeId != "") {
		    document.loginForm.pwd.focus();
		  }
	  }


	}

function fnSetTextColor(){
	var sysScn = document.loginForm.sysScn;
	if(sysScn[1].checked){
		alert("WINS만 사용가능합니다.");
		sysScn[0].checked = true;
		return false;
	}
	for(var i=0; i<sysScn.length ; i++) {
		if(sysScn[i].checked){
			eval("sysText_"+ sysScn[i].value +".innerHTML='<font color=#222222>"+ rt_systemName(sysScn[i].value) +"</font>'");
		} else {
			eval("sysText_"+ sysScn[i].value +".innerHTML='<font color=#a0a0a0>"+ rt_systemName(sysScn[i].value) +"</font>'");
		}
	}
}

function rt_systemName(val) {

	var msg = '';
	switch (val) {
	case 'T' :
		msg = "윈스";
		break;
	case 'W' :
		msg = "웹오아시스";
		break;
	}
	return msg;
}

<%--/*******************************************************************************
* FUNCTION 명 : tryLogin()
* FUNCTION 기능설명 : 입력한 값으로 새로운 쿠키값을 설정하고, 선택한 라디오버튼에 따라 해당 시스템에 로그인을 시도합니다. 
*******************************************************************************/--%>
function tryLogin() {
	if (! dui.wv.validate($('loginForm')) ) return false;
	
    if (document.loginForm.sysScn[0].checked) {				<%--// 윈스 로그인시 --%>

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

		//actSubmit(document.loginForm, "<c:url value='/user/login_Navi/tryTwmsReLogin.dev'/>");
		actSubmit(document.loginForm, "<c:url value="/common/login/tryTwmsReLogin.do"/>");
	} else if (document.loginForm.sysScn[1].checked) {	<%--// 웹오아시스 로그인시--%>
		
		document.woasisForm.xcmk_cd.value = document.loginForm.xcmkCd.value;
		document.woasisForm.login_id.value = document.loginForm.eeId.value;
		document.woasisForm.pwd.value = document.loginForm.pwd.value;
		
		<%--//alert("통합 로그인 준비중입니다.");--%>
		<%--//개발--%>
		<%--//actSubmit(document.woasisForm, "<c:url value='http://165.244.161.97:9092/lgchem.woasis.system.chkUser.laf'/>");--%>
		<%--//운영--%>
		actSubmit(document.woasisForm, "<c:url value=' http://weboasis.lghausys.com/lgchem.woasis.system.chkUser.laf'/>");
	}
}

<%--/*******************************************************************************
* FUNCTION 명 : tryLoginInt()
* FUNCTION 기능설명 : 입력한 값으로 새로운 쿠키값을 설정하고, 선택한 라디오버튼에 따라 해당 시스템에 로그인을 시도합니다. 
*******************************************************************************/--%>
function tryLoginInt() {
	if (! dui.wv.validate($('loginForm')) ) return false;
	
    if (document.loginForm.sysScn[0].checked) {				<%--// 윈스 로그인시 --%>
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
		actSubmit(document.loginForm, "<c:url value="/common/login/tryIrisLogin.do"/>");
		
	} else if (document.loginForm.sysScn[1].checked) {	<%--// 웹오아시스 로그인시--%>
		
		document.woasisForm.xcmk_cd.value = document.loginForm.xcmkCd.value;
		document.woasisForm.login_id.value = document.loginForm.eeId.value;
		document.woasisForm.pwd.value = document.loginForm.pwd.value;
		
		<%--//alert("통합 로그인 준비중입니다.");--%>
		<%--//개발--%>
		actSubmit(document.woasisForm, "<c:url value='http://165.244.161.97:9092/lgchem.woasis.system.chkUser.laf'/>");
		<%--//운영--%>
		<%--//actSubmit(document.woasisForm, "<c:url value=' http://weboasis.lghausys.com/lgchem.woasis.system.chkUser.laf'/>");--%>
	}
}

<%--/*******************************************************************************
* FUNCTION 명 : linkie7()
* FUNCTION 기능설명 : 익스플로러 7.0 다운로드 링크 2010.06.14 추가
*******************************************************************************/--%>
function linkie7(){
	var frm = document.loginForm
	frm.method = 'post';	
	frm.action = contextPath+"/upload/util/IE7-WindowsXP-x86-kor.exe";
	<%--//frm.action = "http://www.microsoft.com/korea/windows/internet-explorer/ie7.aspx";--%>
	<%--//frm.target = '_blank'--%>
	frm.submit();
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

<body style="overflow-y:hidden;" class="LblockLogin_totalback" onload="init();"> 
	<form name="woasisForm" id="woasisForm" method="post">	<%--<!-- 웹오아시스 로그인 파라미터 맞추기 위한 폼 -->--%>
		<input type="hidden" name="xcmk_cd" id="xcmk_cd"/>
		<input type="hidden" name="login_id" id="login_id"/>
		<input type="hidden" name="pwd" id="pwd"/>
	</form>
	<div id="wrap">
		<div id="login_total">
			<div class="top"></div>  
			<div class="flash">
				<object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=7,0,19,0" width="722" height="284">
					<param name="movie" value="<%=imagePath%>/flash1/login_WINGallery.swf">
					<param name="quality" value="high">
					<embed src="<%=imagePath%>/flash1/login_WINGallery.swf" quality="high" pluginspage="http://www.macromedia.com/go/getflashplayer" type="application/x-shockwave-flash" width="722" height="284"></embed>
				</object>
			</div>
			
			<form name="loginForm" id="loginForm" method="post" onSubmit="tryLoginInt()" autocomplete="off">
				<div class="body">
					<div class="loginBox">
						<input type="radio" id="sysT" class="radio" name="sysScn" value="T" onclick="fnSetTextColor();"/><span id="sysText_T" onclick="document.loginForm.sysScn[0].click();"></span>
						<input type="radio" id="sysW" class="radio" name="sysScn" value="W" onclick="fnSetTextColor();"/><span id="sysText_W" onclick="document.loginForm.sysScn[1].click();"></span><span style="padding-right:5px;"></span>
						<%--<!-- 대리점코드 -->--%><span class="boldtext">대리점코드</span><input value="" name="xcmkCd" id="xcmkCd" autocomplete="off" type="text" class="input WV:대리점코드:true:maxLength=18&number" onkeypress="if(event.keyCode == 13){tryLoginInt();}" onfocus="this.select();"/>
						<%--<!-- 아이디 -->--%><span class="boldtext">아이디</span><input name="eeId" id="eeId" autocomplete="off" type="text" class="input WV:아이디:true:maxLength=20" value="" onkeypress="if(event.keyCode == 13){tryLoginInt();}" style="ime-mode:disabled" onfocus="this.select();"/>
						<%--<!-- 비밀번호 -->--%><span class="boldtext">비밀번호</span><input name="pwd" id="pwd" type="password" class="input WV:비밀번호:true:maxLength=30" value="" onkeypress="if(event.keyCode == 13){tryLoginInt();};checkCapsLock(event);" onkeydown="fnCapsDown(event);" onfocus="this.select();"/><span style="padding-right:5px;"></span>
						<%--<!-- 버튼 -->--%><img src="<%=imagePath%>/login_btn.gif" class="btn" style="cursor:hand;" onClick="javascript:tryLoginInt();"/>
					    <span class="boldtext" style="margin-left:3px;"> 시스템 문의: 02-6930-1395, 02-6930-1396</span>
					    <input name="UseSession" id="UseSession" type="hidden" value=""/>
					</div>
					<div id="capsLock"  style="display:none;position:absolute; left:475px; top: 375px;"><img src="<%=imagePath%>/capslock_alert.gif"/></div>
				</div>
			
				<div class="footer">    
					<span style="float:right;margin-right:18px;"><img src="<%=imagePath%>/btn_login_ie7D.gif" style="cursor:hand;" onClick="javascript:linkie7();"/></span>
					<span style="float:right;margin:4px 5px 0 2px;"> * Explorer 7.0 에 최적화 되어 있습니다. </span>
				</div>
			</form>
		</div>
	</div>

</body>
</html>
				