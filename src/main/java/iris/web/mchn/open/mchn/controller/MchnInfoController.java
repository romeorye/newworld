package iris.web.mchn.open.mchn.controller;

import java.util.HashMap;
import java.util.List;
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
import org.springframework.web.servlet.ModelAndView;

import iris.web.common.converter.RuiConverter;
import iris.web.common.util.DateUtil;
import iris.web.mchn.mgmt.service.AnlMchnService;
import iris.web.mchn.open.mchn.service.MchnInfoService;
import iris.web.system.base.IrisBaseController;


@Controller
public class MchnInfoController extends IrisBaseController {

	@Resource(name="messageSourceAccessor")
	private MessageSourceAccessor messageSourceAccessor;
	
	@Resource(name="mchnInfoService")
	private MchnInfoService mchnInfoService;
	
	@Resource(name = "anlMchnService")
	private AnlMchnService anlMchnService;
	
	static final Logger LOGGER = LogManager.getLogger(MchnInfoController.class);
	
	
	/**
	 * 보유기기 list 화면 
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/mchn/open/mchn/retrieveMachineList.do")
	public String retrieveMachineList(@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){

		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		//LOGGER.debug("####################input################################################################# : " + input);

		model.addAttribute("inputData", input);

		return  "web/mchn/open/mchn/mchnInfoList";
	}
	
	/**
	 * 보유기기 list TAB 화면(iframe) 
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/mchn/open/mchn/retrieveMchnTab.do")
	public String retrieveMchnTab(@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){

		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		//LOGGER.debug("==========input session=   : "+input);
		
		//분석기기 리스트 조회
		List<Map<String,Object>> mchnList = mchnInfoService.retrieveMchnInfoSearchList(input);
		//LOGGER.debug("========== mchnList=   : "+mchnList);
				
		model.addAttribute("inputData", input);
		model.addAttribute("mchnList", mchnList);
		
		return  "web/mchn/open/mchn/mchnTab";
	}
	
	/**
	 * 보유기기 개요(Tab) 화면 
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/mchn/open/mchn/retrieveMchnDtl.do")
	public String retrieveMchnDtl(@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			) throws Exception{

		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);

		// 분석자료실 리스트 조회
		input.put("userNm", input.get("_userNm"));
		input.put("userDeptName", input.get("_userDeptName"));
		input.put("userSabun", input.get("_userSabun"));
		//보유기기 상세조회
		HashMap<String,Object> result = mchnInfoService.retrieveMchnInfoDtl(input);
				
		model.addAttribute("inputData", input);
		model.addAttribute("result", result);
		
		return  "web/mchn/open/mchn/mchnDtlMain";
	}
	
	/**
	 * 보유기기 개요 조회 
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/mchn/open/mchn/retrieveMchnInfoTab.do")
	public String retrieveMchnInfoTab(@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			) throws Exception{

		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		//LOGGER.debug("session="+lsession);
		// 분석자료실 리스트 조회
		String 	rtnUrl = input.get("rtnUrl").toString();
		
		//보유기기 상세조회
		HashMap<String,Object> result = mchnInfoService.retrieveMchnInfoDtl(input);
		model.addAttribute("result", result);
		model.addAttribute("inputData", input);
		
		return  rtnUrl;
	}
	
	/**
	 * 보유기기 일정(TAB) 조회 
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/mchn/open/mchn/retrieveMchnPrctTab.do")
	public String retrieveMchnPrctTab(@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			) throws Exception{
		
		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		// 분석자료실 리스트 조회
		String 	rtnUrl = input.get("rtnUrl").toString();
		
		if("".equals(input.get("srhDt")) || input.get("srhDt") == null ){
			input.put("srhDt", DateUtil.getDateString().substring(0, 7));
		}
		
		// 분석기기 일정 조회
		List<Map<String,Object>> mchnPrctList = mchnInfoService.retrieveMchnPrctCalInfo(input);
		
		model.addAttribute("inputData", input);
		model.addAttribute("mchnPrctList", mchnPrctList);
		request.setAttribute("year", input.get("year"));
		request.setAttribute("month", input.get("month"));
		
		return  rtnUrl;
	}
	
	/**
	 * 보유기기 예약 신규 및 Detail 화면 
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/mchn/open/mchn/retrieveMchnPrctInfoPop.do")
	public String retrieveMchnPrctInfoPop(@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			) throws Exception{

		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		HashMap lsession = (HashMap)session.getAttribute("irisSession");
		HashMap<String, Object> result = new HashMap<String, Object>();
		//LOGGER.debug("session="+lsession);
		String prctId = input.get("mchnPrctId").toString();
		
		if("".equals(prctId)){
			input.put("userNm", lsession.get("_userNm"));
			input.put("userDeptName", lsession.get("_userDeptName"));
			input.put("userSabun", lsession.get("_userSabun"));

			result = mchnInfoService.retrieveMchnInfoDtl(input);
		}
		//LOGGER.debug("result============================="+result);
		model.addAttribute("inputData", input);
		model.addAttribute("result", result);
		
		return  "web/mchn/open/mchn/mchnPrctInfoPop";
	}
	
	/**
	 * 보유기기 예약 신규 및 Detail 화면 조회
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 * @throws Exception 
	 */
	@RequestMapping(value="/mchn/open/mchn/retrieveMchnPrctInfo.do")
	public ModelAndView retrieveMchnPrctInfo(@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			) throws Exception{

		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		HashMap lsession = (HashMap)session.getAttribute("irisSession");
		ModelAndView modelAndView = new ModelAndView("ruiView");
		
		//보유기기 예약상세
		HashMap<String, Object> result =  mchnInfoService.retrieveMchnPrctInfo(input);
		result.put("userSabun", lsession.get("_userSabun"));
		
		modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", result));		
		return modelAndView;
	}

	
	/**
	 * 보유기기 예약 신규 및 수정
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 * @throws Exception 
	 */
	@RequestMapping(value="/mchn/open/mchn/saveMchnPrctInfo.do")
	public ModelAndView saveMchnPrctInfo(@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			) throws Exception{

		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		HashMap lsession = (HashMap)session.getAttribute("irisSession");
		ModelAndView modelAndView = new ModelAndView("ruiView");
		HashMap<String, Object> rtnMeaasge = new HashMap<String, Object>();

		String rtnSt ="F";
		String rtnMsg = "";
		
		try{
			//보유기기 예약저장
			mchnInfoService.saveMchnPrctInfo(input);
			
			rtnMsg = "저장되었습니다.";
			rtnSt= "S";
		}catch(Exception e){
			e.printStackTrace();
			rtnMsg ="처리중 오류가발생했습니다. 관리자에게 문의해주십시오.";
		}
		
		rtnMeaasge.put("rtnMsg", rtnMsg);
		rtnMeaasge.put("rtnSt", rtnSt);
		modelAndView.addObject("resultDataSet", RuiConverter.createDataset("resultDataSet", rtnMeaasge));
		
		return modelAndView;
	}
	
	
	/**
	 * 보유기기 예약 삭제
	 * @param input
	 * @param session
	 * @param model
	 * @return
	 * @throws Exception 
	 */
	@RequestMapping(value="/mchn/open/mchn/deleteMchnPrctInfo.do")
	public ModelAndView deleteMchnPrctInfo(@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			) throws Exception{

		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		HashMap lsession = (HashMap)session.getAttribute("irisSession");
		ModelAndView modelAndView = new ModelAndView("ruiView");
		HashMap<String, Object> rtnMeaasge = new HashMap<String, Object>();

		String rtnSt ="F";
		String rtnMsg = "";
		
		try{
			//보유기기 예약저장
			mchnInfoService.deleteMchnPrctInfo(input);
			
			rtnMsg = "삭제되었습니다.";
			rtnSt= "S";
		}catch(Exception e){
			e.printStackTrace();
			rtnMsg ="처리중 오류가발생했습니다. 관리자에게 문의해주십시오.";
		}
		
		rtnMeaasge.put("rtnMsg", rtnMsg);
		rtnMeaasge.put("rtnSt", rtnSt);
		modelAndView.addObject("resultDataSet", RuiConverter.createDataset("resultDataSet", rtnMeaasge));
		
		return modelAndView;
	}
		
	
		
	/**
	 *  보유기기상세 화면(통합검색용)
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/mchn/open/mchn/retrieveMchnDtlSrchView.do")
	public String retrieveMchnDtlSrchView(@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){

		/* 반드시 공통 호출 후 작업 */
		HashMap<String, Object> result = anlMchnService.retrieveAnlMchnSearchDtl(input);
		
		model.addAttribute("inputData", input);
		model.addAttribute("result", result);

		return  "web/mchn/open/mchn/mchnApprView";
	}
}
