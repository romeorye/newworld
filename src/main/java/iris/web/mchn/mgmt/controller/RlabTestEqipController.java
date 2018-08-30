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
import iris.web.mchn.mgmt.service.RlabTestEqipService;
import iris.web.system.base.IrisBaseController;

@Controller
public class RlabTestEqipController extends IrisBaseController {

	@Resource(name="messageSourceAccessor")
	private MessageSourceAccessor messageSourceAccessor;

	@Resource(name="rlabTestEqipService")
	private RlabTestEqipService rlabTestEqipService;
	
	@Resource(name = "anlMchnService")
	private AnlMchnService anlMchnService;
	
	@Resource(name = "configService")
    private ConfigService configService;
	
	static final Logger LOGGER = LogManager.getLogger(MchnCgdgController.class);
	
	
	/**
	 * 분석기기 > 관리 > 소모품 관리 리스트 화면으로 으로
	 */
	@RequestMapping(value="/mchn/mgmt/rlabTestEqipList.do")
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
		
		return  "web/mchn/mgmt/rlabTestEqipList";
	}
	
	

	/**
	 *  관리 > 신뢰성시험 장비 조회
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/mchn/mgmt/rlabTestEqipSearchList.do")
	public ModelAndView retrieveAnlMchnSearchList(@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		ModelAndView modelAndView = new ModelAndView("ruiView");
		input = StringUtil.toUtf8(input);

        List<Map<String, Object>> resultList = rlabTestEqipService.rlabTestEqipSearchList(input);
		modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", resultList));

		return  modelAndView;
	}

	

	/**
	 *  신뢰성시험 장비 등록 화면
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/mchn/mgmt/rlabTestEqipReg.do")
	public String retrieveAnlMchnReg(@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){

		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		input = StringUtil.toUtf8(input);
		
        model.addAttribute("inputData", input);

		return  "web/mchn/mgmt/rlabTestEqipReg";
	}
	
	
	/**
	 *  분석기기 등록
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 * @throws Exception 
	 */
	@RequestMapping(value="/mchn/mgmt/saveRlabTestEqip.do")
	public ModelAndView saveMachineInfo(@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			) throws Exception{
		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		ModelAndView modelAndView = new ModelAndView("ruiView");
		HashMap<String, Object> rtnMeaasge = new HashMap<String, Object>();
		String rtnSt ="F";
		String rtnMsg = "";
		LOGGER.debug("###############################input################################################ : "+ input);
		try{
        	//고정자산 목록이 이미 등록이 되어있는지 확인
        	int fxaCnt = 0;
        	
        	if(!"".equals(input.get("fxaNo"))){
        		fxaCnt = anlMchnService.retrieveFxaInfoCnt(input);
        	}

        	if( fxaCnt > 0 ){
        		rtnMsg = "이미 등록되어 있는 고정자산입니다.";
        	}else{
        		rlabTestEqipService.saveRlabTestEqip(input);
            	
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
	@RequestMapping(value="/mchn/mgmt/rlabTestEqipSearchDtl.do")
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
        	HashMap<String, Object> result = rlabTestEqipService.rlabTestEqipSearchDtl(input);
			modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", result));
        }

		return  modelAndView;
	}



	
	
	
	
}
