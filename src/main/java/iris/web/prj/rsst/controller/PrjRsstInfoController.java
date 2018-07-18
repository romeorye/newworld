package iris.web.prj.rsst.controller;

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
import iris.web.fxa.fxaInfo.service.FxaInfoService;
import iris.web.system.attach.service.AttachFileService;
import iris.web.system.base.IrisBaseController;

/********************************************************************************
 * NAME : PrjRsstInfoController.java
 * DESC : 프로젝트 - 연구팀(Project) controller
 * PROJ : IRIS 구축 프로젝트
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION
 * ----------  ------  ---------------------------------------------------------
 * 2017.08.31  IRIS04	최초생성
 *********************************************************************************/

@Controller
public class PrjRsstInfoController extends IrisBaseController {

	@Resource(name="messageSourceAccessor")
	private MessageSourceAccessor messageSourceAccessor;

	/** 고정자산 서비스 **/
	@Resource(name = "fxaInfoService")
	private FxaInfoService fxaInfoService;

	/** 첨부파일서비스 **/
	@Resource(name = "attachFileService")
	private AttachFileService attachFileService;

	static final Logger LOGGER = LogManager.getLogger(PrjRsstInfoController.class);

	/** 연구팀 > 현황 > 프로젝트등록 > 고정자산 탭 화면이동 **/
	@RequestMapping(value="/prj/rsst/retrievePrjFxaInfo.do")
	public String retrievePrjFxaInfoView(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
		LOGGER.debug("####################################################################################################");
		LOGGER.debug("PrjRsstInfoController - retrievePrjFxaInfoView [연구팀 > 현황 > 프로젝트등록 > 고정자산 탭 화면이동]");
		LOGGER.debug("####################################################################################################");

		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);
		if(NullUtil.isNull(input.get("_userId")) ||  NullUtil.nvl(input.get("_userId"), "").equals("-1")  ){
			String rtnMsg = messageSourceAccessor.getMessage("msg.alert.sessionTimeout");
			SayMessage.setMessage(rtnMsg);
        } else {
	        model.addAttribute("inputData", input);
        }

		return "web/prj/rsst/prjRsstFxaList";
	}

	/** 고정자산 목록 조회 **/
	@RequestMapping(value="/prj/rsst/retrievePrjFxaSearchInfo.do")
	public ModelAndView retrievePrjFxaSearchInfo(
			@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpServletResponse response,
			HttpSession session,
			ModelMap model
			){
		LOGGER.debug("########################################################################");
		LOGGER.debug("PrjRsstInfoController - retrieveMmByMonthSearchInfo [고정자산 목록 조회]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("########################################################################");

		checkSessionObjRUI(input, session, model);
		ModelAndView modelAndView = new ModelAndView("ruiView");

        List<Map<String,Object>> list = fxaInfoService.retrievePrjFxaSearchInfo(input);
		modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", list));

		//LOGGER.debug("###########################################################");
		//LOGGER.debug("modelAndView => " + modelAndView);
		//LOGGER.debug("###########################################################");

		return modelAndView;
	}

	/** 연구팀 > 현황 > 프로젝트등록 > 고정자산 상세팝업 화면이동 **/
	@RequestMapping(value="/prj/rsst/retrieveFxaDtlInfo.do")
	public String retrievePrjFxaDtlInfoView(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
		LOGGER.debug("##########################################################################################################");
		LOGGER.debug("PrjRsstInfoController - retrievePrjFxaInfoView [연구팀 > 현황 > 프로젝트등록 > 고정자산 상세팝업 화면이동]");
		LOGGER.debug("INPUT : "+input);
		LOGGER.debug("##########################################################################################################");

		//반드시 공통 호출 후 작업
		checkSession(input, session, model);
		if(NullUtil.isNull(input.get("_userId")) ||  NullUtil.nvl(input.get("_userId"), "").equals("-1")  ){
			String rtnMsg = messageSourceAccessor.getMessage("msg.alert.sessionTimeout");
			SayMessage.setMessage(rtnMsg);
        } else {
	        model.addAttribute("inputData", input);
        }

		return "web/prj/rsst/fxaDtlPopup";
	}

	/** 고정자산 상세 조회 **/
	@RequestMapping(value="/prj/rsst/retrieveFxaDtlSearchInfo.do")
	public ModelAndView retrievePrjFxaDtlSearchInfo(
			@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpServletResponse response,
			HttpSession session,
			ModelMap model
			){
		LOGGER.debug("########################################################################");
		LOGGER.debug("PrjRsstInfoController - retrieveMmByMonthSearchInfo [고정자산 상세 조회]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("########################################################################");

		checkSessionObjRUI(input, session, model);
		ModelAndView modelAndView = new ModelAndView("ruiView");

        Map<String,Object> resultMap = fxaInfoService.retrieveFxaDtlSearchInfo(input);
		modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", resultMap));

		//LOGGER.debug("###########################################################");
		//LOGGER.debug("modelAndView => " + modelAndView);
		//LOGGER.debug("###########################################################");

		return modelAndView;
	}

}// end class
