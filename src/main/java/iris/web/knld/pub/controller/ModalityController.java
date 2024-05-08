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
import iris.web.knld.pub.service.ModalityService;
import iris.web.system.base.IrisBaseController;

/********************************************************************************
 * NAME : ModalityController.java
 * DESC : 표준양식 관리 controller
 * PROJ : IRIS UPGRADE 1차 프로젝트
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION
 * ----------  ------  ---------------------------------------------------------
 * 2017.09.13  			최초생성
 *********************************************************************************/

@Controller
public class ModalityController  extends IrisBaseController {

	@Resource(name="messageSourceAccessor")
	private MessageSourceAccessor messageSourceAccessor;

	@Resource(name = "codeCacheManager")
	private CodeCacheManager codeCacheManager;

	@Resource(name = "configService")
    private ConfigService configService;

	@Resource(name = "modalityService")
	private ModalityService modalityService;

	static final Logger LOGGER = LogManager.getLogger(ModalityController.class);

	/*리스트 화면 호출*/
	@RequestMapping(value="/knld/pub/retrieveModalityList.do")
	public String modalityList(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			) throws Exception{

		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);

		LOGGER.debug("###########################################################");
		LOGGER.debug("ModalityController - ModalityList [표준양식 리스트 호출]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		model.addAttribute("inputData", input);

		return "web/knld/pub/retrieveModalityList";
	}

	/*리스트*/
	@RequestMapping(value="/knld/pub/getModalityList.do")
	public ModelAndView getModalityList(
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
		LOGGER.debug("ModalityController - getModalityList [표준양식 리스트 검색]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		ModelAndView modelAndView = new ModelAndView("ruiView");

        // 표준양식 리스트 조회
		List<Map<String,Object>> modalityList = modalityService.getModalityList(input);

		modelAndView.addObject("modalityDataSet", RuiConverter.createDataset("modalityDataSet", modalityList));
		return modelAndView;
	}


	/*등록,수정 화면 호출*/
	@RequestMapping(value="/knld/pub/modalityRgst.do")
	public String modalityRgst(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			) throws Exception{

		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);

		LOGGER.debug("###########################################################");
		LOGGER.debug("ModalityController - ModalityRgst [표준양식 등록 화면 호출]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		model.addAttribute("inputData", input);

		return "web/knld/pub/modalityRgst";
	}

	/** 등록 **/
	@RequestMapping(value="/knld/pub/insertModalityInfo.do")
	public ModelAndView insertModalityInfo(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
		LOGGER.debug("###########################################################");
		LOGGER.debug("ModalityController - insertModalityInfo [표준양식 저장&업데이트]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		checkSessionRUI(input, session, model);
		ModelAndView modelAndView = new ModelAndView("ruiView");
		HashMap<String, Object> rtnMeaasge = new HashMap<String, Object>();

		// 결과메시지
		rtnMeaasge.put("rtnSt", "S");
		rtnMeaasge.put("rtnMsg", "저장 되었습니다.");
		rtnMeaasge.put("modalityId", "");

		int totCnt = 0;    							//전체건수
		List<Map<String, Object>> modalityRgstDataSetList;	// 변경데이터

		try{
			// 저장&수정
			String modalityId = "";
			modalityRgstDataSetList = RuiConverter.convertToDataSet(request,"modalityRgstDataSet");

			for(Map<String,Object> modalityRgstDataSetMap : modalityRgstDataSetList) {
				modalityRgstDataSetMap.put("_userId" , NullUtil.nvl(input.get("_userId"), ""));
				modalityService.insertModalityInfo(modalityRgstDataSetMap);
				totCnt++;
			}

			rtnMeaasge.put("modalityId", modalityId);

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

	@RequestMapping(value="/knld/pub/modalityInfo.do")
	public String modalityInfo(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			) throws Exception{

		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);

		LOGGER.debug("###########################################################");
		LOGGER.debug("ModalityController - modalityInfo [표준양식 상세 화면 호출]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		model.addAttribute("inputData", input);

		return "web/knld/pub/modalityInfo";
	}

	@RequestMapping(value="/knld/pub/getModalityInfo.do")
	public ModelAndView getModalityInfo(
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
		LOGGER.debug("ModalityController - getModalityInfo [표준양식 상세]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		ModelAndView modelAndView = new ModelAndView("ruiView");

		if(NullUtil.isNull(input.get("_userId")) ||  NullUtil.nvl(input.get("_userId"), "").equals("-1")  ){
			String rtnMsg = messageSourceAccessor.getMessage("msg.alert.sessionTimeout");
			SayMessage.setMessage(rtnMsg);
			modelAndView.addObject("modalityDataSet", null);
        } else {
        	// 표준양식 상세 조회
	        Map<String,Object> resultMap = modalityService.getModalityInfo(input);

	        modelAndView.addObject("modalityInfoDataSet", RuiConverter.createDataset("modalityInfoDataSet", resultMap));
        }
		return modelAndView;
	}

	/** 표준양식 삭제 **/
	@RequestMapping(value="/knld/pub/deleteModalityInfo.do")
	public ModelAndView deleteModalityInfo(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
		LOGGER.debug("#################################################################################################");
		LOGGER.debug("ModalityController - deleteModalityInfo [표준양식 삭제]");
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
			modalityService.deleteModalityInfo(input);

		} catch (Exception e) {
			e.printStackTrace();
			rtnMeaasge.put("rtnSt", "F");
			rtnMeaasge.put("rtnMsg", "삭제가 실패하였습니다.");
		}

		modelAndView.addObject("trResultDataSet", RuiConverter.createDataset("trResultDataSet", rtnMeaasge));
		return modelAndView;
	}

	/** 게시글 조회건수 증가 **/
	@RequestMapping(value="/knld/pub/updateModalityRtrvCnt.do")
	public ModelAndView updateModalityRtrvCnt(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
		LOGGER.debug("#################################################################################################");
		LOGGER.debug("ModalityController - updateModalityRtrvCnt [표준양식 조회건수증가]");
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
			modalityService.updateModalityRtrvCnt(input);

		} catch (Exception e) {
			e.printStackTrace();
			rtnMeaasge.put("rtnSt", "F");
			rtnMeaasge.put("rtnMsg", "조회건수 증가 실패하였습니다.");
		}

		modelAndView.addObject("trResultDataSet", RuiConverter.createDataset("trResultDataSet", rtnMeaasge));
		return modelAndView;
	}

	@RequestMapping(value="/knld/pub/modalityInfoSrchView.do")
	public String modamodalityInfoSrchViewlityInfo(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			) throws Exception{

		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);

		LOGGER.debug("###########################################################");
		LOGGER.debug("ModalityController - modalityInfoSrchView [표준양식 뷰 화면 호출]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		model.addAttribute("inputData", input);

		return "web/knld/pub/modalityInfoSrchView";
	}

}//class end
