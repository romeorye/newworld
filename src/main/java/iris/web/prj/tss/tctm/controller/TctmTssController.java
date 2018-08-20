package iris.web.prj.tss.tctm.controller;

import iris.web.common.util.StringUtil;
import iris.web.prj.tss.com.service.TssUserService;
import iris.web.prj.tss.gen.service.GenTssPlnService;
import iris.web.prj.tss.gen.service.GenTssService;
import iris.web.system.attach.service.AttachFileService;
import iris.web.system.base.IrisBaseController;

import java.util.*;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
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

import devonframe.message.saymessage.SayMessage;
import devonframe.util.NullUtil;

@Controller
public class TctmTssController extends IrisBaseController {

	@Resource(name = "messageSourceAccessor")
	private MessageSourceAccessor messageSourceAccessor;

	@Resource(name = "tssUserService")
	private TssUserService tssUserService;

	@Resource(name = "genTssService")
	private GenTssService genTssService;

	@Resource(name = "genTssPlnService")
	private GenTssPlnService genTssPlnService;

	@Resource(name = "attachFileService")
	private AttachFileService attachFileService; // 공통파일 서비스

	static final Logger LOGGER = LogManager.getLogger(TctmTssController.class);

	/**
	 * 과제관리 > 기술팀과제 리스트 화면
	 *
	 * @param input HashMap<String, String>
	 * @param request HttpServletRequest
	 * @param session HttpSession
	 * @param model ModelMap
	 * @return String
	 * */
	@RequestMapping(value = "/prj/tss/tctm/tctmTssList.do")
	public String genTssList(@RequestParam HashMap<String, Object> input, HttpServletRequest request, HttpSession session, ModelMap model) {

		checkSessionObjRUI(input, session, model);
		LOGGER.debug("###########################################################");
		LOGGER.debug("GenTssController - genTssList [과제관리 > 기술팀과제 리스트 화면]");
		LOGGER.debug("###########################################################");

		input = StringUtil.toUtf8(input);

		if (pageMoveChkSession((String) input.get("_userId"))) {
			Map<String, Object> role = tssUserService.getTssListRoleChk(input);
			input.put("tssRoleType", role.get("tssRoleType"));
			input.put("tssRoleId", role.get("tssRoleId"));

			model.addAttribute("inputData", input);
		}

		return "web/prj/tss/tctm/tctmTssList";
	}

