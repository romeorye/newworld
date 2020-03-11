package iris.web.prj.tss.mkInnoMonCls.controller;

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
import iris.web.common.util.StringUtil;
import iris.web.prj.tss.mkInnoMonCls.service.MkInnoMonClsService;
import iris.web.system.base.IrisBaseController;

@Controller
public class MkInnoMonClsController extends IrisBaseController{
	
	@Resource(name = "mkInnoMonClsService")
	private MkInnoMonClsService mkInnoMonClsService;
	
	static final Logger LOGGER = LogManager.getLogger(MkInnoMonClsService.class);

	
	
	/**
     * 과제관리 > 제조혁신 월마감 리스트 화면
     *
     * @param input HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return String
     * */                  
    @RequestMapping(value="/prj/tss/mkInnoMonCls/mkInnoTssMonClsList.do")
    public String mkInnoMonClsList(@RequestParam HashMap<String, Object> input, HttpServletRequest request,
            HttpSession session, ModelMap model) {
    	
    	checkSessionObjRUI(input, session, model);
        
    	LOGGER.debug("###########################################################");
        LOGGER.debug("MkInnoMonClsController - mkInnoMonClsList [과제관리 > 제조혁신 월마감 리스트 화면]");
        LOGGER.debug("###########################################################");

        input = StringUtil.toUtf8(input);
        
        model.addAttribute("inputData", input);
        
    	return "web/prj/tss/mkInno/mkInnoMonCls/mkInnoMonClsList"; 
    }
	
	/**
     * 과제관리 > 제조혁신 월마감 리스트 조회
     *
     * @param input HashMap<String, Object>
     * @param request HttpServletRequest
     * @param response HttpServletResponse
     * @param session HttpSession
     * @param model ModelMap
     * @return ModelAndView
     * */
    @SuppressWarnings("unchecked")
    @RequestMapping(value="/prj/tss/mkInnoMonCls/retrieveMkInnoMonClsSearchList.do")
    public ModelAndView retrieveMkInnoMonClsSearchList(@RequestParam HashMap<String, Object> input, HttpServletRequest request,
            HttpServletResponse response, HttpSession session, ModelMap model) {

    	checkSessionObjRUI(input, session, model);
    	
        LOGGER.debug("###########################################################");
        LOGGER.debug("MkInnoMonClsController - retrieveMkInnoMonClsSearchList [과제관리 > 제조혁신 월마감 리스트 조회]");
        LOGGER.debug("###########################################################");

        ModelAndView modelAndView = new ModelAndView("ruiView");

        input = StringUtil.toUtf8(input);

        List<Map<String,Object>> list = mkInnoMonClsService.retrieveMkInnoMonClsSearchList(input);

        modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", list));

        return modelAndView;
    }
	
    /**
     * 과제관리 > 제조혁신 월마감 상세화면
     *
     * @param input HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return String
     * */
    @RequestMapping(value="/prj/tss/mkInnoMonCls/mkInnoMonClsDetail.do")
    public String mkInnoMonClsDetail(@RequestParam HashMap<String, Object> input, HttpServletRequest request,
            HttpSession session, ModelMap model) {
    	
    	checkSessionObjRUI(input, session, model);
        
    	LOGGER.debug("###########################################################");
        LOGGER.debug("MkInnoMonClsController - mkInnoMonClsDetail [과제관리 > 제조혁신 월마감 상세화면]");
        LOGGER.debug("###########################################################");

        input = StringUtil.toUtf8(input);
        
        model.addAttribute("inputData", input);
        
    	return "web/prj/tss/mkInno/mkInnoMonCls/mkInnoMonClsDtl"; 
    }
	
    
    /**
     * 과제관리 > 제조혁신 월마감 상세 조회
     *
     * @param input HashMap<String, Object>
     * @param request HttpServletRequest
     * @param response HttpServletResponse
     * @param session HttpSession
     * @param model ModelMap
     * @return ModelAndView
     * */
    @SuppressWarnings("unchecked")
    @RequestMapping(value="/prj/tss/mkInnoMonCls/retrieveMkInnoMonClsDtl.do")
    public ModelAndView retrieveMkInnoMonClsDtl(@RequestParam HashMap<String, Object> input, HttpServletRequest request,
            HttpServletResponse response, HttpSession session, ModelMap model) {

    	checkSessionObjRUI(input, session, model);
    	
        LOGGER.debug("###########################################################");
        LOGGER.debug("MkInnoMonClsController - retrieveMkInnoMonClsDtl [과제관리 > 제조혁신 월마감 상세 조회]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        ModelAndView modelAndView = new ModelAndView("ruiView");

        input = StringUtil.toUtf8(input);

        Map<String,Object> map = mkInnoMonClsService.retrieveMkInnoMonClsDtl(input);

        modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", map));

        return modelAndView;
    }
	

    /**
     * 과제관리 > 제조혁신 월마감 저장 조회
     *
     * @param input HashMap<String, Object>
     * @param request HttpServletRequest
     * @param response HttpServletResponse
     * @param session HttpSession
     * @param model ModelMap
     * @return ModelAndView
     * */
    @SuppressWarnings("unchecked")
    @RequestMapping(value="/prj/tss/mkInnoMonCls/updateMkInnoMonClsInfo.do")
    public ModelAndView updateMkInnoMonClsInfo(@RequestParam HashMap<String, Object> input, HttpServletRequest request,
            HttpServletResponse response, HttpSession session, ModelMap model) {

    	checkSessionObjRUI(input, session, model);
    	
        LOGGER.debug("###########################################################");
        LOGGER.debug("MkInnoMonClsController - updateMkInnoMonClsInfo [과제관리 > 제조혁신 월마감 저장 조회]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        ModelAndView modelAndView = new ModelAndView("ruiView");

        input = StringUtil.toUtf8(input);
        
        Map<String,Object> monClsInfo = new HashMap<String, Object>();
        Map<String,Object> resultMap = new HashMap<String, Object>();
        
        try{
        	monClsInfo = RuiConverter.convertToDataSet(request, "dataSet").get(0);
        	monClsInfo.put("userId", input.get("_userId"));
        	
        	mkInnoMonClsService.updateMkInnoMonClsInfo(monClsInfo);
        	
        	resultMap.put("rtnSt", "Y");
			resultMap.put("rtnMsg", "정상적으로 저장 되었습니다.");
        }catch(Exception e){
        	resultMap.put("rtnSt", "N");
			resultMap.put("rtnMsg", e.getMessage());
        }
        
        modelAndView.addObject("result", RuiConverter.createDataset("result", resultMap));
        
        return modelAndView;
    }
    
	
}
