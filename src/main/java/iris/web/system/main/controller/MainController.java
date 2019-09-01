package iris.web.system.main.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.lgcns.ikep.common.security.SecurityEncrypter;

import devonframe.configuration.ConfigService;
import devonframe.message.saymessage.SayMessage;
import devonframe.util.DateUtil;
import devonframe.util.NullUtil;
import iris.web.common.util.CommonUtil;
import iris.web.prj.tss.com.service.TssUserService;
import iris.web.prj.tss.gen.service.GenTssService;
import iris.web.prj.tss.nat.service.NatTssService;
import iris.web.prj.tss.ousdcoo.service.OusdCooTssService;
import iris.web.system.base.IrisBaseController;
import iris.web.system.main.service.MainService;

/********************************************************************************
 * NAME : MainController.java
 * DESC : PROJECT 메인 controller
 * PROJ : IRIS 구축 프로젝트
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION
 * ----------  ------  ---------------------------------------------------------
 * 2017.10.19  IRIS04	최초생성
 *********************************************************************************/

@Controller
public class MainController extends IrisBaseController {

	@Resource(name="messageSourceAccessor")
	private MessageSourceAccessor messageSourceAccessor;

	@Resource(name = "mainService")
	private MainService mainService;

    @Resource(name = "genTssService")
    private GenTssService genTssService;

    @Resource(name = "natTssService")
    private NatTssService natTssService;

    @Resource(name = "ousdCooTssService")
    private OusdCooTssService ousdCooTssService;

    @Resource(name = "tssUserService")
    private TssUserService tssUserService;

	@Resource(name = "configService")
    private ConfigService configService;


	static final Logger LOGGER = LogManager.getLogger(MainController.class);

	/** 프로젝트 메인페이지 화면이동 
	 * @throws Exception **/
	@RequestMapping(value="/prj/main.do")
	public String retrievePrjMainInfo(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			) throws Exception{
		LOGGER.debug("########################################################################################");
		LOGGER.debug("MainController - retrievePrjMainInfo [프로젝트 메인페이지 화면이동]");
		LOGGER.debug("########################################################################################");

		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);
		LOGGER.debug("#######################input################################################################# : " + input);

		/* 지재권(지적 재산권) 사번 인코딩*/
		
		//byte[] row =   CommonUtil.getCookieSabun(input.get("_userSabun")).getBytes();
		
		//String encrytoEmpNo = CommonUtil.encode(row);
		String encrytoEmpNo = CommonUtil.getCookieSabun(input.get("_userSabun"));
		//LOGGER.debug("###########################encSabun################################ : " + encrytoEmpNo);
		if(NullUtil.isNull(input.get("_userId")) ||  NullUtil.nvl(input.get("_userId"), "").equals("-1")  ){
			String rtnMsg = messageSourceAccessor.getMessage("msg.alert.sessionTimeout");
			SayMessage.setMessage(rtnMsg);
        } else {

        	// 공지사항 5건
        	List<Map<String,Object>> noticeList = mainService.retrievePrjMainNoticeList();
        	// QnA 5건
        	List<Map<String,Object>> qnaList = mainService.retrievePrjMainQnaList();
        	// QnA 5건
        	List<Map<String,Object>> knowList = mainService.retrievePrjMainKnowLedgeList();
        	// 금주,차주 연구소일정 5건씩
        	List<Map<String,Object>> scheduleList = mainService.retrievePrjMainScheduleList();

        	//현재날짜
        	input.put("nowDate", DateUtil.getDate("yyyy-MM-dd", Locale.getDefault()));
        	input.put("nowEngDay", DateUtil.getEngDay());
        	input.put("pageMode", "prj") ;
        	input.put("encrytoEmpNo", encrytoEmpNo) ;

        	@SuppressWarnings("unchecked")
			HashMap<String, Object> data = (HashMap<String, Object>) input.clone();

        	//권한체크
        	Map<String, Object> role =tssUserService.getTssListRoleChk(data);

        	data.put("tssRoleType", role.get("tssRoleType"));
        	data.put("tssRoleCd",   role.get("tssRoleCd"));

        	data.put("pgsStepCd",   "PG");
        	//일반과제
        	List<Map<String,Object>> genList = genTssService.retrieveGenTssList(data);
        	//국책과제
        	List<Map<String,Object>> natList = natTssService.retrieveNatTssList(data);
        	//대외협력
        	List<Map<String,Object>> ousList = ousdCooTssService.retrieveOusdCooTssList(data);
        	// 유저 과제 카운트
        	Map<String,Object> tssReqCntInfo = mainService.retrieveUserTssReqCntInfo(data);

    		model.addAttribute("noticeList", noticeList);
    		model.addAttribute("qnaList", qnaList);
    		model.addAttribute("knowList", knowList);
    		model.addAttribute("scheduleList", scheduleList);
	        model.addAttribute("inputData", input);

	        model.addAttribute("genList", genList);
	        model.addAttribute("natList", natList);
	        model.addAttribute("ousList", ousList);
	        model.addAttribute("tssReqCntInfo", tssReqCntInfo);


			model.addAttribute("menuList", session.getAttribute("menuList"));

	        LOGGER.debug("########################################################################################");
			LOGGER.debug("input :"+input);
			LOGGER.debug("########################################################################################");
        }

