<%--
/*------------------------------------------------------------------------------
 * NAME : loginForm.java
 * DESC : �α���ȭ��
 * VER  : V1.0
 * PROJ : LG CNS âȣ�ϼ�â�ý��� ������Ʈ
 * Copyright 2010 LG CNS All rights reserved
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG                       
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION                        
 * ----------  ------  --------------------------------------------------------- 
 * 2010/02/17  jdi     
 * 2010/03/20   parkey14	WOASIS, WINS ���� �α��� ȭ�� ����              
 * 2010/04/14 	parkey14	��Ű����. �����ƽý� �α��� ����
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
* FUNCTION �� : init(�������ʱ�ȭ)
* FUNCTION ��ɼ��� : ��Ű�� ����Ǿ� �ִ�  �ý��۱���, �븮���ڵ�, ����� ���̵� ������ �������ݴϴ�. 
*******************************************************************************/--%>
function init(){
	  var sysScn = "<%=data.get("sysScn")%>";		<%--// �ý��۱���--%>
	  var xcmkCd = "<%=data.get("xcmkCd")%>";	<%--// �븮���ڵ�--%>
	  var eeId = "<%=data.get("eeId")%>";	<%--// ����ھ��̵�--%>
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
		alert("WINS�� ��밡���մϴ�.");
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
		msg = "����";
		break;
	case 'W' :
		msg = "�����ƽý�";
		break;
	}
	return msg;
}

<%--/*******************************************************************************
* FUNCTION �� : tryLogin()
* FUNCTION ��ɼ��� : �Է��� ������ ���ο� ��Ű���� �����ϰ�, ������ ������ư�� ���� �ش� �ý��ۿ� �α����� �õ��մϴ�. 
*******************************************************************************/--%>
function tryLogin() {
	if (! dui.wv.validate($('loginForm')) ) return false;
	
    if (document.loginForm.sysScn[0].checked) {				<%--// ���� �α��ν� --%>

      	var url = window.location.hostname;
	  	var sysScn = "";
	
	  	if(url == "wins.lghausys.com" || url == "wins-l.lghausys.com" ||url == "wins-o.lghausys.com"){ 
	  		sysScn = "OA";
	  	}else {
	  		sysScn = "DEV";
	  	}

		if(document.loginForm.xcmkCd.value == "1078718122"){
			
			if(url != "wins-l.lghausys.com" && sysScn == "OA"){
				alert("LG ������� ���  ���� URL�� ���� �Ͻñ� �ٶ��ϴ�.\nhttp://wins-l.lghausys.com");
				parent.location.href = "http://wins-l.lghausys.com";
				return;
			}
		}else if(document.loginForm.xcmkCd.value == "107531" || //(��)�׸��ý���
				 document.loginForm.xcmkCd.value == "107956" ||	//(��)�������ý�
				 document.loginForm.xcmkCd.value == "101941" ||	//���ϻ��(��)
				 document.loginForm.xcmkCd.value == "526371" 	//(��)�����۶�
				 ){
			if(url != "wins-o.lghausys.com" && sysScn == "OA"){
				alert("���»� ������� ���  ���� URL�� ���� �Ͻñ� �ٶ��ϴ�.\nhttp://wins-o.lghausys.com");
				parent.location.href = "http://wins-o.lghausys.com";
				return;
			}
		}

		//actSubmit(document.loginForm, "<c:url value='/user/login_Navi/tryTwmsReLogin.dev'/>");
		actSubmit(document.loginForm, "<c:url value="/common/login/tryTwmsReLogin.do"/>");
	} else if (document.loginForm.sysScn[1].checked) {	<%--// �����ƽý� �α��ν�--%>
		
		document.woasisForm.xcmk_cd.value = document.loginForm.xcmkCd.value;
		document.woasisForm.login_id.value = document.loginForm.eeId.value;
		document.woasisForm.pwd.value = document.loginForm.pwd.value;
		
		<%--//alert("���� �α��� �غ����Դϴ�.");--%>
		<%--//����--%>
		<%--//actSubmit(document.woasisForm, "<c:url value='http://165.244.161.97:9092/lgchem.woasis.system.chkUser.laf'/>");--%>
		<%--//�--%>
		actSubmit(document.woasisForm, "<c:url value=' http://weboasis.lghausys.com/lgchem.woasis.system.chkUser.laf'/>");
	}
}

