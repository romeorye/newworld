package iris.web.mchn.mgmt.controller;

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

import iris.web.common.converter.RuiConverter;
import iris.web.common.util.StringUtil;
import iris.web.mchn.mgmt.service.MchnCgdgService;
import iris.web.system.base.IrisBaseController;

@Controller
public class MchnCgdgController extends IrisBaseController {

	@Resource(name="messageSourceAccessor")
	private MessageSourceAccessor messageSourceAccessor;

	@Resource(name="mchnCgdgService")
	private MchnCgdgService mchnCgdgService;

	static final Logger LOGGER = LogManager.getLogger(MchnCgdgController.class);


	/**
	 * 분석기기 > 관리 > 소모품 관리 리스트 화면으로 으로
	 */
	@RequestMapping(value="/mchn/mgmt/retrieveMchnCgdgList.do")
	public String mchnMgmtList(@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){

		LOGGER.debug("############################################################################### : "+ input);
		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		input = StringUtil.toUtf8(input);

		model.addAttribute("inputData", input);

		return  "web/mchn/mgmt/cgdsAnl/cgdsAnlList";
	}

	/**
	 *  분석기기 > 관리 > 소모품 관리 조회
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/mchn/mgmt/retrieveCdgsList.do")
	public ModelAndView retrieveCdgsList(@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		ModelAndView modelAndView = new ModelAndView("ruiView");

		input = StringUtil.toUtf8(input);

        List<Map<String, Object>> resultList = mchnCgdgService.retrieveCdgsList(input);
		modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", resultList));

		return  modelAndView;
	}

	/**
	 *  소모품 신규 및 상세 조회
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/mchn/mgmt/retrieveCgdgAnlDtl.do")
	public String retrieveCgdgAnlDtl(@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		model.addAttribute("inputData", input);

        return  "web/mchn/mgmt/cgdsAnl/cgdsAnlReg";
	}

	/**
	 *  소모품 신규 및 상세 조회
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/mchn/mgmt/retrieveCdgsMst.do")
	public ModelAndView retrieveCdgsMst(@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		ModelAndView modelAndView = new ModelAndView("ruiView");

        HashMap<String, Object> result = mchnCgdgService.retrieveCdgsMst(input);

        modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", result));
        return  modelAndView;
	}

	/**
	 *  소모품 정보 저장 및 수정
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/mchn/mgmt/saveCgdsMst.do")
	public ModelAndView saveCgdsAnlInfo(@RequestParam HashMap<String, Object> input, HttpServletRequest request, HttpSession session, ModelMap model) {
		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		ModelAndView modelAndView = new ModelAndView("ruiView");
		HashMap<String, Object> rtnMeaasge = new HashMap<String, Object>();

		String rtnMsg = "";
		String rtnSt = "F";
		try {
			mchnCgdgService.saveCgdsMst(input);
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
	 *  소모품 정보 삭제
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/mchn/mgmt/updateCgdsMst.do")
	public ModelAndView updateCgdsMst(@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		ModelAndView modelAndView = new ModelAndView("ruiView");
		HashMap<String, Object> rtnMeaasge = new HashMap<String, Object>();

		String rtnMsg = "";
		String rtnSt = "F";
        try{
        	mchnCgdgService.updateCgdsMst(input);

        	rtnMsg = "삭제되었습니다.";
        	rtnSt = "S";
        }catch(Exception e){
        	e.printStackTrace();
        	rtnMsg = "처리중 오류가발생했습니다. 담당자에게 문의해주세요";
        }

        rtnMeaasge.put("rtnMsg", rtnMsg);
		rtnMeaasge.put("rtnSt", rtnSt);
		modelAndView.addObject("resultDataSet", RuiConverter.createDataset("resultDataSet", rtnMeaasge));

        return  modelAndView;
	}

	/**
	 * 분석기기 > 관리 > 소모품 관리 > 관리 > 소모품 입출력 리스트 화면
	 */
	@RequestMapping(value="/mchn/mgmt/retrieveCgdsMgmtList.do")
	public String retrieveCgdsMgmtList(@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){

		/* 반드시 공통 호출 후 작업 */
		HashMap lsession = (HashMap)session.getAttribute("irisSession");
		ModelAndView modelAndView = new ModelAndView("ruiView");

		model.addAttribute("inputData", input);

		return  "web/mchn/mgmt/cgdsAnl/cgdsMgmtList";
	}

