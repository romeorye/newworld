package iris.web.anl.lib.controller;

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
import iris.web.anl.lib.service.AnlLibService;
import iris.web.system.base.IrisBaseController;

/********************************************************************************
 * NAME : AnlLibController.java
 * DESC : 분석자료실 관리 controller
 * PROJ : IRIS UPGRADE 1차 프로젝트
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION
 * ----------  ------  ---------------------------------------------------------
 * 2017.09.26  			최초생성
 *********************************************************************************/

@Controller
public class AnlLibController  extends IrisBaseController {

	@Resource(name="messageSourceAccessor")
	private MessageSourceAccessor messageSourceAccessor;

	@Resource(name = "codeCacheManager")
	private CodeCacheManager codeCacheManager;

	@Resource(name = "configService")
    private ConfigService configService;

	@Resource(name = "anlLibService")
	private AnlLibService anlLibService;

	static final Logger LOGGER = LogManager.getLogger(AnlLibController.class);

	//분석 공지사항 시작
	/*리스트 화면 호출*/
	@RequestMapping(value="/anl/lib/retrievePubNoticeList.do")
	public String anlNoticeList(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			) throws Exception{

		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);

		LOGGER.debug("###########################################################");
		LOGGER.debug("AnlNoticeController - AnlNoticeList [공지사항 리스트 호출]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		model.addAttribute("inputData", input);

		return "web/anl/lib/retrieveAnlNoticeList";
	}

