package iris.web.prj.rsst.controller;

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

import devonframe.message.saymessage.SayMessage;
import devonframe.util.NullUtil;
import iris.web.common.converter.RuiConverter;
import iris.web.prj.rsst.service.PrjRsstPduInfoService;
import iris.web.system.base.IrisBaseController;

/********************************************************************************
 * NAME : RsstController.java
 * DESC : 프로젝트 - 연구팀(Project) - 산출물(Pdu) controller
 * PROJ : IRIS 구축 프로젝트
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION
 * ----------  ------  ---------------------------------------------------------
 * 2017.08.10  IRIS04	최초생성
 *********************************************************************************/

@Controller
public class PrjRsstPduInfoController  extends IrisBaseController {

	@Resource(name="messageSourceAccessor")
	private MessageSourceAccessor messageSourceAccessor;

	@Resource(name = "prjRsstPduInfoService")
	private PrjRsstPduInfoService prjRsstPduInfoService;

	static final Logger LOGGER = LogManager.getLogger(PrjRsstPduInfoController.class);


	/** 산출물 탭 화면이동 **/
	@RequestMapping(value="/prj/rsst/pdu/retrievePrjRsstPduInfo.do")
	public String retrievePrjRsstPduInfoView(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){

		LOGGER.debug("#####################################################################################");
		LOGGER.debug("PrjRsstPduInfoController - retrievePrjRsstPduInfoView [프로젝트 등록 > 산출물 탭 화면 이동]");
		LOGGER.debug("#####################################################################################");

		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);
		if(NullUtil.isNull(input.get("_userId")) ||  NullUtil.nvl(input.get("_userId"), "").equals("-1")  ){
			String rtnMsg = messageSourceAccessor.getMessage("msg.alert.sessionTimeout");
			SayMessage.setMessage(rtnMsg);
        } else {
	        model.addAttribute("inputData", input);
        }

		LOGGER.debug("###########################################################");
		LOGGER.debug("loginUser => " + model.get("loginUser"));
		LOGGER.debug("inputData => " + input);
		LOGGER.debug("###########################################################");

		return "web/prj/rsst/prjRsstPudDtl";
	}

	/** 산출물 목록 조회 **/
	@RequestMapping(value="/prj/rsst/pdu/retrievePrjRsstPduSearchInfo.do")
	public ModelAndView retrievePrjRsstPduSearchInfo(
			@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpServletResponse response,
			HttpSession session,
			ModelMap model
			){

		LOGGER.debug("#####################################################################################");
		LOGGER.debug("PrjRsstPduInfoController - retrievePrjRsstPduSearchInfo [프로젝트 등록 > 산출물 탭 조회]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("#####################################################################################");

		/*반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		ModelAndView modelAndView = new ModelAndView("ruiView");
		if(NullUtil.isNull(input.get("_userId")) ||  NullUtil.nvl(input.get("_userId"), "").equals("-1")  ){
			String rtnMsg = messageSourceAccessor.getMessage("msg.alert.sessionTimeout");
			SayMessage.setMessage(rtnMsg);
			modelAndView.addObject("dataset", null);
        } else {

	        List<Map<String,Object>> list = prjRsstPduInfoService.retrievePrjRsstPduSearchInfo(input);
			modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", list));
        }

		LOGGER.debug("###########################################################");
		LOGGER.debug("loginUser => " + model.get("loginUser"));
		LOGGER.debug("inputData => " + input);
		//LOGGER.debug("rowsPerPage => " + model.get("rowsPerPage"));
		LOGGER.debug("###########################################################");

		return modelAndView;
	}

	/** 프로젝트 산출물 삭제 **/
	@RequestMapping(value="/prj/rsst/pdu/deletePrjRsstPduInfo.do")
	public ModelAndView deletePrjRsstPduInfo(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
		LOGGER.debug("###########################################################");
		LOGGER.debug("RsstController - deletePrjRsstPduInfo [프로젝트 산출물 삭제]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		checkSessionRUI(input, session, model);
		ModelAndView modelAndView = new ModelAndView("ruiView");
		HashMap<String, Object> rtnMeaasge = new HashMap<String, Object>();

		// 결과메시지
		rtnMeaasge.put("rtnSt", "S");
		rtnMeaasge.put("rtnMsg", "삭제 되었습니다.");

		int totCnt = 0;    							//전체건수
		List<Map<String, Object>> dataSet02List;	//프로젝트 산출물 변경데이터

		try {
			dataSet02List = RuiConverter.convertToDataSet(request,"dataSet02");
				for(Map<String,Object> dataSet02Map : dataSet02List) {

					if( "1".equals(NullUtil.nvl(dataSet02Map.get("chk"), ""))) {
						dataSet02Map.put("_userId" , NullUtil.nvl(input.get("_userId"), ""));
						prjRsstPduInfoService.deletePrjRsstPduInfo(dataSet02Map);
						totCnt++;
					}
				}

				LOGGER.debug("dataSet02List="+dataSet02List);

				if(totCnt == 0 ) {
					rtnMeaasge.put("rtnSt", "F");
					rtnMeaasge.put("rtnMsg", "변경된 내용이 없습니다.");
				}
		} catch (Exception e) {
			e.printStackTrace();
			rtnMeaasge.put("rtnSt", "F");
			rtnMeaasge.put("rtnMsg", "삭제가 실패하였습니다.");
		}

		modelAndView.addObject("resultDataSet", RuiConverter.createDataset("resultDataSet", rtnMeaasge));
		return modelAndView;
	}

	/** 프로젝트 산출물 저장 **/
	@RequestMapping(value="/prj/rsst/pdu/insertPrjRsstPduInfo.do")
	public ModelAndView insertPrjRsstPduInfo(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
		LOGGER.debug("###########################################################");
		LOGGER.debug("RsstController - deletePrjRsstPduInfo [프로젝트 산출물 저장]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		checkSessionRUI(input, session, model);
		ModelAndView modelAndView = new ModelAndView("ruiView");
		HashMap<String, Object> rtnMeaasge = new HashMap<String, Object>();

		// 결과메시지
		rtnMeaasge.put("rtnSt", "S");
		rtnMeaasge.put("rtnMsg", "저장 되었습니다.");

		int totCnt = 0;    							//전체건수
		List<Map<String, Object>> dataSet02List;	//프로젝트 산출물 변경데이터

		try {
			dataSet02List = RuiConverter.convertToDataSet(request,"dataSet02");
				for(Map<String,Object> dataSet02Map : dataSet02List) {

					if( "1".equals(NullUtil.nvl(dataSet02Map.get("chk"), ""))) {

						dataSet02Map.put("_userId" , NullUtil.nvl(input.get("_userId"), ""));
						prjRsstPduInfoService.insertPrjRsstPduInfo(dataSet02Map);
						totCnt++;
					}
				}

				LOGGER.debug("dataSet02List="+dataSet02List);

				if(totCnt == 0 ) {
					rtnMeaasge.put("rtnSt", "F");
					rtnMeaasge.put("rtnMsg", "변경된 내용이 없습니다.");
				}
		} catch (Exception e) {
			e.printStackTrace();
			rtnMeaasge.put("rtnSt", "F");
			rtnMeaasge.put("rtnMsg", "저장이 실패하였습니다.");
		}

		modelAndView.addObject("resultDataSet", RuiConverter.createDataset("resultDataSet", rtnMeaasge));
		return modelAndView;
	}


}
