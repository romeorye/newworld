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
import iris.web.common.util.StringUtil;
import iris.web.prj.tss.com.service.TssUserService;
import iris.web.prj.tss.gen.service.GenTssAltrService;
import iris.web.prj.tss.gen.service.GenTssPlnService;
import iris.web.prj.tss.gen.service.GenTssService;
import iris.web.prj.tss.ousdcoo.service.OusdCooTssService;
import iris.web.system.base.IrisBaseController;


/********************************************************************************
 * NAME : GenTssAltrController.java
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
public class GenTssAltrController  extends IrisBaseController {

    @Resource(name="messageSourceAccessor")
    private MessageSourceAccessor messageSourceAccessor;

    @Resource(name = "tssUserService")
    private TssUserService tssUserService;

    @Resource(name = "genTssAltrService")
    private GenTssAltrService genTssAltrService;

    @Resource(name = "genTssService")
    private GenTssService genTssService;

    @Resource(name = "ousdCooTssService")
    private OusdCooTssService ousdCooTssService;			// 대외협력과제 서비스

    @Resource(name = "codeService")
    private CodeService codeService;

    @Resource(name = "genTssPlnService")
    private GenTssPlnService genTssPlnService;

    static final Logger LOGGER = LogManager.getLogger(GenTssAltrController.class);


    //================================================================================================ 마스터
    /**
     * 과제관리 > 일반과제 > 변경 > 마스터 조회
     *
     * @param input HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return String
     * @throws JSONException
     * */
    @RequestMapping(value="/prj/tss/gen/genTssAltrDetail.do")
    public String genTssAltrDetail(@RequestParam HashMap<String, String> input, HttpServletRequest request,
            HttpSession session, ModelMap model) throws JSONException {

        LOGGER.debug("###########################################################");
        LOGGER.debug("genTssAltrDetail [과제관리 > 일반과제 > 변경 > 마스터 조회]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSession(input, session, model);

        if(pageMoveChkSession(input.get("_userId"))) {
            //데이터 있을 경우
            Map<String, Object> result = null;
            if(!"".equals(input.get("tssCd")) && null != input.get("tssCd")) {
                result = genTssAltrService.retrieveGenTssAltrMst(input);
                result = StringUtil.toUtf8Output((HashMap) result);

                Map<String, Object> mbrCnt = genTssAltrService.retrieveGenTssPtcMbrCnt(input);
                result.put("mbrCnt", mbrCnt.get("mbrCnt"));

                Map<String, Object> role = tssUserService.getTssBtnRoleChk(input, result);
                result.put("tssRoleType", role.get("tssRoleType"));
                result.put("tssRoleId",   role.get("tssRoleId"));

                if("TR04".equals(role.get("tssRoleId"))) {
                    result.put("tssRoleType", "R");
                }
            }

            List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
            list.add(result);

            JSONObject obj = new JSONObject();
            obj.put("records", list);
            LOGGER.debug("#########################result ################################## : " + result);
            request.setAttribute("inputData", input);
            request.setAttribute("resultCnt", result == null ? 0 : result.size());
            request.setAttribute("result", obj);
        }

        return "web/prj/tss/gen/altr/genTssAltrDetail";
    }


    /**
     * 과제관리 > 일반과제 > 변경 > 마스터 신규
     *
     * @param input HashMap<String, Object>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return ModelAndView
     * */
    @RequestMapping(value="/prj/tss/gen/insertGenTssAltrMst.do")
    public ModelAndView insertGenTssAltrMst(@RequestParam HashMap<String, Object> input, HttpServletRequest request,
            HttpSession session, ModelMap model) {

        LOGGER.debug("###########################################################");
        LOGGER.debug("insertGenTssAltrMst [과제관리 > 일반과제 > 변경 > 마스터 신규]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSessionObjRUI(input, session, model);

        ModelAndView modelAndView = new ModelAndView("ruiView");

        HashMap<String, Object> mstDs  = null;
        HashMap<String, Object> smryDs = null;
        List<Map<String, Object>> altrDs = null;

        try {
            mstDs  = (HashMap<String, Object>) RuiConverter.convertToDataSet(request, "mstDataSet").get(0);
            smryDs = (HashMap<String, Object>) RuiConverter.convertToDataSet(request, "smryDataSet").get(0);
            altrDs = RuiConverter.convertToDataSet(request, "altrDataSet");

            boolean upWbsCd = false;

            smryDs = StringUtil.toUtf8Input(smryDs);
            genTssAltrService.insertGenTssAltrMst(mstDs, smryDs, altrDs, upWbsCd);
            
            mstDs.put("rtCd", "SUCCESS");
            mstDs.put("rtVal",messageSourceAccessor.getMessage("msg.alert.saved")); //저장되었습니다.
            mstDs.put("rtType", "I");
        } catch(Exception e) {
            e.printStackTrace();
            mstDs.put("rtCd", "FAIL");
            mstDs.put("rtVal", messageSourceAccessor.getMessage("msg.alert.error")); //오류가 발생하였습니다.
        }

        modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", mstDs));

        return modelAndView;
    }


    /**
     * 과제관리 > 일반과제 > 변경 > 마스터 수정
     *
     * @param input HashMap<String, Object>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return ModelAndView
     * */
    @RequestMapping(value="/prj/tss/gen/updateGenTssAltrMst.do")
    public ModelAndView updateGenTssAltrMst(@RequestParam HashMap<String, Object> input, HttpServletRequest request,
            HttpSession session, ModelMap model) {

        LOGGER.debug("###########################################################");
        LOGGER.debug("updateGenTssAltrMst [과제관리 > 일반과제 > 변경 > 마스터 수정]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSessionObjRUI(input, session, model);

        ModelAndView modelAndView = new ModelAndView("ruiView");

        HashMap<String, Object> mstDs  = new HashMap<String, Object>();
        HashMap<String, Object> smryDs = new HashMap<String, Object>();

        try {
            mstDs  = (HashMap<String, Object>) RuiConverter.convertToDataSet(request, "mstDataSet").get(0);
            smryDs = (HashMap<String, Object>) RuiConverter.convertToDataSet(request, "smryDataSet").get(0);
            List<Map<String, Object>> altrDs = RuiConverter.convertToDataSet(request, "altrDataSet");

            boolean errYn   = false;
            boolean upWbsCd = false;

            if(!errYn) {
                smryDs = StringUtil.toUtf8Input(smryDs);
                genTssAltrService.updateGenTssAltrMst(mstDs, smryDs, altrDs, upWbsCd);

                mstDs.put("rtCd", "SUCCESS");
                mstDs.put("rtVal",messageSourceAccessor.getMessage("msg.alert.saved")); //저장되었습니다.
            }
        } catch(Exception e) {
            e.printStackTrace();
            mstDs.put("rtCd", "FAIL");
            mstDs.put("rtVal", messageSourceAccessor.getMessage("msg.alert.error")); //오류가 발생하였습니다.
        }

        modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", mstDs));

        return modelAndView;
    }



    //================================================================================================ 변경개요
    /**
     * 과제관리 > 일반과제 > 변경 > 변경개요 iframe 조회
     *
     * @param input HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return String
     * @throws JSONException
     * */
    @RequestMapping(value="/prj/tss/gen/genTssAltrIfm.do")
    public String retrieveGenTssAltrSmry1(@RequestParam HashMap<String, String> input, HttpServletRequest request,
            HttpSession session, ModelMap model) throws JSONException {

        LOGGER.debug("###########################################################");
        LOGGER.debug("retrieveGenTssAltrSmry [과제관리 > 일반과제 > 변경개요 > 변경개요 조회]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSession(input, session, model);

        if(pageMoveChkSession(input.get("_userId"))) {
            //데이터 있을 경우
            Map<String, Object> result = null;
            
            result = genTssAltrService.retrieveGenTssAltrInfo(input);
            
            result = StringUtil.toUtf8Output((HashMap) result);

            List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
            list.add(result);

            JSONObject obj = new JSONObject();
            obj.put("records", list);

            request.setAttribute("inputData", input);
            request.setAttribute("resultCnt", result == null ? 0 : result.size());
            request.setAttribute("result", obj);
        }

        return "web/prj/tss/gen/altr/genTssAltrIfm";
    }


    /**
     * 과제관리 > 일반과제 > 변경 > 변경개요목록 조회
     *
     * @param input HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return String
     * */
    @RequestMapping(value="/prj/tss/gen/retrieveGenTssAltrSmryList.do")
    public ModelAndView retrieveGenTssAltrSmryList(@RequestParam HashMap<String, String> input, HttpServletRequest request,
            HttpSession session, ModelMap model) {

        LOGGER.debug("###########################################################");
        LOGGER.debug("retrieveGenTssAltrSmryList [과제관리 > 일반과제 > 변경 > 변경개요목록 조회]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSessionRUI(input, session, model);
        ModelAndView modelAndView = new ModelAndView("ruiView");

        List<Map<String, Object>> result = genTssAltrService.retrieveGenTssAltrSmryList(input);

        modelAndView.addObject("dataset", RuiConverter.createDataset("dataset", result));

        //jsp에 있는 el에 담기위한 쓰레기 데이터
        //        request.setAttribute("resultCnt", 0);
        //        request.setAttribute("result", null);

        return modelAndView;
    }



    //================================================================================================ 개요
    /**
     * 과제관리 > 일반과제 > 변경 > 개요 iframe 조회
     *
     * @param input HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return String
     * @throws JSONException
     * */
    @RequestMapping(value="/prj/tss/gen/genTssAltrSmryIfm.do")
    public String retrieveGenTssAltrSmry2(@RequestParam HashMap<String, String> input, HttpServletRequest request,
            HttpSession session, ModelMap model) throws JSONException {

        LOGGER.debug("###########################################################");
        LOGGER.debug("retrieveGenTssAltrSmry [과제관리 > 일반과제 > 변경 > 개요 조회]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSession(input, session, model);
        input = StringUtil.toUtf8(input);
        if(pageMoveChkSession(input.get("_userId"))) {
            //데이터 있을 경우
            Map<String, Object> result = null;
            if(!"".equals(input.get("tssCd")) && null != input.get("tssCd")) {
                result = genTssAltrService.retrieveGenTssAltrSmry(input);
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

        return "web/prj/tss/gen/altr/genTssAltrSmryIfm";
    }


    /**
     * 과제관리 > 일반과제 > 변경 > 개요 저장
     *
     * @param input HashMap<String, Object>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return ModelAndView
     * */
    @RequestMapping(value="/prj/tss/gen/updateGenTssAltrSmry.do")
    public ModelAndView updateGenTssAltrSmry(@RequestParam HashMap<String, Object> input, HttpServletRequest request, HttpServletResponse response,
            HttpSession session, ModelMap model) {

        LOGGER.debug("###########################################################");
        LOGGER.debug("updateGenTssAltrPtcRsstMbr [과제관리 > 일반과제 > 변경 > 개요 저장]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSessionObjRUI(input, session, model);

        ModelAndView modelAndView = new ModelAndView("ruiView");

        List<Map<String, Object>> ds = null;
        HashMap<String, Object> smryDecodeDs = null;

        try {
            ds  = RuiConverter.convertToDataSet(request, "smryDataSet");
            smryDecodeDs = (HashMap<String, Object>) ds.get(0); //에디터데이터 디코딩처리

            genTssAltrService.updateGenTssAltrSmry2(StringUtil.toUtf8Input(smryDecodeDs));

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



    //================================================================================================ 참여연구원
    /**
     * 과제관리 > 일반과제 > 변경 > 참여연구원 iframe 화면
     *
     * @param input HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return String
     * @throws JSONException
     * */
    @RequestMapping(value="/prj/tss/gen/genTssAltrPtcRsstMbrIfm.do")
    public String genTssAltrPtcRsstMbrIfm(@RequestParam HashMap<String, String> input, HttpServletRequest request,
            HttpSession session, ModelMap model) throws JSONException {

        LOGGER.debug("###########################################################");
        LOGGER.debug("GenTssController - genTssAltrPtcRsstMbrIfm [과제관리 > 일반과제 > 변경 > 참여연구원 iframe 화면 ]");
        LOGGER.debug("###########################################################");

        checkSession(input, session, model);

        if(pageMoveChkSession(input.get("_userId"))) {
            List <Map<String, Object>> codeRtcRole  = codeService.retrieveCodeValueList("PTC_ROLE"); //참여역할

            model.addAttribute("codeRtcRole", codeRtcRole);

            //데이터 있을 경우
            List<Map<String, Object>> result = genTssAltrService.retrieveGenTssAltrPtcRsstMbr(input);

            JSONObject obj = new JSONObject();
            obj.put("records", result);

            request.setAttribute("resultCnt", result == null ? 0 : result.size());
            request.setAttribute("result", obj);

            model.addAttribute("inputData", input);
        }

        return "web/prj/tss/gen/altr/genTssAltrPtcRsstMbrIfm";
    }


    /**
     * 과제관리 > 일반과제 > 변경 > 참여연구원 조회
     *
     * @param input HashMap<String, Object>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return ModelAndView
     * */
    @RequestMapping(value="/prj/tss/gen/retrieveGenTssAltrPtcRsstMbr.do")
    public ModelAndView retrieveGenTssAltrPtcRsstMbr(@RequestParam HashMap<String, String> input, HttpServletRequest request, HttpServletResponse response,
            HttpSession session, ModelMap model) {

        LOGGER.debug("###########################################################");
        LOGGER.debug("retrieveNatTssPlnPtcRsstMbr [과제관리 > 일반과제 > 변경 > 참여연구원 조회]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSessionRUI(input, session, model);

        ModelAndView modelAndView = new ModelAndView("ruiView");

        List<Map<String, Object>> ds = genTssAltrService.retrieveGenTssAltrPtcRsstMbr(input);

        modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", ds));

        return modelAndView;
    }


    /**
     * 과제관리 > 일반과제 > 변경 > 참여연구원 저장
     *
     * @param input HashMap<String, Object>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return ModelAndView
     * */
    @RequestMapping(value="/prj/tss/gen/updateGenTssAltrPtcRsstMbr.do")
    public ModelAndView updateGenTssAltrPtcRsstMbr(@RequestParam HashMap<String, Object> input, HttpServletRequest request, HttpServletResponse response,
            HttpSession session, ModelMap model) {

        LOGGER.debug("###########################################################");
        LOGGER.debug("updateGenTssAltrPtcRsstMbr [과제관리 > 일반과제 > 변경 > 참여연구원 저장]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSessionObjRUI(input, session, model);

        ModelAndView modelAndView = new ModelAndView("ruiView");

        List<Map<String, Object>> ds = null;

        try {
            ds  = RuiConverter.convertToDataSet(request, "mbrDataSet");
            genTssAltrService.updateGenTssAltrPtcRsstMbr(ds);

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
     * 과제관리 > 일반과제 > 변경 > 참여연구원 삭제
     *
     * @param input HashMap<String, Object>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return ModelAndView
     * */
    @RequestMapping(value="/prj/tss/gen/deleteGenTssAltrPtcRsstMbr.do")
    public ModelAndView deleteGenTssAltrPtcRsstMbr(@RequestParam HashMap<String, Object> input, HttpServletRequest request, HttpServletResponse response,
            HttpSession session, ModelMap model) {

        LOGGER.debug("###########################################################");
        LOGGER.debug("deleteGenTssAltrPtcRsstMbr [과제관리 > 일반과제 > 변경 > 참여연구원 삭제]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSessionObjRUI(input, session, model);

        ModelAndView modelAndView = new ModelAndView("ruiView");

        List<Map<String, Object>> ds = null;

        try {
            ds  = RuiConverter.convertToDataSet(request, "mbrDataSet");
            genTssAltrService.deleteGenTssAltrPtcRsstMbr(ds);

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
     * 과제관리 > 일반과제 > 변경 > WBS iframe 화면
     *
     * @param input HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return String
     * @throws JSONException
     * */
    @RequestMapping(value="/prj/tss/gen/genTssAltrWBSIfm.do")
    public String genTssAltrWBSIfm(@RequestParam HashMap<String, String> input, HttpServletRequest request,
            HttpSession session, ModelMap model) throws JSONException {

        LOGGER.debug("###########################################################");
        LOGGER.debug("GenTssController - genTssAltrWBSIfm [과제관리 > 일반과제 > 변경 > WBS iframe 화면 ]");
        LOGGER.debug("###########################################################");

        checkSession(input, session, model);

        if(pageMoveChkSession(input.get("_userId"))) {
            //데이터 있을 경우
            List<Map<String, Object>> result = null;
            if(!"".equals(input.get("tssCd")) && null != input.get("tssCd")) {
                result = genTssAltrService.retrieveGenTssAltrWBS(input);
            }

            JSONObject obj = new JSONObject();
            obj.put("records", result);

            request.setAttribute("resultCnt", result == null ? 0 : result.size());
            request.setAttribute("result", obj);

            model.addAttribute("inputData", input);
        }

        return "web/prj/tss/gen/altr/genTssAltrWBSIfm";
    }


    /**
     * 과제관리 > 일반과제 > 변경 > WBS 조회
     *
     * @param input HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return String
     * */
    @RequestMapping(value="/prj/tss/gen/retrieveGenTssAltrWBS.do")
    public ModelAndView retrieveGenTssAltrWBS(@RequestParam HashMap<String, String> input, HttpServletRequest request,
            HttpSession session, ModelMap model) {

        LOGGER.debug("###########################################################");
        LOGGER.debug("retrieveGenTssAltrWBS [과제관리 > 일반과제 > 변경 > WBS 조회]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSessionRUI(input, session, model);
        ModelAndView modelAndView = new ModelAndView("ruiView");

        List<Map<String, Object>> result = genTssAltrService.retrieveGenTssAltrWBS(input);

        modelAndView.addObject("dataset", RuiConverter.createDataset("dataset", result));

        //jsp에 있는 el에 담기위한 쓰레기 데이터
        request.setAttribute("resultCnt", 0);
        request.setAttribute("result", null);

        return modelAndView;
    }


    /**
     * 과제관리 > 일반과제 > 변경 > WBS 저장
     *
     * @param input HashMap<String, Object>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return ModelAndView
     * */
    @RequestMapping(value="/prj/tss/gen/updateGenTssAltrWBS.do")
    public ModelAndView updateGenTssAltrWBS(@RequestParam HashMap<String, Object> input, HttpServletRequest request,
            HttpSession session, ModelMap model) {

        LOGGER.debug("###########################################################");
        LOGGER.debug("updateGenTssAltrWBS [과제관리 > 일반과제 > 변경 > WBS 저장]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSessionObjRUI(input, session, model);

        ModelAndView modelAndView = new ModelAndView("ruiView");

        List<Map<String, Object>> ds = null;

        try {
            ds = RuiConverter.convertToDataSet(request, "wbsDataSet");

            genTssAltrService.updateGenTssAltrWBS(ds);

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
     * 과제관리 > 일반과제 > 변경 > WBS 삭제
     *
     * @param input HashMap<String, Object>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return ModelAndView
     * */
    @RequestMapping(value="/prj/tss/gen/deleteGenTssAltrWBS.do")
    public ModelAndView deleteGenTssAltrWBS(@RequestParam HashMap<String, Object> input, HttpServletRequest request,
            HttpSession session, ModelMap model) {

        LOGGER.debug("###########################################################");
        LOGGER.debug("updateGenTssAltrWBS [과제관리 > 일반과제 > 변경 > WBS 삭제]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSessionObjRUI(input, session, model);

        ModelAndView modelAndView = new ModelAndView("ruiView");

        List<Map<String, Object>> ds = null;

        try {
            ds = RuiConverter.convertToDataSet(request, "wbsDataSet");
            genTssAltrService.deleteGenTssAltrWBS(ds);

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
     * 과제관리 > 일반과제 > 변경 > 투입예산 생성
     *
     * @param input HashMap<String, Object>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return ModelAndView
     * */
    @RequestMapping(value="/prj/tss/gen/insertGenTssAltrTrwiBudg.do")
    public ModelAndView insertGenTssAltrTrwiBudg(@RequestParam HashMap<String, Object> input, HttpServletRequest request, HttpServletResponse response,
            HttpSession session, ModelMap model) {

        LOGGER.debug("###########################################################");
        LOGGER.debug("insertGenTssAltrTrwiBudg [과제관리 > 일반과제 > 변경 > 투입예산 생성]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSessionObjRUI(input, session, model);

        ModelAndView modelAndView = new ModelAndView("ruiView");

        List<Map<String, Object>> ds = new ArrayList<Map<String,Object>>();
        ds.add(input);

        try {
            Map<String, Object> result = genTssPlnService.getGenTssPlnTrwiBudgInfo(input);
            if(!"0".equals(String.valueOf(result.get("infoCnt")))) {
                genTssAltrService.insertGenTssAltrTrwiBudg(input);

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



    //================================================================================================ 목표및산출물
    /**
     * 과제관리 > 일반과제 > 변경 > 목표및산출물 iframe 화면
     *
     * @param input HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return String
     * @throws JSONException
     * */
    @RequestMapping(value="/prj/tss/gen/genTssAltrGoalYldIfm.do")
    public String genTssAltrGoalYldIfm(@RequestParam HashMap<String, String> input, HttpServletRequest request,
            HttpSession session, ModelMap model) throws JSONException {

        LOGGER.debug("###########################################################");
        LOGGER.debug("GenTssController - genTssAltrGoalYldIfm [과제관리 > 일반과제 > 변경 > 목표및산출물 iframe 화면 ]");
        LOGGER.debug("###########################################################");

        checkSession(input, session, model);

        if(pageMoveChkSession(input.get("_userId"))) {
            //데이터 있을 경우
            List<Map<String, Object>> resultGoal = null;
            List<Map<String, Object>> resultYld  = null;

            if(!"".equals(input.get("tssCd")) && null != input.get("tssCd")) {
                resultGoal = genTssAltrService.retrieveGenTssAltrGoal(input);
                resultYld  = genTssAltrService.retrieveGenTssAltrYld(input);
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

        return "web/prj/tss/gen/altr/genTssAltrGoalYldIfm";
    }


    /**
     * 과제관리 > 일반과제 > 변경 > 목표및산출물 > 목표 조회
     *
     * @param input HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return String
     * @throws JSONException
     * */
    @RequestMapping(value="/prj/tss/gen/retrieveGenTssAltrGoal.do")
    public ModelAndView retrieveGenTssAltrGoal(@RequestParam HashMap<String, String> input, HttpServletRequest request,
            HttpSession session, ModelMap model) throws JSONException {

        LOGGER.debug("###########################################################");
        LOGGER.debug("retrieveGenTssAltrGoal [과제관리 > 일반과제 > 변경 > 목표및산출물 > 목표 조회]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSessionRUI(input, session, model);
        ModelAndView modelAndView = new ModelAndView("ruiView");

        List<Map<String, Object>> resultGoal = genTssAltrService.retrieveGenTssAltrGoal(input);
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
     * 과제관리 > 일반과제 > 변경 > 목표및산출물 > 산출물 조회
     *
     * @param input HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return String
     * @throws JSONException
     * */
    @RequestMapping(value="/prj/tss/gen/retrieveGenTssAltrYld.do")
    public ModelAndView retrieveGenTssAltrYld(@RequestParam HashMap<String, String> input, HttpServletRequest request,
            HttpSession session, ModelMap model) throws JSONException {

        LOGGER.debug("###########################################################");
        LOGGER.debug("retrieveGenTssAltrYld [과제관리 > 일반과제 > 변경 > 목표및산출물 > 산출물 조회]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSessionRUI(input, session, model);
        ModelAndView modelAndView = new ModelAndView("ruiView");

        List<Map<String, Object>> resultYld = genTssAltrService.retrieveGenTssAltrYld(input);
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
     * 과제관리 > 일반과제 > 변경 > 목표및산출물 > 목표 저장
     *
     * @param input HashMap<String, Object>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return ModelAndView
     * */
    @RequestMapping(value="/prj/tss/gen/updateGenTssAltrGoal.do")
    public ModelAndView updateGenTssAltrGoal(@RequestParam HashMap<String, Object> input, HttpServletRequest request,
            HttpSession session, ModelMap model) {

        LOGGER.debug("###########################################################");
        LOGGER.debug("updateGenTssAltrGoal [과제관리 > 일반과제 > 변경 > 목표및산출물 > 목표 저장]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSessionObjRUI(input, session, model);

        ModelAndView modelAndView = new ModelAndView("ruiView");

        List<Map<String, Object>> ds = null;

        try {
            ds  = RuiConverter.convertToDataSet(request, "goalDataSet");
            for(int i = 0; i < ds.size(); i++) {
                StringUtil.toUtf8Input((HashMap)ds.get(i));
            }

            genTssAltrService.updateGenTssAltrGoal(ds);

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
     * 과제관리 > 일반과제 > 변경 > 목표및산출물 > 산출물 저장
     *
     * @param input HashMap<String, Object>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return ModelAndView
     * */
    @RequestMapping(value="/prj/tss/gen/updateGenTssAltrYld.do")
    public ModelAndView updateGenTssAltrYld(@RequestParam HashMap<String, Object> input, HttpServletRequest request,
            HttpSession session, ModelMap model) {

        LOGGER.debug("###########################################################");
        LOGGER.debug("updateGenTssAltrYld [과제관리 > 일반과제 > 변경 > 목표및산출물 > 산출물 저장]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSessionObjRUI(input, session, model);

        ModelAndView modelAndView = new ModelAndView("ruiView");

        List<Map<String, Object>> ds = null;

        try {
            ds  = RuiConverter.convertToDataSet(request, "yldDataSet");
            for(int i = 0; i < ds.size(); i++) {
                StringUtil.toUtf8Input((HashMap)ds.get(i));
            }

            genTssAltrService.updateGenTssAltrYld(ds);

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
     * 과제관리 > 일반과제 > 변경 > 목표및산출물 > 목표 삭제
     *
     * @param input HashMap<String, Object>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return ModelAndView
     * */
    @RequestMapping(value="/prj/tss/gen/deleteGenTssAltrGoal.do")
    public ModelAndView deleteGenTssAltrGoal(@RequestParam HashMap<String, Object> input, HttpServletRequest request,
            HttpSession session, ModelMap model) {

        LOGGER.debug("###########################################################");
        LOGGER.debug("deleteGenTssAltrGoal [과제관리 > 일반과제 > 변경 > 목표및산출물 > 목표 삭제]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSessionObjRUI(input, session, model);

        ModelAndView modelAndView = new ModelAndView("ruiView");

        List<Map<String, Object>> ds = null;

        try {
            ds  = RuiConverter.convertToDataSet(request, "goalDataSet");
            genTssAltrService.deleteGenTssAltrGoal(ds);

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
     * 과제관리 > 일반과제 > 변경 > 목표및산출물 > 산출물 삭제
     *
     * @param input HashMap<String, Object>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return ModelAndView
     * */
    @RequestMapping(value="/prj/tss/gen/deleteGenTssAltrYld.do")
    public ModelAndView deleteGenTssAltrYld(@RequestParam HashMap<String, Object> input, HttpServletRequest request,
            HttpSession session, ModelMap model) {

        LOGGER.debug("###########################################################");
        LOGGER.debug("deleteGenTssAltrYld [과제관리 > 일반과제 > 변경 > 목표및산출물 > 산출물 삭제]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSessionObjRUI(input, session, model);

        ModelAndView modelAndView = new ModelAndView("ruiView");

        List<Map<String, Object>> ds = null;

        try {
            ds  = RuiConverter.convertToDataSet(request, "yldDataSet");
            genTssAltrService.deleteGenTssAltrYld(ds);

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
     * 과제관리 > 일반과제 > 변경 > 품의서요청 화면
     *
     * @param input HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return String
     * @throws JSONException
     * */
    @RequestMapping(value="/prj/tss/gen/genTssAltrCsusRq.do")
    public String genTssAltrCsusRq(@RequestParam HashMap<String, String> input, HttpServletRequest request,
            HttpSession session, ModelMap model) throws JSONException {

        LOGGER.debug("###########################################################");
        LOGGER.debug("genTssAltrCsusRq [과제관리 > 일반과제 > 변경 > 품의서요청 화면 ]");
        LOGGER.debug("###########################################################");

        checkSession(input, session, model);

        if(pageMoveChkSession(input.get("_userId"))) {
        	Map<String, Object> resultGrs         = genTssService.retrieveGenGrs(input); //마스터
        	Map<String, Object> resultMst        = genTssAltrService.retrieveGenTssAltrMst(input); //마스터
            Map<String, Object> resultCsus       = genTssService.retrieveGenTssCsus(resultMst); //품의서
            Map<String, Object> resultSmry       = genTssAltrService.retrieveGenTssAltrSmry(input); //개요
            List<Map<String, Object>> resultAltr = genTssAltrService.retrieveGenTssAltrSmryList(input);

            HashMap<String, String> inputInfo = new HashMap<String, String>();
            inputInfo.put("attcFilId", String.valueOf(resultSmry.get("altrAttcFilId")));

            List<Map<String, Object>> resultAttc  = genTssAltrService.retrieveGenTssAltrAttc(inputInfo);
            
            resultGrs  = StringUtil.toUtf8Output((HashMap) resultGrs);
            resultMst  = StringUtil.toUtf8Output((HashMap) resultMst);
            resultCsus = StringUtil.toUtf8Output((HashMap) resultCsus);
            resultSmry = StringUtil.toUtf8Output((HashMap) resultSmry);

            model.addAttribute("inputData", input);
            model.addAttribute("resultGrs", resultGrs);
            model.addAttribute("resultMst", resultMst);
            model.addAttribute("resultSmry", resultSmry);
            model.addAttribute("resultAltr", resultAltr);
            model.addAttribute("resultAttc", resultAttc);
            model.addAttribute("resultCsus", resultCsus);

            //text컬럼을 위한 json변환
            JSONObject obj = new JSONObject();
            obj.put("records", resultSmry);

            request.setAttribute("jsonSmry", obj);
        }

        return "web/prj/tss/gen/altr/genTssAltrCsusRq";
    }


    /**
     * 과제관리 > 일반과제 > 변경 > 품의서요청 생성
     *
     * @param input HashMap<String, Object>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return ModelAndView
     * */
    @RequestMapping(value="/prj/tss/gen/insertGenTssAltrCsusRq.do")
    public ModelAndView insertGenTssAltrCsusRq(@RequestParam HashMap<String, Object> input, HttpServletRequest request, HttpServletResponse response,
            HttpSession session, ModelMap model) {

        LOGGER.debug("###########################################################");
        LOGGER.debug("insertGenTssAltrCsusRq [과제관리 > 일반과제 > 변경 > 품의서요청 생성]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSessionObjRUI(input, session, model);

        ModelAndView modelAndView = new ModelAndView("ruiView");

        List<Map<String, Object>> ds = null;

        try {
            ds  = RuiConverter.convertToDataSet(request, "dataSet");
            genTssAltrService.insertGenTssAltrCsusRq(ds.get(0));

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
