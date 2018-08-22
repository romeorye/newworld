package iris.web.mchn.mgmt.controller;

import java.io.File;
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

import devonframe.configuration.ConfigService;
import devonframe.message.saymessage.SayMessage;
import devonframe.util.NullUtil;
import iris.web.common.converter.RuiConverter;
import iris.web.common.util.CommonUtil;
import iris.web.common.util.NamoMime;
import iris.web.common.util.StringUtil;
import iris.web.mchn.mgmt.service.AnlMchnService;
import iris.web.mchn.mgmt.service.MchnCgdgService;
import iris.web.mchn.mgmt.service.RlabTestEqipService;
import iris.web.mchn.mgmt.service.SpaceEvToolUseMgmtService;
import iris.web.system.base.IrisBaseController;

@Controller
public class SpaceEvToolUseMgmtController extends IrisBaseController {

	@Resource(name="messageSourceAccessor")
	private MessageSourceAccessor messageSourceAccessor;

	@Resource(name="spaceEvToolUseMgmtService")
	private SpaceEvToolUseMgmtService spaceEvToolUseMgmtService;

	
	@Resource(name = "configService")
    private ConfigService configService;
	
	static final Logger LOGGER = LogManager.getLogger(MchnCgdgController.class);
	
	
	/**
	 * 분석기기 > 관리 > 공간평가 Tool사용관리 화면
	 */
	@RequestMapping(value="/mchn/mgmt/spaceEvToolUseMgmtList.do")
	public String rlabTestEqipList(@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){

		LOGGER.debug("############################################################################### : "+ input);
		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		input = StringUtil.toUtf8(input);

		model.addAttribute("inputData", input);
		
		return  "web/mchn/mgmt/spaceEvToolUseMgmtList";
	}
	
	

	/**
	 *  관리 > 공간평가 Tool사용관리 조회
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/mchn/mgmt/spaceEvToolUseMgmtSearchList.do")
	public ModelAndView retrieveAnlMchnSearchList(@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		ModelAndView modelAndView = new ModelAndView("ruiView");
		input = StringUtil.toUtf8(input);

        List<Map<String, Object>> resultList = spaceEvToolUseMgmtService.spaceEvToolUseMgmtSearchList(input);
		modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", resultList));

		return  modelAndView;
	}

	

	
	
	
}
