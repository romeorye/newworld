package iris.web.prj.tss.rfp.controller;

import java.io.File;
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

import devonframe.configuration.ConfigService;
import iris.web.common.code.service.CodeCacheManager;
import iris.web.common.converter.RuiConverter;
import iris.web.common.util.CommonUtil;
import iris.web.common.util.NamoMime;
import iris.web.common.util.StringUtil;
import iris.web.prj.tss.ousdcoo.controller.OusdCooTssAltrController;
import iris.web.prj.tss.rfp.service.RfpInfoService;
import iris.web.system.base.IrisBaseController;

@Controller
public class RfpInfoController  extends IrisBaseController {

	@Resource(name="messageSourceAccessor")
    private MessageSourceAccessor messageSourceAccessor;
	
	@Resource(name="rfpInfoService")
    private RfpInfoService rfpInfoService;
	
	@Resource(name = "configService")
    private ConfigService configService;
	
	@Resource(name = "codeCacheManager")
	private CodeCacheManager codeCacheManager;
	
	static final Logger LOGGER = LogManager.getLogger(OusdCooTssAltrController.class);
	
	
	/**
     * 연구과제 > RFP요청서 > 요청서 목록 화면으로 이동
     * */
	@RequestMapping(value="/prj/tss/rfp/retrieveRfp.do")
	public String retrieveOpnInno(
			@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
			
		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		LOGGER.debug("########################################################################################");
		LOGGER.debug("RfpInfoController - retrieveRfp [RFP 요청서 리스트로  화면이동]");
		LOGGER.debug("########################################################################################");	
		
		model.addAttribute("inputData", input);
	
		return "web/prj/tss/rfp/rfpList";
	}
	