	/**
	 *  분석기기 > 관리 > 소모품 관리 > 관리 > 소모품 입출력 조회
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/mchn/mgmt/retrieveCdgsMgmtInfo.do")
	public ModelAndView retrieveCdgsMgmtInfo(@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		ModelAndView modelAndView = new ModelAndView("ruiView");

		HashMap<String, Object> result = mchnCgdgService.retrieveCdgsMst(input);
       	List<Map<String, Object>> resultList = mchnCgdgService.retrieveCdgsMgmt(input);

       	modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", result));
       	modelAndView.addObject("dataSetList", RuiConverter.createDataset("dataSetList", resultList));

		return  modelAndView;
	}


	/**
	 *  분석기기 > 관리 > 소모품 관리 > 관리 > 소모품 입출력 > 신규 등록 및 수정 팝업창
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/mchn/mgmt/retrieveCgdsMgmtPop.do")
	public String retrieveCgdsMgmtPop(@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		ModelAndView modelAndView = new ModelAndView("ruiView");
		LOGGER.debug("###############22################################################################ : "+ input);
		model.addAttribute("inputData", input);

		return "web/mchn/mgmt/cgdsAnl/cgdsMgmtPop";
	}


	/**
	 *  분석기기 > 관리 > 소모품 관리 > 관리 > 소모품 입출력 > 팝업창 신규정보조회
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/mchn/mgmt/retrieveCgdsMgmtPopInfo.do")
	public ModelAndView retrieveCgdsMgmtPopInfo(@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		ModelAndView modelAndView = new ModelAndView("ruiView");

		HashMap<String, Object> result =  mchnCgdgService.retrieveCgdsMgmtPopInfo(input);
		modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", result));

		return  modelAndView;
	}



	/**
	 *  분석기기 > 관리 > 소모품 관리 > 관리 > 소모품 입출력 > 팝업창 정보 저장 및 수정
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/mchn/mgmt/saveCgdsMgmtPopInfo.do")
	public ModelAndView saveCgdsMgmtPopInfo(@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		ModelAndView modelAndView = new ModelAndView("ruiView");
		HashMap<String, Object> rtnMeaasge = new HashMap<String, Object>();

		String rtnMsg = "";
		String rtnSt = "F";
		int totQty = 0;
		int qty =  Integer.parseInt(input.get("qty").toString());

		try{

			totQty = mchnCgdgService.retrieveTotQty(input);

			//출고 및 폐기일 경우 현재고 체크
			if(!input.get("whioClCd").equals("WHSN")  ){
				totQty = totQty - qty ;
				if( totQty < 0  ){
					rtnMsg = "현재 재고갯수를 확인해주십시오.";
					throw new Exception();
				}else{
					input.put("totQty", totQty);
				}
			}else{
				totQty = totQty + qty;
				input.put("totQty", totQty);
			}
			mchnCgdgService.saveCgdsMgmtPopInfo(input);

			rtnMsg = "저장되었습니다.";
			rtnSt  = "S";
		}catch(Exception e){
			e.printStackTrace();
			if("".equals(rtnMsg)){
				rtnMsg = "처리중 오류가발생했습니다. 담당자에게 문의해주세요";
			}
		}

		rtnMeaasge.put("rtnMsg", rtnMsg);
		rtnMeaasge.put("rtnSt", rtnSt);
		modelAndView.addObject("resultDataSet", RuiConverter.createDataset("resultDataSet", rtnMeaasge));

		return  modelAndView;
	}






}
