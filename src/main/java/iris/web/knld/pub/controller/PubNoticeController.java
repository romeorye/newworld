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
import iris.web.knld.pub.service.PubNoticeService;
import iris.web.system.base.IrisBaseController;

/********************************************************************************
 * NAME : PubNoticeController.java
 * DESC : 지식관리 공지사항 관리 controller
 * PROJ : IRIS UPGRADE 1차 프로젝트
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION
 * ----------  ------  ---------------------------------------------------------
 * 2017.09.08       	최초생성
 *********************************************************************************/

@Controller
public class PubNoticeController  extends IrisBaseController {

	@Resource(name="messageSourceAccessor")
	private MessageSourceAccessor messageSourceAccessor;

	@Resource(name = "codeCacheManager")
	private CodeCacheManager codeCacheManager;

	@Resource(name = "configService")
    private ConfigService configService;

	@Resource(name = "pubNoticeService")
	private PubNoticeService pubNoticeService;

	static final Logger LOGGER = LogManager.getLogger(PubNoticeController.class);

	@RequestMapping(value="/knld/pub/retrievePubNoticeList.do")
	public String pubNoticeList(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			) throws Exception{

		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);

		LOGGER.debug("###########################################################");
		LOGGER.debug("PubNoticeController - PubNoticeList [공지사항 리스트 호출]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

//		String today = DateUtil.getDateString();

//		input.put("fromRqprDt", DateUtil.addDays(today, -7, "yyyy-MM-dd"));
//		input.put("toRqprDt", today);

		//input = StringUtil.toUtf8Input(input);

		model.addAttribute("inputData", input);

		return "web/knld/pub/retrievePubNoticeList";
	}

