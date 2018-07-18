package iris.web.prj.rsst.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import devonframe.message.saymessage.SayMessage;
import devonframe.util.NullUtil;
import iris.web.common.converter.RuiConverter;
import iris.web.common.util.StringUtil;
import iris.web.prj.rsst.service.PrjPtotPrptInfoService;
import iris.web.prj.rsst.service.PrjRsstMboInfoService;
import iris.web.prj.rsst.service.PrjRsstMstInfoService;
import iris.web.prj.rsst.service.PrjRsstPduInfoService;
import iris.web.prj.rsst.service.RsstClsService;
import iris.web.system.attach.service.AttachFileService;
import iris.web.system.base.IrisBaseController;

@Controller
public class RsstClsController extends IrisBaseController {

	@Resource(name="messageSourceAccessor")
	private MessageSourceAccessor messageSourceAccessor;

	@Resource(name = "rsstClsService")
	private RsstClsService rsstClsService;

	@Resource(name = "prjRsstMboInfoService")
	private PrjRsstMboInfoService prjRsstMboInfoService;	// MBO서비스

	@Resource(name = "prjRsstPduInfoService")
	private PrjRsstPduInfoService prjRsstPduInfoService;    // PDU서비스

	@Resource(name = "attachFileService")
	private AttachFileService attachFileService;			// 첨부파일서비스

	@Resource(name = "prjPtotPrptInfoService")
	private PrjPtotPrptInfoService prjPtotPrptInfoService;	// 지적재산권서비스
	
	@Resource(name = "prjRsstMstInfoService")
	private PrjRsstMstInfoService prjRsstMstInfoService; 	// 프로젝트 마스터 서비스

	static final Logger LOGGER = LogManager.getLogger(RsstClsController.class);


