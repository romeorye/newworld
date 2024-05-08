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
<%-- page import="devonframework.front.channel.context.LActionContext, 
				devon.core.collection.LMultiData,
				devon.core.collection.LData" --%>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>

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

	  var sysScn = getCookie("sysScn");		<%--// 시스템구분--%>
	  var xcmkCd = getCookie("xcmkCd");	<%--// 대리점코드--%>
	  var eeId = getCookie("eeId");	<%--// 사용자아이디--%>
	  var pw = "";

	  document.loginForm.sysScn.value = sysScn;
	  document.loginForm.xcmkCd.value = xcmkCd;
	  document.loginForm.eeId.value = eeId;
	  document.loginForm.pwd.value = pw;

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
	  
	  /* 
	clearCookie("sysScn");
	clearCookie("xcmkCd");
	clearCookie("eeId");
	*/	
	document.loginForm.sysScn[0].checked = true;
	fnSetTextColor();
	//document.loginForm.xcmkCd.focus();
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

/*******************************************************************************
* FUNCTION 명 : clearCookie()
* FUNCTION 기능설명 : 쿠키 소멸 날짜를 설정합니다.  
*******************************************************************************/
function clearCookie(name) {
  var expire_date = new Date();
  <%--//어제 날짜를 쿠키 소멸 날짜로 설정한다.--%>
  expire_date.setDate(expire_date.getDate() - 1)
  document.cookie = name + "= " + "; expires=" + expire_date.toGMTString() + "; path=/"
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
/*	쿠키 값 설정 삭제 */
	setCookie("xcmkCd", document.loginForm.xcmkCd.value, 365);
    setCookie("eeId", document.loginForm.eeId.value, 365); 
    /*
    if (document.loginForm.sysScn[0].checked){
	    setCookie("sysScn", "T", 365);
    } else if (document.loginForm.sysScn[1].checked){
    	setCookie("sysScn", "W", 365);
    }
    */
    setCookie("sysScn", "T", 365);
/*	*/
 
  	var url = window.location.hostname;
  	var sysScn = "";

  	if(url == "wins.lghausys.com" || url == "wins-l.lghausys.com" ||url == "wins-o.lghausys.com"){ 
  		sysScn = "OA";
  	}else {
  		sysScn = "DEV";
  	}

    /* 신규로긴 수행 */
  	actSubmit(document.loginForm, "<c:url value="/common/login/tryIrisLogin.do"/>");

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
	frm.submit();;
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

/*
function goDBScriptCreate(){
	var ptrWin = null;
    url ='/sysmgr/createSql_Navi/initTable.dev';
    if(ptrWin != null && !ptrWin.closed) {
        ptrWin.focus();
        return;
    }
    ptrWin = window.open(url, "DBScriptCreate", "height=600,width=680,status=yes,toolbar=yes,menubar=no,location=no");
    ptrWin.focus();
}
*/
</script>

</head>

<body style="overflow-y:hidden;" class="LblockLogin_totalback" onload="init();"> 
<Tag:saymessage/>
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
			
			<form name="loginForm" id="loginForm" method="post" onSubmit="tryLogin()">
				<div class="body">
					<div class="loginBox">
						<input type="radio" id="sysT" class="radio" name="sysScn" value="T" onclick="fnSetTextColor();"/><span id="sysText_T" onclick="document.loginForm.sysScn[0].click();"></span>
						<input type="radio" id="sysW" class="radio" name="sysScn" value="W" onclick="fnSetTextColor();"/><span id="sysText_W" onclick="document.loginForm.sysScn[1].click();"></span><span style="padding-right:5px;"></span>
						<%--<!-- 대리점코드 -->--%><span class="boldtext">대리점코드</span><input value="" name="xcmkCd" id="xcmkCd" autocomplete="off" type="text" class="input WV:대리점코드:true:maxLength=18&number" onkeypress="if(event.keyCode == 13){tryLogin();}" onfocus="this.select();"/>
						<%--<!-- 아이디 -->--%><span class="boldtext">아이디</span><input name="eeId" id="eeId" autocomplete="off" type="text" class="input WV:아이디:true:maxLength=20" value="" onkeypress="if(event.keyCode == 13){tryLogin();}" style="ime-mode:disabled" onfocus="this.select();"/>
						<%--<!-- 비밀번호 -->--%><span class="boldtext">비밀번호</span><input name="pwd" id="pwd" type="password" class="input WV:비밀번호:true:maxLength=30" value="" onkeypress="if(event.keyCode == 13){tryLogin();};checkCapsLock(event);" onkeydown="fnCapsDown(event);" onfocus="this.select();"/><span style="padding-right:5px;"></span>
						<%--<!-- 버튼 -->--%><img src="<%=imagePath%>/login_btn.gif" class="btn" style="cursor:hand;" onClick="javascript:tryLogin();"/>
					    <span class="boldtext" style="margin-left:3px;"> 시스템 문의: 02-6930-1395, 02-6930-1396</span>
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
				