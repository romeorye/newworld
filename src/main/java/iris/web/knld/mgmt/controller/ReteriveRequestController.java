package iris.web.knld.mgmt.controller;

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

import iris.web.common.converter.RuiConverter;
import iris.web.common.util.StringUtil;
import iris.web.knld.mgmt.service.ReteriveRequestService;
import iris.web.system.base.IrisBaseController;
import iris.web.system.login.service.IrisLoginService;

/********************************************************************************
 * NAME : ReteriveRequestController.java 
 * DESC : Knowledge > 관리 > 조회 요청 관리 controller
 * PROJ : IRIS UPGRADE 1차 프로젝트
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG                       
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION                        
 * ----------  ------  --------------------------------------------------------- 
 * 2017.08.25  오명철	최초생성
 *********************************************************************************/

@Controller
public class ReteriveRequestController extends IrisBaseController {
	
	@Resource(name = "knldRtrvRqService")
	private ReteriveRequestService knldRtrvRqService;
	
	@Resource(name = "irisLoginService")
	private IrisLoginService loginService;
	
	static final Logger LOGGER = LogManager.getLogger(ReteriveRequestController.class);

	@RequestMapping(value="/knld/rsst/retrieveRequestList.do")
	public String knldRtrvRqList(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			) throws Exception{
		
		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);
		
    	input = StringUtil.toUtf8(input);

		LOGGER.debug("###########################################################");
		LOGGER.debug("ReteriveRequestController - knldRtrvRqList [조회 요청 리스트 화면 이동]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");
		
		model.addAttribute("inputData", input);

		return "web/knld/mgmt/knldRtrvRqList";
	}
	
	@RequestMapping(value="/knld/mgmt/getKnldRtrvRqList.do")
	public ModelAndView getKnldRtrvRqList(
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
		LOGGER.debug("ReteriveRequestController - getKnldRtrvRqList [조회 요청 리스트 조회]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");
		
		ModelAndView modelAndView = new ModelAndView("ruiView");
    	
		List<Map<String,Object>> knldRtrvRqList = knldRtrvRqService.getKnldRtrvRqList(input);
		
		modelAndView.addObject("knldRtrvRqDataSet", RuiConverter.createDataset("knldRtrvRqDataSet", knldRtrvRqList));
		
		return modelAndView;
	}

	@RequestMapping(value="/knld/rsst/knldRtrvRqDetail.do")
	public String knldRtrvRqDetail(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			) throws Exception{
		
		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);
		
    	input = StringUtil.toUtf8(input);

		LOGGER.debug("###########################################################");
		LOGGER.debug("ReteriveRequestController - knldRtrvRqDetail [조회 요청 상세 화면 이동]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");
		
		model.addAttribute("inputData", input);

		return "web/knld/mgmt/knldRtrvRqDetail";
	}
	
	@RequestMapping(value="/knld/rsst/retrieveRequestInfo.do")
	public String retrieveRequestInfo(
			@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
		
		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
    	input = StringUtil.toUtf8(input);

		LOGGER.debug("###########################################################");
		LOGGER.debug("ReteriveRequestController - retrieveRequestInfo 조회 요청 화면");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");
    	
		HashMap<String, Object> deptInfo = knldRtrvRqService.retrieveDeptDetail(input);
		
		input.put("rgstOpsId", deptInfo.get("rgstOpsId"));
		input.put("rgstOpsNm", deptInfo.get("rgstOpsNm"));
		
		model.addAttribute("inputData", input);
		
		return "web/knld/mgmt/retrieveRequestInfo";
	}
	
	@RequestMapping(value="/knld/mgmt/requestKnldRtrvRv.do")
	public ModelAndView requestKnldRtrvRv(
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
		LOGGER.debug("ReteriveRequestController - requestKnldRtrvRv 조회 요청 정보 저장");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");
		
		ModelAndView modelAndView = new ModelAndView("ruiView");
		
		Map<String,Object> dataMap = null;
		Map<String,Object> resultMap = new HashMap<String, Object>();

		try {
			dataMap = RuiConverter.convertToDataSet(request, "knldRtrvRqDataSet").get(0);

			input.put("rgstId", dataMap.get("rgstId"));
			
			//등록자가 퇴사또는 시스템일 경우  기술전략팀장 정보 조회
			String apprId = knldRtrvRqService.retrieveApprInfo(input);
			
			dataMap.put("rqApprStCd", "RQ");
			dataMap.put("userId", input.get("_userId"));
			dataMap.put("apprId", apprId);
			
			knldRtrvRqService.insertKnldRtrvRq(dataMap);

			resultMap.put("resultYn", "Y");
			resultMap.put("resultMsg", "정상적으로 요청 되었습니다.");
		} catch (Exception e) {
			e.printStackTrace();
			resultMap.put("resultYn", "N");
			resultMap.put("resultMsg", "작업을 실패하였습니다\\n관리자에게 문의하세요.");
		}
		
		modelAndView.addObject("result", RuiConverter.createDataset("result", resultMap));
		
		return modelAndView;
	}
	
	@RequestMapping(value="/knld/rsst/retrieveRequestTodoInfo.do")
	public String retrieveRequestTodoInfo(
			@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
		
		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		
    	input = StringUtil.toUtf8(input);

		LOGGER.debug("###########################################################");
		LOGGER.debug("ReteriveRequestController - retrieveRequestTodoInfo 조회 요청 승인/반려 화면");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");
    	
		model.addAttribute("inputData", input);
		
		return "web/knld/mgmt/retrieveRequestTodoInfo";
	}
	
	@RequestMapping(value="/knld/mgmt/getKnldRtrvRqInfo.do")
	public ModelAndView getKnldRtrvRqInfo(
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
		LOGGER.debug("ReteriveRequestController - getKnldRtrvRqInfo [조회 요청 상세 정보 조회]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");
		
		ModelAndView modelAndView = new ModelAndView("ruiView");
    	
		Map<String,Object> knldRtrvRqInfo = knldRtrvRqService.getKnldRtrvRqInfo(input);
		
		modelAndView.addObject("knldRtrvRqDataSet", RuiConverter.createDataset("knldRtrvRqDataSet", knldRtrvRqInfo));
		
		return modelAndView;
	}
	
	@RequestMapping(value="/knld/mgmt/approvalKnldRtrvRv.do")
	public ModelAndView approvalKnldRtrvRv(
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
		LOGGER.debug("ReteriveRequestController - approvalKnldRtrvRv 조회 요청 승인/반려 처리");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");
		
		ModelAndView modelAndView = new ModelAndView("ruiView");

		Map<String,Object> dataMap = null;
		Map<String,Object> resultMap = new HashMap<String, Object>();

		try {
			dataMap = RuiConverter.convertToDataSet(request, "knldRtrvRqDataSet").get(0);

			dataMap.put("userId", input.get("_userId"));
			
			knldRtrvRqService.updateApproval(dataMap);

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
}