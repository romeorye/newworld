package iris.web.mailBatch.service;

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
import iris.web.common.mail.service.MailInfoService;
import iris.web.mailBatch.vo.ReplacementVo;
import iris.web.prj.grs.vo.GrsMailInfoVo;
import iris.web.prj.mm.mail.service.MmMailService;

/*********************************************************************************
 * NAME : MailBatchServiceImpl.java
 * DESC : MailBatchServiceImpl
 * PROJ : Iris
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR                      DESCRIPTION
 * ----------  ------  ---------------------------------------------------------
 * 2017.09.23  	최초생성
 *********************************************************************************/
@Service("mailBatchService")
public class MailBatchServiceImpl implements MailBatchService{

    @Resource(name="commonDao")
    private CommonDao commonDao;

    @Resource(name="mailSenderFactory")
    private MailSenderFactory mailSenderFactory;


    @Resource(name="mmMailService")
    private MmMailService mmMailService;			// MmMail 서비스

    @Resource(name="mailInfoService")
    private MailInfoService mailInfoService;

    
    @Override
    public List<Map<String, Object>> retrieveTssPgMgr() {

        List<Map<String, Object>>  rst = 	commonDao.selectList("batch.retrieveTssPgMgr", "");
        return rst;
    }

    @Override
    public void updateTssPgMgr( HashMap<String, Object> input) {
        commonDao.update("batch.updateTssPgMgr", input);
    }

    static final Logger LOGGER = LogManager.getLogger(MailBatchServiceImpl.class);
    
    /**
     * Wbs code생성 폐지 메일 발송
     */
    @SuppressWarnings("null")
    @Override
    public void makeMailSendWbs(HashMap<String, Object> input) {
    	MailSender mailSender = mailSenderFactory.createMailSender();
        ReplacementVo replacementVo = new ReplacementVo();
        
        //WBS 생성
        List<Map<String, Object>>  retrieveWbsCdCreateReq = commonDao.selectList("batch.retrieveWbsCdCreateReq", "");

        for(Map<String, Object> context : retrieveWbsCdCreateReq) {
        	mailSender.setFromMailAddress("iris@lghausys.com");
            mailSender.setToMailAddress(context.get("receMailAdd").toString().split(","));
            mailSender.setCcMailAddress(context.get("ccMailAddr").toString().split(","));
            mailSender.setSubject("WBS 코드 생성의 件");
            
            replacementVo.setPrjNm(NullUtil.nvl(context.get("prjNm").toString(), ""));
            replacementVo.setTssNm(NullUtil.nvl(context.get("tssNm").toString(), ""));
            replacementVo.setWbsCd(NullUtil.nvl(context.get("wbsCd").toString(), ""));
            replacementVo.setBizDptNm(NullUtil.nvl(context.get("bizDptNm").toString(), ""));
            replacementVo.setTssScnNm(NullUtil.nvl(context.get("tssScnNm").toString(), ""));
            replacementVo.setTssSaNm(NullUtil.nvl(context.get("tssSaNm").toString(), ""));
            
            mailSender.setHtmlTemplate("mailBatchWbsCdCrdhtml", replacementVo );
            mailSender.send(); 
            
            HashMap<String, Object> mailMap = new HashMap<String, Object>();
            mailMap.put("mailTitl", " WBS 코드 생성의 件");
            mailMap.put("adreMail", context.get("receMailAdd"));
            mailMap.put("rfpMail", context.get("ccMailAddr"));
            mailMap.put("trrMail", "iris@lghausys.com");
            mailMap.put("_userId", input.get("userId").toString());
           
            mailInfoService.insertMailSndHist(mailMap);
        }

        //WBS_cd 폐기
        List<Map<String, Object>>  retrieveWbsCdDeleteReq = commonDao.selectList("batch.retrieveWbsCdDeleteReq", "");

        ReplacementVo wbcCdDelVo = new ReplacementVo();
        for(Map<String, Object> context : retrieveWbsCdDeleteReq) {
        	mailSender.setFromMailAddress("iris@lghausys.com");
            mailSender.setToMailAddress(context.get("receMailAdd").toString().split(","));
            mailSender.setToMailAddress(context.get("ccMailAddr").toString().split(","));
            mailSender.setSubject(" WBS 코드 폐지의 件");
            
            wbcCdDelVo.setPrjNm(NullUtil.nvl(context.get("prjNm").toString(), ""));
            wbcCdDelVo.setTssNm(NullUtil.nvl(context.get("tssNm").toString(), ""));
            wbcCdDelVo.setWbsCd(NullUtil.nvl(context.get("wbsCd").toString(), ""));
            wbcCdDelVo.setBizDptNm(NullUtil.nvl(context.get("bizDptNm").toString(), ""));
            wbcCdDelVo.setTssScnNm(NullUtil.nvl(context.get("tssScnNm").toString(), ""));
            wbcCdDelVo.setTssSaNm(NullUtil.nvl(context.get("tssSaNm").toString(), ""));
            
            mailSender.setHtmlTemplate("mailBatchWbsCdDelhtml", wbcCdDelVo );
            mailSender.send(); 
            
            HashMap<String, Object> mailMap = new HashMap<String, Object>();
            mailMap.put("mailTitl", " WBS 코드 폐지의 件");
            mailMap.put("adreMail", context.get("receMailAdd") );
            mailMap.put("adreMail", context.get("ccMailAddr") );
            mailMap.put("trrMail", "iris@lghausys.com");
            mailMap.put("_userId", input.get("userId").toString());
           
            mailInfoService.insertMailSndHist(mailMap);
        }
    }


