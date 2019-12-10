package iris.web.knld.leasHous.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.apache.velocity.app.VelocityEngine;
import org.springframework.stereotype.Service;

import devonframe.dataaccess.CommonDao;
import devonframe.mail.MailSender;
import devonframe.mail.MailSenderFactory;
import iris.web.common.mail.service.MailInfoService;
import iris.web.knld.leasHous.vo.LeasHousVo;

@Service("leasHousService")
public class LeasHousServiceImpl implements LeasHousService {

	@Resource(name="commonDao")
	private CommonDao commonDao;
	
	@Resource(name="mailSenderFactory")
	private MailSenderFactory mailSenderFactory;	// 메일전송 팩토리
	
	@Resource(name="mailInfoService")
    private MailInfoService mailInfoService;
	
	@Resource(name = "velocityEngine")
    private VelocityEngine velocityEngine;
	
	static final Logger LOGGER = LogManager.getLogger(LeasHousServiceImpl.class);
	
	
	
	/**
	 * 임차주택관리 > 임차주택관리 리스트 조회
	 * @param input
	 * @return
	 */
	public List<Map<String, Object>> retrieveLeasHousSearchList(HashMap<String, Object> input){
		return commonDao.selectList("knld.leasHous.retrieveLeasHousSearchList", input);
	}
	
	/**
	 * 임차주택관리 > 상세화면 상세조회
	 * @param input
	 * @return
	 */
	public Map<String, Object> retrieveLeasHousDtlInfo(HashMap<String, Object> input){
		Map<String, Object> leasInfo = new HashMap<String, Object>();
		
		if( "".equals(input.get("leasId"))){
			leasInfo = commonDao.select("knld.leasHousMgmt.retrieveAttchFilInfo", input);
		}else{
			leasInfo = commonDao.select("knld.leasHous.retrieveLeasHousDtlInfo", input);
		}
		
		return leasInfo;
	}

	/**
	 * 임차주택관리 > 임차주택관리 저장
	 * @param input
	 * @throws Exception 
	 */
	public String saveLeasHousInfo(Map<String, Object> leasHousInfo) throws Exception {
		String leasId;
		
		if( leasHousInfo.get("leasId") == null ||  "".equals(leasHousInfo.get("leasId"))  ){
			leasId = commonDao.select("knld.leasHous.getLeasId", leasHousInfo);
			leasHousInfo.put("leasId", leasId);
		}else{
			leasId = (String) leasHousInfo.get("leasId");
		}
		//mst update 
		if( commonDao.update("knld.leasHous.saveLeasHousMstInfo", leasHousInfo) > 0 ){
			if(   commonDao.update("knld.leasHous.saveLeasHousDtlInfo", leasHousInfo) > 0  ){
			}else{
				throw new Exception("임차주택 기본정보 저장중 오류가 발생했습니다.");
			}
		}else{
			throw new Exception("임차주택 상세정보 저장중 오류가 발생했습니다");
		}
		
		return leasId;
	}
	
