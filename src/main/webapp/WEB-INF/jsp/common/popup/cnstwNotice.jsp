<%--
/*------------------------------------------------------------------------------
 * NAME : cnstwNotice.jsp
 * DESC : �̿��������˾� 
 * VER  : V1.0
 * PROJ : LG CNS âȣ�ϼ�â�ý��� ������Ʈ
 * Copyright 2010 LG CNS All rights reserved
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG                       
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION                        
 * ----------  ------  --------------------------------------------------------- 
 *  2017.03.23  �ڿ켮 	���ʻ���
 *------------------------------------------------------------------------------*/
--%>
<%@ page language ="java"  pageEncoding="EUC-KR" contentType="text/html; charset=EUC-KR" %>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<%@ include file="/WEB-INF/jsp/include/rui_header.jspf"%>

<title>�̿��� �������� �˾�</title>
<style type="text/css" media="screen">
html, body { height:100%; background-color: #f6eee0;}
body { margin:0; padding:0; overflow:hidden; }
#flashContent { width:100%; height:100%; }
</style>

</style>

<script type="text/javascript">

<%--/*******************************************************************************
* FUNCTION �� : closeWindow
* FUNCTION ��ɼ��� : �˾� �ݱ� 
*******************************************************************************/--%>
function closeWindow(){	
	  if (document.frm.chk.checked) {	  
	    setCookie("cnstwNotice","pop",1); 
	  }
	  self.close();
	}

<%--/*******************************************************************************
* FUNCTION �� : setCookie
* FUNCTION ��ɼ��� : �����Ϸ� ���� ���� 
*******************************************************************************/--%>
function setCookie( name, value, expiredays ) {
  var todayDate = new Date();
  todayDate.setDate( todayDate.getDate() + expiredays );

  document.cookie = name + "=" + escape( value ) + "; path=/; expires=" + todayDate.toGMTString() + ";"
}

</script>
</head>

<base target="_self" />
<body id="popup_body">
<form name="frm">

	<div align="center">
    	<img src="<%=contextPath%>/resource/images/cnstw_notice.png">   
    </div>

	<div align="right">
		<input type="checkbox" name="chk" onClick="javascript:closeWindow();">&nbsp;<FONT color="black" size="3">�����Ϸ� ���� ����&nbsp;&nbsp;</FONT>
	</div>

</form>
</body>
</html>