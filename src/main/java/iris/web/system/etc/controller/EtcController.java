/********************************************************************************
 * NAME : EtcController.java 
 * DESC : 기타 공통
 * PROJ : IRIS UPGRADE 2차 프로젝트
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG                       
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION                        
 * ----------  ------  --------------------------------------------------------- 
 * 2018.08.09 정현웅	최초생성
 *********************************************************************************/

package iris.web.system.etc.controller;

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
import iris.web.prj.rsst.service.PrjRsstMstInfoService;
import iris.web.system.base.IrisBaseController;
import iris.web.system.etc.service.EtcService;

@Controller
public class EtcController  extends IrisBaseController {

	@Resource(name="messageSourceAccessor")
	private MessageSourceAccessor messageSourceAccessor;
	
	@Resource(name = "etcService")
	private EtcService etcService;
	
	@Resource(name = "prjRsstMstInfoService")
	private PrjRsstMstInfoService prjRsstMstInfoService;
	
	static final Logger LOGGER = LogManager.getLogger(EtcController.class);
	
	@RequestMapping(value="/system/etc/wbsCdSearchPopup.do")
	public String wbsCdSearchPopup(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){

		LOGGER.debug("###########################################################");
		LOGGER.debug("EtcController - wbsCdSearchPopup WBS 코드 조회 공통팝업");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");
		
		
		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);
		
		model.addAttribute("inputData", input);
		        
		return "web/common/wbsCdSearchPopup";
	}
	
	@RequestMapping(value="/system/etc/getWbsCdList.do")
	public ModelAndView getWbsCdList(
			@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
		
		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		
    	input = StringUtil.toUtf8(input);

		LOGGER.debug("###########################################################");
		LOGGER.debug("EtcController - getWbsCdList WBS 코드 조회");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");
		
		ModelAndView modelAndView = new ModelAndView("ruiView");
		
		List<Map<String,Object>>  wbsCdList = etcService.getWbsCdList(input);
	        
		modelAndView.addObject("wbsCdDataset", RuiConverter.createDataset("wbsCdDataset", wbsCdList));

		return modelAndView;
	}
	
	

	
}