	@RequestMapping(value="/knld/pub/getPubNoticeList.do")
	public ModelAndView getPubNoticeList(
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
		LOGGER.debug("PubNoticeController - getPubNoticeList [공지사항 리스트 검색]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		ModelAndView modelAndView = new ModelAndView("ruiView");

        // 공지사항 리스트 조회
		List<Map<String,Object>> pubNoticeList = pubNoticeService.getPubNoticeList(input);


		modelAndView.addObject("pwiImtrDataSet", RuiConverter.createDataset("pwiImtrDataSet", pubNoticeList));
		return modelAndView;
	}

	/*등록,수정*/
	@RequestMapping(value="/knld/pub/pubNoticeRgst.do")
	public String pwiImtrRgst(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			) throws Exception{

		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);

		LOGGER.debug("###########################################################");
		LOGGER.debug("PubNoticeController - pubNoticeRgst [공지사항 등록 화면 호출]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		model.addAttribute("inputData", input);


		return "web/knld/pub/pubNoticeRgst";
	}

	/** 공지사항등록 **/
	@RequestMapping(value="/knld/pub/insertPubNoticeInfo.do")
	public ModelAndView insertPwiImtrInfo(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
		LOGGER.debug("###########################################################");
		LOGGER.debug("PubNoticeController - insertPubNoticeInfo [공지사항 저장&업데이트]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		checkSessionRUI(input, session, model);
		ModelAndView modelAndView = new ModelAndView("ruiView");
		HashMap<String, Object> rtnMeaasge = new HashMap<String, Object>();

		// 결과메시지
		rtnMeaasge.put("rtnSt", "S");
		rtnMeaasge.put("rtnMsg", "저장 되었습니다.");
		rtnMeaasge.put("pwiId", "");

		int totCnt = 0;    							//전체건수
		List<Map<String, Object>> dataSet01List;	//공지사항 변경데이터

		try{
			//공지사항 저장&수정
			String pwiId = "";
			dataSet01List = RuiConverter.convertToDataSet(request,"dataSet01");

			for(Map<String,Object> dataSet01Map : dataSet01List) {
				dataSet01Map.put("_userId" , NullUtil.nvl(input.get("_userId"), ""));

				if (!("U").equals(dataSet01Map.get("ugyYn")) ) {
					dataSet01Map.put("ugyYn", "C");
				}
				pubNoticeService.insertPubNoticeInfo(dataSet01Map);
				totCnt++;
			}

			rtnMeaasge.put("pwiId", pwiId);

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

	@RequestMapping(value="/knld/pub/pubNoticeInfo.do")
	public String pwiImtrInfo(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			) throws Exception{

		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);

		LOGGER.debug("###########################################################");
		LOGGER.debug("PubNoticeController - pubNoticeInfo [공지사항 상세 화면 호출]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		model.addAttribute("inputData", input);
		return "web/knld/pub/pubNoticeInfo";
	}

	@RequestMapping(value="/knld/pub/getPubNoticeInfo.do")
	public ModelAndView getPwiImtrInfo(
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
		LOGGER.debug("PubNoticeController - getPubNoticeList [공지사항 상세]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		ModelAndView modelAndView = new ModelAndView("ruiView");

		if(NullUtil.isNull(input.get("_userId")) ||  NullUtil.nvl(input.get("_userId"), "").equals("-1")  ){
			String rtnMsg = messageSourceAccessor.getMessage("msg.alert.sessionTimeout");
			SayMessage.setMessage(rtnMsg);
			modelAndView.addObject("pwiImtrDataSet", null);
        } else {
        	// 공지사항 상세 조회
	        Map<String,Object> resultMap = pubNoticeService.getPubNoticeInfo(input);
			modelAndView.addObject("dataSet01", RuiConverter.createDataset("dataSet01", resultMap));
        }
		return modelAndView;
	}

	/** 공지사항 삭제 **/
	@RequestMapping(value="/knld/pub/deletePubNoticeInfo.do")
	public ModelAndView deletePwiImtrInfo(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
		LOGGER.debug("#################################################################################################");
		LOGGER.debug("PubNoticeController - deletePubNoticeInfo [공지사항 삭제]");
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

			pubNoticeService.deletePubNoticeInfo(input);




		} catch (Exception e) {
			e.printStackTrace();
			rtnMeaasge.put("rtnSt", "F");
			rtnMeaasge.put("rtnMsg", "삭제가 실패하였습니다.");
		}

		modelAndView.addObject("trResultDataSet", RuiConverter.createDataset("trResultDataSet", rtnMeaasge));
		return modelAndView;
	}

	/** 공지사항 조회건수 증가 **/
	@RequestMapping(value="/knld/pub/updatePubNoticeRtrvCnt.do")
	public ModelAndView updatePwiImtrRtrvCnt(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
		LOGGER.debug("#################################################################################################");
		LOGGER.debug("PubNoticeController - updatePubNoticeRtrvCnt [공지사항 조회건수증가]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("#################################################################################################");

		checkSessionRUI(input, session, model);
		ModelAndView modelAndView = new ModelAndView("ruiView");
		HashMap<String, Object> rtnMeaasge = new HashMap<String, Object>();

		// 결과메시지
		rtnMeaasge.put("rtnSt", "S");
		rtnMeaasge.put("rtnMsg", "");

		//int totCnt = 0;    							//전체건수
		//List<Map<String, Object>> dataSet01List;	//공지사항 변경데이터
		try
		{
			pubNoticeService.updatePubNoticeRtrvCnt(input);


		} catch (Exception e) {
			e.printStackTrace();
			rtnMeaasge.put("rtnSt", "F");
			rtnMeaasge.put("rtnMsg", "조회건수 증가 실패하였습니다.");
		}

		modelAndView.addObject("trResultDataSet", RuiConverter.createDataset("trResultDataSet", rtnMeaasge));
		return modelAndView;
	}


	@RequestMapping(value="/knld/pub/pubNoticeInfoSrchView.do")
	public String pubNoticeInfoSrchView(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			) throws Exception{

		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);

		LOGGER.debug("###########################################################");
		LOGGER.debug("PubNoticeController - pubNoticeInfoSrchView [공지사항 뷰 화면 호출]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		model.addAttribute("inputData", input);
		return "web/knld/pub/pubNoticeInfoSrchView";
	}

}
