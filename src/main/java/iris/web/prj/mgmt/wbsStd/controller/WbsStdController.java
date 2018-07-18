package iris.web.prj.mgmt.wbsStd.controller;

import java.net.URLDecoder;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.logging.log4j.LogManager; import org.apache.logging.log4j.Logger;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;



import iris.web.common.converter.RuiConverter;

import iris.web.common.util.StringUtil;
import iris.web.prj.mgmt.wbsStd.service.WbsStdService;
import iris.web.system.base.IrisBaseController;
import devonframe.message.saymessage.SayMessage;
import devonframe.util.NullUtil;

/********************************************************************************
 * NAME : WbsStdController.java 
 * DESC : 관리 controller
 * PROJ : Iris
 * *************************************************************/

@Controller
public class WbsStdController  extends IrisBaseController {

	@Resource(name="messageSourceAccessor")
	private MessageSourceAccessor messageSourceAccessor;
	
	@Resource(name = "wbsStdService")
	private WbsStdService wbsStdService;	
	
	
	private StringUtil stringUtil;
	static final Logger LOGGER = LogManager.getLogger(WbsStdController.class);
	
	/*
	 * 표준 WBS 조회
	 */
	@RequestMapping(value="/prj/mgmt/wbsStd/wbsStdList.do")
	public String wbsStdempList(@RequestParam HashMap<String, String> input, HttpServletRequest request, HttpSession session, ModelMap model ){

		LOGGER.debug("###########################################################");
		LOGGER.debug("WbsStdController - wbsStdempList [표준 WBS화면 호출]");
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

		return "web/prj/mgmt/wbsStd/wbsStdList";
	}
	/**
	 * 상세조회
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 * @throws Exception
	 */
	 @RequestMapping(value="/prj/mgmt/wbsStd/wbsStdDtl.do")
		public String wbsStdempDtl(@RequestParam HashMap<String, String> input,HttpServletRequest request,
								HttpSession session,ModelMap model) throws Exception{
			
			/* 반드시 공통 호출 후 작업 */
			checkSession(input, session, model);
			if(NullUtil.isNull(input.get("_userId")) ||  NullUtil.nvl(input.get("_userId"), "").equals("-1")  ){
				String rtnMsg = messageSourceAccessor.getMessage("msg.alert.sessionTimeout");
				SayMessage.setMessage(rtnMsg);
	        } else {
		        model.addAttribute("inputData", input);
	        }
			
			 ModelAndView modelAndView = new ModelAndView("ruiView");

			LOGGER.debug("###########################################################");
			LOGGER.debug("WbsStdController - wbsStdempDtl [표준 WBS상세화면 호출]");
			LOGGER.debug("input = > " + input);
			LOGGER.debug("###########################################################");
			
		
	        model.addAttribute("inputData", input);
	        
	        return  "web/prj/mgmt/wbsStd/wbsStdDtl";
		
		}


	@RequestMapping(value="/prj/mgmt/wbsStd/retrieveWbsStdList.do")
	public ModelAndView retrievewbsStdempList(@RequestParam HashMap<String, Object> input, HttpServletRequest request,
	                                          HttpServletResponse response, HttpSession session, ModelMap model) {

		LOGGER.debug("###########################################################");
		LOGGER.debug("WbsStdController - retrieveWbsStdList ");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");
		
		ModelAndView modelAndView = new ModelAndView("ruiView");
        	
    	input = StringUtil.toUtf8(input);
    	
        List<Map<String,Object>> list = wbsStdService.retrieveWbsStdList(input);
		 
		modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", list));

		return modelAndView;
	}
	


	
	
		@RequestMapping(value="/prj/mgmt/wbsStd/retrieveWbsStdDtl.do")
		public ModelAndView retrieveWbsStdDtl(@RequestParam HashMap<String, Object> input, HttpServletRequest request,
		                                          HttpServletResponse response, HttpSession session, ModelMap model) {

			LOGGER.debug("###########################################################");
			LOGGER.debug("WbsStdController - retrieveWbsStdDtl");
			LOGGER.debug("input = > " + input);
			LOGGER.debug("###########################################################");
			
			ModelAndView modelAndView = new ModelAndView("ruiView");
	        	
	    	input = StringUtil.toUtf8(input);
	    	

	    	List<Map<String, Object>> list = wbsStdService.retrieveWbsStdDtl(input);
			 
	    	 
	         modelAndView.addObject("gridDataSet", RuiConverter.createDataset("dataSet", list));
			 

			return modelAndView;
		}
		
	 
	 
}
