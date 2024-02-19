<%@ page language="java" contentType="text/html;charset=EUC-KR" %>
<%@ include file="./config.jsp" %>
<%

	String uurl = null;

	//http://nlstest.initech.com:8090/agent/sso/login_exec.jsp : �� ���������� ȣ���ؾ� �ȴ�.
	//1.SSO ID ����
	String sso_id = getSsoId(request);
	System.out.println("*================== [login_exec.jsp]  sso_id = "+sso_id);
	if (sso_id == null || sso_id.equals("")) {
		goLoginPage(response);
		return;
	} else {

		//4.��Ű ��ȿ�� Ȯ�� :0(����)
		String retCode = getEamSessionCheckAndAgentVaild(request,response);
		System.out.println("*================== [retCode]  retCode = " + retCode);
	
		if(!retCode.equals("0")){
			goErrorPage(response, Integer.parseInt(retCode));
			return;
		}
		//
		//5.�����ý��ۿ� ���� ����� ���̵� �������� ����
		String EAM_ID = (String)session.getAttribute("SSO_ID");
		if(EAM_ID == null || EAM_ID.equals("")) {
			session.setAttribute("SSO_ID", sso_id);
			session.setAttribute("InitechEamUID", sso_id);
		}
		out.println("SSO ���� ����!!");

		//6.�����ý��� ������ ȣ��(���� ������ �Ǵ� ���������� ����)  --> �����ý��ۿ� �°� URL ����!
		//response.sendRedirect("app01.jsp");
		response.sendRedirect("index.jsp");
		//out.println("��������");
	}
%>
