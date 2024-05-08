package iris.web.rlab.gid.controller;

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

import devonframe.message.saymessage.SayMessage;
import devonframe.util.NullUtil;
import iris.web.common.code.service.CodeCacheManager;
import iris.web.common.converter.RuiConverter;
import iris.web.common.util.DateUtil;
import iris.web.common.util.StringUtil;
import iris.web.system.base.IrisBaseController;

/********************************************************************************
 * NAME : RlabLibController.java
 * DESC : 분석자료실 관리 controller
 * PROJ : IRIS UPGRADE 1차 프로젝트
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION
 * ----------  ------  ---------------------------------------------------------
 * 2017.09.26  			최초생성
 *********************************************************************************/

@Controller
public class RlabGidController  extends IrisBaseController {

	@Resource(name="messageSourceAccessor")
	private MessageSourceAccessor messageSourceAccessor;

	@Resource(name = "codeCacheManager")
	private CodeCacheManager codeCacheManager;


	static final Logger LOGGER = LogManager.getLogger(RlabGidController.class);

	/*분석분야 화면 호출*/
	@RequestMapping(value="/rlab/gid/rlabSphereInfo.do")
	public String rlabSphereInfo(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			) throws Exception{

		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);

		LOGGER.debug("###########################################################");
		LOGGER.debug("RlabGidController - rlabSphereInfo [분석분야 화면 호출]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		model.addAttribute("inputData", input);

		return "web/rlab/gid/rlabSphereInfo";
	}

	/*분석 담당자 화면 호출*/
	@RequestMapping(value="/rlab/gid/rlabChargerInfo.do")
	public String rlabChargerInfo(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			) throws Exception{

		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);

		LOGGER.debug("###########################################################");
		LOGGER.debug("RlabGidController - rlabChargerInfo [분석 담당자 화면 호출]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		model.addAttribute("inputData", input);

		return "web/rlab/gid/rlabChargerInfo";
	}

	/*분석의뢰 절차 화면 호출*/
	@RequestMapping(value="/rlab/gid/rlabProceedingInfo.do")
	public String rlabProceedingInfo(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			) throws Exception{

		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);

		LOGGER.debug("###########################################################");
		LOGGER.debug("RlabGidController - rlabProceedingInfo [분석의뢰 절차 화면 호출]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		model.addAttribute("inputData", input);

		return "web/rlab/gid/rlabProceedingInfo";
	}


}//class end
