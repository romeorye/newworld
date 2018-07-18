package iris.web.mchn.open.eduAnl.service;

import java.util.ArrayList;
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
import iris.web.mchn.open.edu.service.MchnEduServiceImpl;
import iris.web.mchn.open.eduAnl.vo.MchnEduAnlVo;

@Service("mchnEduAnlService")
public class MchnEduAnlServiceImpl implements MchnEduAnlService{
	@Resource(name="commonDao")
	private CommonDao commonDao;
	static final Logger LOGGER = LogManager.getLogger(MchnEduServiceImpl.class);

	@Resource(name="mailSenderFactory")
	private MailSenderFactory mailSenderFactory;	// 메일전송 팩토리
	
	
	/* open기기 > 기기교육 > 기기교육관리 목록조회*/
	public List<Map<String, Object>> retrieveMchnEduAnlSearchList(HashMap<String, Object> input){
		List<Map<String, Object>> resultList = commonDao.selectList("open.mchnEduAnl.retrieveMchnEduAnlSearchList", input);
		return resultList;
	}

	/* open기기 > 기기교육 > 기기교육관리 상세조회 */
	public HashMap<String, Object> retrieveEduInfo(HashMap<String, Object> input){
		HashMap<String, Object> result = commonDao.select("open.mchnEduAnl.retrieveEduInfo", input);
		return result;
	}

	/* open기기 > 기기교육 > 기기교육관리 > 신규등록 > 분석기기 팝업 목록조회 */
	public List<Map<String, Object>> retrieveMachineList(HashMap<String, Object> input){
		List<Map<String, Object>> resultList = commonDao.selectList("open.mchnEduAnl.retrieveMachineList", input);
		return resultList;
	}

	/* open기기 > 기기교육 > 기기교육관리 > 신규등록 > 기기교육 삭제 */
	public void updateEduInfo(HashMap<String, Object> input){
		commonDao.selectList("open.mchnEduAnl.updateEduInfo", input);
	}

	/* open기기 > 기기교육 > 기기교육관리 > 신규등록 > 기기교육 등록 및 수정 */
	public void saveEduInfo(HashMap<String, Object> input){
		commonDao.update("open.mchnEduAnl.saveEduInfo", input);
	}

	/*  open기기 > 기기교육 > 기기교육관리 > 교육신청관리 화면 조회 */
	public List<Map<String, Object>> retrieveMchnEduAnlRgstList(HashMap<String, Object> input){
		List<Map<String, Object>> resultList = commonDao.selectList("open.mchnEduAnl.retrieveMchnEduAnlRgstList", input);
		return resultList;
	}

	/*  open기기 > 기기교육 > 기기교육관리 > 교육신청관리 화면 조회 (엑셀용) */
	public List<Map<String, Object>> retrieveMchnEduAnlRgstListExcel(HashMap<String, Object> input){
		List<Map<String, Object>> resultList = commonDao.selectList("open.mchnEduAnl.retrieveMchnEduAnlRgstListExcel", input);
		return resultList;
	}

	/* open기기 > 기기교육 > 기기교육관리 > 교육신청관리 수료, 미수료 업데이트 */
	public void updateEduDetailInfo(List<Map<String, Object>> inputList, HashMap<String, Object> input)  throws Exception{
		MchnEduAnlVo vo = new MchnEduAnlVo();
		MailSender mailSender = mailSenderFactory.createMailSender(); 
		
		List<Map<String,Object>> mailList = new ArrayList<Map<String,Object>>();
		
		String arrRecMailAddr[] = String.valueOf(input.get("chkRecMailAddr")).split(",");
		String arrRgstNm[] = String.valueOf(input.get("chkRgstNm")).split(",");

		if(commonDao.batchUpdate("open.mchnEduAnl.updateEduDetailInfo", inputList) > 0 ){
			//메일 전송
			for(int i = 0; i < arrRecMailAddr.length  ; i++){
				Map<String,Object> mailMap = new HashMap<String, Object>();
				mailSender.setFromMailAddress( input.get("_userEmail").toString(), input.get("_userNm").toString());
				mailSender.setToMailAddress(arrRecMailAddr[i], arrRgstNm[i]);
				mailSender.setSubject(NullUtil.nvl(input.get("mailTitl").toString(),""));
				
				vo.setEduNm(NullUtil.nvl(input.get("eduNm").toString(),""));
				vo.setEduCrgrNm(NullUtil.nvl(input.get("eduCrgrNm").toString(),""));
				vo.setEduStNm(input.get("eduStNm").toString());
				// mailSender-context.xml에 설정한 메일 template의 bean id값과 치환시 사용될 VO클래스를 넘김
				mailSender.setHtmlTemplate("mchnEduCoures", vo);
				mailSender.send(); 
				
				mailMap.put("menuType", NullUtil.nvl(input.get("menuType").toString(),""));
				mailMap.put("mailTitl", NullUtil.nvl(input.get("mailTitl").toString(),""));
				mailMap.put("adreMail", arrRecMailAddr[i] );
				mailMap.put("rfpMail", "");
				mailMap.put("trrMail", input.get("_userEmail").toString());
				mailMap.put("_userId", input.get("_userId").toString());
				
				mailList.add(mailMap);
			}
			
			commonDao.batchInsert("open.mchnEduAnl.insertMailHis", mailList);
			
		}else{
			throw new Exception("저장중 오류가발생하였습니다.");
		}
		
	}
	
	/* 메일발송 history
	public void insertMailHis(List<Map<String, Object>> mailList){
		
	}
	*/
}
