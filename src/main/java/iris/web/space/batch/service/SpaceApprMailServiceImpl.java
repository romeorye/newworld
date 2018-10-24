package iris.web.space.batch.service;


import java.util.List;

import javax.annotation.Resource;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.stereotype.Service;

import devonframe.dataaccess.CommonDao;
import devonframe.mail.MailSender;
import devonframe.mail.MailSenderFactory;
import iris.web.space.rqpr.vo.SpaceMailInfo;

/*********************************************************************************
 * NAME : SpaceApprMailServiceImpl.java
 * DESC : 분석 결재 이메일 배치 ServiceImpl
 * PROJ : IRIS UPGRADE 1차 프로젝트
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION
 * ----------  ------  ---------------------------------------------------------
 * 2017.08.25  오명철	최초생성
 *********************************************************************************/

@Service("spaceApprMailService")
public class SpaceApprMailServiceImpl implements SpaceApprMailService {

	static final Logger LOGGER = LogManager.getLogger(SpaceApprMailServiceImpl.class);

	@Resource(name="commonDao")
	private CommonDao commonDao;

	@Resource(name="mailSenderFactory")
	private MailSenderFactory mailSenderFactory;

	/* 분석의뢰 요청 결재 완료 리스트 조회 */
	public List<SpaceMailInfo> getSpaceRqprApprCompleteList() {
		return commonDao.selectList("space.batch.getSpaceRqprApprCompleteList");
	}

	/* 분석 결과 결재 완료 리스트 조회 */
	public List<SpaceMailInfo> getSpaceRsltApprCompleteList() {
		return commonDao.selectList("space.batch.getSpaceRsltApprCompleteList");
	}

	/* 분석의뢰 접수요청 이메일 발송 */
	public boolean sendReceiptRequestMail(SpaceMailInfo spaceMailInfo) throws Exception {
    	if(commonDao.update("space.batch.updateSpaceChrgTrsfFlag", spaceMailInfo) == 1) {

    		MailSender mailSender = mailSenderFactory.createMailSender();
    		//mailSender.setFromMailAddress(spaceMailInfo.getRgstEmail(), spaceMailInfo.getRgstNm());
    		mailSender.setFromMailAddress("iris@lghausys.com");
    		mailSender.setToMailAddress(spaceMailInfo.getReceivers().split(","));
    		mailSender.setSubject("'" + spaceMailInfo.getSpaceNm() + "' 평가의뢰 접수 요청");
    		mailSender.setHtmlTemplate("spaceRqprReceiptRequest", spaceMailInfo);
    		mailSender.send();

        	return true;
    	} else {
    		throw new Exception("평가의뢰 접수요청 이메일 발송 오류");
    	}
	}

	/* 분석결과 통보 이메일 발송 */
	public boolean sendSpaceRqprResultMail(SpaceMailInfo spaceMailInfo) throws Exception {
    	if(commonDao.update("space.batch.updateRgstTrsfFlag", spaceMailInfo) == 1) {

    		MailSender mailSender = mailSenderFactory.createMailSender();
    		//mailSender.setFromMailAddress(spaceMailInfo.getChrgEmail(), spaceMailInfo.getChrgNm());
    		mailSender.setFromMailAddress("iris@lghausys.com");
    		mailSender.setToMailAddress(spaceMailInfo.getReceivers().split(","));
    		mailSender.setSubject("'" + spaceMailInfo.getSpaceNm() + "' 평가결과 통보");
    		mailSender.setHtmlTemplate("spaceRqprResult", spaceMailInfo);
    		mailSender.send();

        	return true;
    	} else {
    		throw new Exception("평가결과 통보 이메일 발송 오류");
    	}
	}
}