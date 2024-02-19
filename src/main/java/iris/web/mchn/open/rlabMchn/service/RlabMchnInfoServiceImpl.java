package iris.web.mchn.open.rlabMchn.service;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
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
import iris.web.fxa.anl.service.FxaAnlServiceImpl;
import iris.web.mchn.open.rlabMchn.vo.RlabMchnInfoVo;

@Service("rlabMchnInfoService")
public class RlabMchnInfoServiceImpl implements RlabMchnInfoService {

	static final Logger LOGGER = LogManager.getLogger(FxaAnlServiceImpl.class);

	@Resource(name="commonDao")
	private CommonDao commonDao;

	@Resource(name = "configService")
    private ConfigService configService;

	@Resource(name="mailSenderFactory")
	private MailSenderFactory mailSenderFactory;	// 메일전송 팩토리

	/**
	 * 보유장비 리스트 조회
	 * @param input
	 * @return
	 */
	public List<Map<String, Object>> retrieveMchnInfoSearchList(HashMap<String, Object> input){
		List<Map<String, Object>> mchnList = commonDao.selectList("open.rlabMchnInfo.retrieveMchnInfoSearchList", input);
		return mchnList;
	}

	/**
	 * 보유장비 Detail 화면 조회
	 * @param input
	 * @return
	 */
	public HashMap<String, Object> retrieveMchnInfoDtl(HashMap<String, Object> input) throws Exception{
		HashMap<String, Object> rtnMap = commonDao.select("open.rlabMchnInfo.retrieveMchnInfoDtl", input);
		return rtnMap;
	}

	/**
	 * 보유장비 예약 신규 및 Detail 화면조회
	 * @param input
	 * @return
	 */
	public HashMap<String, Object> retrieveMchnPrctInfo(HashMap<String, Object> input)  throws Exception{
		HashMap<String, Object> rtnMap = commonDao.select("open.rlabMchnInfo.retrieveMchnPrctInfo", input);
		return rtnMap;
	}

	//calender 일정 조회
	public List<Map<String, Object>> retrieveMchnPrctCalInfo(HashMap<String, Object> input){

		String mchnClCd2 = input.get("mchnClCd2").toString();
		String selectUrl = "";
		if(mchnClCd2.equals("01") || mchnClCd2.equals("02")){
			selectUrl = "open.rlabMchnInfo.retrieveMchnPrctCalInfo2";
		} else if(mchnClCd2.equals("03")){
			selectUrl = "open.rlabMchnInfo.retrieveMchnPrctCalInfo";
		}

		return commonDao.selectList(selectUrl, input);
	}

