/********************************************************************************
 * NAME : tssUserController.java 
 * DESC : 과제연구원조회
 * PROJ : iris
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG                       
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION                        
 * ----------  ------  --------------------------------------------------------- 
 * 2017.09.12 최초작성        
 *********************************************************************************/

package iris.web.prj.tss.com.controller;

import iris.web.common.converter.RuiConverter;
import iris.web.common.util.StringUtil;
import iris.web.prj.tss.com.service.TssUserService;
import iris.web.system.base.IrisBaseController;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
public class TssUserController  extends IrisBaseController {

	@Resource(name="messageSourceAccessor")
	private MessageSourceAccessor messageSourceAccessor;
	
	@Resource(name = "tssUserService")
	private TssUserService tssUserService;
	
	static final Logger LOGGER = LogManager.getLogger(TssUserController.class);
	
	@RequestMapping(value="/com/tss/tssUserSearchPopup.do")
	public String userSearchPopup(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){

		LOGGER.debug("###########################################################");
		LOGGER.debug("TssUserController - userTssSearchPopup 과제 사용자 조회 팝업");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");
		
		
		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);
		input = StringUtil.toUtf8(input);
		
		model.addAttribute("inputData", input);
		
		return "web/prj/tss/com/tssUserSearchPopup";
	}
	
	@RequestMapping(value="/com/tss/getTssUserList.do")
	public ModelAndView getTssUserList(
			@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
		
		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		
    	input = StringUtil.toUtf8(input);
    	
    	String[] userIdArr = ((String)input.get("userIds")).split(",");
    	List<String> userIdList = new ArrayList<String>();
    	
    	for(String userId : userIdArr) {
    		userIdList.add(userId);
    	}
    	
    	input.put("userIdList", userIdList);

		LOGGER.debug("###########################################################");
		LOGGER.debug("TssUserController - getTssUserList 과제 사용자 조회");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");
		
		ModelAndView modelAndView = new ModelAndView("ruiView");
		
		List<Map<String,Object>>  userList = tssUserService.getTssUserList(input);
	        
		modelAndView.addObject("userDataset", RuiConverter.createDataset("userDataset", userList));

		return modelAndView;
	}
	
	
	@RequestMapping(value="/com/tss/grsUserSearchPopup.do")
	public String grsUserSearchPopup(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){

		LOGGER.debug("###########################################################");
		LOGGER.debug("TssUserController - grsUserSearchPopup 과제 심의 사용자 조회 팝업");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");
		
		
		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);
		
		model.addAttribute("inputData", input);
		
		return "web/prj/tss/com/grsUserSearchPopup";
	}
	
	@RequestMapping(value="/com/tss/getGrsUserList.do")
	public ModelAndView getGrsUserList(
			@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
		
		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		
    	input = StringUtil.toUtf8(input);
    	
    	String[] userIdArr = ((String)input.get("userIds")).split(",");
    	List<String> userIdList = new ArrayList<String>();
    	
    	for(String userId : userIdArr) {
    		userIdList.add(userId);
    	}
    	
    	input.put("userIdList", userIdList);

		LOGGER.debug("###########################################################");
		LOGGER.debug("TssUserController - getGrsUserList  과제 심의 사용자 조회");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");
		
		ModelAndView modelAndView = new ModelAndView("ruiView");
		
		List<Map<String,Object>>  userList = tssUserService.getGrsUserList(input);
	        
		modelAndView.addObject("userDataset", RuiConverter.createDataset("userDataset", userList));

		return modelAndView;
	}
}