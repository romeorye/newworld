<%@ page language="java" pageEncoding="utf-8" contentType="text/json; charset=utf-8" session="false" %>
<%---------------------------------------------------------
    파일명 : errorAjax.jsp
    프로젝트명 : XXXX 프로젝트

    Copyright(c) 2012 LG CNS,  All rights reserved.

    설 명 : 본 화면은 일반적인 Ajax 요청에 대한 에러메시지를 출력하는 화면입니다.
    작성자 : XXX팀 OOO
-------------------------------------------------------------%>

<%
	Exception e = (Exception)request.getAttribute("exception");
	Throwable throwable = e.getCause();
	if(throwable == null) {
		throwable = e;
	}

	String message =  throwable.getMessage();
	if(message == null || message.equals("")){
		message =  throwable.getClass().getSimpleName();
	}
%>
{"resultCode":"error", "resultMessage":"<%=message %>"}
