/*------------------------------------------------------------------------------
 * NAME : IrisFrameMenuController
 * DESC : 메뉴 관련 처리 controller
 * VER  : V1.0
 * PROJ : LG CNS WINS 업그레이드 1차 프로젝트
 * Copyright 2016 LG CNS All rights reserved
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION
 * ----------  ------  ---------------------------------------------------------
 * 2016/06/07  김수예   최초생성
 *------------------------------------------------------------------------------*/

package iris.web.system.menu.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.LocaleResolver;
import org.springframework.web.servlet.ModelAndView;

import com.lghausys.eam.EAMUtil;
import com.lghausys.eam.domain.TopMenuVO;
import com.lghausys.eam.exception.EAMException;

import devonframe.configuration.ConfigService;
import devonframe.message.saymessage.SayMessage;
import devonframe.util.NullUtil;
import iris.web.common.converter.RuiConverter;
import iris.web.common.util.StringUtil;
import iris.web.system.base.IrisBaseController;
import iris.web.system.menu.service.IrisFrameMenuService;


@Controller
public class IrisFrameMenuController extends IrisBaseController{

	@Resource(name="irisFrameMenuService")
	private IrisFrameMenuService frameMenuService;

    @Resource(name="localeResolver")
    LocaleResolver localeResolver;

	@Resource(name="messageSourceAccessor")
	private MessageSourceAccessor messageSourceAccessor;

    @Resource(name = "configService")
    private ConfigService configService;

    static final Logger LOGGER = LogManager.getLogger(IrisFrameMenuController.class);

    @RequestMapping("/index.do")
	public String retrieveMenuAffrList(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			) {
    	LOGGER.debug("###########################################################");
		LOGGER.debug("IrisFrameMenuController - retrieveMenuAffrList [메뉴존재여부확인]");
		LOGGER.debug("###########################################################");

		//[EAM추가] - 20170420 TOP 정보 세팅 Start ===========================================================
		checkSession(input, session, model);

		String key = null;
    	Map.Entry entry = null;
    	StringBuffer params = new StringBuffer("");
        Iterator iterator = input.entrySet().iterator();

        while (iterator.hasNext()) {
            entry = (Map.Entry) iterator.next();

            key = (String)entry.getKey();

            if(key.startsWith("_") == false && "|sessionID|rowsPerPage|".indexOf(key) == -1) {
                params.append(params.length() == 0 ? "?" : "&").append(entry.getKey()).append("=").append(entry.getValue());
            }
        }

		model.addAttribute("menuMoveYn", input.get("menuMoveYn"));
		model.addAttribute("vMenuId", input.get("vMenuId"));
		model.addAttribute("parentMenuId", input.get("parentMenuId"));
		model.addAttribute("params", params.toString());
		//[EAM추가] - TOP 정보 세팅 End ===========================================================

		return "web/system/frame";
	}


	@RequestMapping("/system/header.do")
	public String header(HttpServletRequest request, ModelMap model) {
		return "web/system/frame/header";
	}

	@RequestMapping("/system/body.do")
	public String body() {
		return "web/system/frame/body";
	}

	@RequestMapping("/system/menu/irisFrameMenu/footer.do")
	public String footer(HttpServletRequest request, Model model) {
		return "web/system/frame/footer";
	}

	@RequestMapping("/system/menu/irisFrameMenu/menuFrame.do")
	public String menuFrame(HttpServletRequest request, Model model) {
		return "web/system/frame/menuFrame";
	}

