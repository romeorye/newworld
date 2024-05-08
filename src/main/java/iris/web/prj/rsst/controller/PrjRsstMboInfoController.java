package iris.web.prj.rsst.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
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
import iris.web.prj.rsst.service.PrjRsstMboInfoService;
import iris.web.system.attach.service.AttachFileService;
import iris.web.system.base.IrisBaseController;

/********************************************************************************
 * NAME : PrjRsstMboInfoController.java
 * DESC : 프로젝트 - 연구팀(Project) - MBO(특성지표) controller
 * PROJ : IRIS 구축 프로젝트
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION
 * ----------  ------  ---------------------------------------------------------
 * 2017.08.21  IRIS04	최초생성
 *********************************************************************************/

@Controller
public class PrjRsstMboInfoController  extends IrisBaseController {

	@Resource(name="messageSourceAccessor")
	private MessageSourceAccessor messageSourceAccessor;

	@Resource(name = "prjRsstMboInfoService")
	private PrjRsstMboInfoService prjRsstMboInfoService;

	@Resource(name = "attachFileService")
	private AttachFileService attachFileService;			// 첨부파일서비스

	static final Logger LOGGER = LogManager.getLogger(PrjRsstMboInfoController.class);


	/** MBO 탭 화면이동 **/
	@RequestMapping(value="/prj/rsst/mbo/retrievePrjRsstMboInfo.do")
	public String retrievePrjRsstMboInfoView(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){

		LOGGER.debug("#####################################################################################");
		LOGGER.debug("PrjRsstMboInfoController - retrievePrjRsstMboInfoView [프로젝트 등록 > MBO 탭 화면이동]");
		LOGGER.debug("#####################################################################################");

		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);
		if(NullUtil.isNull(input.get("_userId")) ||  NullUtil.nvl(input.get("_userId"), "").equals("-1")  ){
			String rtnMsg = messageSourceAccessor.getMessage("msg.alert.sessionTimeout");
			SayMessage.setMessage(rtnMsg);
        } else {
	        model.addAttribute("inputData", input);
        }

		LOGGER.debug("###########################################################");
		LOGGER.debug("loginUser => " + model.get("loginUser"));
		LOGGER.debug("inputData => " + input);
		LOGGER.debug("###########################################################");

