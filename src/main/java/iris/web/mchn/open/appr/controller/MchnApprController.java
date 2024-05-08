package iris.web.mchn.open.appr.controller;

import java.util.ArrayList;
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

import devonframe.util.NullUtil;
import iris.web.common.converter.RuiConverter;
import iris.web.common.util.StringUtil;
import iris.web.mchn.mgmt.controller.AnlMchnController;
import iris.web.mchn.open.appr.service.MchnApprService;
import iris.web.system.base.IrisBaseController;

@Controller
public class MchnApprController extends IrisBaseController {

	@Resource(name = "mchnApprService")
	private MchnApprService mchnApprService;

	@Resource(name="messageSourceAccessor")
	private MessageSourceAccessor messageSourceAccessor;

	static final Logger LOGGER = LogManager.getLogger(AnlMchnController.class);


	/**
	 *  보유기기관리 목록 화면(예약)
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/mchn/open/appr/retrieveMachineApprList.do")
	public String retrieveMachineApprList(@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
		
		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		input = StringUtil.toUtf8(input);
		
		model.addAttribute("inputData", input);

		return  "web/mchn/open/appr/mchnApprList";
	}


	/**
	 *  분석기기 > open기기 > 보유기기관리 목록조회
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/mchn/open/appr/retrieveMchnApprSearchList.do")
	public ModelAndView retrieveMchnApprSearchList(@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		ModelAndView modelAndView = new ModelAndView("ruiView");
		input = StringUtil.toUtf8(input);

    	List<Map<String, Object>> resultList = mchnApprService.retrieveMchnApprSearchList(input);
		modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", resultList));

		return  modelAndView;
	}

	/**
	 *  보유기기관리상세 화면(예약)
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/mchn/open/appr/retrieveMchnApprDtl.do")
	public String retrieveMchnApprDtl(@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){

		//LOGGER.debug("session="+lsession);
		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		input = StringUtil.toUtf8(input);
		Map<String, Object> result = mchnApprService.retrieveMchnApprInfo(input);
		
		model.addAttribute("result", result);
		model.addAttribute("inputData", input);
		
		return  "web/mchn/open/appr/mchnApprDtl";
	}


	/**
	 *  보유기기관리 승인, 반려 업데이트
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/mchn/open/appr/updateMachineApprInfo.do")
	public ModelAndView updateMachineApprInfo(@RequestParam HashMap<String, Object> input,
			//MultipartFile file,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		ModelAndView modelAndView = new ModelAndView("ruiView");
		HashMap<String, Object> rtnMeaasge = new HashMap<String, Object>();
		
		String rtnMsg = "";
		String rtnSt = "F";
		String prctScnCd = input.get("prctScnCd").toString();

		try{
			mchnApprService.updateMachineApprInfo(input);
			
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
	
	
	/**
	 *  보유기기관리 승인, 반려 업데이트
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 * @throws Exception 
	 */
	@RequestMapping(value="/mchn/open/appr/updateMachineApprList.do")
	public ModelAndView updateMachineApprList(@RequestParam HashMap<String, Object> input,
			//MultipartFile file,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			) throws Exception{
		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		input = StringUtil.toUtf8Input(input);
		
		ModelAndView modelAndView = new ModelAndView("ruiView");
		HashMap<String, Object> rtnMeaasge = new HashMap<String, Object>();
		
		String rtnMsg = "";
		String rtnSt = "F";
		
		String[] mchnPrctIds = (NullUtil.nvl(input.get("mchnPrctIds"), "")).split(",");
		List<String> mchnPrctIdList = new ArrayList<>();

		for (String mchnPrctId : mchnPrctIds) {
			mchnPrctIdList.add(mchnPrctId);
		}

		input.put("mchnPrctIdList", mchnPrctIdList);
		
		try{
			mchnApprService.updateMachineApprList(input);
			
			rtnMsg = "승인되었습니다.";
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

