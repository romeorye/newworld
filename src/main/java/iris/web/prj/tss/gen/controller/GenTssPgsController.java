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
import iris.web.common.code.service.CodeService;
import iris.web.common.converter.RuiConverter;
import iris.web.common.util.StringUtil;
import iris.web.prj.tss.com.service.TssUserService;
import iris.web.prj.tss.gen.service.GenTssAltrService;
import iris.web.prj.tss.gen.service.GenTssPgsService;
import iris.web.system.base.IrisBaseController;


/********************************************************************************
 * NAME : GenTssPgsController.java
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
@SuppressWarnings({"unchecked", "rawtypes"})
public class GenTssPgsController  extends IrisBaseController {

    @Resource(name="messageSourceAccessor")
    private MessageSourceAccessor messageSourceAccessor;

    @Resource(name = "tssUserService")
    private TssUserService tssUserService;

    @Resource(name = "genTssPgsService")
    private GenTssPgsService genTssPgsService;
    
    @Resource(name = "genTssAltrService")
    private GenTssAltrService genTssAltrService;

    @Resource(name = "codeService")
    private CodeService codeService;

    static final Logger LOGGER = LogManager.getLogger(GenTssPgsController.class);


    //================================================================================================ 마스터
    /**
     * 과제관리 > 일반과제 > 진행 > 마스터 조회
     *
     * @param input HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return String
     * @throws JSONException
     * */
    @RequestMapping(value="/prj/tss/gen/genTssPgsDetail.do")
    public String genTssPgsMst(@RequestParam HashMap<String, String> input, HttpServletRequest request,
            HttpSession session, ModelMap model) throws JSONException {

        LOGGER.debug("###########################################################");
        LOGGER.debug("retrieveGenTssPgsMst [과제관리 > 일반과제 > 진행 > 마스터 조회]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSession(input, session, model);

        if(pageMoveChkSession(input.get("_userId"))) {
            //변경취소 후 진행화면 조회시 변경 데이터 삭제
            if(input.get("pgTssCd") != null && !input.get("pgTssCd").isEmpty()) {
                input.put("tssSt", "100");
                genTssPgsService.deleteGenTssOfTssCd(input);
            }

            Map<String, Object> result = genTssPgsService.retrieveGenTssPgsMst(input);
            result = StringUtil.toUtf8Output((HashMap) result);

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

        return "web/prj/tss/gen/pgs/genTssPgsDetail";
    }


    /**
     * 과제관리 > 일반과제 > 진행 > 변경품의
     *
     * @param input HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return String
     * @throws JSONException
     * */
    @RequestMapping(value="/prj/tss/gen/genTssPgsAltrCsus.do")
    public String genTssPgsAltrCsus(@RequestParam HashMap<String, String> input, HttpServletRequest request,
            HttpSession session, ModelMap model) throws JSONException {

        LOGGER.debug("###########################################################");
        LOGGER.debug("genTssPgsAltrCsus [과제관리 > 일반과제 > 진행 > 변경품의]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSession(input, session, model);

        if(pageMoveChkSession(input.get("_userId"))) {
            Map<String, Object> result = genTssPgsService.retrieveGenTssAltrMst(input);
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

        return "web/prj/tss/gen/altr/genTssAltrDetail";
    }

    
    /**
     * 과제관리 > 일반과제 > 진행 > 변경품의(변경요청
     *
     * @param input HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return String
     * @throws JSONException
     * */
    @RequestMapping(value="/prj/tss/gen/genTssPgsAltrCsus1.do")
    public String genTssPgsAltrCsus1(@RequestParam HashMap<String, String> input, HttpServletRequest request,
    		HttpSession session, ModelMap model) throws JSONException {
    	
    	LOGGER.debug("###########################################################");
    	LOGGER.debug("genTssPgsAltrCsus [과제관리 > 일반과제 > 진행 > 변경요청]");
    	LOGGER.debug("input = > " + input);
    	LOGGER.debug("###########################################################");
    	
    	checkSession(input, session, model);
    	
    	if(pageMoveChkSession(input.get("_userId"))) {
    		Map<String, Object> result = genTssPgsService.retrieveGenTssAltrMst(input);
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
    	
    	return "web/prj/tss/gen/altr/genTssAltrDetail1";
    }
    


    //================================================================================================ 개요
    /**
     * 과제관리 > 일반과제 > 진행 > 개요 조회
     *
     * @param input HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return String
     * @throws JSONException
     * */
    @RequestMapping(value="/prj/tss/gen/genTssPgsSmryIfm.do")
    public String genTssPgsSmryIfm(@RequestParam HashMap<String, String> input, HttpServletRequest request,
            HttpSession session, ModelMap model) throws JSONException {

        LOGGER.debug("###########################################################");
        LOGGER.debug("retrieveGenTssPgsSmry [과제관리 > 일반과제 > 진행 > 개요 조회]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSession(input, session, model);

        if(pageMoveChkSession(input.get("_userId"))) {
            Map<String, Object> result = genTssPgsService.retrieveGenTssPgsSmry(input);
            result = StringUtil.toUtf8Output((HashMap) result);

            List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
            list.add(result);

            JSONObject obj = new JSONObject();
            obj.put("records", list);

            request.setAttribute("inputData", input);
            request.setAttribute("resultCnt", result == null ? 0 : result.size());
            request.setAttribute("result", obj);
        }

        return "web/prj/tss/gen/pgs/genTssPgsSmryIfm";
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
    @RequestMapping(value="/prj/tss/gen/genTssPgsPtcRsstMbrIfm.do")
    public String genTssPgsPtcRsstMbrIfm(@RequestParam HashMap<String, String> input, HttpServletRequest request,
            HttpSession session, ModelMap model) throws JSONException {

        LOGGER.debug("###########################################################");
        LOGGER.debug("GenTssController - genTssPgsPtcRsstMbrIfm [과제관리 > 일반과제 > 계획 > 참여연구원 iframe 화면 ]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSession(input, session, model);

        if(pageMoveChkSession(input.get("_userId"))) {
            List <Map<String, Object>> codeRtcRole  = codeService.retrieveCodeValueList("PTC_ROLE"); //참여역할

            model.addAttribute("codeRtcRole", codeRtcRole);

            //데이터 있을 경우
            List<Map<String, Object>> result = genTssPgsService.retrieveGenTssPgsPtcRsstMbr(input);

            JSONObject obj = new JSONObject();
            obj.put("records", result);

            request.setAttribute("resultCnt", result == null ? 0 : result.size());
            request.setAttribute("result", obj);

            model.addAttribute("inputData", input);
        }

        return "web/prj/tss/gen/pgs/genTssPgsPtcRsstMbrIfm";
    }


    //================================================================================================ WBS
    /**
     * 과제관리 > 일반과제 > 진행 > WBS iframe 화면
     *
     * @param input HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return String
     * @throws JSONException
     * */
    @RequestMapping(value="/prj/tss/gen/genTssPgsWBSIfm.do")
    public String genTssPgsWBSIfm(@RequestParam HashMap<String, String> input, HttpServletRequest request,
            HttpSession session, ModelMap model) throws JSONException {

        LOGGER.debug("###########################################################");
        LOGGER.debug("GenTssController - genTssPgsWBSIfm [과제관리 > 일반과제 > 진행 > WBS iframe 화면]");
        LOGGER.debug("###########################################################");

        checkSession(input, session, model);

        if(pageMoveChkSession(input.get("_userId"))) {
            //데이터 있을 경우
            List<Map<String, Object>> result = genTssPgsService.retrieveGenTssPgsWBS(input);

            JSONObject obj = new JSONObject();
            obj.put("records", result);

            request.setAttribute("resultCnt", result == null ? 0 : result.size());
            request.setAttribute("result", obj);

            model.addAttribute("inputData", input);
        }

        return "web/prj/tss/gen/pgs/genTssPgsWBSIfm";
    }


    /**
     * 과제관리 > 일반과제 > 진행 > WBS 조회
     *
     * @param input HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return String
     * */
    @RequestMapping(value="/prj/tss/gen/retrieveGenTssPgsWBS.do")
    public ModelAndView retrieveGenTssPgsWBS(@RequestParam HashMap<String, String> input, HttpServletRequest request,
            HttpSession session, ModelMap model) {

        LOGGER.debug("###########################################################");
        LOGGER.debug("retrieveGenTssPgsWBS [과제관리 > 일반과제 > 진행 > WBS 조회]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSessionRUI(input, session, model);
        ModelAndView modelAndView = new ModelAndView("ruiView");

        List<Map<String, Object>> result = genTssPgsService.retrieveGenTssPgsWBS(input);

        modelAndView.addObject("dataset", RuiConverter.createDataset("dataset", result));

        //jsp에 있는 el에 담기위한 쓰레기 데이터
        request.setAttribute("resultCnt", 0);
        request.setAttribute("result", null);

        return modelAndView;
    }


    /**
     * 과제관리 > 일반과제 > 진행 > WBS 저장
     *
     * @param input HashMap<String, Object>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return ModelAndView
     * */
    @RequestMapping(value="/prj/tss/gen/updateGenTssPgsWBS.do")
    public ModelAndView updateGenTssPgsWBS(@RequestParam HashMap<String, Object> input, HttpServletRequest request,
            HttpSession session, ModelMap model) {

        LOGGER.debug("###########################################################");
        LOGGER.debug("updateGenTssPgsWBS [과제관리 > 일반과제 > 진행 > WBS 저장]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSessionObjRUI(input, session, model);

        ModelAndView modelAndView = new ModelAndView("ruiView");

        List<Map<String, Object>> ds = null;

        try {
            ds  = RuiConverter.convertToDataSet(request, "wbsDataSet");
            genTssPgsService.updateGenTssPgsWBS(ds);

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
     * 과제관리 > 일반과제 > 진행 > WBS > 산출물 화면
     *
     * @param input HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return String
     * @throws JSONException
     * */
    @RequestMapping(value="/prj/tss/gen/genTssPgsWBSYldPop.do")
    public String genTssPgsWBSYldPop(@RequestParam HashMap<String, String> input, HttpServletRequest request,
            HttpSession session, ModelMap model) throws JSONException {

        LOGGER.debug("###########################################################");
        LOGGER.debug("genTssPgsWBSYldPop [과제관리 > 일반과제 > 진행 > WBS > 산출물 화면]");
        LOGGER.debug("###########################################################");

        checkSession(input, session, model);

        if(pageMoveChkSession(input.get("_userId"))) {
            model.addAttribute("inputData", input);
        }

        return "web/prj/tss/gen/pgs/genTssPgsWBSYldPop";
    }


    //================================================================================================ 개발비
    /**
     * 과제관리 > 일반과제 > 진행 > 개발비 iframe 화면
     *
     * @param input HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return String
     * @throws JSONException
     * */
    @RequestMapping(value="/prj/tss/gen/genTssPgsTrwiBudgIfm.do")
    public String genTssPgsTrwiBudgIfm(@RequestParam HashMap<String, String> input, HttpServletRequest request,
            HttpSession session, ModelMap model) {

        LOGGER.debug("###########################################################");
        LOGGER.debug("GenTssController - genTssPgsTrwiBudgIfm [과제관리 > 일반과제 > 진행 > 개발비 iframe 화면]");
        LOGGER.debug("###########################################################");

        checkSession(input, session, model);

        if(pageMoveChkSession(input.get("_userId"))) {
            List<Map<String, Object>> purYy = genTssPgsService.retrieveGenTssPgsTssYy(input);

            request.setAttribute("purYy", purYy);
        }

        return "web/prj/tss/gen/pgs/genTssPgsTrwiBudgIfm";
    }


    /**
     * 과제관리 > 일반과제 > 진행 > 개발비 조회
     *
     * @param input HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return String
     * @throws JSONException
     * */
    @RequestMapping(value="/prj/tss/gen/retrieveGenTssPgsTrwiBudg.do")
    public ModelAndView retrieveGenTssPgsTrwiBudg(@RequestParam HashMap<String, String> input, HttpServletRequest request,
            HttpSession session, ModelMap model) {

        LOGGER.debug("###########################################################");
        LOGGER.debug("retrieveGenTssPgsTrwiBudg [과제관리 > 일반과제 > 진행 > 개발비 조회]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSessionRUI(input, session, model);
        ModelAndView modelAndView = new ModelAndView("ruiView");

        List<Map<String, Object>> result = null;
        
        int budgCnt = 0;
        budgCnt = genTssPgsService.retrieveGenTssBudgCnt(input);
        
        if ( budgCnt > 0    ) {
        	result = genTssPgsService.retrieveGenTssPgsTrwiBudg(input);
        }else{
        	result = genTssPgsService.retrieveGenTssTmpBudg(input);
        }
        		
        modelAndView.addObject("dataset", RuiConverter.createDataset("dataset", result));

        return modelAndView;
    }



    //================================================================================================ 목표및산출물
    /**
     * 과제관리 > 일반과제 > 진행 > 목표및산출물 iframe 화면
     *
     * @param input HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return String
     * @throws JSONException
     * */
    @RequestMapping(value="/prj/tss/gen/genTssPgsGoalYldIfm.do")
    public String genTssPgsGoalYldIfm(@RequestParam HashMap<String, String> input, HttpServletRequest request,
            HttpSession session, ModelMap model) throws JSONException {

        LOGGER.debug("###########################################################");
        LOGGER.debug("GenTssController - genTssPgsGoalYldIfm [과제관리 > 일반과제 > 진행 > 목표및산출물 iframe 화면 ]");
        LOGGER.debug("###########################################################");

        checkSession(input, session, model);

        if(pageMoveChkSession(input.get("_userId"))) {
            //데이터 있을 경우
            List<Map<String, Object>> resultGoal = null;
            List<Map<String, Object>> resultYld  = null;

            if(!"".equals(input.get("tssCd")) && null != input.get("tssCd")) {
                resultGoal = genTssPgsService.retrieveGenTssPgsGoal(input);
                resultYld  = genTssPgsService.retrieveGenTssPgsYld(input);
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

        return "web/prj/tss/gen/pgs/genTssPgsGoalYldIfm";
    }


    /**
     * 과제관리 > 일반과제 > 진행 > 목표및산출물 > 목표 조회
     *
     * @param input HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return String
     * @throws JSONException
     * */
    @RequestMapping(value="/prj/tss/gen/retrieveGenTssPgsGoal.do")
    public ModelAndView retrieveGenTssPgsGoal(@RequestParam HashMap<String, String> input, HttpServletRequest request,
            HttpSession session, ModelMap model) throws JSONException {

        LOGGER.debug("###########################################################");
        LOGGER.debug("retrieveGenTssPgsGoal [과제관리 > 일반과제 > 진행 > 목표및산출물 > 목표 조회]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSessionRUI(input, session, model);
        ModelAndView modelAndView = new ModelAndView("ruiView");

        List<Map<String, Object>> resultGoal = genTssPgsService.retrieveGenTssPgsGoal(input);
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
     * 과제관리 > 일반과제 > 진행 > 목표및산출물 > 산출물 조회
     *
     * @param input HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return String
     * @throws JSONException
     * */
    @RequestMapping(value="/prj/tss/gen/retrieveGenTssPgsYld.do")
    public ModelAndView retrieveGenTssPgsYld(@RequestParam HashMap<String, String> input, HttpServletRequest request,
            HttpSession session, ModelMap model) throws JSONException {

        LOGGER.debug("###########################################################");
        LOGGER.debug("retrieveGenTssPgsYld [과제관리 > 일반과제 > 진행 > 목표및산출물 > 산출물 조회]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSessionRUI(input, session, model);
        ModelAndView modelAndView = new ModelAndView("ruiView");

        List<Map<String, Object>> resultYld = genTssPgsService.retrieveGenTssPgsYld(input);
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
     * 과제관리 > 일반과제 > 진행 > 목표및산출물 > 목표 저장
     *
     * @param input HashMap<String, Object>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return ModelAndView
     * */
    @RequestMapping(value="/prj/tss/gen/updateGenTssPgsGoal.do")
    public ModelAndView updateGenTssPgsGoal(@RequestParam HashMap<String, Object> input, HttpServletRequest request,
            HttpSession session, ModelMap model) {

        LOGGER.debug("###########################################################");
        LOGGER.debug("updateGenTssPgsGoal [과제관리 > 일반과제 > 진행 > 목표및산출물 > 목표 저장]");
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

            genTssPgsService.updateGenTssPgsGoal(ds);

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
     * 과제관리 > 일반과제 > 진행 > 목표및산출물 > 산출물 저장
     *
     * @param input HashMap<String, Object>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return ModelAndView
     * */
    @RequestMapping(value="/prj/tss/gen/updateGenTssPgsYld.do")
    public ModelAndView updateGenTssPgsYld(@RequestParam HashMap<String, Object> input, HttpServletRequest request,
            HttpSession session, ModelMap model) {

        LOGGER.debug("###########################################################");
        LOGGER.debug("updateGenTssPgsYld [과제관리 > 일반과제 > 진행 > 목표및산출물 > 산출물 저장]");
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

            genTssPgsService.updateGenTssPgsYld(ds);

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



    //================================================================================================ 변경이력
    /**
     * 과제관리 > 일반과제 > 진행 > 변경이력 조회
     *
     * @param input HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return String
     * @throws JSONException
     * */
    @RequestMapping(value="/prj/tss/gen/genTssPgsAltrHistIfm.do")
    public String genTssPgsAltrHistIfm(@RequestParam HashMap<String, String> input, HttpServletRequest request,
            HttpSession session, ModelMap model) throws JSONException {

        LOGGER.debug("###########################################################");
        LOGGER.debug("retrieveGenTssPgsSmry [과제관리 > 일반과제 > 진행 > 변경이력 조회]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSession(input, session, model);

        if(pageMoveChkSession(input.get("_userId"))) {
            List<Map<String, Object>> result = genTssPgsService.retrieveGenTssPgsAltrHist(input);
            for(int i = 0; i < result.size(); i++) {
                StringUtil.toUtf8Output((HashMap)result.get(i));
            }

            JSONObject obj = new JSONObject();
            obj.put("records", result);

            request.setAttribute("inputData", input);
            request.setAttribute("resultCnt", result == null ? 0 : result.size());
            request.setAttribute("result", obj);
        }

        return "web/prj/tss/gen/pgs/genTssPgsAltrHistIfm";
    }





    @RequestMapping(value="/prj/tss/gen/retrieveGenTssPgsGoalYy.do")
    public ModelAndView retrieveGenTssPgsGoalYy(
            @RequestParam HashMap<String, String> input,
            HttpServletRequest request,
            HttpServletResponse response,
            HttpSession session,
            ModelMap model
            ){

        LOGGER.debug("###########################################################");
        LOGGER.debug("retrieveGenTssPgsGoalYy []");
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
     * 과제관리 > 일반과제 > 진행 > 변경이력 상세 팝업 화면
     *
     * @param input HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return String
     * @throws JSONException
     * */
    @RequestMapping(value="/prj/tss/gen/genTssAltrDetailPopup.do")
    public String genTssAltrDetailPopup(@RequestParam HashMap<String, String> input, HttpServletRequest request,
            HttpSession session, ModelMap model) throws JSONException {

        checkSession(input, session, model);
        
        LOGGER.debug("###########################################################");
        LOGGER.debug("genTssAltrDetailPopup [과제관리 > 일반과제 > 진행 > 변경이력 상세 팝업 화면 ]");
        LOGGER.debug("###########################################################");
       
        request.setAttribute("inputData", input);
        
        return "web/prj/tss/gen/genTssAltrDetailPopup";
    }
    

    /**
     * 과제관리 > 일반과제 > 진행 > 변경이력 상세 팝업 화면
     *
     * @param input HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return String
     * @throws JSONException
     * */
    @RequestMapping(value="/prj/tss/gen/genTssAltrDetailSearch.do")
    public ModelAndView genTssAltrDetailSearch(@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){

    	checkSessionObjRUI(input, session, model);
        ModelAndView modelAndView = new ModelAndView("ruiView");
        
        LOGGER.debug("###########################################################");
        LOGGER.debug("genTssAltrDetailPopup [과제관리 > 일반과제 > 진행 > 변경이력 상세 팝업 화면 ]");
        LOGGER.debug("####input  : ########### : " + input);
        LOGGER.debug("###########################################################");

        List<Map<String, Object>> resultAltr = genTssPgsService.retrieveGenTssAltrList(input);
        Map<String, Object> altrDtl = genTssPgsService.genTssAltrDetailSearch(input);
        
        StringUtil.toUtf8Output((HashMap<String, Object>) altrDtl);

        modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", resultAltr));
        modelAndView.addObject("rsonDataSet", RuiConverter.createDataset("rsonDataSet", altrDtl));
        
        return modelAndView;
    }
    
    
    /**
     * 과제관리 > 일반과제 > 진행 > 변경이동 팝업 화면
     *
     * @param input HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return String
     * @throws JSONException
     * */
    @RequestMapping(value="/prj/tss/gen/confirmPopup.do")
    public String confirmPopup(@RequestParam HashMap<String, String> input, HttpServletRequest request,
            HttpSession session, ModelMap model) throws JSONException {

        checkSession(input, session, model);
        
        LOGGER.debug("###########################################################");
        LOGGER.debug("confirmPopup [과제관리 > 일반과제 > 진행 > 변경이동 팝업 화면 ]");
        LOGGER.debug("###########################################################");
       
        request.setAttribute("inputData", input);
        
        return "web/prj/tss/gen/confirmPopup";
    }
}
