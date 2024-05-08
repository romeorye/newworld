package iris.web.common.mail.controller;

import java.util.Map;

import javax.annotation.Resource;

import org.springframework.context.support.MessageSourceAccessor;
import org.springframework.stereotype.Controller;

import iris.web.common.mail.service.MailInfoService;
import iris.web.system.base.IrisBaseController;

@Controller
public class MailInfoController extends IrisBaseController {
	
	
	
	@Resource(name="messageSourceAccessor")
    private MessageSourceAccessor messageSourceAccessor;
	
	@Resource(name="mailInfoService")
	private MailInfoService mailInfoService;
	
	
	/**
	 *  발송메일 저장
	 */
	public void insertMailSndHist(Map<String, Object> input){
		
	}
	

}
