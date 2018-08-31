package iris.web.mailBatch;

import iris.web.common.util.StringUtil;
import iris.web.mailBatch.service.MailBatchService;
import iris.web.system.base.IrisBaseController;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.stereotype.Controller;

import javax.annotation.Resource;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.HashMap;
import java.util.Locale;

/********************************************************************************
 * NAME : MailBatchMfr.java
 * DESC :  Monthly Focus Review 매월 20일
 * PROJ : N/A
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR            DESCRIPTION
 * ----------  ------  ---------------------------------------------------------
 * 2017.11.13  	 			 		최초생성
 *********************************************************************************/

@Controller
public class MailBatchMfr  extends IrisBaseController {

    static final Logger LOGGER = LogManager.getLogger(MailBatchMfr.class);

    Calendar cal = Calendar.getInstance();
    SimpleDateFormat date_formatter = new SimpleDateFormat("yyyyMMdd", new Locale("ko","KOREA"));
    SimpleDateFormat month_formatter = new SimpleDateFormat("yyyy.MM", new Locale("ko","KOREA"));


    @Resource(name = "mailBatchService")
    private MailBatchService mailBatchService;

    
    public void batchProcess() throws SQLException, ClassNotFoundException {
    	
        String userId = "Batch_MailBatchMfr";
        HashMap<String, Object> input;

        input =  new HashMap<String, Object>();

        input.put("userId", userId);

        input = StringUtil.toUtf8(input);
       
        String toDate = date_formatter.format(cal.getTime());
        String toMonth = month_formatter.format(cal.getTime());
        LOGGER.debug("mailBatchArsl_START-"+toDate);
        toMonth = toMonth.replace(".","년");
        input.put("Type", "R");
        input.put("yymm", toMonth);
        input.put("title", "[공지] Monthly Focus Review 요청");
        input.put("mailTemplateName", "mailBatchMfrhtml");
        input.put("sendMailAdd", "iris@lghausys.com");
        input.put("sendMailName", "관리자");
 
         mailBatchService.makeMailSend(input);
        
 
        
        LOGGER.debug("MailBatchMfr_End-"+toDate);  
    	
    
    }
}