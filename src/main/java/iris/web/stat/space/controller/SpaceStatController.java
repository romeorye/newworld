package iris.web.stat.space.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import iris.web.common.converter.RuiConverter;
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

	@Resource(name="messageSourceAccessor")
    private MessageSourceAccessor messageSourceAccessor;

	@Resource(name="spaceStatService")
	private SpaceStatService spaceStatService;

	static final Logger LOGGER = LogManager.getLogger(SpaceStatController.class);


	/**
     * 통계 > 공간성능평가 > 평가업무현황 화면
     *
     * @param input HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return String
     * */
    @RequestMapping(value="/stat/space/spaceEvAffrStts.do")
    public String spaceEvAffrStts(@RequestParam HashMap<String, Object> input, HttpServletRequest request,
            HttpSession session, ModelMap model) {

    	LOGGER.debug("###########################################################");
        LOGGER.debug("prjState [통계 > 공간성능평가 > 평가업무현황 화면]");
        LOGGER.debug("###########################################################");

        checkSessionObjRUI(input, session, model);

         model.addAttribute("inputData", input);

        return "web/stat/space/spaceEvAffrStts";
    }

    /**
     * 통계 > 공간성능평가 > 사업부별통계 화면
     *
     * @param input HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return String
     * */
    @RequestMapping(value="/stat/space/spaceCrgrStat.do")
    public String spaceCrgrStat(@RequestParam HashMap<String, Object> input, HttpServletRequest request,
            HttpSession session, ModelMap model) {

    	LOGGER.debug("###########################################################");
        LOGGER.debug("prjState [통계 > 공간성능평가 > 사업부별통계 화면]");
        LOGGER.debug("###########################################################");

        checkSessionObjRUI(input, session, model);

         model.addAttribute("inputData", input);

        return "web/stat/space/spaceCrgrStat";
    }

    /**
     * 통계 > 공간성능평가 > 담당자별통계 화면
     *
     * @param input HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return String
     * */
    @RequestMapping(value="/stat/space/spaceBzdvStat.do")
    public String spaceBzdvStat(@RequestParam HashMap<String, Object> input, HttpServletRequest request,
            HttpSession session, ModelMap model) {

    	LOGGER.debug("###########################################################");
        LOGGER.debug("prjState [통계 > 공간성능평가 > 담당자별통계 화면]");
        LOGGER.debug("###########################################################");

        checkSessionObjRUI(input, session, model);

         model.addAttribute("inputData", input);

        return "web/stat/space/spaceBzdvStat";
    }

    /**
     * 통계 > 공간성능평가 > 분석목적별통계 화면
     *
     * @param input HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return String
     * */
    @RequestMapping(value="/stat/space/spaceAnlStat.do")
    public String spaceAnlStat(@RequestParam HashMap<String, Object> input, HttpServletRequest request,
            HttpSession session, ModelMap model) {

    	LOGGER.debug("###########################################################");
        LOGGER.debug("prjState [통계 > 공간성능평가 > 분석목적별통계 화면]");
        LOGGER.debug("###########################################################");

        checkSessionObjRUI(input, session, model);

         model.addAttribute("inputData", input);

        return "web/stat/space/spaceAnlStat";
    }

    /**
     * 통계 > 공간성능평가 > 분석방법별통계 화면
     *
     * @param input HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return String
     * */
    @RequestMapping(value="/stat/space/spaceAnlWayStat.do")
    public String spaceAnlWayStat(@RequestParam HashMap<String, Object> input, HttpServletRequest request,
            HttpSession session, ModelMap model) {

    	LOGGER.debug("###########################################################");
        LOGGER.debug("prjState [통계 > 공간성능평가 > 분석방법별통계 화면]");
        LOGGER.debug("###########################################################");

        checkSessionObjRUI(input, session, model);

         model.addAttribute("inputData", input);

        return "web/stat/space/spaceAnlWayStat";
    }

    /**
     * 통계 > 공간성능평가 > 연도조회 조회
     *
     * @param input HashMap<String, Object>
     * @param request HttpServletRequest
     * @param response HttpServletResponse
     * @param session HttpSession
     * @param model ModelMap
     * @return ModelAndView
     * */
    @RequestMapping(value="/stat/space/retrieveSpaceYyList.do")
    public ModelAndView retrieveSpaceYyList(@RequestParam HashMap<String, Object> input, HttpServletRequest request,
            HttpServletResponse response, HttpSession session, ModelMap model) {

        LOGGER.debug("###########################################################");
        LOGGER.debug("retrieveRlabYyList [통계 > 공간성능평가 > 연도 조회]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSessionObjRUI(input, session, model);
        ModelAndView modelAndView = new ModelAndView("ruiView");

        List<Map<String,Object>> list = spaceStatService.retrieveSpaceYyList(input);

        modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", list));

        return modelAndView;
    }

    /**
     * 통계 > 공간성능평가 > 담당자별통계 조회
     *
     * @param input HashMap<String, Object>
     * @param request HttpServletRequest
     * @param response HttpServletResponse
     * @param session HttpSession
     * @param model ModelMap
     * @return ModelAndView
     * */
    @RequestMapping(value="/stat/space/getSpaceBzdvStatList.do")
    public ModelAndView getSpaceBzdvStatList(@RequestParam HashMap<String, Object> input, HttpServletRequest request,
            HttpServletResponse response, HttpSession session, ModelMap model) {

        LOGGER.debug("###########################################################");
        LOGGER.debug("getSpaceBzdvStatList [통계 > 공간성능평가 > 담당자별통계 조회]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSessionObjRUI(input, session, model);
        ModelAndView modelAndView = new ModelAndView("ruiView");

        List<Map<String,Object>> list = spaceStatService.getSpaceBzdvStatList(input);

        modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", list));

        return modelAndView;
    }

}
