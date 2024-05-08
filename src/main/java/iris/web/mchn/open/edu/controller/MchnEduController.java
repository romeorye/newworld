package iris.web.mchn.open.edu.controller;

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

import devonframe.message.saymessage.SayMessage;
import devonframe.util.NullUtil;
import iris.web.common.converter.RuiConverter;
import iris.web.common.util.DateUtil;
import iris.web.common.util.StringUtil;
import iris.web.mchn.mgmt.controller.AnlMchnController;
import iris.web.mchn.open.edu.service.MchnEduService;
import iris.web.system.attach.service.AttachFileService;
import iris.web.system.base.IrisBaseController;

@Controller
public class MchnEduController extends IrisBaseController {

	@Resource(name="mchnEduService")
	private MchnEduService mchnEduService;

	@Resource(name="attachFileService")
	private AttachFileService attachFileService;

	@Resource(name="messageSourceAccessor")
	private MessageSourceAccessor messageSourceAccessor;

	static final Logger LOGGER = LogManager.getLogger(AnlMchnController.class);


	/**
	 *  open기기 > 기기교육 > 기기교육목록 화면
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/mchn/open/edu/retrieveEduList.do")
	public String retrieveEduList(@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			) throws Exception{

		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		input = StringUtil.toUtf8(input);

		String today = DateUtil.getDateString();

		if(input.get("frEduDt") == null) {
			input.put("frEduDt", today);
			input.put("toEduDt", DateUtil.addMonths(today, 1, "yyyy-MM-dd"));
		}

		model.addAttribute("inputData", input);

		return  "web/mchn/open/edu/mchnEduList";
	}

	/**
	 *  open기기 > 기기교육 > 기기교육목록조회
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/mchn/open/edu/retrieveMchnEduSearchList.do")
	public ModelAndView retrieveMchnEduSearchList(@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		ModelAndView modelAndView = new ModelAndView("ruiView");
		input = StringUtil.toUtf8(input);

		if(NullUtil.isNull(input.get("_userId")) ||  NullUtil.nvl(input.get("_userId"), "").equals("-1")  ){
			String rtnMsg = messageSourceAccessor.getMessage("msg.alert.sessionTimeout");
			SayMessage.setMessage(rtnMsg);
			modelAndView.addObject("dataset", null);
        } else {
        	List<Map<String, Object>> resultList = mchnEduService.retrieveMchnEduSearchList(input);
        	LOGGER.debug("#############################1#########################resultList############################### : "+ resultList);
			modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", resultList));
        }

		return  modelAndView;
	}

	/**
	 *  open기기 > 기기교육 > 기기교육상세화면
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/mchn/open/edu/retrieveEduInfo.do")
	public String retrieveEduInfo(@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){

		HashMap lsession = (HashMap)session.getAttribute("irisSession");
		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);

		Map<String, Object> result = mchnEduService.retrieveEduInfo(input);

		String attcFilId = "";
		//LOGGER.debug("###########################result####################################################### : "+ result);
		attcFilId =  NullUtil.nvl(result.get("attcFilId").toString(), "");

		input.put("attcFilId", attcFilId);
		List<Map<String,Object>> attachFileList = attachFileService.getAttachFileList(input);

		model.addAttribute("attachFileList", attachFileList);
		model.addAttribute("inputData", input);
		model.addAttribute("result", result);

		return  "web/mchn/open/edu/mchnEduDtl";
	}

	/**
	 *  open기기 > 기기교육 > 기기교육신청 등록
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/mchn/open/edu/insertEduInfoDetail.do")
	public ModelAndView insertEduInfoDetail(@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){

		HashMap lsession = (HashMap)session.getAttribute("irisSession");
		ModelAndView modelAndView = new ModelAndView("ruiView");

		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		HashMap<String, Object> rtnMeaasge = new HashMap<String, Object>();
		String rtnSt ="F";
		String rtnMsg = "";

		try{
			int chkCnt = mchnEduService.retrieveEduInfoCnt(input);

			if(chkCnt > 0 ){
				rtnMsg = "이미 신청한 사용자입니다.";
			}else{
				mchnEduService.insertEduInfoDetail(input);

				rtnMsg = "신청되었습니다.";
				rtnSt= "S";
			}
		}catch(Exception e){
			e.printStackTrace();
			rtnMsg ="처리중 오류가발생했습니다. 관리자에게 문의해주십시오.";
		}

		rtnMeaasge.put("rtnMsg", rtnMsg);
		rtnMeaasge.put("rtnSt", rtnSt);
		modelAndView.addObject("resultDataSet", RuiConverter.createDataset("resultDataSet", rtnMeaasge));

		return  modelAndView;
	}

	/**
	 *  open기기 > 기기교육 > 기기교육신청 취소
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/mchn/open/edu/updateEduCancel.do")
	public ModelAndView updateEduCancel(@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){

		HashMap lsession = (HashMap)session.getAttribute("irisSession");
		ModelAndView modelAndView = new ModelAndView("ruiView");

		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		HashMap<String, Object> rtnMeaasge = new HashMap<String, Object>();
		String rtnSt ="F";
		String rtnMsg = "";

		try{
			int chkCnt = mchnEduService.retrieveEduInfoCnt(input);

			if(chkCnt > 0 ){
				mchnEduService.updateEduCancel(input);

				rtnMsg = "교육신청이 취소되었습니다.";
				rtnSt= "S";
			}else{
				rtnMsg = "교육신청건이 없습니다.";
			}
		}catch(Exception e){
			e.printStackTrace();
			rtnMsg ="처리중 오류가발생했습니다. 관리자에게 문의해주십시오.";
		}

		rtnMeaasge.put("rtnMsg", rtnMsg);
		rtnMeaasge.put("rtnSt", rtnSt);
		modelAndView.addObject("resultDataSet", RuiConverter.createDataset("resultDataSet", rtnMeaasge));

		return  modelAndView;
	}


		/**
		 *  open기기 > 기기교육 > 기기교육상세(통합검색용)
		 * @param input
		 * @param request
		 * @param session
		 * @param model
		 * @return
		 */
		@RequestMapping(value="/mchn/open/edu/retrieveEduInfoSrchView.do")
		public String retrieveEduInfoSrchView(@RequestParam HashMap<String, Object> input,
				HttpServletRequest request,
				HttpSession session,
				ModelMap model
				){

			/* 반드시 공통 호출 후 작업 */
			checkSessionObjRUI(input, session, model);
			HashMap lsession = (HashMap)session.getAttribute("irisSession");

			String attcFilId = "";
			//LOGGER.debug("###########################result####################################################### : "+ result);
			Map<String, Object> result = mchnEduService.retrieveEduInfo(input);
			attcFilId =  NullUtil.nvl(result.get("attcFilId").toString(), "");

			input.put("attcFilId", attcFilId);
			List<Map<String,Object>> attachFileList = attachFileService.getAttachFileList(input);

			model.addAttribute("attachFileList", attachFileList);
			model.addAttribute("result", result);
			model.addAttribute("inputData", result);

			return  "web/mchn/open/edu/mchnEduView";
		}

}
