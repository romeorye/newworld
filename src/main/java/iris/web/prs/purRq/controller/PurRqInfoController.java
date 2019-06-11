package iris.web.prs.purRq.controller;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import iris.web.common.code.service.CodeCacheManager;
import iris.web.common.code.service.PrsCodeService;
import iris.web.common.converter.RuiConverter;
import iris.web.common.util.DateUtil;
import iris.web.common.util.StringUtil;
import iris.web.prs.purRq.service.PurRqInfoService;
import iris.web.sapBatch.service.SapBudgCostService;
import iris.web.system.base.IrisBaseController;

/********************************************************************************
 * NAME : PurRqInfoController.java
 * DESC : 구매요청시스템 - 구매요청 controller
 * PROJ : PRS(구매) 프로젝트
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION
 * ----------  ------  ---------------------------------------------------------
 * 2018.11.20   김연태						최초생성
 *********************************************************************************/
@Controller
public class PurRqInfoController extends IrisBaseController {
	
	@Resource(name = "codeCacheManager")
	private CodeCacheManager codeCacheManager;
	
	@Resource(name = "prsCodeService")
	private PrsCodeService prsCodeService;
	
	@Resource(name = "purRqInfoService")
	private PurRqInfoService purRqInfoService;
	
	@Resource(name = "sapBudgCostService")
	private SapBudgCostService sapBudgCostService;
	
	static final Logger LOGGER = LogManager.getLogger(PurRqInfoController.class);
	
	/**
	 *  구매요청시스템 리스트 화면으로 이동
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/prs/purRq/purRqList.do")
	public String purRqList(
			@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
		
		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		
		LOGGER.debug("###########################################################");
		LOGGER.debug("PurRqInfoController - purRqList [구매요청시스템 리스트 화면 이동]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		input = StringUtil.toUtf8Input(input);
		model.addAttribute("inputData", input);
		
		return "web/prs/purRq/purRqList";
	}
	
	/**
	 *  구매요청시스템 리스트 조회
	 * @param input
	 * @param request
	 * @param response
	 * @param session
	 * @param model
	 * @return
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/prs/pur/retrievePurRqList.do")
	public ModelAndView retrievePurRqList(
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
		LOGGER.debug("PurRqInfoController - retrievePurRqList [구매요청 리스트 검색]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		input = StringUtil.toUtf8(input);

		//구매요청 리스트 조회
		List<Map<String,Object>> rlabChrgList = purRqInfoService.retrievePurRqList(input);
		modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", rlabChrgList));

		return modelAndView;
	}
	
	/**
	 * 비용요청(구매)
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/prs/purRq/purRqDetail.do")
	public String retrievePurRqDetail(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
	
		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);
		
		LOGGER.debug("###########################################################");
		LOGGER.debug("PurRqInfoController - retrievePurRqDetail 비용요청(구매)");
		LOGGER.debug("#########input################################## : " + input);
		LOGGER.debug("###########################################################");

		input = StringUtil.toUtf8Input(input);
		model.addAttribute("inputData", input);
		
		return "web/prs/purRq/purRqDetail";
	}
	
	/**
	 * 투자요청(구매)
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/prs/purRq/purRqLabEquipDetail.do")
	public String retrievePurRqLabEquipDetail(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
	
		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);
		
		LOGGER.debug("###########################################################");
		LOGGER.debug("PurRqInfoController - retrievePurRqLabEquipDetail 투자요청(구매)");
		LOGGER.debug("#########input################################## : " + input);
		LOGGER.debug("###########################################################");
		
		input = StringUtil.toUtf8Input(input);
		model.addAttribute("inputData", input);
		
		return "web/prs/purRq/purRqLabEquipDetail";
	}

	/**
	 * 공사요청(투자)
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/prs/purRq/purRqWorkDetail.do")
	public String retrievePurRqWorkDetail(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
	
		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);
		
		LOGGER.debug("###########################################################");
		LOGGER.debug("PurRqInfoController - retrievePurRqWorkDetail 공사요청(투자)");
		LOGGER.debug("#########input################################## : " + input);
		LOGGER.debug("###########################################################");
		
		input = StringUtil.toUtf8Input(input);
	
		model.addAttribute("inputData", input);
		return "web/prs/purRq/purRqWorkDetail";
	}

	/**
	 * 서비스요청(시설/전산)
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/prs/purRq/purRqOfficeDetail.do")
	public String retrievePurRqOfficeDetail(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
	
		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);
		
		LOGGER.debug("###########################################################");
		LOGGER.debug("PurRqInfoController - retrievePurRqOfficeDetail 서비스요청(시설/전산)");
		LOGGER.debug("#########input################################## : " + input);
		LOGGER.debug("###########################################################");
		
		input = StringUtil.toUtf8Input(input);
		model.addAttribute("inputData", input);
		
		return "web/prs/purRq/purRqOfficeDetail";
	}
	
	/**
	 *  비용요청(구매) 상세내용 조회
	 */
	@RequestMapping(value="/prs/purRq/retrievePurRqDetailList.do")
	public ModelAndView retrievePurRqDetail(
			@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpServletResponse response,
			HttpSession session,
			ModelMap model
			){

		ModelAndView modelAndView = new ModelAndView("ruiView");

		LOGGER.debug("###########################################################");
		LOGGER.debug("PurRqInfoController - retrievePurRqDetail [구매요청 상세조회]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");
		
		//상세화면 조회
		Map<String,Object> purRqDetail = purRqInfoService.retrievePurRqDetail(input);
		//요청리스트 조회
		List<Map<String,Object>> purRqDetailList = purRqInfoService.retrievePurRqDetailList(input);
		
		modelAndView.addObject("prItemDataSet", RuiConverter.createDataset("prItemDataSet", purRqDetail));
		modelAndView.addObject("prItemListDataSet", RuiConverter.createDataset("prItemListDataSet", purRqDetailList));
		
		return modelAndView;
	} 


