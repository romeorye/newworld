package iris.web.mchn.open.mchn.service;

import java.io.File;
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
import iris.web.common.util.CommonUtil;
import iris.web.common.util.NamoMime;
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
		HashMap<String, Object> rtnMap = commonDao.select("open.mchnInfo.retrieveMchnPrctInfo", input); 
		
		input.put("mchnInfoId", rtnMap.get("mchnInfoId"));
		input.put("rgstId", rtnMap.get("rgstId"));
		
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
	public void saveMchnPrctInfo(HashMap<String, Object> input)  throws Exception{
		//기존 예약시간 중복 체크
		int chkPrct = commonDao.select("open.mchnInfo.checkPrctInfo", input);
		
		if( chkPrct  >   0 ){
			throw new Exception("기존 예약건이 존재합니다.");
		}
		
		NamoMime mime = new NamoMime();
		//저장 및 수정
		String dtlSbcHtml = "";
		String dtlSbcHtml_temp = "";
		
		String uploadPath = "";
        String uploadUrl = "";

        uploadUrl =  configService.getString("KeyStore.UPLOAD_URL") + configService.getString("KeyStore.UPLOAD_MCHN");   // 파일명에 세팅되는 경로
        uploadPath = configService.getString("KeyStore.UPLOAD_BASE") + configService.getString("KeyStore.UPLOAD_MCHN");  // 파일이 실제로 업로드 되는 경로

        mime.setSaveURL(uploadUrl);
        mime.setSavePath(uploadPath);
        mime.decode(input.get("dtlSbc").toString());                  // MIME 디코딩
        mime.saveFileAtPath(uploadPath+File.separator);
        dtlSbcHtml = mime.getBodyContent();
        dtlSbcHtml_temp = CommonUtil.replaceSecOutput(CommonUtil.replace(CommonUtil.replace(dtlSbcHtml, "<", "@![!@"),">","@!]!@"));

        input.put("dtlSbc", dtlSbcHtml);

        MailSender mailSender = mailSenderFactory.createMailSender(); 
        MchnInfoVo vo = new MchnInfoVo();
        //LOGGER.debug("#############################input######################################################## : "+ input);   
        if(commonDao.update("open.mchnInfo.saveMchnPrctInfo", input) > 0){
			//기기예약신청 담당자에게 메일 발송
			mailSender.setFromMailAddress( input.get("_userEmail").toString(), input.get("_userNm").toString());
			mailSender.setToMailAddress( input.get("toMailAddr").toString() , input.get("_userEmail").toString());
			mailSender.setSubject(NullUtil.nvl(input.get("mailTitl").toString(),""));
			
			vo.setRgstNm(NullUtil.nvl(input.get("_userNm").toString(),""));
			vo.setMchnHanNm(NullUtil.nvl(input.get("mchnHanNm").toString(),""));
			vo.setMchnEnNm(NullUtil.nvl(input.get("mchnEnNm").toString(),""));
			vo.setPrctFromHH(NullUtil.nvl(input.get("prctFromHH").toString(),""));
			vo.setPrctFrommm(input.get("prctFrommm").toString());
			vo.setPrctToHH(input.get("prctToHH").toString());
			vo.setPrctTomm(input.get("prctTomm").toString());
			vo.setPrctFromTim(input.get("prctFromTim").toString());
			vo.setPrctToTim(input.get("prctToTim").toString());
			vo.setPrctDt(input.get("prctDt").toString());
			// mailSender-context.xml에 설정한 메일 template의 bean id값과 치환시 사용될 VO클래스를 넘김
			mailSender.setHtmlTemplate("mchnApprInfo", vo);
			mailSender.send(); 
			
			input.put("mailTitl", NullUtil.nvl(input.get("mailTitl").toString(),""));
			input.put("adreMail", input.get("toMailAddr").toString());
			input.put("trrMail",  input.get("_userEmail").toString());
			input.put("_userId", input.get("_userId").toString());
			input.put("_userEmail", input.get("_userEmail").toString());
			
			commonDao.insert("open.mchnEduAnl.insertMailHis", input);
		}else{
			throw new Exception("처리중 오류가 발생했습니다. 관리자에게 문의하세요");
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
