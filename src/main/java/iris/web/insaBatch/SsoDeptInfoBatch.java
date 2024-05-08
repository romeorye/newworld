package iris.web.insaBatch;

import javax.annotation.Resource;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import iris.web.insaBatch.service.SsoDeptInfoService;

public class SsoDeptInfoBatch {

	@Resource(name = "ssoDeptInfoService")
	private SsoDeptInfoService ssoDeptInfoService;
	
	static final Logger LOGGER = LogManager.getLogger(SsoDeptInfoBatch.class);

	public void batchProcess() {
    	LOGGER.debug("ssoDeptInfoService >> Start >>>>>>>>>>>>>>>>>>>>>>");	
    	
    	//1. 데이터 조회
		try{
			ssoDeptInfoService.insertDeptInfoIf();
			
		}catch(Exception e){
			e.printStackTrace();
		}
		
    }
}