    /**
     * 메일 발송
     * @param input
     * @param vmParm
     * @return
     */
    public boolean mailSend(Map<String, Object> input ,  ReplacementVo vo ) {
        boolean rst = false;
        try {
            MailSender mailSender = mailSenderFactory.createMailSender();
            String[] toMailAddress = null;

            if(input.get("receMailAdd2") != null) {
                toMailAddress = new String[3];

                toMailAddress[0] = (String)input.get("receMailAdd");
                toMailAddress[1] = (String)input.get("receMailAdd2");
                toMailAddress[2] = (String)input.get("receMailAdd3");
            } else {
                toMailAddress = new String[1];

                toMailAddress[0] = (String)input.get("receMailAdd");
            }
            
            mailSender.setFromMailAddress("iris@lghausys.com");
            mailSender.setToMailAddress(toMailAddress);
            mailSender.setCcMailAddress(NullUtil.nvl(input.get("ccReceMailAdd"),""));
            mailSender.setSubject(NullUtil.nvl(input.get("title"),""));
            mailSender.setHtmlTemplate(input.get("mailTemplateName").toString(), vo );

            mailSender.send();
            // 메일발송정보리스트
            List<HashMap<String, Object>> sndMailList = new ArrayList<HashMap<String, Object>>();
            HashMap<String, Object> mailMap = new HashMap<String, Object>();
            mailMap.put("mailTitl", NullUtil.nvl(input.get("title").toString(),""));
            mailMap.put("adreMail", NullUtil.nvl(input.get("receMailAdd"),"") );
            mailMap.put("rfpMail", NullUtil.nvl(input.get("ccReceMailAdd"),"") );

            mailMap.put("trrMail", NullUtil.nvl(input.get("sendMailAdd"),""));
            mailMap.put("_userId", input.get("userId").toString());
            sndMailList.add(mailMap);
            mmMailService.insertMailSndHis(sndMailList);

            rst = true;
        } catch (Exception e) {
            rst = false;
            e.printStackTrace();
        }

        return rst;

    }


    /**
     * 과제 메일 발송
     */

