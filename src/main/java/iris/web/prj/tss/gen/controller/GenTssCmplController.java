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
import iris.web.prj.tss.gen.service.GenTssCmplService;
import iris.web.prj.tss.gen.service.GenTssPgsService;
import iris.web.prj.tss.gen.service.GenTssService;
import iris.web.system.base.IrisBaseController;


/********************************************************************************
 * NAME : GenTssCmplController.java
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
public class GenTssCmplController  extends IrisBaseController {

    @Resource(name="messageSourceAccessor")
    private MessageSourceAccessor messageSourceAccessor;

    @Resource(name = "tssUserService")
    private TssUserService tssUserService;

    @Resource(name = "genTssService")
    private GenTssService genTssService;

    @Resource(name = "genTssPgsService")
    private GenTssPgsService genTssPgsService;
    
    @Resource(name = "genTssCmplService")
    private GenTssCmplService genTssCmplService;

    @Resource(name = "codeService")
    private CodeService codeService;

    static final Logger LOGGER = LogManager.getLogger(GenTssCmplController.class);


    //================================================================================================ 마스터
    /**
     * 과제관리 > 일반과제 > 완료 > 마스터 조회
     *
     * @param input HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return String
     * @throws JSONException
     * */
    @RequestMapping(value="/prj/tss/gen/genTssCmplDetail.do")
    public String genTssCmplMst(@RequestParam HashMap<String, String> input, HttpServletRequest request,
            HttpSession session, ModelMap model) throws JSONException {

        LOGGER.debug("###########################################################");
        LOGGER.debug("retrieveGenTssCmplMst [과제관리 > 일반과제 > 완료 > 마스터 조회]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSession(input, session, model);

        if(pageMoveChkSession(input.get("_userId"))) {
            Map<String, Object> result = genTssCmplService.retrieveGenTssCmplMst(input);
            result = StringUtil.toUtf8Output((HashMap) result);
          
            Map<String, Object> role = tssUserService.getTssBtnRoleChk(input, result);
            result.put("tssRoleType", role.get("tssRoleType"));
            result.put("tssRoleId",   role.get("tssRoleId"));
            
            Map<String, Object> mbrCnt = genTssService.retrieveCmDcTssPtcMbrCnt(input);
            result.put("mbrCnt", mbrCnt.get("mbrCnt"));
            
            List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
            list.add(result);

            Map<String, Object> resultCsus        = genTssService.retrieveGenTssCsus(result); //품의서
            resultCsus = StringUtil.toUtf8Output((HashMap) resultCsus);
            
            JSONObject obj = new JSONObject();
            obj.put("records", list);

            request.setAttribute("inputData", input);
            request.setAttribute("resultCnt", result == null ? 0 : result.size());
            request.setAttribute("result", obj);

            request.setAttribute("resultCsus", resultCsus);
        }

        return "web/prj/tss/gen/cmpl/genTssCmplDetail";
    }



    /**
     * 과제관리 > 일반과제 > 완료 > 마스터 신규
     *
     * @param input HashMap<String, Object>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return ModelAndView
     * */
    @RequestMapping(value="/prj/tss/gen/insertGenTssCmplMst.do")
    public ModelAndView insertGenTssCmplMst(@RequestParam HashMap<String, Object> input, HttpServletRequest request,
            HttpSession session, ModelMap model) {

        LOGGER.debug("###########################################################");
        LOGGER.debug("insertGenTssCmplMst [과제관리 > 일반과제 > 완료 > 마스터 신규]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSessionObjRUI(input, session, model);

        ModelAndView modelAndView = new ModelAndView("ruiView");

        HashMap<String, Object> mstDs  = null;
        HashMap<String, Object> smryDs = null;
        
        try {
            mstDs  = (HashMap<String, Object>) RuiConverter.convertToDataSet(request, "mstDataSet").get(0);
            smryDs = (HashMap<String, Object>) RuiConverter.convertToDataSet(request, "smryDataSet").get(0);

            smryDs = StringUtil.toUtf8Input(smryDs);
       		
        	genTssCmplService.insertGenTssCmplMst(mstDs, smryDs);
        	
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
     * 과제관리 > 일반과제 > 완료 > 마스터 수정
     *
     * @param input HashMap<String, Object>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return ModelAndView
     * */
    @RequestMapping(value="/prj/tss/gen/updateGenTssCmplMst.do")
    public ModelAndView updateGenTssCmplMst(@RequestParam HashMap<String, Object> input, HttpServletRequest request,
            HttpSession session, ModelMap model) {

        LOGGER.debug("###########################################################");
        LOGGER.debug("updateGenTssCmplMst [과제관리 > 일반과제 > 완료 > 마스터 수정]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSessionObjRUI(input, session, model);

        ModelAndView modelAndView = new ModelAndView("ruiView");

        HashMap<String, Object> mstDs  = new HashMap<String, Object>();
        HashMap<String, Object> smryDs = new HashMap<String, Object>();

        try {
            mstDs  = (HashMap<String, Object>)RuiConverter.convertToDataSet(request, "mstDataSet").get(0);
            smryDs = (HashMap<String, Object>)RuiConverter.convertToDataSet(request, "smryDataSet").get(0);

            smryDs = StringUtil.toUtf8Input(smryDs);
            
        	genTssCmplService.updateGenTssCmplMst(mstDs, smryDs);
        	
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
     * 과제관리 > 일반과제 > 완료 > 완료 iframe 조회
     *
     * @param input HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return String
     * @throws JSONException
     * */
    @RequestMapping(value="/prj/tss/gen/genTssCmplIfm.do")
    public String genTssCmplIfm(@RequestParam HashMap<String, String> input, HttpServletRequest request,
            HttpSession session, ModelMap model) throws JSONException {

        LOGGER.debug("###########################################################");
        LOGGER.debug("genTssCmplIfm [과제관리 > 일반과제 > 완료 > iframe 조회]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSession(input, session, model);
        
        String rtnUrl ="";
        if(input.get("tssSt").equals("104") && (input.get("pgsStepCd").equals("CM") || input.get("pgsStepCd").equals("DC")) ){
            rtnUrl = "web/prj/tss/gen/cmpl/genTssCmplIfmView";
        }else{
        	rtnUrl = "web/prj/tss/gen/cmpl/genTssCmplIfm";
        }
        
        if(pageMoveChkSession(input.get("_userId"))) {
        	Map<String, Object> result = genTssCmplService.retrieveGenTssCmplIfm(input);
           
            if( result == null || result.size() == 0 ){
            	input.put( "tssCd", input.get("pgTssCd") );  	
            	result = genTssCmplService.retrieveGenTssCmplIfm(input);
            }
            
            result = StringUtil.toUtf8Output((HashMap) result);
            StringUtil.toUtf8Output((HashMap) result);

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
     * 과제관리 > 일반과제 > 완료 > 품의서요청 화면
     *
     * @param input HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return String
     * @throws JSONException
     * */
    @RequestMapping(value="/prj/tss/gen/genTssCmplCsusRq.do")
    public String genTssCmplCsusRq(@RequestParam HashMap<String, String> input, HttpServletRequest request,
            HttpSession session, ModelMap model) throws JSONException {


    	LOGGER.debug("###########################################################");
        LOGGER.debug("GenTssController - genTssCmplCsusRq [과제관리 > 일반과제 > 완료 > 품의서요청 화면 ]=== : " + input );
        LOGGER.debug("###########################################################");

        checkSession(input, session, model);
        
        String rtnMsg = "";
       
        if( input.get("itmFlag").equals("Y")){
        	rtnMsg = genTssCmplService.retrieveGenTssCmplCheck(input);	
        }else{
        	rtnMsg = "N";
        }
        
        if(!rtnMsg.equals("N")){
        	input.put("rtnMsg", rtnMsg); //저장되었습니다.
        	
        	return this.genTssCmplMst(input, request, session, model);
        }
        
        if(pageMoveChkSession(input.get("_userId"))) {
        	Map<String, Object> resultGrs         = genTssService.retrieveGenGrs(input); //마스터
        	Map<String, Object> resultMst         = genTssCmplService.retrieveGenTssCmplMst(input); //마스터
            Map<String, Object> resultCsus        = genTssService.retrieveGenTssCsus(resultMst); //품의서
            Map<String, Object> resultSmry        = genTssCmplService.retrieveGenTssCmplIfm(input); //개요
            
            HashMap<String, String> inputInfo = new HashMap<String, String>();
            inputInfo.put("tssCd",     String.valueOf(input.get("tssCd")));
            inputInfo.put("wbsCd",     String.valueOf(input.get("wbsCd")));
            inputInfo.put("pgTssCd",   String.valueOf(resultMst.get("pgTssCd")));
            inputInfo.put("tssStrtDd", String.valueOf(resultMst.get("tssStrtDd")));
            inputInfo.put("tssFnhDd",  String.valueOf(resultMst.get("tssFnhDd")));
            inputInfo.put("attcFilId", String.valueOf(resultSmry.get("cmplAttcFilId")));

            Map<String, Object> resultCmpl        = genTssCmplService.retrieveGenTssCmplInfo(inputInfo);
            List<Map<String, Object>> resultAttc  = genTssCmplService.retrieveGenTssCmplAttc(inputInfo);

            resultGrs  = StringUtil.toUtf8Output((HashMap) resultGrs);
            resultMst  = StringUtil.toUtf8Output((HashMap) resultMst);
            resultCsus = StringUtil.toUtf8Output((HashMap) resultCsus);
            resultSmry = StringUtil.toUtf8Output((HashMap) resultSmry);
            resultCmpl = StringUtil.toUtf8Output((HashMap) resultCmpl);

            model.addAttribute("inputData", input);
            model.addAttribute("resultGrs", resultGrs);
            model.addAttribute("resultMst", resultMst);
            model.addAttribute("resultSmry", resultSmry);
            model.addAttribute("resultCmpl", resultCmpl);
            model.addAttribute("resultAttc", resultAttc);
            model.addAttribute("resultCsus", resultCsus);

            //text컬럼을 위한 json변환
            JSONObject obj = new JSONObject();
            obj.put("records", resultSmry);

            request.setAttribute("jsonSmry", obj);
            
        	
        }
        return "web/prj/tss/gen/cmpl/genTssCmplCsusRq";
    }


    /**
     * 과제관리 > 일반과제 > 완료 > 품의서요청 생성
     *
     * @param input HashMap<String, Object>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return ModelAndView
     * */
    @RequestMapping(value="/prj/tss/gen/insertGenTssCmplCsusRq.do")
    public ModelAndView insertGenTssCmplCsusRq(@RequestParam HashMap<String, Object> input, HttpServletRequest request, HttpServletResponse response,
            HttpSession session, ModelMap model) {

        LOGGER.debug("###########################################################");
        LOGGER.debug("insertGenTssCmplCsusRq [과제관리 > 일반과제 > 완료 > 품의서요청 생성]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSessionObjRUI(input, session, model);

        ModelAndView modelAndView = new ModelAndView("ruiView");

        List<Map<String, Object>> ds = null;

        try {
            ds  = RuiConverter.convertToDataSet(request, "dataSet");
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

    //================================================================================================ 참여연구원
    /**
     * 과제관리 > 일반과제 > 완료 > 초기유동관리 iframe 화면
     *
     * @param input HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return String
     * @throws JSONException
     * */
    @RequestMapping(value="/prj/tss/gen/genTssCmplPtcRsstMbrIfm.do")
    public String genTssCmplPtcRsstMbrIfm(@RequestParam HashMap<String, String> input, HttpServletRequest request,
            HttpSession session, ModelMap model) throws JSONException {

        LOGGER.debug("###########################################################");
        LOGGER.debug("GenTssCmplController - genTssCmplPtcRsstMbrIfm [과제관리 > 일반과제 > 완료 > 초기유동관리 iframe 화면 ]");
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

        return "web/prj/tss/gen/cmpl/genTssCmplPtcRsstMbrIfm";
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
