/********************************************************************************
 * NAME : NwinsUserController.java 
 * DESC : �����ڷ�Խ���
 * PROJ : WINS UPGRADE 1�� ������Ʈ
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG                       
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION                        
 * ----------  ------  --------------------------------------------------------- 
 * 2016.07.25  ������	���ʻ���            
 *********************************************************************************/

package iris.web.system.user.controller;

import iris.web.common.converter.RuiConverter;
import iris.web.common.util.StringUtil;
import iris.web.system.base.IrisBaseController;
import iris.web.system.user.service.IrisUserService;
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
import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
public class IrisUserController  extends IrisBaseController {

	@Resource(name="messageSourceAccessor")
	private MessageSourceAccessor messageSourceAccessor;
	
	@Resource(name = "irisUserService")
	private IrisUserService irisUserService;
	
	static final Logger LOGGER = LogManager.getLogger(IrisUserController.class);
	
	@RequestMapping(value="/system/user/userSearchPopup.do")
	public String userSearchPopup(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){

		LOGGER.debug("###########################################################");
		LOGGER.debug("IrisUserController - userSearchPopup 사용자 조회 팝업");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");

		String userNm = "";
		try {
			input.put("userNm",new String(input.get("userNm").getBytes("iso-8859-1"), "utf-8"));
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}

		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);


		model.addAttribute("inputData", input);
		
		return "web/common/userSearchPopup";
	}
	
	
	@RequestMapping(value="/system/user/userSearchPopup2.do")
	public String userSearchPopup2(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){

		LOGGER.debug("###########################################################");
		LOGGER.debug("IrisUserController - userSearchPopup2 사용자 조회 팝업");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");
		
		
		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);
		
		model.addAttribute("inputData", input);
		
		return "web/common/userSearchPopup2";
	}
	@RequestMapping(value="/system/user/getUserList.do")
	public ModelAndView getUserList(
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
		LOGGER.debug("IrisUserController - getUserList 사용자 조회");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");
		
		ModelAndView modelAndView = new ModelAndView("ruiView");
		
		List<Map<String,Object>>  userList = irisUserService.getUserList(input);
	        
		modelAndView.addObject("userDataset", RuiConverter.createDataset("userDataset", userList));

		return modelAndView;
	}
}