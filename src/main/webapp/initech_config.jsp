<%@ page import="javax.naming.Context"%>
<%@ page import="javax.naming.InitialContext"%>
<%@ page import="javax.sql.DataSource"%>
<%-- --------------------------------------------------------------------------
 - Display     : none
 - File Name   : initech_config.jsp
 - Description :
 - Include     : none
 - Submit      : none
 - Transaction : none
 - DB          : none
 - Author      : BJ,RYU
 - Last Update : 2005-10-04
-------------------------------------------------------------------------- --%>
<%@ page
	import="sun.misc.*,
			java.sql.*,
			java.util.*,
			java.math.*,
			java.net.*,
			java.io.*,
			com.initech.eam.nls.*,
			com.initech.eam.nls.CookieManager,
			com.initech.eam.api.*,
			com.initech.eam.base.*,
			com.initech.eam.nls.command.*,
			com.initech.eam.smartenforcer.*,
			com.initech.eam.smartenforcer.SECode,
			com.initech.eam.xmlrpc.*,
			javax.servlet.*,
			javax.servlet.http.*"
%>

<%!
	// Null Check 1
	public static String NVL(String str)
	{
		if (str==null) return "";
		else return str;
	}

	// Null Check 2
	public static String NVL(String str, String change_str)
	{
		if (str==null) return change_str;
		String str2= str.trim();
		if (str2.equals("")) return change_str;
		else return str;
	}
%>

<%!
	/*--------------------------------------------------------------------------------------'
	' ASCP config.jsp 설정
	' 아래 주석을 확인하시어 수정으로 표기된 부분은 수정해주시기 바랍니다.
	'-------------------------------------------------------------------------------------*/
	//[시스템 담당자 확인]수정1.업무시스템의 호스트명을 할당

	//service name(어플리케이션 명)
	private String SERVICE_NAME = "PWES";

	//[시스템 담당자 확인]수정2.업무시스템의 포트제외한 URL(IP번호 불가) 할당
	private String SERVER_URL = "http://portal.lghausys.com";

	//[시스템 담당자 확인]수정3.업무시스템의 http 접속 포트번호 할당
	private String SERVER_PORT = "80";

	//[시스템 담당자 확인]수정4.ASCP페이지의 경로, 해당 변수들을 고려해 뒷부분 작성
	private String ASCP_URL = SERVER_URL + ":" + SERVER_PORT + "/epWeb/index.jsp";
	//private String ASCP_URL2 = SERVER_URL + ":" + SERVER_PORT + "/epWeb/ssoLoginAction.do";
	private String ASCP_URL2 = "index.jsp";

	//SSO 장애시 자체 로그인 페이지 또는 장애메세지 페이지 URL(API 방식 적용시-SE방식제외)
	private String SSO_FAIL_URL = "http://portal.lghausys.com/epWeb/fail.jsp";

	//기본값 유지
	private String[] SKIP_URL
		= {"url1", "url2", "url3"};

	/*--------------------------------------------------------------------------------------'
	'아래 설정은 SSO NLS서버 및 ND서버 환경 정보로 2005.07.05 현재 epdev.lghausys.com으로
	'설정 되어 있음
	'추후 실서버로 변경시 실서버 정보로 변경이 필요함
	'--------------------------------------------------------------------------------------*/

	//[시스템 담당자 확인]수정5.SSO NLS 서버 도메인 네임 -- 현재 개발서버로 할당되어있음. 추후 실서버정보로 변경
	private static String NLS_URL = "http://sso.lghausys.com";

	//[시스템 담당자 확인]수정6.SSO NLS 서버 도메인 네임
	private String NLS_PORT = "8001";

	// 기본값 유지
	private String NLS_LOGIN_URL
		= NLS_URL + ":" + NLS_PORT + "/nls3/clientLogin.jsp";
	
    //#### 미주포탈 프로젝트 ####/
	// USA Login page
	private String NLS_LOGIN_URL_HSAI
		= NLS_URL + ":" + NLS_PORT + "/nls3/clientLoginHSAI.jsp";