		return "web/prj/rsst/prjRsstMboDtl";
	}

	/** MBO 목록 조회 **/
	@RequestMapping(value="/prj/rsst/mbo/retrievePrjRsstMboSearchInfo.do")
	public ModelAndView retrievePrjRsstMboSearchInfo(
			@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpServletResponse response,
			HttpSession session,
			ModelMap model
			){

		LOGGER.debug("#####################################################################################");
		LOGGER.debug("PrjRsstMboInfoController - retrievePrjRsstMboSearchInfo [프로젝트 등록 > Mbo 조회]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("#####################################################################################");

		/*반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		ModelAndView modelAndView = new ModelAndView("ruiView");
		if(NullUtil.isNull(input.get("_userId")) ||  NullUtil.nvl(input.get("_userId"), "").equals("-1")  ){
			String rtnMsg = messageSourceAccessor.getMessage("msg.alert.sessionTimeout");
			SayMessage.setMessage(rtnMsg);
			modelAndView.addObject("dataset", null);
        } else {

	        List<Map<String,Object>> list = prjRsstMboInfoService.retrievePrjRsstMboSearchInfo(input);
			modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", list));
        }

		LOGGER.debug("###########################################################");
		LOGGER.debug("loginUser => " + model.get("loginUser"));
		LOGGER.debug("inputData => " + input);
		LOGGER.debug("###########################################################");

		return modelAndView;
	}

	/** MBO 삭제 **/
	@RequestMapping(value="/prj/rsst/mbo/deletePrjRsstMboInfo.do")
	public ModelAndView deletePrjRsstMboInfo(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
		LOGGER.debug("###########################################################");
		LOGGER.debug("PrjRsstMboInfoController - deletePrjRsstPduInfo [프로젝트 MBO 삭제]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		checkSessionRUI(input, session, model);
		ModelAndView modelAndView = new ModelAndView("ruiView");
		HashMap<String, Object> rtnMeaasge = new HashMap<String, Object>();

		// 결과메시지
		rtnMeaasge.put("rtnSt", "S");
		rtnMeaasge.put("rtnMsg", "삭제 되었습니다.");

		int totCnt = 0;    							//전체건수
		List<Map<String, Object>> dataSet03List;	//프로젝트 Mbo 변경데이터

		try {
				dataSet03List = RuiConverter.convertToDataSet(request,"dataSet03");
				for(Map<String,Object> dataSet03Map : dataSet03List) {

					if( "1".equals(NullUtil.nvl(dataSet03Map.get("chk"), ""))) {
						dataSet03Map.put("_userId" , NullUtil.nvl(input.get("_userId"), ""));
						prjRsstMboInfoService.deletePrjRsstMboInfo(dataSet03Map);
						totCnt++;
					}
				}

				LOGGER.debug("dataSet03List="+dataSet03List);

				if(totCnt == 0 ) {
					rtnMeaasge.put("rtnSt", "F");
					rtnMeaasge.put("rtnMsg", "변경된 내용이 없습니다.");
				}
		} catch (Exception e) {
			e.printStackTrace();
			rtnMeaasge.put("rtnSt", "F");
			rtnMeaasge.put("rtnMsg", "삭제가 실패하였습니다.");
		}

		modelAndView.addObject("resultDataSet", RuiConverter.createDataset("resultDataSet", rtnMeaasge));
		return modelAndView;
	}
	
	/** MBO 등록 / 업데이트 **/
	@RequestMapping(value="/prj/rsst/mbo/savePrjRsstMboInfo.do")
	public ModelAndView savePrjRsstMboInfo(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
		
		checkSessionRUI(input, session, model);
		
		LOGGER.debug("##########################################################################");
		LOGGER.debug("PrjRsstMboInfoController - savePrjRsstMboInfo [프로젝트 MBO 등록/업데이트]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("##########################################################################");

		
		ModelAndView modelAndView = new ModelAndView("ruiView");
		HashMap<String, Object> rtnMeaasge = new HashMap<String, Object>();

		// 결과메시지
		rtnMeaasge.put("rtnSt", "S");
		rtnMeaasge.put("rtnMsg", "저장 되었습니다.");

		int totCnt = 0;    							//전체건수
		List<Map<String, Object>> dataSet03List;	//프로젝트 Mbo 변경데이터

		try {
				dataSet03List = RuiConverter.convertToDataSet(request,"dataSet03");
				for(Map<String,Object> dataSet03Map : dataSet03List) {

					if( "1".equals(NullUtil.nvl(dataSet03Map.get("chk"), ""))) {
						dataSet03Map.put("_userId" , NullUtil.nvl(input.get("_userId"), ""));
						prjRsstMboInfoService.savePrjRsstMboInfo(dataSet03Map);
						totCnt++;
					}
				}

				if(totCnt == 0 ) {
					rtnMeaasge.put("rtnSt", "F");
					rtnMeaasge.put("rtnMsg", "변경된 내용이 없습니다.");
				}
		} catch (Exception e) {
			e.printStackTrace();
			rtnMeaasge.put("rtnSt", "F");
			rtnMeaasge.put("rtnMsg", "저장이 실패하였습니다.");
		}

		modelAndView.addObject("resultDataSet", RuiConverter.createDataset("resultDataSet", rtnMeaasge));
		return modelAndView;
	}

	/** MBO 목표등록 팝업 **/
	@RequestMapping(value="/prj/rsst/mbo/openPrjRsstMboDtlPlnPopup.do")
	public String openPrjRsstMboDtlPlnPopupView(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){

		LOGGER.debug("#####################################################################################");
		LOGGER.debug("PrjRsstMboInfoController - openPrjRsstMboDtlPlnPopupView [프로젝트 등록 > MBO 목표등록 팝업이동]");
		LOGGER.debug("#####################################################################################");

		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);
		if(NullUtil.isNull(input.get("_userId")) ||  NullUtil.nvl(input.get("_userId"), "").equals("-1")  ){
			String rtnMsg = messageSourceAccessor.getMessage("msg.alert.sessionTimeout");
			SayMessage.setMessage(rtnMsg);
        } else {
	        model.addAttribute("inputData", input);
        }

		LOGGER.debug("###########################################################");
		LOGGER.debug("loginUser => " + model.get("loginUser"));
		LOGGER.debug("inputData => " + input);
		LOGGER.debug("###########################################################");

		return "web/prj/rsst/prjRsstMboDtlPlnPopup";
	}

	/** MBO 목표등록 팝업 **/
	@RequestMapping(value="/prj/rsst/mbo/openPrjRsstMboDtlArslPopup.do")
	public String openPrjRsstMboDtlArslPopupView(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){

		LOGGER.debug("#####################################################################################");
		LOGGER.debug("PrjRsstMboInfoController - openPrjRsstMboDtlArslPopupView [프로젝트 등록 > MBO 실적등록 팝업이동]");
		LOGGER.debug("#####################################################################################");

		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);
		if(NullUtil.isNull(input.get("_userId")) ||  NullUtil.nvl(input.get("_userId"), "").equals("-1")  ){
			String rtnMsg = messageSourceAccessor.getMessage("msg.alert.sessionTimeout");
			SayMessage.setMessage(rtnMsg);
        } else {
	        model.addAttribute("inputData", input);
        }

		LOGGER.debug("###########################################################");
		LOGGER.debug("loginUser => " + model.get("loginUser"));
		LOGGER.debug("inputData => " + input);
		LOGGER.debug("###########################################################");

		return "web/prj/rsst/prjRsstMboDtlArslPopup";
	}

	/** MBO 단건 조회 **/
	@RequestMapping(value="/prj/rsst/mbo/retrievePrjRsstMboSearchDtlInfo.do")
	public ModelAndView retrievePrjRsstMboSearchDtlInfo(
			@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpServletResponse response,
			HttpSession session,
			ModelMap model
			){

		LOGGER.debug("#####################################################################################");
		LOGGER.debug("PrjRsstMboInfoController - retrievePrjRsstMboSearchInfo [프로젝트 등록 > Mbo 단건 조회]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("#####################################################################################");

		/*반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		ModelAndView modelAndView = new ModelAndView("ruiView");
		String filId = "";
		List<Map<String, Object>> mboAttachList = null;

		if(NullUtil.isNull(input.get("_userId")) ||  NullUtil.nvl(input.get("_userId"), "").equals("-1")  ){
			String rtnMsg = messageSourceAccessor.getMessage("msg.alert.sessionTimeout");
			SayMessage.setMessage(rtnMsg);
			modelAndView.addObject("dataset", null);
        } else {

	        Map<String,Object> resultMap = prjRsstMboInfoService.retrievePrjRsstMboSearchDtlInfo(input);
	        // 첨부파일 조회
	        if(resultMap != null) {
	        	filId = NullUtil.nvl(resultMap.get("filId"),"");
	        	if( !"".equals(filId) ){
	        		input.put("attcFilId", filId);
	    	    	mboAttachList = attachFileService.getAttachFileList(input);
	    	    	modelAndView.addObject("mboAttachDataSet"  , RuiConverter.createDataset("mboAttachDataSet", mboAttachList));
	        	}
	    	}
			modelAndView.addObject("popupDataSet0302", RuiConverter.createDataset("popupDataSet0302", resultMap));

        }

		LOGGER.debug("###########################################################");
		LOGGER.debug("loginUser => " + model.get("loginUser"));
		LOGGER.debug("inputData => " + input);
		LOGGER.debug("###########################################################");

		return modelAndView;
	}

	/** MBO 단건 입력&업데이트 **/
	@RequestMapping(value="/prj/rsst/mbo/insertPrjRsstMboInfo.do")
	public ModelAndView insertPrjRsstMboInfo(
			@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
		checkSessionObjRUI(input, session, model);
		
		LOGGER.debug("########################################################################");
		LOGGER.debug("PrjRsstMboInfoController - insertPrjRsstMboInfo [MBO 단건 입력&업데이트]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("#########################################################################");

		ModelAndView modelAndView = new ModelAndView("ruiView");
	    model.addAttribute("inputData", input);
	    String rtnMsg = "";
	    
	    List<Map<String, Object>> dataSet03List;	//프로젝트 Mbo 변경데이터
	    Map<String,Object> dataSet03Map;

		try {
			dataSet03List = RuiConverter.convertToDataSet(request,"popupDataSet0302");
			if(dataSet03List != null && dataSet03List.size() > 0) {
				dataSet03Map = dataSet03List.get(0);
				dataSet03Map.put("_userId" , NullUtil.nvl(input.get("_userId"), ""));
				
				// 저장시 실적년월 중복체크
				String seq = NullUtil.nvl(dataSet03Map.get("seq"), "");
				if("".equals(seq)) {
				    String mboDupYn = prjRsstMboInfoService.getMboDupYn(dataSet03Map);
				    if("Y".equals(mboDupYn)) {
				    	input.put("rtnYn", "N");
				    	input.put("rtnMsg", "이미 목표에 실적년월이 등록되어 있습니다.");
				        modelAndView.addObject("dataset", RuiConverter.createDataset("dataset", input));
				        return modelAndView;
				    }
				}
				
				prjRsstMboInfoService.insertPrjRsstMboInfo(dataSet03Map);
				rtnMsg = messageSourceAccessor.getMessage("msg.alert.saved");
				input.put("rtnYn", "Y");
			}
		} catch (Exception e) {
			input.put("rtnYn", "N");
    		rtnMsg = messageSourceAccessor.getMessage("msg.alert.error");
		}
        input.put("rtnMsg", rtnMsg);
        modelAndView.addObject("dataset", RuiConverter.createDataset("dataset", input));

        LOGGER.debug("###########################################################");
		LOGGER.debug("loginUser => " + model.get("loginUser"));
		LOGGER.debug("inputData => " + input);
		LOGGER.debug("###########################################################");

		return modelAndView;
	}
	
	/** MBO 단건삭제(실적삭제) **/
	@RequestMapping(value="/prj/rsst/mbo/deletePrjRsstMboArslInfo.do")
	public ModelAndView deletePrjRsstMboArslInfo(
			@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
		checkSessionObjRUI(input, session, model);
		
		LOGGER.debug("############################################################################");
		LOGGER.debug("PrjRsstMboInfoController - deletePrjRsstMboArslInfo [MBO 단건삭제(실적삭제)]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("############################################################################");

		ModelAndView modelAndView = new ModelAndView("ruiView");
	    model.addAttribute("inputData", input);
	    String rtnMsg = "";
	    
	    List<Map<String, Object>> dataSet03List;	//프로젝트 Mbo 변경데이터
	    Map<String,Object> dataSet03Map;

		try {
			dataSet03List = RuiConverter.convertToDataSet(request,"popupDataSet0302");
			
			LOGGER.debug("dataSet03List = > " + dataSet03List);
			
			if(dataSet03List != null && dataSet03List.size() > 0) {
				dataSet03Map = dataSet03List.get(0);
				dataSet03Map.put("_userId" , NullUtil.nvl(input.get("_userId"), ""));
				
				// 삭제시 목표(년도+목표번호)개수 체크 1건이상이면 삭제, 미만이면 업데이트
				int mboGoalCnt = prjRsstMboInfoService.getMboGoalCnt(dataSet03Map);
				// 삭제
				if( mboGoalCnt > 1 ) {
					prjRsstMboInfoService.deletePrjRsstMboInfo(dataSet03Map);
					
					rtnMsg = "삭제 되었습니다.";
					input.put("rtnYn", "Y");
				}
				// 수정(실적년월,현황,첨부파일 빈값처리 후)
				else if(mboGoalCnt == 1) {
					dataSet03Map.put("arlsYearMon","");		//실적년월
					dataSet03Map.put("arlsStts","");		//실적현황
					dataSet03Map.put("filId","");			//첨부파일
					prjRsstMboInfoService.updatePrjRsstMboArlsInfo(dataSet03Map);
					
					rtnMsg = "삭제 되었습니다.";
					input.put("rtnYn", "Y");
				}

				rtnMsg = "삭제 되었습니다.";
				input.put("rtnYn", "Y");
			}
		} catch (Exception e) {
			input.put("rtnYn", "N");
    		rtnMsg = messageSourceAccessor.getMessage("msg.alert.error");
		}
        input.put("rtnMsg", rtnMsg);
        modelAndView.addObject("dataset", RuiConverter.createDataset("dataset", input));

        LOGGER.debug("###########################################################");
		LOGGER.debug("loginUser => " + model.get("loginUser"));
		LOGGER.debug("inputData => " + input);
		LOGGER.debug("###########################################################");

		return modelAndView;
	}

}// end class
