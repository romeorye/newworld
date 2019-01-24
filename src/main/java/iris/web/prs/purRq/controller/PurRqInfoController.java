package iris.web.prs.purRq.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import iris.web.common.code.service.CodeCacheManager;
import iris.web.common.code.service.PrsCodeService;
import iris.web.common.converter.RuiConverter;
import iris.web.common.util.DateUtil;
import iris.web.common.util.StringUtil;
import iris.web.prs.purRq.service.PurRqInfoService;
import iris.web.rlab.rqpr.controller.RlabRqprController;
import iris.web.system.base.IrisBaseController;

/********************************************************************************
 * NAME : PurRqInfoController.java
 * DESC : 구매요청시스템 - 구매요청 controller
 * PROJ : PRS(구매) 프로젝트
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION
 * ----------  ------  ---------------------------------------------------------
 * 2018.11.20   김연태						최초생성
 *********************************************************************************/
@Controller
public class PurRqInfoController extends IrisBaseController {
	
	@Resource(name = "codeCacheManager")
	private CodeCacheManager codeCacheManager;
	
	@Resource(name = "prsCodeService")
	private PrsCodeService prsCodeService;
	
	@Resource(name = "purRqInfoService")
	private PurRqInfoService purRqInfoService;
	
	
	static final Logger LOGGER = LogManager.getLogger(RlabRqprController.class);
	
	/**
	 *  구매요청시스템 리스트 화면으로 이동
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/prs/purRq/purRqList.do")
	public String purRqList(
			@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
		
		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		
		input = StringUtil.toUtf8Input(input);
		
		LOGGER.debug("###########################################################");
		LOGGER.debug("PurRqInfoController - purRqList [구매요청시스템 리스트 화면 이동]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");
		
		model.addAttribute("inputData", input);
		
		return "web/prs/purRq/purRqList";
	}
	
	
	/**
	 *  구매요청시스템 리스트 조회
	 * @param input
	 * @param request
	 * @param response
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/prs/pur/retrievePurRqList.do")
	public ModelAndView retrievePurRqList(
			@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpServletResponse response,
			HttpSession session,
			ModelMap model
			){

		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		input = StringUtil.toUtf8(input);
		
		LOGGER.debug("###########################################################");
		LOGGER.debug("PurRqInfoController - retrievePurRqList [구매요청 리스트 검색]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		ModelAndView modelAndView = new ModelAndView("ruiView");

        //구매요청 리스트 조회
		List<Map<String,Object>> rlabChrgList = purRqInfoService.retrievePurRqList(input);

		modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", rlabChrgList));

		return modelAndView;
	}
	
	
	/**
	 *  구매요청 화면으로 이동
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/prs/purRq/purRqDetail.do")
	public String purRqDetail(
			@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
		String retPage = "";
		
		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		
		LOGGER.debug("###########################################################");
		LOGGER.debug("PurRqInfoController - purRqDetail [구매요청 화면 이동]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");
		
		input = StringUtil.toUtf8Output(input);
		LOGGER.debug("############dddd###############################################  : " +    input.get("sCode")  );
		
		if("".equals(input.get("banfnPrs")) || null == input.get("banfnPrs")) {
			int banfnPrs = purRqInfoService.getBanfnPrsNumber();
			input.put("banfnPrs", banfnPrs);
		}
		
		model.addAttribute("inputData", input);
		
		if("EM".equals(input.get("tabId"))) {
			retPage = "web/prs/purRq/purRqDetail";
		} else if("EF".equals(input.get("tabId"))) {
			retPage = "web/prs/purRq/purRqLabEquipDetail";
		} else if("CR".equals(input.get("tabId"))) {
			retPage = "web/prs/purRq/purRqWorkDetail";
		} else if("OM".equals(input.get("tabId"))) {
			retPage = "web/prs/purRq/purRqOfficeDetail";
		} 
		
		return retPage;
	}
	
	
	
	@RequestMapping(value="/prs/purRq/retrievePurRqInfo.do")
	public ModelAndView retrievePurRqInfo(
			@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpServletResponse response,
			HttpSession session,
			ModelMap model
			){

		LOGGER.debug("###########################################################");
		LOGGER.debug("PurRqInfoController - retrievePurRqInfo [구매요청 상세]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		ModelAndView modelAndView = new ModelAndView("ruiView");
        //구매요청 리스트 조회
		HashMap<String,Object> purRqInfoMap = purRqInfoService.retrievePurRqInfo(input);
		
		modelAndView.addObject("purRqUserDataSet", RuiConverter.createDataset("purRqUserDataSet", purRqInfoMap));

		return modelAndView;
	}	
		
		
		
		
		
	/**
	 *  Project list pop 화면으로 이동
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/prs/pur/wbsCdSearchPopup.do")
	public String rlabRqprDetail(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			) throws Exception{

		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);

		LOGGER.debug("###########################################################");
		LOGGER.debug("PurRqInfoController - wbsCdSearchPopup [Project list pop 화면 이동]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		model.addAttribute("inputData", input);

		return "web/prs/popup/prjListPop";
	}

/*	public String wbsCdSearchPopup(
			@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
		
		 반드시 공통 호출 후 작업 
		checkSessionObjRUI(input, session, model);
		
		LOGGER.debug("###########################################################");
		LOGGER.debug("PurRqInfoController - wbsCdSearchPopup [Project list pop 화면 이동]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");
		
		input = StringUtil.toUtf8Input(input);
		
		model.addAttribute("inputData", input);
		
		return "web/prs/popup/prjListPop";
	}
*/	
	
