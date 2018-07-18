package iris.web.prj.tss.ousdcoo.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.json.JSONException;
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
import iris.web.prj.tss.com.service.TssUserService;
import iris.web.prj.tss.gen.service.GenTssPlnService;
import iris.web.prj.tss.gen.service.GenTssService;
import iris.web.prj.tss.ousdcoo.service.OusdCooTssService;
import iris.web.system.attach.service.AttachFileService;
import iris.web.system.base.IrisBaseController;

/********************************************************************************
 * NAME : OusdCooTssController.java
 * DESC : 프로젝트 - 과제관리 - 대외협력과제 controller
 * PROJ : IRIS 구축 프로젝트
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION
 * ----------  ------  ---------------------------------------------------------
 * 2017.09.14  IRIS04	최초생성
 *********************************************************************************/

@Controller
public class OusdCooTssController  extends IrisBaseController {

    @Resource(name="messageSourceAccessor")
    private MessageSourceAccessor messageSourceAccessor;

    @Resource(name = "tssUserService")
    private TssUserService tssUserService;

    @Resource(name = "ousdCooTssService")
    private OusdCooTssService ousdCooTssService;

    @Resource(name = "genTssService")
    private GenTssService genTssService;		// 일반과제 서비스

    @Resource(name = "genTssPlnService")
    private GenTssPlnService genTssPlnService;                  // 일반과제 계획 서비스

    @Resource(name = "attachFileService")
    private AttachFileService attachFileService;                // 공통파일 서비스

    static final Logger LOGGER = LogManager.getLogger(OusdCooTssController.class);

    /**
     * 과제관리 > 대외협력과제 목록화면
     *
     * @param input HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return String
     * */
    @RequestMapping(value="/prj/tss/ousdcoo/ousdCooTssList.do")
    public String ousdCooTssList(@RequestParam HashMap<String, Object> input, HttpServletRequest request,
            HttpSession session, ModelMap model) {
        LOGGER.debug("###########################################################################################");
        LOGGER.debug("OusdCooTssController - ousdCooTssList [과제관리 > 대외협력과제 리스트 화면]");
        LOGGER.debug("###########################################################################################");

        checkSessionObjRUI(input, session, model);

        input = StringUtil.toUtf8(input);
        
        if(pageMoveChkSession((String) input.get("_userId"))) {
            Map<String, Object> role = tssUserService.getTssListRoleChk(input);
            input.put("tssRoleType", role.get("tssRoleType"));
            input.put("tssRoleId",   role.get("tssRoleId"));

            model.addAttribute("inputData", input);
        }

        return "web/prj/tss/ousdcoo/ousdCooTssList";
    }


    /**
     * 과제관리 > 대외협력과제 리스트 조회
     *
     * @param input HashMap<String, Object>
     * @param request HttpServletRequest
     * @param response HttpServletResponse
     * @param session HttpSession
     * @param model ModelMap
     * @return ModelAndView
     * */
    @SuppressWarnings("unchecked")
    @RequestMapping(value="/prj/tss/ousdcoo/retrieveOusdCooTssList.do")
    public ModelAndView retrieveOusdCooTssList(@RequestParam HashMap<String, Object> input, HttpServletRequest request,
            HttpServletResponse response, HttpSession session, ModelMap model) {

        LOGGER.debug("###########################################################");
        LOGGER.debug("OusdCooTssController - retrieveOusdCooTssList [과제관리 > 대외협력과제 리스트 조회]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSessionObjRUI(input, session, model);
        ModelAndView modelAndView = new ModelAndView("ruiView");
        input = StringUtil.toUtf8(input);

        Map<String, Object> role = tssUserService.getTssListRoleChk(input);
        input.put("tssRoleType", role.get("tssRoleType"));
        input.put("tssRoleCd",   role.get("tssRoleCd"));

        List<Map<String,Object>> list = ousdCooTssService.retrieveOusdCooTssList(input);

        modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", list));

        return modelAndView;
    }


    /**
     * 통합검색
     *
     * @param input HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return String
     * @throws JSONException
     * */
    @SuppressWarnings({ "unchecked", "rawtypes" })
    @RequestMapping(value="/prj/tss/ousdcoo/ousdCooTssItgSrch.do")
    public String ousdCooTssItgSrch(@RequestParam HashMap<String, String> input, HttpServletRequest request,
            HttpSession session, ModelMap model) throws JSONException {

        LOGGER.debug("###########################################################");
        LOGGER.debug("ousdCooTssItgSrch [ 통합검색 ]");
        LOGGER.debug("###########################################################");

        checkSession(input, session, model);

        if(pageMoveChkSession(input.get("_userId"))) {
            Map<String, Object> resultMst  = genTssPlnService.retrieveGenTssPlnMst(input);            //마스터
            Map<String, Object> resultSmry = ousdCooTssService.retrieveOusdCooTssSmryNtoBr(input);    //개요

            resultMst  = StringUtil.toUtf8Output((HashMap) resultMst);
            resultSmry = StringUtil.toUtf8Output((HashMap) resultSmry);

            HashMap<String, Object> inputInfo = new HashMap<String, Object>();
            String pgsStepCd = String.valueOf(resultMst.get("pgsStepCd"));
            String attcFilId = "";
            if("AL".equals(pgsStepCd)) attcFilId = String.valueOf(resultSmry.get("altrAttcFilId"));
            else if("CM".equals(pgsStepCd)) attcFilId = String.valueOf(resultSmry.get("cmplAttcFilId"));
            else if("DC".equals(pgsStepCd)) attcFilId = String.valueOf(resultSmry.get("dcacAttcFilId"));
            else attcFilId = String.valueOf(resultSmry.get("attcFilId"));

            inputInfo.put("attcFilId", attcFilId);
            List<Map<String, Object>> resultAttc = attachFileService.getAttachFileList(inputInfo);

            model.addAttribute("inputData", input);
            model.addAttribute("resultMst", resultMst);
            model.addAttribute("resultSmry", resultSmry);
            model.addAttribute("resultAttc", resultAttc);

            //text컬럼을 위한 json변환
            JSONObject obj = new JSONObject();
            obj.put("smry", resultSmry);

            request.setAttribute("resultJson", obj);
        }

        return "web/prj/tss/ousdcoo/ousdCooTssItgSrch";
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
