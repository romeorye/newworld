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
import iris.web.common.util.MimeDecodeException;
import iris.web.common.util.StringUtil;
import iris.web.prj.rsst.service.PrjRsstMstInfoService;
import iris.web.prj.rsst.service.PrjTmmrInfoService;
import iris.web.prj.tss.ousdcoo.service.OusdCooTssService;
import iris.web.system.base.IrisBaseController;
import iris.web.system.dept.service.DeptService;

/********************************************************************************
 * NAME : PrjRsstMstController.java
 * DESC : 프로젝트 - 연구팀(Project) - 프로젝트마스터(Mst) controller
 * PROJ : IRIS 구축 프로젝트
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION
 * ----------  ------  ---------------------------------------------------------
 * 2017.08.10  소영창	최초생성
 *********************************************************************************/

@Controller
public class PrjRsstMstController  extends IrisBaseController {

	@Resource(name="messageSourceAccessor")
	private MessageSourceAccessor messageSourceAccessor;

	@Resource(name = "prjRsstMstInfoService")
	private PrjRsstMstInfoService prjRsstMstInfoService; /* 프로젝트 마스터 서비스 */

	@Resource(name = "prjTmmrInfoService")
	private PrjTmmrInfoService prjTmmrInfoService;       /* 프로젝트 팀원정보 서비스 */
	
	@Resource(name = "ousdCooTssService")
	private OusdCooTssService ousdCooTssService;	     /* 대외협력과제 서비스 */
	
	@Resource(name = "deptService")
	private DeptService deptService;	                 /* 부서 서비스 */
	
	static final Logger LOGGER = LogManager.getLogger(PrjRsstMstController.class);


	/* 프로젝트목록 화면이동 */
	@RequestMapping(value="/prj/rsst/mst/retrievePrjRsstMstInfoList.do")
	public String retrievePrjRsstMstInfoListView(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
		
		checkSession(input, session, model);
		
		LOGGER.debug("#####################################################################################");
		LOGGER.debug("PrjRsstMstController - prjMstListView [프로젝트목록 화면이동]");
		LOGGER.debug("loginUser => " + model.get("loginUser"));
		LOGGER.debug("inputData => " + input);
		LOGGER.debug("#####################################################################################");

		if(NullUtil.isNull(input.get("_userId")) ||  NullUtil.nvl(input.get("_userId"), "").equals("-1")  ){
			String rtnMsg = messageSourceAccessor.getMessage("msg.alert.sessionTimeout");
			SayMessage.setMessage(rtnMsg);
        } else {
	        model.addAttribute("inputData", input);
        }

		return "web/prj/rsst/prjRsstMstList";
	}

	/* 프로젝트목록 조회 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/prj/rsst/mst/retrievePrjRsstMstSearchInfoList.do")
	public ModelAndView retrievePrjRsstMstSearchInfoList(
		@RequestParam HashMap<String, Object> input,
		HttpServletRequest request,
		HttpServletResponse response,
		HttpSession session,
		ModelMap model
		){
		
		checkSessionObjRUI(input, session, model);
		
		LOGGER.debug("#####################################################################################");
		LOGGER.debug("PrjRsstMstController - retrievePrjRsstMstSearchInfoList [프로젝트 목록 조회]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("#####################################################################################");

		
		ModelAndView modelAndView = new ModelAndView("ruiView");
		input = StringUtil.toUtf8(input);

        List<Map<String,Object>> list = prjRsstMstInfoService.retrievePrjMstSearchList(input);
		modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", list));

		return modelAndView;
	}

	/* 프로젝트 마스터상세 메인 탭 화면 이동 */
	@RequestMapping(value="/prj/rsst/mst/retrievePrjRsstMstDtlInfo.do")
	public String retrievePrjRsstMstDtlInfoView(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
		checkSession(input, session, model);
		
		LOGGER.debug("###########################################################################################");
		LOGGER.debug("PrjRsstMstController - retrievePrjRsstMstDtlInfoView [프로젝트 마스터상세 메인 탭 화면이동]");
		LOGGER.debug("inputData => " + input);
		LOGGER.debug("###########################################################################################");

		
		if(NullUtil.isNull(input.get("_userId")) ||  NullUtil.nvl(input.get("_userId"), "").equals("-1")  ){
			String rtnMsg = messageSourceAccessor.getMessage("msg.alert.sessionTimeout");
			SayMessage.setMessage(rtnMsg);
        } else {

        	String pageMode = NullUtil.nvl(request.getParameter("pageMode"),"");
        	Map<String,Object> teamDeptInfo = null;
        	
        	if(pageMode.equals("V")) {
        	}
        	// pageMode = C : 등록인 경우
        	else {

	        	// 1.1.로그인유저 팀정보 조회
	        	teamDeptInfo = prjRsstMstInfoService.retrieveTeamDeptInfo(input);
	        	// 1.2.팀 프로젝트가 없는 경우에만 팀정보 전달
	        	if(teamDeptInfo != null && !teamDeptInfo.isEmpty() && 
	        	   NullUtil.nvl(teamDeptInfo.get("isTeamPrj"), "N").equals("N")) {
	        		model.addAttribute("teamInfo", teamDeptInfo);
	        	}
        	}

	        model.addAttribute("inputData", input);
	        
			LOGGER.debug("###########################################################################################");
			LOGGER.debug("teamInfo => " + teamDeptInfo);
			LOGGER.debug("###########################################################################################");
        }

		return "web/prj/rsst/prjRsstMstDtlTab";
	}

