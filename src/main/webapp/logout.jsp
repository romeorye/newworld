<%--
/*------------------------------------------------------------------------------
 * NAME : logout.jsp
 * DESC : �α׾ƿ��� ���̴� ȭ�� _ �������� �����ϰ� �α׾ƿ��� �����մϴ�. 
 * VER  : V1.0
 * PROJ : LG CNS âȣ�ϼ�â�ý��� ������Ʈ
 * Copyright 2010 LG CNS All rights reserved
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG                       
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION                        
 * ----------  ------  --------------------------------------------------------- 
 * 2010.04.12  parkey14                 
 * 2016.05.24    ������		WINS Upgrade Project   
 *------------------------------------------------------------------------------*/
--%>
<%@ page language="java" pageEncoding="EUC-KR" contentType="text/html; charset=EUC-KR"%>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>

<%	
	if(request.getSession(false) != null){
	    HttpSession session = request.getSession(false);
	    session.invalidate();
	}
	
%>

<html>
<%@ include file="/WEB-INF/jsp/include/header.jspf"%>
<head>
<title><%=documentTitle%></title>  
<link rel="stylesheet" type="text/css" href="<%=duiPathCss%>/login.css" />


<script type="text/javascript" src="<%=duiPathJs%>/jquery.1.4.min.js"></script>
<script type="text/javascript" src="<%=duiPathJs%>/logout.js"></script>

<script language="JavaScript" type="text/javascript">




<%--/*******************************************************************************
* FUNCTION �� : logOut()
* FUNCTION ��ɼ��� : �� ��쿡 ���� �޽��� ��� �� �α׾ƿ� ���� 
*******************************************************************************/--%>
function logOut() {

	 if("${data.logoutYn}" == "Y") {
        <%--//alert("���������� �α׾ƿ��Ǿ����ϴ�");--%>
    	showMsg();
    	setTimeout('login()',1000);
    	return false;
    	
    }
    
    if ("${data.menuExistYn}" == "N") {
      alert("<LTag:message code='msg.alert.login.noAccessibleMenu'/>");
      <%--// ��ȸ�� �� �ִ� �޴��� �������� �ʾ� �α��� �������� �̵��մϴ� \n �����ڷ� �α����Ͽ� �޴��� Ȯ�����ּ��� --%>
    
    }
    if ("${data.menuExistYn}" != "N" && "${data.logoutYn}" != "Y" && "${data.msgYn}" != "Y") {      
       
      <%--//������ ����Ǿ����ϴ�. �ٽ� �α������ֽʽÿ�.--%>
             
    }
    if ("${authSso}" == "N") {
        alert("<LTag:message code='msg.alert.noSsoAuth'/>");
        <%--//�α��� ������ �����ϴ�. \n �μ��� ���� ���� ����ڿ��� �����Ͻñ� �ٶ��ϴ�.--%>
       
    }

    <%--//    if(window.opener && !window.opener.close){--%>
    
    	<%--//parent.top.location.href="<c:url value='/common/page_Navi/itgLoginForm.dev'/>";--%>
    	parent.top.location.href="<c:url value='/'/>";

}

    function login(){
    	parent.top.location.href="<c:url value='/'/>";

}






</script>
</head>

<body onLoad="logOut();">
    
<LTag:saymessage/> 
     
    <%--<!-- �˾� ���� -->--%>
    <div class="popup_warp2" id="msgPopup">
        <div class="inner"><span class="txt">���������� �α׾ƿ��Ǿ����ϴ�</span></div>
        <div class="bg"></div>
    </div>
    <%--<!--// �˾� ���� -->--%>

    
</body>

</html>