package iris.web.system.login.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.logging.log4j.LogManager; import org.apache.logging.log4j.Logger;
import org.springframework.context.MessageSource;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import iris.web.common.listener.IrisLoginManagerListener;
import iris.web.common.util.FormatHelper;
import iris.web.common.util.LoginUtil;
import iris.web.system.login.service.IrisEncryptionService;
import iris.web.system.login.service.IrisLoginService;
import devonframe.message.saymessage.SayMessage;
import devonframe.util.NullUtil;

/********************************************************************************
 * NAME : IrisReLoginController.java 
 * DESC : 재 로긴처리 controller
 * PROJ : WINS UPGRADE 1차 프로젝트
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG                       
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION                        
 * ----------  ------  --------------------------------------------------------- 
 * 2016.07.08  조종민	최초생성            
 *********************************************************************************/

@Controller
public class IrisReLoginController {

	@Resource(name = "irisLoginService")
	private IrisLoginService loginService;
	
	@Resource(name = "irisEncryptionService")
	private IrisEncryptionService irisEncryptionService;	
	
	@Resource(name="messageSource")
	MessageSource messageSource;

    @Resource(name="messageSourceAccessor")
    private MessageSourceAccessor messageSourceAccessor;
    
    //static final Logger LOGGER = LoggerFactory.getLogger(IrisReLoginController.class);
    static final Logger LOGGER = LogManager.getLogger(IrisReLoginController.class);	
	
