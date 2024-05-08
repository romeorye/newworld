package iris.web.anl.rqpr.controller;

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

import iris.web.anl.rqpr.service.AnlRqprService;
import iris.web.common.code.service.CodeCacheManager;
import iris.web.common.converter.RuiConverter;
import iris.web.common.util.DateUtil;
import iris.web.common.util.StringUtil;
import iris.web.system.attach.service.AttachFileService;
import iris.web.system.base.IrisBaseController;

/********************************************************************************
 * NAME : AnlRqprController.java 
 * DESC : 분석의뢰 - 분석의뢰 관리 controller
 * PROJ : IRIS UPGRADE 1차 프로젝트
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG                       
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION                        
 * ----------  ------  --------------------------------------------------------- 
 * 2017.08.25  오명철	최초생성     
 *********************************************************************************/

@Controller
public class AnlRqprController extends IrisBaseController {
	
	@Resource(name = "codeCacheManager")
	private CodeCacheManager codeCacheManager;
	
	@Resource(name = "anlRqprService")
	private AnlRqprService anlRqprService;
	
	@Resource(name = "attachFileService")
	private AttachFileService attachFileService;
	
	static final Logger LOGGER = LogManager.getLogger(AnlRqprController.class);

	@RequestMapping(value="/anl/anlRqprList.do")
	public String anlRqprList(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			) throws Exception{
		
		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);
		
		input = StringUtil.toUtf8(input);
		
		LOGGER.debug("###########################################################");
		LOGGER.debug("AnlRqprController - anlRqprList [분석의뢰 리스트 화면 이동]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");
		
		String today = DateUtil.getDateString();
		
		if(StringUtil.isNullString(input.get("fromRqprDt"))) {
			input.put("fromRqprDt", DateUtil.addMonths(today, -1, "yyyy-MM-dd"));
			input.put("toRqprDt", today);
		}
		
		model.addAttribute("inputData", input);

