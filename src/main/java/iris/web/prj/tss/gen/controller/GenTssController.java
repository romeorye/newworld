package iris.web.prj.tss.gen.controller;

import java.util.ArrayList;
import java.util.Calendar;
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
import iris.web.system.attach.service.AttachFileService;
import iris.web.system.base.IrisBaseController;

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
public class GenTssController  extends IrisBaseController {

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

    static final Logger LOGGER = LogManager.getLogger(GenTssController.class);


    /**
     * 과제관리 > 일반과제 리스트 화면
     *
     * @param input HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return String
     * */
    @RequestMapping(value="/prj/tss/gen/genTssList.do")
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

        return "web/prj/tss/gen/genTssList";
    }


    /**
     * 과제관리 > 일반과제 리스트 조회
     *
     * @param input HashMap<String, Object>
     * @param request HttpServletRequest
     * @param response HttpServletResponse
     * @param session HttpSession
     * @param model ModelMap
     * @return ModelAndView
     * */
    @SuppressWarnings("unchecked")
    @RequestMapping(value="/prj/tss/gen/retrieveGenTssList.do")
    public ModelAndView retrieveGenTssList(@RequestParam HashMap<String, Object> input, HttpServletRequest request,
            HttpServletResponse response, HttpSession session, ModelMap model) {

    	checkSessionObjRUI(input, session, model);
    	
        LOGGER.debug("###########################################################");
        LOGGER.debug("retrievefGenTssList - retrieveGenTssList [과제관리 > 일반과제 리스트 조회]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");


        ModelAndView modelAndView = new ModelAndView("ruiView");

        input = StringUtil.toUtf8(input);

        Map<String, Object> role = tssUserService.getTssListRoleChk(input);
        input.put("tssRoleType", role.get("tssRoleType"));
        input.put("tssRoleCd",   role.get("tssRoleCd"));

        List<Map<String,Object>> list = genTssService.retrieveGenTssList(input);

        modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", list));

        return modelAndView;
    }


    /**
     * 과제검색 팝업 화면
     *
     * @param input HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return String
     * @throws JSONException
     * */
    @RequestMapping(value="/prj/tss/com/tssSearchPopup.do")
    public String tssSearchPopup(@RequestParam HashMap<String, String> input, HttpServletRequest request,
            HttpSession session, ModelMap model) throws JSONException {

        LOGGER.debug("###########################################################");
        LOGGER.debug("tssSearchPopup [과제검색 팝업 화면]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSession(input, session, model);

        if(pageMoveChkSession(input.get("_userId"))) {
            List<Map<String, Object>> result = genTssService.retrieveTssPopupList(input);

            JSONObject obj = new JSONObject();
            obj.put("records", result);

            request.setAttribute("inputData", input);
            request.setAttribute("resultCnt", result == null ? 0 : result.size());
            request.setAttribute("result", obj);
        }

        return "web/prj/tss/com/tssSearchPopup";
    }


    /**
     * 과제검색 팝업 조회
     *
     * @param input HashMap<String, Object>
     * @param request HttpServletRequest
     * @param response HttpServletResponse
     * @param session HttpSession
     * @param model ModelMap
     * @return ModelAndView
     * */
    @SuppressWarnings("unchecked")
    @RequestMapping(value="/prj/tss/com/retrieveTssSearchPopup.do")
    public ModelAndView retrieveTssSearchPopup(@RequestParam HashMap<String, String> input, HttpServletRequest request,
            HttpServletResponse response, HttpSession session, ModelMap model) {

        LOGGER.debug("###########################################################");
        LOGGER.debug("retrieveTssSearchPopup [과제검색 팝업 조회]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSessionRUI(input, session, model);

        ModelAndView modelAndView = new ModelAndView("ruiView");

        input = StringUtil.toUtf8(input);

        List<Map<String,Object>> list = genTssService.retrieveTssPopupList(input);

        modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", list));

        return modelAndView;
    }


    /**
     * WBS 간트차트
     * @param input
     * @param request
     * @param session
     * @param model
     * @return
     * @throws JSONException
     */
    @RequestMapping(value="/prj/tss/gen/genWbsGanttChartPopup.do")
    public String genWbsGanttChartPopup(@RequestParam HashMap<String, String> input, HttpServletRequest request,
            HttpSession session, ModelMap model) throws JSONException {


        LOGGER.debug("###########################################################");
        LOGGER.debug("genWbsGanttChartPopup : retrieveGenTssPlnWBS [과제관리 > 일반과제 > 계획 > WBS 조회]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");


        checkSession(input, session, model);

        if(pageMoveChkSession(input.get("_userId"))) {
            List<Map<String, Object>> result = genTssPlnService.retrieveGenTssPlnWBS(input);

            JSONObject obj = new JSONObject();
            obj.put("records", result);

            request.setAttribute("inputData", input);
            request.setAttribute("resultCnt", result == null ? 0 : result.size());
            request.setAttribute("result", obj);
            request.setAttribute("rstList", result);
        }

        return "web/prj/tss/com/genWbsGanttChartPopup";
    }


    /**
     * 참여연구원 목록 조회
     *
     * @param input HashMap<String, Object>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return ModelAndView
     * */
    @RequestMapping(value="/prj/tss/gen/retrieveChargeMbr.do")
    public ModelAndView retrieveChargeMbr(
            @RequestParam HashMap<String, String> input,
            HttpServletRequest request,
            HttpServletResponse response,
            HttpSession session,
            ModelMap model
            ){

        LOGGER.debug("###########################################################");
        LOGGER.debug("retrieveChargeMbr []");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");


        ModelAndView modelAndView = new ModelAndView("ruiView");

        List chargeMbrList = genTssService.retrieveChargeMbr(NullUtil.nvl(input.get("tssCd"), ""));

        modelAndView.addObject("chargeMbrList", RuiConverter.createDataset("chargeMbrList", chargeMbrList));

        return modelAndView;
    }


    /**
     * 현재년도의 +10 ~ -10 구하기
     *
     * @param input HashMap<String, Object>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return ModelAndView
     * */
    @RequestMapping(value="/prj/tss/gen/retrieveGenTssGoalYy.do")
    public ModelAndView retrieveGenTssPlnGoalYy(
            @RequestParam HashMap<String, String> input,
            HttpServletRequest request,
            HttpServletResponse response,
            HttpSession session,
            ModelMap model
            ){

        LOGGER.debug("###########################################################");
        LOGGER.debug("retrieveGenTssPlnGoalYy []");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");


        ModelAndView modelAndView = new ModelAndView("ruiView");

        Calendar cal = Calendar.getInstance();

        int year = cal.get(Calendar.YEAR);

        List<Map<String, Object>> goalYy = new ArrayList<Map<String, Object>>();
        Map<String, Object> map = null;

        for(int i = year - 10; i < year + 10; i++) {
            map = new HashMap<String, Object>();
            map.put("goalYy", i);
            goalYy.add(map);
        }

        modelAndView.addObject("goalYyList", RuiConverter.createDataset("goalYy", goalYy));

        return modelAndView;
    }


    /**
     * 품의서요청 생성
     *
     * @param input HashMap<String, Object>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return ModelAndView
     * */
    @RequestMapping(value="/prj/tss/gen/insertGenTssCsusRq.do")
    public ModelAndView insertGenTssCsusRq(@RequestParam HashMap<String, Object> input, @RequestParam HashMap<String, String> sInput, HttpServletRequest request, HttpServletResponse response,
            HttpSession session, ModelMap model) {

        LOGGER.debug("###########################################################");
        LOGGER.debug("insertGenTssCsusRq [과제관리 > 일반과제 > 품의서요청 생성]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSessionObjRUI(input, session, model);

        ModelAndView modelAndView = new ModelAndView("ruiView");

        List<Map<String, Object>> ds = null;

        try {
            ds  = RuiConverter.convertToDataSet(request, "dataSet");

            HashMap<String, String> mstMap = new HashMap<String, String>();
            mstMap.put("tssCd", String.valueOf(ds.get(0).get("tssCd")));

            Map<String, Object> resultMst = genTssPlnService.retrieveGenTssPlnMst(mstMap);
            String pgsStepCd = String.valueOf(resultMst.get("pgsStepCd"));
            String tssSt     = String.valueOf(resultMst.get("tssSt"));
            
            boolean setpYn = true;
            if("DC".equals(pgsStepCd) || "CM".equals(pgsStepCd)) {
                if(!"100".equals(tssSt) && !"102".equals(tssSt) && !"500".equals(tssSt) && !"600".equals(tssSt)) {
                    setpYn = false;
                    ds.get(0).put("rtCd", "FAIL");
                    ds.get(0).put("rtVal", "이미 품의가 요청되었습니다.(in.server)");
                }
            }

            if(setpYn) {
                genTssService.insertGenTssCsusRq(ds.get(0));

                ds.get(0).put("rtCd", "SUCCESS");
                ds.get(0).put("rtVal", "결재요청 되었습니다.");
            }
        } catch(Exception e) {
            e.printStackTrace();
            ds.get(0).put("rtCd", "FAIL");
            ds.get(0).put("rtVal", messageSourceAccessor.getMessage("msg.alert.error")); //오류가 발생하였습니다.
        }

        modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", ds));

        return modelAndView;
    }


    /**
     * 품의서요청 수정
     *
     * @param input HashMap<String, Object>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return ModelAndView
     * */
    @RequestMapping(value="/prj/tss/gen/updateGenTssCsusRq.do")
    public ModelAndView updateGenTssCsusRq(@RequestParam HashMap<String, Object> input, @RequestParam HashMap<String, String> sInput, HttpServletRequest request, HttpServletResponse response,
            HttpSession session, ModelMap model) {

        LOGGER.debug("###########################################################");
        LOGGER.debug("updateGenTssCsusRq [과제관리 > 일반과제 > 품의서요청 수정]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSessionObjRUI(input, session, model);

        ModelAndView modelAndView = new ModelAndView("ruiView");

        List<Map<String, Object>> ds = null;

        try {
            ds  = RuiConverter.convertToDataSet(request, "dataSet");

            HashMap<String, String> mstMap = new HashMap<String, String>();
            mstMap.put("tssCd", String.valueOf(ds.get(0).get("tssCd")));

            Map<String, Object> resultMst = genTssPlnService.retrieveGenTssPlnMst(mstMap);
            String pgsStepCd = String.valueOf(resultMst.get("pgsStepCd"));
            String tssSt     = String.valueOf(resultMst.get("tssSt"));
            String initFlowYn = String.valueOf(resultMst.get("initFlowYn"));

            boolean setpYn = true;
            if("DC".equals(pgsStepCd) || "CM".equals(pgsStepCd)) {
                if(!"100".equals(tssSt) && !"500".equals(tssSt) && !"600".equals(tssSt)) {
                    setpYn = false;
                    ds.get(0).put("rtCd", "FAIL");
                    ds.get(0).put("rtVal", "이미 품의가 요청되었습니다.(up.server)");
                }
            }

            if(setpYn) {
                ds.get(0).put("tssSt", tssSt);
                genTssService.updateGenTssCsusRq(ds.get(0));

                ds.get(0).put("rtCd", "SUCCESS");
                ds.get(0).put("rtVal","결재요청 되었습니다.");
            }
        } catch(Exception e) {
            e.printStackTrace();
            ds.get(0).put("rtCd", "FAIL");
            ds.get(0).put("rtVal", messageSourceAccessor.getMessage("msg.alert.error")); //오류가 발생하였습니다.
        }

        modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", ds));

        return modelAndView;
    }


    /**
     * 탭별 등록여부 갯수로 확인
     *
     * @param input HashMap<String, Object>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return ModelAndView
     * @throws JSONException
     * */
    @RequestMapping(value="/prj/tss/gen/getTssRegistCnt.do")
    public ModelAndView getTssRegistCnt(@RequestParam HashMap<String, Object> input, @RequestParam HashMap<String, String> sInput, HttpServletRequest request, HttpServletResponse response,
            HttpSession session, ModelMap model) throws JSONException {

        LOGGER.debug("###########################################################");
        LOGGER.debug("getTssRegistCnt []");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSessionObjRUI(input, session, model);

        ModelAndView modelAndView = new ModelAndView("ruiView");

        Map<String, Object> resultMap = null;

        try {
            HashMap<String, String> map = new HashMap<String, String>();
            map.put("tssCd", String.valueOf(input.get("tssCd")));
            map.put("pgTssCd", String.valueOf(input.get("pgTssCd")));

            resultMap = genTssService.getTssRegistCnt(map);

            resultMap.put("rtCd", "SUCCESS");
            resultMap.put("gbn", String.valueOf(input.get("gbn")));
        } catch(Exception e) {
            e.printStackTrace();
            resultMap.put("rtCd", "FAIL");
            resultMap.put("rtVal", messageSourceAccessor.getMessage("msg.alert.error")); //오류가 발생하였습니다.
        }

        modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", resultMap));

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
    @RequestMapping(value="/prj/tss/gen/genTssItgSrch.do")
    public String genTssItgSrch(@RequestParam HashMap<String, String> input, HttpServletRequest request,
            HttpSession session, ModelMap model) throws JSONException {

        LOGGER.debug("###########################################################");
        LOGGER.debug("genTssItgSrch [ 통합검색 ]");
        LOGGER.debug("###########################################################");

        checkSession(input, session, model);

        if(pageMoveChkSession(input.get("_userId"))) {
            Map<String, Object> resultMst  = genTssPlnService.retrieveGenTssPlnMst(input); //마스터
            Map<String, Object> resultSmry = genTssPlnService.retrieveGenTssPlnSmry(input); //개요

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

        return "web/prj/tss/gen/genTssItgSrch";
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
