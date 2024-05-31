<%-- 
 * PROJ :  
 * NAME : 
 * DESC :
 * Author :
 * Copyright 2005 LG CNS All rights reserved
 *------------------------------------------------------------------------------
 *                  변         경         사         항                       
 *------------------------------------------------------------------------------
 *    DATE       AUTHOR                      DESCRIPTION                        
 * ----------    ------  --------------------------------------------------------- 
 * 04 Jan, 2018  yusang  Support DRM PJT
 *----------------------------------------------------------------------------*/
--%>
<%@ page language="java"%> 
<%@ page contentType="text/html;charset=UTF-8"%>

<%@ page import="java.net.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.*" %>

<%@ page import="com.initech.eam.nls.*"%>
<%@ page import="com.initech.eam.smartenforcer.*"%>
<%@ page import="com.initech.eam.nls.command.*"%>
<%@ page import="com.initech.eam.base.*"%>

<%
	//XLog.print("boanySetup start");
%>
<%@ include file="initech_config.jsp" %>

<%
	String isBoanySetup = (String)session.getAttribute("is_login");
	if ("1".equals(isBoanySetup) == true) return;

	// 사용자 ID
	String InternetID = null;

	if (request.getUserPrincipal() != null) {
		InternetID = request.getUserPrincipal().getName();
	}

	// 사용자 Password
	String eppass = getAuthEncPW(InternetID);

	// 사용자 EMail Server
	String servername = (String)session.getAttribute("emailuseserver");
	String FDepName = (String)session.getAttribute("sadeptnew");
	String sabun = NVL((String)session.getAttribute("sasabunnew"));
%>

<html>
	<head>
	
		<script language=javascript>
			<!--
			//보아니 설치 및 LiveUpdate
			function DRMOnCheck()
			{ 
			/* CSR ID:2018243 DSUpdateCtrl 비기능 처리 Windows7 테스트후 원복 예정
			*/
			}
			
			//보아니 SSO 및 offline패스워드 저장
			function DRMSetPw(){
			
				DRMSSO.Login("<%=InternetID%>"); 
			}
			
			//Window7용 보아니 
			function DRMOnWin7(){
				SafeLogin.SetID("<%=InternetID%>");
			}
			-->
		</script>
	</head>
	<body leftmargin="0" topmargin="0" onLoad="DRMOnCheck();DRMSetPw();DRMOnWin7();">
		<OBJECT ID="DRMSSO" WIDTH=0 HEIGHT=0 CLASSID="CLSID:6A70986F-6565-4D86-849C-4713E1E41AA2" Codebase="http://nboany.lghausys.com:90/DocumentSafer/DrmSSO.cab#version=1,0,0,2"></OBJECT>
		<OBJECT ID="SafeLogin" CLASSID="CLSID:1C9AEB02-260A-4BDF-9737-B632C4349370" codebase="http://nboany.lghausys.com:90/SafeLogin.cab#version=1,0,0,2" width=0 height=0></OBJECT>
	</body>
<%
	session.setAttribute("is_login", "1");
%>
</html>
