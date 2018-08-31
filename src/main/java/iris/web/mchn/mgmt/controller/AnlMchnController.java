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

import devonframe.configuration.ConfigService;
import devonframe.message.saymessage.SayMessage;
import devonframe.util.NullUtil;
import iris.web.common.converter.RuiConverter;
import iris.web.common.util.StringUtil;
import iris.web.mchn.mgmt.service.AnlMchnService;
import iris.web.system.base.IrisBaseController;


@Controller
public class AnlMchnController extends IrisBaseController {

	@Resource(name="messageSourceAccessor")
	private MessageSourceAccessor messageSourceAccessor;

	@Resource(name = "anlMchnService")
	private AnlMchnService anlMchnService;

	@Resource(name = "configService")
    private ConfigService configService;

	static final Logger LOGGER = LogManager.getLogger(AnlMchnController.class);


	/**
	 *  관리 > 분석기기 화면 이동
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/mchn/mgmt/retrieveMachineList.do")
	public String retrieveAnlMachineList(@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){

		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		input = StringUtil.toUtf8(input);
        model.addAttribute("inputData", input);
        
		return  "web/mchn/mgmt/anlMchnList";
	}

	/**
	 *  관리 > 분석기기 조회 팝업 이동
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/mchn/mgmt/retrieveFxaInfoPop.do")
	public String retrieveFxaInfoPop(@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){

		HashMap lsession = (HashMap)session.getAttribute("irisSession");
		LOGGER.debug("session="+lsession);

		/* 반드시 공통 호출 후 작업 */
		//checkSession(input, session, model);
        model.addAttribute("input", input);
		return  "web/mchn/mgmt/fxaInfoPop";
	}

	/**
	 * 고정자산 목록 조회
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/mchn/mgmt/retrieveFxaInfoSearchList.do")
	public ModelAndView retrieveFxaInfoSearchList(@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		input = StringUtil.toUtf8(input);
		
		ModelAndView modelAndView = new ModelAndView("ruiView");
		
       	List<Map<String, Object>> resultList = anlMchnService.retrieveFxaInfoSearchList(input);
		modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", resultList));

		return  modelAndView;
	}

	/**
	 *  관리 > 분석기기 조회
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/mchn/mgmt/retrieveAnlMchnSearchList.do")
	public ModelAndView retrieveAnlMchnSearchList(@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		ModelAndView modelAndView = new ModelAndView("ruiView");
		input = StringUtil.toUtf8(input);

        List<Map<String, Object>> resultList = anlMchnService.retrieveAnlMchnSearchList(input);
		modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", resultList));

		return  modelAndView;
	}


	/**
	 *  기기 등록 화면
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/mchn/mgmt/retrieveAnlMchnReg.do")
	public String retrieveAnlMchnReg(@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){

		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		input = StringUtil.toUtf8(input);
		
        model.addAttribute("inputData", input);

		return  "web/mchn/mgmt/anlMchnReg";
	}


	/**
	 *  분석기기 등록
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/mchn/mgmt/saveMachineInfo.do")
	public ModelAndView saveMachineInfo(@RequestParam HashMap<String, Object> input,
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
        	//고정자산 목록이 이미 등록이 되어있는지 확인
        	int fxaCnt = 0;
        	if(!"".equals(input.get("fxaNo"))){
        		fxaCnt = anlMchnService.retrieveFxaInfoCnt(input);
        	}

        	if( fxaCnt > 0 ){
        		rtnMsg = "이미 등록되어 있는 고정자산입니다.";
        	}else{
        		LOGGER.debug("############################################################################### : "+ input);
        		anlMchnService.saveMachineInfo(input);
            	
                rtnMsg = "저장되었습니다.";
            	rtnSt= "S";
        	}

    	}catch(Exception e){
			e.printStackTrace();
			if("".equals(rtnMsg)){
				rtnMsg = "처리중 오류가발생했습니다. 관리자에게 문의해주십시오.";
			}
    	}

       	rtnMeaasge.put("rtnMsg", rtnMsg);
		rtnMeaasge.put("rtnSt", rtnSt);
		modelAndView.addObject("resultDataSet", RuiConverter.createDataset("resultDataSet", rtnMeaasge));
		modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", input));

		return  modelAndView;
	}



	/**
	 *  분석기기 상세 조회
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/mchn/mgmt/retrieveAnlMchnSearchDtl.do")
	public ModelAndView retrieveAnlMchnSearchDtl(@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);

		ModelAndView modelAndView = new ModelAndView("ruiView");
		if(NullUtil.isNull(input.get("_userId")) ||  NullUtil.nvl(input.get("_userId"), "").equals("-1")  ){
			String rtnMsg = messageSourceAccessor.getMessage("msg.alert.sessionTimeout");
			SayMessage.setMessage(rtnMsg);
			modelAndView.addObject("dataset", null);
        } else {
        	HashMap<String, Object> result = anlMchnService.retrieveAnlMchnSearchDtl(input);
			modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", result));
        }

		return  modelAndView;
	}

	/**
	 * 전체기기 관리 조회 이동
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/mchn/mgmt/retrieveAnlMchnAll.do")
	public String retrieveAnlMchnAll(@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){

		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		input = StringUtil.toUtf8(input);
		
        model.addAttribute("inputData", input);

		return  "web/mchn/mgmt/retrieveAnlMchnAll";
	}


	/**
	 *  관리 > 전체기기 관리 조회
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/mchn/mgmt/retrieveAnlMchnAllSearchList.do")
	public ModelAndView retrieveAnlMchnAllSearchList(@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		ModelAndView modelAndView = new ModelAndView("ruiView");
		input = StringUtil.toUtf8(input);

        List<Map<String, Object>> resultList = anlMchnService.retrieveAnlMchnAllSearchList(input);
		modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", resultList));

		return  modelAndView;
	}
	
}
