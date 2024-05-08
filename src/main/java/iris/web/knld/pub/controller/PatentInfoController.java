package iris.web.knld.pub.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.logging.log4j.LogManager; import org.apache.logging.log4j.Logger;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import devonframe.message.saymessage.SayMessage;
import devonframe.util.NullUtil;

import iris.web.common.code.service.CodeCacheManager;
import iris.web.common.converter.RuiConverter;
import iris.web.common.util.DateUtil;
import iris.web.common.util.StringUtil;
import iris.web.knld.pub.service.PatentInfoService;
import iris.web.system.base.IrisBaseController;

/********************************************************************************
 * NAME : PatentController.java 
 * DESC : 특허 관리 controller
 * PROJ : IRIS UPGRADE 1차 프로젝트
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG                       
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION                        
 * ----------  ------  --------------------------------------------------------- 
 * 2017.09.13  			최초생성     
 *********************************************************************************/

@Controller
public class PatentInfoController  extends IrisBaseController {
	
	@Resource(name = "patentInfoService")
	private PatentInfoService patentInfoService;	

	static final Logger LOGGER = LogManager.getLogger(PatentInfoController.class);

	/*리스트 화면 호출*/
	@RequestMapping(value="/knld/pub/retrievePatentInfoList.do")
	public String patentInfoList(
			@RequestParam HashMap<String, String> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			) throws Exception{
		
		/* 반드시 공통 호출 후 작업 */
		checkSession(input, session, model);

		LOGGER.debug("###########################################################");
		LOGGER.debug("PatentController - PatentList [특허 리스트 호출]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");
		
		model.addAttribute("inputData", input);

		return "web/knld/pub/retrievePatentInfoList";
	}
	
	
	
	
}//class end
