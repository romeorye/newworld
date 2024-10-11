package iris.web.prj.tss.nat.controller;

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
import org.json.JSONException;
import org.json.JSONObject;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.HandlerMapping;
import org.springframework.web.servlet.ModelAndView;

import devonframe.message.saymessage.SayMessage;
import devonframe.util.NullUtil;
import iris.web.common.converter.RuiConverter;
import iris.web.common.util.StringUtil;
import iris.web.prj.tss.com.service.TssUserService;
import iris.web.prj.tss.gen.service.GenTssPlnService;
import iris.web.prj.tss.nat.service.NatTssService;
import iris.web.system.attach.service.AttachFileService;
import iris.web.system.base.IrisBaseController;

/********************************************************************************
 * NAME : NatTssController.java
 * DESC : 관리 controller
 * PROJ : Iris
 * *************************************************************/

@Controller
public class NatTssController  extends IrisBaseController {

    @Resource(name="messageSourceAccessor")
    private MessageSourceAccessor messageSourceAccessor;

    @Resource(name = "tssUserService")
    private TssUserService tssUserService;

    @Resource(name = "natTssService")
    private NatTssService natTssService;

    @Resource(name = "genTssPlnService")
    private GenTssPlnService genTssPlnService;

    @Resource(name = "attachFileService")
    private AttachFileService attachFileService;                // 공통파일 서비스

    static final Logger LOGGER = LogManager.getLogger(NatTssController.class);

    /*
     * GRS 목록화면
     */
    @RequestMapping(value="/prj/tss/nat/natTssList.do")
    public String natTssList(@RequestParam HashMap<String, Object> input, HttpServletRequest request, HttpSession session, ModelMap model ){

        LOGGER.debug("###########################################################");
        LOGGER.debug("NatTssController - natTssList [국책과제화면 호출]");
        LOGGER.debug("inputData => " + input);
        LOGGER.debug("###########################################################");

        input = StringUtil.toUtf8(input);
        /* 반드시 공통 호출 후 작업 */
        checkSessionObjRUI(input, session, model);

        if(pageMoveChkSession((String) input.get("_userId"))) {
            Map<String, Object> role = tssUserService.getTssListRoleChk(input);
            input.put("tssRoleType", role.get("tssRoleType"));
            input.put("tssRoleId",   role.get("tssRoleId"));

            model.addAttribute("inputData", input);
        }

        return "web/prj/tss/nat/natTssList";
    }

    /**
     * 대외 협력 과제 목록조회
     * @param input
     * @param request
     * @param response
     * @param session
     * @param model
     * @return
     */
    @RequestMapping(value="/prj/tss/nat/retrieveNatTssList.do")
    public ModelAndView retrieveNatTssList(@RequestParam HashMap<String, Object> input, HttpServletRequest request,
            HttpServletResponse response, HttpSession session, ModelMap model) {

        LOGGER.debug("###########################################################");
        LOGGER.debug("retrieveNatTssList - retrieveNatTssList ");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSessionObjRUI(input, session, model);

        ModelAndView modelAndView = new ModelAndView("ruiView");

        input = StringUtil.toUtf8(input);

        Map<String, Object> role = tssUserService.getTssListRoleChk(input);
        input.put("tssRoleType", role.get("tssRoleType"));
        input.put("tssRoleCd",   role.get("tssRoleCd"));

        List<Map<String,Object>> list = natTssService.retrieveNatTssList(input);

        modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", list));

        return modelAndView;
    }


    //================================================================================================ 정산
    /**
     * 과제관리 > 국책과제 > 정산 iframe 조회
     * [20241010]siseo.초기유동관리 추가
     * @param input HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return String
     * @throws JSONException
     * */
    //@RequestMapping(value="/prj/tss/nat/natTssStoaIfm.do")
    @RequestMapping(value = {"/prj/tss/nat/natTssStoaIfm.do", "/prj/tss/gen/genTssCmplInitFlowIfm.do"})
    public String natTssStoaIfm(@RequestParam HashMap<String, String> input, HttpServletRequest request,
            HttpSession session, ModelMap model) throws JSONException {

        String reqUrl = (String)request.getAttribute(HandlerMapping.PATH_WITHIN_HANDLER_MAPPING_ATTRIBUTE);
        
        LOGGER.debug("###########################################################");
        LOGGER.debug("natTssCmplStoaIfm [과제관리 > 국책과제 > 정산 iframe 조회]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("req url = > " + reqUrl);
        LOGGER.debug("###########################################################");

        checkSession(input, session, model);

        if(pageMoveChkSession(input.get("_userId"))) {
            Map<String, Object> result = natTssService.retrieveNatTssStoa(input);

            List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
            list.add(result);

            JSONObject obj = new JSONObject();
            obj.put("records", list);

            request.setAttribute("inputData", input);
            request.setAttribute("resultCnt", result == null ? 0 : result.size());
            request.setAttribute("result", obj);
        }
        
        String rtnUrl = "web/prj/tss/nat/stoa/natTssStoaIfm";
        if (reqUrl.indexOf("/prj/tss/gen/")>-1) {
            rtnUrl = "web/prj/tss/gen/cmpl/genTssCmplInitFlowIfm";
        }
        return rtnUrl;
    }


    /**
     * 과제관리 > 국책과제 > 정산 저장
     *
     * @param input HashMap<String, Object>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return ModelAndView
     * */
    @RequestMapping(value="/prj/tss/nat/updateNatTssStoa.do")
    public ModelAndView updateNatTssStoa(@RequestParam HashMap<String, Object> input, HttpServletRequest request, HttpServletResponse response,
            HttpSession session, ModelMap model) {

        LOGGER.debug("###########################################################");
        LOGGER.debug("updateNatTssStoa [과제관리 > 국책과제 > 정산 저장]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSessionObjRUI(input, session, model);

        ModelAndView modelAndView = new ModelAndView("ruiView");

        List<Map<String, Object>> ds = null;

        try {
            ds  = RuiConverter.convertToDataSet(request, "stoaDataSet");
            natTssService.updateNatTssStoa(ds.get(0));

            ds.get(0).put("rtCd", "SUCCESS");
            ds.get(0).put("rtVal",messageSourceAccessor.getMessage("msg.alert.saved")); //저장되었습니다.
        } catch(Exception e) {
            e.printStackTrace();
            ds.get(0).put("rtCd", "FAIL");
            ds.get(0).put("rtVal", messageSourceAccessor.getMessage("msg.alert.error")); //오류가 발생하였습니다.
        }

        modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", ds));

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
    @RequestMapping(value="/prj/tss/nat/natTssItgSrch.do")
    public String natTssItgSrch(@RequestParam HashMap<String, String> input, HttpServletRequest request,
            HttpSession session, ModelMap model) throws JSONException {

        LOGGER.debug("###########################################################");
        LOGGER.debug("natTssItgSrch [ 통합검색 ]");
        LOGGER.debug("###########################################################");

        checkSession(input, session, model);

        if(pageMoveChkSession(input.get("_userId"))) {
            Map<String, Object> resultMst  = genTssPlnService.retrieveGenTssPlnMst(input);  //마스터
            Map<String, Object> resultSmry = natTssService.retrieveNatTssPlnSmry(input); //개요

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

        return "web/prj/tss/nat/natTssItgSrch";
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
