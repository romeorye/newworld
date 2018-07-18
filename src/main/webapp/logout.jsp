<%--
/*------------------------------------------------------------------------------
 * NAME : logout.jsp
 * DESC : 로그아웃시 보이는 화면 _ 프레임을 통합하고 로그아웃을 수행합니다. 
 * VER  : V1.0
 * PROJ : LG CNS 창호완성창시스템 프로젝트
 * Copyright 2010 LG CNS All rights reserved
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG                       
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION                        
 * ----------  ------  --------------------------------------------------------- 
 * 2010.04.12  parkey14                 
 * 2016.05.24    조종민		WINS Upgrade Project   
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
* FUNCTION 명 : logOut()
* FUNCTION 기능설명 : 각 경우에 따른 메시지 출력 및 로그아웃 수행 
*******************************************************************************/--%>
function logOut() {

	 if("${data.logoutYn}" == "Y") {
        <%--//alert("정상적으로 로그아웃되었습니다");--%>
    	showMsg();
    	setTimeout('login()',1000);
    	return false;
    	
    }
    
    if ("${data.menuExistYn}" == "N") {
      alert("<LTag:message code='msg.alert.login.noAccessibleMenu'/>");
      <%--// 조회할 수 있는 메뉴가 존재하지 않아 로그인 페이지로 이동합니다 \n 관리자로 로그인하여 메뉴를 확인해주세요 --%>
    
    }
    if ("${data.menuExistYn}" != "N" && "${data.logoutYn}" != "Y" && "${data.msgYn}" != "Y") {      
       
      <%--//세션이 종료되었습니다. 다시 로그인해주십시오.--%>
             
    }
    if ("${authSso}" == "N") {
        alert("<LTag:message code='msg.alert.noSsoAuth'/>");
        <%--//로그인 권한이 없습니다. \n 부서내 윈스 계정 담당자에게 문의하시기 바랍니다.--%>
       
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
     
    <%--<!-- 팝업 시작 -->--%>
    <div class="popup_warp2" id="msgPopup">
        <div class="inner"><span class="txt">정상적으로 로그아웃되었습니다</span></div>
        <div class="bg"></div>
    </div>
    <%--<!--// 팝업 종료 -->--%>

    
</body>

</html>