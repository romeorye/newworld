package iris.web.system.login.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang.StringUtils;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.context.MessageSource;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.lghausys.eam.EAMUtil;
import com.lghausys.eam.domain.LeftMenuVO;
import com.lghausys.eam.domain.RoleUserInfoVO;
import com.lghausys.eam.domain.UserVO;
import com.lghausys.eam.exception.EAMException;

import devonframe.message.saymessage.SayMessage;
import devonframe.util.NullUtil;
import iris.web.common.util.FormatHelper;
import iris.web.system.login.service.IrisEncryptionService;
import iris.web.system.login.service.IrisLoginService;

/********************************************************************************
 * NAME : IrisLoginController.java 
 * DESC : 초기 로긴처리 controller
 * PROJ : IRIS UPGRADE 1차 프로젝트
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG                       
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION                        
 * ----------  ------  --------------------------------------------------------- 
 * 2016.07.08  조종민  최초생성            
 *********************************************************************************/

@Controller
public class IrisLoginController {

    @Resource(name = "irisLoginService")
    private IrisLoginService loginService;
    
    @Resource(name = "irisEncryptionService")
    private IrisEncryptionService irisEncryptionService;    
    
    @Resource(name="messageSource")
    MessageSource messageSource;

    @Resource(name="messageSourceAccessor")
    private MessageSourceAccessor messageSourceAccessor;
    
    
    static final Logger LOGGER = LogManager.getLogger(IrisLoginController.class);

    @RequestMapping(value="/common/login/irisDirectLogin.do")
    public String resortDirectLogin( 
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
            ModelMap model ,
            @CookieValue(value="LG_GP_SI", required=true) String lycos )  throws Exception{
            
            xcmkCd = "";
            eeId = "";
            pwd = "";
            vowFlag = "";
            securityFlag = "";
            //input.put("eeId", lycos);
            
            
            /*
            if (!"".equals(lycos)){
                eeId ="directLoginTrue";    
            }

            
             * SsoConfig sso = new SsoConfig();

            String sso_id = sso.getSsoId(request);
            
            //return this.doLogin(xcmkCd, eeId, pwd, vowFlag, securityFlag, input, request, response, session, model) ;
            if( "".equals(sso_id)){
                sso_id = CommonUtil.getCookieSsoUserId(request);
            }
            
            //4.쿠키 유효성 확인 :0(정상)
            String retCode = sso.getEamSessionCheckAndAgentVaild(request,response);
            if(!retCode.equals("0")){
                return "common/error/ssoError";
            }
            //5.업무시스템에 읽을 사용자 아이디를 세션으로 생성
            input.put("eeId", sso_id );
            //input.put("ssoUserId", input.get("lycos"));
            */
            
            javax.servlet.http.Cookie [] cookies = request.getCookies();
            
            if(cookies != null) {
             for(int i = 0 ; i < cookies.length ; i++) {
              javax.servlet.http.Cookie cookie = cookies[i];
            
              if(cookie.getName().equals("LG_GP_SI")) {
               String encUid = cookie.getValue();
               System.out.println("ENC UID : " + encUid);
              
               String plainUid = com.lgcns.encypt.EncryptUtil.decryptText(encUid, "amZrbGRzYWpmO2tk");
               System.out.println("PLAIN UID : " + plainUid);
               eeId = plainUid;
              }
             }
            }
            System.out.println("eeId UID : " + eeId);
            input.put("eeId", eeId);
            //6.업무시스템 페이지 호출(세션 페이지 또는 메인페이지 지정)  --> 업무시스템에 맞게 URL 수정!
            return this.doLogin(xcmkCd, eeId, pwd, vowFlag, securityFlag, input, request, response, session, model) ;
            
    }
    
    
    @RequestMapping(value="/common/login/tryIrisLogin.do")
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
        LOGGER.debug("IrisLoginController - doLogin [로긴 시작]");
        LOGGER.debug("xcmkCd => " + xcmkCd);
        LOGGER.debug("eeId => " + eeId);
        LOGGER.debug("pwd => " + pwd);
        LOGGER.debug("xcmkCd => " + input.get("xcmkCd"));
        LOGGER.debug("vowFlag => " + input.get("vowFlag"));
        LOGGER.debug("input eeId => " + input.get("eeId"));
        LOGGER.debug("###########################################################");
        
