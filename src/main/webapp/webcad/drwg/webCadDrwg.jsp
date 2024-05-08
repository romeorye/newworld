<%@ page language="java" pageEncoding="EUC-KR" contentType="text/html; charset=EUC-KR"%>
<%@ page import="devonframe.configuration.ConfigService" %> 
<%@ page import = "java.util.ResourceBundle" %>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>
<% 
ResourceBundle configService = ResourceBundle.getBundle("config.project");
String uploadUrl  = "/upload"; //configService.getString("KeyStore.UPLOAD_URL");   // /esti/drwg/
String uploadDrgw = configService.getString("KeyStore.UPLOAD_DRGW").replace("/drwg/", "");   // /esti/drwg/
String contextPath = request.getContextPath();
if ("/".equals(contextPath)) {
	contextPath = "";
}
//System.out.println("◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆");
//System.out.println(contextPath+uploadUrl+uploadDrgw);
//System.out.println("◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆◆");
%>
<%--
/*
 *************************************************************************
 * $Id		: mstTab.jsp
 * @desc    : 견적마스터 관리
 *------------------------------------------------------------------------
 * VER	DATE		AUTHOR		DESCRIPTION
 * ---	-----------	----------	-----------------------------------------
 * 1.0  2016.08.10   WEB CAD 개발자		최초생성
 * ---	-----------	----------	-----------------------------------------
 * WINS UPGRADE 1차 프로젝트
 *************************************************************************
 */
--%>
<!DOCTYPE html>

<html style="height:100%;margin:0em">
<head>
    <%--<meta charset="utf-8" />  --%>
    <title>TypeScript HTML App</title>
    <link rel="stylesheet" href="app.css" type="text/css" />
    <link href="CSS/w3css.css" rel="stylesheet" />
    <link href="CSS/styles.css" rel="stylesheet" />
    <link href="Libs/bootstrap/css/bootstrap.css" rel="stylesheet" />
    <link href="Libs/bootstrap/css/bootstrap-theme.css" rel="stylesheet" />
    <script src="Libs/base64/base64.min.js"></script>
    <script src="Libs/jquery-2.1.4.min.js"></script>
    <script src="Libs/jquery-ui-1.11.4/jquery-ui.min.js"></script>
    <script src="Libs/bootstrap/js/bootstrap.js"></script>
    <script src="Libs/hammer.min.js"></script>
    <script src="Libs/numeral.js"></script>
    <script src="LGWinCad.js"></script>

    <script>
    var isExist = true;
    var img = "";
    
    
        function loaded()
        {
            var rarea = document.getElementById("RightArea");
            U1.WinCad.Panels.PropertyPanel.Current.Show(rarea);
        }
        function unLoaded()
        {
        }
        function changeType(winType, w, h, w1, h1, hndlLoc, net ,imgSrc)
        {
            
//        	alert('[winType]=>'+ winType +
//            		'\n [w]=>'+ w +
//            		'\n [h]=>'+ h +
//            		'\n [w1]=>'+ w1 +
//            		'\n [h1]=>'+ h1 +
//            		'\n [hncLoc]=>'+ hndlLoc +
//            		'\n [net]=>'+ net +
//            		'\n [imgSrc]=>'+ imgSrc
//            );
            
            
            isExist = U1.WinCad.Services.LgWinService.Current.SetParams(winType, w, h, w1, h1, hndlLoc, net);
            
		    img = new Image();
		    img.onload = function(){
		    	var ctx = document.getElementById('ViewArea').getContext('2d');
			    //alert(img.width + " : " + img.height);	// 230 ,110
			    //alert(img.src);
			    var w = img.width;
			    var h = img.height;
			    if(w * 450 > h * 600 ){
			    	h = parseInt(600 /w * h, 10);
			    	w = 600;
			    } else {
			    	w = parseInt(450 /h * w, 10);
			    	h = 450;		    	
			    }
			    var x = parseInt((600 - w ) /2);
			    var y = parseInt((450 - h ) /2);
			    //alert(x + " : " + y + " : " + w + " : " + h);
			    ctx.drawImage(img,x,y,w,h);
		    };            
            
            //alert(isExist);
            //alert(imgSrc);
            if(! isExist){
 			    <%--//img.src = "http://localhost:8080/iris/upload/esti"+ imgSrc; --%>
 			    img.src = "<%=contextPath+uploadUrl+uploadDrgw%>" + imgSrc;
            }

            return isExist;
        }
        function SaveImage(estNo, estNos, clSn, windLocSn)
        {
        	<%--
				select JPG_PATH from TWE_CL_WIND_INFO 
				where EST_NO = 'EE2016081800019'
				and  EST_NOS = '1'
				and CL_SN = '1'
				and WIND_LOC_SN ='1'
			alert(estNo + " : " + estNos + " : " +clSn + " : " +windLocSn);	          	
        	--%>
        	U1.WinCad.Services.LgWinService.Current.SaveImage(estNo, estNos, clSn, windLocSn);
        }
    </script>
</head>
<body style="width:600px;height:700px;margin:0em;font-family:'Malgun Gothic';" onload="loaded();" onunload="unLoaded();">

    <div id="MainArea" style="top:0;bottom:0;">
        <main id="WorkArea" style="width:95%;">
            <canvas id="ViewArea"></canvas>
            <div id="OverlayArea" clip-rule="evenodd" overflow="hidden">
            </div>
        </main>
        <section id="RightArea" style="visibility:hidden"></section>
    </div>

    <!--<div class="header" style="width:100%;height:42px">
        <div class="toolbar" id="Toolbar" style="width:100%;height:40px;overflow:hidden">
        </div>
    </div>
    <div class="footer">
        <p id="Version">Win CAD</p>
    </div>-->

</body>
</html>

