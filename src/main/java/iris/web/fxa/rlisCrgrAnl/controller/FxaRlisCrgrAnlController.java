package iris.web.fxa.rlisCrgrAnl.controller;

import java.util.ArrayList;
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
import iris.web.fxa.rlisCrgrAnl.service.FxaRlisCrgrAnlService;
import iris.web.system.base.IrisBaseController;

@Controller
public class FxaRlisCrgrAnlController extends IrisBaseController {

	@Resource(name="messageSourceAccessor")
	private MessageSourceAccessor messageSourceAccessor;

	@Resource(name = "fxaRlisCrgrAnlService")
	private FxaRlisCrgrAnlService fxaRlisCrgrAnlService;

	static final Logger LOGGER = LogManager.getLogger(FxaRlisCrgrAnlController.class);

	/**
	 * 자산담당자 목록 화면
	 * @param input
	 * @return
	 */
	@RequestMapping(value="/fxa/rlisCrgrAnl/retrieveFxaRlisCrgrAnlList.do")
	public String retrieveFxaRlisCrgrAnlList(@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){

		/* 반드시 공통 호출 후 작업 */
		HashMap lsession = (HashMap)session.getAttribute("irisSession");
		LOGGER.debug("session="+lsession);
		LOGGER.debug("#################################input#################################################### + " + input);

		model.addAttribute("inputData", input);

		return  "web/fxa/rlisCrgrAnl/fxarlisCrgrAnlList";
	}

	/**
	 * 자산담당자 목록 조회
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/fxa/rlisCrgrAnl/retrieveFxaRlisCrgrAnlSearchList.do")
	public ModelAndView retrieveFxaRlisCrgrAnlSearchList(@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){

		HashMap lsession = (HashMap)session.getAttribute("irisSession");

		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		ModelAndView modelAndView = new ModelAndView("ruiView");
		input = StringUtil.toUtf8(input);

		if(NullUtil.isNull(input.get("_userId")) ||  NullUtil.nvl(input.get("_userId"), "").equals("-1")  ){
			String rtnMsg = messageSourceAccessor.getMessage("msg.alert.sessionTimeout");
			SayMessage.setMessage(rtnMsg);
			modelAndView.addObject("dataset", null);
        } else {

        	List<Map<String, Object>> resultList = fxaRlisCrgrAnlService.retrieveFxaRlisCrgrAnlSearchList(input);
			modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", resultList));
        }
		return  modelAndView;
	}



	/**
	 * 자산담당자 저장
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/fxa/rlisCrgrAnl/saveFxaRlisCrgrAnlInfo.do")
	public ModelAndView saveFxaRlisCrgrAnlInfo(@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){

		HashMap lsession = (HashMap)session.getAttribute("irisSession");

		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		ModelAndView modelAndView = new ModelAndView("ruiView");
		HashMap<String, Object> rtnMeaasge = new HashMap<String, Object>();

		//변경된 dataset 건수 추출
		List<Map<String, Object>> updateDataSetList= null;

		List<Map<String,Object>> crgrList = new ArrayList<Map<String,Object>>();	//담당자정보 리스트
		Map<String,Object> crgrMap = new HashMap<String, Object>();				//담당자 map

		List<Map<String,Object>> rfpList = new ArrayList<Map<String,Object>>();	//통보자정보 리스트
		Map<String,Object> rfpMap = new HashMap<String, Object>();				//통보자 map
		String rfpId = "";

		String rtnMsg = "";
		String rtnSt = "F";
		try{
			updateDataSetList = RuiConverter.convertToDataSet(request,"dataSet");

			LOGGER.debug("#################################input#################################################### + " + input);
			if(  updateDataSetList.size() != 0  ){
				for(int i=0; i < updateDataSetList.size(); i++){

					crgrMap = updateDataSetList.get(i);
					crgrMap.put("wbsCd", crgrMap.get("wbsCd"));
					crgrMap.put("deptCd", crgrMap.get("deptCd"));
					crgrMap.put("crgrId", crgrMap.get("crgrId"));
					crgrMap.put("_userId", String.valueOf(input.get("_userId")));

					String rfpArry[] = String.valueOf(crgrMap.get("rfpId")).split(",");

					for(int j = 0; j < rfpArry.length; j++){
						rfpId = rfpArry[j];
						rfpMap = new HashMap<String, Object>();
						rfpMap.put("wbsCd", crgrMap.get("wbsCd"));
						rfpMap.put("deptCd", crgrMap.get("deptCd"));
						rfpMap.put("rfpId", rfpId.toString().trim());
						rfpMap.put("_userId", String.valueOf(input.get("_userId")));
						rfpList.add(rfpMap);
					}

					crgrList.add(crgrMap);
				}
				//담당자 저장
				fxaRlisCrgrAnlService.insertCrgrInfo(crgrList, rfpList);

				rtnSt = "S";
				rtnMsg = "저장되었습니다.";
			}else{
				rtnMsg = "변경된 데이터가 없습니다..";
			}

		}catch(Exception e){
			e.printStackTrace();
			rtnMsg = "처리중 오류가발생하였습니다. 관리자에게 문의해주십시오.";
		}

		rtnMeaasge.put("rtnMsg", rtnMsg);
		rtnMeaasge.put("rtnSt", rtnSt);
		modelAndView.addObject("resultDataSet", RuiConverter.createDataset("resultDataSet", rtnMeaasge));

		return  modelAndView;
	}
}
