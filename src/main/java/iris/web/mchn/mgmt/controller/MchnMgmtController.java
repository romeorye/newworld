package iris.web.mchn.mgmt.controller;


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

import devonframe.fileupload.FileUpload;
import iris.web.common.converter.RuiConverter;
import iris.web.mchn.mgmt.service.AnlMchnService;
import iris.web.mchn.mgmt.service.MchnMgmtService;
import iris.web.system.base.IrisBaseController;

@Controller
public class MchnMgmtController  extends IrisBaseController {

	@Resource(name = "fileUpload")
    private FileUpload fileUpload;

	@Resource(name = "mchnMgmtService")
	private MchnMgmtService mchnMgmtService;

	@Resource(name = "anlMchnService")
	private AnlMchnService anlMchnService;

	@Resource(name="messageSourceAccessor")
	private MessageSourceAccessor messageSourceAccessor;

	static final Logger LOGGER = LogManager.getLogger(AnlMchnController.class);

	/**
	 *  기기관리 목록 화면
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/mchn/mgmt/mchnMgmtList.do")
	public String mchnMgmtList(@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){

		//LOGGER.debug("#######################mchnMgmtList######input######################################################## : "+ input);
		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);

		model.addAttribute("inputData", input);

		return  "web/mchn/mgmt/mchnMgmtList";
	}



	/**
	 *  관리 > 분석기기 > 기기관리 조회
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/mchn/mgmt/retrieveMchnMgmtSearchList.do")
	public ModelAndView retrieveMchnMgmtSearchList(@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		ModelAndView modelAndView = new ModelAndView("ruiView");

		List<Map<String, Object>> resultList = mchnMgmtService.retrieveMchnMgmtSearchList(input);
		HashMap<String, Object> result = anlMchnService.retrieveAnlMchnSearchDtl(input);

		modelAndView.addObject("mchnInfoDataSet", RuiConverter.createDataset("mchnInfoDataSet", result));
		modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", resultList));

		return  modelAndView;
	}

	/**
	 *  관리 > 분석기기 > 기기관리 조회 > 신규 등록 및 수정 팝업
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/mchn/mgmt/retrieveMchnMgmtInfoPop.do")
	public String retrieveMchnMgmtInfoPop(@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){

		HashMap lsession = (HashMap)session.getAttribute("irisSession");

		input.put("saName", lsession.get("_userNm").toString());
		input.put("saSabun", lsession.get("_userSabun").toString());

		//LOGGER.debug("#############################input######################################################## : "+ input);
		/* 반드시 공통 호출 후 작업 */
		//checkSession(input, session, model);
		model.addAttribute("inputData", input);

		return "web/mchn/mgmt/mchnMgmtInfoPop";
	}


	/**  관리 > 분석기기 > 기기관리 조회 >  및 수정 팝업조회
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/mchn/mgmt/retrieveMchnMgmtInfoSearch.do")
	public ModelAndView retrieveMchnMgmtInfoSearch(@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);

		ModelAndView modelAndView = new ModelAndView("ruiView");

       	HashMap<String, Object> result = mchnMgmtService.retrieveMchnMgmtInfoSearch(input);
		modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", result));

		return  modelAndView;
	}

	/**
	 *  분석기기 등록
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/mchn/mgmt/saveMachineMgmtInfo.do")
	public ModelAndView saveMachineMgmtInfo(@RequestParam HashMap<String, Object> input,
			//MultipartFile file,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		ModelAndView modelAndView = new ModelAndView("ruiView");
		HashMap<String, Object> rtnMeaasge = new HashMap<String, Object>();

		String rtnMsg = "";
		String rtnSt = "F";

		try{
    		mchnMgmtService.saveMachineMgmtInfo(input);
    		rtnMsg = "저장하였습니다.";
    		rtnSt = "S";
    	}catch(Exception e){
			e.printStackTrace();
			rtnMsg = "처리중 오류가발생했습니다. 담당자에게 문의해주세요";
    	}

		rtnMeaasge.put("rtnMsg", rtnMsg);
		rtnMeaasge.put("rtnSt", rtnSt);
		modelAndView.addObject("resultDataSet", RuiConverter.createDataset("resultDataSet", rtnMeaasge));
		modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", input));

		return  modelAndView;
	}


}