<%--/*******************************************************************************
* FUNCTION �� : tryLoginInt()
* FUNCTION ��ɼ��� : �Է��� ������ ���ο� ��Ű���� �����ϰ�, ������ ������ư�� ���� �ش� �ý��ۿ� �α����� �õ��մϴ�. 
*******************************************************************************/--%>
function tryLoginInt() {
	if (! dui.wv.validate($('loginForm')) ) return false;
	
    if (document.loginForm.sysScn[0].checked) {				<%--// ���� �α��ν� --%>
      	var url = window.location.hostname;
	  	var sysScn = "";
	
	  	if(url == "wins.lghausys.com" || url == "wins-l.lghausys.com" ||url == "wins-o.lghausys.com"){ 
	  		sysScn = "OA";
	  	}else {
	  		sysScn = "DEV";
	  	}
	
		if(document.loginForm.xcmkCd.value == "1078718122"){
			
			if(url != "wins-l.lghausys.com" && sysScn == "OA"){
				alert("LG ������� ���  ���� URL�� ���� �Ͻñ� �ٶ��ϴ�.\nhttp://wins-l.lghausys.com");
				parent.location.href = "http://wins-l.lghausys.com";
				return;
			}
		}else if(document.loginForm.xcmkCd.value == "107531" || //(��)�׸��ý���
				 document.loginForm.xcmkCd.value == "107956" ||	//(��)�������ý�
				 document.loginForm.xcmkCd.value == "101941" ||	//���ϻ��(��)
				 document.loginForm.xcmkCd.value == "526371" 	//(��)�����۶�
				 ){
			if(url != "wins-o.lghausys.com" && sysScn == "OA"){
				alert("���»� ������� ���  ���� URL�� ���� �Ͻñ� �ٶ��ϴ�.\nhttp://wins-o.lghausys.com");
				parent.location.href = "http://wins-o.lghausys.com";
				return;
			}
		}
	
		//actSubmit(document.loginForm, "<c:url value='/user/login_Navi/tryIrisLogin.dev'/>");
		actSubmit(document.loginForm, "<c:url value="/common/login/tryIrisLogin.do"/>");
		
	} else if (document.loginForm.sysScn[1].checked) {	<%--// �����ƽý� �α��ν�--%>
		
		document.woasisForm.xcmk_cd.value = document.loginForm.xcmkCd.value;
		document.woasisForm.login_id.value = document.loginForm.eeId.value;
		document.woasisForm.pwd.value = document.loginForm.pwd.value;
		
		<%--//alert("���� �α��� �غ����Դϴ�.");--%>
		<%--//����--%>
		actSubmit(document.woasisForm, "<c:url value='http://165.244.161.97:9092/lgchem.woasis.system.chkUser.laf'/>");
		<%--//�--%>
		<%--//actSubmit(document.woasisForm, "<c:url value=' http://weboasis.lghausys.com/lgchem.woasis.system.chkUser.laf'/>");--%>
	}
}

<%--/*******************************************************************************
* FUNCTION �� : linkie7()
* FUNCTION ��ɼ��� : �ͽ��÷η� 7.0 �ٿ�ε� ��ũ 2010.06.14 �߰�
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
	<form name="woasisForm" id="woasisForm" method="post">	<%--<!-- �����ƽý� �α��� �Ķ���� ���߱� ���� �� -->--%>
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
						<%--<!-- �븮���ڵ� -->--%><span class="boldtext">�븮���ڵ�</span><input value="" name="xcmkCd" id="xcmkCd" autocomplete="off" type="text" class="input WV:�븮���ڵ�:true:maxLength=18&number" onkeypress="if(event.keyCode == 13){tryLoginInt();}" onfocus="this.select();"/>
						<%--<!-- ���̵� -->--%><span class="boldtext">���̵�</span><input name="eeId" id="eeId" autocomplete="off" type="text" class="input WV:���̵�:true:maxLength=20" value="" onkeypress="if(event.keyCode == 13){tryLoginInt();}" style="ime-mode:disabled" onfocus="this.select();"/>
						<%--<!-- ��й�ȣ -->--%><span class="boldtext">��й�ȣ</span><input name="pwd" id="pwd" type="password" class="input WV:��й�ȣ:true:maxLength=30" value="" onkeypress="if(event.keyCode == 13){tryLoginInt();};checkCapsLock(event);" onkeydown="fnCapsDown(event);" onfocus="this.select();"/><span style="padding-right:5px;"></span>
						<%--<!-- ��ư -->--%><img src="<%=imagePath%>/login_btn.gif" class="btn" style="cursor:hand;" onClick="javascript:tryLoginInt();"/>
					    <span class="boldtext" style="margin-left:3px;"> �ý��� ����: 02-6930-1395, 02-6930-1396</span>
					    <input name="UseSession" id="UseSession" type="hidden" value=""/>
					</div>
					<div id="capsLock"  style="display:none;position:absolute; left:475px; top: 375px;"><img src="<%=imagePath%>/capslock_alert.gif"/></div>
				</div>
			
				<div class="footer">    
					<span style="float:right;margin-right:18px;"><img src="<%=imagePath%>/btn_login_ie7D.gif" style="cursor:hand;" onClick="javascript:linkie7();"/></span>
					<span style="float:right;margin:4px 5px 0 2px;"> * Explorer 7.0 �� ����ȭ �Ǿ� �ֽ��ϴ�. </span>
				</div>
			</form>
		</div>
	</div>

</body>
</html>
				