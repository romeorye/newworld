<%@ page language ="java"  pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ include file="./boanySetupNew.jsp"%>
<%@ page import="java.text.*, java.util.*,com.lgcns.encypt.EncryptUtil,devonframe.util.NullUtil,devonframe.util.DateUtil"%>
<%

SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmss");
	TimeZone jst = TimeZone.getTimeZone ("GMT+0");
	java.util.Calendar cal = java.util.Calendar.getInstance ( jst );
	sdf.setTimeZone(cal.getTimeZone());
	String str = sdf.format(cal.getTime());
	String encryptEmpNo = EncryptUtil.encryptText(str + "|" + "00208200"); 



%>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<%@ include file="/WEB-INF/jsp/include/rui_header.jspf"%>
<title><%=documentTitle%></title>

<script>
	


</script>
</head>
<body>

<table>
	<tr>
		<td>
			<input type="text"	id="sabun" value="<%=encryptEmpNo%>"/> 
		</td>	
	</tr>

</table>



</body>
</html>