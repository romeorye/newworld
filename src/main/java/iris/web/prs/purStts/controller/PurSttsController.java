package iris.web.prs.purStts.controller;

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

import iris.web.common.code.service.CodeCacheManager;
import iris.web.common.converter.RuiConverter;
import iris.web.common.util.DateUtil;
import iris.web.common.util.StringUtil;
import iris.web.prs.purRq.service.PurRqInfoService;
import iris.web.prs.purStts.service.PurSttsService;
import iris.web.system.base.IrisBaseController;


@Controller
public class PurSttsController  extends IrisBaseController {


	@Resource(name = "codeCacheManager")
	private CodeCacheManager codeCacheManager;
	
	@Resource(name = "purSttsService")
	private PurSttsService purSttsService;
	
	@Resource(name = "purRqInfoService")
	private PurRqInfoService purRqInfoService;
	
	static final Logger LOGGER = LogManager.getLogger(PurSttsController.class);
	
	
	/**
	 *  구매요청현황 리스트 화면으로 이동
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 * @throws Exception 
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/prs/purStts/purSttsList.do")
	public String purSttsList(
			@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			) throws Exception{
		
		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		input = StringUtil.toUtf8Input(input);
		
		LOGGER.debug("###########################################################");
		LOGGER.debug("PurSttsController - purSttsList [구매요청현황 리스트 화면 이동]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");
		
		String today = DateUtil.getDateString();
		
		if(StringUtil.isNullString( (String)input.get("fromRegDt"))) {
			input.put("fromRegDt", DateUtil.addMonths(today, -1, "yyyy-MM-dd"));
			input.put("toRegDt", today);
		}
		
		model.addAttribute("inputData", input);
		
		return "web/prs/purStts/purSttsList";
	}
	
	/**
	 * 나의 구매요청 조회
	 * @param input
	 * @param request
	 * @param response
	 * @param session
	 * @param model
	 * @return
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/prs/purStts/purSttsSearchList.do")
	public ModelAndView purSttsSearchList(
			@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpServletResponse response,
			HttpSession session,
			ModelMap model
			){

		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		ModelAndView modelAndView = new ModelAndView("ruiView");
		
		input = StringUtil.toUtf8(input);
		
		LOGGER.debug("###########################################################");
		LOGGER.debug("PurRqInfoController - purSttsSearchList [ 구매현황요청리스트]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");


		//나의 구매요청 리스트 조회
		List<Map<String,Object>> myPurRqList = purSttsService.retrievePurSttsList(input);
		List<Map<String,Object>> erpPurRqStatus = purRqInfoService.getPrRequestSAPStatus(myPurRqList);
		
		if(!erpPurRqStatus.isEmpty()) {
			Map<String,Object> myListData = new HashMap<String,Object>();
			int i = 0;
			for(Map<String, Object> purRq : erpPurRqStatus) {
				i = Integer.parseInt(purRq.get("idx").toString());
				
				
				myListData = myPurRqList.get(i);
				LOGGER.debug("**************************************************************************************");
				LOGGER.debug("i : " + i);	
				LOGGER.debug(purRq);
				LOGGER.debug("**************************************************************************************");
				
				myListData.put("prsFlag", 	purRq.get("index"));
				myListData.put("prsNm", 	purRq.get("status"));
				myListData.put("badat", 	purRq.get("badat"));		
				myListData.put("apr4Date", 	purRq.get("apr4Date"));		
				myListData.put("rejeDate", 	purRq.get("rejeDate"));		
				myListData.put("ebeln", 	purRq.get("ebeln"));			
				myListData.put("ebelp", 	purRq.get("ebelp"));			
				myListData.put("bedat", 	purRq.get("bedat"));			
				myListData.put("poMenge", 	purRq.get("poMenge"));		
				myListData.put("poMeins", 	purRq.get("poMeins"));		
				myListData.put("netwr", 	purRq.get("netwr"));			
				myListData.put("waers", 	purRq.get("waers"));			
				myListData.put("name1", 	purRq.get("name1"));			
				myListData.put("grBudat", 	purRq.get("grBudat"));		
				myListData.put("grMenge", 	purRq.get("grMenge"));		
				myListData.put("piBudat", 	purRq.get("piBudat"));		

				LOGGER.debug(myListData);
				LOGGER.debug("**************************************************************************************");
				
				myPurRqList.set(i, myListData);
			}
		}
		
		modelAndView.addObject("prItemListDataSet", RuiConverter.createDataset("prItemListDataSet", myPurRqList));

		return modelAndView;
	}
	
	
	
	
	
	
	
	
	
}
