<%@ page language ="java"  pageEncoding="EUC-KR" contentType="text/html; charset=EUC-KR" %>
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>


<html xmlns="http://www.w3.org/1999/xhtml">
 <head>
  <%@ include file="/WEB-INF/jsp/include/loginHeader.jspf"%>
  <title> 개인정보취급/처리방침 </title>
 <script type="text/javascript">

 function initialization() {
	 var frm = document.aform;

	 if(frm.agreN.checked){
		 alert("품질 관리 약정에 동의하지 않으면\n로그인이 불가능 합니다.");
	 }

	if(frm.agreY.checked){
		frm.agreYn.value = 'Y';
	}
	if(frm.agreN.checked){
		frm.agreYn.value = 'N';
	}

 }
	
 function chgFlag(flag){
	var frm = document.aform;

	if(flag == "Y"){
		frm.agreN.checked = false;
		frm.agreYn.value = 'Y';
	}else if(flag == "N"){
		frm.agreY.checked = false;
		frm.agreYn.value = 'N';
	}
 }

 function tryLogin() {
	 var frm = document.aform;

	 if(!frm.agreY.checked && !frm.agreN.checked){
		alert("품질 관리 약정 동의여부는 필수 사항입니다.");
		return;
	 }

	 if(frm.agreYn.value == 'N'){
		 if(!confirm("품질 관리 약정에 동의하지 않으면\n로그인이 불가능 합니다.\n\n저장하시겠습니까?")) return;
	 }else{
		 if(!confirm("저장하시겠습니까?")) return;
	 }
     
 	document.aform.method = "post";
	document.aform.action = "<c:url value="/common/login/tryIrisLogin.do"/>";
	document.aform.submit();
	
 }
 
 </script>
 </head>
 <body onload="initialization()">
 <form name="aform" method="post">
 <input type="hidden" value="${data.xcmkCd}" name="xcmkCd"/> 
 <input type="hidden" value="${data.eeId}" name="eeId"/>
 <input type="hidden" value="${data.pwd}" name="pwd"/>
 <input type="hidden" value="" name="agreYn"/>
 <input type="hidden" value="Y" name="contractFlag"/>
 <DIV style="overflow:scroll; width:1100px; height:700px; padding:1px;">
	 <div style="width:992px; height:1403px; background:url(<%=newImagePath %>/contract/contract1.png)"></div>
	 <div style="width:992px; height:1403px; background:url(<%=newImagePath %>/contract/contract2.png)"></div>
	 <div style="width:992px; height:1403px; background:url(<%=newImagePath %>/contract/contract3.png)"></div>
	 <div style="width:992px; height:1403px; background:url(<%=newImagePath %>/contract/contract4.png)"></div>
	 <div style="width:992px; height:1403px; background:url(<%=newImagePath %>/contract/contract5.png)"></div>
	 <div style="width:992px; height:1403px; background:url(<%=newImagePath %>/contract/contract6.png)"></div>
	 <div style="width:992px; height:1403px; background:url(<%=newImagePath %>/contract/contract7.png)"></div>
	 <div style="width:992px; height:1403px; background:url(<%=newImagePath %>/contract/contract8.png)"></div>
	 <div style="width:992px; height:1403px; background:url(<%=newImagePath %>/contract/contract9.png)"></div>
	 <div style="width:992px; height:1403px; background:url(<%=newImagePath %>/contract/contract10.png)"></div>
	 <div style="width:992px; height:1403px; background:url(<%=newImagePath %>/contract/contract11.png)"></div>
	 <div style="width:992px; height:1403px; background:url(<%=newImagePath %>/contract/contract12.png)"></div>
	 <div style="width:992px; height:1403px; background:url(<%=newImagePath %>/contract/contract13.png)"></div>
	 <div style="width:992px; height:1403px; background:url(<%=newImagePath %>/contract/contract14.png)"></div>
	 <div style="width:992px; height:1403px; background:url(<%=newImagePath %>/contract/contract15.png)"></div>
	 <div style="width:992px; height:1403px; background:url(<%=newImagePath %>/contract/contract16.png)"></div>
 </DIV>
 <br>
<table width="1100;" border="0">
	<tr>
		<td align="center">
 			동의함<input type="checkbox" name="agreY" onClick="chgFlag('Y')" <c:if test="${loginUser.agreYn == 'Y'}">checked</c:if>/>
 			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
 			동의하지 않음<input type="checkbox" name="agreN" onClick="chgFlag('N')" <c:if test="${loginUser.agreYn == 'N'}">checked</c:if>/>
 		</td>
 	</tr>
 	<tr>
 		<td align="center"><img src="<%=imagePath%>/button/btn_O_save_gy.gif" class="btn" style="cursor:hand;" onClick="javascript:tryLogin();"/></td>
 	</tr>
</table>
</form>
 </body>
</html>