	/**
	 *  Project list search
	 * @param input
	 * @param request
	 * @param response
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/prs/pur/retrieveWbsCdInfoList.do")
	public ModelAndView retrieveWbsCdInfoList(
			@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpServletResponse response,
			HttpSession session,
			ModelMap model
			){

		LOGGER.debug("###########################################################");
		LOGGER.debug("PurRqInfoController - retrieveWbsCdInfoList [Project list 정보 검색]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		ModelAndView modelAndView = new ModelAndView("ruiView");

        //Project 정보 list 조회
		List<Map<String,Object>> wbsCdInfoList = prsCodeService.retrieveWbsCdInfoList(input);

		modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", wbsCdInfoList));

		return modelAndView;
	}
	
	/**
	 * 구매요청 Item 등록 팝업 화면 이동
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/prs/popup/purRqItemPop.do")
	public String purRqItemPop(
			@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
		
		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		
		LOGGER.debug("###########################################################");
		LOGGER.debug("PurRqInfoController - purRqItemPop [구매요청 Item 등록 팝업 화면 이동]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");
		
		input = StringUtil.toUtf8Input(input);
		
		Map<String, Object> code = prsCodeService.retrieveSaktoInfoList(input);
		
		input.put("saktoNm", code.get("CODE_NM"));
		
		model.addAttribute("inputData", input);
		
		return "web/prs/popup/purRqItemPop";
	}
	
	
	/**
	 * 구매요청 저장
	 * @param input
	 * @param request
	 * @param response
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/prs/purRq/insertPurRqInfo.do")
	public ModelAndView insertPurRqInfo(
			@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpServletResponse response,
			HttpSession session,
			ModelMap model
			){

		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		
		LOGGER.debug("###########################################################");
		LOGGER.debug("PurRqInfoController - insertPurRqInfo [구매요청 정보 등록]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");
		
		ModelAndView modelAndView = new ModelAndView("ruiView");
		HashMap<String, Object> rtnMeaasge = new HashMap<String, Object>();
		
		input = StringUtil.toUtf8Input(input);
		
		String rtnSt ="F";
		String rtnMsg = "";
		int bnfpoPrs = 0;
		
		Map<String,Object> purRqMap = new HashMap<String, Object>();
		
		try{
			purRqMap.put("input", input);
			
			LOGGER.debug("##############################purRqMap############################# : " + purRqMap);
			
			bnfpoPrs = purRqInfoService.insertPurRqInfo(purRqMap);
			
			rtnMsg = "추가되었습니다.";
			rtnSt = "S";
		}catch(Exception e){
			e.printStackTrace();
			rtnMsg = "추가 중 오류가 발생하였습니다.";
		}
		
		rtnMeaasge.put("cmd", "insert");
		rtnMeaasge.put("rtnMsg", rtnMsg);
		rtnMeaasge.put("rtnSt", rtnSt);
		rtnMeaasge.put("bnfpoPrs", bnfpoPrs);
		
		modelAndView.addObject("resultDataSet", RuiConverter.createDataset("resultDataSet", rtnMeaasge));

		return modelAndView;
	}
	
	/**
	 * 구매요청 삭제
	 * @param input
	 * @param request
	 * @param response
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/prs/purRq/deletePurRqInfo.do")
	public ModelAndView deletePurRqInfo(
			@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpServletResponse response,
			HttpSession session,
			ModelMap model
			){

		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		
		LOGGER.debug("###########################################################");
		LOGGER.debug("PurRqInfoController - insertPurRqInfo [구매요청 정보 삭제]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");
		
		ModelAndView modelAndView = new ModelAndView("ruiView");
		HashMap<String, Object> rtnMeaasge = new HashMap<String, Object>();
		
		input = StringUtil.toUtf8Input(input);
		
		String rtnSt ="F";
		String rtnMsg = "";
		
		try{
			purRqInfoService.deletePurRqInfo(input);
			
			rtnMsg = "삭제되었습니다.";
			rtnSt = "S";
		}catch(Exception e){
			e.printStackTrace();
			rtnMsg = "삭제 중 오류가 발생하였습니다.";
		}
		
		rtnMeaasge.put("cmd", "delete");
		rtnMeaasge.put("rtnMsg", rtnMsg);
		rtnMeaasge.put("rtnSt", rtnSt);
		
		modelAndView.addObject("resultDataSet", RuiConverter.createDataset("resultDataSet", rtnMeaasge));

		return modelAndView;
	}

	/**
	 * 구매요청 수정
	 * @param input
	 * @param request
	 * @param response
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/prs/purRq/updatePurRqInfo.do")
	public ModelAndView updatePurRqInfo(
			@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpServletResponse response,
			HttpSession session,
			ModelMap model
			){

		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		
		LOGGER.debug("###########################################################");
		LOGGER.debug("PurRqInfoController - insertPurRqInfo [구매요청 정보 수정]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");
		
		ModelAndView modelAndView = new ModelAndView("ruiView");
		HashMap<String, Object> rtnMeaasge = new HashMap<String, Object>();
		
		input = StringUtil.toUtf8Input(input);
		
		String rtnSt ="F";
		String rtnMsg = "";
		
		try{
			purRqInfoService.updatePurRqInfo(input);
			
			rtnMsg = "수정되었습니다.";
			rtnSt = "S";
		}catch(Exception e){
			e.printStackTrace();
			rtnMsg = "수정 중 오류가 발생하였습니다.";
		}
		
		rtnMeaasge.put("cmd", "update");
		rtnMeaasge.put("rtnMsg", rtnMsg);
		rtnMeaasge.put("rtnSt", rtnSt);
		
		modelAndView.addObject("resultDataSet", RuiConverter.createDataset("resultDataSet", rtnMeaasge));

		return modelAndView;
	}

	/**
	 * 구매요청 구매요청일 설명 Popup
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/prs/popup/purRqDateExplainPop.do")
	public String purRqDateExplainPop(
			@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
		
		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		
		LOGGER.debug("###########################################################");
		LOGGER.debug("PurRqInfoController - purRqDateExplainPop [구매요청 구매요청일 설명 Popup]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");
		
		
		return "web/prs/popup/purRqDateExplainPop";
	}

	/**
	 * 구매요청 My List
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */	
	@RequestMapping(value="/prs/popup/myPurRqList.do")
	public String myPurRqList(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			) throws Exception{
		
		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);
		
