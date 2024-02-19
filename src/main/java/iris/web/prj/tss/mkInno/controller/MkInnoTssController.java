package iris.web.prj.tss.mkInno.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
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
import iris.web.prj.tss.mkInno.service.MkInnoTssService;
import iris.web.system.base.IrisBaseController;

@Controller
public class MkInnoTssController  extends IrisBaseController {
	
	static final Logger LOGGER = LogManager.getLogger(MkInnoTssController.class);
	
	@Resource(name = "messageSourceAccessor")
	private MessageSourceAccessor messageSourceAccessor;
	
	@Resource(name = "tssUserService")
	private TssUserService tssUserService;
	
	@Resource(name = "mkInnoTssService")
	private MkInnoTssService mkInnoTssService;

	@Resource(name = "codeService")
    private CodeService codeService;
	
	/**
     * 과제관리 > 제조혁신과제 리스트 화면
     *
     * @param input HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return String
     * */
    @RequestMapping(value="/prj/tss/mkInno/mkInnoTssList.do")
    public String mkInnoTssList(@RequestParam HashMap<String, Object> input, HttpServletRequest request,
            HttpSession session, ModelMap model) {
    	
    	checkSessionObjRUI(input, session, model);
        LOGGER.debug("###########################################################");
        LOGGER.debug("MkInnoController - mkInnoTssList [과제관리 > 제조혁신과제 리스트 화면]");
        LOGGER.debug("###########################################################");

        input = StringUtil.toUtf8(input);
    	
        model.addAttribute("inputData", input);
    
    	return "web/prj/tss/mkInno/mkInnoTssList"; 
    }
    
