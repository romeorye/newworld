<%@ page language="java" pageEncoding="utf-8" contentType="text/html; charset=utf-8" %>

<%@ page import="java.text.*, java.util.*,devonframe.util.NullUtil,devonframe.util.DateUtil,java.net.InetAddress"%>

<%--
/*
 *************************************************************************
 * $Id		: main.jsp
 * @desc    : Main 화면
 *------------------------------------------------------------------------
 * VER	DATE		AUTHOR		DESCRIPTION
 * ---	-----------	----------	-----------------------------------------
 * 1.0  2017.03.30  신동욱		최초생성
 * ---	-----------	----------	-----------------------------------------
 * 정보보안포탈 프로젝트
 *************************************************************************
 */
--%>

<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<%@ include file="/WEB-INF/jsp/include/rui_header.jspf"%>

<title><%=documentTitle%></title>

<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/grid/LEditButtonColumn.js"></script>
<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/grid/LGridView.js"></script>
<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/grid/LGridPanelExt.js"></script>

<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/grid/LGridStatusBar.js"></script>
<link rel="stylesheet" type="text/css" href="<%=ruiPathPlugins%>/ui/grid/LGridStatusBar.css"/>
<script type="text/javascript" src="<%=ruiPathPlugins%>/ui/LFrameDialog.js"></script>
<link rel="stylesheet" type="text/css" href="<%=ruiPathPlugins%>/ui/LFrameDialog.css"/>

