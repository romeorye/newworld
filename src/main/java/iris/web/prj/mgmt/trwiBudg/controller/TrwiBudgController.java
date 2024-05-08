package iris.web.prj.mgmt.trwiBudg.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import devonframe.message.saymessage.SayMessage;
import devonframe.util.NullUtil;
import iris.web.common.converter.RuiConverter;
import iris.web.common.util.StringUtil;
import iris.web.prj.mgmt.trwiBudg.service.TrwiBudgService;
import iris.web.system.base.IrisBaseController;

/********************************************************************************
 * NAME : TrwiBudgController.java 
 * DESC : 관리 controller
 * PROJ : Iris
 * *************************************************************/

@Controller
public class TrwiBudgController  extends IrisBaseController {

	@Resource(name="messageSourceAccessor")
	private MessageSourceAccessor messageSourceAccessor;
	
	@Resource(name = "trwiBudgService")
	private TrwiBudgService trwiBudgService;	
	
	
	private StringUtil stringUtil;
	static final Logger LOGGER = LogManager.getLogger(TrwiBudgController.class);
	
	/**
	 * 조회 화면
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/prj/mgmt/trwiBudg/trwiBudgList.do")
	public String trwiBudgList(@RequestParam HashMap<String, String> input, HttpServletRequest request, HttpSession session, ModelMap model ){

		LOGGER.debug("###########################################################");
		LOGGER.debug("TrwiBudgController - TrwiBudgList [템플릿화면 호출]");
		LOGGER.debug("###########################################################");
		
		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);
		
		if(NullUtil.isNull(input.get("_userId")) ||  NullUtil.nvl(input.get("_userId"), "").equals("-1")  ){
			String rtnMsg = messageSourceAccessor.getMessage("msg.alert.sessionTimeout");
			SayMessage.setMessage(rtnMsg);
        } else {
	        model.addAttribute("inputData", input);
        }
		
		LOGGER.debug("###########################################################");
		LOGGER.debug("loginUser => " + model.get("loginUser"));
		LOGGER.debug("inputData => " + input);
		
		LOGGER.debug("###########################################################");		

		return "web/prj/mgmt/trwiBudg/trwiBudgList";
	}

	
	
	/**
	 * 상세조회및 저장 화면
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/prj/mgmt/trwiBudg/trwiBudgDtlPopup.do")
	public String trwiBudgSavePopup(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){

		LOGGER.debug("###########################################################");
		LOGGER.debug("TrwiBudgController - trwiBudgDtlPopup 예산비용POPUP");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");
		
		
		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);
		
		model.addAttribute("inputData", input);
		
		return "web/prj/mgmt/trwiBudg/trwiBudgDtlPopup";
	}
	
	
/**
 * 목록 조회 
 * @param input
 * @param request
 * @param response
 * @param session
 * @param model
 * @return
 */
	@RequestMapping(value="/prj/mgmt/trwiBudg/retrieveTrwiBudgList.do")
	public ModelAndView retrieveTrwiBudgList(@RequestParam HashMap<String, Object> input, HttpServletRequest request,
	                                          HttpServletResponse response, HttpSession session, ModelMap model) {

		LOGGER.debug("###########################################################");
		LOGGER.debug("retrieveTrwiBudgList - retrieveTrwiBudgList");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");
		
		ModelAndView modelAndView = new ModelAndView("ruiView");
        	
    	input = StringUtil.toUtf8(input);
    	
        List<Map<String,Object>> list = trwiBudgService.retrieveTrwiBudgList(input);
		
        Object a = RuiConverter.createDataset("dataSet", list);
        
        
		modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", list));

		return modelAndView;
	}
/**
 * 	상세조회
 * @param input
 * @param request
 * @param response
 * @param session
 * @param model
 * @return
 */
	@RequestMapping(value="/prj/mgmt/trwiBudg/retrieveTrwiBudgDtl.do")
	public ModelAndView retrieveTrwiBudgDtl(@RequestParam HashMap<String, Object> input, HttpServletRequest request,
	                                          HttpServletResponse response, HttpSession session, ModelMap model) {

		LOGGER.debug("###########################################################");
		LOGGER.debug("retrieveTrwiBudgList - retrieveTrwiBudgList ");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");
		
		ModelAndView modelAndView = new ModelAndView("ruiView");
        	
		input = StringUtil.toUtf8(input);
    	

		  
		  List<Map<String, Object>> rstGridDataSet = trwiBudgService.retrieveTrwiBudgDtl(input);
		  
		  modelAndView.addObject("gridDataSet", RuiConverter.createDataset("dataSet", rstGridDataSet));
	    

	LOGGER.debug("###########################################################");
	LOGGER.debug("modelAndView => " + modelAndView);
	LOGGER.debug("###########################################################");

		return modelAndView;
	}
	

/**
 * 저장	
 * @param input
 * @param request
 * @param session
 * @param model
 * @return
 */
	
