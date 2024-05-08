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
 * NAME : MailBatchArsl.java
 * DESC : 2. 과제 월별 진척도 입력 	매월 21일	매월 27일
 * PROJ : N/A
 *------------------------------------------------------------------------------
 *                               MODIFICATION LOG
 *------------------------------------------------------------------------------
 *    DATE     AUTHOR            DESCRIPTION
 * ----------  ------  ---------------------------------------------------------
 * 2017.11.13  	 			 		최초생성
 *********************************************************************************/

@Controller
public class MailBatchArsl  extends IrisBaseController {

    static final Logger LOGGER = LogManager.getLogger(MailBatchArsl.class);

    Calendar cal = Calendar.getInstance();
    SimpleDateFormat date_formatter = new SimpleDateFormat("yyyyMMdd", new Locale("ko","KOREA"));
    SimpleDateFormat month_formatter = new SimpleDateFormat("yyyy.MM", new Locale("ko","KOREA"));


    @Resource(name = "mailBatchService")
    private MailBatchService mailBatchService;

    
    public void batchProcess() throws SQLException, ClassNotFoundException {
    	
        String userId = "Batch_MailBatchArsl";
        HashMap<String, Object> input;

        input =  new HashMap<String, Object>();

        input.put("userId", userId);

        input = StringUtil.toUtf8(input);

        String toDate = date_formatter.format(cal.getTime());
        String toMonth = month_formatter.format(cal.getTime());
        toMonth = toMonth.replace(".","년");
        LOGGER.debug("mailBatchArsl_START-"+toDate);
        input.put("Type", "B");
        input.put("title", toMonth+"월 과제 진척도 입력 요청");
        input.put("mailTemplateName", "mailBatchArslhtml");
        input.put("sendMailAdd", "iris@lxhausys.com");
        input.put("sendMailName", "관리자");
 
         mailBatchService.makeMailSend(input);
        
        LOGGER.debug("mailBatchArsl_End-"+toDate);  
    	
    
    }
}