	/**
	 * 구매요청 저장
	 * @param input
	 * @param request
	 * @param response
	 * @param session
	 * @param model
	 * @return
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/prs/purRq/insertPurRqInfo.do")
	public ModelAndView insertPurRqInfo(
			@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpServletResponse response,
			HttpSession session,
			ModelMap model
			){

		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		
		LOGGER.debug("###########################################################");
		LOGGER.debug("PurRqInfoController - insertPurRqInfo [구매요청 정보 등록]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");
		
		ModelAndView modelAndView = new ModelAndView("ruiView");
		HashMap<String, Object> rtnMeaasge = new HashMap<String, Object>();
		
		input = StringUtil.toUtf8Input(input);
		
		String rtnSt ="F";
		String rtnMsg = "";
		
		Map<String,Object> purRqDetail = new HashMap<String, Object>();
		
		try{
			
			purRqDetail = RuiConverter.convertToDataSet(request,"prItemDataSet").get(0);
			
			if( "".equals(purRqDetail.get("banfnPrs") ) ){
				purRqDetail.put("banfnPrs", purRqInfoService.getBanfnPrsNumber());
			}
			
			purRqInfoService.insertPurRqInfo(purRqDetail);
			
			rtnMsg = "추가되었습니다.";
			rtnSt = "S";
		}catch(Exception e){
			e.printStackTrace();
			rtnMsg = "추가 중 오류가 발생하였습니다.";
		}
		
		rtnMeaasge.put("cmd", "insert");
		rtnMeaasge.put("rtnMsg", rtnMsg);
		rtnMeaasge.put("rtnSt", rtnSt);
		rtnMeaasge.put("banfnPrs", purRqDetail.get("banfnPrs") );
		
		modelAndView.addObject("resultDataSet", RuiConverter.createDataset("resultDataSet", rtnMeaasge));

		return modelAndView;
	}

	/**
	 * 구매요청 수정
	 * @param input
	 * @param request
	 * @param response
	 * @param session
	 * @param model
	 * @return
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/prs/purRq/updatePurRqInfo.do")
	public ModelAndView updatePurRqInfo(
			@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpServletResponse response,
			HttpSession session,
			ModelMap model
			){

		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		
		LOGGER.debug("###########################################################");
		LOGGER.debug("PurRqInfoController - insertPurRqInfo [구매요청 정보 수정]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");
		
		ModelAndView modelAndView = new ModelAndView("ruiView");
		HashMap<String, Object> rtnMeaasge = new HashMap<String, Object>();
		
		input = StringUtil.toUtf8Input(input);
		
		String rtnSt ="F";
		String rtnMsg = "";
		Map<String,Object> purRqDetail = new HashMap<String, Object>();
		
		try{
			purRqDetail = RuiConverter.convertToDataSet(request,"prItemDataSet").get(0);
			
			purRqInfoService.updatePurRqInfo(purRqDetail);
			
			rtnMsg = "수정되었습니다.";
			rtnSt = "S";
		}catch(Exception e){
			e.printStackTrace();
			rtnMsg = "수정 중 오류가 발생하였습니다.";
		}
		
		rtnMeaasge.put("cmd", "update");
		rtnMeaasge.put("rtnMsg", rtnMsg);
		rtnMeaasge.put("rtnSt", rtnSt);
		rtnMeaasge.put("banfnPrs", purRqDetail.get("banfnPrs") );
		
		modelAndView.addObject("resultDataSet", RuiConverter.createDataset("resultDataSet", rtnMeaasge));

		return modelAndView;
	}
	
	/**
	 * 구매요청 삭제
	 * @param input
	 * @param request
	 * @param response
	 * @param session
	 * @param model
	 * @return
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/prs/purRq/deletePurRqInfo.do")
	public ModelAndView deletePurRqInfo(
			@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpServletResponse response,
			HttpSession session,
			ModelMap model
			){

		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		
		LOGGER.debug("###########################################################");
		LOGGER.debug("PurRqInfoController - insertPurRqInfo [구매요청 정보 삭제]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");
		
		ModelAndView modelAndView = new ModelAndView("ruiView");
		HashMap<String, Object> rtnMeaasge = new HashMap<String, Object>();
		
		input = StringUtil.toUtf8Input(input);
		
		String rtnSt ="F";
		String rtnMsg = "";
		
		try{
			purRqInfoService.deletePurRqInfo(input);
			
			rtnMsg = "삭제되었습니다.";
			rtnSt = "S";
		}catch(Exception e){
			e.printStackTrace();
			rtnMsg = "삭제 중 오류가 발생하였습니다.";
		}
		
		rtnMeaasge.put("cmd", "delete");
		rtnMeaasge.put("rtnMsg", rtnMsg);
		rtnMeaasge.put("rtnSt", rtnSt);
		rtnMeaasge.put("banfnPrs", input.get("banfnPrs") );
		
		modelAndView.addObject("resultDataSet", RuiConverter.createDataset("resultDataSet", rtnMeaasge));

		return modelAndView;
	}
	
	
	/**
	 * 구매요청 My List 이동
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/prs/purRq/myPurRqList.do")
	public String myPurRqList(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			) throws Exception{
		
		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);
		
		LOGGER.debug("###########################################################");
		LOGGER.debug("PurRqInfoController - myPurRqList [나의 구매요청 리스트 화면 이동]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		input = StringUtil.toUtf8(input);
		String today = DateUtil.getDateString();
		
		if(StringUtil.isNullString(input.get("fromRegDt"))) {
			input.put("fromRegDt", DateUtil.addMonths(today, -1, "yyyy-MM-dd"));
			input.put("toRegDt", today);
		}
		
		model.addAttribute("inputData", input);

		return "web/prs/purRq/myPurRqList";
	}	
	
	/**
	 * 나의 구매요청 조회
	 * @param input
	 * @param request
	 * @param response
	 * @param session
	 * @param model
	 * @return
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/prs/purRq/myPurRqSearchList.do")
	public ModelAndView myPurRqSearchList(
			@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpServletResponse response,
			HttpSession session,
			ModelMap model
			){

		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		ModelAndView modelAndView = new ModelAndView("ruiView");
		
		input = StringUtil.toUtf8(input);
		
		LOGGER.debug("###########################################################");
		LOGGER.debug("PurRqInfoController - myPurRqSearchList [나의 구매요청 목록]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		//나의 구매요청 리스트 조회
		List<Map<String,Object>> myPurRqList = purRqInfoService.retrieveMyPurRqList(input);
		List<Map<String,Object>> erpPurRqStatus = purRqInfoService.getPrRequestSAPStatus(myPurRqList);
		
		if(!erpPurRqStatus.isEmpty()) {
			Map<String,Object> myListData = new HashMap<String,Object>();
			int i = 0;
			for(Map<String, Object> purRq : erpPurRqStatus) {
				i = Integer.parseInt(purRq.get("idx").toString());

				myListData = myPurRqList.get(i);
/*
				LOGGER.debug("**************************************************************************************");
				LOGGER.debug("i : " + i);	
				LOGGER.debug(purRq);
				LOGGER.debug("**************************************************************************************");
*/				
				myListData.put("prsFlag", 	purRq.get("index"));
				myListData.put("prsNm", 	purRq.get("status"));
				myListData.put("badat", 	purRq.get("badat"));		
				myListData.put("apr4Date", 	purRq.get("apr4Date"));		
				myListData.put("rejeDate", 	purRq.get("rejeDate"));		
				myListData.put("ebeln", 	purRq.get("ebeln"));			
				myListData.put("ebelp", 	purRq.get("ebelp"));			
				myListData.put("bedat", 	purRq.get("bedat"));			
				myListData.put("poMenge", 	purRq.get("poMenge"));		
				myListData.put("poMeins", 	purRq.get("poMeins"));		
				myListData.put("netwr", 	purRq.get("netwr"));			
				myListData.put("waers", 	purRq.get("waers"));			
				myListData.put("name1", 	purRq.get("name1"));			
				myListData.put("grBudat", 	purRq.get("grBudat"));		
				myListData.put("grMenge", 	purRq.get("grMenge"));		
				myListData.put("piBudat", 	purRq.get("piBudat"));		

