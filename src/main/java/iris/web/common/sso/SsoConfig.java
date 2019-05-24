package iris.web.common.sso;

import java.util.ArrayList;
import java.util.List;
import java.util.Vector;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.initech.eam.api.NXContext;
import com.initech.eam.api.NXNLSAPI;
import com.initech.eam.nls.CookieManager;
import com.initech.eam.smartenforcer.SECode;

import devonframe.configuration.ConfigService;


public class SsoConfig {

	@Resource(name = "configService")
    private ConfigService configService;
	
/***[SERVICE CONFIGURATION : ¾÷¹«½Ã½ºÅÛ ¼³Á¤]***********************************************************************/
	private String SERVICE_NAME = "IRIS+"; //¼­ºñ½º ÀÌ¸§ : ½Ã½ºÅÛº°·Î Áßº¹µÇÁö ¾Êµµ·Ï ¼³Á¤
/*local
	private String SERVER_URL 	= "http://irislocal.lghausys.com"; //½Ã½ºÅÛ Á¢¼Ó URL
	private String SERVER_PORT = "8080"; // ½Ã½ºÅÛ Á¢¼Ó Æ÷Æ®
	private String ASCP_URL = SERVER_URL + ":" + SERVER_PORT + "/iris/common/login/irisDirectLogin.do"; //¹èÆ÷ µÈ login_exec.jsp Á¢±Ù °æ·Î
*/
/* DEV*/
	private String SERVER_URL 	= "http://irisdev.lghausys.com"; //½Ã½ºÅÛ Á¢¼Ó URL
	private String SERVER_PORT = "7030"; // ½Ã½ºÅÛ Á¢¼Ó Æ÷Æ®
	private String ASCP_URL = SERVER_URL + ":" + SERVER_PORT + "/iris/common/login/irisDirectLogin.do"; //¹èÆ÷ µÈ login_exec.jsp Á¢±Ù °æ·Î

/* PRD 
	private String SERVER_URL 	= "http://iris.lghausys.com"; //½Ã½ºÅÛ Á¢¼Ó URL
	private String SERVER_PORT = "7030"; // ½Ã½ºÅÛ Á¢¼Ó Æ÷Æ®
	private String ASCP_URL = SERVER_URL + ":" + SERVER_PORT + "/iris/common/login/irisDirectLogin.do"; //¹èÆ÷ µÈ login_exec.jsp Á¢±Ù °æ·Î
*/
	
	
	//private String ASCP_URL = SERVER_URL + ":" + SERVER_PORT + "/iris/login_exec.jsp"; //¹èÆ÷ µÈ login_exec.jsp Á¢±Ù °æ·Î
	
	
	//private String SERVER_URL 	= "http://"+configService.getString("defaultUrl")+":"; //½Ã½ºÅÛ Á¢¼Ó URL
	//private String SERVER_PORT = configService.getString("serverPort"); // ½Ã½ºÅÛ Á¢¼Ó Æ÷Æ®
	
	//Custom Login Url
	//private String custom_url = SERVER_URL + ":" + SERVER_PORT + "/agent/sso/loginFormPageCoustom.jsp";
	private String custom_url = "";
/*************************************************************************************************/


	/***[SSO CONFIGURATION]**]***********************************************************************/
	private String NLS_URL 		 = "http://lghsso.lghausys.com";
	private String NLS_PORT 	 = "8001";
	private String NLS_LOGIN_URL = NLS_URL + ":" + NLS_PORT + "/nls3/clientLogin.jsp";
	//private String NLS_LOGIN_URL = NLS_URL + ":" + NLS_PORT + "/nls3/cookieLogin.jsp";
	private String NLS_LOGOUT_URL= NLS_URL + ":" + NLS_PORT + "/nls3/NCLogout.jsp";
	private String NLS_ERROR_URL = NLS_URL + ":" + NLS_PORT + "/nls3/error.jsp";
	private static String ND_URL1 = "http://lghsso1.lghausys.com:8001";
	private static String ND_URL2 = "http://lghsso2.lghausys.com:8001";

