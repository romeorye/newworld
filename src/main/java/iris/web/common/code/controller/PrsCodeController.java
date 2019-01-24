package iris.web.common.code.controller;

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
import iris.web.system.base.IrisBaseController;

@Controller
public class PrsCodeController extends IrisBaseController  {

	
	@Resource(name = "prsCodeService")
	private PrsCodeService prsCodeService;    
	
	@Resource(name = "codeCacheManager")
    private CodeCacheManager codeCacheManager;    
	
	static final Logger LOGGER = LogManager.getLogger(CodeController.class);

	
	@RequestMapping(value="/common/prsCode/retrieveEkgrpInfo.do")
    public ModelAndView retrieveEkgrpInfo(
            @RequestParam HashMap<String, Object> input,
            HttpServletRequest request,
            HttpServletResponse response,
            HttpSession session,
            ModelMap model
            ){

        LOGGER.debug("###########################################################");
        LOGGER.debug("PrsCodeController - retrieveEkgrpInfo [구매 공통코드 캐쉬조회]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");
        
        ModelAndView modelAndView = new ModelAndView("ruiView");

        input = StringUtil.toUtf8Input(input);
        //input.put("code", input.get("ekgrp"));
        
        // 공통코드 캐쉬조회
        List prsCodeList = prsCodeService.retrieveEkgrpInfo(input);
         
        modelAndView.addObject("radioDataSet", RuiConverter.createDataset("codeList", prsCodeList));

        return modelAndView;
    }   
	
	@RequestMapping(value="/common/prsCode/retrieveMeinsInfo.do")
	public ModelAndView retrieveMengeInfo(
			@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpServletResponse response,
			HttpSession session,
			ModelMap model
			){
		
		LOGGER.debug("###########################################################");
		LOGGER.debug("PrsCodeController - retrieveMeinsInfo [구매 단위수량 캐쉬조회]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");
		
		ModelAndView modelAndView = new ModelAndView("ruiView");
		
		input = StringUtil.toUtf8Input(input);
		//input.put("code", input.get("ekgrp"));
		
		// 공통코드 캐쉬조회
		List meinsCodeList = prsCodeService.retrieveMeinsInfo(input);
		
		modelAndView.addObject("radioDataSet", RuiConverter.createDataset("codeList", meinsCodeList));
		
		return modelAndView;
	}   
	
	@RequestMapping(value="/common/prsCode/retrieveWerksInfo.do")
	public ModelAndView retrieveWerksInfo(
			@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpServletResponse response,
			HttpSession session,
			ModelMap model
			){
		
		LOGGER.debug("###########################################################");
		LOGGER.debug("PrsCodeController - retrieveWerksInfo [플랜트 캐쉬조회]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");
		
		ModelAndView modelAndView = new ModelAndView("ruiView");
		
		// 공통코드 캐쉬조회
		List werksCodeList = prsCodeService.retrieveWerksInfo(input);
		
		modelAndView.addObject("radioDataSet", RuiConverter.createDataset("codeList", werksCodeList));
		
		return modelAndView;
	}   
	
	@RequestMapping(value="/common/prsCode/retrieveItemGubunInfo.do")
    public ModelAndView retrieveItemGubunInfo(
            @RequestParam HashMap<String, Object> input,
            HttpServletRequest request,
            HttpServletResponse response,
            HttpSession session,
            ModelMap model
            ){

        LOGGER.debug("###########################################################");
        LOGGER.debug("PrsCodeController - retrieveItemGubunInfo [구매요청시 품목구분에 사용할 수 있는 목록 조회]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");
        
        ModelAndView modelAndView = new ModelAndView("ruiView");

        input = StringUtil.toUtf8Input(input);
        System.out.println("-------------------------------------------");
        System.out.println(input.get("tabId"));
        System.out.println("-------------------------------------------");
        // 공통코드 캐쉬조회
        List prsCodeList = prsCodeService.retrieveItemGubunInfo(input);
         
        modelAndView.addObject("radioDataSet", RuiConverter.createDataset("codeList", prsCodeList));

        return modelAndView;
    }   
	
	/**
	 *  품목구분관련정보 조회
	 * @param input
	 * @param request
	 * @param response
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/common/prsCode/retrieveScodeInfo.do")
	public ModelAndView retrieveScodeInfo(
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
		LOGGER.debug("PrsCodeController - retrieveScodeInfo [품목구분관련정보 조회]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		ModelAndView modelAndView = new ModelAndView("ruiView");

        //구매요청 리스트 조회
		List<Map<String,Object>> prsRqScodeInfo = prsCodeService.retrieveScodeInfo(input);

		modelAndView.addObject("purRqScodeDataSet", RuiConverter.createDataset("purRqScodeDataSet", prsRqScodeInfo));

		return modelAndView;
	}
	
	@RequestMapping(value="/common/prsCode/retrievePrsFlagInfo.do")
    public ModelAndView retrievePrsFlagInfo(
            @RequestParam HashMap<String, Object> input,
            HttpServletRequest request,
            HttpServletResponse response,
            HttpSession session,
            ModelMap model
            ){

        LOGGER.debug("###########################################################");
        LOGGER.debug("PrsCodeController - retrieveEkgrpInfo [구매 공통코드 캐쉬조회]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");
        
        ModelAndView modelAndView = new ModelAndView("ruiView");

        input = StringUtil.toUtf8Input(input);
		input.put("delFlag", "Display");			// 나의 목록조회에서 삭제한 것은 보여줄 필요 없음
        
        // 공통코드 캐쉬조회
        List prsFlagList = prsCodeService.retrievePrsFlagInfo(input);
         
        modelAndView.addObject("radioDataSet", RuiConverter.createDataset("codeList", prsFlagList));

        return modelAndView;
    }   

}
