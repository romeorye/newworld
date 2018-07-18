<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ page import="java.text.*, java.util.*,devonframe.util.NullUtil,devonframe.util.DateUtil"%>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/include/rui_header.jspf"%>
<title><%=documentTitle%></title>

<script type="text/javascript">



function setCookie(name, value, expiredays){
 	var todayDate = new Date();
 	todayDate.setDate(todayDate.getDate()+expiredays);
 	document.cookie = name+"="+escape(value)+"; path=/; expires="+todayDate.toGMTString() +";"
}

function closeWin(){
	if(document.pop.Notice1.checked){
  		setCookie("notice","done",1);
  		self.close();
 	} 
}

</script>
</head>
<body>
	<div class="logo"><img src="http://localhost:8080/iris/resource/web/images/newIris/logo.png"  width="254px;" height="250px;"></div>
	
	
	<input type="checkbox" id="toCls" name="toCls" onclick="javascript:closeWin()" />오늘은 이 창을 열지 않습니다.
	<input type="button" id="btn" name="btn">닫기</input>

</body>
</html>