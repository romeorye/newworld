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
import iris.web.common.util.StringUtil;
import iris.web.prj.tss.com.service.TssUserService;
import iris.web.prj.tss.gen.service.GenTssPgsService;
import iris.web.prj.tss.gen.service.GenTssPlnService;
import iris.web.prj.tss.ousdcoo.service.OusdCooTssPgsService;
import iris.web.prj.tss.ousdcoo.service.OusdCooTssService;
import iris.web.system.base.IrisBaseController;

/********************************************************************************
 * NAME : OusdCooTssPgsController.java
 * DESC : 프로젝트 - 과제관리 - 대외협력과제 진행(Pgs) controller
 * PROJ : IRIS 구축 프로젝트
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION
 * ----------  ------  ---------------------------------------------------------
 * 2017.09.19  IRIS04	최초생성
 *********************************************************************************/

@Controller
public class OusdCooTssPgsController  extends IrisBaseController {

    @Resource(name="messageSourceAccessor")
    private MessageSourceAccessor messageSourceAccessor;

    @Resource(name = "tssUserService")
    private TssUserService tssUserService;

    @Resource(name = "ousdCooTssPgsService")
    private OusdCooTssPgsService ousdCooTssPgsService;

    @Resource(name = "ousdCooTssService")
    private OusdCooTssService ousdCooTssService;		//대외협력과제 서비스

    @Resource(name = "genTssPgsService")
    private GenTssPgsService genTssPgsService;			//일반과제 진행 서비스

    @Resource(name = "genTssPlnService")
    private GenTssPlnService genTssPlnService;			//일반과제 계획 서비스

    @Resource(name = "codeService")
    private CodeService codeService;

    static final Logger LOGGER = LogManager.getLogger(OusdCooTssPgsController.class);


