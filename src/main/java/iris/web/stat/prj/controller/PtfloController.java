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
import iris.web.stat.prj.service.PtfloService;
import iris.web.system.base.IrisBaseController;

/********************************************************************************
 * NAME : PtfloController.java
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
public class PtfloController  extends IrisBaseController {

    @Resource(name="messageSourceAccessor")
    private MessageSourceAccessor messageSourceAccessor;

    @Resource(name = "ptfloService")
    private PtfloService ptfloService;

    static final Logger LOGGER = LogManager.getLogger(PtfloController.class);


    /**
     * 통계 > 포트폴리오 리스트 화면
     *
     * @param input HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return String
     * */
    @RequestMapping(value="/stat/prj/ptfloList.do")
    public String ptfloList(@RequestParam HashMap<String, Object> input, HttpServletRequest request,
            HttpSession session, ModelMap model) {

        LOGGER.debug("###########################################################");
        LOGGER.debug("ptfloList [통계 > 포트폴리오 리스트 화면]");
        LOGGER.debug("###########################################################");

        checkSessionObjRUI(input, session, model);

        if(pageMoveChkSession((String)input.get("_userId"))) {
            model.addAttribute("inputData", input);
        }

        return "web/stat/prj/ptfloList";
    }


    /**
     * 통계 > 포트폴리오 > Funding구조 조회
     *
     * @param input HashMap<String, Object>
     * @param request HttpServletRequest
     * @param response HttpServletResponse
     * @param session HttpSession
     * @param model ModelMap
     * @return ModelAndView
     * */
    @RequestMapping(value="/stat/prj/retrievePtfloFunding.do")
    public ModelAndView retrievePtfloFunding(@RequestParam HashMap<String, Object> input, HttpServletRequest request,
            HttpServletResponse response, HttpSession session, ModelMap model) {

        LOGGER.debug("###########################################################");
        LOGGER.debug("retrievePtfloFunding [통계 > 포트폴리오 > Funding구조 조회]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSessionObjRUI(input, session, model);

        ModelAndView modelAndView = new ModelAndView("ruiView");

        input = StringUtil.toUtf8(input);

        List<Map<String,Object>> aList = ptfloService.retrievePtfloFunding_a(input);
        List<Map<String,Object>> pList = ptfloService.retrievePtfloFunding_p(input);

        modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", aList));
        modelAndView.addObject("dataSet1", RuiConverter.createDataset("dataSet1", pList));

        return modelAndView;
    }


    /**
     * 통계 > 포트폴리오 > 기간 조회
     *
     * @param input HashMap<String, Object>
     * @param request HttpServletRequest
     * @param response HttpServletResponse
     * @param session HttpSession
     * @param model ModelMap
     * @return ModelAndView
     * */
    @RequestMapping(value="/stat/prj/retrievePtfloTrm.do")
    public ModelAndView retrievePtfloTrm(@RequestParam HashMap<String, Object> input, HttpServletRequest request,
            HttpServletResponse response, HttpSession session, ModelMap model) {

        LOGGER.debug("###########################################################");
        LOGGER.debug("retrievePtfloTrm [통계 > 포트폴리오 > 기간 조회]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSessionObjRUI(input, session, model);

        ModelAndView modelAndView = new ModelAndView("ruiView");

        input = StringUtil.toUtf8(input);

        List<Map<String,Object>> alist = ptfloService.retrievePtfloTrm_a(input);
        List<Map<String,Object>> plist = ptfloService.retrievePtfloTrm_p(input);

        modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", alist));
        modelAndView.addObject("dataSet1", RuiConverter.createDataset("dataSet1", plist));

        return modelAndView;
    }


    /**
     * 통계 > 포트폴리오 > 과제속성 조회
     *
     * @param input HashMap<String, Object>
     * @param request HttpServletRequest
     * @param response HttpServletResponse
     * @param session HttpSession
     * @param model ModelMap
     * @return ModelAndView
     * */
    @RequestMapping(value="/stat/prj/retrievePtfloAttr.do")
    public ModelAndView retrievePtfloAttr(@RequestParam HashMap<String, Object> input, HttpServletRequest request,
            HttpServletResponse response, HttpSession session, ModelMap model) {

        LOGGER.debug("###########################################################");
        LOGGER.debug("retrievePtfloAttr [통계 > 포트폴리오 > 과제속성 조회]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSessionObjRUI(input, session, model);

        ModelAndView modelAndView = new ModelAndView("ruiView");

        input = StringUtil.toUtf8(input);

        List<Map<String,Object>> aLlist = ptfloService.retrievePtfloAttr_a(input);
        List<Map<String,Object>> pList =  ptfloService.retrievePtfloAttr_p(input);

        modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", aLlist));
        modelAndView.addObject("dataSet1", RuiConverter.createDataset("dataSet1", pList));

        return modelAndView;
    }


    /**
     * 통계 > 포트폴리오 > 연구분야 조회
     *
     * @param input HashMap<String, Object>
     * @param request HttpServletRequest
     * @param response HttpServletResponse
     * @param session HttpSession
     * @param model ModelMap
     * @return ModelAndView
     * */
    @RequestMapping(value="/stat/prj/retrievePtfloSphe.do")
    public ModelAndView retrievePtfloSphe(@RequestParam HashMap<String, Object> input, HttpServletRequest request,
            HttpServletResponse response, HttpSession session, ModelMap model) {

        LOGGER.debug("###########################################################");
        LOGGER.debug("retrievePtfloSphe [통계 > 포트폴리오 > 연구분야 조회]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSessionObjRUI(input, session, model);

        ModelAndView modelAndView = new ModelAndView("ruiView");

        input = StringUtil.toUtf8(input);

        List<Map<String,Object>> aLlist = ptfloService.retrievePtfloSphe_a(input);
        List<Map<String,Object>> pList = ptfloService.retrievePtfloSphe_p(input);

        modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", aLlist));
        modelAndView.addObject("dataSet1", RuiConverter.createDataset("dataSet1", pList));

        return modelAndView;
    }


    /**
     * 통계 > 포트폴리오 > 유형 조회
     *
     * @param input HashMap<String, Object>
     * @param request HttpServletRequest
     * @param response HttpServletResponse
     * @param session HttpSession
     * @param model ModelMap
     * @return ModelAndView
     * */
    @RequestMapping(value="/stat/prj/retrievePtfloType.do")
    public ModelAndView retrievePtfloType(@RequestParam HashMap<String, Object> input, HttpServletRequest request,
            HttpServletResponse response, HttpSession session, ModelMap model) {

        LOGGER.debug("###########################################################");
        LOGGER.debug("retrievePtfloType [통계 > 포트폴리오 > 유형 조회]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSessionObjRUI(input, session, model);

        ModelAndView modelAndView = new ModelAndView("ruiView");

        input = StringUtil.toUtf8(input);

        List<Map<String,Object>> aLlist = ptfloService.retrievePtfloType_a(input);
        List<Map<String,Object>> pList = ptfloService.retrievePtfloType_p(input);

        modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", aLlist));
        modelAndView.addObject("dataSet1", RuiConverter.createDataset("dataSet1", pList));

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