<script type="text/javascript">

	function fnMain() {
		//top.location.href = contextPath + '/common/login/irisDirectLogin.do';
	}

	//[EAM추가] 20170420- top메뉴선택 Start
	function fnSelectTop(subSysId, menuId) {
		$("#topForm").find("#vMenuId").val(subSysId);
		$("#topForm").find("#parentMenuId").val(menuId);
		$("#topForm").submit();
	}
	//[EAM추가] - top메뉴선택 End

	var frameDialog = new Rui.ui.LFrameDialog({
	    id: 'frameDialog',
	    title: '정보보안 신청서',
	    width: 830,
	    height: 590,
	    modal: false,
	    visible: false,
	    buttons: [
	            { text: 'Close', handler: function(){
	                this.cancel();
	            } }
	        ]
	});

	var openDialog = function(url){
			frameDialog.render(document.body);
			frameDialog.setUrl(url || './frameDialogContent.html');
			frameDialog.show();
	}

	openForm = function(gubunFlag){
		 var url = "";

		 if (gubunFlag == "11") {
			 url ="http://uapproval.lghausys.com:7010/lgchem/approval.front.document.RetrieveDocumentFormCmd.lgc?tar=8&appCode=APP00175";
		 }else if (gubunFlag == "12") {
			 url ="http://uapproval.lghausys.com:7010/lgchem/approval.front.document.RetrieveDocumentFormCmd.lgc?tar=8&appCode=APP00221";
		 }else if (gubunFlag == "31") {
			 url ="http://uapproval.lghausys.com:7010/lgchem/approval.front.document.RetrieveDocumentFormCmd.lgc?tar=8&appCode=APP00179";
		 }else if (gubunFlag == "53") {
			 url ="http://uapproval.lghausys.com:7010/lgchem/approval.front.document.RetrieveDocumentFormCmd.lgc?tar=8&appCode=APP00234";
		 }else if (gubunFlag == "62") {
			 url ="http://uapproval.lghausys.com:7010/lgchem/approval.front.document.RetrieveDocumentFormCmd.lgc?tar=8&appCode=APP00063";
		 }

		 //openDialog(url);
		 window.open(url);

	   };

	   var frameDialogNotice = new Rui.ui.LFrameDialog({
		    id: 'frameDialogNotice',
		    title: '정보보안 자료실',
		    width: 880,
		    height: 510,
		    modal: false,
		    visible: false,
		    buttons: [
		            { text: 'Close', handler: function(){
		                this.cancel();
		            } }
		        ]
		});

		var openDialogNotice = function(url){
			frameDialogNotice.render(document.body);
			frameDialogNotice.setUrl(url || './frameDialogContent.html');
			frameDialogNotice.show();
		}

		openFormNotice = function(boardSeq){

			openDialogNotice("/iris/tsp/policy/retrieveLgTBoardDetl.do?gubun=popup&boardType=A&boardSeq=" + boardSeq);

		};

		var frameDialogEdu = new Rui.ui.LFrameDialog({
		    id: 'frameDialogEdu',
		    title: '임직원 교육 자료실',
		    width: 800,
		    height: 510,
		    modal: false,
		    visible: false,
		    buttons: [
		            { text: 'Close', handler: function(){
		                this.cancel();
		            } }
		        ]
		});

		var openDialogEdu = function(url){
			frameDialogEdu.render(document.body);
			frameDialogEdu.setUrl(url || './frameDialogContent.html');
			frameDialogEdu.show();
		}

		openFormEdu = function(boardSeq){

			openDialogNotice("/iris/tsp/policy/retrieveLgTBoardDetl.do?gubun=popup&boardType=E&boardSeq=" + boardSeq);

		};

		var frameDialogSecu = new Rui.ui.LFrameDialog({
		    id: 'frameDialogSecu',
		    title: '보안 최신동향',
		    width: 800,
		    height: 510,
		    modal: false,
		    visible: false,
		    buttons: [
		            { text: 'Close', handler: function(){
		                this.cancel();
		            } }
		        ]
		});

		var openDialogSecu = function(url){
			frameDialogSecu.render(document.body);
			frameDialogSecu.setUrl(url || './frameDialogContent.html');
			frameDialogSecu.show();
		}

		openFormSecu = function(boardSeq){

			openDialogSecu("/iris/tsp/policy/retrieveLgTBoardDetl.do?gubun=popup&boardType=S&boardSeq=" + boardSeq);

		};

		var frameDialogPolicy = new Rui.ui.LFrameDialog({
		    id: 'frameDialogPolicy',
		    title: '정보보안규정',
		    width: 1015,
		    height: 650,
		    modal: false,
		    visible: false,
		    buttons: [
		            { text: 'Close', handler: function(){
		                this.cancel();
		            } }
		        ]
		});

		var openDialogPolicy = function(url){
			frameDialogPolicy.render(document.body);
			frameDialogPolicy.setUrl(url || './frameDialogContent.html');
			frameDialogPolicy.show();
		}

		openFormPolicy = function(){

			openDialogPolicy("/iris/tsp/policy/retrieveInfoSecuPolicyDtl.do?gubun=P");

		};

		var frameDialogWithdraw = new Rui.ui.LFrameDialog({
		    id: 'frameDialogWithdraw',
		    title: '협력사 철수 확인서',
		    width: 1040,
		    height: 650,
		    modal: false,
		    visible: false,
		    buttons: [
		            { text: 'Close', handler: function(){
		                this.cancel();
		            } }
		        ]
		});

		var openDialogWithdraw = function(url){
			frameDialogWithdraw.render(document.body);
			frameDialogWithdraw.setUrl(url || './frameDialogContent.html');
			frameDialogWithdraw.show();
		}

		openFormWithdraw = function(){

			openDialogWithdraw("/iris/tsp/request/openWithdrawInput.do");

		};

		<%--/*******************************************************************************
		* FUNCTION 명 : fncApproval()
		* FUNCTION 기능설명 : 틴탑내부에 전자결재 진행중 페이지로 링크시켜준다.
		*******************************************************************************/--%>
		function fncApproval(){
			window.open("http://uapproval.lghausys.com:7010/lgchem/front.jsp?goUrl=ing");
		}

		function tabChgEloffice(nu) {

	        if(nu == '1'){
	        	tab1.style.display='block';
		        tab2.style.display='none';
	        	t7Menu_OFF.style.display='none';
                t7Menu_ON.style.display='block';
	         }else if(nu == '0'){
	        	 tab1.style.display='none';
		         tab2.style.display='block';
	        	 t7Menu_OFF.style.display='block';
	             t7Menu_ON.style.display='none';
	         }

	    }

		function tabChgEloffice2(nu) {

	        if(nu == '1'){
	        	tab3.style.display='block';
		        tab4.style.display='none';
	        	t7Menu2_OFF.style.display='none';
                t7Menu2_ON.style.display='block';
	         }else if(nu == '0'){
	        	 tab3.style.display='none';
		         tab4.style.display='block';
	        	 t7Menu2_OFF.style.display='block';
	             t7Menu2_ON.style.display='none';
	         }

	    }

