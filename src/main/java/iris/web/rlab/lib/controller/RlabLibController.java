package iris.web.rlab.lib.controller;

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
import iris.web.rlab.lib.service.RlabLibService;
import iris.web.system.base.IrisBaseController;

/********************************************************************************
 * NAME : RlabLibController.java
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
public class RlabLibController  extends IrisBaseController {

	@Resource(name="messageSourceAccessor")
	private MessageSourceAccessor messageSourceAccessor;

	@Resource(name = "codeCacheManager")
	private CodeCacheManager codeCacheManager;

	@Resource(name = "configService")
    private ConfigService configService;

	@Resource(name = "rlabLibService")
	private RlabLibService rlabLibService;

	static final Logger LOGGER = LogManager.getLogger(RlabLibController.class);

	//분석 공지사항 시작
	/*리스트 화면 호출*/
	@RequestMapping(value="/rlab/lib/retrievePubNoticeList.do")
	public String rlabNoticeList(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			) throws Exception{

		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);

		LOGGER.debug("###########################################################");
		LOGGER.debug("RlabNoticeController - RlabNoticeList [공지사항 리스트 호출]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		model.addAttribute("inputData", input);

		return "web/rlab/lib/retrieveRlabNoticeList";
	}

	/*리스트*/
	@RequestMapping(value="/rlab/lib/getRlabNoticeList.do")
	public ModelAndView getRlabNoticeList(
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
		LOGGER.debug("RlabNoticeController - getRlabNoticeList [공지사항 리스트 검색]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		ModelAndView modelAndView = new ModelAndView("ruiView");

        // 공지사항 리스트 조회
		List<Map<String,Object>> rlabNoticeList = rlabLibService.getRlabLibList(input);

		modelAndView.addObject("rlabNoticeDataSet", RuiConverter.createDataset("rlabNoticeDataSet", rlabNoticeList));
		return modelAndView;
	}


	/*등록,수정 화면 호출*/
	@RequestMapping(value="/rlab/lib/rlabNoticeRgst.do")
	public String rlabNoticeRgst(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			) throws Exception{

		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);

		LOGGER.debug("###########################################################");
		LOGGER.debug("RlabNoticeController - RlabNoticeRgst [공지사항 등록 화면 호출]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		model.addAttribute("inputData", input);

		return "web/rlab/lib/rlabNoticeRgst";
	}

	/** 등록 **/
	@RequestMapping(value="/rlab/lib/insertRlabNoticeInfo.do")
	public ModelAndView insertRlabNoticeInfo(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
		LOGGER.debug("###########################################################");
		LOGGER.debug("RlabNoticeController - insertRlabNoticeInfo [공지사항 저장&업데이트]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		checkSessionRUI(input, session, model);
		ModelAndView modelAndView = new ModelAndView("ruiView");
		HashMap<String, Object> rtnMeaasge = new HashMap<String, Object>();
		NamoMime mime = new NamoMime();

		String rlabLibSbcHtml = "";
		String rlabLibSbcHtml_temp = "";

		// 결과메시지
		rtnMeaasge.put("rtnSt", "S");
		rtnMeaasge.put("rtnMsg", "저장 되었습니다.");
		rtnMeaasge.put("bbsId", "");

		int totCnt = 0;    							//전체건수
		List<Map<String, Object>> RlabNoticeRgstDataSetList;	// 변경데이터

		try
		{

			String uploadUrl = "";
			String uploadPath = "";

            uploadUrl =  configService.getString("KeyStore.UPLOAD_URL") + configService.getString("KeyStore.UPLOAD_ANL");   // 파일명에 세팅되는 경로
            uploadPath = configService.getString("KeyStore.UPLOAD_BASE") + configService.getString("KeyStore.UPLOAD_ANL");  // 파일이 실제로 업로드 되는 경로

            mime.setSaveURL(uploadUrl);
            mime.setSavePath(uploadPath);
            //mime.decode(input.get("bbsSbc").toString());                  // MIME 디코딩
            //mime.saveFileAtPath(uploadPath+File.separator);

            //rlabLibSbcHtml = mime.getBodyContent();
            //rlabLibSbcHtml_temp = CommonUtil.replaceSecOutput(CommonUtil.replace(CommonUtil.replace(rlabLibSbcHtml, "<", "@![!@"),">","@!]!@"));

			// 저장&수정
			String bbsId = "";
			RlabNoticeRgstDataSetList = RuiConverter.convertToDataSet(request,"rlabNoticeRgstDataSet");

			for(Map<String,Object> rlabNoticeRgstDataSetMap : RlabNoticeRgstDataSetList) {

				rlabNoticeRgstDataSetMap.put("_userId" , NullUtil.nvl(input.get("_userId"), ""));
				rlabNoticeRgstDataSetMap.put("bbsSbc" , input.get("bbsSbc").toString());

				rlabLibService.insertRlabLibInfo(rlabNoticeRgstDataSetMap);
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

	@RequestMapping(value="/rlab/lib/rlabNoticeInfo.do")
	public String rlabNoticeInfo(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			) throws Exception{

		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);

		LOGGER.debug("###########################################################");
		LOGGER.debug("RlabNoticeController - RlabNoticeRgst [공지사항 상세 화면 호출]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		model.addAttribute("inputData", input);

		return "web/rlab/lib/rlabNoticeInfo";
	}

	@RequestMapping(value="/rlab/lib/getRlabNoticeInfo.do")
	public ModelAndView getRlabNoticeInfo(
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
		LOGGER.debug("RlabNoticeController - getRlabNoticeList [공지사항 상세]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		ModelAndView modelAndView = new ModelAndView("ruiView");

		if(NullUtil.isNull(input.get("_userId")) ||  NullUtil.nvl(input.get("_userId"), "").equals("-1")  ){
			String rtnMsg = messageSourceAccessor.getMessage("msg.alert.sessionTimeout");
			SayMessage.setMessage(rtnMsg);
			modelAndView.addObject("rlabNoticeDataSet", null);
        } else {
        	// 공지사항 상세 조회
	        Map<String,Object> resultMap = rlabLibService.getRlabLibInfo(input);

	        modelAndView.addObject("rlabNoticeInfoDataSet", RuiConverter.createDataset("rlabNoticeInfoDataSet", resultMap));
        }
		return modelAndView;
	}

	/** 공지사항 삭제 **/
	@RequestMapping(value="/rlab/lib/deleteRlabNoticeInfo.do")
	public ModelAndView deleteRlabNoticeInfo(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
		LOGGER.debug("#################################################################################################");
		LOGGER.debug("RlabNoticeController - deleteRlabNoticeInfo [공지사항 삭제]");
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
			rlabLibService.deleteRlabLibInfo(input);

		} catch (Exception e) {
			e.printStackTrace();
			rtnMeaasge.put("rtnSt", "F");
			rtnMeaasge.put("rtnMsg", "삭제가 실패하였습니다.");
		}

		modelAndView.addObject("trResultDataSet", RuiConverter.createDataset("trResultDataSet", rtnMeaasge));
		return modelAndView;
	}

	/** 게시글 조회건수 증가 **/
	@RequestMapping(value="/rlab/lib/updateRlabNoticeRtrvCnt.do")
	public ModelAndView updateRlabNoticeRtrvCnt(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
		LOGGER.debug("#################################################################################################");
		LOGGER.debug("RlabNoticeController - updateRlabNoticeRtrvCnt [공지사항 조회건수증가]");
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
			rlabLibService.updateRlabLibRtrvCnt(input);

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
	@RequestMapping(value="/rlab/lib/retrieveRlabLibList.do")
	public String rlabLibList(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			) throws Exception{

		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);

		LOGGER.debug("###########################################################");
		LOGGER.debug("RlabLibController - RlabLibList [분석자료실 리스트 호출]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		model.addAttribute("inputData", input);

		return "web/rlab/lib/retrieveRlabLibList";
	}

	/*TAB 화면 호출*/
	@RequestMapping(value="/rlab/lib/rlabLibTab.do")
	public String rlabLibTab(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			) throws Exception{

		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);

		LOGGER.debug("###########################################################");
		LOGGER.debug("RlabLibController - RlabLibTabList [분석자료실 TAB 리스트 호출]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		model.addAttribute("inputData", input);

		return "web/rlab/lib/rlabLibTab";
	}

	/*리스트*/
	@RequestMapping(value="/rlab/lib/getRlabLibList.do")
	public ModelAndView getRlabLibList(
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
		LOGGER.debug("RlabLibController - getRlabLibList [분석자료실 리스트 검색]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		ModelAndView modelAndView = new ModelAndView("ruiView");

        // 분석자료실 리스트 조회
		List<Map<String,Object>> rlabLibList = rlabLibService.getRlabLibList(input);

		modelAndView.addObject("rlabLibDataSet", RuiConverter.createDataset("rlabLibDataSet", rlabLibList));
		return modelAndView;
	}


	/*등록,수정 화면 호출*/
	@RequestMapping(value="/rlab/lib/rlabLibRgst.do")
	public String rlabLibRgst(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			) throws Exception{

		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);

		LOGGER.debug("###########################################################");
		LOGGER.debug("RlabLibController - RlabLibRgst [분석자료실 등록 화면 호출]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		model.addAttribute("inputData", input);

		return "web/rlab/lib/rlabLibRgst";
	}

	/** 등록 **/
	@RequestMapping(value="/rlab/lib/insertRlabLibInfo.do")
	public ModelAndView insertRlabLibInfo(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
		LOGGER.debug("###########################################################");
		LOGGER.debug("RlabLibController - insertRlabLibInfo [분석자료실 저장&업데이트]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		checkSessionRUI(input, session, model);
		ModelAndView modelAndView = new ModelAndView("ruiView");
		HashMap<String, Object> rtnMeaasge = new HashMap<String, Object>();
		NamoMime mime = new NamoMime();

		String rlabLibSbcHtml = "";
		String rlabLibSbcHtml_temp = "";

		// 결과메시지
		rtnMeaasge.put("rtnSt", "S");
		rtnMeaasge.put("rtnMsg", "저장 되었습니다.");
		rtnMeaasge.put("bbsId", "");

		int totCnt = 0;    							//전체건수
		List<Map<String, Object>> RlabLibRgstDataSetList;	// 변경데이터

		try
		{
			String uploadUrl = "";
			String uploadPath = "";

            uploadUrl =  configService.getString("KeyStore.UPLOAD_URL") + configService.getString("KeyStore.UPLOAD_ANL");   // 파일명에 세팅되는 경로
            uploadPath = configService.getString("KeyStore.UPLOAD_BASE") + configService.getString("KeyStore.UPLOAD_ANL");  // 파일이 실제로 업로드 되는 경로

            //mime.setSaveURL(uploadUrl);
            //mime.setSavePath(uploadPath);
            //mime.decode(input.get("bbsSbc").toString());                  // MIME 디코딩
            //mime.saveFileAtPath(uploadPath+File.separator);

            //rlabLibSbcHtml = mime.getBodyContent();
            //rlabLibSbcHtml_temp = CommonUtil.replaceSecOutput(CommonUtil.replace(CommonUtil.replace(rlabLibSbcHtml, "<", "@![!@"),">","@!]!@"));


			// 저장&수정
			String bbsId = "";
			RlabLibRgstDataSetList = RuiConverter.convertToDataSet(request,"rlabLibRgstDataSet");

			for(Map<String,Object> rlabLibRgstDataSetMap : RlabLibRgstDataSetList) {

				rlabLibRgstDataSetMap.put("_userId" , NullUtil.nvl(input.get("_userId"), ""));
				rlabLibRgstDataSetMap.put("bbsSbc" , input.get("bbsSbc").toString());

				rlabLibService.insertRlabLibInfo(rlabLibRgstDataSetMap);
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

	@RequestMapping(value="/rlab/lib/rlabLibInfo.do")
	public String rlabLibInfo(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			) throws Exception{

		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);

		LOGGER.debug("###########################################################");
		LOGGER.debug("RlabLibController - RlabLibRgst [분석자료실 상세 화면 호출]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		model.addAttribute("inputData", input);

		return "web/rlab/lib/rlabLibInfo";
	}

	@RequestMapping(value="/rlab/lib/getRlabLibInfo.do")
	public ModelAndView getRlabLibInfo(
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
		LOGGER.debug("RlabLibController - getRlabLibList [분석자료실 상세]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		ModelAndView modelAndView = new ModelAndView("ruiView");

		if(NullUtil.isNull(input.get("_userId")) ||  NullUtil.nvl(input.get("_userId"), "").equals("-1")  ){
			String rtnMsg = messageSourceAccessor.getMessage("msg.alert.sessionTimeout");
			SayMessage.setMessage(rtnMsg);
			modelAndView.addObject("rlabLibDataSet", null);
        } else {
        	// 분석자료실 상세 조회
	        Map<String,Object> resultMap = rlabLibService.getRlabLibInfo(input);

	        modelAndView.addObject("rlabLibInfoDataSet", RuiConverter.createDataset("rlabLibInfoDataSet", resultMap));
        }
		return modelAndView;
	}

	/** 분석자료실 삭제 **/
	@RequestMapping(value="/rlab/lib/deleteRlabLibInfo.do")
	public ModelAndView deleteRlabLibInfo(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
		LOGGER.debug("#################################################################################################");
		LOGGER.debug("RlabLibController - deleteRlabLibInfo [분석자료실 삭제]");
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
			rlabLibService.deleteRlabLibInfo(input);

		} catch (Exception e) {
			e.printStackTrace();
			rtnMeaasge.put("rtnSt", "F");
			rtnMeaasge.put("rtnMsg", "삭제가 실패하였습니다.");
		}

		modelAndView.addObject("trResultDataSet", RuiConverter.createDataset("trResultDataSet", rtnMeaasge));
		return modelAndView;
	}

	/** 게시글 조회건수 증가 **/
	@RequestMapping(value="/rlab/lib/updateRlabLibRtrvCnt.do")
	public ModelAndView updateRlabLibRtrvCnt(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
		LOGGER.debug("#################################################################################################");
		LOGGER.debug("RlabLibController - updateRlabLibRtrvCnt [분석자료실 조회건수증가]");
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
			rlabLibService.updateRlabLibRtrvCnt(input);

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
	@RequestMapping(value="/rlab/lib/retrieveRlabQnaList.do")
	public String rlabQnaList(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			) throws Exception{

		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);

		LOGGER.debug("###########################################################");
		LOGGER.debug("RlabQnaController - RlabQnaList [분석QnA 리스트 호출]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		model.addAttribute("inputData", input);

		return "web/rlab/lib/retrieveRlabQnaList";
	}

	/*리스트*/
	@RequestMapping(value="/rlab/lib/getRlabQnaList.do")
	public ModelAndView getRlabQnaList(
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
		LOGGER.debug("RlabQnaController - getRlabQnaList [분석QnA 리스트 검색]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		ModelAndView modelAndView = new ModelAndView("ruiView");

        // 일반QnA 리스트 조회
		List<Map<String,Object>> rlabQnaList = rlabLibService.getRlabQnaList(input);

		modelAndView.addObject("rlabQnaDataSet", RuiConverter.createDataset("rlabQnaDataSet", rlabQnaList));
		return modelAndView;
	}


	/*등록,수정 화면 호출*/
	@RequestMapping(value="/rlab/lib/rlabQnaRgst.do")
	public String rlabQnaRgst(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			) throws Exception{

		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);

		LOGGER.debug("###########################################################");
		LOGGER.debug("RlabQnaController - RlabQnaRgst [분석QnA 등록 화면 호출]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		model.addAttribute("inputData", input);

		return "web/rlab/lib/rlabQnaRgst";
	}


	/** 등록 **/
	@RequestMapping(value="/rlab/lib/insertRlabQnaInfo.do")
	public ModelAndView insertRlabQnaInfo(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
		LOGGER.debug("###########################################################");
		LOGGER.debug("RlabQnaController - insertRlabQnaInfo [분석QnA 저장&업데이트]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		checkSessionRUI(input, session, model);
		ModelAndView modelAndView = new ModelAndView("ruiView");
		HashMap<String, Object> rtnMeaasge = new HashMap<String, Object>();
		NamoMime mime = new NamoMime();

		String rlabLibSbcHtml = "";
		String rlabLibSbcHtml_temp = "";

		// 결과메시지
		rtnMeaasge.put("rtnSt", "S");
		rtnMeaasge.put("rtnMsg", "저장 되었습니다.");
		rtnMeaasge.put("bbsId", "");

		int totCnt = 0;    							//전체건수
		List<Map<String, Object>> rlabQnaRgstDataSetList;	//일반QnA 변경데이터

		try{

			String uploadUrl = "";
			String uploadPath = "";

            uploadUrl =  configService.getString("KeyStore.UPLOAD_URL") + configService.getString("KeyStore.UPLOAD_ANL");   // 파일명에 세팅되는 경로
            uploadPath = configService.getString("KeyStore.UPLOAD_BASE") + configService.getString("KeyStore.UPLOAD_ANL");  // 파일이 실제로 업로드 되는 경로

            mime.setSaveURL(uploadUrl);
            mime.setSavePath(uploadPath);
            mime.decode(input.get("bbsSbc").toString());                  // MIME 디코딩
            mime.saveFileAtPath(uploadPath+File.separator);

            rlabLibSbcHtml = mime.getBodyContent();
            rlabLibSbcHtml_temp = CommonUtil.replaceSecOutput(CommonUtil.replace(CommonUtil.replace(rlabLibSbcHtml, "<", "@![!@"),">","@!]!@"));

			//일반QnA 저장&수정
			String bbsId = "";
			rlabQnaRgstDataSetList = RuiConverter.convertToDataSet(request,"rlabQnaRgstDataSet");

			for(Map<String,Object> rlabQnaRgstDataSetMap : rlabQnaRgstDataSetList) {

				rlabQnaRgstDataSetMap.put("_userId" , NullUtil.nvl(input.get("_userId"), ""));
				rlabQnaRgstDataSetMap.put("bbsSbc" , NullUtil.nvl(rlabLibSbcHtml, ""));

				rlabLibService.insertRlabLibInfo(rlabQnaRgstDataSetMap);
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

	@RequestMapping(value="/rlab/lib/rlabQnaInfo.do")
	public String rlabQnadInfo(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			) throws Exception{

		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);

		LOGGER.debug("###########################################################");
		LOGGER.debug("rlabQnaController - rlabQnaRgst [분석QnA 상세 화면 호출]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		model.addAttribute("inputData", input);

		return "web/rlab/lib/rlabQnaInfo";
	}

	@RequestMapping(value="/rlab/lib/getRlabQnaInfo.do")
	public ModelAndView getRlabQnaInfo(
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
		LOGGER.debug("RlabQnaController - getRlabQnaList [분석QnA 상세]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		ModelAndView modelAndView = new ModelAndView("ruiView");

		if(NullUtil.isNull(input.get("_userId")) ||  NullUtil.nvl(input.get("_userId"), "").equals("-1")  ){
			String rtnMsg = messageSourceAccessor.getMessage("msg.alert.sessionTimeout");
			SayMessage.setMessage(rtnMsg);
			modelAndView.addObject("rlabQnaDataSet", null);
        } else {
        	// 일반QnA 상세 조회
	        Map<String,Object> resultMap = rlabLibService.getRlabLibInfo(input);
	        modelAndView.addObject("rlabQnaInfoDataSet", RuiConverter.createDataset("rlabQnaInfoDataSet", resultMap));
        }
		return modelAndView;
	}

	/** 게시글 삭제 **/
	@RequestMapping(value="/rlab/lib/deleteRlabQnaInfo.do")
	public ModelAndView deleteRlabQnaInfo(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
		LOGGER.debug("#################################################################################################");
		LOGGER.debug("RlabQnaController - deleteRlabQnaInfo [분석QnA 삭제]");
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
			rlabLibService.deleteRlabLibInfo(input);

		} catch (Exception e) {
			e.printStackTrace();
			rtnMeaasge.put("rtnSt", "F");
			rtnMeaasge.put("rtnMsg", "삭제가 실패하였습니다.");
		}

		modelAndView.addObject("trResultDataSet", RuiConverter.createDataset("trResultDataSet", rtnMeaasge));
		return modelAndView;
	}

	/** 게시글 조회건수 증가 **/
	@RequestMapping(value="/rlab/lib/updateRlabQnaRtrvCnt.do")
	public ModelAndView updateRlabQnaRtrvCnt(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
		LOGGER.debug("#################################################################################################");
		LOGGER.debug("RlabQnaController - updateRlabQnaRtrvCnt [분석QnA 조회건수증가]");
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
			rlabLibService.updateRlabLibRtrvCnt(input);

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
	@RequestMapping(value="/rlab/lib/retrieveRlabQnaRebList.do")
	public String rlabQnaRebList(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			) throws Exception{

		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);

		LOGGER.debug("###########################################################");
		LOGGER.debug("RlabQnaController - RlabQnaRebList [분석QnA 덧글 리스트 호출]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		model.addAttribute("inputData", input);

		return "web/rlab/lib/retrieveRlabQnaRebList";
	}

	/*덧글 리스트*/
	@RequestMapping(value="/rlab/lib/getRlabQnaRebList.do")
	public ModelAndView getRlabQnaRebList(
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
		LOGGER.debug("RlabQnaController - getRlabQnaRebList [분석QnA 덧글 리스트 검색]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		String bbsId = (String)input.get("bbsId");
        // 일반QnA 리스트 조회
		List<Map<String,Object>> rlabQnaRebList = rlabLibService.getRlabQnaRebList(input);

		modelAndView.addObject("rlabQnaRebDataSet", RuiConverter.createDataset("rlabQnaRebDataSet", rlabQnaRebList));
		return modelAndView;
	}


	/*덧글 등록,수정 화면 호출*/
	@RequestMapping(value="/rlab/lib/rlabQnaRebRgst.do")
	public String rlabQnaRebRgst(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			) throws Exception{

		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);

		LOGGER.debug("###########################################################");
		LOGGER.debug("RlabQnaController - RlabQnaRgst [분석QnA 덧글 등록 화면 호출]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		model.addAttribute("inputData", input);

		return "web/rlab/lib/rlabQnaRebRgst";
	}

	/** 덧글 등록 **/
	@RequestMapping(value="/rlab/lib/insertRlabQnaRebInfo.do")
	public ModelAndView insertRlabQnaRebInfo(
			@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
		LOGGER.debug("###########################################################");
		LOGGER.debug("RlabQnaController - insertRlabQnaRebInfo [덧글 저장]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		checkSessionObjRUI(input, session, model);
		ModelAndView modelAndView = new ModelAndView("ruiView");
		HashMap<String, Object> rtnMeaasge = new HashMap<String, Object>();

		// 결과메시지
		rtnMeaasge.put("rtnSt", "S");
		rtnMeaasge.put("rtnMsg", "저장 되었습니다.");

		try	{
			rlabLibService.insertRlabQnaRebInfo(input);
		} catch (Exception e) {
			e.printStackTrace();
			rtnMeaasge.put("rtnSt", "F");
			rtnMeaasge.put("rtnMsg", "저장이 실패하였습니다.");
		}

		modelAndView.addObject("resultDataSet", RuiConverter.createDataset("resultDataSet", rtnMeaasge));
		return modelAndView;
	}

	/** 덧글 수정 **/
	@RequestMapping(value="/rlab/lib/updateRlabQnaRebInfo.do")
	public ModelAndView updateRlabQnaRebInfo(
			@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
		LOGGER.debug("###########################################################");
		LOGGER.debug("RlabQnaController - updateRlabQnaRebInfo [덧글 업데이트]");
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
			List<Map<String, Object>> rlabQnaRebDataSetList = RuiConverter.convertToDataSet(request,"rlabQnaRebInfoDataSet");

			for(Map<String, Object> data : rlabQnaRebDataSetList) {
				data.put("_userId", input.get("_userId"));
			};

			rlabLibService.updateRlabQnaRebInfo(rlabQnaRebDataSetList);
		} catch (Exception e) {
			e.printStackTrace();
			rtnMeaasge.put("rtnSt", "F");
			rtnMeaasge.put("rtnMsg", "저장이 실패하였습니다.");
		}

		modelAndView.addObject("resultDataSet", RuiConverter.createDataset("resultDataSet", rtnMeaasge));
		return modelAndView;
	}

	/** 덧글 삭제 **/
	@RequestMapping(value="/rlab/lib/deleteRlabQnaRebInfo.do")
	public ModelAndView deleteRlabQnaRebInfo(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
		LOGGER.debug("#################################################################################################");
		LOGGER.debug("RlabQnaController - deleteRlabQnaRebInfo [분석QnA 덧글 삭제]");
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
			rlabLibService.deleteRlabQnaRebInfo(input);

		} catch (Exception e) {
			e.printStackTrace();
			rtnMeaasge.put("rtnSt", "F");
			rtnMeaasge.put("rtnMsg", "삭제가 실패하였습니다.");
		}

		modelAndView.addObject("trResultDataSet", RuiConverter.createDataset("trResultDataSet", rtnMeaasge));
		return modelAndView;
	}

	@RequestMapping(value="/rlab/lib/rlabNoticeInfoSrchView.do")
	public String rlabNoticeInfoSrchView(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			) throws Exception{

		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);

		LOGGER.debug("###########################################################");
		LOGGER.debug("RlabQnaController - rlabNoticeInfoSrchView [분석 3게시판 상세 화면 호출]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		model.addAttribute("inputData", input);
		return "web/rlab/lib/rlabNoticeInfoSrchView";
	}

	//분석 Qna 끝
	
    @RequestMapping(value="/rlab/lib/rlabBbsCodeList.do")
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
        
        System.out.println("\n\n input : "+input);
        
        //List codeList = anlBbsService.anlBbsCodeList(NullUtil.nvl(input.get("comCd"), ""));
        List codeList = rlabLibService.rlabBbsCodeList(input);
         
        modelAndView.addObject("radioDataSet", RuiConverter.createDataset("codeList", codeList));

        return modelAndView;
    }

}//class end
