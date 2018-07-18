<%--
/**------------------------------------------------------------------------------
 * NAME : forwordIndex.jsp
 * DESC : index.jsp에서 분기되는 프레임 중 "main"프레임의 연결소스. 
 		 로그인 화면을 불러오는 forwarding 용도의 페이지이다.  
 		 이를 거치지 않을 경우, 로그인 화면의 플래시 파일이 재생되지 않는다. 	
 * VER  : v1.0
 * PROJ : LG CNS TWMS_SPOT 프로젝트
 * Copyright 2010 LG CNS All rights reserved
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG                       
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION                        
 * ----------  ------  --------------------------------------------------------- 
 * 2010.06.28	박은영	initial Release
 * 2016.05.25      조종민	WINS Upgrade Project  
 *------------------------------------------------------------------------------*/
--%>
<%@ page language ="java"  pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<jsp:forward page="/common/login/itgLoginForm.do"/>
 
 