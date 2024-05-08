package iris.web.stat.code.controller;

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

import iris.web.common.converter.RuiConverter;
import iris.web.common.util.StringUtil;
import iris.web.stat.code.service.ComCodeService;
import iris.web.system.base.IrisBaseController;

@Controller
public class ComCodeController extends IrisBaseController {

	@Resource(name="messageSourceAccessor")
	private MessageSourceAccessor messageSourceAccessor;
	
	@Resource(name="comCodeService")
	private ComCodeService comCodeService;
	
	static final Logger LOGGER = LogManager.getLogger(ComCodeController.class);
	
	/**
	 * 통계 > 공통코드 관리 >공통코드 관리 화면이동 
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/stat/mgmt/comCodeList.do")
	public String comCodeList(@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){

		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		//LOGGER.debug("####################input################################################################# : " + input);
		
		model.addAttribute("inputData", input);

		return  "web/stat/code/comCodeList";
	}
	
	/**
	 * 통계 > 공통코드 관리 >공통코드 관리 리스트 조회
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/stat/code/retrieveCcomCodeList.do")
	public ModelAndView retrieveCcomCodeList(
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
		LOGGER.debug("comCodeService - retrieveCcomCodeList [공통코드 관리 리스트 조회]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");
		
		ModelAndView modelAndView = new ModelAndView("ruiView");
    	
		List<Map<String,Object>> resultList = comCodeService.retrieveCcomCodeList(input);
		
		modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", resultList));
		
		return modelAndView;
	}
	
	
	
		/**
		 * 통계 > 공통코드 관리 >공통코드 등록 화면이동 
		 * @param input
		 * @param request
		 * @param session
		 * @param model
		 * @return
		 */
		@RequestMapping(value="/stat/code/codeRegPop.do")
		public String codeRegPop(@RequestParam HashMap<String, Object> input,
				HttpServletRequest request,
				HttpSession session,
				ModelMap model
				){

			/* 반드시 공통 호출 후 작업 */
			checkSessionObjRUI(input, session, model);
			//LOGGER.debug("####################input################################################################# : " + input);
			
			model.addAttribute("inputData", input);

			return  "web/stat/code/codeRegPop";
		}
		
		/**
		 * 통계 > 공통코드 관리 >공통코드 등록 및 수정
		 * @param input
		 * @param request
		 * @param session
		 * @param model
		 * @return
		 */
		@RequestMapping(value="/stat/code/saveCodeInfo.do")
		public ModelAndView saveCodeInfo(
				@RequestParam HashMap<String, Object> input,
				HttpServletRequest request,
				HttpServletResponse response,
				HttpSession session,
				ModelMap model
				){
			
			/* 반드시 공통 호출 후 작업 */
			checkSessionObjRUI(input, session, model);
			
	    	input = StringUtil.toUtf8(input);

			ModelAndView modelAndView = new ModelAndView("ruiView");
			HashMap<String, Object> rtnMeaasge = new HashMap<String, Object>();
			List<Map<String, Object>> codeList= null; 
			List<Map<String, Object>> udateCodeList= null; 
			
			String rtnMsg = "";
			String rtnSt = "F";
			
			try{
				codeList = RuiConverter.convertToDataSet(request,"dataSet");	
				
				if(codeList.size() > 0 ){
					comCodeService.saveCodeInfo(codeList);
				}else{
					throw new Exception("저장할 건수가 없습니다.");
				}
				
				rtnMsg = "저장되었습니다.";
				rtnSt = "S";
			}catch(Exception e){
				rtnMsg = "처리중 오류가발생했습니다. 담당자에게 문의해주세요.";
			}
			
			rtnMeaasge.put("rtnMsg", rtnMsg);
			rtnMeaasge.put("rtnSt", rtnSt);
			modelAndView.addObject("resultDataSet", RuiConverter.createDataset("resultDataSet", rtnMeaasge));
			
			return modelAndView;
		}	
			
}
