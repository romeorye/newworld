<%--
/*------------------------------------------------------------------------------
 * NAME : footer.jsp
 * DESC : 초기화면 
 * VER  : V1.0
 * PROJ : LG CNS 창호완성창시스템 프로젝트
 * Copyright 2010 LG CNS All rights reserved
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG                       
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION                        
 * ----------  ------  --------------------------------------------------------- 
 *  2016.05.27  김수예		WINS Upgrade Project  
 *------------------------------------------------------------------------------*/
--%>

<%@ page language ="java"  pageEncoding="EUC-KR" contentType="text/html; charset=EUC-KR" %>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>
<%@ include file="/WEB-INF/jsp/include/header.jspf"%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>Footer Page</title>

<script language="JavaScript" type="text/javascript">
<%--/*******************************************************************************
* FUNCTION 명 : evalUpdate(사용자 정보 수정)
* FUNCTION 기능설명 : 로그인한 사용자가 자신의 정보를 수정하는 창을 팝업함
*******************************************************************************/--%>
function privacyPopup(){
    var args 		= new Object();
    var url			= contextPath + "http://m.lxhausys.co.kr/mobile/hausys/customers/privacy.jsp";
    var result = window.showModalDialog(url, "privacyPopup", "dialogWidth:720px;dialogHeight:800px;x-scroll:no;y-scroll:yes;status:no");
}

</script>
</head>
<body id="LblockFooter">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <col width="183px">
  <col width="">
  <col width="100px">
  <col width="436px">  
  
  <tr>
      <td><a href="#"><img src="<%=imagePath%>/footerLogo.gif" alt="" /></a></td>
	  <td><a href="#" onclick="privacyPopup();"><c:out value="개인정보취급처리방침"/></a></td>	  
	  <td><img src="<%=imagePath%>/footerCopyright.gif" alt="" /></td>
	</tr>
</table>
  
<% historialWatch.tick("Processing Jsp End"); %>  
<!--
/*
 *************************************************************************
 * Page Processing Information
 *------------------------------------------------------------------------
 * Elapsed Time
<%= historialWatch %>
 *------------------------------------------------------------------------
 * Copyright(c) LG CNS,  All rights reserved.
 *************************************************************************
 */
-->

</body>
</html>