		return "web/main/prjMain";
	}

	@RequestMapping(value="/anl/main.do")
	public String anlMain(
			@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			) throws Exception{

		/* 반드시 공통 호출 후 작업 */
		LOGGER.debug("###########################################################");
		LOGGER.debug("MainController - anlMain [분석 메인 화면 이동]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		checkSessionObjRUI(input, session, model);

		/* 지재권(지적 재산권) 사번 인코딩*/
		byte[] row = ((String) input.get("_userSabun")).getBytes();
		String encSabun = CommonUtil.encode(row);
		
		String encrytoEmpNo = CommonUtil.getCookieSabun(input.get("_userSabun").toString());
		LOGGER.debug("###########################encSabun################################ : " + encrytoEmpNo);
		
		input.put("isAnlChrg", ((String)input.get("_roleId")).indexOf("WORK_IRI_T06") > -1 ? 1 : 0);
		input.put("pageMode", "anl");
		input.put("encSabun", encSabun) ;
		input.put("encrytoEmpNo", encrytoEmpNo) ;

		Map<String, Object> anlCntInfo1 = mainService.getAnlCntInfo1(input);
		Map<String, Object> anlCntInfo2 = mainService.getAnlCntInfo2(input);
		List<Map<String, Object>> anlRqprList = mainService.getAnlRqprList(input);
		List<Map<String, Object>> anlMchnEduReqList = mainService.getAnlMchnEduReqList(input);
		List<Map<String, Object>> anlMchnReqList = mainService.getAnlMchnReqList(input);
		List<Map<String, Object>> anlNoticeList = mainService.getAnlNoticeList();
		List<Map<String, Object>> anlMchnSettingList = mainService.getAnlMchnSettingList();
		List<Map<String, Object>> anlEduReqList = mainService.getAnlEduReqList();
		List<Map<String, Object>> anlMainDataList = mainService.getAnlMainDataList();

		for(Map<String, Object> data : anlMchnSettingList) {
			data.put("anlMchnReservList", mainService.getAnlMchnReservList(data));
		}
		
		model.addAttribute("inputData", input);
		model.addAttribute("anlCntInfo1", anlCntInfo1);
		model.addAttribute("anlCntInfo2", anlCntInfo2);
		model.addAttribute("anlRqprList", anlRqprList);
		model.addAttribute("anlMchnEduReqList", anlMchnEduReqList);
		model.addAttribute("anlMchnReqList", anlMchnReqList);
		model.addAttribute("anlNoticeList", anlNoticeList);
		model.addAttribute("anlMchnSettingList", anlMchnSettingList);
		model.addAttribute("anlEduReqList", anlEduReqList);
		model.addAttribute("anlMainDataList", anlMainDataList);
		model.addAttribute("menuList", session.getAttribute("menuList"));

		return "web/main/anlMain";
	}

	@RequestMapping(value="/main/goLGSP.do")
	public String goLGSP(
			@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			) throws Exception{

		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);

		LOGGER.debug("###########################################################");
		LOGGER.debug("MainController - goLGSP [LG Science Part 화면 이동]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		String iv  = "LGSP";								// 변경불가
		String key = configService.getString("LGSP.key");	// 암호화키
		String cid = "011";									// 회사별 고유 회사 id
		String userInfo = "";								// 암호화된 사용자 정보

		try {
			SecurityEncrypter encrypter = new SecurityEncrypter(key, iv);

			StringBuilder sb = new StringBuilder(160);

			sb.append("ID=").append(input.get("_userSabun"));
			sb.append(",EMAIL=").append(input.get("_userEmail"));
			sb.append(",TIME=").append(System.currentTimeMillis());

			userInfo = encrypter.encrypt(sb.toString());

		} catch (Exception e) {
			e.printStackTrace();
		}

		model.addAttribute("cid", cid);
		model.addAttribute("userInfo", userInfo);
		model.addAttribute("lgspUrl", configService.getString("LGSP.url"));

		return "web/main/goLGSP";
	}
}// end class