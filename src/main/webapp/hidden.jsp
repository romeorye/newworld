<%--
/**------------------------------------------------------------------------------
 * NAME : hidden.jsp
 * DESC : index.jsp에서 분할되는 프레임 중 하나로서 화면에 보이지 않는다.
 		  사용자가 로그아웃 절차를 거치지 않고 브라우저를 닫거나, 다른 사이트로 이동할 경우 로그아웃 처리를 수행한다.  
 * VER  : v1.0
 * PROJ : LG CNS TWMS_SPOT 프로젝트
 * Copyright 2010 LG CNS All rights reserved
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG                       
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION                        
 * ----------  ------  --------------------------------------------------------- 
 *  2010.06.28  박은영		initial release		  
 *  2016.05.24  조종민		WINS Upgrade Project  
 *------------------------------------------------------------------------------*/
--%>  

<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8"%>

<HTML XMLNS="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/include/header.jspf"%>
<title><%=documentTitle%></title>
<script language="JavaScript" type="text/javascript">

<%--/*******************************************************************************
* FUNCTION 명 : logout()
* FUNCTION 기능설명 : 브라우저를 닫을 때 로그아웃 수행
*******************************************************************************/--%>
function logout(){
	//alert("파일위치 사용못함");
	location.href = "/WEB-INF/jsp/web/system/login/logout.jsp";
	//location.href = "/logout.jsp";
}

</script>
</head>
<body OnUnload="logout();"> <%--<!--  OnUnload="logout();" -->--%>
</body>
</html>