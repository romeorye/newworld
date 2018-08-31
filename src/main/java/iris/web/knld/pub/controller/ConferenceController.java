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
import iris.web.knld.pub.service.ConferenceService;
import iris.web.system.base.IrisBaseController;

/********************************************************************************
 * NAME : ConferenceController.java
 * DESC : 학회컨퍼런스 공지사항 관리 controller
 * PROJ : IRIS UPGRADE 1차 프로젝트
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION
 * ----------  ------  ---------------------------------------------------------
 * 2017.09.12  			최초생성
 *********************************************************************************/

@Controller
public class ConferenceController  extends IrisBaseController {

	@Resource(name="messageSourceAccessor")
	private MessageSourceAccessor messageSourceAccessor;

	@Resource(name = "codeCacheManager")
	private CodeCacheManager codeCacheManager;

	@Resource(name = "configService")
    private ConfigService configService;

	@Resource(name = "conferenceService")
	private ConferenceService conferenceService;

	static final Logger LOGGER = LogManager.getLogger(ConferenceController.class);

	/*리스트 화면 호출*/
	@RequestMapping(value="/knld/pub/retrieveConferenceList.do")
	public String conferenceList(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			) throws Exception{

		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);

		LOGGER.debug("###########################################################");
		LOGGER.debug("ConferenceController - ConferenceList [학회컨퍼런스 리스트 호출]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		model.addAttribute("inputData", input);

		return "web/knld/pub/retrieveConferenceList";
	}

	/*리스트*/
	@RequestMapping(value="/knld/pub/getConferenceList.do")
	public ModelAndView getConferenceList(
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
		LOGGER.debug("ConferenceController - getConferenceList [학회컨퍼런스 리스트 검색]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		ModelAndView modelAndView = new ModelAndView("ruiView");

        // 학회컨퍼런스 리스트 조회
		List<Map<String,Object>> conferenceList = conferenceService.getConferenceList(input);

		modelAndView.addObject("conferenceDataSet", RuiConverter.createDataset("conferenceDataSet", conferenceList));
		return modelAndView;
	}


	/*등록,수정 화면 호출*/
	@RequestMapping(value="/knld/pub/conferenceRgst.do")
	public String conferenceRgst(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			) throws Exception{

		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);

		LOGGER.debug("###########################################################");
		LOGGER.debug("ConferenceController - ConferenceRgst [학회컨퍼런스 등록 화면 호출]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		model.addAttribute("inputData", input);

		return "web/knld/pub/conferenceRgst";
	}

	/** 등록 **/
	@RequestMapping(value="/knld/pub/insertConferenceInfo.do")
	public ModelAndView insertConferenceInfo(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
		LOGGER.debug("###########################################################");
		LOGGER.debug("ConferenceController - insertConferenceInfo [학회컨퍼런스 저장&업데이트]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		checkSessionRUI(input, session, model);
		ModelAndView modelAndView = new ModelAndView("ruiView");
		HashMap<String, Object> rtnMeaasge = new HashMap<String, Object>();

		// 결과메시지
		rtnMeaasge.put("rtnSt", "S");
		rtnMeaasge.put("rtnMsg", "저장 되었습니다.");
		rtnMeaasge.put("conferenceId", "");

		int totCnt = 0;    							//전체건수
		List<Map<String, Object>> conferenceRgstDataSetList;	//학회컨퍼런스 변경데이터

		try{
			//학회컨퍼런스 저장&수정
			String conferenceId = "";
			conferenceRgstDataSetList = RuiConverter.convertToDataSet(request,"conferenceRgstDataSet");

			for(Map<String,Object> conferenceRgstDataSetMap : conferenceRgstDataSetList) {

				conferenceRgstDataSetMap.put("_userId" , NullUtil.nvl(input.get("_userId"), ""));

				conferenceService.insertConferenceInfo(conferenceRgstDataSetMap);
				totCnt++;
			}

			rtnMeaasge.put("conferenceId", conferenceId);

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

	@RequestMapping(value="/knld/pub/conferenceInfo.do")
	public String conferenceInfo(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			) throws Exception{

		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);

		LOGGER.debug("###########################################################");
		LOGGER.debug("ConferenceController - conferenceInfo [학회컨퍼런스 상세 화면 호출]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		model.addAttribute("inputData", input);

		return "web/knld/pub/conferenceInfo";
	}

	@RequestMapping(value="/knld/pub/getConferenceInfo.do")
	public ModelAndView getConferenceInfo(
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
		LOGGER.debug("ConferenceController - getConferenceInfo [학회컨퍼런스 상세]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		ModelAndView modelAndView = new ModelAndView("ruiView");

		if(NullUtil.isNull(input.get("_userId")) ||  NullUtil.nvl(input.get("_userId"), "").equals("-1")  ){
			String rtnMsg = messageSourceAccessor.getMessage("msg.alert.sessionTimeout");
			SayMessage.setMessage(rtnMsg);
			modelAndView.addObject("conferenceDataSet", null);
        } else {
        	// 학회컨퍼런스 상세 조회
	        Map<String,Object> resultMap = conferenceService.getConferenceInfo(input);
	        modelAndView.addObject("conferenceInfoDataSet", RuiConverter.createDataset("conferenceInfoDataSet", resultMap));
        }
		return modelAndView;
	}

	/** 게시글 삭제 **/
	@RequestMapping(value="/knld/pub/deleteConferenceInfo.do")
	public ModelAndView deleteConferenceInfo(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
		LOGGER.debug("#################################################################################################");
		LOGGER.debug("ConferenceController - deleteConferenceInfo [학회컨퍼런스 삭제]");
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
			conferenceService.deleteConferenceInfo(input);

		} catch (Exception e) {
			e.printStackTrace();
			rtnMeaasge.put("rtnSt", "F");
			rtnMeaasge.put("rtnMsg", "삭제가 실패하였습니다.");
		}

		modelAndView.addObject("trResultDataSet", RuiConverter.createDataset("trResultDataSet", rtnMeaasge));
		return modelAndView;
	}

	/** 게시글 조회건수 증가 **/
	@RequestMapping(value="/knld/pub/updateConferenceRtrvCnt.do")
	public ModelAndView updateConferenceRtrvCnt(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
		LOGGER.debug("#################################################################################################");
		LOGGER.debug("ConferenceController - updateConferenceRtrvCnt [학회컨퍼런스 조회건수증가]");
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
			conferenceService.updateConferenceRtrvCnt(input);

		} catch (Exception e) {
			e.printStackTrace();
			rtnMeaasge.put("rtnSt", "F");
			rtnMeaasge.put("rtnMsg", "조회건수 증가 실패하였습니다.");
		}

		modelAndView.addObject("trResultDataSet", RuiConverter.createDataset("trResultDataSet", rtnMeaasge));
		return modelAndView;
	}


	@RequestMapping(value="/knld/pub/conferenceInfoSrchView.do")
	public String conferenceInfoSrchView(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			) throws Exception{

		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);

		LOGGER.debug("###########################################################");
		LOGGER.debug("ConferenceController - conferenceInfoSrchView [학회컨퍼런스 뷰 화면 호출]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		model.addAttribute("inputData", input);

		return "web/knld/pub/conferenceInfoSrchView";
	}


}//class end
