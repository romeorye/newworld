package iris.web.stat.anl.controller;

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

import iris.web.common.converter.RuiConverter;
import iris.web.common.util.DateUtil;
import iris.web.common.util.StringUtil;
import iris.web.stat.anl.service.AnlStatService;
import iris.web.system.base.IrisBaseController;

/********************************************************************************
 * NAME : AnlStatController.java 
 * DESC : 통계 - 분석 controller
 * PROJ : IRIS UPGRADE 1차 프로젝트
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG                       
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION                        
 * ----------  ------  --------------------------------------------------------- 
 * 2017.08.25  오명철	최초생성
 *********************************************************************************/

@Controller
public class AnlStatController extends IrisBaseController {
	
	@Resource(name = "anlStatService")
	private AnlStatService anlStatService;
	
	static final Logger LOGGER = LogManager.getLogger(AnlStatController.class);

	@RequestMapping(value="/stat/anl/anlCompleteState.do")
	public String anlCompleteState(
			@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			) throws Exception{
		
		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		
    	input = StringUtil.toUtf8(input);

		LOGGER.debug("###########################################################");
		LOGGER.debug("AnlStatController - anlCompleteState [분석완료 통계 화면 이동]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");
		
		String today = DateUtil.getDateString();
		
		input.put("fromCmplDt", DateUtil.addMonths(today, -1, "yyyy-MM-dd"));
		input.put("toCmplDt", today);
		
		model.addAttribute("inputData", input);

		return "web/stat/anl/anlCompleteStateList";
	}
	
	@RequestMapping(value="/stat/anl/getAnlCompleteStateList.do")
	public ModelAndView getAnlCompleteStateList(
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
		LOGGER.debug("AnlStatController - getAnlCompleteStateList [분석완료 통계 리스트 조회]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");
		
		ModelAndView modelAndView = new ModelAndView("ruiView");
    	
		List<Map<String,Object>> anlCompleteStateList = anlStatService.getAnlCompleteStateList(input);
		
		modelAndView.addObject("anlCompleteStateDataSet", RuiConverter.createDataset("anlCompleteStateDataSet", anlCompleteStateList));
		
		return modelAndView;
	}

	@RequestMapping(value="/stat/anl/anlMchnUseState.do")
	public String anlMchnUseState(
			@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			) throws Exception{
		
		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		
    	input = StringUtil.toUtf8(input);

		LOGGER.debug("###########################################################");
		LOGGER.debug("AnlStatController - anlMchnUseState [분석 기기사용 통계 화면 이동]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");
		
		String today = DateUtil.getDateString();
		
		input.put("fromExprStrtDt", DateUtil.addMonths(today, -1, "yyyy-MM-dd"));
		input.put("toExprStrtDt", today);
		
		model.addAttribute("inputData", input);

		return "web/stat/anl/anlMchnUseStateList";
	}
	
	@RequestMapping(value="/stat/anl/getAnlMchnUseStateList.do")
	public ModelAndView getAnlMchnUseStateList(
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
		LOGGER.debug("AnlStatController - getAnlMchnUseStateList [분석 기기사용 통계 리스트 조회]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");
		
		ModelAndView modelAndView = new ModelAndView("ruiView");
    	
		List<Map<String,Object>> anlMchnUseStateList = anlStatService.getAnlMchnUseStateList(input);
		
		modelAndView.addObject("anlMchnUseStateDataSet", RuiConverter.createDataset("anlMchnUseStateDataSet", anlMchnUseStateList));
		
		return modelAndView;
	}

	@RequestMapping(value="/stat/anl/anlBusinessState.do")
	public String anlBusinessState(
			@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			) throws Exception{
		
		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		
    	input = StringUtil.toUtf8(input);

		LOGGER.debug("###########################################################");
		LOGGER.debug("AnlStatController - anlBusinessState [분석 업무현황 통계 화면 이동]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");
		
		String today = DateUtil.getDateString();
		
		input.put("fromCmplDt", today.substring(0, 7));
		input.put("toCmplDt", today.substring(0, 7));
		
		model.addAttribute("inputData", input);

		return "web/stat/anl/anlBusinessStateList";
	}
	
	@RequestMapping(value="/stat/anl/getAnlBusinessStateList.do")
	public ModelAndView getAnlBusinessStateList(
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
		LOGGER.debug("AnlStatController - getAnlBusinessStateList [분석 업무현황 통계 리스트 조회]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");
		
		ModelAndView modelAndView = new ModelAndView("ruiView");
    	
		List<Map<String,Object>> anlBusinessStateList = anlStatService.getAnlBusinessStateList(input);
		
		modelAndView.addObject("anlBusinessStateDataSet", RuiConverter.createDataset("anlBusinessStateDataSet", anlBusinessStateList));
		
		return modelAndView;
	}

	@RequestMapping(value="/stat/anl/anlDivisionState.do")
	public String anlDivisionState(
			@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			) throws Exception{
		
		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		
    	input = StringUtil.toUtf8(input);

		LOGGER.debug("###########################################################");
		LOGGER.debug("AnlStatController - anlDivisionState [사업부 통계 화면 이동]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");
		
		String today = DateUtil.getDateString();		
		
		input.put("fromCmplDt", today.substring(0, 7));
		input.put("toCmplDt", today.substring(0, 7));
		
		model.addAttribute("inputData", input);

		return "web/stat/anl/anlDivisionStateList";
	}
	
	@RequestMapping(value="/stat/anl/getAnlDivisionStateList.do")
	public ModelAndView getAnlDivisionStateList(
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
		LOGGER.debug("AnlStatController - getAnlDivisionStateList [분석 사업부 통계 리스트 조회]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");
		
		ModelAndView modelAndView = new ModelAndView("ruiView");
    	
		List<Map<String,Object>> anlDivisionStateList = anlStatService.getAnlDivisionStateList(input);
		
		modelAndView.addObject("anlDivisionStateDataSet", RuiConverter.createDataset("anlDivisionStateDataSet", anlDivisionStateList));
		
		return modelAndView;
	}

	@RequestMapping(value="/stat/anl/anlChrgState.do")
	public String anlChrgState(
			@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			) throws Exception{
		
		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		
    	input = StringUtil.toUtf8(input);

		LOGGER.debug("###########################################################");
		LOGGER.debug("AnlStatController - anlChrgState [담당자 분석 통계 화면 이동]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");
		
		String today = DateUtil.getDateString();
				
		input.put("fromAcpcDt", today.substring(0, 7));
		input.put("toAcpcDt", today.substring(0, 7));
		
		model.addAttribute("inputData", input);

		return "web/stat/anl/anlChrgStateList";
	}
	
	@RequestMapping(value="/stat/anl/getAnlChrgStateList.do")
	public ModelAndView getAnlChrgStateList(
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
		LOGGER.debug("AnlStatController - getAnlChrgStateList [담당자 분석 통계 리스트 조회]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");
		
		ModelAndView modelAndView = new ModelAndView("ruiView");
    	
		List<Map<String,Object>> anlChrgStateList = anlStatService.getAnlChrgStateList(input);
		
		modelAndView.addObject("anlChrgStateDataSet", RuiConverter.createDataset("anlChrgStateDataSet", anlChrgStateList));
		
		return modelAndView;
	}
}