	/* 프로젝트 마스터정보 조회 */
	@RequestMapping(value="/prj/rsst/mst/retrievePrjRsstMstDtlSearchInfo.do")
	public ModelAndView retrievePrjRsstMstDtlSearchInfo(
			@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpServletResponse response,
			HttpSession session,
			ModelMap model
			){
		LOGGER.debug("#####################################################################################");
		LOGGER.debug("PrjRsstMstController - retrievePrjRsstMstDtlSearchInfo [프로젝트 마스터 상세 조회]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("#####################################################################################");

		ModelAndView modelAndView = new ModelAndView("ruiView");
    	Map<String,Object> projectMstMap = prjRsstMstInfoService.retrievePrjMstInfo(input);
		model.addAttribute("dataSet", RuiConverter.createDataset("dataSet", projectMstMap));

		return modelAndView;
	}

	/* 프로젝트 개요(DTL) 탭 화면이동 */
	@RequestMapping(value="/prj/rsst/mst/retrievePrjRsstDtlDtlInfo.do")
	public String retrievePrjRsstDtlDtlInfoView(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
		LOGGER.debug("#####################################################################################");
		LOGGER.debug("PrjRsstMstController - retrievePrjRsstDtlDtlInfoView [프로젝트 개요정보 탭 화면이동]");
		LOGGER.debug("loginUser => " + model.get("loginUser"));
		LOGGER.debug("inputData => " + input);
		LOGGER.debug("#####################################################################################");

		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);
		if(NullUtil.isNull(input.get("_userId")) ||  NullUtil.nvl(input.get("_userId"), "").equals("-1")  ){
			String rtnMsg = messageSourceAccessor.getMessage("msg.alert.sessionTimeout");
			SayMessage.setMessage(rtnMsg);
        } else {

        	String pageMode = NullUtil.nvl(request.getParameter("pageMode"),"");
        	if(pageMode.equals("V")) {
        		//Map<String,Object> projectMstMap = prjRsstMstInfoService.retrievePrjMstInfo(input);
        		//model.addAttribute("projectMstData", projectMstMap);
        	}
	        model.addAttribute("inputData", input);
        }

		return "web/prj/rsst/prjRsstDtlDtl";
	}

