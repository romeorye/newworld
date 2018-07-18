package iris.web.insaBatch;

import javax.annotation.Resource;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import iris.web.insaBatch.service.InsaInfoService;

public class InsaInfoBatch {

	
	@Resource(name = "insaInfoService")
	private InsaInfoService insaInfoService;
	
	static final Logger LOGGER = LogManager.getLogger(InsaInfoBatch.class);

    public void batchProcess() {
    	LOGGER.debug("insaInfoService >> Start >>>>>>>>>>>>>>>>>>>>>>");	
    	
    	//1. 데이터 조회
		try{
			insaInfoService.insaInfoBatch();
		}catch(Exception e){
			e.printStackTrace();
		}
		
    }
	
	
}