	@RequestMapping("/system/menu/irisFrameMenu/top.do")
	public String retrieveTopMenuList(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			) {
		LOGGER.debug("###########################################################");
		LOGGER.debug("IrisFrameMenuController - retrieveTopMenuList [1단계 메뉴호출]");
		LOGGER.debug("###########################################################");

		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);
		if(NullUtil.isNull(input.get("_userId")) ||  NullUtil.nvl(input.get("_userId"), "").equals("-1")  ){
			LOGGER.debug("checkSession::::::::::::::::::::::::::::::::"+input);
			String rtnMsg = messageSourceAccessor.getMessage("msg.alert.sessionTimeout");
			SayMessage.setMessage(rtnMsg);
        } else {

        	//[EAM추가] - TOP 메뉴 정보 조회 Start ===========================================================
        	HashMap lsession = (HashMap)request.getSession().getAttribute("irisSession");

        	EAMUtil eamUtil = EAMUtil.getInstance();
        	List topMenuList = new ArrayList();
        	boolean errFlag = true;
        	String alertMsg = "";
        	String logMsg = "";
        	Map reqData = new HashMap();
    		reqData.put("SYS_CD", "IRI");													//시스템 코드
    		reqData.put("EMP_NO", NullUtil.nvl((String)lsession.get("_userSabun"), ""));	//사용자 사번
    		reqData.put("LOCALE_CD", "KR");													//다국어코드 ('KR', 'EN', 'CH')

    		try {
    			topMenuList = eamUtil.eamCall("EAM_TOP", reqData);
    			if(topMenuList!=null && topMenuList.size()>0) {
    				errFlag = false;
    			}else {
    				throw new EAMException(true, "MSG_ERR_MENU_NOAUTH");
    			}
    		}catch(EAMException ea) {
    			logMsg = ea.getMessage();
    			alertMsg = ea.getRemoveMessage();
    		}catch(Exception e) {
    			logMsg = e.toString();
    			alertMsg = eamUtil.getDefaultAlertMessage();
    		}
    		if(errFlag) {
    			topMenuList = new ArrayList();
    			LOGGER.error(logMsg);
    			SayMessage.setMessage(alertMsg);
    		}

        	HashMap <String, Object> data = new HashMap <String, Object> ();
        	input.put("userId", String.valueOf(input.get("_userId")));
        	input.put("_userTypCd", String.valueOf(input.get("_userTypCd")));
        	input.put("eeId", input.get("_userId"));
        	input.put("xcmkCd", input.get("_xcmkCd"));

        	model.addAttribute("lsession", input);
        	model.addAttribute("topMenuList", topMenuList);

			LOGGER.debug("lsession:" + input);
			LOGGER.debug("topMenuList:" + topMenuList);
        	//[EAM추가] - TOP 메뉴 정보 조회 End =============================================================
        }

