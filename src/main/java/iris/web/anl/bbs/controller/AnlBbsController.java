package iris.web.anl.bbs.controller;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang.StringUtils;
import org.apache.logging.log4j.LogManager; import org.apache.logging.log4j.Logger;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import devonframe.configuration.ConfigService;
import devonframe.mail.MailSender;
import devonframe.mail.MailSenderFactory;
import devonframe.message.saymessage.SayMessage;
import devonframe.util.NullUtil;
import iris.web.common.code.service.CodeCacheManager;
import iris.web.common.converter.RuiConverter;
import iris.web.common.util.CommonUtil;
import iris.web.common.util.DateUtil;
import iris.web.common.util.NamoMime;
import iris.web.common.util.StringUtil;
import iris.web.prj.mm.mail.service.MmMailService;
import iris.web.prj.mm.mail.vo.MmMailVo;
import iris.web.anl.bbs.service.AnlBbsService;
import iris.web.system.base.IrisBaseController;
import iris.web.system.user.service.IrisUserService;

/********************************************************************************
 * NAME : AnlBbsController.java
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
public class AnlBbsController  extends IrisBaseController {

	@Resource(name="messageSourceAccessor")
	private MessageSourceAccessor messageSourceAccessor;

	@Resource(name = "codeCacheManager")
	private CodeCacheManager codeCacheManager;

	@Resource(name = "configService")
    private ConfigService configService;

	@Resource(name = "anlBbsService")
	private AnlBbsService anlBbsService;
	
	@Resource(name="mmMailService")
	private MmMailService mmMailService;			// MmMail 서비스
	
	@Resource(name="mailSenderFactory")
	private MailSenderFactory mailSenderFactory;	// 메일전송 팩토리

	@Resource(name="irisUserService")
	private IrisUserService irisUserService;		// 유저조회 서비스

	static final Logger LOGGER = LogManager.getLogger(AnlBbsController.class);

	//분석자료실 시작
	/*리스트 화면 호출*/
	@RequestMapping(value="/anl/bbs/retrieveAnlBbsList.do")
	public String anlBbsList(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			) throws Exception{

		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);

		LOGGER.debug("###########################################################");
		LOGGER.debug("AnlBbsController - AnlBbsList [분석자료실 리스트 호출]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		model.addAttribute("inputData", input);

		return "web/anl/bbs/retrieveAnlBbsList";
	}
	
	/*TAB 화면 호출*/
	@RequestMapping(value="/anl/bbs/anlBbsTab.do")
	public String anlBbsTab(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			) throws Exception{

		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);
		
		LOGGER.debug("###########################################################");
		LOGGER.debug("AnlBbsController - AnlBbsTabList [분석자료실 TAB 리스트 호출]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		model.addAttribute("inputData", input);

		return "web/anl/bbs/anlBbsTab";
	}
	
	/*리스트*/
	@RequestMapping(value="/anl/bbs/getAnlBbsList.do")
	public ModelAndView getAnlBbsList(
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
		LOGGER.debug("AnlBbsController - getAnlBbsList [분석자료실 리스트 검색]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		ModelAndView modelAndView = new ModelAndView("ruiView");

        // 분석자료실 리스트 조회
		List<Map<String,Object>> anlBbsList = anlBbsService.getAnlBbsList(input);

		modelAndView.addObject("anlBbsDataSet", RuiConverter.createDataset("anlBbsDataSet", anlBbsList));
		return modelAndView;
	}
	
	/*등록,수정 화면 호출*/
	@RequestMapping(value="/anl/bbs/anlBbsRgst.do")
	public String anlBbsRgst(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			) throws Exception{

		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);

		LOGGER.debug("###########################################################");
		LOGGER.debug("AnlBbsController - AnlBbsRgst [분석자료실 등록 화면 호출]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		model.addAttribute("inputData", input);

		return "web/anl/bbs/anlBbsRgst";
	}
	
	/** 등록 **/
	@RequestMapping(value="/anl/bbs/insertAnlBbsInfo.do")
	public ModelAndView insertAnlBbsInfo(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
		LOGGER.debug("###########################################################");
		LOGGER.debug("AnlBbsController - insertAnlBbsInfo [분석자료실 저장&업데이트]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		checkSessionRUI(input, session, model);
		ModelAndView modelAndView = new ModelAndView("ruiView");
		HashMap<String, Object> rtnMeaasge = new HashMap<String, Object>();
		NamoMime mime = new NamoMime();

		String anlBbsSbcHtml = "";
		String anlBbsSbcHtml_temp = "";

		// 결과메시지
		rtnMeaasge.put("rtnSt", "S");
		rtnMeaasge.put("rtnMsg", "저장 되었습니다.");
		rtnMeaasge.put("bbsId", "");

		int totCnt = 0;    							//전체건수
		List<Map<String, Object>> anlBbsRgstDataSetList;	// 변경데이터

		try
		{
			String uploadUrl = "";
			String uploadPath = "";

            uploadUrl =  configService.getString("KeyStore.UPLOAD_URL") + configService.getString("KeyStore.UPLOAD_ANL");   // 파일명에 세팅되는 경로
            uploadPath = configService.getString("KeyStore.UPLOAD_BASE") + configService.getString("KeyStore.UPLOAD_ANL");  // 파일이 실제로 업로드 되는 경로
            
            System.out.println("bbsSbc : "+input.get("bbsSbc").toString());

            mime.setSaveURL(uploadUrl);
            mime.setSavePath(uploadPath);
            //mime.decode(input.get("bbsSbc").toString());                  // MIME 디코딩
            //mime.saveFileAtPath(uploadPath+File.separator);

            //anlBbsSbcHtml = mime.getBodyContent();
            //anlBbsSbcHtml_temp = CommonUtil.replaceSecOutput(CommonUtil.replace(CommonUtil.replace(anlBbsSbcHtml, "<", "@![!@"),">","@!]!@"));


			// 저장&수정
			String bbsId = "";
			anlBbsRgstDataSetList = RuiConverter.convertToDataSet(request,"anlBbsRgstDataSet");
			
			
			System.out.println("\n\n anlBbsRgstDataSetList : "+anlBbsRgstDataSetList);
			

			for(Map<String,Object> anlBbsRgstDataSetMap : anlBbsRgstDataSetList) {

				anlBbsRgstDataSetMap.put("_userId" , NullUtil.nvl(input.get("_userId"), ""));
				anlBbsRgstDataSetMap.put("bbsSbc" ,input.get("bbsSbc").toString());

				anlBbsService.insertAnlBbsInfo(anlBbsRgstDataSetMap);
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

	@RequestMapping(value="/anl/bbs/anlBbsInfo.do")
	public String anlBbsInfo(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			) throws Exception{

		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);

		LOGGER.debug("###########################################################");
		LOGGER.debug("AnlBbsController - AnlBbsRgst [분석자료실 상세 화면 호출]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		model.addAttribute("inputData", input);

		return "web/anl/bbs/anlBbsInfo";
	}

	@RequestMapping(value="/anl/bbs/getAnlBbsInfo.do")
	public ModelAndView getAnlBbsInfo(
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
		LOGGER.debug("AnlBbsController - getAnlBbsList [분석자료실 상세]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		ModelAndView modelAndView = new ModelAndView("ruiView");

		if(NullUtil.isNull(input.get("_userId")) ||  NullUtil.nvl(input.get("_userId"), "").equals("-1")  ){
			String rtnMsg = messageSourceAccessor.getMessage("msg.alert.sessionTimeout");
			SayMessage.setMessage(rtnMsg);
			modelAndView.addObject("anlBbsDataSet", null);
        } else {
        	// 분석자료실 상세 조회
	        Map<String,Object> resultMap = anlBbsService.getAnlBbsInfo(input);

	        modelAndView.addObject("anlBbsInfoDataSet", RuiConverter.createDataset("anlBbsInfoDataSet", resultMap));
        }
		return modelAndView;
	}

	/** 분석자료실 삭제 **/
	@RequestMapping(value="/anl/bbs/deleteAnlBbsInfo.do")
	public ModelAndView deleteAnlBbsInfo(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
		LOGGER.debug("#################################################################################################");
		LOGGER.debug("AnlBbsController - deleteAnlBbsInfo [분석자료실 삭제]");
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
			anlBbsService.deleteAnlBbsInfo(input);

		} catch (Exception e) {
			e.printStackTrace();
			rtnMeaasge.put("rtnSt", "F");
			rtnMeaasge.put("rtnMsg", "삭제가 실패하였습니다.");
		}

		modelAndView.addObject("trResultDataSet", RuiConverter.createDataset("trResultDataSet", rtnMeaasge));
		return modelAndView;
	}

	/** 게시글 조회건수 증가 **/
	@RequestMapping(value="/anl/bbs/updateAnlBbsRtrvCnt.do")
	public ModelAndView updateAnlBbsRtrvCnt(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
		LOGGER.debug("#################################################################################################");
		LOGGER.debug("AnlBbsController - updateAnlBbsRtrvCnt [분석자료실 조회건수증가]");
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
			anlBbsService.updateAnlBbsRtrvCnt(input);

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
	@RequestMapping(value="/anl/bbs/retrieveAnlQnaList.do")
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

		return "web/anl/bbs/retrieveAnlQnaList";
	}
	
	/*TAB 화면 호출*/
	@RequestMapping(value="/anl/bbs/anlQnaTab.do")
	public String anlQnaTab(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			) throws Exception{

		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);
		
		LOGGER.debug("###########################################################");
		LOGGER.debug("AnlBbsController - AnlBbsTabList [분석자료실 TAB 리스트 호출]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		model.addAttribute("inputData", input);

		return "web/anl/bbs/anlQnaTab";
	}

	/*리스트*/
	@RequestMapping(value="/anl/bbs/getAnlQnaList.do")
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
		List<Map<String,Object>> anlQnaList = anlBbsService.getAnlQnaList(input);

		modelAndView.addObject("anlQnaDataSet", RuiConverter.createDataset("anlQnaDataSet", anlQnaList));
		return modelAndView;
	}


	/*등록,수정 화면 호출*/
	@RequestMapping(value="/anl/bbs/anlQnaRgst.do")
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

		return "web/anl/bbs/anlQnaRgst";
	}


	/** 등록 **/
	@RequestMapping(value="/anl/bbs/insertAnlQnaInfo.do")
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

		String anlBbsSbcHtml = "";
		String anlBbsSbcHtml_temp = "";

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
            //mime.decode(input.get("bbsSbc").toString());                  // MIME 디코딩
            //mime.saveFileAtPath(uploadPath+File.separator);

            //anlBbsSbcHtml = mime.getBodyContent();
            //anlBbsSbcHtml_temp = CommonUtil.replaceSecOutput(CommonUtil.replace(CommonUtil.replace(anlBbsSbcHtml, "<", "@![!@"),">","@!]!@"));

			//일반QnA 저장&수정
			String bbsId = "";
			anlQnaRgstDataSetList = RuiConverter.convertToDataSet(request,"anlQnaRgstDataSet");

			for(Map<String,Object> anlQnaRgstDataSetMap : anlQnaRgstDataSetList) {

				anlQnaRgstDataSetMap.put("_userId" , NullUtil.nvl(input.get("_userId"), ""));
				anlQnaRgstDataSetMap.put("bbsSbc" , input.get("bbsSbc").toString());

				anlBbsService.insertAnlBbsInfo(anlQnaRgstDataSetMap);
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

	@RequestMapping(value="/anl/bbs/anlQnaInfo.do")
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

		return "web/anl/bbs/anlQnaInfo";
	}

	@RequestMapping(value="/anl/bbs/getAnlQnaInfo.do")
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
	        Map<String,Object> resultMap = anlBbsService.getAnlBbsInfo(input);
	        modelAndView.addObject("anlQnaInfoDataSet", RuiConverter.createDataset("anlQnaInfoDataSet", resultMap));
        }
		return modelAndView;
	}

	/** 게시글 삭제 **/
	@RequestMapping(value="/anl/bbs/deleteAnlQnaInfo.do")
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
			anlBbsService.deleteAnlBbsInfo(input);

		} catch (Exception e) {
			e.printStackTrace();
			rtnMeaasge.put("rtnSt", "F");
			rtnMeaasge.put("rtnMsg", "삭제가 실패하였습니다.");
		}

		modelAndView.addObject("trResultDataSet", RuiConverter.createDataset("trResultDataSet", rtnMeaasge));
		return modelAndView;
	}

	/** 게시글 조회건수 증가 **/
	@RequestMapping(value="/anl/bbs/updateAnlQnaRtrvCnt.do")
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
			anlBbsService.updateAnlBbsRtrvCnt(input);

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
	@RequestMapping(value="/anl/bbs/retrieveAnlQnaRebList.do")
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

		return "web/anl/bbs/retrieveAnlQnaRebList";
	}

	/*덧글 리스트*/
	@RequestMapping(value="/anl/bbs/getAnlQnaRebList.do")
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
		List<Map<String,Object>> anlQnaRebList = anlBbsService.getAnlQnaRebList(input);

		modelAndView.addObject("anlQnaRebDataSet", RuiConverter.createDataset("anlQnaRebDataSet", anlQnaRebList));
		return modelAndView;
	}


	/*덧글 등록,수정 화면 호출*/
	@RequestMapping(value="/anl/bbs/anlQnaRebRgst.do")
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

		return "web/anl/bbs/anlQnaRebRgst";
	}

	/** 덧글 등록 **/
	@RequestMapping(value="/anl/bbs/insertAnlQnaRebInfo.do")
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
			anlBbsService.insertAnlQnaRebInfo(input);
		} catch (Exception e) {
			e.printStackTrace();
			rtnMeaasge.put("rtnSt", "F");
			rtnMeaasge.put("rtnMsg", "저장이 실패하였습니다.");
		}

		modelAndView.addObject("resultDataSet", RuiConverter.createDataset("resultDataSet", rtnMeaasge));
		return modelAndView;
	}

	/** 덧글 수정 **/
	@RequestMapping(value="/anl/bbs/updateAnlQnaRebInfo.do")
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

			anlBbsService.updateAnlQnaRebInfo(anlQnaRebDataSetList);
		} catch (Exception e) {
			e.printStackTrace();
			rtnMeaasge.put("rtnSt", "F");
			rtnMeaasge.put("rtnMsg", "저장이 실패하였습니다.");
		}

		modelAndView.addObject("resultDataSet", RuiConverter.createDataset("resultDataSet", rtnMeaasge));
		return modelAndView;
	}

	/** 덧글 삭제 **/
	@RequestMapping(value="/anl/bbs/deleteAnlQnaRebInfo.do")
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
			anlBbsService.deleteAnlQnaRebInfo(input);

		} catch (Exception e) {
			e.printStackTrace();
			rtnMeaasge.put("rtnSt", "F");
			rtnMeaasge.put("rtnMsg", "삭제가 실패하였습니다.");
		}

		modelAndView.addObject("trResultDataSet", RuiConverter.createDataset("trResultDataSet", rtnMeaasge));
		return modelAndView;
	}

    @RequestMapping(value="/anl/bbs/anlBbsCodeList.do")
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
        List codeList = anlBbsService.anlBbsCodeList(input);
         
        modelAndView.addObject("radioDataSet", RuiConverter.createDataset("codeList", codeList));

        return modelAndView;
    } 
    
	/* 메일 팝업 화면이동 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/anl/bbs/sendMailPopup.do")
	public String sendMailPopupView(
			@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
		LOGGER.debug("#####################################################################################");
		LOGGER.debug("MmMailController - sendMailPopupView [메일 팝업 화면이동]");
		LOGGER.debug("loginUser => " + model.get("loginUser"));
		LOGGER.debug("inputData => " + input);
		LOGGER.debug("#####################################################################################");

		checkSessionObjRUI(input, session, model);
		input = StringUtil.toUtf8(input);
		if(NullUtil.isNull(input.get("_userId")) ||  NullUtil.nvl(input.get("_userId"), "").equals("-1")  ){
			String rtnMsg = messageSourceAccessor.getMessage("msg.alert.sessionTimeout");
			SayMessage.setMessage(rtnMsg);
        } else {

        	// 파라미터로 넘어온 유저리스트 조회
        	if(!"".equals(  NullUtil.nvl(input.get("userIds"),""))){
	        	String[] userIdArr = (NullUtil.nvl(input.get("userIds"),"")).split(",");
	        	List<String> userIdList = new ArrayList<String>();

	        	for(String userId : userIdArr) {
	        		userIdList.add(userId);
	        	}
	        	input.put("userIdList", userIdList);

	        	if(userIdList.size() > 0) {

		        	List<Map<String,Object>>  userList = irisUserService.getUserList(input);
		        	String[] userArr = new String[userList.size()];
		        	String[] userNameArr = new String[userList.size()];
		        	String[] userMailArr = new String[userList.size()];

		        	for(int i=0;i<userList.size();i++) {

		        		userArr[i] = NullUtil.nvl(userList.get(i).get("saUser"),"");
		        		userNameArr[i] = NullUtil.nvl(userList.get(i).get("saName"),"");
		        		userMailArr[i] = NullUtil.nvl(userList.get(i).get("saMail"),"");
		        	}

		        	input.put("userIds", StringUtils.join(userArr,","));
		        	input.put("userNames", StringUtils.join(userNameArr,", "));
		        	input.put("userMails", StringUtils.join(userMailArr,","));
	        	}
        	}
        	
        	Map<String,Object> resultMap = anlBbsService.getAnlBbsInfo(input);
        	
        	input.put("bbsTitl", resultMap.get("bbsTitl"));
        	input.put("bbsSbc", resultMap.get("bbsSbc"));

        	model.addAttribute("inputData", input);
        }

		return "web/anl/bbs/sendMailPopup";
	}

	/** 메일발송 **/
	@RequestMapping(value="/anl/bbs/sendMail.do")
	public ModelAndView simpleSendMail(
			@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
		LOGGER.debug("################################################################");
		LOGGER.debug("AnlBbsController - simpleSendMail [메일보내기]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("################################################################");
		
		MmMailVo vo = new MmMailVo();
		
		checkSessionObjRUI(input, session, model);
		ModelAndView modelAndView = new ModelAndView("ruiView");
		model.addAttribute("inputData", input);
		MailSender mailSender = null;
		String[] receiverNameList = null;
		String[] receiverMailList = null;
		List<HashMap<String, Object>> sndMailList = new ArrayList<HashMap<String, Object>>();	// 메일발송정보리스트

		String rtnMsg = "발송에 성공하였습니다.";	// 결과메시지

		try {
			receiverNameList = NullUtil.nvl(input.get("receiverNameList"),"").split(",");
			receiverMailList = NullUtil.nvl(input.get("receiverMailList"),"").split(",");

			mailSender = mailSenderFactory.createMailSender();
			
			for(String receiverMailAdd : receiverMailList) {
				mailSender.setFromMailAddress( NullUtil.nvl(input.get("hSenderEmail"),""), NullUtil.nvl(input.get("hSenderName"),""));
				mailSender.setToMailAddress(receiverMailAdd);
				mailSender.setSubject(NullUtil.nvl(input.get("mailTitle"),""));
	//			mailSender.setText(NullUtil.nvl(input.get("mailText"),""));
				vo.setMailTitle(NullUtil.nvl(input.get("mailTitle"),""));
				vo.setMailText(NullUtil.nvl(input.get("bbsSbc"),""));
				// mailSender-context.xml에 설정한 메일 template의 bean id값과 치환시 사용될 VO클래스를 넘김
				mailSender.setHtmlTemplate("prjSendMailPopup", vo);
				mailSender.send();
				
				HashMap<String, Object> mailMap = new HashMap<String, Object>();
				mailMap.put("mailTitl", NullUtil.nvl(input.get("mailTitle").toString(),""));
				mailMap.put("adreMail", receiverMailAdd );
				mailMap.put("trrMail", NullUtil.nvl(input.get("hSenderEmail"),""));
				mailMap.put("_userId", input.get("_userId").toString());
				sndMailList.add(mailMap);
			}
			
			mmMailService.insertMailSndHis(sndMailList);

		} catch (Exception e) {
			e.printStackTrace();
			rtnMsg = "발송에 실패하였습니다.";	// 결과메시지
		}

		input.put("rtnMsg", rtnMsg);
        modelAndView.addObject("dataset", RuiConverter.createDataset("dataset", input));
        
        LOGGER.debug("################# MAIL SEND RESULT ###############################################");
        LOGGER.debug("result input = > " + input);
        LOGGER.debug("receiverNameList length = > " + receiverNameList.length);
        LOGGER.debug("receiverMailList length = > " + receiverMailList.length);
        LOGGER.debug("################# MAIL SEND RESULT ###############################################");

		return modelAndView;
	}    

}//class end