	/*리스트*/
	@RequestMapping(value="/anl/lib/getAnlNoticeList.do")
	public ModelAndView getAnlNoticeList(
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
		LOGGER.debug("AnlNoticeController - getAnlNoticeList [공지사항 리스트 검색]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		ModelAndView modelAndView = new ModelAndView("ruiView");

        // 공지사항 리스트 조회
		List<Map<String,Object>> anlNoticeList = anlLibService.getAnlLibList(input);

		modelAndView.addObject("anlNoticeDataSet", RuiConverter.createDataset("anlNoticeDataSet", anlNoticeList));
		return modelAndView;
	}


	/*등록,수정 화면 호출*/
	@RequestMapping(value="/anl/lib/anlNoticeRgst.do")
	public String anlNoticeRgst(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			) throws Exception{

		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);

		LOGGER.debug("###########################################################");
		LOGGER.debug("AnlNoticeController - AnlNoticeRgst [공지사항 등록 화면 호출]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		model.addAttribute("inputData", input);

		return "web/anl/lib/anlNoticeRgst";
	}

	/** 등록 **/
	@RequestMapping(value="/anl/lib/insertAnlNoticeInfo.do")
	public ModelAndView insertAnlNoticeInfo(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
		LOGGER.debug("###########################################################");
		LOGGER.debug("AnlNoticeController - insertAnlNoticeInfo [공지사항 저장&업데이트]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		checkSessionRUI(input, session, model);
		ModelAndView modelAndView = new ModelAndView("ruiView");
		HashMap<String, Object> rtnMeaasge = new HashMap<String, Object>();
		NamoMime mime = new NamoMime();

		String anlLibSbcHtml = "";
		String anlLibSbcHtml_temp = "";

		// 결과메시지
		rtnMeaasge.put("rtnSt", "S");
		rtnMeaasge.put("rtnMsg", "저장 되었습니다.");
		rtnMeaasge.put("bbsId", "");

		int totCnt = 0;    							//전체건수
		List<Map<String, Object>> AnlNoticeRgstDataSetList;	// 변경데이터

		try
		{

			String uploadUrl = "";
			String uploadPath = "";

            uploadUrl =  configService.getString("KeyStore.UPLOAD_URL") + configService.getString("KeyStore.UPLOAD_ANL");   // 파일명에 세팅되는 경로
            uploadPath = configService.getString("KeyStore.UPLOAD_BASE") + configService.getString("KeyStore.UPLOAD_ANL");  // 파일이 실제로 업로드 되는 경로

            mime.setSaveURL(uploadUrl);
            mime.setSavePath(uploadPath);
            mime.decode(input.get("bbsSbc").toString());                  // MIME 디코딩
            mime.saveFileAtPath(uploadPath+File.separator);

            anlLibSbcHtml = mime.getBodyContent();
            anlLibSbcHtml_temp = CommonUtil.replaceSecOutput(CommonUtil.replace(CommonUtil.replace(anlLibSbcHtml, "<", "@![!@"),">","@!]!@"));

			// 저장&수정
			String bbsId = "";
			AnlNoticeRgstDataSetList = RuiConverter.convertToDataSet(request,"anlNoticeRgstDataSet");

			for(Map<String,Object> anlNoticeRgstDataSetMap : AnlNoticeRgstDataSetList) {

				anlNoticeRgstDataSetMap.put("_userId" , NullUtil.nvl(input.get("_userId"), ""));
				anlNoticeRgstDataSetMap.put("bbsSbc" , NullUtil.nvl(anlLibSbcHtml, ""));

				anlLibService.insertAnlLibInfo(anlNoticeRgstDataSetMap);
				totCnt++;
			}

			rtnMeaasge.put("bbsId", bbsId);

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

	@RequestMapping(value="/anl/lib/anlNoticeInfo.do")
	public String anlNoticeInfo(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			) throws Exception{

		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);

		LOGGER.debug("###########################################################");
		LOGGER.debug("AnlNoticeController - AnlNoticeRgst [공지사항 상세 화면 호출]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		model.addAttribute("inputData", input);

		return "web/anl/lib/anlNoticeInfo";
	}

	@RequestMapping(value="/anl/lib/getAnlNoticeInfo.do")
	public ModelAndView getAnlNoticeInfo(
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
		LOGGER.debug("AnlNoticeController - getAnlNoticeList [공지사항 상세]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		ModelAndView modelAndView = new ModelAndView("ruiView");

		if(NullUtil.isNull(input.get("_userId")) ||  NullUtil.nvl(input.get("_userId"), "").equals("-1")  ){
			String rtnMsg = messageSourceAccessor.getMessage("msg.alert.sessionTimeout");
			SayMessage.setMessage(rtnMsg);
			modelAndView.addObject("anlNoticeDataSet", null);
        } else {
        	// 공지사항 상세 조회
	        Map<String,Object> resultMap = anlLibService.getAnlLibInfo(input);

	        modelAndView.addObject("anlNoticeInfoDataSet", RuiConverter.createDataset("anlNoticeInfoDataSet", resultMap));
        }
		return modelAndView;
	}

	/** 공지사항 삭제 **/
	@RequestMapping(value="/anl/lib/deleteAnlNoticeInfo.do")
	public ModelAndView deleteAnlNoticeInfo(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
		LOGGER.debug("#################################################################################################");
		LOGGER.debug("AnlNoticeController - deleteAnlNoticeInfo [공지사항 삭제]");
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
			anlLibService.deleteAnlLibInfo(input);

		} catch (Exception e) {
			e.printStackTrace();
			rtnMeaasge.put("rtnSt", "F");
			rtnMeaasge.put("rtnMsg", "삭제가 실패하였습니다.");
		}

		modelAndView.addObject("trResultDataSet", RuiConverter.createDataset("trResultDataSet", rtnMeaasge));
		return modelAndView;
	}

	/** 게시글 조회건수 증가 **/
	@RequestMapping(value="/anl/lib/updateAnlNoticeRtrvCnt.do")
	public ModelAndView updateAnlNoticeRtrvCnt(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
		LOGGER.debug("#################################################################################################");
		LOGGER.debug("AnlNoticeController - updateAnlNoticeRtrvCnt [공지사항 조회건수증가]");
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
			anlLibService.updateAnlLibRtrvCnt(input);

		} catch (Exception e) {
			e.printStackTrace();
			rtnMeaasge.put("rtnSt", "F");
			rtnMeaasge.put("rtnMsg", "조회건수 증가 실패하였습니다.");
		}

		modelAndView.addObject("trResultDataSet", RuiConverter.createDataset("trResultDataSet", rtnMeaasge));
		return modelAndView;
	}

	//분석 공지사항 끝


	//분석자료실 시작
	/*리스트 화면 호출*/
	@RequestMapping(value="/anl/lib/retrieveAnlLibList.do")
	public String anlLibList(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			) throws Exception{

		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);

		LOGGER.debug("###########################################################");
		LOGGER.debug("AnlLibController - AnlLibList [분석자료실 리스트 호출]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		model.addAttribute("inputData", input);

		return "web/anl/lib/retrieveAnlLibList";
	}

	/*TAB 화면 호출*/
	@RequestMapping(value="/anl/lib/anlLibTab.do")
	public String anlLibTab(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			) throws Exception{

		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);

		LOGGER.debug("###########################################################");
		LOGGER.debug("AnlLibController - AnlLibTabList [분석자료실 TAB 리스트 호출]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		model.addAttribute("inputData", input);

		return "web/anl/lib/anlLibTab";
	}

	/*리스트*/
	@RequestMapping(value="/anl/lib/getAnlLibList.do")
	public ModelAndView getAnlLibList(
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
		LOGGER.debug("AnlLibController - getAnlLibList [분석자료실 리스트 검색]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		ModelAndView modelAndView = new ModelAndView("ruiView");

        // 분석자료실 리스트 조회
		List<Map<String,Object>> anlLibList = anlLibService.getAnlLibList(input);

		modelAndView.addObject("anlLibDataSet", RuiConverter.createDataset("anlLibDataSet", anlLibList));
		return modelAndView;
	}


	/*등록,수정 화면 호출*/
	@RequestMapping(value="/anl/lib/anlLibRgst.do")
	public String anlLibRgst(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			) throws Exception{

		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);

		LOGGER.debug("###########################################################");
		LOGGER.debug("AnlLibController - AnlLibRgst [분석자료실 등록 화면 호출]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		model.addAttribute("inputData", input);

		return "web/anl/lib/anlLibRgst";
	}

	/** 등록 **/
	@RequestMapping(value="/anl/lib/insertAnlLibInfo.do")
	public ModelAndView insertAnlLibInfo(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
		LOGGER.debug("###########################################################");
		LOGGER.debug("AnlLibController - insertAnlLibInfo [분석자료실 저장&업데이트]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		checkSessionRUI(input, session, model);
		ModelAndView modelAndView = new ModelAndView("ruiView");
		HashMap<String, Object> rtnMeaasge = new HashMap<String, Object>();
		NamoMime mime = new NamoMime();

		String anlLibSbcHtml = "";
		String anlLibSbcHtml_temp = "";

		// 결과메시지
		rtnMeaasge.put("rtnSt", "S");
		rtnMeaasge.put("rtnMsg", "저장 되었습니다.");
		rtnMeaasge.put("bbsId", "");

		int totCnt = 0;    							//전체건수
		List<Map<String, Object>> AnlLibRgstDataSetList;	// 변경데이터

		try
		{
			String uploadUrl = "";
			String uploadPath = "";

            uploadUrl =  configService.getString("KeyStore.UPLOAD_URL") + configService.getString("KeyStore.UPLOAD_ANL");   // 파일명에 세팅되는 경로
            uploadPath = configService.getString("KeyStore.UPLOAD_BASE") + configService.getString("KeyStore.UPLOAD_ANL");  // 파일이 실제로 업로드 되는 경로

            mime.setSaveURL(uploadUrl);
            mime.setSavePath(uploadPath);
            mime.decode(input.get("bbsSbc").toString());                  // MIME 디코딩
            mime.saveFileAtPath(uploadPath+File.separator);

            anlLibSbcHtml = mime.getBodyContent();
            anlLibSbcHtml_temp = CommonUtil.replaceSecOutput(CommonUtil.replace(CommonUtil.replace(anlLibSbcHtml, "<", "@![!@"),">","@!]!@"));


			// 저장&수정
			String bbsId = "";
			AnlLibRgstDataSetList = RuiConverter.convertToDataSet(request,"anlLibRgstDataSet");

			for(Map<String,Object> anlLibRgstDataSetMap : AnlLibRgstDataSetList) {

				anlLibRgstDataSetMap.put("_userId" , NullUtil.nvl(input.get("_userId"), ""));
				anlLibRgstDataSetMap.put("bbsSbc" , NullUtil.nvl(anlLibSbcHtml, ""));

				anlLibService.insertAnlLibInfo(anlLibRgstDataSetMap);
				totCnt++;
			}

			rtnMeaasge.put("bbsId", bbsId);

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

	@RequestMapping(value="/anl/lib/anlLibInfo.do")
	public String anlLibInfo(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			) throws Exception{

		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);

		LOGGER.debug("###########################################################");
		LOGGER.debug("AnlLibController - AnlLibRgst [분석자료실 상세 화면 호출]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		model.addAttribute("inputData", input);

		return "web/anl/lib/anlLibInfo";
	}

	@RequestMapping(value="/anl/lib/getAnlLibInfo.do")
	public ModelAndView getAnlLibInfo(
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
		LOGGER.debug("AnlLibController - getAnlLibList [분석자료실 상세]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		ModelAndView modelAndView = new ModelAndView("ruiView");

		if(NullUtil.isNull(input.get("_userId")) ||  NullUtil.nvl(input.get("_userId"), "").equals("-1")  ){
			String rtnMsg = messageSourceAccessor.getMessage("msg.alert.sessionTimeout");
			SayMessage.setMessage(rtnMsg);
			modelAndView.addObject("anlLibDataSet", null);
        } else {
        	// 분석자료실 상세 조회
	        Map<String,Object> resultMap = anlLibService.getAnlLibInfo(input);

	        modelAndView.addObject("anlLibInfoDataSet", RuiConverter.createDataset("anlLibInfoDataSet", resultMap));
        }
		return modelAndView;
	}

	/** 분석자료실 삭제 **/
	@RequestMapping(value="/anl/lib/deleteAnlLibInfo.do")
	public ModelAndView deleteAnlLibInfo(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
		LOGGER.debug("#################################################################################################");
		LOGGER.debug("AnlLibController - deleteAnlLibInfo [분석자료실 삭제]");
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
			anlLibService.deleteAnlLibInfo(input);

		} catch (Exception e) {
			e.printStackTrace();
			rtnMeaasge.put("rtnSt", "F");
			rtnMeaasge.put("rtnMsg", "삭제가 실패하였습니다.");
		}

		modelAndView.addObject("trResultDataSet", RuiConverter.createDataset("trResultDataSet", rtnMeaasge));
		return modelAndView;
	}

	/** 게시글 조회건수 증가 **/
	@RequestMapping(value="/anl/lib/updateAnlLibRtrvCnt.do")
	public ModelAndView updateAnlLibRtrvCnt(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
		LOGGER.debug("#################################################################################################");
		LOGGER.debug("AnlLibController - updateAnlLibRtrvCnt [분석자료실 조회건수증가]");
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
			anlLibService.updateAnlLibRtrvCnt(input);

		} catch (Exception e) {
			e.printStackTrace();
			rtnMeaasge.put("rtnSt", "F");
			rtnMeaasge.put("rtnMsg", "조회건수 증가 실패하였습니다.");
		}

		modelAndView.addObject("trResultDataSet", RuiConverter.createDataset("trResultDataSet", rtnMeaasge));
		return modelAndView;
	}
	//분석자료실 끝

	//분석 QnA 시작
	/*리스트 화면 호출*/
	@RequestMapping(value="/anl/lib/retrieveAnlQnaList.do")
	public String anlQnaList(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			) throws Exception{

		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);

		LOGGER.debug("###########################################################");
		LOGGER.debug("AnlQnaController - AnlQnaList [분석QnA 리스트 호출]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		model.addAttribute("inputData", input);

		return "web/anl/lib/retrieveAnlQnaList";
	}

	/*리스트*/
	@RequestMapping(value="/anl/lib/getAnlQnaList.do")
	public ModelAndView getAnlQnaList(
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
		LOGGER.debug("AnlQnaController - getAnlQnaList [분석QnA 리스트 검색]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		ModelAndView modelAndView = new ModelAndView("ruiView");

        // 일반QnA 리스트 조회
		List<Map<String,Object>> anlQnaList = anlLibService.getAnlQnaList(input);

		modelAndView.addObject("anlQnaDataSet", RuiConverter.createDataset("anlQnaDataSet", anlQnaList));
		return modelAndView;
	}


	/*등록,수정 화면 호출*/
	@RequestMapping(value="/anl/lib/anlQnaRgst.do")
	public String anlQnaRgst(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			) throws Exception{

		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);

		LOGGER.debug("###########################################################");
		LOGGER.debug("AnlQnaController - AnlQnaRgst [분석QnA 등록 화면 호출]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		model.addAttribute("inputData", input);

		return "web/anl/lib/anlQnaRgst";
	}


	/** 등록 **/
	@RequestMapping(value="/anl/lib/insertAnlQnaInfo.do")
	public ModelAndView insertAnlQnaInfo(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
		LOGGER.debug("###########################################################");
		LOGGER.debug("AnlQnaController - insertAnlQnaInfo [분석QnA 저장&업데이트]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		checkSessionRUI(input, session, model);
		ModelAndView modelAndView = new ModelAndView("ruiView");
		HashMap<String, Object> rtnMeaasge = new HashMap<String, Object>();
		NamoMime mime = new NamoMime();

		String anlLibSbcHtml = "";
		String anlLibSbcHtml_temp = "";

		// 결과메시지
		rtnMeaasge.put("rtnSt", "S");
		rtnMeaasge.put("rtnMsg", "저장 되었습니다.");
		rtnMeaasge.put("bbsId", "");

		int totCnt = 0;    							//전체건수
		List<Map<String, Object>> anlQnaRgstDataSetList;	//일반QnA 변경데이터

		try{

			String uploadUrl = "";
			String uploadPath = "";

            uploadUrl =  configService.getString("KeyStore.UPLOAD_URL") + configService.getString("KeyStore.UPLOAD_ANL");   // 파일명에 세팅되는 경로
            uploadPath = configService.getString("KeyStore.UPLOAD_BASE") + configService.getString("KeyStore.UPLOAD_ANL");  // 파일이 실제로 업로드 되는 경로

            mime.setSaveURL(uploadUrl);
            mime.setSavePath(uploadPath);
            mime.decode(input.get("bbsSbc").toString());                  // MIME 디코딩
            mime.saveFileAtPath(uploadPath+File.separator);

            anlLibSbcHtml = mime.getBodyContent();
            anlLibSbcHtml_temp = CommonUtil.replaceSecOutput(CommonUtil.replace(CommonUtil.replace(anlLibSbcHtml, "<", "@![!@"),">","@!]!@"));

			//일반QnA 저장&수정
			String bbsId = "";
			anlQnaRgstDataSetList = RuiConverter.convertToDataSet(request,"anlQnaRgstDataSet");

			for(Map<String,Object> anlQnaRgstDataSetMap : anlQnaRgstDataSetList) {

				anlQnaRgstDataSetMap.put("_userId" , NullUtil.nvl(input.get("_userId"), ""));
				anlQnaRgstDataSetMap.put("bbsSbc" , NullUtil.nvl(anlLibSbcHtml, ""));

				anlLibService.insertAnlLibInfo(anlQnaRgstDataSetMap);
				totCnt++;
			}

			rtnMeaasge.put("bbsId", bbsId);

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

	@RequestMapping(value="/anl/lib/anlQnaInfo.do")
	public String anlQnadInfo(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			) throws Exception{

		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);

		LOGGER.debug("###########################################################");
		LOGGER.debug("anlQnaController - anlQnaRgst [분석QnA 상세 화면 호출]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		model.addAttribute("inputData", input);

		return "web/anl/lib/anlQnaInfo";
	}

	@RequestMapping(value="/anl/lib/getAnlQnaInfo.do")
	public ModelAndView getAnlQnaInfo(
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
		LOGGER.debug("AnlQnaController - getAnlQnaList [분석QnA 상세]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		ModelAndView modelAndView = new ModelAndView("ruiView");

		if(NullUtil.isNull(input.get("_userId")) ||  NullUtil.nvl(input.get("_userId"), "").equals("-1")  ){
			String rtnMsg = messageSourceAccessor.getMessage("msg.alert.sessionTimeout");
			SayMessage.setMessage(rtnMsg);
			modelAndView.addObject("anlQnaDataSet", null);
        } else {
        	// 일반QnA 상세 조회
	        Map<String,Object> resultMap = anlLibService.getAnlLibInfo(input);
	        modelAndView.addObject("anlQnaInfoDataSet", RuiConverter.createDataset("anlQnaInfoDataSet", resultMap));
        }
		return modelAndView;
	}

	/** 게시글 삭제 **/
	@RequestMapping(value="/anl/lib/deleteAnlQnaInfo.do")
	public ModelAndView deleteAnlQnaInfo(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
		LOGGER.debug("#################################################################################################");
		LOGGER.debug("AnlQnaController - deleteAnlQnaInfo [분석QnA 삭제]");
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
			anlLibService.deleteAnlLibInfo(input);

		} catch (Exception e) {
			e.printStackTrace();
			rtnMeaasge.put("rtnSt", "F");
			rtnMeaasge.put("rtnMsg", "삭제가 실패하였습니다.");
		}

		modelAndView.addObject("trResultDataSet", RuiConverter.createDataset("trResultDataSet", rtnMeaasge));
		return modelAndView;
	}

	/** 게시글 조회건수 증가 **/
	@RequestMapping(value="/anl/lib/updateAnlQnaRtrvCnt.do")
	public ModelAndView updateAnlQnaRtrvCnt(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
		LOGGER.debug("#################################################################################################");
		LOGGER.debug("AnlQnaController - updateAnlQnaRtrvCnt [분석QnA 조회건수증가]");
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
			anlLibService.updateAnlLibRtrvCnt(input);

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
	@RequestMapping(value="/anl/lib/retrieveAnlQnaRebList.do")
	public String anlQnaRebList(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			) throws Exception{

		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);

		LOGGER.debug("###########################################################");
		LOGGER.debug("AnlQnaController - AnlQnaRebList [분석QnA 덧글 리스트 호출]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		model.addAttribute("inputData", input);

		return "web/anl/lib/retrieveAnlQnaRebList";
	}

	/*덧글 리스트*/
	@RequestMapping(value="/anl/lib/getAnlQnaRebList.do")
	public ModelAndView getAnlQnaRebList(
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
		LOGGER.debug("AnlQnaController - getAnlQnaRebList [분석QnA 덧글 리스트 검색]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		String bbsId = (String)input.get("bbsId");
        // 일반QnA 리스트 조회
		List<Map<String,Object>> anlQnaRebList = anlLibService.getAnlQnaRebList(input);

		modelAndView.addObject("anlQnaRebDataSet", RuiConverter.createDataset("anlQnaRebDataSet", anlQnaRebList));
		return modelAndView;
	}


	/*덧글 등록,수정 화면 호출*/
	@RequestMapping(value="/anl/lib/anlQnaRebRgst.do")
	public String anlQnaRebRgst(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			) throws Exception{

		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);

		LOGGER.debug("###########################################################");
		LOGGER.debug("AnlQnaController - AnlQnaRgst [분석QnA 덧글 등록 화면 호출]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		model.addAttribute("inputData", input);

		return "web/anl/lib/anlQnaRebRgst";
	}

	/** 덧글 등록 **/
	@RequestMapping(value="/anl/lib/insertAnlQnaRebInfo.do")
	public ModelAndView insertAnlQnaRebInfo(
			@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
		LOGGER.debug("###########################################################");
		LOGGER.debug("AnlQnaController - insertAnlQnaRebInfo [덧글 저장]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		checkSessionObjRUI(input, session, model);
		ModelAndView modelAndView = new ModelAndView("ruiView");
		HashMap<String, Object> rtnMeaasge = new HashMap<String, Object>();

		// 결과메시지
		rtnMeaasge.put("rtnSt", "S");
		rtnMeaasge.put("rtnMsg", "저장 되었습니다.");

		try	{
			anlLibService.insertAnlQnaRebInfo(input);
		} catch (Exception e) {
			e.printStackTrace();
			rtnMeaasge.put("rtnSt", "F");
			rtnMeaasge.put("rtnMsg", "저장이 실패하였습니다.");
		}

		modelAndView.addObject("resultDataSet", RuiConverter.createDataset("resultDataSet", rtnMeaasge));
		return modelAndView;
	}

	/** 덧글 수정 **/
	@RequestMapping(value="/anl/lib/updateAnlQnaRebInfo.do")
	public ModelAndView updateAnlQnaRebInfo(
			@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
		LOGGER.debug("###########################################################");
		LOGGER.debug("AnlQnaController - updateAnlQnaRebInfo [덧글 업데이트]");
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
			List<Map<String, Object>> anlQnaRebDataSetList = RuiConverter.convertToDataSet(request,"anlQnaRebInfoDataSet");

			for(Map<String, Object> data : anlQnaRebDataSetList) {
				data.put("_userId", input.get("_userId"));
			};

			anlLibService.updateAnlQnaRebInfo(anlQnaRebDataSetList);
		} catch (Exception e) {
			e.printStackTrace();
			rtnMeaasge.put("rtnSt", "F");
			rtnMeaasge.put("rtnMsg", "저장이 실패하였습니다.");
		}

		modelAndView.addObject("resultDataSet", RuiConverter.createDataset("resultDataSet", rtnMeaasge));
		return modelAndView;
	}

	/** 덧글 삭제 **/
	@RequestMapping(value="/anl/lib/deleteAnlQnaRebInfo.do")
	public ModelAndView deleteAnlQnaRebInfo(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
		LOGGER.debug("#################################################################################################");
		LOGGER.debug("AnlQnaController - deleteAnlQnaRebInfo [분석QnA 덧글 삭제]");
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
			anlLibService.deleteAnlQnaRebInfo(input);

		} catch (Exception e) {
			e.printStackTrace();
			rtnMeaasge.put("rtnSt", "F");
			rtnMeaasge.put("rtnMsg", "삭제가 실패하였습니다.");
		}

		modelAndView.addObject("trResultDataSet", RuiConverter.createDataset("trResultDataSet", rtnMeaasge));
		return modelAndView;
	}

	@RequestMapping(value="/anl/lib/anlNoticeInfoSrchView.do")
	public String anlNoticeInfoSrchView(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			) throws Exception{

		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);

		LOGGER.debug("###########################################################");
		LOGGER.debug("AnlQnaController - anlNoticeInfoSrchView [분석 3게시판 상세 화면 호출]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		model.addAttribute("inputData", input);
		return "web/anl/lib/anlNoticeInfoSrchView";
	}

	//분석 Qna 끝

}//class end
