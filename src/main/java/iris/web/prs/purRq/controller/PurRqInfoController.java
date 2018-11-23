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
		
		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		
		LOGGER.debug("###########################################################");
		LOGGER.debug("PurRqInfoController - purRqDetail [구매요청 화면 이동]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");
		
		//input = StringUtil.toUtf8Input(input);
		model.addAttribute("inputData", input);
		
		return "web/prs/purRq/purRqDetail";
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
	public String wbsCdSearchPopup(
			@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
		
		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		
		LOGGER.debug("###########################################################");
		LOGGER.debug("PurRqInfoController - wbsCdSearchPopup [Project list pop 화면 이동]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");
		
		input = StringUtil.toUtf8Input(input);
		
		model.addAttribute("inputData", input);
		
		return "web/prs/popup/prjListPop";
	}
	
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
	
	
}