		return "web/system/frame/top";
	}

	@RequestMapping("/system/menu/irisFrameMenu/left.do")
	public String retrieveLeftMenuList(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model) {

		LOGGER.debug("###########################################################");
		LOGGER.debug("IrisFrameMenuController - retrieveLeftMenuList [2,3단계 메뉴호출]");
		LOGGER.debug("###########################################################");

		checkSession(input, session, model);
		input.put("eeId", input.get("_userId"));
    	input.put("xcmkCd", input.get("_xcmkCd"));

		if(NullUtil.isNull(input.get("_userId")) ||  NullUtil.nvl(input.get("_userId"), "").equals("-1")  ){
			String rtnMsg = messageSourceAccessor.getMessage("msg.alert.sessionTimeout");
			SayMessage.setMessage(rtnMsg);
        } else {
        	//[EAM추가] - LEFT 메뉴 정보 조회 Start =============================================================
        	HashMap <String, Object> data = new HashMap <String, Object> ();

        	HashMap lsession = (HashMap)request.getSession().getAttribute("irisSession");
        	EAMUtil eamUtil = EAMUtil.getInstance();
        	String userSabun = NullUtil.nvl((String)lsession.get("_userSabun"), "");

        	boolean errFlag = true;
        	String alertMsg = "";
        	String logMsg = "";
        	String parentMenuId = NullUtil.nvl(input.get("parentMenuId"), "");	//[EAM]menuId
        	String parentMenuNm = NullUtil.nvl(input.get("parentMenuNm"), "");	//[EAM]menuNm
        	String vMenuId = NullUtil.nvl(input.get("vMenuId"), "");			//[EAM]subSysId

        	/*20170420 수정 Start*/
        	Map reqDataTop = new HashMap();
        	List eamTopMenuList = null;
        	reqDataTop.put("SYS_CD", "IRI");							//시스템 코드
        	reqDataTop.put("EMP_NO", NullUtil.nvl(userSabun, ""));		//사용자 사번
        	reqDataTop.put("LOCALE_CD", "KR");							//다국어코드 ('KR', 'EN', 'CH')
    		try {
    			eamTopMenuList = eamUtil.eamCall("EAM_TOP", reqDataTop);
    			if(eamTopMenuList!=null && eamTopMenuList.size()>0) {
    				errFlag = false;
    			}else {
    				throw new EAMException(true, "MSG_ERR_MENU_NOAUTH");
    			}
    		}catch(EAMException ea) {
    			logMsg = ea.getMessage();
    			alertMsg = ea.getRemoveMessage();
    		}catch(Exception e) {
    			logMsg = e.toString();
    			alertMsg = eamUtil.getDefaultAlertMessage();
    		}

			//만약에 조회조건에서 부모메뉴가 없다면, 부모메뉴 중 첫번째 메뉴의 하위메뉴를 조회한다.
	        if(NullUtil.isNone(vMenuId)) {
	        	TopMenuVO topMenuVO = (TopMenuVO)eamTopMenuList.get(0);
				parentMenuId = topMenuVO.getMenuId();
				parentMenuNm = topMenuVO.getMenuNm();
				vMenuId = topMenuVO.getSubSysId();
	        } else {
	        	//부모메뉴명 세팅 (화면에서 받아올경우 한글깨짐)
	        	TopMenuVO topMenuVO = new TopMenuVO();
	        	for(int i=0; i<eamTopMenuList.size(); i++){
	        		topMenuVO = (TopMenuVO)eamTopMenuList.get(i);

	        		if(topMenuVO != null && (parentMenuId.equals(topMenuVO.getMenuId())) || vMenuId.equals(topMenuVO.getSubSysId())){
	        			parentMenuNm = topMenuVO.getMenuNm();
	        		}
	        	}

	        	errFlag = false;
	        }
	        /*20170420 수정 End*/


	        if(errFlag) {	//에러가 존재한다면 에러처리
    			LOGGER.error(logMsg);
    			SayMessage.setMessage(alertMsg);
	        }else {			//에러가 없다면 진행
		        List subMenuList = new ArrayList();
		        if(!errFlag) {
		        	Map reqData = new HashMap();
		    		reqData.put("SYS_CD", "IRI");						//시스템 코드
		    		reqData.put("EMP_NO", NullUtil.nvl(userSabun, ""));	//사용자 사번
		    		reqData.put("MENU_TYPE", "A");						//TOP메뉴프레임('A':TOP메뉴사용 / 'B':TOP메뉴미사용 / 'C':전체메뉴조회)
		    		reqData.put("SUB_SYS_ID", vMenuId);					//상위 업무그룹 코드 ('B','C' 인경우 입력 불필요)
		    		reqData.put("LOCALE_CD", "KR");						//다국어코드 ('KR', 'EN', 'CH')
		    		try {
		    			List eamLeftMenuList = eamUtil.eamCall("EAM_LEFT", reqData);	//웹서비스 호출(jar)
		    			if(eamLeftMenuList!=null && eamLeftMenuList.size()>0) {
		    				subMenuList = eamLeftMenuList;
		    				errFlag = false;
		    			}else {
		    				throw new EAMException(true, "MSG_ERR_MENU_NOAUTH");
		    			}
		    		}catch(EAMException ea) {
		    			logMsg = ea.getMessage();
		    			alertMsg = ea.getRemoveMessage();
		    		}catch(Exception e) {
		    			logMsg = e.toString();
		    			alertMsg = eamUtil.getDefaultAlertMessage();
		    		}
		        }

				String key = null;
		    	Map.Entry entry = null;
		    	StringBuffer params = new StringBuffer("");
		        Iterator iterator = input.entrySet().iterator();

		        while (iterator.hasNext()) {
		            entry = (Map.Entry) iterator.next();

		            key = (String)entry.getKey();

		            if(key.startsWith("_") == false && "|sessionID|rowsPerPage|menuMoveYn|parentMenuId|menuPath|vMenuId|menuId|eeId|xcmkCd|".indexOf(key) == -1) {
		                params.append("&").append(entry.getKey()).append("=").append(entry.getValue());
		            }
		        }

		        model.addAttribute("menuMoveYn", input.get("menuMoveYn"));
		        model.addAttribute("parentMenuId", parentMenuId);
				model.addAttribute("parentMenuNm", (String)parentMenuNm);
				model.addAttribute("subMenuList", subMenuList);
		        model.addAttribute("inputData", input);
		        model.addAttribute("params", params);

		        LOGGER.debug("##########input########################"+input);
				LOGGER.debug("##########parentMenuNm########################"+(String)parentMenuNm);
				LOGGER.debug("##########subMenuList########################"+subMenuList);
	        }
	        //[EAM추가] - LEFT 메뉴 정보 조회 End =============================================================

        }
		return "web/system/frame/left";
	}

	@RequestMapping("/system/menu/NwinsFrameMenu/main.do")
	public String main(@RequestParam HashMap<String, Object> input, HttpServletRequest request, HttpSession session, ModelMap model){

		LOGGER.debug("###########################################################");
		LOGGER.debug("IrisFrameMenuController - main [메인]");
		LOGGER.debug("###########################################################");

		checkSessionObjRUI(input, session, model);

		if(NullUtil.isNull(input.get("_userId")) ||  NullUtil.nvl(input.get("_userId"), "").equals("-1")  ){
			String rtnMsg = messageSourceAccessor.getMessage("msg.alert.sessionTimeout");
			SayMessage.setMessage(rtnMsg);
        }else{
        	LOGGER.debug(":::::::::::>>>>>>>>>>>> input = " + input);
        	LOGGER.debug(":::::::::::>>>>>>>>>>>> loginUser = " + model.get("loginUser"));

        	String xcmkType = NullUtil.nvl(input.get("_xcmkType"), "");
        	String xcmkCd = NullUtil.nvl(input.get("_xcmkCd"), "");		//L,T,C,D,H 등의 구분자가 들어간 코드 : 예) L1078718122
        	String xcmkCdN = NullUtil.nvl(input.get("_xcmkCdN"), ""); 	//구분자가 들어가지 않은 코드      예) 1078718122
        	String rgstYn = NullUtil.nvl(input.get("_rgstYn"), "");		//등록점 여부
        	String userId = NullUtil.nvl(input.get("_userId"), "");

        	if(!"L".equals(xcmkType)){
        		input.put("agenCd", xcmkCdN);
        	}

        	String gesiKind = "", gesiKind1 = "";

        	LOGGER.debug(":::::::::::>>>>>>>>>>>> xcmkType = " + xcmkType);

        	if ("L".equals(xcmkType)){
        		//LG사용자의 경우 전체 공지사항
                gesiKind = "01";
                gesiKind1 = "02";
        	}else{
				if("N".equals(rgstYn)) gesiKind = "01"; //대리점의 경우 대리점 공지사항
				else gesiKind = "02";    				//등록점의 경우 등록점 공지사항
        	}

        	LOGGER.debug(":::::::::::>>>>>>>>>>>> gesiKind = " + gesiKind + " / gesiKind1 = " + gesiKind1);

        	input.put("xcmkType", xcmkType);
        	input.put("gesiGubn", "A");	//A:LG하우시스 공지사항, B: 영업자료 게시판
        	input.put("gesiKind", gesiKind);
        	input.put("gesiKind1", gesiKind1);
        	input.put("rows", "7");
        	input.put("currPage", "1");

        	input.put("loginType", xcmkType);
        	input.put("userId", userId);

        	/** 공지사항 조회 */
//        	List <Map<String, Object>> noticeList = nwinsMainService.retrieveLgDataBoardList(input);
//        	model.addAttribute("noticeList", noticeList);
//
//        	/** 주문 진척 현황 조회 */
//        	List <Map<String, Object>> orderList = new ArrayList <Map<String, Object>> ();
//
//        	if(!"L".equals(xcmkType) || !"L1078718122".equals(xcmkCd))
//        		orderList = nwinsMainService.retrieveAgencyOrderStatusList(input);	//대리점: 로그인시점 대리점 코드가 L로 시작하지 안거나 L1078718122 아닌경우
//        	else
//        		orderList = nwinsMainService.retrieveLgOrderStatusList(input); 		//LG인경우(신유통인경우): 로그인시점 대리점 코드가 L로 시작하거나 L1078718122 인경우
//
//        	model.addAttribute("orderList", orderList);
//
//        	/** 주문진척 SMS 수신내역 조회 */
//        	Map <String, Object> smsRcvMap = nwinsMainService.retriveSmsRcvList(input);
//        	model.addAttribute("smsRcvMap", smsRcvMap);
//
//        	/** 내가 요청한 서비스 조회 */
        	String myReqCnt = "";//nwinsMainService.retriveMyReqCnt(input);
        	List <Map<String, Object>> myReqList = new ArrayList();//nwinsMainService.retriveMyReqList(input);
        	model.addAttribute("inputData", input);
        	model.addAttribute("myReqCnt", myReqCnt);
        	model.addAttribute("myReqList", myReqList);
        }

		return "web/system/main";
	}

	@RequestMapping("/system/menu/NwinsFrameMenu/myMenu.do")
	public ModelAndView myMenu(@RequestParam HashMap<String, Object> input, HttpServletRequest request,
							   HttpServletResponse response, HttpSession session, ModelMap model){

		LOGGER.debug("###########################################################");
		LOGGER.debug("IrisFrameMenuController - myMenu [견적 : 즐겨찾기(마이메뉴) 등록/삭제]");
		LOGGER.debug("###########################################################");

		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		ModelAndView modelAndView = new ModelAndView("ruiView");

		if(NullUtil.isNull(input.get("_userId")) ||  NullUtil.nvl(input.get("_userId"), "").equals("-1")  ){
			String rtnMsg = messageSourceAccessor.getMessage("msg.alert.sessionTimeout");
			SayMessage.setMessage(rtnMsg);
        } else {

        	try{

        		LOGGER.debug("###########################################################");
        		LOGGER.debug("loginUser => " + model.get("loginUser"));
        		LOGGER.debug("inputData => " + input);
        		LOGGER.debug("###########################################################");

            	input = StringUtil.toUtf8(input);

            	int rtnVal = 0;
            	String rtnSt = "", rtnMsg = "";

            	String menuId = NullUtil.nvl(input.get("menuId"), "");
            	String flag = NullUtil.nvl(input.get("flag"), "");

            	input.put("menuId", menuId);

            	Map <String, Object> chk = frameMenuService.checkMyMenu(input);

            	int cnt = Integer.parseInt(String.valueOf(chk.get("cnt")));
            	int allCnt = Integer.parseInt(String.valueOf(chk.get("allCnt")));

            	if(allCnt <= 15){
            		if("C".equals(flag)){
                		if(cnt == 0){
                			rtnVal = frameMenuService.insertMyMenu(input);

                			rtnSt = "SUCCESS";
                    		rtnMsg = "즐겨찾기에 등록되었습니다.";
                		}else{
                			rtnSt = "FAIL";
                    		rtnMsg = "이미 즐겨찾기에 등록되어있습니다.";
                		}
                	}else if("D".equals(flag)){
                		if(cnt != 0){
                			rtnVal = frameMenuService.deleteMyMenu(input);

                			rtnSt = "SUCCESS";
                    		rtnMsg = "즐겨찾기에서 삭제되었습니다.";
                		}else{
                			rtnSt = "FAIL";
                    		rtnMsg = "즐겨찾기에 등록되지 않은 메뉴입니다.";
                		}
                	}
            	}else{
            		rtnSt = "FAIL";
            		rtnMsg = "즐겨찾기는 최대 15개까지 등록이 가능합니다.";
            	}



            	input.put("rtnSt", rtnSt);
            	input.put("rtnMsg", rtnMsg);

    	        modelAndView.addObject("dataset", RuiConverter.createDataset("dataset", input));

    			LOGGER.debug("###########################################################");
    			LOGGER.debug("RuiConverter = > " + RuiConverter.createDataset("dataset", input));
    			LOGGER.debug("RuiConverter done!! ");
    			LOGGER.debug("###########################################################");

        	}catch(Exception e){
        		e.printStackTrace();
        	}

        }

		LOGGER.debug("###########################################################");
		LOGGER.debug("loginUser => " + model.get("loginUser"));
		LOGGER.debug("inputData => " + input);
		LOGGER.debug("rowsPerPage => " + model.get("rowsPerPage"));
		LOGGER.debug("###########################################################");

		return modelAndView;
	}

	@RequestMapping("/system/menu/NwinsFrameMenu/ViewDefaultPage.do")
	public String ViewDefaultPage(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model) {
		LOGGER.debug("###########################################################");
		LOGGER.debug("IrisFrameMenuController - ViewDefaultPage [메뉴 URL처리]");
		LOGGER.debug("###########################################################");

		checkSession(input, session, model);
		input.put("eeId", input.get("_userId"));
    	input.put("xcmkCd", input.get("_xcmkCd"));

		if(NullUtil.isNull(input.get("_userId")) ||  NullUtil.nvl(input.get("_userId"), "").equals("-1")  ){
			String rtnMsg = messageSourceAccessor.getMessage("msg.alert.sessionTimeout");
			SayMessage.setMessage(rtnMsg);
        } else {
        	Map <String, Object> urlData = new HashMap <String, Object> ();
        	List<Map<String, Object>> menuAffr = frameMenuService.retrieveMenuAffrList(input); // SIMD에 메뉴권한존재하는지 조회
        	HashMap hm = (HashMap)menuAffr.get(0);
            String affrScn = (String)hm.get("affrScn");
            String onlyAffrYn = (String)hm.get("onlyAffrYn");

            if((affrScn == "N") || affrScn.equals("N")) {
    			LOGGER.debug("###########################권한없음##########################");
    			String rtnMsg = messageSourceAccessor.getMessage("msg.alert.menuExistN");
    			SayMessage.setMessage(rtnMsg);
    			return "redirect:/common/login/itgLogout.do";
    		}else{
    			if(input.get("quickLinkYn").toString() != null && "Y".equals(input.get("quickLinkYn").toString())){  // 2. 퀵링크 통해서 들어온 경우
    				input.put("affrScn", input.get("affrScnQ").toString());
    				input.put("affrScnQ", input.get("affrScnQ").toString());
	             } else {    // 3. 권한 가진 메뉴가 존재하며, 퀵링크 통하기 전 초기 화면
	            	 input.put("affrScn", affrScn);
	            	 input.put("affrScnQ", "");
	             }

    		 Map <String, Object> subMenuData = frameMenuService.retrieveSubMenuId(input);
    		 input.put("choiceTopMenuId", NullUtil.nvl(subMenuData.get("topMenuId"),""));
    		 input.put("choiceSubMenuId", NullUtil.nvl(subMenuData.get("subMenuId"),""));

          // B2C-WINS 연결 2011.09.15 양호진 (001:b2c사이트에서 접속시)  / B2C-WINS 접속시 SSO처리 요청 건 | [요청번호]C20110916_63204 : WINS2 해당없음. 제외처리.
/*             if ("001".equals(data.getString("systemCd"))) {
                 subMenuData.setString("topMenuId", "T020006");      //헤더 => 견적/주문
                 subMenuData.setString("subMenuId", "T020103");      //디테일 => 견적등록  > 통합견젹
                 data.setString("choiceTopMenuId", "T020006");       //헤더 => 견적/주문
                 data.setString("choiceSubMenuId", "T020103");       //디테일 => 견적등록  > 통합견젹

             // 유리시스템 인도처(현장)등록 팝업 창에서 호출시
             } else if ("002".equals(data.getString("systemCd"))) {
                 subMenuData.setString("topMenuId", "T020006");      //헤더 => 견적/주문
                 subMenuData.setString("subMenuId", "T020156");      //디테일 => 현장관리
                 data.setString("choiceTopMenuId", "T020006");       //헤더 => 견적/주문
                 data.setString("choiceSubMenuId", "T020156");       //현장관리 => 현장관리

             } */

             int subMenuYn = frameMenuService.retrieveSubMenuYn(input);

             if(input.get("choiceTopMenuId").toString() != "" && input.get("choiceTopMenuId").toString() != null){
                 if(subMenuYn > 0) {
                     urlData = frameMenuService.retrieveThirdMenuUrl(input);
                 }
                 else {
                     urlData = frameMenuService.retrieveSubMenuUrl(input);
                 }
             }

             input.put("_choiceTopMenuId", subMenuData.get("topMenuId").toString());
             input.put("_dftMenuId", subMenuData.get("subMenuId").toString());
             input.put("onlyAffrYn", onlyAffrYn);
             input.put("quickLinkYn", NullUtil.nvl(input.get("quickLinkYn"),"N"));

             model.addAttribute("input", input);

    		}

        }
		return "web/system/frame";
	}

	@RequestMapping("/system/menu/NwinsFrameMenu/cnstwNotice.do")
	public String retrieveCnstwNotice(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			) {
		LOGGER.debug("###########################################################");
		LOGGER.debug("IrisFrameMenuController - retrieveCnstwNotice [이엔지팝업공지]");
		LOGGER.debug("###########################################################");

		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);
		if(NullUtil.isNull(input.get("_userId")) ||  NullUtil.nvl(input.get("_userId"), "").equals("-1")  ){
			LOGGER.debug("checkSession::::::::::::::::::::::::::::::::"+input);
			String rtnMsg = messageSourceAccessor.getMessage("msg.alert.sessionTimeout");
			SayMessage.setMessage(rtnMsg);
        } else {
        	input.put("eeId", input.get("_userId"));
        	input.put("xcmkCd", input.get("_xcmkCd"));

        	HashMap <String, Object> data = new HashMap <String, Object> ();
			data.put("_xcmkCd", String.valueOf(input.get("xcmkCd")));
			data.put("_userId", String.valueOf(input.get("_userId")));
			data.put("eeId", String.valueOf(input.get("_userId")));
			data.put("xcmkCd", String.valueOf(input.get("_xcmkCd")));

        }

		return "common/popup/cnstwNotice";
	}

}
