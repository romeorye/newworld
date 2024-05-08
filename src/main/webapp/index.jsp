<%@ page language ="java"  pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%



%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<%@ include file="/WEB-INF/jsp/include/rui_header.jspf"%>
<title><%=documentTitle%></title>
<script type="text/javascript">
	
	function init(){
		document.location = "<c:url value="/common/login/irisDirectLogin.do"/>";
	}
	
</script>
</head>
<body onload="javascript:init();">
</body>
</html>