</script>
<head>
<title>Tip-Top Security Portal</title>
</head>

<div id="wrap">

<!-- 공통으로 top영역 가져오기 -->

	<div class="header">
		<div class="header_inner">
			<h1 class="logo" onclick="fnMain();" style="cursor:pointer;">정보보안포탈</h1>
			<div class="userinfo">
	    	<span class="name"><c:out value="${loginUser._userDeptName}"/> <c:out value="${loginUser._userNm}"/> <c:out value="${loginUser._userJobxName}"/><span></span>
    	</div>
    </div>
	<div class="gnbArea main">
		<ul class="gnb">

		<!-- [EAM추가] - 20170420 TOP 메뉴 정보 조회 Start -->
    	<c:forEach items="${topMenuList}" var="tList" varStatus="status">
    		<c:set var="index" value="${status.index}" />
    		<li>
				<span><a href="#"  onclick="fnSelectTop('${tList.subSysId}', '${tList.menuId} ');">${tList.menuNm}</a></span>
			</li>
		</c:forEach>
		<!-- //[EAM추가] - TOP 메뉴 정보 조회 End -->


		</ul>
   	</div><!-- //gnb_inner -->


<!-- main-left -->
<div id="main-left">
<!-- 부서정보 보안 담당자 -->
	<c:if test = "${loginUser._userGubun != 'F' }">
		<div class="sec-manager">
	    	<h2>부서 정보보안 담당자</h2>
	        <div class="img"><img width="55"  height="75" src="http://intra.lghausys.com:8701${securUser.SYSTEM_FILENAME}"></div>
	        <div class="txt">
	         <dl>
	         	<dt> - <c:out value="${securUser.SA_DEPT_NAME}"/><br>&nbsp;&nbsp;<c:out value="${securUser.SA_NAME}"/> <c:out value="${securUser.SA_JOBX_NAME}"/></dt>
				<dd>부서별 보안사항 관리</dd>
	         </dl>
	       </div>
	    </div>
	    <c:if test = "${!empty infoUser.SA_NAME }">
	    <div class="sec-manager">
	    	<h2>개인 영상정보 관리자</h2>
	        <div class="img"><img width="55"  height="75" src="http://intra.lghausys.com:8701${infoUser.SYSTEM_FILENAME}"></div>
	        <div class="txt">
	         <dl>
	         	<dt> - <c:out value="${infoUser.SA_DEPT_NAME}"/><br>&nbsp;&nbsp;<c:out value="${infoUser.SA_NAME}"/> <c:out value="${infoUser.SA_JOBX_NAME}"/></dt>
				<dd>부서별 영상정보 관리</dd>
	         </dl>
	       </div>
	    </div>
	    </c:if>
	</c:if>

<!-- 메뉴2개 -->
	<div class="left-m">
		<ul>
        	<%-- <a href="javascript:openFormPolicy()"><img src="<%=imagePath%>/main/banner_01.gif"></a> --%>
        	<a href="<c:url value="/mchnPop.jsp"/>">기기팝업</a><br/>
        	<a href="<c:url value="/commonPopup.jsp"/>">공통팝업</a><br/>
        	<a href="<c:url value="/retrieveRequestPopup.jsp"/>">조회요청 관련팝업</a><br/>
        	<a href="<c:url value="/prjPopup.jsp"/>">프로젝트팝업</a>
        </ul>
    </div>
<%--
<!--Contact point -->
    <div class="contact1">
    	<div class="tit"><span class="txt-red">Contact</span> Point</div>
        <p> HelpDesk<br>T.1644-7119</p>
    </div>

<!--보안사고접수 -->
	<div class="contact2">
    	<div class="tit"><span class="txt-red">보안사고</span>접수</div>
        <p> T.02-6930-1357<br>T.02-6930-1397</p>
    </div>

<!-- banner -->
    <c:if test = "${loginUser._userGubun == 'F' }">
    <div class="banner"><a href="javascript:openFormWithdraw()">협력사 철수 확인서</a></div>
    </c:if>



</div>
<!--// main-left -->