	private static Vector PROVIDER_LIST = new Vector();

	private static final int COOKIE_SESSTION_TIME_OUT = 3000000;

	// AIAo A¸AO (ID/PW ¹æ½A : 1, AIAo¼­ : 3)
	private String TOA = "1";
	private String SSO_DOMAIN = ".lghausys.com";

	private static final int timeout = 15000;
	private static NXContext context = null;
	static{
		//PropertyConfigurator.configureAndWatch("D:/INISafeNexess/site/4.1.0/src/Web/WebContent/WEB-INF/logger.properties");
		List<String> serverurlList = new ArrayList<String>();
		serverurlList.add(ND_URL1);
		serverurlList.add(ND_URL2);

		context = new NXContext(serverurlList,timeout);
		CookieManager.setEncStatus(true);

		PROVIDER_LIST.add("ssodev.lghausys.com");
		PROVIDER_LIST.add("sso.lghausys.com");
		
		//NLS3 web.xmlAC CookiePadding °ª°u °°¾Æ¾ß CN´U. ¾E±×·³ °EAo ÆaAI³²
		//InitechEamUID +"_V42" .... CuAA·I Ai¸i ≫y¼ºμE
		SECode.setCookiePadding("");
	}

	// AeCO SSO ID A¶E¸
	public String getSsoId(HttpServletRequest request) {
		String sso_id = null;
		sso_id = CookieManager.getCookieValue(SECode.USER_ID, request);
		return sso_id;
	}
	// AeCO SSO ·I±×AIÆaAIAo AIμ¿
	public void goLoginPage(HttpServletResponse response)throws Exception {
		CookieManager.addCookie(SECode.USER_URL, ASCP_URL, SSO_DOMAIN, response);
		CookieManager.addCookie(SECode.R_TOA, TOA, SSO_DOMAIN, response);
		
	       //AUA¼ ·I±×AIA≫ CO°æ¿i ·I±×AI ÆaAIAo Setting
	    if(custom_url.equals(""))
	   	{
	    	//CookieManager.addCookie("CLP", "", SSO_DOMAIN, response);
	    }else{
	    	CookieManager.addCookie("CLP", custom_url , SSO_DOMAIN, response);
	    }
		
		response.sendRedirect(NLS_LOGIN_URL);
	}

	// AeCOAIAo ¼¼¼CA≫ A¼Aⓒ CI±a A§CI¿ⓒ ≫c¿eμC´A API
	public String getEamSessionCheckAndAgentVaild(HttpServletRequest request,HttpServletResponse response){
		String retCode = "";
		try {
			retCode = CookieManager.verifyNexessCookie(request, response, 10, COOKIE_SESSTION_TIME_OUT, PROVIDER_LIST);
		} catch(Exception npe) {
			npe.printStackTrace();
		}
		return retCode;
	}
	
	
	// AeCOAIAo ¼¼¼CA≫ A¼Aⓒ CI±a A§CI¿ⓒ ≫c¿eμC´A API(Agent AIAo ¾ø´A CO¼o, ≫c¿eAUA|)
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
	
	
	//ND API¸| ≫c¿eCØ¼­ AiA°°EAoCI´A°I(CoAc C￥AØ¿¡¼­´A ≫c¿e¾ECO, ±Uμ￥ CØμμ μC±a´A CO)
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

	// SSO ¿¡·?ÆaAIAo URL
	public void goErrorPage(HttpServletResponse response, int error_code)throws Exception {
		CookieManager.removeNexessCookie(SSO_DOMAIN, response);
		CookieManager.addCookie(SECode.USER_URL, ASCP_URL, SSO_DOMAIN, response);
		response.sendRedirect(NLS_ERROR_URL + "?errorCode=" + error_code);
	}
}
