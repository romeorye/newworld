package iris.web.rlab.rqpr.controller;

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

import iris.web.rlab.rqpr.service.RlabRqprService;
import iris.web.common.code.service.CodeCacheManager;
import iris.web.common.converter.RuiConverter;
import iris.web.common.util.DateUtil;
import iris.web.common.util.StringUtil;
import iris.web.stat.rlab.service.RlabStatService;
import iris.web.system.attach.service.AttachFileService;
import iris.web.system.base.IrisBaseController;

/********************************************************************************
 * NAME : RlabRqprController.java
 * DESC : 신뢰성 시험의뢰 - 신뢰성 시험의뢰 관리 controller
 * PROJ : IRIS UPGRADE 1차 프로젝트
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION
 * ----------  ------  ---------------------------------------------------------
 * 2018.08.06  정현웅	최초생성
 *********************************************************************************/

@Controller
public class RlabRqprController extends IrisBaseController {

	@Resource(name = "codeCacheManager")
	private CodeCacheManager codeCacheManager;

	@Resource(name = "rlabRqprService")
	private RlabRqprService rlabRqprService;

	@Resource(name = "attachFileService")
	private AttachFileService attachFileService;

	@Resource(name="rlabStatService")
	private RlabStatService rlabStatService;

	static final Logger LOGGER = LogManager.getLogger(RlabRqprController.class);

	@RequestMapping(value="/rlab/rlabRqprList.do")
	public String rlabRqprList(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			) throws Exception{

		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);

		input = StringUtil.toUtf8(input);

		LOGGER.debug("###########################################################");
		LOGGER.debug("RlabRqprController - rlabRqprList [신뢰성 시험의뢰 리스트 화면 이동]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		String today = DateUtil.getDateString();

		if(StringUtil.isNullString(input.get("fromRqprDt"))) {
			input.put("fromRqprDt", DateUtil.addMonths(today, -1, "yyyy-MM-dd"));
			input.put("toRqprDt", today);
		}

		model.addAttribute("inputData", input);

		return "web/rlab/rqpr/rlabRqprList";
	}