//		= "http://epdev.lghausys.com:8001/nls3/clientLoginHSAI.jsp";

	// 기본값 유지
	private String NLS_LOGOUT_URL
		= NLS_URL + ":" + NLS_PORT + "/nls3/LogOut.jsp";
	// 기본값 유지
	private String NLS_ERROR_URL
		= NLS_URL + ":" + NLS_PORT + "/nls3/error.jsp";

	//[시스템 담당자 확인]수정6.Nexess Daemon URL(포트제외) -- 추후 이중화 할 경우 두번째 URL설정.
	private static String ND_URL = "http://sso.lghausys.com";
	private static String ND_URL2 = "http://sso.lghausys.com";

	// ID/PW type : 수정사항 없음
	private String TOA = "1";

	// domain (.lghausys.com) : 수정사항 없음
	private String NLS_DOMAIN = ".lghausys.com";
	private String AP_DOMAIN = ".lghausys.com";

	//LTPA Token 생성을 위한 DOMINO NAME
	private String DOMINO_SNAME = "ELOS";
	private String DOMINO_BASE_URL = "http://hub.lghausys.com";

	//장애판단을 위한 CHECK_IP(API 방식 적용시) IP 또는 URL(http://제외)
	private String CHECK_IP = "165.244.234.116";
	private String CHECK_IP2 = "165.244.234.117";
	private String ref="`1234567890-=~!@#$%^&*()_+qwertyuiop[]QWERTYUIOP{}|asdfghjkl;ASDFGHJKL:zxcvbnm,./ZXCVBNM<>?";
%>

<%!
	public NXContext getContext()
	{
		NXContext context = null;
		try
		{
			List serverurlList = new ArrayList();
			serverurlList.add(ND_URL+":5480/");
			serverurlList.add(ND_URL2+":5480/");
			context = new NXContext(serverurlList);
		}
		catch (Exception e)
		{
			e.printStackTrace();
		}
		return context;
	}

	public void goLoginPage(HttpServletResponse response, String uurl)
	throws Exception {
		com.initech.eam.nls.CookieManager.addCookie(SECode.USER_URL, uurl, NLS_DOMAIN, response);
		com.initech.eam.nls.CookieManager.addCookie(SECode.R_TOA, TOA, NLS_DOMAIN, response);
		response.sendRedirect(NLS_LOGIN_URL);
	}

    //#### 미주포탈 프로젝트 ####/
	// USA Login page 
	public void goLoginPageHsai(HttpServletResponse response, String uurl)
	throws Exception {
		com.initech.eam.nls.CookieManager.addCookie(SECode.USER_URL, uurl, NLS_DOMAIN, response);
		com.initech.eam.nls.CookieManager.addCookie(SECode.R_TOA, TOA, NLS_DOMAIN, response);
		response.sendRedirect(NLS_LOGIN_URL_HSAI);
	}

	public void goTestLoginPage(HttpServletResponse response, String uurl)
	throws Exception {
		com.initech.eam.nls.CookieManager.addCookie(SECode.USER_URL, uurl, NLS_DOMAIN, response);
		com.initech.eam.nls.CookieManager.addCookie(SECode.R_TOA, TOA, NLS_DOMAIN, response);
		response.sendRedirect(NLS_URL + ":" + NLS_PORT + "/nls3/clientLogin_test.jsp");
	}

	public void goErrorPage(HttpServletResponse response, int error_code)
	throws Exception {
		CookieManager.removeNexessCookie(NLS_DOMAIN, response);
		response.sendRedirect(NLS_ERROR_URL + "?errorCode=" + error_code);
	}

	public String getSsoId(HttpServletRequest request) {
		String sso_id = null;

		sso_id = CookieManager.getCookieValue(SECode.USER_ID, request);

		return sso_id;
	}

	/**
	 * check default page
	 */
	public String checkUurl(String uurl) {
		String uri = null;
		URL url = null;

		try {
			url = new URL(uurl);
			uri = url.getPath();
		} catch (Exception e) {
			// URI 인 경우
			uri = uurl;
		}

		for (int i = 0; i < SKIP_URL.length; i++) {
			if (SKIP_URL[i].equals(uri)) {
				uurl = null;
				break;
			}
		}
		return uurl;
	}

	/**
	 * SE 가 있을 경우에 사용
	 */
	public int checkSsoId(HttpServletRequest request,
	HttpServletResponse response) throws Exception {
		int return_code = 0;
		return_code = CookieManager.readNexessCookie(request, response,
			NLS_DOMAIN);
		return return_code;
	}

