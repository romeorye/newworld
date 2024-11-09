package iris.web.batch.space.service;


import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.stereotype.Service;

import devonframe.dataaccess.CommonDao;
import devonframe.mail.MailSender;
import devonframe.mail.MailSenderFactory;
import iris.web.space.rqpr.vo.SpaceEvRnewMailInfo;

/*********************************************************************************
 * NAME : SpaceEvRnewMailServiceImpl.java
 * DESC : 공간평가 성적서 갱신 이메일 배치 ServiceImpl
 * PROJ : IRIS UPGRADE 1차 프로젝트
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION
 * ----------  ------  ---------------------------------------------------------
 * 2018.10.30  오정훈	최초생성
 *********************************************************************************/

@Service("spaceEvRnewMailService")
public class SpaceEvRnewMailServiceImpl implements SpaceEvRnewMailService {

	static final Logger LOGGER = LogManager.getLogger(SpaceEvRnewMailServiceImpl.class);

	@Resource(name="commonDao")
	private CommonDao commonDao;

	@Resource(name="mailSenderFactory")
	private MailSenderFactory mailSenderFactory;

	/* 공간평가 성적서 갱신 리스트 조회 */
	public List<SpaceEvRnewMailInfo> getSpaceEvRnewMailList() {
		return commonDao.selectList("space.batch.getSpaceEvRnewMailList");
	}

	/* 공간평가 성적서 이메일 발송 */
	public boolean sendSpaceEvRnewMail(SpaceEvRnewMailInfo spaceEvRnewMailInfo) throws Exception {
    		MailSender mailSender = mailSenderFactory.createMailSender();
    		//mailSender.setFromMailAddress(spaceMailInfo.getRgstEmail(), spaceMailInfo.getRgstNm());
    		mailSender.setFromMailAddress("iris@lxhausys.com");

    		mailSender.setToMailAddress(spaceEvRnewMailInfo.getReceivers().split(","));

    		mailSender.setSubject(spaceEvRnewMailInfo.getTitl() + " 인증서(성적서) 갱신 요청의 건.");

    		mailSender.setHtmlTemplate("spaceEvRnew", spaceEvRnewMailInfo);

    		mailSender.setCcMailAddress(spaceEvRnewMailInfo.getRfp().split(","));

    		mailSender.send();

    		HashMap<String, Object> input = new HashMap<String, Object>();

			input.put("mailTitl", spaceEvRnewMailInfo.getTitl() + " 인증서(성적서) 갱신 요청의 건.");
			input.put("adreMail", spaceEvRnewMailInfo.getReceivers());
			input.put("trrMail",  "iris@lxhausys.com");
			input.put("rfpMail",  spaceEvRnewMailInfo.getRfp());
			input.put("_userId", "Batch-SpaceApprMail");
			input.put("_userEmail", "iris@lxhausys.com");

			/* 전송메일 정보 hist 저장*/
			commonDao.update("open.mchnAppr.insertMailHist", input);

			return true;
	}


}