package iris.web.rlab.batch.service;


import java.util.List;

import javax.annotation.Resource;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.stereotype.Service;

import devonframe.dataaccess.CommonDao;
import devonframe.mail.MailSender;
import devonframe.mail.MailSenderFactory;
import iris.web.rlab.rqpr.vo.RlabMailInfo;

/*********************************************************************************
 * NAME : RlabApprMailServiceImpl.java
 * DESC : 분석 결재 이메일 배치 ServiceImpl
 * PROJ : IRIS UPGRADE 1차 프로젝트
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION
 * ----------  ------  ---------------------------------------------------------
 * 2018.07.30  정현웅	최초생성
 *********************************************************************************/

@Service("rlabApprMailService")
public class RlabApprMailServiceImpl implements RlabApprMailService {

	static final Logger LOGGER = LogManager.getLogger(RlabApprMailServiceImpl.class);

	@Resource(name="commonDao")
	private CommonDao commonDao;

	@Resource(name="mailSenderFactory")
	private MailSenderFactory mailSenderFactory;

	/* 분석의뢰 요청 결재 완료 리스트 조회 */
	public List<RlabMailInfo> getRlabRqprApprCompleteList() {
		return commonDao.selectList("rlab.batch.getRlabRqprApprCompleteList");
	}

	/* 분석 결과 결재 완료 리스트 조회 */
	public List<RlabMailInfo> getRlabRsltApprCompleteList() {
		return commonDao.selectList("rlab.batch.getRlabRsltApprCompleteList");
	}

	/* 분석의뢰 접수요청 이메일 발송 */
	public boolean sendReceiptRequestMail(RlabMailInfo rlabMailInfo) throws Exception {
    	if(commonDao.update("rlab.batch.updateRlabChrgTrsfFlag", rlabMailInfo) == 1) {

    		MailSender mailSender = mailSenderFactory.createMailSender();

    		mailSender.setFromMailAddress(rlabMailInfo.getRgstEmail(), rlabMailInfo.getRgstNm());
    		mailSender.setToMailAddress(rlabMailInfo.getReceivers().split(","));
    		mailSender.setSubject("'" + rlabMailInfo.getRlabNm() + "' 분석의뢰 접수 요청");
    		mailSender.setHtmlTemplate("rlabRqprReceiptRequest", rlabMailInfo);
    		mailSender.send();

        	return true;
    	} else {
    		throw new Exception("분석의뢰 접수요청 이메일 발송 오류");
    	}
	}

	/* 분석결과 통보 이메일 발송 */
	public boolean sendRlabRqprResultMail(RlabMailInfo rlabMailInfo) throws Exception {
    	if(commonDao.update("rlab.batch.updateRgstTrsfFlag", rlabMailInfo) == 1) {

    		MailSender mailSender = mailSenderFactory.createMailSender();

    		mailSender.setFromMailAddress(rlabMailInfo.getChrgEmail(), rlabMailInfo.getChrgNm());
    		mailSender.setToMailAddress(rlabMailInfo.getReceivers().split(","));
    		mailSender.setSubject("'" + rlabMailInfo.getRlabNm() + "' 분석결과 통보");
    		mailSender.setHtmlTemplate("rlabRqprResult", rlabMailInfo);
    		mailSender.send();

        	return true;
    	} else {
    		throw new Exception("분석결과 통보 이메일 발송 오류");
    	}
	}
}