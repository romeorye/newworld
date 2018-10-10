<%@ page language="java" session="false" pageEncoding="utf-8" contentType="text/html; charset=utf-8"%>

<%@page import="iris.web.common.util.HelpDesk" %>

<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />

<%@ include file="/WEB-INF/jsp/include/rui_header.jspf"%>


<link rel="stylesheet" href="<%=cssPath%>/common.css" type="text/css" />
<script type="text/javascript" src="<%=scriptPath%>/jquery.js"></script>
<script type="text/javascript" src="<%=scriptPath%>/common.js"></script>
<script type="text/javascript" src="<%=scriptPath%>/jquery.iframeResizer.min.js"></script>
<script type="text/javascript">


//[EAM추가] - 함수 추가 및 수정 Start =========================================================================
function fnSelectMenu(subSysId, menuId, menuNm) {
	
	if(menuId == "IRIPJ0000" ){
		document.searchForm.action = "<c:url value='/prj/main.do'/>";
		document.searchForm.target = "_top";
		document.searchForm.submit();
	}else if(menuId == "IRIAN0000" ){
		document.searchForm.action = "<c:url value='/anl/main.do'/>";
		document.searchForm.target = "_top";
		document.searchForm.submit();
	}else{
		document.getElementById("parentMenuId").value = menuId;
		document.getElementById("parentMenuNm").value = menuNm;
		document.getElementById("vMenuId").value = subSysId;
		document.searchForm.action = "<c:url value='/system/menu/irisFrameMenu/left.do'/>";
		document.searchForm.target = "leftFrame";
		document.searchForm.submit();
	}
}

function fnSearch(){
	var frm = document.aform;
	
	var openWeight = 1035;
	var openHeight = 720;
	var winleft = (screen.width - openWeight) / 2;
	var wintop = (screen.height - openHeight) / 2;
	var settings = 'width=' + openWeight + ', height=' + openHeight + ', resizable=yes, scrollbars=yes, menubar=no, toolbar=no, status=yes';
	settings += ', top=' + wintop;
	settings += ', left=' + winleft;
    /* var keyword = document.getElementById('NavigatorControl_tbSearchKeyWord').value; */
    var keyword = frm.srh.value; 
   
    var url = 'http://search.lghausys.com:8501/iris/search.jsp?query='+encodeURI(keyword);	
	var win = window.open(url, "searchPop", settings);
    //win.focus();
     if(window.focus){
         setTimeout(function(){
          win.focus();
         }, 1000);
     }
}

function goHelpDesk(){
	var sa = '${lsession._userSabun}';
    <%
	String sabun =  (String)((HashMap<String, String>)request.getAttribute("lsession")).get("_userSabun");
	HelpDesk hd = new HelpDesk();
	%>

	var emp_no = "921700"+sa;
	var fmd5_emp_no = "<%=hd.fmd5_user_id(sabun)%>";
	var popUrl =  '<c:url value="/prj/rsst/helpdesPopUp.do"/>';
    var popupOption = "width=1200, height=700, top=200, left=400";
    
    alert("IRIS+ 문의사항은 02-6987-7396 으로 연락바랍니다.");
    
    popUrl = popUrl+"?emp_no="+emp_no+"&fmd5_emp_no="+fmd5_emp_no;
    window.open(popUrl,"",popupOption);
}


//[EAM추가] - 함수 추가 및 수정 End =========================================================================

</script>

</head>
<body onkeypress="if(event.keyCode==13) {fnSearch();}">
	<!-- 메뉴 전체 보기 시작 -->
	<div class="totalMenuWrap">
	    <div class="inner">
	        <div class="tmenu_header">
	            <a href="#none" class="close">전체메뉴닫기</a>
	        </div>
	    </div>
	</div>
<form name="mainForm2" method="post">
 <input type="hidden" name="emp_no" />
 <input type="hidden" name="fmd5_emp_no" />
 <input type="hidden" name="comp_no" value="921700">
</form>
	<!--// 메뉴 전체 보기 종료 -->

<c:set var="mainUrl" value="/prj/main.do"/>