    @SuppressWarnings("null")
    @Override
    public void makeMailSend(HashMap<String, Object> input) {
        //	       input.put("receMailAdd" , "choinhee@lghausys.com") ;
        List<Map<String, Object>>  retrieveSendAddr  = null;
        ReplacementVo replacementVo = new ReplacementVo();
        if("A".equals( input.get("Type"))){ //모든 PL (연구 팀장) 1. 월마감
            replacementVo.setYymm(input.get("yymm").toString());
            retrieveSendAddr =    commonDao.selectList("batch.retrieveSendAddrAllPL", "");
        }else if("R".equals( input.get("Type"))){ //사업부 연구소 PL (연구 팀장) 2. Monthly Focus Review
            replacementVo.setYymm(input.get("yymm").toString());
            retrieveSendAddr =    commonDao.selectList("batch.retrieveSendAddrResPL", "");
        }else if("B".equals( input.get("Type"))){ //사업부 연구소 PL (연구 팀장) --진행중    2. 과제 월별 진척도 입력
            retrieveSendAddr =    commonDao.selectList("batch.retrieveSendAddrTssPGPL", "");
        }else if("G".equals( input.get("Type"))){ //해당 PL (연구 팀장), 과제 리더 --grs 완료 1. 과제  품의 진행
            retrieveSendAddr =    commonDao.selectList("batch.retrieveSendAddrTssGrsPL", "");
        }else if("C".equals( input.get("Type"))){ //완료과제의 과제 리더   3. 완료예정 과제 안내
            retrieveSendAddr =    commonDao.selectList("batch.retrieveSendAddrTssCmPL", "");
            replacementVo.setYymm(input.get("yymm").toString());

        }else if("E".equals( input.get("Type"))){ //모든 연구원 (분석, 신뢰성, 주택제외) 1. M/M 입력
            retrieveSendAddr =    commonDao.selectList("batch.retrieveSendAddrEve", "");
            replacementVo.setYymm(input.get("yymm").toString());
        }

        String title = input.get("title").toString();
        for(Map<String, Object> addr : retrieveSendAddr) {

            input.put("receMailAdd" , addr.get("saMail")) ;
            if("G".equals( input.get("Type"))){

                replacementVo.setGrsStCd(addr.get("grsCd").toString());
                replacementVo.setGrsStNm(addr.get("grsNm").toString());
                String tssPgsNm ="";
                if("P1".equals(addr.get("grsCd").toString().trim())){
                    tssPgsNm = "계획";
                }else if("P2".equals(addr.get("grsCd").toString().trim())){
                    tssPgsNm = "완료";

                }else if("D".equals(addr.get("grsCd").toString().trim())){
                    tssPgsNm = "중단";

                }else if("M".equals(addr.get("grsCd").toString().trim())){
                    tssPgsNm = "변경";

                }
                replacementVo.setTssPgsNm(tssPgsNm);

                input.put("title",  tssPgsNm +" "+ title );

                Map<String, Object> retrieveCCPrjPLsendAddr =    commonDao.select("batch.retrieveCCPrjPLsendAddr", addr.get("prjCd"));

                input.put("ccReceMailAdd" , retrieveCCPrjPLsendAddr.get("saMail")) ;
            }

            this.mailSend(input , replacementVo);
        }

    }

    /**
    *  grs 심의 요청  메일
    */
    public void grsReqMailSend(HashMap<String, Object> input){
    	MailSender mailSender = mailSenderFactory.createMailSender();
    	GrsMailInfoVo vo = new GrsMailInfoVo();
    	
    	List<HashMap<String, Object>> sndMailList = new ArrayList<HashMap<String, Object>>();
         
    	//grs 심의 요청건 추출
    	List<Map<String, Object>>  grsReqList = commonDao.selectList("batch.retrieveGrsReqSendMailInfo", input) ;
    	String mailTitle ="GRS 평가 요청 메일입니다.";
    	//local
    	//String sendMailAddr = "irisLocal@lghausys.com";
    	//dev
    	//String sendMailAddr = "irisDev@lghausys.com";
    	//운영
    	String sendMailAddr = "iris@lghausys.com";

    	if ( grsReqList.size()  > 0 ){
    		
    		for(Map<String, Object> mailInfo : grsReqList) {
	    		mailSender.setFromMailAddress(sendMailAddr);
	            mailSender.setToMailAddress((String) mailInfo.get("receiMailAddr"), (String) mailInfo.get("dlbrCrgrNm") );
	            mailSender.setSubject(mailTitle);
	            vo.setTssNm(mailInfo.get("tssNm").toString()); 
	    	    vo.setTssCd(mailInfo.get("reqNo").toString()); 	//tssCd + tssSnCd
	    	    vo.setPhNm(mailInfo.get("phNm").toString()); 
	    	    vo.setGrsEvSn(mailInfo.get("grsEvSn").toString()); 
	    	    vo.setTssCdSn(mailInfo.get("tssCdSn").toString()); 
	    	    
	    		mailSender.setHtmlTemplate("grsSendMail", vo);
	
	            mailSender.send();
	            
	            HashMap<String, Object> mailMap = new HashMap<String, Object>();
	            // 메일발송정보리스트
	            mailMap.put("mailTitl", mailTitle);
	            mailMap.put("adreMail", (String) mailInfo.get("receiMailAddr") );
	            mailMap.put("rfpMail", "");
	
	            mailMap.put("trrMail", sendMailAddr);
	            mailMap.put("_userId", input.get("userId").toString());
	            sndMailList.add(mailMap);
	    	}
    	
    		mailInfoService.insertMailSndHist(sndMailList);
    	}
    }	
   




}
