package iris.web.stat.prj.controller;

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
import iris.web.common.util.StringUtil;
import iris.web.stat.prj.service.TssStatService;
import iris.web.system.base.IrisBaseController;

/********************************************************************************
 * NAME : TssStatController.java
 * DESC :
 * PROJ :
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION
 * ----------  ------  ---------------------------------------------------------
 * 2017.0808
 *********************************************************************************/

@Controller
public class TssStatController  extends IrisBaseController {

    @Resource(name="messageSourceAccessor")
    private MessageSourceAccessor messageSourceAccessor;

    @Resource(name = "tssStatService")
    private TssStatService tssStatService;

    static final Logger LOGGER = LogManager.getLogger(TssStatController.class);


    /**
     * 통계 > 일반과제 리스트 화면
     *
     * @param input HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return String
     * */
    @RequestMapping(value="/stat/prj/genTssState.do")
    public String genTssStat(@RequestParam HashMap<String, Object> input, HttpServletRequest request,
            HttpSession session, ModelMap model) {

        LOGGER.debug("###########################################################");
        LOGGER.debug("genTssStat [통계 > 일반과제 리스트 화면]");
        LOGGER.debug("###########################################################");

        checkSessionObjRUI(input, session, model);

        if(pageMoveChkSession((String)input.get("_userId"))) {
            model.addAttribute("inputData", input);
        }

        return "web/stat/prj/genTssStat";
    }


