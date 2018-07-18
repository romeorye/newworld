<%@ page language ="java"  pageEncoding="EUC-KR" contentType="text/html; charset=EUC-KR" %>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>


<html xmlns="http://www.w3.org/1999/xhtml">
 <head>
  <%@ include file="/WEB-INF/jsp/include/loginHeader.jspf"%>
  <title> 개인정보취급/처리방침 </title>
 <script type="text/javascript">

 function initialization() {
	 var frm = document.aform;

	 if(frm.seq1N.checked){
		 alert("개인정보 수집 및 이용에 동의하지 않으면\n로그인이 불가능 합니다.");
	 }else if(frm.seq2N.checked){
		 alert("개인정보 위탁에 동의하지 않으면\n로그인이 불가능 합니다.");
	 }

	if(frm.seq1Y.checked){
		frm.seq1.value = 'Y';
	}
	if(frm.seq1N.checked){
		frm.seq1.value = 'N';
	}
	if(frm.seq2Y.checked){
		frm.seq2.value = 'Y';
	}
	if(frm.seq2N.checked){
		frm.seq2.value = 'N';
	}

 }
	
 function chgFlag(flag){
	var frm = document.aform;

	if(flag == "seq1Y"){
		frm.seq1N.checked = false;
		frm.seq1.value = 'Y';
	}else if(flag == "seq1N"){
		frm.seq1Y.checked = false;
		frm.seq1.value = 'N';
	}else if(flag == "seq2Y"){
		frm.seq2N.checked = false;
		frm.seq2.value = 'Y';
	}else if(flag == "seq2N"){
		frm.seq2Y.checked = false;
		frm.seq2.value = 'N';
	}
 }

 function tryLogin() {
	 var frm = document.aform;

	 if(!frm.seq1Y.checked && !frm.seq1N.checked){
		alert("개인정보 수집 및 이용에 동의여부는 필수 사항입니다.");
		return;
	 }

	 if(!frm.seq2Y.checked && !frm.seq2N.checked){
			alert("개인정보 위탁 동의여부는 필수 사항입니다.");
			return;
		 }

	 if(frm.seq1.value == 'N' || frm.seq2.value == 'N'){
		 if(!confirm("개인정보 수집 및 이용 및 개인정보 위탁에 동의하지 않으면\n로그인이 불가능 합니다.\n\n저장하시겠습니까?")) return;
	 }else{
		 if(!confirm("저장하시겠습니까?")) return;
	 }
	
	 //actSubmit(document.aform, "<c:url value='/user/login_Navi/tryIrisLogin.dev'/>");
     /* 신규로긴 수행 */
  	 actSubmit(document.aform, "<c:url value="/common/login/tryIrisLogin.do"/>");
	
 }
 
 </script>
 </head>
 <body onload="initialization()">
 <form name="aform" method="post">
 <input type="hidden" value="${data.xcmkCd}" name="xcmkCd"/> 
 <input type="hidden" value="${data.eeId}" name="eeId"/>
 <input type="hidden" value="${data.pwd}" name="pwd"/>
 <input type="hidden" value="" name="seq1"/>
 <input type="hidden" value="" name="seq2"/>
 <input type="hidden" value="Y" name="securityFlag"/>
	<div style="width:720px; height:1235px; background:url(<%=newImagePath %>/WINS_Security_Confirm.png)">
		<span style="position:relative;top:813px;left:500px;"><input type="checkbox" name="seq1Y" onClick="chgFlag('seq1Y')" <c:if test="${loginUser.sec1 == 'Y'}">checked</c:if>/></span>
		<span style="position:relative;top:813px;left:540px;"><input type="checkbox" name="seq1N" onClick="chgFlag('seq1N')" <c:if test="${loginUser.sec1 == 'N'}">checked</c:if>/></span>
		<span style="position:relative;top:1060px;left:450px;"><input type="checkbox" name="seq2Y" onClick="chgFlag('seq2Y')" <c:if test="${loginUser.sec2 == 'Y'}">checked</c:if>/></span>
		<span style="position:relative;top:1060px;left:490px;"><input type="checkbox" name="seq2N" onClick="chgFlag('seq2N')" <c:if test="${loginUser.sec2 == 'N'}">checked</c:if>/></span>
		<span style="position:relative;top:1130px;left:520px;">
			<img src="<%=imagePath%>/button/btn_O_save_gy.gif" class="btn" style="cursor:hand;" onClick="javascript:tryLogin();"/>
		</span>
	</div>
</form>
 </body>
</html>
