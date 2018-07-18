<%@ page language="java" pageEncoding="EUC-KR" contentType="text/html; charset=EUC-KR"%>
<!--  %@ page import="devonframework.front.channel.context.LActionContext, 
				devon.core.collection.LMultiData,
				devon.core.collection.LData,
				devonframework.service.message.LMessage" %  -->
<%@ include file="/WEB-INF/jsp/include/doctype.jspf"%>
<%-- 
/*------------------------------------------------------------------------------
 * NAME : userEdit.jsp
 * DESC : 사용자관리 신규, 수정, 삭제
 * VER  : V1.0
 * PROJ : LG 하우시스 완성창 프로젝트
 * Copyright 2010 LG CNS All rights reserved
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG                       
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION                        
 * ----------  ------  --------------------------------------------------------- 
 * 2010.03.30  kcw                  
 *------------------------------------------------------------------------------*/
--%>

<%
	//lghausys.twms.esti.util.FormatHelper fHelper = new lghausys.twms.esti.util.FormatHelper();
    //String toDay = fHelper.curDate();
%>

<HTML XMLNS="http://www.w3.org/1999/xhtml">
<head>
<%@ include file="/WEB-INF/jsp/include/header.jspf"%>
<title><%=documentTitle%></title>
<!--  %@ include file="/jsp/include/dhtmlxGrid.jspf"%  --><%--<!--  DhtmlxGrid 사용  -->--%>
<%
    response.setHeader("Pragma", "No-cache");
    response.setDateHeader("Expires", 0);
    response.setHeader("Cache-Control", "no-cache");
%>
<script language="javascript">
	function init(){
		document.aform.pw.focus();
	}
	
	<%--//수정--%>
	function evalUpdate(){
		var pw = document.aform.pw.value;
		var pw1 = document.aform.pw1.value;
		var refPw = document.aform.refPw.value;
		
		if(pw != refPw) {
		    document.aform.chgPwYn.value = "Y";
		}
		if(!CehckPassWord(document.aform.eeId, document.aform.pw, document.aform.pw1)) return;
	    
	    if (! dui.wv.validate($('aform')) ) return false;
		if(!confirm("변경된 패스워드를 저장하시겠습니까?")) {
			return;
		}
		actSubmit(document.aform, "<c:url value='/common/login/updatePassDo.do'/>");
	}

	function CehckPassWord(ObjUserID, ObjUserPassWord, objUserPassWordRe){
	  
	      if(ObjUserPassWord.value != objUserPassWordRe.value)
	      {
	          alert("입력하신 비밀번호와 비밀번호확인이 일치하지 않습니다");
	          return false;
	      }
	      return true;
	   }
  
</script>

</head>
<base target="_self"/ >
<body onload="javascript:init();">
<Tag:saymessage/>
<form name="aform" method="post" id="aform">
<input type="hidden" id="procRes" name="procRes">
<input type="hidden" id="userXcmkCd" name="userXcmkCd" value="<c:out value="${input.xcmkCd}"/>">
<input type="hidden" name="refPw" id="refPw" value="<c:out value="${input.pw}"/>">
<input type="hidden" name="chgPwYn" id="chgPwYn" value="N">
<div style="width:700px;position:absolute;top:50%; left:50%;margin-top:-120px; margin-left:-350px;">
	<table class="popup" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td class="tleft"></td>
			<td class="top">
				<%--<!-- title -->--%>
				<div id="popup_title">
					<h1>사용자 패스워드 변경</h1>
					<div id="popup_title_right"></div>
				</div>
				<%--<!--// title -->--%>
			</td>
			<td class="tright"></td>
		</tr>
		<tr>
			<td class="left"></td>
			<td class="content">
			<%--<!-- table insert -->--%>
				<div id="LblockMainBody">
					<div id="LblockPageSubtitle01" class="LblockPageSubtitle">
						<div style="float:right;color:red;">
							패스워드 변경일이 90일을 경과 하였습니다. 패스워드를 변경해주세요! &nbsp;&nbsp;<img id="save" src="<%=imagePath %>/button/btn_B_save_gy.gif" onmouseover="this.style.cursor='hand';buttonImageOver(this);" onmouseout="buttonImageOut(this);" onclick="evalUpdate(); return false;" />
						</div>	
					</div>
					<div id="LblockDetail01" class="LblockDetail">
				
					    <table summary="사용자 패스워드 변경" border="0" cellspacing="0" cellpadding="0">
					      <tr>
					      	<th width="20%"><label for="eeId">사용자ID</label></th>
					       	<td>
						        <input maxlength="20"  type="text" class="Ltext WV:사용자ID:true:maxLength=20" disabled name="eeIda" value="<c:out value="${input.eeId}"/>" >
						        <input type="hidden" name="eeId" value="<c:out value="${input.eeId}"/>" >
						        <input type="hidden" name="_xcmkCd" value="<c:out value="${input.xcmkCd}"/>" >
					       	</td>
					     </tr>
					     <tr>
					       <th width="20%"><label for="eeNm">사용자명</label></th>
					       <td><input maxlength="25"  type="text" class="Ltext WV:사용자명:true:maxLength=25" disabled name="eeNm" value="<c:out value="${input.eeNm}"/>"></td>
					     </tr>
					     <tr>
					       <th width="20%"><label for="pw"><img src="<%= imagePath %>/required.gif"> 비밀번호</label></th>
					       <td>
					       		<input  maxlength="15"  type="password" class="Ltext WV:비밀번호:true:minLength=4" name="pw"  id="pw" value="" onfocus="this.select();">
					       		<font color="red"><b>비밀번호는 영문+숫자+특수문자 포함 10자리 이상이어야 합니다.</b></font>
					       </td>
					     </tr>
					     <tr>
					       <th width="20%"><label for="pw1"><img src="<%= imagePath %>/required.gif"> 비밀번호재입력</label></th>
					       <td><input  maxlength="15"  type="password" class="Ltext" name="pw1" id="pw1" value="" onfocus="this.select();"></td>
					     </tr>
				   	 </table>
				     </div>
				</div>
			</td>
			<td class="right">&nbsp;</td>
		</tr>
		<tr>
			<td class="bleft"></td>
			<td class="bott"><span style="float:left;"><img src="<%= imagePath %>/pop_bott_copy.gif"/></span></td>
			<td class="bright"></td>
		</tr>
	</table>
</div>
</form>

</body>
</html>
