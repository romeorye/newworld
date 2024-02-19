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
* 업무시스템 설정 사항 (업무 환경에 맞게 변경)
***************************************************************************************************/


/***[SERVICE CONFIGURATION : 업무시스템 설정]***********************************************************************/
	private String SERVICE_NAME = "IRIS+"; //서비스 이름 : 시스템별로 중복되지 않도록 설정
	private String SERVER_URL 	= "http://irislocal.lghausys.com"; //시스템 접속 URL
	private String SERVER_PORT = "8080"; // 시스템 접속 포트
	private String ASCP_URL = SERVER_URL + ":" + SERVER_PORT + "/iris/login_exec.jsp"; //배포 된 login_exec.jsp 접근 경로
	
	//Custom Login Url
	//private String custom_url = SERVER_URL + ":" + SERVER_PORT + "/agent/sso/loginFormPageCoustom.jsp";
	private String custom_url = "";
/*************************************************************************************************/


/***[SSO CONFIGURATION] : 로그인 서버 및 데몬 서버 설정]***********************************************************************/
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

	// 인증 타입 (ID/PW 방식 : 1, 인증서 : 3)
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
		
		//NLS3 web.xml의 CookiePadding 값과 같아야 한다. 안그럼 검증 페일남
		//InitechEamUID +"_V42" .... 형태로 쿠명 생성됨
		SECode.setCookiePadding("");
	}

	// 통합 SSO ID 조회
	public String getSsoId(HttpServletRequest request) {
		String sso_id = null;
		sso_id = CookieManager.getCookieValue(SECode.USER_ID, request);
		return sso_id;
	}
	// 통합 SSO 로그인페이지 이동
	public void goLoginPage(HttpServletResponse response)throws Exception {
		CookieManager.addCookie(SECode.USER_URL, ASCP_URL, SSO_DOMAIN, response);
		CookieManager.addCookie(SECode.R_TOA, TOA, SSO_DOMAIN, response);
		
	       //자체 로그인을 할경우 로그인 페이지 Setting
	    if(custom_url.equals(""))
	   	{
	    	//CookieManager.addCookie("CLP", "", SSO_DOMAIN, response);
	    }else{
	    	CookieManager.addCookie("CLP", custom_url , SSO_DOMAIN, response);
	    }
		
		response.sendRedirect(NLS_LOGIN_URL);
	}

	// 통합인증 세션을 체크 하기 위하여 사용되는 API
	public String getEamSessionCheckAndAgentVaild(HttpServletRequest request,HttpServletResponse response){
		String retCode = "";
		try {
			retCode = CookieManager.verifyNexessCookie(request, response, 10, COOKIE_SESSTION_TIME_OUT, PROVIDER_LIST);
		} catch(Exception npe) {
			npe.printStackTrace();
		}
		return retCode;
	}
	
	
	// 통합인증 세션을 체크 하기 위하여 사용되는 API(Agent 인증 없는 함수, 사용자제)
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
	
	
	//ND API를 사용해서 쿠키검증하는것(현재 표준에서는 사용안함, 근데 해도 되기는 함)
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

	// SSO 에러페이지 URL
	public void goErrorPage(HttpServletResponse response, int error_code)throws Exception {
		CookieManager.removeNexessCookie(SSO_DOMAIN, response);
		CookieManager.addCookie(SECode.USER_URL, ASCP_URL, SSO_DOMAIN, response);
		response.sendRedirect(NLS_ERROR_URL + "?errorCode=" + error_code);
	}

%>