	/**
	 *  프로젝트 월마감 화면으로 이동
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	@SuppressWarnings("rawtypes")
	@RequestMapping(value="/prj/rsst/retrievePrjClsList.do")
	public String retrievePrjClsList(@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){

		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		LOGGER.debug("#####################################################################################");
		LOGGER.debug("RsstClsController - retrievePrjClsListInfo [프로젝트 마감 조회 화면]");
		LOGGER.debug("#####################################################################################");

        model.addAttribute("inputData", input);
		return  "web/prj/rsst/prjRsstClsList";
	}


	/**
	 *  프로젝트 월마감 리스트 조회
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	@SuppressWarnings("rawtypes")
	@RequestMapping(value="/prj/rsst/retrievePrjClsSearchList.do")
	public ModelAndView retrievePrjClsSearchList(@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){

		HashMap lsession = (HashMap)session.getAttribute("irisSession");
		LOGGER.debug("session="+lsession);

		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);

		ModelAndView modelAndView = new ModelAndView("ruiView");

		if(NullUtil.isNull(input.get("_userId")) ||  NullUtil.nvl(input.get("_userId"), "").equals("-1")  ){
			String rtnMsg = messageSourceAccessor.getMessage("msg.alert.sessionTimeout");
			SayMessage.setMessage(rtnMsg);
			modelAndView.addObject("dataset", null);
        } else {
//        	// 로그인유저 팀만 조회
//        	input.put("searchType","SABUN");
//        	input.put("searchSabun",input.get("_userSabun"));

        	List<Map<String, Object>> resultList = rsstClsService.retrievePrjClsList(input);
			modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", resultList));
        }

		return  modelAndView;
	}



	/**
	 * 프로젝트 월마감 상세 화면으로 이동
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/prj/rsst/retrievePrjRsstClsDtl.do")
	public String retrievePrjRsstClsDtl(@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		
		LOGGER.debug("########################################################################################");
		LOGGER.debug("RsstClsController - retrievePrjRsstClsDtl [프로젝트 월마감 상세 화면으로 이동]");
		LOGGER.debug("########################################################################################");

		
		if(NullUtil.isNull(input.get("_userId")) ||  NullUtil.nvl(input.get("_userId"), "").equals("-1")  ){
			String rtnMsg = messageSourceAccessor.getMessage("msg.alert.sessionTimeout");
			SayMessage.setMessage(rtnMsg);
        } else {
        	model.addAttribute("input", input);
        }
		return  "web/prj/rsst/prjRsstClsDtl";
	}


	/**
	 *  프로젝트 월마감 상세 조회
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/prj/rsst/retrievePrjClsSearchDtl.do")
	public ModelAndView retrievePrjClsSearchDtl(@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
		checkSessionObjRUI(input, session, model);
		
		LOGGER.debug("########################################################################################");
		LOGGER.debug("RsstClsController - retrievePrjClsSearchDtl [월마감 필요정보(mbo, pdu, ptoprpt, cls) 모두 조회]");
		LOGGER.debug("input : " + input);
		LOGGER.debug("########################################################################################");

		ModelAndView modelAndView = new ModelAndView("ruiView");
		String attcFilId = "";
		
		Map<String, Object> prjMap = prjRsstMstInfoService.retrievePrjMstInfo(input);
    	List<Map<String, Object>> mboList = prjRsstMboInfoService.retrievePrjRsstMboSearchInfo(input);
    	List<Map<String, Object>> tssPgsList = null;
//    	List<Map<String, Object>> pduList = prjRsstPduInfoService.retrievePrjRsstPduSearchInfo(input);
//    	List<Map<String, Object>> ptoprptList = prjPtotPrptInfoService.retrievePrjErpPrptInfo(input);
    	HashMap<String, Object> clsMap = rsstClsService.retrievePrjClsDtl(input);

    	LOGGER.debug("######################################################clsMap################################## : " + clsMap);
    	if(clsMap != null) {
    		tssPgsList = rsstClsService.retrievePrjClsProgSearchInfo(input);
    		attcFilId = NullUtil.nvl(clsMap.get("attcFilId"),"");
    	}else{
    		tssPgsList = rsstClsService.retrieveTssPgsSearchInfo(input);
    	}
    	
    	input.put("attcFilId", attcFilId);
    	List<Map<String, Object>> clsAttachList = attachFileService.getAttachFileList(input);
    	
    	modelAndView.addObject("prjDataSet"        , RuiConverter.createDataset("prjDataSet", prjMap));
		modelAndView.addObject("mboDataSet"        , RuiConverter.createDataset("mboDataSet", mboList));
		modelAndView.addObject("tssPgsDataSet"        , RuiConverter.createDataset("tssPgsDataSet", tssPgsList));
//		modelAndView.addObject("pduDataSet"        , RuiConverter.createDataset("pduDataSet", pduList));
//		modelAndView.addObject("ptoprptDataSet"    , RuiConverter.createDataset("ptoprptDataSet", ptoprptList));
		modelAndView.addObject("clsDataSet"        , RuiConverter.createDataset("clsDataSet", StringUtil.toUtf8Output(clsMap)));
		modelAndView.addObject("clsAttachDataSet"  , RuiConverter.createDataset("clsAttachDataSet", clsAttachList));

		return  modelAndView;
	}

	/**
	 *  프로젝트 월마감 단건 입력&업데이트
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/prj/rsst/insertPrjRsstCls.do")
	public ModelAndView insertPrjRsstCls(
			@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
		LOGGER.debug("################################################################");
		LOGGER.debug("RsstClsController - insertPrjRsstCls [월마감 단건 입력&업데이트]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("################################################################");

		input = StringUtil.toUtf8Input(input);
		
		checkSessionObjRUI(input, session, model);
		ModelAndView modelAndView = new ModelAndView("ruiView");
	    model.addAttribute("inputData", input);
	    
	    List<Map<String, Object>> dataSetList;		//변경된 저장데이터 리스트
	    
	    String rtnMsg = "";
		try {
			dataSetList = RuiConverter.convertToDataSet(request,"tssPgsDataSet");
			
			rsstClsService.insertPrjRsstCls(dataSetList, input);
			rtnMsg = messageSourceAccessor.getMessage("msg.alert.saved");
		} catch (Exception e) {
    		rtnMsg = messageSourceAccessor.getMessage("msg.alert.error");
		}
        input.put("rtnMsg", rtnMsg);
        modelAndView.addObject("dataset", RuiConverter.createDataset("dataset", input));

        LOGGER.debug("###########################################################");
		LOGGER.debug("RESULT inputData => " + input);
		LOGGER.debug("###########################################################");

		return modelAndView;
	}

}