    /**
     * 통계 > 일반과제 리스트 조회
     *
     * @param input HashMap<String, Object>
     * @param request HttpServletRequest
     * @param response HttpServletResponse
     * @param session HttpSession
     * @param model ModelMap
     * @return ModelAndView
     * */
    @RequestMapping(value="/stat/prj/retrieveGenTssStatList.do")
    public ModelAndView retrieveGenTssStatList(@RequestParam HashMap<String, Object> input, HttpServletRequest request,
            HttpServletResponse response, HttpSession session, ModelMap model) {

        LOGGER.debug("###########################################################");
        LOGGER.debug("retrieveGenTssStatList [통계 > 일반과제 리스트 조회]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSessionObjRUI(input, session, model);

        ModelAndView modelAndView = new ModelAndView("ruiView");

        input = StringUtil.toUtf8(input);

        List<Map<String,Object>> list = tssStatService.retrieveGenTssStatList(input);

        modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", list));

        return modelAndView;
    }

	/**
	 *  통계 > 일반과제 리스트 년도별 상세팝업 화면
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/stat/prj/genTssStatDtlPop.do")
	public String genTssStatDtlPop(@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){

		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		model.addAttribute("inputData", input);
		return  "web/stat/prj/genTssStatDtlPop";
	}

    /**
     * 통계 > 일반과제 리스트 년도별 상세팝업 조회
     *
     * @param input HashMap<String, Object>
     * @param request HttpServletRequest
     * @param response HttpServletResponse
     * @param session HttpSession
     * @param model ModelMap
     * @return ModelAndView
     * */
    @RequestMapping(value="/stat/prj/retrieveGenTssStatDtlPopList.do")
    public ModelAndView retrieveGenTssStatDtlPopList(@RequestParam HashMap<String, Object> input, HttpServletRequest request,
            HttpServletResponse response, HttpSession session, ModelMap model) {

        LOGGER.debug("###########################################################");
        LOGGER.debug("retrieveGenTssStatDtlPopList [통계 > 일반과제 리스트 년도별 상세팝업 조회]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSessionObjRUI(input, session, model);

        ModelAndView modelAndView = new ModelAndView("ruiView");

        input = StringUtil.toUtf8(input);

        List<Map<String,Object>> list = tssStatService.retrieveGenTssStatDtlPopList(input);

        modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", list));

        return modelAndView;
    }

    //////////////////////////////////////////////////////////
    /**
     * 통계 > 기술팀과제 리스트 화면
     *
     * @param input HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return String
     * */
    @RequestMapping(value="/stat/prj/techTeamTssState.do")
    public String techTeamTssState(@RequestParam HashMap<String, Object> input, HttpServletRequest request,
            HttpSession session, ModelMap model) {

        LOGGER.debug("###########################################################");
        LOGGER.debug("genTssStat [통계 > 기술팀과제 리스트 화면]");
        LOGGER.debug("###########################################################");

        checkSessionObjRUI(input, session, model);

        if(pageMoveChkSession((String)input.get("_userId"))) {
            model.addAttribute("inputData", input);
        }

        return "web/stat/prj/techTeamTssStat";
    }


    /**
     * 통계 > 기술팀과제 리스트 조회
     *
     * @param input HashMap<String, Object>
     * @param request HttpServletRequest
     * @param response HttpServletResponse
     * @param session HttpSession
     * @param model ModelMap
     * @return ModelAndView
     * */
    @RequestMapping(value="/stat/prj/retrieveTechTeamTssStatList.do")
    public ModelAndView retrieveTechTeamTssStatList(@RequestParam HashMap<String, Object> input, HttpServletRequest request,
            HttpServletResponse response, HttpSession session, ModelMap model) {

        LOGGER.debug("###########################################################");
        LOGGER.debug("retrieveTechTeamTssStatList [통계 > 기술팀과제 리스트 조회]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSessionObjRUI(input, session, model);

        ModelAndView modelAndView = new ModelAndView("ruiView");

        input = StringUtil.toUtf8(input);

        List<Map<String,Object>> list = tssStatService.retrieveTechTeamTssStatList(input);

        modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", list));

        return modelAndView;
    }

	/**
	 *  통계 > 기술팀과제 리스트 년도별 상세팝업 화면
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/stat/prj/techTeamTssStatDtlPop.do")
	public String techTeamTssStatDtlPop(@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){

		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		model.addAttribute("inputData", input);
		return  "web/stat/prj/techTeamTssStatDtlPop";
	}

    /**
     * 통계 > 기술팀과제 리스트 년도별 상세팝업 조회
     *
     * @param input HashMap<String, Object>
     * @param request HttpServletRequest
     * @param response HttpServletResponse
     * @param session HttpSession
     * @param model ModelMap
     * @return ModelAndView
     * */
    @RequestMapping(value="/stat/prj/retrieveTechTeamTssStatDtlPopList.do")
    public ModelAndView retrieveTechTeamTssStatDtlPopList(@RequestParam HashMap<String, Object> input, HttpServletRequest request,
            HttpServletResponse response, HttpSession session, ModelMap model) {

        LOGGER.debug("###########################################################");
        LOGGER.debug("retrieveTechTeamTssStatDtlPopList [통계 > 기술팀과제 리스트 년도별 상세팝업 조회]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSessionObjRUI(input, session, model);

        ModelAndView modelAndView = new ModelAndView("ruiView");

        input = StringUtil.toUtf8(input);

        List<Map<String,Object>> list = tssStatService.retrieveTechTeamTssStatDtlPopList(input);

        modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", list));

        return modelAndView;
    }

    /**
     * 통계 > 대외협력과제 리스트 화면
     *
     * @param input HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return String
     * */
    @RequestMapping(value="/stat/prj/ousdTssState.do")
    public String ousdTssStat(@RequestParam HashMap<String, Object> input, HttpServletRequest request,
            HttpSession session, ModelMap model) {

        LOGGER.debug("###########################################################");
        LOGGER.debug("ousdTssStat [통계 > 대외협력과제 리스트 화면]");
        LOGGER.debug("###########################################################");

        checkSessionObjRUI(input, session, model);

        if(pageMoveChkSession((String)input.get("_userId"))) {
            model.addAttribute("inputData", input);
        }

        return "web/stat/prj/ousdTssStat";
    }


    /**
     * 통계 > 대외협력과제 리스트 조회
     *
     * @param input HashMap<String, Object>
     * @param request HttpServletRequest
     * @param response HttpServletResponse
     * @param session HttpSession
     * @param model ModelMap
     * @return ModelAndView
     * */
    @RequestMapping(value="/stat/prj/retrieveOusdTssStatList.do")
    public ModelAndView retrieveOusdTssStatList(@RequestParam HashMap<String, Object> input, HttpServletRequest request,
            HttpServletResponse response, HttpSession session, ModelMap model) {

        LOGGER.debug("###########################################################");
        LOGGER.debug("retrieveOusdTssStatList [통계 > 대외협력과제 리스트 조회]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSessionObjRUI(input, session, model);

        ModelAndView modelAndView = new ModelAndView("ruiView");

        input = StringUtil.toUtf8(input);

        List<Map<String,Object>> list = tssStatService.retrieveOusdTssStatList(input);

        modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", list));

        return modelAndView;
    }


    /**
     * 통계 > 국책과제 리스트 화면
     *
     * @param input HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return String
     * */
    @RequestMapping(value="/stat/prj/natTssState.do")
    public String natTssStat(@RequestParam HashMap<String, Object> input, HttpServletRequest request,
            HttpSession session, ModelMap model) {

        LOGGER.debug("###########################################################");
        LOGGER.debug("natTssStat [통계 > 국책과제 리스트 화면]");
        LOGGER.debug("###########################################################");

        checkSessionObjRUI(input, session, model);

        if(pageMoveChkSession((String)input.get("_userId"))) {
            model.addAttribute("inputData", input);
        }

        return "web/stat/prj/natTssStat";
    }


    /**
     * 통계 > 국책과제 리스트 조회
     *
     * @param input HashMap<String, Object>
     * @param request HttpServletRequest
     * @param response HttpServletResponse
     * @param session HttpSession
     * @param model ModelMap
     * @return ModelAndView
     * */
    @RequestMapping(value="/stat/prj/retrieveNatTssStatList.do")
    public ModelAndView retrieveNatTssStatList(@RequestParam HashMap<String, Object> input, HttpServletRequest request,
            HttpServletResponse response, HttpSession session, ModelMap model) {

        LOGGER.debug("###########################################################");
        LOGGER.debug("retrieveNatTssStatList [통계 > 국책과제 리스트 조회]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSessionObjRUI(input, session, model);

        ModelAndView modelAndView = new ModelAndView("ruiView");

        input = StringUtil.toUtf8(input);

        List<Map<String,Object>> list = tssStatService.retrieveNatTssStatList(input);

        modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", list));

        return modelAndView;
    }


    /**
     * 페이지 이동시 세션체크
     *
     * @param userId 로그인ID
     * @return boolean
     * */
    public boolean pageMoveChkSession(String userId) {

        boolean rtVal = true;

        if(NullUtil.isNull(userId) || NullUtil.nvl(userId, "").equals("-1")) {
            SayMessage.setMessage(messageSourceAccessor.getMessage("msg.alert.sessionTimeout"));
            rtVal = false;
        }

        return rtVal;
    }
}
