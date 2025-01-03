package iris.web.stat.space.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import iris.web.common.converter.RuiConverter;
import iris.web.common.util.DateUtil;
import iris.web.stat.space.service.SpaceStatService;

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

import iris.web.system.base.IrisBaseController;

@Controller
public class SpaceStatController extends IrisBaseController {

	@Resource(name = "messageSourceAccessor")
	private MessageSourceAccessor messageSourceAccessor;

	@Resource(name = "spaceStatService")
	private SpaceStatService spaceStatService;

	static final Logger LOGGER = LogManager
			.getLogger(SpaceStatController.class);

	/**
	 * 통계 > 공간성능평가 > 평가업무현황 화면
	 * */
	@RequestMapping(value = "/stat/space/spaceEvAffrStts.do")
	public String spaceEvAffrStts(@RequestParam HashMap<String, Object> input,
			HttpServletRequest request, HttpSession session, ModelMap model) {

		LOGGER.debug("###########################################################");
		LOGGER.debug("prjState [통계 > 공간성능평가 > 평가업무현황 화면]");
		LOGGER.debug("###########################################################");

		checkSessionObjRUI(input, session, model);
		model.addAttribute("inputData", input);

		return "web/stat/space/spaceEvAffrStts";
	}

	/**
	 * 통계 > 공간성능평가 > 사업부별통계 화면
	 * */
	@RequestMapping(value = "/stat/space/spaceCrgrStat.do")
	public String spaceCrgrStat(@RequestParam HashMap<String, Object> input,
			HttpServletRequest request, HttpSession session, ModelMap model) {

		LOGGER.debug("###########################################################");
		LOGGER.debug("prjState [통계 > 공간성능평가 > 사업부별통계 화면]");
		LOGGER.debug("###########################################################");

		checkSessionObjRUI(input, session, model);

		model.addAttribute("inputData", input);

		return "web/stat/space/spaceCrgrStat";
	}

	/**
	 * 통계 > 공간성능평가 > 담당자별통계 화면
	 * */
	@RequestMapping(value = "/stat/space/spaceBzdvStat.do")
	public String spaceBzdvStat(@RequestParam HashMap<String, Object> input,
			HttpServletRequest request, HttpSession session, ModelMap model) {

		LOGGER.debug("###########################################################");
		LOGGER.debug("prjState [통계 > 공간성능평가 > 담당자별통계 화면]");
		LOGGER.debug("###########################################################");

		checkSessionObjRUI(input, session, model);

		String today = DateUtil.getDateString();

		input.put("fromCmplDt", today.substring(0, 7));
		input.put("toCmplDt", today.substring(0, 7));

		model.addAttribute("inputData", input);

		return "web/stat/space/spaceBzdvStat";
	}

	/**
	 * 통계 > 공간성능평가 > 분석목적별통계 화면
	 * */
	@RequestMapping(value = "/stat/space/spaceAnlStat.do")
	public String spaceAnlStat(@RequestParam HashMap<String, Object> input,
			HttpServletRequest request, HttpSession session, ModelMap model) {

		LOGGER.debug("###########################################################");
		LOGGER.debug("prjState [통계 > 공간성능평가 > 분석목적별통계 화면]");
		LOGGER.debug("###########################################################");

		checkSessionObjRUI(input, session, model);

		model.addAttribute("inputData", input);

		return "web/stat/space/spaceAnlStat";
	}

	/**
	 * 통계 > 공간성능평가 > 분석방법별통계 화면
	 * */
	@RequestMapping(value = "/stat/space/spaceAnlWayStat.do")
	public String spaceAnlWayStat(@RequestParam HashMap<String, Object> input,
			HttpServletRequest request, HttpSession session, ModelMap model) {

		LOGGER.debug("###########################################################");
		LOGGER.debug("prjState [통계 > 공간성능평가 > 분석방법별통계 화면]");
		LOGGER.debug("###########################################################");

		checkSessionObjRUI(input, session, model);

		model.addAttribute("inputData", input);

		return "web/stat/space/spaceAnlWayStat";
	}

