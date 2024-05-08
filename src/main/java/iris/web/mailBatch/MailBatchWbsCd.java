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
 * NAME : MailBatchWbsCdCrd.java
 * DESC : 1. 월마감 	매월 21일	매월 27일
 * PROJ : N/A
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR            DESCRIPTION
 * ----------  ------  ---------------------------------------------------------
 * 2017.11.13  	 			 		최초생성
 *********************************************************************************/

@Controller
public class MailBatchWbsCd  extends IrisBaseController {

    static final Logger LOGGER = LogManager.getLogger(MailBatchWbsCd.class);

    Calendar cal = Calendar.getInstance();
    SimpleDateFormat date_formatter = new SimpleDateFormat("yyyyMMdd", new Locale("ko","KOREA"));
  
    SimpleDateFormat month_formatter = new SimpleDateFormat("yyyy.MM", new Locale("ko","KOREA"));

    @Resource(name = "mailBatchService")
    private MailBatchService mailBatchService;

    
    public void batchProcess() throws SQLException, ClassNotFoundException {
    	
        String userId = "Batch-MailBatchWbsCd";
        HashMap<String, Object> input;

        input =  new HashMap<String, Object>();

        input.put("userId", userId);

        input = StringUtil.toUtf8(input);

        String toDate = date_formatter.format(cal.getTime());
        String toMonth = month_formatter.format(cal.getTime());
        LOGGER.debug("MailBatchWbsCdCrd_START-"+toDate);
        toMonth = toMonth.replace(".","년");
        input.put("yymm", toMonth);
        input.put("sendMailName", "관리자");
 
         mailBatchService.makeMailSendWbs(input);
 
        
        LOGGER.debug("MailBatchWbsCdCrd_End-"+toDate);  
    	
    
    }
}