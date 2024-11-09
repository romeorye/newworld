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

	@Resource(name="commonDaoTodo")
	private CommonDao commonDaoTodo;
	
	@Resource(name="mailSenderFactory")
	private MailSenderFactory mailSenderFactory;

	/* 공간평가 요청 결재 완료 리스트 조회 */
	public List<SpaceMailInfo> getSpaceRqprApprCompleteList() {
		return commonDao.selectList("space.batch.getSpaceRqprApprCompleteList");
	}

	/* 공간평가 결과 결재 완료 리스트 조회 */
	public List<SpaceMailInfo> getSpaceRsltApprCompleteList() {
		return commonDao.selectList("space.batch.getSpaceRsltApprCompleteList");
	}

	/* 공간평가 접수요청 이메일 발송 */
	public boolean sendReceiptRequestMail(SpaceMailInfo spaceMailInfo) throws Exception {
    	if(commonDao.update("space.batch.updateSpaceChrgTrsfFlag", spaceMailInfo) == 1) {

    		MailSender mailSender = mailSenderFactory.createMailSender();
    		//mailSender.setFromMailAddress(spaceMailInfo.getRgstEmail(), spaceMailInfo.getRgstNm());
    		mailSender.setFromMailAddress("iris@lxhausys.com");
    		mailSender.setToMailAddress(spaceMailInfo.getReceivers().split(","));
    		mailSender.setSubject("'" + spaceMailInfo.getSpaceNm() + "' 평가의뢰 접수 요청");
    		mailSender.setHtmlTemplate("spaceRqprReceiptRequest", spaceMailInfo);
    		mailSender.send();

    		HashMap<String, Object> input = new HashMap<String, Object>();

			input.put("mailTitl", "'" + spaceMailInfo.getSpaceNm() + "' 평가의뢰 접수 요청");
			input.put("adreMail", spaceMailInfo.getReceivers());
			input.put("trrMail",  spaceMailInfo.getRgstEmail());
			input.put("rfpMail",  "");
			input.put("_userId", "Batch-SpaceApprMail");
			input.put("_userEmail", "iris@lxhausys.com");

			/* 전송메일 정보 hist 저장*/
			commonDao.update("open.mchnAppr.insertMailHist", input);

			return true;

    	} else {
    		throw new Exception("공간평가 의뢰 접수요청 이메일 발송 오류");
    	}
	}

	/* 공간평가 분석결과 통보 이메일 발송 */
	public boolean sendSpaceRqprResultMail(SpaceMailInfo spaceMailInfo) throws Exception {
    	if(commonDao.update("space.batch.updateRgstTrsfFlag", spaceMailInfo) == 1) {

    		MailSender mailSender = mailSenderFactory.createMailSender();
    		//mailSender.setFromMailAddress(spaceMailInfo.getChrgEmail(), spaceMailInfo.getChrgNm());
    		mailSender.setFromMailAddress("iris@lxhausys.com");
    		mailSender.setToMailAddress(spaceMailInfo.getReceivers().split(","));
    		mailSender.setSubject("'" + spaceMailInfo.getSpaceNm() + "' 평가결과 통보");
    		mailSender.setHtmlTemplate("spaceRqprResult", spaceMailInfo);
    		mailSender.send();

    		HashMap<String, Object> input = new HashMap<String, Object>();

			input.put("mailTitl", "'" + spaceMailInfo.getSpaceNm() + "' 평가결과 통보");
			input.put("adreMail", spaceMailInfo.getReceivers());
			input.put("trrMail",  spaceMailInfo.getRgstEmail());
			input.put("rfpMail",  "");
			input.put("_userId", "Batch-SpaceApprMail");
			input.put("_userEmail", "iris@lxhausys.com");

			/* 전송메일 정보 hist 저장*/
			commonDao.update("open.mchnAppr.insertMailHist", input);

        	return true;
    	} else {
    		throw new Exception("공간평가결과 통보 이메일 발송 오류");
    	}
	}
	
	/* 공간평가 Todo 리스트 조회*/
	public List<HashMap<String, Object>> getSpaceRsltApprTodoList(){
		return commonDao.selectList("space.batch.getSpaceRsltApprTodoList");
	}
	
	/* 공간평가 Todo 정보 생성*/
	public int saveSpaceRqprTodo(HashMap<String, Object> data) throws Exception {
		int reCnt = 0 ;
		reCnt = commonDaoTodo.insert("space.batch.saveSpaceRqprTodo", data);
		
		return reCnt;
	}
	
	public void updateSpaceTodoFlag(HashMap<String, Object> data)  throws Exception {
		if(commonDao.update("space.batch.updateSpaceTodoFlag", data) == 1){

		}else{
			throw new Exception("공간평가 시험결과 TODO 상태업데이트 오류");
		}
	}
}