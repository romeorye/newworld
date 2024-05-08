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
import iris.web.prj.rsst.service.PrjPtotPrptInfoService;
import iris.web.system.base.IrisBaseController;

/********************************************************************************
 * NAME : PrjPtotPrptInfoController .java
 * DESC : 프로젝트 - 연구팀(Project) - 지적재산권(Ptot_Prpt) controller
 * PROJ : IRIS 구축 프로젝트
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION
 * ----------  ------  ---------------------------------------------------------
 * 2017.08.24  IRIS04	최초생성
 *********************************************************************************/

@Controller
public class PrjPtotPrptInfoController extends IrisBaseController {

	@Resource(name="messageSourceAccessor")
	private MessageSourceAccessor messageSourceAccessor;

	@Resource(name = "prjPtotPrptInfoService")
	private PrjPtotPrptInfoService prjPtotPrptInfoService;

	static final Logger LOGGER = LogManager.getLogger(PrjPtotPrptInfoController.class);

	/** 지적재산권 탭 화면이동 **/
	@RequestMapping(value="/prj/rsst/ptotprpt/retrievePrjPtotPrptInfo.do")
	public String retrievePrjRsstMboInfoView(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){

		LOGGER.debug("########################################################################################");
		LOGGER.debug("PrjPtotPrptInfoController - retrievePrjRsstMboInfoView [프로젝트 등록 > MBO 탭 화면이동]");
		LOGGER.debug("########################################################################################");

		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);
		if(NullUtil.isNull(input.get("_userId")) ||  NullUtil.nvl(input.get("_userId"), "").equals("-1")  ){
			String rtnMsg = messageSourceAccessor.getMessage("msg.alert.sessionTimeout");
			SayMessage.setMessage(rtnMsg);
        } else {
	        model.addAttribute("inputData", input);
        }