	@RequestMapping(value="/common/login/tryTwmsReLogin.do")
	public String doLogin( 
			String xcmkCd, 
			String eeId , 
			String pwd, 
			String vowFlag,
			String securityFlag,
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request, 
			HttpServletResponse response, 
			HttpSession session, 
			//RedirectAttributes redirectAttributes,
			ModelMap model){
		LOGGER.debug("###########################################################");
		LOGGER.debug("IrisReLoginController - doLogin [로긴 시작]");
		LOGGER.debug("xcmkCd => " + xcmkCd);
		LOGGER.debug("eeId => " + eeId);
		LOGGER.debug("pwd => " + pwd);
		LOGGER.debug("xcmkCd => " + input.get("xcmkCd"));
		LOGGER.debug("vowFlag => " + input.get("vowFlag"));	
		LOGGER.debug("###########################################################");
		
		String userIP = request.getRemoteAddr();
		
        
		//LoginManager loginTool = LoginManager.getInstance();
		IrisLoginManagerListener loginManager = IrisLoginManagerListener.getInstance();
		
		
        //LData inputData = LCollectionUtility.getData(request);
		
        //사용자 로그인
		/*
        LData userCnt = null;       // 특/시판 모두 등록된 사용자인지 여부 확인
        LData loginUser = null;     // 사용자 마스터에서 해당 사용자 정보를 조회한 결과
        boolean userOk = true;      // 유효한 사용자인지
        String validation = null;   // 로그인 validation 값. 
        LMultiData loginInfo = new LMultiData();		
        //세션 생성
        LData resultData = null;    // 영문 대문자가 붙은 대리점 코드로 사용자 상세 조회 - 세션 생성을 하기 위한 정보 조회         
		*/
        HashMap userCnt = null;       // 특/시판 모두 등록된 사용자인지 여부 확인
        HashMap loginUser = null;     // 사용자 마스터에서 해당 사용자 정보를 조회한 결과
        boolean userOk = true;      // 유효한 사용자인지
        String validation = null;   // 로그인 validation 값. 
        ArrayList loginInfo = new ArrayList();			
        //세션 생성
        HashMap resultData = null;    // 영문 대문자가 붙은 대리점 코드로 사용자 상세 조회 - 세션 생성을 하기 위한 정보 조회         
        
        if(userOk) {
        	LOGGER.debug("ID         :----------> [" + input.get("eeId")+ "]");
        	LOGGER.debug("Password   :----------> [" + input.get("pwd")+ "]");
            LOGGER.debug("Session ID :----------> [" + input.get("UseSession")+ "]");
        }        
        
        // 주소창에 get방식으로 입력하여 로그인할 경우 차단. 엘리안에서 로그인하는 경우 별도 처리 필요 : 10.06.16.
        LOGGER.debug("getMethod------------------>" + request.getMethod()+"<");  // get or post
        if("GET".equals(request.getMethod())) {
            userOk = false;
            validation = "0007";
        }        
        // get 방식 방지 끝        
        
        //사용중인 세션이 존재하므로.. 제거함
        System.out.println("세션을 제거 해야 하는 상황");
        
        String sess[] = input.get("UseSession").toString().split(",");        
        for(int i=0; i<sess.length; i++){
            try{
                //loginTool.removeSessionID(data.getString("xcmkCd"),data.getString("eeId"),sess[i],userIP);
                loginManager.removeSessionID(input.get("xcmkCd").toString(),input.get("eeId").toString(),sess[i],userIP,"web");
                
                /* *********************************************************************************
                 * IrisLoginManagerListener 가 ststic으로 선언되어  쿼리 수행하지 못해서 아래단으로 세션로그 적는 부분 이동
                 ***********************************************************************************/
                HashMap sLogHm = new HashMap();
                sLogHm.put("agenCd", input.get("xcmkCd").toString());
                sLogHm.put("userID", input.get("eeId").toString());
                sLogHm.put("sessionId", sess[i]);
                sLogHm.put("userIP", userIP);
                loginService.sessionLog(sLogHm);
            }catch(Exception e){
                //System.out.println("이미 만료된 세션("+sess[i]+") : " + data.getString("xcmkCd") + ":" + data.getString("eeId"));
            	LOGGER.debug("이미 만료된 세션("+sess[i]+") : " + input.get("xcmkCd") + ":" + input.get("eeId")+":web");
//                validation = "0098";
//                userOk = false;
            }
            validation = "9999";
            userOk = true;
        }        
        
        
        if(userOk){
            //if(data.containsKey("securityFlag")){
        	if(!NullUtil.isNull(securityFlag)){
        		loginService.updateSecurityInfo(input);
            }

            //loginUser = loginService.evalUser(input);
            
            List loginUserList = loginService.evalUser(input);
    		LOGGER.debug("###########################################################");
    		LOGGER.debug("loginUserList size => " + loginUserList.size());
    		LOGGER.debug("loginUserList => " + loginUserList);
            
            
            // 사용자 정보가 없을 때
    		if(NullUtil.isNull(loginUserList)|| loginUserList.size() < 1){
                userOk = false;
                validation = "0001";    			
    		} else {	
                loginUser = (HashMap)loginUserList.get(0);
        		LOGGER.debug("loginUserList.get(0) => " + loginUser);
        		LOGGER.debug("###########################################################");
        		
	            if(loginUser.get("xcmkCd") == null || loginUser.get("eeId") == null) {
        		//if(loginUser.get("XCMK_CD") == null || loginUser.get("EE_ID") == null) {
	                userOk = false;
	                validation = "0001";
	            }else if(loginUser.get("loginLock").toString().equals("Y")){
        		//}else if(loginUser.get("LOGIN_LOCK").toString().equals("Y")){
	                userOk = false;
	                validation = "L001";
	            }
    		}
            LOGGER.debug("사용자 조회 완료");        	
        }
        
		LOGGER.debug("###########################################################");
		LOGGER.debug("userOk => " + userOk);
		LOGGER.debug("validation => " + validation);
		LOGGER.debug("###########################################################");
		
		
        if(userOk){
            // 비밀번호 확인 (암호화된 비밀번호 일치여부 확인)
        	try {
            //if(!EncryptionBiz.isMatchingSHA512Password(loginUser.getString("pw2"), data.getString("pwd"))){
        	if(!irisEncryptionService.isMatchingSHA512Password(loginUser.get("pw2").toString(), input.get("pwd").toString())){
	        		LOGGER.debug("패스워드 불일치");
	                userOk = false;
	                validation = "0002";
	            }else{
	            	LOGGER.debug("비밀번호 확인 완료");
	            }
        	} catch(Exception e) {
        		LOGGER.debug("패스워드 알고리즘 오류");
                userOk = false;
                validation = "0002";        		
        	}
        }
        
        LOGGER.debug("######################### 로그인 정보 확인 #########################");
        LOGGER.debug(loginUser);
        LOGGER.debug("######################### 로그인 정보 확인 #########################");		
		
		
        // 퇴직 직원의 경우 
        if(userOk){
            //if(loginUser.getString("retrYn").equals("Y")){
        	if(loginUser.get("retrYn").toString().equals("Y")){
                userOk = false;
                validation = "0006";
            }
        	LOGGER.debug("퇴직 직원 여부  확인 완료");
        }        
        
        //패스워드변경
        if(userOk){
            //LData chkData = loginBiz.retrievePassDt(loginUser);
        	HashMap chkData = loginService.retrievePassDt(loginUser);
            //if(chkData.getInt("cnt") > 0){
        	if(Integer.parseInt( chkData.get("cnt").toString()) > 0){
                //LNavigationAlter.setReturnUrlName("repass");
        		//return "redirect:/repass.do";
        		//redirectAttributes.addAttribute("eeId", input.get("eeId").toString());
        		//redirectAttributes.addAttribute("_xcmkCd", input.get("xcmkCd").toString());
        		//return "redirect:/common/login/itgRepassLoginForm.do";
        		model.addAttribute("eeId", loginUser.get("eeId").toString());
        		model.addAttribute("_xcmkCd", loginUser.get("xcmkCd").toString());
        		return "redirect:/common/login/itgRepassLoginForm.do";
            }
        }
        
        // 개인정보동의
        if(userOk) {
            
            //if("Y".equals(loginUser.getString("sec1")) && "Y".equals(loginUser.getString("sec2"))){
        	if("Y".equals(loginUser.get("sec1").toString()) && "Y".equals(loginUser.get("sec2").toString())){
                
            }else{
                //LActionContext.setAttribute("data", data);
            	model.addAttribute("data", input); 
                //LActionContext.setAttribute("loginUser", loginUser);
            	model.addAttribute("loginUser", loginUser);
                //LNavigationAlter.setReturnUrlName("sConfirm");
            	//return "redirect:/sConfirm.do";
            	return "web/system/security/WINS_Security_Confirm";
            }
            
            //System.out.println("ID       :----------> [" + data.getString("eeId")+ "]");
            //System.out.println("Password :----------> [" + data.getString("pwd")+ "]");
        	LOGGER.debug("ID       :----------> [" + input.get("eeId")+ "]");
        	LOGGER.debug("Password :----------> [" + input.get("pwd")+ "]");        	
        }        
        
        if(userOk) {
            validation = "9999";
            //loginBiz.updateLoginInfo(loginUser);    // 로그인 횟수 update
            loginService.updateLoginInfo(loginUser);    // 로그인 횟수 update
        }
    
        LOGGER.debug("##### validation  : " + validation );        
        
        
        if(validation == "9999"){
            //request.setAttribute("validation", validation);
        	model.put("validation", validation);
            //request.setAttribute("userInfo", data);
        	model.put("userInfo", input);

            // 세션 생성하기 위한 사용자 정보 조회 
            resultData = loginService.retrieveUserDetail(loginUser);

            if(!resultData.isEmpty()) {
                
                //LData lsession = new LData();
            	HashMap lsession = new HashMap();
                // 세션 변경 과도기 기간을 위한 임시. 장대일K 요청 . 10.03.25
                //lsession.setString("userId"   , resultData.getString("eeId")); 2010.04.23 주석처리 (박은영)

                lsession.put("_systemCd"   , "");      // 타시스템에서 접속했는지 C20110916_63300
                lsession.put("_b2cCustNo"   , "");     // B2C 고객번호 C20110916_63300
                lsession.put("_b2cConsltNo"   , "");   // B2C 상담일련번호  C20110916_63300
                lsession.put("_b2cDeptSeCode" , "");   // B2C 사업부코드  C20110916_63300
                lsession.put("_b2cShopCode"   , "");   // B2C 매장코드  C20110916_63300
                lsession.put("_userId"   , NullUtil.nvl(resultData.get("eeId"), ""));  
                
                
                lsession.put("_userNm"     , NullUtil.nvl(resultData.get("eeNm"), "")); //resultData.get("eeNm").toString());
                lsession.put("_xcmkCd"     , NullUtil.nvl(resultData.get("xcmkCd"), "")); //resultData.get("xcmkCd").toString());   // L,T,C,D,H 등의 구분자가 들어간 코드 : 예) L1078718122
                lsession.put("_xcmkCdN"    , NullUtil.nvl(resultData.get("xcmkCdN"), "")); //resultData.get("xcmkCdN").toString()); // 구분자가 들어가지 않은 코드      예) 1078718122
                lsession.put("_userType"   , NullUtil.nvl(resultData.get("userType"), "")); //resultData.get("userType").toString());
                lsession.put("_xcmkNm"     , NullUtil.nvl(resultData.get("custName"), "")); //resultData.get("custName").toString());
                lsession.put("_xcmkType"   , NullUtil.nvl(resultData.get("custType"), "")); //resultData.get("custType").toString());
                lsession.put("_xcmkTypeNm" ,  NullUtil.nvl(resultData.get("custTypeNm"), "")); //resultData.get("custTypeNm").toString());
                lsession.put("_woasisAuthGrCd" , NullUtil.nvl(resultData.get("woasisAuthGCd"), "")); //resultData.get("woasisAuthGCd").toString());
                lsession.put("_authGrCd"   , NullUtil.nvl(resultData.get("authGCd"), "")); //resultData.get("authGCd").toString());
                
                lsession.put("_postNo"     ,NullUtil.nvl(resultData.get("postNo"), "")); //resultData.get("postNo").toString());
                lsession.put("_postNoAdr"  ,NullUtil.nvl(resultData.get("postNoAdr"), "")); //resultData.get("postNoAdr").toString());
                lsession.put("_dtlAdr"     ,NullUtil.nvl(resultData.get("dtlAdr"), "")); //resultData.get("dtlAdr").toString());
                lsession.put("_emailNm"    ,NullUtil.nvl(resultData.get("emailNm"), "")); //resultData.get("emailNm").toString());
                lsession.put("_crraTelNo"  ,NullUtil.nvl(resultData.get("crraTelNo"), "")); //resultData.get("crraTelNo").toString());
                lsession.put("_homeTelNo"  ,NullUtil.nvl(resultData.get("homeTelNo"), "")); //resultData.get("homeTelNo").toString());
                lsession.put("_lgiOft"     ,NullUtil.nvl(resultData.get("lgiOft"), "")); //resultData.get("lgiOft").toString());
                lsession.put("_opsNm"      ,NullUtil.nvl(resultData.get("opsNm"), "")); //resultData.get("opsNm").toString());
                lsession.put("_poaNm"      ,NullUtil.nvl(resultData.get("poaNm"), "")); //resultData.get("poaNm").toString());
                lsession.put("_brthDt"     ,NullUtil.nvl(resultData.get("brthDt"), "")); //resultData.get("brthDt").toString());
                lsession.put("_woasisUseYn"     ,NullUtil.nvl(resultData.get("woasisUseYn"), "")); //resultData.get("woasisUseYn").toString());
                lsession.put("_rgstYn"     ,NullUtil.nvl(resultData.get("rgstYn"), "")); //resultData.get("rgstYn").toString());
                lsession.put("_loginTime",  FormatHelper.curTime());  //로그인 시간
                lsession.put("rowsPerPage",  "100");      // 그리드 리스트에서 한 화면에 보이는 row 수 
                
                /*
                if(resultData.get("xcmkCd").toString().equals("L1078718122")){ 
                    if(resultData.get("eeId").toString().equals("system")
                       || resultData.get("eeId").toString().equals("lghausys")
                       || resultData.get("eeId").toString().equals("master")
                       || resultData.get("eeId").toString().equals("admin")
                       || resultData.get("eeId").toString().equals("parkeya")
                       || resultData.get("eeId").toString().equals("hcjincns")
                       || resultData.get("eeId").toString().equals("jhyeom")
                       || resultData.get("eeId").toString().equals("sooyae")
                       || resultData.get("eeId").toString().equals("parkws")
                       || resultData.get("eeId").toString().equals("jkmfri")
                       || resultData.get("eeId").toString().equals("oasis")
                       || resultData.get("eeId").toString().equals("rltlt")
                       || resultData.get("eeId").toString().equals("leeminu")    //otp 테스트용
                    ){
                */    
                if(NullUtil.nvl(resultData.get("xcmkCd"), "").equals("L1078718122")){ 
                    if(NullUtil.nvl(resultData.get("eeId"), "").equals("system")
                       || NullUtil.nvl(resultData.get("eeId"), "").equals("lghausys")
                       || NullUtil.nvl(resultData.get("eeId"), "").equals("master")
                       || NullUtil.nvl(resultData.get("eeId"), "").equals("admin")
                       || NullUtil.nvl(resultData.get("eeId"), "").equals("parkeya")
                       || NullUtil.nvl(resultData.get("eeId"), "").equals("hcjincns")
                       || NullUtil.nvl(resultData.get("eeId"), "").equals("jhyeom")
                       || NullUtil.nvl(resultData.get("eeId"), "").equals("sooyae")
                       || NullUtil.nvl(resultData.get("eeId"), "").equals("parkws")
                       || NullUtil.nvl(resultData.get("eeId"), "").equals("jkmfri")
                       || NullUtil.nvl(resultData.get("eeId"), "").equals("oasis")
                       || NullUtil.nvl(resultData.get("eeId"), "").equals("rltlt")
                       || NullUtil.nvl(resultData.get("eeId"), "").equals("leeminu")    //otp 테스트용
                    ){                    	
                        //lsession.setString("_adminYn", "Y");
                    	lsession.put("_adminYn", "Y");
                    } else {
                        //lsession.setString("_adminYn", "N");
                    	lsession.put("_adminYn", "N");
                    }
                }
                else {
                    //lsession.setString("_adminYn", "N");
                	lsession.put("_adminYn", "N");
                }
                
                //if(resultData.getString("xcmkCd").equals("C777777")) {
                if(NullUtil.nvl(resultData.get("xcmkCd"), "").equals("C777777")) {
                    //lsession.setString("_adminYn", "Y");
                    lsession.put("_adminYn", "Y");
                }
                //세션 객체 생성
                //HttpSession session = request.getSession(true); 
                
                //lsession.setString("sessionID",  session.getId()); 
                lsession.put("sessionID",  session.getId());
                
                //세션 시간 설정
                //session.setMaxInactiveInterval(3600);
                session.setAttribute("irisSession", lsession);
                
                // SPOT - 공사관리 : 작업대상 아님
                // SpotSiteInfo spotSiteInfo = new SpotSiteInfo();
                // session.setAttribute(SpotSiteInfo.SESSION_NAME, spotSiteInfo);
                
               
                //로그인 유저관리 클래스 호출.
                LOGGER.debug("*****세션 생성 시작");
                LOGGER.debug("생성된 세션ID: [" + session.getId() + "]");
                LOGGER.debug("생성된 대리점코드: [" + lsession.get("_xcmkCd") + "]");
                LOGGER.debug("생성된 로그인ID: [" + lsession.get("_userId") + "]");
                LOGGER.debug("생성된 세션관리코드: ["+lsession.get("_xcmkCd")+":"+lsession.get("_userId")+"]");
                
                
                loginManager.loginUsers.put(session.getId(), lsession.get("_xcmkCd")+":"+lsession.get("_userId"));
                loginManager.loginSession.put(session,lsession.get("_xcmkCd")+":"+lsession.get("_userId"));
                LOGGER.debug("*****세션 생성 끝");
                    
                //LActionContext.setAttribute("loginUser", lsession);
                model.addAttribute("loginUser", lsession);

                LOGGER.debug("session ::::" + lsession.toString());
                
                //if(lsession.getString("_adminYn").equals("Y")){
                /* [사용안함]
                if(lsession.get("_adminYn").toString().equals("Y")){
                    //LNavigationAlter.setReturnUrlName("otp");
                	return "redirect:/otp.do";
                }
                */
            }
        
        } else if(validation == "0001" || validation == "0002"){            // 사용자 정보가 없을 때 

            //로그인 실패 카운터 --> 이 메소드를 통해 일정 회수 이상 실패시 아이디 Lock
            //LData result = new LData();
        	HashMap resultHm = new HashMap();
        	String rtnMsg = "";
        	
            if(validation.equals("0002")){

                //result = loginBiz.loginFailureCount(data);
            	// msg.alert.login.warning
            	// msg.alert.login.lock.warning
            	//result = loginService.loginFailureCount(input);
            	
            	HashMap inMap = new HashMap();
            	//inMap.put("P_AGEN_CD", loginUser.get("xcmkCd").toString());
            	//inMap.put("P_USER_ID", loginUser.get("eeId").toString());
            	inMap.put("xcmkCd", input.get("xcmkCd").toString());
            	inMap.put("eeId", input.get("eeId").toString());            	
            	//resultHm = loginService.loginFailureCount(inMap);
            	loginService.loginFailureCount(inMap);
            	
            	//resultHm = loginService.loginFailureCount(loginUser);
                
                
                //String rtnMsg = LMessage.getInstance().getMessage(result.getString("returnCode"));
                //String rtnMsg = messageSource.getMessage(result.get("returnCode").toString(), null, Locale.KOREA); 
            	LOGGER.debug("######################### 패스워드불일치#########################");	
            	LOGGER.debug("######### result => " + resultHm);
            	LOGGER.debug("######### inMap => " + inMap);
            	LOGGER.debug("######### input => " + input);
            	LOGGER.debug("##### loginUser => " + loginUser);
            	//LOGGER.debug("#########" + result.get("returnCode"));
            	LOGGER.debug("######################### 패스워드불일치 #########################");
                rtnMsg = messageSourceAccessor.getMessage(inMap.get("returnCode").toString());
                
                //if(result.getString("lock").equals("N")){
                if(inMap.get("lock").toString().equals("N")){
                    //rtnMsg += "\n총 5회중 "+result.getString("failCnt")+"회 실패하셨습니다!";
                	rtnMsg += "\\n총 5회중 "+inMap.get("failCnt")+"회 실패하셨습니다!";
                }

                //LMessageParameter.setMessageParameter(rtnMsg);
                //redirectAttributes.addAttribute("errorMsg",rtnMsg);
                //model.addAttribute("errorMsg",rtnMsg);
                SayMessage.setMessage(rtnMsg);
            }else{
                //LSayMessage.setMessageCode("msg.alert.login.warning");
                //LMessageParameter.setMessageParameter(LMessage.getInstance().getMessage("msg.alert.login.warning"));
            	//String rtnMsg = messageSource.getMessage("msg.alert.login.warning", null, Locale.KOREA);
            	rtnMsg = messageSourceAccessor.getMessage("msg.alert.login.warning");
            	//redirectAttributes.addAttribute("errorMsg",rtnMsg);
            	//model.addAttribute("errorMsg",rtnMsg);
            	SayMessage.setMessage(rtnMsg);
            }
            //LNavigationAlter.setReturnUrl("/common/page_Navi/itgLoginForm.dev");
            //LNavigationAlter.setReturnHandler("alertAndMoveUrlHandler");
            SayMessage.setMessage(rtnMsg);
            LOGGER.debug("##### rtnMsg => " + rtnMsg);
            return "redirect:/common/login/itgLoginForm.do";
            //return "web/system/login/itgLoginForm";
            
//2013.12.26 로그인 오류 메세지 처리                
//        }else if(validation == "0002"){             // 비밀번호가 틀렸을 때 
//            LMessageParameter.setMessageParameter(LMessage.getInstance().getMessage("msg.alert.login.wrongPw"));
//            LNavigationAlter.setReturnHandler("alertAndBack");
//            LNavigationAlter.setReturnUrl("1");  
        } else if(validation == "0006"){             // 퇴직직원인 경우
            //LMessageParameter.setMessageParameter(LMessage.getInstance().getMessage("msg.alert.login.notEmployee"));
        	//String rtnMsg = messageSource.getMessage("msg.alert.login.notEmployee", null, Locale.KOREA);
        	String rtnMsg = messageSourceAccessor.getMessage("msg.alert.login.notEmployee");
        	//redirectAttributes.addAttribute("errorMsg",rtnMsg);
        	//model.addAttribute("errorMsg",rtnMsg);
        	SayMessage.setMessage(rtnMsg);
            //LNavigationAlter.setReturnHandler("alertAndBack");
            //LNavigationAlter.setReturnUrl("1");
        	//return "/common/login/itgLoginForm.do";
        	return "redirect:/common/login/itgLoginForm.do";
        } else if(validation == "0007"){             // get 방식으로 로그인한 경우 
            //LMessageParameter.setMessageParameter(LMessage.getInstance().getMessage("msg.alert.wrongAccess"));
        	//String rtnMsg = messageSource.getMessage("msg.alert.wrongAccess", null, Locale.KOREA);
        	String rtnMsg = messageSourceAccessor.getMessage("msg.alert.wrongAccess");
        	//redirectAttributes.addAttribute("errorMsg",rtnMsg);
        	//model.addAttribute("errorMsg",rtnMsg);
        	SayMessage.setMessage(rtnMsg);
            //LNavigationAlter.setReturnHandler("alertAndBack");
            //LNavigationAlter.setReturnUrl("1");
        	//return "/common/login/itgLoginForm.do";
        	return "redirect:/common/login/itgLoginForm.do";
        }        
		
        //메인화면 이동 필요
		//return "web/system/login/session_test";
        //return "redirect:/esti/list/estiList.do";
        return "redirect:/index.do";
	}		
}