	/**
	 * 통계 > 공간성능평가 > 연도조회 조회
	 * */
	@RequestMapping(value = "/stat/space/retrieveSpaceYyList.do")
	public ModelAndView retrieveSpaceYyList(
			@RequestParam HashMap<String, Object> input,
			HttpServletRequest request, HttpServletResponse response,
			HttpSession session, ModelMap model) {

		LOGGER.debug("###########################################################");
		LOGGER.debug("retrieveRlabYyList [통계 > 공간성능평가 > 연도 조회]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		checkSessionObjRUI(input, session, model);
		ModelAndView modelAndView = new ModelAndView("ruiView");

		List<Map<String, Object>> list = spaceStatService.retrieveSpaceYyList(input);

		modelAndView.addObject("dataSet",RuiConverter.createDataset("dataSet", list));

		return modelAndView;
	}

	/**
	 * 통계 > 공간성능평가 > 담당자별통계 조회
	 * */
	@RequestMapping(value = "/stat/space/getSpaceBzdvStatList.do")
	public ModelAndView getSpaceBzdvStatList(
			@RequestParam HashMap<String, Object> input,
			HttpServletRequest request, HttpServletResponse response,
			HttpSession session, ModelMap model) {

		LOGGER.debug("###########################################################");
		LOGGER.debug("getSpaceBzdvStatList [통계 > 공간성능평가 > 담당자별통계 조회]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		checkSessionObjRUI(input, session, model);
		ModelAndView modelAndView = new ModelAndView("ruiView");

		List<Map<String, Object>> list = spaceStatService.getSpaceBzdvStatList(input);

		modelAndView.addObject("dataSet",RuiConverter.createDataset("dataSet", list));

		return modelAndView;
	}

	/**
		* 통계 > 공간성능평가 > 평가업무현황 조회
	 * */
	@RequestMapping(value = "/stat/space/getSpaceEvAffrSttsList.do")
	public ModelAndView getSpaceEvAffrSttsList(
			@RequestParam HashMap<String, Object> input,
			HttpServletRequest request, HttpServletResponse response,
			HttpSession session, ModelMap model) {

		LOGGER.debug("###########################################################");
		LOGGER.debug("getSpaceBzdvStatList [통계 > 공간성능평가 > 평가업무현황 조회]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		checkSessionObjRUI(input, session, model);
		ModelAndView modelAndView = new ModelAndView("ruiView");

		List<Map<String, Object>> list = spaceStatService.getSpaceEvAffrSttsList(input);

		modelAndView.addObject("dataSet",
		RuiConverter.createDataset("dataSet", list));

		return modelAndView;
	}

	/**
	* 통계 > 공간성능평가 > 분석목적별통계 조회
 * */
@RequestMapping(value = "/stat/space/getSpaceAnlStatList.do")
public ModelAndView getSpaceAnlStatList(
		@RequestParam HashMap<String, Object> input,
		HttpServletRequest request, HttpServletResponse response,
		HttpSession session, ModelMap model) {

	LOGGER.debug("###########################################################");
	LOGGER.debug("getSpaceAnlStatList [통계 > 공간성능평가 > 분석목적별통계 조회]");
	LOGGER.debug("input = > " + input);
	LOGGER.debug("###########################################################");

	checkSessionObjRUI(input, session, model);
	ModelAndView modelAndView = new ModelAndView("ruiView");

	List<Map<String, Object>> list = spaceStatService.getSpaceAnlStatList(input);

	modelAndView.addObject("dataSet",
	RuiConverter.createDataset("dataSet", list));

	return modelAndView;
	}

	/**
		* 통계 > 공간성능평가 > 사업부별통계 조회
	 * */
	@RequestMapping(value = "/stat/space/getSpaceCrgrStatList.do")
	public ModelAndView getSpaceCrgrStatList(
			@RequestParam HashMap<String, Object> input,
			HttpServletRequest request, HttpServletResponse response,
			HttpSession session, ModelMap model) {

		LOGGER.debug("###########################################################");
		LOGGER.debug("getSpaceAnlStatList [통계 > 공간성능평가 > 사업부별통계 조회]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		checkSessionObjRUI(input, session, model);
		ModelAndView modelAndView = new ModelAndView("ruiView");

		List<Map<String, Object>> list = spaceStatService.getSpaceCrgrStatList(input);

		modelAndView.addObject("dataSet",
		RuiConverter.createDataset("dataSet", list));

		return modelAndView;
		}

	/**
	* 통계 > 공간성능평가 > 분석방법별통계 조회
	* */
	@RequestMapping(value = "/stat/space/getSpaceAnlWayStatList.do")
	public ModelAndView getSpaceAnlWayStatList(
		@RequestParam HashMap<String, Object> input,
		HttpServletRequest request, HttpServletResponse response,
		HttpSession session, ModelMap model) {

	LOGGER.debug("###########################################################");
	LOGGER.debug("getSpaceAnlStatList [통계 > 공간성능평가 > 분석방법별통계 조회]");
	LOGGER.debug("input = > " + input);
	LOGGER.debug("###########################################################");

	checkSessionObjRUI(input, session, model);
	ModelAndView modelAndView = new ModelAndView("ruiView");

	List<Map<String, Object>> list = spaceStatService.getSpaceAnlWayStatList(input);

	modelAndView.addObject("dataSet",
	RuiConverter.createDataset("dataSet", list));

	return modelAndView;
	}
}
