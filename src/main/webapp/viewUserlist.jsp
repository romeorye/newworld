<%@ page language="java" pageEncoding="EUC-KR" contentType="text/html; charset=EUC-KR"%>
<%--
/*------------------------------------------------------------------------------
 * NAME : viewUserList.jsp
 * DESC : ���ӻ���� ����Ʈ��ȸ
 * VER  : V1.0
 * PROJ : LG CNS âȣ�ϼ�â�ý��� ������Ʈ
 * Copyright 2010 LG CNS All rights reserved
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG
 *------------------------------------------------------------------------------
 *    DATE			AUTHOR                      DESCRIPTION
 * ----------		------  ---------------------------------------------------------
 *  2010.06.08		������
 *------------------------------------------------------------------------------*/
--%>
<%@ page import="java.text.DecimalFormat
			   , java.util.Calendar
			   , java.util.Enumeration
			   , java.text.SimpleDateFormat
			   , java.util.*
			   , iris.web.common.listener.NwinsLoginManagerListener
			   , iris.web.common.util.FormatHelper
			   , iris.web.common.util.CommonUtil
			   " %>
<html>
<head>
<%
	String flag = request.getParameter("flag");
%>
<title>���ӻ���ڸ���Ʈ</title>
<script type="text/javascript">

	setTimeout("history.go(0);", 60000);  //���ΰ�ħ �ð� 60�ʷ� ����
	function click_(num){
		frm = document.memberView;
		frm.flag.value = num
		frm.submit();
	}
</script>
</head>
<form name= "memberView">
<input type="hidden" name="loginID">
<input type="hidden" name="flag">
<br>
<br>
<u><b>���������� ��: <span id="cnt" name="cnt"></span></b></u>
<table width="100%" border="1" cellpadding="0" cellspacing="1">
  <tr>
    <td><b>��ȣ</b></td>
    <td><b><a href="javascript:click_('1')"><font color="blue">�α���</font></a></b></td>
    <td><b><a href="javascript:click_('2')"><font color="blue">���ð�</font></a></b></td>
    <td><b>����ھ��̵�</b></td>
    <td><b>����ڸ�</b></td>
    <td><b>�ڵ�</b></td>
    <td><b>�ڵ�N</b></td>
    <td><b><a href="javascript:click_('3')"><font color="blue">ȸ���</font></a></b></td>
    <td><b>�����ȣ</b></td>
    <td><b>�ּ�</b></td>
    <td><b>email</b></td>
    <td><b>�޴���</b></td>
    <td><b>�繫��</b></td>
    <td><b>�����ڵ�</b></td>
    <td><b>�α���Ƚ��</b></td>
    <td><b>�μ���</b></td>
    <td><b>������</b></td>
  </tr>
