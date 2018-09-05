package iris.web.mchn.open.spaceMchn.service;

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
import iris.web.mchn.open.spaceMchn.vo.SpaceMchnInfoVo;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;

@Service("spaceMchnInfoService")
public class SpaceMchnInfoServiceImpl implements SpaceMchnInfoService {

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
		List<Map<String, Object>> mchnList = commonDao.selectList("open.spaceMchnInfo.retrieveMchnInfoSearchList", input);
		return mchnList;
	}
	
	/**
	 * 보유기기 Detail 화면 조회
	 * @param input
	 * @return
	 */
	public HashMap<String, Object> retrieveMchnInfoDtl(HashMap<String, Object> input) throws Exception{
		HashMap<String, Object> rtnMap = commonDao.select("open.spaceMchnInfo.retrieveMchnInfoDtl", input);
		return rtnMap;
	}
	
	/**
	 * 보유기기 예약 신규 및 Detail 화면조회
	 * @param input
	 * @return
	 */
	public HashMap<String, Object> retrieveMchnPrctInfo(HashMap<String, Object> input)  throws Exception{
		HashMap<String, Object> rtnMap = commonDao.select("open.spaceMchnInfo.retrieveMchnPrctInfo", input); 
		return rtnMap; 
	}

	//calender 일정 조회
	public List<Map<String, Object>> retrieveMchnPrctCalInfo(HashMap<String, Object> input){
		return commonDao.selectList("open.spaceMchnInfo.retrieveMchnPrctCalInfo", input);
	}
	
	/**
	 * 보유기기 예약 신규 및 수정
	 * @param input
	 * @return
	 * @throws Exception 
	 */
	public void saveMchnPrctInfo(HashMap<String, Object> input)  throws Exception{
		
		int chkPrct = 0;
		
		//기존 예약시간 중복 체크

		chkPrct = commonDao.select("open.spaceMchnInfo.checkPrctInfo", input);

		
		if( chkPrct  >   0 ){
			throw new Exception("기존 예약건이 존재합니다.");
		}
		
        MailSender mailSender = mailSenderFactory.createMailSender(); 
        SpaceMchnInfoVo vo = new SpaceMchnInfoVo();
        //LOGGER.debug("#############################input######################################################## : "+ input);   
        if(commonDao.update("open.spaceMchnInfo.saveMchnPrctInfo", input) > 0){
        	
        	input.put("mchnPrctId", commonDao.select("open.spaceMchnInfo.getMchnPrctId", input));

	    	String[] result = getDiffDays(input.get("prctFromDt").toString(), input.get("prctToDt").toString() );
	    	for( int i = 0; i < result.length; i++ )
	    	{
	    	     input.put("prctDt", result[i]);
	    	     commonDao.insert("open.spaceMchnInfo.saveMchnPrctDetail", input);
	    	}

        	//commonDao.insert("open.spaceMchnInfo.saveMchnPrctDetail", input);

			//기기예약신청 담당자에게 메일 발송
			mailSender.setFromMailAddress( input.get("_userEmail").toString(), input.get("_userNm").toString());
			mailSender.setToMailAddress( input.get("toMailAddr").toString() , input.get("_userEmail").toString());
			mailSender.setSubject(NullUtil.nvl(input.get("mailTitl").toString(),""));
			
			vo.setRgstNm(NullUtil.nvl(input.get("_userNm").toString(),""));
			vo.setMchnHanNm(NullUtil.nvl(input.get("mchnHanNm"),""));
			vo.setMchnEnNm(NullUtil.nvl(input.get("mchnEnNm"),""));
			vo.setPrctDt(input.get("prctDt").toString());
			vo.setPrctFromDt(NullUtil.nvl(input.get("prctFromDt"),""));
			vo.setPrctToDt(NullUtil.nvl(input.get("prctToDt"),""));
			
			// mailSender-context.xml에 설정한 메일 template의 bean id값과 치환시 사용될 VO클래스를 넘김
			mailSender.setHtmlTemplate("spaceMchnAppr", vo);
			mailSender.send(); 
			
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
		commonDao.update("open.spaceMchnInfo.deleteMchnPrctInfo", input);
	}
	
	public static int getDiffDayCount(String fromDate, String toDate) {
		  SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

		  try {
		   return (int) ((sdf.parse(toDate).getTime() - sdf.parse(fromDate)
		     .getTime()) / 1000 / 60 / 60 / 24);
		  } catch (Exception e) {
		   return 0;
		  }
	}
	
	 public static String[] getDiffDays(String fromDate, String toDate) {
		  SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

		  Calendar cal = Calendar.getInstance();

		  try {
		   cal.setTime(sdf.parse(fromDate));
		  } catch (Exception e) {
		  }

		  int count = getDiffDayCount(fromDate, toDate);

		  // 시작일부터
		  cal.add(Calendar.DATE, -1);

		  // 데이터 저장
		  ArrayList<String> list = new ArrayList<String>();

		  for (int i = 0; i <= count; i++) {
		   cal.add(Calendar.DATE, 1);

		   list.add(sdf.format(cal.getTime()));
		  }

		  String[] result = new String[list.size()];

		  list.toArray(result);

		  return result;
		 }


	
}
