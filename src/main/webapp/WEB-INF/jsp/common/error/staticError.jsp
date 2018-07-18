<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" isErrorPage="true"	session="false" %>

<%---------------------------------------------------------
    파일명 : staticError.jsp
    프로젝트명 : XXXX 프로젝트

    Copyright(c) 2012 LG CNS,  All rights reserved.

    설 명 : 본 화면은 일반적인 request 요청에 대한 에러메시지를 출력하는 화면입니다.
    작성자 : XXX팀 OOO
-------------------------------------------------------------%>

<%@ include file="/WEB-INF/jsp/common/include/doctype.jspf" %>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Error Page</title>
<%@ include file="/WEB-INF/jsp/common/include/head.jspf" %>
<style type="text/css">
.error_wrap_s{
	width:800px; height:300px;
}

.error_back_s{
	display:block;
	border:1px solid #ccc;
	vertical-align:middle;
}

.error_ttl_s{
	color:#C1325E;
	background:url("../images/bullet/bullet_error_s.gif") no-repeat 7px 0px;
	font-size:13px;
	padding:1px 7px 5px 30px;
	text-align:left;
}

.error_text{
	color:#555;
	border-top:1px solid #CCCCCC;
	padding:7px;
	text-align:left;
}

.bt, a.bt:link{font-weight:bold;}
</style>
</head>

<body>
<!-- go -->
<!-- go end -->

	<div class="error_wrap_s">
	<div class="error_back_s">
		<div>
			<table width="800px" height="300px">
				<tr height="32px">
					<td class="error_ttl_s">Error Message</td>
				</tr>
				<tr>
					<td class="error_text">
						Unexpected internal server error occured. Please contact system administrator.
					</td>
				</tr>
				<tr height="32px">
					<td class="error_text" style="text-align:center">
						<a href="#" onclick="history.go(-1);">Back</a>
					</td>
				</tr>
			</table>
		</div>
	</div>
	</div>
</body>
</html>