				LOGGER.debug(myListData);
				
				myPurRqList.set(i, myListData);
			}
		}
		
		modelAndView.addObject("prItemListDataSet", RuiConverter.createDataset("prItemListDataSet", myPurRqList));

		return modelAndView;
	}
	
	/**
	 * 
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/prs/popup/prsApprovalPopup.do")
	public String prsApprovalPopup(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){

		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);
		
		LOGGER.debug("###########################################################");
		LOGGER.debug("PurRqInfoController - prsApprovalPopup PRS ERP결재 팝업");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		model.addAttribute("inputData", input);

		return "web/prs/popup/prsApprovalPopup";
	}
	
	/**
	 * 결재의뢰 저장
	 * @param input
	 * @param request
	 * @param response
	 * @param session
	 * @param model
	 * @return
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/prs/purRq/insertApprovalInfo.do")
	public ModelAndView insertPerApprovalInfo(
			@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpServletResponse response,
			HttpSession session,
			ModelMap model
			){

		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		
		LOGGER.debug("###########################################################");
		LOGGER.debug("PurRqInfoController - insertPerApprovalInfo [결재의뢰 저장]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");
		
		ModelAndView modelAndView = new ModelAndView("ruiView");
		HashMap<String, Object> rtnMeaasge = new HashMap<String, Object>();
		HashMap<String, Object> erpResult = new HashMap<String, Object>();
		
		input = StringUtil.toUtf8Input(input);
		
		String rtnSt ="F";
		String rtnMsg = "";
		
//		1.sap connection
		try {
			sapBudgCostService.sapConnection() ;
		
		} catch (IOException e) {
		//오류가 발생하였습니다.
			LOGGER.debug("ERROR >>>>> ERP IF : Connection Error "+e.toString());	
			e.printStackTrace();
		}
		
		try{
			int rtnCnt = purRqInfoService.insertPurApprovalInfo(input);
			
			erpResult = purRqInfoService.sendSapExpensePr(input);

			//LOGGER.debug("retCode => " + erpResult.get("retCode"));
			//LOGGER.debug("retMsg => " + erpResult.get("retMsg"));
			if("E".equals(erpResult.get("retCode"))) {
				rtnSt ="E";
				rtnMsg = "결재의뢰 중 오류가 발생하였습니다.(" + erpResult.get("retMsg") + ")";
			} else if("F".equals(erpResult.get("retCode"))) { 
				rtnSt ="F";
				rtnMsg = "결재의뢰 중 오류가 발생하였습니다.(" + erpResult.get("retMsg") + ")";
			} else if("S".equals(erpResult.get("retCode"))) { 
				rtnSt ="S";
				rtnMsg = "결재의뢰 되었습니다.";
			}
		}catch(Exception e){
			e.printStackTrace();
			LOGGER.debug("retCode => " + erpResult.get("retCode"));
			rtnSt ="F";
			rtnMsg = "결재의뢰 중 오류가 발생하였습니다.";
		}
		
		rtnMeaasge.put("cmd", "insert");
		rtnMeaasge.put("rtnMsg", rtnMsg);
		rtnMeaasge.put("rtnSt", rtnSt);
		
		modelAndView.addObject("resultDataSet", RuiConverter.createDataset("resultDataSet", rtnMeaasge));

		return modelAndView;
	}
	
	/**
	 * 프로젝트 조회 팝업이동
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/prs/purRq/retrieveSrhPrjPop.do")
	public String retrieveSrhPrjPop(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){

		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);

		LOGGER.debug("###########################################################");
		LOGGER.debug("PurRqInfoController - retrieveSrhPrjPop 프로젝트 조회 팝업");
		LOGGER.debug("###########################################################");

		input = StringUtil.toUtf8Input(input);
		model.addAttribute("inputData", input);
		
		return "web/prs/popup/purRqPrjPop";
	}

	/**
	 *  프로젝트 리스트 팝업 조회
	 * @param input
	 * @param request
	 * @param response
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/prs/purRq/retrieveWbsCdInfoList.do")
	public ModelAndView retrieveWbsCdInfoList(
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
		LOGGER.debug("PurRqInfoController - retrieveWbsCdInfoList [프로젝트 리스트  정보 검색]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

        //Project 정보 list 조회
		List<Map<String,Object>> wbsCdInfoList = prsCodeService.retrieveWbsCdInfoList(input);

		modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", wbsCdInfoList));

		return modelAndView;
	}
	
	/**
	 * 사용자 조회 팝업 이동
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/prs/popup/userSearchPopup.do")
	public String prsUserSearchPopup(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){

		LOGGER.debug("###########################################################");
		LOGGER.debug("PurRqInfoController - prsUserSearchPopup 사용자 조회 팝업");
		LOGGER.debug("###########################################################");
		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);

		String userNm = "";
		
		StringUtil.toStringUtf8(input.get("userNm"));
		LOGGER.debug("input = > " + input);

		model.addAttribute("inputData", input);
		
		return "web/prs/popup/prsUserSearchPopup";
	}
	
	/**
	 * 구매요청 구매요청일 설명 Popup
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/prs/popup/purRqDateExplainPop.do")
	public String purRqDateExplainPop(
			@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
		
		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		
		LOGGER.debug("###########################################################");
		LOGGER.debug("PurRqInfoController - purRqDateExplainPop [구매요청 구매요청일 설명 Popup]");
		LOGGER.debug("###########################################################");
		
		return "web/prs/popup/purRqDateExplainPop";
	}
	
	
}