	/**
     * 연구과제 > RFP요청서 > 요청서 목록 조회
     * */
	@RequestMapping(value="/prj/tss/rfp/retrieveRfpSearchList.do")
	public ModelAndView retrieveRfpSearchList(
			@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpServletResponse response,
			HttpSession session,
			ModelMap model
			){

		/*반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		ModelAndView modelAndView = new ModelAndView("ruiView");
		
		input = StringUtil.toUtf8(input);
		
		LOGGER.debug("##############################################################################################");
		LOGGER.debug("RfpInfoController - retrieveRfpSearchList [RFP 요청서 목록 조회");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("##############################################################################################");

		List<Map<String,Object>> list = rfpInfoService.retrieveRfpSearchList(input);
        
		modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", list));

		return modelAndView;
	}
	
	/**
     * 연구과제 > RFP요청서 > 요청서 등록  및 수정
     * */
	@RequestMapping(value="/prj/tss/rfp/rfpReg.do")
	public String rfpReg( @RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
			
		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		LOGGER.debug("########################################################################################");
		LOGGER.debug("RfpInfoController - retrieveRfp [RFP 요청서 등록 및 수정 화면이동]");
		LOGGER.debug("########################################################################################");	
		
		List<Map<String,Object>> comList = codeCacheManager.retrieveCodeValueListForCache("RFP_TCLG"); // Collaboration Type
		
		model.addAttribute("comList", comList);
		model.addAttribute("inputData", input);
	
		return "web/prj/tss/rfp/rfpReg";
	}
	
	
	/**
     * 연구과제 > RFP요청서 > 요청서 조회
     * */
	@RequestMapping(value="/prj/tss/rfp/retrieveRfpInfo.do")
	public ModelAndView retrieveRfpInfo(
			@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpServletResponse response,
			HttpSession session,
			ModelMap model
			){

		/*반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		ModelAndView modelAndView = new ModelAndView("ruiView");
		
		input = StringUtil.toUtf8(input);
		
		LOGGER.debug("##############################################################################################");
		LOGGER.debug("RfpInfoController - retrieveRfpInfo [RFP 요청서 조회");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("##############################################################################################");

		Map<String,Object> map = rfpInfoService.retrieveRfpInfo(input);
        
		modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", map));

		return modelAndView;
	}
	
	/**
     * 연구과제 > RFP요청서 > 요청서 등록 및 수정
     * */
	@RequestMapping(value="/prj/tss/rfp/saveRfpInfo.do")
	public ModelAndView saveRfpInfo(
			@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpServletResponse response,
			HttpSession session,
			ModelMap model
			){

		/*반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		ModelAndView modelAndView = new ModelAndView("ruiView");
		
		LOGGER.debug("##############################################################################################");
		LOGGER.debug("RfpInfoController - saveRfpInfo [RFP 요청서 등록 및 수정");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("##############################################################################################");
		
		HashMap<String, Object> rtnMeaasge = new HashMap<String, Object>();
		NamoMime mime = new NamoMime();
		
		String pjtImgViewHtml = "";
		String pjtImgViewHtml_temp = "";
		
		String rtnSt ="F";
		String rtnMsg = "";
		
		try{
			Map<String, Object> saveDataSet = RuiConverter.convertToDataSet(request, "dataSet").get(0);
			saveDataSet.put("_userId", input.get("_userId"));
			saveDataSet.put("_userSabun", input.get("_userSabun"));
			
			String uploadPath = "";
            String uploadUrl = "";

            uploadUrl =  configService.getString("KeyStore.UPLOAD_URL") + configService.getString("KeyStore.UPLOAD_PRJ");   // 파일명에 세팅되는 경로
            uploadPath = configService.getString("KeyStore.UPLOAD_BASE") + configService.getString("KeyStore.UPLOAD_PRJ");  // 파일이 실제로 업로드 되는 경로

            mime.setSaveURL(uploadUrl);
            mime.setSavePath(uploadPath);
            mime.decode(saveDataSet.get("pjtImgView").toString());                  // MIME 디코딩
            mime.saveFileAtPath(uploadPath+File.separator);

            pjtImgViewHtml = mime.getBodyContent();
            pjtImgViewHtml_temp = CommonUtil.replaceSecOutput(CommonUtil.replace(CommonUtil.replace(pjtImgViewHtml, "<", "@![!@"),">","@!]!@"));

            StringUtil.toUtf8Input((HashMap) saveDataSet);
            saveDataSet.put("pjtImgView", pjtImgViewHtml);
            
			rfpInfoService.saveRfpInfo(saveDataSet);
			
			rtnMsg = "저장되었습니다.";
			rtnSt = "S";
		}catch(Exception e){
			e.printStackTrace();
			rtnMsg = "저장 중 오류가 발생하였습니다.";
		}
		rtnMeaasge.put("rtnMsg", rtnMsg);
		rtnMeaasge.put("rtnSt", rtnSt);
		
		modelAndView.addObject("resultDataSet", RuiConverter.createDataset("resultDataSet", rtnMeaasge));

		return modelAndView;
	}
	
	
	/**
     * 연구과제 > RFP요청서 > 요청서삭제
     * */
	@RequestMapping(value="/prj/tss/rfp/deleteRfpInfo.do")
	public ModelAndView deleteRfpInfo(
			@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpServletResponse response,
			HttpSession session,
			ModelMap model
			){

		/*반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		ModelAndView modelAndView = new ModelAndView("ruiView");
		
		input = StringUtil.toUtf8(input);
		
		LOGGER.debug("##############################################################################################");
		LOGGER.debug("RfpInfoController - deleteRfpInfo [RFP 요청서삭제");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("##############################################################################################");
		
		HashMap<String, Object> rtnMeaasge = new HashMap<String, Object>();
		
		String rtnSt ="F";
		String rtnMsg = "";
		
		try{
			
			rfpInfoService.deleteRfpInfo(input);
			
			rtnMsg = "삭제되었습니다.";
			rtnSt = "S";
		}catch(Exception e){
			e.printStackTrace();
			rtnMsg = "삭제 중 오류가 발생하였습니다.";
		}
		rtnMeaasge.put("rtnMsg", rtnMsg);
		rtnMeaasge.put("rtnSt", rtnSt);
		
		modelAndView.addObject("resultDataSet", RuiConverter.createDataset("resultDataSet", rtnMeaasge));

		return modelAndView;
	}
	
	/**
     * 연구과제 > RFP요청서 > 요청서 제출
     * */
	@RequestMapping(value="/prj/tss/rfp/submitRfpInfo.do")
	public ModelAndView submitRfpInfo(
			@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpServletResponse response,
			HttpSession session,
			ModelMap model
			){

		/*반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		ModelAndView modelAndView = new ModelAndView("ruiView");
		
		input = StringUtil.toUtf8(input);
		
		LOGGER.debug("##############################################################################################");
		LOGGER.debug("RfpInfoController - submitRfpInfo [RFP 요청서 제출하기");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("##############################################################################################");
		
		HashMap<String, Object> rtnMeaasge = new HashMap<String, Object>();
		
		String rtnSt ="F";
		String rtnMsg = "";
		
		try{
			
			rfpInfoService.submitRfpInfo(input);
			
			rtnMsg = "요청서가 제출되었습니다.";
			rtnSt = "S";
		}catch(Exception e){
			e.printStackTrace();
			rtnMsg = "제출 중 오류가 발생하였습니다.";
		}
		rtnMeaasge.put("rtnMsg", rtnMsg);
		rtnMeaasge.put("rtnSt", rtnSt);
		
		modelAndView.addObject("resultDataSet", RuiConverter.createDataset("resultDataSet", rtnMeaasge));

		return modelAndView;
	}
	
	
	
	/**
	 *  RFP 요청서 리스트  팝업창 이동
	 */
	@RequestMapping(value="/prj/tss/rfp/openRfpList.do")
	public String openRfpList(
			@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
			
		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		LOGGER.debug("########################################################################################");
		LOGGER.debug("OpnInnovationController - openRfpList [RFP 요청서 리스트  팝업창 이동");
		LOGGER.debug("########################################################################################");	
		
		model.addAttribute("inputData", input);
	
		return "web/prj/tss/rfp/rfpListPop";
	}
	
	
	/**
	 *  RFP 요청서 리스트 View
	 */
	@RequestMapping(value="/prj/tss/rfp/openRfpDetailViewPop.do")
	public String openRfpDetailViewPop(
			@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
			
		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		LOGGER.debug("########################################################################################");
		LOGGER.debug("OpnInnovationController - openRfpDetailViewPop [RFP 요청서 리스트 View");
		LOGGER.debug("########################################################################################");	
		
		Map<String,Object> map = rfpInfoService.retrieveRfpInfo(input);
		
		model.addAttribute("inputData", input);
		model.addAttribute("result", map);
	
		return "web/prj/tss/rfp/rfpDetailViewPop";
	}	
	
}
