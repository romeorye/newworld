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
import iris.web.prj.rsst.service.PrjMmInfoService;
import iris.web.system.base.IrisBaseController;

/********************************************************************************
 * NAME : PrjMmInfoController.java
 * DESC : 프로젝트 - 연구팀(Project) - 투입M/M(mm) controller
 * PROJ : IRIS 구축 프로젝트
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION
 * ----------  ------  ---------------------------------------------------------
 * 2017.08.29  IRIS04	최초생성
 *********************************************************************************/

@Controller
public class PrjMmInfoController extends IrisBaseController {

	@Resource(name="messageSourceAccessor")
	private MessageSourceAccessor messageSourceAccessor;

	@Resource(name = "prjMmInfoService")
	private PrjMmInfoService prjMmInfoService;

	static final Logger LOGGER = LogManager.getLogger(PrjPtotPrptInfoController.class);

	/** 투입M/M 탭 화면이동 **/
	@RequestMapping(value="/prj/rsst/mm/retrievePrjMmInfo.do")
	public String retrievePrjMmInfoView(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){

		LOGGER.debug("########################################################################################");
		LOGGER.debug("PrjMmInfoController - retrievePrjMmInfoView [프로젝트 등록 > 투입M/M 탭 화면이동]");
		LOGGER.debug("########################################################################################");

		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);
		if(NullUtil.isNull(input.get("_userId")) ||  NullUtil.nvl(input.get("_userId"), "").equals("-1")  ){
			String rtnMsg = messageSourceAccessor.getMessage("msg.alert.sessionTimeout");
			SayMessage.setMessage(rtnMsg);
        } else {
	        model.addAttribute("inputData", input);
        }

		return "web/prj/rsst/prjMmList";
	}

	/** 투입M/M 월별 목록 조회 **/
	@RequestMapping(value="/prj/rsst/mm/retrieveMmByMonthSearchInfo.do")
	public ModelAndView retrieveMmByMonthSearchInfo(
			@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpServletResponse response,
			HttpSession session,
			ModelMap model
			){
		LOGGER.debug("##############################################################################################");
		LOGGER.debug("PrjMmInfoController - retrieveMmByMonthSearchInfo [프로젝트 등록 > 투입M/M 월별 목록 조회]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("##############################################################################################");

		/*반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		ModelAndView modelAndView = new ModelAndView("ruiView");

        List<Map<String,Object>> list = prjMmInfoService.retrieveMmByMonthSearchInfo(input);
		modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", list));

		LOGGER.debug("###########################################################");
		LOGGER.debug("modelAndView => " + modelAndView);
		LOGGER.debug("###########################################################");

		return modelAndView;
	}

	/** 투입M/M 년도별 목록 조회 **/
	@RequestMapping(value="/prj/rsst/mm/retrieveMmByYearSearchInfo.do")
	public ModelAndView retrieveMmByYearSearchInfo(
			@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpServletResponse response,
			HttpSession session,
			ModelMap model
			){

		LOGGER.debug("##############################################################################################");
		LOGGER.debug("PrjMmInfoController - retrievePrjRsstMboSearchInfo [프로젝트 등록 > 지적재산권 목록 조회]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("##############################################################################################");

		/*반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		ModelAndView modelAndView = new ModelAndView("ruiView");

        List<Map<String,Object>> list = prjMmInfoService.retrieveMmByYearSearchInfo(input);
		modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", list));

		LOGGER.debug("###########################################################");
		LOGGER.debug("modelAndView => " + modelAndView);
		LOGGER.debug("###########################################################");

		return modelAndView;
	}

}// end class
