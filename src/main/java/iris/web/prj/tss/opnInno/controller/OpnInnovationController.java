package iris.web.prj.tss.opnInno.controller;

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
import iris.web.prj.tss.opnInno.service.OpnInnovationService;
import iris.web.system.base.IrisBaseController;

@Controller
public class OpnInnovationController extends IrisBaseController {
	
	@Resource(name="messageSourceAccessor")
	private MessageSourceAccessor messageSourceAccessor;

	static final Logger LOGGER = LogManager.getLogger(OpnInnovationController.class);
	
	@Resource(name="opnInnovationService")
	private OpnInnovationService opnInnovationService;
	
	
	/**
	 *  open innovation 협력과제 관리 리스트 화면으로 이동
	 */
	@RequestMapping(value="/prj/tss/opnInno/retrieveOpnInno.do")
	public String retrieveOpnInno(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
			
		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);
		LOGGER.debug("########################################################################################");
		LOGGER.debug("OpnInnovationController - retrieveOpnInno [Open Innovation 협력과제 관리 화면이동]");
		LOGGER.debug("########################################################################################");	
		
		model.addAttribute("inputData", input);
	
		return "web/prj/tss/opnInno/opnInnoList";
	}
	
	
	/**
	 *  open innovation 협력과제 관리 리스트조회
	 */
	@RequestMapping(value="/prj/tss/opnInno/retrieveOpnInnoSearchList.do")
	public ModelAndView retrieveOpnInnoSearchList(
			@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpServletResponse response,
			HttpSession session,
			ModelMap model
			){

		/*반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		ModelAndView modelAndView = new ModelAndView("ruiView");
		
		LOGGER.debug("##############################################################################################");
		LOGGER.debug("OpnInnovationController - retrieveOpnInnoSearchList [Open Innovation 협력과제 관리목록 조회]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("##############################################################################################");

		input = StringUtil.toUtf8(input);
		
        List<Map<String,Object>> list = opnInnovationService.retrieveOpnInnoSearchList(input);
        
		modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", list));

		return modelAndView;
	}


	/**
	 *  open innovation 협력과제 정보 등록(수정)
	 */
	@RequestMapping(value="/prj/tss/opnInno/opnInnoReg.do")
	public String opnInnoReg(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
			
		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);
		LOGGER.debug("########################################################################################");
		LOGGER.debug("OpnInnovationController - opnInnoReg [Open Innovation 협력과제 관리 신규(수정)]");
		LOGGER.debug("########################################################################################");	
		
		model.addAttribute("inputData", input);
	
		return "web/prj/tss/opnInno/opnInnoReg";
	}
	
	/**
	 *  open innovation 협력과제 정보 등록(수정) 정보 조회
	 */
	@RequestMapping(value="/prj/tss/opnInno/retrieveOpnInnoInfo.do")
	public ModelAndView retrieveOpnInnoInfo(
			@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpServletResponse response,
			HttpSession session,
			ModelMap model
			){

		/*반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		ModelAndView modelAndView = new ModelAndView("ruiView");
		
		LOGGER.debug("##############################################################################################");
		LOGGER.debug("OpnInnovationController - retrieveOpnInnoInfo [Open Innovation 협력과제 정보 등록(수정) 정보 조회]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("##############################################################################################");

        Map<String,Object> result = opnInnovationService.retrieveOpnInnoInfo(input);
        
		modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", StringUtil.toUtf8Output((HashMap) result)));

		return modelAndView;
	}
	
	
	/**
	 *  open innovation 협력과제 정보 저장
	 */
	@RequestMapping(value="/prj/tss/opnInno/saveOpnInnoInfo.do")
	public ModelAndView saveOpnInnoInfo(
			@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpServletResponse response,
			HttpSession session,
			ModelMap model
			){

		/*반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		ModelAndView modelAndView = new ModelAndView("ruiView");
		
		LOGGER.debug("##############################################################################################");
		LOGGER.debug("OpnInnovationController - saveOpnInnoInfo [Open Innovation 협력과제 정보 저장]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("##############################################################################################");

		HashMap<String, Object> rtnMeaasge = new HashMap<String, Object>();
		
		String rtnSt ="F";
		String rtnMsg = "";
		
        try{
        		
        	Map<String, Object> saveDataSet = RuiConverter.convertToDataSet(request, "dataSet").get(0);
        	
        	saveDataSet.put("_userId", input.get("_userId"));
        	
        	StringUtil.toUtf8Input((HashMap) saveDataSet);
        	LOGGER.debug("saveDataSet = > " + saveDataSet);
        	opnInnovationService.saveOpnInnoInfo(saveDataSet);
        	
        	rtnMsg = "저장되었습니다.";
			rtnSt = "S";
		}catch(Exception e){
			e.printStackTrace();
			rtnMsg = "저장 중 오류가 발생하였습니다.";
		}

		rtnMeaasge.put("rtnMsg", rtnMsg);
		rtnMeaasge.put("rtnSt", rtnSt);
		
		modelAndView.addObject("resultDataSet", RuiConverter.createDataset("resultDataSet", rtnMeaasge));

		return modelAndView;
	}
	

	/**
	 *  open innovation 협력과제 정보 삭제
	 */
	@RequestMapping(value="/prj/tss/opnInno/deleteOpnInnoInfo.do")
	public ModelAndView deleteOpnInnoInfo(
			@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpServletResponse response,
			HttpSession session,
			ModelMap model
			){

		/*반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		ModelAndView modelAndView = new ModelAndView("ruiView");
		
		LOGGER.debug("##############################################################################################");
		LOGGER.debug("OpnInnovationController - deleteOpnInnoInfo [Open Innovation 협력과제 정보 삭제]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("##############################################################################################");

		HashMap<String, Object> rtnMeaasge = new HashMap<String, Object>();
		
		String rtnSt ="F";
		String rtnMsg = "";
		
        try{
        		
        	opnInnovationService.deleteOpnInnoInfo(input);
        	
        	rtnMsg = "삭제되었습니다.";
			rtnSt = "S";
		}catch(Exception e){
			e.printStackTrace();
			rtnMsg = "삭제 중 오류가 발생하였습니다.";
		}

		rtnMeaasge.put("rtnMsg", rtnMsg);
		rtnMeaasge.put("rtnSt", rtnSt);
		
		modelAndView.addObject("resultDataSet", RuiConverter.createDataset("resultDataSet", rtnMeaasge));

		return modelAndView;
	}
	
}
