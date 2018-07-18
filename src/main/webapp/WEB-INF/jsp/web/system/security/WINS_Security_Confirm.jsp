<%@ page language ="java"  pageEncoding="EUC-KR" contentType="text/html; charset=EUC-KR" %>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>


<html xmlns="http://www.w3.org/1999/xhtml">
 <head>
  <%@ include file="/WEB-INF/jsp/include/loginHeader.jspf"%>
  <title> �����������/ó����ħ </title>
 <script type="text/javascript">

 function initialization() {
	 var frm = document.aform;

	 if(frm.seq1N.checked){
		 alert("�������� ���� �� �̿뿡 �������� ������\n�α����� �Ұ��� �մϴ�.");
	 }else if(frm.seq2N.checked){
		 alert("�������� ��Ź�� �������� ������\n�α����� �Ұ��� �մϴ�.");
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
		alert("�������� ���� �� �̿뿡 ���ǿ��δ� �ʼ� �����Դϴ�.");
		return;
	 }

	 if(!frm.seq2Y.checked && !frm.seq2N.checked){
			alert("�������� ��Ź ���ǿ��δ� �ʼ� �����Դϴ�.");
			return;
		 }

	 if(frm.seq1.value == 'N' || frm.seq2.value == 'N'){
		 if(!confirm("�������� ���� �� �̿� �� �������� ��Ź�� �������� ������\n�α����� �Ұ��� �մϴ�.\n\n�����Ͻðڽ��ϱ�?")) return;
	 }else{
		 if(!confirm("�����Ͻðڽ��ϱ�?")) return;
	 }
	
	 //actSubmit(document.aform, "<c:url value='/user/login_Navi/tryIrisLogin.dev'/>");
     /* �űԷα� ���� */
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
