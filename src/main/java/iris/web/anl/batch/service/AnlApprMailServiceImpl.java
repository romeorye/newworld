package iris.web.anl.batch.service;


import java.util.List;

import javax.annotation.Resource;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.stereotype.Service;

import devonframe.dataaccess.CommonDao;
import devonframe.mail.MailSender;
import devonframe.mail.MailSenderFactory;
import iris.web.anl.rqpr.vo.AnlMailInfo;

/*********************************************************************************
 * NAME : AnlApprMailServiceImpl.java 
 * DESC : 분석 결재 이메일 배치 ServiceImpl
 * PROJ : IRIS UPGRADE 1차 프로젝트
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG                       
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION                        
 * ----------  ------  --------------------------------------------------------- 
 * 2017.08.25  오명철	최초생성               
 *********************************************************************************/

@Service("anlApprMailService")
public class AnlApprMailServiceImpl implements AnlApprMailService {
	
	static final Logger LOGGER = LogManager.getLogger(AnlApprMailServiceImpl.class);

	@Resource(name="commonDao")
	private CommonDao commonDao;
	
	@Resource(name="mailSenderFactory")
	private MailSenderFactory mailSenderFactory;

	/* 분석의뢰 요청 결재 완료 리스트 조회 */
	public List<AnlMailInfo> getAnlRqprApprCompleteList() {
		return commonDao.selectList("anl.batch.getAnlRqprApprCompleteList");
	}

	/* 분석 결과 결재 완료 리스트 조회 */
	public List<AnlMailInfo> getAnlRsltApprCompleteList() {
		return commonDao.selectList("anl.batch.getAnlRsltApprCompleteList");
	}
	
	/* 분석의뢰 접수요청 이메일 발송 */
	public boolean sendReceiptRequestMail(AnlMailInfo anlMailInfo) throws Exception {
    	if(commonDao.update("anl.batch.updateAnlChrgTrsfFlag", anlMailInfo) == 1) {
    		
    		MailSender mailSender = mailSenderFactory.createMailSender();
    		
    		mailSender.setFromMailAddress(anlMailInfo.getRgstEmail(), anlMailInfo.getRgstNm());
    		mailSender.setToMailAddress(anlMailInfo.getReceivers().split(","));
    		mailSender.setSubject("'" + anlMailInfo.getAnlNm() + "' 분석의뢰 접수 요청");
    		mailSender.setHtmlTemplate("anlRqprReceiptRequest", anlMailInfo);
    		mailSender.send();
    		
        	return true;
    	} else {
    		throw new Exception("분석의뢰 접수요청 이메일 발송 오류");
    	}
	}
	
	/* 분석결과 통보 이메일 발송 */
	public boolean sendAnlRqprResultMail(AnlMailInfo anlMailInfo) throws Exception {
    	if(commonDao.update("anl.batch.updateRgstTrsfFlag", anlMailInfo) == 1) {
    		
    		MailSender mailSender = mailSenderFactory.createMailSender();
    		
    		mailSender.setFromMailAddress(anlMailInfo.getChrgEmail(), anlMailInfo.getChrgNm());
    		mailSender.setToMailAddress(anlMailInfo.getReceivers().split(","));
    		mailSender.setSubject("'" + anlMailInfo.getAnlNm() + "' 분석결과 통보");
    		mailSender.setHtmlTemplate("anlRqprResult", anlMailInfo);
    		mailSender.send();
    		
        	return true;
    	} else {
    		throw new Exception("분석결과 통보 이메일 발송 오류");
    	}
	}
}