package iris.web.prj.tss.tctm.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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
import org.springframework.web.servlet.ModelAndView;

import devonframe.message.saymessage.SayMessage;
import devonframe.util.NullUtil;
import iris.web.common.converter.RuiConverter;
import iris.web.common.util.CommonUtil;
import iris.web.common.util.MimeDecodeException;
import iris.web.common.util.StringUtil;
import iris.web.common.util.TestConsole;
import iris.web.prj.tss.com.service.TssUserService;
import iris.web.prj.tss.gen.service.GenTssCmplService;
import iris.web.prj.tss.gen.service.GenTssPlnService;
import iris.web.prj.tss.gen.service.GenTssService;
import iris.web.prj.tss.tctm.TctmUrl;
import iris.web.prj.tss.tctm.service.TctmTssService;
import iris.web.system.attach.service.AttachFileService;
import iris.web.system.base.IrisBaseController;

@Controller
public class TctmTssController extends IrisBaseController {

	static final Logger LOGGER = LogManager.getLogger(TctmTssController.class);

	@Resource(name = "messageSourceAccessor")
	private MessageSourceAccessor messageSourceAccessor;

	@Resource(name = "tssUserService")
	private TssUserService tssUserService;

	@Resource(name = "genTssService")
	private GenTssService genTssService;

	@Resource(name = "tctmTssService")
	private TctmTssService tctmTssService;

	@Resource(name = "genTssPlnService")
	private GenTssPlnService genTssPlnService;

	@Resource(name = "attachFileService")
	private AttachFileService attachFileService; // 공통파일 서비스IRIS_TSS_TCTM_SMRY

	@Resource(name = "genTssCmplService")
	private GenTssCmplService genTssCmplService;

	/**
	 * 과제관리 > 기술팀과제 리스트 화면
	 */
	@RequestMapping(TctmUrl.doList)
	public String doList(@RequestParam HashMap<String, Object> input, HttpSession session, ModelMap model) {

		checkSessionObjRUI(input, session, model);
		LOGGER.debug("###########################################################");
		LOGGER.debug("TctmTssController - tctmTssList [과제관리 > 기술팀과제 리스트 화면]");
		LOGGER.debug("###########################################################");

		input = StringUtil.toUtf8(input);

		if (pageMoveChkSession((String) input.get("_userId"))) {
			Map<String, Object> role = tssUserService.getTssListRoleChk(input);
			input.put("tssRoleType", role.get("tssRoleType"));
			input.put("tssRoleId", role.get("tssRoleId"));

			model.addAttribute("inputData", input);
		}

		return TctmUrl.jspList;
	}