	@RequestMapping(value="/rlab/getRlabChrgList.do")
	public ModelAndView getRlabChrgList(
			@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpServletResponse response,
			HttpSession session,
			ModelMap model
			){

		LOGGER.debug("###########################################################");
		LOGGER.debug("RlabRqprController - getRlabChrgList [신뢰성 시험담당자 리스트 검색]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		ModelAndView modelAndView = new ModelAndView("ruiView");

        // 신뢰성 시험담당자 리스트 조회
		List<Map<String,Object>> rlabChrgList = rlabRqprService.getRlabChrgList(input);

		modelAndView.addObject("rlabChrgDataSet", RuiConverter.createDataset("rlabChrgDataSet", rlabChrgList));

		return modelAndView;
	}

	@RequestMapping(value="/rlab/getRlabRqprList.do")
	public ModelAndView getRlabRqprList(
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
		LOGGER.debug("RlabRqprController - getRlabRqprList [신뢰성 시험의뢰 리스트 검색]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		ModelAndView modelAndView = new ModelAndView("ruiView");

        // 신뢰성 시험의뢰 리스트 조회
		List<Map<String,Object>> rlabRqprList = rlabRqprService.getRlabRqprList(input);

		modelAndView.addObject("rlabRqprDataSet", RuiConverter.createDataset("rlabRqprDataSet", rlabRqprList));

		return modelAndView;
	}

	@RequestMapping(value="/rlab/rlabRqprRgst.do")
	public String rlabRqprRgst(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			) throws Exception{

		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);

		LOGGER.debug("###########################################################");
		LOGGER.debug("RlabRqprController - rlabRqprRgst [신뢰성 시험의뢰서 등록 화면 이동]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		List <Map<String, Object>> infmTypeCdList  = codeCacheManager.retrieveCodeValueListForCache("RLAB_INFM_TYPE_CD"); // 통보유형
		List <Map<String, Object>> smpoTrtmCdList  = codeCacheManager.retrieveCodeValueListForCache("SMPO_TRTM_CD"); // 시료처리구분

		model.addAttribute("inputData", input);
		model.addAttribute("infmTypeCdList", infmTypeCdList);
		model.addAttribute("smpoTrtmCdList", smpoTrtmCdList);

		return "web/rlab/rqpr/rlabRqprRgst";
	}

	@RequestMapping(value="/rlab/rlabChrgDialog.do")
	public String rlabChrgDialog(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			) throws Exception{

		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);

		LOGGER.debug("###########################################################");
		LOGGER.debug("RlabRqprController - rlabChrgDialog [신뢰성 시험담당자 리스트 화면 이동]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		return "web/rlab/rqpr/rlabChrgDialog";
	}

	@RequestMapping(value="/rlab/getRlabRqprInfo.do")
	public ModelAndView getRlabRqprInfo(
			@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpServletResponse response,
			HttpSession session,
			ModelMap model
			){

		LOGGER.debug("###########################################################");
		LOGGER.debug("RlabRqprController - getRlabRqprInfo [신뢰성 시험의로 정보 불러오기]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		ModelAndView modelAndView = new ModelAndView("ruiView");

		Map<String,Object> rlabRqprInfo = rlabRqprService.getRlabRqprInfo(input);
		List<Map<String,Object>> rlabRqprSmpoList = rlabRqprService.getRlabRqprSmpoList(input);

		modelAndView.addObject("rlabRqprDataSet", RuiConverter.createDataset("rlabRqprDataSet", rlabRqprInfo));
		modelAndView.addObject("rlabRqprSmpoDataSet", RuiConverter.createDataset("rlabRqprSmpoDataSet", rlabRqprSmpoList));

		return modelAndView;
	}

	@RequestMapping(value="/rlab/rlabRqprSearchPopup.do")
	public String rlabRqprSearchPopup(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){

		LOGGER.debug("###########################################################");
		LOGGER.debug("RlabRqprController - rlabRqprSearchPopup 신뢰성 시험의뢰 리스트 조회 팝업");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");


		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);

		model.addAttribute("inputData", input);

		return "web/rlab/rqpr/rlabRqprSearchPopup";
	}

	/**
	 *   > 신뢰성시험 장비 팝업 화면 호출
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/rlab/retrieveRlabExatMchnInfoPop.do")
	public String retrieveMchnInfoPop(@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){

		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);

		input = StringUtil.toUtf8(input);
		List<Map<String,Object>> mchnClCdlist = rlabStatService.retrieveRlabMchnClCd(input);
        model.addAttribute("inputData", input);
        model.addAttribute("mchnClCdlist", mchnClCdlist);


		return  "web/rlab/rqpr/rlabExatMchnInfoPop";
	}


	/**
	 *   > 신뢰성시험 장비 팝업 목록조회
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/rlab/retrieveMachineList.do")
	public ModelAndView retrieveMachineList(@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		ModelAndView modelAndView = new ModelAndView("ruiView");
		input = StringUtil.toUtf8(input);

		List<Map<String, Object>> resultList = rlabRqprService.retrieveMachineList(input);
		modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", resultList));

		return  modelAndView;
	}

	@RequestMapping(value="/rlab/regstRlabRqpr.do")
	public ModelAndView regstRlabRqpr(
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
		LOGGER.debug("RlabRqprController - regstRlabRqpr 신뢰성 시험의뢰 등록");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		ModelAndView modelAndView = new ModelAndView("ruiView");

		Map<String,Object> dataMap = new HashMap<String, Object>();
		Map<String,Object> resultMap = new HashMap<String, Object>();

		try {
			dataMap.put("input", input);
			dataMap.put("rlabRqprDataSet", RuiConverter.convertToDataSet(request, "rlabRqprDataSet").get(0));
			dataMap.put("rlabRqprSmpoDataSet", RuiConverter.convertToDataSet(request, "rlabRqprSmpoDataSet"));
			dataMap.put("rlabRqprRltdDataSet", RuiConverter.convertToDataSet(request, "rlabRqprRltdDataSet"));

			rlabRqprService.insertRlabRqpr(dataMap);

			resultMap.put("resultYn", "Y");
			resultMap.put("resultMsg", "정상적으로 등록 되었습니다.");
		} catch (Exception e) {
			e.printStackTrace();
			resultMap.put("resultYn", "N");
			resultMap.put("resultMsg", "작업을 실패하였습니다\n관리자에게 문의하세요.");
		}

		modelAndView.addObject("result", RuiConverter.createDataset("result", resultMap));

		return modelAndView;
	}

	@RequestMapping(value="/rlab/rlabRqprDetail.do")
	public String rlabRqprDetail(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			) throws Exception{

		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);

		LOGGER.debug("###########################################################");
		LOGGER.debug("RlabRqprController - rlabRqprDetail [신뢰성 시험의뢰서 상세 화면 이동]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		List <Map<String, Object>> infmTypeCdList  = codeCacheManager.retrieveCodeValueListForCache("RLAB_INFM_TYPE_CD"); // 통보유형
		List <Map<String, Object>> smpoTrtmCdList  = codeCacheManager.retrieveCodeValueListForCache("SMPO_TRTM_CD"); // 시료처리구분

		model.addAttribute("inputData", input);
		model.addAttribute("infmTypeCdList", infmTypeCdList);
		model.addAttribute("smpoTrtmCdList", smpoTrtmCdList);

		return "web/rlab/rqpr/rlabRqprDetail";
	}

	@RequestMapping(value="/rlab/getRlabRqprDetailInfo.do")
	public ModelAndView getRlabRqprDetailInfo(
			@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpServletResponse response,
			HttpSession session,
			ModelMap model
			){

		LOGGER.debug("###########################################################");
		LOGGER.debug("RlabRqprController - getRlabRqprDetailInfo [신뢰성 시험의로 상세정보 조회]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		ModelAndView modelAndView = new ModelAndView("ruiView");
		List<Map<String,Object>> rlabRqprDecodeSmpoList = null;
		List<Map<String,Object>> rlabRqprDecodeRltdList = null;
		List<Map<String,Object>> rlabRqprDecodeExatList = null;

		Map<String,Object> rlabRqprInfo = rlabRqprService.getRlabRqprInfo(input);
		List<Map<String,Object>> rlabRqprSmpoList = rlabRqprService.getRlabRqprSmpoList(input);
		List<Map<String,Object>> rlabRqprRltdList = rlabRqprService.getRlabRqprRltdList(input);
		List<Map<String,Object>> rlabRqprExatList = rlabRqprService.getRlabRqprExatList(input);
		Map<String,Object> rlabRqprStptInfo = rlabRqprService.getRlabRqprStptInfo(input);					//만족도

		input.put("attcFilId", rlabRqprInfo.get("rqprAttcFileId"));

		List<Map<String,Object>> rqprAttachFileList = attachFileService.getAttachFileList(input);

		input.put("attcFilId", rlabRqprInfo.get("rsltAttcFileId"));

		List<Map<String,Object>> rsltAttachFileList = attachFileService.getAttachFileList(input);

		rlabRqprInfo = StringUtil.toUtf8Output((HashMap) rlabRqprInfo);

		modelAndView.addObject("rlabRqprDataSet", RuiConverter.createDataset("rlabRqprDataSet", rlabRqprInfo));
		modelAndView.addObject("rlabRqprSmpoDataSet", RuiConverter.createDataset("rlabRqprSmpoDataSet", rlabRqprSmpoList));
		modelAndView.addObject("rlabRqprRltdDataSet", RuiConverter.createDataset("rlabRqprRltdDataSet", rlabRqprRltdList));
		modelAndView.addObject("rlabRqprExatDataSet", RuiConverter.createDataset("rlabRqprExatDataSet", rlabRqprExatList));
		modelAndView.addObject("rlabRqprAttachDataSet", RuiConverter.createDataset("rlabRqprAttachDataSet", rqprAttachFileList));
		modelAndView.addObject("rlabRqprRsltAttachDataSet", RuiConverter.createDataset("rlabRqprRsltAttachDataSet", rsltAttachFileList));
		modelAndView.addObject("rlabRqprStptDataSet", RuiConverter.createDataset("rlabRqprStptDataSet", rlabRqprStptInfo));

		return modelAndView;
	}

	@RequestMapping(value="/rlab/updateRlabRqpr.do")
	public ModelAndView updateRlabRqpr(
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
		LOGGER.debug("RlabRqprController - updateRlabRqpr 신뢰성 시험의뢰 수정");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		ModelAndView modelAndView = new ModelAndView("ruiView");

		Map<String,Object> dataMap = new HashMap<String, Object>();
		Map<String,Object> resultMap = new HashMap<String, Object>();

		try {
			input.put("cmd", "update");

			dataMap.put("input", input);
			dataMap.put("rlabRqprDataSet", RuiConverter.convertToDataSet(request, "rlabRqprDataSet").get(0));
			dataMap.put("rlabRqprSmpoDataSet", RuiConverter.convertToDataSet(request, "rlabRqprSmpoDataSet"));
			dataMap.put("rlabRqprRltdDataSet", RuiConverter.convertToDataSet(request, "rlabRqprRltdDataSet"));

			rlabRqprService.updateRlabRqpr(dataMap);

			resultMap.put("cmd", "update");
			resultMap.put("resultYn", "Y");
			resultMap.put("resultMsg", "정상적으로 수정 되었습니다.");
		} catch (Exception e) {
			e.printStackTrace();
			resultMap.put("resultYn", "N");
			resultMap.put("resultMsg", "작업을 실패하였습니다\n관리자에게 문의하세요.");
		}

		modelAndView.addObject("result", RuiConverter.createDataset("result", resultMap));

		return modelAndView;
	}

	@RequestMapping(value="/rlab/requestRlabRqprApproval.do")
	public ModelAndView requestRlabRqprApproval(
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
		LOGGER.debug("RlabRqprController - requestRlabRqprApproval 신뢰성 시험의뢰 결재요청");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		ModelAndView modelAndView = new ModelAndView("ruiView");

		Map<String,Object> dataMap = new HashMap<String, Object>();
		Map<String,Object> resultMap = new HashMap<String, Object>();

		try {
			input.put("cmd", "requestApproval");

			dataMap.put("input", input);
			dataMap.put("rlabRqprDataSet", RuiConverter.convertToDataSet(request, "rlabRqprDataSet").get(0));
			dataMap.put("rlabRqprSmpoDataSet", RuiConverter.convertToDataSet(request, "rlabRqprSmpoDataSet"));
			dataMap.put("rlabRqprRltdDataSet", RuiConverter.convertToDataSet(request, "rlabRqprRltdDataSet"));

			rlabRqprService.updateRlabRqpr(dataMap);

			resultMap.put("cmd", "requestApproval");
			resultMap.put("resultYn", "Y");
			resultMap.put("resultMsg", "");
		} catch (Exception e) {
			e.printStackTrace();
			resultMap.put("resultYn", "N");
			resultMap.put("resultMsg", "작업을 실패하였습니다\n관리자에게 문의하세요.");
		}

		modelAndView.addObject("result", RuiConverter.createDataset("result", resultMap));

		return modelAndView;
	}

	@RequestMapping(value="/rlab/deleteRlabRqpr.do")
	public ModelAndView deleteRlabRqpr(
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
		LOGGER.debug("RlabRqprController - deleteRlabRqpr 신뢰성 시험의뢰 삭제");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		ModelAndView modelAndView = new ModelAndView("ruiView");

		Map<String,Object> resultMap = new HashMap<String, Object>();

		try {
			rlabRqprService.deleteRlabRqpr(input);

			resultMap.put("cmd", "delete");
			resultMap.put("resultYn", "Y");
			resultMap.put("resultMsg", "정상적으로 삭제 되었습니다.");
		} catch (Exception e) {
			e.printStackTrace();
			resultMap.put("resultYn", "N");
			resultMap.put("resultMsg", "작업을 실패하였습니다\n관리자에게 문의하세요.");
		}

		modelAndView.addObject("result", RuiConverter.createDataset("result", resultMap));

		return modelAndView;
	}

	@RequestMapping(value="/rlab/rlabRqprOpinitionPopup.do")
	public String rlabRqprOpinitionPopup(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){

		LOGGER.debug("###########################################################");
		LOGGER.debug("RlabRqprController - rlabRqprOpinitionPopup 신뢰성 시험의뢰 의견 팝업");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");


		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);

		model.addAttribute("inputData", input);

		return "web/rlab/rqpr/rlabRqprOpinitionPopup";
	}

	@RequestMapping(value="/rlab/getRlabRqprOpinitionList.do")
	public ModelAndView getRlabRqprOpinitionList(
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
		LOGGER.debug("RlabRqprController - getRlabRqprOpinitionList [신뢰성 시험의뢰 의견 리스트 검색]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		ModelAndView modelAndView = new ModelAndView("ruiView");

		List<Map<String,Object>> rlabRqprOpinitionList = rlabRqprService.getRlabRqprOpinitionList(input);

		modelAndView.addObject("rlabRqprOpinitionDataSet", RuiConverter.createDataset("rlabRqprOpinitionDataSet", rlabRqprOpinitionList));

		return modelAndView;
	}

	@RequestMapping(value="/rlab/saveRlabRqprOpinition.do")
	public ModelAndView saveRlabRqprOpinition(
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
		LOGGER.debug("RlabRqprController - saveRlabRqprOpinition 신뢰성 시험의뢰 의견 저장");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		ModelAndView modelAndView = new ModelAndView("ruiView");

		Map<String,Object> resultMap = new HashMap<String, Object>();

		try {
			rlabRqprService.saveRlabRqprOpinition(input);

			resultMap.put("event", "0".equals(input.get("opiId")) ? "I" : "U");
			resultMap.put("resultYn", "Y");
			resultMap.put("resultMsg", "정상적으로 저장 되었습니다.");
		} catch (Exception e) {
			e.printStackTrace();
			resultMap.put("resultYn", "N");
			resultMap.put("resultMsg", "작업을 실패하였습니다\n관리자에게 문의하세요.");
		}

		modelAndView.addObject("result", RuiConverter.createDataset("result", resultMap));

		return modelAndView;
	}

	@RequestMapping(value="/rlab/deleteRlabRqprOpinition.do")
	public ModelAndView deleteRlabRqprOpinition(
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
		LOGGER.debug("RlabRqprController - deleteRlabRqprOpinition 신뢰성 시험의뢰 의견 삭제");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		ModelAndView modelAndView = new ModelAndView("ruiView");

		Map<String,Object> resultMap = new HashMap<String, Object>();

		try {
			rlabRqprService.deleteRlabRqprOpinition(input);

			resultMap.put("event", "D");
			resultMap.put("resultYn", "Y");
			resultMap.put("resultMsg", "정상적으로 삭제 되었습니다.");
		} catch (Exception e) {
			e.printStackTrace();
			resultMap.put("resultYn", "N");
			resultMap.put("resultMsg", "작업을 실패하였습니다\n관리자에게 문의하세요.");
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
	@RequestMapping(value="/rlab/openOpinitionPopup.do")
	public String openOpinitionPopup(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){

		LOGGER.debug("###########################################################");
		LOGGER.debug("RlabRqprController - openOpinitionPopup 신뢰성 시험의뢰 의견 상세팝업");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);

		input.put("opiSbc", rlabRqprService.retrieveOpiSbc(input).replaceAll("\n", "<br/>") );

		model.addAttribute("inputData", input);

		return "web/rlab/rqpr/openOpinitionPopup";
	}

	@RequestMapping(value="/rlab/rlabRqprList4Chrg.do")
	public String rlabRqprList4Chrg(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			) throws Exception{

		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);

		input = StringUtil.toUtf8(input);

		LOGGER.debug("###########################################################");
		LOGGER.debug("RlabRqprController - rlabRqprList4Chrg [신뢰성 시험의뢰 리스트 담당자용 화면 이동]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		String today = DateUtil.getDateString();

		if(input.get("fromRqprDt") == null) {
			input.put("fromRqprDt", DateUtil.addMonths(today, -1, "yyyy-MM-dd"));
			input.put("toRqprDt", today);
		}

		model.addAttribute("inputData", input);

		return "web/rlab/rqpr/rlabRqprList4Chrg";
	}

	@RequestMapping(value="/rlab/rlabRqprDetail4Chrg.do")
	public String rlabRqprDetail4Chrg(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			) throws Exception{

		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);

		input = StringUtil.toUtf8(input);
		LOGGER.debug("###########################################################");
		LOGGER.debug("RlabRqprController - rlabRqprDetail4Chrg [신뢰성 시험의뢰서 상세 담당자용 화면 이동]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		List <Map<String, Object>> infmTypeCdList  = codeCacheManager.retrieveCodeValueListForCache("RLAB_INFM_TYPE_CD"); // 통보유형
		List <Map<String, Object>> smpoTrtmCdList  = codeCacheManager.retrieveCodeValueListForCache("SMPO_TRTM_CD"); // 시료처리구분

		model.addAttribute("inputData", input);
		model.addAttribute("infmTypeCdList", infmTypeCdList);
		model.addAttribute("smpoTrtmCdList", smpoTrtmCdList);

		return "web/rlab/rqpr/rlabRqprDetail4Chrg";
	}

	@RequestMapping(value="/rlab/saveRlabRqpr.do")
	public ModelAndView saveRlabRqpr(
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
		LOGGER.debug("RlabRqprController - saveRlabRqpr 신뢰성 시험의뢰 저장");
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
			dataMap.put("rlabRqprDataSet", RuiConverter.convertToDataSet(request, "rlabRqprDataSet").get(0));
			dataMap.put("rlabRqprSmpoDataSet", RuiConverter.convertToDataSet(request, "rlabRqprSmpoDataSet"));
			dataMap.put("rlabRqprRltdDataSet", RuiConverter.convertToDataSet(request, "rlabRqprRltdDataSet"));

			Map<String, Object> rlabRqprDataSet = RuiConverter.convertToDataSet(request, "rlabRqprDataSet").get(0);
			rlabRqprDataSet.put("userId", input.get("_userId"));

			rlabRqprService.saveRlabRqpr(dataMap);

			resultMap.put("cmd", "saveRlabRqpr");
			resultMap.put("resultYn", "Y");
			resultMap.put("resultMsg", "정상적으로 저장 되었습니다.");
		} catch (Exception e) {
			e.printStackTrace();
			resultMap.put("resultYn", "N");
			resultMap.put("resultMsg", "작업을 실패하였습니다\n관리자에게 문의하세요.");
		}

		modelAndView.addObject("result", RuiConverter.createDataset("result", resultMap));

		return modelAndView;
	}

	@RequestMapping(value="/rlab/receiptRlabRqpr.do")
	public ModelAndView receiptRlabRqpr(
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
		LOGGER.debug("RlabRqprController - receiptRlabRqpr 신뢰성 시험의뢰 접수");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		ModelAndView modelAndView = new ModelAndView("ruiView");

		Map<String,Object> resultMap = new HashMap<String, Object>();

		try {
			Map<String, Object> rlabRqprDataSet = RuiConverter.convertToDataSet(request, "rlabRqprDataSet").get(0);

			rlabRqprDataSet.put("rlabAcpcStCd", "03");
			rlabRqprDataSet.put("userId", input.get("_userId"));

			rlabRqprService.updateReceiptRlabRqpr(rlabRqprDataSet);

			resultMap.put("cmd", "receipt");
			resultMap.put("resultYn", "Y");
			resultMap.put("resultMsg", "정상적으로 접수 되었습니다.");
		} catch (Exception e) {
			e.printStackTrace();
			resultMap.put("resultYn", "N");
			resultMap.put("resultMsg", "작업을 실패하였습니다\n관리자에게 문의하세요.");
		}

		modelAndView.addObject("result", RuiConverter.createDataset("result", resultMap));

		return modelAndView;
	}

	@RequestMapping(value="/rlab/rlabRqprEndPopup.do")
	public String rlabRqprEndPopup(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){

    	input = StringUtil.toUtf8(input);

		LOGGER.debug("###########################################################");
		LOGGER.debug("RlabRqprController - rlabRqprEndPopup 신뢰성 시험의뢰 반려/신뢰성 시험중단 팝업");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");


		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);

		model.addAttribute("inputData", input);

		return "web/rlab/rqpr/rlabRqprEndPopup";
	}

	@RequestMapping(value="/rlab/saveRlabRqprEnd.do")
	public ModelAndView saveRlabRqprEnd(
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
		LOGGER.debug("RlabRqprController - saveRlabRqprEnd 신뢰성 시험의뢰 반려/신뢰성 시험중단 처리");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		ModelAndView modelAndView = new ModelAndView("ruiView");

		Map<String,Object> resultMap = new HashMap<String, Object>();

		try {

			rlabRqprService.updateRlabRqprEnd(input);

			resultMap.put("resultYn", "Y");
			resultMap.put("resultMsg", "정상적으로 처리 되었습니다.");
		} catch (Exception e) {
			e.printStackTrace();
			resultMap.put("resultYn", "N");
			resultMap.put("resultMsg", "작업을 실패하였습니다\n관리자에게 문의하세요.");
		}

		modelAndView.addObject("result", RuiConverter.createDataset("result", resultMap));

		return modelAndView;
	}

	@RequestMapping(value="/rlab/rlabRqprExatRsltPopup.do")
	public String rlabRqprExatRsltPopup(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){

    	input = StringUtil.toUtf8(input);

		LOGGER.debug("###########################################################");
		LOGGER.debug("RlabRqprController - rlabRqprExatRsltPopup 실험결과 등록/수정 팝업");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");


		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);

		model.addAttribute("inputData", input);

		return "web/rlab/rqpr/rlabRqprExatRsltPopup";
	}

	@RequestMapping(value="/rlab/getRlabRqprExatInfo.do")
	public ModelAndView getRlabRqprExatInfo(
			@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpServletResponse response,
			HttpSession session,
			ModelMap model
			){

		LOGGER.debug("###########################################################");
		LOGGER.debug("RlabRqprController - getRlabRqprExatInfo [신뢰성 시험의로 실험정보 불러오기]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		ModelAndView modelAndView = new ModelAndView("ruiView");

		input.put("isMng", "0");

		Map<String,Object> rlabRqprExatInfo = null;
		List<Map<String,Object>> rlabExatTreeList = rlabRqprService.getRlabExatTreeList(input);

		if(!"0".equals(input.get("rqprExatId"))) {
			rlabRqprExatInfo = rlabRqprService.getRlabRqprExatInfo(input);
		}

		modelAndView.addObject("rlabRqprExatDataSet", RuiConverter.createDataset("rlabRqprExatDataSet", rlabRqprExatInfo));
		modelAndView.addObject("rlabRqprExatMstTreeDataSet", RuiConverter.createDataset("rlabRqprExatMstTreeDataSet", rlabExatTreeList));

		return modelAndView;
	}

	@RequestMapping(value="/rlab/getRlabExatDtlComboList.do")
	public ModelAndView getRlabRqprExatMchnList(
			@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpServletResponse response,
			HttpSession session,
			ModelMap model
			){

		LOGGER.debug("###########################################################");
		LOGGER.debug("RlabRqprController - getRlabExatDtlComboList [실험정보 상세 콤보 리스트 조회]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		ModelAndView modelAndView = new ModelAndView("ruiView");

		List<Map<String,Object>> rlabExatDtlComboList = rlabRqprService.getRlabExatDtlComboList(input);

		modelAndView.addObject("mchnInfoId", RuiConverter.createDataset("mchnInfoId", rlabExatDtlComboList));

		return modelAndView;
	}

	@RequestMapping(value="/rlab/saveRlabRqprExat.do")
	public ModelAndView saveRlabRqprExat(
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
		LOGGER.debug("RlabRqprController - saveRlabRqprExat 신뢰성 시험결과 실험정보 저장");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		ModelAndView modelAndView = new ModelAndView("ruiView");

		Map<String,Object> dataMap = null;
		Map<String,Object> resultMap = new HashMap<String, Object>();

		try {
			dataMap = RuiConverter.convertToDataSet(request, "rlabRqprExatDataSet").get(0);

			dataMap.put("userId", input.get("_userId"));

			rlabRqprService.saveRlabRqprExat(dataMap);

			resultMap.put("resultYn", "Y");
			resultMap.put("resultMsg", "정상적으로 저장 되었습니다.");
			resultMap.put("rqprExatId", dataMap.get("rqprExatId"));
		} catch (Exception e) {
			e.printStackTrace();
			resultMap.put("resultYn", "N");
			resultMap.put("resultMsg", "작업을 실패하였습니다\n관리자에게 문의하세요.");
		}

		modelAndView.addObject("result", RuiConverter.createDataset("result", resultMap));

		return modelAndView;
	}

	@RequestMapping(value="/rlab/deleteRlabRqprExat.do")
	public ModelAndView deleteRlabRqprExat(
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
		LOGGER.debug("RlabRqprController - deleteRlabRqprExat 신뢰성 시험결과 실험정보 삭제");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		ModelAndView modelAndView = new ModelAndView("ruiView");

		String userId = (String)input.get("_userId");
		Map<String,Object> resultMap = new HashMap<String, Object>();
		List<Map<String,Object>> deleteList = null;

		try {
			deleteList = RuiConverter.convertToDataSet(request, "rlabRqprExatDataSet");

			for(Map<String,Object> data : deleteList) {
				data.put("userId", userId);
			}

			rlabRqprService.deleteRlabRqprExat(deleteList);

			resultMap.put("cmd", "deleteRlabRqprExat");
			resultMap.put("resultYn", "Y");
			resultMap.put("resultMsg", "정상적으로 삭제 되었습니다.");
		} catch (Exception e) {
			e.printStackTrace();
			resultMap.put("resultYn", "N");
			resultMap.put("resultMsg", "작업을 실패하였습니다\n관리자에게 문의하세요.");
		}

		modelAndView.addObject("result", RuiConverter.createDataset("result", resultMap));

		return modelAndView;
	}

	@RequestMapping(value="/rlab/getRlabRqprExatList.do")
	public ModelAndView getRlabRqprExatList(
			@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpServletResponse response,
			HttpSession session,
			ModelMap model
			){

		LOGGER.debug("###########################################################");
		LOGGER.debug("RlabRqprController - getRlabRqprExatList [신뢰성 시험결과 실험정보 리스트 검색]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		ModelAndView modelAndView = new ModelAndView("ruiView");

		List<Map<String,Object>> rlabRqprExatList = rlabRqprService.getRlabRqprExatList(input);

		modelAndView.addObject("rlabRqprExatDataSet", RuiConverter.createDataset("rlabRqprExatDataSet", rlabRqprExatList));

		return modelAndView;
	}

	@RequestMapping(value="/rlab/saveRlabRqprRslt.do")
	public ModelAndView saveRlabRqprRslt(
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
		LOGGER.debug("RlabRqprController - saveRlabRqprRslt 신뢰성 시험결과 저장");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		ModelAndView modelAndView = new ModelAndView("ruiView");

		Map<String,Object> dataMap = null;
		Map<String,Object> resultMap = new HashMap<String, Object>();

		try {
			dataMap = RuiConverter.convertToDataSet(request, "rlabRqprDataSet").get(0);

			dataMap.put("cmd", input.get("save"));
			dataMap.put("userId", input.get("_userId"));

			rlabRqprService.saveRlabRqprRslt(dataMap);

			resultMap.put("cmd", "saveRlabRqprRslt");
			resultMap.put("resultYn", "Y");
			resultMap.put("resultMsg", "정상적으로 저장 되었습니다.");
		} catch (Exception e) {
			e.printStackTrace();
			resultMap.put("resultYn", "N");
			resultMap.put("resultMsg", "작업을 실패하였습니다\n관리자에게 문의하세요.");
		}

		modelAndView.addObject("result", RuiConverter.createDataset("result", resultMap));

		return modelAndView;
	}

	@RequestMapping(value="/rlab/requestRlabRqprRsltApproval.do")
	public ModelAndView requestRlabRqprRsltApproval(
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
		LOGGER.debug("RlabRqprController - requestRlabRqprRsltApproval 신뢰성 시험결과 결재의뢰");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		ModelAndView modelAndView = new ModelAndView("ruiView");

		Map<String,Object> dataMap = null;
		Map<String,Object> resultMap = new HashMap<String, Object>();

		try {
			dataMap = RuiConverter.convertToDataSet(request, "rlabRqprDataSet").get(0);

			dataMap.put("cmd", "requestRsltApproval");
			dataMap.put("userId", input.get("_userId"));
			dataMap.put("userNm", input.get("_userNm"));
			dataMap.put("userJobxName", input.get("_userJobxName"));
			dataMap.put("userDeptName", input.get("_userDeptName"));

			rlabRqprService.saveRlabRqprRslt(dataMap);

			resultMap.put("cmd", "requestRsltApproval");
			resultMap.put("resultYn", "Y");
			resultMap.put("resultMsg", "");
		} catch (Exception e) {
			e.printStackTrace();
			resultMap.put("resultYn", "N");
			resultMap.put("resultMsg", "작업을 실패하였습니다\n관리자에게 문의하세요.");
		}

		modelAndView.addObject("result", RuiConverter.createDataset("result", resultMap));

		return modelAndView;
	}

	@RequestMapping(value="/rlab/rlabExatList.do")
	public String rlabExatList(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			) throws Exception{

		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);

    	input = StringUtil.toUtf8(input);

		LOGGER.debug("###########################################################");
		LOGGER.debug("RlabRqprController - rlabExatList [실험정보 리스트 화면 이동]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		model.addAttribute("inputData", input);

		return "web/rlab/rqpr/rlabExatList";
	}

	@RequestMapping(value="/rlab/getRlabExatMstList.do")
	public ModelAndView getRlabExatMstList(
			@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpServletResponse response,
			HttpSession session,
			ModelMap model
			){

		LOGGER.debug("###########################################################");
		LOGGER.debug("RlabRqprController - getRlabExatMstList [신뢰성 시험정보 마스터 리스트 조회]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		ModelAndView modelAndView = new ModelAndView("ruiView");

		List<Map<String,Object>> rlabExatMstList = rlabRqprService.getRlabExatTreeList(input);

		modelAndView.addObject("rlabRqprExatMstTreeDataSet", RuiConverter.createDataset("rlabRqprExatMstTreeDataSet", rlabExatMstList));

		return modelAndView;
	}

	@RequestMapping(value="/rlab/saveRlabExatMst.do")
	public ModelAndView saveRlabExatMst(
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
		LOGGER.debug("RlabRqprController - saveRlabExatMst 신뢰성 시험 정보 저장");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		ModelAndView modelAndView = new ModelAndView("ruiView");

		Map<String,Object> resultMap = new HashMap<String, Object>();
		List<Map<String,Object>> rlabExatMstTreeDataSet = null;

		try {
			rlabExatMstTreeDataSet = RuiConverter.convertToDataSet(request, "rlabExatMstTreeDataSet");

			for(Map<String,Object> data : rlabExatMstTreeDataSet) {
				data.put("userId", input.get("_userId"));
			}

			rlabRqprService.saveRlabExatMst(rlabExatMstTreeDataSet);

			resultMap.put("cmd", "saveRlabExatMst");
			resultMap.put("resultYn", "Y");
			resultMap.put("resultMsg", "정상적으로 저장 되었습니다.");
		} catch (Exception e) {
			e.printStackTrace();
			resultMap.put("resultYn", "N");
			resultMap.put("resultMsg", "작업을 실패하였습니다\n관리자에게 문의하세요.");
		}

		modelAndView.addObject("result", RuiConverter.createDataset("result", resultMap));

		return modelAndView;
	}

	@RequestMapping(value="/rlab/getRlabExatDtlList.do")
	public ModelAndView getRlabExatDtlList(
			@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpServletResponse response,
			HttpSession session,
			ModelMap model
			){

		LOGGER.debug("###########################################################");
		LOGGER.debug("RlabRqprController - getRlabExatDtlList [신뢰성 시험정보 상세 리스트 조회]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		ModelAndView modelAndView = new ModelAndView("ruiView");

		List<Map<String,Object>> rlabExatDtlList = rlabRqprService.getRlabExatDtlList(input);

		modelAndView.addObject("rlabExatDtlDataSet", RuiConverter.createDataset("rlabExatDtlDataSet", rlabExatDtlList));

		return modelAndView;
	}


	/**
	 *  신뢰성 시험의뢰 완료시 (통보자 추가저장)
	 */
	@RequestMapping(value="/rlab/insertRlabRqprInfm.do")
	public ModelAndView insertRlabRqprInfm(
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
		LOGGER.debug("RlabRqprController - insertRlabRqprInfm 신뢰성 시험의뢰 완료시 (통보자 추가저장)");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		ModelAndView modelAndView = new ModelAndView("ruiView");

		Map<String,Object> resultMap = new HashMap<String, Object>();
		Map<String,Object> dataMap = new HashMap<String, Object>();
		List<Map<String,Object>> rlabExatDtlDataSet = null;

		try {

			dataMap.put("input", input);
			dataMap.put("rlabRqprDataSet", RuiConverter.convertToDataSet(request, "rlabRqprDataSet").get(0));

			rlabRqprService.insertRlabRqprInfm(dataMap);

			resultMap.put("cmd", "insertRlabRqprInfm");
			resultMap.put("resultYn", "Y");
			resultMap.put("resultMsg", "정상적으로 저장 되었습니다.");
		} catch (Exception e) {
			e.printStackTrace();
			resultMap.put("resultYn", "N");
			resultMap.put("resultMsg", "작업을 실패하였습니다\n관리자에게 문의하세요.");
		}

		modelAndView.addObject("result", RuiConverter.createDataset("result", resultMap));

		return modelAndView;
	}


	@RequestMapping(value="/rlab/saveRlabExatDtl.do")
	public ModelAndView saveRlabExatDtl(
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
		LOGGER.debug("RlabRqprController - saveRlabExatDtl 신뢰성시험 상세 정보 저장");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		ModelAndView modelAndView = new ModelAndView("ruiView");

		Map<String,Object> resultMap = new HashMap<String, Object>();
		List<Map<String,Object>> rlabExatDtlDataSet = null;

		try {
			rlabExatDtlDataSet = RuiConverter.convertToDataSet(request, "rlabExatDtlDataSet");

			for(Map<String,Object> data : rlabExatDtlDataSet) {
				data.put("userId", input.get("_userId"));
			}

			rlabRqprService.saveRlabExatDtl(rlabExatDtlDataSet);

			resultMap.put("cmd", "saveRlabExatDtl");
			resultMap.put("resultYn", "Y");
			resultMap.put("resultMsg", "정상적으로 저장 되었습니다.");
		} catch (Exception e) {
			e.printStackTrace();
			resultMap.put("resultYn", "N");
			resultMap.put("resultMsg", "작업을 실패하였습니다\n관리자에게 문의하세요.");
		}

		modelAndView.addObject("result", RuiConverter.createDataset("result", resultMap));

		return modelAndView;
	}

	@RequestMapping(value="/rlab/deleteRlabExatDtl.do")
	public ModelAndView deleteRlabExatDtl(
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
		LOGGER.debug("RlabRqprController - deleteRlabExatDtl 신뢰성시험 상세 정보 삭제");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		ModelAndView modelAndView = new ModelAndView("ruiView");

		Map<String,Object> resultMap = new HashMap<String, Object>();
		List<Map<String,Object>> rlabExatDtlDataSet = null;

		try {
			rlabExatDtlDataSet = RuiConverter.convertToDataSet(request, "rlabExatDtlDataSet");

			for(Map<String,Object> data : rlabExatDtlDataSet) {
				data.put("userId", input.get("_userId"));
			}

			rlabRqprService.deleteRlabExatDtl(rlabExatDtlDataSet);

			resultMap.put("cmd", "deleteRlabExatDtl");
			resultMap.put("resultYn", "Y");
			resultMap.put("resultMsg", "정상적으로 삭제 되었습니다.");
		} catch (Exception e) {
			e.printStackTrace();
			resultMap.put("resultYn", "N");
			resultMap.put("resultMsg", "작업을 실패하였습니다\n관리자에게 문의하세요.");
		}

		modelAndView.addObject("result", RuiConverter.createDataset("result", resultMap));

		return modelAndView;
	}

	@RequestMapping(value="/rlab/rlabExatExpSimulationPopup.do")
	public String rlabExatExpSimulationPopup(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			) throws Exception{

		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);

    	input = StringUtil.toUtf8(input);

		LOGGER.debug("###########################################################");
		LOGGER.debug("RlabRqprController - rlabExatExpSimulationPopup [실험수가 Simulation 팝업]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		model.addAttribute("inputData", input);

		return "web/rlab/rqpr/rlabExatExpSimulationPopup";
	}

	@RequestMapping(value="/rlab/rlabRqprSrchView.do")
	public String rlabRqprSrchView(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			) throws Exception{

		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);

		LOGGER.debug("###########################################################");
		LOGGER.debug("RlabRqprController - rlabRqprSrchView [신뢰성 시험의뢰서 상세 화면 이동]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		model.addAttribute("inputData", input);

		return "web/rlab/rqpr/rlabRqprSrchView";
	}

	@RequestMapping(value="/rlab/exatWayPopup.do")
	public String exatWayPopupView(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			) throws Exception{

		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);

		LOGGER.debug("###########################################################");
		LOGGER.debug("exatWayPopupView - exatWayPopupView [실험방법 상세 팝업화면 이동]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		;
		input.put("exatWay", rlabRqprService.getExatWay(input));
		model.addAttribute("inputData", input);

		return "web/rlab/rqpr/exatWayPopup";
	}

	/**
	 * > 신뢰성평가 평가의뢰 의견팝업
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/rlab/openAddOpinitionPopup.do")
	public String openAddOpinitionPopup(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);

		LOGGER.debug("###########################################################");
		LOGGER.debug("RlabRqprController - openAddOpinitionPopup 분석의뢰 의견 상세등록팝업");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");


		//input.put("opiSbc", anlRqprService.retrieveOpiSbc(input).replaceAll("\n", "<br/>") );

		model.addAttribute("inputData", input);

		return "web/rlab/rqpr/rlabRqprOpinitionAddPopup";
	}

	//만족도 저장
	@RequestMapping(value="/rlab/saveRlabRqprStpt.do")
	public ModelAndView saveRlabRqprStpt(
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
		LOGGER.debug("saveRlabRqprStpt - saveRlabRqprStpt 만족도 저장");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		ModelAndView modelAndView = new ModelAndView("ruiView");

		Map<String,Object> resultMap = new HashMap<String, Object>();

		try {
			rlabRqprService.saveRlabRqprStpt(input);

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

	/**
	 * > 신뢰성 만족도 To_do View
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/rlab/vmRlabStpt.do")
	public String vmRlabStptView(
			@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){

		/* 반드시 공통 호출 후 작업 */
		HashMap lsession = (HashMap)session.getAttribute("irisSession");
		ModelAndView modelAndView = new ModelAndView("ruiView");
		model.addAttribute("inputData", input);

		return "web/rlab/rqpr/vmRlabStpt";
	}

	/**
	 * > 신뢰성 만족도 To_do 화면
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/rlab/getVmRlabStptList.do")
	public ModelAndView getVmRlabStptList(
			@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpServletResponse response,
			HttpSession session,
			ModelMap model
			){

		LOGGER.debug("###########################################################");
		LOGGER.debug("RlabRqprController - getVmRlabStptList [신뢰성 만족도 To_do 조회]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		ModelAndView modelAndView = new ModelAndView("ruiView");

		//List<Map<String,Object>> rlabExatDtlComboList = rlabRqprService.getVmRlabStptList(input);

		//modelAndView.addObject("mchnInfoId", RuiConverter.createDataset("mchnInfoId", rlabExatDtlComboList));

		return modelAndView;
	}

}