		return "web/prj/rsst/prjPtotPrptList";
	}

	/** 지적재산권 목록 조회 **/
	@RequestMapping(value="/prj/rsst/ptotprpt/retrievePrjPtotPrptSearchInfo.do")
	public ModelAndView retrievePrjPtotPrptSearchInfo(
			@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpServletResponse response,
			HttpSession session,
			ModelMap model
			){

		LOGGER.debug("##############################################################################################");
		LOGGER.debug("PrjPtotPrptInfoController - retrievePrjRsstMboSearchInfo [프로젝트 등록 > 지적재산권 목록 조회]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("##############################################################################################");

		/*반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		ModelAndView modelAndView = new ModelAndView("ruiView");
		if(NullUtil.isNull(input.get("_userId")) ||  NullUtil.nvl(input.get("_userId"), "").equals("-1")  ){
			String rtnMsg = messageSourceAccessor.getMessage("msg.alert.sessionTimeout");
			SayMessage.setMessage(rtnMsg);
			modelAndView.addObject("dataset", null);
        } else {

	        List<Map<String,Object>> list = prjPtotPrptInfoService.retrievePrjPtotPrptSearchInfo(input);

	        List<Map<String,Object>> erpPrptInfoList = prjPtotPrptInfoService.retrievePrjErpPrptInfo(input);

			modelAndView.addObject("dataSet04", RuiConverter.createDataset("dataSet04", list));
			modelAndView.addObject("erpDataSet", RuiConverter.createDataset("erpDataSet", erpPrptInfoList));
        }

		LOGGER.debug("###########################################################");
		//LOGGER.debug("loginUser => " + model.get("loginUser"));
		LOGGER.debug("inputData => " + input);
		LOGGER.debug("###########################################################");

		return modelAndView;
	}

	/** 지적재산권 삭제 **/
	@RequestMapping(value="/prj/rsst/ptotprpt/deletePrjPtotPrptInfo.do")
	public ModelAndView deletePrjPtotPrptInfo(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
		LOGGER.debug("#################################################################################################");
		LOGGER.debug("PrjPtotPrptInfoController - deletePrjPtotPrptInfo [프로젝트 등록 > 지적재산권 리스트 삭제]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("#################################################################################################");

		checkSessionRUI(input, session, model);
		ModelAndView modelAndView = new ModelAndView("ruiView");
		HashMap<String, Object> rtnMeaasge = new HashMap<String, Object>();

		// 결과메시지
		rtnMeaasge.put("rtnSt", "S");
		rtnMeaasge.put("rtnMsg", "삭제 되었습니다.");

		int totCnt = 0;    							//전체건수
		List<Map<String, Object>> dataSet04List;	//지적재산권 변경데이터
		try
		{
			dataSet04List = RuiConverter.convertToDataSet(request,"dataSet04");
			for(Map<String,Object> dataSet04Map : dataSet04List) {

				if( "1".equals(NullUtil.nvl(dataSet04Map.get("chk"), ""))) {
					dataSet04Map.put("_userId" , NullUtil.nvl(input.get("_userId"), ""));
					prjPtotPrptInfoService.deletePrjPtotPrptInfo(dataSet04Map);
					totCnt++;
				}
			}

			LOGGER.debug("dataSet04List="+dataSet04List);

			if(totCnt == 0 ) {
				rtnMeaasge.put("rtnSt", "F");
				rtnMeaasge.put("rtnMsg", "변경된 내용이 없습니다.");
			}
		} catch (Exception e) {
			e.printStackTrace();
			rtnMeaasge.put("rtnSt", "F");
			rtnMeaasge.put("rtnMsg", "삭제가 실패하였습니다.");
		}

		modelAndView.addObject("trResultDataSet", RuiConverter.createDataset("trResultDataSet", rtnMeaasge));
		return modelAndView;
	}

	/** 지적재산권 리스트 입력&업데이트 **/
	@RequestMapping(value="/prj/rsst/ptotprpt/insertPrjPtotPrptInfo.do")
	public ModelAndView insertPrjPtotPrptInfo(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
		LOGGER.debug("#######################################################################################################");
		LOGGER.debug("PrjPtotPrptInfoController - insertPrjPtotPrptInfo [프로젝트 등록 > 지적재산권 리스트 저장]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("#######################################################################################################");

		checkSessionRUI(input, session, model);
		ModelAndView modelAndView = new ModelAndView("ruiView");
		HashMap<String, Object> rtnMeaasge = new HashMap<String, Object>();

		// 결과메시지
		rtnMeaasge.put("rtnSt", "S");
		rtnMeaasge.put("rtnMsg", "저장 되었습니다.");

		int totCnt = 0;    							//전체건수
		List<Map<String, Object>> dataSet04List;	//지적재산권 변경데이터

		try
		{
			dataSet04List = RuiConverter.convertToDataSet(request,"dataSet04");
			for(Map<String,Object> dataSet04Map : dataSet04List) {

				if( "1".equals(NullUtil.nvl(dataSet04Map.get("chk"), ""))) {

					dataSet04Map.put("_userId" , NullUtil.nvl(input.get("_userId"), ""));
					prjPtotPrptInfoService.insertPrjPtotPrptInfo(dataSet04Map);
					totCnt++;
				}
			}

			LOGGER.debug("dataSet04List="+dataSet04List);

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



	/* 한꺼번에 저장,수정,삭제하는 예시
List<Map<String, Object>> inputList = RuiConverter.convertToDataSet(request, "tGridDataSet");

            	for(int i=0 ; i<inputList.size() ; i++){
            		inputParam = (HashMap<String, Object>) inputList.get(i);
            		inputParam.put("_userId"       ,input.get("_userId"    )+"");

//                    // state : 시공팀원 관리 상태코드가 I일 경우 생성 ( U일경우 수정)
                    if(inputParam.get(RuiConstants.METADATA_RECORD_STATE).equals(RuiConstants.ROW_STATE_INSERT)){
                    	if(inputParam.get("chk").equals("1")){
                        	tmpData=nwinsCnstwNetworkService.cnstwTeamSeq(inputParam);
	                    	teamSeq =  Integer.parseInt(String.valueOf(tmpData.get("SEQ")))+teamIns;
	                    	inputParam.put("cnstwTeamCd",  teamSeq);
	                    	inputListIns.add(inputParam);
	                    	teamIns++;
                    	}
                    }else if(inputParam.get(RuiConstants.METADATA_RECORD_STATE).equals(RuiConstants.ROW_STATE_UPDATE)){
                    	if(inputParam.get("chk").equals("1")){
                    		inputListUpt.add(inputParam);
                    	}
                    }else if(inputParam.get(RuiConstants.METADATA_RECORD_STATE).equals(RuiConstants.ROW_STATE_DELETE)){
                    	inputListDel.add(inputParam);
                    }
                }
                nwinsCnstwNetworkService.cnstwTeamReg(inputListIns);
                nwinsCnstwNetworkService.cnstwTeamHoliReg(inputListIns);
                nwinsCnstwNetworkService.cnstwTeamUpdate(inputListUpt);
                nwinsCnstwNetworkService.cnstwTeamDelete(inputListDel);
	 * */

}// end class
