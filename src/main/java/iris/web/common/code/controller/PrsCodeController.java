package iris.web.common.code.controller;

import java.util.HashMap;
import java.util.List;

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
}
