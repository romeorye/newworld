package iris.web.prj.tss.ousdcoo.controller;

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
import org.springframework.web.servlet.ModelAndView;

import devonframe.message.saymessage.SayMessage;
import devonframe.util.NullUtil;
import iris.web.common.code.service.CodeService;
import iris.web.common.converter.RuiConverter;
import iris.web.common.util.MimeDecodeException;
import iris.web.common.util.StringUtil;
import iris.web.knld.pub.service.OutsideSpecialistService;
import iris.web.prj.rsst.service.PrjRsstMstInfoService;
import iris.web.prj.tss.com.service.TssUserService;
import iris.web.prj.tss.gen.service.GenTssPlnService;
import iris.web.prj.tss.gen.service.GenTssService;
import iris.web.prj.tss.ousdcoo.service.OusdCooTssPlnService;
import iris.web.prj.tss.ousdcoo.service.OusdCooTssService;
import iris.web.system.attach.service.AttachFileService;
import iris.web.system.base.IrisBaseController;

/********************************************************************************
 * NAME : OusdCooTssPlnController.java
 * DESC : 프로젝트 - 과제관리 - 대외협력과제 계획(Pln) controller
 * PROJ : IRIS 구축 프로젝트
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION
 * ----------  ------  ---------------------------------------------------------
 * 2017.09.18  IRIS04	최초생성
 *********************************************************************************/

@Controller
public class OusdCooTssPlnController  extends IrisBaseController {

    @Resource(name="messageSourceAccessor")
    private MessageSourceAccessor messageSourceAccessor;

    @Resource(name = "prjRsstMstInfoService")
    private PrjRsstMstInfoService prjRsstMstInfoService; /* 프로젝트 마스터 서비스 */

    @Resource(name = "tssUserService")
    private TssUserService tssUserService;

    @Resource(name = "genTssService")
    private GenTssService genTssService;

    @Resource(name = "ousdCooTssPlnService")
    private OusdCooTssPlnService ousdCooTssPlnService;

    @Resource(name = "ousdCooTssService")
    private OusdCooTssService ousdCooTssService;			    // 대외협력과제 서비스

    @Resource(name = "genTssPlnService")
    private GenTssPlnService genTssPlnService;			        // 일반과제 계획 서비스

    @Resource(name = "outsideSpecialistService")
    private OutsideSpecialistService outsideSpecialistService;	// 사외전문가 서비스

    @Resource(name = "attachFileService")
    private AttachFileService attachFileService;			    // 공통파일 서비스


    @Resource(name = "codeService")
    private CodeService codeService;

    static final Logger LOGGER = LogManager.getLogger(OusdCooTssPlnController.class);


    //================================================================================================ 마스터
    /**
     * 과제관리 > 대외협력과제 > 계획 > 마스터 조회
     *
     * @param input HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return String
     * @throws JSONException
     * */
    @RequestMapping(value="/prj/tss/ousdcoo/ousdCooTssPlnDetail.do")
    public String retrieveOusdCooTssPlnMst(@RequestParam HashMap<String, String> input, HttpServletRequest request,
            HttpSession session, ModelMap model) throws JSONException {
        LOGGER.debug("###################################################################");
        LOGGER.debug("retrieveOusdCooTssPlnMst [과제관리 > 대외협력과제 > 계획 > 마스터 조회]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###################################################################");

        checkSession(input, session, model);

        if(pageMoveChkSession(input.get("_userId"))) {
            //데이터 있을 경우
            Map<String, Object> result = new HashMap<String, Object>();
            if(!"".equals(NullUtil.nvl(input.get("tssCd"), "") )) {
                result = genTssPlnService.retrieveGenTssPlnMst(input);
            }

            //사용자권한
            Map<String, Object> role = tssUserService.getTssBtnRoleChk(input, result);
            result.put("tssRoleType", "W");
            result.put("tssRoleId",   role.get("tssRoleId"));

            //사용자조직
            HashMap<String, Object> userMap = new HashMap<String, Object>();
            userMap.put("deptCd", input.get("_teamDept"));

            userMap = genTssService.retrievePrjSearch(userMap);

            //마스터 데이터
            List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
            list.add(result);

            JSONObject obj = new JSONObject();
            obj.put("records", list);

            request.setAttribute("inputData", input);
            request.setAttribute("resultCnt", result == null ? 0 : result.size());
            request.setAttribute("result", obj);
            model.addAttribute("userMap", userMap);
        }

        return "web/prj/tss/ousdcoo/pln/ousdCooTssPlnDetail";
    }

