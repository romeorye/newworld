package iris.web.knld.qna.controller;

import java.io.File;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.logging.log4j.LogManager; import org.apache.logging.log4j.Logger;
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
import iris.web.common.util.CommonUtil;
import iris.web.common.util.DateUtil;
import iris.web.common.util.NamoMime;
import iris.web.common.util.StringUtil;
import iris.web.knld.qna.service.GeneralQnaService;
import iris.web.system.base.IrisBaseController;

/********************************************************************************
 * NAME : GeneralQnaController.java
 * DESC : 일반QnA 관리 controller
 * PROJ : IRIS UPGRADE 1차 프로젝트
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION
 * ----------  ------  ---------------------------------------------------------
 * 2017.09.18  			최초생성
 *********************************************************************************/

@Controller
public class GeneralQnaController  extends IrisBaseController {

	@Resource(name="messageSourceAccessor")
	private MessageSourceAccessor messageSourceAccessor;

	@Resource(name = "codeCacheManager")
	private CodeCacheManager codeCacheManager;

	@Resource(name = "configService")
    private ConfigService configService;

	@Resource(name = "generalQnaService")
	private GeneralQnaService generalQnaService;

	static final Logger LOGGER = LogManager.getLogger(GeneralQnaController.class);

	/*리스트 화면 호출*/
	@RequestMapping(value="/knld/qna/retrieveGeneralQnaList.do")
	public String generalQnaList(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			) throws Exception{

		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);

		LOGGER.debug("###########################################################");
		LOGGER.debug("generalQnaController - generalQnaList [일반QnA 리스트 호출]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		model.addAttribute("inputData", input);

		return "web/knld/qna/retrieveGeneralQnaList";
	}

