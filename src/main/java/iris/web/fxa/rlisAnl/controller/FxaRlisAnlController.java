package iris.web.fxa.rlisAnl.controller;

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

import devonframe.message.saymessage.SayMessage;
import devonframe.util.NullUtil;
import iris.web.common.converter.RuiConverter;
import iris.web.common.util.StringUtil;
import iris.web.fxa.rlisAnl.service.FxaRlisAnlService;
import iris.web.system.base.IrisBaseController;

@Controller
public class FxaRlisAnlController extends IrisBaseController {

	@Resource(name="messageSourceAccessor")
	private MessageSourceAccessor messageSourceAccessor;

	@Resource(name = "fxaRlisAnlService")
	private FxaRlisAnlService fxaRlisAnlService;

	static final Logger LOGGER = LogManager.getLogger(FxaRlisAnlController.class);


	/**
	 * 자산실기간관리 목록 화면
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/fxa/rlisAnl/retrieveFxarlisAnlList.do")
	public String retrieveFxarlisAnlList(@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){

		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		input = StringUtil.toUtf8(input);
		LOGGER.debug("####################input################################################################# : " + input);

		model.addAttribute("inputData", input);

		return  "web/fxa/rlisAnl/fxaInfoRlisAnlList";
	}

	/**
	 * 자산실기간관리 목록 조회
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/fxa/rlisAnl/retrieveFxaRlisAnlSearchList.do")
	public ModelAndView retrieveFxaRlisAnlSearchList(@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){

		HashMap lsession = (HashMap)session.getAttribute("irisSession");

		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		ModelAndView modelAndView = new ModelAndView("ruiView");
		input = StringUtil.toUtf8(input);

		if(NullUtil.isNull(input.get("_userId")) ||  NullUtil.nvl(input.get("_userId"), "").equals("-1")  ){
			String rtnMsg = messageSourceAccessor.getMessage("msg.alert.sessionTimeout");
			SayMessage.setMessage(rtnMsg);
			modelAndView.addObject("dataset", null);
        } else {

        	List<Map<String, Object>> resultList = fxaRlisAnlService.retrieveFxaRlisAnlSearchList(input);
			modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", resultList));
        }
		return  modelAndView;
	}

	/**
	 * 자산실기간관리> 신규등록 팝업화면
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/fxa/rlisAnl/retrieveFxaRlisAnlPop.do")
	public String retrieveFxaRlisAnlPop(@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){

		/* 반드시 공통 호출 후 작업 */
		HashMap lsession = (HashMap)session.getAttribute("irisSession");
		//LOGGER.debug("#################################input#################################################### + " + input);

		model.addAttribute("inputData", input);

		return  "web/fxa/rlisAnl/fxaRlisAnlPop";
	}

	/**
	 * 자산실기간관리> 신규 팝업정보 조회
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/fxa/rlisAnl/retrieveFxaRlisAnlInfo.do")
	public ModelAndView retrieveFxaRlisAnlInfo(@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){

		/* 반드시 공통 호출 후 작업 */
		HashMap lsession = (HashMap)session.getAttribute("irisSession");
		ModelAndView modelAndView = new ModelAndView("ruiView");
		//LOGGER.debug("#################################input#################################################### + " + input);

		HashMap<String, Object> result = fxaRlisAnlService.retrieveFxaRlisAnlInfo(input);

		modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", result));

		return  modelAndView;
	}


	/**
	 * 자산실기간관리 신규등록
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/fxa/rlisAnl/saveFxaRlisAnlInfo.do")
	public ModelAndView saveFxaRlisAnlInfo(@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){

		HashMap lsession = (HashMap)session.getAttribute("irisSession");

		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		ModelAndView modelAndView = new ModelAndView("ruiView");
		HashMap<String, Object> rtnMeaasge = new HashMap<String, Object>();
		input = StringUtil.toUtf8(input);

		String rtnSt ="F";
		String rtnMsg = "";

		try{
			LOGGER.debug("#################################input#################################################### + " + input);
			//자산실사기간 관리 테이블 등록
			fxaRlisAnlService.saveFxaRlisAnlInfo(input);

			rtnMsg = "자산실사를 요청하였습니다.";
			rtnSt = "S";

		}catch(Exception e){
			e.printStackTrace();
			rtnMsg = "처리중 오류가 발생하였습니다. 관리자에게 문의해주십시오";
        }

		rtnMeaasge.put("rtnMsg", rtnMsg);
		rtnMeaasge.put("rtnSt", rtnSt);
		modelAndView.addObject("resultDataSet", RuiConverter.createDataset("resultDataSet", rtnMeaasge));

		return  modelAndView;
	}


}
