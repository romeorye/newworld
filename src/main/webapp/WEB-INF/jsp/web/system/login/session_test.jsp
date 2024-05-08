<%@ page language="java" pageEncoding="EUC-KR" contentType="text/html; charset=EUC-KR"%>
<%@ page import="java.util.*" %>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko">

<%@ include file="/WEB-INF/jsp/include/header.jspf"%>
<title><%=documentTitle%></title>

<head>
<script language="JavaScript" type="text/javascript">
function tryLogout() {
	actSubmit(document.logoutForm, "<c:url value="/common/login/itgLogout.do"/>");
}
</script>
</head>
<body>
<form name="logoutForm" id="logoutForm" method="post">
======================================================================<br>
<B>SESSION »Æ¿Œ</B>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<img src="<%=imagePath%>/logout.gif" class="btn" style="cursor:hand;" onClick="javascript:tryLogout();"/><br>
======================================================================<br>
</form>
<%  
HashMap smap = (HashMap)session.getAttribute("irisSession");
//out.println(session.getAttribute("irisSession"));

out.println(" sessionID        => " + smap.get("sessionID") + "<br>");
out.println(" _userId          => " + smap.get("_userId") + "<br>");
out.println(" _userNm          => " + smap.get("_userNm") + "<br>");
out.println(" _xcmkCd          => " + smap.get("_xcmkCd") + "<br>");
out.println(" _xcmkCdN         => " + smap.get("_xcmkCdN") + "<br>");
out.println(" _userType        => " + smap.get("_userType") + "<br>");
out.println(" _xcmkNm          => " + smap.get("_xcmkNm") + "<br>");
out.println(" _xcmkType        => " + smap.get("_xcmkType") + "<br>");
out.println(" _xcmkTypeNm      => " + smap.get("_xcmkTypeNm") + "<br>");
out.println(" _woasisAuthGrCd  => " + smap.get("_woasisAuthGrCd") + "<br>");
out.println(" _authGrCd        => " + smap.get("_authGrCd") + "<br>");
out.println(" _postNo          => " + smap.get("_postNo") + "<br>");
out.println(" _postNoAdr       => " + smap.get("_postNoAdr") + "<br>");
out.println(" _emailNm         => " + smap.get("_emailNm") + "<br>");
out.println(" _crraTelNo       => " + smap.get("_crraTelNo") + "<br>");
out.println(" _homeTelNo       => " + smap.get("_homeTelNo") + "<br>");
out.println(" _lgiOft          => " + smap.get("_lgiOft") + "<br>");
out.println(" _opsNm           => " + smap.get("_opsNm") + "<br>");
out.println(" _poaNm           => " + smap.get("_poaNm") + "<br>");
out.println(" _brthDt          => " + smap.get("_brthDt") + "<br>");
out.println(" _woasisUseYn     => " + smap.get("_woasisUseYn") + "<br>");
out.println(" _rgstYn          => " + smap.get("_rgstYn") + "<br>");
out.println(" _loginTime       => " + smap.get("_loginTime") + "<br>");
out.println(" rowsPerPage      => " + smap.get("rowsPerPage") + "<br>");

out.println(" _adminYn         => " + smap.get("_adminYn") + "<br>");

%>

</body>
</html>