<!-- main-contents -->
<div id="main-contents">
	<div class="main-img"><img src="<%=imagePath%>/main/main_img_01.jpg"  ></div>
    <div class="main-board">
<!-- 이달의 보안 현황 -->
		<div class="board01">
        	<div class="tit-area">
				<h2>이달의 보안 현황</h2>
				<a href="#" onclick="fnSelectTop('SK', 'ISPSK0000 ');" class="notice-more"></a>
			</div>
        	<table width="100%" border="0" cellspacing="0" cellpadding="0">
             <colgroup>
             	<col width="10%">
                <col width="18%">
                <col width="18%">
                <col width="18%">
                <col width="18%">
                <col width="18%">
             </colgroup>
              <tr>
                <th>구분</th>
                <th><img src="<%=imagePath%>/main/img_kpi_01.gif"><br>Clean Desk 준수</th>
                <th><img src="<%=imagePath%>/main/img_kpi_02.gif"><br>PC도난/분실</th>
                <th><img src="<%=imagePath%>/main/img_kpi_03.gif"><br>자료외부전송위반</th>
                <th><img src="<%=imagePath%>/main/img_kpi_04.gif"><br>정보보안 교육이수</th>
                <th><img src="<%=imagePath%>/main/img_kpi_05.gif"><br>PC보안설정</th>
              </tr>
              <tr>
                <td>개인</td>
                <c:forEach var="datas" items="${kpiAppraisal}" varStatus="status">
                	<c:if test = "${datas.STATE_NAME1 == '-' }">
                	<td>양호</td>
                	</c:if>
                	<c:if test = "${datas.STATE_NAME1 !=  '-' }">
                	<td>${datas.STATE_NAME1}</td>
                	</c:if>
                </c:forEach>
              </tr>
              <tr>
                <td>팀</td>
                <c:forEach var="datas" items="${kpiAppraisalDept}" varStatus="status">
                	<c:if test = "${datas.STATE_NAME1 == '-' }">
                	<td>양호</td>
                	</c:if>
                	<c:if test = "${datas.STATE_NAME1 !=  '-' }">
                	<td>${datas.STATE_NAME1}</td>
                	</c:if>
                </c:forEach>
              </tr>
          </table>
        </div>
<!--// 이달의 보안 현황 -->

<!-- 보안 최신동향 -->
    	<div class="board02">
        	<div class="tit-area">
				<h2>보안 최신동향</h2>
			</div>
        	<table width="100%" border="0" cellspacing="0" cellpadding="0">
            <colgroup>
            	<col width="7%">
                <col width="93%">
            </colgroup>
              <c:forEach var="datas" items="${secuBoard}" varStatus="status">
	              <tr>
	              <td><a href="javascript:openFormSecu('${datas.seq}')">${datas.titl} </a></td>
	              </tr>
              </c:forEach>
          </table>
            <p>&nbsp;</p>
      </div>
<!--// 보안 최신동향 -->

<!-- 공지사항 / Q&A -->
 		<div class="board03">
        	<div id="tab1" style='display:block'>
	        	<div class="tit-on"><a href="javascript:tabChgEloffice(1)">공지사항</a></div>
	            <div class="tit-off"><a href="javascript:tabChgEloffice(0)">임직원 교육</a></div>
	            <div class="tit-area"><a href="#"  onclick="fnSelectTop('SP', 'ISPSP0000 ');" class="notice-more"></a></div>
	        </div>
	        <div id="tab2" style='display:none'>
	        	<div class="tit-off"><a href="javascript:tabChgEloffice(1)">공지사항</a></div>
	            <div class="tit-on"><a href="javascript:tabChgEloffice(0)">임직원 교육</a></div>
	            <div class="tit-area"><a href="#"  onclick="fnSelectTop('SE', 'ISPSE0000 ');" class="notice-more"></a></div>
	        </div>
            <div class="table-area" id=t7Menu_ON style='display:block'>
            <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tableB02">
              <colgroup>
                <col width="300px;">
                <col width="90px;">
                <col width="90px;">
              </colgroup>
              <tr>
                <th>제목</th>
                <th>게시일</th>
                <th>게시자</th>
              </tr>
              <c:forEach var="datas" items="${lgTBoard}" varStatus="status">
	              <tr>
	              <td><a href="javascript:openFormNotice('${datas.seq}')">${datas.titl} </a></td>
	              <td>${datas.frstRgstDt}</td>
	              <td>${datas.frstRgstId}</td>
	              </tr>
              </c:forEach>
            </table>
            </div>
            <div class="table-area" id=t7Menu_OFF style='display:none'>
            <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tableB02">
              <colgroup>
                <col width="300px;">
                <col width="90px;">
                <col width="90px;">
              </colgroup>
              <tr>
                <th>제목</th>
                <th>게시일</th>
                <th>게시자</th>
              </tr>
              <c:forEach var="datas" items="${eduBoard}" varStatus="status">
	              <tr>
	              <td><a href="javascript:openFormEdu('${datas.seq}')">${datas.titl} </a></td>
	              <td>${datas.frstRgstDt}</td>
	              <td>${datas.frstRgstId}</td>
	              </tr>
              </c:forEach>
            </table>
            </div>
        </div>

