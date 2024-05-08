package iris.web.fxa.trsf.controller;

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
import iris.web.common.itgRdcs.service.ItgRdcsService;
import iris.web.common.util.StringUtil;
import iris.web.fxa.trsf.service.FxaTrsfService;
import iris.web.system.base.IrisBaseController;

@Controller
public class FxaTrsfController extends IrisBaseController {
	@Resource(name="messageSourceAccessor")
	private MessageSourceAccessor messageSourceAccessor;

	@Resource(name = "fxaTrsfService")
	private FxaTrsfService fxaTrsfService;
/*
	@Resource(name = "sapBudgCostService")
	private SapBudgCostService sapBudgCostService;
	*/
	@Resource(name = "itgRdcsService")
	private ItgRdcsService itgRdcsService;

	static final Logger LOGGER = LogManager.getLogger(FxaTrsfController.class);

	/**
	 * 자산이관 목록 화면
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/fxa/trsf/retrieveFxaTrsfList.do")
	public String retrieveFxaTrsfList(@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){

		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		input = StringUtil.toUtf8(input);
		LOGGER.debug("####################input################################################################# : " + input);

		model.addAttribute("inputData", input);

		return  "web/fxa/trsf/fxaInfoTrsfList";
	}

	/**
	 *  자산이관 목록 조회
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/fxa/trsf/retrieveFxaTrsfSearchList.do")
	public ModelAndView retrieveFxaTrsfSearchList(@RequestParam HashMap<String, Object> input,
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

        	List<Map<String, Object>> resultList = fxaTrsfService.retrieveFxaTrsfSearchList(input);
			modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", resultList));
        }
		return  modelAndView;
	}


	/**
	 * 자산관리 > 이관 정보 저장
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/fxa/trsf/insertFxaTrsfInfo.do")
	public ModelAndView insertFxaTrsfInfo(@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			) throws Exception{

		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		ModelAndView modelAndView = new ModelAndView("ruiView");
		HashMap<String, Object> rtnMeaasge = new HashMap<String, Object>();
		
		List<Map<String, Object>> trsfList = null;
		String rtnMsg = "";
		String rtnSt = "F";
		String guid ="";
		
		try{
			//LOGGER.debug("input===================================="+input);
			//이관데이터 저장
			trsfList = RuiConverter.convertToDataSet(request, "dataSet");
			guid = fxaTrsfService.insertFxaTrsfInfo(trsfList, input);

			rtnSt = "S";
			rtnMsg = "이관신청되었습니다.";
		}catch(Exception e){
			e.printStackTrace();
			rtnMsg = "처리중 오류가 발생헀습니다. 관리자에게 문의해주십시오.";
		}

		rtnMeaasge.put("rtnMsg", rtnMsg);
		rtnMeaasge.put("rtnSt", rtnSt);
		rtnMeaasge.put("guid", guid);
		modelAndView.addObject("resultDataSet", RuiConverter.createDataset("resultDataSet", rtnMeaasge));

		return  modelAndView;
	}


	/**
	 *  자산이관 팝업목록 조회
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/fxa/trsf/retrieveFxaTrsfPopList.do")
	public ModelAndView retrieveFxaTrsfPopList(@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){

		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		ModelAndView modelAndView = new ModelAndView("ruiView");
		input = StringUtil.toUtf8Input(input);

		
		List<Map<String, Object>> resultList = fxaTrsfService.retrieveFxaTrsfPopList(input);
		modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", resultList));
		
		return  modelAndView;
	}
	
}
