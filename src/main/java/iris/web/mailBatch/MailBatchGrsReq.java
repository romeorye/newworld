package iris.web.mailBatch;

import java.sql.SQLException;
import java.util.HashMap;

import javax.annotation.Resource;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.stereotype.Controller;

import iris.web.mailBatch.service.MailBatchService;
import iris.web.system.base.IrisBaseController;

@Controller
public class MailBatchGrsReq extends IrisBaseController {

	
	 static final Logger LOGGER = LogManager.getLogger(MailBatchGrs.class);
	 
	 @Resource(name = "mailBatchService")
	    private MailBatchService mailBatchService;

	    
	    public void batchProcess() throws SQLException, ClassNotFoundException {
	    	
	    	 HashMap<String, Object> input;

	         input =  new HashMap<String, Object>();

	         input.put("userId", "admin");
	         
	    	mailBatchService.grsReqMailSend(input);
	        
	        LOGGER.debug("MailBatchGrsReq_End-");  
	    }
	    	
	    	
	    	
	    	
	
	
	
}
