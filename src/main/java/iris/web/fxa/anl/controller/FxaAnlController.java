package iris.web.fxa.anl.controller;

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
import iris.web.common.util.StringUtil;
import iris.web.fxa.anl.service.FxaAnlService;
import iris.web.fxa.fxaInfo.service.FxaInfoService;
import iris.web.system.base.IrisBaseController;

@Controller
public class FxaAnlController extends IrisBaseController {

	@Resource(name="messageSourceAccessor")
	private MessageSourceAccessor messageSourceAccessor;

	@Resource(name = "fxaInfoService")
	private FxaInfoService fxaInfoService;

	@Resource(name = "fxaAnlService")
	private FxaAnlService fxaAnlService;

	static final Logger LOGGER = LogManager.getLogger(FxaAnlController.class);


	/**
	 * 자산관리 목록 화면
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/fxa/anl/retrieveFxaAnlList.do")
	public String retrieveFxaAnlList(@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){

		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		input = StringUtil.toUtf8(input);
		LOGGER.debug("###########################################################");
		LOGGER.debug("FxaAnlController - retrieveFxaAnlList [자산관리 목록 화면]");
		LOGGER.debug("input => " + input);
		LOGGER.debug("###########################################################");
		

		model.addAttribute("inputData", input);

		return  "web/fxa/anl/fxaInfoAnlList";
	}

	/**
	 *  자산관리 목록 조회
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/fxa/anl/retrieveFxaAnlSearchList.do")
	public ModelAndView retrieveFxaAnlSearchList(@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){

		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		ModelAndView modelAndView = new ModelAndView("ruiView");
		input = StringUtil.toUtf8(input);
		LOGGER.debug("###########################################################");
		LOGGER.debug("FxaAnlController - retrieveFxaAnlSearchList [자산관리 목록 조회]");
		LOGGER.debug("input => " + input);
		LOGGER.debug("###########################################################");

		List<Map<String, Object>> resultList = fxaAnlService.retrieveFxaAnlSearchList(input);
		
		modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", resultList));

		return  modelAndView;
	}

	/**
	 * 자산관리 상세 화면
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/fxa/anl/retrieveFxaAnlDtl.do")
	public String retrieveFxaAnlDtl(@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){

		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		ModelAndView modelAndView = new ModelAndView("ruiView");
		LOGGER.debug("###########################################################");
		LOGGER.debug("FxaAnlController - retrieveFxaAnlDtl [자산관리 상세 화면]");
		LOGGER.debug("input => " + input);
		LOGGER.debug("###########################################################");
		model.addAttribute("inputData", input);

		return  "web/fxa/anl/fxaInfoAnlDtl";
	}

	/**
	 * 자산관리 상세 조회
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/fxa/anl/retrieveFxaDtlSearchInfo.do")
	public ModelAndView retrieveFxaDtlSearchInfo(@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){

		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		ModelAndView modelAndView = new ModelAndView("ruiView");
		
		LOGGER.debug("###########################################################");
		LOGGER.debug("FxaAnlController - retrieveFxaDtlSearchInfo [자산관리 상세 조회]");
		LOGGER.debug("input => " + input);
		LOGGER.debug("###########################################################");
		
		Map<String, Object> result = fxaAnlService.retrieveFxaAnlSearchDtl(input);

		modelAndView.addObject("fxaDtlDataSet", RuiConverter.createDataset("fxaDtlDataSet", result));

		return  modelAndView;
	}

	/**
	 * 자산관리 신규 및 수정 화면
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/fxa/anl/retrieveFxaAnlUpdate.do")
	public String retrieveFxaAnlUpdate(@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
		
		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);

		LOGGER.debug("###########################################################");
		LOGGER.debug("FxaAnlController - retrieveFxaDtlSearchInfo [자산관리 상세 조회]");
		LOGGER.debug("input => " + input);
		LOGGER.debug("###########################################################");

		ModelAndView modelAndView = new ModelAndView("ruiView");


		model.addAttribute("inputData", input);

		return  "web/fxa/anl/fxaInfoReg";
	}

	/**
	 * 자산관리 삭제
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/fxa/anl/deleteFxaInfo.do")
	public ModelAndView deleteFxaInfo(@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){

		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		ModelAndView modelAndView = new ModelAndView("ruiView");
		HashMap<String, Object> rtnMeaasge = new HashMap<String, Object>();
		
		String rtnSt ="F";
		String rtnMsg = "";

		try{
			fxaAnlService.deleteFxaInfo(input);
			
			rtnMsg = "삭제되었습니다.";
			rtnSt = "S";
		}catch(Exception e){
			e.printStackTrace();
			rtnMsg = "삭제 중 오류가 발생하였습니다.";
		}
		
		rtnMeaasge.put("rtnMsg", rtnMsg);
		rtnMeaasge.put("rtnSt", rtnSt);
		modelAndView.addObject("resultDataSet", RuiConverter.createDataset("resultDataSet", rtnMeaasge));
		
		return  modelAndView;
	}

	/**
	 * 자산관리 정보 저장
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/fxa/anl/saveFxaInfo.do")
	public ModelAndView saveFxaInfo(@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){

		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		
		LOGGER.debug("###########################################################");
		LOGGER.debug("FxaAnlController - saveFxaInfo [자산관리 정보 저장]");
		LOGGER.debug("input => " + input);
		LOGGER.debug("###########################################################");
		
		ModelAndView modelAndView = new ModelAndView("ruiView");
		HashMap<String, Object> rtnMeaasge = new HashMap<String, Object>();
		HashMap<String,Object> dsMap = new HashMap<String, Object>();
		
		String rtnSt ="F";
		String rtnMsg = "";
		
		try{
			
			dsMap = (HashMap<String, Object>) RuiConverter.convertToDataSet(request, "fxaDtlDataSet").get(0);
			dsMap.put("_userId", input.get("_userId"));			
			fxaAnlService.saveFxaInfo(dsMap);
			
			rtnMsg = "저장되었습니다.";
			rtnSt = "S";
		}catch(Exception e){
			e.printStackTrace();
			rtnMsg = "저장 중 오류가 발생하였습니다.";
		}

		rtnMeaasge.put("rtnMsg", rtnMsg);
		rtnMeaasge.put("rtnSt", rtnSt);
		modelAndView.addObject("resultDataSet", RuiConverter.createDataset("resultDataSet", rtnMeaasge));
		
		return  modelAndView;
	}


	/**
	 * 자산관리 이관 팝업 화면
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/fxa/anl/retrieveFxaTrsfPop.do")
	public String retrieveFxaTrsfPop(@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){

		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		
		input = StringUtil.toUtf8(input);
		model.addAttribute("inputData", input);

		return  "web/fxa/anl/fxaTrsfPop";
	}


	/**
	 * 자산관리 상세화면(통합검색용) 
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/fxa/anl/retrieveFxaAnlDtlSrchView.do")
	public String retrieveFxaAnlDtlSrchView(@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){

		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		
		Map<String, Object> result = fxaInfoService.retrieveFxaDtlSearchInfo(input);
		model.addAttribute("inputData", input);
		model.addAttribute("result", result);

		
		return  "web/fxa/anl/fxaAnlViewPop";
	}
}
