package iris.web.prj.tclgInfo.controller;

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
import iris.web.prj.tclgInfo.service.TclgInfoReqService;
import iris.web.system.base.IrisBaseController;

@Controller
public class TclgInfoReqController extends IrisBaseController {

	@Resource(name="messageSourceAccessor")
	private MessageSourceAccessor messageSourceAccessor;

	static final Logger LOGGER = LogManager.getLogger(TclgInfoReqController.class);
	
	@Resource(name="tclgInfoReqService")
	private TclgInfoReqService tclgInfoReqService;
	
	
	/**
	 * 기술정보요청 리스트 화면 이동
	 */
	@RequestMapping(value="/prj/tclgInfo/retrieveTclgInfoReq.do")
	public String retrieveTclgInfoReq(
			@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
		
			/* 반드시 공통 호출 후 작업 */
			checkSessionObjRUI(input, session, model);
			LOGGER.debug("########################################################################################");
			LOGGER.debug("TclgInfoReqService - retrieveTclgInfoReq [기술정보 요청서 리스트로  화면이동]");
			LOGGER.debug("########################################################################################");	
			
			HashMap<String, Object> prjInfo = tclgInfoReqService.retrievePrjInfo(input);
		
			if( input.get("_roleId").toString().indexOf("WORK_IRI_T01") > -1 || input.get("_roleId").toString().indexOf("WORK_IRI_T03") > -1){
				input.put("prjCd", "");
				input.put("prjNm", "");
				input.put("deptCd", "");
				input.put("wbsCd", "");
			}else{
				input.put("prjCd", prjInfo.get("prjCd"));
				input.put("prjNm", prjInfo.get("prjNm"));
				input.put("deptCd", prjInfo.get("deptCd"));
				input.put("wbsCd", prjInfo.get("wbsCd"));
			}
			
			model.addAttribute("inputData", input);
		
		return "web/prj/tclgInfo/tclgInfoReqList";
	}
	
	/**
     * Project > 기술정보 > 기술정보요청 목록 조회
     * */
	@RequestMapping(value="/prj/tclgInfo/retrieveTclgInfoRqSearchList.do")
	public ModelAndView retrieveTclgInfoRqSearchList(
			@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpServletResponse response,
			HttpSession session,
			ModelMap model
			){

		/*반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		ModelAndView modelAndView = new ModelAndView("ruiView");
		
		input = StringUtil.toUtf8(input);
		
		LOGGER.debug("##############################################################################################");
		LOGGER.debug("TclgInfoReqService - retrieveTclgInfoRqSearchList [기술정보요청 목록 조회");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("##############################################################################################");

		List<Map<String,Object>> list = tclgInfoReqService.retrieveTclgInfoRqSearchList(input);
        
		modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", list));

		return modelAndView;
	}
	
	
	/**
	 * Project > 기술정보 > 기술정보요청 등록 팝업창 이동
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/prj/tclgInfo/tclgInfoReqPop.do")
	public String tclgInfoReqPop(
			@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
		
			/* 반드시 공통 호출 후 작업 */
			checkSessionObjRUI(input, session, model);
			LOGGER.debug("########################################################################################");
			LOGGER.debug("TclgInfoReqService - tclgInfoReqPop [기술정보 요청서 등록팝업  화면이동]");
			LOGGER.debug("########################################################################################");	
			
			HashMap<String, Object> prjInfo = tclgInfoReqService.retrievePrjInfo(input);

			input.put("prjCd", StringUtil.isNullGetInput((String)prjInfo.get("prjCd"), ""));
			input.put("prjNm", StringUtil.isNullGetInput((String)prjInfo.get("prjNm"), ""));
			input.put("deptCd", StringUtil.isNullGetInput((String)prjInfo.get("deptCd"), ""));
			input.put("wbsCd", StringUtil.isNullGetInput((String)prjInfo.get("wbsCd"), ""));
			input.put("rgstNm", input.get("_userNm"));
			input.put("rgstNo", input.get("_userSabun"));
		
			model.addAttribute("inputData", input);
		
		return "web/prj/tclgInfo/tclgInfoReqPop";
	}
	
	
	
	/**
     * Project > 기술정보 > 기술정보요청 등록
     * */
	@RequestMapping(value="/prj/tclgInfo/insertTclgInfoReq.do")
	public ModelAndView insertTclgInfoReq(
			@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpServletResponse response,
			HttpSession session,
			ModelMap model
			){

		/*반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		ModelAndView modelAndView = new ModelAndView("ruiView");
		HashMap<String, Object> rtnMeaasge = new HashMap<String, Object>();
		
		input = StringUtil.toUtf8(input);
		
		LOGGER.debug("##############################################################################################");
		LOGGER.debug("TclgInfoReqService - insertTclgInfoReq [기술정보요청 등록");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("##############################################################################################");

		String rtnSt ="F";
		String rtnMsg = "";
		
		try{
			tclgInfoReqService.insertTclgInfoReq(input);
			
			rtnMsg = "등록되었습니다.";
			rtnSt = "S";
		}catch(Exception e){
			rtnMsg = "등록 중 오류가 발생하였습니다.";
		}
       
		rtnMeaasge.put("rtnMsg", rtnMsg);
		rtnMeaasge.put("rtnSt", rtnSt);
		
		modelAndView.addObject("resultDataSet", RuiConverter.createDataset("resultDataSet", rtnMeaasge));

		return modelAndView;
	}

	/**
	 * Project > 기술정보 > 기술정보요청 상세 팝업창 이동
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/prj/tclgInfo/tclgInfoDetailPop.do")
	public String tclgInfoDetailPop(
			@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
		
			/* 반드시 공통 호출 후 작업 */
			checkSessionObjRUI(input, session, model);
			LOGGER.debug("########################################################################################");
			LOGGER.debug("TclgInfoReqService - tclgInfoDetailPop [기술정보 요청서 상세팝업  화면이동]");
			LOGGER.debug("########################################################################################");	
		
			model.addAttribute("inputData", input);
		
		return "web/prj/tclgInfo/tclgInfoDetailPop";
	}
	
	
	/**
     * Project > 기술정보 > 기술정보요청 상세 조회
     * */
	@RequestMapping(value="/prj/tclgInfo/retrieveTclgInfoDetail.do")
	public ModelAndView retrieveTclgInfoDetail(
			@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpServletResponse response,
			HttpSession session,
			ModelMap model
			){

		/*반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		ModelAndView modelAndView = new ModelAndView("ruiView");
		
		input = StringUtil.toUtf8(input);
		
		LOGGER.debug("##############################################################################################");
		LOGGER.debug("TclgInfoReqService - retrieveTclgInfoDetail [기술정보요청 상세 조회");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("##############################################################################################");

		Map<String,Object> tclgInfo = tclgInfoReqService.retrieveTclgInfoDetail(input);
        
		modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", tclgInfo));

		return modelAndView;
	}
	
	
	
	
}