        HashMap loginUser = null;   // 사용자 마스터에서 해당 사용자 정보를 조회한 결과
        boolean userOk = true;      // 유효한 사용자인지
        String validation = null;   // 로그인 validation 값. 
        ArrayList loginInfo = new ArrayList();
        HashMap lsession = null;
        String rtnMsg = "";
        
        //세션 생성
        HashMap resultData = null;    // 세션 생성을 하기 위한 정보 조회         
        
        /*
        // 주소창에 get방식으로 입력하여 로그인할 경우 차단. 
        // direct에서 들어오는 경우가 아니라면 주소창에서 직접입력을 차단함.        
        if(!"directLoginTrue".equals(eeId)){
            if("GET".equals(request.getMethod())) {
                userOk = false;
                validation = "0007";
            }
            // get 방식 방지 끝
        }
        */
        //vpn 접속 차단
        String userip = request.getRemoteAddr();

        if(userip.equals("10.0.39.110") || userip.equals("10.0.39.104")){
            userOk = false;
            validation = "0008";
            
            return "redirect:/common/login/vpnError.do";
        }
        
        if(userOk){
            List loginUserList = loginService.evalUser(input);
            //LOGGER.debug("loginUserList => " + loginUserList);
            
            // 사용자 정보가 없을 때
            if(NullUtil.isNull(loginUserList)|| loginUserList.size() < 1){
                userOk = false;
                validation = "0001";                
            } else {    
                loginUser = (HashMap)loginUserList.get(0);
                //LOGGER.debug("loginUserList.get(0) => " + loginUser);
                validation = "9999";  // 정상 
            }
            LOGGER.debug("사용자 조회 완료");
        }
        
        LOGGER.debug("###########################################################");
        LOGGER.debug("userOk => " + userOk);
        LOGGER.debug("validation => " + validation);
        LOGGER.debug("###########################################################");
        
        LOGGER.debug("######################### 로그인 정보 확인 #########################");
        LOGGER.debug(loginUser != null ? loginUser.toString(): "null");/*[EAM추가] - null참조방지*/
        LOGGER.debug("######################### 로그인 정보 확인 #########################");             
        LOGGER.debug("##### validation  : " + validation );
        
