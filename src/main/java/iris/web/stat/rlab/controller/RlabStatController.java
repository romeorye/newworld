package iris.web.stat.rlab.controller;

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

import iris.web.common.converter.RuiConverter;
import iris.web.stat.rlab.service.RlabStatService;
import iris.web.system.base.IrisBaseController;

@Controller
public class RlabStatController extends IrisBaseController {

	@Resource(name="messageSourceAccessor")
    private MessageSourceAccessor messageSourceAccessor;

	@Resource(name="rlabStatService")
	private RlabStatService rlabStatService;

	static final Logger LOGGER = LogManager.getLogger(RlabStatController.class);


	 /**
     * 통계 > 신뢰성시험 > 연도별통계 화면
     *
     * @param input HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return String
     * */
    @RequestMapping(value="/stat/rlab/rlabState.do")
    public String rlabStat(@RequestParam HashMap<String, Object> input, HttpServletRequest request,
            HttpSession session, ModelMap model) {

    	LOGGER.debug("###########################################################");
        LOGGER.debug("prjState [통계 > 신뢰성시험 > 연도별통계 화면]");
        LOGGER.debug("###########################################################");

        checkSessionObjRUI(input, session, model);

         model.addAttribute("inputData", input);

        return "web/stat/rlab/rlabYyrStatList";
    }

