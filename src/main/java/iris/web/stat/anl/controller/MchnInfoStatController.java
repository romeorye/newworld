package iris.web.stat.anl.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
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
import iris.web.stat.anl.service.MchnInfoStatService;
import iris.web.system.base.IrisBaseController;

@Controller
public class MchnInfoStatController extends IrisBaseController {
	
	@Resource(name="mchnInfoStatService")
	private MchnInfoStatService mchnInfoStatService; 
	
	
	static final Logger LOGGER = LogManager.getLogger(MchnInfoStatController.class);
	
	
	/**
	 * 통계 > 분석 > OPEN기기 사용 화면이동 
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/stat/anl/mchnInfoState.do")
	public String mchnInfoState(@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			)throws Exception{

		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		LOGGER.debug("####################input################################################################# : " + input);
		input = StringUtil.toUtf8(input);
		
		String today = DateUtil.getDateString();
		
		input.put("prctFrDt",  DateUtil.addMonths(today, -1, "yyyy-MM-dd"));  
		input.put("prctToDt", today);
		
		
		model.addAttribute("inputData", input);

		return  "web/stat/anl/mchnInfoStatList";
	}
	
	/**
	 * 통계 > 분석 > OPEN기기 사용조회
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 * @throws Exception 
	 */
	@RequestMapping(value="/stat/anl/retrieveMchnInfoStateList.do")
	public ModelAndView mchnInfoStateList(@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){

		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		ModelAndView modelAndView = new ModelAndView("ruiView");
		input = StringUtil.toUtf8(input);
		
		//OPEN기기 사용조회
		List<Map<String, Object>> mchnStatList =  mchnInfoStatService.mchnInfoStateList(input);
		
		modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", mchnStatList));		
		return modelAndView;
	}
}