<%
	int i=0; 
	Enumeration e = NwinsLoginManagerListener.loginUsers.keys();
	HashMap ldata = null;
	HashMap ay = new HashMap();
	FormatHelper fh = new FormatHelper();
	HashMap tmp = null;
	StringBuffer sb = new StringBuffer();
	//while(e.hasMoreElements()){
	//    String key = (String)e.nextElement();
	
	    Enumeration e2 = NwinsLoginManagerListener.loginSession.keys();
	    while(e2.hasMoreElements()){
	        HttpSession lsession = (HttpSession)e2.nextElement();
	        ldata = new HashMap();
	        Date gap = null;
	        Date gab = null;
	        long h=0,m=0,s=0;
	        String hh,mm,ss;
	        SimpleDateFormat simpleDate = new SimpleDateFormat("HH:mm:ss");
	        //System.out.println("LoginManager.loginUsers.get(key): "+LoginManager.loginUsers.get(key));
	        //System.out.println("LoginManager.loginSession.get(lsession): "+LoginManager.loginSession.get(lsession));
	
	        try{
	          //if(LoginManager.loginUsers.get(key).equals(LoginManager.loginSession.get(lsession))){
	              ldata = (HashMap)lsession.getAttribute("irisSession");
	              gap = simpleDate.parse(ldata.get("_loginTime").toString());
	              gab = simpleDate.parse(fh.curTime());
	              h =(gab.getTime() - gap.getTime()) / (1000*60*60);
	              m =((gab.getTime() - gap.getTime())-(h*1000*60*60)) / (1000*60);
	              s =((gab.getTime() - gap.getTime())-(h*1000*60*60)-(m*1000*60)) / (1000);
	              if(h<10){
	            	  hh = "0" + String.valueOf(h);
	              }else{
	            	  hh = String.valueOf(h);
	              }
	              if(m<10){
	            	  mm = "0" + String.valueOf(h);
	              }else{
	            	  mm = String.valueOf(m);
	              }
	              if(s<10){
	            	  ss = "0" + String.valueOf(h);
	              }else{
	            	  ss = String.valueOf(s);
	              }
	              //System.out.println(ldata.toString());
	    		  
	              ldata.put("hh",hh);
	              ldata.put("mm",mm);
	              ldata.put("ss",ss);
	              ldata.put("hhmmss",hh+mm+ss);
	              ay.put("LData["+i+"]" , ldata);
	              i++;
	      //}
	
	
	       }catch(Exception ex1){}
	    }
	    
	    for(i=0 ; i < ay.size() ; i++){ 
	    	for (int j=0; j < ay.size() ; j++){
	    		
	    		if("1".equals(flag)){
		    		//�α��� �ð� ����
		    		if(Integer.parseInt((((HashMap)ay.get("LData["+i+"]")).get("_loginTime").toString()).replaceAll(":","")) > Integer.parseInt((((HashMap)ay.get("LData["+j+"]")).get("_loginTime").toString()).replaceAll(":",""))){
		    			tmp = (HashMap)ay.get("LData["+i+"]");
		    			ay.put("LData["+i+"]",ay.get("LData["+j+"]"));
		    			ay.put("LData["+j+"]",tmp);
		    		}	
		    	}else if("2".equals(flag)){
		    		//�α��� �� �ʰ��� �ð� ����
		    		if(Integer.parseInt(((HashMap)ay.get("LData["+i+"]")).get("hhmmss").toString()) > Integer.parseInt(((HashMap)ay.get("LData["+j+"]")).get("hhmmss").toString())){
		    			tmp = (HashMap)ay.get("LData["+i+"]");
		    			ay.put("LData["+i+"]",ay.get("LData["+j+"]"));
		    			ay.put("LData["+j+"]",tmp);
		    		}	
		    	}else if("3".equals(flag)){
		    		//�븮���� ����
		    		if(Integer.parseInt(((HashMap)ay.get("LData["+i+"]")).get("_xcmkCdN").toString()) > Integer.parseInt(((HashMap)ay.get("LData["+j+"]")).get("_xcmkCdN").toString())){
		    			tmp = (HashMap)ay.get("LData["+i+"]");
		    			ay.put("LData["+i+"]",ay.get("LData["+j+"]"));
		    			ay.put("LData["+j+"]",tmp);
		    		}
		    	}

	    	}
	    }
	    
	    for(i=0 ; i < ay.size() ; i++){
	    	out.println("<tr>");
	        out.println("<td>"+(i+1)+"</td>");
	        out.println("<td>"+CommonUtil.nullToString(((HashMap)ay.get("LData["+i+"]")).get("_loginTime"))+"</td>");
	        out.println("<td>"+((HashMap)ay.get("LData["+i+"]")).get("hh")+":"+((HashMap)ay.get("LData["+i+"]")).get("mm")+":"+((HashMap)ay.get("LData["+i+"]")).get("ss")+"</td>");
	        out.println("<td>"+CommonUtil.nullToString(((HashMap)ay.get("LData["+i+"]")).get("_userId"))+"</td>");
	        out.println("<td>"+CommonUtil.nullToString(((HashMap)ay.get("LData["+i+"]")).get("_userNm"))+"</td>");
	        out.println("<td>"+CommonUtil.nullToString(((HashMap)ay.get("LData["+i+"]")).get("_xcmkCd"))+"</td>");
	        out.println("<td>"+CommonUtil.nullToString(((HashMap)ay.get("LData["+i+"]")).get("_xcmkCdN"))+"</td>");  
	        out.println("<td>"+CommonUtil.nullToString(((HashMap)ay.get("LData["+i+"]")).get("_xcmkNm"))+"</td>");
	        out.println("<td>"+CommonUtil.nullToString(((HashMap)ay.get("LData["+i+"]")).get("_postNo"))+"</td>");
	        out.println("<td>"+CommonUtil.nullToString(((HashMap)ay.get("LData["+i+"]")).get("_postNoAdr"))+"</td>");
	        out.println("<td>"+CommonUtil.nullToString(((HashMap)ay.get("LData["+i+"]")).get("_emailNm"))+"</td>");
	        out.println("<td>"+CommonUtil.nullToString(((HashMap)ay.get("LData["+i+"]")).get("_crraTelNo"))+"</td>");
	        out.println("<td>"+CommonUtil.nullToString(((HashMap)ay.get("LData["+i+"]")).get("_homeTelNo"))+"</td>");
	        out.println("<td>"+CommonUtil.nullToString(((HashMap)ay.get("LData["+i+"]")).get("_authGrCd"))+"</td>");
	        out.println("<td>"+CommonUtil.nullToString(((HashMap)ay.get("LData["+i+"]")).get("_lgiOft"))+"</td>");
	        out.println("<td>"+CommonUtil.nullToString(((HashMap)ay.get("LData["+i+"]")).get("_opsNm"))+"</td>");
	        out.println("<td>"+CommonUtil.nullToString(((HashMap)ay.get("LData["+i+"]")).get("_poaNm"))+"</td>");
	        out.println("</tr>");
	    }
	    
	//}
%>
</table>
</form>

<script>
cnt.innerHTML=<%=i%>;
</script>

<iframe name="viewHiddenForm" id="viewHiddenForm" width="0" height="0" frameborder="0"></iframe>
</html>