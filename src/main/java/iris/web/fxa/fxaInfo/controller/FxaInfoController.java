package iris.web.fxa.fxaInfo.controller;

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
import iris.web.fxa.fxaInfo.service.FxaInfoService;
import iris.web.system.base.IrisBaseController;



@Controller
public class FxaInfoController extends IrisBaseController {

	@Resource(name="messageSourceAccessor")
	private MessageSourceAccessor messageSourceAccessor;

	@Resource(name = "fxaInfoService")
	private FxaInfoService fxaInfoService;

	static final Logger LOGGER = LogManager.getLogger(FxaInfoController.class);

	/**
	 * 자산관리 목록 화면
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/fxa/fxaInfo/retrieveFxaInfoList.do")
	public String retrieveFxaInfoList(@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){

		/* 반드시 공통 호출 후 작업 */
		HashMap lsession = (HashMap)session.getAttribute("irisSession");
		LOGGER.debug("session="+lsession);
		LOGGER.debug("#####################################################################################");
		LOGGER.debug("RsstClsController - retrieveFxaInfoList [고정자산관리 조회 화면]");
		LOGGER.debug("#####################################################################################");

		model.addAttribute("inputData", input);

		return  "web/fxa/fxaInfo/fxaInfoList";
	}

	/**
	 * 자산이관 목록 > 등록자 조회팝업
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/fxa/fxaInfo/retrievePrjUserInfo.do")
	public String retrievePrjUserInfo(@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){

		/* 반드시 공통 호출 후 작업 */
		HashMap lsession = (HashMap)session.getAttribute("irisSession");
		input = StringUtil.toUtf8(input);

		model.addAttribute("inputData", input);

		return  "web/fxa/fxaInfo/prjUserInfoPop";
	}

	/**
	 * 자산이관 목록 > 등록자 조회
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/fxa/fxaInfo/retrievePrjUserSearch.do")
	public ModelAndView retrievePrjUserSearch(@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){

		/* 반드시 공통 호출 후 작업 */
		HashMap lsession = (HashMap)session.getAttribute("irisSession");
		input = StringUtil.toUtf8(input);

		ModelAndView modelAndView = new ModelAndView("ruiView");
		List<Map<String, Object>> resultList = fxaInfoService.retrievePrjUserSearch(input);

		modelAndView.addObject("userDataSet", RuiConverter.createDataset("userDataSet", resultList));
		model.addAttribute("inputData", input);

		return  modelAndView;
	}


}
