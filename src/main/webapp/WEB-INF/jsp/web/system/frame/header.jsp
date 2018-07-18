<%@ page language ="java"  pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>
<%@ include file="/WEB-INF/jsp/include/header.jspf"%>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko">
<head>
<script type="text/javascript" src="<c:url value="/resource/js/dui_hhmenu.js"/>"></script>
<script type="text/javascript">
function fnSelectMenu(menuId) {
	D$("parentMenuId").value = menuId;
	D$("searchForm").submit();
}

/* function fnResourceRefresh() {
    var ajax = new xui.ajax("<c:url value='/system/resourceRefresh.do'/>");
    ajax.send();
} */

function fnCallback() {
	alert(data.resultCode);
}
</script>
</head>
<body id="LblockHeader">
헤더영역
</body>
</html>
