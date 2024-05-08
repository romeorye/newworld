<%@ page language ="java"  pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>
<%@ include file="/WEB-INF/jsp/include/rui_header.jspf"%>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<link rel="stylesheet" href="<%=cssPath%>/common.css" type="text/css" />
<script type="text/javascript" src="<%=scriptPath%>/jquery.js"></script>
<script type="text/javascript" src="<%=scriptPath%>/common.js"></script>
<script type="text/javascript" src="<%=scriptPath%>/common.js"></script>
<script type="text/javascript" src="<%=scriptPath%>/jquery.iframeResizer.min.js"></script>
<script type="text/javascript">
// function privacyPopup(){
//     var args = new Object();
//     var url    = contextPath + "/security/WINS_Security.jsp";
//     var result = window.showModalDialog(url, "privacyPopup", "dialogWidth:720px;dialogHeight:800px;x-scroll:no;y-scroll:yes;status:no");
// }

// 개인정보처리방침 팝업호출
function privacyPopup(){
    var args = new Object();
    //var url    = contextPath + "/security/WINS_Security.jsp";
    var url    = "http://m.lxhausys.co.kr/mobile/hausys/customers/privacy.jsp";
    //var result = window.showModalDialog(url, "privacyPopup", "dialogWidth:820px;dialogHeight:700px;x-scroll:no;y-scroll:yes;status:no;,resizable=yes");
    var result = openWindow(url, 'privacyPopup', 820, 700, 'yes');
}
</script>
<head>
</head>
<body>
    <!--footer-->
    <div class="footer">
        <img src="<%=imagePath%>/newIris/bottom_logo.png" class="fl">
        <p class="mr15">COPYRIGHT ©  2021 LX HAUSYS ALL RIGHT RESERVED.</p>
        <p class="color_mint bold"><a href="javascript:privacyPopup();">개인정보처리방침</a></p>
    </div><!-- //footer -->
</body>
</html>
