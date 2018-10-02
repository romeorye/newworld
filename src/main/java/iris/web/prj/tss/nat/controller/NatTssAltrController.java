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
import org.springframework.web.servlet.ModelAndView;

import devonframe.message.saymessage.SayMessage;
import devonframe.util.NullUtil;
import iris.web.common.code.service.CodeService;
import iris.web.common.converter.RuiConverter;
import iris.web.common.util.MimeDecodeException;
import iris.web.common.util.StringUtil;
import iris.web.prj.tss.com.service.TssUserService;
import iris.web.prj.tss.gen.service.GenTssAltrService;
import iris.web.prj.tss.gen.service.GenTssService;
import iris.web.prj.tss.nat.service.NatTssAltrService;
import iris.web.prj.tss.ousdcoo.service.OusdCooTssService;
import iris.web.system.base.IrisBaseController;


/********************************************************************************
 * NAME : NatTssAltrController.java
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
@SuppressWarnings({ "rawtypes" })
public class NatTssAltrController  extends IrisBaseController {

    @Resource(name="messageSourceAccessor")
    private MessageSourceAccessor messageSourceAccessor;

    @Resource(name = "tssUserService")
    private TssUserService tssUserService;

    @Resource(name = "genTssService")
    private GenTssService genTssService;

    @Resource(name = "natTssAltrService")
    private NatTssAltrService natTssAltrService;

    @Resource(name = "genTssAltrService")
    private GenTssAltrService genTssAltrService;

    @Resource(name = "ousdCooTssService")
    private OusdCooTssService ousdCooTssService;			// 대외협력과제 서비스

    @Resource(name = "codeService")
    private CodeService codeService;

    static final Logger LOGGER = LogManager.getLogger(NatTssAltrController.class);


    //================================================================================================ 마스터
    /**
     * 과제관리 > 국책과제 > 변경 > 마스터 조회
     *
     * @param input HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return String
     * @throws JSONException
     * */
    @RequestMapping(value="/prj/tss/nat/natTssAltrDetail.do")
    public String retrieveNatTssAltrMst(@RequestParam HashMap<String, String> input, HttpServletRequest request,
            HttpSession session, ModelMap model) throws JSONException {

        LOGGER.debug("###########################################################");
        LOGGER.debug("retrieveNatTssAltrMst [과제관리 > 국책과제 > 변경 > 마스터 조회]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSession(input, session, model);

        if(pageMoveChkSession(input.get("_userId"))) {
            //마스터정보 조회
            Map<String, Object> result = natTssAltrService.retrieveNatTssAltrMst(input);
            StringUtil.toUtf8Output((HashMap)result);

            //개요존재여부 조회
            Map<String, Object> resultSmryInfo = natTssAltrService.retrieveNatTssAltrSmryInfo(result);
            if(resultSmryInfo != null && resultSmryInfo.size() > 0) result.put("smryYn", resultSmryInfo.get("tssCd"));

            //사용자버튼권한 조회
            Map<String, Object> role = tssUserService.getTssBtnRoleChk(input, result);
            result.put("tssRoleType", role.get("tssRoleType"));
            result.put("tssRoleId",   role.get("tssRoleId"));

            if("TR04".equals(role.get("tssRoleId"))) {
                result.put("tssRoleType", "R");
            }

            List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
            list.add(result);

            JSONObject obj = new JSONObject();
            obj.put("records", list);

            request.setAttribute("inputData", input);
            request.setAttribute("resultCnt", result == null ? 0 : result.size());
            request.setAttribute("result", obj);
        }

        return "web/prj/tss/nat/altr/natTssAltrDetail";
    }


    /**
     * 과제관리 > 국책과제 > 변경 > 마스터 신규
     *
     * @param input HashMap<String, Object>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return ModelAndView
     * */
    @RequestMapping(value="/prj/tss/nat/insertNatTssAltrMst.do")
    public ModelAndView insertNatTssAltrMst(@RequestParam HashMap<String, Object> input, HttpServletRequest request,
            HttpSession session, ModelMap model) {

        LOGGER.debug("###########################################################");
        LOGGER.debug("insertNatTssAltrMst [과제관리 > 국책과제 > 변경 > 마스터 신규]");
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


            boolean errYn   = false;
            boolean upWbsCd = false;

            if(!errYn) {
                StringUtil.toUtf8Input(smryDs);
                natTssAltrService.insertNatTssAltrMst(mstDs, smryDs, altrDs, upWbsCd);

                mstDs.put("rtCd", "SUCCESS");
                mstDs.put("rtVal",messageSourceAccessor.getMessage("msg.alert.saved")); //저장되었습니다.
                mstDs.put("rtType", "I");
            }
        } catch(Exception e) {
            e.printStackTrace();
            mstDs.put("rtCd", "FAIL");
            mstDs.put("rtVal", messageSourceAccessor.getMessage("msg.alert.error")); //오류가 발생하였습니다.
        }

        modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", mstDs));

        return modelAndView;
    }


    /**
     * 과제관리 > 국책과제 > 변경 > 마스터 수정
     *
     * @param input HashMap<String, Object>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return ModelAndView
     * */
    @RequestMapping(value="/prj/tss/nat/updateNatTssAltrMst.do")
    public ModelAndView updateNatTssAltrMst(@RequestParam HashMap<String, Object> input, HttpServletRequest request,
            HttpSession session, ModelMap model) {

        LOGGER.debug("###########################################################");
        LOGGER.debug("updateNatTssAltrMst [과제관리 > 국책과제 > 변경 > 마스터 수정]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSessionObjRUI(input, session, model);

        ModelAndView modelAndView = new ModelAndView("ruiView");

        HashMap<String, Object> mstDs  = new HashMap<String, Object>();
        HashMap<String, Object> smryDs = new HashMap<String, Object>();

        try {
            mstDs  = (HashMap<String, Object>)RuiConverter.convertToDataSet(request, "mstDataSet").get(0);
            smryDs = (HashMap<String, Object>)RuiConverter.convertToDataSet(request, "smryDataSet").get(0);
            List<Map<String, Object>> altrDs = RuiConverter.convertToDataSet(request, "altrDataSet");

            boolean errYn   = false;
            boolean upWbsCd = false;

            if(!errYn) {
                StringUtil.toUtf8Input(smryDs);
                natTssAltrService.updateNatTssAltrMst(mstDs, smryDs, altrDs, upWbsCd);

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
     * 과제관리 > 국책과제 > 변경 > 변경개요 iframe 조회
     *
     * @param input HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return String
     * @throws JSONException
     * */
    @RequestMapping(value="/prj/tss/nat/natTssAltrIfm.do")
    public String retrieveNatTssAltrSmry1(@RequestParam HashMap<String, String> input, HttpServletRequest request,
            HttpSession session, ModelMap model) throws JSONException {

        LOGGER.debug("###########################################################");
        LOGGER.debug("retrieveNatTssAltrSmry [과제관리 > 국책과제 > 변경 > 개요 조회]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSession(input, session, model);

        if(pageMoveChkSession(input.get("_userId"))) {
            //데이터 있을 경우
            Map<String, Object> result = null;
            if(!"".equals(input.get("tssCd")) && null != input.get("tssCd")) {
                result = natTssAltrService.retrieveNatTssAltrSmry(input);
            }
            StringUtil.toUtf8Output((HashMap)result);

            List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
            list.add(result);

            JSONObject obj = new JSONObject();
            obj.put("records", list);

            request.setAttribute("inputData", input);
            request.setAttribute("resultCnt", result == null ? 0 : result.size());
            request.setAttribute("result", obj);
        }

        return "web/prj/tss/nat/altr/natTssAltrIfm";
    }


    /**
     * 과제관리 > 국책과제 > 변경 > 변경개요목록 조회
     *
     * @param input HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return String
     * */
    @RequestMapping(value="/prj/tss/nat/retrieveNatTssAltrSmryList.do")
    public ModelAndView retrieveNatTssAltrSmryList(@RequestParam HashMap<String, String> input, HttpServletRequest request,
            HttpSession session, ModelMap model) {

        LOGGER.debug("###########################################################");
        LOGGER.debug("retrieveNatTssAltrSmryList [과제관리 > 국책과제 > 변경 > 변경개요목록 조회]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSessionRUI(input, session, model);
        ModelAndView modelAndView = new ModelAndView("ruiView");

        List<Map<String, Object>> result = natTssAltrService.retrieveNatTssAltrSmryList(input);

        modelAndView.addObject("dataset", RuiConverter.createDataset("dataset", result));

        //jsp에 있는 el에 담기위한 쓰레기 데이터
        //        request.setAttribute("resultCnt", 0);
        //        request.setAttribute("result", null);

        return modelAndView;
    }



    //================================================================================================ 개요
    /**
     * 과제관리 > 국책과제 > 변경 > 개요 iframe 조회
     *
     * @param input HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return String
     * @throws JSONException
     * */
    @RequestMapping(value="/prj/tss/nat/natTssAltrSmryIfm.do")
    public String retrieveNatTssAltrSmry2(@RequestParam HashMap<String, String> input, HttpServletRequest request,
            HttpSession session, ModelMap model) throws JSONException {

        LOGGER.debug("###########################################################");
        LOGGER.debug("retrieveNatTssAltrSmry [과제관리 > 국책과제 > 변경 > 개요 조회]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSession(input, session, model);

        if(pageMoveChkSession(input.get("_userId"))) {
            //개요
            Map<String, Object> result = natTssAltrService.retrieveNatTssAltrSmry(input);
            StringUtil.toUtf8Output((HashMap)result);

            List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
            list.add(result);

            JSONObject obj = new JSONObject();
            obj.put("records", list);

            //차수별 수행기간
            List<Map<String, Object>> resultNos = natTssAltrService.retrieveNatTssNosYmd(input);

            request.setAttribute("inputData", input);
            request.setAttribute("resultCnt", result == null ? 0 : result.size());
            request.setAttribute("result", obj);
            request.setAttribute("resultNosCnt", resultNos == null ? 0 : resultNos.size());
            request.setAttribute("resultNos", resultNos);
        }

        return "web/prj/tss/nat/pln/natTssPlnSmryIfm";
    }


    /**
     * 과제관리 > 국책과제 > 변경 > 개요 기관 조회
     *
     * @param input HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return String
     * @throws JSONException
     * */
    @RequestMapping(value="/prj/tss/nat/retrieveNatTssAltrSmryInst.do")
    public ModelAndView retrieveNatTssAltrSmryInst(@RequestParam HashMap<String, String> input, HttpServletRequest request,
            HttpSession session, ModelMap model) throws JSONException {

        LOGGER.debug("###########################################################");
        LOGGER.debug("retrieveNatTssAltrSmryInst [과제관리 > 국책과제 > 변경 > 개요 기관 조회]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSessionRUI(input, session, model);
        ModelAndView modelAndView = new ModelAndView("ruiView");

        List<Map<String, Object>> resultYld = natTssAltrService.retrieveNatTssAltrSmryInst(input);
        modelAndView.addObject("dataset", RuiConverter.createDataset("dataset", resultYld));

        return modelAndView;
    }


    /**
     * 과제관리 > 국책과제 > 변경 > 개요 저장
     *
     * @param input HashMap<String, Object>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return ModelAndView
     * */
    @RequestMapping(value="/prj/tss/nat/updateNatTssAltrSmry.do")
    public ModelAndView updateNatTssAltrSmry(@RequestParam HashMap<String, Object> input, HttpServletRequest request, HttpServletResponse response,
            HttpSession session, ModelMap model) {

        LOGGER.debug("###########################################################");
        LOGGER.debug("updateNatTssAltrPtcRsstMbr [과제관리 > 국책과제 > 변경 > 개요 저장]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSessionObjRUI(input, session, model);

        ModelAndView modelAndView = new ModelAndView("ruiView");

        List<Map<String, Object>> smryDs = null;
        HashMap<String, Object> smryDecodeDs = null;

        try {
            smryDs  = RuiConverter.convertToDataSet(request, "smryDataSet");
            List<Map<String, Object>> altrDs  = RuiConverter.convertToDataSet(request, "smryInstDataSet");

            smryDecodeDs = (HashMap<String, Object>)smryDs.get(0); //에디터데이터 디코딩처리

            
            natTssAltrService.updateNatTssAltrSmry2( StringUtil.toUtf8Input(smryDecodeDs), altrDs);

            smryDs.get(0).put("rtCd", "SUCCESS");
            smryDs.get(0).put("rtVal",messageSourceAccessor.getMessage("msg.alert.saved")); //저장되었습니다.

        } catch(MimeDecodeException e) {
            LOGGER.debug("MimeDecodeException ERROR");
            e.printStackTrace();
            smryDs.get(0).put("rtCd", "FAIL");
            smryDs.get(0).put("rtVal", messageSourceAccessor.getMessage("msg.alert.imageUploadError")); //이미지파일 등록에 실패했습니다.
        } catch(Exception e) {
            e.printStackTrace();
            smryDs.get(0).put("rtCd", "FAIL");
            smryDs.get(0).put("rtVal", messageSourceAccessor.getMessage("msg.alert.error")); //오류가 발생하였습니다.
        }

        modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", smryDs));

        return modelAndView;
    }


    //================================================================================================ 사업비
    /**
     * 과제관리 > 국책과제 > 변경 > 사업비 iframe 화면
     *
     * @param input HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return String
     * @throws JSONException
     * */
    @RequestMapping(value="/prj/tss/nat/natTssAltrTrwiBudgIfm.do")
    public String natTssAltrTrwiBudgIfm(@RequestParam HashMap<String, String> input, HttpServletRequest request,
            HttpSession session, ModelMap model) throws JSONException {

        LOGGER.debug("###########################################################");
        LOGGER.debug("NatTssController - natTssAltrTrwiBudgIfm [과제관리 > 국책과제 > 변경 > 사업비 iframe 화면 ]");
        LOGGER.debug("###########################################################");

        checkSession(input, session, model);

        if(pageMoveChkSession(input.get("_userId"))) {
            //데이터 있을 경우
            List<Map<String, Object>> result = null;
            if(!"".equals(input.get("tssCd")) && null != input.get("tssCd")) {
                result = natTssAltrService.retrieveNatTssAltrTrwiBudg(input);
            }

            JSONObject obj = new JSONObject();
            obj.put("records", result);

            request.setAttribute("resultCnt", result == null ? 0 : result.size());
            request.setAttribute("result", obj);

            model.addAttribute("inputData", input);
        }

        return "web/prj/tss/nat/pln/natTssPlnTrwiBudgIfm";
    }


    /**
     * 과제관리 > 국책과제 > 변경 > 사업비 조회
     *
     * @param input HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return String
     * */
    @RequestMapping(value="/prj/tss/nat/retrieveNatTssAltrTrwiBudg.do")
    public ModelAndView retrieveNatTssAltrTrwiBudg(@RequestParam HashMap<String, String> input, HttpServletRequest request,
            HttpSession session, ModelMap model) {

        LOGGER.debug("###########################################################");
        LOGGER.debug("retrieveNatTssAltrTrwiBudg [과제관리 > 국책과제 > 변경 > 사업비 조회]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSessionRUI(input, session, model);
        ModelAndView modelAndView = new ModelAndView("ruiView");

        List<Map<String, Object>> result = natTssAltrService.retrieveNatTssAltrTrwiBudg(input);

        modelAndView.addObject("dataset", RuiConverter.createDataset("dataset", result));

        //jsp에 있는 el에 담기위한 쓰레기 데이터
        request.setAttribute("resultCnt", 0);
        request.setAttribute("result", null);

        return modelAndView;
    }


    /**
     * 과제관리 > 국책과제 > 변경 > 사업비 저장
     *
     * @param input HashMap<String, Object>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return ModelAndView
     * */
    @RequestMapping(value="/prj/tss/nat/updateNatTssAltrTrwiBudg.do")
    public ModelAndView updateNatTssAltrTrwiBudg(@RequestParam HashMap<String, Object> input, HttpServletRequest request,
            HttpSession session, ModelMap model) {

        LOGGER.debug("###########################################################");
        LOGGER.debug("updateNatTssAltrTrwiBudg [과제관리 > 국책과제 > 변경 > 사업비 저장]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSessionObjRUI(input, session, model);

        ModelAndView modelAndView = new ModelAndView("ruiView");

        List<Map<String, Object>> ds = null;
        String maxWbsSn = null;

        try {
            ds  = RuiConverter.convertToDataSet(request, "tbDataSet");
            natTssAltrService.updateNatTssAltrTrwiBudg(ds);

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
     * 과제관리 > 국책과제 > 변경 > 참여연구원 iframe 화면
     *
     * @param input HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return String
     * @throws JSONException
     * */
    @RequestMapping(value="/prj/tss/nat/natTssAltrPtcRsstMbrIfm.do")
    public String natTssAltrPtcRsstMbrIfm(@RequestParam HashMap<String, String> input, HttpServletRequest request,
            HttpSession session, ModelMap model) throws JSONException {

        LOGGER.debug("###########################################################");
        LOGGER.debug("NatTssController - natTssAltrPtcRsstMbrIfm [과제관리 > 국책과제 > 변경 > 참여연구원 iframe 화면 ]");
        LOGGER.debug("###########################################################");

        checkSession(input, session, model);

        if(pageMoveChkSession(input.get("_userId"))) {
            List <Map<String, Object>> codeRtcRole  = codeService.retrieveCodeValueList("PTC_ROLE_NAT"); //참여역할

            model.addAttribute("codeRtcRole", codeRtcRole);

            List<Map<String, Object>> result = natTssAltrService.retrieveNatTssAltrPtcRsstMbr(input);

            JSONObject obj = new JSONObject();
            obj.put("records", result);

            request.setAttribute("resultCnt", result == null ? 0 : result.size());
            request.setAttribute("result", obj);

            model.addAttribute("inputData", input);
        }

        return "web/prj/tss/nat/pln/natTssPlnPtcRsstMbrIfm";
    }


    /**
     * 과제관리 > 대회협력과제 > 계획 > 참여연구원 조회
     *
     * @param input HashMap<String, Object>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return ModelAndView
     * */
    @RequestMapping(value="/prj/tss/nat/retrieveNatTssAltrPtcRsstMbr.do")
    public ModelAndView retrieveNatTssAltrPtcRsstMbr(@RequestParam HashMap<String, String> input, HttpServletRequest request, HttpServletResponse response,
            HttpSession session, ModelMap model) {

        LOGGER.debug("###########################################################");
        LOGGER.debug("retrieveNatTssPlnPtcRsstMbr [과제관리 > 대회협력과제 > 계획 > 참여연구원 저장]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSessionRUI(input, session, model);

        ModelAndView modelAndView = new ModelAndView("ruiView");

        List<Map<String, Object>> ds = natTssAltrService.retrieveNatTssAltrPtcRsstMbr(input);

        modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", ds));

        return modelAndView;
    }


    /**
     * 과제관리 > 국책과제 > 변경 > 참여연구원 저장
     *
     * @param input HashMap<String, Object>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return ModelAndView
     * */
    @RequestMapping(value="/prj/tss/nat/updateNatTssAltrPtcRsstMbr.do")
    public ModelAndView updateNatTssAltrPtcRsstMbr(@RequestParam HashMap<String, Object> input, HttpServletRequest request, HttpServletResponse response,
            HttpSession session, ModelMap model) {

        LOGGER.debug("###########################################################");
        LOGGER.debug("updateNatTssAltrPtcRsstMbr [과제관리 > 국책과제 > 변경 > 참여연구원 저장]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSessionObjRUI(input, session, model);

        ModelAndView modelAndView = new ModelAndView("ruiView");

        List<Map<String, Object>> ds = null;

        try {
            ds  = RuiConverter.convertToDataSet(request, "mbrDataSet");
            natTssAltrService.updateNatTssAltrPtcRsstMbr(ds);

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
     * 과제관리 > 국책과제 > 변경 > 참여연구원 삭제
     *
     * @param input HashMap<String, Object>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return ModelAndView
     * */
    @RequestMapping(value="/prj/tss/nat/deleteNatTssAltrPtcRsstMbr.do")
    public ModelAndView deleteNatTssAltrPtcRsstMbr(@RequestParam HashMap<String, Object> input, HttpServletRequest request, HttpServletResponse response,
            HttpSession session, ModelMap model) {

        LOGGER.debug("###########################################################");
        LOGGER.debug("deleteNatTssAltrPtcRsstMbr [과제관리 > 국책과제 > 변경 > 참여연구원 삭제]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSessionObjRUI(input, session, model);

        ModelAndView modelAndView = new ModelAndView("ruiView");

        List<Map<String, Object>> ds = null;

        try {
            ds  = RuiConverter.convertToDataSet(request, "mbrDataSet");
            natTssAltrService.deleteNatTssAltrPtcRsstMbr(ds);

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
     * 과제관리 > 국책과제 > 변경 > 목표및산출물 iframe 화면
     *
     * @param input HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return String
     * @throws JSONException
     * */
    @RequestMapping(value="/prj/tss/nat/natTssAltrGoalYldIfm.do")
    public String natTssAltrGoalYldIfm(@RequestParam HashMap<String, String> input, HttpServletRequest request,
            HttpSession session, ModelMap model) throws JSONException {

        LOGGER.debug("###########################################################");
        LOGGER.debug("NatTssController - natTssAltrGoalYldIfm [과제관리 > 국책과제 > 변경 > 목표및산출물 iframe 화면 ]");
        LOGGER.debug("###########################################################");

        checkSession(input, session, model);

        if(pageMoveChkSession(input.get("_userId"))) {
            //데이터 있을 경우
            List<Map<String, Object>> resultGoal = null;
            List<Map<String, Object>> resultYld  = null;

            if(!"".equals(input.get("tssCd")) && null != input.get("tssCd")) {
                resultGoal = natTssAltrService.retrieveNatTssAltrGoal(input);
                resultYld  = natTssAltrService.retrieveNatTssAltrYld(input);
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

        return "web/prj/tss/nat/pln/natTssPlnGoalYldIfm";
    }


    /**
     * 과제관리 > 국책과제 > 변경 > 목표및산출물 > 목표 조회
     *
     * @param input HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return String
     * @throws JSONException
     * */
    @RequestMapping(value="/prj/tss/nat/retrieveNatTssAltrGoal.do")
    public ModelAndView retrieveNatTssAltrGoal(@RequestParam HashMap<String, String> input, HttpServletRequest request,
            HttpSession session, ModelMap model) throws JSONException {

        LOGGER.debug("###########################################################");
        LOGGER.debug("retrieveNatTssAltrGoal [과제관리 > 국책과제 > 변경 > 목표및산출물 > 목표 조회]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSessionRUI(input, session, model);
        ModelAndView modelAndView = new ModelAndView("ruiView");

        List<Map<String, Object>> resultGoal = natTssAltrService.retrieveNatTssAltrGoal(input);
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
     * 과제관리 > 국책과제 > 변경 > 목표및산출물 > 산출물 조회
     *
     * @param input HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return String
     * @throws JSONException
     * */
    @RequestMapping(value="/prj/tss/nat/retrieveNatTssAltrYld.do")
    public ModelAndView retrieveNatTssAltrYld(@RequestParam HashMap<String, String> input, HttpServletRequest request,
            HttpSession session, ModelMap model) throws JSONException {

        LOGGER.debug("###########################################################");
        LOGGER.debug("retrieveNatTssAltrYld [과제관리 > 국책과제 > 변경 > 목표및산출물 > 산출물 조회]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSessionRUI(input, session, model);
        ModelAndView modelAndView = new ModelAndView("ruiView");

        List<Map<String, Object>> resultYld = natTssAltrService.retrieveNatTssAltrYld(input);
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
     * 과제관리 > 국책과제 > 변경 > 목표및산출물 > 목표 저장
     *
     * @param input HashMap<String, Object>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return ModelAndView
     * */
    @RequestMapping(value="/prj/tss/nat/updateNatTssAltrGoal.do")
    public ModelAndView updateNatTssAltrGoal(@RequestParam HashMap<String, Object> input, HttpServletRequest request,
            HttpSession session, ModelMap model) {

        LOGGER.debug("###########################################################");
        LOGGER.debug("updateNatTssAltrGoal [과제관리 > 국책과제 > 변경 > 목표및산출물 > 목표 저장]");
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

            natTssAltrService.updateNatTssAltrGoal(ds);

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
     * 과제관리 > 국책과제 > 변경 > 목표및산출물 > 산출물 저장
     *
     * @param input HashMap<String, Object>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return ModelAndView
     * */
    @RequestMapping(value="/prj/tss/nat/updateNatTssAltrYld.do")
    public ModelAndView updateNatTssAltrYld(@RequestParam HashMap<String, Object> input, HttpServletRequest request,
            HttpSession session, ModelMap model) {

        LOGGER.debug("###########################################################");
        LOGGER.debug("updateNatTssAltrYld [과제관리 > 국책과제 > 변경 > 목표및산출물 > 산출물 저장]");
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

            natTssAltrService.updateNatTssAltrYld(ds);

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
     * 과제관리 > 국책과제 > 변경 > 목표및산출물 > 목표 삭제
     *
     * @param input HashMap<String, Object>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return ModelAndView
     * */
    @RequestMapping(value="/prj/tss/nat/deleteNatTssAltrGoal.do")
    public ModelAndView deleteNatTssAltrGoal(@RequestParam HashMap<String, Object> input, HttpServletRequest request,
            HttpSession session, ModelMap model) {

        LOGGER.debug("###########################################################");
        LOGGER.debug("deleteNatTssAltrGoal [과제관리 > 국책과제 > 변경 > 목표및산출물 > 목표 삭제]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSessionObjRUI(input, session, model);

        ModelAndView modelAndView = new ModelAndView("ruiView");

        List<Map<String, Object>> ds = null;

        try {
            ds  = RuiConverter.convertToDataSet(request, "goalDataSet");
            natTssAltrService.deleteNatTssAltrGoal(ds);

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
     * 과제관리 > 국책과제 > 변경 > 목표및산출물 > 산출물 삭제
     *
     * @param input HashMap<String, Object>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return ModelAndView
     * */
    @RequestMapping(value="/prj/tss/nat/deleteNatTssAltrYld.do")
    public ModelAndView deleteNatTssAltrYld(@RequestParam HashMap<String, Object> input, HttpServletRequest request,
            HttpSession session, ModelMap model) {

        LOGGER.debug("###########################################################");
        LOGGER.debug("deleteNatTssAltrYld [과제관리 > 국책과제 > 변경 > 목표및산출물 > 산출물 삭제]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSessionObjRUI(input, session, model);

        ModelAndView modelAndView = new ModelAndView("ruiView");

        List<Map<String, Object>> ds = null;

        try {
            ds  = RuiConverter.convertToDataSet(request, "yldDataSet");
            natTssAltrService.deleteNatTssAltrYld(ds);

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
     * 과제관리 > 국책과제 > 변경 > 품의서요청 화면
     *
     * @param input HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return String
     * @throws JSONException
     * */
    @RequestMapping(value="/prj/tss/nat/natTssAltrCsusRq.do")
    public String natTssAltrCsusRq(@RequestParam HashMap<String, String> input, HttpServletRequest request,
            HttpSession session, ModelMap model) throws JSONException {

        LOGGER.debug("###########################################################");
        LOGGER.debug("natTssAltrCsusRq [과제관리 > 국책과제 > 변경 > 품의서요청 화면 ]");
        LOGGER.debug("###########################################################");

        checkSession(input, session, model);

        if(pageMoveChkSession(input.get("_userId"))) {
            Map<String, Object> resultMst        = natTssAltrService.retrieveNatTssAltrMst(input); //마스터
            Map<String, Object> resultSmry       = natTssAltrService.retrieveNatTssAltrSmry(input); //개요
            List<Map<String, Object>> resultAltr = natTssAltrService.retrieveNatTssAltrSmryList(input);
            Map<String, Object> resultCsus       = genTssService.retrieveGenTssCsus(resultMst); //품의서

            HashMap<String, String> inputInfo = new HashMap<String, String>();
            inputInfo.put("pgTssCd",   String.valueOf(resultMst.get("pgTssCd")));
            inputInfo.put("attcFilId", String.valueOf(resultSmry.get("altrAttcFilId")));

            Map<String, Object> resultInfo        = natTssAltrService.retrieveNatTssAltrInfo(inputInfo);
            List<Map<String, Object>> resultAttc  = natTssAltrService.retrieveNatTssAltrAttc(inputInfo); //첨부파일

            StringUtil.toUtf8Output((HashMap)resultMst);
            StringUtil.toUtf8Output((HashMap)resultSmry);
            StringUtil.toUtf8Output((HashMap)resultCsus);
            StringUtil.toUtf8Output((HashMap)resultInfo);

            model.addAttribute("inputData", input);
            model.addAttribute("resultMst", resultMst);
            model.addAttribute("resultSmry", resultSmry);
            model.addAttribute("resultAltr", resultAltr);
            model.addAttribute("resultInfo", resultInfo);
            model.addAttribute("resultAttc", resultAttc);
            model.addAttribute("resultCsus", resultCsus);

            //text컬럼을 위한 json변환
            JSONObject obj = new JSONObject();
            obj.put("jsonSmry", resultSmry);

            request.setAttribute("resultJson", obj);
        }

        return "web/prj/tss/nat/altr/natTssAltrCsusRq";
    }


    /**
     * 과제관리 > 국책과제 > 변경 > 품의서요청 생성
     *
     * @param input HashMap<String, Object>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return ModelAndView
     * */
    @RequestMapping(value="/prj/tss/nat/insertNatTssAltrCsusRq.do")
    public ModelAndView insertNatTssAltrCsusRq(@RequestParam HashMap<String, Object> input, HttpServletRequest request, HttpServletResponse response,
            HttpSession session, ModelMap model) {

        LOGGER.debug("###########################################################");
        LOGGER.debug("insertNatTssAltrCsusRq [과제관리 > 국책과제 > 변경 > 품의서요청 생성]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSessionObjRUI(input, session, model);

        ModelAndView modelAndView = new ModelAndView("ruiView");

        List<Map<String, Object>> ds = null;

        try {
            ds  = RuiConverter.convertToDataSet(request, "dataSet");
            natTssAltrService.insertNatTssAltrCsusRq(ds.get(0));

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