//Domino 외부계정 사용자 정보를 가져오는 기능
	public String[] getSystemAccount(String sso_id) {
		NXContext nx_context = null;
		NXUser nx_user = null;
		NXAccount nx_account = null;
		String[] strA = null;
		nx_context = new NXContext(ND_URL+":5480");
		nx_user = new NXUser(nx_context);
		try {
			//nx_account = nx_user.getUserAccount(sso_id, SERVICE_NAME);
			nx_account = nx_user.getUserAccount(sso_id,DOMINO_SNAME);
			if(nx_account==null){
				strA = null;
			}else{
				strA = new String[2];
				strA[0] = nx_account.getAccountName();
				strA[1] = nx_account.getAccountPassword();
			}
		} catch (APIException ae) {
			strA = null;
			//ae.printStackTrace();
		}
		return strA;
	}

	public String getSsoDomain(HttpServletRequest request) throws Exception {
		String sso_domain = null;
		sso_domain = NLSHelper.getCookieDomain(request);
		return sso_domain;
	}

	//통합인증 세션을 체크 하기 위하여 사용되는 API
	public String getEamSessionCheck(HttpServletRequest request,HttpServletResponse response)
	{
		String retCode = "";
		NXContext context = null;
		try
		{
			context = getContext();
			NXNLSAPI nxNLSAPI = new NXNLSAPI(context);
			retCode = nxNLSAPI.readNexessCookie(request, response, 0, 0);
		}
		catch(Exception npe)
		{
			npe.printStackTrace();
		}
		return retCode;
	}

	/**
	* 20050901 추가 API 방식에서 장애 판단(SE 적용시 필요 없음) by wonho
	*/
	public boolean connectionTest(){

		LinkedList list = new LinkedList();
		list.add(CHECK_IP);
		list.add(CHECK_IP2);
		String[] return_val = null;
		return_val = new String[2];
		boolean return_flag = false;
		Socket c_socket = null;
System.out.println("##### API ConnectTest Strart #########################################");
		for(int i=0; i<list.size();i++){
			try{
				InetAddress addr = InetAddress.getByName((String)list.get(i));
				c_socket = new Socket(addr,Integer.parseInt(NLS_PORT));
System.out.println("##### ConnectTest host"+(i+1)+" is : " + (String)list.get(i) + "#####");
				return_val[i] = "ok";
System.out.println("##### Connection is : " + return_val[i] + "#####");
			}catch(Exception e){
System.out.println("##### ConnectTest host"+(i+1)+" is : " + (String)list.get(i) + "#####");
System.out.println("connectionTest Exception : " + e);
				return_val[i] = "failed";
System.out.println("##### Connection is : " + return_val[i] + "#####");
			}
		}
		if(return_val[0].equals("ok") || return_val[1].equals("ok")){
			return_flag = true;
		}

		return return_flag;
	}

	/**
	 * LGCHEM Encoding String
	 * Creation date: 2005-12-08
	 * @param str : String
	 * @param cipherVal : Integer
	 * @return : String
	 * @throws Exception
	 */
	public String lgchem_encode(String str, int cipherVal) throws Exception{
		String temp = "";

		for(int i=0; i<str.length(); i++){
			String tempChar = str.substring(i,i+1);
			int conv = cton(tempChar);
			int cipher = conv^cipherVal;
			temp += ntoc(cipher);
		}

		return temp;
	}

	/**
	 * LGCHEM Decoding String
	 * Creation date: 2005-12-08
	 * @param str : String
	 * @param cipherVal : Integer
	 * @return : String
	 * @throws Exception
	 */
	public String lgchem_decode(String str, int cipherVal) throws Exception{
		String temp = "";

		for(int i=0; i<str.length(); i++){
			String tempChar = str.substring(i,i+1);
			int conv = cton(tempChar);
			int cipher = conv^cipherVal;
			temp += ntoc(cipher);
		}

		return temp;
	}

	/**
	 * String을 Integer로 변환
	 * Creation date: 2005-12-08
	 * @return : int
	 * @throws Exception
	 */
	public int cton(String val) throws Exception{
		return ref.indexOf(val);
	}

	/**
	 * Integer를 String로 변환
	 * Creation date: 2005-12-08
	 * @return : String
	 * @throws Exception
	 */
	public String ntoc(int val) throws Exception{
		return ref.substring(val,val+1);
	}


	/**
	 * API 통합 비밀번호 select2
	 * Creation date: 2005-12-08
	 * @return String
	 */
	public String getAuthEncPW(String sso_id)
	throws Exception {

		NXContext context = new NXContext(ND_URL+":5480");
		NXUserAPI userAPI = new NXUserAPI(context);
		NXUser user = new NXUser(context);
		String select_str	= null;
		try {
			NXUserInfo userInfo = user.getUserInfo(sso_id);
			select_str = lgchem_encode(userInfo.getEncpasswd(),7);
		} catch (APIException ae) {
			select_str = null;
		}

		return select_str;
	}

	/**
	 * PC 보안 부서 정보 select
	 * Creation date: 2005-12-08
	 * @return String
	 */
	public boolean getBoanyDept(String dept_code)
	throws Exception {
		// 변수 선언
		String query			= "";
		boolean select_str	= false;
		java.sql.Connection conn			= null;
		PreparedStatement pstmt	= null;
		ResultSet rs			= null;
        Context context = null;

		try	{

            Hashtable ht = new Hashtable();
			ht.put(InitialContext.INITIAL_CONTEXT_FACTORY, "weblogic.jndi.WLInitialContextFactory");

			context = new InitialContext(ht);
			DataSource ds = (DataSource)context.lookup("SSODataSource");

			query = "SELECT DEPT_CODE FROM DEPTCHECK WHERE DEPT_CODE = ? ";
			conn = ds.getConnection();

            context.close();


			pstmt = conn.prepareStatement(query);

			pstmt.setString(1, dept_code);

			rs = pstmt.executeQuery();
			if (rs.next())
			{
                String str = rs.getString("DEPT_CODE");
                //System.out.println("rs.next() ========================> " + str);
				select_str = true;
			} else {
				select_str = false;
			}
            //System.out.println("select_str ========================> " + select_str);

			rs.close();
		} catch (Exception e) {
			select_str = false;
			e.printStackTrace();
		} finally {
            if (context != null) {
                context.close();
                context = null;
            }
			if (rs != null) {
                rs.close();
                rs = null;
            }
            if (pstmt != null) {
                pstmt.close();
                pstmt = null;
            }
            if (conn != null) {
                conn.close();
                conn = null;
            }
		}

		return select_str;
	}
    

	/**
	 * PC 보안 부서 정보 select
	 * Creation date: 2007-07-08
	 * @return String
	 */
	public boolean getBoanyDept(String dept_code,String sa_user)
	throws Exception {

        
		// 변수 선언
		String query			= "";
		boolean select_str	= false;
		java.sql.Connection conn			= null;
		PreparedStatement pstmt	= null;        
		ResultSet rs			= null;
        Context context = null;
        
		try	{
            
            Hashtable ht = new Hashtable();
			ht.put(InitialContext.INITIAL_CONTEXT_FACTORY, "weblogic.jndi.WLInitialContextFactory");

			context = new InitialContext(ht);
			DataSource ds = (DataSource)context.lookup("SSODataSource");                                 
            

			query = "SELECT (SELECT nvl(COUNT(DEPT_CODE),0) FROM DEPTCHECK where dept_code= ? ) AS CNT1,(select nvl(COUNT(cont_user),0) from contcheck where cont_user = ? ) AS CNT2 FROM DUAL"; 
			conn = ds.getConnection();
            
            context.close();
            
            
			pstmt = conn.prepareStatement(query);

			pstmt.setString(1, dept_code);
			pstmt.setString(2, sa_user);

      int cnt1 = 0;
      int cnt2 = 0;
      
			rs = pstmt.executeQuery();
			if (rs.next()) 
			{
                cnt1 = rs.getInt("CNT1");
                cnt2 = rs.getInt("CNT2");
                //System.out.println("rs.next() ========================> " + str);
			}                 
			select_str = (cnt1 + cnt2 > 0) ? true : false ;      

			rs.close();
		} catch (Exception e) {
			select_str = false;
			e.printStackTrace();
		} finally { 
            if (context != null) {
                context.close();
                context = null;
            }
			if (rs != null) {
                rs.close();
                rs = null;
            }
            if (pstmt != null) {
                pstmt.close();
                pstmt = null;
            }
            if (conn != null) {
                conn.close();
                conn = null;
            }
		}

		return select_str;
	}
	    
%>