	/**
	 * 임차주택관리 > 임차주택관리 검토요청 업데이트
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	public String updateLeasHousSt(HashMap<String, Object> input) throws Exception {
		String leasId = (String) input.get("leasId");
		
		MailSender mailSender = mailSenderFactory.createMailSender();
		LeasHousVo vo = new LeasHousVo();
		Map<String, Object> mailInfo = new HashMap<String,Object>();
		
		input.put("pgsStCd", "PRI" );
		input.put("reqStCd", "RQ");
		
		if(   commonDao.update("knld.leasHous.updateLeasHousSt", input) > 0  ){
			//메일 발송
			String rvwNm ="정명봉";
			String revMail ="mbjung@lghausys.com";
			String mailTitl = "임차주택  사전검토 신청 메일입니다.";
			
			mailSender.setToMailAddress( revMail , rvwNm);
			mailSender.setFromMailAddress( input.get("_userEmail").toString(), input.get("_userNm").toString());
			mailSender.setSubject(mailTitl);
			
			vo.setLeasId( (String) input.get("leasId"));
			vo.setReqNm( (String) input.get("_userNm"));
			vo.setRvwNm(rvwNm); 
			vo.setJobxNm((String) input.get("_userJobxName")); 
			vo.setRvwCmmt("");
			vo.setRvwStNm("");
			
			mailSender.setHtmlTemplate("leasHousRvw", vo);
			mailSender.send(); 
			
			mailInfo.put("menuType", "LeasHous");
			mailInfo.put("mailTitl", mailTitl);
			mailInfo.put("adreMail", revMail);
			mailInfo.put("trrMail", input.get("_userEmail"));
			mailInfo.put("_userId", input.get("_userId"));
			mailInfo.put("_userEmail", input.get("_userEmail"));
			
			mailInfoService.insertMailSndHist(mailInfo);
		}else{
			throw new Exception("임차주택 기본정보 저장중 오류가 발생했습니다.");
		}
		
		return leasId;
	}
	
	/**
	 * 임차주택관리 > 임차주택관리 검토 결과 업데이트
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 */
	public void updateLeasHousPriSt(Map<String, Object> leasHousInfo) throws Exception {
		
		MailSender mailSender = mailSenderFactory.createMailSender();
		LeasHousVo vo = new LeasHousVo();
		Map<String, Object> mailInfo = new HashMap<String,Object>();
		
		Map<String, Object> sndMailInfo = commonDao.select("knld.leasHous.retrieveSendMailInfo", leasHousInfo);
		
		if( commonDao.update("knld.leasHous.updateLeasHousSt", leasHousInfo) > 0  ){
			if(  commonDao.update("knld.leasHous.updateLeasHousCnrRvwCmmt", leasHousInfo) > 0  ){
				//메일 발송
				String rvwNm ="정명봉";
				String revMail ="mbjung@lghausys.com";
				String mailTitl = "임차주택 시전검토결과 메일입니다.";
				
				mailSender.setToMailAddress( (String) sndMailInfo.get("email") , (String) sndMailInfo.get("saName"));
				mailSender.setFromMailAddress(revMail, rvwNm );
				mailSender.setSubject(mailTitl);
				
				vo.setLeasId( (String) leasHousInfo.get("leasId"));
				vo.setReqNm( (String) leasHousInfo.get("empNm"));
				vo.setRvwNm(rvwNm); 
				vo.setRvwCmmt((String) leasHousInfo.get("rvwCmmt"));
				vo.setJobxNm((String) sndMailInfo.get("jobxNm")); 
				
				if( leasHousInfo.get("reqStCd").equals("APPR")){
					vo.setRvwStNm("승인");
				}else{
					vo.setRvwStNm("반려");
				}
				
				mailSender.setHtmlTemplate("leasHousRvwRpl", vo);
				mailSender.send(); 
				
				mailInfo.put("menuType", "lHR");
				mailInfo.put("mailTitl", mailTitl);
				mailInfo.put("adreMail", sndMailInfo.get("email") );
				mailInfo.put("trrMail", revMail );
				mailInfo.put("_userId", leasHousInfo.get("userId"));
				mailInfo.put("_userEmail", revMail);
				
				mailInfoService.insertMailSndHist(mailInfo);
			}else{
				throw new Exception("임차주택 검토상태 저장중 오류가 발생했습니다.");
			}
		}else{
			throw new Exception("임차주택 검토내용 저장중 오류가 발생했습니다.");
		}
	}
	
