package iris.web.prj.tss.tctm.controller;

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
import iris.web.prj.tss.ousdcoo.service.OusdCooTssService;
import iris.web.prj.tss.tctm.TctmUrl;
import iris.web.prj.tss.tctm.service.TctmTssService;
import iris.web.system.attach.service.AttachFileService;
import iris.web.system.base.IrisBaseController;
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

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
public class TctmTssController extends IrisBaseController {

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

    @Resource(name = "ousdCooTssService")
    private OusdCooTssService ousdCooTssService;            // 대외협력과제 서비스


    @Resource(name = "attachFileService")
    private AttachFileService attachFileService; // 공통파일 서비스IRIS_TSS_TCTM_SMRY

    @Resource(name = "genTssCmplService")
    private GenTssCmplService genTssCmplService;


    static final Logger LOGGER = LogManager.getLogger(TctmTssController.class);

    /**
     * 과제관리 > 기술팀과제 리스트 화면
     *
     * @param input   HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model   ModelMap
     * @return String
     */
    @RequestMapping(value = TctmUrl.doList)
    public String doList(@RequestParam HashMap<String, Object> input, HttpServletRequest request, HttpSession session, ModelMap model) {

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
     *
     * @param input    HashMap<String, Object>
     * @param request  HttpServletRequest
     * @param response HttpServletResponse
     * @param session  HttpSession
     * @param model    ModelMap
     * @return ModelAndView
     */
    @SuppressWarnings("unchecked")
    @RequestMapping(value = TctmUrl.doSelectList)
    public ModelAndView doSelectList(@RequestParam HashMap<String, Object> input, HttpServletRequest request,
                                           HttpServletResponse response, HttpSession session, ModelMap model) {

        checkSessionObjRUI(input, session, model);

        LOGGER.debug("###########################################################");
        LOGGER.debug("retrievefGenTssList - retrieveGenTssList [과제관리 > 기술팀과제 리스트 조회]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");


        ModelAndView modelAndView = new ModelAndView("ruiView");

        input = StringUtil.toUtf8(input);

        Map<String, Object> role = tssUserService.getTssListRoleChk(input);
        input.put("tssRoleType", role.get("tssRoleType"));
        input.put("tssRoleCd", role.get("tssRoleCd"));

//        List<Map<String, Object>> list = genTssService.retrieveGenTssList(input);
        List<Map<String, Object>> list = tctmTssService.selectTctmTssList(input);


        modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", list));

        return modelAndView;
    }




    /**
     * 과제관리 > 기술팀과제 > 계획 > 상세 조회
     *
     * @param input   HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model   ModelMap
     * @return String
     * @throws JSONException
     */
    @RequestMapping(value = TctmUrl.doView)
    public String doView(@RequestParam HashMap<String, String> input, HttpServletRequest request, HttpSession session, ModelMap model) throws JSONException {

        LOGGER.debug("###########################################################");
        LOGGER.debug("tctmTssPlnDetail [과제관리 > 기술팀과제 > 계획 > 마스터 조회]");
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
	 * @param input HashMap<String, String>
	 * @param request HttpServletRequest
	 * @param session HttpSession
	 * @param model ModelMap
	 * @return String
	 * @throws JSONException
	 * */
	@RequestMapping(value=TctmUrl.doTabCmpl)
	public String doTabCmpl(@RequestParam HashMap<String, String> input, HttpServletRequest request,
									HttpSession session, ModelMap model) throws JSONException {

		LOGGER.debug("###########################################################");
		LOGGER.debug("genTssCmplSmryIfm [과제관리 > 기술팀과제 > 완료Tab]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		checkSession(input, session, model);
		String rtnUrl ="";

//		if(input.get("tssSt").equals("104") && (input.get("pgsStepCd").equals("CM") || input.get("pgsStepCd").equals("DC")) ){
//			rtnUrl = "web/prj/tss/gen/cmpl/genTssCmplIfmView";
//		}else{
//			rtnUrl = "web/prj/tss/gen/cmpl/genTssCmplIfm";
//		}

		if(pageMoveChkSession(input.get("_userId"))) {
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
	 *
	 * @param input HashMap<String, Object>
	 * @param request HttpServletRequest
	 * @param session HttpSession
	 * @param model ModelMap
	 * @return ModelAndView
	 * */
	@RequestMapping(value=TctmUrl.doUpdateCmplInfo)
	public ModelAndView doUpdateCmplInfo(@RequestParam HashMap<String, Object> input, HttpServletRequest request,
											HttpSession session, ModelMap model) {

		LOGGER.debug("###########################################################");
		LOGGER.debug("doUpdateCmplInfo [과제관리 > 기술팀과제 > 완료 등록/수정]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		checkSessionObjRUI(input, session, model);

		ModelAndView modelAndView = new ModelAndView("ruiView");

		HashMap<String, Object> mstDs  = null;
		HashMap<String, Object> smryDs = null;

		try {
			mstDs  = (HashMap<String, Object>) RuiConverter.convertToDataSet(request, "mstDataSet").get(0);
			smryDs = (HashMap<String, Object>) RuiConverter.convertToDataSet(request, "smryDataSet").get(0);

			smryDs = StringUtil.toUtf8Input(smryDs);

			// 완료 정보가 없으면 MST SMRY를 복제 있으면 내용 수정
			if("".equals(mstDs.get("cmTssCd"))){
				//신규
				tctmTssService.duplicateTctmTssInfo(mstDs);
				smryDs.put("newTssCd", mstDs.get("newTssCd"));
				tctmTssService.duplicateTctmTssSmryInfo(smryDs);
			}else{
				//수정
				tctmTssService.updateTctmTssInfoCmpl(mstDs);
				tctmTssService.updateTctmTssSmryInfoCmpl(smryDs);
			}

//			genTssCmplService.insertGenTssCmplMst(mstDs, smryDs);

			mstDs.put("rtCd", "SUCCESS");
			mstDs.put("rtVal",messageSourceAccessor.getMessage("msg.alert.saved")); //저장되었습니다.
			mstDs.put("rtType", "I");

		} catch(Exception e) {
			e.printStackTrace();
			mstDs.put("rtCd", "FAIL");
			mstDs.put("rtVal", messageSourceAccessor.getMessage("msg.alert.error")); //오류가 발생하였습니다.
		}

		modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", mstDs));

		return modelAndView;
	}


	/**
	 * 과제관리 > 기술팀과제 > 중단Tab
	 *
	 * @param input HashMap<String, String>
	 * @param request HttpServletRequest
	 * @param session HttpSession
	 * @param model ModelMap
	 * @return String
	 * @throws JSONException
	 * */
	@RequestMapping(value=TctmUrl.doTabDcac)
	public String doTabDcac(@RequestParam HashMap<String, String> input, HttpServletRequest request,
							HttpSession session, ModelMap model) throws JSONException {

		LOGGER.debug("###########################################################");
		LOGGER.debug("doTabDcac [과제관리 > 기술팀과제 > 중단Tab]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		checkSession(input, session, model);
		String rtnUrl ="";

//		if(input.get("tssSt").equals("104") && (input.get("pgsStepCd").equals("CM") || input.get("pgsStepCd").equals("DC")) ){
//			rtnUrl = "web/prj/tss/gen/cmpl/genTssCmplIfmView";
//		}else{
//			rtnUrl = "web/prj/tss/gen/cmpl/genTssCmplIfm";
//		}

		if(pageMoveChkSession(input.get("_userId"))) {
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
	 * 과제관리 > 기술팀과제 > 중단 등록/수정
	 *
	 * @param input HashMap<String, Object>
	 * @param request HttpServletRequest
	 * @param session HttpSession
	 * @param model ModelMap
	 * @return ModelAndView
	 * */
	@RequestMapping(value=TctmUrl.doUpdateDcacInfo)
	public ModelAndView doUpdateDcacInfo(@RequestParam HashMap<String, Object> input, HttpServletRequest request,
										 HttpSession session, ModelMap model) {

		LOGGER.debug("###########################################################");
		LOGGER.debug("doUpdateDcacInfo [과제관리 > 기술팀과제 > 중단 등록/수정]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		checkSessionObjRUI(input, session, model);

		ModelAndView modelAndView = new ModelAndView("ruiView");

		HashMap<String, Object> mstDs  = null;
		HashMap<String, Object> smryDs = null;

		try {
			mstDs  = (HashMap<String, Object>) RuiConverter.convertToDataSet(request, "mstDataSet").get(0);
			smryDs = (HashMap<String, Object>) RuiConverter.convertToDataSet(request, "smryDataSet").get(0);

			smryDs = StringUtil.toUtf8Input(smryDs);

			// 중단 정보가 없으면 MST SMRY를 복제 있으면 내용 수정
			if("".equals(mstDs.get("dcTssCd"))){
				//신규
				tctmTssService.duplicateTctmTssInfo(mstDs);
				smryDs.put("newTssCd", mstDs.get("newTssCd"));
				tctmTssService.duplicateTctmTssSmryInfo(smryDs);
			}else{
				//수정
				tctmTssService.updateTctmTssInfoDcac(mstDs);
				tctmTssService.updateTctmTssSmryInfoDcac(smryDs);
			}

//			genTssCmplService.insertGenTssCmplMst(mstDs, smryDs);

			mstDs.put("rtCd", "SUCCESS");
			mstDs.put("rtVal",messageSourceAccessor.getMessage("msg.alert.saved")); //저장되었습니다.
			mstDs.put("rtType", "I");

		} catch(Exception e) {
			e.printStackTrace();
			mstDs.put("rtCd", "FAIL");
			mstDs.put("rtVal", messageSourceAccessor.getMessage("msg.alert.error")); //오류가 발생하였습니다.
		}

		modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", mstDs));

		return modelAndView;
	}


    // ================================================================================================
    // 개요

    /**
     * 과제관리 > 기술팀과제 > 계획 > 개요 iframe 조회
     *
     * @param input   HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model   ModelMap
     * @return String
     * @throws JSONException
     */
    @RequestMapping(value = TctmUrl.doTabSum)
    public String doTabSum(@RequestParam HashMap<String, String> input, HttpServletRequest request, HttpSession session, ModelMap model) throws JSONException {

        LOGGER.debug("###########################################################");
        LOGGER.debug("tctmTssPlnSmryIfm [과제관리 > 기술팀과제 > 계획 > 개요 조회]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");


        checkSession(input, session, model);

        if (pageMoveChkSession(input.get("_userId").toString())) {
            // 데이터 있을 경우
            Map<String, Object> result = null;
            if (!"".equals(input.get("tssCd")) && null != input.get("tssCd")) {

                TestConsole.showMap(CommonUtil.mapToObj(input),"서머리조회 input");
                result = tctmTssService.selectTctmTssInfoSmry(input);
                TestConsole.showMap(result,"서머리조회 output");
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
    @RequestMapping(value = TctmUrl.doTabGoal)
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
	@RequestMapping(value = TctmUrl.doTabAltr)
	public String doTabAltr(@RequestParam HashMap<String, String> input, HttpServletRequest request,
										  HttpSession session, ModelMap model) throws JSONException {

		LOGGER.debug("###########################################################");
		LOGGER.debug("doTabAltr [과제관리 > 기술팀과제 > 변경 > 개요 조회]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		checkSession(input, session, model);

		if (pageMoveChkSession(input.get("_userId"))) {
			//데이터 있을 경우
			Map<String, Object> result = null;
			if (!"".equals(input.get("tssCd")) && null != input.get("tssCd")) {
//				result = genTssAltrService.retrieveGenTssAltrSmry(input);
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
	 * @param input HashMap<String, Object>
	 * @param request HttpServletRequest
	 * @param session HttpSession
	 * @param model ModelMap
	 * @return ModelAndView
	 * */
	@RequestMapping(value=TctmUrl.doUpdateInfoAltr)
	public ModelAndView doUpdateInfoAltr(@RequestParam HashMap<String, Object> input, HttpServletRequest request,
											HttpSession session, ModelMap model) {
		LOGGER.debug("###########################################################");
		LOGGER.debug("insertGenTssAltrMst [과제관리 > 기술팀과제 > 변경 > 개요 저장/수정]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		checkSessionObjRUI(input, session, model);
		ModelAndView modelAndView = new ModelAndView("ruiView");
		HashMap<String, Object> mstDs  = null;

		try {
			mstDs  = (HashMap<String, Object>) RuiConverter.convertToDataSet(request, "mstDataSet").get(0);
			HashMap<String, Object> smryDs = (HashMap<String, Object>) RuiConverter.convertToDataSet(request, "smryDataSet").get(0);
			List<Map<String, Object>> altrDs = RuiConverter.convertToDataSet(request, "altrDataSet");

			boolean upWbsCd = false;

			smryDs = StringUtil.toUtf8Input(smryDs);
			tctmTssService.updateTctmTssInfoAltrSmry(input,mstDs,smryDs,altrDs);
//			genTssAltrService.insertGenTssAltrMst(mstDs, smryDs, altrDs, upWbsCd);


			mstDs.put("rtCd", "SUCCESS");
			mstDs.put("rtVal",messageSourceAccessor.getMessage("msg.alert.saved")); //저장되었습니다.
//			mstDs.put("rtType", "I");
		} catch(Exception e) {
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
	 * @param input HashMap<String, String>
	 * @param request HttpServletRequest
	 * @param session HttpSession
	 *   @param model ModelMap
	 * @return String
	 * */
	@RequestMapping(value=TctmUrl.doSelectInfoAltrListSmry)
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
	 * @param input HashMap<String, String>
	 * @param request HttpServletRequest
	 * @param session HttpSession
	 *   @param model ModelMap
	 * @return String
	 * */
	@RequestMapping(value=TctmUrl.doCancelInfoAltr)
	public ModelAndView doCancelInfoAltr(@RequestParam HashMap<String, String> input, HttpServletRequest request,
										 HttpSession session, ModelMap model) {
		LOGGER.debug("###########################################################");
		LOGGER.debug("retrieveGenTssAltrSmryList [과제관리 > 기술팀과제 > 변경 > 변경취소]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");


		HashMap<String, Object> rtnMeaasge = new HashMap<String, Object>();
		checkSessionRUI(input, session, model);
		ModelAndView modelAndView = new ModelAndView("ruiView");
		tctmTssService.cancelTctmTssInfoAltrSmry(input);


		rtnMeaasge.put("rtCd", "SUCCESS");
		rtnMeaasge.put("rtVal","변경취소 되었습니다."); //삭제되었습니다.

		modelAndView.addObject("dataset", RuiConverter.createDataset("dataset", rtnMeaasge));
		return modelAndView;
	}

	/**
	 * 과제관리 > 기술팀과제 > 변경 > 내부품의서요청 화면
	 *
	 * @param input HashMap<String, String>
	 * @param request HttpServletRequest
	 * @param session HttpSession
	 * @param model ModelMap
	 * @return String
	 * @throws JSONException
	 * */
	@RequestMapping(value=TctmUrl.doAltrCsusView)
	public String doAltrCsusView(@RequestParam HashMap<String, String> input, HttpServletRequest request,
								   HttpSession session, ModelMap model) throws JSONException {

		LOGGER.debug("###########################################################");
		LOGGER.debug("genTssAltrCsusRq [과제관리 > 기술팀과제 > 변경 > 내부품의서요청 화면 ]");
		LOGGER.debug("###########################################################");

		checkSession(input, session, model);

		if(pageMoveChkSession(input.get("_userId"))) {
//			Map<String, Object> resultMst        = genTssAltrService.retrieveGenTssAltrMst(input); //마스터
//			Map<String, Object> resultCsus       = genTssService.retrieveGenTssCsus(resultMst); //내부품의서
//			Map<String, Object> resultSmry       = genTssAltrService.retrieveGenTssAltrSmry(input); //개요
//			List<Map<String, Object>> resultAltr = genTssAltrService.retrieveGenTssAltrSmryList(input);
			Map<String, Object> resultMst = tctmTssService.selectTctmTssInfo(input);    //마스터 정보
			Map<String, Object> resultCsus = tctmTssService.selectCsus(resultMst);    //통합결제
			Map<String, Object> resultSmry = tctmTssService.selectTctmTssInfoSmry(input);        //개요 정보
			List<Map<String, Object>> resultAltr = tctmTssService.selectTctmTssInfoAltrList(input);    // 변경 목록

			HashMap<String, String> inputInfo = new HashMap<String, String>();
			inputInfo.put("attcFilId", String.valueOf(resultSmry.get("altrAttcFilId")));

			List<Map<String, Object>> resultAttc  = tctmTssService.selectAttachFileList(inputInfo);	//첨부 파일 목록

			resultMst  = StringUtil.toUtf8Output((HashMap) resultMst);
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
	 * @param input HashMap<String, String>
	 * @param request HttpServletRequest
	 * @param session HttpSession
	 * @param model ModelMap
	 * @return String
	 * @throws JSONException
	 * */
	@RequestMapping(value=TctmUrl.doTabAltrHis)
	public String doTabAltrHis(@RequestParam HashMap<String, String> input, HttpServletRequest request,
									   HttpSession session, ModelMap model) throws JSONException {

		LOGGER.debug("###########################################################");
		LOGGER.debug("retrieveGenTssPgsSmry [과제관리 > 기술팀과제 > 진행 > 변경이력 조회]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		checkSession(input, session, model);

		if(pageMoveChkSession(input.get("_userId"))) {
//			List<Map<String, Object>> result = genTssPgsService.retrieveGenTssPgsAltrHist(input);
			List<Map<String, Object>> result = tctmTssService.selectInfoAltrHisListAll(input);
			for(int i = 0; i < result.size(); i++) {
				StringUtil.toUtf8Output((HashMap)result.get(i));
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
	 * @param input HashMap<String, String>
	 * @param request HttpServletRequest
	 * @param session HttpSession
	 * @param model ModelMap
	 * @return String
	 * @throws JSONException
	 * */
	@RequestMapping(value=TctmUrl.doTabAltrHisPop)
	public String doTabAltrHisPop(@RequestParam HashMap<String, String> input, HttpServletRequest request,
										HttpSession session, ModelMap model) throws JSONException {

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
	 * @param request HttpServletRequest
	 * @param session HttpSession
	 * @param model   ModelMap
	 * @return String
	 * @throws JSONException
	 */
	@RequestMapping(value = TctmUrl.doSelectTabAltrHisPop)
	public ModelAndView doSelectTabAltrHisPopSearch(@RequestParam HashMap<String, Object> input, HttpServletRequest request, HttpSession session, ModelMap model) {

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
    @RequestMapping(value = TctmUrl.doUpdateInfo)
    public ModelAndView doUpdateInfo(@RequestParam HashMap<String, Object> input, HttpServletRequest request,
                                          HttpSession session, ModelMap model) {

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

            // deptCode, prjCd, tssScnCd,
            TestConsole.isEmpty("deptCode", mstDs.get("deptCode"));
            TestConsole.isEmpty("prjCd", mstDs.get("prjCd"));
            TestConsole.isEmpty("tssScnCd", mstDs.get("tssScnCd"));
            HashMap<String, Object> getWbs = genTssService.getWbsCdStd("prj.tss.com.getWbsCdStd", mstDs);

            TestConsole.isEmptyMap(mstDs);


            if (getWbs == null || getWbs.size() <= 0) {
                mstDs.put("rtCd", "FAIL");
                mstDs.put("rtVal", "상위사업부코드 또는 Project약어를 먼저 생성해 주시기 바랍니다.");
            } else {
                //SEED WBS_CD 생성
                int seqMax = Integer.parseInt(String.valueOf(getWbs.get("seqMax")));
                String seqMaxS = String.valueOf(seqMax + 1);
                mstDs.put("wbsCd", "D" + seqMaxS);


                TestConsole.isEmpty("wbsCd", mstDs.get("wbsCd"));
                smryDecodeDs = (HashMap<String, Object>) ousdCooTssService.decodeNamoEditorMap(input, smryDs); //에디터데이터 디코딩처리
                smryDecodeDs = StringUtil.toUtf8Input(smryDecodeDs);


                TestConsole.isEmptyMap(mstDs);
                TestConsole.isEmptyMap(smryDecodeDs);


                // TSS CD 생성
                if (mstDs.get("tssCd") == null || mstDs.get("tssCd").equals("")) {
                    String newTssCd = tctmTssService.selectNewTssCdt(mstDs);
                    mstDs.put("tssCd", newTssCd);
                    smryDecodeDs.put("tssCd", newTssCd);
                }

                // 과제 마스터 등록
                tctmTssService.updateTctmTssInfo(mstDs);
                // 과제 개요 등록
                tctmTssService.updateTctmTssSmryInfo(smryDecodeDs);
                // 산출물 등록
                tctmTssService.updateTctmTssYld(mstDs);


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
     * @param input HashMap<String, String>
     * @param request HttpServletRequest
     * @param session HttpSession
     * @param model ModelMap
     * @return ModelAndView
     * */
    @RequestMapping(TctmUrl.doDeleteInfo)
    public ModelAndView doDeleteInfo(@RequestParam HashMap<String, String> input, HttpServletRequest request,
                                           HttpSession session, ModelMap model) {

        LOGGER.debug("###########################################################");
        LOGGER.debug("tctmTssDeleteInfo [과제관리 > 기술팀과제 > 계획 > 삭제]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSessionRUI(input, session, model);

        ModelAndView modelAndView = new ModelAndView("ruiView");

        HashMap<String, Object> mstDs  = new HashMap<String, Object>();

        try {

            tctmTssService.deleteTctmTssInfo(input);

            mstDs.put("rtCd", "SUCCESS");
            mstDs.put("rtVal","삭제되었습니다."); //삭제되었습니다.

        }catch(Exception e) {
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
	 * @param input HashMap<String, String>
	 * @param request HttpServletRequest
	 * @param session HttpSession
	 * @param model ModelMap
	 * @return String
	 * @throws JSONException
	 * */
	@RequestMapping(value=TctmUrl.doCsusView)
	public String doCsusView(@RequestParam HashMap<String, String> input, HttpServletRequest request,
								  HttpSession session, ModelMap model) throws JSONException {

		LOGGER.debug("###########################################################");
		LOGGER.debug("tctmTssController - tctmTssPlnGoalYldIfm [과제관리 > 기술팀과제 > 계획 > 품의서요청 화면 ]");
		LOGGER.debug("###########################################################");

		checkSession(input, session, model);


		if(pageMoveChkSession(input.get("_userId"))) {
			Map<String, Object> resultMst         = tctmTssService.selectTctmTssInfo(input);				// 마스터
			Map<String, Object> resultSmry        = tctmTssService.selectTctmTssInfoSmry(input);	 	//개요
			Map<String, Object> resultCsus        = tctmTssService.selectTssCsus(resultMst); 			//품의서 결제 목록
//			List<Map<String, Object>> resultGoal  = tctmTssService.selectTctmTssInfoGoal(input); 	//목표기술성과
			List<Map<String, Object>> resultTssYy = tctmTssService.selectTssPlnTssYyt(input); 		//과제년도



			HashMap<String, String> inputInfo = new HashMap<String, String>();
			inputInfo.put("tssCd",     String.valueOf(input.get("tssCd")));
			inputInfo.put("pgTssCd",   String.valueOf(resultMst.get("pgTssCd")));
			inputInfo.put("tssStrtDd", String.valueOf(resultMst.get("tssStrtDd")));
			inputInfo.put("tssFnhDd",  String.valueOf(resultMst.get("tssFnhDd")));
			inputInfo.put("attcFilId", String.valueOf(resultSmry.get("attcFilId")));

			List<Map<String, Object>> resultAttc  = genTssCmplService.retrieveGenTssCmplAttc(inputInfo);
//
//			LOGGER.debug("#######################resultBudg #################################### : " + resultBudg);

//			for(int i=0; i < resultBudg.size() ; i++){
//				if(i == 0 ){
//					resultSmry.put("ingun", resultBudg.get(i).get("totSum"));
//				}else if(i == 1 ){
//					resultSmry.put("ounYoung", resultBudg.get(i).get("totSum"));
//				}else if(i == 2 ){
//					resultSmry.put("kungDev", resultBudg.get(i).get("totSum"));
//				}else if(i == 3 ){
//					resultSmry.put("gamgaDev", resultBudg.get(i).get("totSum"));
//				}else if(i == 4 ){
//					resultSmry.put("total", resultBudg.get(i).get("totSum"));
//				}
//			}

			resultMst  = StringUtil.toUtf8Output((HashMap) resultMst);
			resultSmry = StringUtil.toUtf8Output((HashMap) resultSmry);
			resultCsus = StringUtil.toUtf8Output((HashMap) resultCsus);
			//            for(int i = 0; i < resultGoal.size(); i++) {
			//                StringUtil.toUtf8Input((HashMap)resultGoal.get(i));
			//            }

			model.addAttribute("inputData", input);
			model.addAttribute("resultMst", resultMst);
			model.addAttribute("resultSmry", resultSmry);
//			model.addAttribute("resultMbr", resultMbr);
//			model.addAttribute("resultGoal", resultGoal);
			model.addAttribute("resultTssYy", resultTssYy);
//			model.addAttribute("resultBudg", resultBudg);
			model.addAttribute("resultCsus", resultCsus);
			model.addAttribute("resultAttc", resultAttc);

			//text컬럼을 위한 json변환
			JSONObject obj = new JSONObject();
			obj.put("smry", resultSmry);
//			obj.put("goal", resultGoal);

			request.setAttribute("resultJson", obj);
		}

		return TctmUrl.jspCsusView;
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
}
