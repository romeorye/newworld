package iris.web.fxa.oscp.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import iris.web.common.converter.RuiConverter;
import iris.web.common.itgRdcs.service.ItgRdcsService;
import iris.web.common.util.StringUtil;
import iris.web.fxa.oscp.service.FxaOscpService;
import iris.web.system.base.IrisBaseController;

@Controller
public class FxaOscpController extends IrisBaseController {

	@Resource(name="fxaOscpService")
	private FxaOscpService fxaOscpService;
	
	@Resource(name = "itgRdcsService")
	private ItgRdcsService itgRdcsService;
	
	
	static final Logger LOGGER = LogManager.getLogger(FxaOscpController.class);
	
	
		/**
		 * 사외자산이관 목록 화면
		 * @param input
		 * @param request
		 * @param session
		 * @param model
		 * @return
		 */
		@RequestMapping(value="/fxa/oscp/retrieveFxaOscpList.do")
		public String retrieveFxaOscpList(@RequestParam HashMap<String, Object> input,
				HttpServletRequest request,
				HttpSession session,
				ModelMap model
				){

			/* 반드시 공통 호출 후 작업 */
			checkSessionObjRUI(input, session, model);
			input = StringUtil.toUtf8(input);

			model.addAttribute("inputData", input);

			return  "web/fxa/oscp/fxaInfoOscpList";
		}
		
		/**
		 *  자산이관 목록 조회
		 * @param input
		 * @param request
		 * @param session
		 * @param model
		 * @return
		 */
		@RequestMapping(value="/fxa/oscp/retrieveFxaOscpSearchList.do")
		public ModelAndView retrieveFxaOscpSearchList(@RequestParam HashMap<String, Object> input,
				HttpServletRequest request,
				HttpSession session,
				ModelMap model
				){

			/* 반드시 공통 호출 후 작업 */
			checkSessionObjRUI(input, session, model);
			ModelAndView modelAndView = new ModelAndView("ruiView");
			
			input = StringUtil.toUtf8(input);

	       	List<Map<String, Object>> resultList = fxaOscpService.retrieveFxaOscpSearchList(input);
			
	       	modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", resultList));
			
			return  modelAndView;
		}
		
		/**
		 * 자산관리 > 사외자산이관 정보 저장
		 * @param input
		 * @param request
		 * @param session
		 * @param model
		 * @return
		 */
		@RequestMapping(value="/fxa/oscp/insertFxaOscpInfo.do")
		public ModelAndView insertFxaOscpInfo(@RequestParam HashMap<String, Object> input,
				HttpServletRequest request,
				HttpSession session,
				ModelMap model
				){

			/* 반드시 공통 호출 후 작업 */
			checkSessionObjRUI(input, session, model);
			ModelAndView modelAndView = new ModelAndView("ruiView");
			HashMap<String, Object> rtnMeaasge = new HashMap<String, Object>();
			
			LOGGER.debug("###########################################################");
			LOGGER.debug("FxaOscpService - insertFxaOscpInfo [자산관리 > 사외자산이관 정보 저장]");
			LOGGER.debug("input = > " + input);
			LOGGER.debug("###########################################################");

			
			List<Map<String, Object>> oscpList;	// 변경데이터
			String rtnMsg = "";
			String rtnSt = "F";
			String guid ="";
			
			try{
				//이관데이터 저장
				oscpList = RuiConverter.convertToDataSet(request, "dataSet");
				
				guid = fxaOscpService.insertFxaOscpInfo(oscpList, input);

				rtnSt = "S";
				rtnMsg = "신청되었습니다.";
			}catch(Exception e){
				e.printStackTrace();
				rtnMsg = e.getMessage();
			}

			rtnMeaasge.put("rtnMsg", rtnMsg);
			rtnMeaasge.put("rtnSt", rtnSt);
			rtnMeaasge.put("guid", guid);
			modelAndView.addObject("resultDataSet", RuiConverter.createDataset("resultDataSet", rtnMeaasge));

			return  modelAndView;
		}
		
		
		/**
		 *  사외자산이관 팝업목록 조회
		 * @param input
		 * @param request
		 * @param session
		 * @param model
		 * @return
		 */
		@RequestMapping(value="/fxa/oscp/retrieveFxaOscpPopList.do")
		public ModelAndView retrieveFxaOscpPopList(@RequestParam HashMap<String, Object> input,
				HttpServletRequest request,
				HttpSession session,
				ModelMap model
				){

			/* 반드시 공통 호출 후 작업 */
			checkSessionObjRUI(input, session, model);
			ModelAndView modelAndView = new ModelAndView("ruiView");
			input = StringUtil.toUtf8Input(input);

			List<Map<String, Object>> resultList = fxaOscpService.retrieveFxaOscpPopList(input);
			
			modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", resultList));
			
			return  modelAndView;
		}
		
		/**
		 * 사외자산관리 이관 팝업 화면
		 * @param input
		 * @param request
		 * @param session
		 * @param model
		 * @return
		 */
		@RequestMapping(value="/fxa/anl/retrieveFxaOscpPop.do")
		public String retrieveFxaOscpPop(@RequestParam HashMap<String, Object> input,
				HttpServletRequest request,
				HttpSession session,
				ModelMap model
				){

			/* 반드시 공통 호출 후 작업 */
			checkSessionObjRUI(input, session, model);
			
			input = StringUtil.toUtf8(input);
			model.addAttribute("inputData", input);

			return  "web/fxa/anl/fxaOscpPop";
		}
}
