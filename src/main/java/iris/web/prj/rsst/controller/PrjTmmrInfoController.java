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

import devonframe.util.NullUtil;
import iris.web.common.converter.RuiConverter;
import iris.web.prj.rsst.service.PrjTmmrInfoService;
import iris.web.system.base.IrisBaseController;

/********************************************************************************
 * NAME : PrjTmmrInfoController.java
 * DESC : 프로젝트 - 연구팀(Project) - 팀원정보(Tmmr) controller
 * PROJ : IRIS 구축 프로젝트
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION
 * ----------  ------  ---------------------------------------------------------
 * 2017.08.25  IRIS04	최초생성
 *********************************************************************************/

@Controller
public class PrjTmmrInfoController extends IrisBaseController {

	@Resource(name="messageSourceAccessor")
	private MessageSourceAccessor messageSourceAccessor;

	@Resource(name = "prjTmmrInfoService")
	private PrjTmmrInfoService prjTmmrInfoService;

	static final Logger LOGGER = LogManager.getLogger(PrjTmmrInfoController.class);

	/** 팀원정보 탭 화면이동 **/
	@RequestMapping(value="/prj/rsst/tmmr/retrievePrjTmmrInfo.do")
	public String retrievePrjTmmrInfoView(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){

		LOGGER.debug("############################################################################################");
		LOGGER.debug("PrjTmmrInfoController - retrievePrjRsstMboInfoView [프로젝트 등록 > 팀원정보 탭 화면이동]");
		LOGGER.debug("############################################################################################");

		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);
		if(NullUtil.isNull(input.get("_userId")) ||  NullUtil.nvl(input.get("_userId"), "").equals("-1")  ){
			//String rtnMsg = messageSourceAccessor.getMessage("msg.alert.sessionTimeout");
			//SayMessage.setMessage(rtnMsg);
        } else {
	        model.addAttribute("inputData", input);
        }

		return "web/prj/rsst/prjTmmrList";
	}

	/** 팀원정보 목록 조회 **/
	@RequestMapping(value="/prj/rsst/tmmr/retrievePrjTmmrSearchInfo.do")
	public ModelAndView retrievePrjTmmrSearchInfo(
			@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpServletResponse response,
			HttpSession session,
			ModelMap model
			){

		LOGGER.debug("##############################################################################################");
		LOGGER.debug("PrjTmmrInfoController - retrievePrjPtotPrptSearchInfo [프로젝트 등록 > 팀원정보 목록 조회]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("##############################################################################################");

		checkSessionObjRUI(input, session, model);
		ModelAndView modelAndView = new ModelAndView("ruiView");
        List<Map<String,Object>> list = prjTmmrInfoService.retrievePrjTmmrSearchInfo(input);
		modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", list));

		return modelAndView;
	}
}// end class
