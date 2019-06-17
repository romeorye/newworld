package iris.web.mchn.open.mchn.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.stereotype.Service;

import devonframe.configuration.ConfigService;
import devonframe.dataaccess.CommonDao;
import devonframe.mail.MailSender;
import devonframe.mail.MailSenderFactory;
import devonframe.util.NullUtil;
import iris.web.common.mail.service.MailInfoService;
import iris.web.fxa.anl.service.FxaAnlServiceImpl;
import iris.web.mchn.open.mchn.vo.MchnInfoVo;

@Service("mchnInfoService")
public class MchnInfoServiceImpl implements MchnInfoService {

	static final Logger LOGGER = LogManager.getLogger(FxaAnlServiceImpl.class);

	@Resource(name="commonDao")
	private CommonDao commonDao;
	
	@Resource(name = "configService")
    private ConfigService configService;
	
	@Resource(name="mailSenderFactory")
	private MailSenderFactory mailSenderFactory;	// 메일전송 팩토리
	
	@Resource(name="mailInfoService")
    private MailInfoService mailInfoService;
	
	
	/**
	 * 보유기기 리스트 조회
	 * @param input
	 * @return
	 */
	public List<Map<String, Object>> retrieveMchnInfoSearchList(HashMap<String, Object> input){
		List<Map<String, Object>> mchnList = commonDao.selectList("open.mchnInfo.retrieveMchnInfoSearchList", input);
		return mchnList;
	}
	
	/**
	 * 보유기기 Detail 화면 조회
	 * @param input
	 * @return
	 */
	public HashMap<String, Object> retrieveMchnInfoDtl(HashMap<String, Object> input) throws Exception{
		HashMap<String, Object> rtnMap = commonDao.select("open.mchnInfo.retrieveMchnInfoDtl", input);

		input.put("rgstId", input.get("userSabun"));
		
		HashMap<String, Object> eduMap = new HashMap<String, Object>();
		eduMap = commonDao.select("open.mchnInfo.retrieveMchnEduInfo", input); 
		
		if( eduMap != null  ){
			rtnMap.put("ccsDt", eduMap.get("ccsDt"));
			rtnMap.put("eduStNm", eduMap.get("eduStNm"));
			rtnMap.put("eduStCd", eduMap.get("eduStCd"));
		}
		
		return rtnMap;
	}
	
	/**
	 * 보유기기 예약 신규 및 Detail 화면조회
	 * @param input
	 * @return
	 */
	public HashMap<String, Object> retrieveMchnPrctInfo(HashMap<String, Object> input)  throws Exception{
		//기기정보 조회
		HashMap<String, Object> rtnMap = new HashMap<String, Object>();
		
		if( !"".equals(input.get("mchnPrctId"))){
			rtnMap = commonDao.select("open.mchnInfo.retrieveMchnPrctInfo", input); 
			input.put("rgstId", rtnMap.get("rgstId"));
		
		}else{
			rtnMap = commonDao.select("open.mchnInfo.retrieveMchnInfoDtl", input);
			input.put("rgstId", input.get("_userSabun"));
		}
		
		HashMap<String, Object> eduMap = new HashMap<String, Object>();
		
		eduMap = commonDao.select("open.mchnInfo.retrieveMchnEduInfo", input); 
		
		if( eduMap != null  ){
			rtnMap.put("ccsDt", eduMap.get("ccsDt"));
			rtnMap.put("eduStCd", eduMap.get("eduStCd"));
			rtnMap.put("eduStNm", eduMap.get("eduStNm"));
		}
		
		return rtnMap; 
	}

	//calender 일정 조회
	public List<Map<String, Object>> retrieveMchnPrctCalInfo(HashMap<String, Object> input){
		return commonDao.selectList("open.mchnInfo.retrieveMchnPrctCalInfo", input);
	}
	
	/**
	 * 보유기기 예약 신규 및 수정
	 * @param input
	 * @return
	 * @throws Exception 
	 */
	public void saveMchnPrctInfo(Map<String, Object> mchnPrctInfo)  throws Exception{
		//기존 예약시간 중복 체크
		int chkPrct = commonDao.select("open.mchnInfo.checkPrctInfo", mchnPrctInfo);
		
		if( chkPrct  >   0 ){
			int chkId =  commonDao.select("open.mchnInfo.checkPrctId", mchnPrctInfo);
			
			if( chkId > 0 ){
				throw new Exception("기존 예약건이 존재합니다.");
			}
		}
		
		MchnInfoVo vo = new MchnInfoVo();
		
        MailSender mailSender = mailSenderFactory.createMailSender(); 
        
        if(commonDao.update("open.mchnInfo.saveMchnPrctInfo", mchnPrctInfo) > 0){
			//기기예약신청 담당자에게 메일 발송
			mailSender.setFromMailAddress( mchnPrctInfo.get("_userEmail").toString(), mchnPrctInfo.get("_userNm").toString());
			mailSender.setToMailAddress( mchnPrctInfo.get("crgrMail").toString() , mchnPrctInfo.get("crgrNm").toString());
			mailSender.setSubject(NullUtil.nvl(mchnPrctInfo.get("mailTitl").toString(),""));
			
			vo.setRgstNm(NullUtil.nvl(mchnPrctInfo.get("_userNm").toString(),""));
			vo.setMchnHanNm(NullUtil.nvl(mchnPrctInfo.get("mchnHanNm").toString(),""));
			vo.setMchnEnNm(NullUtil.nvl(mchnPrctInfo.get("mchnEnNm").toString(),""));
			vo.setPrctFromHH(NullUtil.nvl(mchnPrctInfo.get("prctFromHH").toString(),""));
			vo.setPrctFrommm(mchnPrctInfo.get("prctFrommm").toString());
			vo.setPrctToHH(mchnPrctInfo.get("prctToHH").toString());
			vo.setPrctTomm(mchnPrctInfo.get("prctTomm").toString());
			vo.setPrctFromTim(mchnPrctInfo.get("prctFromTim").toString());
			vo.setPrctToTim(mchnPrctInfo.get("prctToTim").toString());
			vo.setPrctDt(mchnPrctInfo.get("prctDt").toString());
			// mailSender-context.xml에 설정한 메일 template의 bean id값과 치환시 사용될 VO클래스를 넘김
			mailSender.setHtmlTemplate("mchnApprInfo", vo);
			mailSender.send(); 
			
			mchnPrctInfo.put("menuType", "mchn");
			mchnPrctInfo.put("mailTitl", NullUtil.nvl(mchnPrctInfo.get("mailTitl").toString(),""));
			mchnPrctInfo.put("adreMail", mchnPrctInfo.get("crgrMail").toString());
			mchnPrctInfo.put("trrMail",  mchnPrctInfo.get("_userEmail").toString());
			mchnPrctInfo.put("_userId", mchnPrctInfo.get("_userId").toString());
			mchnPrctInfo.put("_userEmail", mchnPrctInfo.get("_userEmail").toString());
			
			mailInfoService.insertMailSndHist(mchnPrctInfo);
			
		}else{
			throw new Exception("예약 요청중 오류가 발생했습니다. 관리자에게 문의하세요");
		}
	}
	
	/**
	 * 보유기기 예약 삭제
	 * @param input
	 * @return
	 * @throws Exception 
	 */
	public void deleteMchnPrctInfo(HashMap<String, Object> input){
		commonDao.update("open.mchnInfo.deleteMchnPrctInfo", input);
	}
	
}
