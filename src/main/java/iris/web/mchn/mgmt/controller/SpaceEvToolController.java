package iris.web.mchn.mgmt.controller;

import java.io.File;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
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
import devonframe.message.saymessage.SayMessage;
import devonframe.util.NullUtil;
import iris.web.common.converter.RuiConverter;
import iris.web.common.util.CommonUtil;
import iris.web.common.util.NamoMime;
import iris.web.common.util.StringUtil;
import iris.web.mchn.mgmt.service.SpaceEvToolService;
import iris.web.system.base.IrisBaseController;


@Controller
public class SpaceEvToolController extends IrisBaseController {

	@Resource(name="messageSourceAccessor")
	private MessageSourceAccessor messageSourceAccessor;

	@Resource(name = "spaceEvToolService")
	private SpaceEvToolService spaceEvToolService;

	@Resource(name = "configService")
    private ConfigService configService;

	static final Logger LOGGER = LogManager.getLogger(SpaceEvToolController.class);


	/**
	 *  관리 > 공간평가Tool 화면 이동
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	//@RequestMapping(value="/mchn/mgmt/retrieveMachineList.do")
	@RequestMapping(value="/mchn/mgmt/retrieveSpaceEvToolList.do")
	public String retrieveSpaceEvaluationToolList(@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){

		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		input = StringUtil.toUtf8(input);
        model.addAttribute("inputData", input);
        
		return  "web/mchn/mgmt/spaceEvToolList";
	}

	/**
	 *  관리 > 공간평가tool 조회
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/mchn/mgmt/retrieveSpaceEvToolSearchList.do")
	public ModelAndView retrieveSpaceEvaluationToolSearchList(@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		ModelAndView modelAndView = new ModelAndView("ruiView");
		input = StringUtil.toUtf8(input);

        List<Map<String, Object>> resultList = spaceEvToolService.retrieveSpaceEvToolSearchList(input);
		modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", resultList));

		return  modelAndView;
	}
	
	/**
	 *  공간평가tool 등록 화면
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/mchn/mgmt/retrieveSpaceEvToolReg.do")
	public String retrieveSpaceEvToolReg(@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){

		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		input = StringUtil.toUtf8(input);
		
        model.addAttribute("inputData", input);

		return  "web/mchn/mgmt/spaceEvToolReg";
	}
	
	/**
	 *  공간평가 Tool 상세 조회
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/mchn/mgmt/retrieveSpaceEvToolSearchDtl.do")
	public ModelAndView retrieveSpaceEvToolSearchDtl(@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);

		ModelAndView modelAndView = new ModelAndView("ruiView");
		if(NullUtil.isNull(input.get("_userId")) ||  NullUtil.nvl(input.get("_userId"), "").equals("-1")  ){
			String rtnMsg = messageSourceAccessor.getMessage("msg.alert.sessionTimeout");
			SayMessage.setMessage(rtnMsg);
			modelAndView.addObject("dataset", null);
        } else {
        	HashMap<String, Object> result = spaceEvToolService.retrieveSpaceEvToolSearchDtl(input);
			modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", result));
        }

		return  modelAndView;
	}
	
		/**
		 *  공간평가 Tool 등록
		 * @param input
		 * @param request
		 * @param session
		 * @param model
		 * @return
		 */
		@RequestMapping(value="/mchn/mgmt/saveSpaceEvToolInfo.do")
		public ModelAndView saveSpaceEvToolInfo(@RequestParam HashMap<String, Object> input,
				HttpServletRequest request,
				HttpSession session,
				ModelMap model
				){
			/* 반드시 공통 호출 후 작업 */
			checkSessionObjRUI(input, session, model);
			ModelAndView modelAndView = new ModelAndView("ruiView");
			HashMap<String, Object> rtnMeaasge = new HashMap<String, Object>();
			
			String rtnSt ="F";
			String rtnMsg = "";

			NamoMime mime = new NamoMime();

			String mchnSmry = "";
			String mchnSmryHtml = "";

			try{

        		String uploadPath = "";
                String uploadUrl = "";

                uploadUrl =  configService.getString("KeyStore.UPLOAD_URL") + configService.getString("KeyStore.UPLOAD_MCHN");   // 파일명에 세팅되는 경로
                uploadPath = configService.getString("KeyStore.UPLOAD_BASE") + configService.getString("KeyStore.UPLOAD_MCHN");  // 파일이 실제로 업로드 되는 경로

                mime.setSaveURL(uploadUrl);
                mime.setSavePath(uploadPath);
                mime.decode(input.get("mchnSmry").toString());                  // MIME 디코딩
                mime.saveFileAtPath(uploadPath+File.separator);

                mchnSmry = mime.getBodyContent();
                mchnSmryHtml = CommonUtil.replaceSecOutput(CommonUtil.replace(CommonUtil.replace(mchnSmry, "<", "@![!@"),">","@!]!@"));

    			input.put("mchnSmry", mchnSmry);

    			spaceEvToolService.saveSpaceEvToolInfo(input);
            	
                rtnMsg = "저장되었습니다.";
            	rtnSt= "S";

	    	}catch(Exception e){
				e.printStackTrace();
				if("".equals(rtnMsg)){
					rtnMsg = "처리중 오류가발생했습니다. 관리자에게 문의해주십시오.";
				}
	    	}

	       	rtnMeaasge.put("rtnMsg", rtnMsg);
			rtnMeaasge.put("rtnSt", rtnSt);
			modelAndView.addObject("resultDataSet", RuiConverter.createDataset("resultDataSet", rtnMeaasge));
			modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", input));

			return  modelAndView;
		}
		
}
