package iris.web.prj.grs.controller;

import devonframe.message.saymessage.SayMessage;
import devonframe.util.NullUtil;
import iris.web.common.converter.RuiConverter;
import iris.web.common.util.CommonUtil;
import iris.web.common.util.StringUtil;
import iris.web.prj.grs.service.GrsMngService;
import iris.web.prj.grs.service.GrsReqService;
import iris.web.prj.tss.com.service.TssUserService;
import iris.web.prj.tss.gen.service.GenTssPlnService;
import iris.web.prj.tss.gen.service.GenTssService;
import iris.web.system.base.IrisBaseController;
import iris.web.tssbatch.service.TssStCopyService;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
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
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
public class GrsMngController extends IrisBaseController {

	@Resource(name = "messageSourceAccessor")
	private MessageSourceAccessor messageSourceAccessor;

	@Resource(name = "tssUserService")
	private TssUserService tssUserService;

	@Resource(name = "grsReqService")
	private GrsReqService grsReqService;

	@Resource(name = "grsMngService")
	private GrsMngService grsMngService;

	@Resource(name = "genTssPlnService")
	private GenTssPlnService genTssPlnService;

    @Resource(name = "genTssService")
    private GenTssService genTssService;




	static final Logger LOGGER = LogManager.getLogger(GrsMngController.class);

	/*
	 * GRS 조회 화면
	 */
	@RequestMapping(value = "/prj/grs/listGrsMngInfo.do")
	public String grsReqList(@RequestParam HashMap<String, String> input,
			HttpServletRequest request, HttpSession session, ModelMap model) {

		LOGGER.debug("###########################################################");
		LOGGER.debug("GrsMngController - listGrsMngInfo [grs화면 호출]");
		LOGGER.debug("inputData => " + input);
		LOGGER.debug("###########################################################");

		input = StringUtil.toUtf8(input);


		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);

		if (pageMoveChkSession(input.get("_userId"))) {
			model.addAttribute("inputData", input);
		}