	/* 프로젝트 개요(DTL) 정보조회 */
	@RequestMapping(value="/prj/rsst/mst/retrievePrjDtlSearchInfo.do")
	public ModelAndView retrievePrjDtlSearchInfo(
			@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpServletResponse response,
			HttpSession session,
			ModelMap model
			){

		LOGGER.debug("#####################################################################################");
		LOGGER.debug("PrjRsstMstController - retrievePrjDtlSearchInfo [프로젝트 개요 정보조회]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("#####################################################################################");

		ModelAndView modelAndView = new ModelAndView("ruiView");

    	Map<String,Object> projectDtlMap = prjRsstMstInfoService.retrievePrjDtlInfo(input);
		model.addAttribute("dataSet01", RuiConverter.createDataset("dataSet", projectDtlMap));
		model.addAttribute("inputData", input);

		return modelAndView;
	}

	/** 프로젝트 마스터,개요정보 저장&업데이트 **/
	@RequestMapping(value="/prj/rsst/mst/insertPrjRsstMstInfo.do")
	public ModelAndView insertPrjRsstMstInfo(
			@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
		LOGGER.debug("###########################################################");
		LOGGER.debug("PrjRsstMstController - insertPrjRsstMstInfo [프로젝트 개요 마스터, 상세 저장&업데이트]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		checkSessionObjRUI(input, session, model);
		ModelAndView modelAndView = new ModelAndView("ruiView");
		HashMap<String, Object> rtnMeaasge = new HashMap<String, Object>();

		// 결과메시지
		rtnMeaasge.put("rtnSt", "S");
		rtnMeaasge.put("rtnMsg", "저장 되었습니다.");
		rtnMeaasge.put("newPrjCd", "");

		int totCnt = 0;    							 //전체건수
		List<Map<String, Object>> dataSetTopList;	 //프로젝트 개요 마스터 변경데이터
		List<Map<String, Object>> dataSet01List;	 //프로젝트 개요 상세 변경데이터
		HashMap<String, Object> smryDecodeDs = null; // 프로젝트 개요 에디터 디코딩처리 데이터

		try
		{
			dataSetTopList = RuiConverter.convertToDataSet(request,"dataSetTop");

			// 1. 프로젝트 마스터 정보 저장&수정
			for(Map<String,Object> dataSetTopMap : dataSetTopList) {
				
				//1.1. wbs중복체크
				if( !dataSetTopMap.get("orgWbsCd").equals(dataSetTopMap.get("wbsCd")) ) {
					String dupYn = "N";
					dupYn = prjRsstMstInfoService.retrieveDupPrjWbsCd(dataSetTopMap);
					if("Y".equals(dupYn)){
						rtnMeaasge.put("rtnSt", "F");
						rtnMeaasge.put("rtnMsg", "이미 존재하는 WBS 코드입니다.");
						modelAndView.addObject("resultDataSet", RuiConverter.createDataset("resultDataSet", rtnMeaasge));
						return modelAndView;
					}
				}
				
				//1.2. 프로젝트 마스터 저장
				dataSetTopMap.put("_userId", NullUtil.nvl(input.get("_userId"), ""));
				prjRsstMstInfoService.insertPrjRsstMstInfo(dataSetTopMap);
				totCnt++;
				
				//1.3. wbs코드 약어 변경시 약어테이블에 저장/수정
				String orgWbsCdA = NullUtil.nvl( dataSetTopMap.get("orgWbsCdA") , "");
				if( !orgWbsCdA.equals( NullUtil.nvl( dataSetTopMap.get("wbsCdA") , "")) ) {
					Map<String, Object> paramMap = new HashMap<String, Object>();
					paramMap.put("deptCode"      , NullUtil.nvl( dataSetTopMap.get("deptCd") , ""));
					paramMap.put("deptUperCodeA" , NullUtil.nvl( dataSetTopMap.get("wbsCdA") , ""));
					paramMap.put("upperDeptCd"   , NullUtil.nvl( dataSetTopMap.get("deptUper") , ""));
					
					paramMap.put("useYn", "Y");
					paramMap.put("userId", NullUtil.nvl(input.get("_userId"), ""));

					deptService.saveUpperDeptCdA(paramMap);
				}
			}

			// 2. 프로젝트 개요 정보 저장&수정
			String newPrjCd = "";
			dataSet01List = RuiConverter.convertToDataSet(request,"dataSet01");
			for(Map<String,Object> dataSet01Map : dataSet01List) {
				
				// 프로젝트코드 조회
				if("".equals(NullUtil.nvl(dataSet01Map.get("prjCd"),"")) && "".equals(newPrjCd)) {
					newPrjCd = prjRsstMstInfoService.retrievePrjCd();
				}
				dataSet01Map.put("newPrjCd", newPrjCd);
				dataSet01Map.put("_userId" , NullUtil.nvl(input.get("_userId"), ""));
				
				prjRsstMstInfoService.insertPrjRsstDtlInfo(dataSet01Map);
				totCnt++;
			}

			// 3. 프로젝트 인원정보 저장(파트 포함)
			if(newPrjCd != null && !"".equals(newPrjCd)) {
				for(Map<String,Object> dataSetTopMap : dataSetTopList) {
					dataSetTopMap.put("prjCd"   , newPrjCd);
					dataSetTopMap.put("_userId" , NullUtil.nvl(input.get("_userId"), ""));
					prjTmmrInfoService.insertPrjTeamTmmrDeptInfo(dataSetTopMap);
				}
			}

			rtnMeaasge.put("newPrjCd", newPrjCd);

			if(totCnt == 0 ) {
				rtnMeaasge.put("rtnSt", "F");
				rtnMeaasge.put("rtnMsg", "변경된 내용이 없습니다.");
			}
			
        } catch(MimeDecodeException e) {
        	LOGGER.debug("MimeDecodeException ERROR");
            e.printStackTrace();
            rtnMeaasge.put("rtnSt", "F");
            rtnMeaasge.put("rtnMsg", messageSourceAccessor.getMessage("msg.alert.imageUploadError")); //이미지파일 등록에 실패했습니다.
		} catch (Exception e) {
			e.printStackTrace();
			rtnMeaasge.put("rtnSt", "F");
			rtnMeaasge.put("rtnMsg", "저장이 실패하였습니다.");
		}

		modelAndView.addObject("resultDataSet", RuiConverter.createDataset("resultDataSet", rtnMeaasge));
		return modelAndView;
	}

	/** 프로젝트 조회팝업 화면이동 **/
	@RequestMapping(value="/prj/rsst/mst/retrievePrjSearchPopup.do")
	public String retrievePrjSearchPopupView(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
		LOGGER.debug("#####################################################################################");
		LOGGER.debug("PrjRsstMstController - retrievePrjSearchPopupView [프로젝트 조회팝업 화면이동]");
		LOGGER.debug("loginUser => " + model.get("loginUser"));
		LOGGER.debug("inputData => " + input);
		LOGGER.debug("#####################################################################################");

		checkSession(input, session, model);
		if(NullUtil.isNull(input.get("_userId")) ||  NullUtil.nvl(input.get("_userId"), "").equals("-1")  ){
			String rtnMsg = messageSourceAccessor.getMessage("msg.alert.sessionTimeout");
			SayMessage.setMessage(rtnMsg);
        } else {
	        model.addAttribute("inputData", input);
        }

		return "web/prj/rsst/prjSearchPopup";
	}
	
	/** 프로젝트 조회팝업 화면이동 **/
	@RequestMapping(value="/prj/rsst/mst/retrievePrjSearchPopup2.do")
	public String retrievePrjSearchPopupView2(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
		LOGGER.debug("#####################################################################################");
		LOGGER.debug("PrjRsstMstController - retrievePrjSearchPopupView [프로젝트 조회팝업 화면이동]");
		LOGGER.debug("loginUser => " + model.get("loginUser"));
		LOGGER.debug("inputData => " + input);
		LOGGER.debug("#####################################################################################");

		checkSession(input, session, model);
		if(NullUtil.isNull(input.get("_userId")) ||  NullUtil.nvl(input.get("_userId"), "").equals("-1")  ){
			String rtnMsg = messageSourceAccessor.getMessage("msg.alert.sessionTimeout");
			SayMessage.setMessage(rtnMsg);
        } else {
	        model.addAttribute("inputData", input);
        }

		return "web/prj/rsst/prjSearchPopup2";
	}

	/** 프로젝트 조회팝업 화면이동 (프로젝트 전용) **/
	@RequestMapping(value="/prj/rsst/mst/createPrjSearchPopup.do")
	public String createPrjSearchPopup(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
		LOGGER.debug("#####################################################################################");
		LOGGER.debug("PrjRsstMstController - retrievePrjSearchPopupView [프로젝트 조회팝업 화면이동 (프로젝트 전용) ]");
		LOGGER.debug("loginUser => " + model.get("loginUser"));
		LOGGER.debug("inputData => " + input);
		LOGGER.debug("#####################################################################################");

		checkSession(input, session, model);
		if(NullUtil.isNull(input.get("_userId")) ||  NullUtil.nvl(input.get("_userId"), "").equals("-1")  ){
			String rtnMsg = messageSourceAccessor.getMessage("msg.alert.sessionTimeout");
			SayMessage.setMessage(rtnMsg);
        } else {
	        model.addAttribute("inputData", input);
        }

		return "web/prj/rsst/prjSearchPopup3";
	}
	
	/** 프로젝트 조회팝업 목록조회 **/
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/prj/rsst/mst/retrievePrjPopupSearchList.do")
	public ModelAndView retrievePrjPopupSearchList(
		@RequestParam HashMap<String, Object> input,
		HttpServletRequest request,
		HttpServletResponse response,
		HttpSession session,
		ModelMap model
		){
		LOGGER.debug("#####################################################################################");
		LOGGER.debug("PrjRsstMstController - retrievePrjPopupSearchList [프로젝트 조회팝업 목록조회]  (프로젝트 전용)");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("#####################################################################################");

		checkSessionObjRUI(input, session, model);
		ModelAndView modelAndView = new ModelAndView("ruiView");
		input = StringUtil.toUtf8(input);

        List<Map<String,Object>> list = prjRsstMstInfoService.retrievePrjPopupSearchList(input);
		modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", list));

		return modelAndView;
	}
	
	
	/** 프로젝트 조회팝업 목록조회 **/
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/prj/rsst/mst/retrievePrjSearchPopupSearchList.do")
	public ModelAndView retrievePrjSearchPopupSearchList(
		@RequestParam HashMap<String, Object> input,
		HttpServletRequest request,
		HttpServletResponse response,
		HttpSession session,
		ModelMap model
		){
		LOGGER.debug("#####################################################################################");
		LOGGER.debug("PrjRsstMstController - retrievePrjSearchPopupSearchList [프로젝트 조회팝업 목록조회]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("#####################################################################################");

		checkSessionObjRUI(input, session, model);
		ModelAndView modelAndView = new ModelAndView("ruiView");
		input = StringUtil.toUtf8(input);

        List<Map<String,Object>> list = prjRsstMstInfoService.retrievePrjSearchPopupSearchList(input);
		modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", list));

		return modelAndView;
	}
	
	/* 프로젝트 상세 하면 (통합검색용) */
	@RequestMapping(value="/prj/rsst/retrievePrjRsstMstDtlInfoSrchView.do")
	public String retrievePrjRsstMstDtlInfoSrchView(
			@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
		LOGGER.debug("#####################################################################################");
		LOGGER.debug("PrjRsstMstController - retrievePrjRsstMstDtlInfoSrchView [프로젝트 상세 하면 (통합검색용)");
		LOGGER.debug("loginUser => " + model.get("loginUser"));
		LOGGER.debug("inputData => " + input);
		LOGGER.debug("#####################################################################################");

		/* 반드시 공통 호출 후 작업 */
		//retrievePrjMstInfo
		Map<String,Object> prjMstMap = prjRsstMstInfoService.retrievePrjMstInfo(input);
		//retrievePrjDtlInfo
		Map<String, Object> prjDtlMap = prjRsstMstInfoService.retrievePrjDtlInfo(input);

		model.addAttribute("prjMstData", prjMstMap);
		model.addAttribute("prjDtlData", prjDtlMap);
	    model.addAttribute("inputData", input);

		return "web/prj/rsst/prjRsstView";
	}

	/**
	 * 메인 팝업 
	 * @param input
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/prj/rsst/mainPopUp.do")
	public String retrieveMachineList(@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){

		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		//LOGGER.debug("session="+lsession);
		LOGGER.debug("####################input################################################################# : " + input);

		model.addAttribute("inputData", input);

		return  "web/main/mainPopUp";
	}
	
	/**
	 * help desk 팝업 
	 * @param input
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/prj/rsst/helpdesPopUp.do")
	public String helpdesPopUp(@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
		
		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		//LOGGER.debug("session="+lsession);
		LOGGER.debug("####################input################################################################# : " + input);
		
		model.addAttribute("inputData", input);
		
		return  "web/main/helpdeskPopUp2";
	}
	
}
