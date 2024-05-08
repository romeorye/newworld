package iris.web.knld.qna.controller;

import java.util.HashMap;
import java.util.ResourceBundle;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import iris.web.common.security.SecurityEncrypter;
import iris.web.common.util.StringUtil;
import iris.web.knld.qna.service.GroupRnDService;
import iris.web.system.base.IrisBaseController;

/********************************************************************************
 * NAME : GroupRnDController.java 
 * DESC : Knowledge - Group R&D 관리 controller
 * PROJ : IRIS UPGRADE 1차 프로젝트
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG                       
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION                        
 * ----------  ------  --------------------------------------------------------- 
 * 2017.08.25  오명철	최초생성
 *********************************************************************************/

@Controller
public class GroupRnDController extends IrisBaseController {
	
	@Resource(name = "knldGroupRnDService")
	private GroupRnDService knldGroupRnDService;
	
    ResourceBundle configService = ResourceBundle.getBundle("config.project");
	
	static final Logger LOGGER = LogManager.getLogger(GroupRnDController.class);

	@RequestMapping(value="/knld/qna/retrieveGroupBoardList.do")
	public String groupRnDList(
			@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			) throws Exception{
		
		/* 반드시 공통 호출 후 작업 */
		checkSessionObjRUI(input, session, model);
		
    	input = StringUtil.toUtf8(input);

		LOGGER.debug("###########################################################");
		LOGGER.debug("GroupRnDController - groupRnDList [Group R&D 조회 화면 이동]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("###########################################################");
		
		String key = configService.getString("RND_KEY");
		String iv = configService.getString("RND_IV");
		StringBuffer userInfo = new StringBuffer();
		
		userInfo.append("ID=").append(input.get("_userId"))
				.append(",NAME=").append(input.get("_userNm"))
				.append(",POSITION=").append(knldGroupRnDService.getRndPositionCd((String)input.get("_userJobx")))
				.append(",EMAIL=").append(input.get("_userEmail"));
		
		SecurityEncrypter encrypter = new SecurityEncrypter(key, iv);
		
		input.put("authKey", key);
		input.put("userInfo", encrypter.encrypt(userInfo.toString()));
		
		model.addAttribute("inputData", input);

		return "web/knld/qna/groupRnDList";
	}
}