package iris.web.knld.pub.controller;

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
import devonframe.message.saymessage.SayMessage;
import devonframe.util.NullUtil;
import iris.web.common.code.service.CodeCacheManager;
import iris.web.common.converter.RuiConverter;
import iris.web.common.util.StringUtil;
import iris.web.knld.pub.service.OutsideSpecialistService;
import iris.web.system.base.IrisBaseController;

/********************************************************************************
 * NAME : OutsideSpecialistController.java
 * DESC : 사외전문가 관리 controller
 * PROJ : IRIS UPGRADE 1차 프로젝트
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION
 * ----------  ------  ---------------------------------------------------------
 * 2017.09.14  			최초생성
 *********************************************************************************/

@Controller
public class OutsideSpecialistController  extends IrisBaseController {

	@Resource(name="messageSourceAccessor")
	private MessageSourceAccessor messageSourceAccessor;

	@Resource(name = "codeCacheManager")
	private CodeCacheManager codeCacheManager;

	@Resource(name = "configService")
    private ConfigService configService;

	@Resource(name = "outsideSpecialistService")
	private OutsideSpecialistService outsideSpecialistService;

	static final Logger LOGGER = LogManager.getLogger(OutsideSpecialistController.class);

	/*리스트 화면 호출*/
	@RequestMapping(value="/knld/pub/retrieveOutsideSpeciaList.do")
	public String OutsideSpecialistList(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			) throws Exception{

		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);

		LOGGER.debug("###########################################################");
		LOGGER.debug("OutsideSpecialistController - OutsideSpecialistList [사외전문가 리스트 호출]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		model.addAttribute("inputData", input);

		return "web/knld/pub/retrieveOutsideSpeciaList";
	}