	/**
	 * 보유장비 예약 신규 및 수정
	 * @param input
	 * @return
	 * @throws Exception
	 */
	public void saveMchnPrctInfo(HashMap<String, Object> input)  throws Exception{

		String mchnClCd = input.get("mchnClCd").toString();
		int chkPrct = 0;

		if(mchnClCd.equals("02")){
			chkPrct = commonDao.select("open.rlabMchnInfo.checkRlabSmpoQty", input);
		}

		if( chkPrct  >   0 ){
			throw new Exception("시료수가 초과 되었습니다.");
		}

		chkPrct = 0;
		//기존 예약시간 중복 체크
		if(mchnClCd.equals("01")){
			chkPrct = commonDao.select("open.rlabMchnInfo.checkRlabPrctInfo", input);
		} else if(mchnClCd.equals("02")){
			chkPrct = commonDao.select("open.rlabMchnInfo.checkRlabPrctInfo2", input);
		} else if(mchnClCd.equals("03")){
			chkPrct = commonDao.select("open.rlabMchnInfo.checkPrctInfo", input);
		}

		if( chkPrct  >   0 ){
			throw new Exception("기존 예약건이 존재합니다.");
		}

        MailSender mailSender = mailSenderFactory.createMailSender();
        RlabMchnInfoVo vo = new RlabMchnInfoVo();
        //LOGGER.debug("#############################input######################################################## : "+ input);
        if(commonDao.update("open.rlabMchnInfo.saveMchnPrctInfo", input) > 0){

        	input.put("mchnPrctId", commonDao.select("open.rlabMchnInfo.getMchnPrctId", input));

        	if(mchnClCd.equals("01")||mchnClCd.equals("02")){
	    	    String[] result = getDiffDays(input.get("prctFromDt").toString(), input.get("prctToDt").toString() );
	    	    for( int i = 0; i < result.length; i++ )
	    	    {
	    	         input.put("prctDt", result[i]);
	    	         commonDao.insert("open.rlabMchnInfo.saveMchnPrctDetail", input);
	    	    }
        	}

			//장비예약신청 담당자에게 메일 발송
			mailSender.setFromMailAddress( input.get("_userEmail").toString(), input.get("_userNm").toString());
			mailSender.setToMailAddress( input.get("toMailAddr").toString().split(","));
			mailSender.setSubject(NullUtil.nvl(input.get("mailTitl").toString(),""));

			vo.setRgstNm(NullUtil.nvl(input.get("_userNm").toString(),""));
			vo.setMchnHanNm(NullUtil.nvl(input.get("mchnHanNm").toString(),""));
			vo.setMchnEnNm(NullUtil.nvl(input.get("mchnEnNm").toString(),""));
			vo.setRsrtDivnCd(input.get("rsrtDivnCd").toString());
			vo.setPrctDt(input.get("prctDt").toString());

			vo.setPrctFromDt(NullUtil.nvl(input.get("prctFromDt"),""));
			vo.setPrctToDt(NullUtil.nvl(input.get("prctToDt"),""));

			vo.setPrctFromHH(NullUtil.nvl(input.get("prctFromHH"),""));
			vo.setPrctFrommm(NullUtil.nvl(input.get("prctFrommm"),""));
			vo.setPrctToHH(NullUtil.nvl(input.get("prctToHH"),""));
			vo.setPrctTomm(NullUtil.nvl(input.get("prctTomm"),""));
			vo.setPrctFromTim(NullUtil.nvl(input.get("prctFromTim"),""));
			vo.setPrctToTim(NullUtil.nvl(input.get("prctToTim"),""));

			vo.setTestSpceCd(NullUtil.nvl(input.get("testSpceCd"),""));
			vo.setTestCnd01(NullUtil.nvl(input.get("testCnd01"),""));
			vo.setTestCnd02(NullUtil.nvl(input.get("testCnd02"),""));
			vo.setCyclFlag(NullUtil.nvl(input.get("cyclFlag"),""));

			// mailSender-context.xml에 설정한 메일 template의 bean id값과 치환시 사용될 VO클래스를 넘김
			//mailSender.setHtmlTemplate("mchnApprInfo", vo);
			if(mchnClCd.equals("01")){
				mailSender.setHtmlTemplate("rlabMchnAppr01", vo);
			} else if(mchnClCd.equals("02")){
				mailSender.setHtmlTemplate("rlabMchnAppr02", vo);
			} else if(mchnClCd.equals("03")){
				mailSender.setHtmlTemplate("rlabMchnAppr03", vo);
			}

			mailSender.send();

    		HashMap<String, Object> inputM = new HashMap<String, Object>();

			inputM.put("mailTitl", NullUtil.nvl(input.get("mailTitl").toString(),""));
			inputM.put("adreMail", input.get("toMailAddr").toString());
			inputM.put("trrMail",  input.get("_userEmail").toString());
			inputM.put("rfpMail",  "");
			inputM.put("_userId", input.get("_userId").toString());
			inputM.put("_userEmail", input.get("_userEmail").toString());

			/* 전송메일 정보 hist 저장*/
			commonDao.update("open.mchnAppr.insertMailHist", inputM);

		}else{
			throw new Exception("처리중 오류가 발생했습니다. 관리자에게 문의하세요");
		}
	}

	/**
	 * 보유장비 예약 삭제
	 * @param input
	 * @return
	 * @throws Exception
	 */
	public void deleteMchnPrctInfo(HashMap<String, Object> input){
		commonDao.update("open.rlabMchnInfo.deleteMchnPrctInfo", input);
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
