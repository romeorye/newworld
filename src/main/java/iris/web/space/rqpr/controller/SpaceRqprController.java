package iris.web.space.rqpr.controller;

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

import iris.web.space.rqpr.service.SpaceRqprService;
import iris.web.common.code.service.CodeCacheManager;
import iris.web.common.converter.RuiConverter;
import iris.web.common.util.DateUtil;
import iris.web.common.util.StringUtil;
import iris.web.system.attach.service.AttachFileService;
import iris.web.system.base.IrisBaseController;

/********************************************************************************
 * NAME : SpaceRqprController.java
 * DESC : 평가의뢰 - 평가의뢰 관리 controller
 * PROJ : IRIS UPGRADE 2차 프로젝트
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION
 * ----------  ------  ---------------------------------------------------------
 * 2017.08.25  정현웅	최초생성
 *********************************************************************************/

@Controller
public class SpaceRqprController extends IrisBaseController {

	@Resource(name = "codeCacheManager")
	private CodeCacheManager codeCacheManager;

	@Resource(name = "spaceRqprService")
	private SpaceRqprService spaceRqprService;

	@Resource(name = "attachFileService")
	private AttachFileService attachFileService;

	static final Logger LOGGER = LogManager.getLogger(SpaceRqprController.class);

	@RequestMapping(value="/space/spaceRqprList.do")
	public String spaceRqprList(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			) throws Exception{

		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);

		input = StringUtil.toUtf8(input);

		LOGGER.debug("###########################################################");
		LOGGER.debug("SpaceRqprController - spaceRqprList [평가의뢰 리스트 화면 이동]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		String today = DateUtil.getDateString();

		if(StringUtil.isNullString(input.get("fromRqprDt"))) {
			input.put("fromRqprDt", DateUtil.addMonths(today, -1, "yyyy-MM-dd"));
			input.put("toRqprDt", today);
		}

		model.addAttribute("inputData", input);

		return "web/space/rqpr/spaceRqprList";
	}