	/**
	 * 과제관리 > 기술팀과제 > 계획 > 마스터 조회
	 *
	 * @param input HashMap<String, String>
	 * @param request HttpServletRequest
	 * @param session HttpSession
	 * @param model ModelMap
	 * @return String
	 * @throws JSONException
	 * */
	@RequestMapping(value = "/prj/tss/tctm/tctmTssPlnDetail.do")
	public String retrieveGenTssPlnMst(@RequestParam HashMap<String, String> input, HttpServletRequest request, HttpSession session, ModelMap model) throws JSONException {

		LOGGER.debug("###########################################################");
		LOGGER.debug("retrieveGenTssPlnMst [과제관리 > 기술팀과제 > 계획 > 마스터 조회]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		checkSession(input, session, model);

		if (pageMoveChkSession(input.get("_userId"))) {
			// 데이터 있을 경우
			Map<String, Object> result = new HashMap<String, Object>();
			if (!"".equals(input.get("tssCd")) && null != input.get("tssCd")) {
				result = genTssPlnService.retrieveGenTssPlnMst(input);
			}
			result = StringUtil.toUtf8Output((HashMap) result);

			// 사용자권한
			Map<String, Object> role = tssUserService.getTssBtnRoleChk(input, result);
			result.put("tssRoleType", "W");
			result.put("tssRoleId", role.get("tssRoleId"));

			// 사용자조직
			HashMap<String, Object> userMap = new HashMap<String, Object>();
			userMap.put("deptCd", input.get("_teamDept"));

			userMap = genTssService.retrievePrjSearch(userMap);

			// 마스터 데이터
			List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
			list.add(result);

			JSONObject obj = new JSONObject();
			obj.put("records", list);

			// 전달
			request.setAttribute("inputData", input);
			request.setAttribute("resultCnt", result == null ? 0 : result.size());
			request.setAttribute("result", obj);
			model.addAttribute("userMap", userMap);
		}

		return "web/prj/tss/tctm/tctmTssPlnDetail";
	}

	// ================================================================================================
	// 개요
	/**
	 * 과제관리 > 기술팀과제 > 계획 > 개요 iframe 조회
	 *
	 * @param input HashMap<String, String>
	 * @param request HttpServletRequest
	 * @param session HttpSession
	 * @param model ModelMap
	 * @return String
	 * @throws JSONException
	 * */
	@RequestMapping(value = "/prj/tss/tctm/tctmTssPlnSmryIfm.do")
	public String retrieveGenTssPlnSmry(@RequestParam HashMap<String, String> input, HttpServletRequest request, HttpSession session, ModelMap model) throws JSONException {

		LOGGER.debug("###########################################################");
		LOGGER.debug("retrieveGenTssPlnSmry [과제관리 > 기술팀과제 > 계획 > 개요 조회]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		checkSession(input, session, model);

		if (pageMoveChkSession(input.get("_userId"))) {
			// 데이터 있을 경우
			Map<String, Object> result = null;
			if (!"".equals(input.get("tssCd")) && null != input.get("tssCd")) {
				result = genTssPlnService.retrieveGenTssPlnSmry(input);
			}
			result = StringUtil.toUtf8Output((HashMap) result);

			List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
			list.add(result);

			JSONObject obj = new JSONObject();
			obj.put("records", list);

			request.setAttribute("inputData", input);
			request.setAttribute("resultCnt", result == null ? 0 : result.size());
			request.setAttribute("result", obj);
		}

		return "web/prj/tss/tctm/pln/tctmTssPlnSmryIfm";
	}

	/**
	 * 과제관리 > 기술팀과제 > 계획 > 목표및산출물 iframe 화면
	 *
	 * @param input HashMap<String, String>
	 * @param request HttpServletRequest
	 * @param session HttpSession
	 * @param model ModelMap
	 * @return String
	 * @throws JSONException
	 * */
	@RequestMapping(value = "/prj/tss/tctm/tctmTssPlnGoalYldIfm.do")
	public String genTssPlnGoalYldIfm(@RequestParam HashMap<String, String> input, HttpServletRequest request, HttpSession session, ModelMap model) throws JSONException {

		LOGGER.debug("###########################################################");
		LOGGER.debug("GenTssController - genTssPlnGoalYldIfm [과제관리 > 기술팀과제 > 계획 > 목표및산출물 iframe 화면 ]");
		LOGGER.debug("###########################################################");

		checkSession(input, session, model);

		if (pageMoveChkSession(input.get("_userId"))) {
			// 데이터 있을 경우
			List<Map<String, Object>> resultGoal = null;
			List<Map<String, Object>> resultYld = null;

			if (!"".equals(input.get("tssCd")) && null != input.get("tssCd")) {
				resultGoal = genTssPlnService.retrieveGenTssPlnGoal(input);
				resultYld = genTssPlnService.retrieveGenTssPlnYld(input);
			}

			for (int i = 0; i < resultGoal.size(); i++) {
				StringUtil.toUtf8Output((HashMap) resultGoal.get(i));
			}
			for (int i = 0; i < resultYld.size(); i++) {
				StringUtil.toUtf8Output((HashMap) resultYld.get(i));
			}

			JSONObject obj1 = new JSONObject();
			obj1.put("records", resultGoal);
			request.setAttribute("resultGoalCnt", resultGoal == null ? 0 : resultGoal.size());
			request.setAttribute("resultGoal", obj1);

			JSONObject obj2 = new JSONObject();
			obj2.put("records", resultYld);
			request.setAttribute("resultYldCnt", resultYld == null ? 0 : resultYld.size());
			request.setAttribute("resultYld", obj2);

			model.addAttribute("inputData", input);
		}

		return "web/prj/tss/tctm/pln/tctmTssPlnGoalYldIfm";
	}

	/**
	 * 페이지 이동시 세션체크
	 *
	 * @param userId 로그인ID
	 * @return boolean
	 * */
	public boolean pageMoveChkSession(String userId) {

		boolean rtVal = true;

		if (NullUtil.isNull(userId) || NullUtil.nvl(userId, "").equals("-1")) {
			SayMessage.setMessage(messageSourceAccessor.getMessage("msg.alert.sessionTimeout"));
			rtVal = false;
		}

		return rtVal;
	}
}
