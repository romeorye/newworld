package iris.web.prj.tss.tctm.controller;

import devonframe.message.saymessage.SayMessage;
import devonframe.util.NullUtil;
import iris.web.common.converter.RuiConverter;
import iris.web.common.util.MimeDecodeException;
import iris.web.common.util.StringUtil;
import iris.web.common.util.TestConsole;
import iris.web.prj.tss.com.service.TssUserService;
import iris.web.prj.tss.gen.service.GenTssPlnService;
import iris.web.prj.tss.gen.service.GenTssService;
import iris.web.prj.tss.ousdcoo.service.OusdCooTssService;
import iris.web.prj.tss.tctm.TctmUrl;
import iris.web.prj.tss.tctm.service.TctmTssService;
import iris.web.system.attach.service.AttachFileService;
import iris.web.system.base.IrisBaseController;
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

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
public class TctmTssController extends IrisBaseController {

    @Resource(name = "messageSourceAccessor")
    private MessageSourceAccessor messageSourceAccessor;

    @Resource(name = "tssUserService")
    private TssUserService tssUserService;

    @Resource(name = "genTssService")
    private GenTssService genTssService;

    @Resource(name = "tctmTssService")
    private TctmTssService tctmTssService;

    @Resource(name = "genTssPlnService")
    private GenTssPlnService genTssPlnService;

    @Resource(name = "ousdCooTssService")
    private OusdCooTssService ousdCooTssService;            // 대외협력과제 서비스


    @Resource(name = "attachFileService")
    private AttachFileService attachFileService; // 공통파일 서비스

    static final Logger LOGGER = LogManager.getLogger(TctmTssController.class);

    /**
     * 과제관리 > 기술팀과제 리스트 화면
     *
     * @param input   HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model   ModelMap
     * @return String
     */
    @RequestMapping(value = TctmUrl.doList)
    public String tctmTssList(@RequestParam HashMap<String, Object> input, HttpServletRequest request, HttpSession session, ModelMap model) {

        checkSessionObjRUI(input, session, model);
        LOGGER.debug("###########################################################");
        LOGGER.debug("TctmTssController - tctmTssList [과제관리 > 기술팀과제 리스트 화면]");
        LOGGER.debug("###########################################################");

        input = StringUtil.toUtf8(input);

        if (pageMoveChkSession((String) input.get("_userId"))) {
            Map<String, Object> role = tssUserService.getTssListRoleChk(input);
            input.put("tssRoleType", role.get("tssRoleType"));
            input.put("tssRoleId", role.get("tssRoleId"));

            model.addAttribute("inputData", input);
        }

        return TctmUrl.jspList;
    }


    /**
     * 과제관리 > 기술팀과제 리스트 조회
     *
     * @param input    HashMap<String, Object>
     * @param request  HttpServletRequest
     * @param response HttpServletResponse
     * @param session  HttpSession
     * @param model    ModelMap
     * @return ModelAndView
     */
    @SuppressWarnings("unchecked")
    @RequestMapping(value = TctmUrl.doSelectList)
    public ModelAndView tctmTssSelectList(@RequestParam HashMap<String, Object> input, HttpServletRequest request,
                                           HttpServletResponse response, HttpSession session, ModelMap model) {

        checkSessionObjRUI(input, session, model);

        LOGGER.debug("###########################################################");
        LOGGER.debug("retrievefGenTssList - retrieveGenTssList [과제관리 > 기술팀과제 리스트 조회]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");


        ModelAndView modelAndView = new ModelAndView("ruiView");

        input = StringUtil.toUtf8(input);

        Map<String, Object> role = tssUserService.getTssListRoleChk(input);
        input.put("tssRoleType", role.get("tssRoleType"));
        input.put("tssRoleCd", role.get("tssRoleCd"));

//        List<Map<String, Object>> list = genTssService.retrieveGenTssList(input);
        List<Map<String, Object>> list = tctmTssService.selectTctmTssList(input);


        modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", list));

        return modelAndView;
    }




