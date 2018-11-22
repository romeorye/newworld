package iris.web.rlab.tmgt.controller;

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
import iris.web.common.util.StringUtil;
import iris.web.rlab.tmgt.service.RlabTeamGateService;
import iris.web.common.code.service.CodeCacheManager;
import iris.web.system.base.IrisBaseController;


@Controller
public class RlabTeamGateController extends IrisBaseController {

	@Resource(name = "codeCacheManager")
	private CodeCacheManager codeCacheManager;

	@Resource(name="messageSourceAccessor")
	private MessageSourceAccessor messageSourceAccessor;

	@Resource(name = "rlabTeamGateService")
	private RlabTeamGateService rlabTeamGateService;

	@Resource(name = "configService")
    private ConfigService configService;

	static final Logger LOGGER = LogManager.getLogger(RlabTeamGateController.class);


	/**
	 *  신뢰성시험 > team gate 화면 이동
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/rlab/tmgt/rlabTeamGate.do")
	public String rlabTeamGate(@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){

		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		input = StringUtil.toUtf8(input);
        model.addAttribute("inputData", input);

		return  "web/rlab/tmgt/rlabTeamGateList";
	}

	/**
	 *  신뢰성시험 > team gate 조회
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/rlab/tmgt/rlabTeamGateList.do")
	public ModelAndView rlabTeamGateList(@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		ModelAndView modelAndView = new ModelAndView("ruiView");
		input = StringUtil.toUtf8(input);

        List<Map<String, Object>> resultList = rlabTeamGateService.rlabTeamGateList(input);
		modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", resultList));

		return  modelAndView;
	}

	/**
	 *  team gate 등록 화면
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/rlab/tmgt/rlabTeamGateReg.do")
	public String rlabTeamGateReg(@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){

		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		input = StringUtil.toUtf8(input);
        model.addAttribute("inputData", input);

		return  "web/rlab/tmgt/rlabTeamGateReg";
	}

	/**
	 *  team gate 평가 화면(평가자)
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/rlab/tmgt/rlabTeamGateEv.do")
	public String rlabTeamGateEv(@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){

		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		input = StringUtil.toUtf8(input);
        model.addAttribute("inputData", input);

		return  "web/rlab/tmgt/rlabTeamGateEv";
	}

	/**
	 *  team gate 평가 화면(등록자)
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/rlab/tmgt/rlabTeamGateRegEv.do")
	public String rlabTeamGateRegEv(@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){

		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		input = StringUtil.toUtf8(input);
        model.addAttribute("inputData", input);

		return  "web/rlab/tmgt/rlabTeamGateRegEv";
	}

	/**
	 *  team gate 평가 완료
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/rlab/tmgt/rlabTeamGateCmpl.do")
	public String rlabTeamGateCmpl(@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){

		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		input = StringUtil.toUtf8(input);
        model.addAttribute("inputData", input);

		return  "web/rlab/tmgt/rlabTeamGateCmpl";
	}

	/**
	 *  team gate 상세 조회
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/rlab/tmgt/rlabTeamGateDtl.do")
	public ModelAndView retrieveSpaceEvToolSearchDtl(@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		input = StringUtil.toUtf8(input);
		ModelAndView modelAndView = new ModelAndView("ruiView");
		if(NullUtil.isNull(input.get("_userId")) ||  NullUtil.nvl(input.get("_userId"), "").equals("-1")  ){
			String rtnMsg = messageSourceAccessor.getMessage("msg.alert.sessionTimeout");
			SayMessage.setMessage(rtnMsg);
			modelAndView.addObject("dataset", null);
        } else {
        	HashMap<String, Object> result = rlabTeamGateService.rlabTeamGateDtl(input);
        	model.addAttribute("result", result);
			modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", result));
        }

		return  modelAndView;
	}

	/**
	 *  team gate 결과상세 조회
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/rlab/tmgt/rlabTeamGateCmplDtl.do")
	public ModelAndView rlabTeamGateCmplDtl(@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		input = StringUtil.toUtf8(input);
		ModelAndView modelAndView = new ModelAndView("ruiView");
		if(NullUtil.isNull(input.get("_userId")) ||  NullUtil.nvl(input.get("_userId"), "").equals("-1")  ){
			String rtnMsg = messageSourceAccessor.getMessage("msg.alert.sessionTimeout");
			SayMessage.setMessage(rtnMsg);
			modelAndView.addObject("dataset", null);
        } else {
        	HashMap<String, Object> result = rlabTeamGateService.rlabTeamGateCmplDtl(input);
        	model.addAttribute("result", result);
			modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", result));
        }

		return  modelAndView;
	}

	/**
	 *  team gate 등록
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/rlab/tmgt/saveRlabTeamGate.do")
	public ModelAndView saveRlabTeamGate(@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		ModelAndView modelAndView = new ModelAndView("ruiView");
		HashMap<String, Object> rtnMeaasge = new HashMap<String, Object>();

		String rtnSt ="F";
		String rtnMsg = "";

		try{

			rlabTeamGateService.saveRlabTeamGate(input);

            rtnMsg = "저장되었습니다.";
        	rtnSt= "S";

    	}catch(Exception e){
			e.printStackTrace();
			if("".equals(rtnMsg)){
				rtnMsg = "처리중 오류가발생했습니다. 관리자에게 문의해주십시오.";
			}
    	}

       	rtnMeaasge.put("rtnMsg", rtnMsg);
		rtnMeaasge.put("rtnSt", rtnSt);
		modelAndView.addObject("resultDataSet", RuiConverter.createDataset("resultDataSet", rtnMeaasge));
		modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", input));

		return  modelAndView;
	}

	/**
	 *  tema gate 평가 임시저장
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/rlab/tmgt/saveTempRlabTeamGateEv.do")
	public ModelAndView saveTempRlabTeamGateEv(@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		ModelAndView modelAndView = new ModelAndView("ruiView");
		HashMap<String, Object> rtnMeaasge = new HashMap<String, Object>();

		String rtnSt ="F";
		String rtnMsg = "";

		try{

			rlabTeamGateService.saveTempRlabTeamGateEv(input);

            rtnMsg = "저장되었습니다.";
        	rtnSt= "S";

    	}catch(Exception e){
			e.printStackTrace();
			if("".equals(rtnMsg)){
				rtnMsg = "처리중 오류가발생했습니다. 관리자에게 문의해주십시오.";
			}
    	}

       	rtnMeaasge.put("rtnMsg", rtnMsg);
		rtnMeaasge.put("rtnSt", rtnSt);
		modelAndView.addObject("resultDataSet", RuiConverter.createDataset("resultDataSet", rtnMeaasge));
		modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", input));

		return  modelAndView;
	}

	/**
	 *  tema gate 평가 저장
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/rlab/tmgt/saveRlabTeamGateEv.do")
	public ModelAndView saveRlabTeamGateEv(@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		ModelAndView modelAndView = new ModelAndView("ruiView");
		HashMap<String, Object> rtnMeaasge = new HashMap<String, Object>();

		String rtnSt ="F";
		String rtnMsg = "";

		try{

			rlabTeamGateService.saveRlabTeamGateEv(input);

            rtnMsg = "저장되었습니다.";
        	rtnSt= "S";

    	}catch(Exception e){
			e.printStackTrace();
			if("".equals(rtnMsg)){
				rtnMsg = "처리중 오류가발생했습니다. 관리자에게 문의해주십시오.";
			}
    	}

       	rtnMeaasge.put("rtnMsg", rtnMsg);
		rtnMeaasge.put("rtnSt", rtnSt);
		modelAndView.addObject("resultDataSet", RuiConverter.createDataset("resultDataSet", rtnMeaasge));
		modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", input));

		return  modelAndView;
	}

	/**
	 *  tema gate 투표완료
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/rlab/tmgt/saveRlabTeamGateEvCmpl.do")
	public ModelAndView saveRlabTeamGateEvCmpl(@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		ModelAndView modelAndView = new ModelAndView("ruiView");
		HashMap<String, Object> rtnMeaasge = new HashMap<String, Object>();

		String rtnSt ="F";
		String rtnMsg = "";

		try{

			rlabTeamGateService.saveRlabTeamGateEvCmpl(input);

            rtnMsg = "저장되었습니다.";
        	rtnSt= "S";

    	}catch(Exception e){
			e.printStackTrace();
			if("".equals(rtnMsg)){
				rtnMsg = "처리중 오류가발생했습니다. 관리자에게 문의해주십시오.";
			}
    	}

       	rtnMeaasge.put("rtnMsg", rtnMsg);
		rtnMeaasge.put("rtnSt", rtnSt);
		modelAndView.addObject("resultDataSet", RuiConverter.createDataset("resultDataSet", rtnMeaasge));
		modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", input));

		return  modelAndView;
	}

	/**
	 *  tema gate 투표수정
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/rlab/tmgt/saveRlabTeamGateEvReg.do")
	public ModelAndView saveRlabTeamGateEvReg(@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		ModelAndView modelAndView = new ModelAndView("ruiView");
		HashMap<String, Object> rtnMeaasge = new HashMap<String, Object>();

		String rtnSt ="F";
		String rtnMsg = "";

		try{

			rlabTeamGateService.saveRlabTeamGateEvReg(input);

            rtnMsg = "저장되었습니다.";
        	rtnSt= "S";

    	}catch(Exception e){
			e.printStackTrace();
			if("".equals(rtnMsg)){
				rtnMsg = "처리중 오류가발생했습니다. 관리자에게 문의해주십시오.";
			}
    	}

       	rtnMeaasge.put("rtnMsg", rtnMsg);
		rtnMeaasge.put("rtnSt", rtnSt);
		modelAndView.addObject("resultDataSet", RuiConverter.createDataset("resultDataSet", rtnMeaasge));
		modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", input));

		return  modelAndView;
	}

	/**
	 *  tema gate 투표삭제
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/rlab/tmgt/delRlabTeamGateEvReg.do")
	public ModelAndView delRlabTeamGateEvReg(@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		ModelAndView modelAndView = new ModelAndView("ruiView");
		HashMap<String, Object> rtnMeaasge = new HashMap<String, Object>();

		String rtnSt ="F";
		String rtnMsg = "";

		try{

			rlabTeamGateService.delRlabTeamGateEvReg(input);

            rtnMsg = "저장되었습니다.";
        	rtnSt= "S";

    	}catch(Exception e){
			e.printStackTrace();
			if("".equals(rtnMsg)){
				rtnMsg = "처리중 오류가발생했습니다. 관리자에게 문의해주십시오.";
			}
    	}

       	rtnMeaasge.put("rtnMsg", rtnMsg);
		rtnMeaasge.put("rtnSt", rtnSt);
		modelAndView.addObject("resultDataSet", RuiConverter.createDataset("resultDataSet", rtnMeaasge));
		modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", input));

		return  modelAndView;
	}

}
