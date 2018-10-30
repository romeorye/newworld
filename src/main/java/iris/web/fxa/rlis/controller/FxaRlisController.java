package iris.web.fxa.rlis.controller;

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
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import devonframe.util.NullUtil;
import iris.web.common.converter.RuiConverter;
import iris.web.common.util.StringUtil;
import iris.web.fxa.rlis.service.FxaRlisService;
import iris.web.system.base.IrisBaseController;


@Controller
public class FxaRlisController  extends IrisBaseController {
	@Resource(name="messageSourceAccessor")
	private MessageSourceAccessor messageSourceAccessor;

	@Resource(name = "fxaRlisService")
	private FxaRlisService fxaRlisService;

	static final Logger LOGGER = LogManager.getLogger(FxaRlisController.class);

	/**
	 * 자산실사 목록 화면
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/fxa/rlis/retrieveFxaRlisList.do")
	public String retrieveFxaAnlList(@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){

		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		input = StringUtil.toUtf8(input);
		LOGGER.debug("####################input################################################################# : " + input);

		model.addAttribute("inputData", input);

		return  "web/fxa/rlis/fxaInfoRlisList";
	}

	/**
	 * 자산실사> 실사명 combo리스트 조회
	 * @param input
	 * @param request
	 * @param response
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/fxa/rlis/retrieveFxaRlisTitlCombo.do")
    public ModelAndView retrieveFxaRlisTitlCombo(
            @RequestParam HashMap<String, String> input,
            HttpServletRequest request,
            HttpServletResponse response,
            HttpSession session,
            ModelMap model
            ){

        ModelAndView modelAndView = new ModelAndView("ruiView");

        List codeList = fxaRlisService.retrieveFxaRlisTitlCombo(NullUtil.nvl(input.get("comCd"), ""));
        modelAndView.addObject("radioDataSet", RuiConverter.createDataset("codeList", codeList));

        return modelAndView;
    }

	/**
	 * 자산실사 목록 조회
	 * @param input
	 * @return
	 */
	@RequestMapping(value="/fxa/rlis/retrieveFxaRlisSearchList.do")
    public ModelAndView retrieveFxaRlisSearchList(@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){

		HashMap lsession = (HashMap)session.getAttribute("irisSession");

		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		ModelAndView modelAndView = new ModelAndView("ruiView");
		input = StringUtil.toUtf8(input);

		List<Map<String, Object>> resultList = fxaRlisService.retrieveFxaRlisSearchList(input);
		modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", resultList));

        return modelAndView;
    }

	/**
	 * 자산실사 결재상세 팝업 화면
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/fxa/rlis/retrieveFxaRlisApprPop.do")
	public String retrieveFxaRlisApprPop(@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){

		/* 반드시 공통 호출 후 작업 */
		HashMap lsession = (HashMap)session.getAttribute("irisSession");
		ModelAndView modelAndView = new ModelAndView("ruiView");
		model.addAttribute("inputData", input);