		return "web/prj/grs/grsMngList";
	}
	/*
	 * GRS 목록 조회
	 */
    @RequestMapping(value="/prj/grs/selectListGrsMngInfo.do")
    public ModelAndView retrieveGrsReqList(@RequestParam HashMap<String, Object> input, HttpServletRequest request,
            HttpServletResponse response, HttpSession session, ModelMap model) {

        LOGGER.debug("###########################################################");
        LOGGER.debug("GrsMngController - selectListGrsMngInfo [GRS 목록 조회]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSessionObjRUI(input, session, model);

        ModelAndView modelAndView = new ModelAndView("ruiView");

        input = StringUtil.toUtf8(input);

        Map<String, Object> role = tssUserService.getTssListRoleChk(input);
        input.put("tssRoleType", role.get("tssRoleType"));
        input.put("tssRoleCd",   role.get("tssRoleCd"));

        List<Map<String,Object>> list = grsMngService.selectListGrsMngList(input);

        modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", list));

        return modelAndView;
    }

	/*
	 * GRS 기본정보 조회
	 */
	@RequestMapping(value = "/prj/grs/selectGrsMngInfo.do")
	public ModelAndView selectGrsMngInfo(@RequestParam HashMap<String, Object> input, HttpServletRequest request, HttpServletResponse response, HttpSession session, ModelMap model) {

		LOGGER.debug("###########################################################");
		LOGGER.debug("selectGrsMngInfo [GRS 평가 과제 정보 조회]");
		LOGGER.debug("input = > " + input);
		System.out.println(input);
		LOGGER.debug("###########################################################");

		ModelAndView modelAndView = new ModelAndView("ruiView");

		input = StringUtil.toUtf8(input);
		HashMap<String, Object> inputMap = new HashMap<String, Object>();


		Map<String, Object> result = grsMngService.selectGrsMngInfo(input);
//		Map<String, Object> result = grsReqService.retrieveGrsEvRslt(CommonUtil.mapToString(input));
		result = StringUtil.toUtf8Output((HashMap) result);

		modelAndView.addObject("infoDataSet", RuiConverter.createDataset("dataSet", result));


		LOGGER.debug("###########################################################");
		LOGGER.debug("modelAndView => " + modelAndView);
		LOGGER.debug("###########################################################");

		return modelAndView;
	}


	/*
	 * GRS 기본정보 저장
	 */
	@RequestMapping(value = "/prj/grs/updateGrsMngInfo.do")
	public ModelAndView updateGrsEvRslt(@RequestParam HashMap<String, Object> input, HttpServletRequest request, HttpServletResponse response, HttpSession session, ModelMap model) {

		LOGGER.debug("###########################################################");
		LOGGER.debug("updateGrsMngInfo [GRS 기본정보 저장]");
		LOGGER.debug("input = > " + input);
		System.out.println(input);
		LOGGER.debug("###########################################################");
		String rtnMsg = "";
		HashMap<String, Object> rtnMeaasge = new HashMap<String, Object>();
		ModelAndView modelAndView = new ModelAndView("ruiView");
		String rtnSt = "";

		try {
			if ("".equals(input.get("tssCd"))) {
				checkSessionObjRUI(input, session, model);
				rtnSt = "F";

				//신규
				HashMap<String, Object> getWbs = genTssService.getWbsCdStd("prj.tss.com.getWbsCdStd", input);
				//SEED WBS_CD 생성
				int seqMax = Integer.parseInt(String.valueOf(getWbs.get("seqMax")));
				String seqMaxS = String.valueOf(seqMax + 1);
				input.put("wbsCd", input.get("tssScnCd") + seqMaxS);
				input.put("pkWbsCd", input.get("wbsCd"));
				input.put("userId", input.get("_userId"));
				String grsYn = (String) input.get("grsYn");

				// GRS(P1)을 수행하는 경우 계획 하지 않는 경우 진행단계
				if (grsYn.equals("Y")) {
					input.put("pgsStepCd", "PL");                                // 과제 진행 단계 코드
					input.put("tssSt","101");
				}else if (grsYn.equals("N")) {
					input.put("pgsStepCd","PG");
					input.put("tssSt","100");
				}

				// mchnCgdgService.saveCgdsMst(input);
				grsMngService.updateGrsInfo(input);                                                        //과제 기본정보 등록
				input.put("tssCd", input.get("newTssCd"));

				if (grsYn.equals("Y")) {
					LOGGER.debug("=============== GRS=Y 인경우 GRS 요청정보 생성 ===============");
					input.put("grsEvSt", "P1");
					grsMngService.updateGrsReqInfo(input);                                            //GRS 정보 등록
				}else if (grsYn.equals("N")) {
					LOGGER.debug("=============== GRS 미수행시 마스터 이관 ===============");
					grsMngService.moveDefGrsDefInfo(input);	// 과제정보 마스터 이관
					//Qgate I/F
					//리더에게 에게 메일 발송
//					genTssPlnService.retrieveSendMail(input); //개발에서 데이터 등록위해 반영위해 주석 1121

				}

				rtnMsg = "저장되었습니다.";
				rtnSt = "S";
			} else {
				grsMngService.updateGrsInfo(input);                                                        // 과제 기본정보 수정
				rtnMsg = "수정되었습니다.";
				rtnSt = "S";
			}
		} catch (Exception e) {
			e.printStackTrace();
			rtnMsg = "처리중 오류가발생했습니다. 담당자에게 문의해주세요";
		}

		rtnMeaasge.put("rtnMsg", rtnMsg);
		rtnMeaasge.put("rtnSt", rtnSt);
		modelAndView.addObject("resultDataSet", RuiConverter.createDataset("resultDataSet", rtnMeaasge));

		return modelAndView;
	}
	/*
	 * GRS 기본정보 삭제
	 */
	@RequestMapping(value = "/prj/grs/deleteGrsMngInfo.do")
	public ModelAndView deleteGrsMngInfo(@RequestParam HashMap<String, Object> input, HttpServletRequest request, HttpServletResponse response, HttpSession session, ModelMap model) {

		LOGGER.debug("###########################################################");
		LOGGER.debug("deleteGrsMngInfo [GRS 기본정보 삭제]");
		LOGGER.debug("input = > " + input);
		System.out.println(input);
		LOGGER.debug("###########################################################");
		String rtnMsg = "";
		HashMap<String, Object> rtnMeaasge = new HashMap<String, Object>();
		ModelAndView modelAndView = new ModelAndView("ruiView");
		String rtnSt = "";

		try {
				grsMngService.deleteGrsInfo(input);

				rtnMsg = "삭제되었습니다.";
				rtnSt = "S";
		} catch (Exception e) {
			e.printStackTrace();
			rtnMsg = "처리중 오류가발생했습니다. 담당자에게 문의해주세요";
		}

		rtnMeaasge.put("rtnMsg", rtnMsg);
		rtnMeaasge.put("rtnSt", rtnSt);
		modelAndView.addObject("resultDataSet", RuiConverter.createDataset("resultDataSet", rtnMeaasge));

		return modelAndView;
	}

	/*
	 * GRS 평가 과제 정보 조회
	 */
	@RequestMapping(value = "/prj/grs/selectGrsTssInfo.do")
	public ModelAndView selectGrsTssInfo(@RequestParam HashMap<String, Object> input, HttpServletRequest request, HttpServletResponse response, HttpSession session, ModelMap model) {

		LOGGER.debug("###########################################################");
		LOGGER.debug("selectGrsEvRsltInfo [GRS 평가 과제 정보 조회]");
		LOGGER.debug("input = > " + input);
		System.out.println(input);
		LOGGER.debug("###########################################################");

		ModelAndView modelAndView = new ModelAndView("ruiView");

		input = StringUtil.toUtf8(input);
		HashMap<String, Object> inputMap = new HashMap<String, Object>();

		Map<String, Object> result = grsReqService.retrieveGrsEvRslt(CommonUtil.mapToString(input));
		result = StringUtil.toUtf8Output((HashMap) result);

		modelAndView.addObject("evInfoDataSet", RuiConverter.createDataset("dataSet", result));


		LOGGER.debug("###########################################################");
		LOGGER.debug("modelAndView => " + modelAndView);
		LOGGER.debug("###########################################################");

		return modelAndView;
	}



	/**
	 * GRS 평가 항목 조회
	 * @param input
	 * @param request
	 * @param response
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/prj/grs/selectGrsEvRsltInfo.do")
	public ModelAndView selectGrsEvRsltInfo(@RequestParam HashMap<String, Object> input, HttpServletRequest request,
										  HttpServletResponse response, HttpSession session, ModelMap model) {

		LOGGER.debug("###########################################################");
		LOGGER.debug("retrieveGrsTempList - retrieveGrsReqDtl [grs req]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		ModelAndView modelAndView = new ModelAndView("ruiView");

		input = StringUtil.toUtf8(input);


		HashMap<String, Object> inputMap = new HashMap<String, Object>();
		String grsEvSn =  (String) input.get("grsEvSn");

		inputMap.put("grsEvSn", grsEvSn);
		inputMap.put("tssCd", input.get("tssCd"));
		inputMap.put("tssCdSn", input.get("tssCdSn"));
		List<Map<String, Object>> rstGridDataSet = grsReqService.retrieveGrsReqDtlLst(inputMap);

		modelAndView.addObject("evGrsDataSet", RuiConverter.createDataset("dataSet", rstGridDataSet));


		LOGGER.debug("###########################################################");
		LOGGER.debug("modelAndView => " + modelAndView);
		LOGGER.debug("###########################################################");

		return modelAndView;
	}


	/*
	 * 평가 정보 임시저장
	 */
	@RequestMapping(value = "/prj/grs/insertTmpGrsEvRsltInfo.do")
	public ModelAndView insertTmpGrsEvRsltInfo(@RequestParam HashMap<String, Object> input, HttpServletRequest request, HttpServletResponse response, HttpSession session, ModelMap model) {

		LOGGER.debug("###########################################################");
		LOGGER.debug("insertTmpGrsEvRsltInfo [평가 정보 임시저장]");
		LOGGER.debug("input = > " + input);
		System.out.println(input);
		LOGGER.debug("###########################################################");

		checkSessionObjRUI(input, session, model);
		ModelAndView modelAndView = new ModelAndView("ruiView");
		HashMap<String, Object> rtnMeaasge = new HashMap<String, Object>();
		List<Map<String, Object>> dsLst = null;
		String rtnMsg = "";
		String rtnSt = "F";

		try {
			dsLst = RuiConverter.convertToDataSet(request, "gridDataSet");
			input.put("userId", input.get("_userId"));
			input.put("cfrnAtdtCdTxt", input.get("cfrnAtdtCdTxt").toString().replaceAll("%2C", ",")); //참석자
			input = StringUtil.toUtf8Input(input);

			grsReqService.updateGrsEvRslt(input);
			for(Map<String, Object> ds  : dsLst) {
				ds.put("userId", input.get("_userId"));
				ds.put("tssCd", input.get("tssCd"));
				ds.put("tssCdSn", input.get("tssCdSn"));
				grsReqService.updateGrsEvStdRslt(ds);
			}


			rtnMsg = "임시저장되었습니다.";
			rtnSt = "S";
		} catch (Exception e) {
			e.printStackTrace();
			rtnMsg = "처리중 오류가발생했습니다. 담당자에게 문의해주세요";
		}

		rtnMeaasge.put("rtnMsg", rtnMsg);
		rtnMeaasge.put("rtnSt", rtnSt);

		modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", rtnMeaasge));
		return modelAndView;
	}



	/**
	 * 페이지 이동시 세션체크
	 *
	 * @param userId
	 *            로그인ID
	 * @return boolean
	 * */
	public boolean pageMoveChkSession(String userId) {

		boolean rtVal = true;

		if (NullUtil.isNull(userId) || NullUtil.nvl(userId, "").equals("-1")) {
			SayMessage.setMessage(messageSourceAccessor
					.getMessage("msg.alert.sessionTimeout"));
			rtVal = false;
		}

		return rtVal;
	}

}
