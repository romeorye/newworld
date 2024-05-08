package iris.web.prj.tss.rfp.service;

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
import iris.web.common.mail.service.MailInfoService;
import iris.web.common.util.StringUtil;
import iris.web.prj.tss.rfp.vo.RfpReqFormVo;

@Service("rfpInfoService")
public class RfpInfoServiceImpl  implements RfpInfoService{

static final Logger LOGGER = LogManager.getLogger(RfpInfoServiceImpl.class);
	
	@Resource(name="commonDao")
	private CommonDao commonDao;
	
	@Resource(name="mailSenderFactory")
    private MailSenderFactory mailSenderFactory;
	
	@Resource(name="mailInfoService")
    private MailInfoService mailInfoService;
	 
	/**
     * 연구과제 > RFP요청서 > 요청서 목록 조회
     * */
	public List<Map<String, Object>> retrieveRfpSearchList(HashMap<String, Object> input){
		return commonDao.selectList("prj.tss.rfp.retrieveRfpSearchList", input);
	}
	
	/**
     * 연구과제 > RFP요청서 > 요청서 조회
     * */
	public Map<String, Object> retrieveRfpInfo(HashMap<String, Object> input){
		return commonDao.select("prj.tss.rfp.retrieveRfpInfo", input);
	}
	
	/**
     * 연구과제 > RFP요청서 > 요청서 등록 및 수정
     * */
	public void saveRfpInfo(Map<String, Object> saveDataSet){
		commonDao.update("prj.tss.rfp.saveRfpInfo", saveDataSet);
	}
	
	/**
     * 연구과제 > RFP요청서 > 요청서삭제
     * */
	public void deleteRfpInfo(HashMap<String, Object> input){
		commonDao.update("prj.tss.rfp.deleteRfpInfo", input);
	}
	
	/**
	 * 연구과제 > RFP요청서 > 요청서제출
	 * */
	public void submitRfpInfo(HashMap<String, Object> input){
		commonDao.update("prj.tss.rfp.submitRfpInfo", input);
		
		RfpReqFormVo vo = new  RfpReqFormVo();
		
		Map<String, Object> retrieveRfpInfo = retrieveRfpInfo(input); 
		//메일 발송
		MailSender mailSender = mailSenderFactory.createMailSender();
		
		mailSender.setFromMailAddress("iris@lxhausys.com");
        mailSender.setToMailAddress("jihyunlee@lxhausys.com");
        mailSender.setSubject(" RFP요청서 제출");
        
        StringUtil.toUtf8Output((HashMap) retrieveRfpInfo);
        vo.setTitle((String)retrieveRfpInfo.get("title"));  
        vo.setReqDate((String)retrieveRfpInfo.get("reqDate"));  
        vo.setRsechEngn((String)retrieveRfpInfo.get("rsechEngn"));  
        vo.setDescTclg(retrieveRfpInfo.get("descTclg").toString().replace("\n", "<br/>"));  
        vo.setExptAppl(retrieveRfpInfo.get("exptAppl").toString().replace("\n", "<br/>"));  
        vo.setMainReq(retrieveRfpInfo.get("mainReq").toString().replace("\n", "<br/>"));  
        vo.setBenchMarkTclg(retrieveRfpInfo.get("benchMarkTclg").toString().replace("\n", "<br/>"));	
        vo.setColaboTclg(retrieveRfpInfo.get("colaboTclg").toString().replace("\n", "<br/>"));  
       
        String[] colArry = retrieveRfpInfo.get("colaboTclg").toString().split(",");
        
        for(int i=0; i < colArry.length; i++ ){
        	if(colArry[i].equals("JR") ){
        		vo.setJr("checked");
        	}else if(colArry[i].equals("CS") ){
        		vo.setCs("checked");
        	}else if(colArry[i].equals("IO") ){
        		vo.setIo("checked");
        	}else if(colArry[i].equals("SS") ){
        		vo.setSs("checked");
        	}else if(colArry[i].equals("MA") ){
        		vo.setMa("checked");
        	}else if(colArry[i].equals("BT") ){
        		vo.setBt("checked");
        	}
        }
			
        vo.setTimeline(retrieveRfpInfo.get("timeline").toString().replace("\n", "<br/>"));  
        vo.setComments(retrieveRfpInfo.get("comments").toString().replace("\n", "<br/>"));  
        vo.setCompanyNm(retrieveRfpInfo.get("companyNm").toString().replace("\n", "<br/>"));  
        vo.setPjtImgView((String)retrieveRfpInfo.get("pjtImgView"));  
      
        mailSender.setHtmlTemplate("mailRfpReqFormhtml", vo );
        mailSender.send(); 
        
        HashMap<String, Object> mailMap = new HashMap<String, Object>();
        mailMap.put("mailTitl", " RFP요청서 제출");
        mailMap.put("adreMail", "jihyunlee@lxhausys.com");
        mailMap.put("trrMail", "iris@lxhausys.com");
        mailMap.put("_userId", input.get("_userId").toString());
       
        mailInfoService.insertMailSndHist(mailMap);
		
	}
}