	@RequestMapping(value="/prj/mgmt/trwiBudg/insertTrwiBudgSave.do")
	    public ModelAndView insertTrwiBudgSave(@RequestParam HashMap<String, Object> input, HttpServletRequest request,
	                                              HttpSession session, ModelMap model) {

	        LOGGER.debug("###########################################################");
	        LOGGER.debug("insertTrwiBudgSave [투입예산저장]");
	        LOGGER.debug("input = > " + input);
	        LOGGER.debug("###########################################################");
	  
	        checkSessionObjRUI(input, session, model);
	        
	        ModelAndView modelAndView = new ModelAndView("ruiView");
	        
	        HashMap<String, Object> rtnMeaasge = new HashMap<String, Object>();

	        List<Map<String, Object>> dsLst = null;
	   
	        try {
	          
	            dsLst = RuiConverter.convertToDataSet(request,  "dataSet");
	            input.put("userId", input.get("_userId"));
//	        	ds.put("psnnRisnPro", input.get("psnnRisnPro"));
//        		ds.put("pceRisnPro", input.get("pceRisnPro"));
        	
	                	for(Map<String, Object> ds  : dsLst) {
	                		ds.put("yy" , input.get("budgYY") );
	                		ds.put("userId", input.get("_userId"));
	                		trwiBudgService.saveTrwiBudg(ds);		
	                	}
	                	//물가상승율 인건비 수정
	                	trwiBudgService.updateTrwiBudgPro(input);	
	                	
            	rtnMeaasge.put("rtCd", "SUCCESS");
            	rtnMeaasge.put("rtVal",messageSourceAccessor.getMessage("msg.alert.saved")); //저장되었습니다.
            
	            
	        } catch(Exception e) {
	        	e.printStackTrace();	
	        	rtnMeaasge.put("rtCd", "FAIL");
	        	rtnMeaasge.put("rtVal", messageSourceAccessor.getMessage("msg.alert.error")); //오류가 발생하였습니다.
	        }
	        
	        modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", rtnMeaasge));
	        return modelAndView;
	    }
	 

	
	
	@RequestMapping(value="/prj/mgmt/trwiBudg/deleteTrwiBudg.do")
    public ModelAndView deleteTrwiBudg(@RequestParam HashMap<String, Object> input, HttpServletRequest request,
                                              HttpSession session, ModelMap model) {

        LOGGER.debug("###########################################################");
        LOGGER.debug("insertTrwiBudgSave [투입예산저장]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");
  
        checkSessionObjRUI(input, session, model);
        
        ModelAndView modelAndView = new ModelAndView("ruiView");
        
        HashMap<String, Object> rtnMeaasge = new HashMap<String, Object>();

       
   
        try {
            input.put("userId", input.get("_userId"));
            trwiBudgService.deleteTrwiBudg(input);		
                
                
        	rtnMeaasge.put("rtCd", "SUCCESS");
        	rtnMeaasge.put("rtVal",messageSourceAccessor.getMessage("msg.alert.deleted")); //저장되었습니다.
        
            
        } catch(Exception e) {
        	e.printStackTrace();	
        	rtnMeaasge.put("rtCd", "FAIL");
        	rtnMeaasge.put("rtVal", messageSourceAccessor.getMessage("msg.alert.error")); //오류가 발생하였습니다.
        }
        
        modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", rtnMeaasge));
        return modelAndView;
    }

		
		
	 
	 
}
