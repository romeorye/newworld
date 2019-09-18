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
import iris.web.prj.tss.gen.service.GenTssDcacService;
import iris.web.prj.tss.gen.service.GenTssService;
import iris.web.prj.tss.ousdcoo.service.OusdCooTssDcacService;
import iris.web.prj.tss.ousdcoo.service.OusdCooTssService;
import iris.web.system.base.IrisBaseController;

/********************************************************************************
 * NAME : OusdCooTssDcacController.java
 * DESC : 프로젝트 - 과제관리 - 대외협력과제 중단(Dcac) controller
 * PROJ : IRIS 구축 프로젝트
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION
 * ----------  ------  ---------------------------------------------------------
 * 2017.09.26  IRIS04	최초생성
 *********************************************************************************/

@Controller
public class OusdCooTssDcacController  extends IrisBaseController {

    @Resource(name="messageSourceAccessor")
    private MessageSourceAccessor messageSourceAccessor;

    @Resource(name = "tssUserService")
    private TssUserService tssUserService;

    @Resource(name = "genTssService")
    private GenTssService genTssService;

    @Resource(name = "ousdCooTssDcacService")
    private OusdCooTssDcacService ousdCooTssDcacService;	//대외협력과제 - 중단 서비스

    @Resource(name = "genTssDcacService")
    private GenTssDcacService genTssDcacService;		//대외협력과제 - 중단 서비스

    @Resource(name = "ousdCooTssService")
    private OusdCooTssService ousdCooTssService;		//대외협력과제 - 공통 서비스

    @Resource(name = "codeService")
    private CodeService codeService;

    static final Logger LOGGER = LogManager.getLogger(OusdCooTssDcacController.class);