	@RequestMapping(value="/space/getSpaceChrgList.do")
	public ModelAndView getSpaceChrgList(
			@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpServletResponse response,
			HttpSession session,
			ModelMap model
			){

		LOGGER.debug("###########################################################");
		LOGGER.debug("SpaceRqprController - getSpaceChrgList [평가담당자 리스트 검색]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		ModelAndView modelAndView = new ModelAndView("ruiView");

        // 평가담당자 리스트 조회
		List<Map<String,Object>> spaceChrgList = spaceRqprService.getSpaceChrgList(input);

		modelAndView.addObject("spaceChrgDataSet", RuiConverter.createDataset("spaceChrgDataSet", spaceChrgList));

		return modelAndView;
	}

	@RequestMapping(value="/space/getSpaceRqprList.do")
	public ModelAndView getSpaceRqprList(
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
		LOGGER.debug("SpaceRqprController - getSpaceRqprList [평가의뢰 리스트 검색]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		ModelAndView modelAndView = new ModelAndView("ruiView");

        // 평가의뢰 리스트 조회
		List<Map<String,Object>> spaceRqprList = spaceRqprService.getSpaceRqprList(input);

		modelAndView.addObject("spaceRqprDataSet", RuiConverter.createDataset("spaceRqprDataSet", spaceRqprList));

		return modelAndView;
	}

	@RequestMapping(value="/space/spaceRqprRgst.do")
	public String spaceRqprRgst(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			) throws Exception{

		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);

		LOGGER.debug("###########################################################");
		LOGGER.debug("SpaceRqprController - spaceRqprRgst [평가의뢰서 등록 화면 이동]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		List <Map<String, Object>> infmTypeCdList  = codeCacheManager.retrieveCodeValueListForCache("INFM_TYPE_CD"); // 통보유형
		List <Map<String, Object>> smpoTrtmCdList  = codeCacheManager.retrieveCodeValueListForCache("SMPO_TRTM_CD"); // 시료처리구분

		model.addAttribute("inputData", input);
		model.addAttribute("infmTypeCdList", infmTypeCdList);
		model.addAttribute("smpoTrtmCdList", smpoTrtmCdList);

		return "web/space/rqpr/spaceRqprRgst";
	}

	@RequestMapping(value="/space/spaceChrgDialog.do")
	public String spaceChrgDialog(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			) throws Exception{

		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);

		LOGGER.debug("###########################################################");
		LOGGER.debug("SpaceRqprController - spaceChrgDialog [평가방법/담당자 리스트 화면 이동]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		return "web/space/rqpr/spaceChrgDialog";
	}

	@RequestMapping(value="/space/getSpaceRqprInfo.do")
	public ModelAndView getSpaceRqprInfo(
			@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpServletResponse response,
			HttpSession session,
			ModelMap model
			){

		LOGGER.debug("###########################################################");
		LOGGER.debug("SpaceRqprController - getSpaceRqprInfo [평가의뢰 정보 불러오기]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		ModelAndView modelAndView = new ModelAndView("ruiView");

		Map<String,Object> spaceRqprInfo = spaceRqprService.getSpaceRqprInfo(input);
		//List<Map<String,Object>> spaceRqprSmpoList = spaceRqprService.getSpaceRqprSmpoList(input);

		modelAndView.addObject("spaceRqprDataSet", RuiConverter.createDataset("spaceRqprDataSet", spaceRqprInfo));
		//modelAndView.addObject("spaceRqprSmpoDataSet", RuiConverter.createDataset("spaceRqprSmpoDataSet", spaceRqprSmpoList));

		return modelAndView;
	}

	@RequestMapping(value="/space/spaceRqprSearchPopup.do")
	public String spaceRqprSearchPopup(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){

		LOGGER.debug("###########################################################");
		LOGGER.debug("SpaceRqprController - spaceRqprSearchPopup 평가의뢰 리스트 조회 팝업");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");


		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);

		model.addAttribute("inputData", input);

		return "web/space/rqpr/spaceRqprSearchPopup";
	}

	@RequestMapping(value="/space/regstSpaceRqpr.do")
	public ModelAndView regstSpaceRqpr(
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
		LOGGER.debug("SpaceRqprController - regstSpaceRqpr 평가의뢰 등록");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		ModelAndView modelAndView = new ModelAndView("ruiView");

		Map<String,Object> dataMap = new HashMap<String, Object>();
		Map<String,Object> resultMap = new HashMap<String, Object>();

		try {
			dataMap.put("input", input);
			/*dataMap.put("spaceRqprDataSet", RuiConverter.convertToDataSet(request, "spaceRqprDataSet").get(0));
			dataMap.put("spaceRqprSmpoDataSet", RuiConverter.convertToDataSet(request, "spaceRqprSmpoDataSet"));
			dataMap.put("spaceRqprRltdDataSet", RuiConverter.convertToDataSet(request, "spaceRqprRltdDataSet"));*/

			dataMap.put("spaceRqprDataSet", RuiConverter.convertToDataSet(request, "spaceRqprDataSet").get(0));        //메인
			dataMap.put("spaceRqprWayCrgrDataSet", RuiConverter.convertToDataSet(request, "spaceRqprWayCrgrDataSet")); //평가방법/담당자
			dataMap.put("spaceRqprProdDataSet", RuiConverter.convertToDataSet(request, "spaceRqprProdDataSet"));       //제품군
			dataMap.put("spaceRqprRltdDataSet", RuiConverter.convertToDataSet(request, "spaceRqprRltdDataSet"));       //관련평가

			spaceRqprService.insertSpaceRqpr(dataMap);

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

	@RequestMapping(value="/space/spaceRqprDetail.do")
	public String spaceRqprDetail(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			) throws Exception{

		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);

		model.addAttribute("inputData", input);

		LOGGER.debug("###########################################################");
		LOGGER.debug("SpaceRqprController - spaceRqprDetail [평가의뢰서 상세 화면 이동]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		return "web/space/rqpr/spaceRqprDetail";
	}

	@RequestMapping(value="/space/getSpaceRqprDetailInfo.do")
	public ModelAndView getSpaceRqprDetailInfo(
			@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpServletResponse response,
			HttpSession session,
			ModelMap model
			){

		LOGGER.debug("###########################################################");
		LOGGER.debug("SpaceRqprController - getSpaceRqprDetailInfo [평가의뢰 상세정보 조회]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		ModelAndView modelAndView = new ModelAndView("ruiView");

		Map<String,Object> spaceRqprInfo = spaceRqprService.getSpaceRqprInfo(input);					//평가의뢰상세
		List<Map<String,Object>> spaceRqprWayCrgrList = spaceRqprService.spaceRqprWayCrgrList(input);	//평가방법
		List<Map<String,Object>> spaceRqprProdList = spaceRqprService.spaceRqprProdList(input);			//제품군
		List<Map<String,Object>> spaceRqprRltdList = spaceRqprService.getSpaceRqprRltdList(input);		//관련평가
		List<Map<String,Object>> spaceRqprExatList = spaceRqprService.getSpaceRqprExatList(input);		//평가정보

		input.put("attcFilId", spaceRqprInfo.get("rqprAttcFileId"));
		List<Map<String,Object>> rqprAttachFileList = attachFileService.getAttachFileList(input);

		input.put("attcFilId", spaceRqprInfo.get("rsltAttcFileId"));
		List<Map<String,Object>> rsltAttachFileList = attachFileService.getAttachFileList(input);

		spaceRqprInfo = StringUtil.toUtf8Output((HashMap) spaceRqprInfo);

		input.put("acpcStCd", spaceRqprInfo.get("acpcStCd"));

		modelAndView.addObject("spaceRqprDataSet", RuiConverter.createDataset("spaceRqprDataSet", spaceRqprInfo));
		modelAndView.addObject("spaceRqprWayCrgrDataSet", RuiConverter.createDataset("spaceRqprWayCrgrDataSet", spaceRqprWayCrgrList));
		modelAndView.addObject("spaceRqprProdDataSet", RuiConverter.createDataset("spaceRqprProdDataSet", spaceRqprProdList));
		modelAndView.addObject("spaceRqprRltdDataSet", RuiConverter.createDataset("spaceRqprRltdDataSet", spaceRqprRltdList));
		modelAndView.addObject("spaceRqprExatDataSet", RuiConverter.createDataset("spaceRqprExatDataSet", spaceRqprExatList));
		modelAndView.addObject("spaceRqprAttachDataSet", RuiConverter.createDataset("spaceRqprAttachDataSet", rqprAttachFileList));
		modelAndView.addObject("spaceRqprRsltAttachDataSet", RuiConverter.createDataset("spaceRqprRsltAttachDataSet", rsltAttachFileList));

		return modelAndView;
	}

	@RequestMapping(value="/space/updateSpaceRqpr.do")
	public ModelAndView updateSpaceRqpr(
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
		LOGGER.debug("SpaceRqprController - updateSpaceRqpr 평가의뢰 수정");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		ModelAndView modelAndView = new ModelAndView("ruiView");

		Map<String,Object> dataMap = new HashMap<String, Object>();
		Map<String,Object> resultMap = new HashMap<String, Object>();

		try {
			input.put("cmd", "update");

			dataMap.put("input", input);
			dataMap.put("spaceRqprDataSet", RuiConverter.convertToDataSet(request, "spaceRqprDataSet").get(0));
			dataMap.put("spaceRqprWayCrgrDataSet", RuiConverter.convertToDataSet(request, "spaceRqprWayCrgrDataSet"));
			dataMap.put("spaceRqprProdDataSet", RuiConverter.convertToDataSet(request, "spaceRqprProdDataSet"));
			dataMap.put("spaceRqprRltdDataSet", RuiConverter.convertToDataSet(request, "spaceRqprRltdDataSet"));

			spaceRqprService.updateSpaceRqpr(dataMap);

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

	@RequestMapping(value="/space/requestSpaceRqprApproval.do")
	public ModelAndView requestSpaceRqprApproval(
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
		LOGGER.debug("SpaceRqprController - requestSpaceRqprApproval 평가의뢰 결재요청");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		ModelAndView modelAndView = new ModelAndView("ruiView");

		Map<String,Object> dataMap = new HashMap<String, Object>();
		Map<String,Object> resultMap = new HashMap<String, Object>();

		try {
			input.put("cmd", "requestApproval");

			dataMap.put("input", input);
			dataMap.put("spaceRqprDataSet", RuiConverter.convertToDataSet(request, "spaceRqprDataSet").get(0));
			dataMap.put("spaceRqprSmpoDataSet", RuiConverter.convertToDataSet(request, "spaceRqprSmpoDataSet"));
			dataMap.put("spaceRqprRltdDataSet", RuiConverter.convertToDataSet(request, "spaceRqprRltdDataSet"));

			spaceRqprService.updateSpaceRqpr(dataMap);

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

	@RequestMapping(value="/space/deleteSpaceRqpr.do")
	public ModelAndView deleteSpaceRqpr(
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
		LOGGER.debug("SpaceRqprController - deleteSpaceRqpr 평가의뢰 삭제");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		ModelAndView modelAndView = new ModelAndView("ruiView");

		Map<String,Object> resultMap = new HashMap<String, Object>();

		try {
			spaceRqprService.deleteSpaceRqpr(input);

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

	@RequestMapping(value="/space/spaceRqprOpinitionPopup.do")
	public String spaceRqprOpinitionPopup(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){

		LOGGER.debug("###########################################################");
		LOGGER.debug("SpaceRqprController - spaceRqprOpinitionPopup 평가의뢰 의견 팝업");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");


		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);

		model.addAttribute("inputData", input);

		return "web/space/rqpr/spaceRqprOpinitionPopup";
	}

	@RequestMapping(value="/space/getSpaceRqprOpinitionList.do")
	public ModelAndView getSpaceRqprOpinitionList(
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
		LOGGER.debug("SpaceRqprController - getSpaceRqprOpinitionList [평가의뢰 의견 리스트 검색]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		ModelAndView modelAndView = new ModelAndView("ruiView");

		List<Map<String,Object>> spaceRqprOpinitionList = spaceRqprService.getSpaceRqprOpinitionList(input);

		modelAndView.addObject("spaceRqprOpinitionDataSet", RuiConverter.createDataset("spaceRqprOpinitionDataSet", spaceRqprOpinitionList));

		return modelAndView;
	}

	@RequestMapping(value="/space/saveSpaceRqprOpinition.do")
	public ModelAndView saveSpaceRqprOpinition(
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
		LOGGER.debug("SpaceRqprController - saveSpaceRqprOpinition 평가의뢰 의견 저장");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		ModelAndView modelAndView = new ModelAndView("ruiView");

		Map<String,Object> resultMap = new HashMap<String, Object>();

		try {
			spaceRqprService.saveSpaceRqprOpinition(input);

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

	@RequestMapping(value="/space/deleteSpaceRqprOpinition.do")
	public ModelAndView deleteSpaceRqprOpinition(
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
		LOGGER.debug("SpaceRqprController - deleteSpaceRqprOpinition 평가의뢰 의견 삭제");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		ModelAndView modelAndView = new ModelAndView("ruiView");

		Map<String,Object> resultMap = new HashMap<String, Object>();

		try {
			spaceRqprService.deleteSpaceRqprOpinition(input);

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
	@RequestMapping(value="/space/openOpinitionPopup.do")
	public String openOpinitionPopup(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){

		LOGGER.debug("###########################################################");
		LOGGER.debug("SpaceRqprController - openOpinitionPopup 평가의뢰 의견 상세팝업");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);

		input.put("opiSbc", spaceRqprService.retrieveOpiSbc(input).replaceAll("\n", "<br/>") );

		model.addAttribute("inputData", input);

		return "web/space/rqpr/openOpinitionPopup";
	}

	@RequestMapping(value="/space/spaceRqprList4Chrg.do")
	public String spaceRqprList4Chrg(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			) throws Exception{

		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);

		input = StringUtil.toUtf8(input);

		LOGGER.debug("###########################################################");
		LOGGER.debug("SpaceRqprController - spaceRqprList4Chrg [평가의뢰 리스트 담당자용 화면 이동]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		String today = DateUtil.getDateString();

		if(input.get("fromRqprDt") == null) {
			input.put("fromRqprDt", DateUtil.addMonths(today, -1, "yyyy-MM-dd"));
			input.put("toRqprDt", today);
		}

		model.addAttribute("inputData", input);

		return "web/space/rqpr/spaceRqprList4Chrg";
	}

	@RequestMapping(value="/space/spaceRqprDetail4Chrg.do")
	public String spaceRqprDetail4Chrg(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			) throws Exception{

		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);

		input = StringUtil.toUtf8(input);
		LOGGER.debug("###########################################################");
		LOGGER.debug("SpaceRqprController - spaceRqprDetail4Chrg [평가의뢰서 상세 담당자용 화면 이동]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		List <Map<String, Object>> infmTypeCdList  = codeCacheManager.retrieveCodeValueListForCache("INFM_TYPE_CD"); // 통보유형
		List <Map<String, Object>> smpoTrtmCdList  = codeCacheManager.retrieveCodeValueListForCache("SMPO_TRTM_CD"); // 시료처리구분

		model.addAttribute("inputData", input);
		model.addAttribute("infmTypeCdList", infmTypeCdList);
		model.addAttribute("smpoTrtmCdList", smpoTrtmCdList);

		return "web/space/rqpr/spaceRqprDetail4Chrg";
	}

	@RequestMapping(value="/space/saveSpaceRqpr.do")
	public ModelAndView saveSpaceRqpr(
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
		LOGGER.debug("SpaceRqprController - saveSpaceRqpr 평가의뢰 저장");
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
			dataMap.put("spaceRqprDataSet", RuiConverter.convertToDataSet(request, "spaceRqprDataSet").get(0));
			dataMap.put("spaceRqprSmpoDataSet", RuiConverter.convertToDataSet(request, "spaceRqprSmpoDataSet"));
			dataMap.put("spaceRqprRltdDataSet", RuiConverter.convertToDataSet(request, "spaceRqprRltdDataSet"));

			Map<String, Object> spaceRqprDataSet = RuiConverter.convertToDataSet(request, "spaceRqprDataSet").get(0);
			spaceRqprDataSet.put("userId", input.get("_userId"));

			spaceRqprService.saveSpaceRqpr(dataMap);

			resultMap.put("cmd", "saveSpaceRqpr");
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

	@RequestMapping(value="/space/receiptSpaceRqpr.do")
	public ModelAndView receiptSpaceRqpr(
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
		LOGGER.debug("SpaceRqprController - receiptSpaceRqpr 평가의뢰 접수");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		ModelAndView modelAndView = new ModelAndView("ruiView");

		Map<String,Object> resultMap = new HashMap<String, Object>();

		try {
			Map<String, Object> spaceRqprDataSet = RuiConverter.convertToDataSet(request, "spaceRqprDataSet").get(0);

			spaceRqprDataSet.put("acpcStCd", "03");
			spaceRqprDataSet.put("userId", input.get("_userId"));

			spaceRqprService.updateReceiptSpaceRqpr(spaceRqprDataSet);

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

	@RequestMapping(value="/space/spaceRqprEndPopup.do")
	public String spaceRqprEndPopup(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){

    	input = StringUtil.toUtf8(input);

		LOGGER.debug("###########################################################");
		LOGGER.debug("SpaceRqprController - spaceRqprEndPopup 평가의뢰 반려/평가중단 팝업");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");


		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);

		model.addAttribute("inputData", input);

		return "web/space/rqpr/spaceRqprEndPopup";
	}

	@RequestMapping(value="/space/saveSpaceRqprEnd.do")
	public ModelAndView saveSpaceRqprEnd(
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
		LOGGER.debug("SpaceRqprController - saveSpaceRqprEnd 평가의뢰 반려/평가중단 처리");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		ModelAndView modelAndView = new ModelAndView("ruiView");

		Map<String,Object> resultMap = new HashMap<String, Object>();

		try {

			spaceRqprService.updateSpaceRqprEnd(input);

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

	@RequestMapping(value="/space/spaceRqprExatRsltPopup.do")
	public String spaceRqprExatRsltPopup(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){

    	input = StringUtil.toUtf8(input);

		LOGGER.debug("###########################################################");
		LOGGER.debug("SpaceRqprController - spaceRqprExatRsltPopup 실험결과 등록/수정 팝업");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");


		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);

		model.addAttribute("inputData", input);

		return "web/space/rqpr/spaceRqprExatRsltPopup";
	}

	@RequestMapping(value="/space/getSpaceRqprExatInfo.do")
	public ModelAndView getSpaceRqprExatInfo(
			@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpServletResponse response,
			HttpSession session,
			ModelMap model
			){

		LOGGER.debug("###########################################################");
		LOGGER.debug("SpaceRqprController - getSpaceRqprExatInfo [평가의뢰 실험정보 불러오기]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		ModelAndView modelAndView = new ModelAndView("ruiView");

		input.put("isMng", "0");

		Map<String,Object> spaceRqprExatInfo = null;
		List<Map<String,Object>> spaceExatTreeList = spaceRqprService.getSpaceExatTreeList(input);

		if(!"0".equals(input.get("rqprExatId"))) {
			LOGGER.debug(" rqprExatId : " + input.get("rqprExatId"));
			spaceRqprExatInfo = spaceRqprService.getSpaceRqprExatInfo(input);
		}

		modelAndView.addObject("spaceRqprExatDataSet", RuiConverter.createDataset("spaceRqprExatDataSet", spaceRqprExatInfo));
		modelAndView.addObject("spaceRqprExatMstTreeDataSet", RuiConverter.createDataset("spaceRqprExatMstTreeDataSet", spaceExatTreeList));

		return modelAndView;
	}

	@RequestMapping(value="/space/getSpaceExatDtlComboList.do")
	public ModelAndView getSpaceRqprExatMchnList(
			@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpServletResponse response,
			HttpSession session,
			ModelMap model
			){

		LOGGER.debug("###########################################################");
		LOGGER.debug("SpaceRqprController - getSpaceExprDtlComboList [실험정보 상세 콤보 리스트 조회]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		ModelAndView modelAndView = new ModelAndView("ruiView");

		List<Map<String,Object>> spaceExprDtlComboList = spaceRqprService.getSpaceExatDtlComboList(input);

		modelAndView.addObject("mchnInfoId", RuiConverter.createDataset("mchnInfoId", spaceExprDtlComboList));

		return modelAndView;
	}

	@RequestMapping(value="/space/saveSpaceRqprExat.do")
	public ModelAndView saveSpaceRqprExat(
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
		LOGGER.debug("SpaceRqprController - saveSpaceRqprExat 평가결과 실험정보 저장");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		ModelAndView modelAndView = new ModelAndView("ruiView");

		Map<String,Object> dataMap = null;
		Map<String,Object> resultMap = new HashMap<String, Object>();

		try {
			dataMap = RuiConverter.convertToDataSet(request, "spaceRqprExatDataSet").get(0);

			dataMap.put("userId", input.get("_userId"));

			spaceRqprService.saveSpaceRqprExat(dataMap);

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

	@RequestMapping(value="/space/deleteSpaceRqprExat.do")
	public ModelAndView deleteSpaceRqprExat(
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
		LOGGER.debug("SpaceRqprController - deleteSpaceRqprExat 평가결과 실험정보 삭제");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		ModelAndView modelAndView = new ModelAndView("ruiView");

		String userId = (String)input.get("_userId");
		Map<String,Object> resultMap = new HashMap<String, Object>();
		List<Map<String,Object>> deleteList = null;

		try {
			deleteList = RuiConverter.convertToDataSet(request, "spaceRqprExatDataSet");

			for(Map<String,Object> data : deleteList) {
				data.put("userId", userId);
			}

			spaceRqprService.deleteSpaceRqprExat(deleteList);

			resultMap.put("cmd", "deleteSpaceRqprExat");
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

	@RequestMapping(value="/space/getSpaceRqprExatList.do")
	public ModelAndView getSpaceRqprExatList(
			@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpServletResponse response,
			HttpSession session,
			ModelMap model
			){

		LOGGER.debug("###########################################################");
		LOGGER.debug("SpaceRqprController - getSpaceRqprExatList [평가결과 실험정보 리스트 검색]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		ModelAndView modelAndView = new ModelAndView("ruiView");

		List<Map<String,Object>> spaceRqprExatList = spaceRqprService.getSpaceRqprExatList(input);

		modelAndView.addObject("spaceRqprExatDataSet", RuiConverter.createDataset("spaceRqprExatDataSet", spaceRqprExatList));

		return modelAndView;
	}

	@RequestMapping(value="/space/saveSpaceRqprRslt.do")
	public ModelAndView saveSpaceRqprRslt(
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
		LOGGER.debug("SpaceRqprController - saveSpaceRqprRslt 평가결과 저장");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		ModelAndView modelAndView = new ModelAndView("ruiView");

		Map<String,Object> dataMap = null;
		Map<String,Object> resultMap = new HashMap<String, Object>();

		try {
			dataMap = RuiConverter.convertToDataSet(request, "spaceRqprDataSet").get(0);

			dataMap.put("cmd", input.get("save"));
			dataMap.put("userId", input.get("_userId"));

			spaceRqprService.saveSpaceRqprRslt(dataMap);

			resultMap.put("cmd", "saveSpaceRqprRslt");
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

	@RequestMapping(value="/space/requestSpaceRqprRsltApproval.do")
	public ModelAndView requestSpaceRqprRsltApproval(
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
		LOGGER.debug("SpaceRqprController - requestSpaceRqprRsltApproval 평가결과 결재의뢰");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		ModelAndView modelAndView = new ModelAndView("ruiView");

		Map<String,Object> dataMap = null;
		Map<String,Object> resultMap = new HashMap<String, Object>();

		try {
			dataMap = RuiConverter.convertToDataSet(request, "spaceRqprDataSet").get(0);

			dataMap.put("cmd", "requestRsltApproval");
			dataMap.put("userId", input.get("_userId"));
			dataMap.put("userNm", input.get("_userNm"));
			dataMap.put("userJobxName", input.get("_userJobxName"));
			dataMap.put("userDeptName", input.get("_userDeptName"));

			spaceRqprService.saveSpaceRqprRslt(dataMap);

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

	@RequestMapping(value="/space/spaceExatList.do")
	public String spaceExprList(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			) throws Exception{

		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);

    	input = StringUtil.toUtf8(input);

		LOGGER.debug("###########################################################");
		LOGGER.debug("SpaceRqprController - spaceExprList [실험정보 리스트 화면 이동]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		model.addAttribute("inputData", input);

		return "web/space/rqpr/spaceExatList";
	}

	@RequestMapping(value="/space/getSpaceExatMstList.do")
	public ModelAndView getSpaceExprMstList(
			@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpServletResponse response,
			HttpSession session,
			ModelMap model
			){

		LOGGER.debug("###########################################################");
		LOGGER.debug("SpaceRqprController - getSpaceExatMstList [실험정보 마스터 리스트 조회]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		ModelAndView modelAndView = new ModelAndView("ruiView");

		List<Map<String,Object>> spaceExatMstList = spaceRqprService.getSpaceExatTreeList(input);

		modelAndView.addObject("spaceRqprExatMstTreeDataSet", RuiConverter.createDataset("spaceRqprExatMstTreeDataSet", spaceExatMstList));

		return modelAndView;
	}

	@RequestMapping(value="/space/saveSpaceExatMst.do")
	public ModelAndView saveSpaceExatMst(
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
		LOGGER.debug("SpaceRqprController - saveSpaceExatMst 공간평가시험 마스터 정보 저장");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		ModelAndView modelAndView = new ModelAndView("ruiView");

		Map<String,Object> resultMap = new HashMap<String, Object>();
		List<Map<String,Object>> spaceExatMstTreeDataSet = null;

		try {
			spaceExatMstTreeDataSet = RuiConverter.convertToDataSet(request, "spaceExatMstTreeDataSet");

			for(Map<String,Object> data : spaceExatMstTreeDataSet) {
				data.put("userId", input.get("_userId"));
			}

			spaceRqprService.saveSpaceExatMst(spaceExatMstTreeDataSet);

			resultMap.put("cmd", "saveSpaceExatMst");
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

	@RequestMapping(value="/space/getSpaceExatDtlList.do")
	public ModelAndView getSpaceExatDtlList(
			@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpServletResponse response,
			HttpSession session,
			ModelMap model
			){

		LOGGER.debug("###########################################################");
		LOGGER.debug("SpaceRqprController - getSpaceExatDtlList [공간평가 시험정보 상세 리스트 조회]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		ModelAndView modelAndView = new ModelAndView("ruiView");

		List<Map<String,Object>> spaceExatDtlList = spaceRqprService.getSpaceExatDtlList(input);

		modelAndView.addObject("spaceExatDtlDataSet", RuiConverter.createDataset("spaceExatDtlDataSet", spaceExatDtlList));

		return modelAndView;
	}


	/**
	 *  평가의뢰 완료시 (통보자 추가저장)
	 */
	@RequestMapping(value="/space/insertSpaceRqprInfm.do")
	public ModelAndView insertSpaceRqprInfm(
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
		LOGGER.debug("SpaceRqprController - insertSpaceRqprInfm 평가의뢰 완료시 (통보자 추가저장)");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		ModelAndView modelAndView = new ModelAndView("ruiView");

		Map<String,Object> resultMap = new HashMap<String, Object>();
		Map<String,Object> dataMap = new HashMap<String, Object>();
		List<Map<String,Object>> spaceExprDtlDataSet = null;

		try {

			dataMap.put("input", input);
			dataMap.put("spaceRqprDataSet", RuiConverter.convertToDataSet(request, "spaceRqprDataSet").get(0));

			spaceRqprService.insertSpaceRqprInfm(dataMap);

			resultMap.put("cmd", "insertSpaceRqprInfm");
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


	@RequestMapping(value="/space/saveSpaceExatDtl.do")
	public ModelAndView saveSpaceExatDtl(
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
		LOGGER.debug("SpaceRqprController - saveSpaceExatDtl 공간평가시험 상세 정보 저장");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		ModelAndView modelAndView = new ModelAndView("ruiView");

		Map<String,Object> resultMap = new HashMap<String, Object>();
		List<Map<String,Object>> spaceExatDtlDataSet = null;

		try {
			spaceExatDtlDataSet = RuiConverter.convertToDataSet(request, "spaceExatDtlDataSet");

			for(Map<String,Object> data : spaceExatDtlDataSet) {
				data.put("userId", input.get("_userId"));
			}

			spaceRqprService.saveSpaceExatDtl(spaceExatDtlDataSet);

			resultMap.put("cmd", "saveSpaceExatDtl");
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

	@RequestMapping(value="/space/deleteSpaceExatDtl.do")
	public ModelAndView deleteSpaceExatDtl(
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
		LOGGER.debug("SpaceRqprController - deleteSpaceExatDtl 공간평가시험 상세 정보 삭제");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		ModelAndView modelAndView = new ModelAndView("ruiView");

		Map<String,Object> resultMap = new HashMap<String, Object>();
		List<Map<String,Object>> spaceExatDtlDataSet = null;

		try {
			spaceExatDtlDataSet = RuiConverter.convertToDataSet(request, "spaceExatDtlDataSet");

			for(Map<String,Object> data : spaceExatDtlDataSet) {
				data.put("userId", input.get("_userId"));
			}

			spaceRqprService.deleteSpaceExatDtl(spaceExatDtlDataSet);

			resultMap.put("cmd", "deleteSpaceExatDtl");
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

	@RequestMapping(value="/space/spaceExatExpSimulationPopup.do")
	public String spaceExatExpSimulationPopup(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			) throws Exception{

		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);

    	input = StringUtil.toUtf8(input);

		LOGGER.debug("###########################################################");
		LOGGER.debug("SpaceRqprController - spaceExatExpSimulationPopup [공간평가시험 수가 Simulation 팝업]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		model.addAttribute("inputData", input);

		return "web/space/rqpr/spaceExprExpSimulationPopup";
	}

	@RequestMapping(value="/space/spaceRqprSrchView.do")
	public String spaceRqprSrchView(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			) throws Exception{

		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);

		LOGGER.debug("###########################################################");
		LOGGER.debug("SpaceRqprController - spaceRqprSrchView [평가의뢰서 상세 화면 이동]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		model.addAttribute("inputData", input);

		return "web/space/rqpr/spaceRqprSrchView";
	}

	@RequestMapping(value="/space/exprWayPopup.do")
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

		;
		input.put("exprWay", spaceRqprService.getExprWay(input));
		model.addAttribute("inputData", input);

		return "web/space/rqpr/exprWayPopup";
	}

	/**
	 *   > 공간평가시험 장비 팝업 화면 호출
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/space/retrieveSpaceExatMchnInfoPop.do")
	public String retrieveMchnInfoPop(@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){

		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);

		return  "web/space/rqpr/spaceExatMchnInfoPop";
	}

	/**
	 *   > 공간평가시험 장비 팝업 목록조회
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/space/retrieveMachineList.do")
	public ModelAndView retrieveMachineList(@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		ModelAndView modelAndView = new ModelAndView("ruiView");
		input = StringUtil.toUtf8(input);

		List<Map<String, Object>> resultList = spaceRqprService.retrieveMachineList(input);
		modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", resultList));

		return  modelAndView;
	}

	/**
	 * > 공간평가 평가의뢰 의견팝업
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/space/openAddOpinitionPopup.do")
	public String openAddOpinitionPopup(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);

		LOGGER.debug("###########################################################");
		LOGGER.debug("SpaceRqprController - openAddOpinitionPopup 분석의뢰 의견 상세등록팝업");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");


		//input.put("opiSbc", anlRqprService.retrieveOpiSbc(input).replaceAll("\n", "<br/>") );

		model.addAttribute("inputData", input);

		return "web/space/rqpr/spaceRqprOpinitionAddPopup";
	}

}