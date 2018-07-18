package iris.web.prj.tss.gen.controller;

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
import iris.web.prj.rsst.service.PrjRsstMstInfoService;
import iris.web.prj.tss.com.service.TssUserService;
import iris.web.prj.tss.gen.service.GenTssCmplService;
import iris.web.prj.tss.gen.service.GenTssPlnService;
import iris.web.prj.tss.gen.service.GenTssService;
import iris.web.prj.tss.ousdcoo.service.OusdCooTssService;
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
 * 2017.08.08
 *********************************************************************************/

@Controller
@SuppressWarnings({ "unchecked", "rawtypes" })
public class GenTssPlnController  extends IrisBaseController {

    @Resource(name="messageSourceAccessor")
    private MessageSourceAccessor messageSourceAccessor;

    @Resource(name = "prjRsstMstInfoService")
    private PrjRsstMstInfoService prjRsstMstInfoService; /* 프로젝트 마스터 서비스 */

    @Resource(name = "tssUserService")
    private TssUserService tssUserService;

    @Resource(name = "genTssService")
    private GenTssService genTssService;

    @Resource(name = "genTssPlnService")
    private GenTssPlnService genTssPlnService;

    @Resource(name = "ousdCooTssService")
    private OusdCooTssService ousdCooTssService;			// 대외협력과제 서비스

    @Resource(name = "codeService")
    private CodeService codeService;

    @Resource(name = "genTssCmplService")
    private GenTssCmplService genTssCmplService;

    static final Logger LOGGER = LogManager.getLogger(GenTssPlnController.class);