    /**
     * 통계 > 신뢰성시험 > 시험구분별통계 리스트 조회
     *
     * @param input HashMap<String, Object>
     * @param request HttpServletRequest
     * @param response HttpServletResponse
     * @param session HttpSession
     * @param model ModelMap
     * @return ModelAndView
     * */
    @RequestMapping(value="/stat/rlab/retrieveRlabScnStatList.do")
    public ModelAndView retrieveRlabScnStatList(@RequestParam HashMap<String, Object> input, HttpServletRequest request,
            HttpServletResponse response, HttpSession session, ModelMap model) {

        LOGGER.debug("###########################################################");
        LOGGER.debug("retrievePrjRsstStatList [통계 > 신뢰성시험 > 연도별통계 시험구분별통계 리스트 조회]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSessionObjRUI(input, session, model);
        ModelAndView modelAndView = new ModelAndView("ruiView");

        List<Map<String,Object>> list = rlabStatService.retrieveRlabScnStatList(input);

        modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", list));

        return modelAndView;
    }

    /**
     * 통계 > 신뢰성시험 > 사업장별통계 리스트 조회
     *
     * @param input HashMap<String, Object>
     * @param request HttpServletRequest
     * @param response HttpServletResponse
     * @param session HttpSession
     * @param model ModelMap
     * @return ModelAndView
     * */
    @RequestMapping(value="/stat/rlab/retrieveRlabDzdvStatList.do")
    public ModelAndView retrieveRlabDzdvStatList(@RequestParam HashMap<String, Object> input, HttpServletRequest request,
            HttpServletResponse response, HttpSession session, ModelMap model) {

        LOGGER.debug("###########################################################");
        LOGGER.debug("retrievePrjRsstStatList [통계 > 신뢰성시험 > 연도별통계 사업장별통계 리스트 조회]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSessionObjRUI(input, session, model);
        ModelAndView modelAndView = new ModelAndView("ruiView");

        List<Map<String,Object>> list = rlabStatService.retrieveRlabDzdvStatList(input);

        modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", list));

        return modelAndView;
    }

    /**
     * 통계 > 신뢰성시험 > 시험법별통계 리스트 조회
     *
     * @param input HashMap<String, Object>
     * @param request HttpServletRequest
     * @param response HttpServletResponse
     * @param session HttpSession
     * @param model ModelMap
     * @return ModelAndView
     * */
    @RequestMapping(value="/stat/rlab/retrieveRlabExprStatList.do")
    public ModelAndView retrieveRlabExprStatList(@RequestParam HashMap<String, Object> input, HttpServletRequest request,
            HttpServletResponse response, HttpSession session, ModelMap model) {

        LOGGER.debug("###########################################################");
        LOGGER.debug("retrievePrjRsstStatList [통계 > 신뢰성시험 > 연도별통계 시험법통계 리스트 조회]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSessionObjRUI(input, session, model);
        ModelAndView modelAndView = new ModelAndView("ruiView");

        List<Map<String,Object>> list = rlabStatService.retrieveRlabExprStatList(input);

        modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", list));

        return modelAndView;
    }

    /**
     * 통계 > 신뢰성시험 > 담당자별통계 리스트 조회
     *
     * @param input HashMap<String, Object>
     * @param request HttpServletRequest
     * @param response HttpServletResponse
     * @param session HttpSession
     * @param model ModelMap
     * @return ModelAndView
     * */
    @RequestMapping(value="/stat/rlab/retrieveRlabChrgStatList.do")
    public ModelAndView retrieveRlabChrgStatList(@RequestParam HashMap<String, Object> input, HttpServletRequest request,
            HttpServletResponse response, HttpSession session, ModelMap model) {

        LOGGER.debug("###########################################################");
        LOGGER.debug("retrievePrjRsstStatList [통계 > 신뢰성시험 > 연도별통계 담당자별통계 리스트 조회]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSessionObjRUI(input, session, model);
        ModelAndView modelAndView = new ModelAndView("ruiView");

        List<Map<String,Object>> list = rlabStatService.retrieveRlabChrgStatList(input);

        modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", list));

        return modelAndView;
    }

    /**
     * 통계 > 신뢰성시험 > 연도조회 조회
     *
     * @param input HashMap<String, Object>
     * @param request HttpServletRequest
     * @param response HttpServletResponse
     * @param session HttpSession
     * @param model ModelMap
     * @return ModelAndView
     * */
    @RequestMapping(value="/stat/rlab/retrieveRlabYyList.do")
    public ModelAndView retrieveRlabYyList(@RequestParam HashMap<String, Object> input, HttpServletRequest request,
            HttpServletResponse response, HttpSession session, ModelMap model) {

        LOGGER.debug("###########################################################");
        LOGGER.debug("retrieveRlabYyList [통계 > 신뢰성시험 > 연도 조회]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSessionObjRUI(input, session, model);
        ModelAndView modelAndView = new ModelAndView("ruiView");

        List<Map<String,Object>> list = rlabStatService.retrieveRlabYyList(input);

        modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", list));

        return modelAndView;
    }

	 /**
     * 통계 > 신뢰성시험 > 기간별통계 화면
     *
     * @param input HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return String
     * */
    @RequestMapping(value="/stat/rlab/rlabTermState.do")
    public String rlabTermState(@RequestParam HashMap<String, Object> input, HttpServletRequest request,
            HttpSession session, ModelMap model) {

    	LOGGER.debug("###########################################################");
        LOGGER.debug("prjState [통계 > 신뢰성시험 > 기간별통계 화면]");
        LOGGER.debug("###########################################################");

        checkSessionObjRUI(input, session, model);

         model.addAttribute("inputData", input);

        return "web/stat/rlab/rlabTermStatList";
    }

    /**
     * 통계 > 신뢰성시험 > 기간별통계 리스트 조회
     *
     * @param input HashMap<String, Object>
     * @param request HttpServletRequest
     * @param response HttpServletResponse
     * @param session HttpSession
     * @param model ModelMap
     * @return ModelAndView
     * */
    @RequestMapping(value="/stat/rlab/retrieveRlabTermStatList.do")
    public ModelAndView retrieveRlabTermStatList(@RequestParam HashMap<String, Object> input, HttpServletRequest request,
            HttpServletResponse response, HttpSession session, ModelMap model) {

        LOGGER.debug("###########################################################");
        LOGGER.debug("retrieveRlabTermStatList [통계 > 신뢰성시험 > 연도별통계 기간별통계 리스트 조회]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSessionObjRUI(input, session, model);
        ModelAndView modelAndView = new ModelAndView("ruiView");

        List<Map<String,Object>> list = rlabStatService.retrieveRlabTermStatList(input);

        modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", list));

        return modelAndView;
    }
}
