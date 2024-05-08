package iris.web.prj.mgmt.smryCl.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.json.JSONObject;
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
import iris.web.prj.mgmt.smryCl.service.SmryClService;
import iris.web.prj.tss.gen.service.GenTssService;
import iris.web.system.base.IrisBaseController;

/********************************************************************************
 * NAME : SmryClController.java DESC : 관리 controller PROJ : Iris
 *************************************************************/

@Controller
public class SmryClController extends IrisBaseController {

    @Resource(name = "messageSourceAccessor")
    private MessageSourceAccessor messageSourceAccessor;

    @Resource(name = "smryClService")
    private SmryClService smryClService;

    @Resource(name = "genTssService")
    private GenTssService genTssService;

    static final Logger LOGGER = LogManager.getLogger(SmryClController.class);


    /**
     * 목록화면 이동
     *
     * @param input
     * @param request
     * @param response
     * @param session
     * @param model
     * @return
     */
    @RequestMapping(value = "/prj/mgmt/smryCl/smryClList.do")
    public String smryClList(@RequestParam HashMap<String, String> input, HttpServletRequest request,
            HttpSession session, ModelMap model) {

        LOGGER.debug("###########################################################");
        LOGGER.debug("smryClList");
        LOGGER.debug("###########################################################");

        checkSession(input, session, model);

        if (pageMoveChkSession(input.get("_userId"))) {
            model.addAttribute("inputData", input);
        }

        return "web/prj/mgmt/smryCl/smryClList";
    }


    /**
     * 목록화면 조회
     *
     * @param input
     * @param request
     * @param response
     * @param session
     * @param model
     * @return
     */
    @RequestMapping(value = "/prj/mgmt/smryCl/retrieveSmryClList.do")
    public ModelAndView retrieveSmryClList(@RequestParam HashMap<String, Object> input, HttpServletRequest request,
            HttpServletResponse response, HttpSession session, ModelMap model) {

        LOGGER.debug("###########################################################");
        LOGGER.debug("retrieveSmryClList");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSessionObjRUI(input, session, model);

        ModelAndView modelAndView = new ModelAndView("ruiView");

        input = StringUtil.toUtf8(input);

        input.put("tssRoleType", "");
        input.put("tssRoleCd",   "");
        input.put("tssRoleId",   "");

        List<Map<String, Object>> list = genTssService.retrieveGenTssList(input);

        modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", list));

        return modelAndView;
    }


    /**
     * 상세조회
     *
     * @param input
     * @param request
     * @param session
     * @param model
     * @return
     * @throws Exception
     */
    @RequestMapping(value = "/prj/mgmt/smryCl/smryClDetail.do")
    public String smryClDetail(@RequestParam HashMap<String, String> input, HttpServletRequest request,
            HttpSession session, ModelMap model) throws Exception {

        LOGGER.debug("###########################################################");
        LOGGER.debug("smryClDtl");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSession(input, session, model);

        if (pageMoveChkSession(input.get("_userId"))) {
            Map<String, Object> result = smryClService.retrieveSmryClDtl(input);

            List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
            list.add(result);

            JSONObject obj = new JSONObject();
            obj.put("records", list);

            request.setAttribute("inputData", input);
            request.setAttribute("resultCnt", result == null ? 0 : result.size());
            request.setAttribute("result", obj);
        }

        return "web/prj/mgmt/smryCl/smryClDetail";
    }


    /**
     * 템플릿저장
     *
     * @param input
     * @param request
     * @param session
     * @param model
     * @return
     */
    @RequestMapping(value = "/prj/mgmt/smryCl/updateSmryCl.do")
    public ModelAndView updateSmryCl(@RequestParam HashMap<String, Object> input, HttpServletRequest request,
            HttpSession session, ModelMap model) {

        LOGGER.debug("###########################################################");
        LOGGER.debug("updateSmryCl");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSessionObjRUI(input, session, model);

        ModelAndView modelAndView = new ModelAndView("ruiView");

        HashMap<String, Object> mstDs = null;

        try {
            mstDs = (HashMap<String, Object>) RuiConverter.convertToDataSet(request, "mstDataSet").get(0);

            smryClService.updateSmryCl(mstDs);

            mstDs.put("rtCd", "SUCCESS");
            mstDs.put("rtVal", messageSourceAccessor.getMessage("msg.alert.saved")); // 저장되었습니다.
            mstDs.put("rtType", "I");
        } catch (Exception e) {
            e.printStackTrace();
            mstDs.put("rtCd", "FAIL");
            mstDs.put("rtVal", messageSourceAccessor.getMessage("msg.alert.error")); // 오류가 발생하였습니다.
        }

        modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", mstDs));

        return modelAndView;
    }


    /**
     * 페이지 이동시 세션체크
     *
     * @param userId 로그인ID
     * @return boolean
     */
    public boolean pageMoveChkSession(String userId) {

        boolean rtVal = true;

        if (NullUtil.isNull(userId) || NullUtil.nvl(userId, "").equals("-1")) {
            SayMessage.setMessage(messageSourceAccessor.getMessage("msg.alert.sessionTimeout"));
            rtVal = false;
        }

        return rtVal;
    }
}