    //================================================================================================ 마스터
    /**
     * 과제관리 > 대외협력과제 > 중단 > 마스터 조회
     *
     * @param input HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return String
     * @throws JSONException
     * */
    @RequestMapping(value="/prj/tss/ousdcoo/ousdCooTssDcacDetail.do")
    public String ousdCooTssDcacMst(@RequestParam HashMap<String, String> input, HttpServletRequest request,
            HttpSession session, ModelMap model) throws JSONException {
        LOGGER.debug("########################################################################");
        LOGGER.debug("retrieveOusdCooTssDcacMst [과제관리 > 대외협력과제 > 중단 > 마스터 조회]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("########################################################################");

        checkSession(input, session, model);

        if(pageMoveChkSession(input.get("_userId"))) {
            Map<String, Object> result = genTssDcacService.retrieveGenTssDcacMst(input);

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

        return "web/prj/tss/ousdcoo/dcac/ousdCooTssDcacDetail";
    }

    /**
     * 과제관리 > 대외협력과제 > 중단 > 마스터 신규(마스터 복사, 중단개요 저장)
     *
     * @param input HashMap<String, Object>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return ModelAndView
     * */
    @RequestMapping(value="/prj/tss/ousdcoo/insertOusdCooTssDcacMst.do")
    public ModelAndView insertOusdCooTssDcacMst(@RequestParam HashMap<String, Object> input, HttpServletRequest request,
            HttpSession session, ModelMap model) {
        LOGGER.debug("##################################################################################################");
        LOGGER.debug("insertOusdCooTssDcacMst [과제관리 > 대외협력과제 > 중단 > 마스터 신규(마스터 복사, 중단개요 저장)]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###################################################################################################");

        checkSessionObjRUI(input, session, model);

        ModelAndView modelAndView = new ModelAndView("ruiView");

        HashMap<String, Object> mstDs  = null;
        HashMap<String, Object> smryDs = null;
        
        try {
            mstDs  = (HashMap<String, Object>) RuiConverter.convertToDataSet(request, "mstDataSet").get(0);
            smryDs = (HashMap<String, Object>) RuiConverter.convertToDataSet(request, "smryDataSet").get(0);
            
            // 특수문자 변환 INPUT
            iris.web.common.util.StringUtil.toUtf8Input(smryDs);

        	int rtCnt = ousdCooTssDcacService.insertOusdCooTssDcacMst(mstDs, smryDs);
        	
        	if(rtCnt > 0) {
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
     * 과제관리 > 대외협력과제 > 중단 > 마스터 수정(마스터,중단개요 수정)
     *
     * @param input HashMap<String, Object>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return ModelAndView
     * */
    @RequestMapping(value="/prj/tss/ousdcoo/updateOusdCooTssDcacMst.do")
    public ModelAndView updateOusdCooTssDcacMst(@RequestParam HashMap<String, Object> input, HttpServletRequest request,
            HttpSession session, ModelMap model) {
        LOGGER.debug("############################################################################################");
        LOGGER.debug("updateOusdCooTssDcacMst [과제관리 > 대외협력과제 > 중단 > 마스터 수정(마스터,중단개요 수정)]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("############################################################################################");

        checkSessionObjRUI(input, session, model);

        ModelAndView modelAndView = new ModelAndView("ruiView");

        HashMap<String, Object> mstDs  = new HashMap<String, Object>();
        HashMap<String, Object> smryDs = new HashMap<String, Object>();

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
                
                // 특수문자 변환 INPUT
                iris.web.common.util.StringUtil.toUtf8Input(smryDs);
            }

            ousdCooTssDcacService.updateOusdCooTssDcacMst(mstDs, smryDs);

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



    //================================================================================================ 중단개요
    
	/**
     * 과제관리 > 대외협력과제 > 중단 > 중단 iframe 조회
     *
     * @param input HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return String
     * @throws JSONException
     * */
    @SuppressWarnings("rawtypes")
    @RequestMapping(value="/prj/tss/ousdcoo/ousdCooTssDcacSmryIfm.do")
    public String ousdCooTssDcacSmryIfm(@RequestParam HashMap<String, String> input, HttpServletRequest request,
            HttpSession session, ModelMap model) throws JSONException {
        LOGGER.debug("####################################################################");
        LOGGER.debug("ousdCooTssDcacSmryIfm [과제관리 > 대외협력과제 > 중단 > iframe 조회]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("####################################################################");

        checkSession(input, session, model);

        String rtnUrl ="";
        
        if(input.get("tssSt").equals("104") && input.get("pgsStepCd").equals("DC") ){
        	rtnUrl = "web/prj/tss/ousdcoo/dcac/ousdCooTssDcacIfmView";
        }else{
        	rtnUrl = "web/prj/tss/ousdcoo/dcac/ousdCooTssDcacIfm";
        }
        
        if(pageMoveChkSession(input.get("_userId"))) {
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

            request.setAttribute("resultData", result);
            request.setAttribute("inputData", input);
            request.setAttribute("resultCnt", result == null ? 0 : result.size());
            request.setAttribute("result", obj);
        }

        return rtnUrl;
    }



    //================================================================================================ 품의서
   
	/**
     * 과제관리 > 대외협력과제 > 중단 > 품의서요청 화면
     *
     * @param input HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return String
     * @throws JSONException
     * */
    @SuppressWarnings("rawtypes")
    @RequestMapping(value="/prj/tss/ousdcoo/ousdCooTssDcacCsusRq.do")
    public String ousdCooTssDcacCsusRq(@RequestParam HashMap<String, String> input, HttpServletRequest request,
            HttpSession session, ModelMap model) throws JSONException {
        LOGGER.debug("############################################################################");
        LOGGER.debug("ousdCooTssDcacGoalYldIfm [과제관리 > 대외협력과제 > 중단 > 품의서요청 화면 ]");
        LOGGER.debug("############################################################################");

        checkSession(input, session, model);
        HashMap<String, String> inputInfo = null;

        String rtnMsg = "";
        
		//필수값 체크
		rtnMsg = ousdCooTssDcacService.retrieveOusdCooTssDcacCheck(input);	
		LOGGER.debug("###########################rtnMsg11################################ : " + rtnMsg);	   
		
		if(!rtnMsg.equals("N")){
			input.put("rtnMsg", rtnMsg); //저장되었습니다.
			return this.ousdCooTssDcacMst(input, request, session, model);
		}
        
        if(pageMoveChkSession(input.get("_userId"))) {
            Map<String, Object> resultMst         = genTssDcacService.retrieveGenTssDcacMst(input);          //마스터
            
            Map<String, Object> resultSmry        = ousdCooTssService.retrieveOusdCooTssSmryNtoBr(input);    //개요
            // 특수문자 변환 OUTPUT
            if( resultSmry != null && !resultSmry.isEmpty() ) {
            	iris.web.common.util.StringUtil.toUtf8Output((HashMap) resultSmry);
            }
            
            Map<String, Object> resultCsus        = genTssService.retrieveGenTssCsus(resultMst); 		      //품의서
            // 특수문자 변환 OUTPUT
            if( resultCsus != null && !resultCsus.isEmpty() ) {
            	iris.web.common.util.StringUtil.toUtf8Output((HashMap) resultCsus);
            }

            inputInfo = new HashMap<String, String>();
            inputInfo.put("tssCd" , String.valueOf(resultMst.get("pgTssCd")));
            List<Map<String, Object>> resultExpStoa = ousdCooTssService.retrieveOusdCooTssExpStoa(inputInfo);   //진행 비용정보
            inputInfo = new HashMap<String, String>();
            inputInfo.put("attcFilId" , String.valueOf(resultSmry.get("dcacAttcFilId")));
            List<Map<String, Object>> resultAttc  = genTssDcacService.retrieveGenTssDcacAttc(inputInfo);      //중단 첨부파일정보

            inputInfo = new HashMap<String, String>();
            inputInfo.put("tssCd" , String.valueOf(resultMst.get("pgTssCd")));
            Map<String, Object> resultRqEtc       = ousdCooTssService.retrieveOusdCooRqEtcInfo(inputInfo);     //진행 품의서필요기타정보

            model.addAttribute("inputData"     , input);
            model.addAttribute("resultMst"     , resultMst);
            model.addAttribute("resultSmry"    , resultSmry);
            model.addAttribute("resultExpStoa" , resultExpStoa);
            model.addAttribute("resultRqEtc"   , resultRqEtc);
            model.addAttribute("resultAttc"    , resultAttc);
            model.addAttribute("resultCsus"    , resultCsus);

            //text컬럼을 위한 json변환
            JSONObject obj = new JSONObject();
            obj.put("records", resultSmry);

            request.setAttribute("jsonSmry", obj);
        }

        return "web/prj/tss/ousdcoo/dcac/ousdCooTssDcacCsusRq";
    }


    /**
     * 과제관리 > 대외협력과제 > 중단 > 품의서요청 생성(사용안함)
     *
     * @param input HashMap<String, Object>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return ModelAndView
     * */
    @SuppressWarnings("rawtypes")
	@RequestMapping(value="/prj/tss/ousdcoo/insertOusdCooTssDcacCsusRq.do")
    public ModelAndView insertOusdCooTssDcacCsusRq(@RequestParam HashMap<String, Object> input, HttpServletRequest request, HttpServletResponse response,
            HttpSession session, ModelMap model) {
        LOGGER.debug("#############################################################################");
        LOGGER.debug("insertOusdCooTssDcacCsusRq [과제관리 > 대외협력과제 > 중단 > 품의서요청 생성]");
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
