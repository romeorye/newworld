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
import iris.web.prj.tss.com.service.TssUserService;
import iris.web.prj.tss.gen.service.GenTssCmplService;
import iris.web.prj.tss.gen.service.GenTssService;
import iris.web.prj.tss.ousdcoo.service.OusdCooTssCmplService;
import iris.web.prj.tss.ousdcoo.service.OusdCooTssService;
import iris.web.system.base.IrisBaseController;

/********************************************************************************
 * NAME : OusdCooTssController.java
 * DESC : 프로젝트 - 과제관리 - 대외협력과제 완료 controller
 * PROJ : IRIS 구축 프로젝트
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION
 * ----------  ------  ---------------------------------------------------------
 * 2017.09.21  IRIS04	최초생성
 *********************************************************************************/

@Controller
public class OusdCooTssCmplController  extends IrisBaseController {

    @Resource(name="messageSourceAccessor")
    private MessageSourceAccessor messageSourceAccessor;

    @Resource(name = "tssUserService")
    private TssUserService tssUserService;

    @Resource(name = "genTssService")
    private GenTssService genTssService;

    @Resource(name = "ousdCooTssCmplService")
    private OusdCooTssCmplService ousdCooTssCmplService;	// 대외협력과제 완료 서비스

    @Resource(name = "ousdCooTssService")
    private OusdCooTssService ousdCooTssService;		// 대외협력과제 서비스

    @Resource(name = "genTssCmplService")
    private GenTssCmplService genTssCmplService;		// 일반과제 완료 서비스
    
    @Resource(name = "codeService")
    private CodeService codeService;

    static final Logger LOGGER = LogManager.getLogger(OusdCooTssCmplController.class);