		return "web/anl/rqpr/anlRqprList";
	}
	
	@RequestMapping(value="/anl/getAnlChrgList.do")
	public ModelAndView getAnlChrgList(
			@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpServletResponse response,
			HttpSession session,
			ModelMap model
			){

		LOGGER.debug("###########################################################");
		LOGGER.debug("AnlRqprController - getAnlChrgList [분석담당자 리스트 검색]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");
		
		ModelAndView modelAndView = new ModelAndView("ruiView");
    	
        // 분석담당자 리스트 조회 
		List<Map<String,Object>> anlChrgList = anlRqprService.getAnlChrgList(input);
		
		modelAndView.addObject("anlChrgDataSet", RuiConverter.createDataset("anlChrgDataSet", anlChrgList));
		
		return modelAndView;
	}
	
	@RequestMapping(value="/anl/getAnlRqprList.do")
	public ModelAndView getAnlRqprList(
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
		LOGGER.debug("AnlRqprController - getAnlRqprList [분석의뢰 리스트 검색]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");
		
		ModelAndView modelAndView = new ModelAndView("ruiView");
    	
        // 분석의뢰 리스트 조회 
		List<Map<String,Object>> anlRqprList = anlRqprService.getAnlRqprList(input);
		
		modelAndView.addObject("anlRqprDataSet", RuiConverter.createDataset("anlRqprDataSet", anlRqprList));
		
		return modelAndView;
	}

	@RequestMapping(value="/anl/anlRqprRgst.do")
	public String anlRqprRgst(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			) throws Exception{
		
		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);

		LOGGER.debug("###########################################################");
		LOGGER.debug("AnlRqprController - anlRqprRgst [분석의뢰서 등록 화면 이동]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");
		
		List <Map<String, Object>> infmTypeCdList  = codeCacheManager.retrieveCodeValueListForCache("INFM_TYPE_CD"); // 통보유형
		List <Map<String, Object>> smpoTrtmCdList  = codeCacheManager.retrieveCodeValueListForCache("SMPO_TRTM_CD"); // 시료처리구분
		
		model.addAttribute("inputData", input);
		model.addAttribute("infmTypeCdList", infmTypeCdList);
		model.addAttribute("smpoTrtmCdList", smpoTrtmCdList);

		return "web/anl/rqpr/anlRqprRgst";
	}

	@RequestMapping(value="/anl/anlChrgDialog.do")
	public String anlChrgDialog(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			) throws Exception{
		
		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);

		LOGGER.debug("###########################################################");
		LOGGER.debug("AnlRqprController - anlChrgDialog [분석담당자 리스트 화면 이동]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		return "web/anl/rqpr/anlChrgDialog";
	}
	
	@RequestMapping(value="/anl/getAnlRqprInfo.do")
	public ModelAndView getAnlRqprInfo(
			@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpServletResponse response,
			HttpSession session,
			ModelMap model
			){

		LOGGER.debug("###########################################################");
		LOGGER.debug("AnlRqprController - getAnlRqprInfo [분석의로 정보 불러오기]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");
		
		ModelAndView modelAndView = new ModelAndView("ruiView");
    	
		Map<String,Object> anlRqprInfo = anlRqprService.getAnlRqprInfo(input);
		List<Map<String,Object>> anlRqprSmpoList = anlRqprService.getAnlRqprSmpoList(input);
		
		modelAndView.addObject("anlRqprDataSet", RuiConverter.createDataset("anlRqprDataSet", anlRqprInfo));
		modelAndView.addObject("anlRqprSmpoDataSet", RuiConverter.createDataset("anlRqprSmpoDataSet", anlRqprSmpoList));
		
		return modelAndView;
	}
	
	@RequestMapping(value="/anl/anlRqprSearchPopup.do")
	public String anlRqprSearchPopup(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){

		LOGGER.debug("###########################################################");
		LOGGER.debug("AnlRqprController - anlRqprSearchPopup 분석의뢰 리스트 조회 팝업");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");
		
		
		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);
		
		model.addAttribute("inputData", input);
		
		return "web/anl/rqpr/anlRqprSearchPopup";
	}
	
	@RequestMapping(value="/anl/regstAnlRqpr.do")
	public ModelAndView regstAnlRqpr(
			@RequestParam HashMap<String, Object> input,
			HttpServletRequest request, 
			HttpServletResponse response,
			HttpSession session,
			ModelMap model
			){
		
		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		
    	//input = StringUtil.toUtf8(input);
    	input = StringUtil.toUtf8Input(input);

		LOGGER.debug("###########################################################");
		LOGGER.debug("AnlRqprController - regstAnlRqpr 분석의뢰 등록");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");
		
		ModelAndView modelAndView = new ModelAndView("ruiView");
		
		Map<String,Object> dataMap = new HashMap<String, Object>();
		Map<String,Object> resultMap = new HashMap<String, Object>();
		
		try {
			dataMap.put("input", input);
			dataMap.put("anlRqprDataSet", RuiConverter.convertToDataSet(request, "anlRqprDataSet").get(0));
			dataMap.put("anlRqprSmpoDataSet", RuiConverter.convertToDataSet(request, "anlRqprSmpoDataSet"));
			dataMap.put("anlRqprRltdDataSet", RuiConverter.convertToDataSet(request, "anlRqprRltdDataSet"));
			
			anlRqprService.insertAnlRqpr(dataMap);
			
			resultMap.put("resultYn", "Y");
			resultMap.put("resultMsg", "정상적으로 등록 되었습니다.");
		} catch (Exception e) {
			e.printStackTrace();
			resultMap.put("resultYn", "N");
			resultMap.put("resultMsg", "작업을 실패하였습니다\\n관리자에게 문의하세요.");
		}
		
		modelAndView.addObject("result", RuiConverter.createDataset("result", resultMap));
		
		return modelAndView;
	}

	@RequestMapping(value="/anl/anlRqprDetail.do")
	public String anlRqprDetail(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			) throws Exception{
		
		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);

		LOGGER.debug("###########################################################");
		LOGGER.debug("AnlRqprController - anlRqprDetail [분석의뢰서 상세 화면 이동]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");
		
		List <Map<String, Object>> infmTypeCdList  = codeCacheManager.retrieveCodeValueListForCache("INFM_TYPE_CD"); // 통보유형
		List <Map<String, Object>> smpoTrtmCdList  = codeCacheManager.retrieveCodeValueListForCache("SMPO_TRTM_CD"); // 시료처리구분
		
		model.addAttribute("inputData", input);
		model.addAttribute("infmTypeCdList", infmTypeCdList);
		model.addAttribute("smpoTrtmCdList", smpoTrtmCdList);

		return "web/anl/rqpr/anlRqprDetail";
	}
	
	@RequestMapping(value="/anl/getAnlRqprDetailInfo.do")
	public ModelAndView getAnlRqprDetailInfo(
			@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpServletResponse response,
			HttpSession session,
			ModelMap model
			){

		LOGGER.debug("###########################################################");
		LOGGER.debug("AnlRqprController - getAnlRqprDetailInfo [분석의로 상세정보 조회]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");
		
		ModelAndView modelAndView = new ModelAndView("ruiView");
		List<Map<String,Object>> anlRqprDecodeSmpoList = null;
		List<Map<String,Object>> anlRqprDecodeRltdList = null;
		List<Map<String,Object>> anlRqprDecodeExprList = null;
		
		Map<String,Object> anlRqprInfo = anlRqprService.getAnlRqprInfo(input);
		List<Map<String,Object>> anlRqprSmpoList = anlRqprService.getAnlRqprSmpoList(input);
		List<Map<String,Object>> anlRqprRltdList = anlRqprService.getAnlRqprRltdList(input);
		List<Map<String,Object>> anlRqprExprList = anlRqprService.getAnlRqprExprList(input);
		
		input.put("attcFilId", anlRqprInfo.get("rqprAttcFileId"));
		
		List<Map<String,Object>> rqprAttachFileList = attachFileService.getAttachFileList(input);
		
		input.put("attcFilId", anlRqprInfo.get("rsltAttcFileId"));
		
		List<Map<String,Object>> rsltAttachFileList = attachFileService.getAttachFileList(input);
		
		anlRqprInfo = StringUtil.toUtf8Output((HashMap) anlRqprInfo);
		
		modelAndView.addObject("anlRqprDataSet", RuiConverter.createDataset("anlRqprDataSet", anlRqprInfo));
		modelAndView.addObject("anlRqprSmpoDataSet", RuiConverter.createDataset("anlRqprSmpoDataSet", anlRqprSmpoList));
		modelAndView.addObject("anlRqprRltdDataSet", RuiConverter.createDataset("anlRqprRltdDataSet", anlRqprRltdList));
		modelAndView.addObject("anlRqprExprDataSet", RuiConverter.createDataset("anlRqprExprDataSet", anlRqprExprList));
		modelAndView.addObject("anlRqprAttachDataSet", RuiConverter.createDataset("anlRqprAttachDataSet", rqprAttachFileList));
		modelAndView.addObject("anlRqprRsltAttachDataSet", RuiConverter.createDataset("anlRqprRsltAttachDataSet", rsltAttachFileList));
		
		return modelAndView;
	}
	
	@RequestMapping(value="/anl/updateAnlRqpr.do")
	public ModelAndView updateAnlRqpr(
			@RequestParam HashMap<String, Object> input,
			HttpServletRequest request, 
			HttpServletResponse response,
			HttpSession session,
			ModelMap model
			){
		
		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		
    	input = StringUtil.toUtf8Input(input);

		LOGGER.debug("###########################################################");
		LOGGER.debug("AnlRqprController - updateAnlRqpr 분석의뢰 수정");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");
		
		ModelAndView modelAndView = new ModelAndView("ruiView");
		
		Map<String,Object> dataMap = new HashMap<String, Object>();
		Map<String,Object> resultMap = new HashMap<String, Object>();
		
		try {
			input.put("cmd", "update");
            
			dataMap.put("input", input);
			dataMap.put("anlRqprDataSet", RuiConverter.convertToDataSet(request, "anlRqprDataSet").get(0));
			dataMap.put("anlRqprSmpoDataSet", RuiConverter.convertToDataSet(request, "anlRqprSmpoDataSet"));
			dataMap.put("anlRqprRltdDataSet", RuiConverter.convertToDataSet(request, "anlRqprRltdDataSet"));
			
			anlRqprService.updateAnlRqpr(dataMap);

			resultMap.put("cmd", "update");
			resultMap.put("resultYn", "Y");
			resultMap.put("resultMsg", "정상적으로 수정 되었습니다.");
		} catch (Exception e) {
			e.printStackTrace();
			resultMap.put("resultYn", "N");
			resultMap.put("resultMsg", "작업을 실패하였습니다\\n관리자에게 문의하세요.");
		}
		
		modelAndView.addObject("result", RuiConverter.createDataset("result", resultMap));
		
		return modelAndView;
	}
	
	@RequestMapping(value="/anl/requestAnlRqprApproval.do")
	public ModelAndView requestAnlRqprApproval(
			@RequestParam HashMap<String, Object> input,
			HttpServletRequest request, 
			HttpServletResponse response,
			HttpSession session,
			ModelMap model
			){
		
		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		
    	input = StringUtil.toUtf8Input(input);

		LOGGER.debug("###########################################################");
		LOGGER.debug("AnlRqprController - requestAnlRqprApproval 분석의뢰 결재요청");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");
		
		ModelAndView modelAndView = new ModelAndView("ruiView");
		
		Map<String,Object> dataMap = new HashMap<String, Object>();
		Map<String,Object> resultMap = new HashMap<String, Object>();
		
		try {
			input.put("cmd", "requestApproval");
			
			dataMap.put("input", input);
			dataMap.put("anlRqprDataSet", RuiConverter.convertToDataSet(request, "anlRqprDataSet").get(0));
			dataMap.put("anlRqprSmpoDataSet", RuiConverter.convertToDataSet(request, "anlRqprSmpoDataSet"));
			dataMap.put("anlRqprRltdDataSet", RuiConverter.convertToDataSet(request, "anlRqprRltdDataSet"));
			
			anlRqprService.updateAnlRqpr(dataMap);

			resultMap.put("cmd", "requestApproval");
			resultMap.put("resultYn", "Y");
			resultMap.put("resultMsg", "");
		} catch (Exception e) {
			e.printStackTrace();
			resultMap.put("resultYn", "N");
			resultMap.put("resultMsg", "작업을 실패하였습니다\\n관리자에게 문의하세요.");
		}
		
		modelAndView.addObject("result", RuiConverter.createDataset("result", resultMap));
		
		return modelAndView;
	}
	
	@RequestMapping(value="/anl/deleteAnlRqpr.do")
	public ModelAndView deleteAnlRqpr(
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
		LOGGER.debug("AnlRqprController - deleteAnlRqpr 분석의뢰 삭제");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");
		
		ModelAndView modelAndView = new ModelAndView("ruiView");
		
		Map<String,Object> resultMap = new HashMap<String, Object>();

		try {
			anlRqprService.deleteAnlRqpr(input);

			resultMap.put("cmd", "delete");
			resultMap.put("resultYn", "Y");
			resultMap.put("resultMsg", "정상적으로 삭제 되었습니다.");
		} catch (Exception e) {
			e.printStackTrace();
			resultMap.put("resultYn", "N");
			resultMap.put("resultMsg", "작업을 실패하였습니다\\n관리자에게 문의하세요.");
		}
		
		modelAndView.addObject("result", RuiConverter.createDataset("result", resultMap));
		
		return modelAndView;
	}
	
	@RequestMapping(value="/anl/anlRqprOpinitionPopup.do")
	public String anlRqprOpinitionPopup(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){

		LOGGER.debug("###########################################################");
		LOGGER.debug("AnlRqprController - anlRqprOpinitionPopup 분석의뢰 의견 팝업");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");
		
		
		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);
		
		model.addAttribute("inputData", input);
		
		return "web/anl/rqpr/anlRqprOpinitionPopup";
	}
	
	@RequestMapping(value="/anl/getAnlRqprOpinitionList.do")
	public ModelAndView getAnlRqprOpinitionList(
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
		LOGGER.debug("AnlRqprController - getAnlRqprOpinitionList [분석의뢰 의견 리스트 검색]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");
		
		ModelAndView modelAndView = new ModelAndView("ruiView");
    	
		List<Map<String,Object>> anlRqprOpinitionList = anlRqprService.getAnlRqprOpinitionList(input);
		
		modelAndView.addObject("anlRqprOpinitionDataSet", RuiConverter.createDataset("anlRqprOpinitionDataSet", anlRqprOpinitionList));
		
		return modelAndView;
	}
	
	@RequestMapping(value="/anl/saveAnlRqprOpinition.do")
	public ModelAndView saveAnlRqprOpinition(
			@RequestParam HashMap<String, Object> input,
			HttpServletRequest request, 
			HttpServletResponse response,
			HttpSession session,
			ModelMap model
			){
		
		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		
		input = StringUtil.toUtf8Input(input);

		LOGGER.debug("###########################################################");
		LOGGER.debug("AnlRqprController - saveAnlRqprOpinition 분석의뢰 의견 저장");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");
		
		ModelAndView modelAndView = new ModelAndView("ruiView");
		
		Map<String,Object> resultMap = new HashMap<String, Object>();

		try {
			anlRqprService.saveAnlRqprOpinition(input);

			resultMap.put("event", "0".equals(input.get("opiId")) ? "I" : "U");
			resultMap.put("resultYn", "Y");
			resultMap.put("resultMsg", "정상적으로 저장 되었습니다.");
		} catch (Exception e) {
			e.printStackTrace();
			resultMap.put("resultYn", "N");
			resultMap.put("resultMsg", "작업을 실패하였습니다\\n관리자에게 문의하세요.");
		}
		
		modelAndView.addObject("result", RuiConverter.createDataset("result", resultMap));
		
		return modelAndView;
	}
	
	@RequestMapping(value="/anl/deleteAnlRqprOpinition.do")
	public ModelAndView deleteAnlRqprOpinition(
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
		LOGGER.debug("AnlRqprController - deleteAnlRqprOpinition 분석의뢰 의견 삭제");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");
		
		ModelAndView modelAndView = new ModelAndView("ruiView");
		
		Map<String,Object> resultMap = new HashMap<String, Object>();

		try {
			anlRqprService.deleteAnlRqprOpinition(input);

			resultMap.put("event", "D");
			resultMap.put("resultYn", "Y");
			resultMap.put("resultMsg", "정상적으로 삭제 되었습니다.");
		} catch (Exception e) {
			e.printStackTrace();
			resultMap.put("resultYn", "N");
			resultMap.put("resultMsg", "작업을 실패하였습니다\\n관리자에게 문의하세요.");
		}
		
		modelAndView.addObject("result", RuiConverter.createDataset("result", resultMap));
		
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
	@RequestMapping(value="/anl/openOpinitionPopup.do")
	public String openOpinitionPopup(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){

		LOGGER.debug("###########################################################");
		LOGGER.debug("AnlRqprController - openOpinitionPopup 분석의뢰 의견 상세팝업");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");
		
		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);
		
		input.put("opiSbc", anlRqprService.retrieveOpiSbc(input).replaceAll("\n", "<br/>") );
		
		model.addAttribute("inputData", input);
		
		return "web/anl/rqpr/openOpinitionPopup";
	}
	
	/**
	 * 
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/anl/openAddOpinitionPopup.do")
	public String openAddOpinitionPopup(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);

		LOGGER.debug("###########################################################");
		LOGGER.debug("AnlRqprController - openAddOpinitionPopup 분석의뢰 의견 상세등록팝업");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");
		
		
		//input.put("opiSbc", anlRqprService.retrieveOpiSbc(input).replaceAll("\n", "<br/>") );
		
		model.addAttribute("inputData", input);
		
		return "web/anl/rqpr/anlRqprOpinitionAddPopup";
	}	
	
	@RequestMapping(value="/anl/anlRqprList4Chrg.do")
	public String anlRqprList4Chrg(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			) throws Exception{
		
		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);
		
		input = StringUtil.toUtf8(input);
		
		LOGGER.debug("###########################################################");
		LOGGER.debug("AnlRqprController - anlRqprList4Chrg [분석의뢰 리스트 담당자용 화면 이동]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");
		
		String today = DateUtil.getDateString();
		
		if(input.get("fromRqprDt") == null) {
			input.put("fromRqprDt", DateUtil.addMonths(today, -1, "yyyy-MM-dd"));
			input.put("toRqprDt", today);
		}
		
		model.addAttribute("inputData", input);

		return "web/anl/rqpr/anlRqprList4Chrg";
	}

	@RequestMapping(value="/anl/anlRqprDetail4Chrg.do")
	public String anlRqprDetail4Chrg(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			) throws Exception{
		
		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);

		input = StringUtil.toUtf8(input);
		LOGGER.debug("###########################################################");
		LOGGER.debug("AnlRqprController - anlRqprDetail4Chrg [분석의뢰서 상세 담당자용 화면 이동]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");
		
		List <Map<String, Object>> infmTypeCdList  = codeCacheManager.retrieveCodeValueListForCache("INFM_TYPE_CD"); // 통보유형
		List <Map<String, Object>> smpoTrtmCdList  = codeCacheManager.retrieveCodeValueListForCache("SMPO_TRTM_CD"); // 시료처리구분
		
		model.addAttribute("inputData", input);
		model.addAttribute("infmTypeCdList", infmTypeCdList);
		model.addAttribute("smpoTrtmCdList", smpoTrtmCdList);

		return "web/anl/rqpr/anlRqprDetail4Chrg";
	}
	
	@RequestMapping(value="/anl/saveAnlRqpr.do")
	public ModelAndView saveAnlRqpr(
			@RequestParam HashMap<String, Object> input,
			HttpServletRequest request, 
			HttpServletResponse response,
			HttpSession session,
			ModelMap model
			){
		
		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		
		input = StringUtil.toUtf8Input(input);

		LOGGER.debug("###########################################################");
		LOGGER.debug("AnlRqprController - saveAnlRqpr 분석의뢰 저장");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");
		
		ModelAndView modelAndView = new ModelAndView("ruiView");
		
		Map<String,Object> resultMap = new HashMap<String, Object>();
		Map<String,Object> dataMap = new HashMap<String, Object>();
		
		try {
/*            
			input.put("cmd", "update");	
*/
			dataMap.put("input", input);
			dataMap.put("anlRqprDataSet", RuiConverter.convertToDataSet(request, "anlRqprDataSet").get(0));
			dataMap.put("anlRqprSmpoDataSet", RuiConverter.convertToDataSet(request, "anlRqprSmpoDataSet"));
			dataMap.put("anlRqprRltdDataSet", RuiConverter.convertToDataSet(request, "anlRqprRltdDataSet"));
		
			Map<String, Object> anlRqprDataSet = RuiConverter.convertToDataSet(request, "anlRqprDataSet").get(0);
			anlRqprDataSet.put("userId", input.get("_userId"));

			anlRqprService.saveAnlRqpr(dataMap);
			
			resultMap.put("cmd", "saveAnlRqpr");
			resultMap.put("resultYn", "Y");
			resultMap.put("resultMsg", "정상적으로 저장 되었습니다.");
		} catch (Exception e) {
			e.printStackTrace();
			resultMap.put("resultYn", "N");
			resultMap.put("resultMsg", "작업을 실패하였습니다\\n관리자에게 문의하세요.");
		}
		
		modelAndView.addObject("result", RuiConverter.createDataset("result", resultMap));
		
		return modelAndView;
	}
	
	@RequestMapping(value="/anl/receiptAnlRqpr.do")
	public ModelAndView receiptAnlRqpr(
			@RequestParam HashMap<String, Object> input,
			HttpServletRequest request, 
			HttpServletResponse response,
			HttpSession session,
			ModelMap model
			){
		
		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		
    	//input = StringUtil.toUtf8(input);
    	input = StringUtil.toUtf8Input(input);

		LOGGER.debug("###########################################################");
		LOGGER.debug("AnlRqprController - receiptAnlRqpr 분석의뢰 접수");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");
		
		ModelAndView modelAndView = new ModelAndView("ruiView");
		
		Map<String,Object> resultMap = new HashMap<String, Object>();
		
		try {
			Map<String, Object> anlRqprDataSet = RuiConverter.convertToDataSet(request, "anlRqprDataSet").get(0);
			
			anlRqprDataSet.put("acpcStCd", "03");
			anlRqprDataSet.put("userId", input.get("_userId"));
			
			anlRqprService.updateReceiptAnlRqpr(anlRqprDataSet);
			
			resultMap.put("cmd", "receipt");
			resultMap.put("resultYn", "Y");
			resultMap.put("resultMsg", "정상적으로 접수 되었습니다.");
		} catch (Exception e) {
			e.printStackTrace();
			resultMap.put("resultYn", "N");
			resultMap.put("resultMsg", "작업을 실패하였습니다\\n관리자에게 문의하세요.");
		}
		
		modelAndView.addObject("result", RuiConverter.createDataset("result", resultMap));
		
		return modelAndView;
	}
	
	@RequestMapping(value="/anl/anlRqprEndPopup.do")
	public String anlRqprEndPopup(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
		
    	input = StringUtil.toUtf8(input);

		LOGGER.debug("###########################################################");
		LOGGER.debug("AnlRqprController - anlRqprEndPopup 분석의뢰 반려/분석중단 팝업");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");
		
		
		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);
		
		model.addAttribute("inputData", input);
		
		return "web/anl/rqpr/anlRqprEndPopup";
	}
	
	@RequestMapping(value="/anl/saveAnlRqprEnd.do")
	public ModelAndView saveAnlRqprEnd(
			@RequestParam HashMap<String, Object> input,
			HttpServletRequest request, 
			HttpServletResponse response,
			HttpSession session,
			ModelMap model
			){
		
		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		
    	input = StringUtil.toUtf8Output(input);

		LOGGER.debug("###########################################################");
		LOGGER.debug("AnlRqprController - saveAnlRqprEnd 분석의뢰 반려/분석중단 처리");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");
		
		ModelAndView modelAndView = new ModelAndView("ruiView");
		
		Map<String,Object> resultMap = new HashMap<String, Object>();

		try {
			
			anlRqprService.updateAnlRqprEnd(input);
			
			resultMap.put("resultYn", "Y");
			resultMap.put("resultMsg", "정상적으로 처리 되었습니다.");
		} catch (Exception e) {
			e.printStackTrace();
			resultMap.put("resultYn", "N");
			resultMap.put("resultMsg", "작업을 실패하였습니다\\n관리자에게 문의하세요.");
		}
		
		modelAndView.addObject("result", RuiConverter.createDataset("result", resultMap));
		
		return modelAndView;
	}
	
	@RequestMapping(value="/anl/anlRqprExprRsltPopup.do")
	public String anlRqprExprRsltPopup(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
		
    	input = StringUtil.toUtf8(input);

		LOGGER.debug("###########################################################");
		LOGGER.debug("AnlRqprController - anlRqprExprRsltPopup 실험결과 등록/수정 팝업");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");
		
		
		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);
		
		model.addAttribute("inputData", input);
		
		return "web/anl/rqpr/anlRqprExprRsltPopup";
	}
	
	@RequestMapping(value="/anl/getAnlRqprExprInfo.do")
	public ModelAndView getAnlRqprExprInfo(
			@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpServletResponse response,
			HttpSession session,
			ModelMap model
			){

		LOGGER.debug("###########################################################");
		LOGGER.debug("AnlRqprController - getAnlRqprExprInfo [분석의로 실험정보 불러오기]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");
		
		ModelAndView modelAndView = new ModelAndView("ruiView");
		
		input.put("isMng", "0");

		Map<String,Object> anlRqprExprInfo = null;
		List<Map<String,Object>> anlExprTreeList = anlRqprService.getAnlExprTreeList(input);
		
		if(!"0".equals(input.get("rqprExprId"))) {
			anlRqprExprInfo = anlRqprService.getAnlRqprExprInfo(input);
		}

		modelAndView.addObject("anlRqprExprDataSet", RuiConverter.createDataset("anlRqprExprDataSet", anlRqprExprInfo));
		modelAndView.addObject("anlRqprExprMstTreeDataSet", RuiConverter.createDataset("anlRqprExprMstTreeDataSet", anlExprTreeList));
		
		return modelAndView;
	}
	
	@RequestMapping(value="/anl/getAnlExprDtlComboList.do")
	public ModelAndView getAnlRqprExprMchnList(
			@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpServletResponse response,
			HttpSession session,
			ModelMap model
			){

		LOGGER.debug("###########################################################");
		LOGGER.debug("AnlRqprController - getAnlExprDtlComboList [실험정보 상세 콤보 리스트 조회]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");
		
		ModelAndView modelAndView = new ModelAndView("ruiView");
    	
		List<Map<String,Object>> anlExprDtlComboList = anlRqprService.getAnlExprDtlComboList(input);
		
		modelAndView.addObject("mchnInfoId", RuiConverter.createDataset("mchnInfoId", anlExprDtlComboList));
		
		return modelAndView;
	}
	
	@RequestMapping(value="/anl/saveAnlRqprExpr.do")
	public ModelAndView saveAnlRqprExpr(
			@RequestParam HashMap<String, Object> input,
			HttpServletRequest request, 
			HttpServletResponse response,
			HttpSession session,
			ModelMap model
			){
		
		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		
    	input = StringUtil.toUtf8Input(input);

		LOGGER.debug("###########################################################");
		LOGGER.debug("AnlRqprController - saveAnlRqprExpr 분석결과 실험정보 저장");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");
		
		ModelAndView modelAndView = new ModelAndView("ruiView");
		
		Map<String,Object> dataMap = null;
		Map<String,Object> resultMap = new HashMap<String, Object>();

		try {
			dataMap = RuiConverter.convertToDataSet(request, "anlRqprExprDataSet").get(0);

			dataMap.put("userId", input.get("_userId"));
			
			anlRqprService.saveAnlRqprExpr(dataMap);
			
			resultMap.put("resultYn", "Y");
			resultMap.put("resultMsg", "정상적으로 저장 되었습니다.");
			resultMap.put("rqprExprId", dataMap.get("rqprExprId"));
		} catch (Exception e) {
			e.printStackTrace();
			resultMap.put("resultYn", "N");
			resultMap.put("resultMsg", "작업을 실패하였습니다\\n관리자에게 문의하세요.");
		}
		
		modelAndView.addObject("result", RuiConverter.createDataset("result", resultMap));
		
		return modelAndView;
	}
	
	@RequestMapping(value="/anl/deleteAnlRqprExpr.do")
	public ModelAndView deleteAnlRqprExpr(
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
		LOGGER.debug("AnlRqprController - deleteAnlRqprExpr 분석결과 실험정보 삭제");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");
		
		ModelAndView modelAndView = new ModelAndView("ruiView");
		
		String userId = (String)input.get("_userId");
		Map<String,Object> resultMap = new HashMap<String, Object>();
		List<Map<String,Object>> deleteList = null;

		try {
			deleteList = RuiConverter.convertToDataSet(request, "anlRqprExprDataSet");
			
			for(Map<String,Object> data : deleteList) {
				data.put("userId", userId);
			}
			
			anlRqprService.deleteAnlRqprExpr(deleteList);

			resultMap.put("cmd", "deleteAnlRqprExpr");
			resultMap.put("resultYn", "Y");
			resultMap.put("resultMsg", "정상적으로 삭제 되었습니다.");
		} catch (Exception e) {
			e.printStackTrace();
			resultMap.put("resultYn", "N");
			resultMap.put("resultMsg", "작업을 실패하였습니다\\n관리자에게 문의하세요.");
		}
		
		modelAndView.addObject("result", RuiConverter.createDataset("result", resultMap));
		
		return modelAndView;
	}
	
	@RequestMapping(value="/anl/getAnlRqprExprList.do")
	public ModelAndView getAnlRqprExprList(
			@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpServletResponse response,
			HttpSession session,
			ModelMap model
			){

		LOGGER.debug("###########################################################");
		LOGGER.debug("AnlRqprController - getAnlRqprExprList [분석결과 실험정보 리스트 검색]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");
		
		ModelAndView modelAndView = new ModelAndView("ruiView");
    	
		List<Map<String,Object>> anlRqprExprList = anlRqprService.getAnlRqprExprList(input);
		
		modelAndView.addObject("anlRqprExprDataSet", RuiConverter.createDataset("anlRqprExprDataSet", anlRqprExprList));
		
		return modelAndView;
	}
	
	@RequestMapping(value="/anl/saveAnlRqprRslt.do")
	public ModelAndView saveAnlRqprRslt(
			@RequestParam HashMap<String, Object> input,
			HttpServletRequest request, 
			HttpServletResponse response,
			HttpSession session,
			ModelMap model
			){
		
		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		
    	input = StringUtil.toUtf8Input(input);

		LOGGER.debug("###########################################################");
		LOGGER.debug("AnlRqprController - saveAnlRqprRslt 분석결과 저장");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");
		
		ModelAndView modelAndView = new ModelAndView("ruiView");
		
		Map<String,Object> dataMap = null;
		Map<String,Object> resultMap = new HashMap<String, Object>();
		
		try {
			dataMap = RuiConverter.convertToDataSet(request, "anlRqprDataSet").get(0);

			dataMap.put("cmd", input.get("save"));
			dataMap.put("userId", input.get("_userId"));
			dataMap.put("realRgstId", input.get("realRgstId"));
			
			anlRqprService.saveAnlRqprRslt(dataMap);

			resultMap.put("cmd", "saveAnlRqprRslt");
			resultMap.put("resultYn", "Y");
			resultMap.put("resultMsg", "정상적으로 저장 되었습니다.");
		} catch (Exception e) {
			e.printStackTrace();
			resultMap.put("resultYn", "N");
			resultMap.put("resultMsg", "작업을 실패하였습니다\\n관리자에게 문의하세요.");
		}
		
		modelAndView.addObject("result", RuiConverter.createDataset("result", resultMap));
		
		return modelAndView;
	}
	
	@RequestMapping(value="/anl/requestAnlRqprRsltApproval.do")
	public ModelAndView requestAnlRqprRsltApproval(
			@RequestParam HashMap<String, Object> input,
			HttpServletRequest request, 
			HttpServletResponse response,
			HttpSession session,
			ModelMap model
			){
		
		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		
    	input = StringUtil.toUtf8Input(input);

		LOGGER.debug("###########################################################");
		LOGGER.debug("AnlRqprController - requestAnlRqprRsltApproval 분석결과 결재의뢰");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");
		
		ModelAndView modelAndView = new ModelAndView("ruiView");
		
		Map<String,Object> dataMap = null;
		Map<String,Object> resultMap = new HashMap<String, Object>();
		
		try {
			dataMap = RuiConverter.convertToDataSet(request, "anlRqprDataSet").get(0);

			dataMap.put("cmd", "requestRsltApproval");
			dataMap.put("userId", input.get("_userId"));
			dataMap.put("userNm", input.get("_userNm"));
			dataMap.put("userJobxName", input.get("_userJobxName"));
			dataMap.put("userDeptName", input.get("_userDeptName"));
			
			anlRqprService.saveAnlRqprRslt(dataMap);

			resultMap.put("cmd", "requestRsltApproval");
			resultMap.put("resultYn", "Y");
			resultMap.put("resultMsg", "");
		} catch (Exception e) {
			e.printStackTrace();
			resultMap.put("resultYn", "N");
			resultMap.put("resultMsg", "작업을 실패하였습니다\\n관리자에게 문의하세요.");
		}
		
		modelAndView.addObject("result", RuiConverter.createDataset("result", resultMap));
		
		return modelAndView;
	}

	@RequestMapping(value="/anl/anlExprList.do")
	public String anlExprList(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			) throws Exception{
		
		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);
		
    	input = StringUtil.toUtf8(input);

		LOGGER.debug("###########################################################");
		LOGGER.debug("AnlRqprController - anlExprList [실험정보 리스트 화면 이동]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");
		
		model.addAttribute("inputData", input);

		return "web/anl/rqpr/anlExprList";
	}
	
	@RequestMapping(value="/anl/getAnlExprMstList.do")
	public ModelAndView getAnlExprMstList(
			@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpServletResponse response,
			HttpSession session,
			ModelMap model
			){

		LOGGER.debug("###########################################################");
		LOGGER.debug("AnlRqprController - getAnlExprMstList [실험정보 마스터 리스트 조회]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");
		
		ModelAndView modelAndView = new ModelAndView("ruiView");

		List<Map<String,Object>> anlExprMstList = anlRqprService.getAnlExprTreeList(input);

		modelAndView.addObject("anlRqprExprMstTreeDataSet", RuiConverter.createDataset("anlRqprExprMstTreeDataSet", anlExprMstList));
		
		return modelAndView;
	}
	
	@RequestMapping(value="/anl/saveAnlExprMst.do")
	public ModelAndView saveAnlExprMst(
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
		LOGGER.debug("AnlRqprController - saveAnlExprMst 실험 마스터 정보 저장");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");
		
		ModelAndView modelAndView = new ModelAndView("ruiView");

		Map<String,Object> resultMap = new HashMap<String, Object>();
		List<Map<String,Object>> anlExprMstTreeDataSet = null;

		try {
			anlExprMstTreeDataSet = RuiConverter.convertToDataSet(request, "anlExprMstTreeDataSet");
			
			for(Map<String,Object> data : anlExprMstTreeDataSet) {
				data.put("userId", input.get("_userId"));
			}
			
			anlRqprService.saveAnlExprMst(anlExprMstTreeDataSet);

			resultMap.put("cmd", "saveAnlExprMst");
			resultMap.put("resultYn", "Y");
			resultMap.put("resultMsg", "정상적으로 저장 되었습니다.");
		} catch (Exception e) {
			e.printStackTrace();
			resultMap.put("resultYn", "N");
			resultMap.put("resultMsg", "작업을 실패하였습니다\\n관리자에게 문의하세요.");
		}
		
		modelAndView.addObject("result", RuiConverter.createDataset("result", resultMap));
		
		return modelAndView;
	}
	
	@RequestMapping(value="/anl/getAnlExprDtlList.do")
	public ModelAndView getAnlExprDtlList(
			@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpServletResponse response,
			HttpSession session,
			ModelMap model
			){

		LOGGER.debug("###########################################################");
		LOGGER.debug("AnlRqprController - getAnlExprDtlList [실험정보 상세 리스트 조회]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");
		
		ModelAndView modelAndView = new ModelAndView("ruiView");

		List<Map<String,Object>> anlExprDtlList = anlRqprService.getAnlExprDtlList(input);

		modelAndView.addObject("anlExprDtlDataSet", RuiConverter.createDataset("anlExprDtlDataSet", anlExprDtlList));
		
		return modelAndView;
	}
	
	
	/**
	 *  분석의뢰 완료시 (통보자 추가저장)
	 */
	@RequestMapping(value="/anl/insertAnlRqprInfm.do")
	public ModelAndView insertAnlRqprInfm(
			@RequestParam HashMap<String, Object> input,
			HttpServletRequest request, 
			HttpServletResponse response,
			HttpSession session,
			ModelMap model
			){
		
		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		
    	input = StringUtil.toUtf8Input(input);

		LOGGER.debug("###########################################################");
		LOGGER.debug("AnlRqprController - insertAnlRqprInfm 분석의뢰 완료시 (통보자 추가저장)");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");
		
		ModelAndView modelAndView = new ModelAndView("ruiView");

		Map<String,Object> resultMap = new HashMap<String, Object>();
		Map<String,Object> dataMap = new HashMap<String, Object>();
		List<Map<String,Object>> anlExprDtlDataSet = null;

		try {
			
			dataMap.put("input", input);
			dataMap.put("anlRqprDataSet", RuiConverter.convertToDataSet(request, "anlRqprDataSet").get(0));
			
			anlRqprService.insertAnlRqprInfm(dataMap);

			resultMap.put("cmd", "insertAnlRqprInfm");
			resultMap.put("resultYn", "Y");
			resultMap.put("resultMsg", "정상적으로 저장 되었습니다.");
		} catch (Exception e) {
			e.printStackTrace();
			resultMap.put("resultYn", "N");
			resultMap.put("resultMsg", "작업을 실패하였습니다\\n관리자에게 문의하세요.");
		}
		
		modelAndView.addObject("result", RuiConverter.createDataset("result", resultMap));
		
		return modelAndView;
	}
	
		
	@RequestMapping(value="/anl/saveAnlExprDtl.do")
	public ModelAndView saveAnlExprDtl(
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
		LOGGER.debug("AnlRqprController - saveAnlExprDtl 실험 상세 정보 저장");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");
		
		ModelAndView modelAndView = new ModelAndView("ruiView");

		Map<String,Object> resultMap = new HashMap<String, Object>();
		List<Map<String,Object>> anlExprDtlDataSet = null;

		try {
			anlExprDtlDataSet = RuiConverter.convertToDataSet(request, "anlExprDtlDataSet");
			
			for(Map<String,Object> data : anlExprDtlDataSet) {
				data.put("userId", input.get("_userId"));
			}
			
			anlRqprService.saveAnlExprDtl(anlExprDtlDataSet);

			resultMap.put("cmd", "saveAnlExprDtl");
			resultMap.put("resultYn", "Y");
			resultMap.put("resultMsg", "정상적으로 저장 되었습니다.");
		} catch (Exception e) {
			e.printStackTrace();
			resultMap.put("resultYn", "N");
			resultMap.put("resultMsg", "작업을 실패하였습니다\\n관리자에게 문의하세요.");
		}
		
		modelAndView.addObject("result", RuiConverter.createDataset("result", resultMap));
		
		return modelAndView;
	}
	
	@RequestMapping(value="/anl/deleteAnlExprDtl.do")
	public ModelAndView deleteAnlExprDtl(
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
		LOGGER.debug("AnlRqprController - deleteAnlExprDtl 실험 상세 정보 삭제");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");
		
		ModelAndView modelAndView = new ModelAndView("ruiView");

		Map<String,Object> resultMap = new HashMap<String, Object>();
		List<Map<String,Object>> anlExprDtlDataSet = null;

		try {
			anlExprDtlDataSet = RuiConverter.convertToDataSet(request, "anlExprDtlDataSet");
			
			for(Map<String,Object> data : anlExprDtlDataSet) {
				data.put("userId", input.get("_userId"));
			}
			
			anlRqprService.deleteAnlExprDtl(anlExprDtlDataSet);

			resultMap.put("cmd", "deleteAnlExprDtl");
			resultMap.put("resultYn", "Y");
			resultMap.put("resultMsg", "정상적으로 삭제 되었습니다.");
		} catch (Exception e) {
			e.printStackTrace();
			resultMap.put("resultYn", "N");
			resultMap.put("resultMsg", "작업을 실패하였습니다\\n관리자에게 문의하세요.");
		}
		
		modelAndView.addObject("result", RuiConverter.createDataset("result", resultMap));
		
		return modelAndView;
	}

	@RequestMapping(value="/anl/anlExprExpSimulationPopup.do")
	public String anlExprExpSimulationPopup(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			) throws Exception{
		
		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);
		
    	input = StringUtil.toUtf8(input);

		LOGGER.debug("###########################################################");
		LOGGER.debug("AnlRqprController - anlExprExpSimulationPopup [실험수가 Simulation 팝업]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");
		
		model.addAttribute("inputData", input);

		return "web/anl/rqpr/anlExprExpSimulationPopup";
	}

	@RequestMapping(value="/anl/anlRqprSrchView.do")
	public String anlRqprSrchView(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			) throws Exception{
		
		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);

		LOGGER.debug("###########################################################");
		LOGGER.debug("AnlRqprController - anlRqprSrchView [분석의뢰서 상세 화면 이동]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");
		
		model.addAttribute("inputData", input);

		return "web/anl/rqpr/anlRqprSrchView";
	}
	
	@RequestMapping(value="/anl/exprWayPopup.do")
	public String exprWayPopupView(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			) throws Exception{
		
		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);

		LOGGER.debug("###########################################################");
		LOGGER.debug("exprWayPopupView - exprWayPopupView [실험방법 상세 팝업화면 이동]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");
		
		input.put("exprWay", anlRqprService.getExprWay(input));
		model.addAttribute("inputData", input);

		return "web/anl/rqpr/exprWayPopup";
	}
	
	/**
	 * 반려의견 팝업
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/anl/anlGvbRsonPopup.do")
	public String anlGvbRsonPopup(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			) throws Exception{
		
		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);

		LOGGER.debug("###########################################################");
		LOGGER.debug("exprWayPopupView - anlGvbRsonPopup [반려의견 팝업화면 이동]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");
		
		input.put("anlGvbRson", anlRqprService.getAnlGvbRson(input));
		model.addAttribute("inputData", input);

		return "web/anl/rqpr/anlGvbRsonPopup";
	}
	
	
}