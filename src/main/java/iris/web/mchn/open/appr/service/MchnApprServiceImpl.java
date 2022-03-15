package iris.web.mchn.open.appr.service;

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
import iris.web.mchn.open.appr.vo.MchnAppVo;

@Service("mchnApprService")
public class MchnApprServiceImpl implements MchnApprService{

	@Resource(name="commonDao")
	private CommonDao commonDao;
	static final Logger LOGGER = LogManager.getLogger(MchnApprServiceImpl.class);

	@Resource(name="mailSenderFactory")
	private MailSenderFactory mailSenderFactory;	// 메일전송 팩토리

	/**
	 *  분석기기 > open기기 > 보유기기관리 목록조회
	 * @param input
	 * @return
	 */
	public List<Map<String, Object>> retrieveMchnApprSearchList(HashMap<String, Object> input){
		List<Map<String, Object>> resultList = commonDao.selectList("open.mchnAppr.retrieveMchnApprSearchList", input);
	    return resultList;
	}

	/**
	 *  보유기기관리상세 화면(예약)
	 * @param input
	 * @return
	 */
	public HashMap<String, Object> retrieveMchnApprInfo(HashMap<String, Object> input){
		HashMap<String, Object> result = commonDao.select("open.mchnAppr.retrieveMchnApprInfo", input);
	    return result;
	}

	/**
	 *  보유기기관리 승인, 반려 업데이트
	 * @param input
	 * @return
	 */
	public void updateMachineApprInfo(HashMap<String, Object> input) throws Exception{
		
		MailSender mailSender = mailSenderFactory.createMailSender();
		MchnAppVo vo = new MchnAppVo();
		
		if(commonDao.update("open.mchnAppr.updateMachineApprInfo", input) > 0 ){
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
			vo.setPrctScnNm(input.get("prctScnNm").toString());
			mailSender.setHtmlTemplate("mchnApprReq", vo);
			
			mailSender.send();
			
			input.put("mailTitl", NullUtil.nvl(input.get("mailTitl").toString(),""));
			input.put("adreMail", input.get("toMailAddr").toString());
			input.put("trrMail",  input.get("_userEmail").toString());
			input.put("rfpMail",  "");
			input.put("_userId", input.get("_userId").toString());
			input.put("_userEmail", input.get("_userEmail").toString());
			
			/* 전송메일 정보 hist 저장*/
			commonDao.update("open.mchnAppr.insertMailHist", input);
		}else{
			throw new Exception("저장중 오류가발생하였습니다.");
		}
	}
	
	/**
	 *  보유기기관리 일괄 승인 업데이트
	 * @param input
	 * @return
	 * @throws Exception 
	 */
	public void updateMachineApprList(Map<String, Object> input) throws Exception{
		//
		MailSender mailSender = mailSenderFactory.createMailSender();
		MchnAppVo vo = new MchnAppVo();

		try{
			commonDao.update("open.mchnAppr.updateMachineApprInfoList", input); 
			//승인건 조회
			List<Map<String,Object>> machineApprInfoList = commonDao.selectList("open.mchnAppr.retrieveMachineApprInfo", input);
			
			for(Map<String,Object> machineApprInfo : machineApprInfoList) {
				mailSender.setFromMailAddress( input.get("_userEmail").toString(), input.get("_userNm").toString());
				//송신자
				mailSender.setToMailAddress(machineApprInfo.get("toMailAddr").toString(), machineApprInfo.get("rgstNm").toString());
				mailSender.setSubject(NullUtil.nvl(machineApprInfo.get("mailTitl").toString(),""));
				
				vo.setRgstNm(NullUtil.nvl(machineApprInfo.get("rgstNm").toString(),""));
				vo.setMchnHanNm(NullUtil.nvl(machineApprInfo.get("mchnHanNm").toString(),""));
				vo.setMchnEnNm(NullUtil.nvl(machineApprInfo.get("mchnEnNm").toString(),""));
				vo.setPrctDt(machineApprInfo.get("prctDt").toString());
				vo.setPrctFromTim(machineApprInfo.get("prctFromTim").toString());
				vo.setPrctToTim(machineApprInfo.get("prctToTim").toString());
				vo.setPrctScnNm(machineApprInfo.get("prctScnNm").toString());
				mailSender.setHtmlTemplate("mchnApprReq", vo);
				
				mailSender.send();
				
				input.put("mailTitl", NullUtil.nvl(machineApprInfo.get("mailTitl").toString(),""));
				input.put("adreMail", machineApprInfo.get("toMailAddr").toString());
				input.put("trrMail",  input.get("_userEmail").toString());
				input.put("rfpMail",  "");
				input.put("_userId", input.get("_userId").toString());
				input.put("_userEmail", input.get("_userEmail").toString());
				
				/* 전송메일 정보 hist 저장*/
				commonDao.insert("open.mchnAppr.insertMailHist", input);
			}
			
		}catch(Exception e){
			throw new Exception("저장중 오류가발생하였습니다.");
		}	
	}
	
}