    /**
     * 과제관리 > 대외협력과제 > 계획 > 마스터 조회
     *
     * @param input HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return String
     * */
    @RequestMapping(value="/prj/tss/ousdcoo/retrieveOusdCooTssPlnrMst.do")
    public ModelAndView retrieveOusdCooTssPlnrMst(@RequestParam HashMap<String, String> input, HttpServletRequest request,
            HttpSession session, ModelMap model) {
        LOGGER.debug("########################################################################");
        LOGGER.debug("retrieveOusdCooTssAltrMst [과제관리 > 대외협력과제 > 계획 > 마스터 조회]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("#########################################################################");

        checkSessionRUI(input, session, model);
        ModelAndView modelAndView = new ModelAndView("ruiView");

        Map<String, Object> result = genTssPlnService.retrieveGenTssPlnMst(input);

        List<Map<String, Object>> resultList = new ArrayList<Map<String, Object>>();
        resultList.add(result);

        modelAndView.addObject("dataset", RuiConverter.createDataset("dataset", resultList));
        return modelAndView;
    }

    /**
     * 과제관리 > 대외협력과제 > 계획 > 마스터 신규
     *
     * @param input HashMap<String, Object>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return ModelAndView
     * */
    @RequestMapping(value="/prj/tss/ousdcoo/insertOusdCooTssPlnMst.do")
    public ModelAndView insertOusdCooTssPlnMst(@RequestParam HashMap<String, Object> input, HttpServletRequest request,
            HttpSession session, ModelMap model) {
        LOGGER.debug("#####################################################################");
        LOGGER.debug("insertOusdCooTssPlnMst [과제관리 > 대외협력과제 > 계획 > 마스터 신규]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("#####################################################################");

        checkSessionObjRUI(input, session, model);
        ModelAndView modelAndView = new ModelAndView("ruiView");

        HashMap<String, Object> mstDs  = null;
        HashMap<String, Object> smryDs = null;
        HashMap<String, Object> smryDecodeDs = null;
        try {
            mstDs  = (HashMap<String, Object>) RuiConverter.convertToDataSet(request, "mstDataSet").get(0);
            smryDs = (HashMap<String, Object>) RuiConverter.convertToDataSet(request, "smryDataSet").get(0);

            HashMap<String, Object> getWbs = genTssService.getWbsCdStd("prj.tss.com.getWbsCdStd", mstDs);

            if(getWbs == null || getWbs.size() <= 0) {
                mstDs.put("rtCd", "FAIL");
                mstDs.put("rtVal", "상위사업부코드 또는 Project약어를 먼저 생성해 주시기 바랍니다.");
            }
            else {
                //SEED WBS_CD 생성
                int seqMax = Integer.parseInt(String.valueOf(getWbs.get("seqMax")));
                String seqMaxS = String.valueOf(seqMax + 1);
                mstDs.put("wbsCd", "O" + seqMaxS);

                // 특수문자 변환 INPUT
                StringUtil.toUtf8Input(smryDs);

                ousdCooTssPlnService.insertOusdCooTssPlnMst(mstDs,smryDs);

                mstDs.put("rtCd", "SUCCESS");
                mstDs.put("rtVal",messageSourceAccessor.getMessage("msg.alert.saved")); //저장되었습니다.
                mstDs.put("rtType", "I");
            }
        } catch(MimeDecodeException e) {
            LOGGER.debug("MimeDecodeException ERROR");
            e.printStackTrace();
            mstDs.put("rtCd", "FAIL");
            mstDs.put("rtVal", messageSourceAccessor.getMessage("msg.alert.imageUploadError")); //이미지파일 등록에 실패했습니다.
        } catch(Exception e) {
            e.printStackTrace();
            mstDs.put("rtCd", "FAIL");
            mstDs.put("rtVal", messageSourceAccessor.getMessage("msg.alert.error")); //오류가 발생하였습니다.
        }

        modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", mstDs));

        return modelAndView;
    }


    /**
     * 과제관리 > 대외협력과제 > 계획 > 마스터 수정
     *
     * @param input HashMap<String, Object>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return ModelAndView
     * */
    @RequestMapping(value="/prj/tss/ousdcoo/updateOusdCooTssPlnMst.do")
    public ModelAndView updateOusdCooTssPlnMst(@RequestParam HashMap<String, Object> input, HttpServletRequest request,
            HttpSession session, ModelMap model) {

        LOGGER.debug("#####################################################################");
        LOGGER.debug("updateOusdCooTssPlnMst [과제관리 > 대외협력과제 > 계획 > 마스터 수정]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("#####################################################################");

        checkSessionObjRUI(input, session, model);

        ModelAndView modelAndView = new ModelAndView("ruiView");

        HashMap<String, Object> mstDs  = new HashMap<String, Object>();
        HashMap<String, Object> smryDs = new HashMap<String, Object>();
        HashMap<String, Object> smryDecodeDs = null;

        try {
            List<Map<String, Object>> mstDsList  = RuiConverter.convertToDataSet(request, "mstDataSet");
            List<Map<String, Object>> smryDsList = RuiConverter.convertToDataSet(request, "smryDataSet");

            mstDs = (HashMap<String, Object>) mstDsList.get(0);
            smryDs = (HashMap<String, Object>) smryDsList.get(0);

            //1. wbsCd 체크
            boolean errYn   = false;
            boolean upWbsCd = false;

            if(!errYn) {
                // 특수문자 변환 INPUT
                iris.web.common.util.StringUtil.toUtf8Input(smryDs);

                ousdCooTssPlnService.updateOusdCooTssPlnMst(mstDs, smryDs, upWbsCd);
                
                mstDs.put("rtCd", "SUCCESS");
                mstDs.put("rtVal",messageSourceAccessor.getMessage("msg.alert.saved")); //저장되었습니다.
            }
        } catch(MimeDecodeException e) {
            LOGGER.debug("MimeDecodeException ERROR");
            e.printStackTrace();
            mstDs.put("rtCd", "FAIL");
            mstDs.put("rtVal", messageSourceAccessor.getMessage("msg.alert.imageUploadError")); //이미지파일 등록에 실패했습니다.
        } catch(Exception e) {
            e.printStackTrace();
            mstDs.put("rtCd", "FAIL");
            mstDs.put("rtVal", messageSourceAccessor.getMessage("msg.alert.error")); //오류가 발생하였습니다.
        }

        modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", mstDs));

        return modelAndView;
    }


    /**
     * 과제관리 > 대외협력과제 > 계획 > 삭제
     *
     * @param input HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return ModelAndView
     * */
    @RequestMapping(value="/prj/tss/ousdcoo/deleteOusdCooTssPlnMst.do")
    public ModelAndView deleteOusdCooTssPlnMst(@RequestParam HashMap<String, String> input, HttpServletRequest request,
            HttpSession session, ModelMap model) {

        LOGGER.debug("###########################################################");
        LOGGER.debug("deleteOusdCooTssPlnMst [과제관리 > 대외협력과제 > 계획 > 삭제]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSessionRUI(input, session, model);

        ModelAndView modelAndView = new ModelAndView("ruiView");

        HashMap<String, Object> mstDs  = new HashMap<String, Object>();

        try {
            ousdCooTssService.deleteOusdCooTssPlnMst(input);

            mstDs.put("rtCd", "SUCCESS");
            mstDs.put("rtVal","삭제되었습니다."); //삭제되었습니다.

        }catch(Exception e) {
            e.printStackTrace();
            mstDs.put("rtCd", "FAIL");
            mstDs.put("rtVal", messageSourceAccessor.getMessage("msg.alert.error")); //오류가 발생하였습니다.
        }

        modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", mstDs));

        return modelAndView;
    }


    //================================================================================================ 개요
    /**
     * 과제관리 > 대외협력과제 > 계획 > 개요 iframe 조회
     *
     * @param input HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return String
     * @throws JSONException
     * */
    @SuppressWarnings("rawtypes")
    @RequestMapping(value="/prj/tss/ousdcoo/ousdCooTssPlnSmryIfm.do")
    public String retrieveOusdCooTssPlnSmry(@RequestParam HashMap<String, String> input, HttpServletRequest request,
            HttpSession session, ModelMap model) throws JSONException {

        LOGGER.debug("######################################################################");
        LOGGER.debug("retrieveOusdCooTssPlnSmry [과제관리 > 대외협력과제 > 계획 > 개요 조회]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("######################################################################");

        checkSession(input, session, model);

        if(pageMoveChkSession(input.get("_userId"))) {
            //데이터 있을 경우
            Map<String, Object> result = null;
            if(!"".equals(input.get("tssCd"))) {
                result = ousdCooTssService.retrieveOusdCooTssSmry(input);

                // 특수문자 변환 OUTPUT
                if( result != null && !result.isEmpty() ) {
                    iris.web.common.util.StringUtil.toUtf8Output((HashMap) result);
                }
            }

            List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();

            list.add(result);

            JSONObject obj = new JSONObject();
            obj.put("records", list);

            request.setAttribute("inputData", input);
            request.setAttribute("resultCnt", result == null ? 0 : result.size());
            request.setAttribute("result", obj);
        }

        return "web/prj/tss/ousdcoo/pln/ousdCooTssPlnSmryIfm";
    }



    //================================================================================================ 참여연구원
    /**
     * 과제관리 > 대외협력과제 > 계획 > 참여연구원 iframe 화면
     *
     * @param input HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return String
     * @throws JSONException
     * */
    @RequestMapping(value="/prj/tss/ousdcoo/ousdCooTssPlnPtcRsstMbrIfm.do")
    public String ousdCooTssPlnPtcRsstMbrIfm(@RequestParam HashMap<String, String> input, HttpServletRequest request,
            HttpSession session, ModelMap model) throws JSONException {
        LOGGER.debug("#####################################################################################");
        LOGGER.debug("ousdCooTssPlnPtcRsstMbrIfm [과제관리 > 대외협력과제 > 계획 > 참여연구원 iframe 화면 ]");
        LOGGER.debug("#####################################################################################");

        checkSession(input, session, model);

        if(pageMoveChkSession(input.get("_userId"))) {
            List <Map<String, Object>> codeRtcRole  = codeService.retrieveCodeValueList("PTC_ROLE"); //참여역할

            model.addAttribute("codeRtcRole", codeRtcRole);

            //데이터 있을 경우
            List<Map<String, Object>> result = null;
            if(!"".equals(input.get("tssCd"))) {
                result = genTssPlnService.retrieveGenTssPlnPtcRsstMbr(input);
            }

            JSONObject obj = new JSONObject();
            obj.put("records", result);

            request.setAttribute("resultCnt", result == null ? 0 : result.size());
            request.setAttribute("result", obj);

            model.addAttribute("inputData", input);
        }

        return "web/prj/tss/ousdcoo/pln/ousdCooTssPlnPtcRsstMbrIfm";
    }

    /**
     * 과제관리 > 대외협력과제 > 계획 > 참여연구원 조회
     *
     * @param input HashMap<String, Object>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return ModelAndView
     * */
    @RequestMapping(value="/prj/tss/ousdcoo/retrieveOusdCooTssPlnPtcRsstMbr.do")
    public ModelAndView retrieveOusdCooTssPlnPtcRsstMbr(@RequestParam HashMap<String, String> input, HttpServletRequest request, HttpServletResponse response,
            HttpSession session, ModelMap model) {

        LOGGER.debug("###################################################################################");
        LOGGER.debug("retrieveOusdCooTssPlnPtcRsstMbr [과제관리 > 대외협력과제 > 계획 > 참여연구원 조회]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###################################################################################");

        checkSessionRUI(input, session, model);

        ModelAndView modelAndView = new ModelAndView("ruiView");

        List<Map<String, Object>> ds = null;

        try {
            ds = genTssPlnService.retrieveGenTssPlnPtcRsstMbr(input);

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
     * 과제관리 > 대외협력과제 > 계획 > 참여연구원 저장
     *
     * @param input HashMap<String, Object>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return ModelAndView
     * */
    @RequestMapping(value="/prj/tss/ousdcoo/updateOusdCooTssPlnPtcRsstMbr.do")
    public ModelAndView updateOusdCooTssPlnPtcRsstMbr(@RequestParam HashMap<String, Object> input, HttpServletRequest request, HttpServletResponse response,
            HttpSession session, ModelMap model) {

        LOGGER.debug("###########################################################");
        LOGGER.debug("updateOusdCooTssPlnPtcRsstMbr [과제관리 > 대외협력과제 > 계획 > 참여연구원 저장]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSessionObjRUI(input, session, model);

        ModelAndView modelAndView = new ModelAndView("ruiView");

        List<Map<String, Object>> ds = null;

        try {
            ds  = RuiConverter.convertToDataSet(request, "mbrDataSet");
            genTssPlnService.updateGenTssPlnPtcRsstMbr(ds);

            ds.get(0).put("rtCd", "SUCCESS");
            ds.get(0).put("rtVal",messageSourceAccessor.getMessage("msg.alert.saved")); //저장되었습니다.
        } catch(Exception e) {
            //            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            e.printStackTrace();
            ds.get(0).put("rtCd", "FAIL");
            ds.get(0).put("rtVal", messageSourceAccessor.getMessage("msg.alert.error")); //오류가 발생하였습니다.
        }

        modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", ds));

        return modelAndView;
    }


    /**
     * 과제관리 > 대외협력과제 > 계획 > 참여연구원 삭제
     *
     * @param input HashMap<String, Object>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return ModelAndView
     * */
    @RequestMapping(value="/prj/tss/ousdcoo/deleteOusdCooTssPlnPtcRsstMbr.do")
    public ModelAndView deleteOusdCooTssPlnPtcRsstMbr(@RequestParam HashMap<String, Object> input, HttpServletRequest request, HttpServletResponse response,
            HttpSession session, ModelMap model) {

        LOGGER.debug("###########################################################");
        LOGGER.debug("deleteOusdCooTssPlnPtcRsstMbr [과제관리 > 대외협력과제 > 계획 > 참여연구원 삭제]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSessionObjRUI(input, session, model);

        ModelAndView modelAndView = new ModelAndView("ruiView");

        List<Map<String, Object>> ds = null;

        try {
            ds  = RuiConverter.convertToDataSet(request, "mbrDataSet");
            genTssPlnService.deleteGenTssPlnPtcRsstMbr(ds);

            ds.get(0).put("rtCd", "SUCCESS");
            ds.get(0).put("rtVal",messageSourceAccessor.getMessage("msg.alert.saved")); //저장되었습니다.
        } catch(Exception e) {
            //            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            e.printStackTrace();
            ds.get(0).put("rtCd", "FAIL");
            ds.get(0).put("rtVal", messageSourceAccessor.getMessage("msg.alert.error")); //오류가 발생하였습니다.
        }

        modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", ds));

        return modelAndView;
    }

    //================================================================================================ 목표및산출물
    /**
     * 과제관리 > 대외협력과제 > 계획 > 목표및산출물 iframe 화면
     *
     * @param input HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return String
     * @throws JSONException
     * */
    @RequestMapping(value="/prj/tss/ousdcoo/ousdCooTssPlnGoalYldIfm.do")
    public String ousdCooTssPlnGoalYldIfm(@RequestParam HashMap<String, String> input, HttpServletRequest request,
            HttpSession session, ModelMap model) throws JSONException {

        LOGGER.debug("####################################################################################");
        LOGGER.debug("ousdCooTssPlnGoalYldIfm [과제관리 > 대외협력과제 > 계획 > 목표및산출물 iframe 화면 ]");
        LOGGER.debug("####################################################################################");

        checkSession(input, session, model);

        if(pageMoveChkSession(input.get("_userId"))) {
            //데이터 있을 경우
            List<Map<String, Object>> resultGoal = null;
            List<Map<String, Object>> resultYld  = null;

            if(!"".equals(input.get("tssCd"))) {
                resultGoal = genTssPlnService.retrieveGenTssPlnGoal(input);
                // 특수문자 변환 OUTPUT
                if( resultGoal != null && resultGoal.size() > 0 ) {
                    for(int i=0; i< resultGoal.size(); i++) {
                        iris.web.common.util.StringUtil.toUtf8Output((HashMap) resultGoal.get(i));
                    }
                }

                resultYld  = genTssPlnService.retrieveGenTssPlnYld(input);
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

        return "web/prj/tss/ousdcoo/pln/ousdCooTssPlnGoalYldIfm";
    }


    /**
     * 과제관리 > 대외협력과제 > 계획 > 목표및산출물 > 목표 조회
     *
     * @param input HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return String
     * @throws JSONException
     * */
    @RequestMapping(value="/prj/tss/ousdcoo/retrieveOusdCooTssPlnGoal.do")
    public ModelAndView retrieveOusdCooTssPlnGoal(@RequestParam HashMap<String, String> input, HttpServletRequest request,
            HttpSession session, ModelMap model) throws JSONException {

        LOGGER.debug("#####################################################################################");
        LOGGER.debug("retrieveOusdCooTssPlnGoal [과제관리 > 대외협력과제 > 계획 > 목표및산출물 > 목표 조회]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("#####################################################################################");

        checkSessionRUI(input, session, model);
        ModelAndView modelAndView = new ModelAndView("ruiView");

        List<Map<String, Object>> resultGoal = genTssPlnService.retrieveGenTssPlnGoal(input);
        // 특수문자 변환 OUTPUT
        if( resultGoal != null && resultGoal.size() > 0 ) {
            for(int i=0; i< resultGoal.size(); i++) {
                iris.web.common.util.StringUtil.toUtf8Output((HashMap) resultGoal.get(i));
            }
        }
        modelAndView.addObject("dataset", RuiConverter.createDataset("dataset", resultGoal));

        //jsp에 있는 el에 담기위한 쓰레기 데이터
        request.setAttribute("resultGoalCnt", 0);
        request.setAttribute("resultGoal", null);
        request.setAttribute("resultYldCnt", 0);
        request.setAttribute("resultYld", null);

        return modelAndView;
    }


    /**
     * 과제관리 > 대외협력과제 > 계획 > 목표및산출물 > 산출물 조회
     *
     * @param input HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return String
     * @throws JSONException
     * */
    @RequestMapping(value="/prj/tss/ousdcoo/retrieveOusdCooTssPlnYld.do")
    public ModelAndView retrieveOusdCooTssPlnYld(@RequestParam HashMap<String, String> input, HttpServletRequest request,
            HttpSession session, ModelMap model) throws JSONException {

        LOGGER.debug("######################################################################################");
        LOGGER.debug("retrieveOusdCooTssPlnYld [과제관리 > 대외협력과제 > 계획 > 목표및산출물 > 산출물 조회]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("######################################################################################");

        checkSessionRUI(input, session, model);
        ModelAndView modelAndView = new ModelAndView("ruiView");

        List<Map<String, Object>> resultYld = genTssPlnService.retrieveGenTssPlnYld(input);
        modelAndView.addObject("dataset", RuiConverter.createDataset("dataset", resultYld));

        //jsp에 있는 el에 담기위한 쓰레기 데이터
        request.setAttribute("resultGoalCnt", 0);
        request.setAttribute("resultGoal", null);
        request.setAttribute("resultYldCnt", 0);
        request.setAttribute("resultYld", null);

        return modelAndView;
    }


    /**
     * 과제관리 > 대외협력과제 > 계획 > 목표및산출물 > 목표 저장
     *
     * @param input HashMap<String, Object>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return ModelAndView
     * */
    @SuppressWarnings("rawtypes")
    @RequestMapping(value="/prj/tss/ousdcoo/updateOusdCooTssPlnGoal.do")
    public ModelAndView updateOusdCooTssPlnGoal(@RequestParam HashMap<String, Object> input, HttpServletRequest request,
            HttpSession session, ModelMap model) {

        LOGGER.debug("###################################################################################");
        LOGGER.debug("updateOusdCooTssPlnGoal [과제관리 > 대외협력과제 > 계획 > 목표및산출물 > 목표 저장]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###################################################################################");

        checkSessionObjRUI(input, session, model);

        ModelAndView modelAndView = new ModelAndView("ruiView");

        List<Map<String, Object>> ds = null;
        List<Map<String, Object>> dsConvert = new ArrayList<Map<String, Object>>();

        try {
            ds  = RuiConverter.convertToDataSet(request, "goalDataSet");
            // 특수문자 변환 INPUT
            if( ds != null && ds.size() > 0 ) {
                for(int i=0; i< ds.size(); i++) {
                    iris.web.common.util.StringUtil.toUtf8Input((HashMap) ds.get(i));
                }
            }
            genTssPlnService.updateGenTssPlnGoal(ds);

            ds.get(0).put("targetDs", "GOAL");
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
     * 과제관리 > 대외협력과제 > 계획 > 목표및산출물 > 산출물 저장
     *
     * @param input HashMap<String, Object>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return ModelAndView
     * */
    @RequestMapping(value="/prj/tss/ousdcoo/updateOusdCooTssPlnYld.do")
    public ModelAndView updateOusdCooTssPlnYld(@RequestParam HashMap<String, Object> input, HttpServletRequest request,
            HttpSession session, ModelMap model) {

        LOGGER.debug("####################################################################################");
        LOGGER.debug("updateOusdCooTssPlnYld [과제관리 > 대외협력과제 > 계획 > 목표및산출물 > 산출물 저장]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("####################################################################################");

        checkSessionObjRUI(input, session, model);

        ModelAndView modelAndView = new ModelAndView("ruiView");

        List<Map<String, Object>> ds = null;

        try {
            ds  = RuiConverter.convertToDataSet(request, "yldDataSet");
            genTssPlnService.updateGenTssPlnYld(ds);

            ds.get(0).put("targetDs", "YLD");
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
     * 과제관리 > 대외협력과제 > 계획 > 목표및산출물 > 목표 삭제
     *
     * @param input HashMap<String, Object>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return ModelAndView
     * */
    @RequestMapping(value="/prj/tss/ousdcoo/deleteOusdCooTssPlnGoal.do")
    public ModelAndView deleteOusdCooTssPlnGoal(@RequestParam HashMap<String, Object> input, HttpServletRequest request,
            HttpSession session, ModelMap model) {

        LOGGER.debug("###################################################################################");
        LOGGER.debug("deleteOusdCooTssPlnGoal [과제관리 > 대외협력과제 > 계획 > 목표및산출물 > 목표 삭제]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###################################################################################");

        checkSessionObjRUI(input, session, model);

        ModelAndView modelAndView = new ModelAndView("ruiView");

        List<Map<String, Object>> ds = null;

        try {
            ds  = RuiConverter.convertToDataSet(request, "goalDataSet");
            genTssPlnService.deleteGenTssPlnGoal(ds);

            ds.get(0).put("targetDs", "GOAL");
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
     * 과제관리 > 대외협력과제 > 계획 > 목표및산출물 > 산출물 삭제
     *
     * @param input HashMap<String, Object>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return ModelAndView
     * */
    @RequestMapping(value="/prj/tss/ousdcoo/deleteOusdCooTssPlnYld.do")
    public ModelAndView deleteOusdCooTssPlnYld(@RequestParam HashMap<String, Object> input, HttpServletRequest request,
            HttpSession session, ModelMap model) {

        LOGGER.debug("####################################################################################");
        LOGGER.debug("deleteOusdCooTssPlnYld [과제관리 > 대외협력과제 > 계획 > 목표및산출물 > 산출물 삭제]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("####################################################################################");

        checkSessionObjRUI(input, session, model);

        ModelAndView modelAndView = new ModelAndView("ruiView");

        List<Map<String, Object>> ds = null;

        try {
            ds  = RuiConverter.convertToDataSet(request, "yldDataSet");
            genTssPlnService.deleteGenTssPlnYld(ds);

            ds.get(0).put("targetDs", "YLD");
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


    //================================================================================================ 품의서
    @SuppressWarnings("rawtypes")
    /**
     * 과제관리 > 대외협력과제 > 계획 > 품의서요청 화면
     *
     * @param input HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return String
     * @throws JSONException
     * */
    @RequestMapping(value="/prj/tss/ousdcoo/ousdCooTssPlnCsusRq.do")
    public String ousdCooTssPlnCsusRq(@RequestParam HashMap<String, String> input, @RequestParam HashMap<String, Object> inputObj, HttpServletRequest request,
            HttpSession session, ModelMap model) throws JSONException {

        LOGGER.debug("##################################################################################################");
        LOGGER.debug("OusdCooTssController - ousdCooTssPlnGoalYldIfm [과제관리 > 대외협력과제 > 계획 > 품의서요청 화면 ]");
        LOGGER.debug("");
        LOGGER.debug("##################################################################################################");

        checkSession(input, session, model);

        if(pageMoveChkSession(input.get("_userId"))) {
            Map<String, Object> resultMst         = genTssPlnService.retrieveGenTssPlnMst(input); 	         //마스터


            Map<String, Object> resultCsus        = genTssService.retrieveGenTssCsus(resultMst); 			 //품의서
            // 특수문자 변환 OUTPUT
            if( resultCsus != null && !resultCsus.isEmpty() ) {
                iris.web.common.util.StringUtil.toUtf8Output((HashMap) resultCsus);
            }

            List<Map<String, Object>> resultMbr   = genTssPlnService.retrieveGenTssPlnPtcRsstMbr(input);     //참여연구원

            List<Map<String, Object>> resultGoal  = ousdCooTssService.retrieveGenTssPlnGoalNtoBr(input);     //목표기술성과
            // 특수문자 변환 OUTPUT
//            if( resultGoal != null && resultGoal.size() > 0 ) {
//                for(int i=0; i< resultGoal.size(); i++) {
//                        iris.web.common.util.StringUtil.toUtf8Output((HashMap) resultGoal.get(i));
//                }
//            }

            Map<String,Object> resultOsl = null;
            if( !"".equals(inputObj.get("outSpclId")) ) {
                resultOsl = outsideSpecialistService.getOutsideSpecialistInfo(inputObj);                     //협력기관
            }
            Map<String, Object> resultSmry        = ousdCooTssService.retrieveOusdCooTssSmryNtoBr(input);    //개요
            // 특수문자 변환 OUTPUT
            if( resultSmry != null && !resultSmry.isEmpty() ) {
                iris.web.common.util.StringUtil.toUtf8Output((HashMap) resultSmry);
            }

            HashMap<String, Object> inputInfo = new HashMap<String, Object>();
            inputInfo.put("attcFilId", String.valueOf(resultSmry.get("attcFilId")));
            List<Map<String, Object>> resultAttc  =  attachFileService.getAttachFileList(inputInfo);

            model.addAttribute("inputData"  , input);
            model.addAttribute("resultMst"  , resultMst);
            model.addAttribute("resultSmry" , resultSmry);
            model.addAttribute("resultMbr"  , resultMbr);
            model.addAttribute("resultGoal" , resultGoal);
            model.addAttribute("resultOsl"  , resultOsl);
            model.addAttribute("resultAttc" , resultAttc);
            model.addAttribute("resultCsus" , resultCsus);

            //text컬럼을 위한 json변환
            JSONObject obj = new JSONObject();
            obj.put("smry", resultSmry);

            request.setAttribute("resultJson", obj);
        }

        return "web/prj/tss/ousdcoo/pln/ousdCooTssPlnCsusRq";
    }


    /**
     * 과제관리 > 대외협력과제 > 계획 > 품의서요청 생성(사용안함)
     *
     * @param input HashMap<String, Object>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return ModelAndView
     * */
    @SuppressWarnings("rawtypes")
    @RequestMapping(value="/prj/tss/ousdcoo/insertOusdCooTssPlnCsusRq.do")
    public ModelAndView insertOusdCooTssPlnCsusRq(@RequestParam HashMap<String, Object> input, HttpServletRequest request, HttpServletResponse response,
            HttpSession session, ModelMap model) {

        LOGGER.debug("############################################################################");
        LOGGER.debug("insertOusdCooTssPlnCsusRq [과제관리 > 대외협력과제 > 계획 > 품의서요청 생성]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("############################################################################");

        checkSessionObjRUI(input, session, model);

        ModelAndView modelAndView = new ModelAndView("ruiView");

        List<Map<String, Object>> ds = null;

        try {
            ds  = RuiConverter.convertToDataSet(request, "dataSet");

            // 특수문자 변환 INPUT
            if( ds != null && ds.size() > 0 ) {
                iris.web.common.util.StringUtil.toUtf8Input((HashMap) ds.get(0));
            }

            genTssPlnService.insertGenTssPlnCsusRq(ds.get(0));

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
