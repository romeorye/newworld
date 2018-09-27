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
import iris.web.prj.tss.gen.service.GenTssDcacService;
import iris.web.prj.tss.gen.service.GenTssService;
import iris.web.system.base.IrisBaseController;


/********************************************************************************
 * NAME : GenTssDcacController.java
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

public class GenTssDcacController  extends IrisBaseController {

    @Resource(name="messageSourceAccessor")
    private MessageSourceAccessor messageSourceAccessor;

    @Resource(name = "tssUserService")
    private TssUserService tssUserService;

    @Resource(name = "genTssService")
    private GenTssService genTssService;

    @Resource(name = "genTssDcacService")
    private GenTssDcacService genTssDcacService;

    @Resource(name = "codeService")
    private CodeService codeService;

    static final Logger LOGGER = LogManager.getLogger(GenTssDcacController.class);


    //================================================================================================ 마스터
    /**
     * 과제관리 > 일반과제 > 중단 > 마스터 조회
     *
     * @param input HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return String
     * @throws JSONException
     * */
    @RequestMapping(value="/prj/tss/gen/genTssDcacDetail.do")
    public String genTssDcacMst(@RequestParam HashMap<String, String> input, HttpServletRequest request,
            HttpSession session, ModelMap model) throws JSONException {

        LOGGER.debug("###########################################################");
        LOGGER.debug("retrieveGenTssDcacMst [과제관리 > 일반과제 > 중단 > 마스터 조회]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSession(input, session, model);

        if(pageMoveChkSession(input.get("_userId"))) {
            Map<String, Object> result = genTssDcacService.retrieveGenTssDcacMst(input);
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

        return "web/prj/tss/gen/dcac/genTssDcacDetail";
    }



    /**
     * 과제관리 > 일반과제 > 중단 > 마스터 신규
     *
     * @param input HashMap<String, Object>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return ModelAndView
     * */
    @RequestMapping(value="/prj/tss/gen/insertGenTssDcacMst.do")
    public ModelAndView insertGenTssDcacMst(@RequestParam HashMap<String, String> input, HttpServletRequest request,
            HttpSession session, ModelMap model) {

        LOGGER.debug("###########################################################");
        LOGGER.debug("insertGenTssDcacMst [과제관리 > 일반과제 > 중단 > 마스터 신규]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSession(input, session, model);

        ModelAndView modelAndView = new ModelAndView("ruiView");

        HashMap<String, Object> mstDs  = null;
        HashMap<String, Object> smryDs = null;
        String rtnMsg = "";
        int rtCnt = 0;
        
        try {
            mstDs  = (HashMap<String, Object>) RuiConverter.convertToDataSet(request, "mstDataSet").get(0);
            smryDs = (HashMap<String, Object>) RuiConverter.convertToDataSet(request, "smryDataSet").get(0);

            smryDs = StringUtil.toUtf8Input(smryDs);

            rtCnt = genTssDcacService.insertGenTssDcacMst(mstDs, smryDs);

        	if(rtCnt > 0) {
        		mstDs.put("rtCd", "SUCCESS");
        		mstDs.put("rtVal",messageSourceAccessor.getMessage("msg.alert.saved")); //저장되었습니다.
        		mstDs.put("rtType", "I");
        	}
        	
        } catch(Exception e) {
            e.printStackTrace();
            mstDs.put("rtCd", "FAIL");
            mstDs.put("rtVal", "오류가 발생하였습니다. 관리자에게 문읳"); //오류가 발생하였습니다.
        }
        modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", mstDs));
        return modelAndView;
    }


    /**
     * 과제관리 > 일반과제 > 중단 > 마스터 수정
     *
     * @param input HashMap<String, Object>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return ModelAndView
     * */
    @RequestMapping(value="/prj/tss/gen/updateGenTssDcacMst.do")
    public ModelAndView updateGenTssDcacMst(@RequestParam HashMap<String, Object> input, HttpServletRequest request,
            HttpSession session, ModelMap model) {

        LOGGER.debug("###########################################################");
        LOGGER.debug("updateGenTssDcacMst [과제관리 > 일반과제 > 중단 > 마스터 수정]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSessionObjRUI(input, session, model);

        ModelAndView modelAndView = new ModelAndView("ruiView");

        HashMap<String, Object> mstDs  = new HashMap<String, Object>();
        HashMap<String, Object> smryDs = new HashMap<String, Object>();
        String rtnMsg = "";
        
        try {
            List<Map<String, Object>> mstDsList  = RuiConverter.convertToDataSet(request, "mstDataSet");
            List<Map<String, Object>> smryDsList = RuiConverter.convertToDataSet(request, "smryDataSet");

            //마스터 수정
            if(!mstDsList.isEmpty()) {
                mstDs = (HashMap<String, Object>) mstDsList.get(0);
            }

            //개요 수정
            if(!smryDsList.isEmpty()) {
                smryDs = (HashMap<String, Object>) smryDsList.get(0);
            }

            smryDs = StringUtil.toUtf8Input(smryDs);
            
        	genTssDcacService.updateGenTssDcacMst(mstDs, smryDs);

            mstDs.put("rtCd", "SUCCESS");
            mstDs.put("rtVal",messageSourceAccessor.getMessage("msg.alert.saved")); //저장되었습니다.
           
        } catch(Exception e) {
            e.printStackTrace();
            mstDs.put("rtCd", "FAIL");
            mstDs.put("rtVal", messageSourceAccessor.getMessage("msg.alert.error")); //오류가 발생하였습니다.
        }

        modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", mstDs));

        return modelAndView;
    }



    //================================================================================================ 개요
    /**
     * 과제관리 > 일반과제 > 중단 > 중단 iframe 조회
     *
     * @param input HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return String
     * @throws JSONException
     * */
    @RequestMapping(value="/prj/tss/gen/genTssDcacSmryIfm.do")
    public String genTssDcacSmryIfm(@RequestParam HashMap<String, String> input, HttpServletRequest request,
            HttpSession session, ModelMap model) throws JSONException {

        LOGGER.debug("###########################################################");
        LOGGER.debug("genTssDcacSmryIfm [과제관리 > 일반과제 > 중단 > iframe 조회]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSession(input, session, model);

        String rtnUrl ="";
        
        if(input.get("tssSt").equals("104") && input.get("pgsStepCd").equals("DC") ){
        	rtnUrl = "web/prj/tss/gen/dcac/genTssDcacIfmView";
        }else{
        	rtnUrl = "web/prj/tss/gen/dcac/genTssDcacIfm";
        }
        
        if(pageMoveChkSession(input.get("_userId"))) {
            Map<String, Object> result = null;
            if(!"".equals(input.get("tssCd")) && null != input.get("tssCd")) {
                result = genTssDcacService.retrieveGenTssDcacSmry(input);
            }
            result = StringUtil.toUtf8Output((HashMap) result);

            List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
            list.add(result);

            JSONObject obj = new JSONObject();
            obj.put("records", list);

            request.setAttribute("inputData", input);
            request.setAttribute("resultData", result);
            request.setAttribute("resultCnt", result == null ? 0 : result.size());
            request.setAttribute("result", obj);
        }

        return rtnUrl;
    }



    //================================================================================================ 품의서
    /**
     * 과제관리 > 일반과제 > 중단 > 품의서요청 화면
     *
     * @param input HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return String
     * @throws JSONException
     * */
    @RequestMapping(value="/prj/tss/gen/genTssDcacCsusRq.do")
    public String genTssDcacCsusRq(@RequestParam HashMap<String, String> input, HttpServletRequest request,
            HttpSession session, ModelMap model) throws JSONException {

        LOGGER.debug("###########################################################");
        LOGGER.debug("GenTssController - genTssDcacGoalYldIfm [과제관리 > 일반과제 > 중단 > 품의서요청 화면 ]");
        LOGGER.debug("###########################################################");

        checkSession(input, session, model);

        String rtnMsg = "";
        
        rtnMsg = genTssDcacService.retrieveGenTssDcacCheck(input);
        
        LOGGER.debug("#######################rtnMsg#################################### : " + rtnMsg);
        if( !rtnMsg.equals("N") ){
    		input.put("rtnMsg", rtnMsg); 
    		
    		return this.genTssDcacMst(input, request, session, model);
    	}
        
        if(pageMoveChkSession(input.get("_userId"))) {
            Map<String, Object> resultMst         = genTssDcacService.retrieveGenTssDcacMst(input); //마스터
            Map<String, Object> resultCsus        = genTssService.retrieveGenTssCsus(resultMst); //품의서
            Map<String, Object> resultSmry        = genTssDcacService.retrieveGenTssDcacSmry(input); //개요

            HashMap<String, String> inputInfo = new HashMap<String, String>();
            inputInfo.put("tssCd",     String.valueOf(input.get("tssCd")));
            inputInfo.put("pgTssCd",   String.valueOf(resultMst.get("pgTssCd")));
            inputInfo.put("tssStrtDd", String.valueOf(resultMst.get("tssStrtDd")));
            inputInfo.put("tssFnhDd",  String.valueOf(resultMst.get("tssFnhDd")));
            inputInfo.put("attcFilId", String.valueOf(resultSmry.get("dcacAttcFilId")));

            Map<String, Object> resultDcac        = genTssDcacService.retrieveGenTssDcacInfo(inputInfo);
            List<Map<String, Object>> resultAttc  = genTssDcacService.retrieveGenTssDcacAttc(inputInfo);

            resultMst  = StringUtil.toUtf8Output((HashMap) resultMst);
            resultCsus = StringUtil.toUtf8Output((HashMap) resultCsus);
            resultSmry = StringUtil.toUtf8Output((HashMap) resultSmry);
            resultDcac = StringUtil.toUtf8Output((HashMap) resultDcac);

            model.addAttribute("inputData", input);
            model.addAttribute("resultMst", resultMst);
            model.addAttribute("resultSmry", resultSmry);
            model.addAttribute("resultDcac", resultDcac);
            model.addAttribute("resultAttc", resultAttc);
            model.addAttribute("resultCsus", resultCsus);

            //text컬럼을 위한 json변환
            JSONObject obj = new JSONObject();
            obj.put("records", resultSmry);

            request.setAttribute("jsonSmry", obj);
        }

        return "web/prj/tss/gen/dcac/genTssDcacCsusRq";
    }


    /**
     * 과제관리 > 일반과제 > 중단 > 품의서요청 생성
     *
     * @param input HashMap<String, Object>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return ModelAndView
     * */
    @RequestMapping(value="/prj/tss/gen/insertGenTssDcacCsusRq.do")
    public ModelAndView insertGenTssDcacCsusRq(@RequestParam HashMap<String, Object> input, HttpServletRequest request, HttpServletResponse response,
            HttpSession session, ModelMap model) {

        LOGGER.debug("###########################################################");
        LOGGER.debug("insertGenTssDcacCsusRq [과제관리 > 일반과제 > 중단 > 품의서요청 생성]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSessionObjRUI(input, session, model);

        ModelAndView modelAndView = new ModelAndView("ruiView");

        List<Map<String, Object>> ds = null;

        try {
            ds  = RuiConverter.convertToDataSet(request, "dataSet");
            genTssDcacService.insertGenTssDcacCsusRq(ds.get(0));

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
