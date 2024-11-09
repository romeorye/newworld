package iris.web.batch.mail;

import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.HashMap;
import java.util.Locale;

import javax.annotation.Resource;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.stereotype.Controller;

import iris.web.batch.mail.service.MailBatchService;
import iris.web.common.util.StringUtil;
import iris.web.system.base.IrisBaseController;

/********************************************************************************
 * NAME : MailBatchCmTss.java
 * DESC : 3. 완료예정 과제 안내	매월 1일 	매월 20일
 * PROJ : N/A
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR            DESCRIPTION
 * ----------  ------  ---------------------------------------------------------
 * 2017.11.13  	 			 		최초생성
 *********************************************************************************/

@Controller
public class MailBatchCmTss  extends IrisBaseController {

    static final Logger LOGGER = LogManager.getLogger(MailBatchCmTss.class);

    Calendar cal = Calendar.getInstance();
    SimpleDateFormat date_formatter = new SimpleDateFormat("yyyyMMdd", new Locale("ko","KOREA"));
    SimpleDateFormat month_formatter = new SimpleDateFormat("yyyy.MM", new Locale("ko","KOREA"));


    @Resource(name = "mailBatchService")
    private MailBatchService mailBatchService;

    
    public void batchProcess() throws SQLException, ClassNotFoundException {
    	
        String userId = "Batch-MailBatchCmTss";
        HashMap<String, Object> input;

        input =  new HashMap<String, Object>();

        input.put("userId", userId);

        input = StringUtil.toUtf8(input);

  

        
        String toDate = date_formatter.format(cal.getTime());
        String toMonth = month_formatter.format(cal.getTime());
        LOGGER.debug("MailBatchCmTss_START-"+toDate);
        toMonth = toMonth.replace(".","년");
        input.put("Type", "C");
        input.put("yymm", toMonth);
        input.put("title", "완료예정 과제의 산출물 등록 및 진행 절차 안내");
        input.put("mailTemplateName", "mailBatchCmTsshtml");
        input.put("sendMailAdd", "iris@lxhausys.com");
        input.put("sendMailName", "관리자");
 
         mailBatchService.makeMailSend(input);
        
 
        
        LOGGER.debug("MailBatchCmTss_End-"+toDate);  
    	
    
    }
}