package iris.web.prj.tss.tctm.controller;

import iris.web.common.util.StringUtil;
import iris.web.prj.tss.com.service.TssUserService;
import iris.web.prj.tss.gen.service.GenTssPlnService;
import iris.web.prj.tss.gen.service.GenTssService;
import iris.web.system.attach.service.AttachFileService;
import iris.web.system.base.IrisBaseController;

import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import devonframe.message.saymessage.SayMessage;
import devonframe.util.NullUtil;

/********************************************************************************
 * NAME : GenTssController.java
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
public class TctmTssController  extends IrisBaseController {

    @Resource(name="messageSourceAccessor")
    private MessageSourceAccessor messageSourceAccessor;

    @Resource(name = "tssUserService")
    private TssUserService tssUserService;

    @Resource(name = "genTssService")
    private GenTssService genTssService;

    @Resource(name = "genTssPlnService")
    private GenTssPlnService genTssPlnService;

    @Resource(name = "attachFileService")
    private AttachFileService attachFileService;                // 공통파일 서비스

    static final Logger LOGGER = LogManager.getLogger(TctmTssController.class);


    /**
     * 과제관리 > 일반과제 리스트 화면
     *
     * @param input HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return String
     * */
    @RequestMapping(value="/prj/tss/tctm/tctmTssList.do")
    public String genTssList(@RequestParam HashMap<String, Object> input, HttpServletRequest request,
            HttpSession session, ModelMap model) {


        checkSessionObjRUI(input, session, model);
        LOGGER.debug("###########################################################");
        LOGGER.debug("GenTssController - genTssList [과제관리 > 일반과제 리스트 화면]");
        LOGGER.debug("###########################################################");

        input = StringUtil.toUtf8(input);

        if(pageMoveChkSession((String)input.get("_userId"))) {
            Map<String, Object> role = tssUserService.getTssListRoleChk(input);
            input.put("tssRoleType", role.get("tssRoleType"));
            input.put("tssRoleId",   role.get("tssRoleId"));

            model.addAttribute("inputData", input);
        }

        return "web/prj/tss/tctm/tctmTssList";
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
