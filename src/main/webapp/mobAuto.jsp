<%@ page language="java" pageEncoding="EUC-KR" contentType="text/html; charset=EUC-KR"%>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<script language="JavaScript" type="text/javascript">
/*******************************************************************************
* FUNCTION 명 : init()
* FUNCTION 기능설명 : 신규
*******************************************************************************/
function init(){

	document.loginForm.method = "post";
	document.loginForm.action = "http://10.38.81.86:8080/iris/mob/system/NwinsMobSystem/mobLogin.mo";
	document.loginForm.submit();
}
</script>


</head>
<body class="body-login" onload="init();">
<form name="loginForm" id="loginForm" method="post">
			
<h2>LOGIN</h2>
<p class="welcome">WINS(MOBILE)에 오신 것을 환영합니다.</p>
<div class="inputArea">
		<label class="inputCode"><input name="xcmkCd" id="xcmkCd" type="text" value="1078718122"></label>
		<label class="inputId"><input  name="eeId" id="eeId" type="text" value="simpson1"></label>
		<label class="inputPw"><input type="password" name="pwd" id="pwd" value="12345"></label>
		<input type="hidden" id="phoneNum" name="phoneNum" value="01190877746">
</div>
</form>						
</body>
</html>

