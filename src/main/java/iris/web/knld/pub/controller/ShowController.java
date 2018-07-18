package iris.web.knld.pub.controller;

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
import iris.web.knld.pub.service.ShowService;
import iris.web.system.base.IrisBaseController;

/********************************************************************************
 * NAME : ShowController.java
 * DESC : 전시회 관리 controller
 * PROJ : IRIS UPGRADE 1차 프로젝트
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION
 * ----------  ------  ---------------------------------------------------------
 * 2017.09.13  			최초생성
 *********************************************************************************/

@Controller
public class ShowController  extends IrisBaseController {

	@Resource(name="messageSourceAccessor")
	private MessageSourceAccessor messageSourceAccessor;

	@Resource(name = "codeCacheManager")
	private CodeCacheManager codeCacheManager;

	@Resource(name = "configService")
    private ConfigService configService;

	@Resource(name = "showService")
	private ShowService showService;

	static final Logger LOGGER = LogManager.getLogger(ShowController.class);

	/*리스트 화면 호출*/
	@RequestMapping(value="/knld/pub/retrieveShowList.do")
	public String showList(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			) throws Exception{

		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);

		LOGGER.debug("###########################################################");
		LOGGER.debug("ShowController - ShowList [전시회 리스트 호출]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		model.addAttribute("inputData", input);

		return "web/knld/pub/retrieveShowList";
	}

