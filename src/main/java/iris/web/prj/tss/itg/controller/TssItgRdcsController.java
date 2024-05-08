package iris.web.prj.tss.itg.controller;

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
import iris.web.prj.tss.com.service.TssUserService;
import iris.web.prj.tss.itg.service.TssItgRdcsService;
import iris.web.system.base.IrisBaseController;

/********************************************************************************
 * NAME : TssItgRdcsController.java
 * DESC : 관리 controller
 * PROJ : Iris
 * *************************************************************/

@Controller
public class TssItgRdcsController  extends IrisBaseController {

    @Resource(name="messageSourceAccessor")
    private MessageSourceAccessor messageSourceAccessor;

    @Resource(name = "tssUserService")
    private TssUserService tssUserService;

    @Resource(name = "tssItgRdcsService")
    private TssItgRdcsService tssItgRdcsService;

    static final Logger LOGGER = LogManager.getLogger(TssItgRdcsController.class);

    /*
     * GRS 조회
     */
    @RequestMapping(value="/prj/tss/itg/tssItgRdcsList.do")
    public String TssItgRdcsList(@RequestParam HashMap<String, String> input, HttpServletRequest request, HttpSession session, ModelMap model ){

        LOGGER.debug("###########################################################");
        LOGGER.debug("TssItgRdcsController - TssItgRdcsList ");
        LOGGER.debug("###########################################################");

        /* 반드시 공통 호출 후 작업 */
        checkSession(input, session, model);

        if(NullUtil.isNull(input.get("_userId")) ||  NullUtil.nvl(input.get("_userId"), "").equals("-1")  ){
            String rtnMsg = messageSourceAccessor.getMessage("msg.alert.sessionTimeout");
            SayMessage.setMessage(rtnMsg);
        } else {
            model.addAttribute("inputData", input);
        }

        LOGGER.debug("###########################################################");
        LOGGER.debug("loginUser => " + model.get("loginUser"));
        LOGGER.debug("inputData => " + input);

        LOGGER.debug("###########################################################");

        return "web/prj/tss/itg/tssItgRdcsList";
    }


    @RequestMapping(value="/prj/tss/itg/retrieveTssItgRdcsList.do")
    public ModelAndView retrieveTssItgRdcsList(@RequestParam HashMap<String, Object> input, HttpServletRequest request,
            HttpServletResponse response, HttpSession session, ModelMap model) {

        LOGGER.debug("###########################################################");
        LOGGER.debug("retrieveTssItgRdcsList - retrieveTssItgRdcsList ");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSessionObjRUI(input, session, model);

        ModelAndView modelAndView = new ModelAndView("ruiView");

        input = StringUtil.toUtf8(input);

        Map<String, Object> role = tssUserService.getTssListRoleChk(input);
        input.put("tssRoleType", role.get("tssRoleType"));
        input.put("tssRoleCd",   role.get("tssRoleCd"));

        List<Map<String,Object>> list = tssItgRdcsService.retrieveTssItgRdcsList(input);

        modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", list));

        return modelAndView;
    }




}
