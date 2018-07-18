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
import iris.web.prj.rsst.service.PrjTrwiBudgInfoService;
import iris.web.system.base.IrisBaseController;

/********************************************************************************
 * NAME : PrjTrwiBudgInfoController.java
 * DESC : 프로젝트 - 연구팀(Project) - 비용&예산(Trwi_Budg) controller
 * PROJ : IRIS 구축 프로젝트
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION
 * ----------  ------  ---------------------------------------------------------
 * 2017.08.28  IRIS04	최초생성
 *********************************************************************************/

@Controller
public class PrjTrwiBudgInfoController extends IrisBaseController {

	@Resource(name="messageSourceAccessor")
	private MessageSourceAccessor messageSourceAccessor;

	@Resource(name = "prjTrwiBudgInfoService")
	private PrjTrwiBudgInfoService prjTrwiBudgInfoService;

	static final Logger LOGGER = LogManager.getLogger(PrjTrwiBudgInfoController.class);

	/** 비용/예산 탭 화면이동 **/
	@RequestMapping(value="/prj/rsst/trwiBudg/retrievePrjTrwiBudgInfo.do")
	public String retrievePrjTrwiBudgInfoView(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
		LOGGER.debug("###############################################################################################");
		LOGGER.debug("PrjTrwiBudgInfoController - retrievePrjTrwiBudgInfoView [프로젝트 등록 > 비용/예산 탭 화면이동]");
		LOGGER.debug("###############################################################################################");

		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);
		if(NullUtil.isNull(input.get("_userId")) ||  NullUtil.nvl(input.get("_userId"), "").equals("-1")  ){
			String rtnMsg = messageSourceAccessor.getMessage("msg.alert.sessionTimeout");
			SayMessage.setMessage(rtnMsg);
        } else {
	        model.addAttribute("inputData", input);
        }

		return "web/prj/rsst/prjTrwiBudgList";
	}

	/** 비용/예산 1년 통계 조회 **/
	@RequestMapping(value="/prj/rsst/trwiBudg/retrievePrjTrwiBudgSearchInfo.do")
	public ModelAndView retrievePrjTrwiBudgSearchInfo(
			@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpServletResponse response,
			HttpSession session,
			ModelMap model
			){
		LOGGER.debug("###################################################################################################");
		LOGGER.debug("PrjTrwiBudgInfoController - retrievePrjTrwiBudgSearchInfo [프로젝트 등록 > 비용/예산 1년 통계 조회]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###################################################################################################");

		/*반드시 공통 호출 후 작업 */
		//checkSessionObjRUI(input, session, model);
		ModelAndView modelAndView = new ModelAndView("ruiView");

        List<Map<String,Object>> list = prjTrwiBudgInfoService.retrievePrjTrwiBudgSearchInfo(input);
		modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", list));

		return modelAndView;
	}

}// end class