    /**
     * 과제관리 > 제조혁신과제 리스트 조회
     *
     * @param input HashMap<String, Object>
     * @param request HttpServletRequest
     * @param response HttpServletResponse
     * @param session HttpSession
     * @param model ModelMap
     * @return ModelAndView
     * */
    @SuppressWarnings("unchecked")
    @RequestMapping(value="/prj/tss/mkInno/retrieveMkInnoTssList.do")
    public ModelAndView retrieveMkInnoTssList(@RequestParam HashMap<String, Object> input, HttpServletRequest request,
            HttpServletResponse response, HttpSession session, ModelMap model) {

    	checkSessionObjRUI(input, session, model);
    	
        LOGGER.debug("###########################################################");
        LOGGER.debug("retrievefGenTssList - retrieveMkInnoTssList [과제관리 > 제조혁신과제 리스트 조회]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        ModelAndView modelAndView = new ModelAndView("ruiView");

        input = StringUtil.toUtf8(input);

        Map<String, Object> role = tssUserService.getTssListRoleChk(input);
        input.put("tssRoleType", role.get("tssRoleType"));
        input.put("tssRoleCd",   role.get("tssRoleCd"));

        List<Map<String,Object>> list = mkInnoTssService.retrieveMkInnoTssList(input);

        modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", list));

        return modelAndView;
    }
    
    /**
     * 과제관리 > 제조혁신과제 계획상세 화면
     *
     * @param input HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return String
     * */
    @RequestMapping(value="/prj/tss/mkInno/mkInnoTssPlnDetail.do")
    public String mkInnoTssPlnDetail(@RequestParam HashMap<String, Object> input, HttpServletRequest request,
            HttpSession session, ModelMap model) {
    	
    	checkSessionObjRUI(input, session, model);
        LOGGER.debug("###########################################################");
        LOGGER.debug("MkInnoController - mkInnoTssPlnDetail [과제관리 > 제조혁신과제 계획상세 화면]");
        LOGGER.debug("###########################################################");

        input = StringUtil.toUtf8(input);
        model.addAttribute("inputData", input);
        
        List <Map<String, Object>> codeRtcRole  = codeService.retrieveCodeValueList("PTC_ROLE"); //참여역할
    	
        model.addAttribute("codeRtcRole", codeRtcRole);
        model.addAttribute("inputData", input);
        
        return "web/prj/tss/mkInno/pln/mkInnoTssPlnDetail"; 
    }
    
	/**
     * 과제관리 > 제조혁신과제 마스터, smry 저장
     *
     * @param input HashMap<String, Object>
     * @param request HttpServletRequest
     * @param response HttpServletResponse
     * @param session HttpSession
     * @param model ModelMap
     * @return ModelAndView
     * */
    @SuppressWarnings("unchecked")
    @RequestMapping(value="/prj/tss/mkInno/saveMkInnoMst.do")
    public ModelAndView saveMkInnoMst(@RequestParam HashMap<String, Object> input, HttpServletRequest request,
            HttpServletResponse response, HttpSession session, ModelMap model) {

    	checkSessionObjRUI(input, session, model);
        LOGGER.debug("###########################################################");
        LOGGER.debug("MkInnoTssController - saveMkInnoMst [과제관리 > 제조혁신과제 마스터, smry 저장]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");
        
        ModelAndView modelAndView = new ModelAndView("ruiView");
        
        Map<String,Object> resultMap = new HashMap<String, Object>();
        Map<String,Object> dataMap = new HashMap<String, Object>();
        
        input = StringUtil.toUtf8Input(input);
        resultMap.put("rtnSt", "F");
        
        try{
        	dataMap.put("input", input);
        	dataMap.put("mstDataSet", RuiConverter.convertToDataSet(request, "mstDataSet").get(0));
        	dataMap.put("smryDataSet", RuiConverter.convertToDataSet(request, "smryDataSet").get(0));

        	mkInnoTssService.saveMkInnoMst(dataMap);
        	
			resultMap.put("rtnSt", "S");
			resultMap.put("rtnMsg", "저장 되었습니다.");
        }catch(Exception e){
			resultMap.put("rtnMsg", "저장에 실패하였습니다\\n관리자에게 문의하세요.");
        }
        
        modelAndView.addObject("resultDataSet", RuiConverter.createDataset("resultDataSet", resultMap));

        return modelAndView;
    } 
    
    /**
     * 과제관리 > 제조혁신과제 참여연구원 저장
     *
     * @param input HashMap<String, Object>
     * @param request HttpServletRequest
     * @param response HttpServletResponse
     * @param session HttpSession
     * @param model ModelMap
     * @return ModelAndView
     * */
    @SuppressWarnings("unchecked")
    @RequestMapping(value=" /prj/tss/mkInno/saveMkInnoMbr.do")
    public ModelAndView saveMkInnoMbr(@RequestParam HashMap<String, Object> input, HttpServletRequest request,
            HttpServletResponse response, HttpSession session, ModelMap model) {

    	checkSessionObjRUI(input, session, model);
    	
        LOGGER.debug("###########################################################");
        LOGGER.debug("MkInnoTssController - saveMkInnoMbr [과제관리 > 제조혁신과제 참여연구원 저장]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        
        ModelAndView modelAndView = new ModelAndView("ruiView");
        
        Map<String,Object> resultMap = new HashMap<String, Object>();
        Map<String,Object> dataMap = new HashMap<String, Object>();
        
        input = StringUtil.toUtf8Input(input);
        resultMap.put("rtnSt", "N");
        
        try{
        	List<Map<String, Object>> mbrDataSetList = RuiConverter.convertToDataSet(request, "mbrDataSet");

        	mkInnoTssService.saveMkInnoMbr(mbrDataSetList);
        	
			resultMap.put("rtnSt", "S");
			resultMap.put("rtnMsg", "저장 되었습니다.");
        }catch(Exception e){
        	
			resultMap.put("rtnMsg", "저장에 실패하였습니다\\n관리자에게 문의하세요.");
        }

        modelAndView.addObject("resultDataSet", RuiConverter.createDataset("resultDataSet", resultMap));

        return modelAndView;
    } 
   
	/**
     * 과제관리 > 제조혁신과제 품의서 화면
     *
     * @param input HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return String
     * */
    @RequestMapping(value="/prj/tss/mkInno/retrieveMkInnoTssPlnCsusRq.do")
    public String retrieveMkInnoTssPlnCsusRq(@RequestParam HashMap<String, Object> input, HttpServletRequest request,
            HttpSession session, ModelMap model) {
    	
    	checkSessionObjRUI(input, session, model);
        LOGGER.debug("###########################################################");
        LOGGER.debug("MkInnoController - retrieveMkInnoTssPlnCsusRq [과제관리 > 제조혁신과제 품의서 화면]");
        LOGGER.debug("###########################################################");

        input = StringUtil.toUtf8(input);
        
        //mstDataSet 
        Map<String, Object> resultMst = mkInnoTssService.retrieveMkInnoMstInfo(input);
        //smryDataSet
        Map<String, Object> resultSmry = mkInnoTssService.retrieveMkInnoSmryInfo(input);
        //mbrDataSet
        List<Map<String,Object>> resultMbr = mkInnoTssService.retrieveMkInnoMbrList(input);
        //전자결재건 확인 
        Map<String, Object> resultCsus = mkInnoTssService.retrieveMkInnoCsusInfo(input);
        
        HashMap<String, Object> inputInfo = new HashMap<String, Object>();
        inputInfo.put("tssCd", input.get("tssCd"));
        inputInfo.put("pgsStepCd", resultMst.get("pgsStepCd"));
        inputInfo.put("attcFilId", resultSmry.get("attcFilId"));
        
        List<Map<String, Object>> resultAttc  = mkInnoTssService.retrieveMkInnoTssAttc(inputInfo);
    	
        model.addAttribute("resultMst", StringUtil.toUtf8Output((HashMap)resultMst));
        model.addAttribute("resultSmry", StringUtil.toUtf8Output((HashMap)resultSmry));
        model.addAttribute("resultMbr", resultMbr);
        model.addAttribute("resultCsus", StringUtil.toUtf8Output((HashMap)resultCsus));
        model.addAttribute("resultAttc", resultAttc);
        model.addAttribute("inputData", input);
        
    	return "web/prj/tss/mkInno/pln/mkInnoTssPlnCsusRq"; 
    }
    
    /**
     * 과제관리 > 제조혁신과제 진행상세 화면
     *
     * @param input HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return String
     * */
    @RequestMapping(value="/prj/tss/mkInno/mkInnoTssPgsDetail.do")
    public String mkInnoTssPgsDetail(@RequestParam HashMap<String, Object> input, HttpServletRequest request,
            HttpSession session, ModelMap model) {
    	
    	checkSessionObjRUI(input, session, model);
        LOGGER.debug("###########################################################");
        LOGGER.debug("MkInnoController - mkInnoTssPgsDetail [과제관리 > 제조혁신과제 진행상세 화면]");
        LOGGER.debug("###########################################################");

        input = StringUtil.toUtf8Input(input);
    	
        Map<String, Object> role = tssUserService.getTssListRoleChk(input);
        input.put("tssRoleType", role.get("tssRoleType"));
        input.put("tssRoleId",   role.get("tssRoleId"));

        model.addAttribute("inputData", input);
        
    	return "web/prj/tss/mkInno/pgs/mkInnoTssPgsDetail"; 
    }

    /**
     * 과제관리 > 제조혁신과제 완료상세 화면
     *
     * @param input HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return String
     * */
    @RequestMapping(value="/prj/tss/mkInno/mkInnoTssCmplDetail.do")
    public String mkInnoTssCmplDetail(@RequestParam HashMap<String, Object> input, HttpServletRequest request,
            HttpSession session, ModelMap model) {
    	
    	checkSessionObjRUI(input, session, model);
        LOGGER.debug("###########################################################");
        LOGGER.debug("MkInnoController - mkInnoTssPgsDetail [과제관리 > 제조혁신과제 완료상세 화면]");
        LOGGER.debug("###########################################################");

        input = StringUtil.toUtf8Input(input);
    	
        model.addAttribute("inputData", input);
    
    	return "web/prj/tss/mkInno/cmpl/mkInnoTssCmplDetail"; 
    }
    
    /**
     * 과제관리 > 제조혁신과제 상세화면 조회
     *
     * @param input HashMap<String, Object>
     * @param request HttpServletRequest
     * @param response HttpServletResponse
     * @param session HttpSession
     * @param model ModelMap
     * @return ModelAndView
     * */
    @SuppressWarnings("unchecked")
    @RequestMapping(value="/prj/tss/mkInno/retrieveMkInnoTssDetail.do")
    public ModelAndView retrieveMkInnoTssDetail(@RequestParam HashMap<String, Object> input, HttpServletRequest request,
            HttpServletResponse response, HttpSession session, ModelMap model) {

    	checkSessionObjRUI(input, session, model);
    	
        LOGGER.debug("###########################################################");
        LOGGER.debug("retrievefGenTssList - retrieveMkInnoTssDetail [과제관리 > 제조혁신과제 상세화면 조회]");
        LOGGER.debug("###########################################################");

        ModelAndView modelAndView = new ModelAndView("ruiView");

        input = StringUtil.toUtf8Input(input);

        //mstDataSet 
        Map<String, Object> mstInfo = mkInnoTssService.retrieveMkInnoMstInfo(input);
        //smryDataSet
        Map<String, Object> smryInfo = mkInnoTssService.retrieveMkInnoSmryInfo(input);
        //mbrDataSet
        List<Map<String,Object>> mbrlist = mkInnoTssService.retrieveMkInnoMbrList(input);
        
        modelAndView.addObject("mstDataSet", RuiConverter.createDataset("mstDataSet", mstInfo));
        modelAndView.addObject("smryDataSet", RuiConverter.createDataset("smryDataSet", smryInfo));
        modelAndView.addObject("mbrDataSet", RuiConverter.createDataset("mbrDataSet", mbrlist));

        return modelAndView;
    }
    
	/**
     * 과제관리 > 제조혁신과제 결재 정보 등록
     *
     * @param input HashMap<String, Object>
     * @param request HttpServletRequest
     * @param response HttpServletResponse
     * @param session HttpSession
     * @param model ModelMap
     * @return ModelAndView
     * */
    @SuppressWarnings("unchecked")
    @RequestMapping(value="/prj/tss/mkInno/insertMkInnoTssCsusRq.do")
    public ModelAndView insertMkInnoTssCsusRq(@RequestParam HashMap<String, Object> input, HttpServletRequest request,
            HttpServletResponse response, HttpSession session, ModelMap model) {

    	checkSessionObjRUI(input, session, model);
    	
        LOGGER.debug("###########################################################");
        LOGGER.debug("retrievefGenTssList - insertMkInnoTssCsusRq [과제관리 > 제조혁신과제 결재 정보 등록]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        input = StringUtil.toUtf8Input(input);
        
        ModelAndView modelAndView = new ModelAndView("ruiView");

        Map<String, Object> ds = null;

        try {
            ds = RuiConverter.convertToDataSet(request, "dataSet").get(0);
            mkInnoTssService.insertMkInnoTssCsusRq(ds);

            ds.put("rtCd", "SUCCESS");
            ds.put("rtVal",messageSourceAccessor.getMessage("msg.alert.saved")); //저장되었습니다.
        } catch(Exception e) {
            e.printStackTrace();
            ds.put("rtCd", "FAIL");
            ds.put("rtVal", messageSourceAccessor.getMessage("msg.alert.error")); //오류가 발생하였습니다.
        }

        modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", ds));


        return modelAndView;
    }
    
    /**
     * 과제관리 > 제조혁신과제 품의서 결재 정보 업데이트
     *
     * @param input HashMap<String, Object>
     * @param request HttpServletRequest
     * @param response HttpServletResponse
     * @param session HttpSession
     * @param model ModelMap
     * @return ModelAndView
     * */
    @SuppressWarnings("unchecked")
    @RequestMapping(value="/prj/tss/mkInno/updateMkInnoTssCsusRq.do")
    public ModelAndView updateMkInnoTssCsusRq(@RequestParam HashMap<String, Object> input, HttpServletRequest request,
            HttpServletResponse response, HttpSession session, ModelMap model) {

    	checkSessionObjRUI(input, session, model);
    	
        LOGGER.debug("###########################################################");
        LOGGER.debug("retrievefGenTssList - updateMkInnoTssCsusRq [과제관리 > 제조혁신과제 품의서 결재 정보 업데이트]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        ModelAndView modelAndView = new ModelAndView("ruiView");

        Map<String, Object> ds = null;

        try {
            ds = RuiConverter.convertToDataSet(request, "dataSet").get(0);
            
            mkInnoTssService.updateMkInnoTssCsusRq(ds);

            ds.put("rtCd", "SUCCESS");
            ds.put("rtVal",messageSourceAccessor.getMessage("msg.alert.saved")); //저장되었습니다.
        } catch(Exception e) {
            e.printStackTrace();
            ds.put("rtCd", "FAIL");
            ds.put("rtVal", messageSourceAccessor.getMessage("msg.alert.error")); //오류가 발생하였습니다.
        }

        modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", ds));

        return modelAndView;
    }
    
	/**
     * 과제관리 > 제조혁신과제 등록
     *
     * @param input HashMap<String, Object>
     * @param request HttpServletRequest
     * @param response HttpServletResponse
     * @param session HttpSession
     * @param model ModelMap
     * @return ModelAndView
     * */
    @SuppressWarnings("unchecked")
    @RequestMapping(value="/prj/tss/mkInno/saveMkInnoTssReg.do")
    public ModelAndView saveMkInnoTssReg(@RequestParam HashMap<String, Object> input, HttpServletRequest request,
            HttpServletResponse response, HttpSession session, ModelMap model) {

    	checkSessionObjRUI(input, session, model);
    	
        LOGGER.debug("###########################################################");
        LOGGER.debug("retrievefGenTssList - saveMkInnoTssReg [과제관리 > 제조혁신과제 등록]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        ModelAndView modelAndView = new ModelAndView("ruiView");
        HashMap<String, Object> rtnMeaasge = new HashMap<String, Object>();
        Map<String, Object> ds = null;

        String rtnMsg = "";
		String rtnSt = "F";
		String guid ="";
        
        try {
            ds = RuiConverter.convertToDataSet(request, "dataSet").get(0);
            ds.put("userId", input.get("_userId"));
            
            mkInnoTssService.saveMkInnoTssReg(ds);

            rtnSt = "S";
			rtnMsg = "등록되었습니다.";
        } catch(Exception e) {
        	e.printStackTrace();
			rtnMsg = e.getMessage();
        }
        
        rtnMeaasge.put("rtnMsg", rtnMsg);
		rtnMeaasge.put("rtnSt", rtnSt);
		
		modelAndView.addObject("resultDataSet", RuiConverter.createDataset("resultDataSet", rtnMeaasge));
        modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", ds));

        return modelAndView;
    }

    	
    /**
     * 과제관리 > 제조혁신과제 등록 화면
     *
     * @param input HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return String
     * */
    @RequestMapping(value="/prj/tss/mkInno/mkInnoTssRegPop.do")
    public String mkInnoTssRegPop(@RequestParam HashMap<String, Object> input, HttpServletRequest request,
            HttpSession session, ModelMap model) {
    	
    	checkSessionObjRUI(input, session, model);
        LOGGER.debug("###########################################################");
        LOGGER.debug("MkInnoController - mkInnoTssRegPop [과제관리 > 제조혁신과제 등록 화면]");
        LOGGER.debug("###########################################################");

        input = StringUtil.toUtf8Input(input);
    	
        model.addAttribute("inputData", input);
    
    	return "web/prj/tss/mkInno/mkInnoTssRegPop"; 
    }
    
    	/**
         * 과제관리 > 제조혁신과제 완료보고서 등록
         *
         * @param input HashMap<String, Object>
         * @param request HttpServletRequest
         * @param response HttpServletResponse
         * @param session HttpSession
         * @param model ModelMap
         * @return ModelAndView
         * */
        @SuppressWarnings("unchecked")
        @RequestMapping(value="/prj/tss/mkInno/saveMkInnoTssCmpl.do")
        public ModelAndView saveMkInnoTssCmpl(@RequestParam HashMap<String, Object> input, HttpServletRequest request,
                HttpServletResponse response, HttpSession session, ModelMap model) {

        	checkSessionObjRUI(input, session, model);
        	
            LOGGER.debug("###########################################################");
            LOGGER.debug("retrievefGenTssList - saveMkInnoTssCmpl [과제관리 > 제조혁신진행 -> 완료]");
            LOGGER.debug("input = > " + input);
            LOGGER.debug("###########################################################");
            input = StringUtil.toUtf8Input(input);
            
            ModelAndView modelAndView = new ModelAndView("ruiView");
            HashMap<String, Object> rtnMeaasge = new HashMap<String, Object>();
            Map<String, Object> ds = null;

            String rtnMsg = "";
    		String rtnSt = "F";
            String cmplTssCd = "";
            
            try {
            	
            	input.put("userId", input.get("_userId"));
            	cmplTssCd = mkInnoTssService.saveMkInnoTssCmpl(input);

                rtnSt = "S";
    			rtnMsg = "저장되었습니다.";
            } catch(Exception e) {
            	e.printStackTrace();
    			rtnMsg = e.getMessage();
            }
            
            rtnMeaasge.put("rtnMsg", rtnMsg);
    		rtnMeaasge.put("rtnSt", rtnSt);
    		rtnMeaasge.put("cmplTssCd", cmplTssCd);
    		
    		modelAndView.addObject("resultDataSet", RuiConverter.createDataset("resultDataSet", rtnMeaasge));
            modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", ds));

            return modelAndView;
        }
    
    /**
     * 과제관리 > 제조혁신과제 완료보고서 등록
     *
     * @param input HashMap<String, Object>
     * @param request HttpServletRequest
     * @param response HttpServletResponse
     * @param session HttpSession
     * @param model ModelMap
     * @return ModelAndView
     * */
    @SuppressWarnings("unchecked")
    @RequestMapping(value="/prj/tss/mkInno/updateCmplAttcFilId.do")
    public ModelAndView updateCmplAttcFilId(@RequestParam HashMap<String, Object> input, HttpServletRequest request,
            HttpServletResponse response, HttpSession session, ModelMap model) {

    	checkSessionObjRUI(input, session, model);
    	
        LOGGER.debug("###########################################################");
        LOGGER.debug("retrievefGenTssList - updateCmplAttcFilId [과제관리 > 제조혁신과제 등록]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        input = StringUtil.toUtf8Input(input);
        ModelAndView modelAndView = new ModelAndView("ruiView");
        HashMap<String, Object> rtnMeaasge = new HashMap<String, Object>();
        Map<String, Object> ds = null;

        String rtnMsg = "";
		String rtnSt = "F";
		String guid ="";
        
        try {
            ds = RuiConverter.convertToDataSet(request, "smryDataSet").get(0);
            ds.put("userId", input.get("_userId"));
            
            mkInnoTssService.updateCmplAttcFilId(ds);

            rtnSt = "S";
			rtnMsg = "저장되었습니다.";
        } catch(Exception e) {
        	e.printStackTrace();
			rtnMsg = e.getMessage();
        }
        
        rtnMeaasge.put("rtnMsg", rtnMsg);
		rtnMeaasge.put("rtnSt", rtnSt);
		
		modelAndView.addObject("resultDataSet", RuiConverter.createDataset("resultDataSet", rtnMeaasge));
        modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", ds));

        return modelAndView;
    }
    
    /**
     * 과제관리 > 제조혁신과제 완료보고서 등록
     *
     * @param input HashMap<String, Object>
     * @param request HttpServletRequest
     * @param response HttpServletResponse
     * @param session HttpSession
     * @param model ModelMap
     * @return ModelAndView
     * */
    @SuppressWarnings("unchecked")
    @RequestMapping(value="/prj/tss/mkInno/deleteMkInnoTssPtcRsstMbr.do")
    public ModelAndView deleteMkInnoTssPlnPtcRsstMbr(@RequestParam HashMap<String, Object> input, HttpServletRequest request,
            HttpServletResponse response, HttpSession session, ModelMap model) {

    	checkSessionObjRUI(input, session, model);
    	
        LOGGER.debug("###########################################################");
        LOGGER.debug("retrievefGenTssList - deleteMkInnoTssPtcRsstMbr [과제관리 > 제조혁신과제 연구원삭제]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        input = StringUtil.toUtf8Input(input);
        ModelAndView modelAndView = new ModelAndView("ruiView");
        HashMap<String, Object> rtnMeaasge = new HashMap<String, Object>();
        Map<String, Object> ds = null;
        
        String rtnMsg = "";
		String rtnSt = "F";
        
        try {
            
        	ds = RuiConverter.convertToDataSet(request, "mbrDataSet").get(0);
            ds.put("userId", input.get("_userId"));
            
        	mkInnoTssService.deleteMkInnoTssPlnPtcRsstMbr(ds);

            rtnSt = "S";
			rtnMsg = "삭제되었습니다.";
        } catch(Exception e) {
        	e.printStackTrace();
			rtnMsg = e.getMessage();
        }
        
        rtnMeaasge.put("rtnMsg", rtnMsg);
		rtnMeaasge.put("rtnSt", rtnSt);
		
		modelAndView.addObject("resultDataSet", RuiConverter.createDataset("resultDataSet", rtnMeaasge));

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