    //================================================================================================ 마스터
    /**
     * 과제관리 > 일반과제 > 계획 > 마스터 조회
     *
     * @param input HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return String
     * @throws JSONException
     * */
    @RequestMapping(value="/prj/tss/gen/genTssPlnDetail.do")
    public String retrieveGenTssPlnMst(@RequestParam HashMap<String, String> input, HttpServletRequest request,
            HttpSession session, ModelMap model) throws JSONException {

        LOGGER.debug("###########################################################");
        LOGGER.debug("retrieveGenTssPlnMst [과제관리 > 일반과제 > 계획 > 마스터 조회]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSession(input, session, model);

        if(pageMoveChkSession(input.get("_userId"))) {
            //데이터 있을 경우
            Map<String, Object> result = new HashMap<String, Object>();
            if(!"".equals(input.get("tssCd")) && null != input.get("tssCd")) {
                result = genTssPlnService.retrieveGenTssPlnMst(input);
            }
            result = StringUtil.toUtf8Output((HashMap) result);

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

            //전달
            request.setAttribute("inputData", input);
            request.setAttribute("resultCnt", result == null ? 0 : result.size());
            request.setAttribute("result", obj);
            model.addAttribute("userMap", userMap);
        }

        return "web/prj/tss/gen/pln/genTssPlnDetail";
    }


    /**
     * 과제관리 > 일반과제 > 계획 > 마스터 신규
     *
     * @param input HashMap<String, Object>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return ModelAndView
     * */
    @RequestMapping(value="/prj/tss/gen/insertGenTssPlnMst.do")
    public ModelAndView insertGenTssPlnMst(@RequestParam HashMap<String, Object> input, HttpServletRequest request,
            HttpSession session, ModelMap model) {

        LOGGER.debug("###########################################################");
        LOGGER.debug("insertGenTssPlnMst [과제관리 > 일반과제 > 계획 > 마스터 신규]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

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
                mstDs.put("wbsCd", "G" + seqMaxS);

                smryDecodeDs = (HashMap<String, Object>)ousdCooTssService.decodeNamoEditorMap(input,smryDs); //에디터데이터 디코딩처리

                smryDecodeDs = StringUtil.toUtf8Input(smryDecodeDs);
                genTssPlnService.insertGenTssPlnMst(mstDs, smryDecodeDs);

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
     * 과제관리 > 일반과제 > 계획 > 마스터 수정
     *
     * @param input HashMap<String, Object>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return ModelAndView
     * */
    @RequestMapping(value="/prj/tss/gen/updateGenTssPlnMst.do")
    public ModelAndView updateGenTssPlnMst(@RequestParam HashMap<String, Object> input, HttpServletRequest request,
            HttpSession session, ModelMap model) {

        LOGGER.debug("###########################################################");
        LOGGER.debug("updateGenTssPlnMst [과제관리 > 일반과제 > 계획 > 마스터 수정]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSessionObjRUI(input, session, model);

        ModelAndView modelAndView = new ModelAndView("ruiView");

        HashMap<String, Object> mstDs  = new HashMap<String, Object>();
        HashMap<String, Object> smryDs = new HashMap<String, Object>();
        HashMap<String, Object> smryDecodeDs = null;

        try {
            mstDs  = (HashMap<String, Object>) RuiConverter.convertToDataSet(request, "mstDataSet").get(0);
            smryDs = (HashMap<String, Object>) RuiConverter.convertToDataSet(request, "smryDataSet").get(0);

            //마스터 수정
            boolean errYn   = false;
            boolean upWbsCd = false;

            if(!errYn) {
                smryDecodeDs = (HashMap<String, Object>)ousdCooTssService.decodeNamoEditorMap(input,smryDs); //에디터데이터 디코딩처리

                smryDecodeDs = StringUtil.toUtf8Input(smryDecodeDs);
                genTssPlnService.updateGenTssPlnMst(mstDs, smryDecodeDs, upWbsCd);

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
     * 과제관리 > 일반과제 > 계획 > 삭제
     *
     * @param input HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return ModelAndView
     * */
    @RequestMapping(value="/prj/tss/gen/deleteGenTssPlnMst.do")
    public ModelAndView deleteGenTssPlnMst(@RequestParam HashMap<String, String> input, HttpServletRequest request,
            HttpSession session, ModelMap model) {

        LOGGER.debug("###########################################################");
        LOGGER.debug("deleteGenTssPlnMst [과제관리 > 일반과제 > 계획 > 삭제]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSessionRUI(input, session, model);

        ModelAndView modelAndView = new ModelAndView("ruiView");

        HashMap<String, Object> mstDs  = new HashMap<String, Object>();

        try {
            genTssPlnService.deleteGenTssPlnMst(input);

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
     * 과제관리 > 일반과제 > 계획 > 개요 iframe 조회
     *
     * @param input HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return String
     * @throws JSONException
     * */
    @RequestMapping(value="/prj/tss/gen/genTssPlnSmryIfm.do")
    public String retrieveGenTssPlnSmry(@RequestParam HashMap<String, String> input, HttpServletRequest request,
            HttpSession session, ModelMap model) throws JSONException {

        LOGGER.debug("###########################################################");
        LOGGER.debug("retrieveGenTssPlnSmry [과제관리 > 일반과제 > 계획 > 개요 조회]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSession(input, session, model);

        if(pageMoveChkSession(input.get("_userId"))) {
            //데이터 있을 경우
            Map<String, Object> result = null;
            if(!"".equals(input.get("tssCd")) && null != input.get("tssCd")) {
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

        return "web/prj/tss/gen/pln/genTssPlnSmryIfm";
    }



    //================================================================================================ 참여연구원
    /**
     * 과제관리 > 일반과제 > 계획 > 참여연구원 iframe 화면
     *
     * @param input HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return String
     * @throws JSONException
     * */
    @RequestMapping(value="/prj/tss/gen/genTssPlnPtcRsstMbrIfm.do")
    public String genTssPlnPtcRsstMbrIfm(@RequestParam HashMap<String, String> input, HttpServletRequest request,
            HttpSession session, ModelMap model) throws JSONException {

        LOGGER.debug("###########################################################");
        LOGGER.debug("GenTssController - genTssPlnPtcRsstMbrIfm [과제관리 > 일반과제 > 계획 > 참여연구원 iframe 화면 ]");
        LOGGER.debug("###########################################################");

        checkSession(input, session, model);

        if(pageMoveChkSession(input.get("_userId"))) {
            List <Map<String, Object>> codeRtcRole  = codeService.retrieveCodeValueList("PTC_ROLE"); //참여역할

            model.addAttribute("codeRtcRole", codeRtcRole);

            List<Map<String, Object>> result = genTssPlnService.retrieveGenTssPlnPtcRsstMbr(input);

            JSONObject obj = new JSONObject();
            obj.put("records", result);

            request.setAttribute("resultCnt", result == null ? 0 : result.size());
            request.setAttribute("result", obj);

            model.addAttribute("inputData", input);
        }

        return "web/prj/tss/gen/pln/genTssPlnPtcRsstMbrIfm";
    }


    /**
     * 과제관리 > 일반과제 > 계획 > 참여연구원 조회
     *
     * @param input HashMap<String, Object>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return ModelAndView
     * */
    @RequestMapping(value="/prj/tss/gen/retrieveGenTssPlnPtcRsstMbr.do")
    public ModelAndView retrieveGenTssPlnPtcRsstMbr(@RequestParam HashMap<String, String> input, HttpServletRequest request, HttpServletResponse response,
            HttpSession session, ModelMap model) {

        LOGGER.debug("###########################################################");
        LOGGER.debug("retrieveGenTssPlnPtcRsstMbr [과제관리 > 일반과제 > 계획 > 참여연구원 조회]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSessionRUI(input, session, model);

        ModelAndView modelAndView = new ModelAndView("ruiView");

        List<Map<String, Object>> ds = genTssPlnService.retrieveGenTssPlnPtcRsstMbr(input);

        modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", ds));

        return modelAndView;
    }


    /**
     * 과제관리 > 일반과제 > 계획 > 참여연구원 저장
     *
     * @param input HashMap<String, Object>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return ModelAndView
     * */
    @RequestMapping(value="/prj/tss/gen/updateGenTssPlnPtcRsstMbr.do")
    public ModelAndView updateGenTssPlnPtcRsstMbr(@RequestParam HashMap<String, Object> input, HttpServletRequest request, HttpServletResponse response,
            HttpSession session, ModelMap model) {

        LOGGER.debug("###########################################################");
        LOGGER.debug("updateGenTssPlnPtcRsstMbr [과제관리 > 일반과제 > 계획 > 참여연구원 저장]");
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
     * 과제관리 > 일반과제 > 계획 > 참여연구원 삭제
     *
     * @param input HashMap<String, Object>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return ModelAndView
     * */
    @RequestMapping(value="/prj/tss/gen/deleteGenTssPlnPtcRsstMbr.do")
    public ModelAndView deleteGenTssPlnPtcRsstMbr(@RequestParam HashMap<String, Object> input, HttpServletRequest request, HttpServletResponse response,
            HttpSession session, ModelMap model) {

        LOGGER.debug("###########################################################");
        LOGGER.debug("deleteGenTssPlnPtcRsstMbr [과제관리 > 일반과제 > 계획 > 참여연구원 삭제]");
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



    //================================================================================================ WBS
    /**
     * 과제관리 > 일반과제 > 계획 > WBS iframe 화면
     *
     * @param input HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return String
     * @throws JSONException
     * */
    @RequestMapping(value="/prj/tss/gen/genTssPlnWBSIfm.do")
    public String genTssPlnWBSIfm(@RequestParam HashMap<String, String> input, HttpServletRequest request,
            HttpSession session, ModelMap model) throws JSONException {

        LOGGER.debug("###########################################################");
        LOGGER.debug("GenTssController - genTssPlnWBSIfm [과제관리 > 일반과제 > 계획 > WBS iframe 화면 ]");
        LOGGER.debug("###########################################################");

        checkSession(input, session, model);

        if(pageMoveChkSession(input.get("_userId"))) {
            //데이터 있을 경우
            List<Map<String, Object>> result = null;
            if(!"".equals(input.get("tssCd")) && null != input.get("tssCd")) {
                result = genTssPlnService.retrieveGenTssPlnWBS(input);
            }

            JSONObject obj = new JSONObject();
            obj.put("records", result);

            request.setAttribute("resultCnt", result == null ? 0 : result.size());
            request.setAttribute("result", obj);

            model.addAttribute("inputData", input);
        }

        return "web/prj/tss/gen/pln/genTssPlnWBSIfm";
    }


    /**
     * 과제관리 > 일반과제 > 계획 > WBS 조회
     *
     * @param input HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return String
     * */
    @RequestMapping(value="/prj/tss/gen/retrieveGenTssPlnWBS.do")
    public ModelAndView retrieveGenTssPlnWBS(@RequestParam HashMap<String, String> input, HttpServletRequest request,
            HttpSession session, ModelMap model) {

        LOGGER.debug("###########################################################");
        LOGGER.debug("retrieveGenTssPlnWBS [과제관리 > 일반과제 > 계획 > WBS 조회]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSessionRUI(input, session, model);
        ModelAndView modelAndView = new ModelAndView("ruiView");

        List<Map<String, Object>> result = genTssPlnService.retrieveGenTssPlnWBS(input);

        modelAndView.addObject("dataset", RuiConverter.createDataset("dataset", result));

        //jsp에 있는 el에 담기위한 쓰레기 데이터
        request.setAttribute("resultCnt", 0);
        request.setAttribute("result", null);

        return modelAndView;
    }


    /**
     * 과제관리 > 일반과제 > 계획 > WBS 저장
     *
     * @param input HashMap<String, Object>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return ModelAndView
     * */
    @RequestMapping(value="/prj/tss/gen/updateGenTssPlnWBS.do")
    public ModelAndView updateGenTssPlnWBS(@RequestParam HashMap<String, Object> input, HttpServletRequest request,
            HttpSession session, ModelMap model) {

        LOGGER.debug("###########################################################");
        LOGGER.debug("updateGenTssPlnWBS [과제관리 > 일반과제 > 계획 > WBS 저장]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSessionObjRUI(input, session, model);

        ModelAndView modelAndView = new ModelAndView("ruiView");

        List<Map<String, Object>> ds = null;

        try {
            ds = RuiConverter.convertToDataSet(request, "wbsDataSet");
            genTssPlnService.updateGenTssPlnWBS(ds);

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
     * 과제관리 > 일반과제 > 계획 > WBS 삭제
     *
     * @param input HashMap<String, Object>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return ModelAndView
     * */
    @RequestMapping(value="/prj/tss/gen/deleteGenTssPlnWBS.do")
    public ModelAndView deleteGenTssPlnWBS(@RequestParam HashMap<String, Object> input, HttpServletRequest request,
            HttpSession session, ModelMap model) {

        LOGGER.debug("###########################################################");
        LOGGER.debug("updateGenTssPlnWBS [과제관리 > 일반과제 > 계획 > WBS 삭제]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSessionObjRUI(input, session, model);

        ModelAndView modelAndView = new ModelAndView("ruiView");

        List<Map<String, Object>> ds = null;

        try {
            ds = RuiConverter.convertToDataSet(request, "wbsDataSet");
            genTssPlnService.deleteGenTssPlnWBS(ds);

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



    //================================================================================================ 투입예산
    /**
     * 과제관리 > 일반과제 > 계획 > 투입예산 iframe 화면
     *
     * @param input HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return String
     * @throws JSONException
     * */
    @RequestMapping(value="/prj/tss/gen/genTssPlnTrwiBudgIfm.do")
    public String genTssPlnTrwiBudgIfm(@RequestParam HashMap<String, String> input, HttpServletRequest request,
            HttpSession session, ModelMap model) {

        LOGGER.debug("###########################################################");
        LOGGER.debug("GenTssController - genTssPlnTrwiBudgIfm [과제관리 > 일반과제 > 계획 > 투입예산 iframe 화면 ]");
        LOGGER.debug("###########################################################");

        checkSession(input, session, model);

        if(pageMoveChkSession(input.get("_userId"))) {

            HashMap<String, String> purYyInput = new HashMap<String, String> ();
            if(input.get("pgsStepCd") != null && "AL".equals(String.valueOf(input.get("pgsStepCd")))) {
                purYyInput.put("tssCd", input.get("alTssCd"));
            }
            else {
                purYyInput.put("tssCd", input.get("tssCd"));
            }

            List<Map<String, Object>> purYy = genTssPlnService.retrieveGenTssPlnTssYy(purYyInput);

            request.setAttribute("purYy", purYy);
        }

        return "web/prj/tss/gen/pln/genTssPlnTrwiBudgIfm";
    }


    /**
     * 과제관리 > 일반과제 > 계획 > 투입예산 조회
     *
     * @param input HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return String
     * @throws JSONException
     * */
    @RequestMapping(value="/prj/tss/gen/retrieveGenTssPlnTrwiBudg.do")
    public ModelAndView retrieveGenTssPlnTrwiBudg(@RequestParam HashMap<String, String> input, HttpServletRequest request,
            HttpSession session, ModelMap model) {

        LOGGER.debug("###########################################################");
        LOGGER.debug("retrieveGenTssPlnTrwiBudg [과제관리 > 일반과제 > 계획 > 투입예산 조회]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSessionRUI(input, session, model);
        ModelAndView modelAndView = new ModelAndView("ruiView");

        List<Map<String, Object>> result = genTssPlnService.retrieveGenTssPlnTrwiBudg(input);
        modelAndView.addObject("dataset", RuiConverter.createDataset("dataset", result));

        return modelAndView;
    }


    /**
     * 과제관리 > 일반과제 > 계획 > 투입예산 생성
     *
     * @param input HashMap<String, Object>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return ModelAndView
     * */
    @RequestMapping(value="/prj/tss/gen/insertGenTssPlnTrwiBudg.do")
    public ModelAndView insertGenTssPlnTrwiBudg(@RequestParam HashMap<String, Object> input, HttpServletRequest request, HttpServletResponse response,
            HttpSession session, ModelMap model) {

        LOGGER.debug("###########################################################");
        LOGGER.debug("insertGenTssPlnTrwiBudg [과제관리 > 일반과제 > 계획 > 투입예산 생성]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSessionObjRUI(input, session, model);

        ModelAndView modelAndView = new ModelAndView("ruiView");

        List<Map<String, Object>> ds = new ArrayList<Map<String,Object>>();
        ds.add(input);

        try {
            Map<String, Object> result = genTssPlnService.getGenTssPlnTrwiBudgInfo(input);
            if(!"0".equals(String.valueOf(result.get("infoCnt")))) {
                genTssPlnService.insertGenTssPlnTrwiBudg(input);

                ds.get(0).put("rtCd", "C");
            } else {
                ds.get(0).put("rtCd", "FAIL");
                ds.get(0).put("rtVal", "1인당 총 비용등록을 먼저 해주시기 바랍니다.");
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
     * 과제관리 > 일반과제 > 계획 > 투입예산 마스터 화면
     *
     * @param input HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return String
     * @throws JSONException
     * */
    @RequestMapping(value="/prj/tss/gen/genTssPlnTrwiBudgMstPop.do")
    public String genTssPlnTrwiBudgMstPop(@RequestParam HashMap<String, String> input, HttpServletRequest request,
            HttpSession session, ModelMap model) throws JSONException {

        LOGGER.debug("###########################################################");
        LOGGER.debug("genTssPlnTrwiBudgMstPop [과제관리 > 일반과제 > 계획 > 투입예산 마스터 조회]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSession(input, session, model);

        if(pageMoveChkSession(input.get("_userId"))) {
            List<Map<String, Object>> result = genTssPlnService.retrieveGenTssPlnTrwiBudgMst(input);

            HashMap<String, String> purYyInput = new HashMap<String, String> ();
            if(input.get("pgsStepCd") != null && "AL".equals(String.valueOf(input.get("pgsStepCd")))) {
                purYyInput.put("tssCd", input.get("alTssCd"));
            }
            else {
                purYyInput.put("tssCd", input.get("tssCd"));
            }

            List<Map<String, Object>> purYy = genTssPlnService.retrieveGenTssPlnTssYy(purYyInput);

            JSONObject obj = new JSONObject();
            obj.put("records", result);

            request.setAttribute("resultCnt", result == null ? 0 : result.size());
            request.setAttribute("result", obj);
            request.setAttribute("purYy", purYy);

            model.addAttribute("inputData", input);
        }

        return "web/prj/tss/gen/pln/genTssPlnTrwiBudgPop";
    }


    /**
     * 과제관리 > 일반과제 > 계획 > 투입예산 마스터 조회
     *
     * @param input HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return String
     * @throws JSONException
     * */
    @RequestMapping(value="/prj/tss/gen/retrieveGenTssPlnTrwiBudgMst.do")
    public ModelAndView retrieveGenTssPlnTrwiBudgMst(@RequestParam HashMap<String, String> input, HttpServletRequest request,
            HttpSession session, ModelMap model) {

        LOGGER.debug("###########################################################");
        LOGGER.debug("retrieveGenTssPlnTrwiBudgMst [과제관리 > 일반과제 > 계획 > 투입예산 마스터 조회]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSessionRUI(input, session, model);

        ModelAndView modelAndView = new ModelAndView("ruiView");

        List<Map<String, Object>> result = genTssPlnService.retrieveGenTssPlnTrwiBudgMst(input);

        HashMap<String, String> purYyInput = new HashMap<String, String> ();
        if(input.get("pgsStepCd") != null && "AL".equals(String.valueOf(input.get("pgsStepCd")))) {
            purYyInput.put("tssCd", input.get("alTssCd"));
        }
        else {
            purYyInput.put("tssCd", input.get("tssCd"));
        }

        List<Map<String, Object>> purYy = genTssPlnService.retrieveGenTssPlnTssYy(purYyInput);

        modelAndView.addObject("dataset", RuiConverter.createDataset("dataset", result));

        //jsp에 있는 el에 담기위한 쓰레기 데이터
        request.setAttribute("resultCnt", 0);
        request.setAttribute("result", null);
        request.setAttribute("purYy", purYy);

        return modelAndView;
    }


    /**
     * 과제관리 > 일반과제 > 계획 > 투입예산 마스터 저장
     *
     * @param input HashMap<String, Object>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return ModelAndView
     * */
    @RequestMapping(value="/prj/tss/gen/updateGenTssPlnTrwiBudgMst.do")
    public ModelAndView updateGenTssPlnTrwiBudgMst(@RequestParam HashMap<String, Object> input, HttpServletRequest request, HttpServletResponse response,
            HttpSession session, ModelMap model) {

        LOGGER.debug("###########################################################");
        LOGGER.debug("updateGenTssPlnTrwiBudgMst [과제관리 > 일반과제 > 계획 > 투입예산 마스터 저장]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSessionObjRUI(input, session, model);

        ModelAndView modelAndView = new ModelAndView("ruiView");

        List<Map<String, Object>> ds = null;

        try {
            ds  = RuiConverter.convertToDataSet(request, "tbmstDataSet");
            genTssPlnService.updateGenTssPlnTrwiBudgMst(ds);

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
     * 과제관리 > 일반과제 > 계획 > 투입예산 마스터 삭제
     *
     * @param input HashMap<String, Object>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return ModelAndView
     * */
    @RequestMapping(value="/prj/tss/gen/deleteGenTssPlnTrwiBudgMst.do")
    public ModelAndView deleteGenTssPlnTrwiBudgMst(@RequestParam HashMap<String, Object> input, HttpServletRequest request, HttpServletResponse response,
            HttpSession session, ModelMap model) {

        LOGGER.debug("###########################################################");
        LOGGER.debug("deleteGenTssPlnTrwiBudgMst [과제관리 > 일반과제 > 계획 > 투입예산 마스터 삭제]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSessionObjRUI(input, session, model);

        ModelAndView modelAndView = new ModelAndView("ruiView");

        List<Map<String, Object>> ds = null;

        try {
            ds  = RuiConverter.convertToDataSet(request, "tbmstDataSet");
            genTssPlnService.deleteGenTssPlnTrwiBudgMst(ds);

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


    //================================================================================================ 목표및산출물
    /**
     * 과제관리 > 일반과제 > 계획 > 목표및산출물 iframe 화면
     *
     * @param input HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return String
     * @throws JSONException
     * */
    @RequestMapping(value="/prj/tss/gen/genTssPlnGoalYldIfm.do")
    public String genTssPlnGoalYldIfm(@RequestParam HashMap<String, String> input, HttpServletRequest request,
            HttpSession session, ModelMap model) throws JSONException {

        LOGGER.debug("###########################################################");
        LOGGER.debug("GenTssController - genTssPlnGoalYldIfm [과제관리 > 일반과제 > 계획 > 목표및산출물 iframe 화면 ]");
        LOGGER.debug("###########################################################");

        checkSession(input, session, model);

        if(pageMoveChkSession(input.get("_userId"))) {
            //데이터 있을 경우
            List<Map<String, Object>> resultGoal = null;
            List<Map<String, Object>> resultYld  = null;

            if(!"".equals(input.get("tssCd")) && null != input.get("tssCd")) {
                resultGoal = genTssPlnService.retrieveGenTssPlnGoal(input);
                resultYld  = genTssPlnService.retrieveGenTssPlnYld(input);
            }

            for(int i = 0; i < resultGoal.size(); i++) {
                StringUtil.toUtf8Output((HashMap)resultGoal.get(i));
            }
            for(int i = 0; i < resultYld.size(); i++) {
                StringUtil.toUtf8Output((HashMap)resultYld.get(i));
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

        return "web/prj/tss/gen/pln/genTssPlnGoalYldIfm";
    }


    /**
     * 과제관리 > 일반과제 > 계획 > 목표및산출물 > 목표 조회
     *
     * @param input HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return String
     * @throws JSONException
     * */
    @RequestMapping(value="/prj/tss/gen/retrieveGenTssPlnGoal.do")
    public ModelAndView retrieveGenTssPlnGoal(@RequestParam HashMap<String, String> input, HttpServletRequest request,
            HttpSession session, ModelMap model) throws JSONException {

        LOGGER.debug("###########################################################");
        LOGGER.debug("retrieveGenTssPlnGoal [과제관리 > 일반과제 > 계획 > 목표및산출물 > 목표 조회]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSessionRUI(input, session, model);
        ModelAndView modelAndView = new ModelAndView("ruiView");

        List<Map<String, Object>> resultGoal = genTssPlnService.retrieveGenTssPlnGoal(input);

        for(int i = 0; i < resultGoal.size(); i++) {
            StringUtil.toUtf8Output((HashMap)resultGoal.get(i));
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
     * 과제관리 > 일반과제 > 계획 > 목표및산출물 > 산출물 조회
     *
     * @param input HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return String
     * @throws JSONException
     * */
    @RequestMapping(value="/prj/tss/gen/retrieveGenTssPlnYld.do")
    public ModelAndView retrieveGenTssPlnYld(@RequestParam HashMap<String, String> input, HttpServletRequest request,
            HttpSession session, ModelMap model) throws JSONException {

        LOGGER.debug("###########################################################");
        LOGGER.debug("retrieveGenTssPlnYld [과제관리 > 일반과제 > 계획 > 목표및산출물 > 산출물 조회]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSessionRUI(input, session, model);
        ModelAndView modelAndView = new ModelAndView("ruiView");

        List<Map<String, Object>> resultYld = genTssPlnService.retrieveGenTssPlnYld(input);

        for(int i = 0; i < resultYld.size(); i++) {
            StringUtil.toUtf8Output((HashMap)resultYld.get(i));
        }

        modelAndView.addObject("dataset", RuiConverter.createDataset("dataset", resultYld));

        //jsp에 있는 el에 담기위한 쓰레기 데이터
        request.setAttribute("resultGoalCnt", 0);
        request.setAttribute("resultGoal", null);
        request.setAttribute("resultYldCnt", 0);
        request.setAttribute("resultYld", null);

        return modelAndView;
    }


    /**
     * 과제관리 > 일반과제 > 계획 > 목표및산출물 > 목표 저장
     *
     * @param input HashMap<String, Object>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return ModelAndView
     * */
    @RequestMapping(value="/prj/tss/gen/updateGenTssPlnGoal.do")
    public ModelAndView updateGenTssPlnGoal(@RequestParam HashMap<String, Object> input, HttpServletRequest request,
            HttpSession session, ModelMap model) {

        LOGGER.debug("###########################################################");
        LOGGER.debug("updateGenTssPlnGoal [과제관리 > 일반과제 > 계획 > 목표및산출물 > 목표 저장]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSessionObjRUI(input, session, model);

        ModelAndView modelAndView = new ModelAndView("ruiView");

        List<Map<String, Object>> ds = null;

        try {
            ds = RuiConverter.convertToDataSet(request, "goalDataSet");
            for(int i = 0; i < ds.size(); i++) {
                StringUtil.toUtf8Input((HashMap)ds.get(i));
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

        for(int i = 0; i < ds.size(); i++) {
            StringUtil.toUtf8Output((HashMap)ds.get(i));
        }
        modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", ds));

        return modelAndView;
    }


    /**
     * 과제관리 > 일반과제 > 계획 > 목표및산출물 > 산출물 저장
     *
     * @param input HashMap<String, Object>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return ModelAndView
     * */
    @RequestMapping(value="/prj/tss/gen/updateGenTssPlnYld.do")
    public ModelAndView updateGenTssPlnYld(@RequestParam HashMap<String, Object> input, HttpServletRequest request,
            HttpSession session, ModelMap model) {

        LOGGER.debug("###########################################################");
        LOGGER.debug("updateGenTssPlnYld [과제관리 > 일반과제 > 계획 > 목표및산출물 > 산출물 저장]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSessionObjRUI(input, session, model);

        ModelAndView modelAndView = new ModelAndView("ruiView");

        List<Map<String, Object>> ds = null;

        try {
            ds = RuiConverter.convertToDataSet(request, "yldDataSet");
            for(int i = 0; i < ds.size(); i++) {
                StringUtil.toUtf8Input((HashMap)ds.get(i));
            }

            genTssPlnService.updateGenTssPlnYld(ds);

            ds.get(0).put("targetDs", "YLD");
            ds.get(0).put("rtCd", "SUCCESS");
            ds.get(0).put("rtVal",messageSourceAccessor.getMessage("msg.alert.saved")); //저장되었습니다.
        } catch(Exception e) {
            e.printStackTrace();
            ds.get(0).put("rtCd", "FAIL");
            ds.get(0).put("rtVal", messageSourceAccessor.getMessage("msg.alert.error")); //오류가 발생하였습니다.
        }

        for(int i = 0; i < ds.size(); i++) {
            StringUtil.toUtf8Output((HashMap)ds.get(i));
        }
        modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", ds));

        return modelAndView;
    }


    /**
     * 과제관리 > 일반과제 > 계획 > 목표및산출물 > 목표 삭제
     *
     * @param input HashMap<String, Object>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return ModelAndView
     * */
    @RequestMapping(value="/prj/tss/gen/deleteGenTssPlnGoal.do")
    public ModelAndView deleteGenTssPlnGoal(@RequestParam HashMap<String, Object> input, HttpServletRequest request,
            HttpSession session, ModelMap model) {

        LOGGER.debug("###########################################################");
        LOGGER.debug("deleteGenTssPlnGoal [과제관리 > 일반과제 > 계획 > 목표및산출물 > 목표 삭제]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

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
     * 과제관리 > 일반과제 > 계획 > 목표및산출물 > 산출물 삭제
     *
     * @param input HashMap<String, Object>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return ModelAndView
     * */
    @RequestMapping(value="/prj/tss/gen/deleteGenTssPlnYld.do")
    public ModelAndView deleteGenTssPlnYld(@RequestParam HashMap<String, Object> input, HttpServletRequest request,
            HttpSession session, ModelMap model) {

        LOGGER.debug("###########################################################");
        LOGGER.debug("deleteGenTssPlnYld [과제관리 > 일반과제 > 계획 > 목표및산출물 > 산출물 삭제]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

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
    /**
     * 과제관리 > 일반과제 > 계획 > 품의서요청 화면
     *
     * @param input HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return String
     * @throws JSONException
     * */
    @RequestMapping(value="/prj/tss/gen/genTssPlnCsusRq.do")
    public String genTssPlnCsusRq(@RequestParam HashMap<String, String> input, HttpServletRequest request,
            HttpSession session, ModelMap model) throws JSONException {

        LOGGER.debug("###########################################################");
        LOGGER.debug("GenTssController - genTssPlnGoalYldIfm [과제관리 > 일반과제 > 계획 > 품의서요청 화면 ]");
        LOGGER.debug("###########################################################");

        checkSession(input, session, model);

        if(pageMoveChkSession(input.get("_userId"))) {
            Map<String, Object> resultMst         = genTssPlnService.retrieveGenTssPlnMst(input); //마스터
            Map<String, Object> resultSmry        = genTssPlnService.retrieveGenTssPlnSmry(input); //개요
            Map<String, Object> resultCsus        = genTssService.retrieveGenTssCsus(resultMst); //품의서
            List<Map<String, Object>> resultMbr   = genTssPlnService.retrieveGenTssPlnPtcRsstMbr(input); //참여연구원
            List<Map<String, Object>> resultGoal  = genTssPlnService.retrieveGenTssPlnGoal(input); //목표기술성과
            List<Map<String, Object>> resultTssYy = genTssPlnService.retrieveGenTssPlnTssYy(input); //과제년도
            List<Map<String, Object>> resultBudg  = genTssPlnService.retrieveGenTssPlnBudgGroupYy(input, resultTssYy); //예산

            HashMap<String, String> inputInfo = new HashMap<String, String>();
            inputInfo.put("tssCd",     String.valueOf(input.get("tssCd")));
            inputInfo.put("pgTssCd",   String.valueOf(resultMst.get("pgTssCd")));
            inputInfo.put("tssStrtDd", String.valueOf(resultMst.get("tssStrtDd")));
            inputInfo.put("tssFnhDd",  String.valueOf(resultMst.get("tssFnhDd")));
            inputInfo.put("attcFilId", String.valueOf(resultSmry.get("attcFilId")));

            List<Map<String, Object>> resultAttc  = genTssCmplService.retrieveGenTssCmplAttc(inputInfo);
 
            LOGGER.debug("#######################resultBudg #################################### : " + resultBudg);
            
            for(int i=0; i < resultBudg.size() ; i++){
            	if(i == 0 ){
            		resultSmry.put("ingun", resultBudg.get(i).get("totSum"));
            	}else if(i == 1 ){
            		resultSmry.put("ounYoung", resultBudg.get(i).get("totSum"));
            	}else if(i == 2 ){
            		resultSmry.put("kungDev", resultBudg.get(i).get("totSum"));
            	}else if(i == 3 ){
            		resultSmry.put("gamgaDev", resultBudg.get(i).get("totSum"));
            	}else if(i == 4 ){
            		resultSmry.put("total", resultBudg.get(i).get("totSum"));
            	}
            }
            
            resultMst  = StringUtil.toUtf8Output((HashMap) resultMst);
            resultSmry = StringUtil.toUtf8Output((HashMap) resultSmry);
            resultCsus = StringUtil.toUtf8Output((HashMap) resultCsus);
            //            for(int i = 0; i < resultGoal.size(); i++) {
            //                StringUtil.toUtf8Input((HashMap)resultGoal.get(i));
            //            }

            model.addAttribute("inputData", input);
            model.addAttribute("resultMst", resultMst);
            model.addAttribute("resultSmry", resultSmry);
            model.addAttribute("resultMbr", resultMbr);
            model.addAttribute("resultGoal", resultGoal);
            model.addAttribute("resultTssYy", resultTssYy);
            model.addAttribute("resultBudg", resultBudg);
            model.addAttribute("resultCsus", resultCsus);
            model.addAttribute("resultAttc", resultAttc);

            //text컬럼을 위한 json변환
            JSONObject obj = new JSONObject();
            obj.put("smry", resultSmry);
            obj.put("goal", resultGoal);

            request.setAttribute("resultJson", obj);
        }

        return "web/prj/tss/gen/pln/genTssPlnCsusRq";
    }


    /**
     * 과제관리 > 일반과제 > 계획 > 품의서요청 생성
     *
     * @param input HashMap<String, Object>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return ModelAndView
     * */
    @RequestMapping(value="/prj/tss/gen/insertGenTssPlnCsusRq.do")
    public ModelAndView insertGenTssPlnCsusRq(@RequestParam HashMap<String, Object> input, HttpServletRequest request, HttpServletResponse response,
            HttpSession session, ModelMap model) {

        LOGGER.debug("###########################################################");
        LOGGER.debug("insertGenTssPlnCsusRq [과제관리 > 일반과제 > 계획 > 품의서요청 생성]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSessionObjRUI(input, session, model);

        ModelAndView modelAndView = new ModelAndView("ruiView");

        List<Map<String, Object>> ds = null;

        try {
            ds  = RuiConverter.convertToDataSet(request, "dataSet");
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
