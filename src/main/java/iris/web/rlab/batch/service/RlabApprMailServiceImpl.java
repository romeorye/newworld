package iris.web.rlab.batch.service;


import java.util.HashMap;
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

	@Resource(name="commonDaoTodo")
	private CommonDao commonDaoTodo;
	
	@Resource(name="mailSenderFactory")
	private MailSenderFactory mailSenderFactory;

	/* 신뢰성 시험의뢰 요청 결재 완료 리스트 조회 */
	public List<RlabMailInfo> getRlabRqprApprCompleteList() {
		return commonDao.selectList("rlab.batch.getRlabRqprApprCompleteList");
	}

	/* 신뢰성 시험결과 결재 완료 리스트 조회 */
	public List<RlabMailInfo> getRlabRsltApprCompleteList() {
		return commonDao.selectList("rlab.batch.getRlabRsltApprCompleteList");
	}

	/* 신뢰성 시험의뢰 접수요청 이메일 발송 */
	public boolean sendReceiptRequestMail(RlabMailInfo rlabMailInfo) throws Exception {
    	if(commonDao.update("rlab.batch.updateRlabChrgTrsfFlag", rlabMailInfo) == 1) {

    		MailSender mailSender = mailSenderFactory.createMailSender();

    		mailSender.setFromMailAddress(rlabMailInfo.getRgstEmail(), rlabMailInfo.getRgstNm());
    		mailSender.setToMailAddress(rlabMailInfo.getReceivers().split(","));
    		mailSender.setSubject("'" + rlabMailInfo.getRlabNm() + "' 분석의뢰 접수 요청");
    		mailSender.setHtmlTemplate("rlabRqprReceiptRequest", rlabMailInfo);
    		mailSender.send();

    		HashMap<String, Object> input = new HashMap<String, Object>();

			input.put("mailTitl", rlabMailInfo.getRlabNm() + " 분석의뢰 접수 요청");
			input.put("adreMail", rlabMailInfo.getReceivers());
			input.put("trrMail",  rlabMailInfo.getRgstEmail());
			input.put("rfpMail",  "");
			input.put("_userId", "Batch-RlabApprMail");
			input.put("_userEmail", "iris@lxhausys.com");

			/* 전송메일 정보 hist 저장*/
			commonDao.update("open.mchnAppr.insertMailHist", input);

        	return true;
    	} else {
    		throw new Exception("신뢰성 시험의뢰 접수요청 이메일 발송 오류");
    	}
	}

	/* 분석결과 통보 이메일 발송 */
	public boolean sendRlabRqprResultMail(RlabMailInfo rlabMailInfo) throws Exception {
    	if(commonDao.update("rlab.batch.updateRgstTrsfFlag", rlabMailInfo) == 1) {

    		MailSender mailSender = mailSenderFactory.createMailSender();

    		mailSender.setFromMailAddress(rlabMailInfo.getChrgEmail(), rlabMailInfo.getChrgNm());
    		mailSender.setToMailAddress(rlabMailInfo.getReceivers().split(","));
    		mailSender.setSubject(rlabMailInfo.getRlabNm() + " 분석결과 통보");
    		mailSender.setHtmlTemplate("rlabRqprResult", rlabMailInfo);
    		mailSender.send();

    		HashMap<String, Object> input = new HashMap<String, Object>();

			input.put("mailTitl", rlabMailInfo.getRlabNm() + " 분석결과 통보");
			input.put("adreMail", rlabMailInfo.getReceivers());
			input.put("trrMail",  rlabMailInfo.getChrgEmail());
			input.put("rfpMail",  "");
			input.put("_userId", "Batch-RlabApprMail");
			input.put("_userEmail", "iris@lxhausys.com");

			/* 전송메일 정보 hist 저장*/
			commonDao.update("open.mchnAppr.insertMailHist", input);


        	return true;
    	} else {
    		throw new Exception("신뢰성 시험결과 통보 이메일 발송 오류");
    	}
	}
	
	/* 신뢰성 시험결과 Todo 리스트 조회*/
	public List<HashMap<String, Object>> getRlabRqprApprTodoList() {
		return commonDao.selectList("rlab.batch.getRlabRqprApprTodoList");
	}
	
	/* 신뢰성 시험결과 Todo 전송*/
	public int saveRlabRqprTodo(HashMap<String, Object> data) throws Exception {
		int reCnt = 0 ;
		reCnt = commonDaoTodo.insert("rlab.batch.saveRlabRqprTodo", data);
		
		return reCnt;
	}
	
	public void updateRlabTodoFlag(HashMap<String, Object> data) throws Exception{
		commonDao.update("rlab.batch.updateRlabTodoFlag", data);
	}
}