<c:if test="${fn:indexOf(lsession._roleId, 'WORK_IRI_T07') > -1 ||
			  fn:indexOf(lsession._roleId, 'WORK_IRI_T08') > -1 ||
			  fn:indexOf(lsession._roleId, 'WORK_IRI_T09') > -1 ||
			  fn:indexOf(lsession._roleId, 'WORK_IRI_T10') > -1 ||
			  fn:indexOf(lsession._roleId, 'WORK_IRI_T11') > -1 ||
			  fn:indexOf(lsession._roleId, 'WORK_IRI_T12') > -1 ||
			  fn:indexOf(lsession._roleId, 'WORK_IRI_T13') > -1 ||
			  fn:indexOf(lsession._roleId, 'WORK_IRI_T14') > -1}">
	<c:set var="mainUrl" value="/anl/main.do"/>
</c:if>

	<div class="header">
		
		<div class="header_inner">
			<a href="<c:url value="${mainUrl}"/>" target="_top"><h1 class="logo" style="cursor:pointer;">정보보안포탈</h1></a>
			<!-- <div class="userinfo">
    	 		<span class="name"><c:out value="${lsession._userDeptName}"/> <c:out value="${lsession._userNm}"/> <c:out value="${lsession._userJobxName}"/><span></span>
    			</div>-->
         <form id="aform" name="afrom">
    		<div class="gnb_search">
    			<span class="user-name"><c:out value="${lsession._userDeptName}"/> <c:out value="${lsession._userNm}"/> <c:out value="${lsession._userJobxName}"/></span>
            <c:if test="${fn:indexOf(lsession._roleId, 'WORK_IRI_T07') == -1}">
    			<span class="name_info">
    				<input type="text" id="srh" class="search_input" placeholder="Knowledge" ><a href="javascript:fnSearch();"><span class="icon_search"></span></a>
    			</span>
			</c:if>
    		</div>
		</form>	

		</div>
		<div class="gnbArea main pull-left">
			<ul class="gnb">
				<!-- [EAM추가] - TOP 메뉴 정보 조회 Start -->
		    	<c:forEach items="${topMenuList}" var="result" varStatus="status">
		    		<c:set var="index" value="${status.index}" />
		    		<li>
		    			<span><a href="#" onclick="fnSelectMenu('${result.subSysId}', '${result.menuId}', '${result.menuNm}');">${result.menuNm}</a></span>
		    		</li>
				</c:forEach>
		    		<li>
		    			<span><a href="#" onclick="goHelpDesk();">Helpdesk</a></span>
		    		</li>
				
		    	<!-- //[EAM추가] - TOP 메뉴 정보 조회 End -->
			</ul>
	   	</div><!-- //gnb_inner -->

		<form id="searchForm" name="searchForm" method="post" action="<c:url value="/system/menu/irisFrameMenu/left.do"/>" target="leftFrame">
			<input type="hidden" id="parentMenuId" name="parentMenuId" />
			<%-- <!-- [EAM추가]Start ===================================================================================== --> --%>
			<input type="hidden" id="parentMenuNm" name="parentMenuNm" />
			<input type="hidden" id="parentMenuUrl" name="parentMenuUrl" />
			<%-- <!-- [EAM추가]End ===================================================================================== --> --%>
			<input type="hidden" id="vMenuId" name="vMenuId" />
			<input type="hidden" id="menuMoveYn" name="menuMoveYn" value="Y"/>
			<input type="hidden" id="personid" name="personid" value="${lsession._userId}"/>	<%--<!-- 개인 아이디  -->--%>
		</form>

		<form id="menuForm" name="menuForm" method="post" action="/iris/index.do">
			<input type="hidden" id="parentMenuId" name="parentMenuId" />
			<input type="hidden" id="vMenuId" name="vMenuId" value="" />
			<input type="hidden" id="menuMoveYn" name="menuMoveYn" value="Y"/>
			<!-- [EAM추가]Start ===================================================================================== -->
			<input type="hidden" id="menuId" name="menuId"/>
			<input type="hidden" id="menuPath" name="menuPath"/>
			<!-- [EAM추가]End ======================================================================================= -->
		</form>
		<script>
            function goPage(vMenuId, parentMenuId, scrnUrl, menuId) {
                var target = '_top';
                var action = contextPath + '/index.do';


                //[EAM추가] - 변수 Start
                $("#menuForm").find("#parentMenuId").val(parentMenuId);
                $("#menuForm").find("#vMenuId").val(vMenuId);
                $("#menuForm").find("#menuPath").val(scrnUrl);
                $("#menuForm").find("#menuId").val(menuId);
                //[EAM추가] - 변수 Start

                $("#vMenuId").val(vMenuId);
                $("#menuForm").attr("action", action);
                $("#menuForm").attr("target", target);
                $("#menuForm").submit();
            }
		</script>
	</div>
</body>
</html>