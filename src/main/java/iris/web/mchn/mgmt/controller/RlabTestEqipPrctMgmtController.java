package iris.web.mchn.mgmt.controller;

import java.io.File;
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
import iris.web.common.util.CommonUtil;
import iris.web.common.util.NamoMime;
import iris.web.common.util.StringUtil;
import iris.web.mchn.mgmt.service.RlabTestEqipPrctMgmtService;
import iris.web.system.base.IrisBaseController;


@Controller
public class RlabTestEqipPrctMgmtController extends IrisBaseController {

	@Resource(name="messageSourceAccessor")
	private MessageSourceAccessor messageSourceAccessor;

	@Resource(name = "rlabTestEqipPrctMgmtService")
	private RlabTestEqipPrctMgmtService rlabTestEqipPrctMgmtService;

	@Resource(name = "configService")
    private ConfigService configService;

	static final Logger LOGGER = LogManager.getLogger(RlabTestEqipPrctMgmtController.class);


	/**
	 *  관리 >  화면 이동 > 신뢰성장비 예약관리
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/mchn/mgmt/retrieveRlabTestEqipPrctMgmtList.do")
	public String retrieveRlabTestEqipPrctMgmtList(@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){

		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		input = StringUtil.toUtf8(input);
        model.addAttribute("inputData", input);
        
		return  "web/mchn/mgmt/rlabTestEqipPrctMgmtList";
	}

	/**
	 *  관리 > 신뢰성장비 예약관리 조회
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/mchn/mgmt/rlabTestEqipPrctMgmtList.do")
	public ModelAndView RlabTestEqipPrctMgmtList(@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		ModelAndView modelAndView = new ModelAndView("ruiView");
		input = StringUtil.toUtf8(input);

        List<Map<String, Object>> resultList = rlabTestEqipPrctMgmtService.rlabTestEqipPrctMgmtList(input);
		modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", resultList));

		return  modelAndView;
	}
	
	/**
	 *  신뢰성장비 예약관리 상세(신뢰성시험)
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/mchn/mgmt/retrieveRlabTestEqipPrctDtl01.do")
	public String retrieveRlabTestEqipPrctDtl01(@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){

		//LOGGER.debug("session="+lsession);
		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		input = StringUtil.toUtf8(input);
		Map<String, Object> result = rlabTestEqipPrctMgmtService.retrieveRlabTestEqipPrctDtl(input);
		
		model.addAttribute("result", result);
		model.addAttribute("inputData", input);
		
		return  "web/mchn/mgmt/rlabTestEqipPrctMgmtDtlRlab";
	}

	/**
	 *  신뢰성장비 예약관리 상세(내후성시험)
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/mchn/mgmt/retrieveRlabTestEqipPrctDtl02.do")
	public String retrieveRlabTestEqipPrctDtl02(@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){

		//LOGGER.debug("session="+lsession);
		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		input = StringUtil.toUtf8(input);
		Map<String, Object> result = rlabTestEqipPrctMgmtService.retrieveRlabTestEqipPrctDtl(input);
		
		model.addAttribute("result", result);
		model.addAttribute("inputData", input);
		
		return  "web/mchn/mgmt/rlabTestEqipPrctMgmtDtlWp";
	}	
	
	/**
	 *  신뢰성장비 예약관리 상세(측정평가)
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/mchn/mgmt/retrieveRlabTestEqipPrctDtl03.do")
	public String retrieveRlabTestEqipPrctDtl03(@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){

		//LOGGER.debug("session="+lsession);
		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		input = StringUtil.toUtf8(input);
		Map<String, Object> result = rlabTestEqipPrctMgmtService.retrieveRlabTestEqipPrctDtl(input);
		
		model.addAttribute("result", result);
		model.addAttribute("inputData", input);
		
		return  "web/mchn/mgmt/rlabTestEqipPrctMgmtDtlMsev";
	}
	
	/**
	 *  신뢰성장비 예약관리 승인, 반려 업데이트
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/mchn/mgmt/updateRlabTestEqipPrctInfo.do")
	public ModelAndView updateRlabTestEqipPrctInfo(@RequestParam HashMap<String, Object> input,
			//MultipartFile file,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
		LOGGER.debug("###########################################################");
		LOGGER.debug("RlabTestEqipPrctMgmtController - updateRlabTestEqipPrctInfo [공간평가 평가법 관리화면 이동]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");
		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		ModelAndView modelAndView = new ModelAndView("ruiView");
		HashMap<String, Object> rtnMeaasge = new HashMap<String, Object>();
		
		String rtnMsg = "";
		String rtnSt = "F";
		String prctScnCd = input.get("prctScnCd").toString();

		try{
			rlabTestEqipPrctMgmtService.updateRlabTestEqipPrctInfo(input);
			
			if(prctScnCd.equals("APPR")){
				rtnMsg = "승인되었습니다.";
			}else{
				rtnMsg = "반려되었습니다.";
			}
	       	rtnSt = "Y";
		}catch(Exception e){
			e.printStackTrace();
			rtnMsg = "처리중 오류가발생했습니다. 담당자에게 문의해주세요";
		}
		
		rtnMeaasge.put("rtnMsg", rtnMsg);
		rtnMeaasge.put("rtnSt", rtnSt);
		modelAndView.addObject("resultDataSet", RuiConverter.createDataset("resultDataSet", rtnMeaasge));

		return  modelAndView;
	}
	
}
