package iris.web.space.pfmc.controller;

import java.io.File;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.json.JSONException;
import org.json.JSONObject;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import devonframe.message.saymessage.SayMessage;
import devonframe.util.NullUtil;
import iris.web.knld.mgmt.service.ReteriveRequestService;
import iris.web.space.ev.service.SpaceEvService;
import iris.web.space.pfmc.service.SpacePfmcMstService;
import iris.web.common.code.service.CodeCacheManager;
import iris.web.common.converter.RuiConverter;
import iris.web.common.util.CommonUtil;
import iris.web.common.util.DateUtil;
import iris.web.common.util.MimeDecodeException;
import iris.web.common.util.NamoMime;
import iris.web.common.util.StringUtil;
import iris.web.system.attach.service.AttachFileService;
import iris.web.system.base.IrisBaseController;

/********************************************************************************
 * NAME : SpaceEvController.java 
 * DESC : 공간평가 - 평가법 관리 controller
 * PROJ : IRIS UPGRADE 2차 프로젝트
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG                       
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION                        
 * ----------  ------  --------------------------------------------------------- 
 * 2018.08.03  정현웅	최초생성     
 *********************************************************************************/

@Controller
public class SpacePfmcMstController extends IrisBaseController {
	
	@Resource(name="messageSourceAccessor")
    private MessageSourceAccessor messageSourceAccessor;
	
	@Resource(name = "codeCacheManager")
	private CodeCacheManager codeCacheManager;
	
	@Resource(name = "spacePfmcMstService")
	private SpacePfmcMstService spacePfmcMstService;
	
	@Resource(name = "spaceEvService")
	private SpaceEvService spaceEvService;
	
	@Resource(name = "attachFileService")
	private AttachFileService attachFileService;
	
	@Resource(name = "knldRtrvRqService")
	private ReteriveRequestService knldRtrvRqService;
	
	static final Logger LOGGER = LogManager.getLogger(SpacePfmcMstController.class);

	
	
	@RequestMapping(value="/space/spacePfmcMst.do")
	public String spaceEvaluationMgmt(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			) throws Exception{
		
		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);
		
    	input = StringUtil.toUtf8(input);

		LOGGER.debug("###########################################################");
		LOGGER.debug("SpaceEvController - spaceEvaluationMgmt [공간평가 평가법 관리화면 이동]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");
		
		model.addAttribute("inputData", input);

		return "web/space/rqpr/spacePfmcMstList";
	}
	
	@RequestMapping(value="/space/getSpacePfmcMstList.do")
	public ModelAndView getSpacePfmcMstList(
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
		LOGGER.debug("SpacePfmcMstController - getSpacePfmcMstList [공간평가마스터 제품 조회]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");
		
		ModelAndView modelAndView = new ModelAndView("ruiView");
    	
        // 분석담당자 리스트 조회 
		List<Map<String,Object>> getSpacePfmcMstList = spacePfmcMstService.getSpacePfmcMstList(input);
		
		modelAndView.addObject("spaceEvProdListDataSet", RuiConverter.createDataset("spaceEvProdListDataSet", getSpacePfmcMstList));
		LOGGER.debug("getSpacePfmcMstList : " + getSpacePfmcMstList);
		return modelAndView;
	}
	
	@RequestMapping(value="/space/spaceRetrieveRequestInfoPop.do")
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
		
		return "web/space/rqpr/spaceRetrieveRequestInfoPop";
	}	
	
}