    //================================================================================================ 마스터
    /**
     * 과제관리 > 대외협력과제 > 완료 > 마스터 조회
     *
     * @param input HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return String
     * @throws JSONException
     * */
    @RequestMapping(value="/prj/tss/ousdcoo/ousdCooTssCmplDetail.do")
    public String ousdCooTssCmplMst(@RequestParam HashMap<String, String> input, HttpServletRequest request,
            HttpSession session, ModelMap model) throws JSONException {
        LOGGER.debug("###########################################################");
        LOGGER.debug("retrieveGenTssCmplMst [과제관리 > 대외협력과제 > 완료 > 마스터 조회]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSession(input, session, model);

        if(pageMoveChkSession(input.get("_userId"))) {
            Map<String, Object> result = genTssCmplService.retrieveGenTssCmplMst(input);
           
            Map<String, Object> mbrCnt = genTssService.retrieveCmDcTssPtcMbrCnt(input);
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

        return "web/prj/tss/ousdcoo/cmpl/ousdCooTssCmplDetail";
    }

    /**
     * 과제관리 > 대외협력과제 > 완료 > 마스터 신규
     *
     * @param input HashMap<String, Object>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return ModelAndView
     * */
    @SuppressWarnings("rawtypes")
	@RequestMapping(value="/prj/tss/ousdcoo/insertOusdCooTssCmplMst.do")
    public ModelAndView insertOusdCooTssCmplMst(@RequestParam HashMap<String, Object> input, HttpServletRequest request,
            HttpSession session, ModelMap model) {
        LOGGER.debug("###########################################################");
        LOGGER.debug("insertOusdCooTssCmplMst [과제관리 > 대외협력과제 > 완료 > 마스터 신규]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSessionObjRUI(input, session, model);
        ModelAndView modelAndView = new ModelAndView("ruiView");

        HashMap<String, Object> mstDs  = null;
        HashMap<String, Object> smryDs = null;
        
        
        try {
            mstDs  = (HashMap<String, Object>) RuiConverter.convertToDataSet(request, "mstDataSet").get(0);
            smryDs = (HashMap<String, Object>) RuiConverter.convertToDataSet(request, "smryDataSet").get(0);
            // 특수문자 변환 INPUT
            if( smryDs != null && !smryDs.isEmpty() ) {
            	iris.web.common.util.StringUtil.toUtf8Input(smryDs);
            }
            
        	ousdCooTssCmplService.insertOusdCooTssPlnMst(mstDs, smryDs);
        	 
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
     * 과제관리 > 대외협력과제 > 완료 > 마스터 수정
     *
     * @param input HashMap<String, Object>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return ModelAndView
     * */
    @SuppressWarnings("rawtypes")
	@RequestMapping(value="/prj/tss/ousdcoo/updateOusdCooTssCmplMst.do")
    public ModelAndView updateOusdCooTssCmplMst(@RequestParam HashMap<String, Object> input, HttpServletRequest request,
            HttpSession session, ModelMap model) {

        LOGGER.debug("###########################################################");
        LOGGER.debug("updateOusdCooTssCmplMst [과제관리 > 대외협력과제 > 완료 > 마스터 수정]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSessionObjRUI(input, session, model);

        ModelAndView modelAndView = new ModelAndView("ruiView");

        HashMap<String, Object> mstDs  = new HashMap<String, Object>();
        HashMap<String, Object> smryDs = new HashMap<String, Object>();
        
        try {
            List<Map<String, Object>> mstDsList  = RuiConverter.convertToDataSet(request, "mstDataSet");
            List<Map<String, Object>> smryDsList = RuiConverter.convertToDataSet(request, "smryDataSet");

            mstDs = (HashMap<String, Object>) mstDsList.get(0);
            
            smryDs = (HashMap<String, Object>) smryDsList.get(0);
            // 특수문자 변환 INPUT
            if( smryDs != null && !smryDs.isEmpty() ) {
            	iris.web.common.util.StringUtil.toUtf8Input(smryDs);
            	LOGGER.debug("smryDs : "+smryDs);
            }

            ousdCooTssCmplService.updateOusdCooTssCmplMst(mstDs, smryDs, false);
            	 
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
     * 과제관리 > 대외협력과제 > 완료 > 완료 iframe 조회
     *
     * @param input HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return String
     * @throws JSONException
     * */
    @SuppressWarnings("rawtypes")
    @RequestMapping(value="/prj/tss/ousdcoo/ousdCooTssCmplSmryIfm.do")
    public String ousdCooTssCmplSmryIfm(@RequestParam HashMap<String, String> input, HttpServletRequest request,
            HttpSession session, ModelMap model) throws JSONException {

        LOGGER.debug("###########################################################");
        LOGGER.debug("ousdCooTssCmplSmryIfm [과제관리 > 대외협력과제 > 완료 > iframe 조회]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSession(input, session, model);

        String rtnUrl ="";
        
        if(input.get("tssSt").equals("104") && input.get("pgsStepCd").equals("CM") ){
        	rtnUrl = "web/prj/tss/ousdcoo/cmpl/ousdCooTssCmplIfmView";
        }else{
        	rtnUrl = "web/prj/tss/ousdcoo/cmpl/ousdCooTssCmplIfm";
        }
        
        
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
            request.setAttribute("resultData", result);
            request.setAttribute("resultCnt", result == null ? 0 : result.size());
            request.setAttribute("result", obj);
        }

        return rtnUrl;
    }



    //================================================================================================ 품의서
    
	/**
     * 과제관리 > 대외협력과제 > 완료 > 품의서요청 화면
     *
     * @param input HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return String
     * @throws JSONException
     * */
    @SuppressWarnings("rawtypes")
    @RequestMapping(value="/prj/tss/ousdcoo/ousdCooTssCmplCsusRq.do")
    public String ousdCooTssCmplCsusRq(@RequestParam HashMap<String, String> input, HttpServletRequest request,
            HttpSession session, ModelMap model) throws JSONException {
        LOGGER.debug("############################################################################");
        LOGGER.debug("ousdCooTssCmplCsusRq [과제관리 > 대외협력과제 > 완료 > 품의서요청 화면 ]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("############################################################################");

        HashMap<String,String> searchParam = null;
        checkSession(input, session, model);

        String rtnMsg = "";
        
        //필수값 체크
        rtnMsg = ousdCooTssCmplService.retrieveOusdCooTssCmplCheck(input);	
        LOGGER.debug("###########################rtnMsg11################################ : " + rtnMsg);	
        
        if(!rtnMsg.equals("N")){
        	input.put("rtnMsg", rtnMsg); //저장되었습니다.
        	
        	return this.ousdCooTssCmplMst(input, request, session, model);
        }
        
        if(pageMoveChkSession(input.get("_userId"))) {
            Map<String, Object> resultMst     = genTssCmplService.retrieveGenTssCmplMst(input);              //마스터
            
            Map<String, Object> resultSmry    = ousdCooTssService.retrieveOusdCooTssSmryNtoBr(input);        //개요
            // 특수문자 변환 OUTPUT
            if( resultSmry != null && !resultSmry.isEmpty() ) {
            	iris.web.common.util.StringUtil.toUtf8Output((HashMap) resultSmry);
            }
            
            Map<String, Object> resultCsus    = genTssService.retrieveGenTssCsus(resultMst); 				//품의서
            // 특수문자 변환 OUTPUT
            if( resultCsus != null && !resultCsus.isEmpty() ) {
            	iris.web.common.util.StringUtil.toUtf8Output((HashMap) resultCsus);
            }

            searchParam = new HashMap<String,String>();
            //searchParam.put("tssCd",  NullUtil.nvl(input.get("tssCd"), ""));
            Map<String, Object> resultExpStoa = ousdCooTssService.retrieveOusdCooTssExpStoa(input);    //비용실적

            HashMap<String, String> inputInfo = new HashMap<String, String>();
            inputInfo.put("tssCd",     String.valueOf(input.get("tssCd")));
            inputInfo.put("pgTssCd",   String.valueOf(resultMst.get("pgTssCd")));
            inputInfo.put("tssStrtDd", NullUtil.nvl(resultMst.get("tssStrtDd"),""));
            inputInfo.put("tssFnhDd",  NullUtil.nvl(resultMst.get("tssFnhDd"),""));
            inputInfo.put("attcFilId", NullUtil.nvl(resultSmry.get("cmplAttcFilId"),""));

            Map<String, Object> resultCmpl        = genTssCmplService.retrieveGenTssCmplInfo(inputInfo);	//품의서 기타정보
            List<Map<String, Object>> resultAttc  = genTssCmplService.retrieveGenTssCmplAttc(inputInfo);	//품의서 파일정보

            model.addAttribute("inputData"     , input);
            model.addAttribute("resultMst"     , resultMst);
            model.addAttribute("resultSmry"    , resultSmry);
            model.addAttribute("resultExpStoa" , resultExpStoa);
            model.addAttribute("resultCmpl"    , resultCmpl);
            model.addAttribute("resultAttc"    , resultAttc);
            model.addAttribute("resultCsus"    , resultCsus);

            //text컬럼을 위한 json변환
            JSONObject obj = new JSONObject();
            obj.put("records", resultSmry);

            request.setAttribute("jsonSmry", obj);
        }

        return "web/prj/tss/ousdcoo/cmpl/ousdCooTssCmplCsusRq";
    }


    /**
     * 과제관리 > 대외협력과제 > 완료 > 품의서요청 생성(사용안함)
     *
     * @param input HashMap<String, Object>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return ModelAndView
     * */
    @SuppressWarnings("rawtypes")
	@RequestMapping(value="/prj/tss/ousdcoo/insertOusdCooTssCmplCsusRq.do")
    public ModelAndView insertOusdCooTssCmplCsusRq(@RequestParam HashMap<String, Object> input, HttpServletRequest request, HttpServletResponse response,
            HttpSession session, ModelMap model) {

        LOGGER.debug("#############################################################################");
        LOGGER.debug("insertOusdCooTssCmplCsusRq [과제관리 > 대외협력과제 > 완료 > 품의서요청 생성]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("#############################################################################");

        checkSessionObjRUI(input, session, model);

        ModelAndView modelAndView = new ModelAndView("ruiView");

        List<Map<String, Object>> ds = null;

        try {
            ds  = RuiConverter.convertToDataSet(request, "dataSet");
            // 특수문자 변환 INPUT
            if( ds != null && ds.size()>0 ) {
            	iris.web.common.util.StringUtil.toUtf8Input((HashMap) ds.get(0));
            }
            genTssCmplService.insertGenTssCmplCsusRq(ds.get(0));

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
    
  //================================================================================================ 비용지급실적
    /**
     * 과제관리 > 대외협력과제 > 완료 > 비용지급실적 iframe 화면
     *
     * @param input HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return String
     * @throws JSONException
     * */
    @RequestMapping(value="/prj/tss/ousdcoo/ousdCooTssCmplExpStoaIfm.do")
    public String ousdCooTssCmplExpStoaIfm(@RequestParam HashMap<String, String> input, HttpServletRequest request,
            HttpSession session, ModelMap model) throws JSONException {

        LOGGER.debug("###########################################################################################");
        LOGGER.debug("retrieveOusdCooTssCmplExpStoaIfm [과제관리 > 대외협력과제 > 완료 > 비용지급실적 iframe 화면]");
        LOGGER.debug("###########################################################################################");

        checkSession(input, session, model);
        if(pageMoveChkSession(input.get("_userId"))) {

            //데이터 있을 경우
            Map<String, Object> result = null;
            Map<String, Object> smry = null;
            if(!"".equals(input.get("tssCd"))) {
            	result = ousdCooTssService.retrieveCmplOusdCooTssExpStoa(input);	//완료 비용지급실적 조회
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

        return "web/prj/tss/ousdcoo/cmpl/ousdCooTssCmplExpStoaIfm";
    }

    /**
     * 과제관리 > 대외협력과제 > 완료 > 비용지급실적 조회
     *
     * @param input HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return String
     * @throws JSONException
     * */
    @RequestMapping(value="/prj/tss/ousdcoo/retrieveOusdCooTssCmplExpStoa.do")
    public ModelAndView retrieveOusdCooTssCmplExpStoa(@RequestParam HashMap<String, String> input, HttpServletRequest request,
            HttpSession session, ModelMap model) {
    	
    	checkSessionRUI(input, session, model);
    	
        LOGGER.debug("############################################################################");
        LOGGER.debug("retrieveOusdCooTssCmplExpStoa [과제관리 > 대외협력과제 > 완료 > 개발비 조회]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("############################################################################");

        
        ModelAndView modelAndView = new ModelAndView("ruiView");

        Map<String, Object> result = ousdCooTssService.retrieveCmplOusdCooTssExpStoa(input);	//완료 비용지급실적 조회
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
    @RequestMapping(value="/prj/tss/ousdcoo/insertOusdCooTssCmplExpStoa.do")
    public ModelAndView insertOusdCooTssCmplExpStoa(@RequestParam HashMap<String, Object> input, HttpServletRequest request, HttpServletResponse response,
            HttpSession session, ModelMap model) {

        checkSessionObjRUI(input, session, model);
    	
        LOGGER.debug("###############################################################################");
        LOGGER.debug("insertOusdCooTssCmplExpStoa [과제관리 > 대외협력과제 > 진행 > 비용지급실적 저장]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("################################################################################");

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
     * 과제관리 > 대외협력과제 > 완료 > 비용지급실적 수정
     *
     * @param input HashMap<String, Object>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return ModelAndView
     * */
    @RequestMapping(value="/prj/tss/ousdcoo/updateOusdCooTssCmplExpStoa.do")
    public ModelAndView updateOusdCooTssCmplExpStoa(@RequestParam HashMap<String, Object> input, HttpServletRequest request, HttpServletResponse response,
            HttpSession session, ModelMap model) {
    	
    	checkSessionObjRUI(input, session, model);
    	
        LOGGER.debug("###############################################################################");
        LOGGER.debug("updateOusdCooTssCmplExpStoa [과제관리 > 대외협력과제 > 완료 > 비용지급실적 수정]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("################################################################################");

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

}