	/**
	 * 임차주택관리 > 임차주택관리 계약검토 신청 업데이트
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 * @throws Exception 
	 */
	public void updateLeasHousCnrReq(Map<String, Object> leasHousInfo) throws Exception{
		
		MailSender mailSender = mailSenderFactory.createMailSender();
		LeasHousVo vo = new LeasHousVo();
		Map<String, Object> mailInfo = new HashMap<String,Object>();
		
		Map<String, Object> sndMailInfo = commonDao.select("knld.leasHous.retrieveSendMailInfo", leasHousInfo);
		
		if(  commonDao.update("knld.leasHous.updateLeasHousCnrSt", leasHousInfo) > 0   ){
			if( commonDao.update("knld.leasHous.updateLeasHousSt", leasHousInfo) > 0  ){
				//메일 발송
				String rvwNm ="정명봉";
				String revMail ="mbjung@lghausys.com";
				String mailTitl = "임차주택 계약서검토 신청 메일입니다.";
				
				mailSender.setToMailAddress( revMail , rvwNm);
				mailSender.setFromMailAddress( (String) sndMailInfo.get("email"), (String) sndMailInfo.get("saName") );
				mailSender.setSubject(mailTitl);
				
				vo.setLeasId( (String) leasHousInfo.get("leasId"));
				vo.setReqNm( (String) leasHousInfo.get("empNm"));
				vo.setRvwNm(rvwNm); 
				vo.setJobxNm((String) sndMailInfo.get("jobxNm")); 
				vo.setRvwCmmt("");
				vo.setRvwStNm("");
				
				mailSender.setHtmlTemplate("leasHousCnrRvw", vo);
				mailSender.send(); 
				
				mailInfo.put("menuType", "lhCnr");
				mailInfo.put("mailTitl", mailTitl);
				mailInfo.put("adreMail", revMail);
				mailInfo.put("trrMail", sndMailInfo.get("email")  );
				mailInfo.put("_userId", leasHousInfo.get("userId"));
				mailInfo.put("_userEmail", sndMailInfo.get("email"));
				
				mailInfoService.insertMailSndHist(mailInfo);
			}else{
				throw new Exception("임차주택 계약검토 신청중 오류가 발생했습니다.");
			}
		}else{
			throw new Exception("임차주택 계약검토 신청중 오류가 발생했습니다.");
		}
	}
		
	/**
	 * 임차주택관리 > 임차주택관리 계약검토 승인 업데이트
	 * @param input
	 * @param request
	 * @param session
	 * @param model
	 * @return
	 * @throws Exception 
	 */
	public void updateLeasHousCnrSt(Map<String, Object> leasHousInfo) throws Exception {
		MailSender mailSender = mailSenderFactory.createMailSender();
		LeasHousVo vo = new LeasHousVo();
		Map<String, Object> mailInfo = new HashMap<String,Object>();
		
		Map<String, Object> sndMailInfo = commonDao.select("knld.leasHous.retrieveSendMailInfo", leasHousInfo);
		
		if( commonDao.update("knld.leasHous.updateLeasHousSt", leasHousInfo) > 0  ){
			if(  commonDao.update("knld.leasHous.updateLeasHousCnrCrnCmmt", leasHousInfo) > 0  ){
				//메일 발송
				String rvwNm ="정명봉";
				String revMail ="mbjung@lghausys.com";
				String mailTitl = "임차주택 계약서검토결과 메일입니다.";
				
				mailSender.setToMailAddress( (String) sndMailInfo.get("email") , (String) sndMailInfo.get("saName"));
				mailSender.setFromMailAddress(revMail, rvwNm );
				mailSender.setSubject(mailTitl);
				
				vo.setLeasId( (String) leasHousInfo.get("leasId"));
				vo.setReqNm( (String) leasHousInfo.get("empNm"));
				vo.setRvwNm(rvwNm); 
				vo.setRvwCmmt((String) leasHousInfo.get("crnCmmt"));
				vo.setJobxNm((String) sndMailInfo.get("jobxNm")); 
				
				if( leasHousInfo.get("reqStCd").equals("APPR")){
					vo.setRvwStNm("승인");
				}else{
					vo.setRvwStNm("반려");
				}
				
				mailSender.setHtmlTemplate("leasHousRvwRpl", vo);
				mailSender.send(); 
				
				mailInfo.put("menuType", "lHR");
				mailInfo.put("mailTitl", mailTitl);
				mailInfo.put("adreMail", sndMailInfo.get("email") );
				mailInfo.put("trrMail", revMail );
				mailInfo.put("_userId", leasHousInfo.get("userId"));
				mailInfo.put("_userEmail", revMail);
				
				mailInfoService.insertMailSndHist(mailInfo);
			}else{
				throw new Exception("임차주택 검토상태 저장중 오류가 발생했습니다.");
			}
		}else{
			throw new Exception("임차주택 검토내용 저장중 오류가 발생했습니다.");
		}
		
	}
	
	
	
	
	
	
	
	
	
}
