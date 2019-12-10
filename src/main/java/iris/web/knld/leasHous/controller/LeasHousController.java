package iris.web.knld.leasHous.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import iris.web.common.converter.RuiConverter;
import iris.web.common.util.StringUtil;
import iris.web.knld.leasHous.service.LeasHousService;
import iris.web.system.base.IrisBaseController;

@Controller
public class LeasHousController extends IrisBaseController {

	@Resource(name="leasHousService")
	private LeasHousService leasHousService;
	
	static final Logger LOGGER = LogManager.getLogger(LeasHousController.class);
	
	
	
	/**
	 * 임차주택 목록 화면
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/knld/leasHous/retrieveLeasHousList.do")
	public String retrieveFxaOscpList(@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){

		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		input = StringUtil.toUtf8(input);

		model.addAttribute("inputData", input);

		return  "web/knld/leasHous/leasHousList";
	}
	
	/**
	 * 임차주택 > 체크리스트 팝업
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/knld/leasHous/chkListPop.do")
	public String chkListPop(@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){

		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		input = StringUtil.toUtf8(input);

		model.addAttribute("inputData", input);

		return  "web/knld/leasHous/chkListPop";
	}
	
	/**
     * 임차주택관리 > 임차주택관리 리스트 조회
     *
     * @param input HashMap<String, Object>
     * @param request HttpServletRequest
     * @param response HttpServletResponse
     * @param session HttpSession
     * @param model ModelMap
     * @return ModelAndView
     * */
    @SuppressWarnings("unchecked")
    @RequestMapping(value="/knld/leasHous/retrieveLeasHousSearchList.do")
    public ModelAndView retrieveLeasHousSearchList(@RequestParam HashMap<String, Object> input, HttpServletRequest request,
            HttpServletResponse response, HttpSession session, ModelMap model) {

    	checkSessionObjRUI(input, session, model);
    	
        LOGGER.debug("###########################################################");
        LOGGER.debug("LeasHousController - retrieveLeasHousSearchList [임차주택관리 > 임차주택관리 리스트 조회]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        ModelAndView modelAndView = new ModelAndView("ruiView");

        input = StringUtil.toUtf8(input);

        List<Map<String,Object>> list = leasHousService.retrieveLeasHousSearchList(input);

        
        modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", list));

        return modelAndView;
    }
    
	/**
	 * 임차주택 신청 및 상세 화면
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/knld/leasHous/leasHousDtl.do")
	public String leasHousDtl(@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){

		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		input = StringUtil.toUtf8(input);

		model.addAttribute("inputData", input);

		return  "web/knld/leasHous/leasHousDtl";
	}
    	
	/**
     * 임차주택관리 > 임차주택관리 리스트 조회
     *
     * @param input HashMap<String, Object>
     * @param request HttpServletRequest
     * @param response HttpServletResponse
     * @param session HttpSession
     * @param model ModelMap
     * @return ModelAndView
     * */
    @SuppressWarnings("unchecked")
    @RequestMapping(value="/knld/leasHous/retrieveLeasHousDtlInfo.do")
    public ModelAndView retrieveLeasHousDtlInfo(@RequestParam HashMap<String, Object> input, HttpServletRequest request,
            HttpServletResponse response, HttpSession session, ModelMap model) {

    	checkSessionObjRUI(input, session, model);
    	
        LOGGER.debug("###########################################################");
        LOGGER.debug("LeasHousController - retrieveLeasHousDtlInfo [임차주택관리 > 임차주택관리 상세화면 조회]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        ModelAndView modelAndView = new ModelAndView("ruiView");

        input = StringUtil.toUtf8(input);

        Map<String,Object> leasHousDtlInfo = new HashMap<String, Object>();
        
       	leasHousDtlInfo = leasHousService.retrieveLeasHousDtlInfo(input);

        modelAndView.addObject("dataSet", RuiConverter.createDataset("dataSet", leasHousDtlInfo));

        return modelAndView;
    }
    
    /**
	 * 임차주택관리 > 임차주택관리 저장
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/knld/leasHous/saveLeasHousInfo.do")
	public ModelAndView saveLeasHousInfo(@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){

		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		ModelAndView modelAndView = new ModelAndView("ruiView");
		
		LOGGER.debug("###########################################################");
        LOGGER.debug("leasHousService - saveLeasHousInfo [임차주택관리 > 임차주택관리 저장]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        HashMap<String, Object> rtnMeaasge = new HashMap<String, Object>();
		Map<String, Object> leasHousInfo = new HashMap<String, Object>();
		String rtnSt ="F";
		String rtnMsg = "";
		String leasId = "";
		
		try{
			
			leasHousInfo = RuiConverter.convertToDataSet(request, "dataSet").get(0);
			leasHousInfo.put("userId", input.get("_userId"));

			leasId = leasHousService.saveLeasHousInfo(leasHousInfo);
			
			rtnMsg = "저장되었습니다.";
			rtnSt = "S";
		}catch(Exception e){
			e.printStackTrace();
			rtnMsg = e.getMessage();
		}

		rtnMeaasge.put("rtnMsg", rtnMsg);
		rtnMeaasge.put("rtnSt", rtnSt);
		rtnMeaasge.put("leasId", leasId);
		modelAndView.addObject("resultDataSet", RuiConverter.createDataset("resultDataSet", rtnMeaasge));
		
		return  modelAndView;
	}
    
	/**
	 * 임차주택관리 > 임차주택관리 검토요청 업데이트
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/knld/leasHous/updateLeasHousSt.do")
	public ModelAndView updateLeasHousSt(@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){

		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		ModelAndView modelAndView = new ModelAndView("ruiView");
		
		LOGGER.debug("###########################################################");
        LOGGER.debug("leasHousService - updateLeasHousSt [임차주택관리 > 임차주택관리 검토요청 업데이트]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        HashMap<String, Object> rtnMeaasge = new HashMap<String, Object>();
        
		String rtnSt ="F";
		String rtnMsg = "";
		String leasId = "";
		
		try{
			input.put("userId", input.get("_userId"));
			leasId = leasHousService.updateLeasHousSt(input);
			
			rtnMsg = "검토요청되었습니다.";
			rtnSt = "S";
		}catch(Exception e){
			e.printStackTrace();
			rtnMsg = e.getMessage();
		}

		rtnMeaasge.put("rtnMsg", rtnMsg);
		rtnMeaasge.put("rtnSt", rtnSt);
		rtnMeaasge.put("leasId", leasId);
		modelAndView.addObject("resultDataSet", RuiConverter.createDataset("resultDataSet", rtnMeaasge));
		
		return  modelAndView;
	}	
    
	/**
	 * 임차주택관리 > 임차주택관리 검토 결과 업데이트
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/knld/leasHous/updateLeasHousPriSt.do")
	public ModelAndView updateLeasHousPriSt(@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){

		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		ModelAndView modelAndView = new ModelAndView("ruiView");
		input = StringUtil.toUtf8Input(input);
		
		LOGGER.debug("###########################################################");
        LOGGER.debug("leasHousService - updateLeasHousPriSt [임차주택관리 > 임차주택관리 검토 결과 업데이트]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        HashMap<String, Object> rtnMeaasge = new HashMap<String, Object>();
        Map<String, Object> leasHousInfo = new HashMap<String, Object>();
        
        String rtnSt ="F";
		String rtnMsg = "";
		
		try{
			leasHousInfo = RuiConverter.convertToDataSet(request, "dataSet").get(0);
			leasHousInfo.put("userId", input.get("_userId"));
			
			leasHousService.updateLeasHousPriSt(leasHousInfo);
			
			if( leasHousInfo.get("reqStCd").equals("APPR") ){
				rtnMsg = "승인처리되었습니다.";
			}else{
				rtnMsg = "반려처리되었습니다.";
			}
			rtnSt = "S";
		}catch(Exception e){
			e.printStackTrace();
			rtnMsg = e.getMessage();
		}

		rtnMeaasge.put("rtnMsg", rtnMsg);
		rtnMeaasge.put("rtnSt", rtnSt);
		modelAndView.addObject("resultDataSet", RuiConverter.createDataset("resultDataSet", rtnMeaasge));
		
		return  modelAndView;
	}
    
	/**
	 * 임차주택 > 사전검토 화면(관리자용)
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/knld/leasHous/leasHousDtlAdmin.do")
	public String leasHousDtlAdmin(@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){

		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		input = StringUtil.toUtf8(input);

		model.addAttribute("inputData", input);

		return  "web/knld/leasHous/leasHousDtlAdmin";
	}
	
	
	/**
	 * 임차주택 > 계약검토검토 화면(개인용)
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/knld/leasHous/leasHousCnrDtl.do")
	public String leasHousCnrDtl(@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){

		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		input = StringUtil.toUtf8(input);

		model.addAttribute("inputData", input);

		return  "web/knld/leasHous/leasHousCnrDtl";
	}
	
	/**
	 * 임차주택 > 계약검토 화면(관리자용)
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/knld/leasHous/leasHousCnrDtlAdmin.do")
	public String leasHousCnrDtlAdmin(@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){

		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		input = StringUtil.toUtf8(input);

		model.addAttribute("inputData", input);

		return  "web/knld/leasHous/leasHousCnrDtlAdmin";
	}
	
	/**
	 * 임차주택 > 계약검토 완료 화면
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/knld/leasHous/leasHousCnrCmpl.do")
	public String leasHousCnrCmpl(@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){

		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		input = StringUtil.toUtf8(input);

		model.addAttribute("inputData", input);

		return  "web/knld/leasHous/leasHousCnrCmpl";
	}
	
	
	/**
	 * 임차주택관리 > 임차주택관리 계약검토 신청 업데이트
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/knld/leasHous/updateLeasHousCnrReq.do")
	public ModelAndView updateLeasHousCnrReq(@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){

		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		ModelAndView modelAndView = new ModelAndView("ruiView");
		input = StringUtil.toUtf8Input(input);
		
		LOGGER.debug("###########################################################");
        LOGGER.debug("leasHousService - updateLeasHousCnrReq [임차주택관리 > 임차주택관리 계약검토 신청 업데이트]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        HashMap<String, Object> rtnMeaasge = new HashMap<String, Object>();
        Map<String, Object> leasHousInfo = new HashMap<String, Object>();
        
        String rtnSt ="F";
		String rtnMsg = "";
		
		try{
			leasHousInfo = RuiConverter.convertToDataSet(request, "dataSet").get(0);
			leasHousInfo.put("userId", input.get("_userId"));
			
			leasHousService.updateLeasHousCnrReq(leasHousInfo);
			
			rtnMsg = "신청되었습니다.";
			rtnSt = "S";
		}catch(Exception e){
			e.printStackTrace();
			rtnMsg = e.getMessage();
		}

		rtnMeaasge.put("rtnMsg", rtnMsg);
		rtnMeaasge.put("rtnSt", rtnSt);
		modelAndView.addObject("resultDataSet", RuiConverter.createDataset("resultDataSet", rtnMeaasge));
		
		return  modelAndView;
	}
	
	/**
	 * 임차주택관리 > 임차주택관리 계약검토 승인 업데이트
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/knld/leasHous/updateLeasHousCnrSt.do")
	public ModelAndView updateLeasHousCnrSt(@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){

		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		ModelAndView modelAndView = new ModelAndView("ruiView");
		input = StringUtil.toUtf8Input(input);
		
		LOGGER.debug("###########################################################");
        LOGGER.debug("leasHousService - updateLeasHousCnrSt [임차주택관리 > 임차주택관리 계약검토 승인 업데이트]");
        LOGGER.debug("input = > " + input);
        LOGGER.debug("###########################################################");

        HashMap<String, Object> rtnMeaasge = new HashMap<String, Object>();
        Map<String, Object> leasHousInfo = new HashMap<String, Object>();
        
        String rtnSt ="F";
		String rtnMsg = "";
		
		try{
			leasHousInfo = RuiConverter.convertToDataSet(request, "dataSet").get(0);
			leasHousInfo.put("userId", input.get("_userId"));
			
			leasHousService.updateLeasHousCnrSt(leasHousInfo);
			
			if( leasHousInfo.get("reqStCd").equals("APPR") ){
				rtnMsg = "승인처리되었습니다.";
			}else{
				rtnMsg = "반려처리되었습니다.";
			}
			
			rtnSt = "S";
		}catch(Exception e){
			e.printStackTrace();
			rtnMsg = e.getMessage();
		}

		rtnMeaasge.put("rtnMsg", rtnMsg);
		rtnMeaasge.put("rtnSt", rtnSt);
		modelAndView.addObject("resultDataSet", RuiConverter.createDataset("resultDataSet", rtnMeaasge));
		
		return  modelAndView;
	}
	
	/**
	 * 임차주택 > 확약서
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/knld/leasHous/retrieveLeasHousDpyPop.do")
	public String retrieveLeasHousDpyPop(@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){

		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		input = StringUtil.toUtf8(input);

		model.addAttribute("inputData", input);

		return  "web/knld/leasHous/leasHousDpyPop";
	}
	
	
	/**
	 * 임차주택 > 확약서
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/knld/leasHous/retrieveLshCnttSpctPop.do")
	public String retrieveLshCnttSpctPop(@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){

		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		input = StringUtil.toUtf8(input);

		model.addAttribute("inputData", input);

		return  "web/knld/leasHous/lshCnttSpctPop";
	}
	
	
	
	
	
	
	
	
}