	/**
	 * 과제관리 > 기술팀과제 리스트 조회
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(TctmUrl.doSelectList)
	public ModelAndView doSelectList(@RequestParam HashMap<String, Object> input, HttpSession session, ModelMap model) {

		checkSessionObjRUI(input, session, model);

		LOGGER.debug("###########################################################");
		LOGGER.debug("TctmTssController - tctmTssSelectList [과제관리 > 기술팀과제 리스트 조회]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");


		ModelAndView modelAndView = new ModelAndView("ruiView");

		input = StringUtil.toUtf8(input);

		Map<String, Object> role = tssUserService.getTssListRoleChk(input);
		input.put("tssRoleType", role.get("tssRoleType"));
		input.put("tssRoleCd", role.get("tssRoleCd"));

		List<Map<String, Object>> list = tctmTssService.selectTctmTssList(input);
		modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", list));

		return modelAndView;
	}


	/**
	 * 과제관리 > 기술팀과제 > 계획 > 상세 조회
	 */
	@RequestMapping(TctmUrl.doView)
	public String doView(@RequestParam HashMap<String, String> input, HttpServletRequest request, HttpSession session, ModelMap model) throws JSONException {

		LOGGER.debug("###########################################################");
		LOGGER.debug("TctmTssController - tctmTssDetail [과제관리 > 기술팀과제 > 계획 > 마스터 조회]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		checkSession(input, session, model);

		if (pageMoveChkSession(input.get("_userId"))) {
			// 데이터 있을 경우
			Map<String, Object> result = new HashMap<String, Object>();
			if (!"".equals(input.get("tssCd")) && null != input.get("tssCd")) {
//                result = genTssPlnService.retrieveGenTssPlnMst(input);
				result = tctmTssService.selectTctmTssInfo(input);
			}

			result = StringUtil.toUtf8Output((HashMap) result);
			TestConsole.showMap(result);

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

		return TctmUrl.jspView;
	}


	/**
	 * 과제관리 > 기술팀과제 > 완료Tab
	 *
	 * @param input   HashMap<String, String>
	 * @param request HttpServletRequest
	 * @param session HttpSession
	 * @param model   ModelMap
	 * @return String
	 * @throws JSONException
	 */
	@RequestMapping(TctmUrl.doTabCmpl)
	public String doTabCmpl(@RequestParam HashMap<String, String> input, HttpServletRequest request, HttpSession session, ModelMap model) throws JSONException {

		LOGGER.debug("###########################################################");
		LOGGER.debug("TctmTssController - tctmTssCmplIfm [과제관리 > 기술팀과제 > 완료Tab]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		checkSession(input, session, model);
		if (pageMoveChkSession(input.get("_userId"))) {
			Map<String, Object> result = tctmTssService.selectTctmTssInfoSmry(input);
			result = StringUtil.toUtf8Output((HashMap) result);
			StringUtil.toUtf8Output((HashMap) result);

			List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
			list.add(result);

			JSONObject obj = new JSONObject();
			obj.put("records", list);

			request.setAttribute("inputData", input);
			request.setAttribute("resultData", result);
			request.setAttribute("resultCnt", result == null ? 0 : result.size());
			request.setAttribute("result", obj);
		}

		return TctmUrl.jspTabCmpl;
	}

	/**
	 * 과제관리 > 기술팀과제 > 완료 등록/수정
	 */
	@RequestMapping(TctmUrl.doUpdateCmplInfo)
	public ModelAndView doUpdateCmplInfo(@RequestParam HashMap<String, Object> input, HttpServletRequest request, HttpSession session, ModelMap model) {

		LOGGER.debug("###########################################################");
		LOGGER.debug("TctmTssController - tctmTssUpdateCmpl [과제관리 > 기술팀과제 > 완료 등록/수정]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		checkSessionObjRUI(input, session, model);

		ModelAndView modelAndView = new ModelAndView("ruiView");

		HashMap<String, Object> mstDs = null;
		HashMap<String, Object> smryDs;

		try {
			mstDs = (HashMap<String, Object>) RuiConverter.convertToDataSet(request, "mstDataSet").get(0);
			smryDs = (HashMap<String, Object>) RuiConverter.convertToDataSet(request, "smryDataSet").get(0);

			smryDs = StringUtil.toUtf8Input(smryDs);
			String pgsStepCd = (String) mstDs.get("pgsStepCd");

			// 완료 정보가 없으면 MST SMRY를 복제 있으면 내용 수정
			if ("".equals(mstDs.get("cmTssCd"))) {
				String attcFilId = (String) smryDs.get("attcFilId");

				if ("AL".equals(pgsStepCd)) {
					smryDs.put("altrAttcFilId", attcFilId);
				} else if ("CM".equals(pgsStepCd)) {
					smryDs.put("cmAttcFilId", attcFilId);
				} else if ("DC".equals(pgsStepCd)) {
					smryDs.put("dcAttcFilId", attcFilId);
				}

				//신규
				tctmTssService.duplicateTctmTssInfo(mstDs);
				smryDs.put("newTssCd", mstDs.get("newTssCd"));
				tctmTssService.duplicateTctmTssSmryInfo(smryDs);
			} else {
				//수정
				tctmTssService.updateTctmTssInfoCmpl(mstDs);
				tctmTssService.updateTctmTssSmryInfoCmpl(smryDs);
			}

			// 완료/중단인 경우 산출물 완료 보고서 연결
			if ("CM".equals(pgsStepCd) || "DC".equals(pgsStepCd)) {
				smryDs.put("yldItmType", "05");
				tctmTssService.updateYldFile(smryDs);
			}


//			genTssCmplService.insertGenTssCmplMst(mstDs, smryDs);

			mstDs.put("rtCd", "SUCCESS");
			mstDs.put("rtVal", messageSourceAccessor.getMessage("msg.alert.saved")); //저장되었습니다.
			mstDs.put("rtType", "I");

		} catch (Exception e) {
			e.printStackTrace();
			mstDs.put("rtCd", "FAIL");
			mstDs.put("rtVal", messageSourceAccessor.getMessage("msg.alert.error")); //오류가 발생하였습니다.
		}

		modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", mstDs));

		return modelAndView;
	}


	/**
	 * 과제관리 > 기술팀과제 > 중단Tab
	 */
	@RequestMapping(TctmUrl.doTabDcac)
	public String doTabDcac(@RequestParam HashMap<String, String> input, HttpServletRequest request, HttpSession session, ModelMap model) throws JSONException {

		LOGGER.debug("###########################################################");
		LOGGER.debug("TctmTssController - doTabDcac [과제관리 > 기술팀과제 > 중단Tab]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		checkSession(input, session, model);
//		String rtnUrl ="";

//		if(input.get("tssSt").equals("104") && (input.get("pgsStepCd").equals("CM") || input.get("pgsStepCd").equals("DC")) ){
//			rtnUrl = "web/prj/tss/gen/cmpl/genTssCmplIfmView";
//		}else{
//			rtnUrl = "web/prj/tss/gen/cmpl/genTssCmplIfm";
//		}

		if (pageMoveChkSession(input.get("_userId"))) {
			Map<String, Object> result = tctmTssService.selectTctmTssInfoSmry(input);
			result = StringUtil.toUtf8Output((HashMap) result);
			StringUtil.toUtf8Output((HashMap) result);

			List<Map<String, Object>> list = new ArrayList<Map<String, Object>>();
			list.add(result);

			JSONObject obj = new JSONObject();
			obj.put("records", list);

			request.setAttribute("inputData", input);
			request.setAttribute("resultData", result);
			request.setAttribute("resultCnt", result == null ? 0 : result.size());
			request.setAttribute("result", obj);
		}


		return TctmUrl.jspTabDcac;
	}



	/**
	 * 과제관리 > 기술팀과제 > 계획 > 개요 iframe 조회
	 */
	@RequestMapping(TctmUrl.doTabSum)
	public String doTabSum(@RequestParam HashMap<String, String> input, HttpServletRequest request, HttpSession session, ModelMap model) throws JSONException {

		LOGGER.debug("###########################################################");
		LOGGER.debug("TctmTssController - doTabSum [과제관리 > 기술팀과제 > 계획 > 개요 조회]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");


		checkSession(input, session, model);

		if (pageMoveChkSession(input.get("_userId"))) {
			// 데이터 있을 경우
			Map<String, Object> result = null;
			if (!"".equals(input.get("tssCd")) && null != input.get("tssCd")) {

				TestConsole.showMap(CommonUtil.mapToObj(input), "서머리조회 input");
				result = tctmTssService.selectTctmTssInfoSmry(input);
//                TestConsole.showMap(result,"서머리조회 output");
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

		return TctmUrl.jspTabSum;
	}

	/**
	 * 과제관리 > 기술팀과제 > 계획 > 산출물 iframe 화면
	 *
	 * @param input   HashMap<String, String>
	 * @param request HttpServletRequest
	 * @param session HttpSession
	 * @param model   ModelMap
	 * @return String
	 * @throws JSONException
	 */
	@RequestMapping(TctmUrl.doTabGoal)
	public String doTabGoal(@RequestParam HashMap<String, String> input, HttpServletRequest request, HttpSession session, ModelMap model) throws JSONException {

		LOGGER.debug("###########################################################");
		LOGGER.debug("TctmTssController - tctmTssPlnGoalYldIfm [과제관리 > 기술팀과제 > 계획 > 산출물 iframe 화면 ]");
		LOGGER.debug("###########################################################");

		checkSession(input, session, model);

		if (pageMoveChkSession(input.get("_userId"))) {
			// 데이터 있을 경우
			List<Map<String, Object>> resultGoal = new ArrayList<Map<String, Object>>();
			List<Map<String, Object>> resultYld = new ArrayList<Map<String, Object>>();

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

		return TctmUrl.jspTabGoal;
	}


	/**
	 * 과제관리 > 기술팀과제 > 변경 > 변경개요 iframe 조회
	 *
	 * @param input   HashMap<String, String>
	 * @param request HttpServletRequest
	 * @param session HttpSession
	 * @param model   ModelMap
	 * @return String
	 * @throws JSONException
	 */
	@RequestMapping(TctmUrl.doTabAltr)
	public String doTabAltr(@RequestParam HashMap<String, String> input, HttpServletRequest request, HttpSession session, ModelMap model) throws JSONException {

		LOGGER.debug("###########################################################");
		LOGGER.debug("doTabAltr [과제관리 > 기술팀과제 > 변경 > 개요 조회]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		checkSession(input, session, model);

		if (pageMoveChkSession(input.get("_userId"))) {
			//데이터 있을 경우
			Map<String, Object> result = null;
			if (!"".equals(input.get("tssCd")) && null != input.get("tssCd")) {
				result = tctmTssService.selectTctmTssInfoSmry(input);
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

		return TctmUrl.jspTabAltr;
	}


	/**
	 * 과제관리 > 기술팀과제 > 변경 > 개요 저장/수정
	 *
	 * @param input   HashMap<String, Object>
	 * @param request HttpServletRequest
	 * @param session HttpSession
	 * @param model   ModelMap
	 * @return ModelAndView
	 */
	@RequestMapping(TctmUrl.doUpdateInfoAltr)
	public ModelAndView doUpdateInfoAltr(@RequestParam HashMap<String, Object> input, HttpServletRequest request,
										 HttpSession session, ModelMap model) {
		LOGGER.debug("###########################################################");
		LOGGER.debug("insertGenTssAltrMst [과제관리 > 기술팀과제 > 변경 > 개요 저장/수정]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		checkSessionObjRUI(input, session, model);
		ModelAndView modelAndView = new ModelAndView("ruiView");
		HashMap<String, Object> mstDs = null;

		try {
			mstDs = (HashMap<String, Object>) RuiConverter.convertToDataSet(request, "mstDataSet").get(0);
			HashMap<String, Object> smryDs = (HashMap<String, Object>) RuiConverter.convertToDataSet(request, "smryDataSet").get(0);
			List<Map<String, Object>> altrDs = RuiConverter.convertToDataSet(request, "altrDataSet");

//			boolean upWbsCd = false;

			smryDs = StringUtil.toUtf8Input(smryDs);
			tctmTssService.updateTctmTssInfoAltrSmry(input, mstDs, smryDs, altrDs);
//			genTssAltrService.insertGenTssAltrMst(mstDs, smryDs, altrDs, upWbsCd);


			mstDs.put("rtCd", "SUCCESS");
			mstDs.put("rtVal", messageSourceAccessor.getMessage("msg.alert.saved")); //저장되었습니다.
//			mstDs.put("rtType", "I");
		} catch (Exception e) {
			e.printStackTrace();
			mstDs.put("rtCd", "FAIL");
			mstDs.put("rtVal", messageSourceAccessor.getMessage("msg.alert.error")); //오류가 발생하였습니다.
		}

		modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", mstDs));

		return modelAndView;
	}

	/**
	 * 과제관리 > 기술팀과제 > 변경 > 변경개요목록 조회
	 *
	 * @param input   HashMap<String, String>
	 * @param request HttpServletRequest
	 * @param session HttpSession
	 * @param model   ModelMap
	 * @return String
	 */
	@RequestMapping(TctmUrl.doSelectInfoAltrListSmry)
	public ModelAndView doSelectInfoAltrListSmry(@RequestParam HashMap<String, String> input, HttpServletRequest request,
												 HttpSession session, ModelMap model) {

		LOGGER.debug("###########################################################");
		LOGGER.debug("retrieveGenTssAltrSmryList [과제관리 > 기술팀과제 > 변경 > 변경개요목록 조회]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		checkSessionRUI(input, session, model);
		ModelAndView modelAndView = new ModelAndView("ruiView");

		List<Map<String, Object>> result = tctmTssService.selectTctmTssInfoAltrList(input);

		modelAndView.addObject("dataset", RuiConverter.createDataset("dataset", result));
		return modelAndView;
	}

	/**
	 * 과제관리 > 기술팀과제 > 변경 > 변경취소
	 *
	 * @param input   HashMap<String, String>
	 * @param request HttpServletRequest
	 * @param session HttpSession
	 * @param model   ModelMap
	 * @return String
	 */
	@RequestMapping(TctmUrl.doCancelInfoAltr)
	public ModelAndView doCancelInfoAltr(@RequestParam HashMap<String, String> input, HttpServletRequest request,
										 HttpSession session, ModelMap model) {
		LOGGER.debug("###########################################################");
		LOGGER.debug("retrieveGenTssAltrSmryList [과제관리 > 기술팀과제 > 변경 > 변경취소]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");


		Map<String, Object> rtnMeaasge = new HashMap<String, Object>();
		checkSessionRUI(input, session, model);
		ModelAndView modelAndView = new ModelAndView("ruiView");
		tctmTssService.cancelTctmTssInfoAltrSmry(input);


		rtnMeaasge.put("rtCd", "SUCCESS");
		rtnMeaasge.put("rtVal", "변경취소 되었습니다."); //삭제되었습니다.

		modelAndView.addObject("dataset", RuiConverter.createDataset("dataset", rtnMeaasge));
		return modelAndView;
	}

	/**
	 * 과제관리 > 기술팀과제 > 변경 > 내부품의서요청 화면
	 *
	 * @param input   HashMap<String, String>
	 * @param request HttpServletRequest
	 * @param session HttpSession
	 * @param model   ModelMap
	 * @return String
	 * @throws JSONException
	 */
	@RequestMapping(TctmUrl.doAltrCsusView)
	public String doAltrCsusView(@RequestParam HashMap<String, String> input, HttpServletRequest request,
								 HttpSession session, ModelMap model) throws JSONException {

		LOGGER.debug("###########################################################");
		LOGGER.debug("genTssAltrCsusRq [과제관리 > 기술팀과제 > 변경 > 내부품의서요청 화면 ]");
		LOGGER.debug("###########################################################");

		checkSession(input, session, model);

		if (pageMoveChkSession(input.get("_userId"))) {
			Map<String, Object> resultMst = tctmTssService.selectTctmTssInfo(input);    //마스터 정보
			Map<String, Object> resultCsus = tctmTssService.selectCsus(resultMst);    //통합결제
			Map<String, Object> resultSmry = tctmTssService.selectTctmTssInfoSmry(input);        //개요 정보
			List<Map<String, Object>> resultAltr = tctmTssService.selectTctmTssInfoAltrList(input);    // 변경 목록

			HashMap<String, String> inputInfo = new HashMap<String, String>();
			inputInfo.put("attcFilId", String.valueOf(resultSmry.get("altrAttcFilId")));

			List<Map<String, Object>> resultAttc = tctmTssService.selectAttachFileList(inputInfo);    //첨부 파일 목록

			resultMst = StringUtil.toUtf8Output((HashMap) resultMst);
			resultCsus = StringUtil.toUtf8Output((HashMap) resultCsus);
			resultSmry = StringUtil.toUtf8Output((HashMap) resultSmry);

			model.addAttribute("inputData", input);
			model.addAttribute("resultMst", resultMst);
			model.addAttribute("resultSmry", resultSmry);
			model.addAttribute("resultAltr", resultAltr);
			model.addAttribute("resultAttc", resultAttc);
			model.addAttribute("resultCsus", resultCsus);

			//text컬럼을 위한 json변환
			JSONObject obj = new JSONObject();
			obj.put("records", resultSmry);

			request.setAttribute("jsonSmry", obj);
		}

		return TctmUrl.jspAltrCsusView;
	}


	/**
	 * 과제관리 > 기술팀과제 > 변경이력 Tab JSP
	 *
	 * @param input   HashMap<String, String>
	 * @param request HttpServletRequest
	 * @param session HttpSession
	 * @param model   ModelMap
	 * @return String
	 * @throws JSONException
	 */
	@RequestMapping(TctmUrl.doTabAltrHis)
	public String doTabAltrHis(@RequestParam HashMap<String, String> input, HttpServletRequest request,
							   HttpSession session, ModelMap model) throws JSONException {

		LOGGER.debug("###########################################################");
		LOGGER.debug("retrieveGenTssPgsSmry [과제관리 > 기술팀과제 > 진행 > 변경이력 조회]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		checkSession(input, session, model);

		if (pageMoveChkSession(input.get("_userId"))) {
//			List<Map<String, Object>> result = genTssPgsService.retrieveGenTssPgsAltrHist(input);
			List<Map<String, Object>> result = tctmTssService.selectInfoAltrHisListAll(input);
			for (int i = 0; i < result.size(); i++) {
				StringUtil.toUtf8Output((HashMap) result.get(i));
			}

			JSONObject obj = new JSONObject();
			obj.put("records", result);

			request.setAttribute("inputData", input);
			request.setAttribute("resultCnt", result == null ? 0 : result.size());
			request.setAttribute("result", obj);
		}

		return TctmUrl.jspTabAltrHis;
	}


	/**
	 * 과제관리 > 기술팀과제 > 변경이력 Pop JSP
	 *
	 * @param input   HashMap<String, String>
	 * @param request HttpServletRequest
	 * @param session HttpSession
	 * @param model   ModelMap
	 * @return String
	 */
	@RequestMapping(TctmUrl.doTabAltrHisPop)
	public String doTabAltrHisPop(@RequestParam HashMap<String, String> input, HttpServletRequest request,
								  HttpSession session, ModelMap model) {

		checkSession(input, session, model);

		LOGGER.debug("###########################################################");
		LOGGER.debug("genTssAltrDetailPopup [과제관리 > 기술팀과제 > 진행 > 변경이력 상세 팝업 화면 ]");
		LOGGER.debug("###########################################################");

		request.setAttribute("inputData", input);

		return TctmUrl.jspTabAltrHisPop;
	}

	/**
	 * 과제관리 > 기술팀과제 > 변경이력 팝업 Query
	 *
	 * @param input   HashMap<String, String>
	 * @param session HttpSession
	 * @param model   ModelMap
	 * @return String
	 * @throws JSONException
	 */
	@RequestMapping(TctmUrl.doSelectTabAltrHisPop)
	public ModelAndView doSelectTabAltrHisPopSearch(@RequestParam HashMap<String, Object> input, HttpSession session, ModelMap model) {

		checkSessionObjRUI(input, session, model);
		ModelAndView modelAndView = new ModelAndView("ruiView");

		LOGGER.debug("###########################################################");
		LOGGER.debug("genTssAltrDetailPopup [과제관리 > 기술팀과제 > 변경이력 팝업 내역 ]");
		LOGGER.debug("####input  : ########### : " + input);
		LOGGER.debug("###########################################################");

		List<Map<String, Object>> resultAltr = tctmTssService.selectInfoAltrHisList(input);
		Map<String, Object> altrDtl = tctmTssService.selectInfoAltrHisInfo(input);

		StringUtil.toUtf8Output((HashMap<String, Object>) altrDtl);

		modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", resultAltr));
		modelAndView.addObject("rsonDataSet", RuiConverter.createDataset("rsonDataSet", altrDtl));

		return modelAndView;
	}


	/**
	 * 과제관리 > 기술팀과제 > 계획 > 마스터 신규
	 *
	 * @param input   HashMap<String, Object>
	 * @param request HttpServletRequest
	 * @param session HttpSession
	 * @param model   ModelMap
	 * @return ModelAndView
	 */
	@RequestMapping(TctmUrl.doUpdateInfo)
	public ModelAndView doUpdateInfo(@RequestParam HashMap<String, Object> input, HttpServletRequest request, HttpSession session, ModelMap model) {

		LOGGER.debug("###########################################################");
		LOGGER.debug("tctmTssUpdateInfo [과제관리 > 기술팀과제 > 계획 > 마스터 신규]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		checkSessionObjRUI(input, session, model);

		ModelAndView modelAndView = new ModelAndView("ruiView");

		HashMap<String, Object> mstDs = null;
		HashMap<String, Object> smryDs = null;
		HashMap<String, Object> smryDecodeDs = null;


		try {
			mstDs = (HashMap<String, Object>) RuiConverter.convertToDataSet(request, "mstDataSet").get(0);
			smryDs = (HashMap<String, Object>) RuiConverter.convertToDataSet(request, "smryDataSet").get(0);

			TestConsole.isEmpty("deptCode", mstDs.get("deptCode"));
			TestConsole.isEmpty("prjCd", mstDs.get("prjCd"));
			TestConsole.isEmpty("tssScnCd", mstDs.get("tssScnCd"));
			Map<String, Object> getWbs = genTssService.getWbsCdStd("prj.tss.com.getWbsCdStd", mstDs);

			TestConsole.isEmptyMap(mstDs);


			String tssCd = (String) mstDs.get("tssCd");

			if ("".equals(tssCd)) {
				LOGGER.debug("=============== 과제 신규 등록 ===============");
				if (getWbs == null || getWbs.size() <= 0) {
					mstDs.put("rtCd", "FAIL");
					mstDs.put("rtVal", "상위사업부코드 또는 Project약어를 먼저 생성해 주시기 바랍니다.");
				} else {
					LOGGER.debug("=============== SEED WBS_CD 생성 ===============");
					int seqMax = Integer.parseInt(String.valueOf(getWbs.get("seqMax")));
					String seqMaxS = String.valueOf(seqMax + 1);
					mstDs.put("wbsCd", "D" + seqMaxS);

					TestConsole.isEmpty("wbsCd", mstDs.get("wbsCd"));
					smryDecodeDs = StringUtil.toUtf8Input(smryDs);


					TestConsole.isEmptyMap(mstDs);
					TestConsole.isEmptyMap(smryDecodeDs);

					LOGGER.debug("=============== TSS CD 생성 ===============");
					if (mstDs.get("tssCd") == null || mstDs.get("tssCd").equals("")) {
						String newTssCd = tctmTssService.selectNewTssCdt(mstDs);
						mstDs.put("tssCd", newTssCd);
						smryDecodeDs.put("tssCd", newTssCd);
					}

					LOGGER.debug("=============== 과제 마스터 등록 ===============");
					tctmTssService.updateTctmTssInfo(mstDs);
					LOGGER.debug("=============== 과제 개요 등록 ===============");
					tctmTssService.updateTctmTssSmryInfo(smryDecodeDs);
					LOGGER.debug("=============== 산출물 등록 ===============");
					tctmTssService.updateTctmTssYld(mstDs);

					LOGGER.debug("=============== 업로드 파일 산출물 연결 ===============");
					smryDs.put("yldItmType", "01");
					tctmTssService.updateYldFile(smryDecodeDs);


					mstDs.put("rtCd", "SUCCESS");
					mstDs.put("rtVal", messageSourceAccessor.getMessage("msg.alert.saved")); //저장되었습니다.
					mstDs.put("rtType", "I");
				}
			} else if (!"".equals(tssCd)) {
				LOGGER.debug("=============== 과제 수정 ===============");
//				smryDecodeDs = (HashMap<String, Object>) ousdCooTssService.decodeNamoEditorMap(input, smryDs); //에디터데이터 디코딩처리
				smryDecodeDs = StringUtil.toUtf8Input(smryDs);

				LOGGER.debug("=============== 과제 마스터  수정 ===============");
				tctmTssService.updateTctmTssInfo(mstDs);

				LOGGER.debug("=============== 과제 개요 수정 ===============");
				tctmTssService.updateTctmTssSmryInfo(smryDecodeDs);

				LOGGER.debug("=============== 업로드 파일 산출물 연결 ===============");
				smryDs.put("yldItmType", "01");
				tctmTssService.updateYldFile(smryDecodeDs);

				mstDs.put("rtCd", "SUCCESS");
				mstDs.put("rtVal", messageSourceAccessor.getMessage("msg.alert.saved")); //저장되었습니다.
				mstDs.put("rtType", "I");
			}

		} catch (MimeDecodeException e) {
			LOGGER.debug("MimeDecodeException ERROR");
			e.printStackTrace();
			mstDs.put("rtCd", "FAIL");
			mstDs.put("rtVal", messageSourceAccessor.getMessage("msg.alert.imageUploadError")); //이미지파일 등록에 실패했습니다.
		} catch (Exception e) {
			e.printStackTrace();
			mstDs.put("rtCd", "FAIL");
			mstDs.put("rtVal", messageSourceAccessor.getMessage("msg.alert.error")); //오류가 발생하였습니다.
		}

		modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", mstDs));

		return modelAndView;
	}


	/**
	 * 과제관리 > 기술팀과제 > 계획 > 삭제
	 *
	 * @param input   HashMap<String, String>
	 * @param session HttpSession
	 * @param model   ModelMap
	 * @return ModelAndView
	 */
	@RequestMapping(TctmUrl.doDeleteInfo)
	public ModelAndView doDeleteInfo(@RequestParam HashMap<String, String> input,
									 HttpSession session, ModelMap model) {

		LOGGER.debug("###########################################################");
		LOGGER.debug("tctmTssDeleteInfo [과제관리 > 기술팀과제 > 계획 > 삭제]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		checkSessionRUI(input, session, model);

		ModelAndView modelAndView = new ModelAndView("ruiView");

		Map<String, Object> mstDs = new HashMap<>();

		try {

			tctmTssService.deleteTctmTssInfo(input);

			mstDs.put("rtCd", "SUCCESS");
			mstDs.put("rtVal", "삭제되었습니다."); //삭제되었습니다.

		} catch (Exception e) {
			e.printStackTrace();
			mstDs.put("rtCd", "FAIL");
			mstDs.put("rtVal", messageSourceAccessor.getMessage("msg.alert.error")); //오류가 발생하였습니다.
		}

		modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", mstDs));

		return modelAndView;
	}


	/**
	 * 과제관리 > 기술팀과제 > 계획 > 품의서요청 화면
	 *
	 * @param input   HashMap<String, String>
	 * @param request HttpServletRequest
	 * @param session HttpSession
	 * @param model   ModelMap
	 * @return String
	 * @throws JSONException
	 */
	@RequestMapping(TctmUrl.doCsusView)
	public String doCsusView(@RequestParam HashMap<String, String> input, HttpServletRequest request,
							 HttpSession session, ModelMap model) throws JSONException {

		LOGGER.debug("###########################################################");
		LOGGER.debug("tctmTssController - tctmTssPlnGoalYldIfm [과제관리 > 기술팀과제 > 계획 > 품의서요청 화면 ]");
		LOGGER.debug("###########################################################");

		checkSession(input, session, model);

		String view;
		String fileColumn;

		if ("AL".equals(input.get("pgsStepCd"))) {                //
			view = TctmUrl.jspAltrCsusView;
			fileColumn = "altrAttcFilId";
		}else if ("CM".equals(input.get("pgsStepCd"))) {                //완료
			view = TctmUrl.jspCmCsusView;
			fileColumn = "cmplAttcFilId";
		} else if ("DC".equals(input.get("pgsStepCd"))) {        //중단
			view = TctmUrl.jspDcCsusView;
			fileColumn = "dcacAttcFilId";
		} else {                                                                    //진행
			view = TctmUrl.jspCsusView;
			fileColumn = "attcFilId";
		}

		if (pageMoveChkSession(input.get("_userId"))) {
		    Map<String, Object> resultGrs         = genTssService.retrieveGenGrs(input); //GRS 
			Map<String, Object> resultMst = tctmTssService.selectTctmTssInfo(input);                // 마스터
			Map<String, Object> resultSmry = tctmTssService.selectTctmTssInfoSmry(input);        //개요
			Map<String, Object> resultCsus = tctmTssService.selectTssCsus(resultMst);            //품의서 결제 목록
//			List<Map<String, Object>> resultGoal  = tctmTssService.selectTctmTssInfoGoal(input); 	//목표기술성과
			List<Map<String, Object>> resultTssYy = tctmTssService.selectTssPlnTssYyt(input);        //과제년도


			HashMap<String, String> inputInfo = new HashMap<String, String>();
			inputInfo.put("tssCd", String.valueOf(input.get("tssCd")));
			inputInfo.put("pgTssCd", String.valueOf(resultMst.get("pgTssCd")));
			inputInfo.put("tssStrtDd", String.valueOf(resultMst.get("tssStrtDd")));
			inputInfo.put("tssFnhDd", String.valueOf(resultMst.get("tssFnhDd")));
			inputInfo.put("attcFilId", String.valueOf(resultSmry.get(fileColumn)));


			List<Map<String, Object>> resultAttc = genTssCmplService.retrieveGenTssCmplAttc(inputInfo);

			resultGrs  = StringUtil.toUtf8Output((HashMap) resultGrs);
			resultMst = StringUtil.toUtf8Output((HashMap) resultMst);
			resultSmry = StringUtil.toUtf8Output((HashMap) resultSmry);
			resultCsus = StringUtil.toUtf8Output((HashMap) resultCsus);

			model.addAttribute("inputData", input);
			model.addAttribute("resultGrs", resultGrs);
			model.addAttribute("resultMst", resultMst);
			model.addAttribute("resultSmry", resultSmry);
			model.addAttribute("resultTssYy", resultTssYy);
			model.addAttribute("resultCsus", resultCsus);
			model.addAttribute("resultAttc", resultAttc);

			resultSmry.put("saUserName", resultMst.get(("saSabunName")));
			String createDate = ((String) resultSmry.get(("lastMdfyDt"))).substring(0, 10);
			resultSmry.put("createDate", createDate);


			//text컬럼을 위한 json변환
			JSONObject obj = new JSONObject();
			obj.put("smry", resultSmry);

			request.setAttribute("resultJson", obj);
		}

		return view;
	}

	/**
	 * 페이지 이동시 세션체크
	 *
	 * @param userId 로그인ID
	 * @return boolean
	 */
	public boolean pageMoveChkSession(String userId) {

		boolean rtVal = true;

		if (NullUtil.isNull(userId) || NullUtil.nvl(userId, "").equals("-1")) {
			SayMessage.setMessage(messageSourceAccessor.getMessage("msg.alert.sessionTimeout"));
			rtVal = false;
		}

		return rtVal;
	}


	/**
	 * 통합검색
	 *
	 * @param input   HashMap<String, String>
	 * @param request HttpServletRequest
	 * @param session HttpSession
	 * @param model   ModelMap
	 * @return String
	 * @throws JSONException
	 */
	@SuppressWarnings({"unchecked", "rawtypes"})
	@RequestMapping(TctmUrl.doTctmSrch)
	public String tctmTssItgSrch(@RequestParam HashMap<String, String> input, HttpServletRequest request,
								 HttpSession session, ModelMap model) throws JSONException {

		LOGGER.debug("###########################################################");
		LOGGER.debug("tctmTssItgSrch [ 통합검색 ]");
		LOGGER.debug("###########################################################");

		checkSession(input, session, model);

		if (pageMoveChkSession(input.get("_userId"))) {
			Map<String, Object> resultMst = genTssPlnService.retrieveGenTssPlnMst(input);  //마스터
			Map<String, Object> resultSmry = tctmTssService.selectTctmTssInfoSmry(input); //개요

			resultMst = StringUtil.toUtf8Output((HashMap) resultMst);
			resultSmry = StringUtil.toUtf8Output((HashMap) resultSmry);

			Map<String, Object> inputInfo = new HashMap<String, Object>();
			String pgsStepCd = String.valueOf(resultMst.get("pgsStepCd"));
			String attcFilId = "";
			if ("AL".equals(pgsStepCd)) attcFilId = String.valueOf(resultSmry.get("altrAttcFilId"));
			else if ("CM".equals(pgsStepCd)) attcFilId = String.valueOf(resultSmry.get("cmplAttcFilId"));
			else if ("DC".equals(pgsStepCd)) attcFilId = String.valueOf(resultSmry.get("dcacAttcFilId"));
			else attcFilId = String.valueOf(resultSmry.get("attcFilId"));

			inputInfo.put("attcFilId", attcFilId);
			List<Map<String, Object>> resultAttc = attachFileService.getAttachFileList(inputInfo);

			model.addAttribute("inputData", input);
			model.addAttribute("resultMst", resultMst);
			model.addAttribute("resultSmry", resultSmry);
			model.addAttribute("resultAttc", resultAttc);

			//text컬럼을 위한 json변환
			JSONObject obj = new JSONObject();
			obj.put("smry", resultSmry);

			request.setAttribute("resultJson", obj);
		}

		return "web/prj/tss/nat/natTssItgSrch";
	}




	/**
	 * 과제관리 > 기술팀과제 > 진행 > 변경이동 팝업 화면
	 *
	 * @param input HashMap<String, String>
	 * @param request HttpServletRequest
	 * @param session HttpSession
	 * @param model ModelMap
	 * @return String
	 * @throws JSONException
	 * */
	@RequestMapping(value="/prj/tss/tctm/confirmPopup.do")
	public String confirmPopup(@RequestParam HashMap<String, String> input, HttpServletRequest request,
							   HttpSession session, ModelMap model) throws JSONException {

		checkSession(input, session, model);

		LOGGER.debug("###########################################################");
		LOGGER.debug("confirmPopup [과제관리 > 기술팀과제 > 진행 > 변경이동 팝업 화면 ]");
		LOGGER.debug("###########################################################");

		request.setAttribute("inputData", input);

		return "web/prj/tss/tctm/confirmPopup";
	}
}
