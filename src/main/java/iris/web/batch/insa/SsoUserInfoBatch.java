package iris.web.batch.insa;

import javax.annotation.Resource;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import iris.web.batch.insa.service.SsoUserInfoService;


public class SsoUserInfoBatch {

	
	@Resource(name = "ssoUserInfoService")
	private SsoUserInfoService ssoUserInfoService;
	
	static final Logger LOGGER = LogManager.getLogger(SsoUserInfoBatch.class);

   
	public void batchProcess() {
    	LOGGER.debug("ssoUserInfoService >> Start >>>>>>>>>>>>>>>>>>>>>>");	
    	
    	//1. 데이터 조회
		try{
			ssoUserInfoService.insertUserInfoIf();
			
		}catch(Exception e){
			e.printStackTrace();
		}
		
    }

	
	
}
