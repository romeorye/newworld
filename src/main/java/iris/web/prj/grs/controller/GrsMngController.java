package iris.web.prj.grs.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.apache.velocity.app.VelocityEngine;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.ui.velocity.VelocityEngineUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import devonframe.configuration.ConfigService;
import devonframe.dataaccess.CommonDao;
import devonframe.message.saymessage.SayMessage;
import devonframe.util.NullUtil;
import iris.web.common.converter.RuiConverter;
import iris.web.common.util.CommonUtil;
import iris.web.common.util.StringUtil;
import iris.web.prj.grs.service.GrsMngService;
import iris.web.prj.grs.service.GrsReqService;
import iris.web.prj.tss.com.service.TssUserService;
import iris.web.system.base.IrisBaseController;

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

	@Resource(name="commonDao")
	private CommonDao commonDao;
    
	@Resource(name = "configService")
    private ConfigService configService;
	
	@Resource(name = "velocityEngine")
    private VelocityEngine velocityEngine;


	static final Logger LOGGER = LogManager.getLogger(GrsMngController.class);

	/*
	 * GRS 조회 화면
	 */
	@RequestMapping("/prj/grs/listGrsMngInfo.do")
	public String grsReqList(@RequestParam HashMap<String, String> input,
							 HttpSession session, ModelMap model) {

		LOGGER.debug("###########################################################");
		LOGGER.debug("GrsMngController - listGrsMngInfo [grs화면 호출]");
		LOGGER.debug("inputData => " + input);
		LOGGER.debug("###########################################################");

		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);
		input = StringUtil.toUtf8(input);

		model.addAttribute("inputData", input);

		return "web/prj/grs/grsMngList";
	}
	
	/*
	 * GRS 목록 조회
	 */
	@RequestMapping("/prj/grs/selectListGrsMngInfo.do")
	public ModelAndView retrieveGrsReqList(@RequestParam HashMap<String, Object> input,
										   HttpSession session, ModelMap model) {

        LOGGER.debug("###########################################################");
        LOGGER.debug("GrsMngController - selectListGrsMngInfo [GRS 목록 조회]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSessionObjRUI(input, session, model);
        input = StringUtil.toUtf8(input);

        ModelAndView modelAndView = new ModelAndView("ruiView");

        Map<String, Object> role = tssUserService.getTssListRoleChk(input);
        input.put("tssRoleType", role.get("tssRoleType"));
        input.put("tssRoleCd",   role.get("tssRoleCd"));

        List<Map<String,Object>> list = grsMngService.selectListGrsMngList(input);

        modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", list));

        return modelAndView;
    }

	/**
	 * 신규과제 등록 팝업 화면
	 */
	@RequestMapping("/prj/grs/tssRegPop.do")
	public String tssRegPop(@RequestParam HashMap<String, String> input,
							 HttpSession session, ModelMap model) {

		LOGGER.debug("###########################################################");
		LOGGER.debug("GrsMngController - tssRegPop [신규과제팝업화면 호출]");
		LOGGER.debug("inputData => " + input);
		LOGGER.debug("###########################################################");

		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);
		input = StringUtil.toUtf8(input);

		model.addAttribute("inputData", input);

		return "web/prj/grs/tssRegPop";
	}
	
	/*
	 * 신규과제 조회
	 */
	@RequestMapping("/prj/grs/selectGrsMngInfo.do")
	public ModelAndView selectGrsMngInfo(@RequestParam HashMap<String, Object> input,
			 HttpSession session, ModelMap model) {

		LOGGER.debug("###########################################################");
		LOGGER.debug("selectGrsMngInfo [GRS 평가 과제 정보 조회]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");
	
		checkSessionObjRUI(input, session, model);
		ModelAndView modelAndView = new ModelAndView("ruiView");

		input = StringUtil.toUtf8(input);

		HashMap<String, Object> inputMap = new HashMap<String, Object>();
		Map<String, Object> result = grsMngService.selectGrsMngInfo(input);
		
		result = StringUtil.toUtf8Output((HashMap) result);

		modelAndView.addObject("infoDataSet", RuiConverter.createDataset("dataSet", result));

		return modelAndView;
	}

	
	/**
	 * 신규 과제 등록
	 */
	@RequestMapping("/prj/grs/saveTssInfo.do")
	public ModelAndView saveTssInfo(@RequestParam HashMap<String, Object> input, HttpServletRequest request,
            HttpServletResponse response, HttpSession session, ModelMap model) {

        LOGGER.debug("###########################################################");
        LOGGER.debug("GrsMngController - saveTssInfo [신규 과제 등록]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSessionObjRUI(input, session, model);
        ModelAndView modelAndView = new ModelAndView("ruiView");

		input = StringUtil.toUtf8Input(input);
		
		Map<String,Object> resultMap = new HashMap<String, Object>();
		Map<String,Object> ds = new HashMap<String, Object>();
		
		resultMap.put("rtnSt", "F");
		
		try{
			
			ds = RuiConverter.convertToDataSet(request, "dataSet").get(0);
			
			ds.put("userId", input.get("_userId"));
			ds.put("_userSabun", input.get("_userSabun"));
			
			grsMngService.saveTssInfo(ds);
			
			resultMap.put("rtnSt", "S");
			resultMap.put("rtnMsg", "저장 되었습니다.");
		}catch(Exception e){
			resultMap.put("rtnMsg", e.getMessage());
		}
		
		modelAndView.addObject("resultDataSet", RuiConverter.createDataset("resultDataSet", resultMap));


        return modelAndView;
    }
	
	/**
	 * grs평가화면  
	 */
	@RequestMapping("/prj/grs/grsRegPop.do")
	public String grsRegPop(@RequestParam HashMap<String, Object> input,
							 HttpSession session, ModelMap model) {

		LOGGER.debug("###########################################################");
		LOGGER.debug("GrsMngController - grsRegPop [grs평가화면면 호출]");
		LOGGER.debug("inputData => " + input);
		LOGGER.debug("###########################################################");

		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		input = StringUtil.toUtf8(input);

		String url = "";
		
		if( input.get("grsStCd").equals("101") ){
			if( input.get("grsEvSt").equals("P2")  ){
				url = "web/prj/grs/grsRegFnhPop";
			}else{
				url = "web/prj/grs/grsRegPop";
			}
		}else{
			if( input.get("grsEvSt").equals("P2")  ){
				url = "web/prj/grs/grsEvFnhDtlPop";
			}else{
				url = "web/prj/grs/grsEvDtlPop";
			}
		}
		
		model.addAttribute("inputData", input);

		return url;
	}
	
	/**
	 * GRS 정보 조회
	 */
	@RequestMapping("/prj/grs/retrievveGrsInfo.do")
	public ModelAndView retrievveGrsInfo(@RequestParam HashMap<String, Object> input, HttpServletRequest request,
            HttpServletResponse response, HttpSession session, ModelMap model) {

        LOGGER.debug("###########################################################");
        LOGGER.debug("GrsMngController - retrievveGrsInfo [GRS 정보 조회]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSessionObjRUI(input, session, model);
        ModelAndView modelAndView = new ModelAndView("ruiView");

		input = StringUtil.toUtf8Input(input);
		
		Map<String, Object> result = grsMngService.retrievveGrsInfo(input);
		List<Map<String, Object>> grsEvList = grsReqService.retrieveGrsReqDtlLst(input);
		
		modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", result));
		modelAndView.addObject("gridDataSet", RuiConverter.createDataset("gridDataSet", grsEvList));

        return modelAndView;
    }
	
	/**
	 * GRS평가 임시저장(계획)
	 */
	@RequestMapping("/prj/grs/saveTmpGrsEvRsltInfo.do")
	public ModelAndView saveTmpGrsEvRsltInfo(@RequestParam HashMap<String, Object> input, HttpServletRequest request,
            HttpServletResponse response, HttpSession session, ModelMap model) {

        LOGGER.debug("###########################################################");
        LOGGER.debug("GrsMngController - saveTmpGrsEvRsltInfo [GRS평가 임시저장]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSessionObjRUI(input, session, model);
        ModelAndView modelAndView = new ModelAndView("ruiView");

		input = StringUtil.toUtf8Input(input);
		
		Map<String,Object> resultMap = new HashMap<String, Object>();
		Map<String,Object> dsMap = new HashMap<String, Object>();
		
		resultMap.put("rtnSt", "F");
		
		try{
			dsMap.put("input", input);
			dsMap.put("dataSet", RuiConverter.convertToDataSet(request, "dataSet").get(0));
			dsMap.put("gridDataSet", RuiConverter.convertToDataSet(request, "gridDataSet"));
			
			grsMngService.saveTmpGrsEvRsltInfo(dsMap);
			
			resultMap.put("rtnSt", "S");
			resultMap.put("rtnMsg", "임시저장 되었습니다.");
		}catch(Exception e){
			resultMap.put("rtnMsg", e.getMessage());
		}
		
		modelAndView.addObject("resultDataSet", RuiConverter.createDataset("resultDataSet", resultMap));

        return modelAndView;
    }
	
		
	/**
	 * GRS평가 저장(계획)
	 */
	@RequestMapping("/prj/grs/saveGrsEvRsltInfo.do")
	public ModelAndView saveGrsEvRsltInfo(@RequestParam HashMap<String, Object> input, HttpServletRequest request,
            HttpServletResponse response, HttpSession session, ModelMap model) {

        LOGGER.debug("###########################################################");
        LOGGER.debug("GrsMngController - saveGrsEvRsltInfo [GRS평가 저장]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        checkSessionObjRUI(input, session, model);
        ModelAndView modelAndView = new ModelAndView("ruiView");

		input = StringUtil.toUtf8Input(input);
		
		Map<String,Object> resultMap = new HashMap<String, Object>();
		Map<String,Object> dsMap = new HashMap<String, Object>();
		
		resultMap.put("rtnSt", "F");
		
		try{
			dsMap.put("input", input);
			dsMap.put("dataSet", RuiConverter.convertToDataSet(request, "dataSet").get(0));
			dsMap.put("gridDataSet", RuiConverter.convertToDataSet(request, "gridDataSet"));
			
			grsMngService.saveGrsEvRsltInfo(dsMap);
			
			resultMap.put("rtnSt", "S");
			resultMap.put("rtnMsg", "GRS평가가 저장되었습니다.");
		}catch(Exception e){
			resultMap.put("rtnMsg", e.getMessage());
		}
		
		modelAndView.addObject("resultDataSet", RuiConverter.createDataset("resultDataSet", resultMap));

        return modelAndView;
    }	
	
	
	/**
	 * GRS품의  요청
	 * @param input
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping("/prj/grs/requestGrsApproval.do")
	public ModelAndView requestGrsApproval(
			@RequestParam HashMap<String, Object> input, HttpServletRequest request,
            HttpServletResponse response,
			HttpSession session,
			ModelMap model
	) {

		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);

		LOGGER.debug("###########################################################");
		LOGGER.debug("GrsMngController - requestGrsApproval Grs 결재요청");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		ModelAndView modelAndView = new ModelAndView("ruiView");

		Map<String, Object> resultMap = new HashMap<>();

		try {
			input.put("cmd", "requestApproval");
			
			List<Map<String, Object>> appList =  RuiConverter.convertToDataSet(request, "appDataSet");
			
			String serverUrl = "http://" + configService.getString("defaultUrl") + ":" + configService.getString("serverPort") + "/" + configService.getString("contextPath");
			StringBuffer sb = new StringBuffer();

			input = StringUtil.toUtf8Input(input);

//			String tssCode = (String) input.get("tssCds");

			String[] tssCds = (NullUtil.nvl(input.get("tssCds"), "")).split(",");
			List<String> tssCdList = new ArrayList<>();

			String commTxt = "";

			for (String tssCd : tssCds) {
				tssCdList.add(tssCd);
			}

			input.put("tssCdList", tssCdList);

			String guid = grsMngService.getGuid(input);

			Map<String, Object> grsApprInfo = new HashMap<>();

			List<Map<String, Object>> grsInfo = grsMngService.retrieveGrsApproval(input);

			grsApprInfo.put("evTitl", grsInfo.get(0).get("evTitl"));
			grsApprInfo.put("cfrnAtdtCdTxtNm", grsInfo.get(0).get("cfrnAtdtCdTxtNm"));

			List<Map<String, Object>> rqprAttachFileList = commonDao.selectList("common.attachFile.getAttachFileList", input);

			for (int i = 0; i < grsInfo.size(); i++) {
				String dropYn = "";
				if(grsInfo.get(i).get("dropYn") !=null ){
					if(grsInfo.get(i).get("dropYn").equals("Y")){
						dropYn = "DROP";
					}else if(grsInfo.get(i).get("dropYn").equals("N")){
						dropYn = "PASS";
					}
				}
				sb.append("<tr>")
						.append("<th>").append(grsInfo.get(i).get("grsEvSt")).append("</th>")
						.append("<td>").append(grsInfo.get(i).get("prjNm")).append("</td>")
						.append("<td>").append(grsInfo.get(i).get("tssNm")).append("</td>")
						.append("<td>").append(grsInfo.get(i).get("saSabunName")).append("</td>")
						.append("<td>").append(grsInfo.get(i).get("tssType")).append("</td>")
						.append("<td>").append(grsInfo.get(i).get("evScr")).append("</td>")
						.append("<td>").append(dropYn).append("</td>")
						.append("</tr>");
			}

			grsApprInfo.put("grsEvResult", sb.toString());

			sb.delete(0, sb.length());

			for (int i = 0; i < grsInfo.size(); i++) {
				commTxt = ((String) grsInfo.get(i).get("commTxt")).replaceAll("\n", "<br/>");

				sb.append("<li class='analyze_field'>")
						.append("<p class='analyze_s_txt'><b>과제명 : </b>").append(grsInfo.get(i).get("tssNm")).append("</p>")
						.append("<p class='analyze_s_txt'><b>주요 Comment : </b><p style='padding-left:20px; box-sizing:border-box;line-height:1.4;'>").append(commTxt).append("</p></p>");
				sb.append("</p></li>");
			}

			grsApprInfo.put("grsInfo", sb.toString());

			sb.delete(0, sb.length());

			String body = VelocityEngineUtils.mergeTemplateIntoString(velocityEngine, "iris/web/prj/grs/vm/grsApproval.vm", "UTF-8", grsApprInfo);

			Map<String, Object> itgRdcsInfo = new HashMap<String, Object>();

			// guid= B : 신뢰성 분석의뢰, D : 신뢰성 분석완료, E : 공간성능 평가의뢰, G : 공간성능 평가완료 + rqprId
			itgRdcsInfo.put("guId", guid);
			itgRdcsInfo.put("approvalUserid", input.get("_userId"));
			itgRdcsInfo.put("approvalUsername", input.get("_userNm"));
			itgRdcsInfo.put("approvalJobtitle", input.get("_userJobxName"));
			itgRdcsInfo.put("approvalDeptname", input.get("_userDeptName"));
			itgRdcsInfo.put("body", body);
			itgRdcsInfo.put("title", "연구/개발과제 GRS 평가결과 보고의 件 ");

			commonDao.delete("common.itgRdcs.deleteItgRdcsInfo", itgRdcsInfo);

			if (commonDao.insert("common.itgRdcs.saveItgRdcsInfo", itgRdcsInfo) == 0) {
				throw new Exception("결재요청 정보 등록 오류");
			}

			input.put("guid", guid);
			grsMngService.updateApprGuid(input);

			for( Map<String, Object> appData : appList   ){
				appData.put("guid", guid);
			}

			grsMngService.updateGrsGuid(appList);
			
			resultMap.put("guid", guid);
			resultMap.put("rtnSt", "Y");
			resultMap.put("rtnMsg", "");
		} catch (Exception e) {
			e.printStackTrace();
			resultMap.put("rtnSt", "N");
			resultMap.put("rtnMsg", "작업을 실패하였습니다\n관리자에게 문의하세요.");
		}

		modelAndView.addObject("resultDataSet", RuiConverter.createDataset("resultDataSet", resultMap));

		return modelAndView;

	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
//==========================================  구 시스템 =============================================================================================================//	
	

	/*
	 * GRS 기본정보 저장
	 */
	@RequestMapping("/prj/grs/updateGrsMngInfo.do")
	public ModelAndView updateGrsEvRslt(@RequestParam HashMap<String, Object> input, HttpSession session, ModelMap model) {

		LOGGER.debug("###########################################################");
		LOGGER.debug("updateGrsMngInfo [GRS 기본정보 저장]");
		LOGGER.debug("input = > " + input);
		
		LOGGER.debug("###########################################################");
//		String rtnMsg = "";
//		String rtnSt = "";
		Map<String, Object> msgMap = new HashMap<>();

		HashMap<String, Object> rtnMeaasge = new HashMap<String, Object>();
		ModelAndView modelAndView = new ModelAndView("ruiView");
		checkSessionObjRUI(input, session, model);
		try {
			msgMap = grsMngService.saveGrsInfo(input);
		} catch (Exception e) {
			e.printStackTrace();
			msgMap.put("rtnMsg", "처리중 오류가발생했습니다. 담당자에게 문의해주세요");
		}

		rtnMeaasge.put("rtnMsg", msgMap.get("rtnMsg"));
		rtnMeaasge.put("rtnSt", msgMap.get("rtnSt"));
		modelAndView.addObject("resultDataSet", RuiConverter.createDataset("resultDataSet", rtnMeaasge));

		return modelAndView;
	}
	/*
	 * GRS 기본정보 삭제
	 */
	@RequestMapping("/prj/grs/deleteGrsMngInfo.do")
	public ModelAndView deleteGrsMngInfo(@RequestParam HashMap<String, Object> input) {

		LOGGER.debug("###########################################################");
		LOGGER.debug("deleteGrsMngInfo [GRS 기본정보 삭제]");
		LOGGER.debug("input = > " + input);
		
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
	@RequestMapping("/prj/grs/selectGrsTssInfo.do")
	public ModelAndView selectGrsTssInfo(@RequestParam HashMap<String, Object> input) {

		LOGGER.debug("###########################################################");
		LOGGER.debug("selectGrsEvRsltInfo [GRS 평가 과제 정보 조회]");
		LOGGER.debug("input = > " + input);
		
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
	 */
	@RequestMapping("/prj/grs/selectGrsEvRsltInfo.do")
	public ModelAndView selectGrsEvRsltInfo(@RequestParam HashMap<String, Object> input) {

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
	@RequestMapping("/prj/grs/insertTmpGrsEvRsltInfo.do")
	public ModelAndView insertTmpGrsEvRsltInfo(@RequestParam HashMap<String, Object> input, HttpServletRequest request, HttpSession session, ModelMap model) {

		LOGGER.debug("###########################################################");
		LOGGER.debug("insertTmpGrsEvRsltInfo [평가 정보 임시저장]");
		LOGGER.debug("input = > " + input);
		
		LOGGER.debug("###########################################################");

		checkSessionObjRUI(input, session, model);
		ModelAndView modelAndView = new ModelAndView("ruiView");
		HashMap<String, Object> rtnMeaasge = new HashMap<String, Object>();
		List<Map<String, Object>> dsLst;
		HashMap<String, Object> dtlDs;
		String rtnMsg = "";
		String rtnSt = "F";

		try {
			dsLst = RuiConverter.convertToDataSet(request, "gridDataSet");
			dtlDs =  (HashMap<String, Object>)   RuiConverter.convertToDataSet(request, "evInfoDataSet").get(0);
			
			input.put("evTitl", dtlDs.get("evTitl"));
			input.put("commTxt", dtlDs.get("commTxt"));
			input.put("userId", input.get("_userId"));
			input.put("cfrnAtdtCdTxt", input.get("cfrnAtdtCdTxt").toString().replaceAll("%2C", ",")); //참석자

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
	 * 신규과제 수정 팝업 화면
	 */
	@RequestMapping("/prj/grs/tssUpdatePop.do")
	public String tssUpdatePop(@RequestParam HashMap<String, String> input,
			HttpSession session, ModelMap model) {
		
		LOGGER.debug("###########################################################");
		LOGGER.debug("GrsMngController - tssUpdatePop [과제수정팝업화면 호출]");
		LOGGER.debug("inputData => " + input);
		LOGGER.debug("###########################################################");
		
		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);
		input = StringUtil.toUtf8(input);
		
		model.addAttribute("inputData", input);
		
		return "web/prj/grs/tssUpdatePop";
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
