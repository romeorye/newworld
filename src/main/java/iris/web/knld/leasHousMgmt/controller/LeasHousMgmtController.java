package iris.web.knld.leasHousMgmt.controller;

import java.util.HashMap;
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
import iris.web.knld.leasHous.controller.LeasHousController;
import iris.web.knld.leasHousMgmt.service.LeasHousMgmtService;
import iris.web.system.base.IrisBaseController;

@Controller
public class LeasHousMgmtController extends IrisBaseController {

	
	@Resource(name="leasHousMgmtService")
	private LeasHousMgmtService leasHousMgmtService;
	
	static final Logger LOGGER = LogManager.getLogger(LeasHousController.class);
	
	
	
	/**
	 * 임차주택관리 목록 화면
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */                     
	@RequestMapping(value="/knld/leasHousMgmt/retrieveLeasHousMgmtList.do")
	public String retrieveLeasHousMgmtList(@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){

		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		input = StringUtil.toUtf8(input);

		model.addAttribute("inputData", input);

		return  "web/knld/leasHousMgmt/leasHousMgmtList";
	}
	
	/**
	 * 임차주택관리 첨부파일 등록 화면
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/knld/leasHousMgmt/attchFilReqPop.do")
	public String attchFilReqPop(@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
		
		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		input = StringUtil.toUtf8(input);
		
		model.addAttribute("inputData", input);
		
		return  "web/knld/leasHousMgmt/attchFilReqPop";
	}
	
	
	/**
     * 임차주택관리 > 필수첨부파일  조회
     *
     * @param input HashMap<String, Object>
     * @param request HttpServletRequest
     * @param response HttpServletResponse
     * @param session HttpSession
     * @param model ModelMap
     * @return ModelAndView
     * */
    @SuppressWarnings("unchecked")
    @RequestMapping(value="/knld/leasHousMgmt/retrieveAttchFilInfo.do")
    public ModelAndView retrieveAttchFilInfo(@RequestParam HashMap<String, Object> input, HttpServletRequest request,
            HttpServletResponse response, HttpSession session, ModelMap model) {

    	checkSessionObjRUI(input, session, model);
    	
        LOGGER.debug("###########################################################");
        LOGGER.debug("leasHousMgmtService - retrieveAttchFilInfo [임차주택관리 > 필수첨부파일 리스트 조회]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        ModelAndView modelAndView = new ModelAndView("ruiView");

        input = StringUtil.toUtf8(input);

        Map<String,Object> map = leasHousMgmtService.retrieveAttchFilInfo(input);

        
        modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", map));

        return modelAndView;
    }
	
    /**
     * 임차주택관리 > 필수첨부파일 저장
     *
     * @param input HashMap<String, Object>
     * @param request HttpServletRequest
     * @param response HttpServletResponse
     * @param session HttpSession
     * @param model ModelMap
     * @return ModelAndView
     * */
    @SuppressWarnings("unchecked")
    @RequestMapping(value="/knld/leasHousMgmt/saveAttchFil.do")
    public ModelAndView saveAttchFil(@RequestParam HashMap<String, Object> input, HttpServletRequest request,
            HttpServletResponse response, HttpSession session, ModelMap model) {

    	checkSessionObjRUI(input, session, model);
    	
        LOGGER.debug("###########################################################");
        LOGGER.debug("leasHousMgmtService - saveAttchFil [임차주택관리 > 필수첨부파일 저장]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");
        input = StringUtil.toUtf8(input);

        HashMap<String, Object> rtnMeaasge = new HashMap<String, Object>();
        ModelAndView modelAndView = new ModelAndView("ruiView");
        
        Map<String, Object> map = new HashMap<String, Object>();
		
        String rtnSt ="F";
        String rtnMsg = "";
        
        try{
        	map = RuiConverter.convertToDataSet(request, "dataSet").get(0);
        	map.put("userId", input.get("_userId")); 
        	
        	leasHousMgmtService.saveAttchFil(map);
        	
        	rtnMsg = "저장되었습니다.";
			rtnSt = "S";
        }catch(Exception e){
        	e.printStackTrace();
			rtnMsg = e.getMessage();
        }
        
        rtnMeaasge.put("rtnMsg", rtnMsg);
		rtnMeaasge.put("rtnSt", rtnSt);
		
		modelAndView.addObject("resultDataSet", RuiConverter.createDataset("resultDataSet", rtnMeaasge));

        return modelAndView;
    }
    
	
	
}
