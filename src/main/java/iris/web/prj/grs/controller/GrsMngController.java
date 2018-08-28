package iris.web.prj.grs.controller;

import devonframe.message.saymessage.SayMessage;
import devonframe.util.NullUtil;
import iris.web.common.converter.RuiConverter;
import iris.web.common.util.StringUtil;
import iris.web.prj.grs.service.GrsMngService;
import iris.web.prj.grs.service.GrsReqService;
import iris.web.prj.tss.com.service.TssUserService;
import iris.web.prj.tss.gen.service.GenTssPlnService;
import iris.web.prj.tss.gen.service.GenTssService;
import iris.web.system.base.IrisBaseController;
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
	 * GRS 기본정보 저장
	 */
	@RequestMapping(value = "/prj/grs/updateGrsMngInfo.do")
	public ModelAndView updateGrsEvRslt(@RequestParam HashMap<String, Object> input, HttpServletRequest request, HttpServletResponse response, HttpSession session, ModelMap model) {

		LOGGER.debug("###########################################################");
		LOGGER.debug("updateGrsMngInfo [GRS 기본정보 저장]");
		LOGGER.debug("input = > " + input);
		System.out.println(input);
		LOGGER.debug("###########################################################");


		HashMap<String, Object> getWbs = genTssService.getWbsCdStd("prj.tss.com.getWbsCdStd", input);
		input.put("pkWbsCd", getWbs.get("wbsCdStd"));
		input.put("pgsStepCd", "PL");								// 과제 진행 단계 코드
		input.put("tssSt", "100");									// 과제 상태


		checkSessionObjRUI(input, session, model);
		ModelAndView modelAndView = new ModelAndView("ruiView");
		HashMap<String, Object> rtnMeaasge = new HashMap<String, Object>();

		String rtnMsg = "";
		String rtnSt = "F";
		try {
			// mchnCgdgService.saveCgdsMst(input);
			grsMngService.updateGrsInfo(input);
			rtnMsg = "저장되었습니다.";
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