<!--// 공지사항 / Q&A -->

<!-- 보안신청 / 신청현황 -->
 <div class="board04">
  			<div id="tab3" style='display:block'>
	        	<div class="tit-on"><a href="javascript:tabChgEloffice2(1)">보안신청</a></div>
	            <div class="tit-off"><a href="javascript:tabChgEloffice2(0)">신청현황</a></div>
	        </div>
	        <div id="tab4" style='display:none'>
	        	<div class="tit-off"><a href="javascript:tabChgEloffice2(1)">보안신청</a></div>
	            <div class="tit-on"><a href="javascript:tabChgEloffice2(0)">신청현황</a></div>
	        </div>

            <div class="table-area" id=t7Menu2_ON style='display:block'>
             <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tableB02">
              <colgroup>
                <col width="100%">
              </colgroup>
              <tr>
                <td><a href="javascript:openForm('11');">사원증 발급(출입권한) 신청서</a></td>
               </tr>
              <tr>
                <td><a href="javascript:openForm('12');">임시출입증 발급(출입권한) 신청서</a></td>
               </tr>
              <tr>
                <td><a href="javascript:openForm('62');">인터넷사이트 사용신청서</a></td>
               </tr>
              <tr>
                <td><a href="javascript:openForm('31');">사외접속시스템(SSL VPN) 신청서</a></td>
               </tr>
               <tr>
                 <td><a href="javascript:openForm('53');">Network 접근제어 신청서</a></td>
               </tr>
            </table>
            </div>
            <div class="table-area" id=t7Menu2_OFF style='display:none'>
            <table width="100%" border="0" cellspacing="0" cellpadding="0" class="tableB02">
              <colgroup>
                <col width="70%">
                <col width="30%">
              </colgroup>
              <tr>
                <th>항목</th>
                <th>현재결재자</th>
               </tr>
              <tr>
            	 <td colspan="2"><div><iframe name="Main" src="http://uapproval.lghausys.com:7010/lgchem/front.appint.cmd.RetrieveAppintDoMainCmdForSecurity.lgc?desktop=desktop_lgh " width="100%" height="121" frameborder="0" scrolling="no"></iframe></div></td>
              </tr>
            </table>
            </div>
      </div>


<!--// 보안신청 / 신청현황 -->

    </div>
</div>
<!--// main-contents -->
<div id="main-copyright">
    <img src="<%=imagePath%>/main/footer_ci.gif"> &nbsp; l &nbsp; <a href="http://portal.lghausys.com/epWeb/resources/notice/sequrityguide/Tip-Top_Security.html" target="_blank">개인정보취급방침 </a> &nbsp; l &nbsp; Copyright 2017 by LG Hausys,LTD All right reserved. </div>
</div>

 --%>
<%-- <!-- [EAM추가]Start 20170420 ===================================================================================== --> --%>
<form id="topForm" name="topForm" method="post" action="/iris/index.do" >
<input type="hidden" id="parentMenuId" name="parentMenuId" />
<input type="hidden" id="menuMoveYn" name="menuMoveYn" />
<input type="hidden" id="vMenuId" name="vMenuId" />
</form>
<%-- <!-- [EAM추가]End ===================================================================================== --> --%>

</html>