        if(validation == "9999") {
            
            model.put("userInfo", input);

            // 세션 생성하기 위한 사용자 정보 조회 
            resultData = loginService.retrieveUserDetail(loginUser);

            if(!resultData.isEmpty()) {
                //[EAM추가] - 사용자 시스템 권한 확인 Start ===========================================================
                // ※  N 인경우 권한없음 오류 메시지 처리 / D 인경우 장기미사용 접근불가 오류 메시지 및 해제신청 가이드 처리
                boolean errFlag = false;
                String alertMsg = "";
                String logMsg = "";
                EAMUtil eamUtil = EAMUtil.getInstance();
                String userSabun = eamUtil.nvlObj(resultData.get("sa_sabun_new"), "");
//String userSabun = "FB1690"; //신동욱
//String userSabun = "FB1729"; //한용운
                StringBuffer roleIds = new StringBuffer();
                Map reqData = new HashMap();
                reqData.put("SYS_CD", "IRI");   //시스템 코드
                reqData.put("EMP_NO", userSabun);   //사용자 사번
                try {
                    List list = eamUtil.eamCall("EAM_USER", reqData);
                    if(list!=null && list.size()>0) {
                        UserVO userVO = (UserVO)list.get(0);
                        String retCd = userVO.getRetCd();
                        if(!"Y".equals(retCd)) {
                            if("D".equals(retCd)) { //장기미사용 접근불가
                                throw new EAMException(true, "MSG_ERR_NOUSE");
                            }else {     //접근권한 부재
                                throw new EAMException(true, "MSG_ERR_NOAUTH");
                            }
                        } else {
                            reqData.put("ROLE_ID", "");
                            
                            List roleUserInfoList = eamUtil.eamCall("EAM_ROLE_USER_INFO", reqData);
                            
                            if(roleUserInfoList!=null && roleUserInfoList.size()>0) {
                                RoleUserInfoVO roleUserInfoVO = null;
                                
                                for(int i=0, size=roleUserInfoList.size(); i<size; i++) {
                                    roleUserInfoVO = (RoleUserInfoVO)roleUserInfoList.get(i);
                                    
                                    roleIds.append("|").append(roleUserInfoVO.getRoleId());
                                }
                            }
                        }
                    }
                }catch(EAMException ea) {
                    errFlag = true;
                    logMsg = ea.getMessage();
                    alertMsg = ea.getRemoveMessage();
                }catch(Exception e) {
                    errFlag = true;
                    logMsg = e.toString();
                    alertMsg = eamUtil.getDefaultAlertMessage();
                }
                
                if(errFlag) {
                    LOGGER.error(logMsg);
                    SayMessage.setMessage(alertMsg);
                    //return "redirect:/index.do";
                    /////return "common/error/error";
                }
                //[EAM추가] - 사용자 시스템 권한 확인 END ===========================================================
                
                //[EAM추가] - TOP 메뉴 정보 조회 Start ===========================================================              
                List topMenuList = new ArrayList(); 
                errFlag = false;
                alertMsg = "";
                logMsg = "";
                reqData = new HashMap();
                reqData.put("SYS_CD", "IRI");                                                   //시스템 코드
                reqData.put("EMP_NO", userSabun);   //사용자 사번
                reqData.put("LOCALE_CD", "KR");                                                 //다국어코드 ('KR', 'EN', 'CH')
                
                try {
                    topMenuList = eamUtil.eamCall("EAM_TOP", reqData);
                    if(topMenuList == null || topMenuList.size() == 0) {
                        errFlag = true;
                        throw new EAMException(true, "MSG_ERR_MENU_NOAUTH");
                    }
                }catch(EAMException ea) {
                    errFlag = true;
                    logMsg = ea.getMessage();
                    alertMsg = ea.getRemoveMessage();
                }catch(Exception e) {
                    errFlag = true;
                    logMsg = e.toString();
                    alertMsg = eamUtil.getDefaultAlertMessage();
                }
                
                if(errFlag) {
                    topMenuList = new ArrayList();
                    SayMessage.setMessage(alertMsg);
                }                           
                
                //LOGGER.debug("topMenuList:" + topMenuList);
                //[EAM추가] - TOP 메뉴 정보 조회 End =============================================================
                
                //[EAM추가] - EAM 관리 전체 메뉴 URL 조회 Start ===========================================================
                List eamLeftMenuList = null;
                List eamMenuAcceptList = new ArrayList();
                List menuList = new ArrayList();
                List subMenuList = null;
                reqData = new HashMap();
                
                reqData.put("SYS_CD", "IRI");       //시스템 코드
                reqData.put("EMP_NO", userSabun);   //사용자 사번
                reqData.put("MENU_TYPE", "B");      //TOP메뉴프레임('A':TOP메뉴사용 / 'B':TOP메뉴미사용 / 'C':전체메뉴조회)
                reqData.put("SUB_SYS_ID", "");      //상위 업무그룹 코드 ('B','C' 인경우 입력 불필요)
                reqData.put("LOCALE_CD", "KR");     //다국어코드 ('KR', 'EN', 'CH')
                try {
                    eamLeftMenuList = eamUtil.eamCall("EAM_LEFT", reqData);
                    if(eamLeftMenuList!=null && eamLeftMenuList.size()>0) {
                        for(int i=0; i<eamLeftMenuList.size(); i++) {
                            LeftMenuVO leftMenuVO = (LeftMenuVO)eamLeftMenuList.get(i);
                            
                            if("0".equals(leftMenuVO.getMenuLevel())) {
                                if(subMenuList != null) {
                                    menuList.add(subMenuList);
                                }
                                
                                subMenuList = new ArrayList();
                            }
                            
                            subMenuList.add(leftMenuVO);
                            
                            String menuPath = eamUtil.nvl(leftMenuVO.getMenuPath());
                            if(!"".equals(menuPath) && !eamMenuAcceptList.contains(menuPath)) {
                                eamMenuAcceptList.add(menuPath);
                            }
                        }
                        
                        if(subMenuList != null) {
                            menuList.add(subMenuList);
                        }
                    }
                }catch(EAMException ea) {
                    errFlag = true;
                    logMsg = ea.getMessage();
                    alertMsg = ea.getRemoveMessage();
                }catch(Exception e) {
                    errFlag = true;
                    logMsg = e.toString();
                    alertMsg = eamUtil.getDefaultAlertMessage();
                }
                if(errFlag) {
                    LOGGER.error(logMsg);
                    SayMessage.setMessage(alertMsg);
                    //return "redirect:/common/login/itgLoginForm.do";
                    /////return "web/system/main";
                }
                //[EAM추가] - EAM 관리 전체 메뉴 URL 조회 End ===========================================================
                
                lsession = new HashMap();
  
                lsession.put("_userId"   , NullUtil.nvl(resultData.get("sa_user"), ""));  
                lsession.put("_userSabun"   , userSabun);
                lsession.put("_userGubun"   , NullUtil.nvl(resultData.get("sa_gubun"), ""));
                lsession.put("_userNm"   , NullUtil.nvl(resultData.get("sa_name"), ""));
                lsession.put("_userDept"   , NullUtil.nvl(resultData.get("sa_dept"), ""));
                lsession.put("_userDeptName"   , NullUtil.nvl(resultData.get("sa_dept_name"), ""));
                lsession.put("_userJobx"   , NullUtil.nvl(resultData.get("sa_jobx"), ""));
                lsession.put("_userJobxName"   , NullUtil.nvl(resultData.get("sa_jobx_name"), ""));
                lsession.put("_userFunc"   , NullUtil.nvl(resultData.get("sa_func"), ""));
                lsession.put("_userFuncName"   , NullUtil.nvl(resultData.get("sa_func_name"), ""));
                lsession.put("_userEmail"   , NullUtil.nvl(resultData.get("sa_mail"), ""));
                lsession.put("_teamDept"   , NullUtil.nvl(resultData.get("team_dept"), ""));
                lsession.put("_roleId",      "WORK_IRI_T01"); //roleIds.substring(1));
                lsession.put("_loginTime",  FormatHelper.curTime());  //로그인 시간
                lsession.put("rowsPerPage",  "100");      // 그리드 리스트에서 한 화면에 보이는 row 수                                
                lsession.put("sessionID",  session.getId());
                
                LOGGER.debug("[lsession]", lsession);
                
                //세션 시간 설정
                session.setAttribute("irisSession", lsession);     
                                
                //[EAM추가] EAM top리스트, 관리 전체 메뉴 URL 세션 추가                
                session.setAttribute("topMenuList", topMenuList);
                session.setAttribute("menuList", menuList);
                session.setAttribute("eamMenuAcceptList", eamMenuAcceptList);
               
                //로그인 유저관리 클래스 호출.
                //LOGGER.debug("*****세션 생성 시작");
                //LOGGER.debug("생성된 세션ID: [" + session.getId() + "]");
                //LOGGER.debug("생성된 로그인ID: [" + lsession.get("_userId") + "]");
                //LOGGER.debug("*****세션 생성 끝");
                    
                //LActionContext.setAttribute("loginUser", lsession);
                model.addAttribute("loginUser", lsession);

                LOGGER.debug("session ::::" + lsession.toString());
            }
        
        } else if(validation == "0001" || validation == "0002" ){            // 사용자 정보가 없을 때 

            rtnMsg = messageSourceAccessor.getMessage("msg.alert.login.warning");
            SayMessage.setMessage(rtnMsg);

            SayMessage.setMessage(rtnMsg);
            
            return "common/error/ssoError";
            
        }else if (validation == "0008"){
            rtnMsg = "정상적인 접속대상이 아닙니다.";
            SayMessage.setMessage(rtnMsg);

            SayMessage.setMessage(rtnMsg);
            //LOGGER.debug("##### rtnMsg => " + rtnMsg);
        }
        
