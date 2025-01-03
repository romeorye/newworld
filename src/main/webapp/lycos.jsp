<%--
/*------------------------------------------------------------------------------
 * NAME : lycos.jsp
 * DESC : 초기화면
 * VER  : V1.0
 * PROJ : LG CNS 정보보안포탈
 * Copyright 2017 LG CNS All rights reserved
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION
 * ----------  ------  ---------------------------------------------------------
 *                      initial release
 *  2017.02.08  dwshin        임시로그인
 *------------------------------------------------------------------------------*/
--%>
<%@ page language ="java"  pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
    pageContext.setAttribute("crlf", "\r\n");
    pageContext.setAttribute("blank", " ");

    String contextPath = request.getContextPath();

    if ("/".equals(contextPath)) {
        contextPath = "";
    }
    String scriptPath       = contextPath + "/resource/web/js";
%>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>::::::IRIS::::::</title>
<script type="text/javascript" src="<%=scriptPath%>/jquery.js"></script>
<script type="text/javascript" src="<%=scriptPath%>/jquery.iframeResizer.min.js"></script>
<script type="text/javascript">
    //[출처] [jQuery] Input에서 엔터시 Submit 이벤트 발생|작성자 lovekod2hj
    /* $(document).ready(function(){
        $('#ssoid').keyup(function(e){
            if( e.keyCode == 13 && $('#ssoid').val()!=""){
                //alert("Enter Event Define!");
                setCookie('InitechEamUID', '', '1');
            }
        });
    }); */

    function setCookie(cookieName, value, exdays){

        if(value==""){
            value = document.getElementById("ssoid").value;
        }

        var exdate = new Date();

        exdate.setDate(exdate.getDate() + exdays);


       // alert(getCookie('user_id'));

        document.location = "<c:url value='/common/login/irisTodoLogin.do?user_id='/>"+value;
    }

    function getCookie(cookieName) {

        cookieName = cookieName + '=';

        var cookieData = document.cookie;

        var start = cookieData.indexOf(cookieName);

        var cookieValue = '';

        if(start != -1){

            start += cookieName.length;

            var end = cookieData.indexOf(';', start);

            if(end == -1)end = cookieData.length;

            cookieValue = cookieData.substring(start, end);

        }

        return unescape(cookieValue);

    }
</script>
</head>
<body onkeypress="if(event.keyCode==13) {setCookie('InitechEamUID', '', '1');}">

<input name="name" type="button"  value="시스템관리자" onClick="setCookie('InitechEamUID', 'siseo', '1');"><br/>
<input name="name" type="button"  value="일반연구원" onClick="setCookie('InitechEamUID', 'aerioh', '1');"><br/>
<input name="name" type="button"  value="일반연구원이성현" onClick="setCookie('InitechEamUID', 'lshinlg', '1');"><br/>
<input name="name" type="button"  value="일반연구원PL안승현" onClick="setCookie('InitechEamUID', 'shahn', '1');"><br/>
<input name="name" type="button"  value="일반연구원PL김희준" onClick="setCookie('InitechEamUID', 'heejune_kim', '1');"><br/>
<input name="name" type="button"  value="일반연구원PL박현옥" onClick="setCookie('InitechEamUID', 'ykokck', '1');"><br/>
<input name="name" type="button"  value="과제담당자" onClick="setCookie('InitechEamUID', 'yunany', '1');"><br/>
<input name="name" type="button"  value="자산담당자" onClick="setCookie('InitechEamUID', 'eunjoomyung', '1');"><br/>
<input name="name" type="button"  value="PRS담당자" onClick="setCookie('InitechEamUID', 'tansam', '1');"><br/>
<input name="name" type="button"  value="MM담당자" onClick="setCookie('InitechEamUID', 'sojeongm', '1');"><br/>
<input name="name" type="button"  value="공간평가담당자" onClick="setCookie('InitechEamUID', 'yujilee', '1');"><br/>
<input name="name" type="button"  value="신뢰성담당자" onClick="setCookie('InitechEamUID', 'keunjung', '1');"><br/>
<input name="name" type="button"  value="분석담당자" onClick="setCookie('InitechEamUID', 'soonbo', '1');"><br/>
<input name="name" type="button"  value="기타사업부" onClick="setCookie('InitechEamUID', 'sungwan', '1');"><br/>
<input name="name" type="button"  value="창호재GRS" onClick="setCookie('InitechEamUID', 'plsen', '1');"><br/>
<input name="name" type="button"  value="장식재GRS" onClick="setCookie('InitechEamUID', 'kckpos', '1');"><br/>
<input name="name" type="button"  value="표면소재GRS" onClick="setCookie('InitechEamUID', 'yangoon', '1');"><br/>
<input name="name" type="button"  value="자동차소재GRS" onClick="setCookie('InitechEamUID', 'goodpwk', '1');"><br/>
<input name="name" type="button"  value="법인GRS" onClick="setCookie('InitechEamUID', 'youngsunan', '1');"><br/>

<input name="ssoid" type="text" id="ssoid"  value="" ><br/>
<input name="submit" id="submit" value="로그인"  type="button" onClick="setCookie('InitechEamUID', '', '1');" />
 <!--
<input name="name" type="button"  value="송수빈책임" onClick="setCookie('InitechEamUID', 'jollypeas', '1');"><br/>
<input name="name" type="button"  value="이유지선임" onClick="setCookie('InitechEamUID', 'yujilee', '1');"><br/>
<input name="name" type="button"  value="정근책임" onClick="setCookie('InitechEamUID', 'keunjung', '1');"><br/>
<input name="name" type="button"  value="시스템관리자" onClick="setCookie('InitechEamUID', 'youngken', '1');"><br/>
  -->
</body>
</html>