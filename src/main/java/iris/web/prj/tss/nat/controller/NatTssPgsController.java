package iris.web.prj.tss.nat.controller;

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
import iris.web.common.code.service.CodeService;
import iris.web.common.converter.RuiConverter;
import iris.web.common.util.StringUtil;
import iris.web.prj.tss.com.service.TssUserService;
import iris.web.prj.tss.nat.service.NatTssAltrService;
import iris.web.prj.tss.nat.service.NatTssPgsService;
import iris.web.system.base.IrisBaseController;


/********************************************************************************
 * NAME : NatTssPgsController.java
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
public class NatTssPgsController  extends IrisBaseController {

    @Resource(name="messageSourceAccessor")
    private MessageSourceAccessor messageSourceAccessor;

    @Resource(name = "tssUserService")
    private TssUserService tssUserService;

    @Resource(name = "natTssPgsService")
    private NatTssPgsService natTssPgsService;

    @Resource(name = "natTssAltrService")
    private NatTssAltrService natTssAltrService;

    @Resource(name = "codeService")
    private CodeService codeService;

    static final Logger LOGGER = LogManager.getLogger(NatTssPgsController.class);


    //================================================================================================ 마스터
    /**
     * 과제관리 > 국책과제 > 진행 > 마스터 조회
     *
     * @param input HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return String
     * @throws JSONException
     * */
    @RequestMapping(value="/prj/tss/nat/natTssPgsDetail.do")
    public String natTssPgsMst(@RequestParam HashMap<String, String> input, HttpServletRequest request,
            HttpSession session, ModelMap model) throws JSONException {

        LOGGER.debug("###########################################################");
        LOGGER.debug("natTssPgsMst [과제관리 > 국책과제 > 진행 > 마스터 조회]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSession(input, session, model);

        if(pageMoveChkSession(input.get("_userId"))) {
            Map<String, Object> result = natTssPgsService.retrieveNatTssPgsMst(input);
            result = StringUtil.toUtf8Output((HashMap) result);

            Map<String, Object> role = tssUserService.getTssBtnRoleChk(input, result);
            result.put("tssRoleType", role.get("tssRoleType"));
            result.put("tssRoleId",   role.get("tssRoleId"));

            List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
            list.add(result);

            JSONObject obj = new JSONObject();
            obj.put("records", list);

            request.setAttribute("inputData", input);
            request.setAttribute("resultCnt", result == null ? 0 : result.size());
            request.setAttribute("result", obj);
        }

        return "web/prj/tss/nat/pgs/natTssPgsDetail";
    }


    /**
     * 과제관리 > 일반과제 > 진행 > 품의요청 화면
     *
     * @param input HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return String
     * @throws JSONException
     * */
    @RequestMapping(value="/prj/tss/nat/natTssPgsCsus.do")
    public String natTssPgsCsus(@RequestParam HashMap<String, String> input, HttpServletRequest request,
            HttpSession session, ModelMap model) throws JSONException {

        LOGGER.debug("###########################################################");
        LOGGER.debug("natTssPgsCsus [과제관리 > 일반과제 > 진행 > 변경품의]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSession(input, session, model);

        String returnUrl = "web/prj/tss/nat/natTssPgsDetail";

        if(pageMoveChkSession(input.get("_userId"))) {

            String pgsStepCd = input.get("pgsStepCd");

            //변경화면
            if("AL".equals(pgsStepCd)) {
                returnUrl = "web/prj/tss/nat/altr/natTssAltrDetail";
            }
            //중단화면
            else if("DC".equals(pgsStepCd)) {
                returnUrl = "web/prj/tss/nat/dcac/natTssDcacDetail";
            }
            //완료화면
            else if("CM".equals(pgsStepCd)) {
                returnUrl = "web/prj/tss/nat/cmpl/natTssCmplDetail";
            }

            input.put("userId", input.get("_userId"));
            input.put("tssCd", input.get("pgTssCd"));
            input.put("tssSt", "102"); //진행과제 GRS요청완료상태로 변경

            Map<String, Object> result = natTssPgsService.retrieveNatTssPgsCsus(input);
            result = StringUtil.toUtf8Output((HashMap) result);

            Map<String, Object> role = tssUserService.getTssBtnRoleChk(input, result);
            result.put("tssRoleType", role.get("tssRoleType"));
            result.put("tssRoleId",   role.get("tssRoleId"));

            //개요존재여부 조회
            Map<String, Object> resultSmryInfo = natTssAltrService.retrieveNatTssAltrSmryInfo(result);
            if(resultSmryInfo != null && resultSmryInfo.size() > 0) result.put("smryYn", resultSmryInfo.get("tssCd"));

            List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
            list.add(result);

            JSONObject obj = new JSONObject();
            obj.put("records", list);

            //차수별 수행기간
            List<Map<String, Object>> resultNos = natTssPgsService.retrieveNatTssNosYmd(input);

            request.setAttribute("inputData", input);
            request.setAttribute("resultCnt", result == null ? 0 : result.size());
            request.setAttribute("result", obj);
            request.setAttribute("resultNosCnt", resultNos == null ? 0 : resultNos.size());
            request.setAttribute("resultNos", resultNos);
        }

        return returnUrl;
    }



    //================================================================================================ 개요
    /**
     * 과제관리 > 국책과제 > 진행 > 개요 조회
     *
     * @param input HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return String
     * @throws JSONException
     * */
    @RequestMapping(value="/prj/tss/nat/natTssPgsSmryIfm.do")
    public String natTssPgsSmryIfm(@RequestParam HashMap<String, String> input, HttpServletRequest request,
            HttpSession session, ModelMap model) throws JSONException {

        LOGGER.debug("###########################################################");
        LOGGER.debug("natTssPgsSmryIfm [과제관리 > 국책과제 > 진행 > 개요 조회]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSession(input, session, model);

        if(pageMoveChkSession(input.get("_userId"))) {
            //개요
            Map<String, Object> result = natTssPgsService.retrieveNatTssPgsSmry(input);
            result = StringUtil.toUtf8Output((HashMap) result);

            List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
            list.add(result);

            JSONObject obj = new JSONObject();
            obj.put("records", list);

            //차수별 수행기간
            List<Map<String, Object>> resultNos = natTssPgsService.retrieveNatTssNosYmd(input);

            request.setAttribute("inputData", input);
            request.setAttribute("resultCnt", result == null ? 0 : result.size());
            request.setAttribute("result", obj);
            request.setAttribute("resultNosCnt", resultNos == null ? 0 : resultNos.size());
            request.setAttribute("resultNos", resultNos);
        }

        return "web/prj/tss/nat/pgs/natTssPgsSmryIfm";
    }


    /**
     * 과제관리 > 국책과제 > 진행 > 개요 기관 조회
     *
     * @param input HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return ModelAndView
     * @throws JSONException
     * */
    @RequestMapping(value="/prj/tss/nat/retrieveNatTssPgsSmryInst.do")
    public ModelAndView retrieveNatTssPgsSmryInst(@RequestParam HashMap<String, String> input, HttpServletRequest request,
            HttpSession session, ModelMap model) throws JSONException {

        LOGGER.debug("###########################################################");
        LOGGER.debug("retrieveNatTssPgsSmryInst [과제관리 > 국책과제 > 진행 > 개요 기관 조회]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSessionRUI(input, session, model);

        ModelAndView modelAndView = new ModelAndView("ruiView");

        List<Map<String, Object>> resultYld = natTssPgsService.retrieveNatTssPgsSmryInst(input);

        modelAndView.addObject("dataset", RuiConverter.createDataset("dataset", resultYld));

        return modelAndView;
    }



    //================================================================================================ 사업비
    /**
     * 과제관리 > 국책과제 > 진행 > 사업비 iframe 화면
     *
     * @param input HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return String
     * @throws JSONException
     * */
    @RequestMapping(value="/prj/tss/nat/natTssPgsTrwiBudgIfm.do")
    public String natTssPgsTrwiBudgIfm(@RequestParam HashMap<String, String> input, HttpServletRequest request,
            HttpSession session, ModelMap model) throws JSONException {

        LOGGER.debug("###########################################################");
        LOGGER.debug("natTssPgsTrwiBudgIfm [과제관리 > 국책과제 > 진행 > 사업비 iframe 화면]");
        LOGGER.debug("###########################################################");

        checkSession(input, session, model);

        if(pageMoveChkSession(input.get("_userId"))) {
            input.put("gridFlg","1"); //grid 하우시스 사업비
            List<Map<String, Object>> result = natTssPgsService.retrieveNatTssPgsTrwiBudg(input);

            input.put("gridFlg","2");  //grid 하우시스 사업비 상세
            List<Map<String, Object>> result2 = natTssPgsService.retrieveNatTssPgsTrwiBudg(input);

            JSONObject obj = new JSONObject();
            obj.put("records", result);

            JSONObject obj2 = new JSONObject();
            obj2.put("records", result2);

            request.setAttribute("inputData", input);
            request.setAttribute("resultCnt", result == null ? 0 : result.size());
            request.setAttribute("result", obj);
            request.setAttribute("result2", obj2);
        }

        return "web/prj/tss/nat/pgs/natTssPgsTrwiBudgIfm";
    }


    /**
     * 과제관리 > 국책과제 > 진행 > 사업비 조회
     *
     * @param input HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return ModelAndView
     * @throws JSONException
     * */
    @RequestMapping(value="/prj/tss/nat/retrieveNatTssPgsTrwiBudg.do")
    public ModelAndView retrieveNatTssPgsTrwiBudg(@RequestParam HashMap<String, String> input, HttpServletRequest request,
            HttpSession session, ModelMap model) {

        LOGGER.debug("###########################################################");
        LOGGER.debug("retrieveNatTssPgsTrwiBudg [과제관리 > 국책과제 > 진행 > 사업비 조회]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSessionRUI(input, session, model);
        ModelAndView modelAndView = new ModelAndView("ruiView");

        List<Map<String, Object>> result = natTssPgsService.retrieveNatTssPgsTrwiBudg(input);
        modelAndView.addObject("dataset", RuiConverter.createDataset("dataset", result));

        return modelAndView;
    }




    //================================================================================================ 목표및산출물
    /**
     * 과제관리 > 국책과제 > 진행 > 목표및산출물 iframe 화면
     *
     * @param input HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return String
     * @throws JSONException
     * */
    @RequestMapping(value="/prj/tss/nat/natTssPgsGoalYldIfm.do")
    public String natTssPgsGoalYldIfm(@RequestParam HashMap<String, String> input, HttpServletRequest request,
            HttpSession session, ModelMap model) throws JSONException {

        LOGGER.debug("###########################################################");
        LOGGER.debug("natTssPgsGoalYldIfm [과제관리 > 국책과제 > 진행 > 목표및산출물 iframe 화면 ]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSession(input, session, model);

        if(pageMoveChkSession(input.get("_userId"))) {
            //데이터 있을 경우
            List<Map<String, Object>> resultGoal = null;
            List<Map<String, Object>> resultYld  = null;

            if(!"".equals(input.get("tssCd")) && null != input.get("tssCd")) {
                resultGoal = natTssPgsService.retrieveNatTssPgsGoal(input);
                resultYld  = natTssPgsService.retrieveNatTssPgsYld(input);
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

        return "web/prj/tss/nat/pgs/natTssPgsGoalYldIfm";
    }


    /**
     * 과제관리 > 국책과제 > 진행 > 목표및산출물 > 목표 조회
     *
     * @param input HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return ModelAndView
     * @throws JSONException
     * */
    @RequestMapping(value="/prj/tss/nat/retrieveNatTssPgsGoal.do")
    public ModelAndView retrieveNatTssPgsGoal(@RequestParam HashMap<String, String> input, HttpServletRequest request,
            HttpSession session, ModelMap model) throws JSONException {

        LOGGER.debug("###########################################################");
        LOGGER.debug("retrieveNatTssPgsGoal [과제관리 > 국책과제 > 진행 > 목표및산출물 > 목표 조회]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSessionRUI(input, session, model);
        ModelAndView modelAndView = new ModelAndView("ruiView");

        List<Map<String, Object>> resultGoal = natTssPgsService.retrieveNatTssPgsGoal(input);
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
     * 과제관리 > 국책과제 > 진행 > 목표및산출물 > 산출물 조회
     *
     * @param input HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return ModelAndView
     * @throws JSONException
     * */
    @RequestMapping(value="/prj/tss/nat/retrieveNatTssPgsYld.do")
    public ModelAndView retrieveNatTssPgsYld(@RequestParam HashMap<String, String> input, HttpServletRequest request,
            HttpSession session, ModelMap model) throws JSONException {

        LOGGER.debug("###########################################################");
        LOGGER.debug("retrieveNatTssPgsYld [과제관리 > 국책과제 > 진행 > 목표및산출물 > 산출물 조회]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSessionRUI(input, session, model);
        ModelAndView modelAndView = new ModelAndView("ruiView");

        List<Map<String, Object>> resultYld = natTssPgsService.retrieveNatTssPgsYld(input);
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
     * 과제관리 > 국책과제 > 진행 > 목표및산출물 > 목표 저장
     *
     * @param input HashMap<String, Object>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return ModelAndView
     * */
    @RequestMapping(value="/prj/tss/nat/updateNatTssPgsGoal.do")
    public ModelAndView updateNatTssPgsGoal(@RequestParam HashMap<String, Object> input, HttpServletRequest request,
            HttpSession session, ModelMap model) {

        LOGGER.debug("###########################################################");
        LOGGER.debug("updateNatTssPgsGoal [과제관리 > 국책과제 > 진행 > 목표및산출물 > 목표 저장]");
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

            natTssPgsService.updateNatTssPgsGoal(ds);

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
     * 과제관리 > 국책과제 > 진행 > 목표및산출물 > 산출물 저장
     *
     * @param input HashMap<String, Object>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return ModelAndView
     * */
    @RequestMapping(value="/prj/tss/nat/updateNatTssPgsYld.do")
    public ModelAndView updateNatTssPgsYld(@RequestParam HashMap<String, Object> input, HttpServletRequest request,
            HttpSession session, ModelMap model) {

        LOGGER.debug("###########################################################");
        LOGGER.debug("updateNatTssPgsYld [과제관리 > 국책과제 > 진행 > 목표및산출물 > 산출물 저장]");
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

            natTssPgsService.updateNatTssPgsYld(ds);

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




    //================================================================================================ 투자품목
    /**
     * 과제관리 > 국책과제 > 진행 > 투자품목 iframe 화면
     *
     * @param input HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return String
     * @throws JSONException
     * */
    @RequestMapping(value="/prj/tss/nat/natTssPgsIvstIfm.do")
    public String natTssPgsIvstIfm(@RequestParam HashMap<String, String> input, HttpServletRequest request,
            HttpSession session, ModelMap model) throws JSONException {

        LOGGER.debug("###########################################################");
        LOGGER.debug("natTssPgsIvstIfm [과제관리 > 국책과제 > 진행 > 투자품목 iframe 화면]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSession(input, session, model);

        if(pageMoveChkSession(input.get("_userId"))) {
            //데이터 있을 경우
            List<Map<String, Object>> result = natTssPgsService.retrieveNatTssPgsIvst(input);
            for(int i = 0; i < result.size(); i++) {
                StringUtil.toUtf8Output((HashMap)result.get(i));
            }

            JSONObject obj = new JSONObject();
            obj.put("records", result);

            request.setAttribute("resultCnt", result == null ? 0 : result.size());
            request.setAttribute("result", obj);

            model.addAttribute("inputData", input);
        }

        return "web/prj/tss/nat/pgs/natTssPgsIvstIfm";
    }


    /**
     * 과제관리 > 국책과제 > 진행 > 투자품목 조회
     *
     * @param input HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return ModelAndView
     * @throws JSONException
     * */
    @RequestMapping(value="/prj/tss/nat/retrieveNatTssPgsIvst.do")
    public ModelAndView retrieveNatTssPgsIvst(@RequestParam HashMap<String, String> input, HttpServletRequest request,
            HttpSession session, ModelMap model) throws JSONException {

        LOGGER.debug("###########################################################");
        LOGGER.debug("retrieveNatTssPgsIvst [과제관리 > 국책과제 > 진행 > 목표및산출물 > 산출물 조회]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSessionRUI(input, session, model);
        ModelAndView modelAndView = new ModelAndView("ruiView");

        List<Map<String, Object>> result = natTssPgsService.retrieveNatTssPgsIvst(input);
        for(int i = 0; i < result.size(); i++) {
            StringUtil.toUtf8Output((HashMap)result.get(i));
        }

        modelAndView.addObject("dataset", RuiConverter.createDataset("dataset", result));

        //jsp에 있는 el에 담기위한 쓰레기 데이터
        request.setAttribute("resultCnt", 0);
        request.setAttribute("result", null);

        return modelAndView;
    }


    /**
     * 과제관리 > 국책과제 > 진행 > 투자품목 상세 화면
     *
     * @param input HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return String
     * @throws JSONException
     * */
    @RequestMapping(value="/prj/tss/nat/natTssPgsIvstDtlPop.do")
    public String natTssPgsIvstDtlPop(@RequestParam HashMap<String, String> input, HttpServletRequest request,
            HttpSession session, ModelMap model) throws JSONException {

        LOGGER.debug("###########################################################");
        LOGGER.debug("natTssPgsIvstDtlPop [과제관리 > 국책과제 > 진행 > 투자품목 상세 화면]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSession(input, session, model);

        if(pageMoveChkSession(input.get("_userId"))) {
            //데이터 있을 경우
            Map<String, Object> result = null;

            if(!"".equals(input.get("ivstIgSn"))) {
                result = natTssPgsService.retrieveNatTssPgsIvstDtl(input);
            }
            result = StringUtil.toUtf8Output((HashMap) result);

            List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
            list.add(result);

            JSONObject obj = new JSONObject();
            obj.put("records", list);

            request.setAttribute("resultCnt", result == null ? 0 : result.size());
            request.setAttribute("result", obj);

            model.addAttribute("inputData", input);
        }

        return "web/prj/tss/nat/pgs/natTssPgsIvstDtlPop";
    }


    /**
     * 과제관리 > 국책과제 > 진행 > 투자품목 저장
     *
     * @param input HashMap<String, Object>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return ModelAndView
     * */
    @RequestMapping(value="/prj/tss/nat/updateNatTssPgsIvst.do")
    public ModelAndView updateNatTssPgsIvst(@RequestParam HashMap<String, Object> input, HttpServletRequest request,
            HttpSession session, ModelMap model) {

        LOGGER.debug("###########################################################");
        LOGGER.debug("updateNatTssPgsIvst [과제관리 > 국책과제 > 진행 > 투자품목 저장]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSessionObjRUI(input, session, model);

        ModelAndView modelAndView = new ModelAndView("ruiView");

        List<Map<String, Object>> ds = null;

        try {
            ds  = RuiConverter.convertToDataSet(request, "ivstDataSet");
            StringUtil.toUtf8Output((HashMap) ds.get(0));

            natTssPgsService.updateNatTssPgsIvst(ds.get(0));

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
     * 과제관리 > 국책과제 > 진행 > 투자품목 삭제
     *
     * @param input HashMap<String, Object>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return ModelAndView
     * */
    @RequestMapping(value="/prj/tss/nat/deleteNatTssPgsIvst.do")
    public ModelAndView deleteNatTssPgsIvst(@RequestParam HashMap<String, Object> input, HttpServletRequest request,
            HttpSession session, ModelMap model) {

        LOGGER.debug("###########################################################");
        LOGGER.debug("deleteNatTssPgsIvst [과제관리 > 국책과제 > 진행 > 투자품목 삭제]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSessionObjRUI(input, session, model);

        ModelAndView modelAndView = new ModelAndView("ruiView");

        List<Map<String, Object>> ds = null;

        try {
            ds  = RuiConverter.convertToDataSet(request, "ivstDataSet");
            natTssPgsService.deleteNatTssPgsIvst(ds.get(0));

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




    //================================================================================================ 연구비
    /**
     * 과제관리 > 국책과제 > 진행 > 연구비 iframe 화면
     *
     * @param input HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return String
     * @throws JSONException
     * */
    @RequestMapping(value="/prj/tss/nat/natTssPgsCrdIfm.do")
    public String natTssPgsCrdIfm(@RequestParam HashMap<String, String> input, HttpServletRequest request,
            HttpSession session, ModelMap model) throws JSONException {

        LOGGER.debug("###########################################################");
        LOGGER.debug("natTssPgsCrdIfm [과제관리 > 국책과제 > 진행 > 연구비 iframe 화면]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSession(input, session, model);

        if(pageMoveChkSession(input.get("_userId"))) {
            //데이터 있을 경우
            List<Map<String, Object>> result = natTssPgsService.retrieveNatTssPgsCrd(input);

            JSONObject obj = new JSONObject();
            obj.put("records", result);

            request.setAttribute("resultCnt", result == null ? 0 : result.size());
            request.setAttribute("result", obj);

            model.addAttribute("inputData", input);
        }

        return "web/prj/tss/nat/pgs/natTssPgsCrdIfm";
    }


    /**
     * 과제관리 > 국책과제 > 진행 > 연구비 조회
     *
     * @param input HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return ModelAndView
     * @throws JSONException
     * */
    @RequestMapping(value="/prj/tss/nat/retrieveNatTssPgsCrd.do")
    public ModelAndView retrieveNatTssPgsCrd(@RequestParam HashMap<String, String> input, HttpServletRequest request,
            HttpSession session, ModelMap model) throws JSONException {

        LOGGER.debug("###########################################################");
        LOGGER.debug("retrieveNatTssPgsCrd [과제관리 > 국책과제 > 진행 > 목표및산출물 > 산출물 조회]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSessionRUI(input, session, model);
        ModelAndView modelAndView = new ModelAndView("ruiView");

        List<Map<String, Object>> result = natTssPgsService.retrieveNatTssPgsCrd(input);
        modelAndView.addObject("dataset", RuiConverter.createDataset("dataset", result));

        //jsp에 있는 el에 담기위한 쓰레기 데이터
        request.setAttribute("resultCnt", 0);
        request.setAttribute("result", null);

        return modelAndView;
    }


    /**
     * 과제관리 > 국책과제 > 진행 > 연구비 상세 화면
     *
     * @param input HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return String
     * @throws JSONException
     * */
    @RequestMapping(value="/prj/tss/nat/natTssPgsCrdDtlPop.do")
    public String natTssPgsCrdDtlPop(@RequestParam HashMap<String, String> input, HttpServletRequest request,
            HttpSession session, ModelMap model) throws JSONException {

        LOGGER.debug("###########################################################");
        LOGGER.debug("natTssPgsCrdDtlPop [과제관리 > 국책과제 > 진행 > 연구비 상세 화면]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSession(input, session, model);

        if(pageMoveChkSession(input.get("_userId"))) {
            //데이터 있을 경우
            Map<String, Object> result = natTssPgsService.retrieveNatTssPgsCrdDtl(input);
            result = StringUtil.toUtf8Output((HashMap) result);

            List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
            list.add(result);

            JSONObject obj = new JSONObject();
            obj.put("records", list);

            request.setAttribute("resultCnt", result == null ? 0 : result.size());
            request.setAttribute("result", obj);

            model.addAttribute("inputData", input);
        }

        return "web/prj/tss/nat/pgs/natTssPgsCrdDtlPop";
    }


    /**
     * 과제관리 > 국책과제 > 진행 > 연구비 저장
     *
     * @param input HashMap<String, Object>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return ModelAndView
     * */
    @RequestMapping(value="/prj/tss/nat/updateNatTssPgsCrd.do")
    public ModelAndView updateNatTssPgsCrd(@RequestParam HashMap<String, Object> input, HttpServletRequest request,
            HttpSession session, ModelMap model) {

        LOGGER.debug("###########################################################");
        LOGGER.debug("updateNatTssPgsCrd [과제관리 > 국책과제 > 진행 > 연구비 저장]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSessionObjRUI(input, session, model);

        ModelAndView modelAndView = new ModelAndView("ruiView");

        List<Map<String, Object>> ds = null;

        try {
            ds  = RuiConverter.convertToDataSet(request, "crdDataSet");
            StringUtil.toUtf8Input((HashMap) ds.get(0));

            natTssPgsService.updateNatTssPgsCrd(ds.get(0));

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
     * 과제관리 > 국책과제 > 진행 > 연구비 삭제
     *
     * @param input HashMap<String, Object>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return ModelAndView
     * */
    @RequestMapping(value="/prj/tss/nat/deleteNatTssPgsCrd.do")
    public ModelAndView deleteNatTssPgsCrd(@RequestParam HashMap<String, Object> input, HttpServletRequest request,
            HttpSession session, ModelMap model) {

        LOGGER.debug("###########################################################");
        LOGGER.debug("deleteNatTssPgsCrd [과제관리 > 국책과제 > 진행 > 연구비 삭제]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSessionObjRUI(input, session, model);

        ModelAndView modelAndView = new ModelAndView("ruiView");

        List<Map<String, Object>> ds = null;

        try {
            ds  = RuiConverter.convertToDataSet(request, "crdDataSet");
            natTssPgsService.deleteNatTssPgsCrd(ds.get(0));

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



    //================================================================================================ 변경이력
    /**
     * 과제관리 > 국책과제 > 진행 > 변경이력 조회
     *
     * @param input HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return String
     * @throws JSONException
     * */
    @RequestMapping(value="/prj/tss/nat/natTssPgsAltrHistIfm.do")
    public String natTssPgsAltrHistIfm(@RequestParam HashMap<String, String> input, HttpServletRequest request,
            HttpSession session, ModelMap model) throws JSONException {

        LOGGER.debug("###########################################################");
        LOGGER.debug("natTssPgsAltrHistIfm [과제관리 > 국책과제 > 진행 > 변경이력 조회]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSession(input, session, model);

        if(pageMoveChkSession(input.get("_userId"))) {
            List<Map<String, Object>> result = natTssPgsService.retrieveNatTssPgsAltrHist(input);

            JSONObject obj = new JSONObject();
            obj.put("records", result);

            request.setAttribute("inputData", input);
            request.setAttribute("resultCnt", result == null ? 0 : result.size());
            request.setAttribute("result", obj);
        }

        return "web/prj/tss/nat/pgs/natTssPgsAltrHistIfm";
    }



    //================================================================================================ 참여연구원
    /**
     * 과제관리 > 국책과제 > 진행 > 참여연구원 iframe 화면
     *
     * @param input HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return String
     * @throws JSONException
     * */
    @RequestMapping(value="/prj/tss/nat/natTssPgsPtcRsstMbrIfm.do")
    public String natTssPgsPtcRsstMbrIfm(@RequestParam HashMap<String, String> input, HttpServletRequest request,
            HttpSession session, ModelMap model) throws JSONException {

        LOGGER.debug("###########################################################");
        LOGGER.debug("natTssPgsPtcRsstMbrIfm [과제관리 > 국책과제 > 계획 > 참여연구원 iframe 화면 ]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSession(input, session, model);

        if(pageMoveChkSession(input.get("_userId"))) {
            List <Map<String, Object>> codeRtcRole  = codeService.retrieveCodeValueList("PTC_ROLE"); //참여역할

            model.addAttribute("codeRtcRole", codeRtcRole);

            List<Map<String, Object>> result = natTssPgsService.retrieveNatTssPgsPtcRsstMbr(input);

            JSONObject obj = new JSONObject();
            obj.put("records", result);

            request.setAttribute("resultCnt", result == null ? 0 : result.size());
            request.setAttribute("result", obj);

            model.addAttribute("inputData", input);
        }

        return "web/prj/tss/nat/pgs/natTssPgsPtcRsstMbrIfm";
    }





    @RequestMapping(value="/prj/tss/nat/retrieveNatTssPgsGoalYy.do")
    public ModelAndView retrieveNatTssPgsGoalYy(
            @RequestParam HashMap<String, String> input,
            HttpServletRequest request,
            HttpServletResponse response,
            HttpSession session,
            ModelMap model
            ){

        LOGGER.debug("###########################################################");
        LOGGER.debug("retrieveNatTssPgsGoalYy []");
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
    
    /**
     * 과제관리 > 국책과제 > 진행 > 변경이력 상세 팝업 화면
     *
     * @param input HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return String
     * @throws JSONException
     * */
    @RequestMapping(value="/prj/tss/nat/natTssAltrDetailPopup.do")
    public String natTssAltrDetailPopup(@RequestParam HashMap<String, String> input, HttpServletRequest request,
            HttpSession session, ModelMap model) throws JSONException {

        checkSession(input, session, model);
        
        LOGGER.debug("###########################################################");
        LOGGER.debug("ousdCooTssAltrDetailPopup [과제관리 > 국책과제 > 진행 > 변경이력 상세 팝업 화면 ]");
        LOGGER.debug("###########################################################");
       
        request.setAttribute("inputData", input);
        
        return "web/prj/tss/nat/natTssAltrDetailPopup";
    }
    

    /**
     * 과제관리 > 국책과제 > 진행 > 변경이력 상세 조회
     *
     * @param input HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return String
     * @throws JSONException
     * */
    @RequestMapping(value="/prj/tss/nat/natssAltrDetailSearch.do")
    public ModelAndView natssAltrDetailSearch(@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){

    	checkSessionObjRUI(input, session, model);
        ModelAndView modelAndView = new ModelAndView("ruiView");
        
        LOGGER.debug("###########################################################");
        LOGGER.debug("ousdCooTssAltrDetailSearch [과제관리 > 국책과제 > 진행 > 변경이력 상세 조회 ]");
        LOGGER.debug("####input  : ########### : " + input);
        LOGGER.debug("###########################################################");

        List<Map<String, Object>> resultAltr = natTssPgsService.retrieveNatTssAltrList(input);
        Map<String, Object> altrDtl = natTssPgsService.natTssAltrDetailSearch(input);
        
        StringUtil.toUtf8Output((HashMap<String, Object>) altrDtl);

        modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", resultAltr));
        modelAndView.addObject("rsonDataSet", RuiConverter.createDataset("rsonDataSet", altrDtl));
        
        return modelAndView;
    }

}