		return  "web/fxa/rlis/fxaRlisApprPop";
	}

	/**
	 * 자산실사 To_do View
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/fxa/rlis/retrieveFxaRlisTodoView.do")
	public String retrieveFxaRlisTodoView(@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){

		/* 반드시 공통 호출 후 작업 */
		HashMap lsession = (HashMap)session.getAttribute("irisSession");
		ModelAndView modelAndView = new ModelAndView("ruiView");
		model.addAttribute("inputData", input);

		return  "web/fxa/rlis/fxaInfoRlisTodoView";
	}

	/**
	 * 자산실사 To_do View
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/fxa/rlis/retrieveFxaRlisTodoViewList.do")
	public ModelAndView retrieveFxaRlisTodoViewList(@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){

		HashMap lsession = (HashMap)session.getAttribute("irisSession");

		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		ModelAndView modelAndView = new ModelAndView("ruiView");

		//LOGGER.debug("#################################input#################################################### + " + input);
		List<Map<String, Object>> resultList = fxaRlisService.retrieveFxaRlisTodoList(input);

		modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", resultList));

        return modelAndView;
	}


	/**
	 * 자산실사 To_do 화면
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/fxa/rlis/retrieveFxaRlisTodoList.do")
	public String retrieveFxaRlisTodoList(@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){

		/* 반드시 공통 호출 후 작업 */
		HashMap lsession = (HashMap)session.getAttribute("irisSession");
		ModelAndView modelAndView = new ModelAndView("ruiView");
		LOGGER.debug("##############################to_do ###input#################################################### + " + input);
		model.addAttribute("inputData", input);

		return  "web/fxa/rlis/fxaInfoRlisTodoList";
	}


	/**
	 * 자산실사 To_do 조회
	 * @param input
	 * @return
	 */
	@RequestMapping(value="/fxa/rlis/retrieveFxaRlisTodo.do")
    public ModelAndView retrieveFxaRlisTodo(@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){

		HashMap lsession = (HashMap)session.getAttribute("irisSession");

		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		ModelAndView modelAndView = new ModelAndView("ruiView");

		LOGGER.debug("#################################input#################################################### + " + input);
		List<Map<String, Object>> resultList = fxaRlisService.retrieveFxaRlisTodoList(input);

		modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", resultList));

        return modelAndView;
    }


	/**
	 * 자산실사 To_do 저장
	 * @param input
	 * @return
	 */
	@RequestMapping(value="/fxa/rlis/saveFxaRlisTodoInfo.do")
    public ModelAndView saveFxaRlisTodoInfo(@RequestParam HashMap<String, Object> input,
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
		Map<String,Object> todoMap = new HashMap<String, Object>();				//todo map
		List<Map<String,Object>> inputList = new ArrayList<Map<String,Object>>();

		String rtnMsg = "";
		String rtnSt = "F";
		try{
			updateDataSetList = RuiConverter.convertToDataSet(request,"dataSet");

			if( updateDataSetList.size() != 0  ){
				for(int i=0; i < updateDataSetList.size(); i++){
					todoMap = updateDataSetList.get(i);
					todoMap.put("_userId", String.valueOf(input.get("_userId")));

					inputList.add(todoMap);
				}
			}

			//To_do 저장
			fxaRlisService.saveFxaRlisTodoInfo(inputList);

			rtnSt = "S";
			rtnMsg = "저장되었습니다.";

		}catch(Exception e){
			e.printStackTrace();
			rtnMsg = "처리중 오류가 발생헀습니다. 관리자에게 문의해주십시오.";
		}

		rtnMeaasge.put("rtnMsg", rtnMsg);
		rtnMeaasge.put("rtnSt", rtnSt);
		modelAndView.addObject("resultDataSet", RuiConverter.createDataset("resultDataSet", rtnMeaasge));

        return modelAndView;
    }

	/**
	 * 자산실사 To_do 결재
	 * @param input
	 * @return
	 */
	@RequestMapping(value="/fxa/rlis/saveFxaRlisTodoApprInfo.do")
	public ModelAndView saveFxaRlisTodoApprInfo(@RequestParam HashMap<String, Object> input,
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
		Map<String,Object> todoMap = new HashMap<String, Object>();				//todo map
		List<Map<String,Object>> inputList = new ArrayList<Map<String,Object>>();

		String rtnMsg = "";
		String rtnSt = "F";
		try{
			updateDataSetList = RuiConverter.convertToDataSet(request,"dataSet");

			if( updateDataSetList.size() != 0  ){
				for(int i=0; i < updateDataSetList.size(); i++){
					todoMap = updateDataSetList.get(i);
					todoMap.put("_userId", String.valueOf(input.get("_userId")));

					inputList.add(todoMap);
				}
			}

			//To_do 저장
			fxaRlisService.saveFxaRlisTodoApprInfo(inputList, input);

			rtnSt = "S";
			rtnMsg = "결재되었습니다.";

		}catch(Exception e){
			e.printStackTrace();
			rtnMsg = "처리중 오류가 발생헀습니다. 관리자에게 문의해주십시오.";
		}

		rtnMeaasge.put("rtnMsg", rtnMsg);
		rtnMeaasge.put("rtnSt", rtnSt);
		modelAndView.addObject("resultDataSet", RuiConverter.createDataset("resultDataSet", rtnMeaasge));

		return modelAndView;
	}

}