	/*리스트*/
	@RequestMapping(value="/knld/pub/getOutsideSpeciaList.do")
	public ModelAndView getOutsideSpecialistList(
			@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpServletResponse response,
			HttpSession session,
			ModelMap model
			){

		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		input = StringUtil.toUtf8(input);

		LOGGER.debug("###########################################################");
		LOGGER.debug("OutsideSpecialistController - getOutsideSpecialistList [사외전문가 리스트 검색]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		ModelAndView modelAndView = new ModelAndView("ruiView");

        // 사외전문가 리스트 조회
		List<Map<String,Object>> outsideSpecialistList = outsideSpecialistService.getOutsideSpecialistList(input);

		modelAndView.addObject("outsideSpecialistDataSet", RuiConverter.createDataset("outsideSpecialistDataSet", outsideSpecialistList));
		return modelAndView;
	}


	/*등록,수정 화면 호출*/
	@RequestMapping(value="/knld/pub/outsideSpecialistRgst.do")
	public String outsideSpecialistRgst(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			) throws Exception{

		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);

		LOGGER.debug("###########################################################");
		LOGGER.debug("OutsideSpecialistController - OutsideSpecialistRgst [사외전문가 등록 화면 호출]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		model.addAttribute("inputData", input);

		return "web/knld/pub/outsideSpecialistRgst";
	}

	/** 등록 **/
	@RequestMapping(value="/knld/pub/insertOutsideSpecialistInfo.do")
	public ModelAndView insertOutsideSpecialistInfo(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
		LOGGER.debug("###########################################################");
		LOGGER.debug("OutsideSpecialistController - insertOutsideSpecialistInfo [사외전문가 저장&업데이트]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		checkSessionRUI(input, session, model);
		ModelAndView modelAndView = new ModelAndView("ruiView");
		HashMap<String, Object> rtnMeaasge = new HashMap<String, Object>();

		// 결과메시지
		rtnMeaasge.put("rtnSt", "S");
		rtnMeaasge.put("rtnMsg", "저장 되었습니다.");
		rtnMeaasge.put("outSpclId", "");

		int totCnt = 0;    							//전체건수
		List<Map<String, Object>> outsideSpecialistRgstDataSetList;	// 변경데이터

		try{
			// 저장&수정
			String outSpclId = "";
			outsideSpecialistRgstDataSetList = RuiConverter.convertToDataSet(request,"outSpclRgstDataSet");

			for(Map<String,Object> outsideSpecialistRgstDataSetMap : outsideSpecialistRgstDataSetList) {
				outsideSpecialistRgstDataSetMap.put("_userId" , NullUtil.nvl(input.get("_userId"), ""));
				outsideSpecialistService.insertOutsideSpecialistInfo(outsideSpecialistRgstDataSetMap);
				totCnt++;
			}

			rtnMeaasge.put("outSpclId", outSpclId);

			if(totCnt == 0 ) {
				rtnMeaasge.put("rtnSt", "F");
				rtnMeaasge.put("rtnMsg", "변경된 내용이 없습니다.");
			}
		} catch (Exception e) {
			e.printStackTrace();
			rtnMeaasge.put("rtnSt", "F");
			rtnMeaasge.put("rtnMsg", "저장이 실패하였습니다.");
		}

		model.addAttribute("inputData", input);
		modelAndView.addObject("resultDataSet", RuiConverter.createDataset("resultDataSet", rtnMeaasge));
		return modelAndView;
	}

	@RequestMapping(value="/knld/pub/outsideSpecialistInfo.do")
	public String outsideSpecialistInfo(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			) throws Exception{

		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);

		LOGGER.debug("###########################################################");
		LOGGER.debug("OutsideSpecialistController - outsideSpecialistInfo [사외전문가 상세 화면 호출]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		model.addAttribute("inputData", input);

		return "web/knld/pub/outsideSpecialistInfo";
	}

	@RequestMapping(value="/knld/pub/getOutsideSpecialistInfo.do")
	public ModelAndView getOutsideSpecialistInfo(
			@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpServletResponse response,
			HttpSession session,
			ModelMap model
			){

		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		input = StringUtil.toUtf8(input);

		LOGGER.debug("###########################################################");
		LOGGER.debug("OutsideSpecialistController - getOutsideSpecialistInfo [사외전문가 상세]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		ModelAndView modelAndView = new ModelAndView("ruiView");

		if(NullUtil.isNull(input.get("_userId")) ||  NullUtil.nvl(input.get("_userId"), "").equals("-1")  ){
			String rtnMsg = messageSourceAccessor.getMessage("msg.alert.sessionTimeout");
			SayMessage.setMessage(rtnMsg);
			modelAndView.addObject("outsideSpecialistDataSet", null);
        } else {
        	// 사외전문가 상세 조회
	        Map<String,Object> resultMap = outsideSpecialistService.getOutsideSpecialistInfo(input);

	        modelAndView.addObject("outsideSpecialistInfoDataSet", RuiConverter.createDataset("outsideSpecialistInfoDataSet", resultMap));
        }
		return modelAndView;
	}

	/** 사외전문가 삭제 **/
	@RequestMapping(value="/knld/pub/deleteOutsideSpecialistInfo.do")
	public ModelAndView deleteOutsideSpecialistInfo(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
		LOGGER.debug("#################################################################################################");
		LOGGER.debug("OutsideSpecialistController - deleteOutsideSpecialistInfo [사외전문가 삭제]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("#################################################################################################");

		checkSessionRUI(input, session, model);
		ModelAndView modelAndView = new ModelAndView("ruiView");
		HashMap<String, Object> rtnMeaasge = new HashMap<String, Object>();

		// 결과메시지
		rtnMeaasge.put("rtnSt", "S");
		rtnMeaasge.put("rtnMsg", "삭제 되었습니다.");

		int totCnt = 0;    							//전체건수
		try
		{
			outsideSpecialistService.deleteOutsideSpecialistInfo(input);

		} catch (Exception e) {
			e.printStackTrace();
			rtnMeaasge.put("rtnSt", "F");
			rtnMeaasge.put("rtnMsg", "삭제가 실패하였습니다.");
		}

		modelAndView.addObject("trResultDataSet", RuiConverter.createDataset("trResultDataSet", rtnMeaasge));
		return modelAndView;
	}

	/*
	/** 게시글 조회건수 증가 *
	@RequestMapping(value="/knld/pub/updateOutsideSpecialistRtrvCnt.do")
	public ModelAndView updateOutsideSpecialistRtrvCnt(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
		LOGGER.debug("#################################################################################################");
		LOGGER.debug("OutsideSpecialistController - updateOutsideSpecialistRtrvCnt [사외전문가 조회건수증가]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("#################################################################################################");

		checkSessionRUI(input, session, model);
		ModelAndView modelAndView = new ModelAndView("ruiView");
		HashMap<String, Object> rtnMeaasge = new HashMap<String, Object>();

		// 결과메시지
		rtnMeaasge.put("rtnSt", "S");
		rtnMeaasge.put("rtnMsg", "");

		try
		{
			outsideSpecialistService.updateOutsideSpecialistRtrvCnt(input);

		} catch (Exception e) {
			e.printStackTrace();
			rtnMeaasge.put("rtnSt", "F");
			rtnMeaasge.put("rtnMsg", "조회건수 증가 실패하였습니다.");
		}

		modelAndView.addObject("trResultDataSet", RuiConverter.createDataset("trResultDataSet", rtnMeaasge));
		return modelAndView;
	}
	*/

	/* 사외전문가 팝업 화면 이동 */
	@RequestMapping(value="/knld/pub/outsideSpecialistPopup.do")
	public String outsideSpecialistPopup(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			) throws Exception{

		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);

		LOGGER.debug("####################################################################################");
		LOGGER.debug("OutsideSpecialistController - outsideSpecialistPopup [사외전문가 팝업 화면 이동]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("####################################################################################");

		model.addAttribute("inputData", input);

		return "web/knld/pub/outsideSpecialistPopup";
	}

	@RequestMapping(value="/knld/pub/outsideSpecialistInfoSrchView.do")
	public String outsideSpecialistInfoSrchView(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			) throws Exception{

		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);

		LOGGER.debug("###########################################################");
		LOGGER.debug("OutsideSpecialistController - outsideSpecialistInfoSrchView [사외전문가 뷰 화면 호출]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		model.addAttribute("inputData", input);

		return "web/knld/pub/outsideSpecialistInfoSrchView";
	}

}//class end