    //================================================================================================ 마스터
    /**
     * 과제관리 > 대외협력과제 > 진행 > 마스터 조회
     *
     * @param input HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return String
     * @throws JSONException
     * */
    @RequestMapping(value="/prj/tss/ousdcoo/ousdCooTssPgsDetail.do")
    public String ousdCooTssPgsMst(@RequestParam HashMap<String, String> input, HttpServletRequest request,
            HttpSession session, ModelMap model) throws JSONException {
        LOGGER.debug("###############################################################");
        LOGGER.debug("ousdCooTssPgsMst [과제관리 > 대외협력과제 > 진행 > 마스터 조회]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###############################################################");

        checkSession(input, session, model);

        if(pageMoveChkSession(input.get("_userId"))) {
            Map<String, Object> result = genTssPgsService.retrieveGenTssPgsMst(input);

            Map<String, Object> mbrCnt = genTssPgsService.retrieveGenTssPtcMbrCnt(input);
            result.put("mbrCnt", mbrCnt.get("mbrCnt"));

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

        return "web/prj/tss/ousdcoo/pgs/ousdCooTssPgsDetail";
    }


    /**
     * 과제관리 > 대외협력과제 > 진행 > 변경품의
     *
     * @param input HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return String
     * @throws JSONException
     * */
    /*    @RequestMapping(value="/prj/tss/ousdcoo/ousdCooTssPgsAltrCsus.do")
    public String ousdCooTssPgsAltrCsus(@RequestParam HashMap<String, String> input, HttpServletRequest request,
            HttpSession session, ModelMap model) throws JSONException {

        LOGGER.debug("###########################################################");
        LOGGER.debug("ousdCooTssPgsAltrCsus [과제관리 > 대외협력과제 > 진행 > 변경품의]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSession(input, session, model);

        if(pageMoveChkSession(input.get("_userId"))) {
            input.put("tssSt", "102"); //102:GRS완료
            Map<String, Object> result = genTssPgsService.retrieveGenTssAltrMst(input);

            List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
            list.add(result);

            JSONObject obj = new JSONObject();
            obj.put("records", list);

            request.setAttribute("inputData", input);
            request.setAttribute("resultCnt", result == null ? 0 : result.size());
            request.setAttribute("result", obj);
        }

        return "web/prj/tss/ousdcoo/altr/ousdCooTssAltrDetail";
    }*/



    
	//================================================================================================ 개요
    /**
     * 과제관리 > 대외협력과제 > 진행 > 개요 조회
     *
     * @param input HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return String
     * @throws JSONException
     * */
    @SuppressWarnings("rawtypes")
    @RequestMapping(value="/prj/tss/ousdcoo/ousdCooTssPgsSmryIfm.do")
    public String ousdCooTssPgsSmryIfm(@RequestParam HashMap<String, String> input, HttpServletRequest request,
            HttpSession session, ModelMap model) throws JSONException {
        LOGGER.debug("#################################################################");
        LOGGER.debug("ousdCooTssPgsSmryIfm [과제관리 > 대외협력과제 > 진행 > 개요 조회]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("#################################################################");

        checkSession(input, session, model);

        if(pageMoveChkSession(input.get("_userId"))) {
            Map<String, Object> result = ousdCooTssService.retrieveOusdCooTssSmry(input);
            
            // 특수문자 변환 OUTPUT
            if( result != null && !result.isEmpty() ) {
            	iris.web.common.util.StringUtil.toUtf8Output((HashMap) result);
            }

            List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
            list.add(result);

            JSONObject obj = new JSONObject();
            obj.put("records", list);

            request.setAttribute("inputData", input);
            request.setAttribute("resultCnt", result == null ? 0 : result.size());
            request.setAttribute("result", obj);
        }
        return "web/prj/tss/ousdcoo/pgs/ousdCooTssPgsSmryIfm";
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
    @RequestMapping(value="/prj/tss/ousdcoo/ousdCooTssPgsPtcRsstMbrIfm.do")
    public String genTssPgsPtcRsstMbrIfm(@RequestParam HashMap<String, String> input, HttpServletRequest request,
            HttpSession session, ModelMap model) throws JSONException {

        LOGGER.debug("#####################################################################################");
        LOGGER.debug("ousdCooTssPgsPtcRsstMbrIfm [과제관리 > 대외협력과제 > 계획 > 참여연구원 iframe 화면 ]");
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

        return "web/prj/tss/ousdcoo/pgs/ousdCooTssPgsPtcRsstMbrIfm";
    }

    //================================================================================================ 목표및산출물
    
	/**
     * 과제관리 > 대외협력과제 > 진행 > 목표및산출물 iframe 화면
     *
     * @param input HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return String
     * @throws JSONException
     * */
    @SuppressWarnings("rawtypes")
    @RequestMapping(value="/prj/tss/ousdcoo/ousdCooTssPgsGoalYldIfm.do")
    public String ousdCooTssPgsGoalYldIfm(@RequestParam HashMap<String, String> input, HttpServletRequest request,
            HttpSession session, ModelMap model) throws JSONException {

        LOGGER.debug("####################################################################################");
        LOGGER.debug("ousdCooTssPgsGoalYldIfm [과제관리 > 대외협력과제 > 진행 > 목표및산출물 iframe 화면 ]");
        LOGGER.debug("####################################################################################");

        checkSession(input, session, model);

        if(pageMoveChkSession(input.get("_userId"))) {
            //데이터 있을 경우
            List<Map<String, Object>> resultGoal = null;
            List<Map<String, Object>> resultYld  = null;

            if(!"".equals(input.get("tssCd"))) {
                resultGoal = genTssPgsService.retrieveGenTssPgsGoal(input);
                // 특수문자 변환 OUTPUT
                if( resultGoal != null && resultGoal.size() > 0 ) {
                	for(int i=0; i< resultGoal.size(); i++) {
                		iris.web.common.util.StringUtil.toUtf8Output((HashMap) resultGoal.get(i));
                	}
                }
                resultYld  = genTssPgsService.retrieveGenTssPgsYld(input);
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

        return "web/prj/tss/ousdcoo/pgs/ousdCooTssPgsGoalYldIfm";
    }

    /**
     * 과제관리 > 대외협력과제 > 진행 > 목표및산출물 > 목표 조회
     *
     * @param input HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return String
     * @throws JSONException
     * */
    @SuppressWarnings("rawtypes")
	@RequestMapping(value="/prj/tss/ousdcoo/retrieveOusdCooTssPgsGoal.do")
    public ModelAndView retrieveOusdCooTssPgsGoal(@RequestParam HashMap<String, String> input, HttpServletRequest request,
            HttpSession session, ModelMap model) throws JSONException {

        LOGGER.debug("#####################################################################################");
        LOGGER.debug("retrieveOusdCooTssPgsGoal [과제관리 > 대외협력과제 > 진행 > 목표및산출물 > 목표 조회]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("#####################################################################################");

        checkSessionRUI(input, session, model);
        ModelAndView modelAndView = new ModelAndView("ruiView");

        List<Map<String, Object>> resultGoal = genTssPgsService.retrieveGenTssPgsGoal(input);
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
     * 과제관리 > 대외협력과제 > 진행 > 목표및산출물 > 산출물 조회
     *
     * @param input HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return String
     * @throws JSONException
     * */
    @RequestMapping(value="/prj/tss/ousdcoo/retrieveOusdCooTssPgsYld.do")
    public ModelAndView retrieveOusdCooTssPgsYld(@RequestParam HashMap<String, String> input, HttpServletRequest request,
            HttpSession session, ModelMap model) throws JSONException {

        LOGGER.debug("######################################################################################");
        LOGGER.debug("retrieveOusdCooTssPgsYld [과제관리 > 대외협력과제 > 진행 > 목표및산출물 > 산출물 조회]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("######################################################################################");

        checkSessionRUI(input, session, model);
        ModelAndView modelAndView = new ModelAndView("ruiView");

        List<Map<String, Object>> resultYld = genTssPgsService.retrieveGenTssPgsYld(input);
        modelAndView.addObject("dataset", RuiConverter.createDataset("dataset", resultYld));

        //jsp에 있는 el에 담기위한 쓰레기 데이터
        request.setAttribute("resultGoalCnt", 0);
        request.setAttribute("resultGoal", null);
        request.setAttribute("resultYldCnt", 0);
        request.setAttribute("resultYld", null);

        return modelAndView;
    }

    /**
     * 과제관리 > 대외협력과제 > 진행 > 목표및산출물 > 목표 저장
     *
     * @param input HashMap<String, Object>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return ModelAndView
     * */
    @SuppressWarnings("rawtypes")
	@RequestMapping(value="/prj/tss/ousdcoo/updateOusdCooTssPgsGoal.do")
    public ModelAndView updateOusdCooTssPgsGoal(@RequestParam HashMap<String, Object> input, HttpServletRequest request,
            HttpSession session, ModelMap model) {

        LOGGER.debug("###################################################################################");
        LOGGER.debug("updateOusdCooTssPgsGoal [과제관리 > 대외협력과제 > 진행 > 목표및산출물 > 목표 저장]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###################################################################################");

        checkSessionObjRUI(input, session, model);

        ModelAndView modelAndView = new ModelAndView("ruiView");

        List<Map<String, Object>> ds = null;

        try {
            ds  = RuiConverter.convertToDataSet(request, "goalDataSet");
            // 특수문자 변환 INPUT
            if( ds != null && ds.size() > 0 ) {
            	for(int i=0; i< ds.size(); i++) {
            		iris.web.common.util.StringUtil.toUtf8Input((HashMap) ds.get(i));
            	}
            }
            genTssPgsService.updateGenTssPgsGoal(ds);

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
     * 과제관리 > 대외협력과제 > 진행 > 목표및산출물 > 산출물 저장
     *
     * @param input HashMap<String, Object>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return ModelAndView
     * */
    @RequestMapping(value="/prj/tss/ousdcoo/updateOusdCooTssPgsYld.do")
    public ModelAndView updateOusdCooTssPgsYld(@RequestParam HashMap<String, Object> input, HttpServletRequest request,
            HttpSession session, ModelMap model) {

        LOGGER.debug("####################################################################################");
        LOGGER.debug("updateOusdCooTssPgsYld [과제관리 > 대외협력과제 > 진행 > 목표및산출물 > 산출물 저장]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("####################################################################################");

        checkSessionObjRUI(input, session, model);

        ModelAndView modelAndView = new ModelAndView("ruiView");

        List<Map<String, Object>> ds = null;

        try {
            ds  = RuiConverter.convertToDataSet(request, "yldDataSet");
            genTssPgsService.updateGenTssPgsYld(ds);

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

    //================================================================================================ 변경이력
    /**
     * 과제관리 > 대외협력과제 > 진행 > 변경이력 조회
     *
     * @param input HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return String
     * @throws JSONException
     * */
    @RequestMapping(value="/prj/tss/ousdcoo/ousdCooTssPgsAltrHistIfm.do")
    public String ousdCooTssPgsAltrHistIfm(@RequestParam HashMap<String, String> input, HttpServletRequest request,
            HttpSession session, ModelMap model) throws JSONException {

        LOGGER.debug("#########################################################################");
        LOGGER.debug("ousdCooTssPgsAltrHistIfm [과제관리 > 대외협력과제 > 진행 > 변경이력 조회]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("#########################################################################");

        checkSession(input, session, model);

        if(pageMoveChkSession(input.get("_userId"))) {
            List<Map<String, Object>> result = ousdCooTssPgsService.retrieveOusdCooTssPgsAltrHist(input);

            JSONObject obj = new JSONObject();
            obj.put("records", result);

            request.setAttribute("inputData", input);
            request.setAttribute("resultCnt", result == null ? 0 : result.size());
            request.setAttribute("result", obj);
        }

        return "web/prj/tss/ousdcoo/pgs/ousdCooTssPgsAltrHistIfm";
    }

    //================================================================================================ 비용지급실적
    /**
     * 과제관리 > 대외협력과제 > 진행 > 비용지급실적 iframe 화면
     *
     * @param input HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return String
     * @throws JSONException
     * */
    @RequestMapping(value="/prj/tss/ousdcoo/ousdCooTssPgsExpStoaIfm.do")
    public String ousdCooTssPgsExpStoaIfm(@RequestParam HashMap<String, String> input, HttpServletRequest request,
            HttpSession session, ModelMap model) throws JSONException {

        LOGGER.debug("###########################################################################################");
        LOGGER.debug("retrieveOusdCooTssPgsExpStoaIfm [과제관리 > 대외협력과제 > 진행 > 비용지급실적 iframe 화면]");
        LOGGER.debug("###########################################################################################");

        checkSession(input, session, model);
        if(pageMoveChkSession(input.get("_userId"))) {

            //데이터 있을 경우
            Map<String, Object> result = null;
            Map<String, Object> smry = null;
            if(!"".equals(input.get("tssCd"))) {
                result = ousdCooTssService.retrieveOusdCooTssExpStoa(input);
                smry = ousdCooTssService.retrieveOusdCooTssSmry(input);
                if(smry != null) {
                    input.put("rsstExp"           , NullUtil.nvl(smry.get("rsstExp"),"0"));
                    input.put("rsstExpConvertMil" , NullUtil.nvl(smry.get("rsstExpConvertMil"),"0"));
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
        LOGGER.debug("###########################################################################################");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################################################");

        return "web/prj/tss/ousdcoo/pgs/ousdCooTssPgsExpStoaIfm";
    }

    /**
     * 과제관리 > 대외협력과제 > 진행 > 비용지급실적 조회
     *
     * @param input HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return String
     * @throws JSONException
     * */
    @RequestMapping(value="/prj/tss/ousdcoo/retrieveOusdCooTssPgsExpStoa.do")
    public ModelAndView retrieveOusdCooTssPgsExpStoa(@RequestParam HashMap<String, String> input, HttpServletRequest request,
            HttpSession session, ModelMap model) {

        LOGGER.debug("############################################################################");
        LOGGER.debug("retrieveOusdCooTssPgsExpStoa [과제관리 > 대외협력과제 > 진행 > 개발비 조회]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("############################################################################");

        checkSessionRUI(input, session, model);
        ModelAndView modelAndView = new ModelAndView("ruiView");

        Map<String, Object> result = ousdCooTssService.retrieveOusdCooTssExpStoa(input);
        Map<String, Object> smry = ousdCooTssService.retrieveOusdCooTssSmry(input);
        if(smry != null) { input.put("rsstExp", NullUtil.nvl(smry.get("rsstExp"),"0")); }
        modelAndView.addObject("dataset", RuiConverter.createDataset("dataset", result));

        return modelAndView;
    }

    /**
     * 과제관리 > 대외협력과제 > 진행 > 비용지급실적 저장
     *
     * @param input HashMap<String, Object>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return ModelAndView
     * */
    @RequestMapping(value="/prj/tss/ousdcoo/insertOusdCooTssPgsExpStoa.do")
    public ModelAndView insertOusdCooTssPgsExpStoa(@RequestParam HashMap<String, Object> input, HttpServletRequest request, HttpServletResponse response,
            HttpSession session, ModelMap model) {

        LOGGER.debug("###############################################################################");
        LOGGER.debug("insertOusdCooTssPgsExpStoa [과제관리 > 대외협력과제 > 진행 > 비용지급실적 저장]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("################################################################################");

        checkSessionObjRUI(input, session, model);

        ModelAndView modelAndView = new ModelAndView("ruiView");

        List<Map<String, Object>> ds = null;

        try {
            ds  = RuiConverter.convertToDataSet(request, "expStoaDataSet");
            if(ds.size() > 0) {
                ousdCooTssService.insertOusdCooTssExpStoa((HashMap<String, Object>) ds.get(0));
            }
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
     * 과제관리 > 대외협력과제 > 계획 > 비용지급실적 수정
     *
     * @param input HashMap<String, Object>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return ModelAndView
     * */
    @RequestMapping(value="/prj/tss/ousdcoo/updateOusdCooTssPgsExpStoa.do")
    public ModelAndView updateOusdCooTssPgsExpStoa(@RequestParam HashMap<String, Object> input, HttpServletRequest request, HttpServletResponse response,
            HttpSession session, ModelMap model) {

        LOGGER.debug("###############################################################################");
        LOGGER.debug("updateOusdCooTssPgsExpStoa [과제관리 > 대외협력과제 > 진행 > 비용지급실적 수정]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("################################################################################");

        checkSessionObjRUI(input, session, model);

        ModelAndView modelAndView = new ModelAndView("ruiView");

        List<Map<String, Object>> ds = null;

        try {
            ds  = RuiConverter.convertToDataSet(request, "expStoaDataSet");
            if(ds.size() > 0) {
                ousdCooTssService.updateOusdCooTssExpStoa((HashMap<String, Object>)ds.get(0));
            }
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

    /**
     * 과제관리 > 대외협력과제 > 진행 > 변경이력 상세 팝업 화면
     *
     * @param input HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return String
     * @throws JSONException
     * */
    @RequestMapping(value="/prj/tss/ousdCoo/ousdCooTssAltrDetailPopup.do")
    public String ousdCooTssAltrDetailPopup(@RequestParam HashMap<String, String> input, HttpServletRequest request,
            HttpSession session, ModelMap model) throws JSONException {

        checkSession(input, session, model);
        
        LOGGER.debug("###########################################################");
        LOGGER.debug("ousdCooTssAltrDetailPopup [과제관리 > 대외협력과제 > 진행 > 변경이력 상세 팝업 화면 ]");
        LOGGER.debug("###########################################################");
       
        request.setAttribute("inputData", input);
        
        return "web/prj/tss/ousdcoo/ousdCooTssAltrDetailPopup";
    }
    

    /**
     * 과제관리 > 대외협력과제 > 진행 > 변경이력 상세 조회
     *
     * @param input HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return String
     * @throws JSONException
     * */
    @RequestMapping(value="/prj/tss/ousdCoo/ousdCooTssAltrDetailSearch.do")
    public ModelAndView ousdCooTssAltrDetailSearch(@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){

    	checkSessionObjRUI(input, session, model);
        ModelAndView modelAndView = new ModelAndView("ruiView");
        
        LOGGER.debug("###########################################################");
        LOGGER.debug("ousdCooTssAltrDetailSearch [과제관리 > 대외협력과제 > 진행 > 변경이력 상세 조회 ]");
        LOGGER.debug("####input  : ########### : " + input);
        LOGGER.debug("###########################################################");

        List<Map<String, Object>> resultAltr = ousdCooTssService.retrieveOusdCooTssAltrList(input);
        Map<String, Object> altrDtl = ousdCooTssService.ousdCooTssAltrDetailSearch(input);
        
        StringUtil.toUtf8Output((HashMap<String, Object>) altrDtl);

        modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", resultAltr));
        modelAndView.addObject("rsonDataSet", RuiConverter.createDataset("rsonDataSet", altrDtl));
        
        return modelAndView;
    }
        
        
}
