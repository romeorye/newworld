package iris.web.mailBatch;

import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.HashMap;
import java.util.Locale;

import javax.annotation.Resource;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.stereotype.Controller;

import iris.web.common.util.StringUtil;
import iris.web.mailBatch.service.MailBatchService;
import iris.web.system.base.IrisBaseController;


/********************************************************************************
 * NAME : MailBatchGrs.java
 * DESC : GRS 심의 완료후 품의 요청메일
 * PROJ : N/A
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR            DESCRIPTION
 * ----------  ------  ---------------------------------------------------------
 * 2017.11.13  	 			 		최초생성
 *********************************************************************************/

@Controller
public class MailBatchGrs  extends IrisBaseController {

    static final Logger LOGGER = LogManager.getLogger(MailBatchGrs.class);

    Calendar cal = Calendar.getInstance();
    SimpleDateFormat date_formatter = new SimpleDateFormat("yyyyMMdd", new Locale("ko","KOREA"));
    SimpleDateFormat month_formatter = new SimpleDateFormat("yyyyMM", new Locale("ko","KOREA"));


    @Resource(name = "mailBatchService")
    private MailBatchService mailBatchService;

    
    public void batchProcess() throws SQLException, ClassNotFoundException {
    	
        String userId = "Batch-MailBatchGrs";
        HashMap<String, Object> input;

        input =  new HashMap<String, Object>();

        input.put("userId", userId);

        input = StringUtil.toUtf8(input);

        
        String toDate = date_formatter.format(cal.getTime());
        String toMonth = month_formatter.format(cal.getTime());
        LOGGER.debug("MailBatchGrs_START-"+toDate);
        input.put("Type", "G");
        input.put("title", "품의 진행 안내");
        input.put("mailTemplateName", "mailBatchGrshtml");
        input.put("sendMailAdd", "iris@lxhausys.com");
        input.put("sendMailName", "관리자");
 
         mailBatchService.makeMailSend(input);
        
        
        LOGGER.debug("MailBatchGrs_End-"+toDate);  
    	
    
    }
}