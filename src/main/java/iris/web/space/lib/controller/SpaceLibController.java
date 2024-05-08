package iris.web.space.lib.controller;

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
import devonframe.message.saymessage.SayMessage;
import devonframe.util.NullUtil;
import iris.web.common.code.service.CodeCacheManager;
import iris.web.common.converter.RuiConverter;
import iris.web.common.util.CommonUtil;
import iris.web.common.util.NamoMime;
import iris.web.common.util.StringUtil;
import iris.web.space.lib.service.SpaceLibService;
import iris.web.system.base.IrisBaseController;

/********************************************************************************
 * NAME : SpaceLibController.java
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
public class SpaceLibController  extends IrisBaseController {

	@Resource(name="messageSourceAccessor")
	private MessageSourceAccessor messageSourceAccessor;

	@Resource(name = "codeCacheManager")
	private CodeCacheManager codeCacheManager;

	@Resource(name = "configService")
    private ConfigService configService;

	@Resource(name = "spaceLibService")
	private SpaceLibService spaceLibService;

	static final Logger LOGGER = LogManager.getLogger(SpaceLibController.class);

	//분석 공지사항 시작
	/*리스트 화면 호출*/
	@RequestMapping(value="/space/lib/retrievePubNoticeList.do")
	public String spaceNoticeList(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			) throws Exception{

		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);

		LOGGER.debug("###########################################################");
		LOGGER.debug("SpaceNoticeController - SpaceNoticeList [공지사항 리스트 호출]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		model.addAttribute("inputData", input);

		return "web/space/lib/retrieveSpaceNoticeList";
	}

	/*리스트*/
	@RequestMapping(value="/space/lib/getSpaceNoticeList.do")
	public ModelAndView getSpaceNoticeList(
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
		LOGGER.debug("SpaceNoticeController - getSpaceNoticeList [공지사항 리스트 검색]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		ModelAndView modelAndView = new ModelAndView("ruiView");

        // 공지사항 리스트 조회
		List<Map<String,Object>> spaceNoticeList = spaceLibService.getSpaceLibList(input);

		modelAndView.addObject("spaceNoticeDataSet", RuiConverter.createDataset("spaceNoticeDataSet", spaceNoticeList));
		return modelAndView;
	}


	/*등록,수정 화면 호출*/
	@RequestMapping(value="/space/lib/spaceNoticeRgst.do")
	public String spaceNoticeRgst(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			) throws Exception{

		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);

		LOGGER.debug("###########################################################");
		LOGGER.debug("SpaceNoticeController - SpaceNoticeRgst [공지사항 등록 화면 호출]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		model.addAttribute("inputData", input);

		return "web/space/lib/spaceNoticeRgst";
	}

	/** 등록 **/
	@RequestMapping(value="/space/lib/insertSpaceNoticeInfo.do")
	public ModelAndView insertSpaceNoticeInfo(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
		LOGGER.debug("###########################################################");
		LOGGER.debug("SpaceNoticeController - insertSpaceNoticeInfo [공지사항 저장&업데이트]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		checkSessionRUI(input, session, model);
		ModelAndView modelAndView = new ModelAndView("ruiView");
		HashMap<String, Object> rtnMeaasge = new HashMap<String, Object>();
		NamoMime mime = new NamoMime();

		String spaceLibSbcHtml = "";
		String spaceLibSbcHtml_temp = "";

		// 결과메시지
		rtnMeaasge.put("rtnSt", "S");
		rtnMeaasge.put("rtnMsg", "저장 되었습니다.");
		rtnMeaasge.put("bbsId", "");

		int totCnt = 0;    							//전체건수
		List<Map<String, Object>> SpaceNoticeRgstDataSetList;	// 변경데이터

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

            spaceLibSbcHtml = mime.getBodyContent();
            spaceLibSbcHtml_temp = CommonUtil.replaceSecOutput(CommonUtil.replace(CommonUtil.replace(spaceLibSbcHtml, "<", "@![!@"),">","@!]!@"));

			// 저장&수정
			String bbsId = "";
			SpaceNoticeRgstDataSetList = RuiConverter.convertToDataSet(request,"spaceNoticeRgstDataSet");

			for(Map<String,Object> spaceNoticeRgstDataSetMap : SpaceNoticeRgstDataSetList) {

				spaceNoticeRgstDataSetMap.put("_userId" , NullUtil.nvl(input.get("_userId"), ""));
				spaceNoticeRgstDataSetMap.put("bbsSbc" , NullUtil.nvl(spaceLibSbcHtml, ""));

				spaceLibService.insertSpaceLibInfo(spaceNoticeRgstDataSetMap);
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

	@RequestMapping(value="/space/lib/spaceNoticeInfo.do")
	public String spaceNoticeInfo(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			) throws Exception{

		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);

		LOGGER.debug("###########################################################");
		LOGGER.debug("SpaceNoticeController - SpaceNoticeRgst [공지사항 상세 화면 호출]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		model.addAttribute("inputData", input);

		return "web/space/lib/spaceNoticeInfo";
	}

	@RequestMapping(value="/space/lib/getSpaceNoticeInfo.do")
	public ModelAndView getSpaceNoticeInfo(
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
		LOGGER.debug("SpaceNoticeController - getSpaceNoticeList [공지사항 상세]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		ModelAndView modelAndView = new ModelAndView("ruiView");

		if(NullUtil.isNull(input.get("_userId")) ||  NullUtil.nvl(input.get("_userId"), "").equals("-1")  ){
			String rtnMsg = messageSourceAccessor.getMessage("msg.alert.sessionTimeout");
			SayMessage.setMessage(rtnMsg);
			modelAndView.addObject("spaceNoticeDataSet", null);
        } else {
        	// 공지사항 상세 조회
	        Map<String,Object> resultMap = spaceLibService.getSpaceLibInfo(input);

	        modelAndView.addObject("spaceNoticeInfoDataSet", RuiConverter.createDataset("spaceNoticeInfoDataSet", resultMap));
        }
		return modelAndView;
	}

	/** 공지사항 삭제 **/
	@RequestMapping(value="/space/lib/deleteSpaceNoticeInfo.do")
	public ModelAndView deleteSpaceNoticeInfo(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
		LOGGER.debug("#################################################################################################");
		LOGGER.debug("SpaceNoticeController - deleteSpaceNoticeInfo [공지사항 삭제]");
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
			spaceLibService.deleteSpaceLibInfo(input);

		} catch (Exception e) {
			e.printStackTrace();
			rtnMeaasge.put("rtnSt", "F");
			rtnMeaasge.put("rtnMsg", "삭제가 실패하였습니다.");
		}

		modelAndView.addObject("trResultDataSet", RuiConverter.createDataset("trResultDataSet", rtnMeaasge));
		return modelAndView;
	}

	/** 게시글 조회건수 증가 **/
	@RequestMapping(value="/space/lib/updateSpaceNoticeRtrvCnt.do")
	public ModelAndView updateSpaceNoticeRtrvCnt(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
		LOGGER.debug("#################################################################################################");
		LOGGER.debug("SpaceNoticeController - updateSpaceNoticeRtrvCnt [공지사항 조회건수증가]");
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
			spaceLibService.updateSpaceLibRtrvCnt(input);

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
	@RequestMapping(value="/space/lib/retrieveSpaceLibList.do")
	public String spaceLibList(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			) throws Exception{

		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);

		LOGGER.debug("###########################################################");
		LOGGER.debug("SpaceLibController - SpaceLibList [분석자료실 리스트 호출]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		model.addAttribute("inputData", input);

		return "web/space/lib/retrieveSpaceLibList";
	}

	/*TAB 화면 호출*/
	@RequestMapping(value="/space/lib/spaceLibTab.do")
	public String spaceLibTab(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			) throws Exception{

		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);

		LOGGER.debug("###########################################################");
		LOGGER.debug("SpaceLibController - SpaceLibTabList [분석자료실 TAB 리스트 호출]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		model.addAttribute("inputData", input);

		return "web/space/lib/spaceLibTab";
	}

	/*리스트*/
	@RequestMapping(value="/space/lib/getSpaceLibList.do")
	public ModelAndView getSpaceLibList(
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
		LOGGER.debug("SpaceLibController - getSpaceLibList [분석자료실 리스트 검색]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		ModelAndView modelAndView = new ModelAndView("ruiView");

        // 분석자료실 리스트 조회
		List<Map<String,Object>> spaceLibList = spaceLibService.getSpaceLibList(input);

		modelAndView.addObject("spaceLibDataSet", RuiConverter.createDataset("spaceLibDataSet", spaceLibList));
		return modelAndView;
	}


	/*등록,수정 화면 호출*/
	@RequestMapping(value="/space/lib/spaceLibRgst.do")
	public String spaceLibRgst(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			) throws Exception{

		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);

		LOGGER.debug("###########################################################");
		LOGGER.debug("SpaceLibController - SpaceLibRgst [분석자료실 등록 화면 호출]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		model.addAttribute("inputData", input);

		return "web/space/lib/spaceLibRgst";
	}

	/** 등록 **/
	@RequestMapping(value="/space/lib/insertSpaceLibInfo.do")
	public ModelAndView insertSpaceLibInfo(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
		LOGGER.debug("###########################################################");
		LOGGER.debug("SpaceLibController - insertSpaceLibInfo [분석자료실 저장&업데이트]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		checkSessionRUI(input, session, model);
		ModelAndView modelAndView = new ModelAndView("ruiView");
		HashMap<String, Object> rtnMeaasge = new HashMap<String, Object>();

		// 결과메시지
		rtnMeaasge.put("rtnSt", "S");
		rtnMeaasge.put("rtnMsg", "저장 되었습니다.");
		rtnMeaasge.put("bbsId", "");

		HashMap<String, Object> SpaceLibRgstDataSetMap = new HashMap<String, Object>();

		try
		{
			// 저장&수정
			SpaceLibRgstDataSetMap = (HashMap<String, Object>) RuiConverter.convertToDataSet(request,"spaceLibRgstDataSet").get(0);


			SpaceLibRgstDataSetMap.put("_userId" , NullUtil.nvl(input.get("_userId"), ""));

			spaceLibService.insertSpaceLibInfo(SpaceLibRgstDataSetMap);

			rtnMeaasge.put("bbsId", SpaceLibRgstDataSetMap.get("bbsId"));

		} catch (Exception e) {
			e.printStackTrace();
			rtnMeaasge.put("rtnSt", "F");
			rtnMeaasge.put("rtnMsg", "저장이 실패하였습니다.");
		}

		model.addAttribute("inputData", input);
		modelAndView.addObject("resultDataSet", RuiConverter.createDataset("resultDataSet", rtnMeaasge));
		return modelAndView;
	}

	@RequestMapping(value="/space/lib/spaceLibInfo.do")
	public String spaceLibInfo(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			) throws Exception{

		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);

		LOGGER.debug("###########################################################");
		LOGGER.debug("SpaceLibController - SpaceLibRgst [분석자료실 상세 화면 호출]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		model.addAttribute("inputData", input);

		return "web/space/lib/spaceLibInfo";
	}

	@RequestMapping(value="/space/lib/getSpaceLibInfo.do")
	public ModelAndView getSpaceLibInfo(
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
		LOGGER.debug("SpaceLibController - getSpaceLibList [분석자료실 상세]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		ModelAndView modelAndView = new ModelAndView("ruiView");

		if(NullUtil.isNull(input.get("_userId")) ||  NullUtil.nvl(input.get("_userId"), "").equals("-1")  ){
			String rtnMsg = messageSourceAccessor.getMessage("msg.alert.sessionTimeout");
			SayMessage.setMessage(rtnMsg);
			modelAndView.addObject("spaceLibDataSet", null);
        } else {
        	// 분석자료실 상세 조회
	        Map<String,Object> resultMap = spaceLibService.getSpaceLibInfo(input);

	        modelAndView.addObject("spaceLibInfoDataSet", RuiConverter.createDataset("spaceLibInfoDataSet", resultMap));
        }
		return modelAndView;
	}

	/** 분석자료실 삭제 **/
	@RequestMapping(value="/space/lib/deleteSpaceLibInfo.do")
	public ModelAndView deleteSpaceLibInfo(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
		LOGGER.debug("#################################################################################################");
		LOGGER.debug("SpaceLibController - deleteSpaceLibInfo [분석자료실 삭제]");
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
			spaceLibService.deleteSpaceLibInfo(input);

		} catch (Exception e) {
			e.printStackTrace();
			rtnMeaasge.put("rtnSt", "F");
			rtnMeaasge.put("rtnMsg", "삭제가 실패하였습니다.");
		}

		modelAndView.addObject("trResultDataSet", RuiConverter.createDataset("trResultDataSet", rtnMeaasge));
		return modelAndView;
	}

	/** 게시글 조회건수 증가 **/
	@RequestMapping(value="/space/lib/updateSpaceLibRtrvCnt.do")
	public ModelAndView updateSpaceLibRtrvCnt(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
		LOGGER.debug("#################################################################################################");
		LOGGER.debug("SpaceLibController - updateSpaceLibRtrvCnt [분석자료실 조회건수증가]");
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
			spaceLibService.updateSpaceLibRtrvCnt(input);

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
	@RequestMapping(value="/space/lib/retrieveSpaceQnaList.do")
	public String spaceQnaList(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			) throws Exception{

		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);

		LOGGER.debug("###########################################################");
		LOGGER.debug("SpaceQnaController - SpaceQnaList [분석QnA 리스트 호출]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		model.addAttribute("inputData", input);

		return "web/space/lib/retrieveSpaceQnaList";
	}

	/*리스트*/
	@RequestMapping(value="/space/lib/getSpaceQnaList.do")
	public ModelAndView getSpaceQnaList(
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
		LOGGER.debug("SpaceQnaController - getSpaceQnaList [분석QnA 리스트 검색]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		ModelAndView modelAndView = new ModelAndView("ruiView");

        // 일반QnA 리스트 조회
		List<Map<String,Object>> spaceQnaList = spaceLibService.getSpaceQnaList(input);

		modelAndView.addObject("spaceQnaDataSet", RuiConverter.createDataset("spaceQnaDataSet", spaceQnaList));
		return modelAndView;
	}


	/*등록,수정 화면 호출*/
	@RequestMapping(value="/space/lib/spaceQnaRgst.do")
	public String spaceQnaRgst(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			) throws Exception{

		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);

		LOGGER.debug("###########################################################");
		LOGGER.debug("SpaceQnaController - SpaceQnaRgst [분석QnA 등록 화면 호출]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		model.addAttribute("inputData", input);

		return "web/space/lib/spaceQnaRgst";
	}


	/** 등록 **/
	@RequestMapping(value="/space/lib/insertSpaceQnaInfo.do")
	public ModelAndView insertSpaceQnaInfo(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
		LOGGER.debug("###########################################################");
		LOGGER.debug("SpaceQnaController - insertSpaceQnaInfo [분석QnA 저장&업데이트]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		checkSessionRUI(input, session, model);
		ModelAndView modelAndView = new ModelAndView("ruiView");
		HashMap<String, Object> rtnMeaasge = new HashMap<String, Object>();
		NamoMime mime = new NamoMime();

		String spaceLibSbcHtml = "";
		String spaceLibSbcHtml_temp = "";

		// 결과메시지
		rtnMeaasge.put("rtnSt", "S");
		rtnMeaasge.put("rtnMsg", "저장 되었습니다.");
		rtnMeaasge.put("bbsId", "");

		int totCnt = 0;    							//전체건수
		List<Map<String, Object>> spaceQnaRgstDataSetList;	//일반QnA 변경데이터

		try{

			String uploadUrl = "";
			String uploadPath = "";

            uploadUrl =  configService.getString("KeyStore.UPLOAD_URL") + configService.getString("KeyStore.UPLOAD_ANL");   // 파일명에 세팅되는 경로
            uploadPath = configService.getString("KeyStore.UPLOAD_BASE") + configService.getString("KeyStore.UPLOAD_ANL");  // 파일이 실제로 업로드 되는 경로

            mime.setSaveURL(uploadUrl);
            mime.setSavePath(uploadPath);
            mime.decode(input.get("bbsSbc").toString());                  // MIME 디코딩
            mime.saveFileAtPath(uploadPath+File.separator);

            spaceLibSbcHtml = mime.getBodyContent();
            spaceLibSbcHtml_temp = CommonUtil.replaceSecOutput(CommonUtil.replace(CommonUtil.replace(spaceLibSbcHtml, "<", "@![!@"),">","@!]!@"));

			//일반QnA 저장&수정
			String bbsId = "";
			spaceQnaRgstDataSetList = RuiConverter.convertToDataSet(request,"spaceQnaRgstDataSet");

			for(Map<String,Object> spaceQnaRgstDataSetMap : spaceQnaRgstDataSetList) {

				spaceQnaRgstDataSetMap.put("_userId" , NullUtil.nvl(input.get("_userId"), ""));
				spaceQnaRgstDataSetMap.put("bbsSbc" , NullUtil.nvl(spaceLibSbcHtml, ""));

				spaceLibService.insertSpaceLibInfo(spaceQnaRgstDataSetMap);
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

	@RequestMapping(value="/space/lib/spaceQnaInfo.do")
	public String spaceQnadInfo(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			) throws Exception{

		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);

		LOGGER.debug("###########################################################");
		LOGGER.debug("spaceQnaController - spaceQnaRgst [분석QnA 상세 화면 호출]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		model.addAttribute("inputData", input);

		return "web/space/lib/spaceQnaInfo";
	}

	@RequestMapping(value="/space/lib/getSpaceQnaInfo.do")
	public ModelAndView getSpaceQnaInfo(
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
		LOGGER.debug("SpaceQnaController - getSpaceQnaList [분석QnA 상세]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		ModelAndView modelAndView = new ModelAndView("ruiView");

		if(NullUtil.isNull(input.get("_userId")) ||  NullUtil.nvl(input.get("_userId"), "").equals("-1")  ){
			String rtnMsg = messageSourceAccessor.getMessage("msg.alert.sessionTimeout");
			SayMessage.setMessage(rtnMsg);
			modelAndView.addObject("spaceQnaDataSet", null);
        } else {
        	// 일반QnA 상세 조회
	        Map<String,Object> resultMap = spaceLibService.getSpaceLibInfo(input);
	        modelAndView.addObject("spaceQnaInfoDataSet", RuiConverter.createDataset("spaceQnaInfoDataSet", resultMap));
        }
		return modelAndView;
	}

	/** 게시글 삭제 **/
	@RequestMapping(value="/space/lib/deleteSpaceQnaInfo.do")
	public ModelAndView deleteSpaceQnaInfo(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
		LOGGER.debug("#################################################################################################");
		LOGGER.debug("SpaceQnaController - deleteSpaceQnaInfo [분석QnA 삭제]");
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
			spaceLibService.deleteSpaceLibInfo(input);

		} catch (Exception e) {
			e.printStackTrace();
			rtnMeaasge.put("rtnSt", "F");
			rtnMeaasge.put("rtnMsg", "삭제가 실패하였습니다.");
		}

		modelAndView.addObject("trResultDataSet", RuiConverter.createDataset("trResultDataSet", rtnMeaasge));
		return modelAndView;
	}

	/** 게시글 조회건수 증가 **/
	@RequestMapping(value="/space/lib/updateSpaceQnaRtrvCnt.do")
	public ModelAndView updateSpaceQnaRtrvCnt(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
		LOGGER.debug("#################################################################################################");
		LOGGER.debug("SpaceQnaController - updateSpaceQnaRtrvCnt [분석QnA 조회건수증가]");
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
			spaceLibService.updateSpaceLibRtrvCnt(input);

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
	@RequestMapping(value="/space/lib/retrieveSpaceQnaRebList.do")
	public String spaceQnaRebList(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			) throws Exception{

		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);

		LOGGER.debug("###########################################################");
		LOGGER.debug("SpaceQnaController - SpaceQnaRebList [분석QnA 덧글 리스트 호출]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		model.addAttribute("inputData", input);

		return "web/space/lib/retrieveSpaceQnaRebList";
	}

	/*덧글 리스트*/
	@RequestMapping(value="/space/lib/getSpaceQnaRebList.do")
	public ModelAndView getSpaceQnaRebList(
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
		LOGGER.debug("SpaceQnaController - getSpaceQnaRebList [분석QnA 덧글 리스트 검색]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		String bbsId = (String)input.get("bbsId");
        // 일반QnA 리스트 조회
		List<Map<String,Object>> spaceQnaRebList = spaceLibService.getSpaceQnaRebList(input);

		modelAndView.addObject("spaceQnaRebDataSet", RuiConverter.createDataset("spaceQnaRebDataSet", spaceQnaRebList));
		return modelAndView;
	}


	/*덧글 등록,수정 화면 호출*/
	@RequestMapping(value="/space/lib/spaceQnaRebRgst.do")
	public String spaceQnaRebRgst(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			) throws Exception{

		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);

		LOGGER.debug("###########################################################");
		LOGGER.debug("SpaceQnaController - SpaceQnaRgst [분석QnA 덧글 등록 화면 호출]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		model.addAttribute("inputData", input);

		return "web/space/lib/spaceQnaRebRgst";
	}

	/** 덧글 등록 **/
	@RequestMapping(value="/space/lib/insertSpaceQnaRebInfo.do")
	public ModelAndView insertSpaceQnaRebInfo(
			@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
		LOGGER.debug("###########################################################");
		LOGGER.debug("SpaceQnaController - insertSpaceQnaRebInfo [덧글 저장]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		checkSessionObjRUI(input, session, model);
		ModelAndView modelAndView = new ModelAndView("ruiView");
		HashMap<String, Object> rtnMeaasge = new HashMap<String, Object>();

		// 결과메시지
		rtnMeaasge.put("rtnSt", "S");
		rtnMeaasge.put("rtnMsg", "저장 되었습니다.");

		try	{
			spaceLibService.insertSpaceQnaRebInfo(input);
		} catch (Exception e) {
			e.printStackTrace();
			rtnMeaasge.put("rtnSt", "F");
			rtnMeaasge.put("rtnMsg", "저장이 실패하였습니다.");
		}

		modelAndView.addObject("resultDataSet", RuiConverter.createDataset("resultDataSet", rtnMeaasge));
		return modelAndView;
	}

	/** 덧글 수정 **/
	@RequestMapping(value="/space/lib/updateSpaceQnaRebInfo.do")
	public ModelAndView updateSpaceQnaRebInfo(
			@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
		LOGGER.debug("###########################################################");
		LOGGER.debug("SpaceQnaController - updateSpaceQnaRebInfo [덧글 업데이트]");
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
			List<Map<String, Object>> spaceQnaRebDataSetList = RuiConverter.convertToDataSet(request,"spaceQnaRebInfoDataSet");

			for(Map<String, Object> data : spaceQnaRebDataSetList) {
				data.put("_userId", input.get("_userId"));
			};

			spaceLibService.updateSpaceQnaRebInfo(spaceQnaRebDataSetList);
		} catch (Exception e) {
			e.printStackTrace();
			rtnMeaasge.put("rtnSt", "F");
			rtnMeaasge.put("rtnMsg", "저장이 실패하였습니다.");
		}

		modelAndView.addObject("resultDataSet", RuiConverter.createDataset("resultDataSet", rtnMeaasge));
		return modelAndView;
	}

	/** 덧글 삭제 **/
	@RequestMapping(value="/space/lib/deleteSpaceQnaRebInfo.do")
	public ModelAndView deleteSpaceQnaRebInfo(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
		LOGGER.debug("#################################################################################################");
		LOGGER.debug("SpaceQnaController - deleteSpaceQnaRebInfo [분석QnA 덧글 삭제]");
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
			spaceLibService.deleteSpaceQnaRebInfo(input);

		} catch (Exception e) {
			e.printStackTrace();
			rtnMeaasge.put("rtnSt", "F");
			rtnMeaasge.put("rtnMsg", "삭제가 실패하였습니다.");
		}

		modelAndView.addObject("trResultDataSet", RuiConverter.createDataset("trResultDataSet", rtnMeaasge));
		return modelAndView;
	}

	@RequestMapping(value="/space/lib/spaceNoticeInfoSrchView.do")
	public String spaceNoticeInfoSrchView(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			) throws Exception{

		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);

		LOGGER.debug("###########################################################");
		LOGGER.debug("SpaceQnaController - spaceNoticeInfoSrchView [분석 3게시판 상세 화면 호출]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		model.addAttribute("inputData", input);
		return "web/space/lib/spaceNoticeInfoSrchView";
	}

	//분석 Qna 끝
	
    @RequestMapping(value="/space/lib/spaceBbsCodeList.do")
    public ModelAndView retrieveCodeListForCache(
            @RequestParam HashMap<String, String> input,
            HttpServletRequest request,
            HttpServletResponse response,
            HttpSession session,
            ModelMap model
            ){

        LOGGER.debug("###########################################################");
        LOGGER.debug("CodeController - retrieveCodeListForCache [공통코드 캐쉬조회]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");
        
        
        ModelAndView modelAndView = new ModelAndView("ruiView");
            
        // 공통코드 캐쉬조회
        
        //List codeList = anlBbsService.anlBbsCodeList(NullUtil.nvl(input.get("comCd"), ""));
        List codeList = spaceLibService.spaceBbsCodeList(input);
         
        modelAndView.addObject("radioDataSet", RuiConverter.createDataset("codeList", codeList));

        return modelAndView;
    }

}//class end