	/*리스트*/
	@RequestMapping(value="/knld/pub/getShowList.do")
	public ModelAndView getShowList(
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
		LOGGER.debug("ShowController - getShowList [전시회 리스트 검색]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		ModelAndView modelAndView = new ModelAndView("ruiView");

        // 교육세미나 리스트 조회
		List<Map<String,Object>> showList = showService.getShowList(input);

		modelAndView.addObject("showDataSet", RuiConverter.createDataset("showDataSet", showList));
		return modelAndView;
	}


	/*등록,수정 화면 호출*/
	@RequestMapping(value="/knld/pub/showRgst.do")
	public String showRgst(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			) throws Exception{

		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);

		LOGGER.debug("###########################################################");
		LOGGER.debug("ShowController - ShowRgst [전시회 등록 화면 호출]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		model.addAttribute("inputData", input);

		return "web/knld/pub/showRgst";
	}

	/** 등록 **/
	@RequestMapping(value="/knld/pub/insertShowInfo.do")
	public ModelAndView insertShowInfo(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
		LOGGER.debug("###########################################################");
		LOGGER.debug("ShowController - insertShowInfo [전시회 저장&업데이트]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		checkSessionRUI(input, session, model);
		ModelAndView modelAndView = new ModelAndView("ruiView");
		HashMap<String, Object> rtnMeaasge = new HashMap<String, Object>();
		NamoMime mime = new NamoMime();

		String showSbcHtml = "";
		String showSbcHtml_temp = "";


		// 결과메시지
		rtnMeaasge.put("rtnSt", "S");
		rtnMeaasge.put("rtnMsg", "저장 되었습니다.");
		rtnMeaasge.put("showId", "");

		int totCnt = 0;    							//전체건수
		List<Map<String, Object>> showRgstDataSetList;	//교육세미나 변경데이터

		try
		{

			String uploadUrl = "";
			String uploadPath = "";

            uploadUrl =  configService.getString("KeyStore.UPLOAD_URL") + configService.getString("KeyStore.UPLOAD_KNLD");   // 파일명에 세팅되는 경로
            uploadPath = configService.getString("KeyStore.UPLOAD_BASE") + configService.getString("KeyStore.UPLOAD_KNLD");  // 파일이 실제로 업로드 되는 경로

            mime.setSaveURL(uploadUrl);
            mime.setSavePath(uploadPath);
            mime.decode(input.get("sbcNm").toString());                  // MIME 디코딩
            mime.saveFileAtPath(uploadPath+File.separator);

            showSbcHtml = mime.getBodyContent();
            showSbcHtml_temp = CommonUtil.replaceSecOutput(CommonUtil.replace(CommonUtil.replace(showSbcHtml, "<", "@![!@"),">","@!]!@"));


			//교육세미나 저장&수정
			String showId = "";
			showRgstDataSetList = RuiConverter.convertToDataSet(request,"showRgstDataSet");

			for(Map<String,Object> showRgstDataSetMap : showRgstDataSetList) {

				showRgstDataSetMap.put("_userId" , NullUtil.nvl(input.get("_userId"), ""));
				showRgstDataSetMap.put("sbcNm" , NullUtil.nvl(showSbcHtml, ""));

				showService.insertShowInfo(showRgstDataSetMap);
				totCnt++;
			}

			rtnMeaasge.put("showId", showId);

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

	@RequestMapping(value="/knld/pub/showInfo.do")
	public String showInfo(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			) throws Exception{

		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);

		LOGGER.debug("###########################################################");
		LOGGER.debug("ShowController - showInfo [전시회 상세 화면 호출]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		model.addAttribute("inputData", input);

		return "web/knld/pub/showInfo";
	}

	@RequestMapping(value="/knld/pub/getShowInfo.do")
	public ModelAndView getShowInfo(
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
		LOGGER.debug("ShowController - getShowInfo [전시회 상세]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		ModelAndView modelAndView = new ModelAndView("ruiView");

		if(NullUtil.isNull(input.get("_userId")) ||  NullUtil.nvl(input.get("_userId"), "").equals("-1")  ){
			String rtnMsg = messageSourceAccessor.getMessage("msg.alert.sessionTimeout");
			SayMessage.setMessage(rtnMsg);
			modelAndView.addObject("showDataSet", null);
        } else {
        	// 전시회 상세 조회
	        Map<String,Object> resultMap = showService.getShowInfo(input);

	        modelAndView.addObject("showInfoDataSet", RuiConverter.createDataset("showInfoDataSet", resultMap));
        }
		return modelAndView;
	}

	/** 전시회 삭제 **/
	@RequestMapping(value="/knld/pub/deleteShowInfo.do")
	public ModelAndView deleteShowInfo(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
		LOGGER.debug("#################################################################################################");
		LOGGER.debug("ShowController - deleteShowInfo [전시회 삭제]");
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
			showService.deleteShowInfo(input);

		} catch (Exception e) {
			e.printStackTrace();
			rtnMeaasge.put("rtnSt", "F");
			rtnMeaasge.put("rtnMsg", "삭제가 실패하였습니다.");
		}

		modelAndView.addObject("trResultDataSet", RuiConverter.createDataset("trResultDataSet", rtnMeaasge));
		return modelAndView;
	}

	/** 게시글 조회건수 증가 **/
	@RequestMapping(value="/knld/pub/updateShowRtrvCnt.do")
	public ModelAndView updateShowRtrvCnt(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
		LOGGER.debug("#################################################################################################");
		LOGGER.debug("ShowController - updateShowRtrvCnt [전시회 조회건수증가]");
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
			showService.updateShowRtrvCnt(input);

		} catch (Exception e) {
			e.printStackTrace();
			rtnMeaasge.put("rtnSt", "F");
			rtnMeaasge.put("rtnMsg", "조회건수 증가 실패하였습니다.");
		}

		modelAndView.addObject("trResultDataSet", RuiConverter.createDataset("trResultDataSet", rtnMeaasge));
		return modelAndView;
	}

	@RequestMapping(value="/knld/pub/showInfoSrchView.do")
	public String showInfoSrchView(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			) throws Exception{

		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);

		LOGGER.debug("###########################################################");
		LOGGER.debug("ShowController - showInfoSrchView [전시회 뷰 화면 호출]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		model.addAttribute("inputData", input);

		return "web/knld/pub/showInfoSrchView";
	}

}//class end
