package iris.web.prj.grs.service;

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
import iris.web.prj.grs.vo.GrsMailInfoVo;

/*********************************************************************************
 * NAME : GrsReqServiceImpl.java
 * DESC : grsReqServiceImpl
 * PROJ : Iris
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION
 * ----------  ------  ---------------------------------------------------------
 * 2017.08.28  jih	최초생성
 *********************************************************************************/

@Service("grsReqService")
public class GrsReqServiceImpl implements  GrsReqService{

    static final Logger LOGGER = LogManager.getLogger(GrsReqServiceImpl.class);

    @Resource(name="commonDao")
    private CommonDao commonDao;
    
    @Resource(name="commonDaoTodo")
	private CommonDao commonDaoTodo;
    
    @Resource(name="mailSenderFactory")
    private MailSenderFactory mailSenderFactory;
    
    @Override
    public List<Map<String, Object>> retrieveGrsReqList(HashMap<String, Object> input) {
        return commonDao.selectList("prj.grs.retrieveGrsReqList", input);
    }


    //GRS 상세 조회
    @Override
    public Map<String, Object> retrieveGrsEvRslt(HashMap<String, String> input) {
		input.put("beforGrs", (String) commonDao.select("prj.grs.selectIsBeforGrs", input));
        return commonDao.select("prj.grs.retrieveGrsEvRslt", input);
    }

    @Override
    public int insertGrsEvRslt(Map<String, Object> input) {

        //GRS요청 등록
        commonDao.update("prj.grs.insertGrsEvRslt", input);

        String tssCd = (String)input.get("tssCd");
        String tssCdSn = (String)input.get("tssCdSn");

        input.put("reqNo", tssCd + tssCdSn);

        LOGGER.debug("=============== TODO 프로시져호출 ===============");
        commonDaoTodo.insert("prj.grs.insertGrsEvRsltTodo", input);
        int cnt = commonDao.update("prj.tss.com.updateTssMstTssSt", input);
        
        if (cnt > 0 ){
			LOGGER.debug("=============== GRS 메일발송 ===============");
        	grsSendMail(input);
        }
        return cnt;
    }


    //GRS평가항목 목록
    @Override
    public List<Map<String, Object>> retrieveGrsEvStd(HashMap<String, String> input) {
        return commonDao.selectList("prj.grs.retrieveGrsEvStd", input);
    }

    @Override
    public List<Map<String, Object>> retrieveGrsEvStdGrsY() {
        return commonDao.selectList("prj.grs.retrieveGrsEvStdGrsY");
    }


    //GRS평가항목 상세
    @Override
    public List<Map<String, Object>> retrieveGrsEvStdDtl(HashMap<String, String> input) {
        return commonDao.selectList("prj.grs.retrieveGrsEvStdDtl", input);
    }

    @Override
    public int updateGrsEvStdRslt(Map<String, Object> input) {
        return commonDao.update("prj.grs.updateGrsEvStdRslt", input);

    }

    @Override
    public List<Map<String, Object>> retrieveGrsReqDtlLst(HashMap<String, Object> inputMap) {
        return commonDao.selectList("prj.grs.retrieveGrsReqDtlLst", inputMap);
    }

    @Override
    public int updateGrsEvRslt(Map<String, Object> input) {
        return commonDao.update("prj.grs.updateGrsEvRslt", input);
    }

    @Override
    public Map<String, Object> retrieveGrsTodo(HashMap<String, String> input) {
        return commonDao.select("prj.grs.retrieveGrsTodo", input);
    }


    @Override
    public void insertGrsEvRsltSave(List<Map<String, Object>> dsLst, HashMap<String, Object> input) {
		updateGrsEvRslt(input);

        for(Map<String, Object> ds  : dsLst) {
            ds.put("userId", input.get("_userId"));
            ds.put("tssCd", input.get("tssCd"));
            ds.put("tssCdSn", input.get("tssCdSn"));
            updateGrsEvStdRslt(ds);
        }

        String tssCd = (String)input.get("tssCd");
        String tssCdSn = (String)input.get("tssCdSn");

        input.put("reqNo", tssCd + tssCdSn);
        input.put("reqSabun", input.get("_userSabun"));

        LOGGER.debug("=============== TODO 프로시저 호출 ===============");
        commonDaoTodo.insert("prj.grs.insertGrsEvRsltTodo", input);
    }

    
   public boolean grsSendMail(Map<String, Object> input){
	   GrsMailInfoVo vo = new GrsMailInfoVo();
	   MailSender mailSender = mailSenderFactory.createMailSender(); 
	   String reciveMailAddr = input.get("dlbrCrgrId").toString()+"@lghausys.com";
	   
	   Map<String,Object> mailMap = new HashMap<String, Object>();

	   mailSender.setFromMailAddress("iris@lghausys.com", "관리자");
	   mailSender.setToMailAddress(reciveMailAddr, input.get("dlbrCrgrNm").toString());
	   mailSender.setSubject(NullUtil.nvl(input.get("mailTitl").toString(),""));
	   
		// mailSender-context.xml에 설정한 메일 template의 bean id값과 치환시 사용될 VO클래스를 넘김
	    vo.setTssNm(input.get("tssNm").toString()); 
	    vo.setTssCd(input.get("reqNo").toString()); 	//tssCd + tssSnCd
	    vo.setPhNm(input.get("phNm").toString()); 
	    vo.setGrsEvSn(input.get("grsEvSn").toString()); 
	    vo.setTssCdSn(input.get("tssCdSn").toString()); 
		mailSender.setHtmlTemplate("grsSendMail", vo);
		mailSender.send(); 
		
		mailMap.put("menuType", "GRS");
		mailMap.put("mailTitl", NullUtil.nvl(input.get("mailTitl").toString(),""));
		mailMap.put("adreMail", reciveMailAddr );
		mailMap.put("rfpMail", "");
		mailMap.put("trrMail", input.get("userId")+"@lghausys.com");
		mailMap.put("_userId", input.get("userId"));
		
		commonDao.insert("open.mchnEduAnl.insertMailHis", mailMap);
		   
		return true; 
   }
 
   public void updateGrsDecode(HashMap<String, Object> data){
	   commonDao.update("prj.grs.updateGrsDecode", data); 
   }
   
   public List<Map<String, Object>> retrieveGrsDecodeList(HashMap<String, Object> input){
	   return commonDao.selectList("prj.grs.retrieveGrsDecodeList");
   }
   
}