        /*try {
            
            // 로그인 정보 저장
            HashMap<String, String> param = (HashMap<String, String>) input.clone();
            param.put("loginId",     ""+lsession.get("_userId"));
            param.put("loginValid",  validation);
            param.put("userIp",      CommonUtil.getClientIP(request));
            
            param.put("saSabunNew",  ""+lsession.get("_userSabun"));
            param.put("saSabunName", ""+lsession.get("_userNm"));
            
            param.put("serverIp",    InetAddress.getLocalHost().getHostAddress());
            param.put("headerInfo",  CommonUtil.getHeaderValues(request));
            param.put("successYn",   (validation == "9999") ? "Y" : "N");
            param.put("errorMsg",    rtnMsg);
            param.put("refererUrl",  request.getHeader("referer"));
            param.put("servletPath", request.getServletPath());
            
            loginService.insertLoginLog(param);
            
        } catch(Exception e) {
            e.printStackTrace();
        }*/
        
        String reUrl = input.get("reUrl");
        
        if(StringUtils.isNotEmpty(reUrl)) {
            Map.Entry entry = null;
            StringBuffer params = new StringBuffer("");
            Iterator iterator = input.entrySet().iterator();
            
            while (iterator.hasNext()) {
                entry = (Map.Entry) iterator.next();
                if("|reUrl|eeId|".indexOf((String)entry.getKey()) == -1) {
                    params.append(params.length() == 0 ? "?" : "&").append(entry.getKey()).append("=").append(entry.getValue());
                }
            }
            
            LOGGER.debug("##### " + reUrl + " 로 이동");
            
            return "redirect:" + reUrl + params;
        } else {
            String roleId = (String)((HashMap)session.getAttribute("irisSession")).get("_roleId");
            
            if(roleId.indexOf("WORK_IRI_T07") > -1 ||
                    roleId.indexOf("WORK_IRI_T08") > -1 ||
                    roleId.indexOf("WORK_IRI_T09") > -1 ||
                    roleId.indexOf("WORK_IRI_T10") > -1 ||
                    roleId.indexOf("WORK_IRI_T11") > -1 ||
                    roleId.indexOf("WORK_IRI_T12") > -1 ||
                    roleId.indexOf("WORK_IRI_T13") > -1 ||
                    roleId.indexOf("WORK_IRI_T14") > -1 ||
                    roleId.indexOf("WORK_IRI_T19") > -1) {
                LOGGER.debug("##### /anl/main.do 로 이동");
                
                return "redirect:/anl/main.do";
            } else {
                LOGGER.debug("##### /prj/main.do 로 이동");
                
                /////return "redirect:/prj/main.do";
                return "redirect:/menu/index.html";
            }
        }
    }
    
    @RequestMapping(value="/common/login/sessionError.do")
    public String retrieveReLoginForm(String redirectUrl,  HttpSession session, ModelMap model){
        if(redirectUrl != null && !redirectUrl.trim().equals("")) {
            model.addAttribute("redirectUrl", redirectUrl);
        }
        
        if(session != null) {
              HashMap lsession = (HashMap)session.getAttribute("irisSession");
              session.invalidate();
          }else{
              //System.out.println("session is null");
        }
        
        LOGGER.debug("###########################################################");
        LOGGER.debug("IrissLoginController - retrieveReLoginForm [로긴폼 호출]");
        LOGGER.debug("###########################################################");
        
        return "common/error/sessionError";
    }
    
    @RequestMapping(value="/common/login/vpnError.do")
    public String retrieveVpnError(String redirectUrl,  HttpSession session, ModelMap model){
        if(redirectUrl != null && !redirectUrl.trim().equals("")) {
            model.addAttribute("redirectUrl", redirectUrl);
        }
        
        if(session != null) {
            //System.out.println(session.toString());
              HashMap lsession = (HashMap)session.getAttribute("irisSession");
              session.invalidate();
          }else{
              //System.out.println("session is null");
        }
        
        LOGGER.debug("###########################################################");
        LOGGER.debug("retrieveVpnError - retrieveVpnError [로긴폼 호출]");
        LOGGER.debug("###########################################################");
        
        return "common/error/vpnError";
    }
    
    
    @RequestMapping(value="/common/login/todoLogin.do")
    public String todoLogin(String redirectUrl,  HttpSession session, ModelMap model){
        if(redirectUrl != null && !redirectUrl.trim().equals("")) {
            model.addAttribute("redirectUrl", redirectUrl);
        }
        
        if(session != null) {
            //System.out.println(session.toString());
              HashMap lsession = (HashMap)session.getAttribute("irisSession");
              session.invalidate();
          }else{
              //System.out.println("session is null");
        }
        
        LOGGER.debug("###########################################################");
        LOGGER.debug("retrieveVpnError - retrieveVpnError [로긴폼 호출]");
        LOGGER.debug("###########################################################");
        
        return "common/error/vpnError";
    }
    
    @RequestMapping(value="/common/login/irisTodoLogin.do")
    public String irisTodoLogin( 
            String xcmkCd, 
            String eeId , 
            String pwd, 
            String vowFlag,
            String securityFlag,
            @RequestParam HashMap<String, String> input,
            HttpServletRequest request, 
            HttpServletResponse response, 
            HttpSession session, 
            ModelMap model , String lycos ){
            
            xcmkCd = "";
            eeId = "";
            pwd = "";
            vowFlag = "";
            securityFlag = "";

            lycos = request.getParameter("user_id");
            
            input.put("eeId", lycos);
            
            if (!"".equals(lycos)){
                eeId ="directLoginTrue";    
            }
            
            return this.doLogin(xcmkCd, eeId, pwd, vowFlag, securityFlag, input, request, response, session, model) ;
    }
    
    
    
}