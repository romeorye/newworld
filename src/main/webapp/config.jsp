<%@page import="com.initech.eam.api.NXNLSAPI"%>
<%@page import="com.initech.eam.smartenforcer.SECode"%>
<%@page import="java.util.Vector"%>
<%@page import="com.initech.eam.nls.CookieManager"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="org.apache.log4j.PropertyConfigurator"%>
<%@page import="com.initech.eam.api.NXContext"%>
<%!
/**[INISAFE NEXESS JAVA AGENT]**********************************************************************
* �����ý��� ���� ���� (���� ȯ�濡 �°� ����)
***************************************************************************************************/


/***[SERVICE CONFIGURATION : �����ý��� ����]***********************************************************************/
	private String SERVICE_NAME = "IRIS+"; //���� �̸� : �ý��ۺ��� �ߺ����� �ʵ��� ����
	private String SERVER_URL 	= "http://irislocal.lghausys.com"; //�ý��� ���� URL
	private String SERVER_PORT = "8080"; // �ý��� ���� ��Ʈ
	private String ASCP_URL = SERVER_URL + ":" + SERVER_PORT + "/iris/login_exec.jsp"; //���� �� login_exec.jsp ���� ���
	
	//Custom Login Url
	//private String custom_url = SERVER_URL + ":" + SERVER_PORT + "/agent/sso/loginFormPageCoustom.jsp";
	private String custom_url = "";
/*************************************************************************************************/


/***[SSO CONFIGURATION] : �α��� ���� �� ���� ���� ����]***********************************************************************/
	private String NLS_URL 		 = "http://ssodev.lghausys.com";
	private String NLS_PORT 	 = "8002";
	private String NLS_LOGIN_URL = NLS_URL + ":" + NLS_PORT + "/nls3/clientLogin.jsp";
	//private String NLS_LOGIN_URL = NLS_URL + ":" + NLS_PORT + "/nls3/cookieLogin.jsp";
	private String NLS_LOGOUT_URL= NLS_URL + ":" + NLS_PORT + "/nls3/NCLogout.jsp";
	private String NLS_ERROR_URL = NLS_URL + ":" + NLS_PORT + "/nls3/error.jsp";
	private static String ND_URL1 = "http://ssodev.lghausys.com:5481";
	private static String ND_URL2 = "http://ssodev.lghausys.com:5481";

	private static Vector PROVIDER_LIST = new Vector();

	private static final int COOKIE_SESSTION_TIME_OUT = 3000000;

	// ���� Ÿ�� (ID/PW ��� : 1, ������ : 3)
	private String TOA = "1";
	private String SSO_DOMAIN = ".lghausys.com";

	private static final int timeout = 15000;
	private static NXContext context = null;
	static{
		List<String> serverurlList = new ArrayList<String>();
		serverurlList.add(ND_URL1);
		serverurlList.add(ND_URL2);

		context = new NXContext(serverurlList,timeout);
		CookieManager.setEncStatus(true);

		PROVIDER_LIST.add("ssodev.lghausys.com");
		PROVIDER_LIST.add("sso.lghausys.com");
		
		//NLS3 web.xml�� CookiePadding ���� ���ƾ� �Ѵ�. �ȱ׷� ���� ���ϳ�
		//InitechEamUID +"_V42" .... ���·� ��� ������
		SECode.setCookiePadding("");
	}

	// ���� SSO ID ��ȸ
	public String getSsoId(HttpServletRequest request) {
		String sso_id = null;
		sso_id = CookieManager.getCookieValue(SECode.USER_ID, request);
		return sso_id;
	}
	// ���� SSO �α��������� �̵�
	public void goLoginPage(HttpServletResponse response)throws Exception {
		CookieManager.addCookie(SECode.USER_URL, ASCP_URL, SSO_DOMAIN, response);
		CookieManager.addCookie(SECode.R_TOA, TOA, SSO_DOMAIN, response);
		
	       //��ü �α����� �Ұ�� �α��� ������ Setting
	    if(custom_url.equals(""))
	   	{
	    	//CookieManager.addCookie("CLP", "", SSO_DOMAIN, response);
	    }else{
	    	CookieManager.addCookie("CLP", custom_url , SSO_DOMAIN, response);
	    }
		
		response.sendRedirect(NLS_LOGIN_URL);
	}

	// �������� ������ üũ �ϱ� ���Ͽ� ���Ǵ� API
	public String getEamSessionCheckAndAgentVaild(HttpServletRequest request,HttpServletResponse response){
		String retCode = "";
		try {
			retCode = CookieManager.verifyNexessCookie(request, response, 10, COOKIE_SESSTION_TIME_OUT, PROVIDER_LIST);
		} catch(Exception npe) {
			npe.printStackTrace();
		}
		return retCode;
	}
	
	
	// �������� ������ üũ �ϱ� ���Ͽ� ���Ǵ� API(Agent ���� ���� �Լ�, �������)
	//@deprecated
	public String getEamSessionCheck(HttpServletRequest request,HttpServletResponse response){
		String retCode = "";
		try {
			retCode = CookieManager.verifyNexessCookie(request, response, 10, COOKIE_SESSTION_TIME_OUT,PROVIDER_LIST);
		} catch(Exception npe) {
			npe.printStackTrace();
		}
		return retCode;
	}
	
	
	//ND API�� ����ؼ� ��Ű�����ϴ°�(���� ǥ�ؿ����� ������, �ٵ� �ص� �Ǳ�� ��)
	public String getEamSessionCheck2(HttpServletRequest request,HttpServletResponse response)
	{
		String retCode = "";
		try {
			NXNLSAPI nxNLSAPI = new NXNLSAPI(context);
			retCode = nxNLSAPI.readNexessCookie(request, response, 0, 0);
		} catch(Exception npe) {
			npe.printStackTrace();
		}
		return retCode;
	}

	// SSO ���������� URL
	public void goErrorPage(HttpServletResponse response, int error_code)throws Exception {
		CookieManager.removeNexessCookie(SSO_DOMAIN, response);
		CookieManager.addCookie(SECode.USER_URL, ASCP_URL, SSO_DOMAIN, response);
		response.sendRedirect(NLS_ERROR_URL + "?errorCode=" + error_code);
	}

%>
