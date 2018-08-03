package iris.web.space.ev.controller;

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

import iris.web.space.ev.service.SpaceEvService;
import iris.web.common.code.service.CodeCacheManager;
import iris.web.common.converter.RuiConverter;
import iris.web.common.util.DateUtil;
import iris.web.common.util.StringUtil;
import iris.web.system.attach.service.AttachFileService;
import iris.web.system.base.IrisBaseController;

/********************************************************************************
 * NAME : SpaceEvController.java 
 * DESC : 공간평가 - 평가법 관리 controller
 * PROJ : IRIS UPGRADE 2차 프로젝트
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG                       
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION                        
 * ----------  ------  --------------------------------------------------------- 
 * 2018.08.03  정현웅	최초생성     
 *********************************************************************************/

@Controller
public class SpaceEvController extends IrisBaseController {
	
	@Resource(name = "codeCacheManager")
	private CodeCacheManager codeCacheManager;
	
	@Resource(name = "spaceEvService")
	private SpaceEvService spaceEvService;
	
	@Resource(name = "attachFileService")
	private AttachFileService attachFileService;
	
	static final Logger LOGGER = LogManager.getLogger(SpaceEvController.class);

	
	
	@RequestMapping(value="/space/spaceEvaluationMgmt.do")
	public String spaceEvaluationMgmt(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			) throws Exception{
		
		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);
		
    	input = StringUtil.toUtf8(input);

		LOGGER.debug("###########################################################");
		LOGGER.debug("SpaceEvController - spaceEvaluationMgmt [공간평가 평가법 관리화면 이동]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");
		
		model.addAttribute("inputData", input);

		return "web/space/rqpr/spaceEvaluationMgmt";
	}
	
	@RequestMapping(value="/space/spaceEvBzdvList.do")
	public ModelAndView spaceEvBzdvList(
			@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpServletResponse response,
			HttpSession session,
			ModelMap model
			){

		LOGGER.debug("###########################################################");
		LOGGER.debug("SpaceEvController - spaceEvBzdvList [공간평가 평가법관리 사업부 조회]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");
		
		ModelAndView modelAndView = new ModelAndView("ruiView");
    	
        // 분석담당자 리스트 조회 
		List<Map<String,Object>> spaceEvBzdvList = spaceEvService.getSpaceEvBzdvList(input);
		
		modelAndView.addObject("spaceEvBzdvDataSet", RuiConverter.createDataset("spaceEvBzdvDataSet", spaceEvBzdvList));
		LOGGER.debug("spaceEvBzdvList : " + spaceEvBzdvList);
		return modelAndView;
	}
	
	@RequestMapping(value="/space/spaceEvProdClList.do")
	public ModelAndView spaceEvProdClList(
			@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpServletResponse response,
			HttpSession session,
			ModelMap model
			){

		LOGGER.debug("###########################################################");
		LOGGER.debug("SpaceEvController - spaceEvProdClList [공간평가 평가법관리 제품군 조회]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");
		
		ModelAndView modelAndView = new ModelAndView("ruiView");
    	
        // 분석담당자 리스트 조회 
		List<Map<String,Object>> getSpaceEvProdClList = spaceEvService.getSpaceEvProdClList(input);
		
		modelAndView.addObject("getSpaceEvProdClList", RuiConverter.createDataset("getSpaceEvProdClList", getSpaceEvProdClList));
		LOGGER.debug("getSpaceEvClList : " + getSpaceEvProdClList);
		return modelAndView;
	}
	
	@RequestMapping(value="/space/spaceEvClList.do")
	public ModelAndView spaceEvClList(
			@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpServletResponse response,
			HttpSession session,
			ModelMap model
			){

		LOGGER.debug("###########################################################");
		LOGGER.debug("SpaceEvController - spaceEvClList [공간평가 평가법관리 분류 조회]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");
		
		ModelAndView modelAndView = new ModelAndView("ruiView");
    	
        // 분석담당자 리스트 조회 
		List<Map<String,Object>> getSpaceEvClList = spaceEvService.getSpaceEvClList(input);
		
		modelAndView.addObject("getSpaceEvProdClList", RuiConverter.createDataset("getSpaceEvClList", getSpaceEvClList));
		LOGGER.debug("getSpaceEvClList : " + getSpaceEvClList);
		return modelAndView;
	}
	
	@RequestMapping(value="/space/spaceEvProdList.do")
	public ModelAndView spaceEvProdList(
			@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpServletResponse response,
			HttpSession session,
			ModelMap model
			){

		LOGGER.debug("###########################################################");
		LOGGER.debug("SpaceEvController - spaceEvProdList [공간평가 평가법관리 제품 조회]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");
		
		ModelAndView modelAndView = new ModelAndView("ruiView");
    	
        // 분석담당자 리스트 조회 
		List<Map<String,Object>> getSpaceEvProdList = spaceEvService.getSpaceEvProdList(input);
		
		modelAndView.addObject("getSpaceEvProdList", RuiConverter.createDataset("getSpaceEvProdList", getSpaceEvProdList));
		LOGGER.debug("getSpaceEvProdList : " + getSpaceEvProdList);
		return modelAndView;
	}
}