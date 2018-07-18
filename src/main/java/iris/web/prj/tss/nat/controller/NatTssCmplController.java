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
import iris.web.common.util.CommonUtil;
import iris.web.common.util.StringUtil;
import iris.web.prj.tss.com.service.TssUserService;
import iris.web.prj.tss.gen.service.GenTssService;
import iris.web.prj.tss.nat.service.NatTssCmplService;
import iris.web.system.base.IrisBaseController;


/********************************************************************************
 * NAME : NatTssCmplController.java
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
public class NatTssCmplController  extends IrisBaseController {

    @Resource(name="messageSourceAccessor")
    private MessageSourceAccessor messageSourceAccessor;

    @Resource(name = "tssUserService")
    private TssUserService tssUserService;

    @Resource(name = "genTssService")
    private GenTssService genTssService;

    @Resource(name = "natTssCmplService")
    private NatTssCmplService natTssCmplService;

    @Resource(name = "codeService")
    private CodeService codeService;

    static final Logger LOGGER = LogManager.getLogger(NatTssCmplController.class);


    //================================================================================================ 마스터
    /**
     * 과제관리 > 국책과제 > 완료 > 마스터 조회
     *
     * @param input HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return String
     * @throws JSONException
     * */
    @RequestMapping(value="/prj/tss/nat/natTssCmplDetail.do")
    public String natTssCmplMst(@RequestParam HashMap<String, String> input, HttpServletRequest request,
            HttpSession session, ModelMap model) throws JSONException {

        LOGGER.debug("###########################################################");
        LOGGER.debug("retrieveNatTssCmplMst [과제관리 > 국책과제 > 완료 > 마스터 조회]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSession(input, session, model);

        if(pageMoveChkSession(input.get("_userId"))) {
            Map<String, Object> result = natTssCmplService.retrieveNatTssCmplMst(input);
            StringUtil.toUtf8Output((HashMap)result);

            Map<String, Object> resultSmryInfo = natTssCmplService.retrieveNatTssCmplSmryInfo(result);
            result.put("finYn", resultSmryInfo.get("finYn"));
            result.put("smryYn", resultSmryInfo.get("tssCd"));

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

        return "web/prj/tss/nat/cmpl/natTssCmplDetail";
    }



    /**
     * 과제관리 > 국책과제 > 완료 > 마스터 신규
     *
     * @param input HashMap<String, Object>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return ModelAndView
     * */
    @RequestMapping(value="/prj/tss/nat/insertNatTssCmplMst.do")
    public ModelAndView insertNatTssCmplMst(@RequestParam HashMap<String, Object> input, HttpServletRequest request,
            HttpSession session, ModelMap model) {

        LOGGER.debug("###########################################################");
        LOGGER.debug("insertNatTssCmplMst [과제관리 > 국책과제 > 완료 > 마스터 신규]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSessionObjRUI(input, session, model);

        ModelAndView modelAndView = new ModelAndView("ruiView");

        HashMap<String, Object> mstDs  = null;
        HashMap<String, Object> smryDs = null;
        
        try {
            mstDs  = (HashMap<String, Object>) RuiConverter.convertToDataSet(request, "mstDataSet").get(0);
            smryDs = (HashMap<String, Object>) RuiConverter.convertToDataSet(request, "smryDataSet").get(0);

            StringUtil.toUtf8Input(smryDs);
            
        	natTssCmplService.insertNatTssCmplMst(mstDs, smryDs);
       	 
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
     * 과제관리 > 국책과제 > 완료 > 마스터 수정
     *
     * @param input HashMap<String, Object>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return ModelAndView
     * */
    @RequestMapping(value="/prj/tss/nat/updateNatTssCmplMst.do")
    public ModelAndView updateNatTssCmplMst(@RequestParam HashMap<String, Object> input, HttpServletRequest request,
            HttpSession session, ModelMap model) {

        LOGGER.debug("###########################################################");
        LOGGER.debug("updateNatTssCmplMst [과제관리 > 국책과제 > 완료 > 마스터 수정]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSessionObjRUI(input, session, model);

        ModelAndView modelAndView = new ModelAndView("ruiView");

        HashMap<String, Object> mstDs  = new HashMap<String, Object>();
        HashMap<String, Object> smryDs = new HashMap<String, Object>();
        
        try {
            mstDs  = (HashMap<String, Object>) RuiConverter.convertToDataSet(request, "mstDataSet").get(0);
            smryDs = (HashMap<String, Object>) RuiConverter.convertToDataSet(request, "smryDataSet").get(0);

            StringUtil.toUtf8Input(smryDs);
            
        	natTssCmplService.updateNatTssCmplMst(mstDs, smryDs);

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
     * 과제관리 > 국책과제 > 완료 > 완료 iframe 조회
     *
     * @param input HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return String
     * @throws JSONException
     * */
    @RequestMapping(value="/prj/tss/nat/natTssCmplSmryIfm.do")
    public String natTssCmplSmryIfm(@RequestParam HashMap<String, String> input, HttpServletRequest request,
            HttpSession session, ModelMap model) throws JSONException {

        LOGGER.debug("###########################################################");
        LOGGER.debug("natTssCmplSmryIfm [과제관리 > 국책과제 > 완료 > iframe 조회]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSession(input, session, model);

        String rtnUrl ="";
        
        if(input.get("tssSt").equals("104") && input.get("pgsStepCd").equals("CM") ){
        	rtnUrl = "web/prj/tss/nat/cmpl/natTssCmplIfmView";
        }else{
        	rtnUrl = "web/prj/tss/nat/cmpl/natTssCmplIfm";
        }
        
        if(pageMoveChkSession(input.get("_userId"))) {
            Map<String, Object> result = natTssCmplService.retrieveNatTssCmplSmry(input);
            StringUtil.toUtf8Output((HashMap)result);

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
     * 과제관리 > 국책과제 > 완료 > 품의서요청 화면
     *
     * @param input HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return String
     * @throws JSONException
     * */
    @RequestMapping(value="/prj/tss/nat/natTssCmplCsusRq.do")
    public String natTssCmplCsusRq(@RequestParam HashMap<String, String> input, HttpServletRequest request,
            HttpSession session, ModelMap model) throws JSONException {

        LOGGER.debug("###########################################################");
        LOGGER.debug("NatTssController - natTssCmplGoalYldIfm [과제관리 > 국책과제 > 완료 > 품의서요청 화면 ]");
        LOGGER.debug("###########################################################");

        checkSession(input, session, model);
        String rtnMsg = "";
        
		//필수값 체크
		rtnMsg = natTssCmplService.retrieveNatTssCmplCheck(input);	
		
		if(!rtnMsg.equals("N")){
			input.put("rtnMsg", rtnMsg);
			
			return this.natTssCmplMst(input, request, session, model);
		}    

        if(pageMoveChkSession(input.get("_userId"))) {
            Map<String, Object> resultMst         = natTssCmplService.retrieveNatTssCmplMst(input);  //마스터
            Map<String, Object> resultSmry        = natTssCmplService.retrieveNatTssCmplSmry(input); //개요
            Map<String, Object> resultCsus        = genTssService.retrieveGenTssCsus(resultMst); //품의서

            HashMap<String, String> inputInfo = new HashMap<String, String>();
            inputInfo.put("tssCd",     String.valueOf(input.get("tssCd")));
            inputInfo.put("pgTssCd",   String.valueOf(resultMst.get("pgTssCd")));

            if( input.get("pageRqType").equals("stoa") ){
            	String resultStorAttchId = natTssCmplService.retrieveNatTssStoal(input); //정산 첨부파일
            	inputInfo.put("attcFilId", CommonUtil.isNullGetInput(resultStorAttchId, ""));	
            }else{
            	inputInfo.put("attcFilId", String.valueOf(resultSmry.get("cmplAttcFilId")));
            }
            
            inputInfo.put("pkWbsCd",   String.valueOf(resultMst.get("pkWbsCd")));

            Map<String, Object> resultInfo        = natTssCmplService.retrieveNatTssCmplInfo(inputInfo);
            List<Map<String, Object>> resultBudg  = natTssCmplService.retrieveNatTssCmplTrwiBudg(inputInfo); //사업비
            List<Map<String, Object>> resultAttc  = natTssCmplService.retrieveNatTssCmplAttc(inputInfo);//첨부파일

            StringUtil.toUtf8Output((HashMap)resultMst);
            StringUtil.toUtf8Output((HashMap)resultSmry);
            StringUtil.toUtf8Output((HashMap)resultCsus);
            StringUtil.toUtf8Output(inputInfo);

            model.addAttribute("inputData", input);
            model.addAttribute("resultMst", resultMst);
            model.addAttribute("resultSmry", resultSmry);
            model.addAttribute("resultBudg", resultBudg);
            model.addAttribute("resultInfo", resultInfo);
            model.addAttribute("resultAttc", resultAttc);
            model.addAttribute("resultCsus", resultCsus);

            //text컬럼을 위한 json변환
            JSONObject obj = new JSONObject();
            obj.put("jsonSmry", resultSmry);

            //정산
            if("stoa".equals(String.valueOf(input.get("pageRqType")))) {
                Map<String, Object> resultStoa  = natTssCmplService.retrieveNatTssCmplStoa(inputInfo);

                StringUtil.toUtf8Output((HashMap)resultStoa);

                model.addAttribute("resultStoa", resultStoa);
                obj.put("jsonStoa", resultStoa);
            }

            request.setAttribute("resultJson", obj);
        }
        return "web/prj/tss/nat/cmpl/natTssCmplCsusRq";
    }


    /**
     * 과제관리 > 국책과제 > 완료 > 품의서요청 생성
     *
     * @param input HashMap<String, Object>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return ModelAndView
     * */
    @RequestMapping(value="/prj/tss/nat/insertNatTssCmplCsusRq.do")
    public ModelAndView insertNatTssCmplCsusRq(@RequestParam HashMap<String, Object> input, HttpServletRequest request, HttpServletResponse response,
            HttpSession session, ModelMap model) {

        LOGGER.debug("###########################################################");
        LOGGER.debug("insertNatTssCmplCsusRq [과제관리 > 국책과제 > 완료 > 품의서요청 생성]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSessionObjRUI(input, session, model);

        ModelAndView modelAndView = new ModelAndView("ruiView");

        List<Map<String, Object>> ds = null;

        try {
            ds  = RuiConverter.convertToDataSet(request, "dataSet");
            natTssCmplService.insertNatTssCmplCsusRq(ds.get(0));

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
