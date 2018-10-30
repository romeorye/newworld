package iris.web.prj.mm.mail.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang.StringUtils;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import devonframe.mail.MailSender;
import devonframe.mail.MailSenderFactory;
import devonframe.message.saymessage.SayMessage;
import devonframe.util.NullUtil;
import iris.web.common.converter.RuiConverter;
import iris.web.common.util.StringUtil;
import iris.web.prj.mm.mail.service.MmMailService;
import iris.web.prj.mm.mail.vo.MmMailVo;
import iris.web.system.base.IrisBaseController;
import iris.web.system.user.service.IrisUserService;

/********************************************************************************
 * NAME : MmMailController.java
 * DESC : 메일 controller
 * PROJ : IRIS 구축 프로젝트
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION
 * ----------  ------  ---------------------------------------------------------
 * 2017.09.08  IRIS04	최초생성
 *********************************************************************************/

@Controller
public class MmMailController  extends IrisBaseController {

	@Resource(name="messageSourceAccessor")
	private MessageSourceAccessor messageSourceAccessor;

	@Resource(name="mmMailService")
	private MmMailService mmMailService;			// MmMail 서비스

	@Resource(name="mailSenderFactory")
	private MailSenderFactory mailSenderFactory;	// 메일전송 팩토리

	@Resource(name="irisUserService")
	private IrisUserService irisUserService;		// 유저조회 서비스

	static final Logger LOGGER = LogManager.getLogger(MmMailController.class);


	/* 메일 팝업 화면이동 */
	@SuppressWarnings("unchecked")
	@RequestMapping(value="/prj/mm/mail/sendMailPopup.do")
	public String sendMailPopupView(
			@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
		LOGGER.debug("#####################################################################################");
		LOGGER.debug("MmMailController - sendMailPopupView [메일 팝업 화면이동]");
		LOGGER.debug("loginUser => " + model.get("loginUser"));
		LOGGER.debug("inputData => " + input);
		LOGGER.debug("#####################################################################################");

		checkSessionObjRUI(input, session, model);
		input = StringUtil.toUtf8(input);
		if(NullUtil.isNull(input.get("_userId")) ||  NullUtil.nvl(input.get("_userId"), "").equals("-1")  ){
			String rtnMsg = messageSourceAccessor.getMessage("msg.alert.sessionTimeout");
			SayMessage.setMessage(rtnMsg);
        } else {

        	// 파라미터로 넘어온 유저리스트 조회
        	if(!"".equals(  NullUtil.nvl(input.get("userIds"),""))){
	        	String[] userIdArr = (NullUtil.nvl(input.get("userIds"),"")).split(",");
	        	List<String> userIdList = new ArrayList<String>();

	        	for(String userId : userIdArr) {
	        		userIdList.add(userId);
	        	}
	        	input.put("userIdList", userIdList);

	        	if(userIdList.size() > 0) {

		        	List<Map<String,Object>>  userList = irisUserService.getUserList(input);
		        	String[] userArr = new String[userList.size()];
		        	String[] userNameArr = new String[userList.size()];
		        	String[] userMailArr = new String[userList.size()];

		        	for(int i=0;i<userList.size();i++) {

		        		userArr[i] = NullUtil.nvl(userList.get(i).get("saUser"),"");
		        		userNameArr[i] = NullUtil.nvl(userList.get(i).get("saName"),"");
		        		userMailArr[i] = NullUtil.nvl(userList.get(i).get("saMail"),"");
		        	}

		        	input.put("userIds", StringUtils.join(userArr,","));
		        	input.put("userNames", StringUtils.join(userNameArr,", "));
		        	input.put("userMails", StringUtils.join(userMailArr,","));
	        	}
        	}

        	model.addAttribute("inputData", input);
        }

		return "web/prj/mm/sendMailPopup";
	}

	/** 메일발송 **/
	@RequestMapping(value="/prj/mm/mail/sendMail.do")
	public ModelAndView simpleSendMail(
			@RequestParam HashMap<String, Object> input,
			HttpServletRequest request,
			HttpSession session,
			ModelMap model
			){
		LOGGER.debug("################################################################");
		LOGGER.debug("MmClsInfoController - simpleSendMail [메일보내기]");
		LOGGER.debug("input = > " + input);
		LOGGER.debug("################################################################");

		MmMailVo vo = new MmMailVo();

		checkSessionObjRUI(input, session, model);
		ModelAndView modelAndView = new ModelAndView("ruiView");
		model.addAttribute("inputData", input);
		MailSender mailSender = null;
		String[] receiverNameList = null;
		String[] receiverMailList = null;
		List<HashMap<String, Object>> sndMailList = new ArrayList<HashMap<String, Object>>();	// 메일발송정보리스트

		String rtnMsg = "발송에 성공하였습니다.";	// 결과메시지

		try {
			receiverNameList = NullUtil.nvl(input.get("receiverNameList"),"").split(",");
			receiverMailList = NullUtil.nvl(input.get("receiverMailList"),"").split(",");

			mailSender = mailSenderFactory.createMailSender();

			for(String receiverMailAdd : receiverMailList) {
				mailSender.setFromMailAddress( NullUtil.nvl(input.get("hSenderEmail"),""), NullUtil.nvl(input.get("hSenderName"),""));
				mailSender.setToMailAddress(receiverMailAdd);
				mailSender.setSubject(NullUtil.nvl(input.get("mailTitle"),""));
	//			mailSender.setText(NullUtil.nvl(input.get("mailText"),""));
				vo.setMailTitle(NullUtil.nvl(input.get("mailTitle"),""));
				vo.setMailText(NullUtil.nvl(input.get("mailText"),""));
				// mailSender-context.xml에 설정한 메일 template의 bean id값과 치환시 사용될 VO클래스를 넘김
				mailSender.setHtmlTemplate("prjSendMailPopup", vo);
				mailSender.send();

				HashMap<String, Object> mailMap = new HashMap<String, Object>();
				mailMap.put("mailTitl", NullUtil.nvl(input.get("mailTitle").toString(),""));
				mailMap.put("adreMail", receiverMailAdd );
				mailMap.put("trrMail", NullUtil.nvl(input.get("hSenderEmail"),""));
				mailMap.put("_userId", input.get("_userId").toString());
				sndMailList.add(mailMap);
			}

			mmMailService.insertMailSndHis(sndMailList);

		} catch (Exception e) {
			e.printStackTrace();
			rtnMsg = "발송에 실패하였습니다.";	// 결과메시지
		}

		input.put("rtnMsg", rtnMsg);
        modelAndView.addObject("dataset", RuiConverter.createDataset("dataset", input));

        LOGGER.debug("################# MAIL SEND RESULT ###############################################");
        LOGGER.debug("result input = > " + input);
        LOGGER.debug("################# MAIL SEND RESULT ###############################################");

		return modelAndView;
	}
}
