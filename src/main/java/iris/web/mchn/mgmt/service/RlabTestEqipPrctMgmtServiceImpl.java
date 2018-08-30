package iris.web.mchn.mgmt.service;

import iris.web.mchn.open.appr.vo.MchnApprVo;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.stereotype.Service;

import devonframe.dataaccess.CommonDao;
import devonframe.mail.MailSender;
import devonframe.mail.MailSenderFactory;
import devonframe.util.NullUtil;

@Service("rlabTestEqipPrctMgmtService")
public class RlabTestEqipPrctMgmtServiceImpl  implements RlabTestEqipPrctMgmtService{

	static final Logger LOGGER = LogManager.getLogger(RlabTestEqipPrctMgmtServiceImpl.class);

	@Resource(name="commonDao")
	private CommonDao commonDao;

	@Resource(name="mailSenderFactory")
	private MailSenderFactory mailSenderFactory;	// 메일전송 팩토리

	/* 신뢰성장비 예약관리 리스트 조회 */
	public List<Map<String, Object>> rlabTestEqipPrctMgmtList(HashMap<String, Object> input){
	    List<Map<String, Object>> resultList = commonDao.selectList("mgmt.rlabTestEqipPrctMgmt.retrieveRlabTestEqipPrctMgmtList", input);
	    return resultList;
	}
	
	/**
	 *  신뢰성시험장비 예약관리리스트 상세조회 (예약)
	 * @param input
	 * @return
	 */
	public HashMap<String, Object> retrieveRlabTestEqipPrctDtl(HashMap<String, Object> input){
		HashMap<String, Object> result = commonDao.select("mgmt.rlabTestEqipPrctMgmt.retrieveRlabTestEqipPrctDtl", input);
	    return result;
	}
	
	/**
	 *  신뢰성장비 예약관리 승인, 반려 업데이트
	 * @param input
	 * @return
	 */
	public void updateRlabTestEqipPrctInfo(HashMap<String, Object> input) throws Exception{
		
		MailSender mailSender = mailSenderFactory.createMailSender();
		MchnApprVo vo = new MchnApprVo();
		
		if(commonDao.update("mgmt.rlabTestEqipPrctMgmt.updateRlabTestEqipPrctInfo", input) > 0 ){
			//메일 발송 부분
	       	//LOGGER.debug("#######################mchnapprtList######input######################################################## : "+ input);
	       	//승인자 session 정보
			mailSender.setFromMailAddress( input.get("_userEmail").toString(), input.get("_userNm").toString());
			//송신자
			mailSender.setToMailAddress(input.get("toMailAddr").toString(), input.get("rgstNm").toString());
			mailSender.setSubject(NullUtil.nvl(input.get("mailTitl").toString(),""));
			
			vo.setRgstNm(NullUtil.nvl(input.get("rgstNm").toString(),""));
			vo.setMchnHanNm(NullUtil.nvl(input.get("mchnHanNm").toString(),""));
			vo.setMchnEnNm(NullUtil.nvl(input.get("mchnEnNm").toString(),""));
			vo.setPrctDt(input.get("prctDt").toString());
			vo.setPrctFromTim(input.get("prctFromTim").toString());
			vo.setPrctToTim(input.get("prctToTim").toString());
			vo.setPrctFromToDt(input.get("prctFromToDt").toString());
			vo.setPrctScnNm(input.get("prctScnNm").toString());
			mailSender.setHtmlTemplate("rlabApprReq", vo);
			
			mailSender.send();
			
			input.put("mailTitl", NullUtil.nvl(input.get("mailTitl").toString(),""));
			input.put("adreMail", input.get("toMailAddr").toString());
			input.put("trrMail",  input.get("_userEmail").toString());
			input.put("rfpMail",  "");
			input.put("_userId", input.get("_userId").toString());
			input.put("_userEmail", input.get("_userEmail").toString());
			
			/* 전송메일 정보 hist 저장*/
			commonDao.update("mgmt.rlabTestEqipPrctMgmt.insertMailHist", input);
		}else{
			throw new Exception("저장중 오류가발생하였습니다.");
		}
	}	
	
}