	/*리스트*/
	@RequestMapping(value="/knld/qna/getGeneralQnaList.do")
	public ModelAndView getGeneralQnaList(
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
		LOGGER.debug("GeneralQnaController - getGeneralQnaList [일반QnA 리스트 검색]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		ModelAndView modelAndView = new ModelAndView("ruiView");

        // 일반QnA 리스트 조회
		List<Map<String,Object>> generalQnaList = generalQnaService.getGeneralQnaList(input);

		modelAndView.addObject("generalQnaDataSet", RuiConverter.createDataset("generalQnaDataSet", generalQnaList));
		return modelAndView;
	}


	/*등록,수정 화면 호출*/
	@RequestMapping(value="/knld/qna/generalQnaRgst.do")
	public String generalQnaRgst(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			) throws Exception{

		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);

		LOGGER.debug("###########################################################");
		LOGGER.debug("generalQnaController - generalQnaRgst [일반QnA 등록 화면 호출]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		model.addAttribute("inputData", input);

		return "web/knld/qna/generalQnaRgst";
	}


	/** 등록 **/
	@RequestMapping(value="/knld/qna/insertGeneralQnaInfo.do")
	public ModelAndView insertGeneralQnaInfo(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
		LOGGER.debug("###########################################################");
		LOGGER.debug("QnaController - insertGeneralQnaInfo [일반QnA 저장&업데이트]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		checkSessionRUI(input, session, model);
		ModelAndView modelAndView = new ModelAndView("ruiView");
		HashMap<String, Object> rtnMeaasge = new HashMap<String, Object>();
		NamoMime mime = new NamoMime();

		String pqnaSbcHtml = "";
		String pqnaSbcHtml_temp = "";

		// 결과메시지
		rtnMeaasge.put("rtnSt", "S");
		rtnMeaasge.put("rtnMsg", "저장 되었습니다.");
		rtnMeaasge.put("qnaId", "");

		int totCnt = 0;    							//전체건수
		List<Map<String, Object>> qnaRgstDataSetList;	//일반QnA 변경데이터

		try{
			qnaRgstDataSetList = RuiConverter.convertToDataSet(request,"qnaRgstDataSet");

			String uploadUrl = "";
			String uploadPath = "";

            uploadUrl =  configService.getString("KeyStore.UPLOAD_URL") + configService.getString("KeyStore.UPLOAD_KNLD");   // 파일명에 세팅되는 경로
            uploadPath = configService.getString("KeyStore.UPLOAD_BASE") + configService.getString("KeyStore.UPLOAD_KNLD");  // 파일이 실제로 업로드 되는 경로

            mime.setSaveURL(uploadUrl);
            mime.setSavePath(uploadPath);
            mime.decode(input.get("sbcNm").toString());                  // MIME 디코딩
            mime.saveFileAtPath(uploadPath+File.separator);

            pqnaSbcHtml = mime.getBodyContent();
            pqnaSbcHtml_temp = CommonUtil.replaceSecOutput(CommonUtil.replace(CommonUtil.replace(pqnaSbcHtml, "<", "@![!@"),">","@!]!@"));


			//일반QnA 저장&수정
			String qnaId = "";
			qnaRgstDataSetList = RuiConverter.convertToDataSet(request,"qnaRgstDataSet");

			for(Map<String,Object> qnaRgstDataSetMap : qnaRgstDataSetList) {

				qnaRgstDataSetMap.put("_userId" , NullUtil.nvl(input.get("_userId"), ""));
				qnaRgstDataSetMap.put("sbcNm" , NullUtil.nvl(pqnaSbcHtml, ""));

				generalQnaService.insertGeneralQnaInfo(qnaRgstDataSetMap);
				totCnt++;
			}

			rtnMeaasge.put("qnaId", qnaId);

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

	@RequestMapping(value="/knld/qna/generalQnaInfo.do")
	public String generalQnadInfo(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			) throws Exception{

		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);

		LOGGER.debug("###########################################################");
		LOGGER.debug("generalQnaController - generalQnaInfo [일반QnA 상세 화면 호출]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		model.addAttribute("inputData", input);

		return "web/knld/qna/generalQnaInfo";
	}

	@RequestMapping(value="/knld/qna/getGeneralQnaInfo.do")
	public ModelAndView getGeneralQnaInfo(
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
		LOGGER.debug("generalQnaController - getGeneralQnaInfo [일반QnA 상세]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		ModelAndView modelAndView = new ModelAndView("ruiView");

		if(NullUtil.isNull(input.get("_userId")) ||  NullUtil.nvl(input.get("_userId"), "").equals("-1")  ){
			String rtnMsg = messageSourceAccessor.getMessage("msg.alert.sessionTimeout");
			SayMessage.setMessage(rtnMsg);
			modelAndView.addObject("generalQnaDataSet", null);
        } else {
        	// 일반QnA 상세 조회
	        Map<String,Object> resultMap = generalQnaService.getGeneralQnaInfo(input);
	        modelAndView.addObject("generalQnaInfoDataSet", RuiConverter.createDataset("generalQnaInfoDataSet", resultMap));
        }
		return modelAndView;
	}

	/** 게시글 삭제 **/
	@RequestMapping(value="/knld/qna/deleteGeneralQnaInfo.do")
	public ModelAndView deleteGeneralQnaInfo(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
		LOGGER.debug("#################################################################################################");
		LOGGER.debug("generalQnaController - deleteGeneralQnaInfo [일반QnA 삭제]");
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
			generalQnaService.deleteGeneralQnaInfo(input);

		} catch (Exception e) {
			e.printStackTrace();
			rtnMeaasge.put("rtnSt", "F");
			rtnMeaasge.put("rtnMsg", "삭제가 실패하였습니다.");
		}

		modelAndView.addObject("trResultDataSet", RuiConverter.createDataset("trResultDataSet", rtnMeaasge));
		return modelAndView;
	}

	/** 게시글 조회건수 증가 **/
	@RequestMapping(value="/knld/qna/updateGeneralQnaRtrvCnt.do")
	public ModelAndView updateGeneralQnaRtrvCnt(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
		LOGGER.debug("#################################################################################################");
		LOGGER.debug("generalQnaController - updateGeneralQnaRtrvCnt [일반QnA 조회건수증가]");
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
			generalQnaService.updateGeneralQnaRtrvCnt(input);

		} catch (Exception e) {
			e.printStackTrace();
			rtnMeaasge.put("rtnSt", "F");
			rtnMeaasge.put("rtnMsg", "조회건수 증가 실패하였습니다.");
		}

		modelAndView.addObject("trResultDataSet", RuiConverter.createDataset("trResultDataSet", rtnMeaasge));
		return modelAndView;
	}


	/*덧글*/
	/*덧글 리스트 화면 호출*/
	@RequestMapping(value="/knld/qna/retrieveGeneralQnaRebList.do")
	public String generalQnaRebList(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			) throws Exception{

		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);

		LOGGER.debug("###########################################################");
		LOGGER.debug("generalQnaController - generalQnaRebList [일반QnA 덧글 리스트 호출]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		model.addAttribute("inputData", input);

		return "web/knld/qna/retrieveGeneralQnaRebList";
	}

	/*덧글 리스트*/
	@RequestMapping(value="/knld/qna/getGeneralQnaRebList.do")
	public ModelAndView getGeneralQnaRebList(
			@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpServletResponse response,
			HttpSession session,
			ModelMap model
			){

		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		ModelAndView modelAndView = new ModelAndView("ruiView");

		LOGGER.debug("###########################################################");
		LOGGER.debug("GeneralQnaController - getGeneralQnaRebList [일반QnA 덧글 리스트 검색]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		String qnaId = (String)input.get("qnaId");
        // 일반QnA 리스트 조회
		List<Map<String,Object>> generalQnaRebList = generalQnaService.getGeneralQnaRebList(input);

		modelAndView.addObject("generalQnaRebDataSet", RuiConverter.createDataset("generalQnaRebDataSet", generalQnaRebList));
		return modelAndView;
	}


	/*덧글 등록,수정 화면 호출*/
	@RequestMapping(value="/knld/qna/generalQnaRebRgst.do")
	public String generalQnaRebRgst(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			) throws Exception{

		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);

		LOGGER.debug("###########################################################");
		LOGGER.debug("generalQnaController - generalQnaRgst [일반QnA 덧글 등록 화면 호출]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		model.addAttribute("inputData", input);

		return "web/knld/qna/generalQnaRebRgst";
	}

	/** 덧글 등록 **/
	@RequestMapping(value="/knld/qna/insertGeneralQnaRebInfo.do")
	public ModelAndView insertGeneralQnaRebInfo(
			@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
		LOGGER.debug("###########################################################");
		LOGGER.debug("QnaController - insertGeneralQnaRebInfo [덧글 저장]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		checkSessionObjRUI(input, session, model);
		ModelAndView modelAndView = new ModelAndView("ruiView");
		HashMap<String, Object> rtnMeaasge = new HashMap<String, Object>();

		// 결과메시지
		rtnMeaasge.put("rtnSt", "S");
		rtnMeaasge.put("rtnMsg", "저장 되었습니다.");

		try	{
			generalQnaService.insertGeneralQnaRebInfo(input);
		} catch (Exception e) {
			e.printStackTrace();
			rtnMeaasge.put("rtnSt", "F");
			rtnMeaasge.put("rtnMsg", "저장이 실패하였습니다.");
		}

		modelAndView.addObject("resultDataSet", RuiConverter.createDataset("resultDataSet", rtnMeaasge));
		return modelAndView;
	}

	/** 덧글 수정 **/
	@RequestMapping(value="/knld/qna/updateGeneralQnaRebInfo.do")
	public ModelAndView updateGeneralQnaRebInfo(
			@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
		LOGGER.debug("###########################################################");
		LOGGER.debug("QnaController - updateGeneralQnaRebInfo [덧글 업데이트]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		checkSessionObjRUI(input, session, model);
		ModelAndView modelAndView = new ModelAndView("ruiView");
		HashMap<String, Object> rtnMeaasge = new HashMap<String, Object>();
		// 결과메시지
		rtnMeaasge.put("rtnSt", "S");
		rtnMeaasge.put("rtnMsg", "저장 되었습니다.");

		try
		{
			List<Map<String, Object>> qnaRebDataSetList = RuiConverter.convertToDataSet(request,"qnaRebInfoDataSet");

			for(Map<String, Object> data : qnaRebDataSetList) {
				data.put("userId", input.get("_userId"));
			};

			generalQnaService.updateGeneralQnaRebInfo(qnaRebDataSetList);
		} catch (Exception e) {
			e.printStackTrace();
			rtnMeaasge.put("rtnSt", "F");
			rtnMeaasge.put("rtnMsg", "저장이 실패하였습니다.");
		}

		modelAndView.addObject("resultDataSet", RuiConverter.createDataset("resultDataSet", rtnMeaasge));
		return modelAndView;
	}

	/** 덧글 삭제 **/
	@RequestMapping(value="/knld/qna/deleteGeneralQnaRebInfo.do")
	public ModelAndView deleteGeneralQnaRebInfo(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
		LOGGER.debug("#################################################################################################");
		LOGGER.debug("generalQnaController - deleteGeneralQnaRebInfo [일반QnA 덧글 삭제]");
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
			generalQnaService.deleteGeneralQnaRebInfo(input);

		} catch (Exception e) {
			e.printStackTrace();
			rtnMeaasge.put("rtnSt", "F");
			rtnMeaasge.put("rtnMsg", "삭제가 실패하였습니다.");
		}

		modelAndView.addObject("trResultDataSet", RuiConverter.createDataset("trResultDataSet", rtnMeaasge));
		return modelAndView;
	}

	@RequestMapping(value="/knld/qna/generalQnaInfoSrchView.do")
	public String generalQnaInfoSrchView(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			) throws Exception{

		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);

		LOGGER.debug("###########################################################");
		LOGGER.debug("generalQnaController - generalQnaInfoSrchView [일반QnA 뷰 화면 호출]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		model.addAttribute("inputData", input);

		return "web/knld/qna/generalQnaInfoSrchView";
	}

}//class end