    /**
     * 과제관리 > 기술팀과제 > 계획 > 마스터 조회
     *
     * @param input   HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model   ModelMap
     * @return String
     * @throws JSONException
     */
    @RequestMapping(value = TctmUrl.doView)
    public String tctmTssPlnDetail(@RequestParam HashMap<String, String> input, HttpServletRequest request, HttpSession session, ModelMap model) throws JSONException {

        LOGGER.debug("###########################################################");
        LOGGER.debug("tctmTssPlnDetail [과제관리 > 기술팀과제 > 계획 > 마스터 조회]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSession(input, session, model);

        if (pageMoveChkSession(input.get("_userId"))) {
            // 데이터 있을 경우
            Map<String, Object> result = new HashMap<String, Object>();
            if (!"".equals(input.get("tssCd")) && null != input.get("tssCd")) {
//                result = genTssPlnService.retrieveGenTssPlnMst(input);
                result = tctmTssService.selectTctmTssInfo(input);
            }

            result = StringUtil.toUtf8Output((HashMap) result);
            TestConsole.showMap(result);

            // 사용자권한
            Map<String, Object> role = tssUserService.getTssBtnRoleChk(input, result);
            result.put("tssRoleType", "W");
            result.put("tssRoleId", role.get("tssRoleId"));

            // 사용자조직
            HashMap<String, Object> userMap = new HashMap<String, Object>();
            userMap.put("deptCd", input.get("_teamDept"));

            userMap = genTssService.retrievePrjSearch(userMap);

            // 마스터 데이터
            List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
            list.add(result);

            JSONObject obj = new JSONObject();
            obj.put("records", list);



            // 전달
            request.setAttribute("inputData", input);
            request.setAttribute("resultCnt", result == null ? 0 : result.size());
            request.setAttribute("result", obj);
            model.addAttribute("userMap", userMap);
        }

        return TctmUrl.jspView;
    }

    // ================================================================================================
    // 개요

    /**
     * 과제관리 > 기술팀과제 > 계획 > 개요 iframe 조회
     *
     * @param input   HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model   ModelMap
     * @return String
     * @throws JSONException
     */
    @RequestMapping(value = TctmUrl.doTabSum)
    public String tctmTssPlnSmryIfm(@RequestParam HashMap<String, String> input, HttpServletRequest request, HttpSession session, ModelMap model) throws JSONException {

        LOGGER.debug("###########################################################");
        LOGGER.debug("tctmTssPlnSmryIfm [과제관리 > 기술팀과제 > 계획 > 개요 조회]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");


        checkSession(input, session, model);

        if (pageMoveChkSession(input.get("_userId"))) {
            // 데이터 있을 경우
            Map<String, Object> result = null;
            if (!"".equals(input.get("tssCd")) && null != input.get("tssCd")) {
                result = genTssPlnService.retrieveGenTssPlnSmry(input);
            }
            result = StringUtil.toUtf8Output((HashMap) result);

            List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
            list.add(result);

            JSONObject obj = new JSONObject();
            obj.put("records", list);

            request.setAttribute("inputData", input);
            request.setAttribute("resultCnt", result == null ? 0 : result.size());
            request.setAttribute("result", obj);
        }

        return TctmUrl.jspTabSum;
    }

    /**
     * 과제관리 > 기술팀과제 > 계획 > 목표및산출물 iframe 화면
     *
     * @param input   HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model   ModelMap
     * @return String
     * @throws JSONException
     */
    @RequestMapping(value = TctmUrl.doTabGoal)
    public String tctmTssPlnGoalYldIfm(@RequestParam HashMap<String, String> input, HttpServletRequest request, HttpSession session, ModelMap model) throws JSONException {

        LOGGER.debug("###########################################################");
        LOGGER.debug("TctmTssController - tctmTssPlnGoalYldIfm [과제관리 > 기술팀과제 > 계획 > 목표및산출물 iframe 화면 ]");
        LOGGER.debug("###########################################################");

        checkSession(input, session, model);

        if (pageMoveChkSession(input.get("_userId"))) {
            // 데이터 있을 경우
            List<Map<String, Object>> resultGoal = new ArrayList<Map<String, Object>>();
            List<Map<String, Object>> resultYld = new ArrayList<Map<String, Object>>();

            if (!"".equals(input.get("tssCd")) && null != input.get("tssCd")) {
                resultGoal = genTssPlnService.retrieveGenTssPlnGoal(input);
                resultYld = genTssPlnService.retrieveGenTssPlnYld(input);
            }

            for (int i = 0; i < resultGoal.size(); i++) {
                StringUtil.toUtf8Output((HashMap) resultGoal.get(i));
            }
            for (int i = 0; i < resultYld.size(); i++) {
                StringUtil.toUtf8Output((HashMap) resultYld.get(i));
            }

            JSONObject obj1 = new JSONObject();
            obj1.put("records", resultGoal);
            request.setAttribute("resultGoalCnt", resultGoal == null ? 0 : resultGoal.size());
            request.setAttribute("resultGoal", obj1);

            JSONObject obj2 = new JSONObject();
            obj2.put("records", resultYld);
            request.setAttribute("resultYldCnt", resultYld == null ? 0 : resultYld.size());
            request.setAttribute("resultYld", obj2);

            model.addAttribute("inputData", input);
        }

        return TctmUrl.jspTabGoal;
    }


    /**
     * 과제관리 > 기술팀과제 > 계획 > 마스터 신규
     *
     * @param input   HashMap<String, Object>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model   ModelMap
     * @return ModelAndView
     */
    @RequestMapping(value = TctmUrl.doUpdateInfo)
    public ModelAndView tctmTssUpdateInfo(@RequestParam HashMap<String, Object> input, HttpServletRequest request,
                                          HttpSession session, ModelMap model) {

        LOGGER.debug("###########################################################");
        LOGGER.debug("tctmTssUpdateInfo [과제관리 > 기술팀과제 > 계획 > 마스터 신규]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSessionObjRUI(input, session, model);

        ModelAndView modelAndView = new ModelAndView("ruiView");

        HashMap<String, Object> mstDs = null;
        HashMap<String, Object> smryDs = null;
        HashMap<String, Object> smryDecodeDs = null;

        try {
            mstDs = (HashMap<String, Object>) RuiConverter.convertToDataSet(request, "mstDataSet").get(0);
            smryDs = (HashMap<String, Object>) RuiConverter.convertToDataSet(request, "smryDataSet").get(0);

            // deptCode, prjCd, tssScnCd,
            TestConsole.isEmpty("deptCode", mstDs.get("deptCode"));
            TestConsole.isEmpty("prjCd", mstDs.get("prjCd"));
            TestConsole.isEmpty("tssScnCd", mstDs.get("tssScnCd"));
            HashMap<String, Object> getWbs = genTssService.getWbsCdStd("prj.tss.com.getWbsCdStd", mstDs);

            TestConsole.isEmptyMap(mstDs);


            if (getWbs == null || getWbs.size() <= 0) {
                mstDs.put("rtCd", "FAIL");
                mstDs.put("rtVal", "상위사업부코드 또는 Project약어를 먼저 생성해 주시기 바랍니다.");
            } else {
                //SEED WBS_CD 생성
                int seqMax = Integer.parseInt(String.valueOf(getWbs.get("seqMax")));
                String seqMaxS = String.valueOf(seqMax + 1);
                mstDs.put("pkWbsCd", "D" + seqMaxS);


                TestConsole.isEmpty("wbsCd", mstDs.get("wbsCd"));

                smryDecodeDs = (HashMap<String, Object>) ousdCooTssService.decodeNamoEditorMap(input, smryDs); //에디터데이터 디코딩처리

                smryDecodeDs = StringUtil.toUtf8Input(smryDecodeDs);


                TestConsole.isEmptyMap(mstDs);
                TestConsole.isEmptyMap(smryDecodeDs);


                // 과제코드가 없는 경우 생성
                if (mstDs.get("tssCd") == null || mstDs.get("tssCd").equals("")) {
                    String newTssCd = tctmTssService.selectNewTssCdt(mstDs);
                    mstDs.put("tssCd", newTssCd);
                    smryDecodeDs.put("tssCd", newTssCd);
                }

                tctmTssService.updateTctmTssInfo(mstDs);
                tctmTssService.updateTctmTssSmryInfo(smryDecodeDs);
//                genTssPlnService.insertGenTssPlnMst(mstDs, smryDecodeDs);

                mstDs.put("rtCd", "SUCCESS");
                mstDs.put("rtVal", messageSourceAccessor.getMessage("msg.alert.saved")); //저장되었습니다.
                mstDs.put("rtType", "I");
            }
        } catch (MimeDecodeException e) {
            LOGGER.debug("MimeDecodeException ERROR");
            e.printStackTrace();
            mstDs.put("rtCd", "FAIL");
            mstDs.put("rtVal", messageSourceAccessor.getMessage("msg.alert.imageUploadError")); //이미지파일 등록에 실패했습니다.
        } catch (Exception e) {
            e.printStackTrace();
            mstDs.put("rtCd", "FAIL");
            mstDs.put("rtVal", messageSourceAccessor.getMessage("msg.alert.error")); //오류가 발생하였습니다.
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