		input = StringUtil.toUtf8(input);
		
		LOGGER.debug("###########################################################");
		LOGGER.debug("PurRqInfoController - myPurRqList [나의 구매요청 리스트 화면 이동]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");
		
		String today = DateUtil.getDateString();
		
		if(StringUtil.isNullString(input.get("fromRegDt"))) {
			input.put("fromRegDt", DateUtil.addMonths(today, -1, "yyyy-MM-dd"));
			input.put("toRegDt", today);
			input.put("fromPurRqDt", today);
			input.put("toPurRqDt", DateUtil.addMonths(today, 1, "yyyy-MM-dd"));
		}
		
		model.addAttribute("inputData", input);

		return "web/prs/purRq/myPurRqList";
	}	
	
	/**
	 * 구매요청 수정
	 * @param input
	 * @param request
	 * @param response
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/prs/purRq/myPurRqList.do")
	public ModelAndView myPurRqList(
			@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpServletResponse response,
			HttpSession session,
			ModelMap model
			){

		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		input = StringUtil.toUtf8(input);
		
		LOGGER.debug("###########################################################");
		LOGGER.debug("PurRqInfoController - myPurRqList [나의 구매요청 목록]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		ModelAndView modelAndView = new ModelAndView("ruiView");

        //구매요청 리스트 조회
		List<Map<String,Object>> myPurRqList = purRqInfoService.retrieveMyPurRqList(input);

		modelAndView.addObject("prItemListDataSet", RuiConverter.createDataset("prItemListDataSet", myPurRqList));

		return modelAndView;
	}
	
	@RequestMapping(value="/prs/popup/prsApprovalPopup.do")
	public String prsApprovalPopup(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){

		LOGGER.debug("###########################################################");
		LOGGER.debug("PurRqInfoController - prsApprovalPopup PRS ERP결재 팝업");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");


		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);

		model.addAttribute("inputData", input);

		return "web/prs/popup/prsApprovalPopup";
	}
	
	@RequestMapping(value="/prs/popup/userSearchPopup.do")
	public String prsUserSearchPopup(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){

		LOGGER.debug("###########################################################");
		LOGGER.debug("PurRqInfoController - prsUserSearchPopup 사용자 조회 팝업");
		LOGGER.debug("###########################################################");
		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);

		String userNm = "";
		
		StringUtil.toStringUtf8(input.get("userNm"));
		LOGGER.debug("input = > " + input);

		model.addAttribute("inputData", input);
		
		return "web/prs/popup/prsUserSearchPopup";
	}
	
	/**
	 * 구매요청 저장
	 * @param input
	 * @param request
	 * @param response
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/prs/purRq/insertApprovalInfo.do")
	public ModelAndView insertPerApprovalInfo(
			@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpServletResponse response,
			HttpSession session,
			ModelMap model
			){

		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		
		LOGGER.debug("###########################################################");
		LOGGER.debug("PurRqInfoController - insertPerApprovalInfo [구매요청 결재의뢰 저장]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");
		
		ModelAndView modelAndView = new ModelAndView("ruiView");
		HashMap<String, Object> rtnMeaasge = new HashMap<String, Object>();
		HashMap<String, Object> erpResult = new HashMap<String, Object>();
		
		input = StringUtil.toUtf8Input(input);
		
		String rtnSt ="F";
		String rtnMsg = "";
		
		Map<String,Object> purRqAppMap = new HashMap<String, Object>();
		
		try{
			LOGGER.debug("##############################purRqMap############################# : " + input);
			purRqAppMap.put("input", input);
			
			int rtnCnt = purRqInfoService.insertPurApprovalInfo(purRqAppMap);
			
			LOGGER.debug("--------------------------------------------------------- rtnCnt : " + rtnCnt);
			
			erpResult = purRqInfoService.sendSapExpensePr(purRqAppMap);

			LOGGER.debug("retCode => " + erpResult.get("retCode"));
			LOGGER.debug("retMsg => " + erpResult.get("retMsg"));

			if("E".equals(erpResult.get("retCode"))) {
				rtnSt ="E";
				rtnMsg = "결재의뢰 중 오류가 발생하였습니다.(" + erpResult.get("retMsg") + ")";
			} else if("F".equals(erpResult.get("retCode"))) { 
				rtnSt ="F";
				rtnMsg = "결재의뢰 중 오류가 발생하였습니다.(" + erpResult.get("retMsg") + ")";
			} else if("S".equals(erpResult.get("retCode"))) { 
				rtnSt ="S";
				rtnMsg = "결재의뢰 되었습니다.";
			}
		}catch(Exception e){
			e.printStackTrace();
			rtnSt ="F";
			rtnMsg = "결재의뢰 중 오류가 발생하였습니다.";
		}
		
		rtnMeaasge.put("cmd", "insert");
		rtnMeaasge.put("rtnMsg", rtnMsg);
		rtnMeaasge.put("rtnSt", rtnSt);
		
		modelAndView.addObject("resultDataSet", RuiConverter.createDataset("resultDataSet", rtnMeaasge));

		return modelAndView;
	}
	
}


