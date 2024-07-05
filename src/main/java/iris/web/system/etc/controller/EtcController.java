/********************************************************************************
 * NAME : EtcController.java
 * DESC : 기타 공통
 * PROJ : IRIS UPGRADE 2차 프로젝트
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION
 * ----------  ------  ---------------------------------------------------------
 * 2018.08.09 정현웅    최초생성
 * 2024.07.05 서성일   spring batch 수동실행을 위한 RequestMapping 추가
 *********************************************************************************/

package iris.web.system.etc.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import iris.web.common.converter.RuiConverter;
import iris.web.common.util.StringUtil;
import iris.web.fxaInfoBatch.FxaInfoIFBatch;
import iris.web.fxaInfoBatch.WbsPjtIFBatch;
import iris.web.insaBatch.SsoDeptInfoBatch;
import iris.web.insaBatch.SsoUserInfoBatch;
import iris.web.prj.rsst.service.PrjRsstMstInfoService;
import iris.web.system.base.IrisBaseController;
import iris.web.system.etc.service.EtcService;

@Controller
public class EtcController  extends IrisBaseController {

    @Resource(name="messageSourceAccessor")
    private MessageSourceAccessor messageSourceAccessor;

    @Resource(name = "etcService")
    private EtcService etcService;

    @Resource(name = "prjRsstMstInfoService")
    private PrjRsstMstInfoService prjRsstMstInfoService;

    @Autowired
    private WbsPjtIFBatch wbsPjtIFBatch;

    @Autowired
    private FxaInfoIFBatch fxaInfoIFBatch;

    @Autowired
    private SsoUserInfoBatch ssoUserInfoBatch;

    @Autowired
    private SsoDeptInfoBatch ssoDeptInfoBatch;

    static final Logger LOGGER = LogManager.getLogger(EtcController.class);

    @RequestMapping(value="/system/etc/wbsCdSearchPopup.do")
    public String wbsCdSearchPopup(
            @RequestParam HashMap<String, String> input,
            HttpServletRequest request,
            HttpSession session,
            ModelMap model
            ){

        LOGGER.debug("###########################################################");
        LOGGER.debug("EtcController - wbsCdSearchPopup WBS 코드 조회 공통팝업");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");


        /* 반드시 공통 호출 후 작업 */
        checkSession(input, session, model);

        model.addAttribute("inputData", input);

        return "web/common/wbsCdSearchPopup";
    }

    @RequestMapping(value="/system/etc/getWbsCdList.do")
    public ModelAndView getWbsCdList(
            @RequestParam HashMap<String, Object> input,
            HttpServletRequest request,
            HttpSession session,
            ModelMap model
            ){

        /* 반드시 공통 호출 후 작업 */
        checkSessionObjRUI(input, session, model);

        input = StringUtil.toUtf8(input);

        LOGGER.debug("###########################################################");
        LOGGER.debug("EtcController - getWbsCdList WBS 코드 조회");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        ModelAndView modelAndView = new ModelAndView("ruiView");

        List<Map<String,Object>>  wbsCdList = etcService.getWbsCdList(input);

        modelAndView.addObject("wbsCdDataset", RuiConverter.createDataset("wbsCdDataset", wbsCdList));

        return modelAndView;
    }

    /*******************************************************/
    //[20240705][RFC] WBS PRJ INFO 배치
    @RequestMapping(value="/system/etc/WbsPjtIFBatch.do")
    public void WbsPjtIFBatch(
            @RequestParam HashMap<String, Object> input,
            HttpServletRequest request,
            HttpSession session,
            ModelMap model
            ){

        /* 반드시 공통 호출 후 작업 */
        checkSessionObjRUI(input, session, model);

        input = StringUtil.toUtf8(input);

        LOGGER.debug("###########################################################");
        LOGGER.debug("EtcController - WbsPjtIFBatch 수동 실행");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        wbsPjtIFBatch.batchProcess();
    }

    //[20240705][RFC] 고정자산 배치
    @RequestMapping(value="/system/etc/FxaInfoIFBatch.do")
    public void FxaInfoIFBatch(
            @RequestParam HashMap<String, Object> input,
            HttpServletRequest request,
            HttpSession session,
            ModelMap model
            ){

        /* 반드시 공통 호출 후 작업 */
        checkSessionObjRUI(input, session, model);

        input = StringUtil.toUtf8(input);

        LOGGER.debug("###########################################################");
        LOGGER.debug("EtcController - FxaInfoIFBatch 수동 실행");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        fxaInfoIFBatch.batchProcess();
    }

    //[20240705] sso user if 배치
    @RequestMapping(value="/system/etc/SsoUserInfoBatch.do")
    public void SsoUserInfoBatch(
            @RequestParam HashMap<String, Object> input,
            HttpServletRequest request,
            HttpSession session,
            ModelMap model
            ){

        /* 반드시 공통 호출 후 작업 */
        checkSessionObjRUI(input, session, model);

        input = StringUtil.toUtf8(input);

        LOGGER.debug("###########################################################");
        LOGGER.debug("EtcController - SsoUserInfoBatch 수동 실행");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        ssoUserInfoBatch.batchProcess();
    }

    //[20240705] sso dept if 배치
    @RequestMapping(value="/system/etc/SsoDeptInfoBatch.do")
    public void SsoDeptInfoBatch(
            @RequestParam HashMap<String, Object> input,
            HttpServletRequest request,
            HttpSession session,
            ModelMap model
            ){

        /* 반드시 공통 호출 후 작업 */
        checkSessionObjRUI(input, session, model);

        input = StringUtil.toUtf8(input);

        LOGGER.debug("###########################################################");
        LOGGER.debug("EtcController - SsoDeptInfoBatch 수동 실행");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        ssoDeptInfoBatch.batchProcess();
    }
}